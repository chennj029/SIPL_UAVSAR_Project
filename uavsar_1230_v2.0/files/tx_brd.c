#include "platform.h"
#include "base_brd.h"
#include "tx_brd.h"
#include "math.h"
#include "main.h"
#include <math.h>

#define USE_AD9508_OUT2
// #define LMX2492_DEBUG
#define USE_PLL_LMX2492

/**
 * @brief	Initialize pins and registers of chips used in Tx_Brd.
 * @param	void.
 * @return	none.
 */
void TxBrd_Init(void){
	AD9508_PinInit();
	//AD9508_Reset();
	//AD9508_RegInit();
	#ifdef USE_PLL_HMC703
		HMC703_PinInit();
		usleep(10000); //delay 10ms
		HMC703_Reset();
		HMC703_RegInit();
	#endif
	#ifdef USE_PLL_LMX2492
		LMX2492_PinInit();
	#endif	
}

#ifdef USE_PLL_HMC703
/**
 * @brief	Initialize pins used by HMC703LP4E.
 * @param	void.
 * @return	none.
 */
void HMC703_PinInit(void){
    ZynqMPGpio_ExportPin(HMC703_CEN);
	ZynqMPGpio_ExportPin(HMC860_ENA);
	ZynqMPGpio_ExportPin(HMC703_SCK);
	ZynqMPGpio_ExportPin(HMC703_SDI);
	ZynqMPGpio_ExportPin(HMC703_SEN);
	
	ZynqMPGpio_SetPinDirection(HMC703_CEN, GPIO_OUTPUT);
	ZynqMPGpio_SetPinDirection(HMC860_ENA, GPIO_OUTPUT);
	ZynqMPGpio_SetPinDirection(HMC703_SCK, GPIO_OUTPUT);
	ZynqMPGpio_SetPinDirection(HMC703_SDI, GPIO_OUTPUT);
	ZynqMPGpio_SetPinDirection(HMC703_SEN, GPIO_OUTPUT);
	
	ZynqMPGpio_WritePin(HMC703_SEN, 0);
}

/**
 * @brief	Reset HMC703 to ensure enter HMC Mode.
 * @param	void.
 * @return	none.
 */
void HMC703_Reset(void){
	ZynqMPGpio_WritePin(HMC860_ENA, 0);
	ZynqMPGpio_WritePin(HMC703_CEN, 0);
	usleep(20000);

	ZynqMPGpio_WritePin(HMC860_ENA, 1);
	usleep(10000);
	ZynqMPGpio_WritePin(HMC703_CEN, 1);
	usleep(100000);
	ZynqMPGpio_WritePin(HMC703_SEN, 1);
	usleep(10000);
	ZynqMPGpio_WritePin(HMC703_SEN, 0);
}

/**
 * @brief	Write one byte data to HMC703LP4E.
 * @param	Data is the 8 bits data to be written.
 * @return	none.
 */
void HMC703_WriteByte(uint8_t Data){
	uint8_t i;
	ZynqMPGpio_WritePin(HMC703_SDI, 0);
	for(i = 0; i < 8; i ++){
		if(Data & 0x80){
			ZynqMPGpio_WritePin(HMC703_SDI, 1);
		}
		else{
			ZynqMPGpio_WritePin(HMC703_SDI, 0);
		}
		Data <<= 1;
		usleep(5);
		ZynqMPGpio_WritePin(HMC703_SCK, 1);
		usleep(4);
		ZynqMPGpio_WritePin(HMC703_SCK, 0);
	}
	ZynqMPGpio_WritePin(HMC703_SDI, 0);
}

/**
 * @brief	Write one byte data to specified register of HMC703LP4E.
 * @param	Addr is the 8 bits address of register.
 * @param	Data is the 32 bits data to be written.
 * @return	none.
 */
void HMC703_WriteReg(uint8_t Addr, uint32_t Data){
	ZynqMPGpio_WritePin(HMC703_SCK, 0);
	ZynqMPGpio_WritePin(HMC703_SEN, 1);
	HMC703_SpiSendAddr(Addr << 1);
	HMC703_WriteByte((Data >> 16) & 0xFF);
	HMC703_WriteByte((Data >> 8) & 0xFF);
	HMC703_WriteByte(Data & 0xFF);
	ZynqMPGpio_WritePin(HMC703_SEN, 0);
}

/**
 * @brief	Read one byte from HMC703.
 * @param	void.
 * @return	The 8 bit data read from HMC703LP4E.
 */
// uint8_t HMC703_ReadByte(void){
// 	uint8_t data = 0;
// 	uint8_t i = 0;
// 	ZynqMPGpio_WritePin(HMC703_SCK, 0);
// 	for (i = 0; i < 8; i++){
// 		usleep(1);
// 		data <<= 1;
// 		usleep(5);
// 		ZynqMPGpio_WritePin(HMC703_SCK, 1);
// 		usleep(4);
// 		if (ZynqMPGpio_ReadPin(HMC703_SDO)){
// 			data |= 0x01;
// 		}
// 		usleep(1);
// 		ZynqMPGpio_WritePin(HMC703_SCK, 0);
// 	}
// 	return data;
// }

/**
 * @brief	Transfer the specified register address to HMC703LP4E.
 * @param	Addr is the 8 bits address of register.
 * @return	none.
 */
void HMC703_SpiSendAddr(uint8_t Addr){
	uint8_t i = 0;
	ZynqMPGpio_WritePin(HMC703_SDI, 0);
	for (i = 0; i < 7; i++){
		if (Addr & 0x80)
			ZynqMPGpio_WritePin(HMC703_SDI, 1);
		else
			ZynqMPGpio_WritePin(HMC703_SDI, 0);
		Addr <<= 1;
		usleep(5);
		ZynqMPGpio_WritePin(HMC703_SCK, 1);
		usleep(4);
		ZynqMPGpio_WritePin(HMC703_SCK, 0);
	}
	ZynqMPGpio_WritePin(HMC703_SDI, 0);
}

