onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /arm_top/pld_clk
add wave -noupdate -format Logic -radix hexadecimal /arm_top/reset_slave
add wave -noupdate -format Logic -radix hexadecimal /arm_top/lcd_en
add wave -noupdate -format Literal -radix hexadecimal /arm_top/lcd_data
add wave -noupdate -format Literal -radix hexadecimal /arm_top/mode
add wave -noupdate -format Literal -radix hexadecimal /arm_top/seg_gnd1
add wave -noupdate -format Literal -radix hexadecimal /arm_top/seg_gnd2
add wave -noupdate -format Literal -radix hexadecimal /arm_top/seg_out1
add wave -noupdate -format Literal -radix hexadecimal /arm_top/seg_out2
add wave -noupdate -divider {AMBA AHB }
add wave -noupdate -format Literal -radix hexadecimal /arm_top/HADDR
add wave -noupdate -format Literal -radix hexadecimal /arm_top/HBURST
add wave -noupdate -format Logic -radix hexadecimal /arm_top/HCLOCK
add wave -noupdate -format Literal -radix hexadecimal /arm_top/HRDATA
add wave -noupdate -format Logic -radix hexadecimal /arm_top/HREADY
add wave -noupdate -format Literal -radix hexadecimal /arm_top/HRESP
add wave -noupdate -format Literal -radix hexadecimal /arm_top/HSIZE
add wave -noupdate -format Literal -radix hexadecimal /arm_top/HTRANS
add wave -noupdate -format Literal -radix hexadecimal /arm_top/HWDATA
add wave -noupdate -format Logic -radix hexadecimal /arm_top/HWRITE
add wave -noupdate -format Logic -radix hexadecimal /arm_top/RESETN
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {56 ns} 0}
WaveRestoreZoom {303 ns} {437 ns}
configure wave -namecolwidth 181
configure wave -valuecolwidth 114
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
