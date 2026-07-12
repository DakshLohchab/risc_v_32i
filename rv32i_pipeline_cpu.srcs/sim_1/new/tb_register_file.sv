`timescale 1ns/1ps

module tb_register_file;

logic         clk;
logic         rst_n;

logic [4:0]   rs1_addr;
logic [4:0]   rs2_addr;

logic [4:0]   rd_addr;
logic [31:0]  rd_write_data;
logic         reg_write_en;

logic [31:0]  rs1_data;
logic [31:0]  rs2_data;

register_file dut (

    .clk(clk),
    .rst_n(rst_n),

    .rs1_addr(rs1_addr),
    .rs2_addr(rs2_addr),

    .rd_addr(rd_addr),
    .rd_write_data(rd_write_data),
    .reg_write_en(reg_write_en),

    .rs1_data(rs1_data),
    .rs2_data(rs2_data)

);

always #5 clk = ~clk;

initial begin

    clk = 0;

    rst_n = 0;

    rs1_addr = 0;
    rs2_addr = 0;

    rd_addr = 0;
    rd_write_data = 0;
    reg_write_en = 0;

    #15;

    rst_n = 1;

    //-------------------------------------------------
    // Write x5 = 100
    //-------------------------------------------------

    @(posedge clk);

    reg_write_en = 1;
    rd_addr = 5;
    rd_write_data = 32'd100;

    @(posedge clk);

    reg_write_en = 0;

    rs1_addr = 5;

    #10;

    //-------------------------------------------------
    // Write x10 = 500
    //-------------------------------------------------

    @(posedge clk);

    reg_write_en = 1;
    rd_addr = 10;
    rd_write_data = 32'd500;

    @(posedge clk);

    reg_write_en = 0;

    rs2_addr = 10;

    #10;

    //-------------------------------------------------
    // Attempt write to x0
    //-------------------------------------------------

    @(posedge clk);

    reg_write_en = 1;
    rd_addr = 0;
    rd_write_data = 32'd999;

    @(posedge clk);

    reg_write_en = 0;

    rs1_addr = 0;

    #10;

    //-------------------------------------------------
    // Same-cycle bypass
    //-------------------------------------------------

    rs1_addr = 7;

    @(posedge clk);

    reg_write_en = 1;
    rd_addr = 7;
    rd_write_data = 32'd777;

    #1;

    @(posedge clk);

    reg_write_en = 0;

    #20;

    $finish;

end

initial begin

$monitor(
"Time=%0t  WE=%b  RD=%0d  WD=%0d  RS1=%0d  RD1=%0d  RS2=%0d  RD2=%0d",
$time,
reg_write_en,
rd_addr,
rd_write_data,
rs1_addr,
rs1_data,
rs2_addr,
rs2_data
);

end

endmodule