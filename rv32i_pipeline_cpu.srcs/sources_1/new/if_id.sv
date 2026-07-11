`timescale 1ns/1ps

module if_id (

    input  logic         clk,
    input  logic         rst_n,

    // Hazard Control
    input  logic         stallD,
    input  logic         flushD,

    // Inputs from IF stage
    input  logic [31:0]  instrF,
    input  logic [31:0]  pcF,
    input  logic [31:0]  pcPlus4F,

    // Outputs to ID stage
    output logic [31:0]  instrD,
    output logic [31:0]  pcD,
    output logic [31:0]  pcPlus4D

);

always_ff @(posedge clk or negedge rst_n) begin

    if(!rst_n) begin

        instrD   <= 32'h00000013;   // NOP
        pcD      <= 32'd0;
        pcPlus4D <= 32'd0;

    end

    else if(flushD) begin

        instrD   <= 32'h00000013;   // Insert Bubble
        pcD      <= 32'd0;
        pcPlus4D <= 32'd0;

    end

    else if(stallD) begin

        instrD   <= instrD;
        pcD      <= pcD;
        pcPlus4D <= pcPlus4D;

    end

    else begin

        instrD   <= instrF;
        pcD      <= pcF;
        pcPlus4D <= pcPlus4F;

    end

end

endmodule