#ifndef _TX_BRD_H_
#define _TX_BRD_H_
/***************************** Include Files *********************************/
#include "platform.h"
/*************************** Macro  Definitions ******************************/
/*
 * @PartNumb	AD9508BCPZ
 * @PartFunc	Clock Distribution
 * @CommType	IIC w/ chip select
 */
#define AD9508_RST_INDEX    82
#define AD9508_SCL_INDEX    83
#define AD9508_SYN_INDEX    84
#define AD9508_SDA_INDEX    85
#define AD9508_RST  (ZYNQMP_GPIO_BASE + AD9508_RST_INDEX)
#define AD9508_SCL  (ZYNQMP_GPIO_BASE + AD9508_SCL_INDEX)
#define AD9508_SYN  (ZYNQMP_GPIO_BASE + AD9508_SYN_INDEX)
#define AD9508_SDA  (ZYNQMP_GPIO_BASE + AD9508_SDA_INDEX)
/*
 * @PartNumb	HMC703LP4E
 * @PartFunc	Phase Detector in PLL (opt001)
 * @CommType	SPI (HMC Mode)
 */
#ifdef USE_PLL_HMC703
#define HMC703_CEN_INDEX    78
#define HMC703_SEN_INDEX    79
#define HMC703_SCK_INDEX    80
#define HMC703_SDI_INDEX    81
#define HMC703_CEN  (ZYNQMP_GPIO_BASE + HMC703_CEN_INDEX)
#define HMC703_SEN  (ZYNQMP_GPIO_BASE + HMC703_SEN_INDEX)
#define HMC703_SCK  (ZYNQMP_GPIO_BASE + HMC703_SCK_INDEX)
#define HMC703_SDI  (ZYNQMP_GPIO_BASE + HMC703_SDI_INDEX)
#endif
/*
 * @PartNumb	LMX2492RTWR
 * @PartFunc	Phase Detector in PLL (opt002)
 * @CommType	SPI
 */
#ifdef USE_PLL_LMX2492
#define LMX2492_CLK_INDEX    78
#define LMX2492_LAT_INDEX    79
#define LMX2492_DIN_INDEX    80
#define LMX2492_MUX_INDEX    81
#define LMX2492_CLK  (ZYNQMP_GPIO_BASE + LMX2492_CLK_INDEX)
#define LMX2492_LAT  (ZYNQMP_GPIO_BASE + LMX2492_LAT_INDEX)
#define LMX2492_DIN  (ZYNQMP_GPIO_BASE + LMX2492_DIN_INDEX)
#define LMX2492_MUX  (ZYNQMP_GPIO_BASE + LMX2492_MUX_INDEX)
#endif
/*
 * @PartNumb	HMC960LP3E
 * @PartFunc	Power Supplies
 * @CommType	Direct control
 */
#define HMC860_ENA_INDEX 	86
#define HMC860_ENA  (ZYNQMP_GPIO_BASE + HMC860_ENA_INDEX)
/************************** Variable Definitions *****************************/
#define AD9508_ADDR 0xD8
/************************** Function Prototypes ******************************/
/* HMC703LP4E */
void HMC703_PinInit(void);
void HMC703_Reset(void);
void HMC703_WriteByte(uint8_t Data);
void HMC703_WriteReg(uint8_t Addr, uint32_t Data);
uint8_t HMC703_ReadByte(void);
uint32_t HMC703_ReadReg(uint8_t Addr);
void HMC703_SpiSendAddr(uint8_t Addr);
void HMC703_RegInit(void);
void HMC703_SetParam(uint32_t StartFreq, uint32_t StopFreq, uint16_t PulseWidth);
/* LMX2492RTWR */
void LMX2492_PinInit(void);
void LMX2492_WriteReg(uint16_t RegAddr, uint8_t Data);
uint8_t LMX2492_ReadReg(uint16_t RegAddr);
void LMX2492_SetFixedFreq(uint32_t Freq);
void LMX2492_SetRampParam(uint32_t StartFreq, uint32_t StopFreq, uint16_t PulseWidth);
/* AD9508BCPZ */
void AD9508_Reset(void);
void AD9508_Sync(void);
void AD9508_PinInit(void);
void AD9508_RegInit(void);
void AD9508_IICStart(void);
void AD9508_IICStop(void);
void AD9508_GpioTest(void);
uint8_t AD9508_IICWaitAck(void);
void AD9508_IICWriteByte(uint8_t Data);
uint32_t AD9508_WriteReg(uint8_t Addr, uint8_t Data);
void AD9508_SetOutputFreq(double SampleRate_MHz);
/* Tx Board Pin and Regiser Initialization */
void TxBrd_Init(void);

#endif

