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
module CU(
    input clk,
    input rst,
    input [31:0]instruction, // memory_data_output,
    input [31:0] wb_data_wb, calculated_adr_ex, // normally from writeback
    input wb_rf_wb, // normally from writeback
    input [4:0] wb_rd_wb, // normally from writeback
    input branch_taken_E, pc_src_E,
    output [31:0]pc_if, // mem_read_adr,mem_write_adr,
    // output [31:0]mem_write_data,
    // output mem_we0,
    // output [3:0]wmask
    );
    
    //writeback output signals
    // wire wb_pc_src_wb;
    // wire wb_rf_wb;
    // wire [4:0]wb_rd_wb;
    // wire [31:0]wb_target_pc_wb,wb_data_wb,calculated_adr_ex;
    assign wb_data_o = wb_data_wb;

    //stall and flush signals
    // wire branch_taken_E;
    wire forward_adr_from_ex; // pc_src_E;
    assign forward_adr_from_ex = branch_taken_E | pc_src_E;
    //core connections
    wire [31:0]pc_plus_4_if;

    PC fetch(
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
    
    ID decode(
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
endmodule
