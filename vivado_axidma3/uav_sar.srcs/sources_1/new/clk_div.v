`timescale 1ns / 1ps

module clk_div(
    input sys_clk               , // 系统时钟
    
    input clk_in                , // adc时钟，来自外部
    (* MARK_DEBUG = "TRUE" *)input rst_n                 ,
    input ext_trig              , //external trigger input (optional)
    input [31:0] prt_count      , //PRT
    input [31:0] pulse_width    , //sample counter of each pulse interval
	(* MARK_DEBUG = "TRUE" *)input module_en             , //clk_div module enable
    input trig_sel              , //trigger source selection, 1 for internal and 0 for external
	
	(* MARK_DEBUG = "TRUE" *)input utc_done				, // 串口时间戳提取模块的输出
	
    (* MARK_DEBUG = "TRUE" *)output reg triggle     , //HMC703 trigger signal
    (* MARK_DEBUG = "TRUE" *)output reg sample_en   , //sample enable
    output reg led,  								  //AD9269 DCO indicator

	(* MARK_DEBUG = "TRUE" *)input sample_start             , //ad9269 sample start(雷达回波开始接收传输)
	(* MARK_DEBUG = "TRUE" *)output reg [63:0]   clk_cnt,						 // 第一个触发脉冲开始时刻的时钟周期计数器	  
    (* MARK_DEBUG = "TRUE" *)output first_pulse_flag   // 输出给utc_time模块
);

(* MARK_DEBUG = "TRUE" *)reg [ 2: 0] state;
(* MARK_DEBUG = "TRUE" *)reg [31: 0] count;
reg [31: 0] ext_count;
reg [22: 0] led_count;

localparam triggle_width = 8'd5;
localparam triggle_delay = 8'd50;
localparam led_max_cnt   = 23'd500_0000; 

localparam S_IDLE        = 3'b000;	//0
localparam S_FIRST_TRIG  = 3'b001;	//1
localparam S_WAIT_INTERV = 3'b011;	//3
localparam S_SECOND_TRIG = 3'b010;	//2
localparam S_WAIT_PRT    = 3'b100;	//4

wire ext_trig_pedge;
reg  ext_trig_dly1;
reg  ext_trig_dly2;
reg  ext_trig_dly3;

(* MARK_DEBUG = "TRUE" *)wire module_en_pedge;
(* MARK_DEBUG = "TRUE" *)wire module_en_nedge;
reg  module_en_dly1;
reg  module_en_dly2;
(* MARK_DEBUG = "TRUE" *)reg  module_en_flg;


always@(posedge clk_in or negedge rst_n) begin
    if(~rst_n) begin
        led <= 1'd0;
        led_count <= 23'd0;
    end
    else begin
        if(led_count == led_max_cnt) begin
            led_count <= 23'd0;
            led <= ~led;
        end
        else begin
            led_count <= led_count + 1'b1;
        end
    end
end

always@(posedge clk_in or negedge rst_n) begin
	if(!rst_n) begin
		sample_en <= 1'b0;
		triggle <= 1'b0;
		count <= 32'd0;
		ext_count <= 32'd0;
		state <= S_IDLE;
	end
	else if(trig_sel) begin //1 for internal trigger source
		case(state)
			S_IDLE: begin //0
				if(module_en_flg) begin
					state <= S_FIRST_TRIG;
				end
				else begin
					state <= S_IDLE;
				end
			end
			S_FIRST_TRIG: begin //1
				if(count == triggle_width) begin
					triggle <= 1'b0;
					count <= count + 1'b1;
					state <= S_WAIT_INTERV;
				end
				else begin
					triggle <= 1'b1;
					sample_en <= 1'b1;
					count <= count + 1'b1;
				end
			end
			S_WAIT_INTERV: begin //3
				if(count == pulse_width) begin
				    sample_en <= 1'b0;
					count <= count + 1'b1;
					state <= S_SECOND_TRIG;
				end
				else begin
					count <= count + 1'b1;
				end
			end
			S_SECOND_TRIG: begin //2
				if(count == pulse_width + triggle_delay) begin
					triggle <= 1'b1;
					count <= count + 1'b1;
					state <= S_WAIT_PRT;
				end
				else begin				    
					count <= count + 1'b1;
				end
			end
			S_WAIT_PRT: begin //4
				if(count == pulse_width + triggle_delay + triggle_width) begin
					triggle <= 1'b0;
					count <= count + 1'b1;
				end
				else if(count == prt_count - 1'b1) begin
					state <= S_IDLE;
					count <= 32'd0;
				end
				else begin
					count <= count + 1'b1;
				end
			end
			default: begin
				sample_en <= 1'b0;
				triggle <= 1'b0;
				count <= 32'd0;
				state <= S_IDLE;
			end
		endcase
	end
	else if(~trig_sel) begin //0 for external trigger source
		case(state)
			S_IDLE: begin //0
				if(module_en_flg) begin
					state <= S_FIRST_TRIG;
				end
				else begin
					state <= S_IDLE;
				end
			end
			S_FIRST_TRIG: begin //1
				if(ext_count == triggle_width) begin
					triggle <= 1'b0;
					ext_count <= ext_count + 1'b1;
					state <= S_WAIT_INTERV;
				end
				else begin
					triggle <= 1'b1;
					sample_en <= 1'b1;
					ext_count <= ext_count + 1'b1;
				end
			end
			S_WAIT_INTERV: begin //3
				if(ext_count == pulse_width) begin
					sample_en <= 1'b0;
					ext_count <= ext_count + 1'b1;
				end
				if(ext_count == pulse_width + triggle_delay) begin
					triggle <= 1'b1;					
					ext_count <= ext_count + 1'b1;
					state <= S_SECOND_TRIG;
				end
				else begin
					ext_count <= ext_count + 1'b1;
				end
			end
			S_SECOND_TRIG: begin //2
				if(ext_count == pulse_width + triggle_width + triggle_delay) begin
					triggle <= 1'b0;
					ext_count <= ext_count + 1'b1;
					state <= S_WAIT_PRT;
				end
				else begin
					ext_count <= ext_count + 1'b1;
				end
			end
			S_WAIT_PRT: begin //4
				if(ext_count == 16'd49000) begin
					state <= S_IDLE;
					ext_count <= 16'd0;
				end
				else begin
					ext_count <= ext_count + 1'b1;
				end
			end
			default: begin
				sample_en <= 1'b0;
				triggle <= 1'b0;
				ext_count <= 16'd0;
				state <= S_IDLE;
			end
		endcase
	end
end

always@(posedge clk_in or negedge rst_n) begin
	if(!rst_n) begin
		ext_trig_dly1 <= 1'b0;
		ext_trig_dly2 <= 1'b0;
		ext_trig_dly3 <= 1'b0;
	end
	else begin
		ext_trig_dly1 <= ext_trig;
		ext_trig_dly2 <= ext_trig_dly1;
		ext_trig_dly3 <= ext_trig_dly2;
	end
end
assign ext_trig_pedge = (!ext_trig_dly3) & ext_trig;

always@(posedge clk_in or negedge rst_n) begin
	if(!rst_n) begin
		module_en_dly1 <= 1'b0;
		module_en_dly2 <= 1'b0;
	end
	else begin
		module_en_dly1 <= module_en;
		module_en_dly2 <= module_en_dly1;
	end
end
assign module_en_pedge = (!module_en_dly2) & module_en;
assign module_en_nedge = module_en_dly2 & (!module_en);

always@(posedge clk_in or negedge rst_n) begin
	if(!rst_n) begin
		module_en_flg <= 1'b0;
	end
	else if(module_en_pedge) begin
		module_en_flg <= 1'b1;
	end
	else if(module_en_nedge) begin
		module_en_flg <= 1'b0;
	end
end

//  首个脉冲发出标志
(* MARK_DEBUG = "TRUE" *) reg first_pulse_out_flag;
(* MARK_DEBUG = "TRUE" *) reg first_pulse_out_flag_t;
always@(posedge sys_clk or negedge rst_n) begin
    if(!rst_n) begin
        first_pulse_out_flag <= 1'b0;
    end
    else if(sample_start) begin
        first_pulse_out_flag <= 1'b1;
    end
    else if(~sample_start) begin
        first_pulse_out_flag <= 1'b0;
    end
    else begin
        first_pulse_out_flag <= first_pulse_out_flag;
    end
end
always@(posedge sys_clk or negedge rst_n) begin
    if(!rst_n) begin
        first_pulse_out_flag_t <= 1'b0;
    end
    else begin
        first_pulse_out_flag_t <= first_pulse_out_flag;
    end
end

assign first_pulse_flag = first_pulse_out_flag & ~first_pulse_out_flag_t;

// 供时间对齐模块使用的clk_cnt信号
(* MARK_DEBUG = "TRUE" *)reg clk_cnt_flag; // 当此信号拉高，就可以开始计数
always@(posedge sys_clk or negedge rst_n) begin
	if(!rst_n) begin
		clk_cnt_flag <= 1'b0;
		end
	else begin
	   if(first_pulse_flag) begin
		clk_cnt_flag <= 1'b1;
		end
	   else if(utc_done) begin
		clk_cnt_flag <= 1'b0;
		end
	end
end
	
always@(posedge sys_clk or negedge rst_n) begin
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


