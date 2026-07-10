`timescale 1ns / 1ps
`include "defines.vh"

module Hazard_Unit(
    input [4:0] Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW,
    input [1:0] PCSrc, ResultSrcE,
    input  RegWriteM, RegWriteW,
    output StallF, StallD, FlushD, FlushE, 
    output [1:0] ForwardAE, ForwardBE
    );
    
    wire LwStall;
    
    assign ForwardAE = (Rs1E == RdM && RegWriteM) && (Rs1E!=0)? `FORWARD_MEM :
                       (Rs1E == RdW && RegWriteW) && (Rs1E!=0)?`FORWARD_WB:`FORWARD_NONE;
                       
    assign ForwardBE = (Rs2E == RdM && RegWriteM) && (Rs2E!=0)? `FORWARD_MEM :
                       (Rs2E == RdW && RegWriteW) && (Rs2E!=0)?`FORWARD_WB:`FORWARD_NONE;
                       
    assign LwStall   = ((Rs1D == RdE && Rs1D != 5'b0) || (Rs2D == RdE && Rs2D != 5'b0)) && (ResultSrcE == `RESULTSRC_LOAD);
     assign StallF = LwStall;
     assign StallD = LwStall;
     
     // Flush if we are taking ANY jump or branch (PCSrc is not PC+4)
     assign FlushE = ( LwStall || PCSrc != `PCSRC_PLUS4 );
     assign FlushD = ( PCSrc != `PCSRC_PLUS4 );
    
endmodule
