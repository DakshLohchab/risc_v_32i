`timescale 1ns/1ps
module mem_stage #(parameter DMEM_DEPTH_BYTES = 4096) (
    input logic clk, mem_writeM,
    input logic [2:0] funct3M,
    input logic [31:0] alu_resultM, write_dataM,
    output logic [31:0] read_dataM
);
    data_memory #(.DEPTH_BYTES(DMEM_DEPTH_BYTES)) u_data_memory(
        .clk, .mem_write(mem_writeM), .funct3(funct3M), .addr(alu_resultM), .write_data(write_dataM), .read_data(read_dataM)
    );
endmodule
