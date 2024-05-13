`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2024 01:09:26 PM
// Design Name: 
// Module Name: Adder
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

module Adder (input wire cin,
              input [31:0] a, b,
              output cout,
              output [31:0] y);

wire [32:0] c;
assign c[0] = cin;
assign cout = c[32];

generate
  genvar i;
  for (i = 0; i < 32; i = i + 1)
    begin : generate_FA    
        FA fa (.a(a[i]), .b(b[i]), .c_in(c[i]), .c_out(c[i+1]), .sum(y[i]));
    end
endgenerate 

endmodule

module FA (input a, b, c_in,
           output c_out, sum);

assign sum = a ^ b ^ c_in;
assign c_out = (c_in & (a ^ b)) | (a & b);

endmodule

