#define _GNU_SOURCE 1
#include "platform.h"
#include "psu_brd.h"
#include "tx_brd.h"
#include "base_brd.h"
#include "acq_brd.h"
#include "eth_tcp.h"
#include "axi_dma_ctrl.h"
#include "adc_sample_ctrl.h"
#include <sys/ioctl.h>
#include <pthread.h>
#include <sched.h>
#include <stdio.h>
#include <unistd.h>
#include <signal.h>
#include <string.h>
#include <stdbool.h>
#include <sys/poll.h>
#include <errno.h>

// static volatile bool uart_dma_pause = false;

static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
// pthread_mutex_lock(&mutex);
// pthread_mutex_unlock(&mutex);

// set CPU affinity
static int set_thread_affinity(pthread_t th, int cpu){
	cpu_set_t set;
	CPU_ZERO(&set);
	CPU_SET(cpu, &set);
	int ret = pthread_setaffinity_np(th, sizeof(set), &set);
	if(ret != 0){
		errno = ret;
		perror("pthread_setaffinity_np");
		return -1;
	}
	return 0;
}

// 全局变量用于控制UART线程
static volatile bool uart_thread_running = true;
static pthread_t uart_thread_id;

// 全局变量用于控制TIME ALIGN线程
volatile bool time_align_thread_running = false;
pthread_t time_align_thread_id;
// static char align_time[11];

// 用于uart_dma_thread线程的参数结构体
typedef struct {
	volatile uint32_t* uart_nav_dma_start;
	volatile uint32_t* uart_nav_dma_pack_len;
} uart_thread_params_t;

void* uart_dma_thread(void* arg){
	// 取回参数
	uart_thread_params_t* params = (uart_thread_params_t*)arg;
	// params->uart_nav_base

	int uart_dma_fd;
	char nav_filename[100];

	uart_dma_fd = open("/dev/uart0", O_RDWR);
	if(uart_dma_fd < 0){
		printf("Can't open /dev/uart0 device!\n");
		// LOGE("uart_dma_thread: Can't open /dev/uart0 device: %s\n", strerror(errno));
		return NULL;
	}

	int mem_fd = open("/dev/mem", O_RDWR | O_SYNC);
	volatile uint32_t* uartdma_base = (volatile uint32_t*)mmap(NULL, 0X10000, PROT_READ | PROT_WRITE, MAP_SHARED, mem_fd, 0x80020000);

	snprintf(nav_filename, sizeof(nav_filename), "/media/nvmefs/nav_data_%s.bin", timestamp_uav);
	FILE *uart_f = fopen(nav_filename, "ab");


	void* uart_dma_dst_buf;
	struct dma_buffer_info dst_buf_info;
	uint32_t uart_dma_pack_bytes = 0x1000;
	uint32_t uart_dma_pack_len = uart_dma_pack_bytes / 4;

    ioctl(uart_dma_fd, AXI_UART_SET_DMA_LEN_BYTES, uart_dma_pack_bytes);   
    ioctl(uart_dma_fd, AXI_UART_DMA_INIT, 0);  
    ioctl(uart_dma_fd, AXI_UART_DMA_GET_BUFFER_INFO, &dst_buf_info);
	uart_dma_dst_buf = mmap(NULL, dst_buf_info.size, PROT_READ | PROT_WRITE, MAP_SHARED, uart_dma_fd, 0);

	while(uart_thread_running){
					
		
		*(params->uart_nav_dma_pack_len) = uart_dma_pack_len;
		// S2MM传输
		pthread_mutex_lock(&mutex);
		if(XAXIDMA_SimpleTransfer(uartdma_base, dst_buf_info.phys_addr, uart_dma_pack_bytes) != 0){
			printf("uart_dma_thread: S2MM transfer failed!\n");
			return NULL;
		} 
		pthread_mutex_unlock(&mutex);
		*(params->uart_nav_dma_start) = 1;
		*(params->uart_nav_dma_start) = 0;
		// 等待传输完成
		// printf("111\n");
		dma_s2mm_idle(uartdma_base);
		// printf("222\n");
		// read_data(uart_dma_dst_buf, uart_dma_pack_len, true);
		fwrite(uart_dma_dst_buf, 1, uart_dma_pack_bytes, uart_f);
		
		// fflush(uart_f);
			
	}
	fflush(uart_f);
	close(uart_dma_fd);

	printf("UART DMA thread stopped!\n");
	return NULL;
}

