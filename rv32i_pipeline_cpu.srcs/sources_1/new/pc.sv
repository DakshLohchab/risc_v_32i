`timescale 1ns / 1ps
module pc(
    input logic clk,rst_n,
    input logic [31:0] pc_next,
    output logic [31:0] pc_current
    );
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc_current<=0;
        end else begin
            pc_current<=pc_next;
            end 
    end
endmodule
