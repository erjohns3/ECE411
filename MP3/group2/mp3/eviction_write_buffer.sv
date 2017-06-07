/*
 * Eviction Write Buffer (NOTE: SINGLE ENTRY)
 */

import lc3b_types::*;
module eviction_write_buffer
(
	input							clk,
	input							pmem_resp,
	input							source_read,
	input							source_write,
	input		lc3b_word		source_addr,
	input 	l1_cache_line	source_data,
	input		l1_cache_line	pmem_data,
	
	output	logic				out_resp,
	output	logic				ewb_read,
	output	logic				ewb_write,
	output	lc3b_word		ewb_addr,
	output	l1_cache_line	ewb_data,
	output	l1_cache_line	mem_data
);

/* internal signals */
logic					dirty, dirty_val;
logic					writing_to_mem, writing_to_mem_val;
lc3b_word			addr, addr_val;
l1_cache_line		data, data_val;


/* internal assignments */
initial begin
	dirty					= 0;
	writing_to_mem		= 0;
	addr					= 0;
	data					= 0;
end

always_comb
begin
	/* Default assignments */
	out_resp					= 1'b0;
	ewb_read					= 1'b0;
	ewb_write				= 1'b0;
	ewb_addr					= source_addr;
	ewb_data					= data;
	mem_data					= pmem_data;
	
	/* Next State Logic Updaters */
	dirty_val				= dirty;
	writing_to_mem_val	= writing_to_mem;
	addr_val					= addr;
	data_val					= data;
	
	/* Control Logic */
	/* Read if prompted */
	if(~writing_to_mem & source_read) begin
		if(source_addr == addr & dirty) begin
			out_resp					= 1;
			mem_data					= data;
		end 
		else begin
			out_resp					= pmem_resp;
			ewb_read					= 1;
		end
	end
	
	/* Store Incoming Data if w and not dirty and not writing to mem ;; READ=0 HERE */
	else if(~writing_to_mem & source_write & ~dirty) begin
		out_resp					= 1;
		dirty_val				= 1;
		addr_val					= source_addr; 
		data_val					= source_data;
	end
	
	/* Write stored data if dirty (also includes writing to mem) ;; READ = 0 HERE */
	else if(dirty) begin
		ewb_write				= 1;
		ewb_addr					= addr;
		writing_to_mem_val	= 1;
		if(pmem_resp) begin
			writing_to_mem_val	= 0;
			dirty_val				= 0;
		end
	end
	
end

always_ff @(posedge clk)
begin: store_data
	dirty				<= dirty_val;
	writing_to_mem <= writing_to_mem_val;
	addr				<= addr_val;
	data				<= data_val;
end

endmodule : eviction_write_buffer