void* time_align_thread(void* arg){
    unsigned char* nav_uart_base = (unsigned char*)arg;

    volatile uint32_t* nav_align_time_low32_reg  = (volatile uint32_t*)(nav_uart_base + NAV_ALIGN_TIME_LOW32_OFFSET);
    volatile uint32_t* nav_align_time_mid32_reg  = (volatile uint32_t*)(nav_uart_base + NAV_ALIGN_TIME_MID32_OFFSET);
    volatile uint32_t* nav_align_time_high16_reg = (volatile uint32_t*)(nav_uart_base + NAV_ALIGN_TIME_HIG16_OFFSET);
    volatile uint32_t* nav_align_time_avail_reg  = (volatile uint32_t*)(nav_uart_base + NAV_ALIGN_TIME_AVAIL_OFFSET);

	int timeout_cnt = 0;
	const int MAX_TIMEOUT = 5000; // wait 5s

    // 轮询等待 slv_reg3[0] 置1（PL 写好对齐时间）
    while (1) {
        if (*nav_align_time_avail_reg == 1) {
            uint32_t v2 = *nav_align_time_high16_reg;
            uint32_t v1 = *nav_align_time_mid32_reg;
            uint32_t v0 = *nav_align_time_low32_reg;

            char c0 = (char)((v2>>8)  & 0xFF);
            char c1 = (char)( v2      & 0xFF);
            char c5 = (char)( v1      & 0xFF);
            char c4 = (char)((v1>>8)  & 0xFF);
            char c3 = (char)((v1>>16) & 0xFF);
            char c2 = (char)((v1>>24) & 0xFF);
            char c9 = (char)( v0      & 0xFF);
            char c8 = (char)((v0>>8)  & 0xFF);
            char c7 = (char)((v0>>16) & 0xFF);
            char c6 = (char)((v0>>24) & 0xFF);

            align_time[0]  = c0;
            align_time[1]  = c1;
            align_time[2]  = c2;
            align_time[3]  = c3;
            align_time[4]  = c4;
            align_time[5]  = c5;
            align_time[6]  = c6;
            align_time[7]  = c7;
            align_time[8]  = c8;
            align_time[9]  = c9;
            align_time[10] = '\0';

            printf("align time = %s\n", align_time);

            // 读完清零粘滞位（让 PL/PS 形成握手）
            *nav_align_time_avail_reg = 0;
            return NULL;
        }

		usleep(1000); // wait for 1ms
		if(++timeout_cnt > MAX_TIMEOUT){
			printf("Error: time_align_thread timeout!\n");
			strncpy(align_time, "000000.000", 11);
			break;
		}
    }

    return NULL;	
} 
int main(int argc, char* argv[]){
	// setvbuf(stdout, NULL, _IOLBF, 0);
	// bind main() to CPU0
	set_thread_affinity(pthread_self(), 0);

	// 程序统一时间戳
	struct tm *timeinfo;
	time_t rawtime;
	time(&rawtime);
	timeinfo = localtime(&rawtime);
	strftime(timestamp_uav, sizeof(timestamp_uav), "%Y%m%d%H%M%S", timeinfo);


	int uart_fd = open("/dev/ttyPS1", O_RDWR | O_NOCTTY | O_NDELAY );
	if(uart_fd < 0)
	{
		perror("Can't open serial port ttyPS1.\n");
		return -1;
	}
	else{
		fcntl(uart_fd, F_SETFL, 0);
	}
	
	struct termios options;
	tcgetattr(uart_fd, &options);

	// set to original mode
	// options.c_lflag &= ~(ICANON | ECHO | ECHOE | ISIG);
	options.c_lflag &= ~(ICANON | ECHO | ECHOE | ISIG);
	
	// set uart parameters
	cfsetispeed(&options, B9600);
	cfsetospeed(&options, B9600);
	options.c_cflag |= (CLOCAL | CREAD);
	// close hardware flow control
	options.c_cflag &= ~CRTSCTS;

	options.c_iflag &= ~(IXON | IXOFF | IXANY);
	options.c_oflag &= ~OPOST;
	tcsetattr(uart_fd, TCSANOW, &options);

	
	snprintf(send_str, sizeof(send_str), "-------- UAV-SAR is starting. --------\r\n");
	write(uart_fd, send_str, strlen(send_str));
	// printf("-------- UAV-SAR is starting. --------\r\n");

    int mem_fd = open("/dev/mem", O_RDWR | O_SYNC);
    if(mem_fd < 0){
		snprintf(send_str, sizeof(send_str), "!!!!!!!! Open /dev/mem failed. !!!!!!!!\r\n");
        write(uart_fd, send_str, strlen(send_str));
		// printf("!!!!!!!! Open /dev/mem failed. !!!!!!!!\r\n");
        return 1;
    }

	unsigned char* adc_sample_base = (unsigned char*)mmap(NULL, 0X10000, PROT_READ | PROT_WRITE, MAP_SHARED, mem_fd, AD9269_SAMPLE_BASE);
    //printf("mapped adc_sample_base:%p\n", adc_sample_base);
	// if(adc_sample_base == MAP_FAILED){
    //     perror("mmap");
    //     close(mem_fd);
    //     return 1;
    // }
	volatile uint64_t* sample_prt_count_reg = (volatile uint64_t*)(adc_sample_base+PRT_COUNT_OFFSET_ADDR);
    volatile uint64_t* sample_pulse_width_reg = (volatile uint64_t*)(adc_sample_base+PULSE_WIDTH_OFFSET_ADDR);
	volatile uint64_t* sample_module_en_reg = (volatile uint64_t*)(adc_sample_base+MODULE_EN_OFFSET_ADDR);
    volatile uint64_t* sample_start_reg = (volatile uint64_t*)(adc_sample_base+SAMPLE_START_OFFSET_ADDR);
    volatile uint64_t* sample_len_reg = (volatile uint64_t*)(adc_sample_base+SAMPLE_LEN_OFFSET_ADDR);
	volatile uint64_t* dma_pack_len_reg = (volatile uint64_t*)(adc_sample_base+DMA_CNT_OFFSET_ADDR);


	unsigned char* nav_uart_base = (unsigned char*)mmap(NULL, 0x10000, PROT_READ | PROT_WRITE, MAP_SHARED, mem_fd, NAV_UART_BASE);
	// if(nav_uart_base == MAP_FAILED){
    //     perror("mmap");
    //     close(mem_fd);
    //     return 1;
    // }
	volatile uint32_t* uart_nav_dma_pack_len_reg = (volatile uint32_t*)(nav_uart_base + UART_NAV_DMA_PACK_LEN_OFFSET);
	volatile uint32_t* uart_nav_dma_start_reg = (volatile uint32_t*)(nav_uart_base + UART_NAV_DMA_START_OFFSET);
	static uart_thread_params_t uart_params;
	uart_params.uart_nav_dma_start = uart_nav_dma_start_reg;
	uart_params.uart_nav_dma_pack_len = uart_nav_dma_pack_len_reg;


	Platform_Init(sample_module_en_reg, sample_prt_count_reg, sample_pulse_width_reg);
	write(uart_fd, send_str, strlen(send_str));
	// printf("-------- Platform initialization done. --------\r\n");


    // 创建UART DMA线程
    if (pthread_create(&uart_thread_id, NULL, uart_dma_thread, &uart_params) != 0) {
		snprintf(send_str, sizeof(send_str), "!!!!!!!! Failed to create UART DMA thread !!!!!!!!\r\n");
        write(uart_fd, send_str, strlen(send_str));
		// printf("!!!!!!!! Failed to create UART DMA thread !!!!!!!!\r\n");
        return 1;
    }	
	set_thread_affinity(uart_thread_id, 1);

	// set state
	int uart_read;
	char state_buf[256];
	while(1){
		snprintf(send_str, sizeof(send_str), "**** Please send 'set xx xx...' to set system parameters. ****\r\n");
		write(uart_fd, send_str, strlen(send_str));
		// printf("**** Please send 'set xx xx...' to set system parameters. ****\r\n");
		snprintf(send_str, sizeof(send_str), "**** or send 'sample' to start sampling. ****\r\n");
		write(uart_fd, send_str, strlen(send_str));
		// printf("**** or send 'sample' to start sampling. ****\r\n");

		uart_read = read(uart_fd, state_buf, sizeof(state_buf));
		// switch_state2(state_buf, uart_read);
		if(uart_read > 0){
			if(*state_buf != '\n'){
				state_buf[uart_read] = '\0';
				if(state_buf[uart_read - 1] == '\n'){
					state_buf[uart_read - 1] = '\0';	
				}
					
			}
			
			if(strncmp(state_buf, "set ", 4) == 0){
				int temp_StartFreq, temp_StopFreq, temp_VGA_Gain, temp_PulseWidth, temp_PRF, temp_SampleTime;
				double temp_SampleRate;
				int item_scanned = sscanf(state_buf+4,"%d %d %d %d %d %lf %d",&temp_StartFreq, &temp_StopFreq, &temp_VGA_Gain, &temp_PulseWidth, &temp_PRF, &temp_SampleRate, &temp_SampleTime);
				if(item_scanned == 7){
					StartFreq_kHz = temp_StartFreq;
					StopFreq_kHz = temp_StopFreq;
					VGA_Gain_dB = temp_VGA_Gain;	
					PulseWidth_us = temp_PulseWidth;
					PRF_Hz = temp_PRF;
					SampleRate_MHz = temp_SampleRate;
					sample_time_s = temp_SampleTime;

					state = S_SET_PARAM;

					snprintf(send_str, sizeof(send_str), "**** Receive SET command. ****\r\n");
					write(uart_fd, send_str, strlen(send_str));
					// printf("**** Receive SET command. ****\r\n");

				}
				else{
					snprintf(send_str, sizeof(send_str), "!!!!!!!! Error: 'set' command requires 7 parameters. !!!!!!!!\r\n");
					write(uart_fd, send_str, strlen(send_str));
					// printf("!!!!!!!! Error: 'set' command requires 7 parameters. !!!!!!!!\r\n");
				}
			}
			else if(strcmp(state_buf, "sample") == 0){
				state = S_START_SAMPLE;

				snprintf(send_str, sizeof(send_str), "**** Receive 'sample' command. ****\r\n");
				write(uart_fd, send_str, strlen(send_str));
				// printf("**** Receive 'sample' command. ****\r\n");
			}
			else{
				snprintf(send_str, sizeof(send_str), "!!!!!!!! Unknown command. !!!!!!!!\r\n");
				write(uart_fd, send_str, strlen(send_str));
				// printf("**** Receive 'sample' command. ****\r\n");
			}
		}
		

		if(state == S_SET_PARAM){
			prt_count = SampleRate_MHz * 1e6 / PRF_Hz;
			pulse_width = SampleRate_MHz * PulseWidth_us;
			sample_len = SampleRate_MHz * PulseWidth_us * sample_time_s * PRF_Hz;
			Nr = SampleRate_MHz * PulseWidth_us;
			Na = sample_time_s * PRF_Hz;
			lambda = 3e8 / (StopFreq_kHz/2.0 + StartFreq_kHz/2.0);

			snprintf(send_str, sizeof(send_str), "**** Params setting finish:\r\n");
			write(uart_fd, send_str, strlen(send_str));
			// printf("**** Params setting finish:\r\n");
			snprintf(send_str, sizeof(send_str), "**** StartFreq = %d kHz \r\n", StartFreq_kHz);
			write(uart_fd, send_str, strlen(send_str));
			// printf("**** StartFreq = %d kHz \r\n", StartFreq_kHz);
			snprintf(send_str, sizeof(send_str), "**** StopFreq = %d kHz \r\n", StopFreq_kHz);
			write(uart_fd, send_str, strlen(send_str));
			// printf("**** StopFreq = %d kHz \r\n", StopFreq_kHz);
			snprintf(send_str, sizeof(send_str), "**** VGA Gain = %d dB \r\n", VGA_Gain_dB);
			write(uart_fd, send_str, strlen(send_str));
			// printf("**** VGA Gain = %d dB \r\n", VGA_Gain_dB);
			snprintf(send_str, sizeof(send_str), "**** Pulse Width = %d us \r\n", PulseWidth_us);
			write(uart_fd, send_str, strlen(send_str));
			// printf("**** Pulse Width = %d us \r\n", PulseWidth_us);
			snprintf(send_str, sizeof(send_str), "**** PRF = %d Hz \r\n", PRF_Hz);
			write(uart_fd, send_str, strlen(send_str));
			// printf("**** PRF = %d Hz \r\n", PRF_Hz);
			snprintf(send_str, sizeof(send_str), "**** Sample Rate = %.2f MHz \r\n", SampleRate_MHz);
			write(uart_fd, send_str, strlen(send_str));
			// printf("**** Sample Rate = %.2f MHz \r\n", SampleRate_MHz);
			snprintf(send_str, sizeof(send_str), "**** Sample time = %d s \r\n", sample_time_s);
			write(uart_fd, send_str, strlen(send_str));
			// printf("**** Sample time = %d s \r\n", sample_time_s);
			snprintf(send_str, sizeof(send_str), "**** Sample length = %ld points \r\n", sample_len);
			write(uart_fd, send_str, strlen(send_str));
			// printf("**** Sample length = %d points \r\n", sample_len);
			snprintf(send_str, sizeof(send_str), "**** PRT Count points = %ld \r\n", prt_count);
			write(uart_fd, send_str, strlen(send_str));
			// printf("**** PRT Count points = %d \r\n", prt_count);
			snprintf(send_str, sizeof(send_str), "**** Pulse Width points = %ld \r\n", pulse_width);
			write(uart_fd, send_str, strlen(send_str));
			// printf("**** Pulse Width points = %d \r\n", pulse_width);
			snprintf(send_str, sizeof(send_str), "**** Nr = %d  Na = %d \r\n", Nr, Na);
			write(uart_fd, send_str, strlen(send_str));
			// printf("**** Nr = %d  Na = %d \r\n", Nr, Na);


			AD9508_SetOutputFreq(SampleRate_MHz);
			ADL5205_SPIGainCtrl(VGA_Gain_dB, 0);
			LMX2492_SetRampParam(StartFreq_kHz, StopFreq_kHz, PulseWidth_us);

			// printf("----- begin reset 0 ------\n");
			// uart_dma_pause = true;
			// Platform_ResetPL();  //// adddddddddddd
			// printf("----- end   reset 0 ------\n");
			*sample_module_en_reg = 0;
			usleep(1000);
			// printf("----- begin reset 1 ------\n");
			// Platform_ResetPL();
			// uart_dma_pause = false;
			// printf("----- end   reset 1 ------\n");
			*sample_prt_count_reg = prt_count;
			*sample_pulse_width_reg = pulse_width;
			usleep(1000);
			*sample_module_en_reg = 1;

			snprintf(send_str, sizeof(send_str), "**** Parameters have been written to hardware. ****\r\n");
			write(uart_fd, send_str, strlen(send_str));
			// printf("**** Parameters have been written to hardware. ****\r\n");
			state = S_IDLE;
		}

		else if(state == S_START_SAMPLE){
			time(&rawtime);
			timeinfo = localtime(&rawtime);
			strftime(timestamp, sizeof(timestamp), "%Y%m%d%H%M%S", timeinfo);
			snprintf(send_str, sizeof(send_str), "**** Start Sample... ****\r\n");
			write(uart_fd, send_str, strlen(send_str));
			// printf("**** Start Sample... ****\r\n");
			// Platform_ResdsssssssssssssssssssssssssssssssssssssssssssssssetPL();
			if(!time_align_thread_running){
				time_align_thread_running = true;
				if(pthread_create(&time_align_thread_id, NULL, time_align_thread, nav_uart_base) != 0){
					perror("pthread_create time_align_thread");
					time_align_thread_running = false;
				}
			}

			Sample_Start(sample_len_reg, sample_start_reg, nav_uart_base, sample_module_en_reg, dma_pack_len_reg);
			// time_align_thread_running = false;

			///////////// add
			pthread_join(time_align_thread_id, NULL);
			time_align_thread_running = false;
			
			
			snprintf(send_str, sizeof(send_str), "**** Sampling finished! ****\r\n");
			write(uart_fd, send_str, strlen(send_str));
			// printf("**** Sampling finished! ****\r\n");
			state = S_IDLE;
					
		}
	}
    
    // 清理资源：停止UART线程并等待其结束
    uart_thread_running = false;
    pthread_join(uart_thread_id, NULL);
	pthread_mutex_destroy(&mutex);

    if(munmap(adc_sample_base, 0x10000)==-1 || munmap(nav_uart_base, 0x10000)==-1){
        perror("munmap");
    }
	close(mem_fd);

    return 0;
	
}