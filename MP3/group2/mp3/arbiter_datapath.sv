/*
 * Arbiter Datapath Module
 */

import lc3b_types::*;
module arbiter_datapath
(	
	/* Memory */
	input						clk,
	input lc3b_word		input_A_address,	input_B_address,
	input	l1_cache_line	input_A_wdata,		input_B_wdata,	

	input						input_C_resp,
	input	l1_cache_line	input_C_rdata,
	
	output logic			input_C_resp_delay,
	output l1_cache_line out_AB_rdata,		// A and B get same rdata
	
	output lc3b_word 		out_C_address,
	output l1_cache_line out_C_wdata,
	
	/* Control */
	input					sel_ab_address_mux,
	input					sel_ab_to_c_data_mux
);

/* internal signals */
lc3b_word		ab_address_mux_out;
l1_cache_line	ab_to_c_data_mux_out;

/* internal modules */
mux2 #(.width($bits(lc3b_word))) ab_to_c_address_mux
(
	.sel(sel_ab_address_mux),
	.a(input_A_address),
	.b(input_B_address),
	.f(ab_address_mux_out)
);

register #(.width($bits(lc3b_word))) ab_to_c_address_reg
(
	.clk,
	.load(clk),
	.reset(1'b0),
	.in(ab_address_mux_out),
	.out(out_C_address)
);

mux2 #(.width($bits(l1_cache_line))) ab_to_c_data_mux
(
	.sel(sel_ab_to_c_data_mux),
	.a(input_A_wdata),
	.b(input_B_wdata),
	.f(ab_to_c_data_mux_out)
);

register #(.width($bits(l1_cache_line))) ab_to_c_data_reg
(
	.clk,
	.load(clk),
	.reset(1'b0),
	.in(ab_to_c_data_mux_out),
	.out(out_C_wdata)
);

register #(.width($bits(l1_cache_line))) c_to_ab_data_reg
(
	.clk,
	.load(clk),
	.reset(1'b0),
	.in(input_C_rdata),
	.out(out_AB_rdata)
);

register #(.width(1)) c_resp_delay
(
	.clk,
	.load(clk),
	.reset(1'b0),
	.in(input_C_resp),
	.out(input_C_resp_delay)
);


endmodule : arbiter_datapath