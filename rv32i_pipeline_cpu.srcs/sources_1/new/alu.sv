`timescale 1ns/1ps

module alu (

    input  logic [31:0] src_a,
    input  logic [31:0] src_b,
    input  logic [3:0]  alu_ctrl,

    output logic [31:0] alu_result,
    output logic        zero,
    output logic        negative,
    output logic        carry,
    output logic        overflow

);

 logic [32:0] sum;
 logic [32:0] diff;
 // Keep the operands explicitly signed for instructions whose ISA semantics
 // are signed.  This avoids an unsigned comparison after pipeline forwarding.
 logic signed [31:0] signed_a;
 logic signed [31:0] signed_b;
 logic signed [31:0] signed_res;

 always_comb begin

    sum  = {1'b0, src_a} + {1'b0, src_b};
    diff = {1'b0, src_a} - {1'b0, src_b};

    signed_a = src_a;
    signed_b = src_b;
    signed_res = signed_a >>> src_b[4:0];

    alu_result = 32'd0;
    carry      = 1'b0;
    overflow   = 1'b0;

    unique case (alu_ctrl)

        // ADD
        4'b0000: begin
            alu_result = sum[31:0];
            carry      = sum[32];
            overflow   = (~(src_a[31] ^ src_b[31])) &
                         (src_a[31] ^ alu_result[31]);
        end

        // SUB
        4'b0001: begin
            alu_result = diff[31:0];
            carry      = ~diff[32];
            overflow   = (src_a[31] ^ src_b[31]) &
                         (src_a[31] ^ alu_result[31]);
        end

        // AND
        4'b0010:
            alu_result = src_a & src_b;

        // OR
        4'b0011:
            alu_result = src_a | src_b;

        // XOR
        4'b0100:
            alu_result = src_a ^ src_b;

        // SLT (signed): compare operands as signed values.
        4'b0101:
            alu_result = ($signed(src_a) < $signed(src_b)) ? 32'd1 : 32'd0;

        // SLTU
        4'b0110:
            alu_result = (src_a < src_b);

        // SLL
        4'b0111:
            alu_result = src_a << src_b[4:0];

        // SRL
        4'b1000:
            alu_result = src_a >> src_b[4:0];

        // SRA
        4'b1001:
            alu_result = signed_res;

        default:
            alu_result = 32'd0;

    endcase

 end

 assign zero     = (alu_result == 32'd0);
 assign negative = alu_result[31];

endmodule
