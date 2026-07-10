`timescale 1ns / 1ps
`include "defines.vh"

module ALUSrcAMux(
    input [1:0] ALUSrcA,
    input [31:0] PC,RD1,
    output reg [31:0] SrcA
    );

  always @* begin
    SrcA = RD1; 
    case (ALUSrcA)
        `ALUSRCA_REG:  SrcA = RD1;   
        `ALUSRCA_PC:   SrcA = PC;   
        `ALUSRCA_ZERO: SrcA = 32'b0; 
    endcase
end
endmodule
