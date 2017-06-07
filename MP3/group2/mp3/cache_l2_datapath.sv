import lc3b_types::*;

module cache_l2_datapath
(
	input 						clk,
	
	input lc3b_word			mem_address,
	input l1_cache_line		mem_wdata,
	
	input	l1_cache_line		pmem_rdata,
	
	output logic				hit0, hit1, hit2, hit3,
									dirty0_val, dirty1_val, dirty2_val, dirty3_val,
	output logic [1:0]		lru_val,
	output l1_cache_line		mem_rdata,
	output lc3b_word			pmem_address,
	output l1_cache_line		pmem_wdata,
	
	/* Control Signals */
	input							load_lru,
									load_data0, load_data1, load_data2, load_data3,
									load_valid0, load_valid1, load_valid2, load_valid3,
									load_dirty0, load_dirty1, load_dirty2, load_dirty3,
									load_tag0, load_tag1, load_tag2, load_tag3, dirty_load_val,
	input							input_mux_sel,
	input [1:0]					data_mux_sel,
	input	[2:0]					pmem_address_mux_sel
);

/* internal signals */
logic				valid0_out, valid1_out, valid2_out, valid3_out;
l1_cache_line	data0_out, data1_out, data2_out, data3_out,
					data_mux_out, input_mux_out;
					
logic [2:0]		lru_array_out, lru_decoder_out;

l1_tag			tag, tag0_out, tag1_out, tag2_out, tag3_out;
l1_c_index		set_index;


/* Simple Assignments */
assign tag = mem_address[15:7];
assign set_index = mem_address[6:4];
assign hit0 = (tag == tag0_out) && valid0_out;
assign hit1 = (tag == tag1_out) && valid1_out;
assign hit2 = (tag == tag2_out) && valid2_out;
assign hit3 = (tag == tag3_out) && valid3_out;
assign pmem_wdata = data_mux_out;
assign mem_rdata = data_mux_out;

/* ##### modules ##### */

/* Arrays*/

array data0
(
	.clk,
	.write(load_data0),
	.index(set_index),
	.datain(input_mux_out),
	.dataout(data0_out)
);


array #(.width(1)) valid0
(
	.clk,
	.write(load_valid0),
	.index(set_index),
	.datain(1'b1),
	.dataout(valid0_out)
);

array #(.width(1)) dirty0
(
	.clk,
	.write(load_dirty0),
	.index(set_index),
	.datain(dirty_load_val),
	.dataout(dirty0_val)
);

array #(.width($bits(l1_tag))) tag0
(
	.clk,
	.write(load_tag0),
	.index(set_index),
	.datain(tag),
	.dataout(tag0_out)
);

array data1
(
	.clk,
	.write(load_data1),
	.index(set_index),
	.datain(input_mux_out),
	.dataout(data1_out)
);


array #(.width(1)) valid1
(
	.clk,
	.write(load_valid1),
	.index(set_index),
	.datain(1'b1),
	.dataout(valid1_out)
);

array #(.width(1)) dirty1
(
	.clk,
	.write(load_dirty1),
	.index(set_index),
	.datain(dirty_load_val),
	.dataout(dirty1_val)
);

array #(.width($bits(l1_tag))) tag1
(
	.clk,
	.write(load_tag1),
	.index(set_index),
	.datain(tag),
	.dataout(tag1_out)
);

array data2
(
	.clk,
	.write(load_data2),
	.index(set_index),
	.datain(input_mux_out),
	.dataout(data2_out)
);

array #(.width(1)) valid2
(
	.clk,
	.write(load_valid2),
	.index(set_index),
	.datain(1'b1),
	.dataout(valid2_out)
);

array #(.width(1)) dirty2
(
	.clk,
	.write(load_dirty2),
	.index(set_index),
	.datain(dirty_load_val),
	.dataout(dirty2_val)
);

array #(.width($bits(l1_tag))) tag2
(
	.clk,
	.write(load_tag2),
	.index(set_index),
	.datain(tag),
	.dataout(tag2_out)
);

array data3
(
	.clk,
	.write(load_data3),
	.index(set_index),
	.datain(input_mux_out),
	.dataout(data3_out)
);

array #(.width(1)) valid3
(
	.clk,
	.write(load_valid3),
	.index(set_index),
	.datain(1'b1),
	.dataout(valid3_out)
);

array #(.width(1)) dirty3
(
	.clk,
	.write(load_dirty3),
	.index(set_index),
	.datain(dirty_load_val),
	.dataout(dirty3_val)
);

array #(.width($bits(l1_tag))) tag3
(
	.clk,
	.write(load_tag3),
	.index(set_index),
	.datain(tag),
	.dataout(tag3_out)
);

array #(.width(3)) lru
(
	.clk,
	.write(load_lru),
	.index(set_index),
	.datain(lru_decoder_out),
	.dataout(lru_array_out)
);

/* ### Dataflow ### */

lru_decoder lru_decoder
(
	.hit0,
	.hit1,
	.hit2,
	.hit3,
	.in(lru_array_out),
	.decoded_val(lru_val),
	.out(lru_decoder_out)
);

/* input_mux */
mux2 #(.width($bits(l1_cache_line))) input_mux
(
	.sel(input_mux_sel),
	.a(pmem_rdata),
	.b(mem_wdata),
	.f(input_mux_out)
);

/* data_mux */
mux4 #(.width($bits(l1_cache_line))) data_mux
(
	.sel(data_mux_sel),
	.a(data0_out),
	.b(data1_out),
	.c(data2_out),
	.d(data3_out),
	.f(data_mux_out)
);

/* pmem_address */
mux8 pmem_address_mux
(
	.sel(pmem_address_mux_sel),
	.a({tag, set_index, 4'h0}),
	.b({tag0_out, set_index, 4'h0}),
	.c({tag1_out, set_index, 4'h0}),
	.d({tag2_out, set_index, 4'h0}),
	.e({tag3_out, set_index, 4'h0}),
	.f(16'h0),
	.g(16'h0),
	.h(16'h0),
	.o(pmem_address)
);

endmodule : cache_l2_datapath
