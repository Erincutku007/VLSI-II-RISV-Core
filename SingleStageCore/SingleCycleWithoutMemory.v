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
////////////////////////////////////////////////////////////////////////////////////
module SingleCycleWithoutMemory(
    input clk,
    input rst,
    input [31:0]instruction,memory_data_output,
    output [31:0]pc_if,mem_read_adr,mem_write_adr,
    output [31:0]mem_write_data,
    output mem_we0,
    output [3:0]wmask
    );
    
    //writeback output signals
    wire wb_pc_src_wb;
    wire [1:0]wb_rf_wb;
    wire [4:0]wb_rd_wb;
    wire [31:0]wb_target_pc_wb,wb_data_wb,calculated_adr_ex;
    assign wb_data_o = wb_data_wb;
    //stall and flush signals
    wire branch_taken_E;
    wire forward_adr_from_ex,pc_src_E;
    assign forward_adr_from_ex = branch_taken_E | pc_src_E;
    //core connections
    wire [31:0]pc_plus_4_if;
    FetchStage fetch(
        .clk(clk),
        .rst(rst),
        .forward_adr_from_ex(forward_adr_from_ex),
        .target_pc(calculated_adr_ex),
        .PC_if(pc_if),
        .PC_plus_four_if(pc_plus_4_if)
    );
    localparam if_dec_reg_size = 32*3;
    wire [if_dec_reg_size:0] fetch_to_dec_in,fetch_to_dec_out;
    assign fetch_to_dec_in = {1'b1,pc_if,pc_plus_4_if,instruction};
    
    
    //decode input signals
    wire decode_valid_raw,decode_valid;
    wire [31:0] pc_if_to_dec,pc_plus_4_if_to_dec,instruction_to_dec;
    //temporary
    assign fetch_to_dec_out = fetch_to_dec_in;
    assign {decode_valid_raw,pc_if_to_dec,pc_plus_4_if_to_dec,instruction_to_dec} = fetch_to_dec_out;
    //decode output signals
    wire [31:0]regfilea_dec,regfileb_dec,imm_dec,pc_dec,pc_plus_4_dec;
    wire [27:0]control_word_dec;
    assign decode_valid = decode_valid_raw;
    localparam dec_ex_reg_size = 5*32+28;
    wire [dec_ex_reg_size:0] dec_ex_reg_in,dec_ex_reg_out;
    assign dec_ex_reg_in = {decode_valid,regfilea_dec,regfileb_dec,imm_dec,pc_dec,pc_plus_4_dec,control_word_dec};
    //hazard handling wires
    wire wb_valid;
    wire [31:0]ALU_result_ex,ALU_result_mem;
    wire [4:0] rs1_dec,rs2_dec;
    //wire [3:0] RAW_mem_hazards;
    
    DecodeStage dec(
    .clk(clk),
    .instruction(instruction_to_dec),
    .pc_if(pc_if_to_dec),
    .pc_plus_4_if(pc_plus_4_if_to_dec),
    .wb_data(wb_data_wb),
    .wadr(wb_rd_wb),
    .we_wb(wb_rf_wb),
    .regfilea(regfilea_dec),
    .regfileb(regfileb_dec),
    .imm(imm_dec),
    .pc_dec(pc_dec),
    .pc_plus_4_dec(pc_plus_4_dec),
    .control_word_dec(control_word_dec)
    );
    
    //temp
    assign dec_ex_reg_out = dec_ex_reg_in;
    //execute input signals
    wire execute_valid_raw,execute_valid;
    wire [31:0] regfilea_dec_to_ex,regfileb_dec_to_ex,imm_dec_to_ex,pc_dec_to_ex,pc_plus_4_dec_to_ex;
    wire [27:0] control_word_dec_to_ex,control_word_dec_to_ex_raw;
    assign {execute_valid_raw,regfilea_dec_to_ex,regfileb_dec_to_ex,imm_dec_to_ex,pc_dec_to_ex,pc_plus_4_dec_to_ex,control_word_dec_to_ex} = dec_ex_reg_out;
    //execute output signals
    wire [31:0] regfileb_ex;
    wire [13:0]control_word_ex;
    assign execute_valid = execute_valid_raw;
    localparam ex_mem_reg_size = 32*3+14;
    wire [ex_mem_reg_size:0] ex_mem_reg_in,ex_mem_reg_out;
    assign ex_mem_reg_in = {execute_valid,calculated_adr_ex,ALU_result_ex,regfileb_ex,control_word_ex};
    
    ExecuteStage ex(
        .control_word_dec(control_word_dec_to_ex),
        .pc_plus_4_dec(pc_plus_4_dec_to_ex),
        .pc_dec(pc_dec_to_ex),
        .imm(imm_dec_to_ex),
        .regfilea(regfilea_dec_to_ex),
        .regfileb(regfileb_dec_to_ex),
        .calculated_adr(calculated_adr_ex),
        .ALU_result(ALU_result_ex),
        .regfileb_ex(regfileb_ex),
        .control_word_ex(control_word_ex)
    );
    
    //temp
    assign ex_mem_reg_out = ex_mem_reg_in;
    //memory input signals
    wire memory_valid_raw,memory_valid;
    wire [31:0] calculated_adr_ex_to_mem,ALU_result_ex_to_mem,regfileb_ex_to_mem;
    wire [13:0]control_word_ex_to_mem,control_word_ex_to_mem_raw;
    assign {memory_valid_raw,calculated_adr_ex_to_mem,ALU_result_ex_to_mem,regfileb_ex_to_mem,control_word_ex_to_mem} = ex_mem_reg_out;
    //{branch_taken,rf_wb,mem_we,wb_src,pc_src,rd,funct3}
//    assign control_word_ex_to_mem = control_word_ex_to_mem_raw & {14{memory_valid_raw}};
    //memory output signals
    assign memory_valid = memory_valid_raw;
    wire [31:0]mem_data_out_mem;
    wire [8:0]control_word_mem;
    localparam mem_wb_reg_size = 3*32+9;
    wire [mem_wb_reg_size:0]mem_wb_reg_in,mem_wb_reg_out;
    assign mem_wb_reg_in = {memory_valid,mem_data_out_mem,ALU_result_mem,control_word_mem};
    //mem-core interface
//     {branch_taken,rf_wb,mem_we,wb_src,pc_src,rd,funct3}
    assign mem_we0 = control_word_ex_to_mem[11];
    assign mem_read_adr = calculated_adr_ex_to_mem;
    assign mem_write_adr = calculated_adr_ex_to_mem;
    MemStageWithoutMemory mem(
        .calculated_adr(calculated_adr_ex_to_mem),
        .ALU_result(ALU_result_ex_to_mem),
        .regfileb_ex(regfileb_ex_to_mem),
        .data_read_from_memory(memory_data_output),
        .control_word_ex(control_word_ex_to_mem),
        .mem_write_in(mem_write_data),
        .ALU_result_mem(ALU_result_mem),
        .memory_stage_data(mem_data_out_mem),
        .control_word_mem(control_word_mem),
        .wmask(wmask)
    );
    //temp
    assign mem_wb_reg_out = mem_wb_reg_in;
    //writeback input signals
    wire [31:0]mem_data_out_mem_to_wb,ALU_result_mem_to_wb;
    wire [8:0]control_word_mem_to_wb;
    assign {wb_valid,mem_data_out_mem_to_wb,ALU_result_mem_to_wb,control_word_mem_to_wb} = mem_wb_reg_out;
    
    WriteBackStage wb(
        .mem_data_out(mem_data_out_mem_to_wb),
        .ALU_result_mem(ALU_result_mem_to_wb),
        .control_word_mem(control_word_mem_to_wb),
        .wb_pc_src(wb_pc_src_wb),
        .wb_rf_wb(wb_rf_wb),
        .wb_rd(wb_rd_wb),
        .wb_data(wb_data_wb)
    );
    
    assign branch_taken_E = control_word_ex[13];
    assign pc_src_E = control_word_dec_to_ex[15];
endmodule
