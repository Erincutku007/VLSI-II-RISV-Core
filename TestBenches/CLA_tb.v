`timescale 1ns / 1ps
`include "CLA.v"

module CLA_tb;

	wire [31:0] s;
	wire cout;
    reg sub;
	reg [31:0] x,y;
		
	CLA DUT (sub,x,y,cout,s);
        initial
        begin
        $dumpfile("CLA_TB.vcd");
        $dumpvars(0, CLA_tb);
        end
  	initial
    	begin
      	x = 32'h56745675; y = 32'h54546576;
        sub = 0;
		#10
		if((x+y) == {cout,s}) $display($time, " correct");
		else $display("error");

      	x = 32'h92384923; y = 32'h;
        sub = 0;
		#10
		if((x+y) == {cout,s}) $display($time, " correct");
		else $display("error");

      	x = 32'hAB674594; y = 32'hAC784387; 
        sub = 1;
		#10
		if((x-y) == $signed(s)) $display($time, " correct");
		else $display("error");

      	x = 32'hAB674594; y = 32'hAC784387; 
        sub = 1;
		#10
		if((x-y) == $signed(s)) $display($time, " correct");
		else $display("error");
    	end
  
endmodule