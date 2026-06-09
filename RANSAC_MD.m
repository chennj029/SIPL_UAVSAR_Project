%% 方位解压缩，准备做MD
data_md = Sra_rcmc; %Na*Ny

[Na,Ny] = size(data_md);
%% 粗 map-drift 估计与补偿（适配 RD 成像流程）
% 思路：
%    - 距离向分块
%    - 方位向取两个相邻、部分重叠的子孔径
%    - 利用子孔径间漂移估计局部“相位曲率/频率斜率”
%    - 各距离块加权融合
%    - 两次累加恢复为相位误差曲线
%    - 去掉线性项
%    - 将粗补偿后的 data_md 再重新方位压缩成像

% ---------- map-drift 参数 ----------
% 对于10000~26999这组：距离向450m，M=5

M         = 6;                         % 距离向分成 2 个子块
subAziLen = 1000;                       % 每个方位子孔径长度（与 w-k 版本保持一致）
hopAzi    = 800;                       % 相邻子孔径起点间隔
Nfft      = 4096;                     % 漂移峰值搜索时的零填充长度
nIter     = 48;                         % 粗 MD 迭代次数，先保持 1 次

% 最佳参数组合图像熵：15.679498
% 保存原始 data_md，便于每轮都从同一份基准数据出发
data_md_ref = data_md;

% 累计相位误差曲线（单位上沿用原 w-k 代码的写法，最终通过 exp(2j*pi*phase_md_total) 施加）
phase_md_total = zeros(Na, 1);

% 慢时间轴（未居中），用于插值
t_full = (0:Na-1).' / PRF;

% 居中的慢时间轴，用于去线性项
t_full_center = t_full - mean(t_full);

