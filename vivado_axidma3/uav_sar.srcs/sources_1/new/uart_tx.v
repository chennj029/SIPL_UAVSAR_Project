`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/23 16:32:23
// Design Name: 
// Module Name: uart_tx
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

module uart_tx(
	input 			clk,
	input 			rst_n,
	
	input 			uart_tx_en,		// 发送使能
	input [7:0] 	uart_tx_data,	// 发送数据
	output reg 		uart_txd,		// 发送端口数据线
	output reg 		uart_tx_busy	// 发送忙信号
	
	);
	
parameter 		CLK_FREQ = 50000000;
parameter 		UART_BPS = 115200;
localparam 		BAUD_CNT_MAX = CLK_FREQ/UART_BPS;

reg [7:0]		tx_data_t;			// 发送数据寄存器
reg [3:0] 		tx_cnt;				// 发送数据计数器
reg [15:0] 		baud_cnt;			// 波特率计数器

// 当开始发送，寄存发送数据，并拉高发送忙信号。发送一帧数据（8bit）后停止发送
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		tx_data_t <= 8'b0;
		uart_tx_busy <= 1'b0;
		end
	else if(uart_tx_en) begin
		tx_data_t <= uart_tx_data;
		uart_tx_busy <= 1'b1;
		end
	else if(tx_cnt == 4'd9 && baud_cnt == BAUD_CNT_MAX-1'b1) begin
		tx_data_t <= 8'b0;
		uart_tx_busy <= 1'b0;
		end
	else begin
		tx_data_t <= tx_data_t;
		uart_tx_busy <= uart_tx_busy;
		end
	end

// 波特率计数器
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		baud_cnt <= 16'd0;
		end
	else if(uart_tx_en) begin  // ????????可以去掉吗
		baud_cnt <= 16'd0;
		end
	else if(uart_tx_busy) begin
		if(baud_cnt < BAUD_CNT_MAX-1'b1)
			baud_cnt <= baud_cnt + 1'b1;
		else
			baud_cnt <= 16'd0;
		end
	else
		baud_cnt <= 16'd0;
	end
	
// 发送数据计数器
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		tx_cnt <= 4'd0;
		end
	else if(uart_tx_en) begin // ???????
		tx_cnt <= 4'd0;
		end
	else if(uart_tx_busy) begin
		if(baud_cnt == BAUD_CNT_MAX-1'b1)
			tx_cnt <= tx_cnt + 1'b1;
		else
			tx_cnt <= tx_cnt;
		end
	else	
		tx_cnt <= 4'd0;
	end

// 根据tx_cnt寄存待发送的数据，计数到8时完成整帧数据的寄存
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		uart_txd <= 1'b1;
		end
	else if(uart_tx_busy) begin
		case(tx_cnt) 
			4'd0: uart_txd <= 1'b0; 		// 起始位
			4'd1: uart_txd <= tx_data_t[0];
			4'd2: uart_txd <= tx_data_t[1];
			4'd3: uart_txd <= tx_data_t[2];
			4'd4: uart_txd <= tx_data_t[3];
			4'd5: uart_txd <= tx_data_t[4];
			4'd6: uart_txd <= tx_data_t[5];
			4'd7: uart_txd <= tx_data_t[6];
			4'd8: uart_txd <= tx_data_t[7];
			4'd9: uart_txd <= 1'b1;			// 停止位
			default: uart_txd <= 1'b1;
			endcase
		end
	else begin
		uart_txd <= 1'b1;
		end
	end

endmodule			