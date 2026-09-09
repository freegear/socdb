onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /Atb_div/clk
add wave -noupdate -format Logic -radix hexadecimal /Atb_div/rstb
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/romaddr
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/romdata
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/dividend
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/divisor
add wave -noupdate -color Orange -format Literal -itemcolor Orange -radix hexadecimal /Atb_div/q
add wave -noupdate -color Orange -format Literal -itemcolor Orange -radix hexadecimal /Atb_div/q_i
add wave -noupdate -color Thistle -format Literal -itemcolor Thistle -radix hexadecimal /Atb_div/r
add wave -noupdate -color Thistle -format Literal -itemcolor Thistle -radix hexadecimal /Atb_div/r_i
add wave -noupdate -format Logic -radix hexadecimal /Atb_div/diven
add wave -noupdate -format Logic -radix hexadecimal /Atb_div/divend
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/result_log
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/diff_q
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/diff_r
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/abs_diff_q
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/abs_diff_r
add wave -noupdate -divider Divider
add wave -noupdate -format Logic -radix hexadecimal /Atb_div/divider/clk
add wave -noupdate -format Logic -radix hexadecimal /Atb_div/divider/rstb
add wave -noupdate -format Logic -radix hexadecimal /Atb_div/divider/diven
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/divider/dividend
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/divider/divisor
add wave -noupdate -format Logic -radix hexadecimal /Atb_div/divider/divend
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/divider/lz_2
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/divider/lz_4
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/divider/lz_8
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/divider/lz_16
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/divider/lz_cnt
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/divider/lz_num4
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/divider/divs_s4
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/divider/divs_sht
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/divider/divisor_m
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/divider/divisor_m1
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/divider/divisor_m2
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/divider/divisor_m3
add wave -noupdate -color Orange -format Literal -itemcolor Orange -radix hexadecimal /Atb_div/divider/cs
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/divider/loop_cnt
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/divider/remainder
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/divider/dividend_rm
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/divider/q_cmp
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/divider/q_cmb
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/divider/q_s4
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/divider/q
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/divider/r_s4
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/divider/r
add wave -noupdate -divider {divider cell}
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/divider/div_cmp/dividend
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/divider/div_cmp/divisor_m1
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/divider/div_cmp/divisor_m2
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/divider/div_cmp/divisor_m3
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/divider/div_cmp/remainder1
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/divider/div_cmp/remainder2
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/divider/div_cmp/remainder3
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/divider/div_cmp/q
add wave -noupdate -format Literal -radix hexadecimal /Atb_div/divider/div_cmp/r
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {54958700 ps} 0}
configure wave -namecolwidth 158
configure wave -valuecolwidth 68
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
WaveRestoreZoom {54911900 ps} {54996800 ps}
