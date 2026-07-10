`timescale 1ns / 1ps
`include "defines.vh"

module ImmSignExtend(
    input [31:0] instr,
    input [2:0] ImmSrc,
    output reg [31:0] ImmExt
    );

    wire sign;
    assign sign = instr[31];
    
    always @* begin
    case (ImmSrc)
        `IMM_I: ImmExt = {{20{sign}}, instr[31:20]};
        `IMM_S: ImmExt = {{20{sign}}, instr[31:25], instr[11:7]};
        `IMM_B: ImmExt = {{20{sign}}, instr[7], instr[30:25], instr[11:8], 1'b0};
        `IMM_U: ImmExt = {instr[31:12], 12'b0};
        `IMM_J: ImmExt = {{12{sign}}, instr[19:12], instr[20], instr[30:21], 1'b0};
        default: ImmExt = {{20{sign}}, instr[31:20]};
    endcase
end
    
endmodule
