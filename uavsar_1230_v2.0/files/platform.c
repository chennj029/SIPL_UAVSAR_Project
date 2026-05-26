#include "platform.h"
#include "acq_brd.h"
#include "base_brd.h"
#include "psu_brd.h"
#include "tx_brd.h"
#include "main.h"

#include <stdio.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <unistd.h>
/**
 * @brief	Export a new pin with specified number of ZynqMP.
 * @param	PinName is the pin number defined by macro defination.
 * @return	none.
 */
void ZynqMPGpio_ExportPin(int PinName){
    int lGpioFd;
	char lCache[100];
 
	lGpioFd = open("/sys/class/gpio/export", O_WRONLY); //open file export to lGpioFd
	if(lGpioFd < 0){
		printf("Open export failed when initialize GPIO%d.\n", PinName);
	}
	//type conversion from integter (PinName) to sting
	int len = sprintf(lCache, "%d", PinName);
	//write lCache to lGpioFd with length of len+1
	write(lGpioFd, lCache, len + 1);
	close(lGpioFd); //close file after wirtting done
}

/**
 * @brief	Export a new pin with specified number of ZynqMP.
 * @param	PinName is the pin number defined by macro defination.
 * @param	Direction is the direction of pin to be set.
 * @return	none.
 */
void ZynqMPGpio_SetPinDirection(int PinName, uint8_t Direction){
    int lGpioFd;
	char lCache[100];

	sprintf(lCache, "/sys/class/gpio/gpio%d/direction", PinName);
	lGpioFd = open(lCache, O_RDWR);

	if(lGpioFd < 0){
		printf("Open file direction of gpio%d failed.\n", PinName);
	}
	else{
		if(Direction == GPIO_INPUT){
			write(lGpioFd, "in", 4);
		}
		else if(Direction == GPIO_OUTPUT){
			write(lGpioFd, "out", 4);
		}
	}
	close(lGpioFd);
}

/**
 * @brief	Set output status of specified number of pin.
 * @param	PinName is the pin number defined by macro defination.
 * @param	Value is 1 or 0 which sets GPIO output high or low.
 * @return	none.
 * @note	Call this function after initialize related pin.
 */
void ZynqMPGpio_WritePin(int PinName, uint8_t Value){
    int lGpioFd;
	char lCache[100], Buffer[4] = {""};

	sprintf(lCache, "/sys/class/gpio/gpio%d/direction", PinName);
	lGpioFd = open(lCache, O_RDWR);
	if(lGpioFd < 0){ //file 'direction' does not exist
		printf("Open file direction of gpio%d falied.\n", PinName);
	}
	else{ //open file 'direction' successfully
		read(lGpioFd, Buffer, 3);		
		close(lGpioFd);
		if(!strcmp((char *)Buffer, "out")){ //check value of direction if is "out"
			sprintf(lCache, "/sys/class/gpio/gpio%d/value", PinName);
			lGpioFd = open(lCache, O_RDWR);
			if(lGpioFd < 0){ //file 'value' does not exist
				printf("Open file value of gpio%d failed.\n", PinName);
			}
			else{ //open file 'value' successfully
				if(Value){
					write(lGpioFd, "1",  2);
				}
				else{
					write(lGpioFd, "0",  2);
				}
			}
		}
		else{ //value of file 'direction' is not "out"
			printf("Direction is not \"out\" when set gpio%d.\n", PinName);
		}
	}
	close(lGpioFd);
}

/**
 * @brief	Read input status of specified number of pin.
 * @param	PinName is the pin number defined by macro defination.
 * @return	Pin status which is formated as unsigned char.
 * @note	Call this function after initialize related pin.
 */
uint8_t ZynqMPGpio_ReadPin(int PinName){
    uint8_t Value, Status[10];
	int lGpioFd;
	char lCache[100], Buffer[3] = {""};

	sprintf(lCache, "/sys/class/gpio/gpio%d/direction", PinName);
	lGpioFd = open(lCache, O_RDWR);
	if(lGpioFd < 0){ //file 'direction' does not exist
		printf("Open file direction of gpio%d falied.\n", PinName);
	}
	else{ //open file 'direction' successfully
		read(lGpioFd, Buffer, 2);
		close(lGpioFd);		
		if(!strcmp((char *)Buffer, "in")){ //check value of direction if is "in"
			sprintf(lCache, "/sys/class/gpio/gpio%d/value", PinName);
			lGpioFd = open(lCache, O_RDWR);
			if(lGpioFd < 0){ //file 'value' does not exist
				printf("Open file value of gpio%d failed.\n", PinName);
			}
			else{ //open file 'value' successfully
				read(lGpioFd, Status, 1);
				close(lGpioFd);
				Value = Status[0] - '0';
				return Value;
			}
		}
		else{ //value of file 'direction' is not "in"
			sprintf(lCache, "/sys/class/gpio/gpio%d/value", PinName);
			lGpioFd = open(lCache, O_RDWR);
			if(lGpioFd < 0){ //file 'value' does not exist
				printf("Open file value of gpio%d failed.\n", PinName);
			}
			else{ //open file 'value' successfully
				read(lGpioFd, Status, 1);
				close(lGpioFd);
				Value = Status[0] - '0';
				return Value;
			}
			// printf("Direction is not \"in\" when read gpio%d.\n", PinName);
		}
	}
	close(lGpioFd);

	return 0;
}

