module sys (
	clk,
	reset,
	addr,
	din,
	dout,
	req,
	wr,
	rdy,
	seed0,
	seed1,
	seed2,
	seed3,
	range
);

input           clk, reset;
input   [63:0]  din;
output  [63:0]  dout;
output  [63:0]  addr;
input   [15:0]  seed0, seed1, seed2, seed3;
output          req;
output          wr;
input           rdy;
input   [63:0]  range;

wire	[255:0]	addr_a;
wire	[255:0] din_a;
wire	[255:0] dout_a;
wire	[3:0]	req_a;
wire	[3:0]	wr_a;
wire	[3:0]	rdy_a;

arb arbiter(clk, reset, addr_a, din_a, dout_a, req_a, wr_a,
	rdy_a, addr, din, dout,req, wr, rdy);

gups g0(clk, reset, din_a[063:000], dout_a[063:000],
	addr_a[063:000], seed0, req_a[0], wr_a[0], rdy_a[0], range);
gups g1(clk, reset, din_a[127:064], dout_a[127:064],
	addr_a[127:064], seed1, req_a[1], wr_a[1], rdy_a[1], range);
gups g2(clk, reset, din_a[191:128], dout_a[191:128],
	addr_a[191:128], seed2, req_a[2], wr_a[2], rdy_a[2], range);
gups g3(clk, reset, din_a[255:192], dout_a[255:192],
	addr_a[255:192], seed3, req_a[3], wr_a[3], rdy_a[3], range);
endmodule
