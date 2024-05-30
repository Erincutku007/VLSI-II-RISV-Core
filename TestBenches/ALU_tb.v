`timescale 1ns / 1ps
`include "ALU.v"
`include "Adder.v"
`include "Shifter.v"

module ALU_tb ();

    reg [6:0] funct7;
    reg [2:0] funct3;
    reg [31:0] A,B;
    wire signed [31:0]result;
    wire [3:0]alu_flags;

    ALU DUT (
        .funct7(funct7),
        .funct3(funct3),
        .A(A), .B(B),
        .result(result),
        .alu_flags(alu_flags)
    );

    //this is to create .vcd file
    //in order to simulate on gtkwave
    initial 
    begin
        $dumpfile ("PC_TB.vcd");
        $dumpvars (0, PC_tb);
    end

    initial begin
        funct7 = 7'b0000000;
        funct3 = 3'b000;
        A = 0;
        B = 0;
        #10
        $display($time,": result = %d",result); 
        
        // ADD
        funct7 = 7'b0000000;
        funct3 = 3'b000;
        A = 20;
        B = 30;
        #10
        if(result == (A + B))
            begin
            $display($time,": ADD result = %d",result," TRUE");
            end
        else
            $display("ERROR");
        
        // SUB
        funct7 = 7'b0100000;
        funct3 = 3'b000;
        A = 20;
        B = 30;
        #10
        if(result == (A - B))
            begin
            $display($time,": SUB result = %d",result," TRUE");
            end
        else
            $display("ERROR");

        // SLT
        funct7 = 7'b0000000;
        funct3 = 3'b010;
        A = -4;
        B = 3;
        #10
        if(result == ($signed(A)<$signed(B)))
            begin
            $display($time,": SLT result = %d",result," TRUE");
            end
        else
            $display("ERROR");

        // SLTU
        funct7 = 7'b0000000;
        funct3 = 3'b011;
        A = 3;
        B = 4;
        #10
        if(result == (A < B))
            begin
            $display($time,": SLTU result = %d",result," TRUE");
            end
        else
            $display("ERROR");

        // XOR
        funct7 = 7'b0000000;
        funct3 = 3'b100;
        A = 32'hF0F0_F0F0;
        B = 32'h00FF_FF00;
        #10
        if(result == (A ^ B))
            begin
            $display($time,": XOR result = %h",result," TRUE");
            end
        else
            $display("ERROR");
        
        // OR
        funct7 = 7'b0000000;
        funct3 = 3'b110;
        A = 32'hF0FF_F0F0;
        B = 32'hFF00_00FF;
        #10
        if(result == (A | B))
            begin
            $display($time,": OR result = %h",result," TRUE");
            end
        else
            $display("ERROR");

        // AND
        funct7 = 7'b0000000;
        funct3 = 3'b111;
        A = 32'hF0FF_F0F0;
        B = 32'hFF00_00FF;
        #10
        if(result == (A & B))
            begin
            $display($time,": AND result = %h",result," TRUE");
            end
        else
            $display("ERROR");

        // ADDI
        funct3 = 3'b000;
        A = 34;
        B = 12;
        #10
        if(result == (A + B))
            begin
            $display($time,": ADDI result = %d",result," TRUE");
            end
        else
            $display("ERROR");

        // SLTI
        funct3 = 3'b010;
        A = 3;
        B = -4;
        #10
        if(result == ($signed(A)<$signed(B)))
            begin
            $display($time,": SLTI result = %d",result," TRUE");
            end
        else
            $display("ERROR");

        // SLTIU
        funct3 = 3'b010;
        A = 3;
        B = 4;
        #10
        if(result == (A < B))
            begin
            $display($time,": SLTIU result = %d",result," TRUE");
            end
        else
            $display("ERROR");

        // XORI
        funct3 = 3'b100;
        A = 32'hF0F0_F0F0;
        B = 32'h00FF_FF00;
        #10
        if(result == (A ^ B))
            begin
            $display($time,": XORI result = %h",result," TRUE");
            end
        else
            $display("ERROR");

        // ORI
        funct3 = 3'b110;
        A = 32'hF0F0_F0F0;
        B = 32'h00FF_FF00;
        #10
        if(result == (A | B))
            begin
            $display($time,": ORI result = %h",result," TRUE");
            end
        else
            $display("ERROR");

        // ANDI
        funct3 = 3'b111;
        A = 32'hF0F0_F0F0;
        B = 32'h00FF_FF00;
        #10
        if(result == (A & B))
            begin
            $display($time,": ANDI result = %h",result," TRUE");
            end
        else
            $display("ERROR");

        $finish;
    end
endmodule