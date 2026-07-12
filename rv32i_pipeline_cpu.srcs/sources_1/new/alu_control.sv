`timescale 1ns/1ps

module alu_control (

    input  logic [1:0] alu_op,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,
    input  logic [6:0] opcode,

    output logic [3:0] alu_ctrl

);

 always_comb begin

    unique case (alu_op)

        // Address calculation
        2'b00:
            alu_ctrl = 4'b0000;

        // Branch comparison
        2'b01:
            alu_ctrl = 4'b0001;

        // Decode R/I-type ALU instructions
        2'b10: begin

            unique case (funct3)

                3'b000: begin
                    // bit 30 selects SUB only for an R-type operation.
                    // In ADDI it is part of the signed immediate.
                    if (opcode == 7'b0110011 && funct7 == 7'b0100000)
                        alu_ctrl = 4'b0001;   // SUB
                    else
                        alu_ctrl = 4'b0000;   // ADD / ADDI
                end

                3'b111: alu_ctrl = 4'b0010;   // AND
                3'b110: alu_ctrl = 4'b0011;   // OR
                3'b100: alu_ctrl = 4'b0100;   // XOR
                3'b010: alu_ctrl = 4'b0101;   // SLT
                3'b011: alu_ctrl = 4'b0110;   // SLTU
                3'b001: alu_ctrl = 4'b0111;   // SLL

                3'b101: begin
                    if (funct7 == 7'b0100000)
                        alu_ctrl = 4'b1001;   // SRA
                    else
                        alu_ctrl = 4'b1000;   // SRL
                end

                default:
                    alu_ctrl = 4'b0000;

            endcase

        end

        default:
            alu_ctrl = 4'b0000;

    endcase

end

endmodule
