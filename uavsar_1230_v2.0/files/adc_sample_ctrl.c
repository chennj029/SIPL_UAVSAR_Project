#include "adc_sample_ctrl.h"
#include "main.h"
#include "platform.h"
#include "axi_dma_ctrl.h"

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <time.h>
#include <poll.h>
#include <pthread.h>
#include <semaphore.h>
#include <errno.h>

// ---------------- 文件头结构体定义 ----------------
#pragma pack(push, 1)
typedef struct {
    char align_time[11];
    double start_freq; // 起始频率，GHz
    double stop_freq;  // 终止频率，GHz
    double pulse_width; // 脉宽，ms
    uint32_t prf;       // 脉冲重复频率，Hz   
    int32_t  vga_gain;  // VGA增益，dB
    double sample_rate; // 采样率，MHz
    uint32_t sample_time; // 采样时间，s
    uint64_t sample_len; // 采样点数
    uint64_t Nr;            // 距离向点数
    uint64_t Na;            // 方位向点数
    double  lambda;         // 波长，m

} header_t;
#pragma pack(pop)

// ---------------- DMA乒乓缓存配置 ----------------
#define PING_PONG_NUM    4

// 乒乓文件控制结构体
typedef struct {
    void* buffers[PING_PONG_NUM];   // 乒乓块
    volatile size_t actual_bytes[PING_PONG_NUM]; // 每个Block实际存储的数据量
    int write_to_disk_idx;  // 当前写入磁盘的Block索引
    sem_t sem_disk_ready;   // 通知磁盘线程：Buffer已填满可写盘
    sem_t sem_buffer_free;  // 通知主线程：Buffer已存盘可覆盖
    FILE* fp;               // 文件指针
    volatile int running;   // 运行标志
} pp_file_ctrl_t;

pp_file_ctrl_t pp_file;

// 磁盘写入线程：负责将填满的乒乓块写入NVMe
// void* disk_writer_thread(void* arg) {
//     while (pp_file.running || sem_trywait(&pp_file.sem_disk_ready) == 0) {
//         // 等待有数据可写盘
//         if (sem_wait(&pp_file.sem_disk_ready) != 0) break;
        
//         int idx = pp_file.write_to_disk_idx; // 当前要写入磁盘的Block索引
//         if (pp_file.actual_bytes[idx] > 0) {
//             fwrite(pp_file.buffers[idx], 1, pp_file.actual_bytes[idx], pp_file.fp);
//         }
        
//         // 通知主线程该Block已空闲，可以覆盖了，并且切换到下一个Block
//         pp_file.write_to_disk_idx = (pp_file.write_to_disk_idx + 1) % PING_PONG_NUM;
//         sem_post(&pp_file.sem_buffer_free); 
//     }
//     return NULL;
// }
void* disk_writer_thread(void* arg) {
    struct sched_param param;
    param.sched_priority = 80;
    pthread_setschedparam(pthread_self(), SCHED_FIFO, &param);


    while (1) {
        sem_wait(&pp_file.sem_disk_ready);

        // 如果被唤醒发现运行标志已关，且确实没数据了，直接退出
        int sval;
        sem_getvalue(&pp_file.sem_disk_ready, &sval);
        if (pp_file.running == 0 && sval == 0 && pp_file.actual_bytes[pp_file.write_to_disk_idx] == 0) {
            break;
        }

        int idx = pp_file.write_to_disk_idx;
        if (pp_file.actual_bytes[idx] > 0) {
            size_t n = fwrite(pp_file.buffers[idx], 1, pp_file.actual_bytes[idx], pp_file.fp);
            printf("write %d bytes to SSD.\n", n);
            // 写完后立即清零，防止哨兵信号导致重复写入
            pp_file.actual_bytes[idx] = 0; 
        }

        pp_file.write_to_disk_idx = (pp_file.write_to_disk_idx + 1) % PING_PONG_NUM;
        sem_post(&pp_file.sem_buffer_free);

        // 再次检查退出条件
        if (pp_file.running == 0 && sval == 0) break;
    }
    printf("Disk writer thread exited safely.\n");
    return NULL;
}

