#ifndef _AXI_DMA_CTRL_H_
#define _AXI_DMA_CTRL_H_
/***************************** Include Files *********************************/
#include "platform.h"

/*************************** Macro  Definitions ******************************/


#define AXI_ADC_SET_SAMPLE_NUM          _IO('W', 0)
#define AXI_ADC_SET_DMA_LEN_BYTES       _IO('W', 1)
#define AXI_ADC_DMA_INIT                _IO('W', 2)
#define AXI_ADC_DMA_GET_BUFFER_INFO     _IOR('W', 3, struct dma_buffer_info)
#define AXI_ADC_DMA_DEINIT              _IO('W', 4)

#define AXI_UART_SET_SAMPLE_NUM          _IO('X', 0)
#define AXI_UART_SET_DMA_LEN_BYTES       _IO('X', 1)
#define AXI_UART_DMA_INIT                _IO('X', 2)
#define AXI_UART_DMA_GET_BUFFER_INFO     _IOR('X', 3, struct dma_buffer_info)

/* AXI DMA通道寄存器定义 */
/*
DMA控制寄存器（CR）：
DMA Control Register (CR):
Bit 0: RUNSTOP - 运行/停止控制
       0 = 停止DMA操作
       1 = 启动DMA操作
Bit 2: RESET - 复位控制
       1 = 复位DMA通道（自清零）
Bit 12: IOC_IrqEn - 传输完成中断使能
Bit 13: Dly_IrqEn - 延迟中断使能
Bit 14: Err_IrqEn - 错误中断使能
Bit 15: IOC_IrqEn - IOC中断使能
*/
#define XAXIDMA_MM2S_OFFSET 0x00000000      // MM2S通道寄存器基地址
#define XAXIDMA_S2MM_OFFSET 0x00000030     // S2MM通道寄存器基地址

#define XAXIDMA_CR_RESET_MASK 0x00000004   // 控制寄存器的reset位掩码
#define XAXIDMA_CR_RUNSTOP_MASK 0x00000001 // 控制寄存器的run/stop位掩码
#define XAXIDMA_SR_HALTED_MASK 0x00000001    // 状态寄存器的halted位掩码
#define XAXIDMA_SR_IDLE_MASK 0x00000002        // 状态寄存器的idle位掩码

#define XAXIDMA_CR_OFFSET 0x00000000    // 控制寄存器偏移
#define XAXIDMA_SR_OFFSET 0x00000004    // 状态寄存器偏移
#define XAXIDMA_SRCADDR_OFFSET 0x00000018 // 源地址寄存器偏移
#define XAXIDMA_SRCADDR_MSB_OFFSET 0x0000001C // 源地址高32位寄存器偏移
#define XAXIDMA_DESTADDR_OFFSET 0x00000018 // 目的地址寄存器偏移
#define XAXIDMA_DESTADDR_MSB_OFFSET 0x0000001C // 目的地址高32位寄存器偏移
#define XAXIDMA_BUFFLEN_OFFSET 0x00000028 // 缓冲区长度寄存器偏移



struct dma_buffer_info {
    unsigned long phys_addr;
    size_t size;
};


/************************** Function Prototypes ******************************/
// void dma_mmap(uint32_t dma_malloc_bytes, void* dma_dst_buffer, struct dma_buffer_info dst_buf_info);
void dma_write(volatile uint32_t* axidma_base_addr, int reg_offset, unsigned int value);
unsigned int dma_read(volatile uint32_t* axidma_base_addr, int reg_offset);
// void read_data(void* address, int byte_length);
void read_data(void* address, size_t bytes, bool isContinue);
void dma_status_read(volatile uint32_t* axidma_base_addr);
int dma_s2mm_idle(volatile uint32_t* axidma_base_addr);
int dma_mm2s_idle(volatile uint32_t* axidma_base_addr);
void load_data(void* address, int byte_length);

// 新增函数
int XAXIDMA_Reset(volatile uint32_t* axidma_base_addr);
int XAXIDMA_Reset_Isdone(volatile uint32_t* axidma_base_addr);
int XAXIDMA_SimpleTransfer(volatile uint32_t* axidma_base_addr, unsigned long buff_addr, unsigned int length);
int XAXIDMA_Busy(volatile uint32_t* axidma_base_addr);

#endif