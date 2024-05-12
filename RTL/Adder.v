`timescale 1ns / 1ps

`timescale 1ns / 1ps
// `include "Nbit_RCA.v"
// `include "BEC_1.v"
// `include "Nbit_MUX.v"

module Adder(x,y,s,cout);

	output [31:0] s;
	input [31:0] x,y;
	output cout;
	wire [4:0] sel;
	
	wire [3:0] sum0;
	wire [4:0] temp0,temp0_1;
	wire [4:0] sum1;
	wire [5:0] temp1,temp1_1;
	wire [5:0] sum2;
	wire [6:0] temp2,temp2_1;
	wire [6:0] sum3;
	wire [7:0] temp3,temp3_1;
	wire [6:0] sum4;
	wire [7:0] temp4,temp4_1;


    wire carry0, carry1, carry2, carry3, carry4;

    //sum[2:0] - rca 3 bit
    rca_n #(3) rca1(.x(x[2:0]),.y(y[2:0]),.cin(1'b0),.s(s[2:0]),.cout(sel[0]));

    // sum[6:3] -rca 4 bit , BEC 5 bit
    rca_n #(4) rca2(.x(x[6:3]),.y(y[6:3]),.cin(1'b0),.s(sum0),.cout(carry0));
	assign temp0 = {carry0,sum0[3:0]};
	bec_5 b1(temp0,temp0_1);

	bitNmux #(4) mux1(.out(s[6:3]),.in0(temp0[3:0]),.in1(temp0_1[3:0]),.select(sel[0])); //for selecting sum
	bitNmux #(1) mux2(.out(sel[1]),.in0(temp0[4]),.in1(temp0_1[4]),.select(sel[0]));     //for selecting carry

	//sum[11:7]-rca 5 bit ,bec 6 bit
	rca_n #(5) rca3(.x(x[11:7]),.y(y[11:7]),.cin(1'b0),.s(sum1),.cout(carry1));
	assign temp1 = {carry1,sum1[4:0]};
	bec_6 b2(temp1,temp1_1);

	bitNmux #(5) mux3(.out(s[11:7]),.in0(temp1[4:0]),.in1(temp1_1[4:0]),.select(sel[1]));  //for selecting sum
	bitNmux #(1) mux4(.out(sel[2]),.in0(temp1[5]),.in1(temp1_1[5]),.select(sel[1]));       //for selecting carry

	//sum[17:12] -rca 6 bit ,bec 7 bit
    rca_n #(6) rca4(.x(x[17:12]),.y(y[17:12]),.cin(1'b0),.s(sum2),.cout(carry2));
    assign temp2 = {carry2,sum2[5:0]};
	bec_7 b3(temp2,temp2_1);

	bitNmux #(6) mux5(.out(s[17:12]),.in0(temp2[5:0]),.in1(temp2_1[5:0]),.select(sel[2]));
	bitNmux #(1) mux6(.out(sel[3]),.in0(temp2[6]),.in1(temp2_1[6]),.select(sel[2]));

	//sum[24:18]-rca 7 bit ,BEC 8 bit
    rca_n #(7) rca5(.x(x[24:18]),.y(y[24:18]),.cin(1'b0),.s(sum3),.cout(carry3));
	assign temp3 = {carry3,sum3[6:0]};
	bec_8 b4(temp3,temp3_1);

	bitNmux #(7) mux7(.out(s[24:18]),.in0(temp3[6:0]),.in1(temp3_1[6:0]),.select(sel[3]));
	bitNmux #(1) mux8(.out(sel[4]),.in0(temp3[7]),.in1(temp3_1[7]),.select(sel[3]));

    //sum[31:25]-rca 7 bit ,BEC 8 bit
    rca_n #(7) rca6(.x(x[31:25]),.y(y[31:25]),.cin(1'b0),.s(sum4),.cout(carry4));
	assign temp4 = {carry4,sum4[6:0]};
	bec_8 b5(temp4,temp4_1);

	bitNmux #(7) mux9(.out(s[31:25]),.in0(temp4[6:0]),.in1(temp4_1[6:0]),.select(sel[4]));
	bitNmux #(1) mux10(.out(cout),.in0(temp4[7]),.in1(temp4_1[7]),.select(sel[4]));

endmodule

module bec_5(x,y);

	input [4:0] x;
	output [4:0] y;

	assign y[0] = ~x[0];
	assign y[1] = x[1]^x[0];
	assign y[2] = x[2]^(x[1]&x[0]);
	assign y[3] = x[3]^(x[2]&x[1]&x[0]);
	assign y[4] = x[4]^(x[3]&x[2]&x[1]&x[0]);

endmodule

module bec_6(x,y);

	input [5:0] x;
	output [5:0] y;

	assign y[0] = ~x[0];
	assign y[1] = x[1]^x[0];
	assign y[2] = x[2]^(x[1]&x[0]);
	assign y[3] = x[3]^(x[2]&x[1]&x[0]);
	assign y[4] = x[4]^(x[3]&x[2]&x[1]&x[0]);
	assign y[5] = x[5]^(x[4]&x[3]&x[2]&x[1]&x[0]);

endmodule

module bec_7(x,y);

	input [6:0] x;
	output [6:0] y;

	assign y[0] = ~x[0];
	assign y[1] = x[1]^x[0];
	assign y[2] = x[2]^(x[1]&x[0]);
	assign y[3] = x[3]^(x[2]&x[1]&x[0]);
	assign y[4] = x[4]^(x[3]&x[2]&x[1]&x[0]);
	assign y[5] = x[5]^(x[4]&x[3]&x[2]&x[1]&x[0]);
	assign y[6] = x[6]^(x[5]&x[4]&x[3]&x[2]&x[1]&x[0]);

endmodule

module bec_8(x,y);

	input [7:0] x;
	output [7:0] y;

	assign y[0] = ~x[0];
	assign y[1] = x[1]^x[0];
	assign y[2] = x[2]^(x[1]&x[0]);
	assign y[3] = x[3]^(x[2]&x[1]&x[0]);
	assign y[4] = x[4]^(x[3]&x[2]&x[1]&x[0]);
	assign y[5] = x[5]^(x[4]&x[3]&x[2]&x[1]&x[0]);
	assign y[6] = x[6]^(x[5]&x[4]&x[3]&x[2]&x[1]&x[0]);
	assign y[7] = x[7]^(x[6]&x[5]&x[4]&x[3]&x[2]&x[1]&x[0]);

endmodule

module bitNmux #(parameter N = 5) (
output [N-1:0] out  ,
input wire [N-1:0] in0,in1,
input wire select   
);

assign out = (select) ? in1 : in0; 

endmodule

module rca_n(x,y,cin,s,cout);
	parameter WIDTH = 2 ;
	input [WIDTH-1:0] x,y;
	input cin;
	output cout;
	output [WIDTH-1:0] s;
	wire [WIDTH:0] temp;

	assign temp = x + y + cin;
	assign s = temp[WIDTH-1:0];
	assign cout = temp[WIDTH];

endmodule
