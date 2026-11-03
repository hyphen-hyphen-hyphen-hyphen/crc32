/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none
 

module topmodule (input wire clk, input wire rst, input wire data, output wire [31:0] out, output reg done);

	reg [31:0] crc;
	reg [31:0] next_crc;
	wire fb;
	assign fb = crc[31] ^ data;
	always @(*) begin
		next_crc = crc;
		if (!done) begin
		next_crc = crc << 1;
		next_crc[26] = fb ^ next_crc[26];
		next_crc[23] = fb ^ next_crc[23];
		next_crc[22] = fb ^ next_crc[22];
		next_crc[16] = fb ^ next_crc[16];
		next_crc[12] = fb ^ next_crc[12];
		next_crc[11] = fb ^ next_crc[11];
		next_crc[10] = fb ^ next_crc[10];
		next_crc[8 ] = fb ^ next_crc[8 ];
		next_crc[7 ] = fb ^ next_crc[7 ];
		next_crc[5 ] = fb ^ next_crc[5 ];
		next_crc[4 ] = fb ^ next_crc[4 ];
		next_crc[2 ] = fb ^ next_crc[2 ];
		next_crc[1 ] = fb ^ next_crc[1 ];
		next_crc[0 ] = fb ^ next_crc[0 ];
		end

	end
	always @(posedge clk) begin
		if (rst)  begin 
			crc <= 32'hFFFFFFFF;
		end
		else if (!done) crc <= next_crc;	
	end
	wire [31:0] rev;
	genvar i;
	generate 
		for (i = 0; i < 32; i = i + 1) begin
			assign rev[i] = crc[31-i];
		end
	endgenerate
	assign out = ~rev;

	reg [7:0] count;
	always @(posedge clk) begin
		if (rst) begin
			done <= 0;
			count <= 0;
		end
		else if (count == 71) begin
			done <= 1;
			count <= 0;
		end 
		else begin
		       	count <= count + 1;
		end
	end

endmodule
