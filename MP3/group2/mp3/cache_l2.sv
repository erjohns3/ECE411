import lc3b_types::*;

module cache_l2
(
	input							clk,

    /* Memory signals */
	input							pmem_resp,
	input	l1_cache_line		pmem_rdata,

	input							mem_read,
	input							mem_write,
	input lc3b_word			mem_address,
	input l1_cache_line		mem_wdata,
	
	output						mem_resp,
	output l1_cache_line		mem_rdata,
	
	output						pmem_read,
	output						pmem_write,
	output lc3b_word			pmem_address,
	output l1_cache_line		pmem_wdata,
	
	output logic				perf_hit,
	output logic				perf_miss
);

/* internal signals */
logic			load_lru, 
				load_data0, load_data1, load_data2, load_data3,
				load_tag0, load_tag1, load_tag2, load_tag3,
				load_valid0, load_valid1, load_valid2, load_valid3,
				load_dirty0, load_dirty1, load_dirty2, load_dirty3,
				dirty_load_val;
logic			input_mux_sel;
logic [1:0]	data_mux_sel;
logic [2:0]	pmem_address_mux_sel;

logic			hit0, hit1, hit2, hit3, dirty0_val, dirty1_val, dirty2_val, dirty3_val;
logic [1:0]	lru_val;

/* internal assignments */
assign perf_hit = (hit0 | hit1 | hit2 | hit3) & (mem_read | mem_write);
assign perf_miss = pmem_resp & pmem_read;

/* modules */
cache_l2_control cache_l2_controller
(
	.*
);


cache_l2_datapath cache_l2_datapath
(
	.*
);

endmodule : cache_l2
