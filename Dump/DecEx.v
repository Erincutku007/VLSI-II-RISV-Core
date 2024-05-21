`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2024 01:35:48 PM
// Design Name: 
// Module Name: DecEx
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


module DecEx(
    input clk,
    input rst,
    input [31:0]instruction,pc_if,pc_plus_4_if,
    output [31:0]ALU_result
    );
    wire branch_taken_ex,rf_wb_ex,mem_we_ex,pc_src_ex;
    wire [1:0]wb_src_ex;
    wire [2:0]funct3_ex;
    wire [4:0]rd_ex;
    
    wire [13:0]control_word_ex;
    wire [23:0]control_word_dec;
    wire [31:0]regfilea,regfileb,imm,pc_dec,pc_plus_4_dec;
    assign {branch_taken_ex,rf_wb_ex,mem_we_ex,wb_src_ex,pc_src_ex,rd_ex,funct3_ex} = control_word_ex;
    
    assign test = imm;
    
    DecodeStage dec(
    .clk(clk),
    .rst(rst),
    .instruction(instruction),
    .pc_if(pc_if),
    .pc_plus_4_if(pc_plus_4_if),
    .wb_data(ALU_result),
    .wadr(rd_ex),
    .we_wb(rf_wb_ex),
    .regfilea(regfilea),
    .regfileb(regfileb),
    .imm(imm),
    .pc_dec(pc_dec),
    .pc_plus_4_dec(pc_plus_4_dec),
    .control_word_dec(control_word_dec)
    );
    ExecuteStage ex(
        .control_word_dec(control_word_dec),
        .pc_plus_4_dec(pc_plus_4_dec),
        .pc_dec(pc_dec),
        .imm(imm),
        .regfilea(regfilea),
        .regfileb(regfileb),
        .calculated_adr(),
        .pc_plus_4_ex(),
        .ALU_result(ALU_result),
        .regfileb_ex(),
        .control_word_ex(control_word_ex)
    );
endmodule
