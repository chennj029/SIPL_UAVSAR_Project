// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1_AR75502 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
// Date        : Thu Jan 16 16:01:42 2025
// Host        : DESKTOP-STTR34N running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               e:/Files/uav_sar/vivado_axibram_new/uav_sar.srcs/sources_1/ip/fifo_generator_0/fifo_generator_0_stub.v
// Design      : fifo_generator_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu2cg-sfvc784-1-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_5,Vivado 2020.1_AR75502" *)
module fifo_generator_0(clk, srst, din, wr_en, rd_en, dout, full, empty, 
  wr_rst_busy, rd_rst_busy)
/* synthesis syn_black_box black_box_pad_pin="clk,srst,din[7:0],wr_en,rd_en,dout[7:0],full,empty,wr_rst_busy,rd_rst_busy" */;
  input clk;
  input srst;
  input [7:0]din;
  input wr_en;
  input rd_en;
  output [7:0]dout;
  output full;
  output empty;
  output wr_rst_busy;
  output rd_rst_busy;
endmodule
