/*
 * Performance Counter Module
 */

import lc3b_types::*;
module perf_counter
(
	input						clk,
	input						accumulate,
	input						reset,
	
	output	lc3b_word	total
);

lc3b_word data;

/* Altera device registers are 0 at power on. Specify this
 * so that Modelsim works as expected.
 */
initial
begin
	data = 16'h0;
end

always_ff @(posedge clk)
begin
	if (reset)
	begin
		data = 0;
	end
	else if (accumulate)
	begin
		data = data + 16'h1;
	end
end

always_comb
begin
	total = data;
end

endmodule : perf_counter
