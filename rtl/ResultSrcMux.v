`timescale 1ns / 1ps
`include "defines.vh"

module ResultSrcMux (
    input  [1:0]  ResultSrc,   
    input  [31:0] ALUResult,LoadData,PCPlus4, 
    output reg [31:0] Result   
);
    always @* begin
      Result = ALUResult;
       case (ResultSrc)
    `RESULTSRC_ALU     : Result = ALUResult;
    `RESULTSRC_LOAD    : Result = LoadData;
    `RESULTSRC_PCPLUS4 : Result = PCPlus4;
endcase
        
    end
endmodule
