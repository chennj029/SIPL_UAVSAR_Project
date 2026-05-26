`timescale 1ns / 1ps

/*********** 时间戳提取与对齐模块 ************/
module utc_time(
	input 				clk,
	input				rst_n,
	(* MARK_DEBUG = "TRUE" *)   input [7:0] 		uart_rx_data,
	(* MARK_DEBUG = "TRUE" *)   input 				uart_rx_done,
	
	(* MARK_DEBUG = "TRUE" *)   input [63:0]		clk_cnt,		// 来自采集模块的clk_div模块，每个脉冲开始采集时计数系统时钟周期个数，收到下一个utc时间就停止计数。对于100M系统时钟，周期为0.01us，惯导数据为5Hz，每0.2s（200ms）产生一次数据，time offset最大为200ms，故clk_cnt最大为10000000，需要64位
//	output reg [71:0] 	utc_time,		// hhmmss.ss共9字节UTC Time
	(* MARK_DEBUG = "TRUE" *)   output reg 		utc_done,
	
	(* MARK_DEBUG = "TRUE" *)   output    [79:0]	align_time,	// 对齐后的utc time
	(* MARK_DEBUG = "TRUE" *)   output  			time_aligned_done,
	(* MARK_DEBUG = "TRUE" *)    input             first_pulse_flag // 来自clk_div模块，首个脉冲发出的标志
	);

/****** 从串口数据流提取出utc时间 ******/
localparam		S_IDLE 	= 3'd0;  // 等待识别到ZDA语句
localparam		S_ZDA 	= 3'd1;	 // 识别到GPZDA语句，进行时间戳寄存
localparam		S_UTC 	= 3'd2;	 // 提取完UTC Time
(* MARK_DEBUG = "TRUE" *)   reg 	[2:0]	state;
	
(* MARK_DEBUG = "TRUE" *)   reg		[7:0] 	char_buffer[0:6]; // 当buffer为{"$","G","P","Z","D","A",","}，识别到GPZDA语句
(* MARK_DEBUG = "TRUE" *)   reg 	[71:0]  time_buffer;
(* MARK_DEBUG = "TRUE" *)   reg		[3:0]	time_cnt; 		  // 提取时间戳时使用的字符计数器
(* MARK_DEBUG = "TRUE" *)   reg     [71:0] 	utc_time;	// hhmmss.ss共9字节UTC Time
// 连续寄存7个字符
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		char_buffer[0] <= 8'b0;
		char_buffer[1] <= 8'b0;
		char_buffer[2] <= 8'b0;
		char_buffer[3] <= 8'b0;
		char_buffer[4] <= 8'b0;
		char_buffer[5] <= 8'b0;
		char_buffer[6] <= 8'b0;
		end
	else begin
		if(uart_rx_done) begin
			char_buffer[0] <= char_buffer[1];
			char_buffer[1] <= char_buffer[2];
			char_buffer[2] <= char_buffer[3];
			char_buffer[3] <= char_buffer[4];
			char_buffer[4] <= char_buffer[5];
			char_buffer[5] <= char_buffer[6];
			char_buffer[6] <= uart_rx_data;
			end
		end
	end

/**** 状态机实现 ****/
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		state <= S_IDLE;
		time_buffer <= 72'b0;
		utc_time <= 72'b0;
		time_cnt <= 4'd0;
		utc_done <= 1'b0;
		end
	else begin
		case(state)
			S_IDLE:begin
				utc_done <= 1'b0;
				time_buffer <= 72'b0;
				time_cnt <= 4'd0;
				if(char_buffer[0]=="$" && char_buffer[1]=="G" && char_buffer[2]=="P" &&
					char_buffer[3]=="Z" && char_buffer[4]=="D" && char_buffer[5]=="A" && char_buffer[6]==",")
					state <= S_ZDA; 
				else
					state <= S_IDLE;
				end
			S_ZDA:begin
				if(uart_rx_done) begin
					if(time_cnt <= 4'd8) begin
						time_buffer <= {time_buffer[63:0], uart_rx_data};
						time_cnt <= time_cnt + 1'b1;
						end
					else begin
						time_cnt <= 4'd0;
						state <= S_UTC;
						end
					end
				end
			S_UTC:begin
				utc_time <= time_buffer;
				utc_done <= 1'b1;
				state <= S_IDLE;
				end
			default:state <= S_IDLE;
			endcase
		end
	end		

/****** 脉冲时间戳对齐 ******/
localparam  SYS_CLK_FREQ = 50000000;
// 用状态机实现首脉冲等待UTC对齐
localparam  S_WAIT_REQ   = 3'd0;
localparam  S_WAIT_UTC   = 3'd1;
localparam  S_ALIGN      = 3'd2;
(* MARK_DEBUG = "TRUE" *)   reg [1:0] align_state;
(* MARK_DEBUG = "TRUE" *)   reg [63:0]     clk_cnt_reg; // 在首脉冲发出时刻锁存clk_cnt

(* MARK_DEBUG = "TRUE" *)   wire [31:0]  	time_offset;	
(* MARK_DEBUG = "TRUE" *)   wire [31:0] 	hh,mm,ss,ss_frac;
(* MARK_DEBUG = "TRUE" *)   wire [32:0]    time_aligned_ms;	// 对齐后的utc时间，毫秒

(* MARK_DEBUG = "TRUE" *)   reg utc_done_t;
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		utc_done_t <= 1'b0;
		end
	else begin
		utc_done_t <= utc_done;
		end
	end
	

(* MARK_DEBUG = "TRUE" *) reg time_aligned_done_flag;
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        align_state <= S_WAIT_REQ;
        clk_cnt_reg <= 64'd0;
        time_aligned_done_flag <= 1'b0;
    end
    else begin
        time_aligned_done_flag <= 1'b0;
        case(align_state)
            S_WAIT_REQ: begin
                if(first_pulse_flag) begin
                    
                    align_state <= S_WAIT_UTC;
                end
                time_aligned_done_flag <= 1'b0;
            end
            S_WAIT_UTC: begin
                if(utc_done) begin
                    clk_cnt_reg <= clk_cnt;
                    align_state <= S_ALIGN;
                end
                time_aligned_done_flag <= 1'b0;
            end
            S_ALIGN: begin                                   
                    time_aligned_done_flag <= 1'b1;
                    align_state <= S_WAIT_REQ;            		         
            end
        endcase
    end
end

assign time_offset = (clk_cnt_reg * 1000)/SYS_CLK_FREQ; 					// 把clk_cnt计算为毫秒数
assign hh = ((utc_time[71:64]-48) * 10 + utc_time[63:56]-48) * 3600 * 1000; 				// 解析小时字符为毫秒数
assign mm = ((utc_time[55:48]-48) * 10 + utc_time[47:40]-48) * 60 * 1000;
assign ss = ((utc_time[39:32]-48) * 10 + utc_time[31:24]-48) * 1000; 
assign ss_frac = ((utc_time[15:8]-48) * 10 + utc_time[7:0]-48) * 10; 		// 小数部分转换为毫秒数
assign time_aligned_ms = hh + mm + ss + ss_frac - time_offset; 

assign align_time[79:72]  = (time_aligned_ms/(3600*1000))/10 + 32'h30; // 小时高位，并换成十六进制ASCII码字
assign align_time[71:64]  = (time_aligned_ms / (3600 * 1000)) % 10 + 32'h30; // 小时低位
assign align_time[63:56]  = ((time_aligned_ms % (3600 * 1000)) / (60 * 1000)) / 10 + 32'h30; // 分钟高位
assign align_time[55:48]  = ((time_aligned_ms % (3600 * 1000)) / (60 * 1000)) % 10 + 32'h30; // 分钟低位
assign align_time[47:40]  = ((time_aligned_ms % (60 * 1000)) / 1000) / 10 + 32'h30; // 秒高位
assign align_time[39:32]  = ((time_aligned_ms % (60 * 1000)) / 1000) % 10 + 32'h30; // 秒低位
assign align_time[31:24]  = 8'h2e;
assign align_time[23:16]  = ((time_aligned_ms % 1000) / 10) / 10 + 32'h30;         // 小数高位
assign align_time[15:8]   = ((time_aligned_ms % 1000) / 10) % 10 + 32'h30;         // 小数低位
assign align_time[7:0]	  = time_aligned_ms % 10 + 32'h30;

(* MARK_DEBUG = "TRUE" *) reg time_aligned_done_flag_t; //延时一拍
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		time_aligned_done_flag_t <= 1'b0;
		end
	else begin
		time_aligned_done_flag_t <= time_aligned_done_flag;
		end
	end

assign time_aligned_done = time_aligned_done_flag_t;
	
endmodule