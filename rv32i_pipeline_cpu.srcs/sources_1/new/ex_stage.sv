`timescale 1ns/1ps
// Execute stage: forwarding muxes, ALU operation, and branch/jump resolution.
module ex_stage (
    input  logic [31:0] pcE, pcPlus4E, rs1_dataE, rs2_dataE, immE,
    input  logic [4:0]  rs1E, rs2E,
    input  logic [2:0]  funct3E,
    input  logic [6:0]  funct7E, opcodeE,
    input  logic        alu_srcE, branchE, jumpE,
    input  logic [1:0]  alu_opE,
    input  logic [1:0]  forwardAE, forwardBE,
    input  logic [31:0] resultM, resultW,
    output logic [31:0] alu_resultE, write_dataE, pcTargetE,
    output logic        pcSrcE
);
    localparam OP_LUI   = 7'b0110111;
    localparam OP_AUIPC = 7'b0010111;
    localparam OP_JALR  = 7'b1100111;
    logic [31:0] srcA, srcB, aluA, aluB, alu_result_raw;
    logic [3:0] alu_ctrl;
    logic branch_taken;

    always_comb begin
        srcA = (forwardAE == 2'b10) ? resultM :
               (forwardAE == 2'b01) ? resultW : rs1_dataE;
        srcB = (forwardBE == 2'b10) ? resultM :
               (forwardBE == 2'b01) ? resultW : rs2_dataE;
        write_dataE = srcB;
        aluA = srcA;
        aluB = alu_srcE ? immE : srcB;
        if (opcodeE == OP_LUI) begin
            aluA = 32'd0;
            aluB = immE;
        end else if (opcodeE == OP_AUIPC) begin
            aluA = pcE;
            aluB = immE;
        end
    end

    alu_control u_alu_control(.alu_op(alu_opE), .funct3(funct3E), .funct7(funct7E), .opcode(opcodeE), .alu_ctrl(alu_ctrl));
    alu u_alu(.src_a(aluA), .src_b(aluB), .alu_ctrl(alu_ctrl), .alu_result(alu_result_raw), .zero(), .negative(), .carry(), .overflow());

    // Link instructions write the address of the following instruction.  Keep
    // this on the regular ALU-result path so it is forwarded and written back
    // exactly like any other register result.
    assign alu_resultE = jumpE ? pcPlus4E : alu_result_raw;

    always_comb begin
        branch_taken = 1'b0;
        unique case (funct3E)
            3'b000: branch_taken = (srcA == srcB);                 // BEQ
            3'b001: branch_taken = (srcA != srcB);                 // BNE
            3'b100: branch_taken = ($signed(srcA) <  $signed(srcB)); // BLT
            3'b101: branch_taken = ($signed(srcA) >= $signed(srcB)); // BGE
            3'b110: branch_taken = (srcA <  srcB);                 // BLTU
            3'b111: branch_taken = (srcA >= srcB);                 // BGEU
            default: ;
        endcase
    end

    assign pcTargetE = (opcodeE == OP_JALR) ? ((srcA + immE) & 32'hffff_fffe) : (pcE + immE);
    assign pcSrcE = jumpE || (branchE && branch_taken);
endmodule
