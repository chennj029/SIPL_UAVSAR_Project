`timescale 1ns / 1ps

module time_align(
	input				clk,
	input				rst_n,
	
	input 				module_en,
	input [7:0]			uart_rx_data,
	input 				uart_rx_done,
	
	output  [63:0] 	    clk_cnt,
	output  [79:0]	    time_aligned,
	output 				time_aligned_done
	
	
);


wire [71:0]		utc_time;
wire 			utc_done;


utc_time u_utc_time(
	.clk(clk),
	.rst_n(rst_n),
	
	.uart_rx_data(uart_rx_data),
	.uart_rx_done(uart_rx_done),
	.clk_cnt(clk_cnt),
	
	.utc_time(utc_time),
	.utc_done(utc_done),
	.time_aligned(time_aligned),
	.time_aligned_done(time_aligned_done)
	);
	
sample u_sample(
	.clk(clk),
	.rst_n(rst_n),
	
	.utc_done(utc_done),
	.module_en(module_en),
	
	.clk_cnt(clk_cnt)
	);
	

////----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
//axi_fifo_mm_s_0 your_instance_name (
//  .interrupt(interrupt),                            // output wire interrupt 当FIFO状态变化或发生错误时触发
//  .s_axi_aclk(s_axi_aclk),                          // input wire s_axi_aclk
//  .s_axi_aresetn(s_axi_aresetn),                    // input wire s_axi_aresetn
//  // AXI4-Lite接口
//  // 地址写信号组
//  .s_axi_awaddr(s_axi_awaddr),                      // input wire [31 : 0] s_axi_awaddr 32位写操作目标寄存器地址
//  .s_axi_awvalid(s_axi_awvalid),                    // input wire s_axi_awvalid 地址有效信号，高电平有效
//  .s_axi_awready(s_axi_awready),                    // output wire s_axi_awready 地址就绪信号
//  // 写数据信号组
//  .s_axi_wdata(s_axi_wdata),                        // input wire [31 : 0] s_axi_wdata 32位写数据
//  .s_axi_wstrb(s_axi_wstrb),                        // input wire [3 : 0] s_axi_wstrb 写数据的字节有效信号
//  .s_axi_wvalid(s_axi_wvalid),                      // input wire s_axi_wvalid 写数据有效信号
//  .s_axi_wready(s_axi_wready),                      // output wire s_axi_wready 写数据就绪信号
//  // 写响应信号组
//  .s_axi_bresp(s_axi_bresp),                        // output wire [1 : 0] s_axi_bresp 写响应信号，2位
//  .s_axi_bvalid(s_axi_bvalid),                      // output wire s_axi_bvalid 写响应有效信号
//  .s_axi_bready(s_axi_bready),                      // input wire s_axi_bready  写响应就绪信号，表示主设备已接受写响应
//  // 地址读信号组
//  .s_axi_araddr(s_axi_araddr),                      // input wire [31 : 0] s_axi_araddr
//  .s_axi_arvalid(s_axi_arvalid),                    // input wire s_axi_arvalid
//  .s_axi_arready(s_axi_arready),                    // output wire s_axi_arready
//  // 读数据信号组
//  .s_axi_rdata(s_axi_rdata),                        // output wire [31 : 0] s_axi_rdata
//  .s_axi_rresp(s_axi_rresp),                        // output wire [1 : 0] s_axi_rresp
//  .s_axi_rvalid(s_axi_rvalid),                      // output wire s_axi_rvalid
//  .s_axi_rready(s_axi_rready),                      // input wire s_axi_rready
  
  
//  // 发送数据 PL->PS
//  .mm2s_prmry_reset_out_n(mm2s_prmry_reset_out_n),  // output wire mm2s_prmry_reset_out_n 发送通道复位信号
//  .axi_str_txd_tvalid(axi_str_txd_tvalid),          // output wire axi_str_txd_tvalid
//  .axi_str_txd_tready(axi_str_txd_tready),          // input wire axi_str_txd_tready
//  .axi_str_txd_tlast(axi_str_txd_tlast),            // output wire axi_str_txd_tlast 最后一包发送数据
//  .axi_str_txd_tdata(axi_str_txd_tdata),            // output wire [31 : 0] axi_str_txd_tdata
//  .mm2s_cntrl_reset_out_n(mm2s_cntrl_reset_out_n),  // output wire mm2s_cntrl_reset_out_n 控制复位信号
//  .axi_str_txc_tvalid(axi_str_txc_tvalid),          // output wire axi_str_txc_tvalid 发送控制数据有效
//  .axi_str_txc_tready(axi_str_txc_tready),          // input wire axi_str_txc_tready 对端设备准备好接收控制数据
//  .axi_str_txc_tlast(axi_str_txc_tlast),            // output wire axi_str_txc_tlast 发送的最后一个控制数据
//  .axi_str_txc_tdata(axi_str_txc_tdata),            // output wire [31 : 0] axi_str_txc_tdata 32位控制数据
//  // 接收数据 PS->PL
//  .s2mm_prmry_reset_out_n(s2mm_prmry_reset_out_n),  // output wire s2mm_prmry_reset_out_n
//  .axi_str_rxd_tvalid(axi_str_rxd_tvalid),          // input wire axi_str_rxd_tvalid
//  .axi_str_rxd_tready(axi_str_rxd_tready),          // output wire axi_str_rxd_tready
//  .axi_str_rxd_tlast(axi_str_rxd_tlast),            // input wire axi_str_rxd_tlast
//  .axi_str_rxd_tdata(axi_str_rxd_tdata)            // input wire [31 : 0] axi_str_rxd_tdata
//);

endmodule
