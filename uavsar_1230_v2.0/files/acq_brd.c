#include "platform.h"
#include "acq_brd.h"
#include "main.h"
#include <stdio.h>

/**
 * @brief	Initialize pins and registers of chips used in Acq_Brd.
 * @param	void.
 * @return	none.
 */
void AcqBrd_Init(void){
	AcqBrd_PinInit();
}

/**
 * @brief	Initialize pins used by acquisition board (AD9269BCPZ and HMC960LP4E).
 * @param	void.
 * @return	none.
 */
void AcqBrd_PinInit(void){
    ZynqMPGpio_ExportPin(SPI_SCK); //87
    ZynqMPGpio_ExportPin(SPI_SDI); //88
    ZynqMPGpio_ExportPin(AD9269_CSB); //89
	ZynqMPGpio_ExportPin(ADL5205_CSA); // 90
	ZynqMPGpio_ExportPin(ADL5205_CSB); // 91
    // ZynqMPGpio_ExportPin(AD9269_PDN);
	// ZynqMPGpio_ExportPin(AD9269_DIO);
	// ZynqMPGpio_ExportPin(AD9269_SCK);
    // ZynqMPGpio_ExportPin(HMC960_SEN);

    ZynqMPGpio_SetPinDirection(SPI_SCK, GPIO_OUTPUT);
    ZynqMPGpio_SetPinDirection(SPI_SDI, GPIO_OUTPUT);
    ZynqMPGpio_SetPinDirection(AD9269_CSB, GPIO_OUTPUT);
    // ZynqMPGpio_SetPinDirection(AD9269_PDN, GPIO_OUTPUT);
	//ZynqMPGpio_SetPinDirection(AD9269_DIO, GPIO_OUTPUT);
	// ZynqMPGpio_SetPinDirection(AD9269_SCK, GPIO_OUTPUT);
    // ZynqMPGpio_SetPinDirection(HMC960_SEN, GPIO_OUTPUT); 

	ZynqMPGpio_WritePin(SPI_SCK, 0);
	ZynqMPGpio_WritePin(SPI_SDI, 0);
	// ZynqMPGpio_WritePin(AD9269_PDN, 0);
	ZynqMPGpio_WritePin(AD9269_CSB, 1);
	// ZynqMPGpio_WritePin(HMC960_SEN, 1);	

	ZynqMPGpio_SetPinDirection(ADL5205_CSA, GPIO_OUTPUT);
	ZynqMPGpio_SetPinDirection(ADL5205_CSB, GPIO_OUTPUT);
	ZynqMPGpio_WritePin(ADL5205_CSA, 1);
	ZynqMPGpio_WritePin(ADL5205_CSB, 1);

}

/**
 * @brief	Write data to a register for the specified address.
 * @param	RegAddr is the address of register to be written.
 * @param	Data is the 8 bit data to be written to register.
 * @note 	The SPI port should not be active during periods
 * 		 	when the full dynamic performance of the converter is required.
 * @note 	MSB first is the default on power-up.
 * @return	none.
 */
void AD9269_WriteReg(uint16_t RegAddr, uint8_t Data){
	//R / W\  = 0  : write register
	//W[ 1:0] = 00 : transfer one byte
	//A[12:0] = RegAddr
	//D[ 7:0] = Data
	//0000_0000_1111_1111_|1111_1111
	uint32_t DataToWrite =  ((((uint16_t)RegAddr) << 8) & 0xFF00) | Data;
	uint8_t i = 0;

	ZynqMPGpio_SetPinDirection(AD9269_DIO, GPIO_OUTPUT);

	//set SCK to IDEL state
	ZynqMPGpio_WritePin(AD9269_SCK, 0);
	usleep(2);
	//falling edge of CSB
	ZynqMPGpio_WritePin(AD9269_CSB, 1);
	usleep(2);
	ZynqMPGpio_WritePin(AD9269_CSB, 0);
	usleep(2);
	for(i = 0; i < 24; i ++){
		if(DataToWrite & 0x800000){
			ZynqMPGpio_WritePin(AD9269_DIO, 1);
		}
		else{
			ZynqMPGpio_WritePin(AD9269_DIO, 0);
		}
		DataToWrite <<= 1;
		usleep(3);
		ZynqMPGpio_WritePin(AD9269_SCK, 1);
		usleep(10);
		ZynqMPGpio_WritePin(AD9269_SCK, 0);
		usleep(5);
	}
	ZynqMPGpio_WritePin(AD9269_CSB, 1);
	usleep(10);
}

