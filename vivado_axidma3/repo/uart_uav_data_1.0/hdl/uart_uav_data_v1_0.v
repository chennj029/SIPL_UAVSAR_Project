
`timescale 1 ns / 1 ps

	module uart_uav_data_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 5,

		// Parameters of Axi Master Bus Interface M00_AXIS
		parameter integer C_M00_AXIS_TDATA_WIDTH	= 32,
		parameter integer C_M00_AXIS_START_COUNT	= 32
	)
	(
		// Users to add ports here
        // IP外部接口
        input   wire         uart_rxd,
        input   wire [63:0]  clk_cnt,
        output  wire         utc_done,
//        output  wire         uart_rx_done, 
//        output  wire [7:0]   uart_rx_data,
//        output  wire [79:0]  align_time,
//        output  wire         time_aligned_done,
        input   wire         first_pulse_flag, // 来自采样的clk_div模块输出
        
        // M_AXIS信号接口
//        input          m00_axis_tready,
//        input          m00_axis_aresetn,
//        input          m00_axis_aclk,
//        output [15: 0] m00_axis_tdata,
//        output [ 1: 0] m00_axis_tkeep,
//        output         m00_axis_tlast,
//        output         m00_axis_tvalid,
		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S00_AXI
		input wire  s00_axi_aclk,
		input wire  s00_axi_aresetn,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
		input wire [2 : 0] s00_axi_awprot,
		input wire  s00_axi_awvalid,
		output wire  s00_axi_awready,
		input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
		input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
		input wire  s00_axi_wvalid,
		output wire  s00_axi_wready,
		output wire [1 : 0] s00_axi_bresp,
		output wire  s00_axi_bvalid,
		input wire  s00_axi_bready,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
		input wire [2 : 0] s00_axi_arprot,
		input wire  s00_axi_arvalid,
		output wire  s00_axi_arready,
		output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
		output wire [1 : 0] s00_axi_rresp,
		output wire  s00_axi_rvalid,
		input wire  s00_axi_rready,

		// Ports of Axi Master Bus Interface M00_AXIS
		input wire  m00_axis_aclk,
		input wire  m00_axis_aresetn,
		output wire  m00_axis_tvalid,
		output wire [C_M00_AXIS_TDATA_WIDTH-1 : 0] m00_axis_tdata,
		output wire [(C_M00_AXIS_TDATA_WIDTH/8)-1 : 0] m00_axis_tkeep,
		output wire  m00_axis_tlast,
		input wire  m00_axis_tready
	);
// Instantiation of Axi Bus Interface S00_AXI
	uart_uav_data_v1_0_S00_AXI # ( 
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) uart_uav_data_v1_0_S00_AXI_inst (
	
		.uart_rxd(uart_rxd),
	    .clk_cnt(clk_cnt),
	    .utc_done(utc_done),
//    	.uart_rx_done(uart_rx_done),
//    	.uart_rx_data(uart_rx_data),
//    	.align_time(align_time),
//    	.time_aligned_done(time_aligned_done),
    	.first_pulse_flag(first_pulse_flag),

        .m00_axis_tdata   (m00_axis_tdata   ),
        .m00_axis_tkeep   (m00_axis_tkeep   ),
        .m00_axis_tlast   (m00_axis_tlast   ),
        .m00_axis_tready  (m00_axis_tready  ),
        .m00_axis_tvalid  (m00_axis_tvalid  ),
        .m00_axis_aresetn (m00_axis_aresetn ),
        .m00_axis_aclk    (m00_axis_aclk    ),
        	
		.S_AXI_ACLK(s00_axi_aclk),
		.S_AXI_ARESETN(s00_axi_aresetn),
		.S_AXI_AWADDR(s00_axi_awaddr),
		.S_AXI_AWPROT(s00_axi_awprot),
		.S_AXI_AWVALID(s00_axi_awvalid),
		.S_AXI_AWREADY(s00_axi_awready),
		.S_AXI_WDATA(s00_axi_wdata),
		.S_AXI_WSTRB(s00_axi_wstrb),
		.S_AXI_WVALID(s00_axi_wvalid),
		.S_AXI_WREADY(s00_axi_wready),
		.S_AXI_BRESP(s00_axi_bresp),
		.S_AXI_BVALID(s00_axi_bvalid),
		.S_AXI_BREADY(s00_axi_bready),
		.S_AXI_ARADDR(s00_axi_araddr),
		.S_AXI_ARPROT(s00_axi_arprot),
		.S_AXI_ARVALID(s00_axi_arvalid),
		.S_AXI_ARREADY(s00_axi_arready),
		.S_AXI_RDATA(s00_axi_rdata),
		.S_AXI_RRESP(s00_axi_rresp),
		.S_AXI_RVALID(s00_axi_rvalid),
		.S_AXI_RREADY(s00_axi_rready)
	);

// Instantiation of Axi Bus Interface M00_AXIS
//	uart_uav_data_v1_0_M00_AXIS # ( 
//		.C_M_AXIS_TDATA_WIDTH(C_M00_AXIS_TDATA_WIDTH),
//		.C_M_START_COUNT(C_M00_AXIS_START_COUNT)
//	) uart_uav_data_v1_0_M00_AXIS_inst (
//		.M_AXIS_ACLK(m00_axis_aclk),
//		.M_AXIS_ARESETN(m00_axis_aresetn),
//		.M_AXIS_TVALID(m00_axis_tvalid),
//		.M_AXIS_TDATA(m00_axis_tdata),
//		.M_AXIS_TSTRB(m00_axis_tstrb),
//		.M_AXIS_TLAST(m00_axis_tlast),
//		.M_AXIS_TREADY(m00_axis_tready)
//	);

	// Add user logic here

	// User logic ends

	endmodule
