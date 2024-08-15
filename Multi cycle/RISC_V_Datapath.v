module RISC_V_Datapath(input clk, rst, PCWrite, AdrSrc, MemWrite, IRWrite, RegWrite, Branch, input [1:0] ResultSrc, ALUSrcA, ALUSrcB, Bsel,
                    input [2:0] ALUControl, ImmSrc, output [6:0] op, output [2:0] func3, output func7);


    wire [31:0] PC, Adr, ReadData, OldPC;
    wire [31:0] ImmExt, Instr, Data;
    wire [31:0] RD1, RD2, A, B, SrcA, SrcB;
    wire [31:0] ALUResult, ALUOut,Result;
    wire BRes, PCWriteEn, znRes;
    wire zero, neg;

    Register PCReg     (.in(Result),    .en(PCWriteEn), .rst(rst),  .clk(clk), .out(PC));
    Register OldPCReg  (.in(PC),        .en(IRWrite),   .rst(1'b0), .clk(clk), .out(OldPC));
    Register IR        (.in(ReadData),  .en(IRWrite),   .rst(1'b0), .clk(clk), .out(Instr));
    Register MDR       (.in(ReadData),  .en(1'b1),      .rst(1'b0), .clk(clk), .out(Data));
    Register AReg      (.in(RD1),       .en(1'b1),      .rst(1'b0), .clk(clk), .out(A));
    Register BReg      (.in(RD2),       .en(1'b1),      .rst(1'b0), .clk(clk), .out(B));
    Register ALUoutReg (.in(ALUResult), .en(1'b1),      .rst(1'b0), .clk(clk), .out(ALUOut));

    Mux2to1 AdrMux (.slc(AdrSrc),    .a(PC),     .b(Result), .w(Adr));

    Mux4to1 #(32) AMux      (.slc(ALUSrcA),   .a(PC),     .b(OldPC),  .c(A),         .d(32'd0),  .w(SrcA));
    Mux4to1 #(32) BMux      (.slc(ALUSrcB),   .a(B),      .b(ImmExt), .c(32'd4),     .d(32'd0),  .w(SrcB));
    Mux4to1 #(32) ResultMux (.slc(ResultSrc), .a(ALUOut), .b(Data),   .c(ALUResult), .d(ImmExt), .w(Result));
    Mux4to1 #(1)  PCEN      (.slc(Bsel),      .a(zero),    .b(~zero), .c(neg),       .d(~neg),   .w(znRes));

    assign BRes = Branch & znRes;
    assign PCWriteEn = PCWrite | BRes;

    ImmExtension Extend(.ImmSrc(ImmSrc), .data(Instr[31:7]), .w(ImmExt));

    ALU ALU_Instance(.ALUControl(ALUControl), .a(SrcA), .b(SrcB), .zero(zero), .neg(neg), .w(ALUResult));

    InstrDataMemory DM(.memAdr(Adr), .WriteData(B), .clk(clk), .MemWrite(MemWrite), .ReadData(ReadData));

    RegisterFile RF(.clk(clk), .RegWrite(RegWrite), .WriteData(Result), .ReadData1(RD1), .ReadData2(RD2),
        .readRegister1(Instr[19:15]), .readRegister2(Instr[24:20]), .writeRegister(Instr[11:7]));

    assign op = Instr[6:0];
    assign func3 = Instr[14:12];
    assign func7 = Instr[30];

endmodule
