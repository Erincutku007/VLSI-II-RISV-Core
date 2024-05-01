`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/01/2024 04:59:44 PM
// Design Name: 
// Module Name: FetchStage
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


module FetchStage(
        input clk,rst
    );
    i_mem(
        .clk(clk),
        .rst(rst),
        .rd_addr0(),
        .wr_addr0(),
        .wr_din0(),
        .we0(1'b0),
        .rd_dout0()
    );
endmodule
