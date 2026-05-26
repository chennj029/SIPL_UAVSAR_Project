`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/22 16:57:39
// Design Name: 
// Module Name: uart_rx
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

module uart_rx(
    input clk,
	input rst_n,
	
	input uart_rxd,					// 接收端口数据线
	output reg uart_rx_done,  		// 接收完成标志
	output reg [7:0] uart_rx_data	// 接收到的字符，ASCII

    );
	
parameter 	CLK_FREQ = 50000000; 		
parameter 	UART_BPS = 115200; 					// 串口波特率
localparam 	BAUD_CNT_MAX = CLK_FREQ/UART_BPS; 	// 当前波特率下，串口传输一位所需要的系统时钟周期数

reg 		uart_rxd_d0;
reg			uart_rxd_d1;
reg 		uart_rxd_d2;
reg			rx_flag; 							// 接收过程标志
reg	 [3:0]  rx_cnt;								// 接收数据计数器，接收1位就加一
reg  [15:0] baud_cnt;							// 波特率计数器，数一个波特率周期对应的系统时钟周期数
reg  [7:0]  rx_data_t; 							// 接收数据寄存器

wire 		start_en;
assign 		start_en = uart_rxd_d2 & (~uart_rxd_d1) & (~rx_flag); // 捕获接收端口下降沿（起始位），得到一个时钟周期的脉冲信号


// 针对异步信号的同步处理，避免异步信号亚稳态
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		uart_rxd_d0 <= 1'b1;
		uart_rxd_d1 <= 1'b1;
		uart_rxd_d2 <= 1'b1;
		end
	else begin
		uart_rxd_d0 <= uart_rxd;
		uart_rxd_d1 <= uart_rxd_d0;
		uart_rxd_d2 <= uart_rxd_d1;
		end
	end
	
// 接收标志，检测到起始位就拉高，当接收完一个完整数据帧（包括停止位）后就清除
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		rx_flag <= 1'b0;
	else if(start_en)
		rx_flag <= 1'b1;
	else if((rx_cnt == 4'd9) && (baud_cnt == BAUD_CNT_MAX/2-1'b1)) // 当接收到停止位即rx_cnt计数到9，就可以拉低rx_flag
		rx_flag <= 1'b0;										// 波特计数到一半是因为此时是采样该位的最佳时刻
	else
		rx_flag <= rx_flag;
	end
	
// 波特率计数器
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		baud_cnt <= 16'd0;
	else if(rx_flag) begin
		if(baud_cnt < BAUD_CNT_MAX - 1'b1)
			baud_cnt <= baud_cnt + 16'b1;
		else
			baud_cnt <= 16'd0;
		end
	else
		baud_cnt <= 16'd0;
	end

// 接收数据计数器
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		rx_cnt <= 4'd0;
	else if(rx_flag) begin
		if(baud_cnt == BAUD_CNT_MAX - 1'b1)
			rx_cnt <= rx_cnt + 1'b1;
		else	
			rx_cnt <= rx_cnt;
		end
	else
		rx_cnt <= 4'd0;
	end

// 根据rx_cnt寄存接收到的数据，计数到8时完成整帧数据的寄存
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) 
		rx_data_t <= 8'b0;
	else if(rx_flag) begin
		if(baud_cnt == BAUD_CNT_MAX/2-1'b1) begin // 在采样稳定时刻开始寄存接收数据
			case(rx_cnt)
				4'd1: rx_data_t[0] <= uart_rxd_d2;
				4'd2: rx_data_t[1] <= uart_rxd_d2;
				4'd3: rx_data_t[2] <= uart_rxd_d2;
				4'd4: rx_data_t[3] <= uart_rxd_d2;
				4'd5: rx_data_t[4] <= uart_rxd_d2;
				4'd6: rx_data_t[5] <= uart_rxd_d2;
				4'd7: rx_data_t[6] <= uart_rxd_d2;
				4'd8: rx_data_t[7] <= uart_rxd_d2;
				default: ;
				endcase
			end
		else
			rx_data_t <= rx_data_t;
		end
	else
		rx_data_t <= 8'b0;
	end
	
// 接收完成信号以及输出的接收数据
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		uart_rx_done <= 1'b0;
		uart_rx_data <= 8'b0;
		end
	else if(rx_cnt == 4'd9 && baud_cnt == BAUD_CNT_MAX/2-1'b1) begin
		uart_rx_done <= 1'b1; // 一个字节（8bit）接收完毕，拉高接收完成信号
		uart_rx_data <= rx_data_t;
		end
	else begin
		uart_rx_done <= 1'b0;
		uart_rx_data <= uart_rx_data;
		end
	end
	
endmodule