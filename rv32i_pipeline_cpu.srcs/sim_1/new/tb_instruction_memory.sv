`timescale 1ns/1ps

module tb_instruction_memory;

logic [31:0] addr;
logic [31:0] instr;

instruction_memory dut(
    .addr(addr),
    .instr(instr)
);

initial begin

    addr = 32'h00000000;
    #10;

    addr = 32'h00000004;
    #10;

    addr = 32'h00000008;
    #10;

    addr = 32'h0000000C;
    #10;

    $finish;

end

initial begin
    $monitor("Time=%0t  Addr=%h  Instr=%h",
              $time, addr, instr);
end

endmodule