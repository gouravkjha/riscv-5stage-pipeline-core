`timescale 1ns / 1ps

module Register_File(
    input clk,RegWrite,rst,
    input [4:0] R1,R2,RD,
    input [31:0] WriteD,
    output [31:0] RD1,RD2
    );
    
    integer i;
    reg [31:0] regmem [31:0];
    
    assign RD1 = regmem[R1];
    assign RD2 = regmem[R2];
    
    always@(negedge clk or posedge rst)begin
      if(rst)begin     
        for(i=0;i<32;i=i+1)
          regmem[i]<=32'b0;     
      end
      
     else if(RegWrite && RD!=0)
      regmem[RD] <= WriteD;
    end
    
endmodule
