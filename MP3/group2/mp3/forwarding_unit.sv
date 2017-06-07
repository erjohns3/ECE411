/*
 * Forwarding Module
 */

import lc3b_types::*;
module forwarding_unit
(
	input		lc3b_control_word	D_ctrl,
	input		lc3b_control_word	E_ctrl,
	input		lc3b_control_word	M_ctrl,
	
	input		lc3b_word			D_ir,
	input		lc3b_word			E_ir,
	input		lc3b_word			M_ir,
	
	input		lc3b_word			EX_alu,
	input		lc3b_word			EX_pc,
	input		lc3b_word			EX_pc_offset,
	input		lc3b_word			MEM_alu,
	input		lc3b_word			MEM_pc,
	input		lc3b_word			MEM_pc_offset,
	input		lc3b_word			MEM_mem,
	
	output	logic					FWD_sel_ID_sr1_mux,
	output	logic					FWD_sel_ID_sr2_mux,
	output	logic					FWD_sel_EX_sr1_mux,
	output	logic					FWD_sel_EX_sr2_mux,
	
	output	lc3b_word			FWD_ID_sr1_data,
	output	lc3b_word			FWD_ID_sr2_data,
	output	lc3b_word			FWD_EX_sr1_data,
	output	lc3b_word			FWD_EX_sr2_data
);

/* internal signals */
lc3b_opcode			d_op;
lc3b_opcode			e_op;
lc3b_opcode			m_op;

lc3b_reg				e_dr;
lc3b_reg				m_dr;

lc3b_reg				d_sr1;
lc3b_reg				d_sr2;
lc3b_reg				e_sr1;
lc3b_reg				e_sr2;

/* internal assignments */
assign d_op		= D_ctrl.opcode;
assign e_op		= E_ctrl.opcode;
assign m_op		= M_ctrl.opcode;

assign e_dr		= E_ir[11:9];
assign m_dr		= M_ir[11:9];

/* internal combinational logic */
always_comb
begin
	/* Default output assignments */
	FWD_sel_ID_sr1_mux	= 0;
	FWD_sel_ID_sr2_mux	= 0;
	FWD_sel_EX_sr1_mux	= 0;
	FWD_sel_EX_sr2_mux	= 0;
	FWD_ID_sr1_data		= MEM_alu;
	FWD_ID_sr2_data		= MEM_alu;
	FWD_EX_sr1_data		= MEM_alu;
	FWD_EX_sr2_data		= MEM_alu;
	
	/* Default internal assignments */
	d_sr1						= D_ir[8:6];
	d_sr2						= D_ir[2:0];
	e_sr1						= E_ir[8:6];
	e_sr2						= E_ir[2:0];
	
	/* Get Needed Registers */
	if(d_op == op_stb || d_op == op_sti || d_op == op_str) begin
		d_sr2					= D_ir[11:9];
	end
	
	if(e_op == op_stb || e_op == op_sti || e_op == op_str) begin
		e_sr2					= E_ir[11:9];
	end
	
	/* Perform MEM -> EX and MEM -> ID */
	if(m_op == op_add || m_op == op_and || m_op == op_not || m_op == op_shf) begin
		if(m_dr == d_sr1) begin
			FWD_sel_ID_sr1_mux	 = 1;
		end
		
		if(m_dr == d_sr2) begin
			FWD_sel_ID_sr2_mux	 = 1;
		end
		
		if(m_dr == e_sr1) begin
			FWD_sel_EX_sr1_mux	 = 1;
		end
		
		if(m_dr == e_sr2) begin
			FWD_sel_EX_sr2_mux	 = 1;
		end
		
	end
	else if(m_op == op_jsr || m_op == op_trap) begin
		if(3'b111 == d_sr1) begin
			FWD_sel_ID_sr1_mux	= 1;
		end
		
		if(3'b111 == d_sr2) begin
			FWD_sel_ID_sr2_mux	= 1;
		end
		
		if(3'b111 == e_sr1) begin
			FWD_sel_EX_sr1_mux	= 1;
		end
		
		if(3'b111 == e_sr2) begin
			FWD_sel_EX_sr2_mux	= 1;
		end
		
		FWD_ID_sr1_data		= MEM_pc;
		FWD_ID_sr2_data		= MEM_pc;
		FWD_EX_sr1_data		= MEM_pc;
		FWD_EX_sr2_data		= MEM_pc;
		
	end
	else if (m_op == op_lea) begin
		if(m_dr == d_sr1) begin
			FWD_sel_ID_sr1_mux	= 1;
		end
		
		if(m_dr == d_sr2) begin
			FWD_sel_ID_sr2_mux	= 1;
		end
		
		if(m_dr == e_sr1) begin
			FWD_sel_EX_sr1_mux	= 1;
		end
		
		if(m_dr == e_sr2) begin
			FWD_sel_EX_sr2_mux	= 1;
		end
		
		FWD_ID_sr1_data		= MEM_pc_offset;
		FWD_ID_sr2_data		= MEM_pc_offset;
		FWD_EX_sr1_data		= MEM_pc_offset;
		FWD_EX_sr2_data		= MEM_pc_offset;
		
	end
	else if (m_op == op_ldb || m_op == op_ldi || m_op == op_ldr) begin
		if(m_dr == d_sr1) begin
			FWD_sel_ID_sr1_mux	= 1;
		end
		
		if(m_dr == d_sr2) begin
			FWD_sel_ID_sr2_mux	= 1;
		end
		
		if(m_dr == e_sr1) begin
			FWD_sel_EX_sr1_mux	= 1;
		end
		
		if(m_dr == e_sr2) begin
			FWD_sel_EX_sr2_mux	= 1;
		end
		
		FWD_ID_sr1_data		= MEM_mem;
		FWD_ID_sr2_data		= MEM_mem;
		FWD_EX_sr1_data		= MEM_mem;
		FWD_EX_sr2_data		= MEM_mem;
		
	end
	
	/* Perform EX -> ID, overwriting MEM -> ID */
	if(e_op == op_add || e_op == op_and || e_op == op_not || e_op == op_shf) begin
		if(e_dr == d_sr1) begin
			FWD_sel_ID_sr1_mux	= 1;
			FWD_ID_sr1_data		= EX_alu;
		end
		
		if(e_dr == d_sr2) begin
			FWD_sel_ID_sr2_mux	= 1;
			FWD_ID_sr2_data		= EX_alu;
		end
	end
	else if(e_op == op_jsr || e_op == op_trap) begin
		if(3'b111 == d_sr1) begin
			FWD_sel_ID_sr1_mux	= 1;
			FWD_ID_sr1_data		= EX_pc;
		end
		
		if(3'b111 == d_sr2) begin
			FWD_sel_ID_sr2_mux	= 1;
			FWD_ID_sr2_data		= EX_pc;
		end
	end
	else if (e_op == op_lea) begin
		if(e_dr == d_sr1) begin
			FWD_sel_ID_sr1_mux	= 1;
			FWD_ID_sr1_data		= EX_pc_offset;
		end
		
		if(e_dr == d_sr2) begin
			FWD_sel_ID_sr2_mux	= 1;
			FWD_ID_sr2_data		= EX_pc_offset;
		end
	end
	/*else begin if (e_op == op_ldb || e_op == op_ldi || e_op == op_ldr) begin
		if(e_dr == d_sr1) begin
			FWD_sel_EX_sr1_mux	= 1;
		end
		
		if(e_dr == d_sr2) begin
			FWD_sel_EX_sr2_mux	= 1;
		end
		
	end*/
	
end

/* internal modules */

endmodule : forwarding_unit
