`timescale 1ns / 1ps

module Reg_id_ex(
    input clk, rst, FlushE,
    input  [31:0] RD1D, RD2D, PCPlus4D, PCD, ImmExtD,
    input  [4:0] Rs1D, Rs2D, RdD,
    input  [2:0] funct3D,
    input  RegWriteD, ALUSrcBD, MemWriteD, JumpD, JumpRD, BranchD,
    input  [3:0]  ALUControlD,
    input  [1:0]  ResultSrcD, ALUSrcAD,
    output reg [31:0] RD1E, RD2E, PCPlus4E, PCE, ImmExtE,
    output reg [4:0]  Rs1E, Rs2E, RdE,
    output reg [2:0]  funct3E,
    output reg RegWriteE, ALUSrcBE, MemWriteE, JumpE, JumpRE, BranchE,
    output reg [3:0]  ALUControlE,
    output reg [1:0]  ResultSrcE, ALUSrcAE
);

  
  always @(posedge clk or posedge rst) begin
    if (rst) begin
        RD1E        <= 32'b0;
        RD2E        <= 32'b0;
        PCPlus4E    <= 32'b0;
        PCE         <= 32'b0;
        ImmExtE     <= 32'b0;
        Rs1E        <= 5'b0;
        Rs2E        <= 5'b0;
        RdE         <= 5'b0;

        RegWriteE   <= 1'b0;
        ALUSrcBE    <= 1'b0;
        MemWriteE   <= 1'b0;
        ALUSrcAE    <= 1'b0;
        JumpE       <= 1'b0;
        JumpRE      <= 1'b0;
        BranchE     <= 1'b0;

        ALUControlE <= 4'b0;
        ResultSrcE  <= 2'b0;
        funct3E     <= 3'b0;
    end
    else begin
        if (FlushE) begin
            RD1E        <= 32'b0;
            RD2E        <= 32'b0;
            PCPlus4E    <= 32'b0;
            PCE         <= 32'b0;
            ImmExtE     <= 32'b0;
            Rs1E        <= 5'b0;
            Rs2E        <= 5'b0;
            RdE         <= 5'b0;

            RegWriteE   <= 1'b0;
            ALUSrcBE    <= 1'b0;
            MemWriteE   <= 1'b0;
            ALUSrcAE    <= 1'b0;
            JumpE       <= 1'b0;
            JumpRE      <= 1'b0;
            BranchE     <= 1'b0;

            ALUControlE <= 4'b0;
            ResultSrcE  <= 2'b0;
            funct3E     <= 3'b0;
        end
        else begin
            RD1E        <= RD1D;
            RD2E        <= RD2D;
            PCPlus4E    <= PCPlus4D;
            PCE         <= PCD;
            ImmExtE     <= ImmExtD;
            Rs1E        <= Rs1D;
            Rs2E        <= Rs2D;
            RdE         <= RdD;

            RegWriteE   <= RegWriteD;
            ALUSrcBE    <= ALUSrcBD;
            MemWriteE   <= MemWriteD;
            ALUSrcAE    <= ALUSrcAD;
            JumpE       <= JumpD;
            JumpRE      <= JumpRD;
            BranchE     <= BranchD;
            
            ALUControlE <= ALUControlD;
            ResultSrcE  <= ResultSrcD;
            funct3E     <= funct3D;
        end
    end
  end

endmodule
