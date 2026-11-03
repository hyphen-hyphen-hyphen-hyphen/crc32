`default_nettype none
`timescale 1ns / 1ps

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
module tb ();

	// Dump the signals to a FST file. You can view it with gtkwave or surfer.
	initial begin
		$dumpfile("tb.fst");
		$dumpvars(0, tb);
		#1;
	end

	// Wire up the inputs and outputs:
	reg [71:0] s = "123456789";
	reg clk;
	reg rst_n;
	reg ena;
	reg data;
	wire [7:0] ui_in = {7'b0, data};
	reg [7:0] uio_in;
	wire [7:0] uo_out;
	wire done = uo_out[1];
	wire [7:0] uio_out;
	wire [7:0] uio_oe;
	reg [31:0] out;
`ifdef GL_TEST
	wire VPWR = 1'b1;
	wire VGND = 1'b0;
`endif
	integer n;
	initial begin
		clk = 0;
		forever #10 clk = ~clk;
	end
	initial begin
		#100000;
		$fatal(1, "FAIL: timeout");
	end
//	always @(posedge done) begin
//		rst_n = 0;
//		#100;
//		rst_n = 1;
//	end
	initial begin
		rst_n = 0; data = 0; ena = 1; uio_in = 0;
		repeat (3) @(posedge clk);
		@(negedge clk) rst_n = 1;

		// shift in 72 bits, one per clock
		for (n = 0; n < 72; n = n + 1) begin
			data = s[64 - 8*(n/8) + (n%8)];
			@(posedge clk);
			@(negedge clk);
		end

		// read the CRC back serially, out[0] first
		for (n = 0; n < 32; n = n + 1) begin
			@(posedge clk);
			@(negedge clk);
			out[n] = uo_out[0];
		end

		if (out !== 32'hCBF43926)
			$fatal(1, "FAIL: %08X", out);
		else
			$display("PASS: %08X", out);
		$finish;
	end


	// Replace tt_um_example with your module name:
	tt_um_crc32 user_project (

		// Include power ports for the Gate Level test:
`ifdef GL_TEST
		.VPWR(VPWR),
		.VGND(VGND),
`endif

		.ui_in	(ui_in),	// dedicated inputs
		.uo_out	(uo_out),	// dedicated outputs
		.uio_in	(uio_in),	// IO input path
		.uio_out(uio_out),	// IO output path
		.uio_oe	(uio_oe),	// IO enable path
		.ena	(ena),		// always 1
		.clk	(clk),		// clock
		.rst_n	(rst_n)		// reset, active low
	);

endmodule
