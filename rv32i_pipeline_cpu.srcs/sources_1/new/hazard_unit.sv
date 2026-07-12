`timescale 1ns/1ps
// Interlock and forwarding policy for an in-order five-stage pipeline.
module hazard_unit (
    input logic [6:0] opcodeD,
    input logic [4:0] rs1D, rs2D, rs1E, rs2E, rdE, rdM, rdW,
    input logic [1:0] result_srcE, result_srcM,
    input logic reg_writeM, reg_writeW, pcSrcE,
    output logic stallF, stallD, flushD, flushE,
    output logic [1:0] forwardAE, forwardBE
);
    logic uses_rs1D, uses_rs2D, load_stall;
    always_comb begin
        uses_rs1D = 1'b0; uses_rs2D = 1'b0;
        unique case (opcodeD)
            7'b0110011, 7'b0100011, 7'b1100011: begin uses_rs1D=1; uses_rs2D=1; end
            7'b0010011, 7'b0000011, 7'b1100111: uses_rs1D=1;
            default: ;
        endcase
        load_stall = (result_srcE == 2'b01) && (rdE != 0) &&
                     ((uses_rs1D && rdE == rs1D) || (uses_rs2D && rdE == rs2D));
        stallF = load_stall;
        stallD = load_stall;
        flushD = pcSrcE;
        flushE = load_stall || pcSrcE;

        forwardAE = 2'b00;
        forwardBE = 2'b00;
        // A load cannot forward from MEM: its data is captured only at MEM/WB.
        if (reg_writeM && result_srcM != 2'b01 && rdM != 0 && rdM == rs1E) forwardAE = 2'b10;
        else if (reg_writeW && rdW != 0 && rdW == rs1E) forwardAE = 2'b01;
        if (reg_writeM && result_srcM != 2'b01 && rdM != 0 && rdM == rs2E) forwardBE = 2'b10;
        else if (reg_writeW && rdW != 0 && rdW == rs2E) forwardBE = 2'b01;
    end
endmodule
