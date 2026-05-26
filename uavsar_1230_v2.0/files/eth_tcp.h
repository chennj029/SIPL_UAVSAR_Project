#ifndef _ETH_TCP_H_
#define _ETH_TCP_H_
/***************************** Include Files *********************************/
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/fcntl.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/wait.h>
#include <pthread.h>
/************************** Variable Definitions *****************************/
// #define S_IDLE                    0
// #define S_WAIT_UART_STAGE1        1
// #define S_SET_PARAM               2
// #define S_WAIT_UART_STAGE2        3
// #define S_START_SAMPLE            4

/************************** Function Prototypes ******************************/
int tcp_init();
void switch_state(uint8_t recv_buf[], int recv_size);
void switch_state2(char uart_recv_buf[], int uart_bytes_read);
#endif