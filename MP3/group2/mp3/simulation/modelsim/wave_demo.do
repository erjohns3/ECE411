onerror {resume}
quietly virtual function -install /mp3_tb/dut/memory_conf/i_cache -env /mp3_tb/dut/memory_conf/i_cache { &{/mp3_tb/dut/memory_conf/i_cache/pmem_resp, /mp3_tb/dut/memory_conf/i_cache/pmem_rdata, /mp3_tb/dut/memory_conf/i_cache/mem_read, /mp3_tb/dut/memory_conf/i_cache/mem_write, /mp3_tb/dut/memory_conf/i_cache/mem_byte_enable, /mp3_tb/dut/memory_conf/i_cache/mem_address, /mp3_tb/dut/memory_conf/i_cache/mem_wdata, /mp3_tb/dut/memory_conf/i_cache/mem_resp, /mp3_tb/dut/memory_conf/i_cache/mem_rdata, /mp3_tb/dut/memory_conf/i_cache/pmem_read, /mp3_tb/dut/memory_conf/i_cache/pmem_write, /mp3_tb/dut/memory_conf/i_cache/pmem_address, /mp3_tb/dut/memory_conf/i_cache/pmem_wdata }} icache
quietly WaveActivateNextPane {} 0
add wave -noupdate /mp3_tb/clk
add wave -noupdate /mp3_tb/pmem_resp
add wave -noupdate /mp3_tb/pmem_read
add wave -noupdate /mp3_tb/pmem_write
add wave -noupdate /mp3_tb/pmem_address
add wave -noupdate /mp3_tb/pmem_rdata
add wave -noupdate /mp3_tb/pmem_wdata
add wave -noupdate /mp3_tb/clk
add wave -noupdate -expand -group CPU /mp3_tb/dut/cpu/if_block/pc_out
add wave -noupdate -expand -group CPU /mp3_tb/dut/cpu/icache_rdata
add wave -noupdate -expand -group CPU /mp3_tb/dut/cpu/dcache_rdata
add wave -noupdate -expand -group CPU /mp3_tb/dut/cpu/branch
add wave -noupdate -expand -group CPU -label registers -expand -subitemconfig {{/mp3_tb/dut/cpu/id_block/regfile/data[7]} {-height 15} {/mp3_tb/dut/cpu/id_block/regfile/data[6]} {-height 15} {/mp3_tb/dut/cpu/id_block/regfile/data[5]} {-height 15} {/mp3_tb/dut/cpu/id_block/regfile/data[4]} {-height 15} {/mp3_tb/dut/cpu/id_block/regfile/data[3]} {-height 15} {/mp3_tb/dut/cpu/id_block/regfile/data[2]} {-height 15} {/mp3_tb/dut/cpu/id_block/regfile/data[1]} {-height 15} {/mp3_tb/dut/cpu/id_block/regfile/data[0]} {-height 15}} /mp3_tb/dut/cpu/id_block/regfile/data
add wave -noupdate -expand -group CPU -label ID_ctrl /mp3_tb/dut/cpu/id_block/ctrl_out
add wave -noupdate -expand -group CPU -label EX_ctrl /mp3_tb/dut/cpu/ex_block/ctrl
add wave -noupdate -expand -group CPU -label MEM_ctrl /mp3_tb/dut/cpu/mem_block/ctrl
add wave -noupdate -expand -group CPU -label WB_ctrl /mp3_tb/dut/cpu/wb_block/ctrl
add wave -noupdate -expand -group CPU -label mar /mp3_tb/dut/cpu/MEM_mar_reg/out
add wave -noupdate -expand -group CPU -label nzp /mp3_tb/dut/cpu/wb_block/nzp_reg/out
add wave -noupdate -expand -group CPU -label second_mem_op /mp3_tb/dut/cpu/mem_block/second_mem_op/out
add wave -noupdate -expand -group CPU -label ID_ir /mp3_tb/dut/cpu/IF_ID_ir_reg/data
add wave -noupdate -expand -group CPU -label EX_ir /mp3_tb/dut/cpu/ID_EX_ir_reg/data
add wave -noupdate -expand -group CPU -label MEM_ir /mp3_tb/dut/cpu/EX_MEM_ir_reg/data
add wave -noupdate -expand -group CPU /mp3_tb/dut/cpu/MEM_branch_miss
add wave -noupdate -expand -group CPU /mp3_tb/dut/cpu/reset_registers
add wave -noupdate -group counters -label br_miss /mp3_tb/dut/cpu/counter_br_miss/data
add wave -noupdate -group counters -label br_total /mp3_tb/dut/cpu/counter_br_total/data
add wave -noupdate -group counters -label icache_miss /mp3_tb/dut/cpu/counter_icache_miss_total/data
add wave -noupdate -group counters -label icache_total /mp3_tb/dut/cpu/counter_icache_total/data
add wave -noupdate -group counters -label dcache_miss /mp3_tb/dut/cpu/counter_dcache_miss_total/data
add wave -noupdate -group counters -label dcache_total /mp3_tb/dut/cpu/counter_dcache_total/data
add wave -noupdate -group counters -label l2_miss /mp3_tb/dut/cpu/counter_l2cache_miss_total/data
add wave -noupdate -group counters -label l2_total /mp3_tb/dut/cpu/counter_l2cache_total/data
add wave -noupdate -group counters -label total_mem_stall /mp3_tb/dut/cpu/counter_MEM_stall/data
add wave -noupdate -group counters -label total_full_load /mp3_tb/dut/cpu/counter_total_full_load/data
add wave -noupdate -group counters -label total_cycles /mp3_tb/dut/cpu/counter_total_cycles/data
add wave -noupdate -group Arbiter /mp3_tb/dut/memory_conf/arbiter/input_A_address
add wave -noupdate -group Arbiter /mp3_tb/dut/memory_conf/arbiter/input_A_wdata
add wave -noupdate -group Arbiter /mp3_tb/dut/memory_conf/arbiter/input_A_read
add wave -noupdate -group Arbiter /mp3_tb/dut/memory_conf/arbiter/input_A_write
add wave -noupdate -group Arbiter /mp3_tb/dut/memory_conf/arbiter/out_A_resp
add wave -noupdate -group Arbiter /mp3_tb/dut/memory_conf/arbiter/input_B_address
add wave -noupdate -group Arbiter /mp3_tb/dut/memory_conf/arbiter/input_B_wdata
add wave -noupdate -group Arbiter /mp3_tb/dut/memory_conf/arbiter/input_B_read
add wave -noupdate -group Arbiter /mp3_tb/dut/memory_conf/arbiter/input_B_write
add wave -noupdate -group Arbiter /mp3_tb/dut/memory_conf/arbiter/out_B_resp
add wave -noupdate -group Arbiter /mp3_tb/dut/memory_conf/arbiter/out_AB_rdata
add wave -noupdate -group Arbiter /mp3_tb/dut/memory_conf/arbiter/input_C_rdata
add wave -noupdate -group Arbiter /mp3_tb/dut/memory_conf/arbiter/input_C_resp
add wave -noupdate -group Arbiter /mp3_tb/dut/memory_conf/arbiter/out_C_read
add wave -noupdate -group Arbiter /mp3_tb/dut/memory_conf/arbiter/out_C_write
add wave -noupdate -group Arbiter /mp3_tb/dut/memory_conf/arbiter/out_C_address
add wave -noupdate -group Arbiter /mp3_tb/dut/memory_conf/arbiter/out_C_wdata
add wave -noupdate -group Arbiter /mp3_tb/dut/memory_conf/arbiter/sel_ab_address_mux
add wave -noupdate -group Arbiter /mp3_tb/dut/memory_conf/arbiter/sel_ab_to_c_data_mux
add wave -noupdate -group Arbiter /mp3_tb/dut/memory_conf/arbiter/AC/state
add wave -noupdate -expand -group icache /mp3_tb/dut/memory_conf/i_cache/pmem_resp
add wave -noupdate -expand -group icache /mp3_tb/dut/memory_conf/i_cache/pmem_rdata
add wave -noupdate -expand -group icache /mp3_tb/dut/memory_conf/i_cache/mem_read
add wave -noupdate -expand -group icache /mp3_tb/dut/memory_conf/i_cache/mem_write
add wave -noupdate -expand -group icache /mp3_tb/dut/memory_conf/i_cache/mem_byte_enable
add wave -noupdate -expand -group icache /mp3_tb/dut/memory_conf/i_cache/mem_address
add wave -noupdate -expand -group icache /mp3_tb/dut/memory_conf/i_cache/mem_wdata
add wave -noupdate -expand -group icache /mp3_tb/dut/memory_conf/i_cache/mem_resp
add wave -noupdate -expand -group icache /mp3_tb/dut/memory_conf/i_cache/mem_rdata
add wave -noupdate -expand -group icache /mp3_tb/dut/memory_conf/i_cache/pmem_read
add wave -noupdate -expand -group icache /mp3_tb/dut/memory_conf/i_cache/pmem_write
add wave -noupdate -expand -group icache /mp3_tb/dut/memory_conf/i_cache/pmem_address
add wave -noupdate -expand -group icache /mp3_tb/dut/memory_conf/i_cache/pmem_wdata
add wave -noupdate -group dcache -label data0 /mp3_tb/dut/memory_conf/d_cache/cache_l1_datapath/data0/data
add wave -noupdate -group dcache -label data1 /mp3_tb/dut/memory_conf/d_cache/cache_l1_datapath/data1/data
add wave -noupdate -group dcache -label lru /mp3_tb/dut/memory_conf/d_cache/cache_l1_datapath/lru/data
add wave -noupdate -group dcache -label valid0 /mp3_tb/dut/memory_conf/d_cache/cache_l1_datapath/valid0/data
add wave -noupdate -group dcache -label valid1 /mp3_tb/dut/memory_conf/d_cache/cache_l1_datapath/valid1/data
add wave -noupdate -group dcache -label dirty0 /mp3_tb/dut/memory_conf/d_cache/cache_l1_datapath/dirty0/data
add wave -noupdate -group dcache -label dirty1 /mp3_tb/dut/memory_conf/d_cache/cache_l1_datapath/dirty1/data
add wave -noupdate -group l2_cache -group pmem /mp3_tb/dut/memory_conf/l2_cache/pmem_resp
add wave -noupdate -group l2_cache -group pmem /mp3_tb/dut/memory_conf/l2_cache/pmem_rdata
add wave -noupdate -group l2_cache -group pmem /mp3_tb/dut/memory_conf/l2_cache/pmem_read
add wave -noupdate -group l2_cache -group pmem /mp3_tb/dut/memory_conf/l2_cache/pmem_write
add wave -noupdate -group l2_cache -group pmem /mp3_tb/dut/memory_conf/l2_cache/pmem_address
add wave -noupdate -group l2_cache -group pmem /mp3_tb/dut/memory_conf/l2_cache/pmem_wdata
add wave -noupdate -group l2_cache -group mem /mp3_tb/dut/memory_conf/l2_cache/mem_read
add wave -noupdate -group l2_cache -group mem /mp3_tb/dut/memory_conf/l2_cache/mem_write
add wave -noupdate -group l2_cache -group mem /mp3_tb/dut/memory_conf/l2_cache/mem_address
add wave -noupdate -group l2_cache -group mem /mp3_tb/dut/memory_conf/l2_cache/mem_wdata
add wave -noupdate -group l2_cache -group mem /mp3_tb/dut/memory_conf/l2_cache/mem_resp
add wave -noupdate -group l2_cache -group mem /mp3_tb/dut/memory_conf/l2_cache/mem_rdata
add wave -noupdate -group l2_cache /mp3_tb/dut/memory_conf/l2_cache/cache_l2_datapath/tag
add wave -noupdate -group l2_cache /mp3_tb/dut/memory_conf/l2_cache/cache_l2_datapath/set_index
add wave -noupdate -group l2_cache /mp3_tb/dut/memory_conf/l2_cache/cache_l2_controller/hit
add wave -noupdate -group l2_cache -group hitX /mp3_tb/dut/memory_conf/l2_cache/cache_l2_controller/hit0
add wave -noupdate -group l2_cache -group hitX /mp3_tb/dut/memory_conf/l2_cache/cache_l2_controller/hit1
add wave -noupdate -group l2_cache -group hitX /mp3_tb/dut/memory_conf/l2_cache/cache_l2_controller/hit2
add wave -noupdate -group l2_cache -group hitX /mp3_tb/dut/memory_conf/l2_cache/cache_l2_controller/hit3
add wave -noupdate -group l2_cache -group way0 -label data0 -expand /mp3_tb/dut/memory_conf/l2_cache/cache_l2_datapath/data0/data
add wave -noupdate -group l2_cache -group way0 -label valid0 /mp3_tb/dut/memory_conf/l2_cache/cache_l2_datapath/valid0/data
add wave -noupdate -group l2_cache -group way0 -label dirty0 /mp3_tb/dut/memory_conf/l2_cache/cache_l2_datapath/dirty0/data
add wave -noupdate -group l2_cache -group way0 -label tag0 /mp3_tb/dut/memory_conf/l2_cache/cache_l2_datapath/tag0/data
add wave -noupdate -group l2_cache -group way1 -label data1 -expand /mp3_tb/dut/memory_conf/l2_cache/cache_l2_datapath/data1/data
add wave -noupdate -group l2_cache -group way1 -label valid1 /mp3_tb/dut/memory_conf/l2_cache/cache_l2_datapath/valid1/data
add wave -noupdate -group l2_cache -group way1 -label dirty1 /mp3_tb/dut/memory_conf/l2_cache/cache_l2_datapath/dirty1/data
add wave -noupdate -group l2_cache -group way1 -label tag1 /mp3_tb/dut/memory_conf/l2_cache/cache_l2_datapath/tag1/data
add wave -noupdate -group l2_cache -group way2 -label data2 -expand /mp3_tb/dut/memory_conf/l2_cache/cache_l2_datapath/data2/data
add wave -noupdate -group l2_cache -group way2 -label valid2 /mp3_tb/dut/memory_conf/l2_cache/cache_l2_datapath/valid2/data
add wave -noupdate -group l2_cache -group way2 -label dirty2 /mp3_tb/dut/memory_conf/l2_cache/cache_l2_datapath/dirty2/data
add wave -noupdate -group l2_cache -group way2 -label tag2 /mp3_tb/dut/memory_conf/l2_cache/cache_l2_datapath/tag2/data
add wave -noupdate -group l2_cache -group way3 -label data3 -expand /mp3_tb/dut/memory_conf/l2_cache/cache_l2_datapath/data3/data
add wave -noupdate -group l2_cache -group way3 -label valid3 /mp3_tb/dut/memory_conf/l2_cache/cache_l2_datapath/valid3/data
add wave -noupdate -group l2_cache -group way3 -label dirty3 /mp3_tb/dut/memory_conf/l2_cache/cache_l2_datapath/dirty3/data
add wave -noupdate -group l2_cache -group way3 -label tag3 /mp3_tb/dut/memory_conf/l2_cache/cache_l2_datapath/tag3/data
add wave -noupdate -group l2_cache -label lru /mp3_tb/dut/memory_conf/l2_cache/cache_l2_datapath/lru/data
add wave -noupdate -group l2_cache -group lru_decoder -label lru_dec_in /mp3_tb/dut/memory_conf/l2_cache/cache_l2_datapath/lru_decoder/in
add wave -noupdate -group l2_cache -group lru_decoder -label lru_dec_out /mp3_tb/dut/memory_conf/l2_cache/cache_l2_datapath/lru_decoder/out
add wave -noupdate -group l2_cache -label lru_val /mp3_tb/dut/memory_conf/l2_cache/cache_l2_datapath/lru_decoder/decoded_val
add wave -noupdate -group l2_cache /mp3_tb/dut/memory_conf/l2_cache/cache_l2_controller/state
add wave -noupdate -group ewb /mp3_tb/dut/memory_conf/eviction_write_buffer/addr
add wave -noupdate -group ewb /mp3_tb/dut/memory_conf/eviction_write_buffer/data
add wave -noupdate -group ewb /mp3_tb/dut/memory_conf/eviction_write_buffer/dirty
add wave -noupdate -group ewb /mp3_tb/dut/memory_conf/eviction_write_buffer/writing_to_mem
add wave -noupdate -group ewb /mp3_tb/dut/memory_conf/eviction_write_buffer/ewb_addr
add wave -noupdate -group ewb /mp3_tb/dut/memory_conf/eviction_write_buffer/ewb_data
add wave -noupdate -group ewb /mp3_tb/dut/memory_conf/eviction_write_buffer/ewb_read
add wave -noupdate -group ewb /mp3_tb/dut/memory_conf/eviction_write_buffer/ewb_write
add wave -noupdate -group ewb /mp3_tb/dut/memory_conf/eviction_write_buffer/mem_data
add wave -noupdate -group ewb /mp3_tb/dut/memory_conf/eviction_write_buffer/out_resp
add wave -noupdate -group ewb /mp3_tb/dut/memory_conf/eviction_write_buffer/pmem_data
add wave -noupdate -group ewb /mp3_tb/dut/memory_conf/eviction_write_buffer/pmem_resp
add wave -noupdate -group ewb /mp3_tb/dut/memory_conf/eviction_write_buffer/source_addr
add wave -noupdate -group ewb /mp3_tb/dut/memory_conf/eviction_write_buffer/source_data
add wave -noupdate -group ewb /mp3_tb/dut/memory_conf/eviction_write_buffer/source_read
add wave -noupdate -group ewb /mp3_tb/dut/memory_conf/eviction_write_buffer/source_write
add wave -noupdate -group mem /mp3_tb/memory/read
add wave -noupdate -group mem /mp3_tb/memory/write
add wave -noupdate -group mem /mp3_tb/memory/address
add wave -noupdate -group mem /mp3_tb/memory/wdata
add wave -noupdate -group mem /mp3_tb/memory/resp
add wave -noupdate -group mem /mp3_tb/memory/rdata
add wave -noupdate -group mem /mp3_tb/memory/internal_address
add wave -noupdate -group mem /mp3_tb/memory/ready
add wave -noupdate -group mem /mp3_tb/memory/state
add wave -noupdate -group tb /mp3_tb/pmem_resp
add wave -noupdate -group tb /mp3_tb/pmem_read
add wave -noupdate -group tb /mp3_tb/pmem_write
add wave -noupdate -group tb /mp3_tb/pmem_address
add wave -noupdate -group tb /mp3_tb/pmem_rdata
add wave -noupdate -group tb /mp3_tb/pmem_wdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2501392 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 188
configure wave -valuecolwidth 199
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {2357830 ps} {2613611 ps}
