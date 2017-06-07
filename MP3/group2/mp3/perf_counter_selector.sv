/*
 * Performance Counter Selector Module
 */

import lc3b_types::*;
module perf_counter_selector
(
	/* To/From MEM block */
	input						counter_reset,
	input		lc3b_word	counter_address,
	output	lc3b_word	counter_data,
	
	/* To/From Counters */
	input		lc3b_word	c0_data,
	output	logic			c0_reset,
	
	input		lc3b_word	c1_data,
	output	logic			c1_reset,
	
	input		lc3b_word	c2_data,
	output	logic			c2_reset,
	
	input		lc3b_word	c3_data,
	output	logic			c3_reset,
	
	input		lc3b_word	c4_data,
	output	logic			c4_reset,
	
	input		lc3b_word	c5_data,
	output	logic			c5_reset,
	
	input		lc3b_word	c6_data,
	output	logic			c6_reset,
	
	input		lc3b_word	c7_data,
	output	logic			c7_reset,
	
	input		lc3b_word	c8_data,
	output	logic			c8_reset,
	
	input		lc3b_word	c9_data,
	output	logic			c9_reset,
	
	input		lc3b_word	ca_data,
	output	logic			ca_reset
	
);

/* Module Declaration */
always_comb begin
	/* Default output assignments */
	counter_data	= 16'hFFFF;			// Should never output this; if it does there is most likely an error
	c0_reset			= 1'b0;
	c1_reset			= 1'b0;
	c2_reset			= 1'b0;
	c3_reset			= 1'b0;
	c4_reset			= 1'b0;
	c5_reset			= 1'b0;
	c6_reset			= 1'b0;
	c7_reset			= 1'b0;
	c8_reset			= 1'b0;
	c9_reset			= 1'b0;
	ca_reset			= 1'b0;
	
	case(counter_address)
		16'h00: begin
			counter_data	= c0_data;
			c0_reset			= counter_reset;
		end
		
		16'h02: begin
			counter_data	= c1_data;
			c1_reset			= counter_reset;
		end
		
		16'h04: begin
			counter_data	= c2_data;
			c2_reset			= counter_reset;
		end
		
		16'h06: begin
			counter_data	= c3_data;
			c3_reset			= counter_reset;
		end
		
		16'h08: begin
			counter_data	= c4_data;
			c4_reset			= counter_reset;
		end
		
		16'h0a: begin
			counter_data	= c5_data;
			c5_reset			= counter_reset;
		end
		
		16'h0c: begin
			counter_data	= c6_data;
			c6_reset			= counter_reset;
		end
		
		16'h0e: begin
			counter_data	= c7_data;
			c7_reset			= counter_reset;
		end
		
		16'h10: begin
			counter_data	= c8_data;
			c8_reset			= counter_reset;
		end
		
		16'h12: begin
			counter_data	= c9_data;
			c9_reset			= counter_reset;
		end
		
		16'h14: begin
			counter_data	= ca_data;
			ca_reset			= counter_reset;
		end
		
		default: begin
			counter_data	= 16'hFFFF;			// Should never output this; if it does there is most likely an error
		end
	
	endcase
end

endmodule : perf_counter_selector
