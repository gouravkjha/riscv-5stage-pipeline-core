`timescale 1ns / 1ps

module Memory_Stage(
   input clk, MemWriteM,
   input [2:0] funct3M,
   input  [31:0] ALUResultM, WDataM,
   output [31:0] LoadDataM
    );
    
    wire  [31:0] RD;
    
     Data_Memory u_Data_Memory (
        .clk     (clk),
        .MemWrite(MemWriteM),
        .funct3  (funct3M),
        .ALUAddr (ALUResultM),
        .WData   (WDataM),
        .RD      (RD)
    );
    
    Load_extend u_Load_extend (
        .func3     (funct3M),
        .ByteOffset(ALUResultM[1:0]),
        .RD        (RD),
        .LoadData  (LoadDataM)
    );
endmodule
