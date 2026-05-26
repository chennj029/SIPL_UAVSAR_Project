`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/23 17:52:11
// Design Name: 
// Module Name: uart_top
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


module pl_uart(
	input 		sys_clk,
	input		sys_rst_n,
	
	input 		uart_rxd,
	output 		uart_txd
	);
	
parameter 		CLK_FREQ = 50000000;
parameter		UART_BPS = 115200;

wire 			uart_rx_done;
wire [7:0]		uart_rx_data;

uart_rx #(
	.CLK_FREQ(CLK_FREQ),
	.UART_BPS(UART_BPS)
	)
	u_uart_rx(
	.clk(sys_clk),
	.rst_n(sys_rst_n),
	
	.uart_rxd(uart_rxd),
	.uart_rx_done(uart_rx_done),
	.uart_rx_data(uart_rx_data)
	);
	
uart_tx #(
	.CLK_FREQ(CLK_FREQ),
	.UART_BPS(UART_BPS)
	)
	u_uart_tx(
	.clk(sys_clk),
	.rst_n(sys_rst_n),
	
	.uart_tx_en(uart_rx_done),
	.uart_tx_data(uart_rx_data),
	.uart_txd(uart_txd),
	.uart_tx_busy()
	);
	
endmodule
