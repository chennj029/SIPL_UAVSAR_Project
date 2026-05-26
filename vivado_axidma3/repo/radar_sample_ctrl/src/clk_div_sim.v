`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/31 01:14:50
// Design Name: 
// Module Name: clk_div_sim
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


module clk_div_sim();
    reg clk_in,rst_n;
    wire clk_out;
    initial begin
    clk_in=0;
    rst_n=0;
    #500 rst_n=1;
    #100000 $stop;
    end
    
   parameter PERIOD = 200;

   always begin
      clk_in = 1'b0;
      #(PERIOD/2) clk_in = 1'b1;
      #(PERIOD/2);
   end
    clk_div dut(
        .clk_in(clk_in),
        .rst_n(rst_n),
        .div_count(32'd10),
        .duty_cycle(32'd3),
        .clk_out(clk_out)
    );
endmodule
