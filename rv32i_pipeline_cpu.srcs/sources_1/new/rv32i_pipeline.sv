`timescale 1ns/1ps
// Integration wrapper: all datapath behaviour remains in the stage/component modules.
module rv32i_pipeline #(parameter DMEM_DEPTH_BYTES = 4096) (input logic clk, rst_n);
    logic stallF,stallD,flushD,flushE,pcSrcE; logic [31:0] pcTargetE;
    logic [31:0] instrD,pcD,pcPlus4D,pcOutD,pcPlus4OutD,rs1Ddata,rs2Ddata,immD;
    logic [4:0] rs1D,rs2D,rdD; logic [2:0] funct3D; logic [6:0] funct7D;
    logic regWriteD,memWriteD,aluSrcD,branchD,jumpD; logic [1:0] resultSrcD,aluOpD;
    logic [31:0] pcE,pcPlus4E,rs1Edata,rs2Edata,immE; logic [4:0] rs1E,rs2E,rdE; logic [2:0] funct3E; logic [6:0] funct7E,opcodeE;
    logic regWriteE,memWriteE,aluSrcE,branchE,jumpE; logic [1:0] resultSrcE,aluOpE;
    logic [1:0] forwardAE,forwardBE; logic [31:0] aluResultE,writeDataE;
    logic regWriteM,memWriteM; logic [1:0] resultSrcM; logic [2:0] funct3M; logic [4:0] rdM; logic [31:0] aluResultM,writeDataM,pcPlus4M,readDataM,resultM;
    logic regWriteW; logic [1:0] resultSrcW; logic [4:0] rdW; logic [31:0] aluResultW,readDataW,pcPlus4W,resultW;

    if_stage u_if_stage(.clk,.rst_n,.stallD,.flushD,.pcSrc(pcSrcE),.pcTarget(pcTargetE),.instrD,.pcD,.pcPlus4D);
    id_stage u_id_stage(.clk,.rst_n,.instrD,.pcD,.pcPlus4D,.reg_writeW(regWriteW),.rdW,.resultW,.pc_outD(pcOutD),.pcPlus4_outD(pcPlus4OutD),.rs1_dataD(rs1Ddata),.rs2_dataD(rs2Ddata),.immD,.rs1D,.rs2D,.rdD,.funct3D,.funct7D,.reg_writeD(regWriteD),.mem_writeD(memWriteD),.alu_srcD(aluSrcD),.branchD,.jumpD,.result_srcD(resultSrcD),.alu_opD(aluOpD));
    id_ex u_id_ex(.clk,.rst_n,.flushE,.pcD(pcOutD),.pcPlus4D(pcPlus4OutD),.rs1_dataD(rs1Ddata),.rs2_dataD(rs2Ddata),.immD,.rs1D,.rs2D,.rdD,.funct3D,.funct7D,.opcodeD(instrD[6:0]),.reg_writeD(regWriteD),.mem_writeD(memWriteD),.alu_srcD(aluSrcD),.branchD,.jumpD,.result_srcD(resultSrcD),.alu_opD(aluOpD),.pcE,.pcPlus4E,.rs1_dataE(rs1Edata),.rs2_dataE(rs2Edata),.immE,.rs1E,.rs2E,.rdE,.funct3E,.funct7E,.opcodeE,.reg_writeE(regWriteE),.mem_writeE(memWriteE),.alu_srcE(aluSrcE),.branchE,.jumpE,.result_srcE(resultSrcE),.alu_opE(aluOpE));
    ex_stage u_ex_stage(.pcE,.pcPlus4E,.rs1_dataE(rs1Edata),.rs2_dataE(rs2Edata),.immE,.rs1E,.rs2E,.funct3E,.funct7E,.opcodeE,.alu_srcE(aluSrcE),.branchE,.jumpE,.alu_opE(aluOpE),.forwardAE,.forwardBE,.resultM,.resultW,.alu_resultE(aluResultE),.write_dataE(writeDataE),.pcTargetE,.pcSrcE);
    ex_mem u_ex_mem(.clk,.rst_n,.reg_writeE(regWriteE),.mem_writeE(memWriteE),.result_srcE(resultSrcE),.funct3E,.rdE,.alu_resultE(aluResultE),.write_dataE(writeDataE),.pcPlus4E,.reg_writeM(regWriteM),.mem_writeM(memWriteM),.result_srcM(resultSrcM),.funct3M,.rdM,.alu_resultM(aluResultM),.write_dataM(writeDataM),.pcPlus4M);
    mem_stage #(.DMEM_DEPTH_BYTES(DMEM_DEPTH_BYTES)) u_mem_stage(.clk,.mem_writeM(memWriteM),.funct3M,.alu_resultM(aluResultM),.write_dataM(writeDataM),.read_dataM(readDataM));
    mem_wb u_mem_wb(.clk,.rst_n,.reg_writeM(regWriteM),.result_srcM(resultSrcM),.rdM,.alu_resultM(aluResultM),.read_dataM(readDataM),.pcPlus4M,.reg_writeW(regWriteW),.result_srcW(resultSrcW),.rdW,.alu_resultW(aluResultW),.read_dataW(readDataW),.pcPlus4W);
    wb_stage u_wb_stage(.result_srcW(resultSrcW),.alu_resultW(aluResultW),.read_dataW(readDataW),.pcPlus4W,.resultW);
    assign resultM = (resultSrcM == 2'b10) ? pcPlus4M : aluResultM;
    hazard_unit u_hazard_unit(.opcodeD(instrD[6:0]),.rs1D,.rs2D,.rs1E,.rs2E,.rdE,.rdM,.rdW,.result_srcE(resultSrcE),.result_srcM(resultSrcM),.reg_writeM(regWriteM),.reg_writeW(regWriteW),.pcSrcE,.stallF,.stallD,.flushD,.flushE,.forwardAE,.forwardBE);
endmodule
