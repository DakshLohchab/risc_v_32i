`timescale 1ns/1ps
// Synthesizable little-endian byte-addressed RAM for RV32I loads and stores.
module data_memory #(parameter DEPTH_BYTES = 4096) (
    input logic clk, mem_write,
    input logic [2:0] funct3,
    input logic [31:0] addr, write_data,
    output logic [31:0] read_data
);
    logic [7:0] mem [0:DEPTH_BYTES-1];
    always_ff @(posedge clk) begin
        if (mem_write && addr < DEPTH_BYTES) begin
            unique case (funct3)
                3'b000: mem[addr] <= write_data[7:0];
                3'b001: if (addr + 1 < DEPTH_BYTES) begin mem[addr]<=write_data[7:0]; mem[addr+1]<=write_data[15:8]; end
                3'b010: if (addr + 3 < DEPTH_BYTES) begin mem[addr]<=write_data[7:0]; mem[addr+1]<=write_data[15:8]; mem[addr+2]<=write_data[23:16]; mem[addr+3]<=write_data[31:24]; end
                default: ;
            endcase
        end
    end
    always_comb begin
        read_data = 32'd0;
        if (addr < DEPTH_BYTES) begin
            unique case (funct3)
                3'b000: read_data = {{24{mem[addr][7]}},mem[addr]};
                3'b001: if (addr+1 < DEPTH_BYTES) read_data = {{16{mem[addr+1][7]}},mem[addr+1],mem[addr]};
                3'b010: if (addr+3 < DEPTH_BYTES) read_data = {mem[addr+3],mem[addr+2],mem[addr+1],mem[addr]};
                3'b100: read_data = {24'd0,mem[addr]};
                3'b101: if (addr+1 < DEPTH_BYTES) read_data = {16'd0,mem[addr+1],mem[addr]};
                default: ;
            endcase
        end
    end
endmodule
