`timescale 1ns / 1ps
`include "mem_1r1w.v"
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


module i_mem #(parameter WIDTH = 32,parameter DEPTH = 4)(
        input clk,
        input rst,
        input [31:0]rd_addr0,wr_addr0,
        input [31:0]wr_din0,
        input we0,
        output [31:0]rd_dout0
    );
    
    mem_1r1w #(WIDTH,DEPTH,1) iram(
        .clk(clk),
        .rst(rst),
        .rd_addr0(rd_addr0[$clog2(DEPTH)+1:0]),
        .wr_addr0(wr_addr0[$clog2(DEPTH)+1:0]),
        .wr_din0(wr_din0),
        .we0(we0),
        .rd_dout0(rd_dout0)
    );
endmodule
