`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2024 02:43:18 PM
// Design Name: 
// Module Name: Decode
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


module DecodeStage(
    input clk,
    input rst,
    input [31:0]instruction,pc_if,pc_plus_4_if,wb_data,
    input [4:0]wadr,
    input we_wb,
    output [31:0]regfilea,regfileb,imm,pc_dec,pc_plus_4_dec,
    output wire [23:0]control_word_dec
    );
    //control signal declerations
    wire b_src,r_i_op,mem,mem_load,adr_adder_a,is_branch,arithmetic,jump,rf_wb,mem_we,is_control,adr_a,pc_src;
    wire raw_dec_a,raw_dec_b;
    wire [4:0]rs2,rs1,rd;
    wire [6:0]opcode,funct7;
    wire [2:0]funct3,op_type;
    wire [31:0]extended_imm,reg_a_val,reg_b_val;
    wire [1:0]wb_src;
    //control signal assignments
    assign raw_dec_a = we_wb & !adr_a &(rs1 == wadr);
    assign raw_dec_b = we_wb & (rs2 == wadr);
    
    assign rs2 = instruction[24:20];
    assign rs1 = adr_a ? 5'b0 : instruction[19:15]; 
    assign rd = instruction[11:7];
    assign funct3 = instruction[14:12];
    assign opcode = instruction[6:0];
    assign funct7 = instruction[31:25];
    //internal control signals
    assign r_i_op = (opcode == 7'b001_0011);
    assign mem = (opcode == 7'b000_0011) | (opcode == 7'b010_0011);
    assign arithmetic = (opcode == 7'b011_0011) | (opcode == 7'b001_0011);
    assign mem_load = (opcode == 7'b000_0011);
    assign jump = (opcode == 7'b110_1111) | (opcode == 7'b110_0111);
    assign is_control_expect_jalr = (opcode == 7'b110_0011) | (opcode == 7'b110_1111);
    assign is_control = adr_adder_a | (opcode == 7'b110_0111);
    //control signal assignments
    assign b_src =r_i_op | mem;
    assign adr_adder_a = is_control_expect_jalr;
    assign is_branch = (opcode == 7'b110_0011);
    assign rf_wb = arithmetic | mem_load | jump;
    assign mem_we = (opcode == 7'b010_0011);
    assign wb_src = {mem_load,arithmetic};
    assign pc_src = jump | (opcode == 7'b001_0111);
    assign adr_a = (opcode == 7'b011_0111);
    //{b_src,adr_adder_a,is_branch,rf_wb,mem_we,wb_src,pc_src,rd,funct3,funct7};
    assign control_word_dec = {b_src,adr_adder_a,is_branch,rf_wb,mem_we,wb_src,pc_src,rd,funct3,funct7};
    //DP block declerations
    RegFile rf(
        .clk(clk),
        .rst(rst),
        .rd_addr0(rs1),
        .rd_addr1(rs2),
        .wr_addr0(wadr),
        .wr_din0(wb_data),
        .we0(we_wb),
        .rd_dout0(reg_a_val),
        .rd_dout1(reg_b_val)
    );
    InstTypeDecoder inst_type_dec(
    .op_code(opcode),
    .op_type(op_type)
    );
    ImmExtender im_dec(
        .inst(instruction),
        .op_type(op_type),
        .imm_out(extended_imm)
    );
    //control to DP connections
    assign imm = extended_imm;
    assign regfilea = 1'b0 ? wb_data : reg_a_val; //raw_dec_a olacak normalde
    assign regfileb = 1'b0 ? wb_data : reg_b_val; //raw_dec_b olacak normalde
    assign pc_dec = pc_if;
    assign pc_plus_4_dec = pc_plus_4_if;
endmodule
