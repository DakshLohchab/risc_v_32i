`timescale 1ns / 1ps
module instruction_memory #(
    parameter DEPTH = 256
    )(
    input logic [31:0] addr,
    output logic [31:0] instr
    );
    logic [31:0] mem [0:DEPTH-1];
    initial begin   
        $readmemh("program.mem",mem);
    end
    assign instr = mem[addr[31:2]];
endmodule
