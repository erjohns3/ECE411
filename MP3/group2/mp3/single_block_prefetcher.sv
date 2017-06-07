/*
 * Single Block Prefetcher 
 */

import lc3b_types::*;
module single_block_prefetcher
(
	input							clk,
	input							pmem_resp,
	input							source_read,
	input							source_write,
	input		lc3b_word		source_addr,
	input 	l1_cache_line	source_data,
	input		l1_cache_line	pmem_data,
	
	output	logic				out_resp,
	output	logic				sbp_read,
	output	logic				sbp_write,
	output	lc3b_word		sbp_addr,
	output	l1_cache_line	sbp_data,
	output	l1_cache_line	mem_data
);

/* internal signals */
logic					get_next, get_next_val;
logic					valid, valid_val;
logic					data_access, data_access_val;
lc3b_word			addr, addr_val;
l1_cache_line		data, data_val;


/* internal assignments */
initial begin
	get_next				= 0;
	valid					= 0;
	data_access			= 0;
	addr					= 0;
	data					= 0;
end

always_comb
begin
	/* Default assignments */
	out_resp					= 1'b0;
	sbp_read					= 1'b0;
	sbp_write				= 1'b0;
	sbp_addr					= source_addr;
	sbp_data					= source_data;
	mem_data					= pmem_data;
	
	/* Next State Logic Updaters */
	get_next_val			= get_next;
	valid_val				= valid;
	data_access_val		= data_access;
	addr_val					= addr;
	data_val					= data;
	
	/* Control Logic */
	/* Continue MEM access if required */
	if(data_access) begin
		if(get_next) begin
			sbp_read					= 1;
			sbp_addr					= addr;
			
			if(pmem_resp) begin
				get_next_val			= 0;
				valid_val				= 1;
				data_access_val		= 0;
				data_val					= pmem_data;
			end
		end
		else begin
			out_resp					= pmem_resp;
			sbp_read					= source_read;
			sbp_write				= source_write;
			
			if(pmem_resp) begin
				data_access_val		= 0;
				
				if(source_read) begin
					get_next_val			= 1;
					valid_val				= 0;
					addr_val					= addr + 16'h0010;
				end
			end
		end
	end
	
	/* If read */
	else if(source_read) begin
		if((source_addr == addr) & valid) begin	// Prefetch Hit
			out_resp					= 1;
			mem_data					= data;
			get_next_val			= 1;
			valid_val				= 0;
			addr_val					= addr + 16'h0010;
		end
		else begin
			out_resp					= pmem_resp;
			sbp_read					= 1;
			data_access_val		= 1;
			
			if(pmem_resp) begin
				valid_val				= 0;
				get_next_val			= 1;
				data_access_val		= 0;
				addr_val					= addr + 16'h0010;
			end		
		end
	end
	
	/* If write */
	else if(source_write) begin
		out_resp					= pmem_resp;
		sbp_write				= 1;
		data_access_val		= 1;
		
		if(pmem_resp) begin
			data_access_val		= 0;
		end
		
		if((source_addr == addr) & valid) begin	// Prefetch Hit		
			data_val					= source_data;
		end
	end
	
	/* Else prefetch if haven't down here to prevent starvation */
	else if(get_next) begin
		sbp_read					= 1;
		sbp_addr					= addr;
		data_access_val		= 1;
		
		if(pmem_resp) begin
			get_next_val			= 0;
			valid_val				= 1;
			data_val					= pmem_data;
		end
	end
	
end

always_ff @(posedge clk)
begin: store_data
	get_next			<= get_next_val;
	valid				<= valid_val;
	data_access		<= data_access_val;
	addr				<= addr_val;
	data				<= data_val;
end

endmodule : single_block_prefetcher
