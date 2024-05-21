`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2024 05:02:41 PM
// Design Name: 
// Module Name: HazardControlUnit
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


module HazardControlUnit(
        input branch_taken_E,pc_src_E,we_ex,we_mem,we_wb,valid_ex,valid_mem,valid_wb, //<- buraya mem weler gelecek ve RAW için onlar da eklenecek stora'da
        input [1:0]wb_src_ex,wb_src_mem,wb_src_wb,
        input [4:0]rd_ex,rd_mem,rd_wb,
        input [4:0]rs1_dec,rs2_dec,
        output [3:0]RAW_hazards,
        output [1:0]RAW_mem_wb_hazards,
        output stall_if,stall_dec,
        output flush_ex,flush_dec
    );
    //RAW hazard handling
    wire raw_rs1_ex,raw_rs2_ex,raw_rs1_mem,raw_rs2_mem;
    wire ex_rd_to_x0,mem_rd_to_x0,wb_rd_to_x0;
    
    assign ex_rd_to_x0 = (rd_ex == 5'b0_0000);
    assign mem_rd_to_x0 = (rd_mem == 5'b0_0000);
    
    assign raw_rs1_ex = ~ex_rd_to_x0 & (rd_ex == rs1_dec) & we_ex & valid_ex;
    assign raw_rs2_ex = ~ex_rd_to_x0 & (rd_ex == rs2_dec) & we_ex & valid_ex;
    assign raw_rs1_mem = ~mem_rd_to_x0 & (rd_mem == rs1_dec) & we_mem & valid_mem;
    assign raw_rs2_mem = ~mem_rd_to_x0 & (rd_mem == rs2_dec) & we_mem & valid_mem;
    //rs1_ex_hazard,rs2_ex_hazard,rs1_mem_hazard,rs2_mem_hazard
    assign RAW_hazards = {raw_rs1_ex,raw_rs2_ex,raw_rs1_mem,raw_rs2_mem};
    //Memory RAW hazard handling
    wire raw_load_ex,raw_load_mem,raw_load_wb,raw_ex_dec_rs1,raw_ex_dec_rs2,raw_mem_dec_rs1,raw_mem_dec_rs2,raw_wb_dec_rs1,raw_wb_dec_rs2;
    wire [3:0]RAW_mem_hazards;
    
    
    assign raw_load_ex  = (wb_src_ex == 2'b10) & we_ex;
    assign raw_load_mem = (wb_src_mem == 2'b10) & we_mem;
    assign raw_load_wb = (wb_src_wb == 2'b10) & we_wb;
    
    assign raw_ex_dec_rs1 =  (rd_ex == rs1_dec) & raw_load_ex & valid_ex;
    assign raw_ex_dec_rs2 =  (rd_ex == rs2_dec) & raw_load_ex & valid_ex;
    assign raw_mem_dec_rs1 = (rd_mem == rs1_dec)& raw_load_mem & valid_mem;
    assign raw_mem_dec_rs2 = (rd_mem == rs2_dec)& raw_load_mem & valid_mem;
    assign raw_wb_dec_rs1 =  (rd_wb == rs1_dec) & raw_load_wb & valid_wb;
    assign raw_wb_dec_rs2 =  (rd_wb == rs2_dec) & raw_load_wb & valid_wb;
    //control hazards 
    wire pc_change;
    assign pc_change = branch_taken_E | pc_src_E;
    //output signals
    assign RAW_mem_hazards = {raw_ex_dec_rs1,raw_ex_dec_rs2,raw_mem_dec_rs1,raw_mem_dec_rs2};
    assign stall_if  = |RAW_mem_hazards;
    assign stall_dec = stall_if;
    assign flush_ex = stall_if | pc_change;
    assign flush_dec = pc_change;
    assign RAW_mem_wb_hazards = {raw_wb_dec_rs1,raw_wb_dec_rs2};
endmodule
