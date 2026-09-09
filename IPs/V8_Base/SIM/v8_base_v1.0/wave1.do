onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/clk
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/rstb
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/set_addr
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/acc_addr
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/write
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/wdata
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/read
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/rdata
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/run
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/romdata
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/addr
add wave -noupdate -divider Top
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/clk
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/rstb
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/set_addr
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/acc_addr
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/write
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/wdata
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/read
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/rdata
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/run
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/fetch
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/cpu_cycle
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/cpu_opcde
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/cpu_write_nxt
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/cpu_pc
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/cpu_psr
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/cpu_sp_oflo
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/mem_cs
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/mem_dataout
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/mem_ready
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/p_datain
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/restart
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/spc_cs
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/spc_addr
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/spc_read
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/spc_write
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/spc_datain
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/spc_dataout
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/sl_csb
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/sl_addr
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/sl_writeb
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/sl_outenb
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/sl_dataout
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/sl_datain
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/mem_out
add wave -noupdate -color Orange -format Literal -itemcolor Orange -radix hexadecimal /Atb_v8_base/v8_base_top/cpu_addr
add wave -noupdate -color Orange -format Logic -itemcolor Orange -radix hexadecimal /Atb_v8_base/v8_base_top/cpu_write
add wave -noupdate -color Orange -format Logic -itemcolor Orange -radix hexadecimal /Atb_v8_base/v8_base_top/cpu_read
add wave -noupdate -color Orange -format Literal -itemcolor Orange -radix hexadecimal /Atb_v8_base/v8_base_top/cpu_dataout
add wave -noupdate -color Orange -format Literal -itemcolor Orange -radix hexadecimal /Atb_v8_base/v8_base_top/cpu_datain
add wave -noupdate -color Orange -format Logic -itemcolor Orange -radix hexadecimal /Atb_v8_base/v8_base_top/cpu_ready
add wave -noupdate -divider ram
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/psram/CLK
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/psram/A
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/psram/Q
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/psram/CEN
add wave -noupdate -format Literal -radix binary /Atb_v8_base/v8_base_top/psram/WEN
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/psram/D
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/psram/OEN
add wave -noupdate -divider {sp control}
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/sp_ctrl/clk
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/sp_ctrl/rstb
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/sp_ctrl/set_addr
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/sp_ctrl/acc_addr
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/sp_ctrl/write
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/sp_ctrl/wdata
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/sp_ctrl/read
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/sp_ctrl/rdata
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/sp_ctrl/run
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/sp_ctrl/bus_addr
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/sp_ctrl/fetch
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/sp_ctrl/restart
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/sp_ctrl/spc_cs
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/sp_ctrl/spc_addr
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/sp_ctrl/spc_read
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/sp_ctrl/spc_write
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/sp_ctrl/spc_dataout
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/sp_ctrl/spc_datain
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/sp_ctrl/rstvec
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/sp_ctrl/cs
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/sp_ctrl/ns
add wave -noupdate -divider BUS
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/sp_ctrl/clk
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/bus/cpu_addr
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/bus/cpu_dataout
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/bus/cpu_datain
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/bus/cpu_ready
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/bus/pctrl_ready
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/bus/mem_cs
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/bus/mem_dataout
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/bus/mem_ready
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/bus/p_be
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/bus/p_datain
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/bus/p0_cs
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/bus/p0_dataout
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/bus/p0_ready
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/bus/p1_cs
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/bus/p1_dataout
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/bus/p1_ready
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/bus/p2_cs
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/bus/p2_dataout
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/bus/p2_ready
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/bus/p3_cs
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/bus/p3_dataout
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/bus/p3_ready
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/bus/p4_cs
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/bus/p4_dataout
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/bus/p4_ready
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/bus/p5_cs
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/bus/p5_dataout
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/bus/p5_ready
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/bus/p6_cs
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/bus/p6_dataout
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/bus/p6_ready
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/bus/p7_cs
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/bus/p7_dataout
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/bus/p7_ready
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/bus/p_dataout
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/bus/peri_cs
add wave -noupdate -divider {memory rapper}
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/mem_rap/clk
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/mem_rap/rstb
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/mem_rap/bus_cs
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/mem_rap/bus_addr
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/mem_rap/bus_read
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/mem_rap/bus_write
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/mem_rap/bus_datain
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/mem_rap/bus_dataout
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/mem_rap/bus_ready
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/mem_rap/spc_cs
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/mem_rap/spc_addr
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/mem_rap/spc_read
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/mem_rap/spc_write
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/mem_rap/spc_datain
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/mem_rap/spc_dataout
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/mem_rap/sl_csb
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/mem_rap/sl_addr
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/mem_rap/sl_writeb
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/mem_rap/sl_outenb
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/mem_rap/sl_dataout
add wave -noupdate -format Literal -radix hexadecimal /Atb_v8_base/v8_base_top/mem_rap/sl_datain
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/mem_rap/sl_ready
add wave -noupdate -format Logic -radix hexadecimal /Atb_v8_base/v8_base_top/mem_rap/rd_st
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {6850340 ps} 0}
configure wave -namecolwidth 176
configure wave -valuecolwidth 74
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
WaveRestoreZoom {6713820 ps} {7092880 ps}
