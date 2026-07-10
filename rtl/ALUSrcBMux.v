`timescale 1ns / 1ps

module ALUSrcBMux(
    input ALUSrcB,
    input [31:0] RD2,ImmExt,
    output [31:0] SrcB
    );
    
    assign SrcB = (ALUSrcB)? ImmExt : RD2;
endmodule
