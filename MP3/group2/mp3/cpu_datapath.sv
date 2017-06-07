/*
 * CPU data path
 */ 

import lc3b_types::*;
module cpu_datapath
(
	input								clk,
	input								icache_resp,			dcache_resp,
	input		lc3b_word			icache_rdata,			dcache_rdata,
	output							icache_read,			dcache_read,
	output							icache_write,			dcache_write,
	output	lc3b_mem_wmask		icache_byte_enable,	dcache_byte_enable,
	output	lc3b_word			icache_address,		dcache_address,
	output	lc3b_word			icache_wdata,			dcache_wdata,
	
	input								icache_miss,			dcache_miss,			l2_miss,
	input								icache_hit,				dcache_hit,				l2_hit
);

logic			load_all, skip_MEM, mem_confirm_skip, reset_registers;

/* internal signals for IF */
logic			load_IF_ID;
logic			IF_sel_branch_predict;
lc3b_word	IF_branch_predict_target;
lc3b_word 	IF_pc_out;
lc3b_word 	IF_ID_pc, IF_ID_ir;


/* internal signals for ID */
logic					load_ID_EX;
lc3b_reg				data_dest;
lc3b_word			ID_sr1, ID_sr2, ID_EX_sr1, ID_EX_sr2;
lc3b_word 			ID_EX_pc, ID_EX_ir;
lc3b_word			ID_FWD_sr1_out, ID_FWD_sr2_out;
lc3b_control_word	ID_ctrl_word, ID_EX_ctrl_word;

/* internal signals for EX */
logic					load_EX_MEM;
lc3b_word			EX_FWD_sr1_out;
lc3b_word			EX_FWD_sr2_out;
lc3b_word 			EX_MEM_pc;
lc3b_word			EX_MEM_ir;
lc3b_word			EX_alu_out, EX_MEM_alu;
lc3b_word			EX_pc_offset, EX_MEM_pc_offset;
lc3b_control_word	EX_MEM_ctrl_word;

/* internal signals for MEM */
logic					MEM_mem_op_complete;
logic					load_MEM_WB;
logic					load_MEM_mdr;
logic					load_MEM_mar;
logic					branch;
logic					valid_branch;
logic					MEM_branch_miss;
logic					MEM_sel_mar_mux;
logic					MEM_sel_mdr_mux;
lc3b_word			MEM_mdr_mux_out;
lc3b_word			MEM_mar_mux_out;
lc3b_word			MEM_mem_out;
lc3b_word			MEM_WB_ir;
lc3b_word 			MEM_WB_pc;
lc3b_word			MEM_WB_alu;
lc3b_word			MEM_WB_pc_offset;
lc3b_word			MEM_WB_mem_out;
lc3b_control_word MEM_out_ctrl_word;
lc3b_control_word MEM_WB_ctrl_word;

/* internal signals for forwarding */
logic					FWD_sel_ID_sr1_mux;
logic					FWD_sel_ID_sr2_mux;
logic					FWD_sel_EX_sr1_mux;
logic					FWD_sel_EX_sr2_mux;
lc3b_word			FWD_ID_sr1_data;
lc3b_word			FWD_ID_sr2_data;
lc3b_word			FWD_EX_sr1_data;
lc3b_word			FWD_EX_sr2_data;

lc3b_word			MEM_PASS_ir_out;
lc3b_word			MEM_PASS_alu_out;
lc3b_word			MEM_PASS_pc_out;
lc3b_word			MEM_PASS_pc_offset_out;
lc3b_control_word	MEM_PASS_ctrl_word_out;

/* internal signals for WB */
lc3b_nzp				WB_cc;
lc3b_word			WB_data;

/* internal signals for counters */
logic					counter_read;
logic					counter_reset;
lc3b_word			counter_address;
lc3b_word			counter_data;
lc3b_word			c0_data,	 c1_data,  c2_data,  c3_data,  c4_data,  c5_data,  c6_data,  c7_data,
						c8_data,  c9_data,  ca_data;
logic					c0_reset, c1_reset, c2_reset, c3_reset, c4_reset, c5_reset, c6_reset, c7_reset,
						c8_reset, c9_reset, ca_reset;

/* internal assignments for IF */
assign load_IF_ID = load_all | skip_MEM;
assign icache_byte_enable = 2'b11;
assign icache_read = 1;
assign icache_write = 0;
assign icache_wdata = 16'h0;

/* internal assignments for ID */
assign load_ID_EX = load_all | skip_MEM;
assign data_dest = MEM_WB_ir[11:9];

/* internal assignments for EX */
assign load_EX_MEM = load_all;

