/*
 * LRU Decoder
 */

import lc3b_types::*;
module lru_decoder
(
	input						hit0,
	input						hit1,
	input						hit2,
	input						hit3,
	input [2:0]				in,
	output logic [1:0]	decoded_val,
	output logic [2:0]	out
);

always_comb
begin
	/* defaults */
	out 			= in;
	decoded_val	= 2'b00;
	
	/* LRU updater:
	 *     bit2
	 *	   0/ \1
	 *  bit1  bit0
	 * 0/ \1 0/ \1
	 * 0   1 2   3
	 *
	 */
	if(hit0) begin
		out = {1'b1, 1'b1, in[0]};
	end
	else if(hit1) begin
		out = {1'b1, 1'b0, in[0]};
	end
	else if(hit2) begin
		out = {1'b0, in[1], 1'b1};
	end
	else if(hit3) begin
		out = {1'b0, in[1], 1'b0};
	end
	
	/* LRU Value Decoder */
	if(in[2]) begin
		if(in[0])	decoded_val = 2'b11;
		else			decoded_val = 2'b10;
	end
	else begin
		if(in[1])	decoded_val = 2'b01;
		else			decoded_val = 2'b00;
	end
end

endmodule : lru_decoder