int Sample_Start(volatile uint64_t* sample_len_reg, volatile uint64_t* sample_start_reg, 
                unsigned char* nav_uart_base, volatile uint64_t* module_en_reg, volatile uint64_t* dma_pack_len_reg)
{
    // 1. 初始化和内存分配
    // 创建雷达回波数据文件
    char sample_datas_file[100];
    snprintf(sample_datas_file, 100, "/media/nvmefs/radar_data_%s.bin", timestamp);
    pp_file.fp = fopen(sample_datas_file, "wb+");
    if(!pp_file.fp) return -errno;

    // 先写一个空的 Header 占位，让后续的数据写在正确的位置
    header_t dummy_header;
    memset(&dummy_header, 0, sizeof(header_t));
    fwrite(&dummy_header, 1, sizeof(header_t), pp_file.fp);
    fflush(pp_file.fp);

    // 创建乒乓缓冲区
    size_t block_size = (size_t)20 * PulseWidth_us * SampleRate_MHz * 2; // 20个脉冲的数据量，单位字节，也是一包DMA的数据量，不能超过64MB
    for(int i=0; i<PING_PONG_NUM; i++) {
        // posix_memalign(&pp_file.buffers[i], 4096, block_size);    
        pp_file.actual_bytes[i] = 0; // 明确初始化为0        
    }
    sem_init(&pp_file.sem_buffer_free, 0, PING_PONG_NUM);  // 初始时所有Buffer均为空闲
    sem_init(&pp_file.sem_disk_ready, 0, 0); // 初始时无数据可写盘
    pp_file.write_to_disk_idx = 0;
    pp_file.running = 1;


    // 2. 硬件映射
    int fd = open("/dev/adc0", O_RDWR);
    struct dma_buffer_info dst_buf_info;
    // uint32_t Max_Dma_Pack_Bytes = 1 * PulseWidth_us * SampleRate_MHz * 2;
    uint32_t Max_Dma_Pack_Bytes = (uint32_t)block_size;  ///////////////// add //////////////////  一包DMA等于一个乒乓块的大小
    uint32_t Dma_dst_buf_size = PING_PONG_NUM * block_size;  ///////////////// add //////////////////

    // ioctl(fd, AXI_ADC_SET_DMA_LEN_BYTES, Max_Dma_Pack_Bytes);   
    // ioctl(fd, AXI_ADC_DMA_INIT, 0);  
    // ioctl(fd, AXI_ADC_DMA_GET_BUFFER_INFO, &dst_buf_info);
    // void* dma_dst_buffer = mmap(NULL, dst_buf_info.size, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
    ioctl(fd, AXI_ADC_SET_DMA_LEN_BYTES, Dma_dst_buf_size);   ///////////////// add //////////////////
    ioctl(fd, AXI_ADC_DMA_INIT, 0);  ///////////////// add //////////////////
    ioctl(fd, AXI_ADC_DMA_GET_BUFFER_INFO, &dst_buf_info);   ///////////////// add //////////////////
    void* dma_dst_buffer = mmap(NULL, dst_buf_info.size, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);   ///////////////// add //////////////////
    // 把写硬盘的乒乓操作区直接指向DMA目标内存区
    // pp_file.buffers[0] = dma_dst_buffer;  ///////////////// add //////////////////
    // pp_file.buffers[1] = (uint8_t*)dma_dst_buffer + block_size;  ///////////////// add //////////////////
    for(int i = 0;i < PING_PONG_NUM;i++){
        pp_file.buffers[i] = (uint8_t*)dma_dst_buffer + (i*block_size);
    }

    int mem_fd = open("/dev/mem", O_RDWR|O_SYNC);
    volatile uint32_t* axidma_base = (volatile uint32_t*)mmap(NULL, 0x10000, PROT_READ|PROT_WRITE, MAP_SHARED, mem_fd, 0x80010000);

    // 创建磁盘写入线程
    pthread_t disk_tid;
    pthread_create(&disk_tid, NULL, disk_writer_thread, NULL);


    // 3. 开启ADC采集
    size_t total_remaining = (size_t)sample_len * 2;
    int current_pp_idx = 0; // 当前正在进行DMA写入的乒乓块索引

    *sample_len_reg = sample_len;
    *sample_start_reg = 1;
    *module_en_reg = 0; 
    usleep(10); 
    *module_en_reg = 1; 
    *sample_start_reg = 0;


    // 4. 核心连续传输逻辑
    while (total_remaining > 0) {
        // 等待当前的乒乓块已被磁盘线程释放
        sem_wait(&pp_file.sem_buffer_free);
        
        size_t block_filled_size = 0;

        // 进行第一个乒乓块的DMA数据填充
        while (block_filled_size < block_size && total_remaining > 0) {
            size_t this_dma_size = (total_remaining < Max_Dma_Pack_Bytes) ? total_remaining : Max_Dma_Pack_Bytes; // 本次DMA传输大小，一个脉冲的数据
            // 更新DMA搬运的目标基地址，在两个block之间切换
            // 必须加上block_filled_size偏移，应对最后一包可能不足一个block_size的情况
            uint64_t dma_phys_addr = (uint64_t)dst_buf_info.phys_addr + ((uint64_t)current_pp_idx * block_size) + block_filled_size;; /////////////// add //////////////////
            // 配置并启动DMA
            *dma_pack_len_reg = this_dma_size / 2;
            // XAXIDMA_SimpleTransfer(axidma_base, dst_buf_info.phys_addr, this_dma_size);
            XAXIDMA_SimpleTransfer(axidma_base, (unsigned long)dma_phys_addr, this_dma_size);  /////////////// add //////////////////
            *module_en_reg |= (1u << 1); // DMA Start
            *module_en_reg &= ~(1u << 1);

            // 【关键点】在等待本轮DMA完成时，硬件正在搬运
            dma_s2mm_idle(axidma_base); 

            // DMA一完成，立即把数据拷贝到后台Buffer，以便DMA腾空dst_buf继续下一轮
            // 这步memcpy非常快，通常在1ms以内，远快于2ms的脉冲周期
            // memcpy((uint8_t*)pp_file.buffers[current_pp_idx] + block_filled_size, dma_dst_buffer, this_dma_size);
            
            block_filled_size += this_dma_size;
            total_remaining -= this_dma_size;

            // 这里可以添加一个极短的控制，确保硬件逻辑准备好下一次触发
        }

        pp_file.actual_bytes[current_pp_idx] = block_filled_size; // 记录当前乒乓块实际写入的数据量
        sem_post(&pp_file.sem_disk_ready); // 提交给磁盘线程处理，磁盘可以写入该块数据
        current_pp_idx = (current_pp_idx + 1) % PING_PONG_NUM; // 切换到下一个乒乓块，进行DMA传输
    }

    usleep(100000); //////////////// add ///////////////////  delay quit to reserve the last package
    // 5. 退出
    pp_file.running = 0;
    // 【关键修改】发送一个“哨兵”信号唤醒可能正阻塞在 sem_wait 的写线程
    // 即使此时没有新数据，也要让它醒来检查 running 标志
    sem_post(&pp_file.sem_disk_ready);      ///////// add
    pthread_join(disk_tid, NULL);
    fflush(pp_file.fp);             ///////// add
    fsync(fileno(pp_file.fp));      ////////  add

    // 6. 写入最终文件头
    if(time_align_thread_running){
        pthread_join(time_align_thread_id, NULL);
    }
    int c = 3E8;
    // unsigned int s2mm_cr_reg, s2mm_sr_reg;
    header_t header;
    // header.align_time = align_time;
    memcpy(header.align_time, align_time, sizeof header.align_time);
    header.start_freq = (double)StartFreq_kHz / 1E6;
    header.stop_freq = (double)StopFreq_kHz / 1E6;
    header.pulse_width = (double)PulseWidth_us / 1E3;
    header.prf = (uint32_t)PRF_Hz;
    header.vga_gain = (int32_t)VGA_Gain_dB;
    header.sample_rate = SampleRate_MHz;
    header.sample_time = sample_time_s;
    header.sample_len = sample_len;
    header.lambda = c / (StopFreq_kHz / 2 + StartFreq_kHz / 2) / 1E3;
    header.Nr = SampleRate_MHz * PulseWidth_us;
    header.Na = sample_time_s * PRF_Hz;
    // 回到文件开头覆盖 Dummy Header
    fseek(pp_file.fp, 0, SEEK_SET);
    fwrite(&header, 1, sizeof(header_t), pp_file.fp);

    // 7. 清理资源
    fclose(pp_file.fp);
    // for(int i=0; i<PING_PONG_NUM; i++) free(pp_file.buffers[i]);   /////// add /////// 这里要删除对dma缓冲区的释放，否则会导致后续使用出错
    munmap(dma_dst_buffer, dst_buf_info.size);
    ioctl(fd, AXI_ADC_DMA_DEINIT);
    close(fd);
    close(mem_fd);

    return 0;
}