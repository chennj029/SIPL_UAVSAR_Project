#ifndef _BASE_BRD_H_
#define _BASE_BRD_H_
/***************************** Include Files *********************************/
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdbool.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>
#include "main.h"
/*************************** Macro  Definitions ******************************/
#define PS_LED_INDEX    40
#define PS_KEY_INDEX    26
#define PS_LED  (ZYNQMP_GPIO_BASE + PS_LED_INDEX)
#define PS_KEY  (ZYNQMP_GPIO_BASE + PS_KEY_INDEX)
/************************** Variable Definitions *****************************/
#define KEY_PRES    1
#define KEY_IDLE    0
/************************** Function Prototypes ******************************/
void BaseBrd_Init(void);
void PS_LED_PinInit(void);
void PS_LED_ON(void);
void PS_LED_OFF(void);
void PS_KEY_PinInit(void);
uint32_t PS_KEY_Read(void);

#endif
