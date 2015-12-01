// arbiter for requests

module arb (
	clk,
	reset,
	addr_a,
	din_a,
	dout_a,
	req_a,
	wr_a,
	rdy_a,
	addr_m,
	din_m,
	dout_m,
	req_m,
	wr_m,
	rdy_m
);

input			clk, reset;
input	[255:0]	addr_a;
output	[255:0] din_a;
input	[255:0] dout_a;
input	[3:0]	req_a;
input	[3:0]	wr_a;
output	[3:0]	rdy_a;
output	[63:0]	addr_m;
input	[63:0]	din_m;
output	[63:0]	dout_m;
output			req_m;
output			wr_m;
input			rdy_m;

reg		[1:0]	current;
reg		[1:0]	last;
reg				working;

wire	[3:0]	shfand;

always @(posedge clk) begin
	if(reset == 1'b1) begin
		current <= 2'b00;
		last	<= 2'b00;
		working	<= 1'b0;
	end
	else if (working == 1'b0) begin
		if (((1 << ((last + 1) % 4)) & req_a) != 0) begin
			current <= (last + 1) % 4;
			working <= 1'b1;
		end
		else if (((1 << ((last + 2) % 4)) & req_a) != 0) begin
			current <= (last + 2) % 4;
			working <= 1'b1;
		end
		else if (((1 << ((last + 3) % 4)) & req_a) != 0) begin
			current <= (last + 3) % 4;
			working <= 1'b1;
		end
		else if (((1 << ((last + 4) % 4)) & req_a) != 0) begin
			current <= (last + 4) % 4;
			working <= 1'b1;
		end
	else if (rdy_m == 1'b1) begin
		last 	<= current;
		working <= 1'b0;
	end
end

assign din_a[((64*(current+1))-1):(64*current)]	= din_m;
assign rdy_a[current]							= rdy_m;
assign addr_m	= addr_a[((64*(current+1))-1):(64*current)];
assign dout_m	= dout_a[((64*(current+1))-1):(64*current)];
assign req_m	= req_a[current];
assign wr_m		= wr_a[current];

endmodule
