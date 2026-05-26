// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
// Date        : Tue Dec 30 11:15:17 2025
// Host        : WIN-DQCLN0PBKKI running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub E:/vivado_axidma3/uav_sar.srcs/sources_1/bd/uav_sar/uav_sar_stub.v
// Design      : uav_sar
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu2cg-sfvc784-1-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module uav_sar(EMIO_tri_i, EMIO_tri_o, EMIO_tri_t, adc_clk, 
  adc_data, ext_trig, led, trig_sel, triggle, uart_rxd)
/* synthesis syn_black_box black_box_pad_pin="EMIO_tri_i[25:0],EMIO_tri_o[25:0],EMIO_tri_t[25:0],adc_clk[0:0],adc_data[15:0],ext_trig,led,trig_sel,triggle,uart_rxd" */;
  input [25:0]EMIO_tri_i;
  output [25:0]EMIO_tri_o;
  output [25:0]EMIO_tri_t;
  input [0:0]adc_clk;
  input [15:0]adc_data;
  input ext_trig;
  output led;
  input trig_sel;
  output triggle;
  input uart_rxd;
endmodule
