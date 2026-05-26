#include "platform.h"
#include "base_brd.h"
#include "psu_brd.h"
#include "acq_brd.h"
#include "tx_brd.h"
#include "main.h"
#include <stdio.h>

/**
 * @brief	Initialize pins and registers of chips used in Base_Brd.
 * @param	void.
 * @return	none.
 */
void BaseBrd_Init(void){
	PS_LED_PinInit();
	//PS_LED_OFF();
	PS_KEY_PinInit();
}

/**
 * @brief	Initialize pins used by PS LED.
 * @param	void
 * @return	none.
 */
void PS_LED_PinInit(void){
    ZynqMPGpio_ExportPin(PS_LED);
    ZynqMPGpio_SetPinDirection(PS_LED, GPIO_OUTPUT);
    ZynqMPGpio_WritePin(PS_LED, 0);
}

/**
 * @brief	Lights PS LED on.
 * @param	void
 * @return	none.
 */
void PS_LED_ON(void){
	ZynqMPGpio_WritePin(PS_LED, 1);
}

/**
 * @brief	Turn PS LED off.
 * @param	void
 * @return	none.
 */
void PS_LED_OFF(void){
	ZynqMPGpio_WritePin(PS_LED, 0);
}

/**
 * @brief	Initialize pins used by KEY.
 * @param	void
 * @return	none.
 */
void PS_KEY_PinInit(void){
    ZynqMPGpio_ExportPin(PS_KEY);
	ZynqMPGpio_SetPinDirection(PS_KEY, GPIO_INPUT);
}

/**
 * @brief	Read I/O status of PS KEY pin.
 * @param	void
 * @return	none.
 */
uint32_t PS_KEY_Read(void){
	uint32_t val = KEY_IDLE;
	if(ZynqMPGpio_ReadPin(PS_KEY) == 0){
		usleep(10000);
		if(ZynqMPGpio_ReadPin(PS_KEY) == 0){
			val = KEY_PRES;
		}
		else{
			val = KEY_IDLE;
		}
	}
	return (uint32_t)val;
}

