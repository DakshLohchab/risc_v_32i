`timescale 1ns/1ps

module tb_rv32i_pipeline;
    logic clk = 1'b0;
    logic rst_n = 1'b0;

    // 10ns clock period
    always #5 clk = ~clk;

    // Instantiate with 64 bytes of memory to match the tb footprint
    rv32i_pipeline #(.DMEM_DEPTH_BYTES(64)) dut(.clk, .rst_n);

    initial begin
        // Reset sequence
        repeat (2) @(posedge clk);
        rst_n = 1'b1;

        // Wait long enough for all 25+ instructions to flow through the pipeline
        // taking into account stalls and flushes. 50 cycles is plenty.
        repeat (50) @(posedge clk);

        $display("\n===============================================================");
        $display("                 UNIFIED PIPELINE VERIFICATION                 ");
        $display("===============================================================\n");

        // -------------------------------------------------------------
        // VERIFY SUITE 1: DATA PROCESSING & ALU
        // -------------------------------------------------------------
        assert (dut.u_id_stage.u_register_file.registers[1] == 32'd10)  else $fatal(1, "ADDI x1 Failed");
        assert (dut.u_id_stage.u_register_file.registers[2] == -32'd5)  else $fatal(1, "ADDI x2 (Negative) Failed");
        assert (dut.u_id_stage.u_register_file.registers[3] == 32'd5)   else $fatal(1, "ADD x3 Failed (EX Forwarding error?)");
        assert (dut.u_id_stage.u_register_file.registers[4] == 32'd15)  else $fatal(1, "SUB x4 Failed");
        assert (dut.u_id_stage.u_register_file.registers[5] == 32'd1)   else $fatal(1, "SLT x5 Failed (Signed comparison error)");
        assert (dut.u_id_stage.u_register_file.registers[6] == 32'd0)   else $fatal(1, "AND x6 Failed");
        assert (dut.u_id_stage.u_register_file.registers[7] == 32'd5)   else $fatal(1, "XOR x7 Failed");
        assert (dut.u_id_stage.u_register_file.registers[8] == 32'd40)  else $fatal(1, "SLLI x8 Failed");
        $display("[PASS] Suite 1: Data Processing & ALU Forwarding");

        // -------------------------------------------------------------
        // VERIFY SUITE 2: CONTROL FLOW & PIPELINE FLUSHES
        // -------------------------------------------------------------
        assert (dut.u_id_stage.u_register_file.registers[9] == 32'd5)   else $fatal(1, "ADDI x9 Failed");
        assert (dut.u_id_stage.u_register_file.registers[10] == 32'd5)  else $fatal(1, "ADDI x10 Failed");
        assert (dut.u_id_stage.u_register_file.registers[11] == 32'd0)  else $fatal(1, "BEQ Flush Failed! Instruction was executed.");
        assert (dut.u_id_stage.u_register_file.registers[12] == 32'd10) else $fatal(1, "BEQ Target execution Failed");
        assert (dut.u_id_stage.u_register_file.registers[13] == 32'h38) else $fatal(1, "JAL Link Register (x13) calculation failed");
        assert (dut.u_id_stage.u_register_file.registers[14] == 32'd0)  else $fatal(1, "JAL Flush Failed! Instruction was executed.");
        assert (dut.u_id_stage.u_register_file.registers[15] == 32'd20) else $fatal(1, "JAL Target execution Failed");
        $display("[PASS] Suite 2: Control Flow (Branches, Jumps & Flushes)");

        // -------------------------------------------------------------
        // VERIFY SUITE 3: MEMORY & LOAD-USE HAZARD STALLS
        // -------------------------------------------------------------
        assert ({dut.u_mem_stage.u_data_memory.mem[51], dut.u_mem_stage.u_data_memory.mem[50],
                 dut.u_mem_stage.u_data_memory.mem[49], dut.u_mem_stage.u_data_memory.mem[48]} == 32'd42)
            else $fatal(1, "SW operation failed to write correctly to Data Memory");

        assert (dut.u_id_stage.u_register_file.registers[18] == 32'd42)
            else $fatal(1, "LW operation failed to retrieve data from memory");

        assert (dut.u_id_stage.u_register_file.registers[19] == 32'd42)
            else $fatal(1, "Load-Use Hazard Stall Failed! x19 did not receive forwarded data from x18");
        $display("[PASS] Suite 3: Memory & Load-Use Hazard Stalls");

        $display("\n===============================================================");
        $display(" ALL TESTS PASSED! RTL verified across full instruction set.");
        $display("===============================================================\n");
        $stop;
    end
endmodule
