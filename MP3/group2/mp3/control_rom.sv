/*
 * Control ROM module
 */

import lc3b_types::*;
module control_rom
(
	input		lc3b_opcode				opcode,
	input									valid,
	input		lc3b_bit					bit11,
	input		lc3b_bit					bit5,
	input		lc3b_bit					bit4,
	output	lc3b_control_word		ctrl
);

always_comb
begin : assignments
	/* Default assignments */
	ctrl.opcode 						= opcode;
	ctrl.aluop							= alu_add;
	ctrl.IF_sel_pc_mux				= 0;
	ctrl.ID_r7_reg_mux				= 0;
	ctrl.ID_sr1_sel_store_reg_mux	= 0;
	ctrl.ID_sr2_sel_store_reg_mux	= 0;
	ctrl.ID_load_regfile				= 0;
	ctrl.EX_sel_alu_mux				= 0;
	ctrl.EX_sel_pc_zero_mux			= 0;
	ctrl.EX_sel_pc_offset_mux		= 0;
	ctrl.MEM_branch					= 0;
	ctrl.WB_sel_regfile_mux			= 0;
	ctrl.WB_load_cc					= 0;
	ctrl.dcache_read					= 0;
	ctrl.dcache_write					= 0;
	
	/* Overwrite default based on opcode */
	if(valid) begin
		case(opcode)
			op_add: begin
				ctrl.ID_load_regfile				= 1;
				ctrl.WB_load_cc					= 1;
				
				if(bit5) begin
					ctrl.EX_sel_alu_mux				= 2;
				end
				else begin
					ctrl.EX_sel_alu_mux				= 0;
				end
			end // op_add
			
			op_and: begin
				ctrl.aluop 							= alu_and;
				ctrl.ID_load_regfile				= 1;
				ctrl.WB_load_cc					= 1;
				
				if(bit5) begin
					ctrl.EX_sel_alu_mux				= 2;
				end
				else begin
					ctrl.EX_sel_alu_mux				= 0;
				end
			end // op_and
			
			op_br: begin
				ctrl.MEM_branch					= 1;
			end // op_br
			
			op_not: begin
				ctrl.aluop							= alu_not;
				ctrl.ID_load_regfile				= 1;
				ctrl.WB_load_cc					= 1;
			end // op_not
			
			op_ldr: begin
				ctrl.ID_load_regfile				= 1;
				ctrl.WB_load_cc					= 1;
				ctrl.EX_sel_alu_mux				= 1;
				ctrl.WB_sel_regfile_mux			= 1;
				ctrl.dcache_read					= 1;
			end // op_ldr
			
			op_str: begin
				ctrl.ID_sr2_sel_store_reg_mux	= 1;
				ctrl.EX_sel_alu_mux				= 1;
				ctrl.dcache_write					= 1;
			end // op_str
			
			op_jmp: begin	// jmp and ret
				ctrl.IF_sel_pc_mux				= 1;
				ctrl.EX_sel_pc_zero_mux			= 1;
				ctrl.EX_sel_pc_offset_mux		= 2;
			end // op_jmp
			
			op_jsr: begin	// jsr and jsrr
				ctrl.IF_sel_pc_mux				= 1;
				ctrl.ID_r7_reg_mux				= 1;
				ctrl.ID_load_regfile				= 1;
				ctrl.WB_sel_regfile_mux			= 2;
			
				if(bit11) begin
					ctrl.EX_sel_pc_offset_mux		= 1;
				end
				else begin
					ctrl.EX_sel_pc_zero_mux			= 1;
					ctrl.EX_sel_pc_offset_mux		= 2;
				end		
			end // op_jsr
			
			op_ldb: begin
				ctrl.ID_load_regfile				= 1;
				ctrl.WB_load_cc					= 1;
				ctrl.EX_sel_alu_mux				= 3;
				ctrl.WB_sel_regfile_mux			= 1;
				ctrl.dcache_read					= 1;
			end // op_ldb
			
			op_lea: begin
				ctrl.ID_load_regfile				= 1;
				ctrl.WB_load_cc					= 1;
				ctrl.WB_sel_regfile_mux			= 3;
			end	// op_lea
			
			op_shf: begin
				ctrl.ID_load_regfile				= 1;
				ctrl.WB_load_cc					= 1;
				ctrl.EX_sel_alu_mux				= 4;
				
				if(~bit4) begin			// D Flag = 0, shift = sr << im4
					ctrl.aluop							= alu_sll;
				end
				else begin
					if(~bit5) begin			// A Flag = 0, shift = sr << im4,0
						ctrl.aluop							= alu_srl;
					end
					else begin					// shift = sr << im4,SR[15]
						ctrl.aluop							= alu_sra;
					end
				end
			end	// op_shf
			
			op_stb: begin
				ctrl.aluop							= alu_add;
				ctrl.ID_sr2_sel_store_reg_mux	= 1;
				ctrl.EX_sel_alu_mux				= 3;
				ctrl.dcache_write					= 1;
			end
			
			op_trap: begin
				ctrl.aluop							= alu_pass;
				ctrl.IF_sel_pc_mux				= 2;
				ctrl.ID_load_regfile				= 1;
				ctrl.ID_r7_reg_mux				= 1;
				ctrl.EX_sel_alu_mux				= 5;
				ctrl.WB_sel_regfile_mux			= 2;
				ctrl.dcache_read					= 1;
			end	// op_trap
			
			op_ldi: begin
				ctrl.ID_load_regfile				= 1;
				ctrl.WB_load_cc					= 1;
				ctrl.EX_sel_alu_mux				= 1;
				ctrl.WB_sel_regfile_mux			= 1;
				ctrl.dcache_read					= 1;		// Note: Changing this will have an Adverse Effect - Careful - see memory_interface
			end	// op_ldi
			
			op_sti: begin
				ctrl.ID_sr2_sel_store_reg_mux	= 1;
				ctrl.EX_sel_alu_mux				= 1;
				ctrl.dcache_write					= 1;		// Note: Changing this will have an Adverse Effect - Careful - see memory_interface
			end	// op_sti
			
			default: begin
				ctrl = 0;
			end // default
		endcase
	end
end : assignments

endmodule : control_rom
