# SIPL_UAVSAR_Project

本仓库用于保存 UAV-SAR 相关研究代码，主要包含多个子工程，用于数据采集、成像算法、实验验证和结果分析等。

## 项目结构

```text
SIPL_UAVSAR_Project/
├── uavsar_1230_v2.0/
├── vivado_axidma3/
├── petalinux_proj/
└── README.md
```

## uavsar_1230_v2.0

说明：UAVSAR的Linux C代码。

##  vivado_axidma3

说明：FPGA工程，vivado中打开uav_sar.xpr即可；uav_sar_wrapper1.xsa是当前petalinux工程中使用的XSA文件。

## petalinux_proj

说明：bsp使用petalinux-create -t project -s <BSP路径>即可复现工程；image为当前可用镜像，导入SD卡即可上板使用。