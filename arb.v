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
output	reg [3:0]	rdy_a;
output	reg [63:0]	addr_m;
input	[63:0]	din_m;
output	reg [63:0]	dout_m;
output	reg		req_m;
output	reg		wr_m;
input			rdy_m;

reg		[1:0]	current;
reg		[1:0]	last;
reg				working;

wire	[3:0]	shfand;

always @(posedge clk) begin
	if(reset == 1'b1) begin
		current <= 2'b00;
		last	<= 2'b11;
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
	end
	else if (rdy_m == 1'b1) begin
		last 	<= current;
		working <= 1'b0;
	end
end

always @(posedge clk) begin
    if(working != 1'b1) begin
        req_m   = 1'b0;
        rdy_a   = 4'b0000;
        wr_m    = 1'b0;
    end
	else if (current == 2'b00) begin
		rdy_a 	= rdy_m ? 4'b0001 : 4'b0000; 
		addr_m 	= addr_a[063:000];
		dout_m	= dout_a[063:000];
		req_m	= req_a[0];
		wr_m	= wr_a[0];
	end
	else if (current == 2'b01) begin
		rdy_a 	= rdy_m ? 4'b0010 : 4'b0000; 
		addr_m 	= addr_a[127:064];
		dout_m	= dout_a[127:064];
		req_m	= req_a[1];
		wr_m	= wr_a[1];
	end
	else if (current == 2'b10) begin
		rdy_a 	= rdy_m ? 4'b0100 : 4'b0000; 
		addr_m 	= addr_a[191:128];
		dout_m	= dout_a[191:128];
		req_m	= req_a[2];
		wr_m	= wr_a[2];
	end
	else if (current == 2'b11) begin
		rdy_a 	= rdy_m ? 4'b1000 : 4'b0000; 
		addr_m 	= addr_a[255:192];
		dout_m	= dout_a[255:192];
		req_m	= req_a[3];
		wr_m	= wr_a[3];
	end		

end

assign din_a[255:192] = din_m;
assign din_a[191:128] = din_m;
assign din_a[127:064] = din_m;
assign din_a[063:000] = din_m;

endmodule
