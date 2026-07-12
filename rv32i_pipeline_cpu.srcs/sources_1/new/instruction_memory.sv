`timescale 1ns / 1ps
module instruction_memory #(
    parameter DEPTH = 256,
    parameter MEM_FILE = "program.mem"
    )(
    input logic [31:0] addr,
    output logic [31:0] instr
    );
    logic [31:0] mem [0:DEPTH-1];
    initial begin   
        if (MEM_FILE != "") $readmemh(MEM_FILE, mem);
    end
    // An unmapped instruction address behaves as an architectural NOP.  This
    // avoids an X-propagation avalanche after a test program falls off its end.
    assign instr = (addr[31:2] < DEPTH) ? mem[addr[31:2]] : 32'h0000_0013;
endmodule
