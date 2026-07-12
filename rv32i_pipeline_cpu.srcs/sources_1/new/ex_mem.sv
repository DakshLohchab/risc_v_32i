`timescale 1ns/1ps
// EX/MEM pipeline register.  Only architectural side-effect controls cross it.
module ex_mem (
    input logic clk, rst_n,
    input logic reg_writeE, mem_writeE,
    input logic [1:0] result_srcE,
    input logic [2:0] funct3E,
    input logic [4:0] rdE,
    input logic [31:0] alu_resultE, write_dataE, pcPlus4E,
    output logic reg_writeM, mem_writeM,
    output logic [1:0] result_srcM,
    output logic [2:0] funct3M,
    output logic [4:0] rdM,
    output logic [31:0] alu_resultM, write_dataM, pcPlus4M
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_writeM<=0; mem_writeM<=0; result_srcM<=0; funct3M<=0; rdM<=0;
            alu_resultM<=0; write_dataM<=0; pcPlus4M<=0;
        end else begin
            reg_writeM<=reg_writeE; mem_writeM<=mem_writeE; result_srcM<=result_srcE;
            funct3M<=funct3E; rdM<=rdE; alu_resultM<=alu_resultE;
            write_dataM<=write_dataE; pcPlus4M<=pcPlus4E;
        end
    end
endmodule
