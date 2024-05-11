`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2024 10:38:35 PM
// Design Name: 
// Module Name: i_mem
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


module i_mem #(parameter MEM_DATA = "") (
        input clk,
        input rst,
        input [31:0]rd_addr0,wr_addr0,
        input [31:0]wr_din0,
        input we0,
        output [31:0]rd_dout0
    );
    
    mem_1r1w #(32,16,MEM_DATA) iram(
        .clk(clk),
        .rst(rst),
        .rd_addr0(rd_addr0[6:0]),
        .wr_addr0(wr_addr0[6:0]),
        .wr_din0(wr_din0),
        .we0(we0),
        .rd_dout0(rd_dout0)
    );
endmodule
