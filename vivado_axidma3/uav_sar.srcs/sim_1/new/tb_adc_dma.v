`timescale 1ns / 1ps

module tb_adc_dma();

// 时钟/复位
reg sys_clk;
reg rst_n;
reg adc_clk;
reg adc_rst_n;
reg M_AXIS_CLK;
reg M_AXIS_RSTN;

// ADC data interface
reg [15:0] adc_data;
reg start_clr_ack;

// PS端控制寄存器
reg [31:0] prt_count;
reg [31:0] pulse_width;
reg  	   module_en;
reg 	   sample_start;
reg [31:0] sample_len;
reg [31:0] DMA_pack_len;
reg DMA_start;

// AXI Stream interface
reg 		M_AXIS_tready;
wire [15:0] M_AXIS_tdata;
wire [1:0]  M_AXIS_tkeep;
wire   		M_AXIS_tlast;
wire 		M_AXIS_tvalid;

// output signals
wire start_clr;
wire triggle;
wire led;


// wire
wire sample_en;
wire [63:0] clk_cnt;
wire first_pulse_flag;

initial begin
	M_AXIS_tready = 1'b1;
end

// Clock generation
initial begin
	sys_clk = 0;
	forever #5 sys_clk = ~sys_clk; // 100MHz
end

initial begin
	adc_clk = 0;
	forever #10 adc_clk = ~adc_clk; // 50MHz
end

initial begin
	M_AXIS_CLK = 0;
	forever #5 M_AXIS_CLK = ~M_AXIS_CLK;
end

// reset generation
initial begin
	rst_n = 0;
	adc_rst_n = 0;
	M_AXIS_RSTN = 0;
	#20;
	rst_n = 1;
	adc_rst_n = 1;
	M_AXIS_RSTN = 1;
end

// 寄存器控制
initial begin
	module_en = 1'b0;
	sample_start = 1'b0;
	prt_count = 32'd0;
	pulse_width = 32'd0;
	sample_len = 32'd0;
	DMA_pack_len = 32'd0;
	DMA_start = 1'b0;
	#100;
	prt_count = 32'd8000;
	pulse_width = 32'd2000;
	#20;
	sample_len = 32'd20000;
	#20;
	sample_start = 1'b1;
	#20; // adc_clk下延时一拍
	module_en = 1'b1;
	#20;
	sample_start = 1'b0;
	#20;
	DMA_pack_len = 32'd20000;
	#20;
	DMA_start = 1'b1;
	#40;
	DMA_start = 1'b0;
	
	// wait for tlast
	wait(M_AXIS_tlast == 1'b1)
	#100
	module_en = 1'b0;
	prt_count = 32'd0;
	pulse_width = 32'd0;
	#100;
	prt_count = 32'd8000;
	pulse_width = 32'd2000;
	#20;
	sample_len = 32'd20000;
	#20;
	sample_start = 1'b1;
	#20;
	module_en = 1'b1;
	#20;
	sample_start = 1'b0;
	#20;
	DMA_pack_len = 32'd20000;
	#20;
	DMA_start = 1'b1;
	#40;
	DMA_start = 1'b0;
	
end

// 生成ADC数据
always@(posedge adc_clk or negedge adc_rst_n) begin
	if(!adc_rst_n) begin
		adc_data <= 16'd0;
	end
	else if(sample_en && dut.state == dut.S_SAMPLE) begin
		adc_data <= adc_data + 1'b1;
	end
end

// 产生start_clr_ack信号
reg start_clr_d1;
always @(posedge adc_clk or negedge adc_rst_n) begin
  if (!adc_rst_n) begin
    start_clr_d1  <= 1'b0;
    start_clr_ack <= 1'b0;
  end else begin
    start_clr_d1  <= start_clr;
    start_clr_ack <= start_clr & ~start_clr_d1;
  end
end
		
// 例化
clk_div u_clk_div(
	.sys_clk 			(sys_clk),
	.clk_in				(adc_clk),
	.rst_n				(rst_n),
	.ext_trig   		(1'b0),
	.prt_count			(prt_count),
	.pulse_width		(pulse_width),
	.module_en			(module_en),
	.trig_sel			(1'b1),
			
	.utc_done			(1'b0),
	.triggle			(triggle),
	.sample_en			(sample_en),
	.led				(led),
	.sample_start		(sample_start),
	.clk_cnt			(clk_cnt),
	.first_pulse_flag 	(first_pulse_flag)
);
	

ad9269_sample #(.DEBUG(0)) dut(
	.adc_clk 			(adc_clk),
	.adc_rst_n			(adc_rst_n),
	.adc_data			(adc_data),
	.sample_len			(sample_len),
	.sample_start		(sample_start),
	.sample_en			(sample_en),
	
	.start_clr_ack		(start_clr_ack),
	.start_clr			(start_clr),
	
	.DMA_pack_len		(DMA_pack_len),
	.DMA_start 			(DMA_start),
	
	.M_AXIS_CLK			(M_AXIS_CLK),
	.M_AXIS_RSTN		(M_AXIS_RSTN),
	.M_AXIS_tready		(M_AXIS_tready),
	.M_AXIS_tdata		(M_AXIS_tdata),
	.M_AXIS_tkeep		(M_AXIS_tkeep),
	.M_AXIS_tlast		(M_AXIS_tlast),
	.M_AXIS_tvalid		(M_AXIS_tvalid)
);
	

endmodule