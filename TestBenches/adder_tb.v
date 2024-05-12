`timescale 1ns / 1ps
`include "Adder.v"

module Adder_tb;

	wire [31:0] s;
	wire cout;
	reg [31:0] x,y;
	
	
	Adder uut(x,y,s,cout);
        initial
        begin
        $dumpfile("Adder_top.vcd");
        $dumpvars(0, Adder_tb);
        end
  	initial
    	begin
      	x = 32'h56745675; y = 32'h54546576; 
		#10
		if((x+y) == {cout,s}) $display($time, " correct");
		else $display("error");
      	x = 32'hAB674594; y = 32'hAC784387; 
		#10
		if((x+y) == {cout,s}) $display($time, " correct");
		else $display("error");
    	end
  
  	// initial
    // 	$monitor(,$time,"x=%h,y=%h,s=%h,cout=%h",x,y,s,cout);
  
endmodule