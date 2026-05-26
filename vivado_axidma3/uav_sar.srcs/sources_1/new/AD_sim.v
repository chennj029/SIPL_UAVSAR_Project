`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/05 16:28:14
// Design Name: 
// Module Name: AD_sim
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


 module ADC_sim(
	input clk,
	input rst_n,
	input sample_en,
	input sample_start,
    (* MARK_DEBUG = "true" *)output [15:0] AD_out
    );
    reg[15:0] ADC_data;
    always@(posedge clk or negedge rst_n) begin
    	if(~rst_n) begin
    		ADC_data <= 16'd0;
    	end
    	else begin
    	   if(sample_start) begin
    	       if(sample_en) begin
    		      ADC_data <= ADC_data + 1'b1;
    	       end
    	       else begin
    	           ADC_data <= ADC_data;
    	       end
    	   end
    	   else begin
    	       ADC_data <= ADC_data;
    	   end
    	end  
    end
    assign AD_out=ADC_data;
endmodule
