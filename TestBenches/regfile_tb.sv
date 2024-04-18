`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2024 10:57:43 AM
// Design Name: 
// Module Name: regfile_tb
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


module regfile_tb(
    );
    reg clk,rst,we0;
    wire [31:0]rd_dout0,rd_dout1;
    reg [31:0]wr_din0;
    reg [4:0]wr_addr0,rd_addr1,rd_addr0;
    initial clk = 0;
    always #10 clk++;
    RegFile DUT(
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
    integer i;
    initial begin
        rst = 0;
        #30;
        rst = 1;
        we0 = 1;
        #20;
        for(i=0;i<32;i=i+1) begin
            wr_addr0 = i;
            wr_din0 = i;
            #20;
        end
        #20;
        for(i=0;i<16;i=i+1) begin
            rd_addr0 = i*2;
            rd_addr1 = (i+1)*2;
            #20;
        end
    end
endmodule
