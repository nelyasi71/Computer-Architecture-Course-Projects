module RISC_V(input clk, rst);
    
    wire PCSrc, MemWrite, func7, RegWrite, ALUSrc, PCWrite, AdrSrc, IRWrite, Branch;
    wire [1:0] ResultSrc, ALUSrcA, ALUSrcB, Bsel;
    wire [2:0] func3, ALUControl, ImmSrc;
    wire [6:0] op; 

    RISC_V_Controller CU(.clk(clk), .rst(rst), .op(op), .func3(func3), .ImmSrc(ImmSrc), .func7(func7), .Branch(Branch),
        .PCWrite(PCWrite), .AdrSrc(AdrSrc), .MemWrite(MemWrite),  .IRWrite(IRWrite), .ResultSrc(ResultSrc), .Bsel(Bsel),
        .ALUControl(ALUControl), .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB), .RegWrite(RegWrite));

    RISC_V_Datapath DP(.clk(clk), .rst(rst), .PCWrite(PCWrite), .AdrSrc(AdrSrc), .MemWrite(MemWrite), .IRWrite(IRWrite),
        .ResultSrc(ResultSrc), .ImmSrc(ImmSrc), .ALUControl(ALUControl), .op(op), .ALUSrcA(ALUSrcA), .func3(func3),
        .ALUSrcB(ALUSrcB), .RegWrite(RegWrite), .func7(func7), .Branch(Branch), .Bsel(Bsel));
    
endmodule