/**
 * @brief	Read one byte data from a register for the specified address.
 * @param	RegAddr is the address of register to be read.
 * @return	8 bits data of the register.
 */
uint8_t AD9269_ReadReg(uint16_t RegAddr){
	uint8_t RecvData = 0;
	//R / W\  = 1  : read register
	//W[ 1:0] = 00 : transfer one byte
	//A[12:0] = RegAddr
	//1001_1111_1111_1111
	uint16_t DataToWrite = 0x8000 | ((uint16_t)RegAddr);
	uint8_t i = 0;

	ZynqMPGpio_SetPinDirection(AD9269_DIO, GPIO_OUTPUT);

	//falling edge of CSB
	ZynqMPGpio_WritePin(AD9269_CSB, 1);
	usleep(5);
	ZynqMPGpio_WritePin(AD9269_CSB, 0);
	usleep(2);
	ZynqMPGpio_WritePin(AD9269_SCK, 0);
	//send command and register address
	for(i = 0; i < 16; i ++){
		if(DataToWrite & 0x8000){
			ZynqMPGpio_WritePin(AD9269_DIO, 1);
		}
		else{
			ZynqMPGpio_WritePin(AD9269_DIO, 0);
		}
		DataToWrite <<= 1;
		usleep(2);
		ZynqMPGpio_WritePin(AD9269_SCK, 1);
		usleep(10);
		ZynqMPGpio_WritePin(AD9269_SCK, 0);
		usleep(5);
	}
	//set SDIO direction as input
	ZynqMPGpio_SetPinDirection(AD9269_DIO, GPIO_INPUT);
	usleep(1);

	//begin to receive data
	for(uint8_t i = 0; i < 8; i ++){
		RecvData <<= 1;
		usleep(5);
		ZynqMPGpio_WritePin(AD9269_SCK, 1);
		if(ZynqMPGpio_ReadPin(AD9269_DIO) != 0){
			RecvData |= 1;
		}
		usleep(5);
		ZynqMPGpio_WritePin(AD9269_SCK, 0);
	}
	ZynqMPGpio_WritePin(AD9269_CSB, 1);

	return RecvData;
}

/**
 * @brief	Check working status of AD9269BCPZ after power on.
 * @param	Gpio is the structure pointer of Zynq's I/O driver instance.
 * @param	mode sets the BIST output data format.
 *
 * @note 	This function can only works properly ONCE after a power on event.
 *			1. check SPI write & read register.
 *			2. run BIST in ADC
 *		    3. disconnect analog input and run digital output test
 * @note 	BIST output data format relates to parameter mode.
 *			0 ---> analog input connect
 *			1 ---> output 0x8000
 *			2 ---> output 0xFFFF
 *			3 ---> output 0x0000
 *			4 ---> output 0xAAAA and 0x5555
 *			7 ---> output 0xFFFF and 0x0000
 *
 *****	In "Transfer Register Map" section of data sheet of AD9269BCPZ	*****
 *			Address 0x08 to Address 0x18 are shadowed. Writes to these addresses
 *			do not affect device operation until a transfer command is issued by
 *			writing 0x01 to Address 0xFF, setting the transfer bit.
 *
 * @return	1 if successful, 0 if failed.
 */
