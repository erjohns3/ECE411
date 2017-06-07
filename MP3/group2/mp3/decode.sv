/*
 * Instruction Decode Module
 */

import lc3b_types::*;
module decode
(
	input								clk,
	input		lc3b_reg				dest,
	input		lc3b_word			data,
	input		lc3b_word			ir,
	input		lc3b_control_word	ctrl_in,

	output	lc3b_word			sr1_out,
	output	lc3b_word			sr2_out,
	output	lc3b_control_word	ctrl_out
);

/* internal signals */
lc3b_reg		new_dest, sr1, sr2;
lc3b_reg		sr1_store_reg_mux_out, sr2_store_reg_mux_out, r7_reg_mux_out;
lc3b_opcode	opcode;

/* internal assignments */
assign	opcode	= lc3b_opcode'(ir[15:12]);
assign	new_dest = ir[11:9];
assign	sr1		= ir[8:6];
assign	sr2		= ir[2:0];

/* Modules */
mux2 #(.width($bits(lc3b_reg))) r7_reg_mux
(
	.sel(ctrl_in.ID_r7_reg_mux),
	.a(dest),
	.b(3'b111),
	.f(r7_reg_mux_out)
);

mux4 #(.width($bits(lc3b_reg))) sr1_store_reg_mux
(
	.sel(ctrl_out.ID_sr1_sel_store_reg_mux),
	.a(sr1),
	.b(new_dest),
	.c(sr2),
	.d(3'b000),
	.f(sr1_store_reg_mux_out)
);

mux4 #(.width($bits(lc3b_reg))) sr2_store_reg_mux
(
	.sel(ctrl_out.ID_sr2_sel_store_reg_mux),
	.a(sr2),
	.b(new_dest),
	.c(sr1),
	.d(3'b000),
	.f(sr2_store_reg_mux_out)
);

regfile regfile
(
	.clk,
	.load(ctrl_in.ID_load_regfile),
	.in(data),
	.src_a(sr1_store_reg_mux_out),
	.src_b(sr2_store_reg_mux_out),
	.dest(r7_reg_mux_out),
	.reg_a(sr1_out),
	.reg_b(sr2_out)
);

control_rom	control_gen
(
	.opcode,
	.valid(ir != 16'h0),
	.bit11(ir[11]),
	.bit5(ir[5]),
	.bit4(ir[4]),
	.ctrl(ctrl_out)
);

endmodule : decode
