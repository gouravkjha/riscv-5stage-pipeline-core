`timescale 1ns / 1ps

module RV32I_Core(
    input clk, reset
);
    
    // 1. Fetch Stage Wires

    wire        StallF;
    wire [1:0]  PCSrcE;
    wire [31:0] PCTargetE;
    wire [31:0] ALUResultE;
    wire [31:0] InstrF;
    wire [31:0] PCPlus4F;
    wire [31:0] PCF;

    Fetch_Stage u_Fetch_Stage (       
        .clk       (clk),
        .reset     (reset),
        .StallF    (StallF),
        .PCSrcE    (PCSrcE),
        .PCTargetE (PCTargetE),
        .ALUResultE(ALUResultE),
        .InstrF    (InstrF),
        .PCPlus4F  (PCPlus4F),
        .PCF       (PCF)
    );
    
    
    // 2. IF/ID Pipeline Register Wires
    
    wire        StallD;
    wire        FlushD;
    wire [31:0] InstrD;
    wire [31:0] PCPlus4D;
    wire [31:0] PCD;

    Reg_if_id u_Reg_if_id (      
        .clk       (clk),
        .rst       (reset),
        .StallD    (StallD),
        .FlushD    (FlushD),
        .InstrF    (InstrF),
        .PCPlus4F  (PCPlus4F),
        .PCF       (PCF),
        .InstrD    (InstrD),
        .PCPlus4D  (PCPlus4D),
        .PCD       (PCD)
    );
    
   
    // 3. Decode Stage Wires

    wire        RegWriteW;
    wire [4:0]  RdW;
    wire [31:0] ResultW;

    wire        RegWriteD;
    wire        ALUSrcBD;
    wire        MemWriteD;
    wire        JumpD;
    wire        JumpRD;
    wire        BranchD;
    wire [2:0]  funct3D;
    wire [1:0]  ALUSrcAD;
    wire [3:0]  ALUControlD;
    wire [1:0]  ResultSrcD;
    wire [4:0]  Rs1D;
    wire [4:0]  Rs2D;
    wire [4:0]  RdD;
    wire [31:0] RD1D;
    wire [31:0] RD2D;
    wire [31:0] ImmExtD;

    Decode_Stage u_Decode_Stage (     
        .clk        (clk),
        .reset      (reset),
        .RegWriteW  (RegWriteW),
        .RdW        (RdW),
        .InstrD     (InstrD),
        .ResultW    (ResultW),

        .RegWriteD  (RegWriteD),
        .ALUSrcBD   (ALUSrcBD),
        .MemWriteD  (MemWriteD),
        .JumpD      (JumpD),
        .JumpRD     (JumpRD),
        .BranchD    (BranchD),
        .funct3D    (funct3D),
        .ALUSrcAD   (ALUSrcAD),
        .ALUControlD(ALUControlD),
        .ResultSrcD (ResultSrcD),
        .Rs1D       (Rs1D),
        .Rs2D       (Rs2D),
        .RdD        (RdD),
        .RD1D       (RD1D),
        .RD2D       (RD2D),
        .ImmExtD    (ImmExtD)
    );

    
    // 4. ID/EX Pipeline Register Wires
    
    wire        FlushE;
    wire [31:0] RD1E;
    wire [31:0] RD2E;
    wire [31:0] PCPlus4E;
    wire [31:0] PCE;
    wire [31:0] ImmExtE;
    wire [4:0]  Rs1E;
    wire [4:0]  Rs2E;
    wire [4:0]  RdE;
    wire [2:0]  funct3E;
    wire        RegWriteE;
    wire        ALUSrcBE;
    wire        MemWriteE;
    wire  [1:0]  ALUSrcAE;
    wire        JumpE;
    wire        JumpRE;
    wire        BranchE;
    wire [3:0]  ALUControlE;
    wire [1:0]  ResultSrcE;

    Reg_id_ex u_Reg_id_ex (       
        .clk        (clk),
        .rst        (reset),     
        .FlushE     (FlushE),
        .RD1D       (RD1D),
        .RD2D       (RD2D),
        .PCPlus4D   (PCPlus4D),
        .PCD        (PCD),
        .ImmExtD    (ImmExtD),
        .Rs1D       (Rs1D),
        .Rs2D       (Rs2D),
        .RdD        (RdD),
        .funct3D    (funct3D),
        .RegWriteD  (RegWriteD),
        .ALUSrcBD   (ALUSrcBD),
        .MemWriteD  (MemWriteD),
        .ALUSrcAD   (ALUSrcAD),
        .JumpD      (JumpD),
        .JumpRD     (JumpRD),
        .BranchD    (BranchD),
        .ALUControlD(ALUControlD),
        .ResultSrcD (ResultSrcD),

        .RD1E       (RD1E),
        .RD2E       (RD2E),
        .PCPlus4E   (PCPlus4E),
        .PCE        (PCE),
        .ImmExtE    (ImmExtE),
        .Rs1E       (Rs1E),
        .Rs2E       (Rs2E),
        .RdE        (RdE),
        .funct3E    (funct3E),
        .RegWriteE  (RegWriteE),
        .ALUSrcBE   (ALUSrcBE),
        .MemWriteE  (MemWriteE),
        .ALUSrcAE   (ALUSrcAE),
        .JumpE      (JumpE),
        .JumpRE     (JumpRE),
        .BranchE    (BranchE),
        .ALUControlE(ALUControlE),
        .ResultSrcE (ResultSrcE)
    );
    
    
    // 5. Execute Stage Wires
   
    wire [1:0]  ForwardAE;
    wire [1:0]  ForwardBE;
    wire [31:0] ALUResultM;
    wire [31:0] WDataE;

    Execute_Stage u_Execute_Stage (      
        .JumpE      (JumpE),
        .JumpRE     (JumpRE),
        .BranchE    (BranchE),
        .ALUSrcBE   (ALUSrcBE),
        .funct3E    (funct3E),
        .ALUControlE(ALUControlE),
        .ALUSrcAE   (ALUSrcAE),
        .ForwardAE  (ForwardAE),
        .ForwardBE  (ForwardBE),
        .PCE        (PCE),
        .ImmExtE    (ImmExtE),
        .RD1E       (RD1E),
        .RD2E       (RD2E),
        .ALUResultM (ALUResultM),
        .ResultW    (ResultW),

        .PCTargetE  (PCTargetE),
        .ALUResultE (ALUResultE),
        .WDataE     (WDataE),
        .PCSrcE     (PCSrcE)
    );

    
    // 6. EX/MEM Pipeline Register Wires
    
    wire        RegWriteM;
    wire        MemWriteM;
    wire [1:0]  ResultSrcM;
    wire [31:0] PCPlus4M;
    wire [31:0] WDataM;
    wire [4:0]  RdM;
    wire [2:0]  funct3M; 

    Reg_ex_mem u_Reg_ex_mem (     
        .clk        (clk),
        .rst        (reset),     
        .RegWriteE  (RegWriteE),
        .MemWriteE  (MemWriteE),
        .ResultSrcE (ResultSrcE),
        .ALUResultE (ALUResultE),
        .PCPlus4E   (PCPlus4E),
        .WDataE     (WDataE),
        .RdE        (RdE),
        .funct3E    (funct3E),  

        .RegWriteM  (RegWriteM),
        .MemWriteM  (MemWriteM),
        .ResultSrcM (ResultSrcM),
        .ALUResultM (ALUResultM),
        .PCPlus4M   (PCPlus4M),
        .WDataM     (WDataM),
        .RdM        (RdM),
        .funct3M    (funct3M)    
    );
    
    
    // 7. Memory Stage Wires
    
    wire [31:0] LoadDataM;

    Memory_Stage u_Memory_Stage (      
        .clk        (clk),
        .MemWriteM  (MemWriteM),
        .funct3M    (funct3M),
        .ALUResultM (ALUResultM),
        .WDataM     (WDataM),
        .LoadDataM  (LoadDataM)
    );
    
    
    // 8. MEM/WB Pipeline Register Wires
    
    wire [1:0]  ResultSrcW;
    wire [31:0] ALUResultW;
    wire [31:0] LoadDataW;
    wire [31:0] PCPlus4W;

    Reg_mem_wb u_Reg_mem_wb (
        .clk        (clk),
        .rst        (reset),     
        .RegWriteM  (RegWriteM),
        .ResultSrcM (ResultSrcM),
        .ALUResultM (ALUResultM),
        .LoadDataM  (LoadDataM),
        .PCPlus4M   (PCPlus4M),
        .RdM        (RdM),

        .RegWriteW  (RegWriteW),
        .ResultSrcW (ResultSrcW),
        .ALUResultW (ALUResultW),
        .LoadDataW  (LoadDataW),
        .PCPlus4W   (PCPlus4W),
        .RdW        (RdW)
    );

    
    // 9. Writeback Stage Wires
   
    Writeback_Stage u_Writeback_Stage (
        .ResultSrcW (ResultSrcW),
        .LoadDataW  (LoadDataW),
        .PCPlus4W   (PCPlus4W),
        .ALUResultW (ALUResultW),
        .ResultW    (ResultW)
    );
    
    
    // 10. Hazard Unit 


    Hazard_Unit u_Hazard_Unit (
        .Rs1D       (Rs1D),
        .Rs2D       (Rs2D),
        .Rs1E       (Rs1E),
        .Rs2E       (Rs2E),
        .RdE        (RdE),
        .RdM        (RdM),
        .RdW        (RdW),
        .PCSrc      (PCSrcE),    
        .ResultSrcE (ResultSrcE),
        .RegWriteM  (RegWriteM),
        .RegWriteW  (RegWriteW),

        .StallF     (StallF),
        .StallD     (StallD),
        .FlushD     (FlushD),
        .FlushE     (FlushE),
        .ForwardAE  (ForwardAE),
        .ForwardBE  (ForwardBE)
    );
    
endmodule