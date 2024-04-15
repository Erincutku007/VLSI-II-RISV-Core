`timescale 1ns / 1ps

interface memory_interface#(parameter MEM_DEPTH=4)(
     logic clk,
     reg rst,
     reg [$clog2(MEM_DEPTH)-1:0]rd_addr0,wr_addr0,
     reg [31:0]wr_din0,
     reg we0,
     reg [2:0]wr_strb,
     logic [31:0]rd_dout0
    );
    modport memory (
         input clk,
               rst,
               rd_addr0,
               wr_addr0,
               wr_din0,
               we0,
               wr_strb,
         output rd_dout0
    );
    reg clock;
    reg reset;
    initial begin
        clock = 0;
        forever begin
            #10;
            clock = ~clock;
        end
    end
    assign clk = clock;
endinterface
