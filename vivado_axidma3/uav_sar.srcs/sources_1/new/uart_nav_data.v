`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/01/09 21:57:00
// Design Name: 
// Module Name: uart_nav_data
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


module uart_nav_data(
        input                clk,
        input                rst_n,
		// BRAM PORTS
        output  wire         ram_clk,
        output  wire         ram_rst,
        output  wire         ram_en,
        output  wire [31:0]  ram_addr,                
        output  wire [3:0]   ram_we,
        output  wire [31:0]  ram_wr_data,
        input   wire [31:0]  ram_rd_data,
        
        // IP外部接口
        input   wire         uart_rxd,
        input   wire [63:0]  clk_cnt,
        output  wire         utc_done
    );
    
	// wire定义
	wire [7:0]     uart_rx_data;
	wire           uart_rx_done;
	wire [79:0]    align_time;
	wire           time_aligned_done;

	
	uart_rx u_uart_rx(
	       .clk(clk),
	       .rst_n(rst_n),
	       
	       .uart_rxd(uart_rxd),
	       .uart_rx_data(uart_rx_data),
	       .uart_rx_done(uart_rx_done),
	       
	       .ram_clk(ram_clk),
	       .ram_rst(ram_rst),
	       .ram_en(ram_en),
	       .ram_addr(ram_addr),
	       .ram_we(ram_we),
	       .ram_wr_data(ram_wr_data),
	       .ram_rd_data(ram_rd_data)
	       );
	 
	 utc_time u_utc_time(
	       .clk(clk),
	       .rst_n(rst_n),
	       .uart_rx_data(uart_rx_data),
	       .uart_rx_done(uart_rx_done),
	       .align_time(align_time),
	       .time_aligned_done(time_aligned_done),
	       
	       .utc_done(utc_done),
	       .clk_cnt(clk_cnt)
	       );
	 
	  align_time_to_regs u_align_time_to_regs(
	       .clk(clk),
	       .rst_n(rst_n),
	       .align_time(align_time),
	       .time_aligned_done(time_aligned_done),
	       .slv_reg0(slv_reg0),
	       .slv_reg1(slv_reg1),
	       .slv_reg2(slv_reg2)
	       );
	           
endmodule
