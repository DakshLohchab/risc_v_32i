`timescale 1ns/1ps

module tb_alu;

logic [31:0] src_a;
logic [31:0] src_b;
logic [3:0]  alu_ctrl;

logic [31:0] alu_result;
logic        zero;
logic        negative;
logic        carry;
logic        overflow;

alu dut (

    .src_a(src_a),
    .src_b(src_b),
    .alu_ctrl(alu_ctrl),

    .alu_result(alu_result),
    .zero(zero),
    .negative(negative),
    .carry(carry),
    .overflow(overflow)

);

initial begin

    // ADD
    src_a = 32'd20;
    src_b = 32'd5;
    alu_ctrl = 4'b0000;
    #10;

    // SUB
    alu_ctrl = 4'b0001;
    #10;

    // AND
    alu_ctrl = 4'b0010;
    #10;

    // OR
    alu_ctrl = 4'b0011;
    #10;

    // XOR
    alu_ctrl = 4'b0100;
    #10;

    // SLT
    alu_ctrl = 4'b0101;
    #10;

    // SLL
    alu_ctrl = 4'b0110;
    #10;

    // SRL
    alu_ctrl = 4'b0111;
    #10;

    // SRA
    src_a = -32'sd20;
    src_b = 32'd2;
    alu_ctrl = 4'b1000;
    #10;

    // Zero Flag
    src_a = 32'd10;
    src_b = 32'd10;
    alu_ctrl = 4'b0001;
    #10;

    // Carry Test
    src_a = 32'hFFFFFFFF;
    src_b = 32'h00000001;
    alu_ctrl = 4'b0000;
    #10;

    // Overflow Test
    src_a = 32'h7FFFFFFF;
    src_b = 32'h00000001;
    alu_ctrl = 4'b0000;
    #10;

    // Negative Result
    src_a = 32'd5;
    src_b = 32'd20;
    alu_ctrl = 4'b0001;
    #10;

    $finish;

end

initial begin

    $monitor(
"Time=%0t CTRL=%0d A=%0d B=%0d RESULT=%0d Z=%b N=%b C=%b V=%b",
$time,
alu_ctrl,
$signed(src_a),
$signed(src_b),
$signed(alu_result),
zero,
negative,
carry,
overflow
);

end

endmodule