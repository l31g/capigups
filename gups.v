// clk freq = 200 mhz

module gups(
    clk,
    reset,
    address,
    data_in,
    dout,
    req,
    write,
    ready,
    seed,
    range
);

input   wire    clk;
input   [63:0]  data_in;
output  [63:0]  dout;
output  [63:0]  address;
input   [15:0]  seed;
output          req;
output          write;
input           ready;
input   [63:0]  range;

reg     [63:0]  data_out;
reg             request;
reg     [63:0]  addr;
reg     [15:0]  mask;
reg     [2:0]   count;
reg     [63:0]  data;

always @(posedge clk) begin
    if(reset == 1'b0)
    begin
        addr  <= seed;
        mask  <= 16'b1011000110100110;
        count <= 3'b000;
    else if (count < 3'b100) begin
        addr  <= {addr[47:0], addr[63:48]^mask};
        mask  <= {mask[14:0], mask[15]}
        count <= count + 1;
    end 

    if(count == 3'b100 && request == 1'b0) begin
        request <= 1'b1;
        write   <= 1'b0;
    end

    if(ready == 1'b1 and write == 1'b0) begin
        data_out <= data_in + 1;
        write    <= 1'b1;
    end

    if(ready == 1'b1 and write == 1'b1) begin
        request <= 1'b0;
        count   <= 2'b00;
    end
end 

assign req      = request;
assign dout     = data_out;
assign address  = addr & range;

endmodule;