% ---------- 粗 map-drift 主循环 ----------
for ii = 1:nIter

    % ---------------------------------------------------------
    % 1 先把当前累计相位补偿施加到 data_md 上
    % ---------------------------------------------------------
    % 这里采用 exp(2j*pi*phase_md_total) 的写法，
    % 与前面 w-k 粗 MD 代码在循环内部的补偿形式保持一致。
    data_md_work = data_md_ref .* exp(2j*pi * phase_md_total);


    % 每个距离子块的 nominal 宽度
    subNy = floor(Ny / M);

    % 方位向滑窗个数
    % 每个窗口长度 subAziLen_md，相邻窗口起点间隔 hopAzi_md
    Nwin_md = floor((Na - subAziLen) / hopAzi);

    % 保存每个窗口、每个距离子块的漂移估计结果
    K_phase_md = zeros(Nwin_md, M);

    % ---------------------------------------------------------
    % 2 遍历各距离子块
    % ---------------------------------------------------------
    for ib = 1:M

        % 当前距离子块的列范围
        c1 = 1 + (ib-1) * subNy;
        if ib < M
            c2 = ib * subNy;
        else
            % 最后一块把剩余的距离单元全部并进去，避免漏掉尾部
            c2 = Ny;
        end

        % 取出当前距离子块数据：Na × Nsub
        sub_data = data_md_work(:, c1:c2);

        % 3 在方位向上滑动两个相邻的子孔径
        % -----------------------------------------------------
        for j = 1:Nwin_md

            % 第一个子孔径的行范围
            r1s = 1 + (j-1) * hopAzi;
            r1e = (j-1) * hopAzi + subAziLen;

            % 第二个子孔径相对第一个向后平移 hopAzi_md 个脉冲
            r2s = 1 + j * hopAzi;
            r2e = j * hopAzi + subAziLen;

            % 取两个子孔径
            sub1 = sub_data(r1s:r1e, :);      % subAziLen_md × Nsub
            sub2 = sub_data(r2s:r2e, :);      % subAziLen_md × Nsub

            % 4 用两个子孔径的共轭乘积构造漂移估计量
            % -------------------------------------------------
            % 注意：
            % 这里保持与原 w-k 代码相同的实现形式。
            % sub2 .* conj(sub1) 表征了两个相邻子孔径之间的相位差关系。
            sub = sub2 .* conj(sub1);

            % 沿“方位维”做 IFFT，把相对漂移映射到 lag 轴上
            % 这里必须显式写 dim=1，因为 sub 的第一维才是方位维
            sub = ifft(sub, [], 1);

            % 对当前距离子块内所有距离单元做能量累加，
            % 得到仅关于“方位漂移”的一维曲线
            sub = sum(abs(sub).^2, 2);        % subAziLen_md × 1

            % 再做零填充，提高峰值位置估计精度
            sub = abs(ifft(fft(sub, Nfft), [], 1));   % Nfft × 1

            % 找漂移峰值位置
            [~, idx_peak] = max(sub);

            % 5 把峰值索引换算成有符号的漂移量
            % -------------------------------------------------
            if idx_peak > Nfft/2
                lag = -(Nfft - idx_peak + 1);
            else
                lag = idx_peak - 1;
            end

            % 峰值索引 -> 多普勒频移量（Hz）
            f_shift = PRF / Nfft * lag;

            % 再除以两个子孔径中心时间间隔，换算成“频率变化率/斜率量”
            % 这一步与原 w-k 粗 MD 代码保持一致
            K1 = f_shift / (hopAzi / PRF);

            % 保存该窗口、该距离子块的估计值
            K_phase_md(j, ib) = K1;
        end
    end

    % 6 多距离子块加权融合
    % ---------------------------------------------------------
    % 剔除明显过大的异常值（与原 w-k 代码保持一致）
    K_phase_md(K_phase_md >  5) = 0;
    K_phase_md(K_phase_md < -5) = 0;

    % 先简单平均，得到粗中心曲线
    phase_delta = mean(K_phase_md, 2);              % Nwin_md × 1

    % 先简单平均，得到粗中心曲线
    phase_delta = mean(K_phase_md, 2);              % Nwin_md × 1

    % 计算各距离子块相对均值的偏差
    W = abs(K_phase_md - phase_delta);

    % 加一个极小值，避免除零
    W = W + 0.01;

    % 偏差越小，权值越大
    W = 1 ./ W;

    % 加权平均，得到更稳健的窗口级估计
    phase_delta = sum(K_phase_md .* W, 2) ./ sum(W, 2);   % Nwin_md × 1

    % 7 两次累加，恢复为相位误差曲线
    % ---------------------------------------------------------
    % 这里完全模仿前面 w-k 粗 MD 代码的恢复方式
    % 第一次乘 hopAzi_md/PRF 后，量纲更接近“局部频移/相位梯度”
    phase_delta = phase_delta * (hopAzi / PRF);

    % 第一次累加
    phase_delta = cumsum(phase_delta);

    % 去掉均值，避免整体偏置
    phase_delta = phase_delta - mean(phase_delta);

    % 再乘一次时间步长
    phase_delta = phase_delta * (hopAzi / PRF);

    % 第二次累加，恢复到相位量
    phase_delta = cumsum(phase_delta);

    
    % 8 把窗口中心处估计到的相位误差插值到整条孔径
    % ---------------------------------------------------------
    % 每个估计值对应于两个子孔径中心之间的大致中点
    t_win = (((subAziLen + hopAzi) / 2) : hopAzi : Na).' / PRF;
    t_win = t_win(1:Nwin_md);

    % 样条插值到整条慢时间轴
    phase_delta_full = interp1(t_win, phase_delta, t_full, 'spline', 'extrap');

   
    % 9 去掉线性项
    % ---------------------------------------------------------
    % 线性相位主要对应图像整体平移，
    % 对散焦影响相对较小，因此粗 MD 通常只保留非线性部分
    p1 = polyfit(t_full_center, phase_delta_full, 1);
    phase_delta_full = phase_delta_full - p1(1) * t_full_center;

    % 累加到总相位误差
    phase_md_total = phase_md_total + phase_delta_full;

    
    % 10 用当前粗补偿结果重新方位压缩，检查效果
    % ---------------------------------------------------------
    data_md_eval = data_md_ref .* exp(2j*pi * phase_md_total);

    % 回到方位频域
    Sfa_md_eval = fftshift(fft(data_md_eval, [], 1), 1);

    % 用原 RD 流程中的方位匹配滤波器 H 重新压缩
    img_md_eval = ifft(ifftshift(Sfa_md_eval .* H, 1), [], 1);

    % 计算一个简单的图像熵，作为聚焦质量参考
    P = abs(img_md_eval).^2;
    P = P / (sum(P(:)) + eps);
    EI_md = -sum(P(:) .* log(P(:) + eps));

    fprintf('粗 map-drift 第 %d 次迭代：Entropy = %.6f\n', ii, EI_md);
end


%% 粗 map-drift 补偿后的输出

% 将最终粗相位补偿施加到 data_md 上
% 注意：
% 这里统一采用 exp(2j*pi*phase_md_total)，
% 与上面迭代评估阶段保持一致。
data_md_comp = data_md_ref .* exp(2j*pi * phase_md_total);

% 再次方位压缩，得到粗 MD 补偿后的图像
Sfa_md_comp = fftshift(fft(data_md_comp, [], 1), 1);
img_md = ifft(ifftshift(Sfa_md_comp .* H, 1), [], 1);