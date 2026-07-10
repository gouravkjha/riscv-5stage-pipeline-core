`timescale 1ns / 1ps

module Writeback_Stage(
   input  [1:0] ResultSrcW,
   input [31:0] LoadDataW, PCPlus4W, ALUResultW,
   output [31:0] ResultW
    );
    
     ResultSrcMux u_ResultSrcMux (
        .ResultSrc (ResultSrcW),
        .ALUResult (ALUResultW),
        .LoadData  (LoadDataW),
        .PCPlus4   (PCPlus4W),
        .Result    (ResultW)
    );
    
endmodule
