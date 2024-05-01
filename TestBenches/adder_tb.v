`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2024 01:13:24 PM
// Design Name: 
// Module Name: adder_tb
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


module adder_tb(
    );
    reg [31:0]a,b;
    reg cin;
    wire [31:0]y;
    wire cout;
    integer test;
    Adder DUT(
        .cin(cin),
        .a(a),
        .b(b),
        .y(y),
        .cout(cout)
    );
    initial begin
            repeat(20)    begin
            #10;
            cin = 0;
            a = $random()%100;
            b = $random()%100;
            test = a+b;
            $display("%d + %d 'yi %d buldum sonuc %d olmaliydi",a,b,y,a+b);
            #10;
            end
    end
endmodule
