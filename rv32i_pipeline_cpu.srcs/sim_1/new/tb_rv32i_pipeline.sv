`timescale 1ns/1ps
// Advanced Integration test for the pipeline handling Hazards and Branches
module tb_rv32i_pipeline;
    logic clk = 1'b0;
    logic rst_n = 1'b0;
    
    always #5 clk = ~clk; // 10ns clock period

    rv32i_pipeline #(.DMEM_DEPTH_BYTES(64)) dut(.clk, .rst_n);

    initial begin
        // Reset sequence
        repeat (2) @(posedge clk);
        rst_n = 1'b1;
        
        // Wait enough cycles for the entire program to clear the pipeline
        repeat (25) @(posedge clk);

        // 1. Check basic arithmetic and Data Forwarding
        assert (dut.u_id_stage.u_register_file.registers[1] == 32'd5)
            else $fatal(1, "ADDI x1 failed");
        assert (dut.u_id_stage.u_register_file.registers[2] == 32'd10)
            else $fatal(1, "ADDI x2 failed");
        assert (dut.u_id_stage.u_register_file.registers[3] == 32'd15)
            else $fatal(1, "ADD x3 (Forwarding) failed");

        // 2. Check Load and Load-Use Stall resolution
        assert (dut.u_id_stage.u_register_file.registers[4] == 32'd15)
            else $fatal(1, "LW x4 failed");
        assert (dut.u_id_stage.u_register_file.registers[5] == 32'd20)
            else $fatal(1, "ADD x5 (Load-Use Stall) failed");

        // 3. Check Branching (x6 should be 99, not 1)
        assert (dut.u_id_stage.u_register_file.registers[6] == 32'd99)
            else $fatal(1, "Branch logic or pipeline flush failed (x6 incorrect)");

        // 4. Check Little-Endian Memory Stores
        assert ({dut.u_mem_stage.u_data_memory.mem[7], dut.u_mem_stage.u_data_memory.mem[6],
                 dut.u_mem_stage.u_data_memory.mem[5], dut.u_mem_stage.u_data_memory.mem[4]} == 32'd15)
            else $fatal(1, "SW to memory address 4 failed");
            
        assert ({dut.u_mem_stage.u_data_memory.mem[11], dut.u_mem_stage.u_data_memory.mem[10],
                 dut.u_mem_stage.u_data_memory.mem[9], dut.u_mem_stage.u_data_memory.mem[8]} == 32'd99)
            else $fatal(1, "SW to memory address 8 failed");

        $display("===============================================================");
        $display("PASS: Architecture successfully handled Forwarding, Stalls, and Branches!");
        $display("===============================================================");
        $stop;
    end
endmodule