APP = uavsar

# Add any other object files to this list below
APP_OBJS = main.o platform.o psu_brd.o tx_brd.o base_brd.o acq_brd.o eth_tcp.o adc_sample_ctrl.o axi_dma_ctrl.o

# CC = aarch64-linux-gnu-gcc

CFLAGS = -Wall -g -D_GNU_SOURCE

LDLIBS = -lm -lpthread

all: build
build: $(APP)
$(APP): $(APP_OBJS)
	$(CC) -o $@ $(APP_OBJS) $(LDFLAGS) $(LDLIBS)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

main.o : main.c main.h
platform.o : platform.c platform.h
psu_brd.o : psu_brd.c psu_brd.h
tx_brd.o : tx_brd.c tx_brd.h
base_brd.o : base_brd.c base_brd.h
acq_brd.o : acq_brd.c acq_brd.h
eth_tcp.o : eth_tcp.c eth_tcp.h
adc_sample_ctrl.o : adc_sample_ctrl.c adc_sample_ctrl.h
axi_dma_ctrl.o : axi_dma_ctrl.c axi_dma_ctrl.h

clean:
	rm -f $(APP) *.o
