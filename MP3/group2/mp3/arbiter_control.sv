/*
 * Arbiter Control Module
 */

import lc3b_types::*;
module arbiter_control
(
	/* Memory */
	input 					clk,
	input 					input_A_read,		input_B_read,
	input						input_A_write,		input_B_write,
	
	input 					input_C_resp,
	
	output logic			out_A_resp,			out_B_resp,
	
	output logic 			out_C_read,
	output logic 			out_C_write,
	
	/* Control */
	output logic			sel_ab_address_mux,
	output logic			sel_ab_to_c_data_mux
);

enum int unsigned {
	/* List of states */
	idle, access_A, access_B
} state, next_state;

always_comb
begin : state_actions
	/* Default output assignments */
	out_A_resp				= 1'b0;
	out_B_resp				= 1'b0;
	out_C_read				= 1'b0;
	out_C_write				= 1'b0;
	sel_ab_address_mux	= 1'b0;
	sel_ab_to_c_data_mux	= 1'b0;
	
	/* Actions for each state */
	case(state)
		idle: begin
			if((input_B_read | input_B_write) & ~(input_A_read | input_A_write)) begin
				sel_ab_address_mux	= 1;
				sel_ab_to_c_data_mux	= 1;
			end
		end
		
		access_A: begin
			out_C_read				= input_A_read;
			out_C_write				= input_A_write;
			out_A_resp				= input_C_resp;
			
			if(input_C_resp) begin
				out_C_read				= 0;
				out_C_write				= 0;
				
				if(input_B_read | input_B_write) begin
					sel_ab_address_mux	= 1;
					sel_ab_to_c_data_mux	= 1;
				end
			end
		end
		
		access_B: begin
			out_C_read				= input_B_read;
			out_C_write				= input_B_write;
			out_B_resp				= input_C_resp;
			sel_ab_address_mux	= 1;
			sel_ab_to_c_data_mux	= 1;
			
			if(input_C_resp) begin
				out_C_read				= 0;
				out_C_write				= 0;
				
				if(input_A_read | input_A_write) begin
					sel_ab_address_mux	= 0;
					sel_ab_to_c_data_mux	= 0;
				end
			end
		end
		
	endcase
end

always_comb
begin: next_state_logic
	/* Next state information and conditions (if any)
	 * for transititoning between states */
	next_state = idle;
	
	case(state)
		idle: begin
			if(input_A_read | input_A_write) begin
				next_state = access_A;
			end
			else if(input_B_read | input_B_write) begin
				next_state = access_B;
			end
		end
		
		access_A: begin
			if(input_C_resp & (input_B_read | input_B_write)) begin
				next_state = access_B;
			end
			else if (~input_C_resp & (input_A_read | input_A_write)) begin
				next_state = access_A;
			end
		end
		
		access_B: begin
			if(input_C_resp & (input_A_read | input_A_write)) begin
				next_state = access_A;
			end
			else if (~input_C_resp & (input_B_read | input_B_write)) begin
				next_state = access_B;
			end
		end
	endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
	/* Assignment of next state on clock edge */
	state <= next_state;
end

endmodule : arbiter_control