/**
 * @brief	Read one byte from HMC703 register.
 * @param	Addr is the address of register ti be read.
 * @return	The 32 bit data read from specified register.
 */
// uint32_t HMC703_ReadReg(uint8_t Addr){
// 	int i;
// 	uint8_t tmp;
// 	uint32_t recv_data = 0;
// 	uint8_t tmp_addr = (Addr << 1) | 0x80;

// 	ZynqMPGpio_WritePin(HMC703_SEN, 1);
// 	ZynqMPGpio_WritePin(HMC703_SCK, 0);
// 	HMC703_SpiSendAddr(tmp_addr);
// 	usleep(2);
// 	for(i = 0; i < 3; i ++){
// 		tmp = HMC703_ReadByte();
// 		recv_data |= tmp << 8 * (2 - i);
// 	}
// 	ZynqMPGpio_WritePin(HMC703_SEN, 0);
// 	return recv_data;
// }

/**
 * @brief	Configure HMC703LP4E registers.
 * @param	void.
 * @return	none.
 */
void HMC703_RegInit(void){
	uint8_t Addr, RegNum;
	uint32_t reg_val[] = {
		// 0x097370,  // Reg 00h, Chip ID, read only
		0x000020,  // Reg 00h, Chip ID, read only
		0x000002,  // Reg 01h, master Enable from the SPI
		0x000001,  // Reg 02h, Reference Divider ’R’ Value = 1
		0x000032,  // Reg 03h, The integer portion of the prescaler divide ratio
		0x000000,  // Reg 04h, VCO Divider Fractional part (24 bit unsigned)
		0xDEADBE,  // Reg 05h, The initial starting point for the fractional modulator at the “Trigger” position.
		0x003D1E,  // Reg 06h, SD Configure Register
		0x104845,  // Reg 07h, Lock Detect Register
		0x016FFF,  // Reg 08h, Analog EN Register
		0x35FEFD,  // Reg 09h, Charge Pump Register
		// 0xB5FEFD,  // Reg 09h, Charge Pump Register HI GAIN
		0x000001,  // Reg 0Ah, Modulation Step Register
		0x01E071,  // Reg 0Bh, PD Register
		0x00001F,  // Reg 0Ch, Stop freq for Ramp mode, Alternate freq for FM mode
		0x000000,  // Reg 0Dh, Stop freq for Ramp mode, Alternate freq for FM mode, number of channels/boundary for Exact frequency mode
		0x000001,  // Reg 0Eh, SPI TRIG
		0x000001   // Reg 0Fh, GPO Register
	};
	RegNum = sizeof(reg_val) / sizeof(reg_val[0]);
	ZynqMPGpio_WritePin(HMC703_SCK, 0);
	usleep(100);
	for(Addr = 0; Addr < RegNum; Addr ++){
		HMC703_WriteReg(Addr, reg_val[Addr]);
		usleep(5);
	}
	ZynqMPGpio_WritePin(HMC703_SCK, 0);
}

// #define HMC703_DEBUG

/**
 * @brief	Calculate and set FMCW parameters.
 * @param	StartFreq is the start frequency of FMCW signal in kilohertz.
 * @param	StopFreq is the stop frequency of FMCW signal in kilohertz.
 * @param	PulseWidth is the pulse width of each FMCW signal in microsecond.
 * @return	none.
 */
void HMC703_SetParam(uint32_t StartFreq, uint32_t StopFreq, uint16_t PulseWidth){
	uint32_t f_pd = 50e6; //HMC703 XREF pin input frequency (Hz).
	uint8_t VCO_FreqDivRatio = 4;
	uint8_t HMC_PreDivider = 1;
	uint32_t PLL_BaseFreq = f_pd * VCO_FreqDivRatio * HMC_PreDivider / 1e3; //kHz

	start_int = (uint32_t)(round(StartFreq / PLL_BaseFreq));
	start_frac = (((double)StartFreq / PLL_BaseFreq) - start_int) * 0x1000000;

	uint32_t n_step = f_pd / 1e6 * PulseWidth;

	double step_practical = (double)(StopFreq - StartFreq) / PLL_BaseFreq / n_step * 16777216.0; //2^24=16777216

	step = round(step_practical);

	stop_int = floor((double)(n_step * step + start_frac) / 0x1000000) + start_int; //0x1000000=16777216

	stop_frac = (n_step * step + start_frac) % 0x1000000;

	// #ifdef HMC703_DEBUG
	// 	printf("PLL_BaseFreq = %1.3E kHz\r\n", (float)PLL_BaseFreq);
	// 	printf("n_step = %d\r\n", n_step);
	// 	printf("step_practical = %f\r\n", step_practical);
	// 	printf("step = %d\r\n", step);
	// 	printf("start_int  = %d\r\n", start_int);
	// 	printf("start_frac = %d\r\n", start_frac);
	// 	printf("stop_int   = %d\r\n", stop_int);
	// 	printf("stop_frac  = %d\r\n", stop_frac);
	// #endif
	
	HMC703_WriteReg(0x06, 0x3F1E); //enter fractional mode first
	HMC703_WriteReg(0x03, start_int); //start frequency integer part
	HMC703_WriteReg(0x04, start_frac); //start frequency fractional part
	HMC703_WriteReg(0x0A, step); //Fractional Modulation Step size
	HMC703_WriteReg(0x0C, stop_int); //stop frequency integer part
	HMC703_WriteReg(0x0D, stop_frac); //stop frequency fractional part
	// HMC703_WriteReg(0x06, 0x3FBE); //Ramp then Hop (Triggered)
	// HMC703_WriteReg(0x06, 0x3FDE); //Ramp Both directions (Triggered)
}
#endif

