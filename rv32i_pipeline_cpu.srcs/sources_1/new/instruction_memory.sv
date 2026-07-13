`timescale 1ns / 1ps
module instruction_memory #(
    parameter DEPTH = 256,
    parameter string MEM_FILE = ""
    )(
    input logic [31:0] addr,
    output logic [31:0] instr
    );
    logic [31:0] mem [0:DEPTH-1];
    integer fd;
    integer i;
    logic loaded;
    string candidates [4];

    initial begin
        loaded = 1'b0;
        candidates[0] = MEM_FILE;
        candidates[1] = "program.mem";
        candidates[2] = "rv32i_pipeline_cpu.srcs/sources_1/new/program.mem";
        candidates[3] = "/home/dlohchab/projects/Verilog/rv32i_pipeline_cpu/rv32i_pipeline_cpu.srcs/sources_1/new/program.mem";

        for (i = 0; i < 4 && !loaded; i = i + 1) begin
            if (candidates[i] != "") begin
                fd = $fopen(candidates[i], "r");
                if (fd != 0) begin
                    $fclose(fd);
                    $readmemh(candidates[i], mem);
                    loaded = 1'b1;
                end
            end
        end
    end

    // An unmapped instruction address behaves as an architectural NOP.  This
    // avoids an X-propagation avalanche after a test program falls off its end.
    assign instr = (addr[31:2] < DEPTH) ? mem[addr[31:2]] : 32'h0000_0013;
endmodule
