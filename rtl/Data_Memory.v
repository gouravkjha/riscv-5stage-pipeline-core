`timescale 1ns / 1ps

module Data_Memory(
    input  clk,
    input  MemWrite,
    input  [2:0]  funct3,
    input  [31:0] ALUAddr,
    input  [31:0] WData,
    output [31:0] RD
);

    reg [31:0] mem [0:4095];

    // {funct3, Addr}
  localparam [4:0]
    STORE_WORD      = 5'b010_00, // Store Word (SW)
    STORE_HALF_LOW  = 5'b001_00, // Store Halfword to lower 16 bits
    STORE_HALF_HIGH = 5'b001_10, // Store Halfword to upper 16 bits
    STORE_BYTE_0    = 5'b000_00, // Store Byte at byte lane 0
    STORE_BYTE_1    = 5'b000_01, // Store Byte at byte lane 1
    STORE_BYTE_2    = 5'b000_10, // Store Byte at byte lane 2
    STORE_BYTE_3    = 5'b000_11; // Store Byte at byte lane 3

    // Address Normalization
    wire [1:0] Addr;

    assign Addr =
            (funct3 == 3'b010) ? 2'b00 :               // SW
            (funct3 == 3'b001) ? {ALUAddr[1],1'b0} :   // SH
                                ALUAddr[1:0];          // SB

    assign RD = mem[ALUAddr[11:2]];

    always @(posedge clk) begin
        if (MemWrite) begin
            case ({funct3, Addr})         
        STORE_WORD:      mem[ALUAddr[11:2]] <= WData;

        STORE_HALF_LOW:  mem[ALUAddr[11:2]][15:0]  <= WData[15:0];
        STORE_HALF_HIGH: mem[ALUAddr[11:2]][31:16] <= WData[15:0];

        STORE_BYTE_0: mem[ALUAddr[11:2]][7:0]   <= WData[7:0];
        STORE_BYTE_1: mem[ALUAddr[11:2]][15:8]  <= WData[7:0];
        STORE_BYTE_2: mem[ALUAddr[11:2]][23:16] <= WData[7:0];
        STORE_BYTE_3: mem[ALUAddr[11:2]][31:24] <= WData[7:0];
            endcase
           end
    end
endmodule