//#ifdef USE_PLL_LMX2492
uint8_t RegCfgTab[] = {
	0x18, //Reg 0x00, set as default
	0x00, //Reg 0x01, Reserved
	0x01, //Reg 0x02, operate normally
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //Reg 0x03 ~ 0x0F, Reserved
	0x28, //Reg 0x10, PLL_N[ 7: 0]
	0x00, //Reg 0x11, PLL_N[15: 8]
	0x2C, //Reg 0x12, fractional mode, 2nd modulator, disable dither
	0x00, //Reg 0x13, FRAC_NUM[ 7: 0]
	0x00, //Reg 0x14, FRAC_NUM[15: 8]
	0x00, //Reg 0x15, FRAC_NUM[23:16]
	0xFF, //Reg 0x16, FRAC_DEN[ 7: 0]
	0xFF, //Reg 0x17, FRAC_DEN[15: 8]
	0xFF, //Reg 0x18, FRAC_DEN[23:16]
	0x01, //Reg 0x19, PLL_R[ 7: 0], reference clock divide ratio = 1
	0x00, //Reg 0x1A, PLL_R[15: 8]
	0x08, //Reg 0x1B, fast lock configuration, set as default
	0x3F, //Reg 0x1C, positive polarity, mid charge pump gain
	0x00, //Reg 0x1D, fast lock configuration, set as default
	0x0A, //Reg 0x1E, CP voltage comparator low threshold, set as default
	0x32, //Reg 0x1F, CP voltage comparator high threshold, set as default
	0x00, //Reg 0x20, fast lock tolerance, set as default
	0x0F, //Reg 0x21, digital lock detect pass count, set as default
	0x34, //Reg 0x22, set TOL as 1 when Fpd < 130MHz, ERR_CNT is recommended as 4
	0x41, //Reg 0x23, digital lock detect configuration, as default
	0x0F, //Reg 0x24, ramp trigger signal input from TRIG1
	0x10, //Reg 0x25, MUX configuration, set as default
	0x18, //Reg 0x26, MUX configuration, set as default
	0x3A, //Reg 0x27, MUXout readback
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //Reg 0x28 ~ 0x30, Reserved
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //Reg 0x31 ~ 0x39, Reserved
	0x11, //0x3A, trigger source as Trigger A source, TRIG1 rising edge, RAMP_EN = 0
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //0x3B ~ 0x43
	0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //0x44 ~ 0x4C
	0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0x18, //0x4D ~ 0x53
	0x03, //Reg 0x54, RAMP_TRIG_INC = RAMP finish, RAMP_AUTO = 0
	0x00, //Reg 0x55, Reserved
	0x00, //Reg 0x56, RAMP0_INC[ 7: 0]
	0x00, //Reg 0x57, RAMP0_INC[15: 8]
	0x00, //Reg 0x58, RAMP0_INC[23:16]
	0x00, //Reg 0x59, RAMP0_INC[29:24]
	0x50, //Reg 0x5A, RAMP0_LEN[ 7: 0]
	0xC3, //Reg 0x5B, RAMP0_LEN[15: 8]
	0x2C, //Reg 0x5C, RAMP0_NEXT = RAMP1, RAMP0_NEXT_TRIG = Trig A, RAMP0_RST = 1
	0x8E, //Reg 0x5D, RAMP1_INC[ 7: 0]...........................................RAMP 1
	0x06, //Reg 0x5E, RAMP1_INC[15: 8]
	0x00, //Reg 0x5F, RAMP1_INC[23:16]
	0x00, //Reg 0x60, fast lock and RAMP1_INC[29:24]
	0x50, //Reg 0x61, RAMP1_LEN[ 7: 0]
	0xC3, //Reg 0x62, RAMP1_LEN[15: 8]
	0x40, //Reg 0x63, RAMP1_NEXT = RAMP2, RAMP1_NEXT_TRIG = TimeOut, RAMP1_RST = 1
	0x8D, //Reg 0x64, RAMP2_INC[ 7: 0]...........................................RAMP 2
	0x06, //Reg 0x65, RAMP2_INC[15: 8]
	0x00, //Reg 0x66, RAMP2_INC[23:16]
	0x00, //Reg 0x67, fast lock and RAMP2_INC[29:24]
	0x50, //Reg 0x68, RAMP2_LEN[ 7: 0]
	0xC3, //Reg 0x69, RAMP2_LEN[15: 8]
	0x60, //Reg 0x6A, RAMP2_NEXT = RAMP3, RAMP2_NEXT_TRIG = TimeOut, RAMP2_RST = 1
	0x8E, //Reg 0x6B, RAMP3_INC[ 7: 0]...........................................RAMP 3
	0x06, //Reg 0x6C, RAMP3_INC[15: 8]
	0x00, //Reg 0x6D, RAMP3_INC[23:16]
	0x00, //Reg 0x6E, fast lock and RAMP3_INC[29:24]
	0x50, //Reg 0x6F, RAMP3_LEN[ 7: 0]
	0xC3, //Reg 0x70, RAMP3_LEN[15: 8]
	0x80, //Reg 0x71, RAMP3_NEXT = RAMP4, RAMP3_NEXT_TRIG = TimeOut, RAMP3_RST = 1
	0x8E, //Reg 0x72, RAMP4_INC[ 7: 0]...........................................RAMP 4
	0x06, //Reg 0x73, RAMP4_INC[15: 8]
	0x00, //Reg 0x74, RAMP4_INC[23:16]
	0x00, //Reg 0x75, fast lock and RAMP4_INC[29:24]
	0x50, //Reg 0x76, RAMP4_LEN[ 7: 0]
	0xC3, //Reg 0x77, RAMP4_LEN[15: 8]
	0xA0, //Reg 0x78, RAMP4_NEXT = RAMP5, RAMP2_NEXT_TRIG = TimeOut, RAMP4_RST = 1
	0x8E, //Reg 0x79, RAMP5_INC[ 7: 0]...........................................RAMP 5
	0x06, //Reg 0x7A, RAMP5_INC[15: 8]
	0x00, //Reg 0x7B, RAMP5_INC[23:16]
	0x00, //Reg 0x7C, fast lock and RAMP5_INC[29:24]
	0x50, //Reg 0x7D, RAMP5_LEN[ 7: 0]
	0xC3, //Reg 0x7E, RAMP5_LEN[15: 8]
	0xC0, //Reg 0x7F, RAMP5_NEXT = RAMP6, RAMP2_NEXT_TRIG = TimeOut, RAMP5_RST = 1
	0x8D, //Reg 0x80, RAMP6_INC[ 7: 0]...........................................RAMP 6
	0x06, //Reg 0x81, RAMP6_INC[15: 8]
	0x00, //Reg 0x82, RAMP6_INC[23:16]
	0x00, //Reg 0x83, fast lock and RAMP6_INC[29:24]
	0x50, //Reg 0x84, RAMP6_LEN[ 7: 0]
	0xC3, //Reg 0x85, RAMP6_LEN[15: 8]
	0xE0, //Reg 0x86, RAMP6_NEXT = RAMP7, RAMP2_NEXT_TRIG = TimeOut, RAMP6_RST = 1
	0x8E, //Reg 0x87, RAMP7_INC[ 7: 0]...........................................RAMP 7
	0x06, //Reg 0x88, RAMP7_INC[15: 8]
	0x00, //Reg 0x89, RAMP7_INC[23:16]
	0x00, //Reg 0x8A, fast lock and RAMP7_INC[29:24]
	0x50, //Reg 0x8B, RAMP7_LEN[ 7: 0]
	0xC3, //Reg 0x8C, RAMP7_LEN[15: 8]
	0x00, //Reg 0x8D, RAMP7_NEXT = RAMP0, RAMP2_NEXT_TRIG = TimeOut, RAMP7_RST = 1
};

