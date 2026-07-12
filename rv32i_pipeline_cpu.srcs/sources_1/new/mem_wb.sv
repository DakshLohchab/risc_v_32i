`timescale 1ns/1ps
module mem_wb (
    input logic clk, rst_n,
    input logic reg_writeM,
    input logic [1:0] result_srcM,
    input logic [4:0] rdM,
    input logic [31:0] alu_resultM, read_dataM, pcPlus4M,
    output logic reg_writeW,
    output logic [1:0] result_srcW,
    output logic [4:0] rdW,
    output logic [31:0] alu_resultW, read_dataW, pcPlus4W
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin reg_writeW<=0; result_srcW<=0; rdW<=0; alu_resultW<=0; read_dataW<=0; pcPlus4W<=0; end
        else begin
            reg_writeW<=reg_writeM; result_srcW<=result_srcM; rdW<=rdM;
            alu_resultW<=alu_resultM; read_dataW<=read_dataM; pcPlus4W<=pcPlus4M;
        end
    end
endmodule
