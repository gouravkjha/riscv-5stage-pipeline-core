`timescale 1ns / 1ps

module PC(
    input clk,
    input reset,
    input StallF,
    input [31:0] PCNext,
    output reg [31:0] PC
    );
    
    always@(posedge clk)begin
     if(reset)
       PC<=32'b0;
     else if(!StallF)
      PC<=PCNext;
    end
endmodule
