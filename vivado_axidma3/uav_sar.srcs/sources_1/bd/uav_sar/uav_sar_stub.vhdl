-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
-- Date        : Tue Dec 30 11:15:17 2025
-- Host        : WIN-DQCLN0PBKKI running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub E:/vivado_axidma3/uav_sar.srcs/sources_1/bd/uav_sar/uav_sar_stub.vhdl
-- Design      : uav_sar
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xczu2cg-sfvc784-1-e
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity uav_sar is
  Port ( 
    EMIO_tri_i : in STD_LOGIC_VECTOR ( 25 downto 0 );
    EMIO_tri_o : out STD_LOGIC_VECTOR ( 25 downto 0 );
    EMIO_tri_t : out STD_LOGIC_VECTOR ( 25 downto 0 );
    adc_clk : in STD_LOGIC_VECTOR ( 0 to 0 );
    adc_data : in STD_LOGIC_VECTOR ( 15 downto 0 );
    ext_trig : in STD_LOGIC;
    led : out STD_LOGIC;
    trig_sel : in STD_LOGIC;
    triggle : out STD_LOGIC;
    uart_rxd : in STD_LOGIC
  );

end uav_sar;

architecture stub of uav_sar is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "EMIO_tri_i[25:0],EMIO_tri_o[25:0],EMIO_tri_t[25:0],adc_clk[0:0],adc_data[15:0],ext_trig,led,trig_sel,triggle,uart_rxd";
begin
end;
