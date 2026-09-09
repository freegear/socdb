onerror {resume}
quietly WaveActivateNextPane {} 0
quietly virtual function -install /tb/jtag_md/wr_reg -env /tb/jtag_md/wr_reg { &{/tb/jtag_md/wr_reg/wr_data[3], /tb/jtag_md/wr_reg/wr_data[2], /tb/jtag_md/wr_reg/wr_data[1], /tb/jtag_md/wr_reg/wr_data[0] }} wr_data_3_0
add wave -noupdate -format Logic -radix binary /tb/RESETn
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/DBGEN
add wave -noupdate -format Logic -radix binary /tb/Clock
add wave -noupdate -format Logic -radix binary /tb/etrstb
add wave -noupdate -format Logic -radix binary /tb/ertclk
add wave -noupdate -format Logic -radix binary /tb/ensrst
add wave -noupdate -format Logic -radix binary /tb/eedbgrq
add wave -noupdate -format Logic -radix binary /tb/edbgack
add wave -noupdate -format Logic -radix binary /tb/etdi
add wave -noupdate -format Logic -radix binary /tb/etdo
add wave -noupdate -format Logic -radix binary /tb/etms
add wave -noupdate -format Logic -radix binary /tb/etclk
add wave -noupdate -format Logic -radix binary /tb/jtag_en
add wave -noupdate -divider {JTAG Master Model}
add wave -noupdate -format Logic -radix binary /tb/jtag_md/clk
add wave -noupdate -format Logic -radix binary /tb/jtag_md/rstb
add wave -noupdate -format Logic -radix binary /tb/jtag_md/en
add wave -noupdate -format Logic -radix binary /tb/jtag_md/TDMISO
add wave -noupdate -format Logic -radix binary /tb/jtag_md/TDMOSI
add wave -noupdate -format Logic -radix binary /tb/jtag_md/TMS
add wave -noupdate -format Logic -radix binary /tb/jtag_md/TCK
add wave -noupdate -format Logic -radix binary /tb/jtag_md/TRSTb
add wave -noupdate -format Literal -radix binary /tb/jtag_md/en_dly
add wave -noupdate -format Logic -radix binary /tb/jtag_md/enable
add wave -noupdate -format Literal -radix hexadecimal /tb/jtag_md/rd_buff
add wave -noupdate -divider {wr task}
add wave -noupdate -format Literal -radix decimal /tb/jtag_md/wr_reg/bit_cnt
add wave -noupdate -format Logic -radix binary /tb/jtag_md/TDMOSI
add wave -noupdate -format Literal /tb/jtag_md/wr_reg/wr_data_3_0
add wave -noupdate -format Literal /tb/jtag_md/wr_reg/wr_data
add wave -noupdate -divider {ARM JTAG}
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/CLK
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/DBGnTRST
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/DBGTCKEN
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/DBGTDI
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/DBGTMS
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/DBGTDO
add wave -noupdate -format Literal /tb/Top/Core/cpu/CPU/DBGIR
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/DBGTAPSM
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1585655 ps} 0}
configure wave -namecolwidth 190
configure wave -valuecolwidth 60
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
WaveRestoreZoom {1282917 ps} {1774620 ps}
