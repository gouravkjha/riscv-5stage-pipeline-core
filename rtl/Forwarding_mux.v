`timescale 1ns / 1ps
`include "defines.vh"
module Forwarding_mux(
    input [1:0] ForwardE,
    input [31:0] ResultW,ALUResultM,RDE,
    output reg [31:0] OutE 
    );
    
    always@* begin 
      OutE = RDE;
     case(ForwardE)
     `FORWARD_NONE:OutE = RDE;
     `FORWARD_WB: OutE  =  ResultW;
     `FORWARD_MEM: OutE = ALUResultM;
      endcase
    end
endmodule
