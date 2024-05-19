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


module ExecuteStagePipelined(
        input wire [27:0]control_word_dec,
        input wire [31:0]pc_plus_4_dec,pc_dec,imm,regfilea,regfileb,
        output wire [31:0]calculated_adr,ALU_result,regfileb_ex,
        output wire [13:0]control_word_ex
    );
    wire auipc_or_lui,r_i_op,auipc,is_jump,b_src,adr_adder_a,is_branch,rf_wb,mem_we,pc_src;
    wire [1:0]wb_src;
    wire [4:0]rd;
    
    wire branch_taken_ex;
    
    wire [31:0]A,B,alu_result,adr_adder_a_input,ALU_result_or_4;
    wire [2:0]funct3,funct3_masked;
    wire [6:0]funct7,funct7_masked;
    wire [3:0]alu_flags;
    //deconstructing control word
    assign {arithmetic_set,auipc_or_lui,r_i_op,auipc,is_jump,b_src,adr_adder_a,is_branch,rf_wb,mem_we,wb_src,pc_src,rd,funct3,funct7} = control_word_dec;
    //ALU inputs
    assign A = regfilea;
    assign B = b_src ? imm : regfileb;
    assign funct3_masked = (auipc_or_lui) ? 3'b000 : funct3;
    assign funct7_masked = funct7 & {1'b1,~ (r_i_op | auipc_or_lui) ,5'b1_1111} | {1'b0,(is_branch | arithmetic_set),5'b0_0000};
    ALU alu(
    .funct7(funct7_masked),
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
        .a(adr_adder_a_input),
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
    assign control_word_ex = {branch_taken_ex,rf_wb,mem_we,wb_src,pc_src,rd,funct3};
    //output assignments 
    assign ALU_result_or_4 = is_jump ? pc_plus_4_dec : alu_result;
    assign ALU_result = auipc ? calculated_adr : ALU_result_or_4;
    assign regfileb_ex = regfileb;
endmodule
