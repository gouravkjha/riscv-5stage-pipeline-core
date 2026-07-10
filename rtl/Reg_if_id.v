`timescale 1ns / 1ps

module Reg_if_id(
    input clk, rst, StallD, FlushD,
    input  [31:0] InstrF, PCPlus4F, PCF,
    output reg [31:0] InstrD, PCPlus4D, PCD
);
    
    
    always@(posedge clk or posedge rst)begin
     if (rst) begin
        InstrD     <= 32'h00000013; 
        PCPlus4D   <= 32'b0;
        PCD        <= 32'b0;
    end
    else begin
        if (FlushD) begin
            InstrD   <= 32'h00000013; // Drop NOP on branch misprediction
            PCPlus4D <= 32'b0;
            PCD      <= 32'b0;
        end
      else if(!StallD)begin
        InstrD    <= InstrF;
        PCPlus4D  <= PCPlus4F;
        PCD       <= PCF;

       end
    end 
  end
endmodule