/**
 * @brief	Initialize pins used by LMX2492RTWR.
 * @param   void.
 * @return  void.
 */
void LMX2492_PinInit(void){
	ZynqMPGpio_ExportPin(LMX2492_CLK);
	ZynqMPGpio_ExportPin(LMX2492_DIN);
	ZynqMPGpio_ExportPin(LMX2492_LAT);
	ZynqMPGpio_ExportPin(LMX2492_MUX);
	
	ZynqMPGpio_SetPinDirection(LMX2492_CLK, GPIO_OUTPUT);
	ZynqMPGpio_SetPinDirection(LMX2492_DIN, GPIO_OUTPUT);
	ZynqMPGpio_SetPinDirection(LMX2492_LAT, GPIO_OUTPUT);
	ZynqMPGpio_SetPinDirection(LMX2492_MUX, GPIO_INPUT);
	
	ZynqMPGpio_WritePin(LMX2492_CLK, 0);
	ZynqMPGpio_WritePin(LMX2492_DIN, 0);
	ZynqMPGpio_WritePin(LMX2492_LAT, 1);
}

/**
 * @brief	Write data to a register for the specified address.
 * @param	Gpio is the structure pointer of Zynq's I/O driver instance.
 * @param	RegAddr is the address of register to be written.
 * @param	Data is the 8 bit data to be written to register.
 * @return	void.
 * @note	MSB first is the default on power-up.
 */
void LMX2492_WriteReg(uint16_t RegAddr, uint8_t Data){
	uint32_t DataToWrite = ((((uint32_t)RegAddr) << 8) & 0xFF00) | Data;
	uint8_t i;
	
	ZynqMPGpio_WritePin(LMX2492_CLK, 0);
	usleep(2);
	ZynqMPGpio_WritePin(LMX2492_LAT, 1);
	usleep(2);
	ZynqMPGpio_WritePin(LMX2492_LAT, 0);
	usleep(2);
	for(i = 0; i < 24; i ++){
		if(DataToWrite & 0x800000){
			ZynqMPGpio_WritePin(LMX2492_DIN, 1);
		}
		else{
			ZynqMPGpio_WritePin(LMX2492_DIN, 0);
		}
		DataToWrite <<= 1;
		usleep(3);
		ZynqMPGpio_WritePin(LMX2492_CLK, 1);
		usleep(10);
		ZynqMPGpio_WritePin(LMX2492_CLK, 0);
		usleep(5);
	}
	usleep(5);
	ZynqMPGpio_WritePin(LMX2492_DIN, 0);
	usleep(5);
	ZynqMPGpio_WritePin(LMX2492_LAT, 1);
	usleep(10);
}

/**
 * @brief  Read one byte data from a register for the specified address.
 * @param  RegAddr is the address of register to be read.
 * @return 8 bits data of the aimed register.
 */
