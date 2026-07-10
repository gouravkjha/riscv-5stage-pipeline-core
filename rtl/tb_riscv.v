`timescale 1ns / 1ps

module tb_riscv;

    parameter MEM_FILE = "C:/Vivado_Projects/rv32i-5stage-pipeline/tests_hex/rv32ui-p-add.mem";

    reg clk = 0;
    reg reset;
    integer fd;

    // Clock and Core Instantiation
    always #2 clk = ~clk;
    RV32I_Core RV32I_Core_inst (.clk(clk), .reset(reset));

    // Memory Initialization & Reset Vector
    initial begin
        $readmemh(MEM_FILE, RV32I_Core_inst.u_Fetch_Stage.u_Instruction_Memory.mem);
        $readmemh(MEM_FILE, RV32I_Core_inst.u_Memory_Stage.u_Data_Memory.mem);
        reset = 1;
        #40;
        reset = 0;
    end

    // Direct Architectural Probes
    wire [31:0] gp     = RV32I_Core_inst.u_Decode_Stage.u_Register_File.regmem[3];
    wire [31:0] instrD = RV32I_Core_inst.InstrD;
    wire [31:0] instrF = RV32I_Core_inst.u_Fetch_Stage.InstrF;

    // Clean Execution Tracker
    always @(posedge clk) begin
        if (!reset) begin
            // Terminate instantly if ECALL is decoded OR sequential memory boundary is hit
            if ((instrD == 32'h00000073 && !RV32I_Core_inst.FlushD) || (^instrF === 1'bx)) begin
                repeat(3) @(posedge clk); // Allow final writeback write to clear
                
                fd = $fopen("status.txt", "w");
                if (gp == 32'd1) begin
                    $display("[PASS] %s", MEM_FILE);
                    $fdisplay(fd, "PASSED");
                end else begin
                    $display("[FAIL] %s | Subtest: %0d", MEM_FILE, gp >> 1);
                    $fdisplay(fd, "FAILED_%0d", gp >> 1);
                end
                $fclose(fd);
                $finish;
            end
        end
    end

endmodule