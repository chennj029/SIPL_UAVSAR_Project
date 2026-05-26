vlib work
vlib riviera

vlib riviera/xilinx_vip
vlib riviera/xpm
vlib riviera/axi_infrastructure_v1_1_0
vlib riviera/axi_vip_v1_1_7
vlib riviera/zynq_ultra_ps_e_vip_v1_0_7
vlib riviera/xil_defaultlib
vlib riviera/lib_cdc_v1_0_2
vlib riviera/proc_sys_reset_v5_0_13
vlib riviera/generic_baseblocks_v2_1_0
vlib riviera/axi_register_slice_v2_1_21
vlib riviera/fifo_generator_v13_2_5
vlib riviera/axi_data_fifo_v2_1_20
vlib riviera/axi_crossbar_v2_1_22
vlib riviera/lib_pkg_v1_0_2
vlib riviera/lib_fifo_v1_0_14
vlib riviera/lib_srl_fifo_v1_0_2
vlib riviera/axi_datamover_v5_1_23
vlib riviera/axi_sg_v4_1_13
vlib riviera/axi_dma_v7_1_22
vlib riviera/axis_infrastructure_v1_1_0
vlib riviera/axis_data_fifo_v2_0_3
vlib riviera/axi_protocol_converter_v2_1_21
vlib riviera/axi_clock_converter_v2_1_20
vlib riviera/blk_mem_gen_v8_4_4
vlib riviera/axi_dwidth_converter_v2_1_21

vmap xilinx_vip riviera/xilinx_vip
vmap xpm riviera/xpm
vmap axi_infrastructure_v1_1_0 riviera/axi_infrastructure_v1_1_0
vmap axi_vip_v1_1_7 riviera/axi_vip_v1_1_7
vmap zynq_ultra_ps_e_vip_v1_0_7 riviera/zynq_ultra_ps_e_vip_v1_0_7
vmap xil_defaultlib riviera/xil_defaultlib
vmap lib_cdc_v1_0_2 riviera/lib_cdc_v1_0_2
vmap proc_sys_reset_v5_0_13 riviera/proc_sys_reset_v5_0_13
vmap generic_baseblocks_v2_1_0 riviera/generic_baseblocks_v2_1_0
vmap axi_register_slice_v2_1_21 riviera/axi_register_slice_v2_1_21
vmap fifo_generator_v13_2_5 riviera/fifo_generator_v13_2_5
vmap axi_data_fifo_v2_1_20 riviera/axi_data_fifo_v2_1_20
vmap axi_crossbar_v2_1_22 riviera/axi_crossbar_v2_1_22
vmap lib_pkg_v1_0_2 riviera/lib_pkg_v1_0_2
vmap lib_fifo_v1_0_14 riviera/lib_fifo_v1_0_14
vmap lib_srl_fifo_v1_0_2 riviera/lib_srl_fifo_v1_0_2
vmap axi_datamover_v5_1_23 riviera/axi_datamover_v5_1_23
vmap axi_sg_v4_1_13 riviera/axi_sg_v4_1_13
vmap axi_dma_v7_1_22 riviera/axi_dma_v7_1_22
vmap axis_infrastructure_v1_1_0 riviera/axis_infrastructure_v1_1_0
vmap axis_data_fifo_v2_0_3 riviera/axis_data_fifo_v2_0_3
vmap axi_protocol_converter_v2_1_21 riviera/axi_protocol_converter_v2_1_21
vmap axi_clock_converter_v2_1_20 riviera/axi_clock_converter_v2_1_20
vmap blk_mem_gen_v8_4_4 riviera/blk_mem_gen_v8_4_4
vmap axi_dwidth_converter_v2_1_21 riviera/axi_dwidth_converter_v2_1_21

vlog -work xilinx_vip  -sv2k12 "+incdir+E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/include" \
"E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/hdl/axi_vip_if.sv" \
"E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/hdl/clk_vip_if.sv" \
"E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm  -sv2k12 "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/ec67/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/e257/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8b3d" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8713/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/1b7e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/122e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/b205/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/c968/hdl/verilog" "+incdir+E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/include" \
"E:/Xilinx_vitis2020/Vivado/2020.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"E:/Xilinx_vitis2020/Vivado/2020.1/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"E:/Xilinx_vitis2020/Vivado/2020.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"E:/Xilinx_vitis2020/Vivado/2020.1/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work axi_infrastructure_v1_1_0  -v2k5 "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/ec67/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/e257/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8b3d" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8713/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/1b7e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/122e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/b205/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/c968/hdl/verilog" "+incdir+E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/include" \
"../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_vip_v1_1_7  -sv2k12 "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/ec67/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/e257/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8b3d" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8713/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/1b7e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/122e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/b205/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/c968/hdl/verilog" "+incdir+E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/include" \
"../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/ce6c/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work zynq_ultra_ps_e_vip_v1_0_7  -sv2k12 "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/ec67/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/e257/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8b3d" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8713/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/1b7e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/122e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/b205/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/c968/hdl/verilog" "+incdir+E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/include" \
"../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/e257/hdl/zynq_ultra_ps_e_vip_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/ec67/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/e257/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8b3d" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8713/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/1b7e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/122e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/b205/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/c968/hdl/verilog" "+incdir+E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/include" \
"../../../bd/uav_sar/ip/uav_sar_zynq_ultra_ps_e_0_0/sim/uav_sar_zynq_ultra_ps_e_0_0_vip_wrapper.v" \

