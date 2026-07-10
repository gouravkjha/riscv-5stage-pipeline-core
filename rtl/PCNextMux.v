`timescale 1ns / 1ps
`include "defines.vh"

module PCNextMux(
    input [1:0] PCSrc,
    input [31:0] PCPlus4,PCTarget,JALRTarget,
    output reg [31:0] PCNext
    );
   
    always @* begin
       PCNext=PCPlus4;
    case (PCSrc)
    `PCSRC_PLUS4 : PCNext = PCPlus4;
    `PCSRC_TARGET: PCNext = PCTarget;
    `PCSRC_JALR  : PCNext = JALRTarget;   //top module me logic lagna h
endcase
end
    
endmodule
