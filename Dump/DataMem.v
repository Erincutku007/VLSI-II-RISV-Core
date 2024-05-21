`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2024 02:21:19 PM
// Design Name: 
// Module Name: DataMem
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


module DataMem #(parameter MEM_DEPTH=32,parameter MEMDATA = "")(
    input clk,
    input rst,
    input [$clog2(MEM_DEPTH)+1:0]rd_addr0,wr_addr0,
    input [31:0]wr_din0,
    input we0,
    input [2:0]wr_strb,
    output [31:0]rd_dout0
    );
    wire [31:0]memory_read_val_raw,memory_read_val_shifted,memory_write_val_shifted,mem_write_in;
    reg  [31:0]mem_read_out;
    wire [1:0]byte_index_r,byte_index_w;
    wire [4:0]shamt_r,shamt_w;
    localparam adr_width = $clog2(MEM_DEPTH)+2;
    mem_1r1w_sram #(.WIDTH(32),.DEPTH(MEM_DEPTH),.MEMDATA(MEMDATA)) dmem(
    .clk(clk),
    .rst(rst),
    .rd_addr0({rd_addr0[31:2],2'h0}),
    .wr_addr0({wr_addr0[31:2],2'h0}),
    .wr_din0(mem_write_in),
    .we0(we0),
    .rd_dout0(memory_read_val_raw)
    );
    wire [1:0]mode = wr_strb[1:0];
    wire isUint = wr_strb[2];
    // mode = 00 -> byte
    // mode = 01 -> hw
    // mode = 10 -> hw
    // isuint =1 -> Unsigned L/S
    
    assign byte_index_r = rd_addr0[1:0];
    assign byte_index_w = wr_addr0[1:0];
    assign shamt_r = (byte_index_r << 3);
    assign shamt_w = (byte_index_w << 3);
    assign memory_read_val_shifted = memory_read_val_raw >> shamt_r;
    
    always @(*) begin
        if (isUint) begin
            if (~mode[0]) begin //if mode[0] we are in the byte mode
                mem_read_out = {24'd0,memory_read_val_shifted[7:0]};
            end
            else begin          //else we are in the half word mode
                mem_read_out = {16'd0,memory_read_val_shifted[15:0]};
            end
        end
        else begin
            if (~mode[0]) begin //if mode[0] we are in the byte mode
                mem_read_out = {{24{memory_read_val_shifted[7]}},memory_read_val_shifted[7:0]};
            end
            else begin          //else we are in the half word mode
                mem_read_out = {{16{memory_read_val_shifted[15]}},memory_read_val_shifted[15:0]};
            end
        end
    end
    
    assign memory_write_val_shifted = wr_din0 << shamt_w;
    
    assign mem_write_in = memory_write_val_shifted;
    assign rd_dout0 = mem_read_out;
endmodule
