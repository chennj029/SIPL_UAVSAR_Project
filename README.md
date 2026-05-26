\# SIPL\_UAVSAR\_Project



本仓库用于保存 UAV-SAR 相关研究代码，主要包含多个子工程，用于数据采集、成像算法、实验验证和结果分析等。



\## 项目结构



```text

SIPL\_UAVSAR\_Project/

├── uavsar\_1230\_v2.0/

├── vivado\_axidma3/

├── petalinux\_proj/

└── README.md



\## uavsar\_1230\_v2.0



说明：UAVSAR的Linux C代码。



\##  vivado\_axidma3



说明：FPGA工程，vivado中打开uav\_sar.xpr即可；uav\_sar\_wrapper1.xsa是当前petalinux工程中使用的XSA文件。



\## petalinux\_proj



说明：bsp使用petalinux-create -t project -s <BSP路径>即可复现工程；image为当前可用镜像，导入SD卡即可上板使用。

