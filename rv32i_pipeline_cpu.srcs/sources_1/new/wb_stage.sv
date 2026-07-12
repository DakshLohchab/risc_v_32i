`timescale 1ns/1ps
module wb_stage (
    input logic [1:0] result_srcW,
    input logic [31:0] alu_resultW, read_dataW, pcPlus4W,
    output logic [31:0] resultW
);
    always_comb begin
        unique case (result_srcW)
            2'b00: resultW = alu_resultW;
            2'b01: resultW = read_dataW;
            2'b10: resultW = pcPlus4W;
            default: resultW = 32'd0;
        endcase
    end
endmodule
