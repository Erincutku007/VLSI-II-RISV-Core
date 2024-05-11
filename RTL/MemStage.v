`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/01/2024 03:06:15 PM
// Design Name: 
// Module Name: MemStage
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


module MemStage(
        input clk,rst,
        input wire [31:0]calculated_adr,pc_plus_4_ex,ALU_result,regfileb_ex,
        input wire [13:0]control_word_ex,
        output wire [31:0] mem_data_out,target_pc,pc_plus_4_mem,ALU_result_mem,
        output wire [8:0]control_word_mem
    );
    wire branch_taken,rf_wb,mem_we,pc_src,pc_src_mem;
    wire [1:0] wb_src;
    wire [2:0] funct3;
    wire [4:0] rd;
    assign {branch_taken,rf_wb,mem_we,wb_src,pc_src,rd,funct3} = control_word_ex;
    //mem module instantation
    DataMem #(.MEM_DEPTH(64),.MEMDATA("dmem.mem")) dmem (
    .clk(clk),
    .rst(rst),
    .rd_addr0(calculated_adr),
    .wr_addr0(calculated_adr),
    .wr_din0(regfileb_ex),
    .we0(mem_we),
    .wr_strb(funct3),
    .rd_dout0(mem_data_out)
    );
    //new control word
    assign pc_src_mem = branch_taken & pc_src;
    assign control_word_mem = {rf_wb,wb_src,pc_src_mem,rd};
    assign target_pc = calculated_adr;
    assign pc_plus_4_mem = pc_plus_4_ex;
    assign ALU_result_mem = ALU_result;
endmodule
