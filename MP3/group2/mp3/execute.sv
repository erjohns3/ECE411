/*
 * Execute Module
 */

import lc3b_types::*;
module execute
(
	input		lc3b_word			ir,
	input		lc3b_word			pc,
	input		lc3b_word			sr1,
	input		lc3b_word			sr2,
	input		lc3b_control_word ctrl,

	output	lc3b_word			alu_out,
	output	lc3b_word			pc_offset
);

/* internal signals */
lc3b_word		alu_mux_out, pc_offset_mux_out, pc_zero_mux_out;
lc3b_word		adj11, adj9, adj6, sext6, sext5, imm4_zext, trap_vector;

lc3b_offset11	offset11;
lc3b_trapvect8	trapvect8;
lc3b_offset9	offset9;
lc3b_offset6	offset6;
lc3b_imm5		imm5;
lc3b_imm4		imm4;

/* internal assignments */
assign	offset11		=	ir[10:0];
assign	offset9		=	ir[8:0];
assign	trapvect8	=	ir[7:0];
assign	offset6		=	ir[5:0];
assign	imm5			=	ir[4:0];
assign	imm4			=	ir[3:0];

assign	pc_offset	= pc_zero_mux_out + pc_offset_mux_out;

/* Sign / Shift assignments */
assign adj11 			=	$signed({offset11, 1'b0});		// adj[n] =  SEXT[offset-n << 1]
assign adj9 			=	$signed({offset9, 1'b0});
assign trap_vector	=	$unsigned({trapvect8, 1'b0});
assign adj6 			=	$signed({offset6, 1'b0});
assign sext6			=	$signed(offset6);
assign sext5			=	$signed(imm5);
assign imm4_zext		=	$unsigned(imm4);

/* Modules */
mux8 alu_mux
(
	.sel(ctrl.EX_sel_alu_mux),
	.a(sr2),
	.b(adj6),
	.c(sext5),
	.d(sext6),
	.e(imm4_zext),
	.f(trap_vector),
	.g(16'h0),
	.h(16'h0),
	.o(alu_mux_out)
);

alu alu
(
	.aluop(ctrl.aluop),
	.a(sr1),
	.b(alu_mux_out),
	.f(alu_out)
);

mux4 pc_offset_mux
(
	.sel(ctrl.EX_sel_pc_offset_mux),
	.a(adj9),
	.b(adj11),
	.c(sr1),
	.d(16'h0),
	.f(pc_offset_mux_out)
);

mux2 pc_zero_mux
(
	.sel(ctrl.EX_sel_pc_zero_mux),
	.a(pc),
	.b(16'h0),
	.f(pc_zero_mux_out)
);

endmodule : execute
