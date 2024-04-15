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


module dmem_tb(

    );
    reg clk,rst,we0;
    reg [3:0]rd_addr0,wr_addr0;
    reg [31:0]wr_din0;
    reg [2:0]wr_strb;
    wire [31:0]rd_dout0;
    DataMem #(16) DUT (
        .clk(clk),
        .rst(rst),
        .rd_addr0(rd_addr0),
        .wr_addr0(wr_addr0),
        .wr_din0(wr_din0),
        .we0(we0),
        .wr_strb(wr_strb),
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
        wr_din0=32'hF0_F0_0F_0F;
        wr_strb = 3'b010;
        we0 = 1;
        #40;
        we0 = 0;
        rd_addr0=1;
        wr_strb = 3'b100;
        #20;
    end
    
endmodule