/* internal assignments for MEM */
assign load_MEM_WB = load_all | skip_MEM;
assign valid_branch = EX_MEM_ctrl_word.opcode == op_br && EX_MEM_ctrl_word.MEM_branch;
assign MEM_branch_miss = valid_branch & ~branch;

/* internal signals for memory response watchers and register reset*/
assign load_all = icache_resp & MEM_mem_op_complete;
assign skip_MEM = icache_resp & mem_confirm_skip;
assign reset_registers = MEM_branch_miss | (EX_MEM_ctrl_word.opcode == op_jsr || EX_MEM_ctrl_word.opcode == op_jmp || EX_MEM_ctrl_word.opcode == op_trap);

/*
 * Instruction Fetch + IF_ID
 */

fetch if_block
(
	.clk,
	.branch_miss(MEM_branch_miss),
	.branch_prediction(IF_sel_branch_predict),
	.load_pc(load_IF_ID),
	.pc_offset(EX_MEM_pc_offset),
	.pc_reset(EX_MEM_pc),
	.pc_new_out(IF_pc_out),
	.mem_val(dcache_rdata),
	.br_predict(IF_branch_predict_target),
	.ctrl(EX_MEM_ctrl_word),
	.icache_address
);

branch_prediction	branch_prediction
(
	.ir(icache_rdata),
	.pc(IF_pc_out),
	.sel_branch_predict(IF_sel_branch_predict),
	.branch_target(IF_branch_predict_target)
);

register IF_ID_pc_reg
(
	.clk,
	.load(load_IF_ID),
	.reset(reset_registers),
	.in(IF_pc_out),
	.out(IF_ID_pc)
);

register IF_ID_ir_reg
(
	.clk,
	.load(load_IF_ID),
	.reset(reset_registers),
	.in(icache_rdata),
	.out(IF_ID_ir)
);

/*
 * Instruction Decode + ID_EX
 */

decode id_block
(
	.clk,
	.dest(data_dest),
	.data(WB_data),
	.ir(IF_ID_ir),
	.ctrl_in(MEM_WB_ctrl_word),
	.sr1_out(ID_sr1),
	.sr2_out(ID_sr2),
	.ctrl_out(ID_ctrl_word)
);

/* FWDing Muxes */
mux2 ID_FWD_sr1
(
	.sel(FWD_sel_ID_sr1_mux),
	.a(ID_sr1),
	.b(FWD_ID_sr1_data),
	.f(ID_FWD_sr1_out)
);

mux2 ID_FWD_sr2
(
	.sel(FWD_sel_ID_sr2_mux),
	.a(ID_sr2),
	.b(FWD_ID_sr2_data),
	.f(ID_FWD_sr2_out)
);

register ID_EX_pc_reg
(
	.clk,
	.load(load_ID_EX),
	.reset(reset_registers),
	.in(IF_ID_pc),
	.out(ID_EX_pc)
);

register ID_EX_ir_reg
(
	.clk,
	.load(load_ID_EX),
	.reset(reset_registers),
	.in(IF_ID_ir),
	.out(ID_EX_ir)
);

register ID_EX_sr1_reg
(
	.clk,
	.load(load_ID_EX),
	.reset(reset_registers),
	.in(ID_FWD_sr1_out),
	.out(ID_EX_sr1)
);

register ID_EX_sr2_reg
(
	.clk,
	.load(load_ID_EX),
	.reset(reset_registers),
	.in(ID_FWD_sr2_out),
	.out(ID_EX_sr2)
);

register #(.width($bits(lc3b_control_word))) ID_EX_control_word
(
	.clk,
	.load(load_ID_EX),
	.reset(reset_registers),
	.in(ID_ctrl_word),
	.out(ID_EX_ctrl_word)
);

/*
 * Execute + EX_MEM
 */
 
/* FWDing Muxes */
mux2 EX_FWD_sr1
(
	.sel(FWD_sel_EX_sr1_mux),
	.a(ID_EX_sr1),
	.b(FWD_EX_sr1_data),
	.f(EX_FWD_sr1_out)
);

mux2 EX_FWD_sr2
(
	.sel(FWD_sel_EX_sr2_mux),
	.a(ID_EX_sr2),
	.b(FWD_EX_sr2_data),
	.f(EX_FWD_sr2_out)
);

/* Execute */
execute ex_block
(
	.ir(ID_EX_ir),
	.pc(ID_EX_pc),
	.sr1(EX_FWD_sr1_out),
	.sr2(EX_FWD_sr2_out),
	.ctrl(ID_EX_ctrl_word),
	.alu_out(EX_alu_out),
	.pc_offset(EX_pc_offset)	
);

register EX_MEM_ir_reg
(
	.clk,
	.load(load_EX_MEM),
	.reset(reset_registers),
	.in(ID_EX_ir),
	.out(EX_MEM_ir)
);

