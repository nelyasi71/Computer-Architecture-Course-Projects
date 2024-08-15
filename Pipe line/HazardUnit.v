module HazardUnit(input [4:0] Rs1D, Rs2D, RdE, RdM, RdW, Rs1E, Rs2E, input [1:0] PCSrcE,
                  input regWriteM, regWriteW, resultSrc0, output reg [1:0] forwardAE, forwardBE,
                  output reg stallF, stallD, flushD, flushE);

    assign forwardAE = ((Rs1E == RdM) && regWriteM && (Rs1E != 5'b0)) ? 2'b10:
                       ((Rs1E == RdW) && regWriteW && (Rs1E != 5'b0)) ? 2'b01: 2'b00; 

    assign forwardBE = ((Rs2E == RdM) && regWriteM && (Rs2E != 5'b0)) ? 2'b10:
                       ((Rs2E == RdW) && regWriteW && (Rs2E != 5'b0)) ? 2'b01: 2'b00;
                                
    reg lwStall;
    assign lwStall = ((((Rs1D == RdE) || (Rs2D == RdE)) && resultSrc0)) ? 1'b1 : 1'b0;

    assign stallF = lwStall;
    assign stallD = lwStall;

    assign flushD = (PCSrcE != 2'b00) ? 1'b1 : 1'b0 ;
    assign flushE = lwStall || (PCSrcE != 2'b00);

endmodule