uint8_t AD9269_DeviceCheck(uint8_t mode){
	uint8_t test_data = 0xAA;
	uint8_t chip_id, reg;
	uint8_t BIST_result;

	//check registers read and write
	AD9269_WriteReg(0x19, test_data);
	//transfers data from master to slave synchronously
	AD9269_WriteReg(0xFF, 0x01);

	reg = AD9269_ReadReg(0x19);
	if(reg != test_data){
		printf("r/w register failed, reg = %x\n", reg);
	}

	chip_id = AD9269_ReadReg(0x01);
	if(chip_id != 0x75){
		printf("read chip_id failed, chip_id = %x\n", chip_id);
	}

	reg = AD9269_ReadReg(0x02);
	switch(reg){
		case 0x00:{
			printf("speed grade: 20 MSa/s.\n");
			break;
		}
		case 0x10:{
			printf("speed grade: 40 MSa/s.\n");
			break;
		}
		case 0x20:{
			printf("speed grade: 65 MSa/s.\n");
			break;
		}
		case 0x30:{
			printf("speed grade: 80 MSa/s.\n");
			break;
		}
		default:{
			printf("unknown speed grade: %d.\n", reg);
			break;
		}
	}

	AD9269_WriteReg(0x0E, 0x01); //run built-in self test
	AD9269_WriteReg(0xFF, 0x01); //transfers data from master to slave synchronously
	usleep(100000);

	BIST_result = AD9269_ReadReg(0x24);
	if(BIST_result != 0x01){
		printf("BIST_result = 0x%x\n", BIST_result);
		printf("BIST failed.\n");
	}
	usleep(1000);

	AD9269_WriteReg(0x0D, mode); //run ADC output test
	AD9269_WriteReg(0xFF, 0x01); //transfer data from master to slave
	return 1;
}

/**
 * @brief	Initialize registers of AD9269BCPZ before conversion.
 * @param	void.
 * @return	none.
 */
void AD9269_RegInit(void){
	AD9269_WriteReg(0x00, 0x18); //configure serial interface for MSB first
	AD9269_WriteReg(0x05, 0x03); //set Devices-Index to program ADC Channels 0 & 1

	AD9269_WriteReg(0x08, 0x00); //various generic modes of chip operation
	AD9269_WriteReg(0xFF, 0x01); //transfer data from master to slave
	AD9269_WriteReg(0x09, 0x01); //duty cycle stabilize
	AD9269_WriteReg(0xFF, 0x01); //transfer data from master to slave
//	AD9269_WriteReg(0x0B, 0x01); //clock divide ratio, 0x01 means clock divide by 2
//	AD9269_WriteReg(0xFF, 0x01); //transfer data from master to slave
	AD9269_WriteReg(0x14, 0x80); //output level and data format
	AD9269_WriteReg(0xFF, 0x01); //transfer data from master to slave


	AD9269_WriteReg(0x101, 0x85); //enable OEB, run GCLK and disable DIO pull-down
}

/**
 * @brief	Enable conversion channel of AD9269BCPZ.
 * @param	Channel sets the enabled channel of AD9269BCPZ.
 * @note	Channel is 1 enables channel A of AD9269BCPZ.
 * 					   2 enables channel B of AD9269BCPZ.
 * 					   3 enables channel A and B of AD9269BCPZ.
 * @return	none.
 */
void AD9269_ChannelEnable(uint8_t Channel){
	AD9269_WriteReg(0x05, Channel);
}

/*******************************************************************************/

/**
 * @brief	Write data to a register for the specified address.
 * @param	RegAddr is the 5 bits address of register to be written.
 * @param	Data is the 24 bits data to be written to register.
 * @return	none.
 */
void HMC960_WriteReg(uint16_t RegAddr, uint32_t Data){
	uint32_t DataToWrite = ((uint32_t)Data << 8) | (RegAddr << 3) | HMC960_ADDR;

	ZynqMPGpio_WritePin(HMC960_SEN, 0);
	usleep(10);
	ZynqMPGpio_WritePin(HMC960_SCK, 0);
	usleep(2);
	for(uint8_t i = 0; i < 32; i ++){
		if(DataToWrite & 0x80000000){
			ZynqMPGpio_WritePin(HMC960_SDI, 1);
		}
		else{
			ZynqMPGpio_WritePin(HMC960_SDI, 0);
		}
		DataToWrite <<= 1;
		usleep(2);
		ZynqMPGpio_WritePin(HMC960_SCK, 1);
		usleep(10);
		ZynqMPGpio_WritePin(HMC960_SCK, 0);
		usleep(5);
	}
	ZynqMPGpio_WritePin(HMC960_SEN, 1);
	usleep(10);
	ZynqMPGpio_WritePin(HMC960_SCK, 0);
	usleep(4);
}

