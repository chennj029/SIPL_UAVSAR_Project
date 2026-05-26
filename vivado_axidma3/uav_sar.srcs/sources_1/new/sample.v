`timescale 1ns / 1ps
////模拟采集模块的clk_div逻辑

module sample(
	input 				clk,
	input 				rst_n,
	input				utc_done,
	input 				module_en,
	
	output reg 			triggle, 	// HMC703 trigger signal
	output reg 			sample_en, // sample enable
	output reg[63:0] 	clk_cnt
	);
	
reg [ 2:0] 				state;
reg [31:0] 				count;
localparam				S_IDLE = 3'b000;
localparam				S_FIRST_TRIG = 3'b001;
localparam 				S_WAIT_INTERV = 3'b010;
localparam				S_SECOND_TRIG = 3'b011;
localparam				S_WAIT_PRT = 3'b100;

localparam 				triggle_width = 8'd5;
localparam				pulse_width = 32'd100; //1ms脉宽
localparam 				triggle_delay = 8'd50;
localparam 				prt_count = 32'd200; //500Hz

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
		sample_en <= 1'b0;
		triggle <= 1'b0;
        count <= 32'd0;
        state <= S_IDLE;
		end 
	else begin
        case(state)
            S_IDLE: begin
                if (module_en)
                    state <= S_FIRST_TRIG;  // 切换到 S_FIRST_TRIG 状态
                else
                    state <= S_IDLE;  // 保持 S_IDLE 状态
            end
            
            S_FIRST_TRIG: begin
                if (count == triggle_width) begin
					triggle <= 1'b0;
					count <= count + 1'b1;
                    state <= S_WAIT_INTERV;  // 达到脉冲宽度后切换回 S_IDLE 状态
					end
                else begin
					triggle <= 1'b1;
					sample_en <= 1'b1;
                    count <= count + 1'b1;  // 继续计数
					end
            end
			
			S_WAIT_INTERV: begin
				if(count == pulse_width) begin
					sample_en <= 1'b0;
					count <= count + 1'b1;
					state <= S_SECOND_TRIG;
					end
				else
					count <= count + 1'b1;
				end
            
			S_SECOND_TRIG: begin
				if(count == pulse_width + triggle_delay) begin
					triggle <= 1'b1;
					count <= count + 1'b1;
					state <= S_WAIT_PRT;
					end
				else 
					count <= count + 1'b1;
				end
			
			S_WAIT_PRT: begin
				if(count == pulse_width + triggle_delay + triggle_width) begin
					triggle <= 1'b0;
					count <= count + 1'b1;
					end
				else if(count == prt_count - 1'b1) begin
					state <= S_IDLE;
					count <= 32'd0;
					end
				else 
					count <= count + 1'b1;
				end
				
            default: begin
				sample_en <= 1'b0;
				triggle <= 1'b0;
                state <= S_IDLE;  // 默认返回 S_IDLE 状态
                count <= 32'd0;    // 清零计数器
				end
        endcase
    end
end


// 供时间对齐模块使用的clk_cnt信号
reg clk_cnt_flag; // 当此信号拉高，就可以开始计数
reg utc_done_flag;
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		utc_done_flag <= 1'b0;
		end
	else if(utc_done) begin
		utc_done_flag <= 1'b1;
		end
	end
	
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		clk_cnt_flag <= 1'b0;
		end
	else if(module_en && (~utc_done_flag)) begin  // 第一个脉冲开始采集，就开始计数
		clk_cnt_flag <= 1'b1;
		end
	else begin
		clk_cnt_flag <= 1'b0;
		end
	end
	
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		clk_cnt <= 64'd0;
		end
	else if(clk_cnt_flag) begin
		clk_cnt <= clk_cnt + 1'b1;
		end
	else begin
		clk_cnt <= 64'd0;
		end
	end
	
endmodule
	