`timescale 1 ns / 1 ps

module ad9269_sample_v1_0 #(
    // Parameters of Axi Slave Bus Interface S00_AXI
    parameter integer C_S00_AXI_DATA_WIDTH	= 64,
    parameter integer C_S00_AXI_ADDR_WIDTH	= 6
)
(
    input          sys_clk,
    
    input          ext_trig,  //external trigger input (optional)
    input          trig_sel,  //internal/external trigger source select, 1 for internal and 0 for external
    output         triggle,
    output         led,
    input          adc_clk,
    input          adc_rst_n,    
    input  [15: 0] adc_data,
    
    input          utc_done,  /////////////////////////////////////////////////////////////////////////v2.0
    output [63:0]  clk_cnt,   /////////////////////////////////////////////////////////////////////////v2.0
    output         first_pulse_flag, /////////////////////////////////////////////////////////////////v3.0
//    output         sample_en,           //////////////v5.0--debug
    
    (* MARK_DEBUG = "TRUE" *) input          m00_axis_tready,
    (* MARK_DEBUG = "TRUE" *) input          m00_axis_aresetn,
    (* MARK_DEBUG = "TRUE" *) input          m00_axis_aclk,
    (* MARK_DEBUG = "TRUE" *) output [15: 0] m00_axis_tdata,
    (* MARK_DEBUG = "TRUE" *) output [ 1: 0] m00_axis_tkeep,
    (* MARK_DEBUG = "TRUE" *) output         m00_axis_tlast,
    (* MARK_DEBUG = "TRUE" *) output         m00_axis_tvalid,

    // Ports of Axi Slave Bus Interface S00_AXI
    input wire  [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
    input wire  [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
    input wire  [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
    input wire  [2 : 0] s00_axi_awprot,
    input wire  [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
    input wire  [2 : 0] s00_axi_arprot,
    input wire  s00_axi_aclk,
    input wire  s00_axi_aresetn,
    input wire  s00_axi_awvalid,
    input wire  s00_axi_wvalid,
    input wire  s00_axi_bready,
    input wire  s00_axi_arvalid,
    input wire  s00_axi_rready,
    
    output wire [1 : 0] s00_axi_bresp,
    output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
    output wire [ 1: 0] s00_axi_rresp,
    output wire  s00_axi_awready,
    output wire  s00_axi_wready,
    output wire  s00_axi_bvalid,
    output wire  s00_axi_arready,
    output wire  s00_axi_rvalid 
);

// Instantiation of Axi Bus Interface S00_AXI
ad9269_sample_v1_0_S00_AXI #( 
    .C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
    .C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
)
ad9269_sample_v1_0_S00_AXI_inst(
    .sys_clk          (sys_clk),
    
    .trig_sel         (trig_sel         ),
    .ext_trig         (ext_trig         ),
    .triggle          (triggle          ),
    .led              (led              ),
    .adc_clk          (adc_clk          ),
    .adc_rst_n        (adc_rst_n        ),
    .adc_data         (adc_data         ),
    .utc_done   (utc_done   ),////////////////////////////////////////////v2.0
    .clk_cnt    (clk_cnt    ), ////////////////////////////////////////////v2.0
    .first_pulse_flag  (first_pulse_flag), ////////////////////////////////v3.0
//    .sample_en  (sample_en),//////////////v5.0
    
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

endmodule
