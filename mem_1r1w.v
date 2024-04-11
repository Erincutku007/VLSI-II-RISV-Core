`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2024 10:00:31 PM
// Design Name: 
// Module Name: mem_1r1w
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


module mem_1r1w #(parameter WIDTH = 32,parameter DEPTH = 4)(
        input clk,
        input rst,
        input [31:0]rd_addr0,wr_addr0,
        input [WIDTH-1:0]wr_din0,
        input we0,
        output reg [WIDTH-1:0]rd_dout0
    );
    
    reg [WIDTH-1:0] ram_block [DEPTH-1:0];
    integer i = 0;
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            for (i=0;i<DEPTH;i=i+1)begin
                ram_block[i] = 0;
            end
        end
        else if (we0)
            ram_block[wr_addr0] <= wr_din0;
    end
    
    always @(*) begin
        rd_dout0 = ram_block[rd_addr0];
    end
endmodule
