`timescale 1ns/1ps
module instruction_decoder (

    input  logic [31:0] instr,
    output logic [6:0] opcode,
    output logic [4:0] rd,
    output logic [2:0] funct3,
    output logic [4:0] rs1,
    output logic [4:0] rs2,
    output logic [6:0] funct7,
    output logic is_r_type,
    output logic is_i_type,
    output logic is_s_type,
    output logic is_b_type,
    output logic is_u_type,
    output logic is_j_type

);
    always_comb begin

        opcode = instr[6:0];
        rd      = instr[11:7];
        funct3  = instr[14:12];
        rs1     = instr[19:15];
        rs2     = instr[24:20];
        funct7  = instr[31:25];

    end
    always_comb begin

        // Default
        is_r_type = 1'b0;
        is_i_type = 1'b0;
        is_s_type = 1'b0;
        is_b_type = 1'b0;
        is_u_type = 1'b0;
        is_j_type = 1'b0;

        case(opcode)

            7'b0110011 : is_r_type = 1'b1;   // ADD SUB AND OR XOR ...

            7'b0010011,
            7'b0000011,
            7'b1100111 : is_i_type = 1'b1;   // ALU Immediate, Load, JALR

            7'b0100011 : is_s_type = 1'b1;   // SW SH SB

            7'b1100011 : is_b_type = 1'b1;   // BEQ BNE BLT ...

            7'b0110111,
            7'b0010111 : is_u_type = 1'b1;   // LUI AUIPC

            7'b1101111 : is_j_type = 1'b1;   // JAL

            default: begin
                is_r_type = 1'b0;
                is_i_type = 1'b0;
                is_s_type = 1'b0;
                is_b_type = 1'b0;
                is_u_type = 1'b0;
                is_j_type = 1'b0;
            end

        endcase

    end

endmodule