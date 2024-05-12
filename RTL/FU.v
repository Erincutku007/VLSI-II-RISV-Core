`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2024 08:08:14 PM
// Design Name: 
// Module Name: ALU
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

module FU(
    input wire [6:0]funct7,
    input wire [2:0]funct3,
    input wire [31:0]A,B,
    output wire [31:0]result,
    output wire [3:0]alu_flags
    );
    
    ALU alu (
        .funct7(funct7),
        .funct3(funct3),
        .A(A),.B(B),
        .result(result_tmp),
        .alu_flags(alu_flags)
    );
    
    Shifter shifter (
        .a(A),
        .b(B[4:0]),
        .mode(funct7[5]),
        .sel(funct3[2]),
        .y(y)
    );

    wire [31:0]y;
    wire [31:0]result_tmp;
    reg [31:0] res;

    always@(*) begin
        if(funct3[1:0] == 2'b01)
            res = y;
        else
            res = result_tmp;
    end
    assign result = res;
endmodule
