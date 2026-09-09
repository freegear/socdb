onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/clk
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/rstb
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/tmode
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/scl
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/sda_in
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/sda_out
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/sda_oeb
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/tool_mode
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/ahb_sel
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/ahb_readyin
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/ahb_trans
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/ahb_addr
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/ahb_write
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/ahb_size
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/ahb_rdata
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/ahb_ready
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/ahb_resp
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/apb_enable
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/apb_sel
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/apb_addr
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/apb_write
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/apb_wdata
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/apb_rdata
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/fmt_en
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/fmt_tmr
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/fmt_vpp
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/fmt_tm
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/fmt_mas1
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/fmt_ifren
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/fmt_xe
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/fmt_ye
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/fmt_erase
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/fmt_se
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/fmt_nvstr
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/fmt_prog
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/fmt_xadr
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/fmt_yadr
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/fmt_din
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/fmt_dout
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/fmt_oeb
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/tstart
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/fmc_logfile
add wave -noupdate -divider Mem
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmcore/clk
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmcore/rstb
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
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/fmcore/data_i
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/fmcore/addr
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/fmcore/data_o_i
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/fmcore/data_o_m
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmcore/we_n
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmcore/rd_n
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmcore/cs_n_m
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmcore/cs_n_i
add wave -noupdate -format Literal -radix hexadecimal /Atb_fmc/Top/fmcore/tcnt
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmcore/p_min
add wave -noupdate -format Logic -radix hexadecimal /Atb_fmc/Top/fmcore/p_max
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1431820 ps} 0}
configure wave -namecolwidth 201
configure wave -valuecolwidth 75
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
WaveRestoreZoom {0 ps} {2444440 ps}
