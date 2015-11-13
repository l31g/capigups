`define CLK_OVER_TWO	3.5
`define CLK				(`CLK_OVER_TWO * 2)

module gups_tb();
	`define BITS	32
	
	reg				clk, rst, rdy;
	wire			req, wr;
	reg		[63:0]	din;
	reg		[63:0]	data	[8191:0];
	reg		[63:0]	exp		[8191:0];
	wire	[63:0]	dout;
	wire	[63:0]	addr;
	reg		[15:0]	seed;
	reg		[63:0]	range;

	reg		[31:0]	idx;

	gups dut(clk, rst, addr, din, dout, req, wr, rdy, seed, range);
	
	initial begin
		clk = 1;
	end

	always begin
		#`CLK_OVER_TWO	clk = ~clk;
	end

	initial begin
		$display("\n========================================================\ntestbench\n");
		idx = 0;
		
		repeat (8192) begin
			data[idx] = {$random, $random};
			exp[idx] = data[idx];
			idx = idx + 1;
		end

		rst = 0;
		rdy = 0;
		seed = $random;
		range = 64'h0000_0000_0000_1fff;

		# (3 * `CLK)

		rst = 1;

		# (3 * `CLK)

		rst = 0;

		repeat (1000000) begin
			if (req == 1'b1) begin
				if (wr == 1'b1) begin
					exp[addr] = exp[addr] + 1;
					(# 5 * CLK)
					data[addr] = dout;
					if (exp[addr] != dout) begin
						$display ("Error writing %d", addr);
				else begin
					(# 2 * CLK)
					din = data[addr];
				end
				rdy = 1'b1;
				(# `CLK)
				rdy = 1'b0;
			end
			(#`CLK)
		end

		$display("\n========================================================\n");
	end

endmodule 
