`define S_T   2'b00
`define B_T   2'b01
`define R_T   2'b10
`define I_T   2'b11

`define ADD  3'b000
`define SUB  3'b001
`define AND  3'b010
`define OR   3'b011
`define SLT  3'b101
`define SLTU 3'b110
`define XOR  3'b100

module ALU_Controller(input [2:0] func3, input func7, input [1:0] ALUOp, output reg [2:0] ALUControl);

    always @(ALUOp or func3 or func7)begin
        case (ALUOp)
            `S_T   : ALUControl <= `ADD;
            `B_T   : ALUControl <= `SUB;
            `R_T   : ALUControl <= 
                        (func3 == 3'b000 & ~func7) ? `ADD:
                        (func3 == 3'b000 & func7) ? `SUB:
                        (func3 == 3'b111) ? `AND:
                        (func3 == 3'b110) ? `OR:
                        (func3 == 3'b011) ? `SLTU:
                        (func3 == 3'b010) ? `SLT : 3'bzzz;
            `I_T   : ALUControl <=  
                        (func3 == 3'b000) ? `ADD:
                        (func3 == 3'b100) ? `XOR:
                        (func3 == 3'b110) ? `OR:
                        (func3 == 3'b011) ? `SLTU:
                        (func3 == 3'b010) ? `SLT: 3'bzzz;
            default: ALUControl <= `ADD;
        endcase
    end
    
endmodule