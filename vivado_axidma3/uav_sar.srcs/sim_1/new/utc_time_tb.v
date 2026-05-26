`timescale 1ns / 1ps

module utc_time_tb;

    // Testbench 信号
    reg         clk;
    reg         rst_n;
    reg [7:0]   uart_rx_data;
    reg         uart_rx_done;
    wire [71:0] utc_time; // 连接被测模块的输出
	wire 		utc_done;



	always #10 clk = ~clk;

    // 测试信号初始化与测试序列
    initial begin
        // 初始化信号
		clk   = 1'b0;
        rst_n = 1'b0;
        uart_rx_data = 8'b0;
        uart_rx_done = 1'b0;

        // 复位系统
        #10;
        rst_n = 1'b1;

        // 模拟发送数据流 "$GPGGA,"
        #100;
		uart_rx_done = 1'b1;
		#20;
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h24;
		#800;
		uart_rx_done = 1'b1;
		#20;
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h47;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h50;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h47;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h47;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h41;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h2c;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h01;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h04;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h03;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h08;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h05;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h09;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h2e;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h02;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h06;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h2c;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h02; // &
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h02;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h04;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h08;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h2e;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h01;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h09;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h2c;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h4e;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h0a; //换行符
		#800
		uart_rx_done = 1'b1;
		#20;
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h24;
		#800;
		uart_rx_done = 1'b1;
		#20;
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h47;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h50;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h47;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h47;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h41;
		#800
		uart_rx_done = 1'b1;
		#20
        uart_rx_done = 1'b0;
		uart_rx_data = 8'h2c;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h00;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h08;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h14;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h25;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h07;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h20;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h2e;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h05;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h09;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
		uart_rx_data = 8'h2c;
		#800
		uart_rx_done = 1'b1;
		#20
		uart_rx_done = 1'b0;
			
	end

    // 被测模块实例化
    utc_time uut (
        .clk(clk),
        .rst_n(rst_n),
        .uart_rx_data(uart_rx_data),
        .uart_rx_done(uart_rx_done),
        .utc_time(utc_time),
		.utc_done(utc_done)
    );

endmodule
