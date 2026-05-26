`timescale 1ns / 1ps

/*********** 时间戳提取与对齐模块 ************/
module utc_time(
	input 				clk,
	input				rst_n,
	input [7:0] 		uart_rx_data,
	input 				uart_rx_done,
	
	input [63:0]		clk_cnt,		// 来自采集模块的clk_div模块，每个脉冲开始采集时计数系统时钟周期个数，收到下一个utc时间就停止计数。对于100M系统时钟，周期为0.01us，惯导数据为5Hz，每0.2s（200ms）产生一次数据，time offset最大为200ms，故clk_cnt最大为10000000，需要64位
	output reg [71:0] 	utc_time,		// hhmmss.ss共9字节UTC Time
	output reg 			utc_done,
	
	output reg [79:0]	time_aligned,	// 对齐后的utc time
	output  			time_aligned_done
	);

/****** 从串口数据流提取出utc时间 ******/
localparam		S_IDLE 	= 3'd0;  // 等待识别到GGA语句
localparam		S_GGA 	= 3'd1;	 // 识别到GPGGA语句，进行时间戳寄存
localparam		S_UTC 	= 3'd2;	 // 提取完UTC Time
reg 	[2:0]	state;
	
reg		[7:0] 	char_buffer[0:6]; // 当buffer为{"$","G","P","G","G","A",","}，识别到GPGGA语句
reg 	[71:0]  time_buffer;
reg		[3:0]	time_cnt; 		  // 提取时间戳时使用的字符计数器

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
					char_buffer[3]=="G" && char_buffer[4]=="G" && char_buffer[5]=="A" && char_buffer[6]==",")
					state <= S_GGA; 
				else
					state <= S_IDLE;
				end
			S_GGA:begin
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

integer  time_offset;	

integer hh,mm,ss,ss_frac;

integer 	time_ms; // 把当前UTC Time转换为毫秒数
integer  time_aligned_ms;	// 对齐后的utc时间，毫秒

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		time_offset = 0; 					
		hh = 0;
		mm = 0;
		ss = 0;
		ss_frac = 0;
		time_ms = 0;	
		time_aligned_ms = 0;
		end
	else begin
		
		if(utc_done) begin		
			time_offset = (clk_cnt * 1000)/SYS_CLK_FREQ; 					// 把clk_cnt计算为毫秒数
			hh = ((utc_time[71:64]) * 10 + utc_time[63:56]) * 3600 * 1000; 				// 解析小时字符为毫秒数
			mm = ((utc_time[55:48]) * 10 + utc_time[47:40]) * 60 * 1000;
			ss = ((utc_time[39:32]) * 10 + utc_time[31:24]) * 1000; 
			ss_frac = ((utc_time[15:8]) * 10 + utc_time[7:0]) * 10; 		// 小数部分转换为毫秒数
			time_ms = hh + mm + ss + ss_frac;
			
			time_aligned_ms = time_ms - time_offset;
			end
		end
	end


// 将对齐后的毫秒数转换为ASCII码形式的UTC Time
reg time_aligned_done_flag;
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		time_aligned <= 72'b0;
		time_aligned_done_flag <= 1'b0;
		end
	else if(time_aligned_ms) begin
		time_aligned[79:72] <= (time_aligned_ms/(3600*1000))/10 ; // 小时高位
		time_aligned[71:64] <= (time_aligned_ms / (3600 * 1000)) % 10 ; // 小时低位
		time_aligned[63:56] <= ((time_aligned_ms % (3600 * 1000)) / (60 * 1000)) / 10 ; // 分钟高位
		time_aligned[55:48] <= ((time_aligned_ms % (3600 * 1000)) / (60 * 1000)) % 10 ; // 分钟低位
		time_aligned[47:40] <= ((time_aligned_ms % (60 * 1000)) / 1000) / 10 ; // 秒高位
		time_aligned[39:32] <= ((time_aligned_ms % (60 * 1000)) / 1000) % 10 ; // 秒低位
		time_aligned[31:24] <= 8'h2e;
		time_aligned[23:16]  <= ((time_aligned_ms % 1000) / 10) / 10 ;         // 小数高位
		time_aligned[15:8]   <= ((time_aligned_ms % 1000) / 10) % 10 ;         // 小数低位
		time_aligned[7:0]	<= time_aligned_ms % 10;
		time_aligned_done_flag <= 1'b1;
		end
	end

reg time_aligned_done_flag_t; //延时一拍
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		time_aligned_done_flag_t <= 1'b0;
		end
	else begin
		time_aligned_done_flag_t <= time_aligned_done_flag;
		end
	end

assign time_aligned_done = time_aligned_done_flag & (~time_aligned_done_flag_t);
	
endmodule