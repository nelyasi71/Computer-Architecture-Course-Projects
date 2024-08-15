`define BEQ 3'b000
`define BNE 3'b001
`define BLT 3'b010
`define BGE 3'b011

module BranchController(input [2:0] func3, output reg [1:0] Bsel);

    always @(func3) begin
        case(func3)
            `BEQ   : Bsel <= 2'b00;
            `BNE   : Bsel <= 2'b01;
            `BLT   : Bsel <= 2'b10;
            `BGE   : Bsel <= 2'b11;
            default: Bsel <= 2'b00;
        endcase
    end

endmodule
