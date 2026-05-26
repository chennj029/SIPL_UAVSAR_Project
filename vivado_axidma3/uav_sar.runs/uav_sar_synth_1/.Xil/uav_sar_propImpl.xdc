set_property SRC_FILE_INFO {cfile:e:/vivado_axidma3/uav_sar.srcs/sources_1/bd/uav_sar/ip/uav_sar_axi_dma_0_0/uav_sar_axi_dma_0_0.xdc rfile:../../../uav_sar.srcs/sources_1/bd/uav_sar/ip/uav_sar_axi_dma_0_0/uav_sar_axi_dma_0_0.xdc id:1 order:EARLY scoped_inst:zynq_ultra_pl/axi_dma/U0} [current_design]
set_property SRC_FILE_INFO {cfile:e:/vivado_axidma3/uav_sar.srcs/sources_1/bd/uav_sar/ip/uav_sar_clk_wiz_0_0/uav_sar_clk_wiz_0_0.xdc rfile:../../../uav_sar.srcs/sources_1/bd/uav_sar/ip/uav_sar_clk_wiz_0_0/uav_sar_clk_wiz_0_0.xdc id:2 order:EARLY scoped_inst:zynq_ultra_pl/clk_wiz/inst} [current_design]
set_property SRC_FILE_INFO {cfile:e:/vivado_axidma3/uav_sar.srcs/sources_1/bd/uav_sar/ip/uav_sar_axi_dma_0_1/uav_sar_axi_dma_0_1.xdc rfile:../../../uav_sar.srcs/sources_1/bd/uav_sar/ip/uav_sar_axi_dma_0_1/uav_sar_axi_dma_0_1.xdc id:3 order:EARLY scoped_inst:zynq_ultra_pl/axi_dma_0/U0} [current_design]
set_property SRC_FILE_INFO {cfile:E:/Xilinx_vitis2020/Vivado/2020.1/data/ip/xpm/xpm_cdc/tcl/xpm_cdc_gray.tcl rfile:../../../../Xilinx_vitis2020/Vivado/2020.1/data/ip/xpm/xpm_cdc/tcl/xpm_cdc_gray.tcl id:4 order:LATE scoped_inst:zynq_ultra_pl/ad9269_sample_ctrl/inst/ad9269_sample_v1_0_S00_AXI_inst/sample_inst/xpm_fifo_async_inst/gnuram_async_fifo.xpm_fifo_base_inst/gen_cdc_pntr.rd_pntr_cdc_inst unmanaged:yes} [current_design]
set_property SRC_FILE_INFO {cfile:E:/Xilinx_vitis2020/Vivado/2020.1/data/ip/xpm/xpm_cdc/tcl/xpm_cdc_gray.tcl rfile:../../../../Xilinx_vitis2020/Vivado/2020.1/data/ip/xpm/xpm_cdc/tcl/xpm_cdc_gray.tcl id:5 order:LATE scoped_inst:zynq_ultra_pl/ad9269_sample_ctrl/inst/ad9269_sample_v1_0_S00_AXI_inst/sample_inst/xpm_fifo_async_inst/gnuram_async_fifo.xpm_fifo_base_inst/gen_cdc_pntr.wr_pntr_cdc_inst unmanaged:yes} [current_design]
set_property SRC_FILE_INFO {cfile:E:/Xilinx_vitis2020/Vivado/2020.1/data/ip/xpm/xpm_cdc/tcl/xpm_cdc_gray.tcl rfile:../../../../Xilinx_vitis2020/Vivado/2020.1/data/ip/xpm/xpm_cdc/tcl/xpm_cdc_gray.tcl id:6 order:LATE scoped_inst:zynq_ultra_pl/ad9269_sample_ctrl/inst/ad9269_sample_v1_0_S00_AXI_inst/sample_inst/xpm_fifo_async_inst/gnuram_async_fifo.xpm_fifo_base_inst/gen_cdc_pntr.rd_pntr_cdc_dc_inst unmanaged:yes} [current_design]
set_property SRC_FILE_INFO {cfile:E:/Xilinx_vitis2020/Vivado/2020.1/data/ip/xpm/xpm_cdc/tcl/xpm_cdc_gray.tcl rfile:../../../../Xilinx_vitis2020/Vivado/2020.1/data/ip/xpm/xpm_cdc/tcl/xpm_cdc_gray.tcl id:7 order:LATE scoped_inst:zynq_ultra_pl/ad9269_sample_ctrl/inst/ad9269_sample_v1_0_S00_AXI_inst/sample_inst/xpm_fifo_async_inst/gnuram_async_fifo.xpm_fifo_base_inst/gen_cdc_pntr.wr_pntr_cdc_dc_inst unmanaged:yes} [current_design]
current_instance zynq_ultra_pl/axi_dma/U0
set_property src_info {type:SCOPED_XDC file:1 line:52 export:INPUT save:INPUT read:READ} [current_design]
create_waiver -internal -scope -type CDC -id {CDC-1} -user "axi_dma" -tags "9601" -desc "The CDC-1 warning is waived as it is safe in the context of AXI DMA. The Address and Data value does not change until AXI transaction is complete." -to [get_pins -hier -quiet -filter {NAME =~*I_AXI_DMA_REG_MODULE/GEN_AXI_LITE_IF.AXI_LITE_IF_I/GEN_ASYNC_WRITE.REG_WADDR_TO_IPCLK/GENERATE_LEVEL_P_S_CDC.MULTI_BIT.FOR_IN_cdc_to[*].CROSS2_PLEVEL_IN2SCNDRY_IN_cdc_to/D}]
set_property src_info {type:SCOPED_XDC file:1 line:56 export:INPUT save:INPUT read:READ} [current_design]
create_waiver -internal -scope -type CDC -id {CDC-1} -user "axi_dma" -tags "9601" -desc "The CDC-1 warning is waived as it is safe in the context of AXI DMA. The Address and Data value does not change until AXI transaction is complete." -to [get_pins -hier -quiet -filter {NAME =~*I_AXI_DMA_REG_MODULE/GEN_AXI_LITE_IF.AXI_LITE_IF_I/GEN_ASYNC_WRITE.REG_WADDR_TO_IPCLK1/GENERATE_LEVEL_P_S_CDC.MULTI_BIT.FOR_IN_cdc_to[*].CROSS2_PLEVEL_IN2SCNDRY_IN_cdc_to/D}]
set_property src_info {type:SCOPED_XDC file:1 line:61 export:INPUT save:INPUT read:READ} [current_design]
create_waiver -internal -scope -type CDC -id {CDC-1} -user "axi_dma" -tags "9601" -desc "The CDC-1 warning is waived as it is safe in the context of AXI DMA. In multi channel mode, it is safe to ignore this." -from [get_pins -hier -quiet -filter {NAME =~*MM2S_SPLIT.I_COMMAND_MM2S_SPLITTER/vsize_data_int_reg[*]/C}]
current_instance
current_instance zynq_ultra_pl/clk_wiz/inst
set_property src_info {type:SCOPED_XDC file:2 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk_in1]] 0.1
current_instance
current_instance zynq_ultra_pl/axi_dma_0/U0
set_property src_info {type:SCOPED_XDC file:3 line:52 export:INPUT save:INPUT read:READ} [current_design]
create_waiver -internal -scope -type CDC -id {CDC-1} -user "axi_dma" -tags "9601" -desc "The CDC-1 warning is waived as it is safe in the context of AXI DMA. The Address and Data value does not change until AXI transaction is complete." -to [get_pins -hier -quiet -filter {NAME =~*I_AXI_DMA_REG_MODULE/GEN_AXI_LITE_IF.AXI_LITE_IF_I/GEN_ASYNC_WRITE.REG_WADDR_TO_IPCLK/GENERATE_LEVEL_P_S_CDC.MULTI_BIT.FOR_IN_cdc_to[*].CROSS2_PLEVEL_IN2SCNDRY_IN_cdc_to/D}]
set_property src_info {type:SCOPED_XDC file:3 line:56 export:INPUT save:INPUT read:READ} [current_design]
create_waiver -internal -scope -type CDC -id {CDC-1} -user "axi_dma" -tags "9601" -desc "The CDC-1 warning is waived as it is safe in the context of AXI DMA. The Address and Data value does not change until AXI transaction is complete." -to [get_pins -hier -quiet -filter {NAME =~*I_AXI_DMA_REG_MODULE/GEN_AXI_LITE_IF.AXI_LITE_IF_I/GEN_ASYNC_WRITE.REG_WADDR_TO_IPCLK1/GENERATE_LEVEL_P_S_CDC.MULTI_BIT.FOR_IN_cdc_to[*].CROSS2_PLEVEL_IN2SCNDRY_IN_cdc_to/D}]
set_property src_info {type:SCOPED_XDC file:3 line:61 export:INPUT save:INPUT read:READ} [current_design]
create_waiver -internal -scope -type CDC -id {CDC-1} -user "axi_dma" -tags "9601" -desc "The CDC-1 warning is waived as it is safe in the context of AXI DMA. In multi channel mode, it is safe to ignore this." -from [get_pins -hier -quiet -filter {NAME =~*MM2S_SPLIT.I_COMMAND_MM2S_SPLITTER/vsize_data_int_reg[*]/C}]
current_instance
current_instance zynq_ultra_pl/ad9269_sample_ctrl/inst/ad9269_sample_v1_0_S00_AXI_inst/sample_inst/xpm_fifo_async_inst/gnuram_async_fifo.xpm_fifo_base_inst/gen_cdc_pntr.rd_pntr_cdc_inst
set_property src_info {type:SCOPED_XDC file:4 line:23 export:INPUT save:NONE read:READ} [current_design]
create_waiver -internal -scoped -type CDC -id {CDC-6} -user "xpm_cdc" -tags "1009444" -desc "The CDC-6 warning is waived as it is safe in the context of XPM_CDC_GRAY." -from [get_pins -quiet {src_gray_ff_reg*/C}] -to [get_pins -quiet {dest_graysync_ff_reg*/D}]
current_instance
current_instance zynq_ultra_pl/ad9269_sample_ctrl/inst/ad9269_sample_v1_0_S00_AXI_inst/sample_inst/xpm_fifo_async_inst/gnuram_async_fifo.xpm_fifo_base_inst/gen_cdc_pntr.wr_pntr_cdc_inst
set_property src_info {type:SCOPED_XDC file:5 line:23 export:INPUT save:NONE read:READ} [current_design]
create_waiver -internal -scoped -type CDC -id {CDC-6} -user "xpm_cdc" -tags "1009444" -desc "The CDC-6 warning is waived as it is safe in the context of XPM_CDC_GRAY." -from [get_pins -quiet {src_gray_ff_reg*/C}] -to [get_pins -quiet {dest_graysync_ff_reg*/D}]
current_instance
current_instance zynq_ultra_pl/ad9269_sample_ctrl/inst/ad9269_sample_v1_0_S00_AXI_inst/sample_inst/xpm_fifo_async_inst/gnuram_async_fifo.xpm_fifo_base_inst/gen_cdc_pntr.rd_pntr_cdc_dc_inst
set_property src_info {type:SCOPED_XDC file:6 line:23 export:INPUT save:NONE read:READ} [current_design]
create_waiver -internal -scoped -type CDC -id {CDC-6} -user "xpm_cdc" -tags "1009444" -desc "The CDC-6 warning is waived as it is safe in the context of XPM_CDC_GRAY." -from [get_pins -quiet {src_gray_ff_reg*/C}] -to [get_pins -quiet {dest_graysync_ff_reg*/D}]
current_instance
current_instance zynq_ultra_pl/ad9269_sample_ctrl/inst/ad9269_sample_v1_0_S00_AXI_inst/sample_inst/xpm_fifo_async_inst/gnuram_async_fifo.xpm_fifo_base_inst/gen_cdc_pntr.wr_pntr_cdc_dc_inst
set_property src_info {type:SCOPED_XDC file:7 line:23 export:INPUT save:NONE read:READ} [current_design]
create_waiver -internal -scoped -type CDC -id {CDC-6} -user "xpm_cdc" -tags "1009444" -desc "The CDC-6 warning is waived as it is safe in the context of XPM_CDC_GRAY." -from [get_pins -quiet {src_gray_ff_reg*/C}] -to [get_pins -quiet {dest_graysync_ff_reg*/D}]
