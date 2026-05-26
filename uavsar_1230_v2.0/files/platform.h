#ifndef _PLATFORM_H_
#define _PLATFORM_H_
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
#define ZynqMP_Out32(BaseAddress, RegOffset, Data) *(volatile unsigned int *) \
                    (BaseAddress + RegOffset) = Data
#define ZynqMP_In32(BaseAddress, RegOffset) *(volatile unsigned int*) \
                    ((BaseAddress) + (RegOffset))

#define PL_RST_INDEX    173
#define PL_RST  (ZYNQMP_GPIO_BASE + PL_RST_INDEX)

#define AD9269_SAMPLE_BASE    			0x80000000
#define SAMPLE_START_OFFSET_ADDR		AD9269_SAMPLE_S00_AXI_SLV_REG0_OFFSET
#define SAMPLE_LEN_OFFSET_ADDR			AD9269_SAMPLE_S00_AXI_SLV_REG1_OFFSET
#define PRT_COUNT_OFFSET_ADDR			AD9269_SAMPLE_S00_AXI_SLV_REG2_OFFSET
#define PULSE_WIDTH_OFFSET_ADDR			AD9269_SAMPLE_S00_AXI_SLV_REG3_OFFSET
#define DMA_CNT_OFFSET_ADDR				AD9269_SAMPLE_S00_AXI_SLV_REG4_OFFSET
#define MODULE_EN_OFFSET_ADDR			AD9269_SAMPLE_S00_AXI_SLV_REG5_OFFSET

#define AD9269_SAMPLE_S00_AXI_SLV_REG0_OFFSET 0
#define AD9269_SAMPLE_S00_AXI_SLV_REG1_OFFSET 8
#define AD9269_SAMPLE_S00_AXI_SLV_REG2_OFFSET 16
#define AD9269_SAMPLE_S00_AXI_SLV_REG3_OFFSET 24
#define AD9269_SAMPLE_S00_AXI_SLV_REG4_OFFSET 32
#define AD9269_SAMPLE_S00_AXI_SLV_REG5_OFFSET 40

#define NAV_UART_BASE                   0x80030000
#define NAV_ALIGN_TIME_LOW32_OFFSET     NAV_UART_S01_AXI_SLV_REG0_OFFSET
#define NAV_ALIGN_TIME_MID32_OFFSET     NAV_UART_S01_AXI_SLV_REG1_OFFSET
#define NAV_ALIGN_TIME_HIG16_OFFSET     NAV_UART_S01_AXI_SLV_REG2_OFFSET
#define NAV_ALIGN_TIME_AVAIL_OFFSET     NAV_UART_S01_AXI_SLV_REG3_OFFSET // ALIGN TIME IS AVAILABLE
#define UART_NAV_DMA_PACK_LEN_OFFSET    NAV_UART_S01_AXI_SLV_REG4_OFFSET     
#define UART_NAV_DMA_START_OFFSET       NAV_UART_S01_AXI_SLV_REG5_OFFSET

#define NAV_UART_S01_AXI_SLV_REG0_OFFSET      0
#define NAV_UART_S01_AXI_SLV_REG1_OFFSET      4
#define NAV_UART_S01_AXI_SLV_REG2_OFFSET      8
#define NAV_UART_S01_AXI_SLV_REG3_OFFSET      12
#define NAV_UART_S01_AXI_SLV_REG4_OFFSET      16
#define NAV_UART_S01_AXI_SLV_REG5_OFFSET      20

/************************** Variable Definitions *****************************/
#define RF_OSC_FREQ_MHz  100
#define PL_CLK_FREQ     100000000

#define ZYNQMP_GPIO_BASE 338

#define GPIO_INPUT      0
#define GPIO_OUTPUT     1
/************************** Function Prototypes ******************************/
void ZynqMPGpio_ExportPin(int PinName);
void ZynqMPGpio_SetPinDirection(int PinName, uint8_t Direction);
void ZynqMPGpio_WritePin(int PinName, uint8_t Value);
uint8_t ZynqMPGpio_ReadPin(int PinName);
// void ZynqMP_Out32(uint32_t Addr, uint32_t RegOffset, uint32_t Value);

void Platform_ResetPL(void);
void Platform_Init(volatile uint64_t*,volatile uint64_t*,volatile uint64_t*);
void Platform_SetDefaultParam(void);
void Platform_SubmodulesInit(void);
int Platform_SetRadarPRF(uint32_t PRF_Hz_new, uint32_t PulseWidth_us_new);
void Platform_SetSampleRate(uint8_t SampleRate_MHz_new);

#endif
