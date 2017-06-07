import lc3b_types::*; /* Import types defined in lc3b_types.sv */

module cache_l1_control
(
	input						clk,
	
	input						pmem_resp,
	input						mem_read,
	input						mem_write,
	
	input						hit0, hit1, lru_out,
								dirty0_val, dirty1_val,

	output logic			load_lru, load_data0, load_data1,
								load_tag0, load_tag1, load_valid0, load_valid1,
								load_dirty0, load_dirty1, dirty_load_val,
								write_mux_sel,
	output logic [1:0]	pmem_address_mux_sel,
								
	output logic			mem_resp,
	output logic			pmem_read,
	output logic			pmem_write
);

enum int unsigned {
	/* List of states */
	standby, read_from_memory, write_to_memory
} state, next_state;

/* internal signals */
logic hit, update0, update1;

/* internal assignments */
assign hit = hit0 | hit1;
assign update0 = ~lru_out & dirty0_val;
assign update1 = lru_out & dirty1_val;

always_comb
begin : state_actions
	/* Default output assignments */
	load_lru					=	1'b0;
	load_data0				=	1'b0;
	load_data1				=	1'b0;
	load_tag0				=	1'b0;
	load_tag1				=	1'b0;
	load_valid0				=	1'b0;
	load_valid1				=	1'b0;
	load_dirty0				=	1'b0;
	load_dirty1				=	1'b0;
	dirty_load_val			=	1'b0;
	write_mux_sel			=	1'b0;
	pmem_address_mux_sel =	2'b00;
	
	mem_resp 				=	1'b0;
	pmem_read				=	1'b0;
	pmem_write				=	1'b0;
	
	/* Actions for each state */
	case(state)
		standby: begin
			if(mem_read) begin
				/* ### START MEM_READ ### */
				if(hit) begin
					load_lru = 1;
					mem_resp = 1;
				end
				/* ### END MEM_READ ### */
			end
			
			if(mem_write) begin
				/* ### START MEM_WRITE ### */
				if(hit) begin
					write_mux_sel = 1;
					dirty_load_val = 1;
					load_lru = 1;
					mem_resp = 1;
					
					if(hit0) begin
						load_data0 = 1;
						load_dirty0 = 1;
					end
					else begin
						load_data1 = 1;
						load_dirty1 = 1;
					end
				end
				/* ### END MEM_WRITE ### */
			end
		end
		
		read_from_memory: begin
			/* Keep reading till data arrives */
			pmem_read = 1;
			
			if(lru_out) begin
				/* Write to Way 1 */
				load_data1 = 1;
				load_tag1 = 1;
				load_valid1 = 1;
				load_dirty1 = 1;
			end
			else begin
				/* Write to Way 0 */
				load_data0 = 1;
				load_tag0 = 1;
				load_valid0 = 1;
				load_dirty0 = 1;
			end
		end
		
		write_to_memory: begin
			pmem_write = 1;
			if(lru_out)	pmem_address_mux_sel = 2;
			else			pmem_address_mux_sel = 1;
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
			if(mem_read || mem_write) begin
				if(~hit) begin
					if(update0) 			next_state = write_to_memory;		// lru == 0 && dirty0 == 1
					else if(update1) 		next_state = write_to_memory;
					else						next_state = read_from_memory;		// ~hit ~dirty
				end // endif nohit
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

endmodule : cache_l1_control
