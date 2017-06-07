import lc3b_types::*;

module cache_l2_control
(
	input						clk,
	
	input						pmem_resp,
	input						mem_read,
	input						mem_write,
	
	input						hit0, hit1, hit2, hit3,
								dirty0_val, dirty1_val, dirty2_val, dirty3_val,
	input [1:0]				lru_val,
								

	output logic			load_lru, 
								load_data0, load_data1, load_data2, load_data3,
								load_tag0, load_tag1, load_tag2, load_tag3,
								load_valid0, load_valid1, load_valid2, load_valid3,
								load_dirty0, load_dirty1, load_dirty2, load_dirty3,
								dirty_load_val,
								
	output logic			input_mux_sel,
	output logic [1:0]	data_mux_sel,
	output logic [2:0]	pmem_address_mux_sel,
								
	output logic			mem_resp,
	output logic			pmem_read,
	output logic			pmem_write
);

enum int unsigned {
	/* List of states */
	standby, read_from_memory, write_to_memory
} state, next_state;

logic hit;
assign hit = hit0 || hit1 || hit2 || hit3;

always_comb
begin : state_actions
	/* Default output assignments */
	load_lru					= 0;
	load_data0				= 0;
	load_data1				= 0;
	load_data2				= 0;
	load_data3				= 0;
	load_tag0				= 0;
	load_tag1				= 0;
	load_tag2				= 0;
	load_tag3				= 0;
	load_valid0				= 0;
	load_valid1				= 0;
	load_valid2				= 0;
	load_valid3				= 0;
	load_dirty0				= 0;
	load_dirty1				= 0;
	load_dirty2				= 0;
	load_dirty3				= 0;
	dirty_load_val			= 0;
	input_mux_sel			= 0;
	data_mux_sel			= 0;
	pmem_address_mux_sel	= 0;
	mem_resp					= 0;
	pmem_read				= 0;
	pmem_write				= 0;
	
	/* Actions for each state */
	case(state)
		standby: begin
			if(mem_read && hit) begin
				load_lru	= 1;
				mem_resp = 1;
				
				if(hit0) 		data_mux_sel = 0;
				else if(hit1)	data_mux_sel = 1;
				else if(hit2)	data_mux_sel = 2;
				else				data_mux_sel = 3;
			end
			else if (mem_write && hit) begin
				load_lru	= 1;
				mem_resp = 1;
				dirty_load_val = 1;
				input_mux_sel = 1;
				
				if(hit0) begin
					load_data0 = 1;
					load_dirty0 = 1;
				end
				else if(hit1) begin
					load_data1 = 1;
					load_dirty1 = 1;
				end
				else if(hit2) begin
					load_data2 = 1;
					load_dirty2 = 1;
				end
				else if(hit3) begin
					load_data3 = 1;
					load_dirty3 = 1;
				end
			end
		end
		
		read_from_memory: begin
			pmem_read = 1;
			
			if(lru_val == 2'b00) begin
				load_data0	= 1;
				load_tag0 	= 1;
				load_valid0	= 1;
				load_dirty0	= 1;
			end
			else if(lru_val == 2'b01) begin
				load_data1	= 1;
				load_tag1 	= 1;
				load_valid1	= 1;
				load_dirty1	= 1;
			end
			else if(lru_val == 2'b10) begin
				load_data2	= 1;
				load_tag2	= 1;
				load_valid2	= 1;
				load_dirty2	= 1;
			end
			else begin
				load_data3	= 1;
				load_tag3 	= 1;
				load_valid3	= 1;
				load_dirty3	= 1;
			end
		end
		
		write_to_memory: begin
			pmem_write = 1;
			if(lru_val == 2'b00) begin
				pmem_address_mux_sel = 1;
				data_mux_sel = 0;
			end 
			else if(lru_val == 2'b01) begin
				pmem_address_mux_sel = 2;
				data_mux_sel = 1;
			end
			else if(lru_val == 2'b10) begin
				pmem_address_mux_sel = 3;
				data_mux_sel = 2;
			end
			else if(lru_val == 2'b11) begin
				pmem_address_mux_sel = 4;
				data_mux_sel = 3;
			end
		end
		
	endcase
end

always_comb
begin : next_state_logic
	/* Next state information and conditions (if any)
	 * for transitioning between states */
	 next_state = standby;
	 
	case(state)
		standby: begin
			if((mem_read || mem_write) && ~hit) begin
				if(lru_val == 2'b00 && dirty0_val) 				next_state = write_to_memory;		// lru == 0 && dirty0 == 1
				else if(lru_val == 2'b01 && dirty1_val) 		next_state = write_to_memory;
				else if(lru_val == 2'b10 && dirty2_val) 		next_state = write_to_memory;
				else if(lru_val == 2'b11 && dirty3_val) 		next_state = write_to_memory;
				else														next_state = read_from_memory;		// ~hit ~dirty
			end	// endif read/write
		end
		
		read_from_memory: begin
			if(pmem_resp)		next_state = standby;
			else					next_state = read_from_memory;
		end
		
		write_to_memory: begin
			if(pmem_resp)		next_state = read_from_memory;
			else					next_state = write_to_memory;
		end
		
		default: next_state = standby;
		
	endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
	/* Assignment of next state on clock edge */
	state <= next_state;
end

endmodule : cache_l2_control
