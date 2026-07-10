`timescale 1ns / 1ps

module Reg_mem_wb(
    input clk, rst, RegWriteM,
    input  [1:0]  ResultSrcM,
    input  [31:0] ALUResultM, LoadDataM, PCPlus4M,
    input  [4:0]  RdM,
    output reg RegWriteW,
    output reg [1:0]  ResultSrcW,
    output reg [31:0] ALUResultW, LoadDataW, PCPlus4W,
    output reg [4:0]  RdW
);

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      RegWriteW   <= 1'b0;
      ResultSrcW  <= 2'b00;
      ALUResultW  <= 32'b0;
      LoadDataW   <= 32'b0;
      PCPlus4W    <= 32'b0;
      RdW         <= 5'b0;
    end
    else begin
      RegWriteW   <= RegWriteM;
      ResultSrcW  <= ResultSrcM;
      ALUResultW  <= ALUResultM;
      LoadDataW   <= LoadDataM;
      PCPlus4W    <= PCPlus4M;
      RdW         <= RdM;
    end
  end

endmodule
