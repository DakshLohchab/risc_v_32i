`timescale 1ns/1ps

module tb_control_unit;

logic [6:0] opcode;

logic reg_write;
logic mem_write;
logic alu_src;
logic branch;
logic jump;

logic [1:0] result_src;
logic [1:0] alu_op;

control_unit dut (

    .opcode(opcode),

    .reg_write(reg_write),
    .mem_write(mem_write),
    .alu_src(alu_src),
    .branch(branch),
    .jump(jump),

    .result_src(result_src),
    .alu_op(alu_op)

);

initial begin

    opcode = 7'b0110011; #10;   // R-Type

    opcode = 7'b0010011; #10;   // I-Type

    opcode = 7'b0000011; #10;   // Load

    opcode = 7'b0100011; #10;   // Store

    opcode = 7'b1100011; #10;   // Branch

    opcode = 7'b1101111; #10;   // JAL

    opcode = 7'b1100111; #10;   // JALR

    opcode = 7'b0110111; #10;   // LUI

    opcode = 7'b0010111; #10;   // AUIPC

    $finish;

end

initial begin

    $monitor(
"opcode=%b RW=%b MW=%b ALUSrc=%b Branch=%b Jump=%b ResultSrc=%b ALUOp=%b",
opcode,
reg_write,
mem_write,
alu_src,
branch,
jump,
result_src,
alu_op
);

end

endmodule