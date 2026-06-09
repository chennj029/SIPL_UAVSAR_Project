%% ---------- CFAR_PGA：MD之后使用

% 对于826 10000~27000这组数据距离向180m~450m这组数据，参数用Threshold_Factor_SmallBigWind =25;Threshold_Factor_hist = 1e-3;K_guard = 2.5;Win_Rg = 5;Win_Azi = 151;PGALoopNum = 1;
% 1. 映射输入变量，承接 RD+MD 补偿后的复图像
data = img_md;                  
[Na, Nr] = size(data); % 更新维度，Nr对应原 Ny
% 2. 补充雷达参数
fc = c / lamda;                 
thetaBw = deg2rad(7); % 估算波束宽度(rad)，用于计算合成孔径长度
ImagingAlgorithm = 'RD';        
bdownsampleByDopBandwidth = 0; % 关闭多普勒降采样
% 3. 构造 PGA 参数配置体 param
param = struct();
param.Win_Rg = 5;
param.Win_Azi = 351;
param.PGALoopNum = 1;
param.SubAperture_MOCO_LoopNum = 1;
param.Threshold_Factor_Peak_Decay = 0.08;
param.Threshold_Factor_SmallBigWind = 20;
param.Threshold_Factor_DeRamp_Decay = 0.3;
param.Threshold_Factor_WinSize = 0.8;
param.Threshold_Factor_hist = 1e-3;
param.bSelect_AziWin = true;
param.bSelect_RgWin = true;
param.bSelect_DopplerWidth = false;
param.bSelect_NearAziWin = false;
param.bRemoveLinearMoCo = true;
param.Threshold_Main_Side = 3;
param.Shrink_Factor = 0.95;
param.Factor_SyntheticAperture = 1;
param.SubAperturNum = 3;
param.bEnable_FineSelection = false;   % [新增] 是否在2D-CFAR后开启多条件精细筛选

% 解析参数
Win_Azi = param.Win_Azi;
Win_Rg = param.Win_Rg;
PGALoopNum = param.PGALoopNum;
SubAperture_MOCO_LoopNum = param.SubAperture_MOCO_LoopNum;
Threshold_Factor_Peak_Decay = param.Threshold_Factor_Peak_Decay;
Threshold_Factor_SmallBigWind = param.Threshold_Factor_SmallBigWind;
Threshold_Factor_DeRamp_Decay = param.Threshold_Factor_DeRamp_Decay;
Threshold_Factor_WinSize = param.Threshold_Factor_WinSize;
Threshold_Factor_hist = param.Threshold_Factor_hist;
bSelect_AziWin = param.bSelect_AziWin;
bSelect_RgWin = param.bSelect_RgWin;
bSelect_DopplerWidth = param.bSelect_DopplerWidth;
bSelect_NearAziWin = param.bSelect_NearAziWin;
bRemoveLinearMoCo = param.bRemoveLinearMoCo;
Threshold_Main_Side = param.Threshold_Main_Side;
Shrink_Factor = param.Shrink_Factor;
Factor_SyntheticAperture = param.Factor_SyntheticAperture;
SubAperturNum = param.SubAperturNum;
if mod(SubAperturNum,2)~=0
    SubAperturNum = SubAperturNum + 1;
end

bEnable_FineSelection = param.bEnable_FineSelection; % [新增] 解析精选开关
% 桥接缺失的评估函数
calculate_Entropyy = @(x) calc_image_entropy(x);
% calculateContrast  = @(x) std(abs(x(:))) / (mean(abs(x(:))) + eps);

% 核心代码块：方位向降采样与合成孔径时间计算 
if(bdownsampleByDopBandwidth)
    Na_Valid = ceil(Na*ProBandWidth/PRF/16)*16;
    data = fftshift(fft(data));
    data = ifft(fftshift(data(Na/2+1-Na_Valid/2:Na/2+Na_Valid/2,:)));
    fprintf("根据处理带宽对数据进行降采样\n")
else
    Na_Valid = Na;
    fprintf("不进行降采样\n")
