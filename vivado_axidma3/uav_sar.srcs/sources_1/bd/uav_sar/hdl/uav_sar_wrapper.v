//Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
//Date        : Tue Dec 30 11:09:27 2025
//Host        : WIN-DQCLN0PBKKI running 64-bit major release  (build 9200)
//Command     : generate_target uav_sar_wrapper.bd
//Design      : uav_sar_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module uav_sar_wrapper
   (EMIO_tri_io,
    adc_clk,
    adc_data,
    ext_trig,
    led,
    trig_sel,
    triggle,
    uart_rxd);
  inout [25:0]EMIO_tri_io;
  input [0:0]adc_clk;
  input [15:0]adc_data;
  input ext_trig;
  output led;
  input trig_sel;
  output triggle;
  input uart_rxd;

  wire [0:0]EMIO_tri_i_0;
  wire [1:1]EMIO_tri_i_1;
  wire [10:10]EMIO_tri_i_10;
  wire [11:11]EMIO_tri_i_11;
  wire [12:12]EMIO_tri_i_12;
  wire [13:13]EMIO_tri_i_13;
  wire [14:14]EMIO_tri_i_14;
  wire [15:15]EMIO_tri_i_15;
  wire [16:16]EMIO_tri_i_16;
  wire [17:17]EMIO_tri_i_17;
  wire [18:18]EMIO_tri_i_18;
  wire [19:19]EMIO_tri_i_19;
  wire [2:2]EMIO_tri_i_2;
  wire [20:20]EMIO_tri_i_20;
  wire [21:21]EMIO_tri_i_21;
  wire [22:22]EMIO_tri_i_22;
  wire [23:23]EMIO_tri_i_23;
  wire [24:24]EMIO_tri_i_24;
  wire [25:25]EMIO_tri_i_25;
  wire [3:3]EMIO_tri_i_3;
  wire [4:4]EMIO_tri_i_4;
  wire [5:5]EMIO_tri_i_5;
  wire [6:6]EMIO_tri_i_6;
  wire [7:7]EMIO_tri_i_7;
  wire [8:8]EMIO_tri_i_8;
  wire [9:9]EMIO_tri_i_9;
  wire [0:0]EMIO_tri_io_0;
  wire [1:1]EMIO_tri_io_1;
  wire [10:10]EMIO_tri_io_10;
  wire [11:11]EMIO_tri_io_11;
  wire [12:12]EMIO_tri_io_12;
  wire [13:13]EMIO_tri_io_13;
  wire [14:14]EMIO_tri_io_14;
  wire [15:15]EMIO_tri_io_15;
  wire [16:16]EMIO_tri_io_16;
  wire [17:17]EMIO_tri_io_17;
  wire [18:18]EMIO_tri_io_18;
  wire [19:19]EMIO_tri_io_19;
  wire [2:2]EMIO_tri_io_2;
  wire [20:20]EMIO_tri_io_20;
  wire [21:21]EMIO_tri_io_21;
  wire [22:22]EMIO_tri_io_22;
  wire [23:23]EMIO_tri_io_23;
  wire [24:24]EMIO_tri_io_24;
  wire [25:25]EMIO_tri_io_25;
  wire [3:3]EMIO_tri_io_3;
  wire [4:4]EMIO_tri_io_4;
  wire [5:5]EMIO_tri_io_5;
  wire [6:6]EMIO_tri_io_6;
  wire [7:7]EMIO_tri_io_7;
  wire [8:8]EMIO_tri_io_8;
  wire [9:9]EMIO_tri_io_9;
  wire [0:0]EMIO_tri_o_0;
  wire [1:1]EMIO_tri_o_1;
  wire [10:10]EMIO_tri_o_10;
  wire [11:11]EMIO_tri_o_11;
  wire [12:12]EMIO_tri_o_12;
  wire [13:13]EMIO_tri_o_13;
  wire [14:14]EMIO_tri_o_14;
  wire [15:15]EMIO_tri_o_15;
  wire [16:16]EMIO_tri_o_16;
  wire [17:17]EMIO_tri_o_17;
  wire [18:18]EMIO_tri_o_18;
  wire [19:19]EMIO_tri_o_19;
  wire [2:2]EMIO_tri_o_2;
  wire [20:20]EMIO_tri_o_20;
  wire [21:21]EMIO_tri_o_21;
  wire [22:22]EMIO_tri_o_22;
  wire [23:23]EMIO_tri_o_23;
  wire [24:24]EMIO_tri_o_24;
  wire [25:25]EMIO_tri_o_25;
  wire [3:3]EMIO_tri_o_3;
  wire [4:4]EMIO_tri_o_4;
  wire [5:5]EMIO_tri_o_5;
  wire [6:6]EMIO_tri_o_6;
  wire [7:7]EMIO_tri_o_7;
  wire [8:8]EMIO_tri_o_8;
  wire [9:9]EMIO_tri_o_9;
  wire [0:0]EMIO_tri_t_0;
  wire [1:1]EMIO_tri_t_1;
  wire [10:10]EMIO_tri_t_10;
  wire [11:11]EMIO_tri_t_11;
  wire [12:12]EMIO_tri_t_12;
  wire [13:13]EMIO_tri_t_13;
  wire [14:14]EMIO_tri_t_14;
  wire [15:15]EMIO_tri_t_15;
  wire [16:16]EMIO_tri_t_16;
  wire [17:17]EMIO_tri_t_17;
  wire [18:18]EMIO_tri_t_18;
  wire [19:19]EMIO_tri_t_19;
  wire [2:2]EMIO_tri_t_2;
  wire [20:20]EMIO_tri_t_20;
  wire [21:21]EMIO_tri_t_21;
  wire [22:22]EMIO_tri_t_22;
  wire [23:23]EMIO_tri_t_23;
  wire [24:24]EMIO_tri_t_24;
  wire [25:25]EMIO_tri_t_25;
  wire [3:3]EMIO_tri_t_3;
  wire [4:4]EMIO_tri_t_4;
  wire [5:5]EMIO_tri_t_5;
  wire [6:6]EMIO_tri_t_6;
  wire [7:7]EMIO_tri_t_7;
  wire [8:8]EMIO_tri_t_8;
  wire [9:9]EMIO_tri_t_9;
  wire [0:0]adc_clk;
  wire [15:0]adc_data;
  wire ext_trig;
  wire led;
  wire trig_sel;
  wire triggle;
  wire uart_rxd;

  IOBUF EMIO_tri_iobuf_0
       (.I(EMIO_tri_o_0),
        .IO(EMIO_tri_io[0]),
        .O(EMIO_tri_i_0),
        .T(EMIO_tri_t_0));
  IOBUF EMIO_tri_iobuf_1
       (.I(EMIO_tri_o_1),
        .IO(EMIO_tri_io[1]),
        .O(EMIO_tri_i_1),
        .T(EMIO_tri_t_1));
  IOBUF EMIO_tri_iobuf_10
       (.I(EMIO_tri_o_10),
        .IO(EMIO_tri_io[10]),
        .O(EMIO_tri_i_10),
        .T(EMIO_tri_t_10));
  IOBUF EMIO_tri_iobuf_11
       (.I(EMIO_tri_o_11),
        .IO(EMIO_tri_io[11]),
        .O(EMIO_tri_i_11),
        .T(EMIO_tri_t_11));
  IOBUF EMIO_tri_iobuf_12
       (.I(EMIO_tri_o_12),
        .IO(EMIO_tri_io[12]),
        .O(EMIO_tri_i_12),
        .T(EMIO_tri_t_12));
  IOBUF EMIO_tri_iobuf_13
       (.I(EMIO_tri_o_13),
        .IO(EMIO_tri_io[13]),
        .O(EMIO_tri_i_13),
        .T(EMIO_tri_t_13));
  IOBUF EMIO_tri_iobuf_14
       (.I(EMIO_tri_o_14),
        .IO(EMIO_tri_io[14]),
        .O(EMIO_tri_i_14),
        .T(EMIO_tri_t_14));
  IOBUF EMIO_tri_iobuf_15
       (.I(EMIO_tri_o_15),
        .IO(EMIO_tri_io[15]),
        .O(EMIO_tri_i_15),
        .T(EMIO_tri_t_15));
  IOBUF EMIO_tri_iobuf_16
       (.I(EMIO_tri_o_16),
        .IO(EMIO_tri_io[16]),
        .O(EMIO_tri_i_16),
        .T(EMIO_tri_t_16));
  IOBUF EMIO_tri_iobuf_17
       (.I(EMIO_tri_o_17),
        .IO(EMIO_tri_io[17]),
        .O(EMIO_tri_i_17),
        .T(EMIO_tri_t_17));
  IOBUF EMIO_tri_iobuf_18
       (.I(EMIO_tri_o_18),
        .IO(EMIO_tri_io[18]),
        .O(EMIO_tri_i_18),
        .T(EMIO_tri_t_18));
  IOBUF EMIO_tri_iobuf_19
       (.I(EMIO_tri_o_19),
        .IO(EMIO_tri_io[19]),
        .O(EMIO_tri_i_19),
        .T(EMIO_tri_t_19));
  IOBUF EMIO_tri_iobuf_2
       (.I(EMIO_tri_o_2),
        .IO(EMIO_tri_io[2]),
        .O(EMIO_tri_i_2),
        .T(EMIO_tri_t_2));
  IOBUF EMIO_tri_iobuf_20
       (.I(EMIO_tri_o_20),
        .IO(EMIO_tri_io[20]),
        .O(EMIO_tri_i_20),
        .T(EMIO_tri_t_20));
  IOBUF EMIO_tri_iobuf_21
       (.I(EMIO_tri_o_21),
        .IO(EMIO_tri_io[21]),
        .O(EMIO_tri_i_21),
        .T(EMIO_tri_t_21));
  IOBUF EMIO_tri_iobuf_22
       (.I(EMIO_tri_o_22),
        .IO(EMIO_tri_io[22]),
        .O(EMIO_tri_i_22),
        .T(EMIO_tri_t_22));
  IOBUF EMIO_tri_iobuf_23
       (.I(EMIO_tri_o_23),
        .IO(EMIO_tri_io[23]),
        .O(EMIO_tri_i_23),
        .T(EMIO_tri_t_23));
  IOBUF EMIO_tri_iobuf_24
       (.I(EMIO_tri_o_24),
        .IO(EMIO_tri_io[24]),
        .O(EMIO_tri_i_24),
        .T(EMIO_tri_t_24));
  IOBUF EMIO_tri_iobuf_25
       (.I(EMIO_tri_o_25),
        .IO(EMIO_tri_io[25]),
        .O(EMIO_tri_i_25),
        .T(EMIO_tri_t_25));
  IOBUF EMIO_tri_iobuf_3
       (.I(EMIO_tri_o_3),
        .IO(EMIO_tri_io[3]),
        .O(EMIO_tri_i_3),
        .T(EMIO_tri_t_3));
  IOBUF EMIO_tri_iobuf_4
       (.I(EMIO_tri_o_4),
        .IO(EMIO_tri_io[4]),
        .O(EMIO_tri_i_4),
        .T(EMIO_tri_t_4));
  IOBUF EMIO_tri_iobuf_5
       (.I(EMIO_tri_o_5),
        .IO(EMIO_tri_io[5]),
        .O(EMIO_tri_i_5),
        .T(EMIO_tri_t_5));
  IOBUF EMIO_tri_iobuf_6
       (.I(EMIO_tri_o_6),
        .IO(EMIO_tri_io[6]),
        .O(EMIO_tri_i_6),
        .T(EMIO_tri_t_6));
  IOBUF EMIO_tri_iobuf_7
       (.I(EMIO_tri_o_7),
        .IO(EMIO_tri_io[7]),
        .O(EMIO_tri_i_7),
        .T(EMIO_tri_t_7));
  IOBUF EMIO_tri_iobuf_8
       (.I(EMIO_tri_o_8),
        .IO(EMIO_tri_io[8]),
        .O(EMIO_tri_i_8),
        .T(EMIO_tri_t_8));
  IOBUF EMIO_tri_iobuf_9
       (.I(EMIO_tri_o_9),
        .IO(EMIO_tri_io[9]),
        .O(EMIO_tri_i_9),
        .T(EMIO_tri_t_9));
  uav_sar uav_sar_i
       (.EMIO_tri_i({EMIO_tri_i_25,EMIO_tri_i_24,EMIO_tri_i_23,EMIO_tri_i_22,EMIO_tri_i_21,EMIO_tri_i_20,EMIO_tri_i_19,EMIO_tri_i_18,EMIO_tri_i_17,EMIO_tri_i_16,EMIO_tri_i_15,EMIO_tri_i_14,EMIO_tri_i_13,EMIO_tri_i_12,EMIO_tri_i_11,EMIO_tri_i_10,EMIO_tri_i_9,EMIO_tri_i_8,EMIO_tri_i_7,EMIO_tri_i_6,EMIO_tri_i_5,EMIO_tri_i_4,EMIO_tri_i_3,EMIO_tri_i_2,EMIO_tri_i_1,EMIO_tri_i_0}),
        .EMIO_tri_o({EMIO_tri_o_25,EMIO_tri_o_24,EMIO_tri_o_23,EMIO_tri_o_22,EMIO_tri_o_21,EMIO_tri_o_20,EMIO_tri_o_19,EMIO_tri_o_18,EMIO_tri_o_17,EMIO_tri_o_16,EMIO_tri_o_15,EMIO_tri_o_14,EMIO_tri_o_13,EMIO_tri_o_12,EMIO_tri_o_11,EMIO_tri_o_10,EMIO_tri_o_9,EMIO_tri_o_8,EMIO_tri_o_7,EMIO_tri_o_6,EMIO_tri_o_5,EMIO_tri_o_4,EMIO_tri_o_3,EMIO_tri_o_2,EMIO_tri_o_1,EMIO_tri_o_0}),
        .EMIO_tri_t({EMIO_tri_t_25,EMIO_tri_t_24,EMIO_tri_t_23,EMIO_tri_t_22,EMIO_tri_t_21,EMIO_tri_t_20,EMIO_tri_t_19,EMIO_tri_t_18,EMIO_tri_t_17,EMIO_tri_t_16,EMIO_tri_t_15,EMIO_tri_t_14,EMIO_tri_t_13,EMIO_tri_t_12,EMIO_tri_t_11,EMIO_tri_t_10,EMIO_tri_t_9,EMIO_tri_t_8,EMIO_tri_t_7,EMIO_tri_t_6,EMIO_tri_t_5,EMIO_tri_t_4,EMIO_tri_t_3,EMIO_tri_t_2,EMIO_tri_t_1,EMIO_tri_t_0}),
        .adc_clk(adc_clk),
        .adc_data(adc_data),
        .ext_trig(ext_trig),
        .led(led),
        .trig_sel(trig_sel),
        .triggle(triggle),
        .uart_rxd(uart_rxd));
endmodule
