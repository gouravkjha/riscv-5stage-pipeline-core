//=========================================================
// ALU Operation Encodings
// Used by ALU Decoder and ALU module.
//=========================================================

`define ALU_ADD   4'b0000   // Addition
`define ALU_SUB   4'b0001   // Subtraction
`define ALU_AND   4'b0010   // Bitwise AND
`define ALU_OR    4'b0011   // Bitwise OR
`define ALU_XOR   4'b0100   // Bitwise XOR
`define ALU_SLL   4'b0101   // Logical Left Shift
`define ALU_SRL   4'b0110   // Logical Right Shift
`define ALU_SRA   4'b0111   // Arithmetic Right Shift
`define ALU_SLT   4'b1000   // Signed Less-Than Comparison
`define ALU_SLTU  4'b1001   // Unsigned Less-Than Comparison

//=========================================================
// Immediate Source Encodings
// Used by Control Unit and Immediate Sign Extension module.
//=========================================================

`define IMM_I  3'b000   // I-type Immediate
`define IMM_S  3'b001   // S-type Immediate
`define IMM_B  3'b010   // B-type Immediate
`define IMM_U  3'b011   // U-type Immediate
`define IMM_J  3'b100   // J-type Immediate

// ALU Source A Select Encodings
// Used by Control Unit and ALUSrcAMux module.
//=========================================================
`define ALUSRCA_REG      2'b00   // Route Register Data (RD1) to ALU Port A
`define ALUSRCA_PC       2'b01   // Route current PC to ALU Port A (for AUIPC)
`define ALUSRCA_ZERO     2'b10   // Route hardwired 32'b0 to ALU Port A (for LUI)

//=========================================================
// PC Source Select Encodings
// Used by Control Unit and PCNextMux module.
//=========================================================

`define PCSRC_PLUS4   2'b00   // Next sequential instruction (PC + 4)
`define PCSRC_TARGET  2'b01   // Branch taken or JAL target (PC + Immediate)
`define PCSRC_JALR    2'b10   // JALR target ({PCTarget[31:1], 1'b0})

//=========================================================
// Result Source Select Encodings
// Used by Control Unit and ResultSrcMux module.
//=========================================================

`define RESULTSRC_ALU      2'b00   // Write back ALUResult (R-type, I-type ALU,AUIPC,LUI ( 0 + ImmExt))
`define RESULTSRC_LOAD     2'b01   // Write back LoadData (Load instructions)
`define RESULTSRC_PCPLUS4  2'b10   // Write back PC+4 (JAL , JALR)

//=========================================================
// RV32I Opcode Encodings
// Used by Control Unit and instruction decode logic.
//=========================================================

`define RTYPE   7'b0110011   // R-type: ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND
`define ITYPE   7'b0010011   // I-type ALU: ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI
`define LOAD    7'b0000011   // Load: LB, LH, LW, LBU, LHU   # ADD IN ALU ALWAYS
`define STORE   7'b0100011   // Store: SB, SH, SW  #ADD IN ALU ALWAYS
`define BRANCH  7'b1100011   // Branch: BEQ, BNE, BLT, BGE, BLTU, BGEU
`define LUI     7'b0110111   // Load Upper Immediate
`define AUIPC   7'b0010111   // Add Upper Immediate to PC # ADD IN ALU ALWAYS
`define JAL     7'b1101111   // Jump And Link
`define JALR    7'b1100111   // Jump And Link Register

//=========================================================
// ALU funct3 Encodings
// Used by ALU Decoder inside Control Unit.
//=========================================================

`define F3_ADD_SUB   3'b000   // ADD/SUB (R-type), ADDI (I-type)
`define F3_SLL       3'b001   // SLL, SLLI
`define F3_SLT       3'b010   // SLT, SLTI
`define F3_SLTU      3'b011   // SLTU, SLTIU
`define F3_XOR       3'b100   // XOR, XORI
`define F3_SRL_SRA   3'b101   // SRL/SRA, SRLI/SRAI
`define F3_OR        3'b110   // OR, ORI
`define F3_AND       3'b111   // AND, ANDI

//=================================================================
// func3 encodings for branch conditions (B-type) used by Branch_PCSrc
// These macros are used by the control unit to select which comparison to perform.
//=================================================================

`define B_BEQ   3'b000  // BEQ   : branch if rs1 == rs2
`define B_BNE   3'b001  // BNE   : branch if rs1 != rs2
`define B_BLT   3'b100  // BLT   : branch if rs1 < rs2 (signed)
`define B_BGE   3'b101  // BGE   : branch if rs1 >= rs2 (signed)
`define B_BLTU  3'b110  // BLTU  : branch if rs1 < rs2 (unsigned)
`define B_BGEU  3'b111  // BGEU  : branch if rs1 >= rs2 (unsigned)

//=========================================================
// Data Forwarding Select Encodings
// Used by Hazard Unit and Execute Stage Forwarding Muxes
//=========================================================

`define FORWARD_NONE 2'b00   // No Hazard: Route standard Decode stage register data (RDE)
`define FORWARD_WB   2'b01   // Writeback Hazard: Forward data from the Writeback stage (ResultW)
`define FORWARD_MEM  2'b10   // Memory Hazard: Forward most recent data from the Memory stage (ALUResultM)