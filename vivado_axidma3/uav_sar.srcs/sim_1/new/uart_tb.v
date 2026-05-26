`timescale 1ns / 1ps

module uart_tb;

    // 参数定义
    parameter CLK_FREQ = 50000000;      // 系统时钟频率
    parameter UART_BPS = 115200;        // 串口波特率
    localparam BAUD_PERIOD = 1000000000 / UART_BPS; // 波特率周期（纳秒），即每BAUD_PERIOD ns传输一位

    // Testbench 信号定义
    reg sys_clk;
    reg sys_rst_n;
    reg uart_rxd;
    wire uart_txd;

    // 待发送的 GPGGA 字符串
    reg [7:0] gpgga_data [0:31]; // 存储 GPGGA 字符串
    integer i;


	always #10 sys_clk = ~sys_clk;
	
    // 初始化和复位
    initial begin
        // 初始化信号
		sys_clk <= 1'b1;
        sys_rst_n <= 1'b0;
        uart_rxd <= 1'b1; // 空闲状态为高电平

        // 待发送的 GPGGA 数据
        gpgga_data[0] = "$";
        gpgga_data[1] = "G";
        gpgga_data[2] = "P";
        gpgga_data[3] = "G";
        gpgga_data[4] = "G";
        gpgga_data[5] = "A";
        gpgga_data[6] = ",";
        gpgga_data[7] = "1";
        gpgga_data[8] = "4";
        gpgga_data[9] = "5";
        gpgga_data[10] = "9";
        gpgga_data[11] = "5";
        gpgga_data[12] = "9";
        gpgga_data[13] = ".";
        gpgga_data[14] = "3";
        gpgga_data[15] = "3";
        gpgga_data[16] = ",";
		gpgga_data[17] = "2";
		gpgga_data[18] = "2";
		gpgga_data[19] = "4";
		gpgga_data[20] = "8";
		gpgga_data[21] = ".";
		gpgga_data[22] = "1";
		gpgga_data[23] = "9";
		gpgga_data[24] = "4";
		gpgga_data[25] = "4";
		gpgga_data[26] = ",";
		gpgga_data[27] = "N";
		gpgga_data[28] = ",";
		gpgga_data[29] = "-";
		gpgga_data[30] = "1";
		gpgga_data[31] = "\r"; // 模拟结束符（可选）

        // 释放复位
        #(100);
        sys_rst_n = 1'b1;

        // 模拟发送 GPGGA 字符串
		// send_byte(8'h24);
		// send_byte(8'h47);
		// send_byte(8'h50);
		// send_byte(8'h47);
		// send_byte(8'h47);
		// send_byte(8'h41);
        for (i = 0; i < 32; i = i + 1) begin
            send_byte(gpgga_data[i][7:0]);
        end

        // 测试完成
        #(1000);
        $stop;
    end

    // 模拟发送一个字节（8 数据位，无校验，1 停止位）
    task send_byte(input [7:0] data);
        integer j;
        begin
            // 起始位
            uart_rxd = 1'b0;	
            #(BAUD_PERIOD);

            // 数据位（从最低位开始发送）
            for (j = 0; j < 8; j = j + 1) begin
                uart_rxd = data[j];
                #(BAUD_PERIOD);
            end

            // 停止位
            uart_rxd = 1'b1;
            #(BAUD_PERIOD);
        end
    endtask

    //捕获接收到的数据
    // always @(posedge clk) begin
        // if (uart_rx_done) begin
            // $display("Received Data: %c", uart_rxd);
        // end
    // end

    // UART 接收模块实例化
    pl_uart uut (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .uart_rxd(uart_rxd),
		.uart_txd(uart_txd)
    );
	
endmodule
