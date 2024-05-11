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


module core_tb(

    );

    reg clk,rst;
    Core DUT(
    .clk(clk),
    .rst(rst),
    .wb_data_o()
    );
    
    always begin
        clk = 0;
        forever #10 clk = ~clk;
    end
    
    initial begin
        rst = 0;
        #10;
        rst = 1;
        #200;
    end
endmodule
