`timescale 1ns/1ps

module tb_if_id;

logic clk;
logic rst_n;

logic stallD;
logic flushD;

logic [31:0] instrF;
logic [31:0] pcF;
logic [31:0] pcPlus4F;

logic [31:0] instrD;
logic [31:0] pcD;
logic [31:0] pcPlus4D;

if_id dut(

    .clk(clk),
    .rst_n(rst_n),

    .stallD(stallD),
    .flushD(flushD),

    .instrF(instrF),
    .pcF(pcF),
    .pcPlus4F(pcPlus4F),

    .instrD(instrD),
    .pcD(pcD),
    .pcPlus4D(pcPlus4D)

);

always #5 clk = ~clk;

initial begin

    clk=0;

    rst_n=0;

    stallD=0;
    flushD=0;

    instrF=32'h00500093;
    pcF=32'h0;
    pcPlus4F=32'h4;

    #12;

    rst_n=1;

    //-------------------------
    // Instruction 1
    //-------------------------

    @(posedge clk);

    //-------------------------
    // Instruction 2
    //-------------------------

    instrF=32'h00A00113;
    pcF=32'h4;
    pcPlus4F=32'h8;

    @(posedge clk);

    //-------------------------
    // Stall
    //-------------------------

    stallD=1;

    instrF=32'hFFFFFFFF;
    pcF=32'h100;

    @(posedge clk);

    stallD=0;

    //-------------------------
    // Flush
    //-------------------------

    flushD=1;

    @(posedge clk);

    flushD=0;

    //-------------------------
    // Instruction 3
    //-------------------------

    instrF=32'h002081B3;
    pcF=32'h8;
    pcPlus4F=32'hC;

    @(posedge clk);

    #10;

    $finish;

end

initial begin

$monitor(
"Time=%0t rst=%b stall=%b flush=%b instrD=%h pcD=%h",
$time,
rst_n,
stallD,
flushD,
instrD,
pcD
);

end

endmodule