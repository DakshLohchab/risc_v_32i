`timescale 1ns/1ps

module tb_id_ex;

logic clk;
logic rst_n;
logic flushE;

logic [31:0] pcD;
logic [31:0] pcPlus4D;

logic [31:0] rs1_dataD;
logic [31:0] rs2_dataD;

logic [31:0] immD;

logic [4:0] rs1D;
logic [4:0] rs2D;
logic [4:0] rdD;

logic [2:0] funct3D;
logic [6:0] funct7D;

logic reg_writeD;
logic mem_writeD;
logic alu_srcD;
logic branchD;
logic jumpD;

logic [1:0] result_srcD;
logic [1:0] alu_opD;

logic [31:0] pcE;
logic [31:0] pcPlus4E;

logic [31:0] rs1_dataE;
logic [31:0] rs2_dataE;

logic [31:0] immE;

logic [4:0] rs1E;
logic [4:0] rs2E;
logic [4:0] rdE;

logic [2:0] funct3E;
logic [6:0] funct7E;

logic reg_writeE;
logic mem_writeE;
logic alu_srcE;
logic branchE;
logic jumpE;

logic [1:0] result_srcE;
logic [1:0] alu_opE;

id_ex dut (

    .*

);

always #5 clk = ~clk;

initial begin

    clk = 0;
    rst_n = 0;
    flushE = 0;

    #12;

    rst_n = 1;

    pcD         = 32'h00000020;
    pcPlus4D    = 32'h00000024;

    rs1_dataD   = 32'd100;
    rs2_dataD   = 32'd200;

    immD        = 32'd16;

    rs1D        = 5'd1;
    rs2D        = 5'd2;
    rdD         = 5'd5;

    funct3D     = 3'b000;
    funct7D     = 7'b0000000;

    reg_writeD  = 1;
    mem_writeD  = 0;
    alu_srcD    = 1;
    branchD     = 0;
    jumpD       = 0;

    result_srcD = 2'b00;
    alu_opD     = 2'b10;

    @(posedge clk);

    #1;

    flushE = 1;

    @(posedge clk);

    #1;

    flushE = 0;

    pcD         = 32'h00000040;
    pcPlus4D    = 32'h00000044;

    rs1_dataD   = 32'd50;
    rs2_dataD   = 32'd75;

    immD        = 32'd8;

    rs1D        = 5'd6;
    rs2D        = 5'd7;
    rdD         = 5'd8;

    funct3D     = 3'b111;
    funct7D     = 7'b0000000;

    reg_writeD  = 1;
    mem_writeD  = 1;
    alu_srcD    = 0;
    branchD     = 1;
    jumpD       = 0;

    result_srcD = 2'b01;
    alu_opD     = 2'b00;

    @(posedge clk);

    #20;

    $finish;

end

initial begin

$monitor(
"t=%0t flush=%b PC=%h RD=%0d RegWrite=%b MemWrite=%b ALUSrc=%b Branch=%b ResultSrc=%b ALUOp=%b",
$time,
flushE,
pcE,
rdE,
reg_writeE,
mem_writeE,
alu_srcE,
branchE,
result_srcE,
alu_opE
);

end

endmodule