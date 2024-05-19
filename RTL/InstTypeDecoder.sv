`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2024 09:17:09 PM
// Design Name: 
// Module Name: InstTypeDecoder
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


module InstTypeDecoder(
    input wire[6:0]op_code,
    output wire[2:0]op_type
    );
    typedef enum {I,IStar,S,B,U,J,R} instruction_type;
    instruction_type inst_type;
    always_comb begin
        case(op_code)
            7'b011_0011:inst_type = R;
            7'b001_0011:inst_type = I;
            7'b010_0011:inst_type = S;
            7'b110_0011:inst_type = B;
            7'b110_1111:inst_type = J;
            7'b110_0111:inst_type = I;
            7'b001_0111:inst_type = U;
            7'b011_0111:inst_type = U;
            7'b111_0011:inst_type = I;
            default: inst_type = I;
        endcase
    end
    assign op_type = inst_type;
endmodule
