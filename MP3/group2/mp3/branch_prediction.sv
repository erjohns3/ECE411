/*
 * Branch Prediction Module
 */

import lc3b_types::*;
module branch_prediction
(
	input		lc3b_word			ir,
	input		lc3b_word			pc,
	
	output	logic					sel_branch_predict,
	output	lc3b_word			branch_target
);

/* internal signals */
lc3b_word		br_offset;

/* internal assignments */
assign br_offset 		= $signed({ir[8:0], 1'b0});

/* Control to set predicted Branch */
always_comb
begin
	/* Default output assignments */
	branch_target			=	pc + br_offset;
	sel_branch_predict	=	1'b0;
	
	if(ir[15:12] == op_br && ir[11:9] != 3'b000) begin
		sel_branch_predict	=	1;
	end
end

endmodule : branch_prediction
