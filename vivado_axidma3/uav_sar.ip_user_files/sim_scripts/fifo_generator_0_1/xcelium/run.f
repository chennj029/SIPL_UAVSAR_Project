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
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

