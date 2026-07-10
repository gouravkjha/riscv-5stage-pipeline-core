`timescale 1ns / 1ps

module Execute_Stage(
  input JumpE,JumpRE,BranchE,ALUSrcBE,
  input [2:0] funct3E,
  input [3:0] ALUControlE,
  input [1:0] ALUSrcAE, ForwardAE, ForwardBE,
  input [31:0] PCE, ImmExtE, RD1E, RD2E, ALUResultM, ResultW,
  output [31:0] PCTargetE, ALUResultE, WDataE,
  output [1:0] PCSrcE
    );
    
    wire [31:0] SrcA, SrcB, ForwardA, ForwardB;
    wire zero,less_than_signed,less_than_unsigned;
    
    assign WDataE = ForwardB; 
    
    PCSrc_Evaluator u_PCSrc_Evaluator (
        .JumpE               (JumpE),
        .JumpRE              (JumpRE),
        .BranchE             (BranchE),
        .zeroE               (zero),
        .less_than_signedE   (less_than_signed),
        .less_than_unsignedE (less_than_unsigned),
        .func3E              (funct3E),
        .PCSrc               (PCSrcE)
    );
    
    ALU u_ALU (
        .ALUControl        (ALUControlE),
        .A                 (SrcA),
        .B                 (SrcB),
        .ALUResult         (ALUResultE),
        .zero              (zero),
        .less_than_signed  (less_than_signed),
        .less_than_unsigned(less_than_unsigned)
    );
    
    PCAdder u_PCAdder (
        .PC       (PCE),
        .ImmExt   (ImmExtE),
        .PCTarget (PCTargetE)
    );
    
     ALUSrcAMux u_ALUSrcAMux (
        .ALUSrcA (ALUSrcAE),
        .PC      (PCE),
        .RD1     (ForwardA),
        .SrcA    (SrcA)
    );
    
    ALUSrcBMux u_ALUSrcBMux (
        .ALUSrcB (ALUSrcBE),
        .RD2     (ForwardB),
        .ImmExt  (ImmExtE),
        .SrcB    (SrcB)
    );
    
    Forwarding_mux uA_Forwarding_mux (
        .ForwardE  (ForwardAE),
        .ResultW   (ResultW),
        .ALUResultM(ALUResultM),
        .RDE       (RD1E),
        .OutE      (ForwardA)
    );
    
    Forwarding_mux uB_Forwarding_mux (
        .ForwardE  (ForwardBE),
        .ResultW   (ResultW),
        .ALUResultM(ALUResultM),
        .RDE       (RD2E),
        .OutE      (ForwardB)
    );

endmodule
