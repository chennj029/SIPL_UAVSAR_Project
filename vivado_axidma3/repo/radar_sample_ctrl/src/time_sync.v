`timescale 1ns / 1ps

module time_sync(
	input 				clk,
	input 				rst_n,
	input [31:0] 		clk_cnt,
	input [71:0]		utc_time, // 来自utc_time模块
	
	output reg [71:0] 	utc_time_sync,
	output reg 			time_sync_done
	);

localparam  SYS_CLK_FREQ = 10000000;

reg [31:0]  time_offset;	

integer hh,mm,ss,ss_frac;

reg [31:0] 	time_ms; // 把当前UTC Time转换为毫秒数
reg [31:0]  time_sync_ms;	// 对齐后的utc时间，毫秒

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		time_offset <= 32'b0;
		hh = 0;
		mm = 0;
		ss = 0;
		ss_frac = 0;
		time_ms <= 32'd0;		
		end
	else begin
		time_offset <= (clk_cnt * 1000)/SYS_CLK_FREQ; 									// 把clk_cnt计算为毫秒数
		hh = ((utc_time[71:64] - 8'd48) * 10 + (utc_time[63:56] - 8'd48)) * 3600 * 1000; // 解析小时字符为毫秒数
		mm = ((utc_time[55:48] - 8'd48) * 10 + (utc_time[47:40] - 8'd48)) * 60 * 1000;
		ss = ((utc_time[39:32] - 8'd48) * 10 + (utc_time[31:24] - 8'd48)) * 1000; 
		ss_frac = ((utc_time[15:8] - 8'd48) * 10 + (utc_time[7:0] - 8'd48)) * 10; 		// 小数部分转换为毫秒数
		time_ms <= hh + mm + ss + ss_frac;
		
		time_sync_ms <= time_ms - time_offset;
		end
	end


// 将对齐后的毫秒数转换为ASCII码形式的UTC Time
reg time_sync_done_dly;
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		utc_time_sync <= 72'b0;
		time_sync_done <= 1'b0;
		time_sync_done_dly <= 1'b0;
		end
	else begin
		utc_time_sync[71:64] <= (time_sync_ms/(3600*1000))/10 + 8'd48; // 小时高位
		utc_time_sync[63:56] <= (time_sync_ms / (3600 * 1000)) % 10 + 8'd48; // 小时低位
		utc_time_sync[55:48] <= ((time_sync_ms % (3600 * 1000)) / (60 * 1000)) / 10 + 8'd48; // 分钟高位
		utc_time_sync[47:40] <= ((time_sync_ms % (3600 * 1000)) / (60 * 1000)) % 10 + 8'd48; // 分钟低位
		utc_time_sync[39:32] <= ((time_sync_ms % (60 * 1000)) / 1000) / 10 + 8'd48; // 秒高位
		utc_time_sync[31:24] <= ((time_sync_ms % (60 * 1000)) / 1000) % 10 + 8'd48; // 秒低位
		utc_time_sync[23:16] <= 8'h2e;
		utc_time_sync[15:8]  <= ((time_sync_ms % 1000) / 10) / 10 + 8'd48;         // 小数高位
		utc_time_sync[7:0]   <= ((time_sync_ms % 1000) / 10) % 10 + 8'd48;         // 小数低位
		
		time_sync_done_dly <= (time_sync_done == 1'b1);
		time_sync_done <= (time_sync_done_dly == 1'b0) ? 1'b1 : 1'b0;  // 确保只拉高一拍
		end
	end

endmodule