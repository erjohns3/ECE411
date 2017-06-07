/*
 * Memory Configuration
 */

import lc3b_types::*;
module memory_configuration
(
	input							clk,
	
	/* Main Memory signals */
	input							pmem_resp,
	input	l1_cache_line		pmem_rdata,
	
	output logic				pmem_read,
	output logic				pmem_write,
	output lc3b_word			pmem_address,
	output l1_cache_line		pmem_wdata,
	
	/* Internal Cache signals */
	input							mem_i_read,				mem_d_read,
	input							mem_i_write,			mem_d_write,
	input	lc3b_mem_wmask		mem_i_byte_enable,	mem_d_byte_enable,
	input	lc3b_word			mem_i_address,			mem_d_address,
	input lc3b_word			mem_i_wdata,			mem_d_wdata,
	
	output logic				mem_i_resp,				mem_d_resp,
	output lc3b_word			mem_i_rdata,			mem_d_rdata,
	
	output logic				icache_miss,			dcache_miss,			l2_miss,
	output logic				icache_hit,				dcache_hit,				l2_hit
);

/* internal signals */
logic								icache_arb_resp,		dcache_arb_resp;
logic								icache_arb_read,		dcache_arb_read;
logic								icache_arb_write,		dcache_arb_write;
lc3b_word						icache_arb_address,	dcache_arb_address;
l1_cache_line					icache_arb_wdata,		dcache_arb_wdata;
l1_cache_line					l1_arb_mem_rdata;

logic								l2_arb_resp;
logic								l2_arb_read;
logic								l2_arb_write;
lc3b_word						l2_arb_address;
l1_cache_line					l2_arb_wdata;
l1_cache_line					l2_arb_rdata;

logic								ewb_l2_resp;
logic								ewb_l2_read;
logic								ewb_l2_write;
lc3b_word						ewb_l2_address;
l1_cache_line					ewb_l2_rdata;
l1_cache_line					ewb_l2_wdata;

/* internal assignments */

/* Modules */
eviction_write_buffer eviction_write_buffer
(
	.clk,
	.pmem_resp,
	.source_read(ewb_l2_read),
	.source_write(ewb_l2_write),
	.source_addr(ewb_l2_address),
	.source_data(ewb_l2_wdata),
	.pmem_data(pmem_rdata),
	.out_resp(ewb_l2_resp),
	.ewb_read(pmem_read),
	.ewb_write(pmem_write),
	.ewb_addr(pmem_address),
	.ewb_data(pmem_wdata),
	.mem_data(ewb_l2_rdata)
);

cache_l2 l2_cache
(
	.clk,
	.pmem_resp(ewb_l2_resp),
	.pmem_rdata(ewb_l2_rdata),
	.mem_read(l2_arb_read),
	.mem_write(l2_arb_write),
	.mem_address(l2_arb_address),
	.mem_wdata(l2_arb_wdata),
	.mem_resp(l2_arb_resp),
	.mem_rdata(l2_arb_rdata),
	.pmem_read(ewb_l2_read),
	.pmem_write(ewb_l2_write),
	.pmem_address(ewb_l2_address),
	.pmem_wdata(ewb_l2_wdata),
	.perf_hit(l2_hit),
	.perf_miss(l2_miss)
);

arbiter arbiter
(
	.clk,
	.input_A_address(dcache_arb_address),
	.input_B_address(icache_arb_address),
	.input_A_wdata(dcache_arb_wdata),
	.input_B_wdata(icache_arb_wdata),
	.input_A_read(dcache_arb_read),
	.input_B_read(icache_arb_read),
	.input_A_write(dcache_arb_write),
	.input_B_write(icache_arb_write),
	.input_C_rdata(l2_arb_rdata),
	.input_C_resp(l2_arb_resp),
	.out_A_resp(dcache_arb_resp),
	.out_B_resp(icache_arb_resp),
	.out_AB_rdata(l1_arb_mem_rdata),
	.out_C_read(l2_arb_read),
	.out_C_write(l2_arb_write),
	.out_C_address(l2_arb_address),
	.out_C_wdata(l2_arb_wdata)
);

cache_l1 i_cache
(
	.clk,
	.pmem_resp(icache_arb_resp),
	.pmem_rdata(l1_arb_mem_rdata),
	.mem_read(mem_i_read),
	.mem_write(mem_i_write),
	.mem_byte_enable(mem_i_byte_enable),
	.mem_address(mem_i_address),
	.mem_wdata(mem_i_wdata),
	.mem_resp(mem_i_resp),
	.mem_rdata(mem_i_rdata),
	.pmem_read(icache_arb_read),
	.pmem_write(icache_arb_write),
	.pmem_address(icache_arb_address),
	.pmem_wdata(icache_arb_wdata),
	.perf_hit(icache_hit),
	.perf_miss(icache_miss)
);

cache_l1 d_cache
(
	.clk,
	.pmem_resp(dcache_arb_resp),
	.pmem_rdata(l1_arb_mem_rdata),
	.mem_read(mem_d_read),
	.mem_write(mem_d_write),
	.mem_byte_enable(mem_d_byte_enable),
	.mem_address(mem_d_address),
	.mem_wdata(mem_d_wdata),
	.mem_resp(mem_d_resp),
	.mem_rdata(mem_d_rdata),
	.pmem_read(dcache_arb_read),
	.pmem_write(dcache_arb_write),
	.pmem_address(dcache_arb_address),
	.pmem_wdata(dcache_arb_wdata),
	.perf_hit(dcache_hit),
	.perf_miss(dcache_miss)
);

endmodule : memory_configuration
