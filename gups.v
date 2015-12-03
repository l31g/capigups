// clk freq = 200 mhz

module gups(
    clk,
    reset,
    address,
    data_in,
    dout,
    req,
    wr,
    ready,
    seed,
    range
);

input           clk, reset;
input   [63:0]  data_in;
output  [63:0]  dout;
output  [63:0]  address;
input   [63:0]  seed;
output          req;
output          wr;
input           ready;
input   [63:0]  range;

reg             write;
reg     [63:0]  data_out;
reg             request;
reg     [63:0]  addr;
reg     [31:0]  mask;
reg     [2:0]   count;
reg     [63:0]  data;

always @(posedge clk) begin
    if(reset == 1'b1) begin
        addr  <= seed;
        mask  <= 32'b1010_0001_1110_0110_0010_1011_1011_1000;
        count <= 3'b000;
        request <= 1'b0;
    end
    else if (count < 3'b100) begin
        addr  <= {addr[47:0], addr[63:48]^mask[15:0]};
        mask  <= {mask[30:0], mask[31]};
        count <= count + 1;
    end 

    if(count == 3'b100 && request == 1'b0) begin
        request <= 1'b1;
        write   <= 1'b0;
    end

    if(ready == 1'b1 && write == 1'b0) begin
        data_out <= data_in + 1;
        write    <= 1'b1;
    end

    if(ready == 1'b1 && write == 1'b1) begin
        request <= 1'b0;
        count   <= 2'b00;
    end
end 

assign req      = request;
assign dout     = data_out;
assign address  = addr & range;
assign wr       = write;

endmodule