vcom -work lib_cdc_v1_0_2 -93 \
"../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work proc_sys_reset_v5_0_13 -93 \
"../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8842/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/uav_sar/ip/uav_sar_proc_sys_reset_0_0/sim/uav_sar_proc_sys_reset_0_0.vhd" \

vlog -work generic_baseblocks_v2_1_0  -v2k5 "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/ec67/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/e257/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8b3d" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8713/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/1b7e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/122e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/b205/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/c968/hdl/verilog" "+incdir+E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/include" \
"../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \

vlog -work axi_register_slice_v2_1_21  -v2k5 "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/ec67/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/e257/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8b3d" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8713/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/1b7e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/122e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/b205/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/c968/hdl/verilog" "+incdir+E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/include" \
"../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/2ef9/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work fifo_generator_v13_2_5  -v2k5 "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/ec67/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/e257/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8b3d" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8713/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/1b7e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/122e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/b205/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/c968/hdl/verilog" "+incdir+E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/include" \
"../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/276e/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_5 -93 \
"../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/276e/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_5  -v2k5 "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/ec67/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/e257/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8b3d" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8713/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/1b7e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/122e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/b205/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/c968/hdl/verilog" "+incdir+E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/include" \
"../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/276e/hdl/fifo_generator_v13_2_rfs.v" \

vlog -work axi_data_fifo_v2_1_20  -v2k5 "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/ec67/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/e257/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8b3d" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8713/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/1b7e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/122e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/b205/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/c968/hdl/verilog" "+incdir+E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/include" \
"../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/47c9/hdl/axi_data_fifo_v2_1_vl_rfs.v" \

vlog -work axi_crossbar_v2_1_22  -v2k5 "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/ec67/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/e257/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8b3d" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8713/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/1b7e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/122e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/b205/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/c968/hdl/verilog" "+incdir+E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/include" \
"../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/b68e/hdl/axi_crossbar_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/ec67/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/e257/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8b3d" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8713/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/1b7e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/122e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/b205/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/c968/hdl/verilog" "+incdir+E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/include" \
"../../../bd/uav_sar/ip/uav_sar_xbar_0/sim/uav_sar_xbar_0.v" \
"../../../bd/uav_sar/ipshared/2577/src/ad9269_sample .v" \
"../../../bd/uav_sar/ipshared/2577/src/clk_div.v" \
"../../../bd/uav_sar/ip/uav_sar_ad9269_sample_ctrl_0_0/sim/uav_sar_ad9269_sample_ctrl_0_0.v" \
"../../../bd/uav_sar/ip/uav_sar_axi_data_fifo_0_0/sim/uav_sar_axi_data_fifo_0_0.v" \

vcom -work lib_pkg_v1_0_2 -93 \
"../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/0513/hdl/lib_pkg_v1_0_rfs.vhd" \

vcom -work lib_fifo_v1_0_14 -93 \
"../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/a5cb/hdl/lib_fifo_v1_0_rfs.vhd" \

vcom -work lib_srl_fifo_v1_0_2 -93 \
"../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/51ce/hdl/lib_srl_fifo_v1_0_rfs.vhd" \

vcom -work axi_datamover_v5_1_23 -93 \
"../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/af86/hdl/axi_datamover_v5_1_vh_rfs.vhd" \

vcom -work axi_sg_v4_1_13 -93 \
"../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/4919/hdl/axi_sg_v4_1_rfs.vhd" \

vcom -work axi_dma_v7_1_22 -93 \
"../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/0fb1/hdl/axi_dma_v7_1_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/uav_sar/ip/uav_sar_axi_dma_0_0/sim/uav_sar_axi_dma_0_0.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/ec67/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/e257/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8b3d" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8713/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/1b7e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/122e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/b205/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/c968/hdl/verilog" "+incdir+E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/include" \
"../../../bd/uav_sar/ip/uav_sar_clk_wiz_0_0/uav_sar_clk_wiz_0_0_clk_wiz.v" \
"../../../bd/uav_sar/ip/uav_sar_clk_wiz_0_0/uav_sar_clk_wiz_0_0.v" \

vcom -work xil_defaultlib -93 \
"../../../bd/uav_sar/ip/uav_sar_util_ds_buf_0_0/util_ds_buf.vhd" \
"../../../bd/uav_sar/ip/uav_sar_util_ds_buf_0_0/sim/uav_sar_util_ds_buf_0_0.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/ec67/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/e257/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8b3d" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8713/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/1b7e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/122e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/b205/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/c968/hdl/verilog" "+incdir+E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/include" \
"../../../bd/uav_sar/ip/uav_sar_xbar_1/sim/uav_sar_xbar_1.v" \

