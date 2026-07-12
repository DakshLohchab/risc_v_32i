`timescale 1ns/1ps

module id_stage (

    input  logic         clk,
    input  logic         rst_n,

    input  logic [31:0]  instrD,
    input  logic [31:0]  pcD,
    input  logic [31:0]  pcPlus4D,

    // Write Back Interface
    input  logic         reg_writeW,
    input  logic [4:0]   rdW,
    input  logic [31:0]  resultW,

    // Datapath Outputs
    output logic [31:0]  pc_outD,
    output logic [31:0]  pcPlus4_outD,

    output logic [31:0]  rs1_dataD,
    output logic [31:0]  rs2_dataD,
    output logic [31:0]  immD,

    output logic [4:0]   rs1D,
    output logic [4:0]   rs2D,
    output logic [4:0]   rdD,

    output logic [2:0]   funct3D,
    output logic [6:0]   funct7D,

    output logic         reg_writeD,
    output logic         mem_writeD,
    output logic         alu_srcD,
    output logic         branchD,
    output logic         jumpD,

    output logic [1:0]   result_srcD,
    output logic [1:0]   alu_opD

);

logic [6:0] opcode;

assign pc_outD     = pcD;
assign pcPlus4_outD = pcPlus4D;

instruction_decoder u_instruction_decoder (

    .instr(instrD),

    .opcode(opcode),
    .rd(rdD),
    .funct3(funct3D),
    .rs1(rs1D),
    .rs2(rs2D),
    .funct7(funct7D),

    .is_r_type(),
    .is_i_type(),
    .is_s_type(),
    .is_b_type(),
    .is_u_type(),
    .is_j_type()

);

register_file u_register_file (

    .clk(clk),
    .rst_n(rst_n),

    .rs1_addr(rs1D),
    .rs2_addr(rs2D),

    .rd_addr(rdW),
    .rd_write_data(resultW),
    .reg_write_en(reg_writeW),

    .rs1_data(rs1_dataD),
    .rs2_data(rs2_dataD)

);

immediate_generator u_immediate_generator (

    .instr(instrD),
    .opcode(opcode),

    .imm(immD)

);

control_unit u_control_unit (

    .opcode(opcode),

    .reg_write(reg_writeD),
    .mem_write(mem_writeD),
    .alu_src(alu_srcD),
    .branch(branchD),
    .jump(jumpD),

    .result_src(result_srcD),
    .alu_op(alu_opD)

);

endmodule