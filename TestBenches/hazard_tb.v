`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2024 03:20:53 PM
// Design Name: 
// Module Name: hazard_tb
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


module hazard_tb(

    );
    HazardUnit DUT(
        .we_ex(1),
        .we_mem(1),
        .rd_ex(0),
        .rd_mem(0),
        .rs1_dec(0),
        .rs2_dec(0),
        .RAW_hazards()
    );
    initial begin
        #100;
    end
endmodule
