`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2024 02:24:37 PM
// Design Name: 
// Module Name: RegFile
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


module RegFile#(parameter WIDTH = 32,parameter ADRESS_WIDTH = 5,parameter DEPTH = 32)(
        input clk,
        input rst,
        input [ADRESS_WIDTH-1:0]rd_addr0,rd_addr1,wr_addr0,
        input [WIDTH-1:0]wr_din0,
        input we0,
        output reg [WIDTH-1:0]rd_dout0,rd_dout1
    );
    reg [WIDTH-1:0] ram_block [DEPTH-1:0];
    integer i = 0;
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            for (i=0;i<DEPTH;i=i+1)begin
                ram_block[i] = 0;
            end
        end
        else if (we0 & (wr_addr0 != 5'd0))
            ram_block[wr_addr0] <= wr_din0;
    end
    wire test = we0 & (wr_addr0 != 0);
    always @(*) begin
        rd_dout0 = ram_block[rd_addr0];
        rd_dout1 = ram_block[rd_addr1];
    end
endmodule
