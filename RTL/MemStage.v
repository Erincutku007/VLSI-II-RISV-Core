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
        input wire [15:0]control_word_ex,
        output wire [31:0] mem_data_out,
        output wire [3:0]control_word_mem
    );
    wire branch_taken,rf_wb,mem_we,pc_src,funct3,pc_src_mem;
    wire [1:0] wb_src;
    assign {branch_taken,rf_wb,mem_we,wb_src,pc_src,funct3} = control_word_ex;
    //mem module instantation
    DataMem #(2**32) dmem (
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
    assign control_word_mem = {rf_wb,wb_src,pc_src_mem};
endmodule
