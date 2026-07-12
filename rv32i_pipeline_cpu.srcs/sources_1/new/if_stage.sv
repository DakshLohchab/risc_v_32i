`timescale 1ns/1ps

module if_stage(

    input  logic clk,
    input  logic rst_n,

    // Hazard control
    input  logic stallD,
    input  logic flushD,

    // Branch/Jump control
    input  logic        pcSrc,
    input  logic [31:0] pcTarget,

    // Outputs to Decode Stage
    output logic [31:0] instrD,
    output logic [31:0] pcD,
    output logic [31:0] pcPlus4D

);

    logic [31:0] pcF;
    logic [31:0] pcNext;
    logic [31:0] pcPlus4F;
    logic [31:0] instrF;
    // A load-use stall holds both the IF/ID register and the PC.  Keeping the
    // PC stable is essential; otherwise the instruction after the dependent
    // instruction would be lost while IF/ID is held.
    assign pcNext = pcSrc ? pcTarget : (stallD ? pcF : pcPlus4F);
    pc PC(

    .clk(clk),
    .rst_n(rst_n),
    .pc_next(pcNext),
    .pc_current(pcF)

    );
    adder PC_PLUS4(

    .a(pcF),
    .b(32'd4),
    .y(pcPlus4F)

    );
    instruction_memory IMEM(

    .addr(pcF),
    .instr(instrF)

    );
    if_id IF_ID(

    .clk(clk),
    .rst_n(rst_n),

    .stallD(stallD),
    .flushD(flushD),

    .instrF(instrF),
    .pcF(pcF),
    .pcPlus4F(pcPlus4F),

    .instrD(instrD),
    .pcD(pcD),
    .pcPlus4D(pcPlus4D)

    );

endmodule
