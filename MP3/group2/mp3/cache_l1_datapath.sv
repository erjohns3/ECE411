import lc3b_types::*;

module cache_l1_datapath
(
	input 						clk,
	
	input							load_lru, load_data0, load_data1,
									load_tag0, load_tag1, load_valid0, load_valid1,
									load_dirty0, load_dirty1, dirty_load_val,
									write_mux_sel,
	input				[1:0]		pmem_address_mux_sel,
	
	input lc3b_mem_wmask		mem_byte_enable,
	input lc3b_word			mem_address,
	input lc3b_word			mem_wdata,
	
	input	l1_cache_line		pmem_rdata,
	
	output logic				hit0, hit1, lru_out,
									dirty0_val, dirty1_val,
	output lc3b_word			mem_rdata,
	output lc3b_word			pmem_address,
	output l1_cache_line		pmem_wdata
);

/* internal signals */
logic				valid0_out, valid1_out;
l1_cache_line	data0_out, data1_out, data_mux_out, write_mux_out, offset_writer_out;

l1_tag				tag, tag0_out, tag1_out;
l1_c_index			set_index;
l1_block_offset	block_offset;


/* Simple Assignments */
assign tag = mem_address[15:7];
assign set_index = mem_address[6:4];
assign block_offset = mem_address[3:1];
assign hit0 = (tag == tag0_out) && valid0_out;
assign hit1 = (tag == tag1_out) && valid1_out;

/* ##### modules ##### */

/* Arrays*/

array data0
(
	.*,
	.write(load_data0),
	.index(set_index),
	.datain(write_mux_out),
	.dataout(data0_out)
);


array #(.width(1)) valid0
(
	.*,
	.write(load_valid0),
	.index(set_index),
	.datain(1'b1),
	.dataout(valid0_out)
);

array #(.width(1)) dirty0
(
	.*,
	.write(load_dirty0),
	.index(set_index),
	.datain(dirty_load_val),
	.dataout(dirty0_val)
);

array #(.width(9)) tag0
(
	.*,
	.write(load_tag0),
	.index(set_index),
	.datain(tag),
	.dataout(tag0_out)
);

array data1
(
	.*,
	.write(load_data1),
	.index(set_index),
	.datain(write_mux_out),
	.dataout(data1_out)
);


array #(.width(1)) valid1
(
	.*,
	.write(load_valid1),
	.index(set_index),
	.datain(1'b1),
	.dataout(valid1_out)
);

array #(.width(1)) dirty1
(
	.*,
	.write(load_dirty1),
	.index(set_index),
	.datain(dirty_load_val),
	.dataout(dirty1_val)
);

array #(.width(9)) tag1
(
	.*,
	.write(load_tag1),
	.index(set_index),
	.datain(tag),
	.dataout(tag1_out)
);

array #(.width(1)) lru
(
	.*,
	.write(load_lru),
	.index(set_index),
	.datain(hit0),
	.dataout(lru_out)
);

/* ### Dataflow ### */

/* mem_rdata */
mux2 #(.width(128)) data_mux
(
	.sel(hit1),
	.a(data0_out),
	.b(data1_out),
	.f(data_mux_out)
);

mux8 dataoffset_mux
(
	.sel(block_offset),
	.a(data_mux_out[15:0]),
	.b(data_mux_out[31:16]),
	.c(data_mux_out[47:32]),
	.d(data_mux_out[63:48]),
	.e(data_mux_out[79:64]),
	.f(data_mux_out[95:80]),
	.g(data_mux_out[111:96]),
	.h(data_mux_out[127:112]),
	.o(mem_rdata)
);

/* pmem_address */
mux4 pmem_address_mux
(
	.sel(pmem_address_mux_sel),
	.a({tag, set_index, 4'h0}),
	.b({tag0_out, set_index, 4'h0}),
	.c({tag1_out, set_index, 4'h0}),
	.d(16'h0),
	.f(pmem_address)
);


/* pmem_wdata */
mux2 #(.width(128)) pmem_wdata_mux
(
	.sel(lru_out),
	.a(data0_out),
	.b(data1_out),
	.f(pmem_wdata)
);

/* writemux */
mux2 #(.width(128)) write_mux
(
	.sel(write_mux_sel),
	.a(pmem_rdata),
	.b(offset_writer_out),
	.f(write_mux_out)
);

/* input offset_writer */
offset_writer offset_writer
(
	.in(data_mux_out),
	.index(block_offset),
	.inserted_data(mem_wdata),
	.mem_byte_enable,
	.out(offset_writer_out)
);

endmodule : cache_l1_datapath
