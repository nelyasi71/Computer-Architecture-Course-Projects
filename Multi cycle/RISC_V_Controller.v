module RISC_V_Controller(input clk, rst, func7, input [6:0] op, input [2:0] func3, output PCWrite, AdrSrc, MemWrite, IRWrite, RegWrite, Branch,
                    output [1:0] ResultSrc, ALUSrcA, ALUSrcB, Bsel, output [2:0] ALUControl, ImmSrc);

    wire [1:0] ALUOp;

    MainController MC(.clk(clk), .rst(rst), .op(op), .PCWrite(PCWrite), .AdrSrc(AdrSrc), .MemWrite(MemWrite), .Branch(Branch),
                        .ResultSrc(ResultSrc), .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB), .ImmSrc(ImmSrc), .RegWrite(RegWrite), .IRWrite(IRWrite), .ALUOp(ALUOp));
    
    ALU_Controller AC(.func3(func3), .func7(func7), .ALUOp(ALUOp), .ALUControl(ALUControl));    
    
    BranchController BC(.func3(func3), .Bsel(Bsel)); 
                                            

endmodule
