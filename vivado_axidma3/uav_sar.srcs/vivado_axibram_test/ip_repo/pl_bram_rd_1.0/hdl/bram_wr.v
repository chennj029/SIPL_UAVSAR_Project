`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/01/09 18:18:12
// Design Name: 
// Module Name: bram_wr
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


module bram_wr(
    input                   clk,
    input                   rst_n,
    
    input   [7:0]           uart_rx_data,
    input                   uart_rx_done,

    // RAM Ports
    output                   ram_clk,
    output                   ram_rst,
    output                   ram_en, // 端口使能
    output      [31:0]       ram_addr,  // 最大8192（根据BRAM深度调整位宽）
    output       [3:0]       ram_we,
    output      [31:0]       ram_wr_data,  // din
    input      [31:0]        ram_rd_data   // dout
);

    assign ram_clk = clk;
    assign ram_rst = 1'b0; // BRAM 不复位
    assign ram_en = 1'b1;  // BRAM 始终使能
    
    reg [31:0] addr; // BRAM 地址计数器，调整为 13 位以适配深度为 8192 的 BRAM
    reg [7:0] uart_data_reg [0:3]; // 存储接收的4个字符
    reg [1:0] uart_data_count;     // 计数4个字符进行拼接，然后写入
    reg [31:0] bram_data_reg;      // 拼接后的32位数据

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            addr <= 32'd0;
            uart_data_reg[0] <= 8'b0;
            uart_data_reg[1] <= 8'b0;  
            uart_data_reg[2] <= 8'b0; 
            uart_data_reg[3] <= 8'b0;         
            uart_data_count <= 2'd0;
        end 
        else if (uart_rx_done) begin
            // 存储接收到的字符
            uart_data_reg[uart_data_count] <= uart_rx_data;
            uart_data_count <= uart_data_count + 1'b1;
            
            // 每接收到4个字符，拼接为32bit数据并写入BRAM
            if (uart_data_count == 2'd3) begin
                bram_data_reg <= {uart_data_reg[3], uart_data_reg[2], uart_data_reg[1], uart_data_reg[0]};
                uart_data_count <= 2'd0; // 重置计数器

                // 地址溢出保护
                if (addr == 32'd8191)
                    addr <= 32'd0; // 如果地址超过范围，重置
                else
                    addr <= addr + 1;
            end
        end
    end

    assign ram_addr = addr;
    assign ram_wr_data = bram_data_reg; 
    assign ram_we = (uart_data_count == 2'd3) ? 4'b1111 : 4'b0000; // 写使能信号

endmodule

