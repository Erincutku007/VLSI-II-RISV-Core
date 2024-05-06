`timescale 1ns / 1ps
`include "Shifter.v"

module Shifter_tb();
    reg signed [31:0]a;
    reg signed [4:0]b;
    reg mode;
    reg sel;
    wire signed [31:0]y;

    Shifter DUT (
        .a(a),
        .b(b),
        .mode(mode),
        .sel(sel),
        .y(y)
    );

    //this is to create .vcd file
    //in order to simulate on gtkwave
    initial 
    begin
        $dumpfile ("Shifter_TB.vcd");
        $dumpvars (0, Shifter_tb);
    end

    initial begin

        // reset
        mode = 7'b0000000;
        sel = 3'b000;
        a = 0;
        b = 0;
        #10
        $display($time,": result = %d",y); 
        
        // SLL
        mode = 0;
        sel = 0;
        repeat(5)
        begin
            a = ({$random} % 32'hFFFF_FFFF); // 32-bit random number
            b = {$urandom} % 5'b11111;  // 5-bit random number
            #10
            if(y == (a << b))
                begin
                $display($time,": SLL result = %d",y," TRUE");
                end
            else
                $display("ERROR");
        end

        // SRL
        mode = 0;
        sel = 1;
        repeat(5)
        begin
            a = ({$random} % 32'hFFFF_FFFF); // 32-bit random number
            b = {$urandom} % 5'b11111;  // 5-bit random number
            #10
            if(y == (a >> b))
                begin
                $display($time,": SRL result = %d",y," TRUE");
                end
            else
                $display("ERROR");
        end

        // SRA
        mode = 1;
        sel = 1;
        repeat(5)
        begin
            a = ({$random} % 32'hFFFF_FFFF); // 32-bit random number
            b = {$urandom} % 5'b11111;  // 5-bit random number
            #10
            if(y == (a >>> b))
                begin
                $display($time,": SRA result = %d",y," TRUE");
                end
            else
                $display("ERROR");
        end
        
        $finish;
    end
endmodule