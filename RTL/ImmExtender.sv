`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2024 08:20:34 PM
// Design Name: 
// Module Name: ImmExtend
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


module ImmExtender(
        input wire[31:0]inst,
        input wire[2:0]op_type,
        output wire [31:0]imm_out
    );
    typedef enum {I,IStar,S,B,U,J,R} instruction_type;
    instruction_type inst_type;
    reg [31:0]imm;
    
    assign inst_type = instruction_type'(op_type);
    
    always_comb begin
        case(inst_type)
            I: imm = { {21{inst[31]}} ,inst[30:25],inst[24:21],inst[20]};
            S: imm = { {21{inst[31]}} ,inst[30:25],inst[11:8],inst[7]};
            B: imm = { {20{inst[31]}} ,inst[7],inst[30:25],inst[11:8],1'b0};
            U: imm = { inst[31],inst[30:20],inst[19:12],12'b0};
            J: imm = { {12{inst[31]}} ,inst[19:12],inst[20],inst[30:25],inst[24:21],1'b0};
            default: imm = 32'b0;
        endcase
    end
    assign imm_out = imm;
endmodule
