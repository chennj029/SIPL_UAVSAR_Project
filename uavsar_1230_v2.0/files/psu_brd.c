#include "platform.h"
#include "psu_brd.h"

INA226_OBJ ina226_data;

/**
 * @brief	Initialize Psu_Brd hardward and register of used chips.
 * @return	none.
 */
void PsuBrd_Init(void){
	INA226_PinInit();
	INA226_RegInit();
}

/**
 * @brief	Initialize pins used by INA226 (system power monitor).
 * @return	none.
 */
void INA226_PinInit(void){
	ZynqMPGpio_ExportPin(INA226_SCL);
	ZynqMPGpio_ExportPin(INA226_SDA);
	ZynqMPGpio_ExportPin(ANALOG_ESW);

	ZynqMPGpio_SetPinDirection(INA226_SCL, GPIO_OUTPUT);
	ZynqMPGpio_SetPinDirection(INA226_SDA, GPIO_OUTPUT);
	ZynqMPGpio_SetPinDirection(ANALOG_ESW, GPIO_OUTPUT);

	ZynqMPGpio_WritePin(INA226_SCL, 1);
	ZynqMPGpio_WritePin(INA226_SDA, 1);
	ZynqMPGpio_WritePin(ANALOG_ESW, 1);
}

/**
 * @brief	Initialize pins used by INA226 (system power monitor).
 * @return	none.
 */
void INA226_RegInit(void){
	INA226_ConfigTypeDef INA226_Cfg;

	INA226_Cfg.ConvAvgTime = CONV_AVG_16;
	INA226_Cfg.VBusConvTime = BUS_VOLT_CONV_TIME_332;
	INA226_Cfg.VShuntConvTime = SHUNT_VOLT_CONV_TIME_332;
	INA226_Cfg.ModeSetting = MODE_CNT_SHT_BUS;

	uint16_t DataToWrite = INA226_Cfg.ConvAvgTime | INA226_Cfg.VBusConvTime | INA226_Cfg.VShuntConvTime | INA226_Cfg.ModeSetting;

	INA226_WriteWord(ADDR_INA226, ADDR_CFG_REG, INA226_RST);	//reset chip
	INA226_WriteWord(ADDR_INA226, ADDR_CFG_REG, DataToWrite); //Configure Register 0x00
	INA226_WriteWord(ADDR_INA226, ADDR_CAL_REG, CAL_VALUE);	//set resolution
}

/**
 * @brief	Generate a start condition of IIC bus.
 * @return	none.
 */
void INA226_IICStart(void){
	ZynqMPGpio_SetPinDirection(INA226_SCL, GPIO_OUTPUT);
	ZynqMPGpio_SetPinDirection(INA226_SDA, GPIO_OUTPUT);
	ZynqMPGpio_WritePin(INA226_SCL, 1);
	ZynqMPGpio_WritePin(INA226_SDA, 1);
	usleep(4);	
	ZynqMPGpio_WritePin(INA226_SDA, 0);
	usleep(4);
	ZynqMPGpio_WritePin(INA226_SCL, 0);
	usleep(4);
}

/**
 * @brief	Generate a stop condition of IIC bus.
 * @return	none.
 */
void INA226_IICStop(void){
	ZynqMPGpio_WritePin(INA226_SCL, 1);
	ZynqMPGpio_WritePin(INA226_SDA, 0);
	usleep(4);
	ZynqMPGpio_WritePin(INA226_SDA, 1);
	usleep(4);
}

/**
 * @brief	Waiting for ACK from slave device.
 * @return	1 if failed to receive ACK, 0 if received successfully.
 */
uint8_t INA226_IICWaitAck(void){
	uint8_t ack = 0;

	ZynqMPGpio_SetPinDirection(INA226_SDA, GPIO_INPUT);
	ZynqMPGpio_WritePin(INA226_SCL, 1);
	usleep(4);

	if(ZynqMPGpio_ReadPin(INA226_SDA))
		ack = 1; //nACK
	else
		ack = 0; //ACK
	ZynqMPGpio_WritePin(INA226_SCL, 0);
	usleep(4);
	ZynqMPGpio_SetPinDirection(INA226_SDA, GPIO_OUTPUT);
	return ack;
}

