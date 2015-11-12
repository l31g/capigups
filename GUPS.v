// clk freq = 200 MHz

module GUPS(
    CLK,
    RESET,
    ADDRESS,
    DATA_IN,
    DATA_OUT,
    REQUEST,
    WRITE,
    READY,
    SEED,
    RANGE
);

input wire CLK;
input [63:0] DATA_IN;
output [63:0] DATA_OUT;
output [63:0] ADDRESS;
reg[63:0] ADDR;
input [15:0] SEED;
output REQUEST;
output WRITE;
input READY;
input [63:0] RANGE; 
reg [15:0] MASK;
reg [3:0] COUNT;
reg [63:0] DATA;

always @(posedge CLK)
    if(RESET == 1'b0)
    begin
        assign ADDR = SEED;
        assign MASK = 16'b1011000110100110;
        assign COUNT = 2'b00;
    else 
        assign ADDR = {ADDR[47:0], ADDR[63:48]^MASK};
        assign MASK = {MASK[14:0], MASK[15]}
    end 
    if(COUNT == 2'b11 and REQUEST == 1'b0)
    begin
        assign ADDRESS = ADDR & RANGE;
        assign REQUEST = 1'b1;
        assign WRITE = 1'b0;
    else if(COUNT == 2'b10 and REQUEST == 1'b0)
        assign COUNT = 2'b11;
        assign REQUEST = 1'b0;
    else if(COUNT == 2'b01 and REQUEST == 1'b0)
        assign COUNT = 2'b10;
        assign REQUEST = 1'b0;    
    else if(REQUEST == 1'b0)
        assign COUNT = 2'b01;
        assign REQUEST = 1'b0;
    end
    if(READY == 1'b1 and REQUEST == 1'b1 and WRITE == 1'b0)
    begin
        assign COUNT = 2'b00;
        assign DATA_OUT = DATA_IN + 1;
        assign WRITE = 1'b1;
    end
    if(READY ==1'b1 and REQUEST == 1'b1 and WRITE == 1'b1)
    begin
        assign REQUEST = 1'b0;
        
    end
endmodule;
