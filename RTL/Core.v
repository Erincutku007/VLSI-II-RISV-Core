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


module Core(
    input clk,
    input rst,
    output [31:0]wb_data_o
    );
    wire [4:0]wb_rd;
    wire [8:0]control_word_mem;
    wire [13:0]control_word_ex;
    wire [23:0]control_word_dec;
    wire [31:0]regfilea,regfileb,imm,pc_dec,pc_plus_4_dec,calculated_adr,mem_data_out,wb_data,wb_target_pc,
    pc_plus_4_ex,regfileb_ex,ALU_result,pc_plus_4_mem,ALU_result_mem,target_pc,pc_if,instruction,pc_plus_4_if;
    
    assign wb_data_o = wb_data;
    
    FetchStage fetch(
        .clk(clk),
        .rst(rst),
        .pc_src(wb_pc_src),
        .target_pc(wb_target_pc),
        .PC_if(pc_if),
        .PC_plus_four_if(pc_plus_4_if),
        .instruction_if(instruction)
    );

    DecodeStage dec(
    .clk(clk),
    .rst(rst),
    .instruction(instruction),
    .pc_if(pc_if),
    .pc_plus_4_if(pc_plus_4_if),
    .wb_data(wb_data),
    .wadr(wb_rd),
    .we_wb(wb_rf_wb),
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
        .rst(1'b1),
        .calculated_adr(calculated_adr),
        .pc_plus_4_ex(pc_plus_4_ex),
        .ALU_result(ALU_result),
        .regfileb_ex(regfileb_ex),
        .control_word_ex(control_word_ex),
        .mem_data_out(mem_data_out),
        .target_pc(target_pc),
        .pc_plus_4_mem(pc_plus_4_mem),
        .ALU_result_mem(ALU_result_mem),
        .control_word_mem(control_word_mem)
    );
    WriteBackStage wb(
        .mem_data_out(mem_data_out),
        .target_pc(target_pc),
        .pc_plus_4_mem(pc_plus_4_mem),
        .ALU_result_mem(ALU_result_mem),
        .control_word_mem(control_word_mem),
        .wb_pc_src(wb_pc_src),
        .wb_rf_wb(wb_rf_wb),
        .wb_rd(wb_rd),
        .wb_target_pc(wb_target_pc),
        .wb_data(wb_data)
    );
endmodule