///////////////////////////////////////////////////////////////////////////////////

// /**
//  * @brief   Performs an output operation for a memory location by writing the
//  *          32 bit Value to the the specified address.
//  * @param	Addr contains the address to perform the output operation.
//  * @param	Value contains the 32 bit Value to be written at the specified address.
//  * @return	none.
//  */
// void ZynqMP_Out32(uint32_t BaseAddr, uint32_t RegOffset, uint32_t Data){
// 	*(volatile uint32_t *)((BaseAddr) + (RegOffset)) = Data;
// }

#define PLATFORM_DEBUG

/**
 * @brief	Initialize UAV-SAR platform.
 * @param	void.
 * @return	none.
 */
void Platform_Init(volatile uint64_t* module_en_reg,volatile uint64_t* prt_cnt_reg,volatile uint64_t* pulse_width_reg){
	//printf("\r\nPlatform Initializing ...\r\n");
	Platform_SetDefaultParam(); //default value assignment of global variables
	Platform_SubmodulesInit(); //initialize pins and configure registers of each chips
	AD9508_SetOutputFreq(SampleRate_MHz);
	
	ADL5205_SPIGainCtrl(VGA_Gain_dB,0);

	// printf("ADL5205_SPIGainCtrl successed!\r\n");
	// ADL5205_ReadReg();
	// printf("ADL5205_ReadReg successed!\r\n");
	
	LMX2492_SetRampParam(StartFreq_kHz, StopFreq_kHz, PulseWidth_us);

	// Radar_SetPRF(PRF_Hz, PulseWidth_us)
	prt_count = SampleRate_MHz * 1e6 / PRF_Hz;
	pulse_width = prt_count * PulseWidth_us / 1e2 * PRF_Hz / 1e4;

	Platform_ResetPL(); //// adddddddddddddddddddd
	*module_en_reg = 0;
	usleep(1000);

	Platform_ResetPL();

	*prt_cnt_reg = prt_count;
	*pulse_width_reg = pulse_width;
	usleep(1000);
	*module_en_reg = 1;

	#ifdef PLATFORM_DEBUG
		printf("\n **********Starting initializing the platform*********** \n");
		printf("Sweep Start Frequency = %d kHz\n", StartFreq_kHz);
		printf("Sweep Stop Frequency = %d kHz\n", StopFreq_kHz);
		printf("Sample Rate = %.2f MHz\r\n", SampleRate_MHz);
		printf("Sample Time = %d s\n", sample_time_s);
		printf("Sample Length = %ld\n", sample_len);
		printf("Pulse Width = %d μs\r\n", PulseWidth_us);
		printf("Pulse Repeat Freq = %d Hz\r\n", PRF_Hz);
		printf("VGA Gain = %d dB\r\n", VGA_Gain_dB);
	#endif

	// AD9269_DeviceCheck(4);
	snprintf(send_str, sizeof(send_str), "-------- Platform initialization done. --------\r\n");
}

/**
 * @brief	Initialize UAV-SAR global variables.
 * @param	void.
 * @return	none.
 */
void Platform_SetDefaultParam(void){
	state = S_IDLE;
	SampleRate_MHz = 10.0;
	PulseWidth_us = 2000;
	PRF_Hz = 200;
	StartFreq_kHz = (uint32_t)(14E6);
	StopFreq_kHz  = (uint32_t)(15E6);
	
	VGA_Gain_dB = 0;

	// rail_traval_x = 0;
	// rail_traval_y = 0;
	// rail_direction_x = 0;
	// rail_direction_y = 0;
	// rail_speed = 0;

	sample_time_s = 10;
	sample_len = SampleRate_MHz * PulseWidth_us * sample_time_s * PRF_Hz;
	/**** For Debug ****/
	// printf("Sweep Start Frequency = %d kHz\n", StartFreq_kHz);
	// printf("Sweep Stop Frequency = %d kHz\n", StopFreq_kHz);
	// printf("Sample Rate = %d MHz\n", SampleRate_MHz);
	// printf("Sample Time = %d s\n", sample_time_s);
	// printf("Sample Length = %d\n", sample_len);
	// printf("Pulse Width = %d us\n", PulseWidth_us);
	// printf("Pulse Repeat Frequency = %d Hz\n", PRF_Hz);
	// printf("VGA Gain = %d dB\n", VGA_Gain_dB);
}

/**
 * @brief	Initialize UAV-SAR I/O peripheral and registers of used chips.
 * @param	void
 * @return	none.
 */