register EX_MEM_pc_reg
(
	.clk,
	.load(load_EX_MEM),
	.reset(reset_registers),
	.in(ID_EX_pc),
	.out(EX_MEM_pc)
);

register EX_MEM_alu_reg
(
	.clk,
	.load(load_EX_MEM),
	.reset(reset_registers),
	.in(EX_alu_out),
	.out(EX_MEM_alu)
);

register EX_MEM_pc_offset_reg
(
	.clk,
	.load(load_EX_MEM),
	.reset(reset_registers),
	.in(EX_pc_offset),
	.out(EX_MEM_pc_offset)
);

register #(.width($bits(lc3b_control_word))) EX_MEM_control_word
(
	.clk,
	.load(load_EX_MEM),
	.reset(reset_registers),
	.in(ID_EX_ctrl_word),
	.out(EX_MEM_ctrl_word)
);

/*
 * MDR + MAR
 */
 
mux2 MEM_mdr_mux
(
	.sel(MEM_sel_mdr_mux),
	.a(EX_FWD_sr2_out),
	.b({EX_FWD_sr2_out[7:0], EX_FWD_sr2_out[7:0]}),
	.f(MEM_mdr_mux_out)
);

register MEM_mdr_reg
(
	.clk,
	.load(load_MEM_mdr),
	.reset(1'b0),
	.in(MEM_mdr_mux_out),
	.out(dcache_wdata)
);

mux2 MEM_mar_mux
(
	.sel(MEM_sel_mar_mux),
	.a(EX_alu_out),
	.b(dcache_rdata),
	.f(MEM_mar_mux_out)
);

register MEM_mar_reg
(
	.clk,
	.load(load_MEM_mar),
	.reset(1'b0),
	.in(MEM_mar_mux_out),
	.out(dcache_address)
);

/*
 * Memory + MEM_WB
 */

memory_interface mem_block
(
	.clk,
	.dcache_resp,
	.load_all,
	.cc(WB_cc),
	.ir(EX_MEM_ir),
	.upcoming_ir(ID_EX_ir),
	.addr(EX_MEM_alu),
	.dcache_rdata,
	.counter_data,
	.ctrl(EX_MEM_ctrl_word),
	.upcoming_ctrl(ID_EX_ctrl_word),
	.mem_confirm_skip,
	.mem_op_complete(MEM_mem_op_complete),
	.load_MEM_mdr,
	.load_MEM_mar,
	.branch_enable(branch),
	.MEM_sel_mdr_mux,
	.MEM_sel_mar_mux,
	.counter_reset,
	.dcache_read,
	.dcache_write,
	.dcache_byte_enable,
	.memory_output(MEM_mem_out),
	.counter_address,
	.ctrl_out(MEM_out_ctrl_word)
);

forwarding_unit forwarder
(
	.D_ctrl(ID_ctrl_word),
	.E_ctrl(ID_EX_ctrl_word),
	.M_ctrl(EX_MEM_ctrl_word),
	.D_ir(IF_ID_ir),
	.E_ir(ID_EX_ir),
	.M_ir(EX_MEM_ir),
	.EX_alu(EX_alu_out),
	.EX_pc(ID_EX_pc),
	.EX_pc_offset(EX_pc_offset),
	.MEM_alu(EX_MEM_alu),
	.MEM_pc(EX_MEM_pc),
	.MEM_pc_offset(EX_MEM_pc_offset),
	.MEM_mem(MEM_mem_out),
	.FWD_sel_ID_sr1_mux,
	.FWD_sel_ID_sr2_mux,
	.FWD_sel_EX_sr1_mux,
	.FWD_sel_EX_sr2_mux,	
	.FWD_ID_sr1_data,
	.FWD_ID_sr2_data,
	.FWD_EX_sr1_data,
	.FWD_EX_sr2_data
);

mux2 MEM_PASS_ir
(
	.sel(skip_MEM),
	.a(EX_MEM_ir),
	.b(ID_EX_ir),
	.f(MEM_PASS_ir_out)
);

register MEM_WB_ir_reg
(
	.clk,
	.load(load_MEM_WB),
	.reset(1'b0),
	.in(MEM_PASS_ir_out),
	.out(MEM_WB_ir)
);

mux2 MEM_PASS_pc
(
	.sel(skip_MEM),
	.a(EX_MEM_pc),
	.b(ID_EX_pc),
	.f(MEM_PASS_pc_out)
);

register MEM_WB_pc_reg
(
	.clk,
	.load(load_MEM_WB),
	.reset(1'b0),
	.in(MEM_PASS_pc_out),
	.out(MEM_WB_pc)
);

mux2 MEM_PASS_alu
(
	.sel(skip_MEM),
	.a(EX_MEM_alu),
	.b(EX_alu_out),
	.f(MEM_PASS_alu_out)
);

register MEM_WB_alu_reg
(
	.clk,
	.load(load_MEM_WB),
	.reset(1'b0),
	.in(MEM_PASS_alu_out),
	.out(MEM_WB_alu)
);

mux2 MEM_PASS_pc_offset
(
	.sel(skip_MEM),
	.a(EX_MEM_pc_offset),
	.b(EX_pc_offset),
	.f(MEM_PASS_pc_offset_out)
);

register MEM_WB_pc_offset_reg
(
	.clk,
	.load(load_MEM_WB),
	.reset(1'b0),
	.in(MEM_PASS_pc_offset_out),
	.out(MEM_WB_pc_offset)
);

register MEM_WB_dcache_val
(
	.clk,
	.load(load_MEM_WB),
	.reset(1'b0),
	.in(MEM_mem_out),
	.out(MEM_WB_mem_out)
);

mux2 #(.width($bits(lc3b_control_word))) MEM_PASS_ctrl_word
(
	.sel(skip_MEM),
	.a(MEM_out_ctrl_word),
	.b(ID_EX_ctrl_word),
	.f(MEM_PASS_ctrl_word_out)
);

register #(.width($bits(lc3b_control_word))) MEM_WB_control_word
(
	.clk,
	.load(load_MEM_WB),
	.reset(1'b0),
	.in(MEM_PASS_ctrl_word_out),
	.out(MEM_WB_ctrl_word)
);

/*
 * Write Back
 */
 
write_back wb_block
(
	.clk,
	.alu(MEM_WB_alu),
	.mem(MEM_WB_mem_out),
	.pc(MEM_WB_pc),
	.pc_offset(MEM_WB_pc_offset),
	.ctrl(MEM_WB_ctrl_word),
	.cc_out(WB_cc),
	.out_data(WB_data)
);

/*
 * Performance Counters
 */
perf_counter_selector counter_selector
(
	.counter_reset,
	.counter_address,
	.counter_data,
	.c0_data,
	.c0_reset,
	.c1_data,
	.c1_reset,
	.c2_data,
	.c2_reset,
	.c3_data,
	.c3_reset,
	.c4_data,
	.c4_reset,
	.c5_data,
	.c5_reset,
	.c6_data,
	.c6_reset,
	.c7_data,
	.c7_reset,
	.c8_data,
	.c8_reset,
	.c9_data,
	.c9_reset,
	.ca_data,
	.ca_reset
); 

perf_counter counter_br_miss										// 0 0xFFE0
(
	.clk,
	.accumulate(MEM_branch_miss & load_all),
	.reset(c0_reset),
	.total(c0_data)
); 
 
perf_counter counter_br_total										// 2 0xFFE2
(
	.clk,
	.accumulate(valid_branch & load_all),
	.reset(c1_reset),
	.total(c1_data)
);

perf_counter counter_icache_miss_total							// 4 0xFFE4
(
	.clk,
	.accumulate(icache_miss),
	.reset(c2_reset),
	.total(c2_data)
);

perf_counter counter_icache_total								// 6 0xFFE6
(
	.clk,
	.accumulate(icache_hit),
	.reset(c3_reset),
	.total(c3_data)
);

perf_counter counter_dcache_miss_total							// 8 0xFFE8
(
	.clk,
	.accumulate(dcache_miss),
	.reset(c4_reset),
	.total(c4_data)
);

perf_counter counter_dcache_total								// A 0xFFEA
(
	.clk,
	.accumulate(dcache_hit),
	.reset(c5_reset),
	.total(c5_data)
);

perf_counter counter_l2cache_miss_total						// C 0xFFEC
(
	.clk,
	.accumulate(l2_miss),
	.reset(c6_reset),
	.total(c6_data)
);

perf_counter counter_l2cache_total								// E 0xFFEE
(
	.clk,
	.accumulate(l2_hit),
	.reset(c7_reset),
	.total(c7_data)
);

perf_counter counter_total_cycles								// 10 0xFFF0
(
	.clk,
	.accumulate(clk),
	.reset(c8_reset),
	.total(c8_data)
);

perf_counter counter_MEM_stall									// 12 0xFFF2
(
	.clk,
	.accumulate(skip_MEM & ~load_all),
	.reset(c9_reset),
	.total(c9_data)
);

perf_counter counter_total_full_load							// 14 0xFFF4
(
	.clk,
	.accumulate(load_all),
	.reset(ca_reset),
	.total(ca_data)
);

endmodule : cpu_datapath
