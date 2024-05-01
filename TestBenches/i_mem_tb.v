`timescale 1ns / 1ps
`include "i_mem.v"

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


module i_mem_tb #(parameter WIDTH = 32,parameter DEPTH = 128)(

    );
    reg clk,rst,we0;
    reg [31:0]rd_addr0,wr_addr0;
    reg [31:0]wr_din0;
    wire [31:0]rd_dout0;
    i_mem #(WIDTH,DEPTH) DUT (
        .clk(clk),
        .rst(rst),
        .rd_addr0(rd_addr0),
        .wr_addr0(wr_addr0),
        .wr_din0(wr_din0),
        .we0(we0),
        .rd_dout0(rd_dout0)
    );
    //this is to create .vcd file
    //in order to simulate on gtkwave
    initial 
    begin
        $dumpfile ("i_mem_TB.vcd");
        $dumpvars (0, i_mem_tb);
    end

    always
        begin
        clk = 0;
        forever #10 clk = ~clk;
    end
    integer i;
    initial begin
        rst = 1;
        we0 = 0;
        rd_addr0=0;
        wr_addr0=0;
        #10;
    for (i=0;i<DEPTH;i=i+1) begin
            rd_addr0=i*4;
            #10;
            $display($time,": read address=%b",rd_dout0); 
        end
        we0 = 1;
        $finish;
    end
    
endmodule
