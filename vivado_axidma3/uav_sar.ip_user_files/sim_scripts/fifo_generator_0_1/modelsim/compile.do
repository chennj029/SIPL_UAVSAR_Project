vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xilinx_vip
vlib modelsim_lib/msim/xpm
vlib modelsim_lib/msim/xil_defaultlib

vmap xilinx_vip modelsim_lib/msim/xilinx_vip
vmap xpm modelsim_lib/msim/xpm
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xilinx_vip  -incr -sv -L axi_vip_v1_1_7 -L zynq_ultra_ps_e_vip_v1_0_7 -L xilinx_vip "+incdir+E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/include" \
"E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/hdl/axi_vip_if.sv" \
"E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/hdl/clk_vip_if.sv" \
"E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm  -incr -sv -L axi_vip_v1_1_7 -L zynq_ultra_ps_e_vip_v1_0_7 -L xilinx_vip "+incdir+E:/Xilinx_vitis2020/Vivado/2020.1/data/xilinx_vip/include" \
"E:/Xilinx_vitis2020/Vivado/2020.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"E:/Xilinx_vitis2020/Vivado/2020.1/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"E:/Xilinx_vitis2020/Vivado/2020.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm  -93 \
"E:/Xilinx_vitis2020/Vivado/2020.1/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

