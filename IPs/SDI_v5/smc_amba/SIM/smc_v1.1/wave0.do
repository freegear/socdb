onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/clk
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/rstb
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/apb_enable
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/apb_sel
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/apb_addr
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/apb_write
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/apb_wdata
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/apb_rdata
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/ahb_sel0
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/ahb_sel1
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/ahb_sel2
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/ahb_sel3
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/ahb_readyin
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/ahb_htrans
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/ahb_addr
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/ahb_write
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/ahb_size
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/ahb_wdata
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/ahb_rdata
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/ahb_ready
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/ext_csb
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/ext_beb
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/ext_adr
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/ext_wbeb
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/ext_web
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/ext_oeb
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/ext_wdata
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/ext_bidoe
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/sram_data_h
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/sram_data_l
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/ahb_addr
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/taddr
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/str_addr
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/ahb_act
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/reg_smc/bnkctrl
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/reg_smc/bnkctrl_eff
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {20187 ns} 0}
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
WaveRestoreZoom {57393 ns} {63611 ns}
