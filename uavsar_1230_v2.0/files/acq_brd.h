#ifndef _ACQ_BRD_H_
#define _ACQ_BRD_H_
/***************************** Include Files *********************************/
#include "platform.h"
#include "main.h"
/*************************** Macro  Definitions ******************************/
/*
 * @PartNumb	HMC960LP4E
 * @PartFunc	Variable Gain Amplifier
 * @CommType	SPI
 */
#define HMC960_SCK_INDEX	87
#define HMC960_SDI_INDEX	88
#define HMC960_SEN_INDEX	90

#define HMC960_SCK (ZYNQMP_GPIO_BASE + HMC960_SCK_INDEX)
#define HMC960_SDI (ZYNQMP_GPIO_BASE + HMC960_SDI_INDEX)
#define HMC960_SEN (ZYNQMP_GPIO_BASE + HMC960_SEN_INDEX)

/* @PartNumb	AD9269BCPZ-80
 * @PartFunc	Analog to Digital Converter
 * @CommType	SPI
 */
#define AD9269_SCK_INDEX    87
#define AD9269_DIO_INDEX    88
#define AD9269_CSB_INDEX    89
#define AD9269_PDN_INDEX    91

#define AD9269_SCK (ZYNQMP_GPIO_BASE + AD9269_SCK_INDEX)
#define AD9269_DIO (ZYNQMP_GPIO_BASE + AD9269_DIO_INDEX)
#define AD9269_CSB (ZYNQMP_GPIO_BASE + AD9269_CSB_INDEX)
#define AD9269_PDN (ZYNQMP_GPIO_BASE + AD9269_PDN_INDEX)

#define ADC_DATA_BYTE 2
#define ADC_DATA_BITS 16

/*
 * Acq_Brd SPI Bus
 */
#define SPI_SCK_INDEX   87
#define SPI_SDI_INDEX   88

#define SPI_SCK   (ZYNQMP_GPIO_BASE + SPI_SCK_INDEX)
#define SPI_SDI   (ZYNQMP_GPIO_BASE + SPI_SDI_INDEX)

/*
 * @PartNumb	ADL5205
 * @PartFunc	Variable Gain Amplifier
 * @CommType	SPI
 */
#define ADL5205_SCK_INDEX	87
#define ADL5205_SDI_INDEX	88
#define ADL5205_CSA_INDEX	90
#define ADL5205_CSB_INDEX	91

#define ADL5205_SCK (ZYNQMP_GPIO_BASE + ADL5205_SCK_INDEX)
#define ADL5205_SDI (ZYNQMP_GPIO_BASE + ADL5205_SDI_INDEX)
#define ADL5205_CSA (ZYNQMP_GPIO_BASE + ADL5205_CSA_INDEX)
#define ADL5205_CSB (ZYNQMP_GPIO_BASE + ADL5205_CSB_INDEX)

/* HMC960 Chip Address */
#define HMC960_ADDR 0x06
/* HMC960 Register Definition */
#define HMC960_ReadSpecReg     0x00
#define HMC960_EnableReg       0x01
#define HMC960_SettingReg      0x02
#define HMC960_GainCtrlReg     0x03
/* HMC960 Gain Definitions */
#define GAIN_0dB    0x020	//0_0010_0000
#define GAIN_10dB   0x034	//0_0011_0100
#define GAIN_20dB   0x054	//0_0101_0100
#define GAIN_30dB   0x154	//1_0101_0100
#define GAIN_40dB   0x114	//1_0001_0100
/************************** Variable Definitions *****************************/
typedef enum{
	OPAMP_MIN_BIAS = 0,
	OPAMP_LF_BIAS = 1,
	OPAMP_HF_BIAS = 2,
	OPAMP_MAX_BIAS = 3
}HMC960_OpAmpBaisTypeDef;

typedef enum{
	DRV_MIN_BIAS = 0,
	DRV_RCMD_BIAS = 2,
	DRV_MAX_BIAS = 3
}HMC960_DrvBaisTypeDef;

typedef enum{
	RIN_200OHM = 0,
	RIN_50OHM = 1
}HMC960_RinTypeDef;

typedef enum{
	GAIN_CTRL_PARALLEL = 0,
	GAIN_CTRL_SPI = 1
}HMC960_GainCtrlTypeDef;

typedef enum{
	DECODED_GAIN = 0,
	UNDECODED_GAIN = 1
}HMC960_GainDecodeTypeDef;

typedef enum{
	GAIN_DEGLITCH_ENABLE = 0,
	GAIN_DEGLITCH_DISABLE = 1
}HMC960_GainDeglitchTypeDef;

typedef struct{
	HMC960_OpAmpBaisTypeDef OpAmpBias;
	HMC960_DrvBaisTypeDef DrvBias;
	HMC960_RinTypeDef Rin;
	HMC960_GainCtrlTypeDef GainCtrl;
	HMC960_GainDecodeTypeDef GainDecode;
	HMC960_GainDeglitchTypeDef GainDeglitch;
}HMC960_ConfigTypeDef;
/************************** Function Prototypes ******************************/
/* AD9269BCPZ-80 */
void AD9269_WriteReg(uint16_t RegAddr, uint8_t Data);
uint8_t AD9269_ReadReg(uint16_t RegAddr);
uint8_t AD9269_ReadReg(uint16_t RegAddr);
uint8_t AD9269_DeviceCheck(uint8_t Mode);
void AcqBrd_PinInit(void);
void AD9269_RegInit(void);
void AD9269_ChannelEnable(uint8_t Channel);
/* HMC960LP4E */
void HMC960_WriteReg(uint16_t RegAddr, uint32_t Data);
uint32_t HMC960_ReadReg(uint16_t RegAddr);
void HMC960_ChannelEnable(uint8_t Channel);
void HMC960_SPIGainCtrl(uint8_t Gain_dB);
void HMC960_RegInit(void);

void ADL5205_WriteReg(uint16_t Data);
void ADL5205_ReadReg(void);
void ADL5205_SPIGainCtrl(uint8_t Gain_dB,uint8_t FA);

void AcqBrd_Init(void);

#endif