/**
 * @brief	Generate an ACK signal.
 * @return	none.
 */
void INA226_IICAck(void){
	ZynqMPGpio_WritePin(INA226_SCL, 0);
	ZynqMPGpio_SetPinDirection(INA226_SDA, GPIO_OUTPUT);
	ZynqMPGpio_WritePin(INA226_SDA, 0);
	usleep(2);
	ZynqMPGpio_WritePin(INA226_SCL, 1);
	usleep(2);
	ZynqMPGpio_WritePin(INA226_SCL, 0);
}

/**
 * @brief	Generate a NACK signal.
 * @return	none.
 */
void INA226_IICNAck(void){
	ZynqMPGpio_WritePin(INA226_SCL, 0);
	ZynqMPGpio_SetPinDirection(INA226_SDA, GPIO_OUTPUT);
	ZynqMPGpio_WritePin(INA226_SDA, 1);
	usleep(2);
	ZynqMPGpio_WritePin(INA226_SCL, 1);
	usleep(2);
	ZynqMPGpio_WritePin(INA226_SCL, 0);
}

/**
 * @brief	Write one byte data to slave device through IIC bus.
 * @param	dat is the date byte to be write.
 * @return	none.
 */
void INA226_IICWriteByte(uint8_t dat){
	int32_t i;

	ZynqMPGpio_SetPinDirection(INA226_SDA, GPIO_OUTPUT);
  	ZynqMPGpio_WritePin(INA226_SCL, 0);
  	for(i = 0; i < 8; i ++){
		if((dat << i) & 0x80){
			ZynqMPGpio_WritePin(INA226_SDA, 1);
		}
		else{
			ZynqMPGpio_WritePin(INA226_SDA, 0);
		}
		usleep(2);
		ZynqMPGpio_WritePin(INA226_SCL, 1);
		usleep(2);
		ZynqMPGpio_WritePin(INA226_SCL, 0);
		usleep(2);
  }
}

/**
 * @brief	Read one byte data from slave device through IIC bus.
 * @param	ack is the option which returns ACK or NACK after receiving data.
 * @return	recv is the data read from slave device.
 */
