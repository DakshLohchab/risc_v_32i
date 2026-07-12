`timescale 1ns/1ps

module tb_alu_control;

logic [1:0] alu_op;
logic [2:0] funct3;
logic [6:0] funct7;

logic [3:0] alu_ctrl;

alu_control dut (

    .alu_op(alu_op),
    .funct3(funct3),
    .funct7(funct7),
    .alu_ctrl(alu_ctrl)

);

initial begin

    // Load/Store
    alu_op = 2'b00;
    funct3 = 3'b000;
    funct7 = 7'b0000000;
    #10;

    // Branch
    alu_op = 2'b01;
    #10;

    // ADD
    alu_op = 2'b10;
    funct3 = 3'b000;
    funct7 = 7'b0000000;
    #10;

    // SUB
    funct7 = 7'b0100000;
    #10;

    // AND
    funct3 = 3'b111;
    funct7 = 7'b0000000;
    #10;

    // OR
    funct3 = 3'b110;
    #10;

    // XOR
    funct3 = 3'b100;
    #10;

    // SLT
    funct3 = 3'b010;
    #10;

    // SLL
    funct3 = 3'b001;
    #10;

    // SRL
    funct3 = 3'b101;
    funct7 = 7'b0000000;
    #10;

    // SRA
    funct7 = 7'b0100000;
    #10;

    $finish;

end

initial begin

    $monitor(
        "Time=%0t ALUOp=%b funct3=%b funct7=%b ALUCtrl=%b",
        $time,
        alu_op,
        funct3,
        funct7,
        alu_ctrl
    );
end

endmodule