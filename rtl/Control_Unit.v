`timescale 1ns / 1ps
`include "defines.vh"

module Control_Unit(
    input func7_5,
    input [2:0] func3,
    input [6:0] OPcode,
    output  RegWrite,ALUSrcB,MemWrite,Jump,JumpR,Branch,
    output [2:0] funct3,
    output reg [1:0] ALUSrcA,
    output  reg [2:0] ImmSrc,
    output  reg [3:0] ALUControl,
    output  reg [1:0] ResultSrc
    );

    wire ALUOpADD;
     
    assign JumpR =  (OPcode == `JALR);
    assign Jump = (OPcode == `JAL);
    assign Branch = (OPcode == `BRANCH);
    assign ALUOpADD = (OPcode == `LOAD || OPcode == `STORE || OPcode == `AUIPC);
    assign RegWrite= (OPcode != `STORE && OPcode != `BRANCH);
    assign ALUSrcB =(OPcode != `RTYPE && OPcode != `BRANCH);
    assign MemWrite = (OPcode == `STORE); 
    assign funct3 = func3;
    
   always @* begin  
   
    ImmSrc   = `IMM_I;
    ResultSrc = `RESULTSRC_ALU;
    ALUSrcA   = `ALUSRCA_REG; 

    case (OPcode)
       `RTYPE, `ITYPE: ; // Handled entirely by defaults
        `LOAD: ResultSrc = `RESULTSRC_LOAD; 

        `STORE: ImmSrc = `IMM_S; 
        `BRANCH: ImmSrc = `IMM_B; 

        `LUI: begin
            ImmSrc   = `IMM_U;
            ALUSrcA  = `ALUSRCA_ZERO;
        end

        `AUIPC: begin
            ImmSrc   = `IMM_U;
            ALUSrcA  = `ALUSRCA_PC; 
        end
        
        `JAL: begin
            ImmSrc   = `IMM_J;
            ResultSrc = `RESULTSRC_PCPLUS4; 
        end

        `JALR: ResultSrc = `RESULTSRC_PCPLUS4;

    endcase
end

        
    //ALU Decoder Logic 
    
    wire funct7_rtype_bit;      // funct7[5] valid only for R-type instructions
    wire funct7_shift_imm_bit;  // funct7[5] valid only for SRLI/SRAI
    wire alu_func7_bit;         // Unified funct7[5] bit used by ALU decoder 
    
    
   assign funct7_rtype_bit =(OPcode == `RTYPE)? func7_5 : 1'b0;
   assign funct7_shift_imm_bit = (OPcode == `ITYPE && func3 == `F3_SRL_SRA)? func7_5 : 1'b0;
   assign alu_func7_bit =funct7_rtype_bit | funct7_shift_imm_bit; // For all instructions except R-type and SRLI/SRAI this signal is forced LOW

    always@* begin 
      ALUControl = `ALU_ADD;
     if(ALUOpADD)
       ALUControl=`ALU_ADD;   //ADD FOR AUIPC,S,I-LOAD
       else if (OPcode == `BRANCH) begin
            ALUControl = `ALU_SUB;
        end
       else begin
      case ({alu_func7_bit, func3})
      
    {1'b0, `F3_ADD_SUB} : ALUControl = `ALU_ADD;
    {1'b1, `F3_ADD_SUB} : ALUControl = `ALU_SUB;
    {1'b0, `F3_AND}     : ALUControl = `ALU_AND;
    {1'b0, `F3_OR}      : ALUControl = `ALU_OR;
    {1'b0, `F3_XOR}     : ALUControl = `ALU_XOR;
    {1'b0, `F3_SLL}     : ALUControl = `ALU_SLL;
    {1'b0, `F3_SRL_SRA} : ALUControl = `ALU_SRL;
    {1'b1, `F3_SRL_SRA} : ALUControl = `ALU_SRA;
    {1'b0, `F3_SLT}     : ALUControl = `ALU_SLT;
    {1'b0, `F3_SLTU}    : ALUControl = `ALU_SLTU;   
    endcase
    end
    
    end
endmodule