/*
 * Memory Interface Module
 */

import lc3b_types::*;
module memory_interface
(
	input		logic					clk,
	input		logic					dcache_resp,
	input		logic					load_all,
	input		lc3b_nzp				cc,
	input		lc3b_word			ir,
	input		lc3b_word			upcoming_ir,
	input		lc3b_word			addr,
	input		lc3b_word			dcache_rdata,
	input		lc3b_word			counter_data,
	input		lc3b_control_word ctrl,
	input		lc3b_control_word	upcoming_ctrl,
	
	output	logic					mem_confirm_skip,
	output	logic					mem_op_complete,
	output	logic					load_MEM_mdr,
	output	logic					load_MEM_mar,
	output	logic					MEM_sel_mar_mux,
	output	logic					MEM_sel_mdr_mux,
	output	logic					branch_enable,
	output	logic					counter_reset,
	output	logic					dcache_read,
	output	logic					dcache_write,
	output	lc3b_mem_wmask		dcache_byte_enable,
	output	lc3b_word			memory_output,
	output	lc3b_word			counter_address,
	output	lc3b_control_word ctrl_out
);

/* internal signals */
logic			cccomp_out;
logic			load_second_mem_op;
logic			second_mem_op_out;
logic			two_mem_ops;
logic			load_skip_cc;
logic			skip_cc_out;
logic			counter_read;
lc3b_nzp		nzp;
lc3b_word	zext_mux_out;
lc3b_word	mem_70_zext, mem_158_zext;

/* internal assignments */
assign nzp						= ir[11:9];
assign branch_enable			= cccomp_out & ctrl.MEM_branch;
assign two_mem_ops			= ctrl.opcode == op_sti | ctrl.opcode == op_ldi;
assign mem_70_zext			= $unsigned(dcache_rdata[7:0]);
assign mem_158_zext			= $unsigned(dcache_rdata[15:8]);
assign counter_address		= addr - 16'hFFE0;


always_comb
begin
	/* Default output assignments */
	dcache_byte_enable = 2'b11;
	MEM_sel_mdr_mux 		= 0;
	MEM_sel_mar_mux 		= 0;
	load_MEM_mdr 			= 0;
	load_MEM_mar 			= 0;
	load_skip_cc			= 0;
	mem_confirm_skip		= 0;
	mem_op_complete 		= 0;
	counter_read			= 0;
	counter_reset			= 0;
	dcache_read				= ctrl.dcache_read;
	dcache_write			= ctrl.dcache_write;
	ctrl_out					= ctrl;
	
	if(load_all) begin
		load_MEM_mdr 			= 1;
		load_MEM_mar 			= 1;
	end
	
	if(dcache_resp | ~(ctrl.dcache_read | ctrl.dcache_write)) begin
		mem_op_complete		= 1;
	end
	
	if(ctrl.opcode == op_ldr && addr >= 16'hFFE0) begin	// Read from Counter
		mem_op_complete		= 1;
		dcache_read				= 0;
		dcache_write			= 0;
		counter_read			= 1;
	end
	
	if(ctrl.opcode == op_str && addr >= 16'hFFE0) begin	// Reset Counter
		mem_op_complete		= 1;
		dcache_read				= 0;
		dcache_write			= 0;
		counter_reset			= 1;
	end
	
	if(upcoming_ctrl.opcode == op_stb) begin
		MEM_sel_mdr_mux = 1;
	end
	
	if(ctrl.opcode == op_stb) begin
		if(addr[0]) begin
			dcache_byte_enable = 2'b10;
		end
		else begin
			dcache_byte_enable = 2'b01;
		end
	end
	else if(two_mem_ops) begin
		mem_op_complete = 0;
		if(second_mem_op_out) begin		// Second Pass		
			if(dcache_resp) begin
				mem_op_complete = 1;
			end
		end
		else begin			// First (Read)
			dcache_read = 1;
			dcache_write = 0;
			if(dcache_resp) begin
				MEM_sel_mar_mux = 1;
				load_MEM_mar 	= 1;
			end
		end
	end
	
	/* Generate Logic to Skip MEM */
	if(ctrl.dcache_write && ~mem_op_complete) begin
		mem_confirm_skip = 1;
	end
	else if(ctrl.dcache_read && ~mem_op_complete) begin
		if(ir[11:9] != upcoming_ir[8:6] && ir[11:9] != upcoming_ir[11:9]) begin		// Check SR1 and DR (Can do additional logic to skip if DR later)
			if(upcoming_ir[5] || (ir[11:9] != upcoming_ir[2:0])) begin		// Check SR2 or bit5
				mem_confirm_skip = 1;
			end
		end
	end
	
	if(upcoming_ctrl.dcache_read | upcoming_ctrl.dcache_write | upcoming_ctrl.MEM_branch | upcoming_ctrl.IF_sel_pc_mux != 2'b00 | ctrl.IF_sel_pc_mux != 2'b00) begin
		mem_confirm_skip = 0;
	end
	
	// If the one that skips over MEM loads cc, don't load CC on current waiting operation
	if((mem_confirm_skip & upcoming_ctrl.WB_load_cc) | skip_cc_out) begin
		ctrl_out.WB_load_cc = 0;
		load_skip_cc = 1;
	end
end

/* Modules */
cccomp cccomp
(
	.a(nzp),
	.b(cc),
	.f(cccomp_out)
);


register #(.width(1)) second_mem_op
(
	.clk,
	.load(dcache_resp & two_mem_ops),
	.reset(load_all),
	.in(1'b1),
	.out(second_mem_op_out)
);

register #(.width(1)) skip_cc
(
	.clk,
	.load(load_skip_cc),
	.reset(load_all),
	.in(1'b1),
	.out(skip_cc_out)
);

mux2 zext_mux
(
	.sel(addr[0]),		// if Address is odd, select 15:8
	.a(mem_70_zext),
	.b(mem_158_zext),
	.f(zext_mux_out)
);

mux4 mem_out_mux
(
	.sel({counter_read, ctrl.opcode == op_ldb}),
	.a(dcache_rdata),
	.b(zext_mux_out),
	.c(counter_data),
	.d(counter_data),
	.f(memory_output)
);


endmodule : memory_interface
