onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /Atb_fmc/clk
add wave -noupdate -format Logic /Atb_fmc/rstb
add wave -noupdate -format Logic /Atb_fmc/tmode
add wave -noupdate -format Logic /Atb_fmc/scl
add wave -noupdate -format Logic /Atb_fmc/sda_in
add wave -noupdate -format Logic /Atb_fmc/sda_out
add wave -noupdate -format Logic /Atb_fmc/sda_oeb
add wave -noupdate -format Logic /Atb_fmc/tool_mode
add wave -noupdate -format Logic /Atb_fmc/Top/scl
add wave -noupdate -format Logic /Atb_fmc/Top/sda_in
add wave -noupdate -format Logic /Atb_fmc/Top/sda_out
add wave -noupdate -format Logic /Atb_fmc/Top/ifmc_serial/scl
add wave -noupdate -format Logic /Atb_fmc/Top/ifmc_serial/sda_in
add wave -noupdate -format Logic /Atb_fmc/Top/ifmc_serial/sda_out
add wave -noupdate -format Logic /Atb_fmc/Top/ifmc_serial/sda_oeb
add wave -noupdate -divider {Detect Tool Mode}
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_tool/clk
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_tool/rstb
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_tool/tmode
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_tool/scl_lpf
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_tool/tool_mode
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_tool/cnt
add wave -noupdate -divider Analysis
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ana/clk
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ana/rstb
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ana/scl_lpf
add wave -noupdate -color Orange -format Logic -itemcolor Orange -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ana/sst_start
add wave -noupdate -color Orange -format Logic -itemcolor Orange -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ana/sst_stop
add wave -noupdate -color Orange -format Logic -itemcolor Orange -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ana/sst_ishift
add wave -noupdate -color Orange -format Logic -itemcolor Orange -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ana/sst_oshift
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ana/end_sclh
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ana/sda_lpf
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ana/sda_dly
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ana/scl_dly
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ana/start_edge
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ana/stop_edge
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ana/set_start
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ana/set_stop
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ana/scl_pos
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ana/scl_pos_dly
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ana/scl_neg
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ana/scl_neg_dly
add wave -noupdate -divider {Protocal SM}
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/clk
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/rstb
add wave -noupdate -color {Orange Red} -format Logic -itemcolor {Orange Red} /Atb_fmc/gang/ReadOp
add wave -noupdate -color {Medium Slate Blue} -format Logic -itemcolor Thistle /Atb_fmc/gang/WriteOp
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/scl_lpf
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/sda_lpf
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/sda_out
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/sda_oeb
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/sst_start
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/sst_stop
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/sst_ishift
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/sst_oshift
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/end_sclh
add wave -noupdate -color {Light Steel Blue} -format Logic -itemcolor {Light Steel Blue} -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/sop_read
add wave -noupdate -color {Light Steel Blue} -format Logic -itemcolor {Light Steel Blue} -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/sop_prog
add wave -noupdate -color {Light Steel Blue} -format Logic -itemcolor {Light Steel Blue} -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/sop_erase
add wave -noupdate -color {Light Steel Blue} -format Logic -itemcolor {Light Steel Blue} -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/sop_wrp
add wave -noupdate -color {Light Steel Blue} -format Logic -itemcolor {Light Steel Blue} -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/sop_rdp
add wave -noupdate -color Orange -format Logic -itemcolor Orange -radix binary /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/sm_idle
add wave -noupdate -color Orange -format Logic -itemcolor Orange -radix binary /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/sm_initialize
add wave -noupdate -color Orange -format Logic -itemcolor Orange -radix binary /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/sm_get_addr
add wave -noupdate -color Orange -format Logic -itemcolor Orange -radix binary /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/sm_addr_dummy
add wave -noupdate -color Orange -format Logic -itemcolor Orange -radix binary /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/sm_clr_counter
add wave -noupdate -color Orange -format Logic -itemcolor Orange -radix binary /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/sm_get_data
add wave -noupdate -color Orange -format Logic -itemcolor Orange -radix binary /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/sm_data_dummy
add wave -noupdate -color Orange -format Logic -itemcolor Orange -radix binary /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/sm_stop
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/fmr_adr
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/fmr_rd
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/fmr_rdata
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/gang/rd_data
add wave -noupdate -format Logic /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/fmb_ready
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/fm_wrmode
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/fmw_adr
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/fmw_xe
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/fmw_ye
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/fmw_se
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/fmw_erase
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/fmw_mas1
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/fmw_prog
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/fmw_nvstr
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/fmw_ifren
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/fmw_din
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/hdp
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/rdp
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/smart
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/perase_hit
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/protected
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/bit_cnt
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/bit_zero
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/byte_cnt
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/rx_shift
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/gang/addr0
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/rx_addr0
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/gang/addr1
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/rx_addr1
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/gang/addr2
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/rx_addr2
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/rx_data
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/ld_tx_data
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/pdata
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/tx_shift
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/ddm_dly
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/ddm_pe
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/scl_dly
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/scl_pe
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/wait_nvstr
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/wdata_va
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/data_phase
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/fst_ddm
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/cnt_en
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/cs
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_serial/ifmc_ptsm/ns
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/gang/rd_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 3} {20731337670 ps} 0} {{Cursor 4} {20726384000 ps} 0}
configure wave -namecolwidth 185
configure wave -valuecolwidth 55
configure wave -justifyvalue left
configure wave -signalnamewidth 2
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
update
WaveRestoreZoom {20718562990 ps} {20738447920 ps}
