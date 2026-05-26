#ifndef _UAVSAR_H_
#define _UAVSAR_H_
/***************************** Include Files *********************************/
#include "platform.h"
#include <stdint.h>

#include <stdio.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/fcntl.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/socket.h> 
#include <sys/wait.h>
#include <pthread.h>
#include <termios.h> /* PPSIX terminal control*/
#include <poll.h>
#include <sys/stat.h>
/*************************** Macro  Definitions ******************************/
//#define USE_PLL_HMC703
#define USE_PLL_LMX2492
/************************** Variable Definitions *****************************/

double SampleRate_MHz;
uint8_t VGA_Gain_dB;
uint16_t sample_time_s;   /////////////////
// unused
uint8_t rail_traval_x, rail_direction_x;
uint8_t rail_traval_y, rail_direction_y;
uint8_t rail_speed;

uint16_t PRF_Hz;
uint16_t PulseWidth_us;

uint64_t prt_count;
uint64_t pulse_width;
uint32_t StartFreq_kHz;
uint32_t StopFreq_kHz;
uint64_t sample_len;	//total sample points
uint32_t start_int;
uint32_t start_frac;
uint32_t stop_int;
uint32_t stop_frac;
uint32_t step;

uint32_t  Nr;
uint32_t  Na;
double    lambda;
char align_time[11];

char timestamp_uav[50];
char timestamp[50]; // 文件命名的统一时间戳

char send_str[100];

uint8_t state;


extern volatile bool time_align_thread_running;
extern pthread_t time_align_thread_id;

#define S_IDLE                    0
#define S_SET_PARAM               1
#define S_WRITE_PARAM             2
#define S_START_SAMPLE            3

// char nav_buffer[4096];
/************************** Function Prototypes ******************************/

#endif