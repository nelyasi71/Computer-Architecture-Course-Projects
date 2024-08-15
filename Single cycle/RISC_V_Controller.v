module RISC_V_Controller(input [6:0] op, input [2:0] func3, input func7, zero, neg,
                         output [1:0] PCSrc, resultSrc, output [2:0] ALUControl, immSrc,
                         output regWrite, memWrite, ALUSrc);
  
    wire jal, jalr, branch, branchRes;
    wire [1:0] ALUOp;
    
    MainController MC(.op(op), .zero(zero), .neg(neg), .resultSrc(resultSrc), .ALUOp(ALUOp),
                        .immSrc(immSrc), .regWrite(regWrite), .memWrite(memWrite), .ALUSrc(ALUSrc),  
                        .jal(jal), .jalr(jalr), .branch(branch));
    
    BranchController BC(.func3(func3), .branch(branch), .zero(zero), .neg(neg), .w(branchRes));   
    
    ALU_Controller AC(.func3(func3), .func7(func7), .ALUOp(ALUOp), .ALUControl(ALUControl));
    
    assign PCSrc =  (jalr) ? 2'b10 : (jal | branchRes) ? 2'b01: 2'b00;

endmodule