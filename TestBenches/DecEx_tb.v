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


module DecEx_tb(

    );
    wire [4:0] imem_adr;
    reg clk,rst;
    reg [31:0]instruction,pc_if,pc_plus_4_if;
    reg [31:0]ram[31:0];
    DecEx DUT(
    .clk(clk),
    .rst(rst),
    .instruction(instruction),
    .pc_if(pc_if*4),
    .pc_plus_4_if(pc_plus_4_if*4)
    );
    
    assign imem_adr = pc_if[4:0];
    
    always @(*) begin
        pc_plus_4_if = pc_if +1;
        instruction = ram[imem_adr];
    end
    
    always begin
        clk = 0;
        forever #10 clk = ~clk;
    end
    
    always @(posedge clk) begin
        pc_if = pc_if + 1;
    end
    
    initial begin
        $readmemh("inst.mem", ram);
        pc_if = -1;
        rst = 0;
        #10;
        rst = 1;
        #200;
        $finish();
    end
endmodule
