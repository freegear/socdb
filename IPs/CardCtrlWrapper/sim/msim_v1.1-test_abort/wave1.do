onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/rstb
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/clk_card
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/clk_sys
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/ci_adsb
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/ci_wr
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/ci_blastb
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/ci_csb
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/ci_addr
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/ci_beb
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/ci_rdata
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/ci_wdata
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/ci_error
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/ci_rdyb
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/ci_size
add wave -noupdate -format Logic /Atb_1/ci_abortb
add wave -noupdate -format Logic /Atb_1/cardctrlwrap/abortb_hsk
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/si_addr
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/si_wdata
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/si_rdata
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/si_beb
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/si_wrb
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/si_rdb
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/si_rdyb
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/si_err
add wave -noupdate -format Literal /Atb_1/csb
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/addr
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/size
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/rd
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/wr
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/busy
add wave -noupdate -divider {Card Interface Model}
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/ci_model/rstb
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/ci_model/clk_card
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/ci_model/ci_adsb
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/ci_model/ci_wr
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/ci_model/ci_csb
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/ci_model/ci_addr
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/ci_model/ci_beb
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/ci_model/ci_error
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/ci_model/ci_size
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/ci_model/ci_blastb
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/ci_model/ci_rdyb
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/ci_model/ci_rdata
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/ci_model/ci_wdata
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/ci_model/addr
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/ci_model/size
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/ci_model/rd
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/ci_model/wr
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/ci_model/busy
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/ci_model/cmd_rwb
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/ci_model/size_cnt
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/ci_model/cim_cs
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/ci_model/cim_ns
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/ci_model/cim_sm_idle
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/ci_model/cim_sm_send_ads
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/ci_model/cim_sm_end_size
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/ci_model/ADDR_a
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/ci_model/CEn_a
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/ci_model/RDATA_a
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/cardctrlwrap/rstb
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/cardctrlwrap/clk_card
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/cardctrlwrap/ci_adsb
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/cardctrlwrap/ci_wr
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/cardctrlwrap/ci_blastb
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/cardctrlwrap/ci_csb
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/cardctrlwrap/ci_addr
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/cardctrlwrap/ci_beb
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/cardctrlwrap/ci_error
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/cardctrlwrap/ci_size
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/cardctrlwrap/ci_rdyb
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/cardctrlwrap/ci_rdata
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/cardctrlwrap/ci_wdata
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/cardctrlwrap/ci_cs
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/cardctrlwrap/ci_ns
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/cardctrlwrap/ci_sm_idle
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/cardctrlwrap/ci_sm_send_cmd
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/cardctrlwrap/ci_sm_get_rdy
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/cardctrlwrap/ci_sm_end_cmd
add wave -noupdate -format Logic /Atb_1/cardctrlwrap/ci_sm_abort
add wave -noupdate -color Orange -format Logic -itemcolor Orange -radix hexadecimal /Atb_1/cardctrlwrap/clk_sys
add wave -noupdate -format Literal /Atb_1/cardctrlwrap/csb_hsk
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/cardctrlwrap/ads_fgb
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/cardctrlwrap/adsb_hsk
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/cardctrlwrap/lastb_hsk
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/cardctrlwrap/wr_hsk
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/cardctrlwrap/rdyb_hsk
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/cardctrlwrap/addr_hsk
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/cardctrlwrap/wdata_hsk
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/cardctrlwrap/beb_hsk
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/cardctrlwrap/rdata_hsk
add wave -noupdate -format Logic /Atb_1/cardctrlwrap/abortb_hsk
add wave -noupdate -format Logic /Atb_1/cardctrlwrap/si_newopb
add wave -noupdate -format Literal /Atb_1/cardctrlwrap/si_csb
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/cardctrlwrap/si_addr
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/cardctrlwrap/si_wrb
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/cardctrlwrap/si_rdb
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/cardctrlwrap/si_beb
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/cardctrlwrap/si_wdata
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/cardctrlwrap/si_rdata
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/cardctrlwrap/si_err
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/cardctrlwrap/si_rdyb
add wave -noupdate -format Logic /Atb_1/cardctrlwrap/si_rdyb_dly
add wave -noupdate -format Logic /Atb_1/cardctrlwrap/si_rdyb_edge
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/cardctrlwrap/si_cs
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/cardctrlwrap/si_ns
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/cardctrlwrap/si_sm_idle
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/cardctrlwrap/si_sm_wait_rdys
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/cardctrlwrap/si_sm_send_rd
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/cardctrlwrap/si_sm_wait_frdy
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/cardctrlwrap/si_sm_send_rdy
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/cardctrlwrap/si_sm_end_cmd
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/cardctrlwrap/si_sm_wait_ads
add wave -noupdate -divider {SRAM Interface Model}
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/si_model/rstb
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/si_model/clk_sys
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/si_model/si_addr
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/si_model/si_wdata
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/si_model/si_rdata
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/si_model/si_beb
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/si_model/si_wrb
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/si_model/si_rdb
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/si_model/si_rdyb
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/si_model/si_err
add wave -noupdate -format Logic /Atb_1/si_model/rdb_dly
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/si_model/byte_cnt
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/si_model/addr
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/si_model/rdata
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/si_model/wrb
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/si_model/ram_addr
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/si_model/ram_rdata
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/si_model/ram_wdata
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/si_model/ram_csb
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/si_model/ram_wrb
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/si_model/si_cs
add wave -noupdate -format Literal -radix hexadecimal /Atb_1/si_model/si_ns
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/si_model/si_sm_idle
add wave -noupdate -format Logic -radix hexadecimal /Atb_1/si_model/si_sm_run
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5771670 ps} 0}
configure wave -namecolwidth 217
configure wave -valuecolwidth 81
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
WaveRestoreZoom {1537740 ps} {4047540 ps}
