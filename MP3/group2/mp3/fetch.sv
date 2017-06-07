/*
 * Instruction Fetch Module
 */

import lc3b_types::*;
module fetch
(
	input								clk,
	input								branch_miss,
	input								branch_prediction,
	input								load_pc,
	input		lc3b_word			pc_offset,
	input		lc3b_word			pc_reset,
	input		lc3b_word			mem_val,
	input		lc3b_word			br_predict,
	input		lc3b_control_word ctrl,
	
	output	lc3b_word			pc_new_out,
	output	lc3b_word			icache_address
);

/* internal signals */
logic	[1:0]	sel_branch_mux;
lc3b_word	pc_out;
lc3b_word	pc_mux_out;
lc3b_word	branch_mux_out;

/* internal assignments */
assign pc_new_out = pc_out + 16'd2;
assign icache_address = pc_out;

/* Simple Control Logic for branch sel */
always_comb
begin
	sel_branch_mux	= 2'b00;
	
	if(branch_miss) begin
		sel_branch_mux = 2;
	end
	else if(ctrl.IF_sel_pc_mux != 0) begin
		;			// Do Nothing, but doesn't do the 'branch_prediction' below. This allows jmp/ret/jsr/jsrr/trap to occur if predicting
	end
	else if(branch_prediction) begin
		sel_branch_mux = 1;
	end
end

/* Modules */
mux4 pc_mux
(
	.sel(ctrl.IF_sel_pc_mux),
	.a(pc_new_out),
	.b(pc_offset),						// Used elsewhere for different values - JSR
	.c(mem_val),
	.d(16'd0),
	.f(pc_mux_out)
);

mux4 branch_predict_mux						// Needed for automatic branch logic
(
	.sel(sel_branch_mux),
	.a(pc_mux_out),
	.b(br_predict),
	.c(pc_reset),
	.d(16'h0),
	.f(branch_mux_out)
);

register pc
(
	.clk,
	.load(load_pc),
	.reset(1'b0),
	.in(branch_mux_out),
	.out(pc_out)
);

endmodule : fetch
