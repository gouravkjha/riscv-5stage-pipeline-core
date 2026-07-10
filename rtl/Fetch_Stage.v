`timescale 1ns / 1ps

 module Fetch_Stage(
  input clk,reset,StallF,
  input [1:0] PCSrcE,
  input [31:0] PCTargetE,ALUResultE,
  output [31:0] InstrF, PCPlus4F, PCF 
    );
    
    wire [31:0] PCNext,JALRTarget;
    
    assign JALRTarget = {ALUResultE[31:1],1'b0};
    
    
    PCNextMux u_PCNextMux (
        .PCSrc     (PCSrcE),
        .PCPlus4   (PCPlus4F),
        .PCTarget  (PCTargetE),
        .JALRTarget(JALRTarget),
        .PCNext    (PCNext)
    );
       
    PC u_PC (
        .clk    (clk),
        .reset  (reset),
        .StallF (StallF),
        .PCNext (PCNext),
        .PC     (PCF)
    );
        
    PCPlus4 u_PCPlus4 (
        .PC      (PCF),
        .PCPlus4 (PCPlus4F)
    );
   
    Instruction_Memory u_Instruction_Memory (
        .PC    (PCF),
        .Instr (InstrF)
    );
endmodule
