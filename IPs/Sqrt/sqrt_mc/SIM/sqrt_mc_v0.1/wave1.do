onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /Asqrt_tb/clk
add wave -noupdate -format Logic -radix hexadecimal /Asqrt_tb/rstb
add wave -noupdate -format Literal -radix hexadecimal /Asqrt_tb/radicad
add wave -noupdate -format Literal -radix hexadecimal /Asqrt_tb/quotient
add wave -noupdate -format Logic -radix hexadecimal /Asqrt_tb/sqrten
add wave -noupdate -format Logic -radix hexadecimal /Asqrt_tb/sqrtend
add wave -noupdate -format Literal -radix hexadecimal /Asqrt_tb/log_file
add wave -noupdate -divider {SQRT Top}
add wave -noupdate -format Logic -radix hexadecimal /Asqrt_tb/sqrt_top/clk
add wave -noupdate -format Logic -radix hexadecimal /Asqrt_tb/sqrt_top/rstb
add wave -noupdate -format Logic -radix hexadecimal /Asqrt_tb/sqrt_top/sqrten
add wave -noupdate -format Literal -radix hexadecimal /Asqrt_tb/sqrt_top/radicad
add wave -noupdate -format Logic -radix hexadecimal /Asqrt_tb/sqrt_top/sqrtend
add wave -noupdate -format Literal -radix hexadecimal /Asqrt_tb/sqrt_top/q
add wave -noupdate -format Literal -radix hexadecimal /Asqrt_tb/sqrt_top/quot
add wave -noupdate -format Literal -radix hexadecimal /Asqrt_tb/sqrt_top/rad
add wave -noupdate -format Literal -radix hexadecimal /Asqrt_tb/sqrt_top/r
add wave -noupdate -format Literal -radix hexadecimal /Asqrt_tb/sqrt_top/quotient
add wave -noupdate -format Literal -radix hexadecimal /Asqrt_tb/sqrt_top/radicad_0
add wave -noupdate -format Literal -radix hexadecimal /Asqrt_tb/sqrt_top/r_org
add wave -noupdate -format Literal -radix hexadecimal /Asqrt_tb/sqrt_top/loop_cnt
add wave -noupdate -format Literal -radix hexadecimal /Asqrt_tb/sqrt_top/cs
add wave -noupdate -format Literal -radix hexadecimal /Asqrt_tb/sqrt_top/ns
add wave -noupdate -divider Cell
add wave -noupdate -format Literal -radix hexadecimal /Asqrt_tb/sqrt_top/sqrt_r2/quot_bfr
add wave -noupdate -format Literal -radix hexadecimal /Asqrt_tb/sqrt_top/sqrt_r2/rad_bfr
add wave -noupdate -format Literal -radix hexadecimal /Asqrt_tb/sqrt_top/sqrt_r2/r_org_bfr
add wave -noupdate -format Literal -radix hexadecimal /Asqrt_tb/sqrt_top/sqrt_r2/quotient
add wave -noupdate -format Literal -radix hexadecimal /Asqrt_tb/sqrt_top/sqrt_r2/radicad
add wave -noupdate -format Literal -radix hexadecimal /Asqrt_tb/sqrt_top/sqrt_r2/r_org
add wave -noupdate -format Literal -radix hexadecimal /Asqrt_tb/sqrt_top/sqrt_r2/fgen
add wave -noupdate -format Literal -radix hexadecimal /Asqrt_tb/sqrt_top/sqrt_r2/rad
add wave -noupdate -format Literal -radix hexadecimal /Asqrt_tb/sqrt_top/sqrt_r2/rest
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1328 ns} 0}
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
WaveRestoreZoom {0 ns} {2510 ns}
