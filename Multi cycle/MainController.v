`define R_T     7'b0110011
`define I_T     7'b0010011
`define S_T     7'b0100011
`define B_T     7'b1100011
`define U_T     7'b0110111
`define J_T     7'b1101111
`define LW_T    7'b0000011
`define JALR_T  7'b1100111

`define IF          5'b00000
`define ID          5'b00001
`define EX_I        5'b00010
`define EX_R        5'b00011
`define EX_B        5'b00100
`define EX1_J       5'b00101
`define EX2_JALR    5'b00110
`define EX_S        5'b00111
`define EX2_J       5'b01000
`define EX1_JALR    5'b01001
`define EX_LW       5'b01010
`define MEM_LW      5'b01011
`define MEM_I       5'b01100
`define MEM_S       5'b01101
`define MEM_R       5'b01110
`define MEM_U       5'b01111
`define MEM_J       5'b10000
`define WB          5'b10001

module MainController(input clk, rst, input [6:0] op, output reg AdrSrc, RegWrite, MemWrite, PCWrite, Branch, IRWrite,
                      output reg [1:0]  ResultSrc, ALUSrcA, ALUSrcB, ALUOp, output reg [2:0] ImmSrc);

    reg [4:0] ps;
    reg [4:0] ns = `IF;

    always @(ps or op) begin
        case(ps)
            `IF : ns <= `ID;

            `ID: ns <= (op == `R_T) ? `EX_R :
                       (op == `I_T) ? `EX_I :
                       (op == `S_T) ? `EX_S :
                       (op == `J_T) ? `EX1_J :
                       (op == `B_T) ? `EX_B :
                       (op == `U_T) ? `MEM_U :
                       (op == `LW_T) ? `EX_LW :
                       (op == `JALR_T) ? `EX1_JALR: `IF;

            `EX_I : ns <= `MEM_I;
            `EX_R : ns <= `MEM_R;
            `EX_B : ns <= `IF;
            `EX1_J : ns <= `EX2_J;
            `EX2_JALR : ns <= `MEM_I;
            `EX_S : ns <= `MEM_S;
            `EX2_J : ns <= `MEM_J;
            `EX1_JALR : ns <= `EX2_JALR;
            `EX_LW : ns <= `MEM_LW;
            `MEM_LW: ns <= `WB;
            `MEM_I: ns <= `IF;
            `MEM_S: ns <= `IF;
            `MEM_R: ns <= `IF;
            `MEM_U: ns <= `IF;
            `MEM_J: ns <= `IF;
            `WB  : ns <= `IF;
        endcase
    end


    always @(ps) begin

        {ResultSrc, MemWrite, ALUOp, ALUSrcA, ALUSrcB, ImmSrc, RegWrite, PCWrite, Branch, IRWrite, AdrSrc} <= 15'b0;

        case(ps)

            `IF : begin
                IRWrite <= 1'b1; ALUSrcA <= 2'b00; ALUSrcB <= 2'b10; ALUOp <= 2'b00; ResultSrc <= 2'b10; PCWrite <= 1'b1; AdrSrc <= 1'b0;
            end
        
            `ID: begin
                ALUSrcA <= 2'b01; ALUSrcB <= 2'b01; ALUOp <= 2'b00; ImmSrc <= 3'b010;
            end
        
            `EX_I: begin 
                ALUSrcA <= 2'b10; ALUSrcB <= 2'b01; ImmSrc <= 3'b000; ALUOp <= 2'b11;
            end

            `EX_R: begin
                ALUSrcA <= 2'b10; ALUSrcB <= 2'b00; ALUOp <= 2'b10;
            end
        
            `EX_B: begin
                ALUSrcA <= 2'b10; ALUSrcB <= 2'b00; ALUOp <= 2'b01; ResultSrc <= 2'b0; Branch <= 1'b1;
            end
        
            `EX1_J: begin
                ALUSrcA <= 2'b01; ALUSrcB <= 2'b10; ALUOp <= 2'b00;
            end
        
            `EX2_JALR: begin
                ALUSrcA <= 2'b01; ALUSrcB <= 2'b10; ALUOp <= 2'b00; ResultSrc <= 2'b00; PCWrite <= 1'b1;
            end
        
            `EX_S: begin
                ALUSrcA <= 2'b10; ALUSrcB <= 2'b01; ALUOp <= 2'b00; ImmSrc <= 3'b001;
            end
        
            `EX2_J: begin
                RegWrite <= 1'b1; ALUSrcA <= 2'b01; ALUSrcB <= 2'b01; ImmSrc <= 3'b011; ALUOp <= 2'b00;
            end

            `EX1_JALR: begin 
                ALUSrcA <= 2'b10; ALUSrcB <= 2'b01; ImmSrc <= 3'b000; ALUOp <= 2'b00;
            end

            `EX_LW: begin 
                ALUSrcA <= 2'b10; ALUSrcB <= 2'b01; ImmSrc <= 3'b000; ALUOp <= 2'b00;
            end

            `MEM_LW: begin
                ResultSrc <= 2'b00; AdrSrc <= 1'b1;
            end
        
            `MEM_I: begin
                ResultSrc <= 2'b00; RegWrite <= 1'b1;
            end
        
            `MEM_S: begin
                ResultSrc <= 2'b00; AdrSrc <= 1'b1; MemWrite <= 1'b1;
            end
        
            `MEM_R: begin
                ResultSrc <= 2'b00; RegWrite <= 1'b1;
            end
        
            `MEM_U: begin
                ResultSrc <= 2'b11; ImmSrc <= 3'b100; RegWrite <= 1'b1;
            end
        
            `MEM_J: begin
                ResultSrc <= 2'b00; PCWrite <= 1'b1;
            end
        
            `WB: begin
                ResultSrc <= 2'b01; RegWrite <= 1'b1;
            end
        
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if(rst)
            ps <= `IF;
        else
            ps <= ns;
    end

endmodule
