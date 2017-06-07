import lc3b_types::*;

module cache_l1
(
	input							clk,

    /* Memory signals */
	input							pmem_resp,
	input	l1_cache_line		pmem_rdata,

	input							mem_read,
	input							mem_write,
	input lc3b_mem_wmask		mem_byte_enable,
	input lc3b_word			mem_address,
	input lc3b_word			mem_wdata,
	
	output						mem_resp,
	output lc3b_word			mem_rdata,
	
	output						pmem_read,
	output						pmem_write,
	output lc3b_word			pmem_address,
	output l1_cache_line		pmem_wdata,
	
	output logic				perf_hit,
	output logic				perf_miss
);

/* internal signals */
logic								load_lru, load_data0, load_data1,
									load_tag0, load_tag1, load_valid0, load_valid1,
									load_dirty0, load_dirty1, dirty_load_val,
									hit0, hit1, lru_out, dirty0_val, dirty1_val,
									write_mux_sel;
logic					[1:0]		pmem_address_mux_sel;

/* internal assignments */
assign perf_hit = (hit0 | hit1) & (mem_read | mem_write);
assign perf_miss = pmem_resp & pmem_read;

/* modules */
cache_l1_control cache_l1_controller
(
	.*
);


cache_l1_datapath cache_l1_datapath
(
	.*
);

endmodule : cache_l1