/**
 * @brief	Read one byte data from a register for the specified address.
 * @param	RegAddr is the 5 bits address of register to be read.
 * @return	32 bits data of the register if successful, 0 if read failed.
 */
uint32_t HMC960_ReadReg(uint16_t RegAddr){
	uint32_t RecvData = 0;
	uint8_t i = 0;

	//0000_0000_0000_0000_0001_1111|_0000_0|110
	uint32_t DataToWrite = (0x00001F00 & ((uint32_t)RegAddr << 8)) | HMC960_ADDR;
	//pull down SEN
	ZynqMPGpio_WritePin(HMC960_SEN, 0);
	usleep(10);
	ZynqMPGpio_WritePin(HMC960_SCK, 0);
	usleep(2);
	//place data followed by rising edge of SCK
	for(i = 0; i < 32; i ++){
		if(DataToWrite & 0x80000000)
			ZynqMPGpio_WritePin(HMC960_SDI, 1);
		else
			ZynqMPGpio_WritePin(HMC960_SDI, 0);
		DataToWrite <<= 1;
		usleep(5);
		ZynqMPGpio_WritePin(SPI_SCK, 1);
		usleep(10);
		ZynqMPGpio_WritePin(SPI_SCK, 0);
		usleep(2);
	}

	ZynqMPGpio_WritePin(HMC960_SEN, 1);
	usleep(10);
	ZynqMPGpio_WritePin(SPI_SCK, 0);

	usleep(2);
	ZynqMPGpio_WritePin(HMC960_SEN, 0);
	usleep(10);
	ZynqMPGpio_WritePin(HMC960_SCK, 0);
	for(i = 0; i < 32; i ++){
		if(ZynqMPGpio_ReadPin(HMC960_SDI) != 0){
			RecvData |= 1;
		}
		else{
			RecvData |= 0;
		}
		RecvData <<= 1;
		usleep(2);
		ZynqMPGpio_WritePin(HMC960_SCK, 1);
		usleep(2);
		ZynqMPGpio_WritePin(HMC960_SCK, 0);
	}
	usleep(2);
	ZynqMPGpio_WritePin(HMC960_SCK, 0);
	usleep(2);
	ZynqMPGpio_WritePin(HMC960_SEN, 1);
	usleep(10);

	return RecvData;
}

/**
 * @brief	Initialize registers of HMC960LP4E before conversion.
 * @param	void.
 * @return	none.
 */
void HMC960_RegInit(void){
	uint32_t DataToWrite = 0;
	HMC960_ConfigTypeDef HMC960_Cfg;

	//configure these Setting Register value referring to data sheet.
	HMC960_Cfg.OpAmpBias = OPAMP_LF_BIAS;
	HMC960_Cfg.DrvBias = DRV_RCMD_BIAS;
	HMC960_Cfg.Rin = RIN_50OHM;
	HMC960_Cfg.GainCtrl = GAIN_CTRL_SPI;
	// HMC960_Cfg.GainCtrl = GAIN_CTRL_PARALLEL;
	HMC960_Cfg.GainDecode = DECODED_GAIN;
	HMC960_Cfg.GainDeglitch = GAIN_DEGLITCH_DISABLE;

	DataToWrite = (HMC960_Cfg.GainDeglitch << 7) | (HMC960_Cfg.GainDecode << 6) | \
		(HMC960_Cfg.GainCtrl << 5) | (HMC960_Cfg.Rin << 4) | (HMC960_Cfg.DrvBias << 2) | HMC960_Cfg.OpAmpBias;
//	printf("DataToWrite = 0x%x\n", DataToWrite);
	HMC960_WriteReg(HMC960_SettingReg, DataToWrite); //enable SPI gain control
	HMC960_ChannelEnable(0x01 | 0x02); //enable channel I/Q of HMC960LP4E
}

/**
 * @brief	Enable conversion channel of HMC960LP4E.
 * @param	Channel sets the enabled channel of HMC960LP4E.
 * @note	Channel is 1 enables channel I of HMC960LP4E.
 * 					   2 enables channel Q of HMC960LP4E.
 * 					   3 enables channel I and Q of HMC960LP4E.
 * @return	none.
 */
