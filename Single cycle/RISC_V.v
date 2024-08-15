module RISC_V(input clk, rst);

    wire [2:0] func3, ALUControl, immSrc;
    wire zero, neg, memWrite, regWrite, ALUSrc, func7;
    wire [1:0] resultSrc, PCSrc;
    wire [6:0] op; 

    RISC_V_Controller CU(.op(op), .func3(func3), .func7(func7), .zero(zero), .neg(neg),
        .PCSrc(PCSrc), .resultSrc(resultSrc), .ALUControl(ALUControl), .immSrc(immSrc),
        .regWrite(regWrite), .memWrite(memWrite), .ALUSrc(ALUSrc));

    RISC_V_Datapath DP(.clk(clk), .rst(rst), .regWrite(regWrite), .ALUSrc(ALUSrc), .memWrite(memWrite),
        .resultSrc(resultSrc), .PCSrc(PCSrc), .immSrc(immSrc), .ALUControl(ALUControl), .zero(zero),
        .neg(neg), .func7(func7), .op(op), .func3(func3));
    
endmodule
