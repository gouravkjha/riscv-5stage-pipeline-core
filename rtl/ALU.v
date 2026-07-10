`timescale 1ns / 1ps
`include "defines.vh"

module ALU(
    input  [3:0]  ALUControl,
    input  [31:0] A,
    input  [31:0] B,
    output reg [31:0] ALUResult,
    output  zero,less_than_signed,less_than_unsigned
    );

    assign zero = (ALUResult == 32'b0);    //BEQ= zero and BNE = !zero
    assign less_than_signed = ($signed(A) < $signed(B));
    assign less_than_unsigned = (A < B);

    always @* begin
      ALUResult = A + B;
        case (ALUControl)
            `ALU_ADD:  ALUResult = A + B;
            `ALU_SUB:  ALUResult = A - B;
            `ALU_AND:  ALUResult = A & B;
            `ALU_OR :  ALUResult = A | B;
            `ALU_XOR:  ALUResult = A ^ B;
            `ALU_SLL:  ALUResult = A << B[4:0];
            `ALU_SRL:  ALUResult = A >> B[4:0];
            `ALU_SRA:  ALUResult = $signed(A) >>> B[4:0];
            `ALU_SLT:  ALUResult = {31'b0, less_than_signed};   
            `ALU_SLTU: ALUResult = {31'b0, less_than_unsigned};  
        endcase
    end

endmodule