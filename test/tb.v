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
  integer n;
  reg [71:0] s = "123456789";
  reg clk;
  reg rst;
  reg ena;
  reg data;	
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire done;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;
  wire [31:0] out;
`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif
	initial begin
		clk = 0;
		forever #10 clk  = ~clk;
	end
	initial begin
		rst = 1;
		#100;
		rst = 0;
		#100000;
		$finish;
	end
//	always @(posedge done) begin
//		rst = 1;
//		#100;
//		rst = 0;
//	end
	initial begin
		rst = 1; data = 0;
    repeat (3) @(posedge clk);
    @(negedge clk) rst = 0;

    for (n = 0; n < 72; n = n + 1) begin
	data = s[64 - 8*(n/8) + (n%8)];
	@(posedge clk);
        @(negedge clk);    
    end
    @(posedge clk);
    @(negedge clk);

    $finish;
end


  // Replace tt_um_example with your module name:
  topmodule user_project (

      // Include power ports for the Gate Level test:
`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif

      .out (out),
      .clk    (clk),      // clock
      .rst  (rst),     // not reset
      .done (done),
      .data (data)
  );

endmodule
