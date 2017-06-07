/*
 * Write Back Module
 */

import lc3b_types::*;
module write_back
(
	input								clk,
	input		lc3b_word			alu,
	input		lc3b_word			mem,
	input		lc3b_word			pc,
	input		lc3b_word			pc_offset,
	input		lc3b_control_word	ctrl,
	
	output	lc3b_nzp				cc_out,
	output	lc3b_word			out_data
);

/* internal signals */
lc3b_nzp		gencc_out;
/* internal assignments */

/* Modules */
mux4	regfile_mux
(
	.sel(ctrl.WB_sel_regfile_mux),
	.a(alu),
	.b(mem),
	.c(pc),
	.d(pc_offset),
	.f(out_data)
);

gencc gencc
(
	.in(out_data),
	.out(gencc_out)
);

register #(.width($bits(lc3b_nzp))) nzp_reg
(
	.clk(~clk),						// Transparent register, so MEM can branch if needed -- SLOW: fix later
	.load(ctrl.WB_load_cc),
	.reset(1'b0),
	.in(gencc_out),
	.out(cc_out)
);

endmodule : write_back
