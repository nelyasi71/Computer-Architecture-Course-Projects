`define JAL_ 3'b000 // no branch
`define BEQ  3'b001
`define BNE  3'b010
`define BLT  3'b011
`define BGE  3'b100

`define JAL  2'b01
`define JALR 2'b10

module BranchController(input [2:0] branchE, input [1:0] jumpE, input neg, zero, output reg [1:0] PCSrcE);
    
    always @(jumpE, zero, neg, branchE) begin
        case(branchE)
            `JAL_: PCSrcE <= (jumpE == `JAL)  ? 2'b01 :
                             (jumpE == `JALR) ? 2'b10 : 2'b00;
            `BEQ : PCSrcE <= (zero)           ? 2'b01 : 2'b00;
            `BNE : PCSrcE <= (~zero)          ? 2'b01 : 2'b00;
            `BLT : PCSrcE <= (neg)            ? 2'b01 : 2'b00;
            `BGE : PCSrcE <= (zero | ~neg)    ? 2'b01 : 2'b00;
        endcase
    end

endmodule
