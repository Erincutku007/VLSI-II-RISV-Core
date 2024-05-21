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


module DecExMem(
    input clk,
    input rst,
    input [31:0]instruction,pc_if,pc_plus_4_if,
    output pc_src_mem,
    output [31:0]mem_data_out,target_pc
    );
    wire branch_taken_ex,rf_wb_ex,mem_we_ex,pc_src_ex,
    rf_wb;
    wire [1:0]wb_src_ex,wb_src;
    wire [2:0]funct3_ex;
    wire [8:0]control_word_mem;
    wire [4:0]rd_ex,rd;
    
    wire [13:0]control_word_ex;
    wire [23:0]control_word_dec;
    wire [31:0]regfilea,regfileb,imm,pc_dec,pc_plus_4_dec,calculated_adr
    ,pc_plus_4_ex,regfileb_ex,ALU_result;
    assign {branch_taken_ex,rf_wb_ex,mem_we_ex,wb_src_ex,pc_src_ex,rd_ex,funct3_ex} = control_word_ex;
    assign {rf_wb,wb_src,pc_src_mem,rd} = control_word_mem;
    
    DecodeStage dec(
    .clk(clk),
    .rst(rst),
    .instruction(instruction),
    .pc_if(pc_if),
    .pc_plus_4_if(pc_plus_4_if),
    .wb_data(ALU_result),
    .wadr(rd),
    .we_wb(rf_wb),
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
        .calculated_adr(calculated_adr),
        .pc_plus_4_ex(pc_plus_4_ex),
        .ALU_result(ALU_result),
        .regfileb_ex(regfileb_ex),
        .control_word_ex(control_word_ex)
    );
    MemStage mem(
        .clk(clk),
        .rst(rst),
        .calculated_adr(calculated_adr),
        .pc_plus_4_ex(pc_plus_4_ex),
        .ALU_result(ALU_result),
        .regfileb_ex(regfileb_ex),
        .control_word_ex(control_word_ex),
        .mem_data_out(mem_data_out),
        .target_pc(target_pc),
        .control_word_mem(control_word_mem)
    );
endmodule
