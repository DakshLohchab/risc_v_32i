`timescale 1ns/1ps

module register_file (

    input  logic         clk,
    input  logic         rst_n,
    input  logic [4:0]   rs1_addr,
    input  logic [4:0]   rs2_addr,
    input  logic [4:0]   rd_addr,
    input  logic [31:0]  rd_write_data,
    input  logic         reg_write_en,
    output logic [31:0]  rs1_data,
    output logic [31:0]  rs2_data
);
    logic [31:0] registers [31:0];
    integer i;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'd0;
        end
        else begin
            if (reg_write_en && (rd_addr != 5'd0))
                registers[rd_addr] <= rd_write_data;
        end
   end

    always_comb begin

        if (rs1_addr == 5'd0)
            rs1_data = 32'd0;
        else if (reg_write_en &&
             (rd_addr == rs1_addr) &&
             (rd_addr != 5'd0))
            rs1_data = rd_write_data;
        else
            rs1_data = registers[rs1_addr];
    end

    always_comb begin
        if (rs2_addr == 5'd0)
            rs2_data = 32'd0;
        else if (reg_write_en &&
             (rd_addr == rs2_addr) &&
             (rd_addr != 5'd0))
            rs2_data = rd_write_data;
        else
            rs2_data = registers[rs2_addr];
    end

endmodule