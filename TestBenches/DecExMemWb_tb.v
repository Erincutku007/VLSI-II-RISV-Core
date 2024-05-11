`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2024 07:34:24 PM
// Design Name: 
// Module Name: DecEx_tb
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


module DecExMemWb_tb(

    );
    wire wb_pc_src;
    wire [4:0] imem_adr;
    wire [31:0]target_pc;
    reg clk,rst;
    reg [31:0]instruction,pc_if,pc_plus_4_if,target_pc_normalized;
    reg [31:0]ram[31:0];
    DecExMemWb DUT(
    .clk(clk),
    .rst(rst),
    .instruction(instruction),
    .pc_if(pc_if*4),
    .pc_plus_4_if(pc_plus_4_if*4),
    .wb_pc_src(wb_pc_src),
    .wb_target_pc(target_pc)
    );
    
    assign imem_adr = pc_if[4:0];
    
    always @(*) begin
        pc_plus_4_if = pc_if +1;
        instruction = ram[imem_adr];
        target_pc_normalized = target_pc/4;
    end
    
    always begin
        clk = 0;
        forever #10 clk = ~clk;
    end
    
    always @(posedge clk) begin
        if (wb_pc_src)
            pc_if = target_pc_normalized;
        else
            pc_if = pc_if + 1;
    end
    
    initial begin
        $readmemh("inst.mem", ram);
        pc_if = -1;
        rst = 1;
        #10;
        #200;
        $finish();
    end
endmodule