uint8_t LMX2492_ReadReg(uint16_t RegAddr){
	uint8_t RecvData = 0;
	uint16_t DataToWrite = 0x8000 | RegAddr;
	uint8_t i;
	
	ZynqMPGpio_WritePin(LMX2492_CLK, 0);
	usleep(2);
	ZynqMPGpio_WritePin(LMX2492_LAT, 1);
	usleep(2);
	ZynqMPGpio_WritePin(LMX2492_LAT, 0);
	usleep(2);
	//send command and register address
	for(i = 0; i < 16; i ++){
		if(DataToWrite & 0x8000){
			ZynqMPGpio_WritePin(LMX2492_DIN, 1);
		}
		else{
			ZynqMPGpio_WritePin(LMX2492_DIN, 0);
		}
		DataToWrite <<= 1;
		usleep(2);
		ZynqMPGpio_WritePin(LMX2492_CLK, 1);
		usleep(10);
		ZynqMPGpio_WritePin(LMX2492_CLK, 0);
		usleep(5);
	}
	ZynqMPGpio_WritePin(LMX2492_DIN, 0);
	usleep(2);
	//begin to receive data
	for(i = 0; i < 8; i ++){
		RecvData <<= 1;
		usleep(8);
		ZynqMPGpio_WritePin(LMX2492_CLK, 1);
		if(ZynqMPGpio_ReadPin(LMX2492_MUX) != 0){
			RecvData += 1;
		}
		usleep(10);
		ZynqMPGpio_WritePin(LMX2492_CLK, 0);		
	}
	usleep(5);
	ZynqMPGpio_WritePin(LMX2492_DIN, 0);
	usleep(10);
	ZynqMPGpio_WritePin(LMX2492_LAT, 1);
	
	return RecvData;
}

//#define LMX2492_DEBUG

/**
 * @brief  Calculate parameters and configure registers to generate a single frequency signal.
 * @param  Freq is the aimed single frequency whose unit is kHz.
 * @return void.
 */
void LMX2492_SetFixedFreq(uint32_t Freq){
	uint32_t RefClkFreq = 50000; //LMX2492 OSCin pin input reference clock (kHz)
	uint8_t PrescalerFactor = 4; //HMC493, divide by 4
	double DivActual = ((double)Freq) / PrescalerFactor / RefClkFreq; //actual fractional N
	uint16_t DivInt = (uint32_t)DivActual; //PLL_N[15: 0], integer part of actual fractional N
	double DivFrac = DivActual - DivInt; //fractional part of actual fractional N
	uint32_t FracDen = 0xFFFFFF; //FRAC_DEN[23: 0]
	uint32_t FracNum = round(DivFrac * FracDen); //FRAC_NUM[23: 0]
	
	uint32_t b;
	uint32_t CommFactor = FracNum;
	uint32_t a = FracDen;
	while(a != 0){
		b = CommFactor % a;
		CommFactor = a;
		a = b;
	}
	FracNum /= CommFactor;
	FracDen /= CommFactor;
	
	// #ifdef LMX2492_DEBUG
	// 	printf("FixedFreq = %1.3E kHz\r\n", (float)Freq);
	// 	printf("DivActual = %f\r\n", DivActual);
	// 	printf("DivInt = %d (0x%X)->Reg 0x10, 0x11\r\n", DivInt, DivInt);
	// 	printf("DivFrac = %f\r\n", DivFrac);
	// 	printf("FracNum = %d (0x%X)->Reg 0x13 ~ 0x15\r\n", FracNum, FracNum);
	// 	printf("FracDen = %d (0x%X)->Reg 0x16 ~ 0x18\r\n\r\n", FracDen, FracDen);
	// #endif

	RegCfgTab[0x10] = (uint8_t)(DivInt & 0xFF); //PLL_N[ 7: 0]
	RegCfgTab[0x11] = (uint8_t)((DivInt & 0xFF00) >> 8); //PLL_N[15: 8]
	RegCfgTab[0x13] = (uint8_t)(FracNum & 0xFF); //FRAC_NUM[ 7: 0]
	RegCfgTab[0x14] = (uint8_t)((FracNum & 0xFF00) >> 8); //FRAC_NUM[15: 8]
	RegCfgTab[0x15] = (uint8_t)((FracNum & 0xFF0000) >> 16); //FRAC_NUM[23:16]
	RegCfgTab[0x16] = (uint8_t)(FracDen & 0xFF); //FRAC_DEN[ 7: 0]
	RegCfgTab[0x17] = (uint8_t)((FracDen & 0xFF00) >> 8); //FRAC_DEN[15: 8]
	RegCfgTab[0x18] = (uint8_t)((FracDen & 0xFF0000) >> 16); //FRAC_DEN[23:16]

	for(int8_t i = 0x27; i >= 0; i --){
		LMX2492_WriteReg(i, RegCfgTab[i]);
		printf("Write Reg 0x%02X = 0x%02X\r\n", i, RegCfgTab[i]);
		usleep(1);
	}
}

/**
 * @brief	Calculate parameters and configure registers to generate the FMCW signal.
 * @param	StartFreq is the start frequency whose unit is kHz.
 * @param	StopFreq is the stop single frequency whose unit is kHz.
 * @param	PulseWidth is the time duration of each FMCW signal whose unit is us.
 * @return 	void.
 * @note	each RAMP length of the LMX2492RTWR is limited to 50000 or less here, so multiple RAMP is needed 
 *			to piece together a complete long sweep. The shape of signal frequency is shown as follow.
 *
 *   LastRamp -->  /|
 *                / |
 *    RAMPx -->  /  |
 *              /   |
 *  RAMP1 -->  /    |
 *       _____/     |_________
 *      RAMP0          RAMP0
 *             ______
 *            |      |
 *  pEdge --> |      |    Trigger Signal
 *            |      |
 *       _____|      |________
 *
 */
