`timescale 1ns / 1ps

module Decode_Stage(
    input clk,reset,RegWriteW,
    input [4:0] RdW,                                                          
    input [31:0] InstrD, ResultW, 
    output  RegWriteD, ALUSrcBD, MemWriteD, JumpD, JumpRD, BranchD,
    output [2:0] funct3D,
    output  [1:0] ALUSrcAD,
    output  [3:0] ALUControlD,
    output  [1:0] ResultSrcD,
    output  [4:0] Rs1D, Rs2D, RdD,
    output [31:0] RD1D, RD2D, ImmExtD
    );
   
   
    assign Rs1D = InstrD[19:15];
    assign Rs2D = InstrD[24:20];
    assign RdD  =  InstrD[11:7];

    
     wire [2:0] ImmSrc;
                        
    Control_Unit u_Control_Unit (
        .func3     (InstrD[14:12]),
        .func7_5   (InstrD[30]),
        .OPcode    (InstrD[6:0]),
        .RegWrite  (RegWriteD),
        .ALUSrcB   (ALUSrcBD),
        .MemWrite  (MemWriteD),
        .Jump      (JumpD),
        .JumpR     (JumpRD),
        .Branch    (BranchD),
        .funct3    (funct3D),
        .ALUSrcA   (ALUSrcAD),
        .ImmSrc    (ImmSrc),
        .ALUControl(ALUControlD),
        .ResultSrc (ResultSrcD)
    );
    
     Register_File u_Register_File (
        .clk      (clk),
        .RegWrite (RegWriteW),
        .rst      (reset),
        .R1       (InstrD[19:15]),
        .R2       (InstrD[24:20]),
        .RD       (RdW),
        .WriteD   (ResultW),
        .RD1      (RD1D),
        .RD2      (RD2D)
    );
    
    ImmSignExtend u_ImmSignExtend (
        .instr   (InstrD[31:0]),
        .ImmSrc  (ImmSrc),
        .ImmExt  (ImmExtD)
    );
endmodule
