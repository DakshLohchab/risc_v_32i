`timescale 1ns/1ps

module id_ex (

    input  logic         clk,
    input  logic         rst_n,
    input  logic         flushE,

    input  logic [31:0]  pcD,
    input  logic [31:0]  pcPlus4D,

    input  logic [31:0]  rs1_dataD,
    input  logic [31:0]  rs2_dataD,

    input  logic [31:0]  immD,

    input  logic [4:0]   rs1D,
    input  logic [4:0]   rs2D,
    input  logic [4:0]   rdD,

    input  logic [2:0]   funct3D,
    input  logic [6:0]   funct7D,
    input  logic [6:0]   opcodeD,

    input  logic         reg_writeD,
    input  logic         mem_writeD,
    input  logic         alu_srcD,
    input  logic         branchD,
    input  logic         jumpD,

    input  logic [1:0]   result_srcD,
    input  logic [1:0]   alu_opD,

    output logic [31:0]  pcE,
    output logic [31:0]  pcPlus4E,

    output logic [31:0]  rs1_dataE,
    output logic [31:0]  rs2_dataE,

    output logic [31:0]  immE,

    output logic [4:0]   rs1E,
    output logic [4:0]   rs2E,
    output logic [4:0]   rdE,

    output logic [2:0]   funct3E,
    output logic [6:0]   funct7E,
    output logic [6:0]   opcodeE,

    output logic         reg_writeE,
    output logic         mem_writeE,
    output logic         alu_srcE,
    output logic         branchE,
    output logic         jumpE,

    output logic [1:0]   result_srcE,
    output logic [1:0]   alu_opE

);

always_ff @(posedge clk or negedge rst_n) begin

    if (!rst_n) begin

        pcE         <= 32'd0;
        pcPlus4E    <= 32'd0;

        rs1_dataE   <= 32'd0;
        rs2_dataE   <= 32'd0;

        immE        <= 32'd0;

        rs1E        <= 5'd0;
        rs2E        <= 5'd0;
        rdE         <= 5'd0;

        funct3E     <= 3'd0;
        funct7E     <= 7'd0;
        opcodeE     <= 7'd0;

        reg_writeE  <= 1'b0;
        mem_writeE  <= 1'b0;
        alu_srcE    <= 1'b0;
        branchE     <= 1'b0;
        jumpE       <= 1'b0;

        result_srcE <= 2'd0;
        alu_opE     <= 2'd0;

    end

    else begin

        pcE         <= pcD;
        pcPlus4E    <= pcPlus4D;

        rs1_dataE   <= rs1_dataD;
        rs2_dataE   <= rs2_dataD;

        immE        <= immD;

        rs1E        <= rs1D;
        rs2E        <= rs2D;
        rdE         <= rdD;

        funct3E     <= funct3D;
        funct7E     <= funct7D;
        opcodeE     <= opcodeD;

        if (flushE) begin

            reg_writeE  <= 1'b0;
            mem_writeE  <= 1'b0;
            alu_srcE    <= 1'b0;
            branchE     <= 1'b0;
            jumpE       <= 1'b0;

            result_srcE <= 2'd0;
            alu_opE     <= 2'd0;

        end

        else begin

            reg_writeE  <= reg_writeD;
            mem_writeE  <= mem_writeD;
            alu_srcE    <= alu_srcD;
            branchE     <= branchD;
            jumpE       <= jumpD;

            result_srcE <= result_srcD;
            alu_opE     <= alu_opD;

        end

    end

end

endmodule
