`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/14 22:40:15
// Design Name: 
// Module Name: uart_rx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_rx(
    (* MARK_DEBUG = "TRUE" *)   input clk,
	(* MARK_DEBUG = "TRUE" *)   input rst_n,
	
    (* MARK_DEBUG = "TRUE" *) 	input uart_rxd,					// 接收端口数据线
	(* MARK_DEBUG = "TRUE" *)  output reg uart_rx_done,  		// 接收完成标志
	(* MARK_DEBUG = "TRUE" *)  output reg [7:0] uart_rx_data,	// 接收到的字符，ASCII
	(* MARK_DEBUG = "TRUE" *) 	input [31:0]	DMA_pack_len,
	(* MARK_DEBUG = "TRUE" *) 	input 			DMA_start,
	
	(* MARK_DEBUG = "TRUE" *)  	input M_AXIS_CLK,
	(* MARK_DEBUG = "TRUE" *)   input M_AXIS_RSTN,
	(* MARK_DEBUG = "TRUE" *)   input M_AXIS_tready,

	(* MARK_DEBUG = "TRUE" *)   output [31:0] M_AXIS_tdata,
	(* MARK_DEBUG = "TRUE" *)   output [3:0] M_AXIS_tkeep,
	(* MARK_DEBUG = "TRUE" *)   output M_AXIS_tlast,
	(* MARK_DEBUG = "TRUE" *)   output M_AXIS_tvalid	

    );
	
parameter 	CLK_FREQ = 50000000; 		
parameter 	UART_BPS = 921600; 					// 串口波特率
localparam 	BAUD_CNT_MAX = CLK_FREQ/UART_BPS; 	// 当前波特率下，串口传输一位所需要的系统时钟周期数
// 固定数据包大小（单位：字节）
//parameter PACKET_SIZE = 1024;  // 每 1024 字节生成一次 tlast

// UART接收器相关信号
(* MARK_DEBUG = "TRUE" *)   reg 		uart_rxd_d0;
(* MARK_DEBUG = "TRUE" *)   reg			uart_rxd_d1;
(* MARK_DEBUG = "TRUE" *)   reg 		uart_rxd_d2;
(* MARK_DEBUG = "TRUE" *)   reg			rx_flag; 							// 接收过程标志
(* MARK_DEBUG = "TRUE" *)   reg	 [3:0]  rx_cnt;								// 接收数据计数器，接收1位就加一
(* MARK_DEBUG = "TRUE" *)   reg  [15:0] baud_cnt;							// 波特率计数器，数一个波特率周期对应的系统时钟周期数
(* MARK_DEBUG = "TRUE" *)   reg  [7:0]  rx_data_t; 							// 接收数据寄存器

(* MARK_DEBUG = "TRUE" *)   wire 		start_en;
assign 		start_en = uart_rxd_d2 & (~uart_rxd_d1) & (~rx_flag); // 捕获接收端口下降沿（起始位），得到一个时钟周期的脉冲信号

// FIFO控制信号
(* MARK_DEBUG = "TRUE" *) 	reg			uart_buf_wr; // FIFO写使能
(* MARK_DEBUG = "TRUE" *) 	reg  [31:0] uart_buf_data; //fifo write data
(* MARK_DEBUG = "TRUE" *)	wire 		uart_buf_rd; // FIFO读使能
(* MARK_DEBUG = "TRUE" *)	reg			uart_buf_rd_dly0; // FIFO读使能延迟
(* MARK_DEBUG = "TRUE" *) 	wire 		empty; // FIFO空信号
(* MARK_DEBUG = "TRUE" *) 	wire        prog_full; // FIFO将满信号
(* MARK_DEBUG = "TRUE" *) 	wire        full; // FIFO满信号
(* MARK_DEBUG = "TRUE" *)	reg			tvalid_en; // tvalid使能信号
//(* MARK_DEBUG = "TRUE" *)	wire [12:0] fifo_wr_count;
//(* MARK_DEBUG = "TRUE" *)	wire [12:0] fifo_rd_count;
//(* MARK_DEBUG = "TRUE" *)	wire 		fifo_full;

 // AXI-Stream计数器
(* MARK_DEBUG = "TRUE" *)	reg [31:0]	dma_cnt; // 数据包计数器，以32位为单位
(* MARK_DEBUG = "TRUE" *)	reg [1:0]	byte_cnt; // 字节计数器，4字节打一包
(* MARK_DEBUG = "TRUE" *)   reg[31:0]   fifo_wr_cnt; // FIFO 
 
 // DMA分包控制信号
(* MARK_DEBUG = "TRUE" *) 	reg [31:0] 	dma_pack_cnt;
(* MARK_DEBUG = "TRUE" *) 	reg        	dma_active;
(* MARK_DEBUG = "TRUE" *) 	reg        	dma_start_dly0;
(* MARK_DEBUG = "TRUE" *) 	reg        	dma_start_dly1;
(* MARK_DEBUG = "TRUE" *) 	reg        	dma_start_dly2;
reg     	[31:0] 		dma_pack_len_dly0;
reg     	[31:0] 		dma_pack_len_dly1;
reg     	[31:0] 		dma_pack_len_dly2;
/**************************UART时序控制*******************************/
// 针对异步信号的同步处理，避免异步信号亚稳态
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		uart_rxd_d0 <= 1'b1;
		uart_rxd_d1 <= 1'b1;
		uart_rxd_d2 <= 1'b1;
		end
	else begin
		uart_rxd_d0 <= uart_rxd;
		uart_rxd_d1 <= uart_rxd_d0;
		uart_rxd_d2 <= uart_rxd_d1;
		end
	end
	
// 接收标志，检测到起始位就拉高，当接收完一个完整数据帧（包括停止位）后就清除
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		rx_flag <= 1'b0;
	else if(start_en)
		rx_flag <= 1'b1;
	else if((rx_cnt == 4'd9) && (baud_cnt == BAUD_CNT_MAX/2-1'b1)) // 当接收到停止位即rx_cnt计数到9，就可以拉低rx_flag
		rx_flag <= 1'b0;										// 波特计数到一半是因为此时是采样该位的最佳时刻
	else
		rx_flag <= rx_flag;
	end
	
// 波特率计数器
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		baud_cnt <= 16'd0;
	else if(rx_flag) begin
		if(baud_cnt < BAUD_CNT_MAX - 1'b1)
			baud_cnt <= baud_cnt + 16'b1;
		else
			baud_cnt <= 16'd0;
		end
	else
		baud_cnt <= 16'd0;
	end

// 接收数据计数器
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		rx_cnt <= 4'd0;
	else if(rx_flag) begin
		if(baud_cnt == BAUD_CNT_MAX - 1'b1)
			rx_cnt <= rx_cnt + 1'b1;
		else	
			rx_cnt <= rx_cnt;
		end
	else
		rx_cnt <= 4'd0;
	end

// 根据rx_cnt寄存接收到的数据，计数到8时完成整帧数据的寄存
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) 
		rx_data_t <= 8'b0;
	else if(rx_flag) begin
		if(baud_cnt == BAUD_CNT_MAX/2-1'b1) begin // 在采样稳定时刻开始寄存接收数据
			case(rx_cnt)
				4'd1: rx_data_t[0] <= uart_rxd_d2;
				4'd2: rx_data_t[1] <= uart_rxd_d2;
				4'd3: rx_data_t[2] <= uart_rxd_d2;
				4'd4: rx_data_t[3] <= uart_rxd_d2;
				4'd5: rx_data_t[4] <= uart_rxd_d2;
				4'd6: rx_data_t[5] <= uart_rxd_d2;
				4'd7: rx_data_t[6] <= uart_rxd_d2;
				4'd8: rx_data_t[7] <= uart_rxd_d2;
				default: ;
				endcase
			end
		else
			rx_data_t <= rx_data_t;
		end
	else
		rx_data_t <= 8'b0;
	end
	
// 接收完成信号以及输出的接收数据
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		uart_rx_done <= 1'b0;
		uart_rx_data <= 8'b0;
		end
	else if(rx_cnt == 4'd9 && baud_cnt == BAUD_CNT_MAX/2-1'b1) begin
		uart_rx_done <= 1'b1; // 一个字节（8bit）接收完毕，拉高接收完成信号
		uart_rx_data <= rx_data_t;
		end
	else begin
		uart_rx_done <= 1'b0;
		uart_rx_data <= uart_rx_data;
		end
	end


/**************************FIFO时序控制*******************************/
// uart_rx_data和uart_rx_done的时序：
// uart_rxd每传入8bits，uart_rx_data解析成1字节数据，在uart_rx_data的最后一拍拉高done

/* Sync data to adc_clk clock domain */
always@(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0) begin
	    byte_cnt <= 2'd0;
		uart_buf_data <= 32'd0;
		uart_buf_wr <= 1'b0;
	end
	else if(uart_rx_done) begin
        case(byte_cnt)
            2'd0: uart_buf_data[7:0] <= uart_rx_data;
            2'd1: uart_buf_data[15:8] <= uart_rx_data;
            2'd2: uart_buf_data[23:16] <= uart_rx_data;
            2'd3: begin
                  uart_buf_data[31:24] <= uart_rx_data;
                  uart_buf_wr <= 1'b1;
            end
        endcase
        byte_cnt <= byte_cnt + 1'b1;
    end
    else begin
         uart_buf_wr <= 1'b0;
    end
end



// FIFO读：AXI-Stream下游就绪且FIFO将满
// (* MARK_DEBUG = "TRUE" *)	reg  full_flag;
// always@(posedge M_AXIS_CLK or negedge M_AXIS_RSTN) begin
    // if(!M_AXIS_RSTN) begin
        // full_flag <= 1'b0;
        // end
    // else if(prog_full & ~empty) begin
        // full_flag <= 1'b1;
        // end
    // else if(empty) begin
        // full_flag <= 1'b0;
        // end
    // end
    
// //assign uart_buf_rd = M_AXIS_tready & ~empty;
// assign uart_buf_rd = M_AXIS_tready & full_flag & ~empty;

/* 跨时钟域同步：将dma包场和DMA_start信号同步到M_AXIS_CLK时钟域 */
always@(posedge M_AXIS_CLK or negedge M_AXIS_RSTN) begin
	if(M_AXIS_RSTN == 1'b0) begin
		dma_pack_len_dly0 <= 32'd0;
		dma_pack_len_dly1 <= 32'd0;
		dma_pack_len_dly2 <= 32'd0;
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

/* DMA 控制逻辑 */
always@(posedge M_AXIS_CLK or negedge M_AXIS_RSTN) begin
    if(M_AXIS_RSTN == 1'b0) begin
        dma_active <= 1'b0;
        dma_pack_cnt <= 32'd0;
    end
    else begin
        // DMA START CONTROL
        if(dma_start_dly2 && ~dma_active) begin
            dma_active <= 1'b1;
            dma_pack_cnt <= 32'd0;
        end
        // DMA packet counter
        else if(M_AXIS_tready && M_AXIS_tvalid && dma_active) begin
            dma_pack_cnt <= dma_pack_cnt + 1'b1;
            // Check if reached DMA packet length
            if(dma_pack_cnt >= dma_pack_len_dly2 - 1) begin
                dma_active <= 1'b0;
                dma_pack_cnt <= 32'd0;
            end
        end
    end
end
// 跨时钟域同步：将读使能信号同步到M_AXIS_CLK时钟域
// always@(posedge M_AXIS_CLK or negedge M_AXIS_RSTN) begin
	// if(!M_AXIS_RSTN) begin
		// uart_buf_rd_dly0 <= 1'b0;
		// end
	// else begin
		// uart_buf_rd_dly0 <= uart_buf_rd;
		// end
	// end
// // AXI-Stream下游tready信号
// always@(posedge M_AXIS_CLK or negedge M_AXIS_RSTN) begin
	// if(!M_AXIS_RSTN) begin
		// tvalid_en <= 1'b0;
		// end
	// else if(uart_buf_rd_dly0 & ~M_AXIS_tready) begin
		// tvalid_en <= 1'b1;
		// end
	// else if(M_AXIS_tready) begin
		// tvalid_en <= 1'b0;
		// end
	// end
// AXI-Stream数据包计数器
always@(posedge M_AXIS_CLK or negedge M_AXIS_RSTN) begin
	if(!M_AXIS_RSTN) begin
		dma_cnt <= 32'd0;
		end
	else if(M_AXIS_tvalid & (~M_AXIS_tlast)) begin
		dma_cnt <= dma_cnt+1'b1;
		end
	else if(M_AXIS_tvalid & M_AXIS_tlast) begin
		dma_cnt <= 32'd0;
		end
	end
// 生成AXI-Stream信号
// assign M_AXIS_tvalid = M_AXIS_tready & (tvalid_en | uart_buf_rd_dly0);
// assign M_AXIS_tkeep = 4'b1111;
// assign M_AXIS_tlast = (M_AXIS_tvalid & (dma_cnt == PACKET_SIZE-1));
assign M_AXIS_tvalid = ~empty & dma_active;
assign uart_buf_rd = M_AXIS_tready & M_AXIS_tvalid;
assign M_AXIS_tkeep = 4'b1111;
assign M_AXIS_tlast = M_AXIS_tvalid & (dma_pack_cnt >= dma_pack_len_dly2-1);

// 跨时钟域异步FIFO例化
fifo_generator_0 fifo_async (
  .srst(~rst_n),                // input wire srst
  .wr_clk(clk),            // input wire wr_clk
  .rd_clk(M_AXIS_CLK),            // input wire rd_clk
  .din(uart_buf_data),                  // input wire [31 : 0] din
  .wr_en(uart_buf_wr),              // input wire wr_en
  .rd_en(uart_buf_rd),              // input wire rd_en
  .dout(M_AXIS_tdata),                // output wire [31 : 0] dout
  .full(full),                // output wire full
  .empty(empty),              // output wire empty
  .wr_rst_busy(),  // output wire wr_rst_busy
  .rd_rst_busy()  // output wire rd_rst_busy
);

//xpm_fifo_async #(
//   .CDC_SYNC_STAGES      (2			),
//   .DOUT_RESET_VALUE     ("1"		),
//   .ECC_MODE             ("no_ecc"	),
//   .FIFO_MEMORY_TYPE     ("auto"	),
//   .FIFO_READ_LATENCY    (1			),
//   .FIFO_WRITE_DEPTH     (1024		),
//   .FULL_RESET_VALUE     (0			),
//   .PROG_EMPTY_THRESH    (10		),
//   .PROG_FULL_THRESH     (10		),
//   .RD_DATA_COUNT_WIDTH  (11		),
//   .READ_DATA_WIDTH      (16		),
//   .READ_MODE            ("std"		),
//   .RELATED_CLOCKS       (0			),
//   .USE_ADV_FEATURES     ("0707"	), 
//   .WAKEUP_TIME          (0			),
//   .WRITE_DATA_WIDTH     (16		),
//   .WR_DATA_COUNT_WIDTH  (11		)
//)
//xpm_fifo_async_inst(
//   .rst            (~adc_rst_n		),
//   .wr_clk         (adc_clk			),
//   .wr_en          (adc_buf_wr		),
//   .din            (adc_buf_data	),
//   .rd_clk         (M_AXIS_CLK		),
//   .rd_en          (adc_buf_rd		),
//   .dout           (M_AXIS_tdata	),
//   .empty          (empty			),
//   .full           (				),
//   .almost_empty   (				),
//   .almost_full    (				),
//   .wr_data_count  (				),
//   .rd_data_count  (				),
//   .prog_empty     (				),
//   .prog_full      (				),
//   .data_valid     (				),
//   .dbiterr        (				),
//   .sbiterr        (				),
//   .overflow       (				),
//   .underflow      (				),
//   .wr_ack         (				),
//   .wr_rst_busy    (				),
//   .rd_rst_busy    (				),
//   .injectdbiterr  (1'b0			),
//   .injectsbiterr  (1'b0			),
//   .sleep          (1'b0			)
//   );
   
endmodule