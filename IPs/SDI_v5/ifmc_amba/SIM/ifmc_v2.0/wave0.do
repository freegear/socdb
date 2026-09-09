onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/clk
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/apb_clk
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/rstb
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/tmode
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/scl
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/sda_in
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/sda_out
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/sda_oeb
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/tool_mode
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ahb_sel
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ahb_readyin
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ahb_trans
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ahb_addr
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ahb_write
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ahb_size
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ahb_rdata
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/ahb_ready
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ahb_resp
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/apb_enable
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/apb_sel
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/apb_addr
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/apb_write
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/apb_wdata
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/apb_rdata
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmt_en
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmt_tmr
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmt_vpp
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/fmt_tm
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmt_nvstr
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmt_se
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmt_mas1
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmt_ifren
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmt_xe
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmt_ye
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmt_erase
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/rdwaitcycle
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/info_rd
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/bfmr_adr
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/bfmr_rd
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/bfm_wrmode
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/bfmw_adr
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/bfmw_xe
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/bfmw_ye
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/bfmw_se
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/bfmw_erase
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/bfmw_mas1
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/bfmw_prog
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/bfmw_nvstr
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/bfmw_ifren
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/bfmw_din
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/sfmr_adr
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/sfmr_rd
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/sfm_wrmode
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/sfmw_adr
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/sfmw_xe
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/sfmw_ye
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/sfmw_se
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/sfmw_erase
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/sfmw_mas1
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/sfmw_prog
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/sfmw_nvstr
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/sfmw_ifren
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/sfmw_din
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/fmr_adr
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmr_rd
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/fmr_rdata
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb_ready_1cb
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmb_ready
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fm_wrmode
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/ifmc_bus/ifmc_reg/fmaddr
add wave -noupdate -format Literal -radix hexadecimal -expand /Atb_fmc/Top/fmb/fm_xadr
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/fmb/fm_yadr
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/fmw_adr
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmw_xe
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmw_ye
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmw_se
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmw_erase
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmw_mas1
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmw_prog
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmw_nvstr
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmw_ifren
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/fmw_din
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/hdp
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/rdp
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/smart
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/fm_xadr
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/fm_yadr
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fm_xe
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fm_ye
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fm_se
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fm_erase
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fm_mas1
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fm_prog
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fm_nvstr
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fm_ifren
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/fm_din
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/fm_dout
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmc_tmr
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmc_nvstr
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmc_se
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmc_mas1
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmc_ifren
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmc_xe
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmc_ye
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmc_erase
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {21821725800 ps} 0}
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
WaveRestoreZoom {20832153350 ps} {22617334860 ps}
