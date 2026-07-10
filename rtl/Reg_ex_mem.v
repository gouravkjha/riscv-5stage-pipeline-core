`timescale 1ns / 1ps

module Reg_ex_mem(
    input clk, rst, RegWriteE, MemWriteE,
    input  [1:0]  ResultSrcE,
    input  [2:0] funct3E,
    input  [31:0] ALUResultE, PCPlus4E, WDataE, 
    input  [4:0]  RdE,
    output reg RegWriteM,
    output reg MemWriteM,
    output reg [2:0] funct3M,
    output reg [1:0]  ResultSrcM,
    output reg [31:0] ALUResultM, PCPlus4M, WDataM,
    output reg [4:0]  RdM
);


  always @(posedge clk or posedge rst) begin
    if (rst) begin
      RegWriteM   <= 1'b0;
      MemWriteM   <= 1'b0;
      ResultSrcM  <= 2'b00;
      ALUResultM  <= 32'b0;
      PCPlus4M    <= 32'b0;
      WDataM      <= 32'b0;
      funct3M     <= 3'b0;
      RdM         <= 5'b0;
    end
    else begin
      RegWriteM   <= RegWriteE;
      MemWriteM   <= MemWriteE;
      ResultSrcM  <= ResultSrcE;
      ALUResultM  <= ALUResultE;
      PCPlus4M    <= PCPlus4E;
      WDataM      <= WDataE;
      funct3M     <= funct3E;
      RdM         <= RdE;
    end
  end

endmodule
