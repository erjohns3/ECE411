/*
 * Arbiter Module. Input A and B are given data from C
 */
 
import lc3b_types::*;
module arbiter
(
	input 					clk,

	input lc3b_word		input_A_address,	input_B_address,
	input l1_cache_line	input_A_wdata,		input_B_wdata,
	input 					input_A_read,		input_B_read,
	input						input_A_write,		input_B_write,
	
	input l1_cache_line	input_C_rdata,
	input 					input_C_resp,
	
	output logic			out_A_resp,			out_B_resp,
	output l1_cache_line out_AB_rdata,		// A and B get same rdata
	
	output logic 			out_C_read,
	output logic 			out_C_write,
	output lc3b_word 		out_C_address,
	output l1_cache_line out_C_wdata
);

logic sel_ab_address_mux;
logic	sel_ab_to_c_data_mux;
logic input_C_resp_delay;

arbiter_datapath AD
(
	.clk,
	.input_A_address,
	.input_B_address,
	.input_A_wdata,
	.input_B_wdata,
	.input_C_resp,
	.input_C_rdata,
	.input_C_resp_delay,
	.out_AB_rdata,
	.out_C_address,
	.out_C_wdata,
	.sel_ab_address_mux,
	.sel_ab_to_c_data_mux
);

arbiter_control AC
(
	.clk,
	.input_A_read,
	.input_B_read,
	.input_A_write,
	.input_B_write,
	.input_C_resp(input_C_resp_delay),
	.out_A_resp,
	.out_B_resp,
	.out_C_read,
	.out_C_write,
	.sel_ab_address_mux,
	.sel_ab_to_c_data_mux
);

endmodule : arbiter