vlog -work axis_infrastructure_v1_1_0  -v2k5 "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/ec67/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/e257/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8b3d" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8713/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/1b7e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/122e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/b205/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/c968/hdl/verilog" "+incdir+E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/include" \
"../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8713/hdl/axis_infrastructure_v1_1_vl_rfs.v" \

vlog -work axis_data_fifo_v2_0_3  -v2k5 "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/ec67/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/e257/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8b3d" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8713/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/1b7e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/122e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/b205/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/c968/hdl/verilog" "+incdir+E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/include" \
"../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/50d0/hdl/axis_data_fifo_v2_0_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/ec67/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/e257/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8b3d" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8713/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/1b7e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/122e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/b205/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/c968/hdl/verilog" "+incdir+E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/include" \
"../../../bd/uav_sar/ip/uav_sar_axis_data_fifo_0_1/sim/uav_sar_axis_data_fifo_0_1.v" \

vcom -work xil_defaultlib -93 \
"../../../bd/uav_sar/ip/uav_sar_axi_dma_0_1/sim/uav_sar_axi_dma_0_1.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/ec67/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/e257/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8b3d" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8713/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/1b7e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/122e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/b205/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/c968/hdl/verilog" "+incdir+E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/include" \
"../../../bd/uav_sar/ip/uav_sar_axi_data_fifo_0_1/sim/uav_sar_axi_data_fifo_0_1.v" \
"../../../bd/uav_sar/ip/uav_sar_uart_uav_data_0_4/src/fifo_generator_0/sim/fifo_generator_0.v" \
"../../../bd/uav_sar/ipshared/f421/hdl/uart_rx.v" \
"../../../bd/uav_sar/ipshared/f421/hdl/uart_uav_data_v1_0_S00_AXI.v" \
"../../../bd/uav_sar/ipshared/f421/hdl/utc_time.v" \
"../../../bd/uav_sar/ipshared/f421/hdl/uart_uav_data_v1_0.v" \
"../../../bd/uav_sar/ip/uav_sar_uart_uav_data_0_4/sim/uav_sar_uart_uav_data_0_4.v" \
"../../../bd/uav_sar/ip/uav_sar_system_ila_1_0/bd_0/sim/bd_9e4d.v" \
"../../../bd/uav_sar/ip/uav_sar_system_ila_1_0/bd_0/ip/ip_0/sim/bd_9e4d_ila_lib_0.v" \
"../../../bd/uav_sar/ip/uav_sar_system_ila_1_0/sim/uav_sar_system_ila_1_0.v" \

vlog -work axi_protocol_converter_v2_1_21  -v2k5 "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/ec67/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/e257/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8b3d" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8713/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/1b7e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/122e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/b205/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/c968/hdl/verilog" "+incdir+E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/include" \
"../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8dfa/hdl/axi_protocol_converter_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/ec67/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/e257/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8b3d" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8713/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/1b7e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/122e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/b205/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/c968/hdl/verilog" "+incdir+E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/include" \
"../../../bd/uav_sar/ip/uav_sar_auto_pc_0/sim/uav_sar_auto_pc_0.v" \

vlog -work axi_clock_converter_v2_1_20  -v2k5 "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/ec67/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/e257/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8b3d" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8713/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/1b7e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/122e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/b205/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/c968/hdl/verilog" "+incdir+E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/include" \
"../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/7589/hdl/axi_clock_converter_v2_1_vl_rfs.v" \

vlog -work blk_mem_gen_v8_4_4  -v2k5 "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/ec67/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/e257/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8b3d" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8713/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/1b7e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/122e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/b205/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/c968/hdl/verilog" "+incdir+E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/include" \
"../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/2985/simulation/blk_mem_gen_v8_4.v" \

vlog -work axi_dwidth_converter_v2_1_21  -v2k5 "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/ec67/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/e257/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8b3d" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8713/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/1b7e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/122e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/b205/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/c968/hdl/verilog" "+incdir+E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/include" \
"../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/07be/hdl/axi_dwidth_converter_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/ec67/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/e257/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8b3d" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8713/hdl" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/1b7e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/122e/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/b205/hdl/verilog" "+incdir+../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/c968/hdl/verilog" "+incdir+E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/include" \
"../../../bd/uav_sar/ip/uav_sar_auto_us_0/sim/uav_sar_auto_us_0.v" \
"../../../bd/uav_sar/ip/uav_sar_auto_ds_0/sim/uav_sar_auto_ds_0.v" \
"../../../bd/uav_sar/ip/uav_sar_auto_ds_1/sim/uav_sar_auto_ds_1.v" \
"../../../bd/uav_sar/ip/uav_sar_auto_ds_2/sim/uav_sar_auto_ds_2.v" \
"../../../bd/uav_sar/ip/uav_sar_auto_us_1/sim/uav_sar_auto_us_1.v" \
"../../../bd/uav_sar/ip/uav_sar_auto_us_2/sim/uav_sar_auto_us_2.v" \
"../../../bd/uav_sar/sim/uav_sar.v" \

vlog -work xil_defaultlib \
"glbl.v"

