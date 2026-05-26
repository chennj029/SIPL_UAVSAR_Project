#ifndef _PSU_BRD_H_
#define _PSU_BRD_H_
/***************************** Include Files *********************************/
#include "platform.h"
/*************************** Macro  Definitions ******************************/
/*
 * @PartNumb	INA226AIDGSR
 * @PartFunc	Current and Power Monitor
 * @CommType	IIC
 */
#define INA226_SCL_INDEX 93
#define INA226_SDA_INDEX 94
#define ANALOG_ESW_INDEX 95

#define INA226_SCL  (ZYNQMP_GPIO_BASE + INA226_SCL_INDEX)
#define INA226_SDA  (ZYNQMP_GPIO_BASE + INA226_SDA_INDEX)
#define ANALOG_ESW  (ZYNQMP_GPIO_BASE + ANALOG_ESW_INDEX)
/* INA226 Register Address */
#define ADDR_CFG_REG	0x00	//
#define ADDR_SV_REG		0x01	//Shunt Voltage Register Address
#define ADDR_BV_REG		0x02	//Bus Voltage Register Address
#define ADDR_PWR_REG	0x03	//Power Register Address
#define ADDR_CUR_REG	0x04	//Shunt Current Register Address
#define ADDR_CAL_REG	0x05	//Calibration Register Address.
#define ADDR_ONFF_REG	0x06	//Mask/Enable Register Address
#define ADDR_ALT_REG	0x07	//Alert Register Address
#define ADDR_INA226_ID	0xff	//ID Register Address
#define ADDR_INA226		0x80	//Hardware connection is A0 = 0 and A1 = 0, thus device address = 0x80
/* INA226 Command */
#define INA226_RST      0x8000
/************************** Variable Definitions *****************************/
//INA226 Register Configuration Type Define
typedef enum{
	CONV_AVG_1 = 0x4000,
	CONV_AVG_4 = 0x4200,
	CONV_AVG_16 = 0x4400,
	CONV_AVG_64 = 0x4600,
	CONV_AVG_128 = 0x4800,
	CONV_AVG_256 = 0x4A00,
	CONV_AVG_512 = 0x4C00,
	CONV_AVG_1024 = 0x4E00
}INA226_ConvAvgTimeTypeDef;

typedef enum{
	BUS_VOLT_CONV_TIME_140  = 0x4000,
	BUS_VOLT_CONV_TIME_204  = 0x4040,
	BUS_VOLT_CONV_TIME_332  = 0x4080,
	BUS_VOLT_CONV_TIME_588  = 0x40C0,
	BUS_VOLT_CONV_TIME_1100 = 0x4100,
	BUS_VOLT_CONV_TIME_2116 = 0x4140,
	BUS_VOLT_CONV_TIME_4156 = 0x4180,
	BUS_VOLT_CONV_TIME_8244 = 0x41C0
}INA226_BusVoltConvTimeTypeDef;

typedef enum{
	SHUNT_VOLT_CONV_TIME_140  = 0x4000,
	SHUNT_VOLT_CONV_TIME_204  = 0x4008,
	SHUNT_VOLT_CONV_TIME_332  = 0x4010,
	SHUNT_VOLT_CONV_TIME_588  = 0x4018,
	SHUNT_VOLT_CONV_TIME_1100 = 0x4020,
	SHUNT_VOLT_CONV_TIME_2116 = 0x4028,
	SHUNT_VOLT_CONV_TIME_4156 = 0x4030,
	SHUNT_VOLT_CONV_TIME_8244 = 0x4038
}INA226_ShuntVoltConvTimeTypeDef;

typedef enum{
	MODE_PWRDWN = 0x4000, //Power Down
	MODE_TRVSHT = 0x4001, //Triggered Shunt Voltage
	MODE_TRVBUS = 0x4002, //Triggered Bus Voltage
	MODE_TRVS_B = 0x4003, //Triggered Shunt & Bus Voltage
	MODE_CTN_SHT = 0x4105, //Continuous Shunt Voltage
	MODE_CTN_BUS = 0x4106, //Continuous Bus Voltage
	MODE_CNT_SHT_BUS = 0x4107  //Continuous Shunt & Bus Voltage
}INA226_ModeSettingTypeDef;

typedef struct{
	INA226_ConvAvgTimeTypeDef ConvAvgTime;
	INA226_BusVoltConvTimeTypeDef VBusConvTime;
	INA226_ShuntVoltConvTimeTypeDef VShuntConvTime;
	INA226_ModeSettingTypeDef ModeSetting;
}INA226_ConfigTypeDef;

/******************** Fixed System Parameters ********************/
/*
 * Shunt voltage LSB = 2.5 uV
 * Full scale of reg = 0x7fff
 * Max. shunt voltage = 81.9175 mV
 */
#define SHUNT_VOLT_LSB		2.5f

/*
 * Bus Voltage LSB = 1.25 mV
 * Full scale of register = 0x7fff
 * Max bus voltage is limited to 36 V in hardware (although Max. value is 40.96 V)
 */
#define BUS_VOLT_LSB		1.25f


/*
 * Maximum Expected Current = 1.6384 A
 * CURR_LSB = Maximum Expected Current / 2^15 = 0.05 mA
 */
#define SHUNT_CURR_LSB    0.05f

/*
 * POWER_LSB is internally set to be 25 times the programmed CURR_LSB
 */
#define POWER_LSB   25 * CURR_LSB

/*
 * Calibration Register Calculation
 * R_SHUNT = 0.05 Ω
 * CAL_VALUE = 0.00512 / Current_LSB / R_SHUNT * 1000 = 2048
 * CAL_VALUE can be changed if the measurement result is not precision
 */
#define CAL_VALUE   2048

typedef struct{
	double BusVoltage; //Unit: V
	double ShuntVoltage; //Unit: mV
	double ShuntCurrent; //Unit: A
	double PowerConsumption; //Unit: W
	uint32_t ina226_id;
}INA226_OBJ;

extern INA226_OBJ ina226_data;
/************************** Function Prototypes ******************************/
void PsuBrd_Init(void);
void INA226_PinInit(void);
void INA226_RegInit(void);
void INA226_IICStart(void);
void INA226_IICStop(void);
uint8_t INA226_IICWaitAck(void);
void INA226_IICAck(void);
void INA226_IICNAck(void);
void INA226_IICWriteByte(uint8_t dat);
uint8_t INA226_IICReadByte(uint8_t ack);
void INA226_SetRegPointer(uint8_t slv_addr, uint8_t reg_addr);
void INA226_WriteWord(uint8_t slv_addr, uint8_t reg_addr, uint16_t dat);
uint16_t INA226_ReadWord(uint8_t slv_addr);
void INA226_GetShuntCurrent(uint8_t slv_addr);
void INA226_GetID(uint8_t slv_addr);
uint16_t INA226_GetCalReg(uint8_t slv_addr);
void INA226_GetBusVoltage(uint8_t slv_addr);
void INA226_GetShuntVoltage(uint8_t slv_addr);
void PsuBrd_PowerParamMeas(void);

#endif
