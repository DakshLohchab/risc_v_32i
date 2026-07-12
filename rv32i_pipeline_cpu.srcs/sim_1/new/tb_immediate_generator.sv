`timescale 1ns/1ps

module tb_immediate_generator;

logic [31:0] instr;
logic [6:0]  opcode;
logic [31:0] imm;

immediate_generator dut (

    .instr(instr),
    .opcode(opcode),
    .imm(imm)

);

initial begin

    // addi x1,x0,5
    instr  = 32'h00500093;
    opcode = 7'b0010011;
    #10;

    // sw x3,0(x0)
    instr  = 32'h00302023;
    opcode = 7'b0100011;
    #10;

    // beq x1,x2,+8
    instr  = 32'h00208463;
    opcode = 7'b1100011;
    #10;

    // lui x1,0x12345
    instr  = 32'h123450B7;
    opcode = 7'b0110111;
    #10;

    // jal x0,+8
    instr  = 32'h0080006F;
    opcode = 7'b1101111;
    #10;

    $finish;

end

initial begin

    $monitor(
        "Time=%0t Instr=%h Opcode=%b Imm=%h (%0d)",
        $time,
        instr,
        opcode,
        imm,
        $signed(imm)
    );

end

endmodule