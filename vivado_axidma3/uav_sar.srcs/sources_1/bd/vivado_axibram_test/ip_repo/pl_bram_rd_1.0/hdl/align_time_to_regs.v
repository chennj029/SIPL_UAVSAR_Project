`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/01/09 18:54:38
// Design Name: 
// Module Name: align_time_to_regs
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


module align_time_to_regs (
    input  wire         clk,               // 时钟信号
    input  wire         rst_n,             // 复位信号
    input  wire [79:0]  align_time,        // 对齐后的时间戳
    input  wire         time_aligned_done, // 对齐完成标志
    output reg  [31:0]  slv_reg0,          // 对应 align_time[31:0]
    output reg  [31:0]  slv_reg1,          // 对应 align_time[63:32]
    output reg  [31:0]  slv_reg2           // 对应 align_time[79:64]（高 16 位）
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            slv_reg0 <= 32'b0;
            slv_reg1 <= 32'b0;
            slv_reg2 <= 32'b0;
        end else if (time_aligned_done) begin
            // 更新寄存器内容
            slv_reg0 <= align_time[31:0];       // align_time 低 32 位
            slv_reg1 <= align_time[63:32];      // align_time 中间 32 位
            slv_reg2 <= {16'b0, align_time[79:64]}; // align_time 高 16 位
        end
    end

endmodule

