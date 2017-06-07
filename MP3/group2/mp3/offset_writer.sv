import lc3b_types::*;

module offset_writer #(parameter line = 128)
(
	input		[line-1:0]			in,
	input		l1_block_offset	index,
	input		lc3b_word			inserted_data,
	input		lc3b_mem_wmask		mem_byte_enable,

	output	logic [line-1:0]	out
);

always_comb
begin
	out = in;
	
	case(index)
		0: begin
			if(mem_byte_enable[0])	out[7:0] = inserted_data[7:0];
			if(mem_byte_enable[1])	out[15:8] = inserted_data[15:8];
		end
		
		1: begin
			if(mem_byte_enable[0])	out[23:16] = inserted_data[7:0];
			if(mem_byte_enable[1])	out[31:24] = inserted_data[15:8];
		end
		
		2: begin
			if(mem_byte_enable[0])	out[39:32] = inserted_data[7:0];
			if(mem_byte_enable[1])	out[47:40] = inserted_data[15:8];
		end
		
		3: begin
			if(mem_byte_enable[0])	out[55:48] = inserted_data[7:0];
			if(mem_byte_enable[1])	out[63:56] = inserted_data[15:8];
		end
		
		4: begin
			if(mem_byte_enable[0])	out[71:64] = inserted_data[7:0];
			if(mem_byte_enable[1])	out[79:72] = inserted_data[15:8];
		end
		
		5: begin
			if(mem_byte_enable[0])	out[87:80] = inserted_data[7:0];
			if(mem_byte_enable[1])	out[95:88] = inserted_data[15:8];
		end
		
		6: begin
			if(mem_byte_enable[0])	out[103:96] = inserted_data[7:0];
			if(mem_byte_enable[1])	out[111:104] = inserted_data[15:8];
		end
		
		7: begin
			if(mem_byte_enable[0])	out[119:112] = inserted_data[7:0];
			if(mem_byte_enable[1])	out[127:120] = inserted_data[15:8];
		end
	endcase
end

endmodule : offset_writer
