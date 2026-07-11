`timescale 1ns/1ps

module pc_tb;

    // DUT Signals
    logic         clk;
    logic         rst_n;
    logic [31:0]  pc_next;
    logic [31:0]  pc_current;

    // Instantiate DUT
    pc dut (
        .clk        (clk),
        .rst_n      (rst_n),
        .pc_next    (pc_next),
        .pc_current (pc_current)
    );

    //------------------------------------------
    // Clock Generation
    //------------------------------------------
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    //------------------------------------------
    // Stimulus
    //------------------------------------------
    initial begin

        // Initialize
        rst_n   = 0;
        pc_next = 32'h00000000;

        // Hold reset for a while
        #12;
        rst_n = 1;

        // Apply new PC values
        @(posedge clk);
        pc_next = 32'h00000004;

        @(posedge clk);
        pc_next = 32'h00000008;

        @(posedge clk);
        pc_next = 32'h0000000C;

        @(posedge clk);
        pc_next = 32'h00000010;

        @(posedge clk);

        $display("---------------------------------------");
        $display("PC Test Completed Successfully");
        $display("---------------------------------------");

        $finish;

    end

    //------------------------------------------
    // Monitor
    //------------------------------------------
    initial begin
        $display(" Time\t rst_n\t pc_next\t pc_current");
        $monitor("%4t\t %b\t %h\t %h",
                 $time,
                 rst_n,
                 pc_next,
                 pc_current);
    end

endmodule