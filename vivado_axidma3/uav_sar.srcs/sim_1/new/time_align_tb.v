`timescale 1ns / 1ps

module time_align_tb;

    // Testbench 信号
    reg         clk;
    reg         rst_n;
    reg [7:0]   uart_rx_data;
    reg         uart_rx_done;
	reg			module_en;
	
    wire [63:0] clk_cnt;
	wire [79:0] time_aligned;
	wire 		time_aligned_done;
	

	always #10 clk = ~clk; // 50MHz


    initial begin
        // 初始化
		clk   = 1'b0;
        rst_n = 1'b0;
		module_en = 1'b0;
		
        #10;
        rst_n = 1'b1;

		#100;
		module_en = 1'b1;
		#38000000; //38ms
		module_en = 1'b0;
	end

    // send_gpgga_data 任务，动态生成并发送GPGGA语句
	reg [191:0] gpgga_data; // 完整的 GPGGA 数据（$GPGGA,hhmmss.ss,2248,N,113,E）
	integer i,j;
	initial begin
		//gpgga_data = "$GPGGA,142301.10,2248,N\n";
		gpgga_data[7:0] = 8'h24;
		gpgga_data[15:8] = 8'h47;
		gpgga_data[23:16] = 8'h50;
		gpgga_data[31:24] = 8'h47;
		gpgga_data[39:32] = 8'h47;
		gpgga_data[47:40] = 8'h41;
		gpgga_data[55:48] = 8'h2c; //,
		gpgga_data[63:56] = 8'h01;
		gpgga_data[71:64] = 8'h04;
		gpgga_data[79:72] = 8'h02;
		gpgga_data[87:80] = 8'h03;
		gpgga_data[95:88] = 8'h00;
		gpgga_data[103:96] = 8'h01;
		gpgga_data[111:104] = 8'h2e; //.
		gpgga_data[119:112] = 8'h01;
		gpgga_data[127:120] = 8'h00;
		gpgga_data[135:128] = 8'h2c;
		gpgga_data[143:136] = 8'h02;
		gpgga_data[151:144] = 8'h02;
		gpgga_data[159:152] = 8'h04;
		gpgga_data[167:160] = 8'h08;
		gpgga_data[175:168] = 8'h2c;
		gpgga_data[183:176] = 8'h4e; //N
		gpgga_data[191:184] = 8'h0a; //\n
		end
	
    task send_gpgga_data;

        begin

			
            // 发送多个 GPGGA 数据，直到25ms
            // 一个 GPGGA 字符串的总长度为 72 位 (9 字节)
            for (i = 0; i < 26; i = i + 1) begin
                uart_rx_data = gpgga_data[(i+1)*8-1 -: 8]; // 提取一个字节
				#800
                uart_rx_done = 1'b1; // 表示当前字节已发送
                #20; // 每个字节之间的延时 800ns
                uart_rx_done = 1'b0;
            end
        end
    endtask
	
    initial begin
        // 初始化
		clk   = 1'b0;
        rst_n = 1'b0;
        uart_rx_data = 8'b0;
        uart_rx_done = 1'b0;
		
        #10;
        rst_n = 1'b1;
		#8000000;
		// 按顺序调用1250个任务
        for (j = 0; j < 2; j = j + 1) begin
            send_gpgga_data; // 顺序执行任务
			#2000000;
        end
        for (j = 0; j < 4; j = j + 1) begin
            send_gpgga_data; // 顺序执行任务
			#4000000;
        end		
	
	end
	

	
	
	time_align uut(
		.clk(clk),
		.rst_n(rst_n),
		.module_en(module_en),
		
		.uart_rx_data(uart_rx_data),
		.uart_rx_done(uart_rx_done),
		.clk_cnt(clk_cnt),
		.time_aligned(time_aligned),
		.time_aligned_done(time_aligned_done)
		);
		
endmodule
