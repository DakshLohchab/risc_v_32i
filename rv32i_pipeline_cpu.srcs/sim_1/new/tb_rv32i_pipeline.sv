`timescale 1ns/1ps

module tb_rv32i_pipeline;
    logic clk = 1'b0;
    logic rst_n = 1'b0;
    
    always #5 clk = ~clk; // 10ns clock period

    rv32i_pipeline #(.DMEM_DEPTH_BYTES(64)) dut(.clk, .rst_n);

    always_ff @(posedge clk) begin
        if (dut.u_ex_stage.alu_ctrl == 4'b0101) begin
            $display("[DBG] SLT EX: rs1=%0d rs2=%0d alu=%0h rd=%0d",
                     dut.u_ex_stage.rs1E, dut.u_ex_stage.rs2E, dut.aluResultE, dut.rdE);
        end
        if (dut.u_ex_stage.opcodeE == 7'b1100111) begin
            $display("[DBG] JALR EX: rs1=%0d rd=%0d pcPlus4=%0h pcTarget=%0h",
                     dut.u_ex_stage.rs1E, dut.rdE, dut.u_ex_stage.pcPlus4E, dut.u_ex_stage.pcTargetE);
        end
    end

    initial begin
        // Reset sequence
        repeat (2) @(posedge clk);
        rst_n = 1'b1;
        
        // Wait long enough for the instructions to flow through the full pipeline
        // and for the writeback stage to observe the final values.
        repeat (60) @(posedge clk);

        $display("x1=%0h x2=%0h x4=%0h x5=%0h x6=%0h x7=%0h x8=%0h", 
                 dut.u_id_stage.u_register_file.registers[1],
                 dut.u_id_stage.u_register_file.registers[2],
                 dut.u_id_stage.u_register_file.registers[4],
                 dut.u_id_stage.u_register_file.registers[5],
                 dut.u_id_stage.u_register_file.registers[6],
                 dut.u_id_stage.u_register_file.registers[7],
                 dut.u_id_stage.u_register_file.registers[8]);

        // 1. Check U-Type instructions (LUI & AUIPC)
        assert (dut.u_id_stage.u_register_file.registers[1] == 32'h12345000)
            else $fatal(1, "LUI x1 failed");
        assert (dut.u_id_stage.u_register_file.registers[2] == 32'h00001004)
            else $fatal(1, "AUIPC x2 failed (Should be PC(0x04) + 0x1000)");

        // 2. Check Shifts (SLLI & SRAI)
        assert (dut.u_id_stage.u_register_file.registers[4] == 32'hFFFFFFF0)
            else $fatal(1, "SLLI x4 failed");
        assert (dut.u_id_stage.u_register_file.registers[5] == 32'hFFFFFFFC)
            else $fatal(1, "SRAI x5 failed (Did it maintain the negative sign bit?)");

        // 3. Check Comparison (SLT)
        assert (dut.u_id_stage.u_register_file.registers[6] == 32'd1)
            else $fatal(1, "SLT x6 failed (-4 is less than 0, should be 1)");

        // 4. Check Jump and Link Register (JALR)
        assert (dut.u_id_stage.u_register_file.registers[7] == 32'h0000001C)
            else $fatal(1, "JALR x7 failed (Return address incorrect)");
        assert (dut.u_id_stage.u_register_file.registers[8] == 32'd0)
            else $fatal(1, "JALR jump failed (It executed the skipped instructions!)");

        // 5. Check Little-Endian Memory Stores
        assert ({dut.u_mem_stage.u_data_memory.mem[15], dut.u_mem_stage.u_data_memory.mem[14],
                 dut.u_mem_stage.u_data_memory.mem[13], dut.u_mem_stage.u_data_memory.mem[12]} == 32'd1)
            else $fatal(1, "SW to memory address 12 failed");
            
        assert ({dut.u_mem_stage.u_data_memory.mem[19], dut.u_mem_stage.u_data_memory.mem[18],
                 dut.u_mem_stage.u_data_memory.mem[17], dut.u_mem_stage.u_data_memory.mem[16]} == 32'h0000001C)
            else $fatal(1, "SW to memory address 16 failed");

        $display("===============================================================");
        $display("PASS: Architecture successfully handled LUI, AUIPC, Shifts, and JALR!");
        $display("===============================================================");
        $stop;
    end
endmodule