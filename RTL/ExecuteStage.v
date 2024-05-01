`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2024 01:23:03 PM
// Design Name: 
// Module Name: ExecuteStage
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


module ExecuteStage(
        input wire [18:0]control_word_dec,
        input wire [31:0]pc_plus_4_dec,pc_dec,imm,regfilea,regfileb,
        output wire [31:0]calculated_adr,pc_plus_4_ex,ALU_result,regfileb_ex,
        output wire [8:0]control_word_ex
    );
    wire b_src,adr_adder_a,is_branch,rf_wb,mem_we,pc_src;
    wire [1:0]wb_src;
    
    wire branch_taken_ex,rf_wb_ex,mem_we_ex,pc_src_ex,funct3_ex;
    wire [1:0]wb_src_ex;
    
    wire [31:0]A,B,alu_result,adr_adder_a_input;
    wire [2:0]funct3,funct3_masked;
    wire [6:0]funct7;
    wire [3:0]alu_flags;
    //deconstructing control word
    assign {b_src,adr_adder_a,is_branch,rf_wb,mem_we,wb_src,pc_src,funct3,funct7} = control_word_dec;
    //ALU inputs
    assign A = regfilea;
    assign B = b_src ? imm : regfileb;
    assign funct3_masked = is_branch ? 32'b0 : funct3;
    assign address_adder_a = adr_adder_a ? pc_dec : regfilea;
    ALU(
    .funct7(funct7),
    .funct3(funct3_masked),
    .A(A),
    .B(B),
    .result(alu_result),
    .alu_flags(alu_flags)
    );
    //address adder inputs
    assign adr_adder_a_input = adr_adder_a ? pc_dec : A;
    Adder address_adder(
        .cin(1'b0),
        .a(),
        .b(imm),
        .y(calculated_adr),
        .cout()
    );
    //condition check
    ConditionCheck condcheck(
        .funct3(funct3),
        .flags(alu_flags),
        .condition_valid(branch_taken)
    );
    //new conrol word
    assign branch_taken_ex = branch_taken & is_branch;
    assign control_word_ex = {branch_taken_ex,rf_wb_ex,mem_we_ex,wb_src_ex,pc_src_ex,funct3_ex};
    //output assignments
    assign pc_plus_4_ex = pc_plus_4_dec;
    assign ALU_result = alu_result;
    assign regfileb_ex = regfileb;
endmodule
