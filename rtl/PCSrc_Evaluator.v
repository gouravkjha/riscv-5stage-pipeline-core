`timescale 1ns / 1ps
`include "defines.vh"

module PCSrc_Evaluator(
    input JumpE, JumpRE, BranchE, zeroE, less_than_signedE, less_than_unsignedE,
    input [2:0] func3E,
    output reg [1:0] PCSrc
    );
   
   wire [1:0] Jmp;
   assign Jmp = {JumpRE,JumpE};
   
  always@*begin
   if(JumpRE | JumpE)
      PCSrc= Jmp;
      
      else if(BranchE) begin
         PCSrc = `PCSRC_PLUS4;
        case (func3E)
            `B_BEQ:  PCSrc = {1'b0,zeroE};
            `B_BNE:  PCSrc = {1'b0,~zeroE};
            `B_BLT:  PCSrc = {1'b0,less_than_signedE};
            `B_BGE:  PCSrc = {1'b0,~less_than_signedE};
            `B_BLTU: PCSrc = {1'b0,less_than_unsignedE};
            `B_BGEU: PCSrc = {1'b0,~less_than_unsignedE};
        endcase
    end
    
    else
      PCSrc = `PCSRC_PLUS4;
  end 

endmodule