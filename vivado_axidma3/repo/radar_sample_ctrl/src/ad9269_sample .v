`timescale 1 ns / 1 ps

module ad9269_sample #(
    parameter  DEBUG = 0,
    // Width of S_AXI data bus
    parameter integer C_S_AXI_DATA_WIDTH	= 64,
    // Width of S_AXI address bus
    parameter integer C_S_AXI_ADDR_WIDTH	= 6
)
(
	(* MARK_DEBUG = "TRUE" *)input             adc_clk       ,
	(* MARK_DEBUG = "TRUE" *)input             adc_rst_n     ,
	(* MARK_DEBUG = "TRUE" *)input      [15:0] adc_data      ,
	
    (* MARK_DEBUG = "TRUE" *)input      [C_S_AXI_DATA_WIDTH-1:0] sample_len    , //total sample points
	(* MARK_DEBUG = "TRUE" *)input             sample_start  , //sample start signal
	(* MARK_DEBUG = "TRUE" *)input             start_clr_ack , //ack
    (* MARK_DEBUG = "TRUE" *)input             sample_en     ,
    
	(* MARK_DEBUG = "TRUE" *)output reg        start_clr     , //clear start_sampling flag(slv_reg0)
//	(* MARK_DEBUG = "TRUE" *)output reg [31:0] dma_pack_cnt  ,
    (* MARK_DEBUG = "TRUE" *)input      [C_S_AXI_DATA_WIDTH-1:0]    DMA_pack_len,
	(* MARK_DEBUG = "TRUE" *)input             DMA_start,

    
    (* MARK_DEBUG = "TRUE" *)input             M_AXIS_CLK    ,
    (* MARK_DEBUG = "TRUE" *)input      [ 0:0] M_AXIS_RSTN   ,
    (* MARK_DEBUG = "TRUE" *)input             M_AXIS_tready ,
    
    (* MARK_DEBUG = "TRUE" *)output     [15:0] M_AXIS_tdata  ,
    (* MARK_DEBUG = "TRUE" *)output     [ 1:0] M_AXIS_tkeep  ,
    (* MARK_DEBUG = "TRUE" *)output            M_AXIS_tlast  ,
    (* MARK_DEBUG = "TRUE" *)output            M_AXIS_tvalid 
    
);

(* MARK_DEBUG = "TRUE" *)wire [12:0]  fifo_wr_count;
(* MARK_DEBUG = "TRUE" *)wire [12:0]  fifo_rd_count;
(* MARK_DEBUG = "TRUE" *)wire fifo_full;

localparam S_IDLE      = 3'd0;
localparam S_SAMP_WAIT = 3'd1;
localparam S_SAMPLE    = 3'd2;

(* MARK_DEBUG = "TRUE" *) reg [ 2:0] state;
(* MARK_DEBUG = "TRUE" *) reg [C_S_AXI_DATA_WIDTH-1:0] sample_cnt; //sample counter
(* MARK_DEBUG = "TRUE" *) reg [ 7:0] wait_cnt; //used for debug
(* MARK_DEBUG = "TRUE" *) reg      adc_buf_wr; //fifo write enable
reg     [15:0]  adc_buf_data; //fifo write data
(* MARK_DEBUG = "TRUE" *) wire     adc_buf_rd; //fifo read enable
//reg        adc_buf_rd_dly0;
(* MARK_DEBUG = "TRUE" *) wire       empty;	 //fifo empty
//(* MARK_DEBUG = "TRUE" *) reg        tvalid_en; //tvalid enable signal

(* MARK_DEBUG = "TRUE" *) reg [C_S_AXI_DATA_WIDTH-1:0] dma_pack_cnt;
(* MARK_DEBUG = "TRUE" *) reg        dma_active;
(* MARK_DEBUG = "TRUE" *) reg        dma_start_dly0;
(* MARK_DEBUG = "TRUE" *) reg        dma_start_dly1;
(* MARK_DEBUG = "TRUE" *) reg        dma_start_dly2;

reg         	sample_start_dly0;
reg         	sample_start_dly1;
reg         	sample_start_dly2;

reg     [C_S_AXI_DATA_WIDTH-1:0] 	sample_len_dly0;
reg     [C_S_AXI_DATA_WIDTH-1:0] 	sample_len_dly1;
reg     [C_S_AXI_DATA_WIDTH-1:0] 	sample_len_dly2;

reg             start_clr_ack_dly0;
reg             start_clr_ack_dly1;
reg             start_clr_ack_dly2;

reg     [C_S_AXI_DATA_WIDTH-1:0] 	dma_pack_len_dly0;
reg     [C_S_AXI_DATA_WIDTH-1:0] 	dma_pack_len_dly1;
reg     [C_S_AXI_DATA_WIDTH-1:0] 	dma_pack_len_dly2;

//(* MARK_DEBUG = "TRUE" *)reg     [31:0]    sample_points_cnt;

/* Sync data to adc_clk clock domain */
always@(posedge adc_clk or negedge adc_rst_n) begin
	if(adc_rst_n == 1'b0) begin
		sample_start_dly0  <=  1'b0;
		sample_start_dly1  <=  1'b0;
		sample_start_dly2  <=  1'b0;
		sample_len_dly0    <= 64'd0;
		sample_len_dly1    <= 64'd0;
		sample_len_dly2    <= 64'd0;
		start_clr_ack_dly0 <=  1'b0;
		start_clr_ack_dly1 <=  1'b0;		
		start_clr_ack_dly2 <=  1'b0;
	end
	else begin
        sample_start_dly0  <= sample_start;
        sample_start_dly1  <= sample_start_dly0;
        sample_start_dly2  <= sample_start_dly1;
        sample_len_dly0    <= sample_len;
        sample_len_dly1    <= sample_len_dly0;
        sample_len_dly2    <= sample_len_dly1;
        start_clr_ack_dly0 <= start_clr_ack;
        start_clr_ack_dly1 <= start_clr_ack_dly0;
        start_clr_ack_dly2 <= start_clr_ack_dly1;
    end
end

/* Sync data to adc_clk clock domain */
always@(posedge adc_clk or negedge adc_rst_n) begin
	if(adc_rst_n == 1'b0) begin
		adc_buf_data <= 16'd0;
	end
	else begin
        adc_buf_data <=  adc_data;
    end
end

// ADC²âÊÔÊý¾Ý
reg [15:0] test_adc_data;
always@(posedge adc_clk or negedge adc_rst_n) begin
    if(adc_rst_n == 1'b0) begin
        test_adc_data <= 16'd0;
    end
    else if(sample_en && state == S_SAMPLE) begin
        test_adc_data <= test_adc_data + 1'b1;
    end
end

(* MARK_DEBUG = "TRUE" *)wire [15:0] fifo_data_in = DEBUG ? test_adc_data : adc_buf_data;

always@(posedge adc_clk or negedge adc_rst_n) begin
	if(adc_rst_n == 1'b0) begin
		state <= S_IDLE;
		wait_cnt <= 8'd0;
		sample_cnt <= 64'd0;
		adc_buf_wr <= 1'b0;
		start_clr <= 1'b0;
	end
	else begin
		case(state)
			S_IDLE: begin
				adc_buf_wr <= 1'b0;
				if(sample_start_dly2) begin
					state <= S_SAMP_WAIT;
					start_clr <= 1'b1; //clear start register
				end
			end
			S_SAMP_WAIT: begin
				if(start_clr_ack_dly2 & ~sample_en) begin //wait ack signal assert
					state <= S_SAMPLE;
					wait_cnt <= 8'd0;
					start_clr <= 1'b0;
				end
				else begin
			  	    wait_cnt <= wait_cnt + 8'd1;
				end
			end
			S_SAMPLE: begin
				if(sample_cnt >= sample_len_dly2) begin
					sample_cnt <= 64'd0;
					adc_buf_wr <= 1'b0;
					state <= S_IDLE;
				end
				else if(sample_en) begin
					sample_cnt <= sample_cnt + 64'd1;
					adc_buf_wr <= 1'b1;
				end
				else begin
					adc_buf_wr <= 1'b0;
				end
			end
			default:
				state <= S_IDLE;
		endcase
	end
end

/* When axis slave interface ready and fifo is not empty, read fifo data */
//assign adc_buf_rd = M_AXIS_tready & ~empty & dma_active & (dma_pack_cnt < dma_pack_len_dly2);

/* Sync signal to M_AXIS_CLK clock domain */
//always@(posedge M_AXIS_CLK or negedge M_AXIS_RSTN) begin
//	if(M_AXIS_RSTN == 1'b0) begin
//		adc_buf_rd_dly0 <= 1'b0;
//	end
//	else begin
//	    adc_buf_rd_dly0 <= adc_buf_rd;
//	end
//end

// FIFO data is one clock cycle later than read enable,
// When read signal and axis ready signal valid at the same time,
// enable FIFO read data. Read FIFO data under M_AXIS_CLK.
//always@(posedge M_AXIS_CLK or negedge M_AXIS_RSTN) begin
//	if(M_AXIS_RSTN == 1'b0) begin
//		tvalid_en <= 1'b0;
//	end
//	//~M_AXIS_tready is the same principle as ~sample_en in state S_SAMP_EN.
//	else if(adc_buf_rd_dly0 & ~M_AXIS_tready) begin
//	    tvalid_en <= 1'b1;
//	end
//	else if(M_AXIS_tready) begin
//	    tvalid_en <= 1'b0;
//	end
//end

/* Async data to sync clock domain */
always@(posedge M_AXIS_CLK or negedge M_AXIS_RSTN) begin
	if(M_AXIS_RSTN == 1'b0) begin
		dma_pack_len_dly0 <= 64'd0;
		dma_pack_len_dly1 <= 64'd0;
		dma_pack_len_dly2 <= 64'd0;
		dma_start_dly0 <= 1'b0;
		dma_start_dly1 <= 1'b0;
		dma_start_dly2 <= 1'b0;
	end
	else begin
         dma_pack_len_dly0 <= DMA_pack_len;
         dma_pack_len_dly1 <= dma_pack_len_dly0;
         dma_pack_len_dly2 <= dma_pack_len_dly1;
         dma_start_dly0    <= DMA_start;
         dma_start_dly1    <= dma_start_dly0;
         dma_start_dly2    <= dma_start_dly1;
    end    
end

/* DMA control logic */
always@(posedge M_AXIS_CLK or negedge M_AXIS_RSTN) begin
    if(M_AXIS_RSTN == 1'b0) begin
        dma_active <= 1'b0;
        dma_pack_cnt <= 64'd0;
    end
    else begin
        // DMA START CONTROL
        if(dma_start_dly2 && ~dma_active) begin
            dma_active <= 1'b1;
            dma_pack_cnt <= 64'd0;
        end
        // DMA packet counter
        else if(M_AXIS_tready && M_AXIS_tvalid && dma_active) begin
            dma_pack_cnt <= dma_pack_cnt + 1'b1;
            // Check if reached DMA packet length
            if(dma_pack_cnt >= dma_pack_len_dly2 - 1) begin
                dma_active <= 1'b0;
                dma_pack_cnt <= 64'd0;
            end
        end
    end
end



//When slave is ready and tvalid_en is ACTIVE or FIFO read is ready, master transfer is effective. 
//assign M_AXIS_tvalid = M_AXIS_tready & (tvalid_en | adc_buf_rd_dly0);
assign M_AXIS_tvalid = ~empty & dma_active;
assign adc_buf_rd = M_AXIS_tready & M_AXIS_tvalid;
//DMA is always ready before transfer, tkeep can be ACTIVE at all time.
assign M_AXIS_tkeep  = 2'b11;
//tlast is active at the last packet
assign M_AXIS_tlast  = M_AXIS_tvalid & (dma_pack_cnt >= dma_pack_len_dly2 - 1);
/*
 * Instantiate async fifo by using Xilinx parameterized Macros.
 * For ultrasclae, refer to ug974, for 7 series, ug953
 * write and read depth is 1024, write and read data width is 16
 */
xpm_fifo_async #(
   .CDC_SYNC_STAGES      (2			),
   .DOUT_RESET_VALUE     ("1"		),
   .ECC_MODE             ("no_ecc"	),
   .FIFO_MEMORY_TYPE     ("auto"	),
   .FIFO_READ_LATENCY    (1			),
   .FIFO_WRITE_DEPTH     (131072	),
   .FULL_RESET_VALUE     (0			),
   .PROG_EMPTY_THRESH    (10		),
   .PROG_FULL_THRESH     (10		),
   .RD_DATA_COUNT_WIDTH  (18		),
   .READ_DATA_WIDTH      (16		),
   .READ_MODE            ("std"		),
   .RELATED_CLOCKS       (0			),
   .USE_ADV_FEATURES     ("0707"	), 
   .WAKEUP_TIME          (0			),
   .WRITE_DATA_WIDTH     (16		),
   .WR_DATA_COUNT_WIDTH  (18		)
)
xpm_fifo_async_inst(
   .rst            (~adc_rst_n		),
   .wr_clk         (adc_clk			),
   .wr_en          (adc_buf_wr		),
   .din            (fifo_data_in	),
   .rd_clk         (M_AXIS_CLK		),
   .rd_en          (adc_buf_rd      ),
   .dout           (M_AXIS_tdata	),
   .empty          (empty			),
   .full           (fifo_full				),
   .almost_empty   (				),
   .almost_full    (				),
   .wr_data_count  (fifo_wr_count				),
   .rd_data_count  (fifo_rd_count				),
   .prog_empty     (				),
   .prog_full      (				),
   .data_valid     (				),
   .dbiterr        (				),
   .sbiterr        (				),
   .overflow       (				),
   .underflow      (				),
   .wr_ack         (				),
   .wr_rst_busy    (				),
   .rd_rst_busy    (				),
   .injectdbiterr  (1'b0			),
   .injectsbiterr  (1'b0			),
   .sleep          (1'b0			)
   );

endmodule