uint8_t INA226_IICReadByte(uint8_t ack){
	uint8_t i, recv = 0;

	ZynqMPGpio_SetPinDirection(INA226_SDA, GPIO_INPUT);
	for(i = 0; i < 8; i ++){
		ZynqMPGpio_WritePin(INA226_SCL, 0);
		usleep(2);
		ZynqMPGpio_WritePin(INA226_SCL, 1);
		recv <<= 1;
		if(ZynqMPGpio_ReadPin(INA226_SDA))
			recv ++;
		usleep(2);
	}
	if(!ack)
		INA226_IICNAck();
	else
		INA226_IICAck();
	return recv;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * @brief	Set register pointer.
 * @param	slv_addr is the address of slave device, which is determined by hardware configuration.
 * @param	reg_addr is the address of register on chip.
 * @return	none.
 */
void INA226_SetRegPointer(uint8_t slv_addr, uint8_t reg_addr){
	INA226_IICStart();
	INA226_IICWriteByte(slv_addr);
	INA226_IICWaitAck();
	INA226_IICWriteByte(reg_addr);
	INA226_IICWaitAck();
	INA226_IICStop();
}

/**
 * @brief	Write one word data to aimed register in slave device through IIC bus.
 * @param	slv_addr is the address of slave device, which is determined by hardware configuration.
 * @param	reg_addr is the address of register in chip.
 * @param	dat is the 16 bits data to be write.
 * @return	none.
 */
void INA226_WriteWord(uint8_t slv_addr, uint8_t reg_addr, uint16_t dat){
	uint8_t temp = 0;

	INA226_IICStart();

	INA226_IICWriteByte(slv_addr);
	INA226_IICWaitAck();

	INA226_IICWriteByte(reg_addr);
	INA226_IICWaitAck();

	temp = (uint8_t)(dat >> 8);
	INA226_IICWriteByte(temp);
	INA226_IICWaitAck();

	temp = (uint8_t)(dat & 0x00ff);
	INA226_IICWriteByte(temp);
	INA226_IICWaitAck();

	INA226_IICStop();
}

/**
 * @brief	Read one word data from aimed register in slave device through IIC bus.
 * @param	slv_addr is the address of slave device.
 * @return	recv is the data read from slave device.
 */
uint16_t INA226_ReadWord(uint8_t slv_addr){
	uint16_t recv = 0;

	INA226_IICStart();

	INA226_IICWriteByte(slv_addr + 1); //key word: direction bit, refer to data sheet
	INA226_IICWaitAck();

	recv = INA226_IICReadByte(1);
	recv <<= 8;
	recv |= INA226_IICReadByte(0);

	INA226_IICStop();
	return recv;
}

/**
 * @brief	Read shunt current register in slave device through IIC bus.
 * @param	slv_addr is the address of slave device.
 * @return	none.
 * @note	The resolution of shunt current register is set to be 0.05 mA/bit.
 */
void INA226_GetShuntCurrent(uint8_t slv_addr){
	uint16_t res = 0;

	INA226_SetRegPointer(slv_addr, ADDR_CUR_REG);
	res = INA226_ReadWord(slv_addr);
	if(res & 0x8000)
		res = ~(res - 1);
	ina226_data.ShuntCurrent = res * SHUNT_CURR_LSB * 0.001f;
}

/**
 * @brief	Get ID of INA226 through IIC bus.
 * @param	slv_addr is the address of slave device.
 * @return	none.
 */
void INA226_GetID(uint8_t slv_addr){
	INA226_SetRegPointer(slv_addr, ADDR_INA226_ID);
	ina226_data.ina226_id = INA226_ReadWord(slv_addr);
}

/**
 * @brief	Read calibration register in slave device through IIC bus.
 * @param	slv_addr is the address of slave device.
 * @return	res is the data read from register.
 */
uint16_t INA226_GetCalReg(uint8_t slv_addr){
	uint32_t temp = 0;

	INA226_SetRegPointer(slv_addr, ADDR_CAL_REG);
	temp = INA226_ReadWord(slv_addr);
	return (uint16_t)temp;
}

/**
 * @brief	Read bus voltage register in slave device through IIC bus.
 * @param	slv_addr is the address of slave device.
 * @return	none.
 * @note	The resolution of bus voltage register is fixed 1.25 mV/bit.
 */
void INA226_GetBusVoltage(uint8_t slv_addr){
	uint32_t temp = 0;

	INA226_SetRegPointer(slv_addr, ADDR_BV_REG);
	temp = INA226_ReadWord(slv_addr);
	ina226_data.BusVoltage = temp * BUS_VOLT_LSB * 0.001f;
}

/**
 * @brief	Read bus voltage register in slave device through IIC bus.
 * @param	slv_addr is the address of slave device.
 * @return	res is the data read from register.
 * @note	The resolution of shunt voltage register is fixed 2.5 uV/bit.
 */
void INA226_GetShuntVoltage(uint8_t slv_addr){
	uint16_t temp = 0;
	
	INA226_SetRegPointer(slv_addr, ADDR_SV_REG);
	temp = INA226_ReadWord(slv_addr);
	if(temp & 0x8000)
		temp = ~(temp - 1);
	ina226_data.ShuntVoltage = temp * SHUNT_CURR_LSB * 0.001f;
}

/**
 * @brief	Measure system voltage, current and power consumption.
 * @return	none.
 */
void PsuBrd_PowerParamMeas(void){
	INA226_GetBusVoltage(ADDR_INA226);
	INA226_GetShuntCurrent(ADDR_INA226);
	ina226_data.PowerConsumption = ina226_data.BusVoltage * ina226_data.ShuntCurrent;
	if(ina226_data.ShuntCurrent){ //sometimes the current reading is 0
		printf("\r\n---PsuBoard Power message---\r\n");
		printf("Voltage: %.3f V\n", ina226_data.BusVoltage);
		printf("Current: %.3f A\n", ina226_data.ShuntCurrent);
		printf("Power  : %.3f W\n\n", ina226_data.PowerConsumption);
	}	
}
