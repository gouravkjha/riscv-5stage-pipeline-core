`timescale 1ns / 1ps

module Load_extend(
    input [2:0] func3,
    input [1:0] ByteOffset,
    input [31:0] RD,
    output reg [31:0] LoadData
    );
    
    // Localparams for combined {funct3, Offset} selector (funct3[2:0], Offset[1:0])
localparam [4:0]
    L_LB_0   = {3'b000, 2'b00}, // LB byte offset 0 (signed)
    L_LB_1   = {3'b000, 2'b01}, // LB byte offset 1 (signed)
    L_LB_2   = {3'b000, 2'b10}, // LB byte offset 2 (signed)
    L_LB_3   = {3'b000, 2'b11}, // LB byte offset 3 (signed)

    L_LH_0   = {3'b001, 2'b00}, // LH halfword offset 0 (signed)
    L_LH_2   = {3'b001, 2'b10}, // LH halfword offset 2 (signed)

    L_LW     = {3'b010, 2'b00}, // LW word offset 0 (word, no sign/zero extension)

    L_LBU_0  = {3'b100, 2'b00}, // LBU byte offset 0 (unsigned)
    L_LBU_1  = {3'b100, 2'b01}, // LBU byte offset 1 (unsigned)
    L_LBU_2  = {3'b100, 2'b10}, // LBU byte offset 2 (unsigned)
    L_LBU_3  = {3'b100, 2'b11}, // LBU byte offset 3 (unsigned)

    L_LHU_0  = {3'b101, 2'b00}, // LHU halfword offset 0 (unsigned)
    L_LHU_2  = {3'b101, 2'b10}; // LHU halfword offset 2 (unsigned)
    
    wire [1:0] Offset;
    assign Offset = func3[1]?2'b00:func3[0]?{ByteOffset[1],1'b0}:ByteOffset;
    
   always @* begin
    case ({func3, Offset})
        L_LB_0:LoadData = {{24{RD[7]}},RD[7:0]};
        L_LB_1:LoadData = {{24{RD[15]}},RD[15:8]};
        L_LB_2:LoadData = {{24{RD[23]}},RD[23:16]};
        L_LB_3:LoadData = {{24{RD[31]}},RD[31:24]};
        
        L_LH_0:LoadData = {{16{RD[15]}},RD[15:0]};
        L_LH_2:LoadData = {{16{RD[31]}},RD[31:16]};
        
        L_LW:LoadData =RD;
        
        L_LBU_0:LoadData = {24'b0,RD[7:0]};
        L_LBU_1:LoadData = {24'b0,RD[15:8]};
        L_LBU_2:LoadData = {24'b0,RD[23:16]};
        L_LBU_3:LoadData = {24'b0,RD[31:24]};
        
        L_LHU_0:LoadData = {16'b0,RD[15:0]};
        L_LHU_2:LoadData = {16'b0,RD[31:16]};
        
        default :LoadData =RD;
    endcase
end
    
endmodule

