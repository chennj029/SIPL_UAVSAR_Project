// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module uav_sar(EMIO_tri_i, EMIO_tri_o, EMIO_tri_t, adc_clk, 
  adc_data, ext_trig, led, trig_sel, triggle);
  input [25:0]EMIO_tri_i;
  output [25:0]EMIO_tri_o;
  output [25:0]EMIO_tri_t;
  input [0:0]adc_clk;
  input [15:0]adc_data;
  input ext_trig;
  output led;
  input trig_sel;
  output triggle;
endmodule
