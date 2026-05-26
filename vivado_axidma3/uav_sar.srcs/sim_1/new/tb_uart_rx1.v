`timescale 1ns / 1ps

module tb_uart_rx1;

  // ===================== 参数 =====================
  parameter integer CLK_FREQ  = 50_000_000;   // 50 MHz
  parameter integer UART_BPS  = 115200;
  // 在 timescale 1ns/1ps 下，用时间(ns)表示一个比特周期
  localparam integer BAUD_T_NS = 1_000_000_000 / UART_BPS; // ≈ 8680 ns/bit

  // ===================== 信号 =====================
  reg         clk;
  reg         rst_n;
  reg         uart_rxd;

  reg  [31:0] DMA_pack_len;
  reg         DMA_start;

  wire        uart_rx_done;
  wire [7:0]  uart_rx_data;

  wire        M_AXIS_CLK;
  wire        M_AXIS_RSTN;
  wire        M_AXIS_tready;
  wire        M_AXIS_tvalid;
  wire        M_AXIS_tlast;
  wire [31:0] M_AXIS_tdata;
  wire [3:0]  M_AXIS_tkeep;

  // 一帧 32 字节
  reg [7:0] gpgga_data [0:31];

  integer i, j, k;

  // ===================== 时钟 =====================
  initial clk = 1'b0;
  always #10 clk = ~clk;  // 50MHz

  // ===================== 连接被测模块输入 =====================
  assign M_AXIS_CLK    = clk;
  assign M_AXIS_RSTN   = rst_n;
  assign M_AXIS_tready = 1'b1;

  // ===================== 任务：发送一个字节（8N1） =====================
  task send_byte(input [7:0] data);
    begin
      // 起始位
      uart_rxd = 1'b0;
      #(BAUD_T_NS);

      // 8 个数据位，LSB first
      for (j = 0; j < 8; j = j + 1) begin
        uart_rxd = data[j];
        #(BAUD_T_NS);
      end

      // 停止位
      uart_rxd = 1'b1;
      #(BAUD_T_NS);
    end
  endtask

  // ===================== 任务：发送一整帧（数组全部字节） =====================
  task send_one_frame;
    begin
      for (i = 0; i < 32; i = i + 1) begin
        send_byte(gpgga_data[i]);
      end
    end
  endtask

  // ===================== 初始化 & 发送 15 帧 =====================
  
  initial begin
    // 准备一帧数据（32 字节）
    gpgga_data[0]  = "$";
    gpgga_data[1]  = "G";
    gpgga_data[2]  = "P";
    gpgga_data[3]  = "G";
    gpgga_data[4]  = "G";
    gpgga_data[5]  = "A";
    gpgga_data[6]  = ",";
    gpgga_data[7]  = "1";
    gpgga_data[8]  = "4";
    gpgga_data[9]  = "5";
    gpgga_data[10] = "9";
    gpgga_data[11] = "5";
    gpgga_data[12] = "9";
    gpgga_data[13] = ".";
    gpgga_data[14] = "3";
    gpgga_data[15] = "3";
    gpgga_data[16] = ",";
    gpgga_data[17] = "2";
    gpgga_data[18] = "2";
    gpgga_data[19] = "4";
    gpgga_data[20] = "8";
    gpgga_data[21] = ".";
    gpgga_data[22] = "1";
    gpgga_data[23] = "9";
    gpgga_data[24] = "4";
    gpgga_data[25] = "4";
    gpgga_data[26] = ",";
    gpgga_data[27] = "N";
    gpgga_data[28] = ",";
    gpgga_data[29] = "-";
    gpgga_data[30] = "1";
    gpgga_data[31] = "M";

	#200;
	
    // 发送 15 帧
    for (k = 0; k < 15; k = k + 1) begin
      send_one_frame();
      // 帧间隙：2 个字符时间（含起始/停止位），可按需调大/调小
      #(2*BAUD_T_NS*10);
    end
end
	
  initial begin
    // 初始值
    rst_n       = 1'b0;
    uart_rxd    = 1'b1;        // 空闲高
    DMA_pack_len= 32'd40;     // 5 帧 * 8 (32bit拍/帧) = 40
    DMA_start   = 1'b0;


    // 释放复位
    @(posedge clk);
    rst_n = 1'b1;

    // 先等一段时间攒点 FIFO 数据
    @(posedge clk);

    // 触发一次 DMA（1 个 clk 周期脉冲），包长度=800 拍
    DMA_start = 1'b1;
    @(posedge clk);
	@(posedge clk);
	@(posedge clk);
    DMA_start = 1'b0;

	
	// 第二包启动传输
	wait(M_AXIS_tlast == 1'b1)	
	// #(20);
	// $display("0000");
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	DMA_start = 1'b1;
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	DMA_start = 1'b0;
	// $display("mmmm");
 
	// 第三包启动传输
	wait(M_AXIS_tlast == 1'b1)
	// $display("1111");
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	DMA_start = 1'b1;
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	DMA_start = 1'b0;
	// $display("2222");
	
	// $stop;
  end

  // ===================== DUT =====================
  uart_rx1 uut (
    .clk          (clk),
    .rst_n        (rst_n),
    .uart_rxd     (uart_rxd),
    .uart_rx_done (uart_rx_done),
    .uart_rx_data (uart_rx_data),

    .DMA_pack_len (DMA_pack_len),
    .DMA_start    (DMA_start),

    .M_AXIS_CLK   (M_AXIS_CLK),
    .M_AXIS_RSTN  (M_AXIS_RSTN),
    .M_AXIS_tready(M_AXIS_tready),
    .M_AXIS_tdata (M_AXIS_tdata),
    .M_AXIS_tkeep (M_AXIS_tkeep),
    .M_AXIS_tlast (M_AXIS_tlast),
    .M_AXIS_tvalid(M_AXIS_tvalid)
  );

endmodule
