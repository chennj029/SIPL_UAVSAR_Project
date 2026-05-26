#include "main.h"
#include "eth_tcp.h"

#define SERVER_PORT			7	
#define LISENT_NUM			10

int tcp_init(){
	int sfd, cfd;//server socket fd & client socket fd
	struct sockaddr_in clientaddr;
	struct sockaddr_in serveraddr;
	// uint8_t* buff = (uint8_t*)malloc(1024*sizeof(uint8_t));
	int size = sizeof(struct sockaddr);
	// pthread_t client_thread[LISENT_NUM];

	if ((sfd = socket(AF_INET, SOCK_STREAM, 0)) == -1)
	{
		perror("socket");
		exit(-1);
	}
 
	memset(&serveraddr, 0, sizeof(struct sockaddr)); //Clear serveraddr memory block
	serveraddr.sin_family = AF_INET; //IPv4
	serveraddr.sin_addr.s_addr = inet_addr("192.168.192.99"); //matlab client ip is 192.168.1.20
	serveraddr.sin_port = htons(SERVER_PORT);
 
	if (bind(sfd, (struct sockaddr*)&serveraddr, sizeof(struct sockaddr)) == -1) //bind socket id to server ip
	{
		perror("bind");
		close(sfd);
		exit(-1);
	}
 
	if (listen(sfd, LISENT_NUM) == -1) //listen the server socket port
	{
		perror("listen");
		close(sfd);
		exit(-1);
	}
 
	//printf("#@ listen SERVER_PORT %d\n", SERVER_PORT);
 
	printf("tcp initialing：server waiting connect...\n");
 
	if ((cfd = accept(sfd, (struct sockaddr *)&clientaddr, (socklen_t*)&size)) == -1) //server accept the require by client, create a new socket cfd
	{
		perror("accept");
		close(sfd);
		return 0;
	}
	else
	{
		printf("tcp connection success!\n");
		return cfd;
	}
		

}


void switch_state(uint8_t recv_buf[], int recv_size){
	
	/* Setting Radar Parameters */
	if(recv_size == 15 && recv_buf[0] == 1){
		state = S_SET_PARAM;
		//printf("receive: %s, len = %d\r\n", recv_buf, recv_);
		printf("\n******** Now set sample parameters ********\n");

		SampleRate_MHz = recv_buf[1];
		PulseWidth_us = ((0x00FF & recv_buf[2]) << 8) + (recv_buf[3] & 0x00FF);
		PRF_Hz = ((0x00FF & recv_buf[4] << 8)) + (recv_buf[5] & 0x00FF);
		StartFreq_kHz = ((0x00FF & recv_buf[6]) << 24) + ((0x00FF & recv_buf[7]) << 16) +
						((0x00FF & recv_buf[8]) << 8) + ((0x00FF & recv_buf[9]));
		StopFreq_kHz = ((0x00FF & recv_buf[10]) << 24) + ((0x00FF & recv_buf[11]) << 16) +
						((0x00FF & recv_buf[12]) << 8) + ((0x00FF & recv_buf[13]));
		VGA_Gain_dB = recv_buf[14];

		printf("Sample Rate = %d MHz\r\n", SampleRate_MHz);
		printf("Pulse Width = %d us\r\n", PulseWidth_us);
		printf("PRF = %d Hz\r\n", PRF_Hz);
		printf("Start Frequency = %d kHz\r\n", StartFreq_kHz);
		printf("Stop Frequency = %d kHz\r\n", StopFreq_kHz);
		printf("VGA Gain = %d dB\r\n", VGA_Gain_dB);
		//printf("***-----******-----*****-----***\n");
	}
	
	/* Starting Sampling */
	if(recv_size == 7 && recv_buf[0] == 2){
		state = S_START_SAMPLE;
		printf("\n******** Now set rail parameters ********\n");
		rail_traval_x = recv_buf[1];
		rail_direction_x = recv_buf[2];
		rail_traval_y = recv_buf[3];
		rail_direction_y = recv_buf[4];
		rail_speed = recv_buf[5];
		sample_time_s = recv_buf[6];
		sample_len = SampleRate_MHz * PulseWidth_us * sample_time_s * PRF_Hz;
		printf("Sample time = %d s\r\n",sample_time_s);
		printf("Sample length = %d\r\n", sample_len);
	}
}

// void switch_state2(char uart_recv_buf[], int uart_bytes_read){

// 	if(uart_bytes_read > 0){
// 		printf("11111111111111111\n");
// 		if(*uart_recv_buf != '\n'){
// 			printf("2222222222222222\n");
// 			uart_recv_buf[uart_bytes_read] = '\0';
// 			if(uart_recv_buf[uart_bytes_read - 1] == '\n'){
// 				printf("333333333333333333\n");
// 				uart_recv_buf[uart_bytes_read - 1] = '\0';	
// 			}
                
// 		}
// 	}
// 	/* system start state */
// 	// start setting radar parameters
// 	if(strcmp(uart_recv_buf, "radar") == 0){
// 		state = S_WAIT_UART_STAGE1;
// 	}

// 	/* sample set state */
// 	// start setting sample parameters
// 	// if(strcmp(uart_recv_buf, "sample") == 0){
// 	// 	state = S_
// 	// }
// }
