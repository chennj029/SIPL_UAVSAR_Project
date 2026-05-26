// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1_AR75502 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
// Date        : Fri Jan 10 15:11:42 2025
// Host        : DESKTOP-STTR34N running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               e:/Files/uav_sar/vivado_axibram/uav_sar.srcs/sources_1/ip/ila_0/ila_0_stub.v
// Design      : ila_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu2cg-sfvc784-1-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "ila,Vivado 2020.1_AR75502" *)
module ila_0(clk, probe0, probe1, probe2, probe3, probe4, probe5, 
  probe6, probe7, probe8, probe9)
/* synthesis syn_black_box black_box_pad_pin="clk,probe0[0:0],probe1[0:0],probe2[0:0],probe3[3:0],probe4[31:0],probe5[31:0],probe6[31:0],probe7[0:0],probe8[0:0],probe9[63:0]" */;
  input clk;
  input [0:0]probe0;
  input [0:0]probe1;
  input [0:0]probe2;
  input [3:0]probe3;
  input [31:0]probe4;
  input [31:0]probe5;
  input [31:0]probe6;
  input [0:0]probe7;
  input [0:0]probe8;
  input [63:0]probe9;
endmodule