end
Retac = Rnear/cos(theta);
Ls = thetaBw*Retac; 
D_fdc = sqrt(max(1e-8, 1 - (fdc * lamda / (2 * v))^2));
Ts_rg = Ls/v; 
Ts_cnt0 = ceil(Ts_rg*PRF);
Ts_cnt0 = round(Na_Valid/Na*Ts_cnt0);
PRF =  Na_Valid/Na*PRF;
Win_Azi = round(Na_Valid/Na*Win_Azi);
Na = Na_Valid;
PhaseSmoothLen = Win_Azi;
% 统计幅值直方图，确定强点提取的初始功率门限
[count, bin] = hist(abs(data(:)),256);
cum_bin = cumsum(count(end:-1:1));
ind_bin = find(cum_bin<Nr*Na*Threshold_Factor_hist,1,'last');
Threshold_Power = bin(256+1-ind_bin)^2;
Threshold_MainLobe = Threshold_Power*20;


% 核心代码块：多普勒谱宽估计     
Doppler_Spec_org = fftshift(sum(abs(fft(data)).^2,2));
Doppler_Spec = smooth(Doppler_Spec_org,100,'rloess');
[max_peak, ind_peak] = max(Doppler_Spec);
Dop_Win_Left = find(Doppler_Spec(1:ind_peak-1)>max_peak*Threshold_Factor_DeRamp_Decay,1,'first');
Dop_Win_Right = find(Doppler_Spec(ind_peak+1:end)<max_peak*Threshold_Factor_DeRamp_Decay,1,'first') + ind_peak;
Dop_Win_Size = Dop_Win_Right - Dop_Win_Left;
% =========================================================================
% PGA 主循环开始
% =========================================================================
for iLoop = 1:PGALoopNum  
    figure(iLoop);imagesc(abs(data),[0 10*mean(mean(abs(data)))]);title('data', 'fontname', '微软雅黑');
    
    Es1 = calculate_Entropyy(data); 
    IC1 = calculateContrast(abs(data));
    data_power = abs(data).^2;
    
    if iLoop>1 && Win_Azi>=3
        Win_Azi = floor(Win_Azi*Shrink_Factor/2)*2+1; 
        Threshold_Power = Threshold_Power/Shrink_Factor;
        Threshold_MainLobe = Threshold_MainLobe*Shrink_Factor;
    end
    

    % 强孤立散射点初筛（基于 2D-CFAR 与保护环隔离度检验）  
    % 1. 定义三层滑动窗的尺寸边界 (目标主瓣区 T，保护环区 G，背景杂波区 B)
    G_azi = max(5, floor(Win_Azi/3)); % 保护区外边界 (例如Win_Azi=51时，G_azi=17)
    G_rg  = max(2, floor(Win_Rg/2));  % 保护区外边界
    T_azi = max(2, floor(G_azi/3));   % 目标主瓣容忍区内边界 (例如G_azi=17时，T_azi=5)
    T_rg  = max(1, floor(G_rg/2));    % 目标主瓣容忍区内边界

    % 2. 构造背景区域滤波器 (用于估计局域背景杂波均值)
    h_B = ones(2*Win_Azi+1, 2*Win_Rg+1);
    % 将中心包含保护区的部分全部挖空，仅留最外环作为背景
    h_B(Win_Azi+1-G_azi : Win_Azi+1+G_azi, Win_Rg+1-G_rg : Win_Rg+1+G_rg) = 0;
    h_B = h_B / sum(h_B(:));
    Mean_B = imfilter(data_power, h_B, 'replicate'); % 滤波得到背景均值

    % 【修复补丁】：重构局域对比度 IJ，供后续局部峰值检验和 PGA 加权使用
    IJ = data_power ./ (Mean_B + eps); 

    % 3. 构造保护环滤波器 (用于寻找环内的最大能量)
    mask_G = ones(2*G_azi+1, 2*G_rg+1);
    % 将中心目标主瓣区挖空，形成一个“空心保护环”
    mask_G(G_azi+1-T_azi : G_azi+1+T_azi, G_rg+1-T_rg : G_rg+1+T_rg) = 0;
    se_G = strel('arbitrary', mask_G);
    % 利用形态学膨胀操作，极其高效地获取滑动空心环内的最大值
    Max_G = imdilate(data_power, se_G); 

    % 4. 2D-CFAR 与孤立度多重判决
    % 条件A：绝对能量必须大于全局设定的强度下限
    mask_abs = (data_power > Threshold_Power);
    
    % 条件B：标准 CFAR 均值对比度，中心峰值必须显著大于局域背景均值
    mask_cfar = (data_power > Threshold_Factor_SmallBigWind * Mean_B);
    
    % 条件C：保护环孤立性检测 (抗公路/线状目标的核心)
    % 设定峰值必须是保护环内最大值的 K_guard 倍以上，即可将公路点全部淘汰。
    K_guard = 2.5; % 孤立度倍数阈值
    mask_iso = (data_power > K_guard * Max_G);

    % 综合掩膜，生成最终候选点
    mask_final = mask_abs & mask_cfar & mask_iso;
    
    rg_wholemap = [];
    azi_wholemap = [];
    [ind_az, ind_rg] = find(mask_final);
    
    % 可视化 CFAR 筛选效果（仅在第1次迭代时绘制以供直观验证）
    if iLoop == 1
        figure('Name', '初次迭代选点分布(2D-CFAR)', 'Color', 'w');
        imagesc(abs(data), [0, 5*mean(abs(data(:)))]); 
        colormap('gray'); hold on;
        plot(ind_rg, ind_az, 'r.', 'MarkerSize', 8);
        title('2D-CFAR 及保护环约束后的候选点分布', 'FontName', '微软雅黑');
        xlabel('距离向', 'FontName', '微软雅黑');
        ylabel('方位向', 'FontName', '微软雅黑');
    end
    
    rg_wholemap = [];
    azi_wholemap = [];
    
    if bEnable_FineSelection
        % 核心代码块：强点质量精细控制（多重条件约束） 
        for iPoint=1:length(ind_rg)
            ind_az_up = max(ind_az(iPoint) - Win_Azi,1) ;
            ind_az_down = min(ind_az(iPoint) + Win_Azi,Na);
            if IJ(ind_az(iPoint),ind_rg(iPoint)) ~= max(IJ(ind_az_up:ind_az_down,ind_rg(iPoint)))
                continue; 
            end
            
            data_peak = data_power(ind_az(iPoint),ind_rg(iPoint));
            
            if bSelect_RgWin
                ind_rg_left = find(data_power(ind_az(iPoint),1:ind_rg(iPoint)-1)<data_peak*Threshold_Factor_Peak_Decay,1,'last');
                if isempty(ind_rg_left), ind_rg_left = 1; end
                ind_rg_right = find(data_power(ind_az(iPoint),ind_rg(iPoint)+1:end)<data_peak*Threshold_Factor_Peak_Decay,1,'first')+ind_rg(iPoint);
                if isempty(ind_rg_right), ind_rg_right = Nr; end
                if ind_rg_right-ind_rg_left+1>Win_Rg*2
                    continue;
                end
            end
            
            if bSelect_AziWin
                ind_up = find(data_power(1:ind_az(iPoint)-1,ind_rg(iPoint))<data_peak*Threshold_Factor_Peak_Decay,1,'last');
                if isempty(ind_up), ind_up=1; end
                ind_down = find(data_power(ind_az(iPoint)+1:end,ind_rg(iPoint))<data_peak*Threshold_Factor_Peak_Decay,1,'first')+ind_az(iPoint);
                if isempty(ind_down), ind_down=Na; end
                if ind_down-ind_up+1>2*Win_Azi
                    continue;
                end
            end
            
            if bSelect_NearAziWin
                size_win_azi_cur = ind_down-ind_up+1;
                ind_up_near_win = max(ind_up - size_win_azi_cur,1);
                ind_down_near_win = min(ind_down + size_win_azi_cur,Na);
                MainLobe = sum(data_power(ind_up:ind_down,ind_rg(iPoint)));
                if MainLobe<Threshold_MainLobe
                    continue;
                end
                Main_SideLobe = MainLobe/(sum(data_power(ind_up_near_win:ind_up-1,ind_rg(iPoint)))+sum(data_power(ind_down+1:ind_down_near_win,ind_rg(iPoint))));
                if Main_SideLobe<Threshold_Main_Side
                    continue;
                end
            end
            
            if bSelect_DopplerWidth
                data_point = zeros(Na,1);
                data_point(ind_up:ind_down) = data(ind_up:ind_down,ind_rg(iPoint));  
                data_point = abs(fftshift(fft(data_point))).^2;
                [max_peak, ind_peak] = max(data_point);
                Dop_Win_Left = find(data_point(1:ind_peak-1)>max_peak*Threshold_Factor_DeRamp_Decay,1,'first');
                Dop_Win_Right = find(data_point(ind_peak+1:end)<max_peak*Threshold_Factor_DeRamp_Decay,1,'first') + ind_peak;
                Dop_Win_Size_Point = Dop_Win_Right - Dop_Win_Left;
                if Dop_Win_Size_Point<Dop_Win_Size*Threshold_Factor_WinSize
                    continue;
                end
            end
            
            azi_wholemap = [azi_wholemap ind_az(iPoint)];
            rg_wholemap = [rg_wholemap ind_rg(iPoint)];
        end
    else
        % 当精选关闭时，直接将粗选结果作为最终选点
        azi_wholemap = ind_az.';
        rg_wholemap = ind_rg.';
    end

    
    figure(iLoop);hold on;plot(rg_wholemap,azi_wholemap,'r*');
    fprintf("第%d次迭代--选出%d个点\n",iLoop,length(rg_wholemap));

    % PGA 相位提取（圆周移位、解压缩、相位差分与积分）
    N = length(azi_wholemap); 
    dphase_all = NaN(Na,N); 
    Weight_all = NaN(Na,N);
    Theta_all  = NaN(Na,N);
    
    for iPoint = 1:N
        data_point = zeros(Na,1);
        datapower_peak = data_power(azi_wholemap(iPoint),rg_wholemap(iPoint));
        ind_valid_min = max(azi_wholemap(iPoint) - 2*Win_Azi, 1);
        ind_valid_max = min(azi_wholemap(iPoint) + 2*Win_Azi, Na);
        
        ind_up = find(data_power(ind_valid_min:azi_wholemap(iPoint)-1,rg_wholemap(iPoint))<datapower_peak*Threshold_Factor_Peak_Decay,1,'last')+ind_valid_min-1;
        if isempty(ind_up), ind_up=1; end
        ind_down = find(data_power(azi_wholemap(iPoint)+1:ind_valid_max,rg_wholemap(iPoint))<datapower_peak*Threshold_Factor_Peak_Decay,1,'first')+azi_wholemap(iPoint);
        if isempty(ind_down), ind_down=Na; end
        
        Win_Azi_Size =  ind_down - ind_up + 1;
        data_point(ind_up:ind_down) = data(ind_up:ind_down,rg_wholemap(iPoint));  
        
        n0 = round(sum(abs(data_point(ind_up:ind_down)).^2.*(ind_up:ind_down).')/sum(abs(data_point(ind_up:ind_down)).^2));
        data_point = circshift(data_point,-n0+1);
        
        R0 = R_axis(rg_wholemap(iPoint));


        % 直接提取该点所在距离单元的 RD 匹配滤波器，并取共轭作为解压缩算子
        H_inv_One = conj(H(:, rg_wholemap(iPoint))); 
        
        % 按照 RD 框架的频域定义进行 FFT、解压、IFFT
        data_point = fftshift(fft(data_point, [], 1), 1); 
        data_point = data_point .* H_inv_One;
        data_point = ifft(ifftshift(data_point, 1), [], 1);
        
        % 提取完相位历史后，直接圆周移位还原位置
        data_point = circshift(data_point, n0-1);    


        R_Doppler0 = R0*D_fdc;
        L_synthetic = thetaBw * R_Doppler0 / v * PRF *Factor_SyntheticAperture/cos(theta);
        ApertureStart = max([n0-round(L_synthetic/2) 1]);
        ApertureEnd = min([n0+round(L_synthetic/2) Na]);
        point = data_point(ApertureStart:ApertureEnd);
        
        d_phase = angle(conj(point(1:end-1)).*point(2:end));
        phase1 = [0;cumsum(d_phase)];
        
        phase1 = smooth(phase1,PhaseSmoothLen);
        phase1 = diff(phase1);
        phase1 = smooth(phase1,20);
        phase1 = interp1(1.5:((length(phase1))+0.5),phase1,1:length(phase1)+1,'linear','extrap');
        
        dphase_all(ApertureStart:ApertureEnd,iPoint) = phase1;
        Weight_all(ApertureStart:ApertureEnd,iPoint) = sqrt(IJ(azi_wholemap(iPoint),rg_wholemap(iPoint))/Win_Azi_Size)*abs(point)/max(abs(point));
        
        Theta_all(ApertureStart:ApertureEnd,iPoint) = theta;
    end
    clear data_power IJ;
    
    % 一维相位误差加权融合与全局补偿      
    phase_gradient_1d = zeros(Na, 1);
    for iNa = 1:Na
        ind_valid = find(~isnan(dphase_all(iNa,:)));
        if isempty(ind_valid)
            continue;
        end
        % 按权重进行加权平均，提取全局一维非线性相位【梯度】
        phase_gradient_1d(iNa) = sum(dphase_all(iNa, ind_valid) .* Weight_all(iNa, ind_valid)) / (sum(Weight_all(iNa, ind_valid)) + eps);
    end
    clear dphase_all Weight_all Theta_all;
    
    % 【关键修复】：必须将相位梯度进行沿方位向的累加积分，才能恢复出真实的相位误差历程！
    phase_error_1d = cumsum(phase_gradient_1d);
    
    if bRemoveLinearMoCo
        % 去除线性倾斜趋势，防止补偿后图像发生方位向平移和旋转畸变
        phase_error_1d = detrend(phase_error_1d);
    end

    % 1. 全局解压缩：图像域 -> 频域 -> 乘以 conj(H) -> 时域
    Sfa_uncomp = fftshift(fft(data, [], 1), 1);
    raw_data   = ifft(ifftshift(Sfa_uncomp .* conj(H), 1), [], 1);
    
    % 2. 在方位时域直接施加 PGA 提取的一维非线性相位误差补偿
    raw_data = raw_data .* exp(-1j * phase_error_1d);
    
    % 3. 全局重压缩：时域 -> 频域 -> 乘以原装的 H -> 图像域
    Sfa_recomp = fftshift(fft(raw_data, [], 1), 1);
    data       = ifft(ifftshift(Sfa_recomp .* H, 1), [], 1);
    clear raw_data;
    

    % 聚焦质量评估与结果输出 
    Es2 = calculate_Entropyy(data); 
    fprintf("第%d次迭代--熵：补偿前=%f,补偿后=%f -----",iLoop,Es1,Es2);
    if(Es2<Es1) 
        fprintf("PGA处理后，熵减小%f\n",Es1-Es2);
    else
        fprintf("PGA处理后，熵没有改善\n");
    end
    
    IC2 = calculateContrast(abs(data));
    fprintf("第%d次迭代--对比度：补偿前=%f,补偿后=%f -----",iLoop,IC1,IC2);
    if(IC2>IC1) 
        fprintf("PGA处理后，对比度增大%f\n",IC2-IC1);
    else
        fprintf("PGA处理后，对比度没有改善\n");
    end
end
%% ---------- PGA 补偿后的最终成像与显示 ----------
% PGA 大循环结束后，变量 data 即为最终的二维复图像
img_pga = data;