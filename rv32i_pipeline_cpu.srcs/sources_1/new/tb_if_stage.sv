`timescale 1ns/1ps

module tb_if_stage;

logic clk;
logic rst_n;

logic stallD;
logic flushD;

logic pcSrc;
logic [31:0] pcTarget;

logic [31:0] instrD;
logic [31:0] pcD;
logic [31:0] pcPlus4D;

if_stage dut(

    .clk(clk),
    .rst_n(rst_n),

    .stallD(stallD),
    .flushD(flushD),

    .pcSrc(pcSrc),
    .pcTarget(pcTarget),

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

    pcSrc=0;
    pcTarget=32'd0;

    #12;

    rst_n=1;

    repeat(8)
        @(posedge clk);

    $finish;

end

initial begin

$monitor("T=%0t PC=%h Instr=%h",
          $time,
          pcD,
          instrD);

end

endmodule