onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tb_dual/Ce_n
add wave -noupdate -format Logic /tb_dual/Ce_n2
add wave -noupdate -format Logic /tb_dual/Rb_n
add wave -noupdate -format Logic /tb_dual/Rb_n2
add wave -noupdate -divider UUT_0
add wave -noupdate -format Logic /tb_dual/uut_0/Ce_n
add wave -noupdate -format Logic /tb_dual/uut_0/Rb_n
add wave -noupdate -format Literal -radix hexadecimal /tb_dual/uut_0/cache_reg
add wave -noupdate -format Literal -radix hexadecimal /tb_dual/uut_0/data_reg
add wave -noupdate -format Literal -radix hexadecimal /tb_dual/uut_0/special_array
add wave -noupdate -format Literal /tb_dual/uut_0/status_register
add wave -noupdate -format Logic /tb_dual/uut_0/intRb_state
add wave -noupdate -format Logic /tb_dual/uut_0/Wp_n
add wave -noupdate -format Logic /tb_dual/uut_0/PowerUp_Complete
add wave -noupdate -format Logic /tb_dual/uut_0/Pre
add wave -noupdate -format Logic /tb_dual/uut_0/Re_n
add wave -noupdate -format Logic /tb_dual/uut_0/We_n
add wave -noupdate -format Logic /tb_dual/uut_0/Ale
add wave -noupdate -format Logic /tb_dual/uut_0/Cle
add wave -noupdate -format Literal -radix hexadecimal /tb_dual/uut_0/Io
add wave -noupdate -format Literal -radix hexadecimal /tb_dual/uut_0/Io_buf
add wave -noupdate -format Logic /tb_dual/uut_0/cmnd_00h
add wave -noupdate -format Logic /tb_dual/uut_0/cmnd_3Fh
add wave -noupdate -format Logic /tb_dual/uut_0/cmnd_05h
add wave -noupdate -format Logic /tb_dual/uut_0/cmnd_10h
add wave -noupdate -format Logic /tb_dual/uut_0/cmnd_31h
add wave -noupdate -divider UUT_1
add wave -noupdate -format Logic /tb_dual/uut_1/Ce_n
add wave -noupdate -format Logic /tb_dual/uut_1/Rb_n
add wave -noupdate -format Literal -radix hexadecimal /tb_dual/uut_1/cache_reg
add wave -noupdate -format Literal -radix hexadecimal /tb_dual/uut_1/data_reg
add wave -noupdate -format Literal -radix hexadecimal /tb_dual/uut_1/special_array
add wave -noupdate -format Literal -radix binary /tb_dual/uut_1/status_register
add wave -noupdate -format Logic /tb_dual/uut_1/intRb_state
add wave -noupdate -format Logic /tb_dual/uut_1/Wp_n
add wave -noupdate -format Logic /tb_dual/uut_1/PowerUp_Complete
add wave -noupdate -format Logic /tb_dual/uut_1/Pre
add wave -noupdate -format Logic /tb_dual/uut_1/Re_n
add wave -noupdate -format Logic /tb_dual/uut_1/We_n
add wave -noupdate -format Logic /tb_dual/uut_1/Ale
add wave -noupdate -format Logic /tb_dual/uut_1/Cle
add wave -noupdate -format Literal -radix hexadecimal /tb_dual/uut_1/Io
add wave -noupdate -format Literal -radix hexadecimal /tb_dual/uut_1/Io_buf
add wave -noupdate -format Logic /tb_dual/uut_1/cmnd_00h
add wave -noupdate -format Logic /tb_dual/uut_1/cmnd_3Fh
add wave -noupdate -format Logic /tb_dual/uut_1/cmnd_05h
add wave -noupdate -format Logic /tb_dual/uut_1/cmnd_10h
add wave -noupdate -format Logic /tb_dual/uut_1/cmnd_31h
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {0 ns} {1380628 ns} {412998 ns}
WaveRestoreZoom {0 ns} {5250 us}
configure wave -namecolwidth 213
configure wave -valuecolwidth 115
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
