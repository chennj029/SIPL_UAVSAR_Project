-makelib xcelium_lib/xilinx_vip -sv \
  "E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
  "E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
  "E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
  "E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
  "E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
  "E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
  "E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/hdl/axi_vip_if.sv" \
  "E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/hdl/clk_vip_if.sv" \
  "E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/hdl/rst_vip_if.sv" \
-endlib
-makelib xcelium_lib/xpm -sv \
  "E:/Xilinx_vitis2020/Vivado/2020.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "E:/Xilinx_vitis2020/Vivado/2020.1/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
  "E:/Xilinx_vitis2020/Vivado/2020.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "E:/Xilinx_vitis2020/Vivado/2020.1/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/axi_infrastructure_v1_1_0 \
  "../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_vip_v1_1_7 -sv \
  "../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/ce6c/hdl/axi_vip_v1_1_vl_rfs.sv" \
-endlib
-makelib xcelium_lib/zynq_ultra_ps_e_vip_v1_0_7 -sv \
  "../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/e257/hdl/zynq_ultra_ps_e_vip_v1_0_vl_rfs.sv" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/uav_sar/ip/uav_sar_zynq_ultra_ps_e_0_0/sim/uav_sar_zynq_ultra_ps_e_0_0_vip_wrapper.v" \
-endlib
-makelib xcelium_lib/lib_cdc_v1_0_2 \
  "../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \
-endlib
-makelib xcelium_lib/proc_sys_reset_v5_0_13 \
  "../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8842/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/uav_sar/ip/uav_sar_proc_sys_reset_0_0/sim/uav_sar_proc_sys_reset_0_0.vhd" \
-endlib
-makelib xcelium_lib/generic_baseblocks_v2_1_0 \
  "../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_register_slice_v2_1_21 \
  "../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/2ef9/hdl/axi_register_slice_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_5 \
  "../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/276e/simulation/fifo_generator_vlog_beh.v" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_5 \
  "../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/276e/hdl/fifo_generator_v13_2_rfs.vhd" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_5 \
  "../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/276e/hdl/fifo_generator_v13_2_rfs.v" \
-endlib
-makelib xcelium_lib/axi_data_fifo_v2_1_20 \
  "../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/47c9/hdl/axi_data_fifo_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_crossbar_v2_1_22 \
  "../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/b68e/hdl/axi_crossbar_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/uav_sar/ip/uav_sar_xbar_0/sim/uav_sar_xbar_0.v" \
  "../../../bd/uav_sar/ipshared/2577/src/ad9269_sample .v" \
  "../../../bd/uav_sar/ipshared/2577/src/clk_div.v" \
  "../../../bd/uav_sar/ip/uav_sar_ad9269_sample_ctrl_0_0/sim/uav_sar_ad9269_sample_ctrl_0_0.v" \
  "../../../bd/uav_sar/ip/uav_sar_axi_data_fifo_0_0/sim/uav_sar_axi_data_fifo_0_0.v" \
-endlib
-makelib xcelium_lib/lib_pkg_v1_0_2 \
  "../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/0513/hdl/lib_pkg_v1_0_rfs.vhd" \
-endlib
-makelib xcelium_lib/lib_fifo_v1_0_14 \
  "../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/a5cb/hdl/lib_fifo_v1_0_rfs.vhd" \
-endlib
-makelib xcelium_lib/lib_srl_fifo_v1_0_2 \
  "../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/51ce/hdl/lib_srl_fifo_v1_0_rfs.vhd" \
-endlib
-makelib xcelium_lib/axi_datamover_v5_1_23 \
  "../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/af86/hdl/axi_datamover_v5_1_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/axi_sg_v4_1_13 \
  "../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/4919/hdl/axi_sg_v4_1_rfs.vhd" \
-endlib
-makelib xcelium_lib/axi_dma_v7_1_22 \
  "../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/0fb1/hdl/axi_dma_v7_1_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/uav_sar/ip/uav_sar_axi_dma_0_0/sim/uav_sar_axi_dma_0_0.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/uav_sar/ip/uav_sar_clk_wiz_0_0/uav_sar_clk_wiz_0_0_clk_wiz.v" \
  "../../../bd/uav_sar/ip/uav_sar_clk_wiz_0_0/uav_sar_clk_wiz_0_0.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/uav_sar/ip/uav_sar_util_ds_buf_0_0/util_ds_buf.vhd" \
  "../../../bd/uav_sar/ip/uav_sar_util_ds_buf_0_0/sim/uav_sar_util_ds_buf_0_0.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/uav_sar/ip/uav_sar_xbar_1/sim/uav_sar_xbar_1.v" \
-endlib
-makelib xcelium_lib/axis_infrastructure_v1_1_0 \
  "../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8713/hdl/axis_infrastructure_v1_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axis_data_fifo_v2_0_3 \
  "../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/50d0/hdl/axis_data_fifo_v2_0_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/uav_sar/ip/uav_sar_axis_data_fifo_0_1/sim/uav_sar_axis_data_fifo_0_1.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/uav_sar/ip/uav_sar_axi_dma_0_1/sim/uav_sar_axi_dma_0_1.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
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
-endlib
-makelib xcelium_lib/axi_protocol_converter_v2_1_21 \
  "../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/8dfa/hdl/axi_protocol_converter_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/uav_sar/ip/uav_sar_auto_pc_0/sim/uav_sar_auto_pc_0.v" \
-endlib
-makelib xcelium_lib/axi_clock_converter_v2_1_20 \
  "../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/7589/hdl/axi_clock_converter_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/blk_mem_gen_v8_4_4 \
  "../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/2985/simulation/blk_mem_gen_v8_4.v" \
-endlib
-makelib xcelium_lib/axi_dwidth_converter_v2_1_21 \
  "../../../../uav_sar.srcs/sources_1/bd/uav_sar/ipshared/07be/hdl/axi_dwidth_converter_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/uav_sar/ip/uav_sar_auto_us_0/sim/uav_sar_auto_us_0.v" \
  "../../../bd/uav_sar/ip/uav_sar_auto_ds_0/sim/uav_sar_auto_ds_0.v" \
  "../../../bd/uav_sar/ip/uav_sar_auto_ds_1/sim/uav_sar_auto_ds_1.v" \
  "../../../bd/uav_sar/ip/uav_sar_auto_ds_2/sim/uav_sar_auto_ds_2.v" \
  "../../../bd/uav_sar/ip/uav_sar_auto_us_1/sim/uav_sar_auto_us_1.v" \
  "../../../bd/uav_sar/ip/uav_sar_auto_us_2/sim/uav_sar_auto_us_2.v" \
  "../../../bd/uav_sar/sim/uav_sar.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