void LMX2492_SetRampParam(uint32_t StartFreq, uint32_t StopFreq, uint16_t PulseWidth){
	uint32_t RefClkFreq = 50000; //LMX2492 OSCin pin input reference clock frequency (kHz)
	uint8_t PrescalerFactor = 4; //HMC493 (divide by 4)

	//calculate PLL_N, FracNum and Frac_Den for start frequency
	double DivActual = ((double)StartFreq) / PrescalerFactor / RefClkFreq; //actual fractional N
	uint16_t DivInt = (uint32_t)DivActual; //PLL_N[15: 0], integer part of actual fractional N
	double DivFrac = DivActual - DivInt; //fractional part of actual fractional N
	uint32_t FracDen = 0xFFFFFF; //FRAC_DEN[23: 0]
	uint32_t FracNum = round(DivFrac * FracDen); //FRAC_NUM[23: 0]
	//reduction of a fraction
	uint32_t b;
	uint32_t CommFactor = FracNum;
	uint32_t a = FracDen;
	while(a != 0){
		b = CommFactor % a;
		CommFactor = a;
		a = b;
	}
	FracNum /= CommFactor;
	FracDen /= CommFactor;
	
	// #ifdef LMX2492_DEBUG
	// 	printf("********** Parameters Calculation of Start Frequency **********\r\n");
	// 	printf("DivActual of start freq = %f\r\n", DivActual);
	// 	printf("DivInt = %d (0x%X)->Reg 0x10, 0x11\r\n", DivInt, DivInt);
	// 	printf("DivFrac = %f\r\n", DivFrac);
	// 	printf("FracNum = %d (0x%X)->Reg 0x13 ~ 0x15\r\n", FracNum, FracNum);
	// 	printf("FracDen = %d (0x%X)->Reg 0x16 ~ 0x18\r\n\r\n", FracDen, FracDen);
	// #endif

	RegCfgTab[0x10] = (uint8_t)(DivInt & 0xFF); //PLL_N[ 7: 0]
	RegCfgTab[0x11] = (uint8_t)((DivInt & 0xFF00) >> 8); //PLL_N[15: 8]
	RegCfgTab[0x13] = (uint8_t)(FracNum & 0xFF); //FRAC_NUM[ 7: 0]
	RegCfgTab[0x14] = (uint8_t)((FracNum & 0xFF00) >> 8); //FRAC_NUM[15: 8]
	RegCfgTab[0x15] = (uint8_t)((FracNum & 0xFF0000) >> 16); //FRAC_NUM[23:16]
	RegCfgTab[0x16] = (uint8_t)(FracDen & 0xFF); //FRAC_DEN[ 7: 0]
	RegCfgTab[0x17] = (uint8_t)((FracDen & 0xFF00) >> 8); //FRAC_DEN[15: 8]
	RegCfgTab[0x18] = (uint8_t)((FracDen & 0xFF0000) >> 16); //FRAC_DEN[23:16]
	
	//calculate RampLen and RampInc for frequency sweep
	uint32_t RampLen = RefClkFreq / 1000 * PulseWidth; //total phase detector cycles
	double RampFrac = ((double)(StopFreq - StartFreq)) / PrescalerFactor / RampLen * 0x1000000 / RefClkFreq;
	uint32_t RampInc = round(RampFrac);
	
	uint16_t FixedPulseWidth = 1000;
	uint8_t FixedRampNum = PulseWidth / FixedPulseWidth;
	uint32_t FixedRampLen = RefClkFreq / 1000 * FixedPulseWidth; //RefClk (MHz) * 1000 (us)
	double   FixedRampDeltaFreq = ((double)(StopFreq - StartFreq)) / PulseWidth * FixedPulseWidth / PrescalerFactor; // k * 1000 us
	double   FixedRampFrac = FixedRampDeltaFreq / FixedRampLen * 0x1000000 / RefClkFreq;
	uint32_t FixedRampInc = round(FixedRampFrac);
	
	uint32_t LastRampPulseWidth = PulseWidth % FixedPulseWidth;
	uint16_t LastRampNum = FixedRampNum;
	if(LastRampPulseWidth > 0){ //if the PulseWidth cannot be divided by 1000
		LastRampNum = FixedRampNum + 1; //there must be an addational ramp to finish the remained things
	}
	uint32_t LastRampLen = RefClkFreq / 1000 * LastRampPulseWidth;
	double   LastRampDeltaFreq = ((double)(StopFreq - StartFreq) / PrescalerFactor - (FixedRampDeltaFreq * FixedRampNum));
	double   LastRampFrac = LastRampDeltaFreq / LastRampLen * 0x1000000 / RefClkFreq;
	uint32_t LastRampInc = round(LastRampFrac);

	uint32_t Inc = FixedRampInc;
	uint32_t Len = FixedRampLen;
	
	// #ifdef LMX2492_DEBUG
	// 	printf("StartFreq = %1.3E kHz\r\n", (float)StartFreq);
	// 	printf("StopFreq = %1.3E kHz\r\n", (float)StopFreq);
	// 	printf("PulseWidth = %d us\r\n", PulseWidth);
	// 	printf("RampLen = %d (0x%X)->Reg 0x5A, 0x5B\r\n", RampLen, RampLen);
	// 	printf("RampFrac = %f\r\n", RampFrac);
	// 	printf("RampInc = %d (0x%X)->Reg 0x56 ~ 0x59\r\n\r\n", RampInc, RampInc);
	
	// 	printf("FixedRampNum = %d\r\n", FixedRampNum);
	// 	printf("LastRampPulseWidth = %d us\r\n", LastRampPulseWidth);
	// 	printf("FixedRampDeltaFreq = %f kHz\r\n", FixedRampDeltaFreq);
	// 	printf("FixedRampLen = %d\r\n", FixedRampLen);
	// 	printf("FixedRampInc = %d\r\n\r\n", FixedRampInc);
	
	// 	printf("LastRampNum = %d\r\n", LastRampNum);
	// 	printf("LastRampPulseWidth = %d kHz\r\n", LastRampPulseWidth);
	// 	printf("LastRampDeltaFreq = %f kHz\r\n", LastRampDeltaFreq);
	// 	printf("LastRampLen = %d\r\n", LastRampLen);
	// 	printf("LastRampInc = %d\r\n\r\n", LastRampInc);
	// #endif
	
	//Reset RegCfgTab data
	RegCfgTab[0x5C] = 0x2C;
	RegCfgTab[0x63] = 0x40;
	RegCfgTab[0x6A] = 0x60;
	RegCfgTab[0x71] = 0x80;
	RegCfgTab[0x78] = 0xA0;
	RegCfgTab[0x7F] = 0xC0;
	RegCfgTab[0x86] = 0xE0;

	for(uint8_t i = 0; i <= LastRampNum; i ++){
		if(LastRampNum == i + 1){ //last ramp increment and length
			if(LastRampPulseWidth != 0){
				Inc = LastRampInc;
				Len = LastRampLen;
			}
			RegCfgTab[0x63 + 7 * i] = RegCfgTab[0x63 + 7 * i] & 0x1F; //RAMPx_NEXT = RAMP0
		}
		RegCfgTab[0x5D + 7 * i] = (uint8_t)(Inc & 0xFF); //RAMPx_INC[ 7: 0]
		RegCfgTab[0x5E + 7 * i] = (uint8_t)((Inc & 0xFF00) >> 8); //RAMPx_INC[15: 8]
		RegCfgTab[0x5F + 7 * i] = (uint8_t)((Inc & 0xFF0000) >> 16); //RAMPx_INC[23:16]
		RegCfgTab[0x60 + 7 * i] = (uint8_t)(((Inc & 0xFF000000) >> 24) & 0xFF); //RAMPx_INC[29:24]
		RegCfgTab[0x61 + 7 * i] = (uint8_t)(Len & 0xFF); //RAMPx_LEN[ 7: 0]
		RegCfgTab[0x62 + 7 * i] = (uint8_t)((Len & 0xFF00) >> 8); //RAMPx_LEN[15: 8]		
	}
	
	uint16_t RegNum = sizeof(RegCfgTab) / sizeof(RegCfgTab[0]);
	for(int16_t i = RegNum - 1; i >= 0x00; i --){
		LMX2492_WriteReg(i, RegCfgTab[i]);
		usleep(1000);
	}
}
//#endif

