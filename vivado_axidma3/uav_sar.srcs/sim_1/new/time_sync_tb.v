`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/27 21:40:19
// Design Name: 
// Module Name: time_sync_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module time_sync_tb;

    // 输入信号
    reg clk;
    reg rst_n;

    // clk_div 信号
    wire [31:0] clk_cnt; // 输出到 time_sync 的时钟计数器
    reg module_en;       // clk_div 启用信号
    wire time_sync_done; // 来自 time_sync 的时间对齐完成信号

    // utc_time 信号
    reg [7:0] uart_rx_data; // 模拟串口输入数据
    reg uart_rx_done;       // 模拟串口接收完成信号
    wire [71:0] utc_time;   // UTC 时间，输出到 time_sync

    // time_sync 信号
    wire [71:0] utc_time_sync; // 对齐后的 UTC 时间

    // 时钟信号生成
    always #5 clk = ~clk; // 100MHz 时钟



    // 仿真输入数据
    initial begin
        // 初始化信号
        clk = 1'b0;
        rst_n = 1'b0;
        module_en = 1'b0;
        uart_rx_data = 8'b0;
        uart_rx_done = 1'b0;

        // 复位
        #20;
        rst_n = 1'b1;

        // 启用 clk_div 模块
        #20;
        module_en = 1'b1;

        // 模拟串口接收到 UTC 时间 $GPGGA,120101.23
        #100;
        uart_rx_data = "$"; uart_rx_done = 1'b1; #10; uart_rx_done = 1'b0;
        uart_rx_data = "G"; uart_rx_done = 1'b1; #10; uart_rx_done = 1'b0;
        uart_rx_data = "P"; uart_rx_done = 1'b1; #10; uart_rx_done = 1'b0;
        uart_rx_data = "G"; uart_rx_done = 1'b1; #10; uart_rx_done = 1'b0;
        uart_rx_data = "G"; uart_rx_done = 1'b1; #10; uart_rx_done = 1'b0;
        uart_rx_data = "A"; uart_rx_done = 1'b1; #10; uart_rx_done = 1'b0;
        uart_rx_data = ","; uart_rx_done = 1'b1; #10; uart_rx_done = 1'b0;
        uart_rx_data = "1"; uart_rx_done = 1'b1; #10; uart_rx_done = 1'b0;
        uart_rx_data = "2"; uart_rx_done = 1'b1; #10; uart_rx_done = 1'b0;
        uart_rx_data = "0"; uart_rx_done = 1'b1; #10; uart_rx_done = 1'b0;
        uart_rx_data = "1"; uart_rx_done = 1'b1; #10; uart_rx_done = 1'b0;
        uart_rx_data = "0"; uart_rx_done = 1'b1; #10; uart_rx_done = 1'b0;
        uart_rx_data = "1"; uart_rx_done = 1'b1; #10; uart_rx_done = 1'b0;
        uart_rx_data = "."; uart_rx_done = 1'b1; #10; uart_rx_done = 1'b0;
        uart_rx_data = "2"; uart_rx_done = 1'b1; #10; uart_rx_done = 1'b0;
        uart_rx_data = "3"; uart_rx_done = 1'b1; #10; uart_rx_done = 1'b0;

        // 等待时间对齐完成
        #500;

        // 结束仿真
        #1000;
        $stop;
    end

    // 模块实例化
    clk_div u_clk_div (
        .clk_in(clk),
        .rst_n(rst_n),
        .ext_trig(1'b0),         // 忽略外部触发
        .prt_count(32'd2000000),    // PRT 为 2000000 个时钟周期=20ms,50Hz PRF
        .pulse_width(32'd200000),   // 脉冲宽度 为 200000个时钟周期=2ms
        .module_en(module_en),
        .trig_sel(1'b1),         // 内部触发
        .time_sync_done(time_sync_done), // 输入时间对齐完成标志
        .triggle(),              // 忽略触发信号
        .sample_en(),            // 忽略采样信号
        .led(),                  // 忽略 LED 信号
        .clk_cnt(clk_cnt)        // 输出时钟计数器
    );

    utc_time u_utc_time (
        .clk(clk),
        .rst_n(rst_n),
        .uart_rx_data(uart_rx_data),
        .uart_rx_done(uart_rx_done),
        .utc_time(utc_time),
        .utc_done(time_sync_done) // 输出对齐完成信号
    );

    time_sync u_time_sync (
        .clk(clk),
        .rst_n(rst_n),
        .clk_cnt(clk_cnt),
        .utc_time(utc_time),
        .utc_time_sync(utc_time_sync),
        .time_sync_done(time_sync_done)
    );
	
endmodule

