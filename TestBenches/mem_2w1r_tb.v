`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2024 09:40:18 PM
// Design Name: 
// Module Name: mem_2w1r_tb
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


module mem_2w1r_tb(

    );
    reg clk,rst,we0;
    reg [31:0] rd_addr0,rd_addr1,wr_addr0,wr_din0;
    wire [31:0] rd_dout0,rd_dout1;
    mem_2r1w #(.DEPTH(16)) DUT(
        .clk(clk),
        .rst(rst),
        .rd_addr0(rd_addr0),
        .rd_addr1(rd_addr1),
        .wr_addr0(wr_addr0),
        .wr_din0(wr_din0),
        .we0(we0),
        .rd_dout0(rd_dout0),
        .rd_dout1(rd_dout1)
    );
    always
        begin
        clk = 0;
        forever #10 clk = ~clk;
    end
    integer i;
    initial begin
        rst = 1;
        we0 = 1;

        #10;
        for (i=0;i<16;i=i+1) begin
                wr_addr0=i*4;
                wr_din0 =i;
                @(posedge clk);
        end
        we0 = 0;
        rd_addr0 = 0;
        rd_addr1 = 1;
    end
endmodule
