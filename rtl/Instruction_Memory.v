`timescale 1ns / 1ps

module Instruction_Memory(
    input [31:0] PC,
    output [31:0] Instr
    );
    
   reg [31:0] mem [0:4095];
   
assign Instr = mem[PC[13:2]]; 

    
endmodule
