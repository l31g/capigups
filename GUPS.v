// clk freq = 200 MHz

module GUPS(
  clk,
  address,
  data,
  request,
  seed,
  range
);

input wire clk;
input [63:0] data;
output [63:0] address;
reg[63:0] addr;
input [15:0] seed;
output request;
input [63:0] range; 

reg mask = 16'b1011000110100110;
assign addr = seed;

always @(posedge clk)
  begin
  assign addr = {addr[47:0],addr[63:48]^mask};
  assign mask = {mask[14:0], mask[15]}
  assign count = count + 1;
  if(count == 4)
    assign count = 0;
    assign address = addr & range;
    assign request = 1;
  else 
    assign request = 0;
  end;
endmodule;