void HMC960_ChannelEnable(uint8_t Channel){
	HMC960_WriteReg(HMC960_EnableReg, Channel);
}

/**
 * @brief	Set channel gain of HMC960LP4E.
 * @param	Gain_dB sets the channel gain of HMC960LP4E.
 * @note	Parameter Gain_dB uses macros GAIN_xdB in acq_brd.h
 * @return	none.
 */
void HMC960_SPIGainCtrl(uint8_t Gain_dB){
	uint32_t VGA_Gain = (uint32_t)Gain_dB;
	//0000_0000_0000_0000_0000_000|0_0111_1111
	VGA_Gain = 0x000007F & (VGA_Gain << 1); //<<1 means x2

	/* write Gain Register 03h to set gain */
	HMC960_WriteReg(HMC960_GainCtrlReg, VGA_Gain);
}

/*******************************************************************************/
/*
 * @brief	Write data to a register for the specified address.
 * @param	Gpio is the structure pointer of Zynq's I/O driver instance.
 * @param	RegAddr is the 5 bits address of register to be written.
 * @param	Data is the 24 bits data to be written to register.
 * @return	void.
 */
void ADL5205_WriteReg(uint16_t Data){
	uint8_t i;

	ZynqMPGpio_WritePin(ADL5205_CSA, 0);
	ZynqMPGpio_WritePin(ADL5205_CSB, 0);
	usleep(10);
	ZynqMPGpio_WritePin(ADL5205_SCK, 0);
	usleep(2);
	for(i = 0; i < 16; i ++){
		if(Data & 0x8000){
			ZynqMPGpio_WritePin(ADL5205_SDI, 1);
		}
		else{
			ZynqMPGpio_WritePin(ADL5205_SDI, 0);
		}
		Data <<= 1;
		usleep(2);
		ZynqMPGpio_WritePin(ADL5205_SCK, 1);
		usleep(10);
		ZynqMPGpio_WritePin(ADL5205_SCK, 0);
		usleep(5);
	}
	ZynqMPGpio_WritePin(ADL5205_CSA, 1);
	ZynqMPGpio_WritePin(ADL5205_CSB, 1);
	usleep(10);
	ZynqMPGpio_WritePin(ADL5205_SCK, 0);
	usleep(4);
}

void ADL5205_SPIGainCtrl(uint8_t Gain_dB,uint8_t FA){
	uint16_t VGA_Gain_Ctrl;
	//5bit GAIN + 2bit FA + 1 bit R/W + 16bit DONT CARE
	Gain_dB=Gain_dB>=26?0x00:(26-Gain_dB);
	FA=FA & 0x03;
	VGA_Gain_Ctrl = 0x00FF & ((Gain_dB) | (FA<<6));
	// printf("VGA_Gain_Ctrl= %x \r\n",VGA_Gain_Ctrl);
	//write Gain Control data
	ADL5205_WriteReg(VGA_Gain_Ctrl);
}

void ADL5205_ReadReg(void){
	uint16_t RecvData,i;
	ADL5205_WriteReg(0x0100);
	usleep(10);
	ZynqMPGpio_WritePin(ADL5205_CSA, 0);

	usleep(10);
	ZynqMPGpio_WritePin(ADL5205_SCK, 0);
	for(i = 0; i < 16; i ++){
		if(ZynqMPGpio_ReadPin(ADL5205_SDI) != 0){
			RecvData |= 1;
		}
		else{
			RecvData |= 0;
		}
		RecvData <<= 1;
		usleep(5);
		ZynqMPGpio_WritePin(ADL5205_SCK, 1);
		usleep(5);
		ZynqMPGpio_WritePin(ADL5205_SCK, 0);

	}
	usleep(5);
	ZynqMPGpio_WritePin(HMC960_SCK, 0);
	usleep(5);
	ZynqMPGpio_WritePin(ADL5205_CSA, 1);
	ZynqMPGpio_WritePin(ADL5205_CSB, 1);
	usleep(10);
	printf("ADL5205_ReadReg= %x \r\n",RecvData);
}
