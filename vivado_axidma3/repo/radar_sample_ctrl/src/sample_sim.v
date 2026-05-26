`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/02/02 00:08:27
// Design Name: 
// Module Name: sample_sim
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


module sample_sim();
    reg clk,rst_n,S_AXI_ACLK;
    reg start_clr_d0,start_clr_d1,start_clr_d2,start_clr_ack;
    
    reg sample_start;
    wire start_clr;
    wire clk_out;
    wire [15:0] adc_out;
    initial begin
    clk=0;
    S_AXI_ACLK=0;
    rst_n=0;
    sample_start=0;
    #500 rst_n=1;
    #1000 sample_start=1;
    #100000 $stop;
    end
    
   parameter PERIOD = 50;
   always begin
      clk = 1'b0;
      #(PERIOD/2) clk = 1'b1;
      #(PERIOD/2);
   end
   
   parameter PERIOD1 = 10;
   always begin
      S_AXI_ACLK = 1'b0;
      #(PERIOD1/2) S_AXI_ACLK = 1'b1;
      #(PERIOD1/2);
   end
   
    clk_div dut(
        .clk_in(clk),
        .rst_n(rst_n),
        .div_count(32'd1000),
        .duty_cycle(32'd100),
        .sample_en(clk_out)
    );
    
    ADC_sim dut1(
	.clk(clk),
	.rst_n(rst_n),
    .AD_out(adc_out)
    );
    
    ad9269_sample dut2(
	.adc_clk(clk),
	.adc_rst_n(rst_n),
	.adc_data(adc_out),
	
    .sample_len(32'd20000),        //sample length
	.sample_start(sample_start),      //sample start 
	.start_clr(start_clr),         //clear start register
	.start_clr_ack(start_clr_ack) ,    //ack
	.sample_en(clk_out),
	
//    output [15:0]               M_AXIS_tdata,
//    output [1:0]                M_AXIS_tkeep,
//    output                      M_AXIS_tlast,
    .M_AXIS_tready(1'b1),
//    output                      M_AXIS_tvalid,
    .M_AXIS_RSTN(rst_n),
	.M_AXIS_CLK(S_AXI_ACLK)
);
 
   always @( posedge S_AXI_ACLK )
	begin
	  if ( rst_n == 1'b0 )
	    begin
	      start_clr_d0 <= 0;
		  start_clr_d1 <= 0;
		  start_clr_d2 <= 0;
	    end 
	  else
	    begin    
	      start_clr_d0 <= start_clr;
		  start_clr_d1 <= start_clr_d0;
		  start_clr_d2 <= start_clr_d1;
	    end 
	end  
 
 always @( posedge S_AXI_ACLK )
begin
  if ( rst_n == 1'b0 )
      start_clr_ack  <= 1'b0;
  else if (start_clr_d2)
       start_clr_ack  <= 1'b1;
   else
       start_clr_ack  <= 1'b0;
end	
    
always @( posedge S_AXI_ACLK ) begin
  if ( rst_n == 1'b0 )
      sample_start  <= 1'b0;
  if (start_clr_d2)
       sample_start  <= 1'b0;
  else
       sample_start  <= sample_start;
end	
    
    
endmodule
