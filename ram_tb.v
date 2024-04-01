`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2024 10:19:01 PM
// Design Name: 
// Module Name: ram_tb
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


module ram_tb(

    );
    reg clk,rst,we0;
    reg [3:0]rd_addr0,wr_addr0;
    reg [31:0]wr_din0;
    wire [31:0]rd_dout0;
    mem_1r1w #(32,4) DUT (
        .clk(clk),
        .rst(rst),
        .rd_addr0(rd_addr0),
        .wr_addr0(wr_addr0),
        .wr_din0(wr_din0),
        .we0(we0),
        .rd_dout0(rd_dout0)
    );
    always
        begin
        clk = 0;
        forever #10 clk = ~clk;
    end
    
    initial begin
        rst = 0;
        #30;
        rst = 1;
        rd_addr0=0;
        wr_addr0=0;
        wr_din0=31;
        we0 = 0;
        #20;
        we0 = 1;
        #20;
        wr_addr0 = 1;
    end
    
endmodule
