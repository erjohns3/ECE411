import lc3b_types::*;

module mp3
(
	input clk,

	/* Memory signals */
	input							pmem_resp,
	input	l1_cache_line		pmem_rdata,
	
	output logic				pmem_read,
	output logic				pmem_write,
	output lc3b_word			pmem_address,
	output l1_cache_line		pmem_wdata
);

logic				mem_i_resp,				mem_d_resp;
lc3b_word		mem_i_rdata,			mem_d_rdata;
logic				mem_i_read,				mem_d_read;
logic				mem_i_write,			mem_d_write;
lc3b_mem_wmask	mem_i_byte_enable,	mem_d_byte_enable;
lc3b_word		mem_i_address,			mem_d_address;
lc3b_word		mem_i_wdata,			mem_d_wdata;
logic				icache_hit,				dcache_hit,			l2_hit;
logic				icache_miss,			dcache_miss,		l2_miss;

/* Instantiate MP3 top level blocks here */
cpu_datapath cpu
(
	.clk(clk),
	.icache_resp(mem_i_resp),
	.icache_rdata(mem_i_rdata),
	.icache_read(mem_i_read),
	.icache_write(mem_i_write),
	.icache_byte_enable(mem_i_byte_enable),
	.icache_address(mem_i_address),
	.icache_wdata(mem_i_wdata),
	
	.dcache_resp(mem_d_resp),
	.dcache_rdata(mem_d_rdata),
	.dcache_read(mem_d_read),
	.dcache_write(mem_d_write),
	.dcache_byte_enable(mem_d_byte_enable),
	.dcache_address(mem_d_address),
	.dcache_wdata(mem_d_wdata),
	
	.icache_miss,
	.icache_hit,
	.dcache_miss,
	.dcache_hit,
	.l2_miss,
	.l2_hit
);

memory_configuration memory_conf
(
	.clk,
	.pmem_resp,
	.pmem_rdata,
	.pmem_read,
	.pmem_write,
	.pmem_address,
	.pmem_wdata,
	.mem_i_read,
	.mem_i_write,
	.mem_i_byte_enable,
	.mem_i_address,
	.mem_i_wdata,
	.mem_i_resp,
	.mem_i_rdata,
	.mem_d_read,
	.mem_d_write,
	.mem_d_byte_enable,
	.mem_d_address,
	.mem_d_wdata,
	.mem_d_resp,
	.mem_d_rdata,
	.icache_miss,
	.icache_hit,
	.dcache_miss,
	.dcache_hit,
	.l2_miss,
	.l2_hit
);

endmodule : mp3
