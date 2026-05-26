	// while(1){
		
		

	// 	if(state == S_START_SAMPLE){
	// 		TCP_test();
	// 		state = S_IDLE;
	// 	}
	// }
	// for(i = 0; i < 3; i ++){
	
	// 	HMC960_SPIGainCtrl(i * 10+ 1);
	// 	printf("VGA Gain = %d dB.\n", i * 10 + 1);
	// 	sleep(2);
	// }

	
	// int fd = open("/dev/mem", O_RDWR | O_SYNC);
    // if(fd < 0){
    //     printf("open /dev/mem failed!\n");
    //     return 1;
    // }

	// off_t start_reg_address = AD9269_SAMPLE_BASE+SAMPLE_START_OFFSET_ADDR;
	// off_t len_reg_address = AD9269_SAMPLE_BASE+SAMPLE_LEN_OFFSET_ADDR;
	// off_t prt_reg_address = AD9269_SAMPLE_BASE+PRT_COUNT_OFFSET_ADDR;
	// off_t pulse_reg_address = AD9269_SAMPLE_BASE+PULSE_WIDTH_OFFSET_ADDR;
	// off_t dma_reg_address = AD9269_SAMPLE_BASE+DMA_CNT_OFFSET_ADDR;
	// off_t module_reg_address = AD9269_SAMPLE_BASE+MODULE_EN_OFFSET_ADDR;
	// uint32_t start_reg_value;
	// uint32_t len_reg_value;
	// uint32_t prt_reg_value;
	// uint32_t pulse_reg_value;
	// uint32_t dma_reg_value;
	// uint8_t module_reg_value;
	
	

    // unsigned char* base_address = (unsigned char*)mmap(NULL, 0X10000, PROT_READ | PROT_WRITE, MAP_SHARED, fd, AD9269_SAMPLE_BASE);
    // if(base_address == MAP_FAILED){
    //     perror("mmap");
    //     close(fd);
    //     return 1;
    // }
	//printf("mmap address: %p \n", (void*)(base_address));

	//printf("Mapped address range:\n");
	//for(int i=0;i< 0xFFFF;i+=32){
	//	printf("%p \n", (void*)((uintptr_t)base_address+i));
	//}

    // sample_start_reg = (volatile uint32_t*)(base_address+SAMPLE_START_OFFSET_ADDR);
    // sample_len_reg = (volatile uint32_t*)(base_address+SAMPLE_LEN_OFFSET_ADDR);
    // sample_prt_count_reg = (volatile uint32_t*)(base_address+PRT_COUNT_OFFSET_ADDR);
    // sample_pulse_width_reg = (volatile uint32_t*)(base_address+PULSE_WIDTH_OFFSET_ADDR);
    // sample_dma_cnt_reg = (volatile uint32_t*)(base_address+DMA_CNT_OFFSET_ADDR);
    // sample_module_en_reg = (volatile uint32_t*)(base_address+MODULE_EN_OFFSET_ADDR);


    //write value to register
	//*sample_start_reg = 1;
	// 

    //*sample_len_reg =  sample_len;
    //uint32_t sample_len = *sample_len_reg;

    //*sample_prt_count_reg = SampleRate_MHz*10e6/PRF_Hz;
    //uint32_t prt_count = *sample_prt_count_reg;

    //*sample_pulse_width_reg = *sample_prt_count_reg*PulseWidth_us*PRF_Hz/10e6;//us
    //uint32_t pulse_width = *sample_pulse_width_reg;

    //*sample_dma_cnt_reg = 0x20000000; //byte
    //uint32_t dma_cnt = *sample_dma_cnt_reg;

    //*sample_module_en_reg = 1;
	//uint32_t module_en = *sample_module_en_reg;