`timescale 1ns / 1ps
//+++++++++++++++++++++++++++++++++++++++++++++++++
// Define the interface
//+++++++++++++++++++++++++++++++++++++++++++++++++
interface mem_if (input wire clk);
        logic rst;
        logic [31:0]rd_addr0;
        logic [31:0]wr_addr0;
        logic [31:0]wr_din0;
        logic we0;
        logic [2:0]wr_strb;
        logic [31:0]rd_dout0;
  //=================================================
  // Modport for System interface 
  //=================================================
  modport  system (
        input       rst,
                    clk,
                    rd_dout0,   
        output      rd_addr0,
                    wr_addr0,
                    wr_din0,
                    we0,         
                    wr_strb
             );
  //=================================================
  // Modport for memory interface 
  //=================================================
  modport  memory (
        input  clk,
        input  rst,
        input  rd_addr0,wr_addr0,
        input  wr_din0,
        input  we0,
        input  wr_strb,
        output rd_dout0
            );

endinterface

module memory_model#(MEM_DEPTH=16) (mem_if.memory mif);
    DataMem #(MEM_DEPTH)memory (
        .clk(mif.clk),
        .rst(mif.rst),
        .rd_addr0(mif.rd_addr0),
        .wr_addr0(mif.wr_addr0),
        .wr_din0(mif.wr_din0),
        .we0(mif.we0),
        .wr_strb(mif.wr_strb),
        .rd_dout0(mif.rd_dout0)
        );
endmodule

//+++++++++++++++++++++++++++++++++++++++++++++++++
//  Memory Controller
//+++++++++++++++++++++++++++++++++++++++++++++++++
module memory_ctrl #(MEM_DEPTH=16) (mem_if.system sif);
    integer i,strb;
    typedef enum {sbyte,halfword,word} strb_dat;
    strb_dat mode;
    initial begin
        sif.rst = 0;
        sif.we0 = 0;
        sif.rd_addr0 =0;
        sif.wr_addr0 =0;
        sif.wr_din0  =0;
        sif.wr_strb  =0;
        #10;
        sif.rst = 1;
        sif.we0 = 1;
        for (i = 0;i<MEM_DEPTH;i++) begin
            sif.wr_din0  =i;
            strb = i%3;
            sif.wr_addr0 =4*i+strb;
            case(strb) 
                3: mode = sbyte;
                2: mode = halfword;
                1: mode = sbyte;
                0: mode = word;
            endcase
            sif.wr_strb = mode;
            #20;
        end
        #20;
        sif.we0 = 0;
        #20;
        for (i = 0;i<MEM_DEPTH;i++) begin
            strb = i%3;
            sif.rd_addr0 = 4*i+strb;
            case(strb) 
                3: mode = sbyte;
                2: mode = halfword;
                1: mode = sbyte;
                0: mode = word;
            endcase
            sif.wr_strb = mode;
            sif.wr_strb[2] = 1'b0;
            #20;
        end
        #20;
        for (i = 0;i<MEM_DEPTH;i++) begin
            strb = i%3;
            sif.rd_addr0 = 4*i+strb;
            case(strb) 
                3: mode = sbyte;
                2: mode = halfword;
                1: mode = sbyte;
                0: mode = word;
            endcase
            sif.wr_strb = mode;
            sif.wr_strb[2] = 1'b1;
            #20;
        end
    end
endmodule

//+++++++++++++++++++++++++++++++++++++++++++++++++
//  Testbench
//+++++++++++++++++++++++++++++++++++++++++++++++++
module testbench();

logic clk = 0;
always #10 clk++;
//=================================================
// Instianciate Interface and DUT 
//=================================================
mem_if miff(clk);
memory_ctrl U_ctrl(miff);
memory_model #(16) U_model(miff);

endmodule