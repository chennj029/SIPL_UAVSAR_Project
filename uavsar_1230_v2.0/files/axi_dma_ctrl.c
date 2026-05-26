#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <fcntl.h>
#include <termios.h>
#include <sys/mman.h>
#include <sys/ioctl.h>
#include <string.h>

#include "axi_dma_ctrl.h"


void dma_write(volatile uint32_t* axidma_base_addr, int reg_offset, unsigned int value) 
{
    axidma_base_addr[reg_offset>>2] = value;
}
unsigned int dma_read(volatile uint32_t* axidma_base_addr, int reg_offset)
{
    return axidma_base_addr[reg_offset>>2];
}

int dma_s2mm_idle(volatile uint32_t* axidma_base_addr) 
{
    unsigned int s2mm_status = dma_read(axidma_base_addr, XAXIDMA_S2MM_OFFSET+XAXIDMA_SR_OFFSET);
    while(!(s2mm_status & XAXIDMA_SR_IDLE_MASK)){
        s2mm_status = dma_read(axidma_base_addr, XAXIDMA_S2MM_OFFSET+XAXIDMA_SR_OFFSET);
    }
    return 0;
}

// void read_data(void* address, int byte_length) 
// {
//     int *addr = address;
//     int reg_offset;
//     for (reg_offset = 0; reg_offset < byte_length/4; reg_offset+=4) {
//         printf("%x\t", addr[reg_offset]);
//     }
//     printf("\n");
// }

void read_data(void* address, size_t bytes, bool isContinue){
    const uint16_t* p = (const uint16_t*)address;
    if(!isContinue){
        FILE* f = fopen("data1.txt", "w");
        for(size_t i = 0;i < bytes;i++){
            fprintf(f, "%u%s", (unsigned)p[i], (i%16==15)?"\n":" ");
        }
        if(bytes % 16) fputc('\n', f);

        fclose(f);
    }
    else{
        FILE* f = fopen("data.txt", "a");
        for(size_t i = 0;i < bytes;i++){
            fprintf(f, "%u%s", (unsigned)p[i], (i%16==15)?"\n":" ");
        }
        if(bytes % 16) fputc('\n', f);

        fclose(f);
    }

}

void load_data(void* address, int byte_length) 
{
    int *addr = address;
    int reg_offset;
    for (reg_offset = 0; reg_offset < byte_length/4; reg_offset+=4) {
		addr[reg_offset]=0x12345678+reg_offset;
        printf("%x\t", addr[reg_offset]); 
    }
    printf("\n");
}

int XAXIDMA_Reset(volatile uint32_t* axidma_base_addr)
{
    // 复位S2MM通道
    dma_write(axidma_base_addr, XAXIDMA_S2MM_OFFSET, XAXIDMA_CR_RESET_MASK);
    int timeout = 1000;
    // 检查复位情况
    while(timeout){
        if(XAXIDMA_Reset_Isdone(axidma_base_addr)){
            break;
        }
        timeout--;
        usleep(10);
    }

    if(!timeout){
        printf("DMA S2MM reset failed\n");
        return -1;
    }

    return 0;
}

int XAXIDMA_Reset_Isdone(volatile uint32_t* axidma_base_addr)
{
    unsigned int s2mm_cr = dma_read(axidma_base_addr, XAXIDMA_S2MM_OFFSET);
    if(s2mm_cr & XAXIDMA_CR_RESET_MASK){
        return 0;
    }
    return 1;
}

int XAXIDMA_SimpleTransfer(volatile uint32_t* axidma_base_addr, unsigned long buff_addr, unsigned int length)
{
//    unsigned int s2mm_sr = dma_read(axidma_base_addr, XAXIDMA_S2MM_OFFSET+XAXIDMA_SR_OFFSET);
//    if(s2mm_sr & XAXIDMA_SR_HALTED_MASK){
//        if(XAXIDMA_Busy(axidma_base_addr)){
//            printf("DMA channel is busy, transfer not started\n");
 //           return -1;
 //       }
 //   }
     usleep(1000);

    // 配置目标地址寄存器
    dma_write(axidma_base_addr, XAXIDMA_S2MM_OFFSET + XAXIDMA_DESTADDR_OFFSET, (unsigned int)(buff_addr & 0xFFFFFFFF));
    // 启动DMA通道
    unsigned int current_s2mm_cr = dma_read(axidma_base_addr, XAXIDMA_S2MM_OFFSET + XAXIDMA_CR_OFFSET);
    dma_write(axidma_base_addr, XAXIDMA_S2MM_OFFSET + XAXIDMA_CR_OFFSET, current_s2mm_cr | XAXIDMA_CR_RUNSTOP_MASK);
    // 配置传输长度寄存器，启动传输
    dma_write(axidma_base_addr, XAXIDMA_S2MM_OFFSET + XAXIDMA_BUFFLEN_OFFSET, length);

    return 0;
}
int XAXIDMA_Busy(volatile uint32_t* axidma_base_addr)
{
    unsigned int status = dma_read(axidma_base_addr, XAXIDMA_S2MM_OFFSET + XAXIDMA_SR_OFFSET);
    
    if(status & XAXIDMA_SR_IDLE_MASK){ // 检查传输完成位
        return 0; // 不忙
    }else{
        return 1; // 忙
    }
}