void Platform_SubmodulesInit(void){
	PsuBrd_Init();
	TxBrd_Init();
	AcqBrd_Init();
	BaseBrd_Init();

	// printf("xxxxxx\n");
	// printf("PL_RST pin value is %d\n",ZynqMPGpio_ReadPin(PL_RST));
	ZynqMPGpio_ExportPin(PL_RST);
	// printf("PL_RST pin value is %d\n",ZynqMPGpio_ReadPin(PL_RST));
	// printf("yyyyyy\n");
    ZynqMPGpio_SetPinDirection(PL_RST, GPIO_OUTPUT);   ////0
	// printf("PL_RST pin value is %d\n",ZynqMPGpio_ReadPin(PL_RST));
	// printf("zzzzzz\n");
	ZynqMPGpio_WritePin(PL_RST, 1);

	AD9508_Reset();
	INA226_RegInit();
	AD9508_RegInit();

	HMC960_RegInit();
	AD9269_RegInit();

	printf("Platform submodules init success!\r\n");
}

/**
 * @brief	Reset PL by software.
 * @param	void
 * @return	none.
 */
void Platform_ResetPL(void){
	// printf("0000000\n");
	ZynqMPGpio_WritePin(PL_RST, 0);
	// printf("1111111\n");
	usleep(2000);
	// printf("2222222\n");
	ZynqMPGpio_WritePin(PL_RST, 1);
	// printf("3333333\n");
	usleep(2000);
}

/**
 * @brief	Set PRF and pulse width of UAV-SAR system.
 * @param	PRF_Hz_new is the pulse repeat frequency of FMCW signal.
 * @param	PulseWidth_us_new is the pulse width of each FMCW signal.
 * @return	none.
 */

int Platform_SetRadarPRF(uint32_t PRF_Hz_new, uint32_t PulseWidth_us_new){
	
	int fd = open("/dev/mem", O_RDWR | O_SYNC);
    if(fd < 0){
        printf("open /dev/mem failed!\n");
        return 1;
    }


	volatile uint64_t* sample_prt_count_reg;
	volatile uint64_t* sample_pulse_width_reg;
	volatile uint64_t* sample_module_en_reg;

	unsigned char* base_address = (unsigned char*)mmap(NULL, 0X10000, PROT_READ | PROT_WRITE, MAP_SHARED, fd, AD9269_SAMPLE_BASE);
    if(base_address == MAP_FAILED){
        perror("mmap");
        close(fd);
        return 1;
    }

    sample_prt_count_reg = (volatile uint64_t*)(base_address+PRT_COUNT_OFFSET_ADDR);
    sample_pulse_width_reg = (volatile uint64_t*)(base_address+PULSE_WIDTH_OFFSET_ADDR);
	sample_module_en_reg = (volatile uint64_t*)(base_address+MODULE_EN_OFFSET_ADDR);

	PRF_Hz = PRF_Hz_new;
	PulseWidth_us = PulseWidth_us_new;

	prt_count = SampleRate_MHz * 1e6 / PRF_Hz;	//number of points refer to sample rate in a PRT, PL prt_count
	pulse_width = prt_count * PulseWidth_us / 1e2 * PRF_Hz / 1e4;	//PL pulse_width
	//ZynqMP_Out32(AD9269_SAMPLE_BASE, MODULE_EN_OFFSET_ADDR, 0);
	*sample_module_en_reg = 0;
	usleep(1000);	//delay enough time to finish a full trigger period
	Platform_ResetPL();
	//ZynqMP_Out32(AD9269_SAMPLE_BASE, PRT_COUNT_OFFSET_ADDR, prt_count);
	*sample_prt_count_reg = prt_count;
	//ZynqMP_Out32(AD9269_SAMPLE_BASE, PULSE_WIDTH_OFFSET_ADDR, pulse_width);
	*sample_pulse_width_reg = pulse_width;//us
	usleep(1000);	//waiting for AXI parameters stable
	//ZynqMP_Out32(AD9269_SAMPLE_BASE, MODULE_EN_OFFSET_ADDR, 1);
	*sample_module_en_reg = 1;

	if(munmap(base_address, 0x10000)==-1){
        perror("munmap");
    }
	close(fd);

	return 0;
}


/**
 * @brief	Set sample rate of UAV-SAR system.
 * @param	SampleRate_MHz_new is the sample rate of Analog-to-Digital Converter.
 * @return	none.
 */
void Platform_SetSampleRate(uint8_t SampleRate_MHz_new){
	if((RF_OSC_FREQ_MHz % SampleRate_MHz_new != 0)){
		printf("Sample Rate invalid.\r\n");
	}
	else{
		SampleRate_MHz = SampleRate_MHz_new;
		AD9508_SetOutputFreq(SampleRate_MHz_new);
	}
}

/**
 * @brief	Write data to a address.
 * @param	void.
 * @return	none.
*/
/*
void Platform_WrtieData(voi){
	
}
*/