/****************************** AD9508BCPZ Configuration ******************************/
// #define USE_AD9508_OUT2
// #define USE_AD9508_OUT3

/**
 * @brief	Initialize pins used by AD9508BCPZ.
 * @param	void.
 * @return	none.
 */
void AD9508_PinInit(void){
	ZynqMPGpio_ExportPin(AD9508_SCL);
	ZynqMPGpio_ExportPin(AD9508_SDA);
	ZynqMPGpio_ExportPin(AD9508_RST);
	ZynqMPGpio_ExportPin(AD9508_SYN);

	ZynqMPGpio_SetPinDirection(AD9508_SCL, GPIO_OUTPUT);
	ZynqMPGpio_SetPinDirection(AD9508_SDA, GPIO_OUTPUT);

	ZynqMPGpio_SetPinDirection(AD9508_RST, GPIO_OUTPUT);
	ZynqMPGpio_WritePin(AD9508_RST, 1);
	ZynqMPGpio_SetPinDirection(AD9508_SYN, GPIO_OUTPUT);	
	ZynqMPGpio_WritePin(AD9508_SYN, 1);
}

/**
 * @brief	Pull down RST and SYNC 40 ms to reset AD9508BCPZ.
 * @param	void.
 * @return	none.
 */
void AD9508_Reset(void){
	ZynqMPGpio_WritePin(AD9508_RST, 0);
	ZynqMPGpio_WritePin(AD9508_SYN, 0);
	usleep(40000);
	ZynqMPGpio_WritePin(AD9508_RST, 1);
	ZynqMPGpio_WritePin(AD9508_SYN, 1);
	usleep(20000);
}

/**
 * @brief	Pull down SYNC 40ms to synchronize AD9508BCPZ.
 * @param	void.
 * @return	none.
 */
void AD9508_Sync(void){
	ZynqMPGpio_WritePin(AD9508_SYN, 0);
	usleep(40000);
	ZynqMPGpio_WritePin(AD9508_SYN, 1);
	usleep(20000);
}

/**
 * @brief	make an IIC start condition for AD9508BCPZ.
 * @param	void.
 * @return	none.
 */
void AD9508_IICStart(void){
	ZynqMPGpio_SetPinDirection(AD9508_SCL, GPIO_OUTPUT);
	ZynqMPGpio_SetPinDirection(AD9508_SDA, GPIO_OUTPUT);
	ZynqMPGpio_WritePin(AD9508_SCL, 1);
	ZynqMPGpio_WritePin(AD9508_SDA, 1);
	usleep(4);
	ZynqMPGpio_WritePin(AD9508_SDA, 0);
	usleep(4);
	ZynqMPGpio_WritePin(AD9508_SCL, 0);
	usleep(4);
}

/**
 * @brief	make an IIC stop condition for AD9508BCPZ.
 * @param	void.
 * @return	none.
 */
void AD9508_IICStop(void){
	ZynqMPGpio_WritePin(AD9508_SCL, 1);
	ZynqMPGpio_WritePin(AD9508_SDA, 0);
	usleep(4);
	ZynqMPGpio_WritePin(AD9508_SDA, 1);
	usleep(4);
}

