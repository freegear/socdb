onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/clk
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/rstb
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/apb_sel
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/apb_addr
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/apb_write
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/apb_wdata
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/apb_rdata
add wave -noupdate -divider Reg
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/apb_clk
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/apb_rstb
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/apb_enable
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/apb_sel
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/apb_addr
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/apb_write
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/apb_wdata
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/apb_rdata
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/fm_write
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/clr_fmreg
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/hdp
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/rdp
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/smart
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/key_hit
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/fmaddr
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/fmdata
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/fmucon
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/rdwaitcycle
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/tnvs
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/tnvh
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/tpgs
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/tpgh
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/trcv
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/tnvh1
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/tprog
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/terase
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/tme
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/pscal_value
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/fmkey
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/treg
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/treg_0
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/treg_1
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/treg_2
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/treg_3
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/treg_4
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/treg_5
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/reg_wr
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/rdata
add wave -noupdate -divider FMB
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/clk
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/rstb
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/fmb/rdwaitcycle
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/fmb/addr
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/fmr_rd
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/fmb/fmr_rdata
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/ready_1cb
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/ready
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/fmb/fmw_adr
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/fmw_xe
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/fmw_ye
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/fmw_se
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/fmw_erase
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/fmw_mas1
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/fmw_prog
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/fmw_nvstr
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/fmw_ifren
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/fmb/fmw_din
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/hdp
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/rdp
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/fmb/smart
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/fmb/fm_xadr
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/fmb/fm_yadr
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/fm_xe
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/fm_ye
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/fm_se
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/fm_erase
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/fm_mas1
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/fm_prog
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/fm_nvstr
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/fm_ifren
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/fmb/fm_din
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/fmb/fm_dout
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/op_read
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/op_prog
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/op_perase
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/op_berase
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/fmb/cnt
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/read_end
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/fmb/cs
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/fmb/ns
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/fmb/rd_cs
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/fmb/rd_ns
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/sm_idle
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/sm_setcnt
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/sm_read
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/sm_rdend
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/sm_start
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/sm_wait0
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/sm_wait1
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/sm_wait2
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/sm_set_rd_prot
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/sm_wait_rd_prot
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/sm_set_rd_smart
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/sm_wait_rd_smart
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb/sm_normal
add wave -noupdate -divider {FM Core}
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmcore/XE
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmcore/YE
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmcore/SE
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmcore/ERASE
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmcore/MAS1
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmcore/PROG
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmcore/NVSTR
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmcore/IFREN
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/fmcore/XADR
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/fmcore/YADR
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/fmcore/DIN
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/fmcore/DOUT
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmcore/TMR
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmcore/VPP
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/fmcore/TM
add wave -noupdate -divider {Writer Module}
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/clk
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/rstb
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/fm_read
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/key_hit
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/fmaddr
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/fmdata
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/fmucon
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/hdp
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/smart
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/tnvs
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/tnvh
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/tpgs
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/tpgh
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/trcv
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/tnvh1
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/tprog
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/terase
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/tme
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/pscal_value
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/fm_write
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/mx_sel_wr
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/clr_fmreg
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/fmw_adr
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/fmw_xe
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/fmw_ye
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/fmw_se
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/fmw_erase
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/fmw_mas1
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/fmw_prog
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/fmw_nvstr
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/fmw_ifren
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/fmw_din
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/start_new
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/fmucon_lt
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/chip_erase
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/pg_erase
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/program
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/opt_prog
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/start
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/cnt_en
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/perase_hit
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/key_hit_lt
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/operation
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/protected
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/pscal_rst
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/pscal_clk
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/pscal_d1
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/pscal_d2
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/pscal_d3
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/counter0
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/counter1
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/counter2
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/cnt0_zero
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/cnt_zero
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/cs
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/ns
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/sm_idle
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/sm_start_op
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/sm_pre_tnvs
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/sm_tnvs
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/sm_pre_tpgs
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/sm_tpgs
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/sm_pre_tprog
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/sm_tprog
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/sm_pre_tpgh
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/sm_tpgh
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/sm_pre_erase
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/sm_erase
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/sm_pre_tnvh
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/sm_tnvh
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/sm_pre_trcv
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/sm_trcv
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/sm_clr_reg
add wave -noupdate -divider pscaler
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/pscaler/clk
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/pscaler/rstb
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/pscaler/cnt_rst
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/pscaler/cnt_value
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/pscaler/pscal_clk
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_wr/pscaler/cnt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2081190 ps} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {1133530 ps} {2670370 ps}
