#ifndef _ADC_SAMPLE_CTRL_H_
#define _ADC_SAMPLE_CTRL_H_
/***************************** Include Files *********************************/
#include "platform.h"

/*************************** Macro  Definitions ******************************/
#define MAX_DMA_LEN      0x20000000 /* DMA max length in byte */  // 513MB
// #define MAX_DMA_PACK_LEN 100000 /* DMA max pack length in byte */
// #define MAX_DMA_PACK_BYTES 200000 

// uint32_t DMA_pack_num;
// uint32_t DMA_pack_cnt_CH0, DMA_pack_cnt_CH1;
// uint32_t DMA_last_pack_len;


#define DMA_STATUS_FINISHED 1
#define DMA_STATUS_UNFINISHED 0

uint16_t CH0DmaRxBuffer[MAX_DMA_LEN/sizeof(uint16_t)];
/************************** Function Prototypes ******************************/
int Sample_Start(volatile uint64_t* sample_len_reg, volatile uint64_t* sample_start_reg, unsigned char* nav_uart_base, volatile uint64_t* module_en_reg, volatile uint64_t* dma_pack_len_reg);
// static inline void s2mm_clear_sr(volatile uint32_t* axidma_base);
//int ADC_DMA_init();

#endif