/**
 * @brief	Wait for an ACK from AD9508BCPZ.
 * @param	void.
 * @return	none.
 */
uint8_t AD9508_IICWaitAck(void){
	uint8_t ack = 0;

	ZynqMPGpio_SetPinDirection(AD9508_SDA, GPIO_INPUT);
	ZynqMPGpio_WritePin(AD9508_SCL, 1);
	usleep(4);
	if(ZynqMPGpio_ReadPin(AD9508_SDA)){
		ack = 1; //nACK
	}
	else{
		ack = 0; //ACK
	}
	ZynqMPGpio_WritePin(AD9508_SCL, 0);
	usleep(4);
	ZynqMPGpio_SetPinDirection(AD9508_SDA, GPIO_OUTPUT);
	return ack;
}

/**
 * @brief	Write one byte data to AD9508BCPZ.
 * @param	Data is one byte data to be written.
 * @return	none.
 */
void AD9508_IICWriteByte(uint8_t Data){
	int32_t i; //must use int32_t

	ZynqMPGpio_SetPinDirection(AD9508_SDA, GPIO_OUTPUT);
	ZynqMPGpio_WritePin(AD9508_SCL, 0);
	usleep(4);
	for(i = 7; i >= 0; i --){
		if(Data & (1 << i)){
			ZynqMPGpio_WritePin(AD9508_SDA, 1);
		}
		else{
			ZynqMPGpio_WritePin(AD9508_SDA, 0);
		}
		usleep(4);
		ZynqMPGpio_WritePin(AD9508_SCL, 1);
		usleep(4);
		ZynqMPGpio_WritePin(AD9508_SCL, 0);
		usleep(4);
	}
}

/**
 * @brief	Write one byte data to AD9508BCPZ.
 * @param	Addr is the specified address of register.
 * @param	Data is one byte data to be written.
 * @return	none.
 */
uint32_t AD9508_WriteReg(uint8_t Addr, uint8_t Data){
	uint8_t ack;

	AD9508_IICStart(); //send START signal
	AD9508_IICWriteByte(AD9508_ADDR); //write device address
	ack = AD9508_IICWaitAck(); //wait for ACK from slave device
	if(ack){
		printf("AD9508 Write Device Address NACK.\r\n");
		return 1;
	}
	AD9508_IICWriteByte(0x00); //write upper 8 bit of address
	ack = AD9508_IICWaitAck(); //wait for ACK from slave device
	if(ack){
		printf("AD9508 Write Upper Register Address NACK.\r\n");
		return 2;
	}
	AD9508_IICWriteByte(Addr); //write lower 8 bit of address
	ack = AD9508_IICWaitAck(); //wait for ACK from slave device
	if(ack){
		printf("AD9508 Write Lower Register Address NACK.\r\n");
		return 3;
	}
	AD9508_IICWriteByte(Data); //write data
	ack = AD9508_IICWaitAck(); //wait for ACK from slave device
	if(ack){
		printf("AD9508 Write Data NACK.\r\n");
		return 4;
	}
	AD9508_IICStop(); //send STOP signal
	return 0;
}

/**
 * @brief	Write one byte data to AD9508BCPZ.
 * @param	void.
 * @return	none.
 * @note	Use the USE_AD9508_OUTx macro to enable OUT2 or OUT3 of AD9508BCPZ.
 */
void AD9508_RegInit(void){
	//AD9508BCPZ OUT0, Pin 2&3 (0x15 ~ 0x1A) ---> PD_REF_CLK
	AD9508_WriteReg(0x15, 0x01); //divide ratio = 2, f = 50 MHz
	AD9508_WriteReg(0x19, 0x18); //output Driver = non-inverting
//	AD9508_WriteReg(0x1A, 0xA4); //single ended CMOS output

	//AD9508BCPZ OUT1, Pin 7&8 (0x1B ~ 0x20) ---> N.C.
	AD9508_WriteReg(0x1F, 0x8C); //power down

	//AD9508BCPZ OUT2, Pin 11&12 (0x21 ~ 0x26) ---> CLK_OUT1 & CK_O2
	#ifdef USE_AD9508_OUT2
		AD9508_WriteReg(0x2B, 0x8C); //OUT3 power down
		AD9508_WriteReg(0x21, 0x09); //divide ratio = 10, f = 10 MHz
		AD9508_WriteReg(0x25, 0x1C); //output driver = non-inverting
		AD9508_WriteReg(0x26, 0xA4); //single ended CMOS output
	#endif

	//AD9508BCPZ OUT3, Pin 16&17 (0x27 ~ 0x2C) ---> CLK_OUT2 & CK_O3
	#ifdef USE_AD9508OUT3
		AD9508_WriteReg(0x25, 0x8C); //OUT2 power down
		AD9508_WriteReg(0x27, 0x09); //divide ratio = 10, f = 10 MHz
		AD9508_WriteReg(0x2B, 0x1C); //output Driver = non-inverting
		AD9508_WriteReg(0x2C, 0xA4); //single ended CMOS output
	#endif

	AD9508_Sync();
}

/**
 * @brief	Write one byte data to AD9508BCPZ.
 * @param	SampleRate_MHz is the output frequency of OUT0 of AD9508BCPZ.
 * @return	none.
 */
void AD9508_SetOutputFreq(double SampleRate_MHz){
	uint8_t ratio = RF_OSC_FREQ_MHz / SampleRate_MHz;
	#ifdef USE_AD9508_OUT2
		AD9508_WriteReg(0x21, ratio - 1);
	#endif
	#ifdef USE_AD9508_OUT3
		AD9508_WriteReg(0x27, ratio - 1);
	#endif
	usleep(40000);
	AD9508_Sync();
}

