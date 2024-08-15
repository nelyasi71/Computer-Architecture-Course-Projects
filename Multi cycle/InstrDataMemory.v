module InstrDataMemory (input [31:0] memAdr, WriteData, input MemWrite, clk, output reg [31:0] ReadData);

    reg [7:0] dataMem [0:$pow(2, 16)-1];

    wire [31:0] adr;
    assign adr = {memAdr[31:2], 2'b00};
    
    initial $readmemb("data.mem", dataMem);

    always @(posedge clk) begin
        if (MemWrite)
            {dataMem[adr + 3], dataMem[adr + 2], dataMem[adr + 1], dataMem[adr]} <= WriteData;
    end

    assign ReadData = {dataMem[adr + 3], dataMem[adr + 2], dataMem[adr + 1], dataMem[adr]};
    
endmodule
