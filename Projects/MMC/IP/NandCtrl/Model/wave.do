onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tb/uut_0/intRb_state
add wave -noupdate -divider Command
add wave -noupdate -format Literal /tb/uut_0/data_reg
add wave -noupdate -format Logic /tb/Cle
add wave -noupdate -format Logic /tb/Ale
add wave -noupdate -format Logic /tb/We_n
add wave -noupdate -format Logic /tb/Re_n
add wave -noupdate -format Logic /tb/uut_0/Rb_n
add wave -noupdate -format Logic /tb/Rb_n
add wave -noupdate -format Literal -radix hexadecimal /tb/Io
add wave -noupdate -format Literal -radix hexadecimal /tb/uut_0/Io
add wave -noupdate -format Literal -radix hexadecimal /tb/uut_0/Io_buf
add wave -noupdate -divider Relative
add wave -noupdate -format Literal -radix hexadecimal /tb/uut_0/col_addr
add wave -noupdate -format Literal -radix hexadecimal /tb/uut_0/col_counter
add wave -noupdate -format Logic /tb/uut_0/row_valid
add wave -noupdate -format Logic /tb/uut_0/col_valid
add wave -noupdate -format Logic /tb/uut_0/data_valid
add wave -noupdate -format Logic /tb/uut_0/cache_valid
add wave -noupdate -divider Misc
add wave -noupdate -format Logic /tb/uut_0/saw_cmnd_00h
add wave -noupdate -format Logic /tb/uut_0/cmnd_00h
add wave -noupdate -format Logic /tb/uut_0/cmnd_30h
add wave -noupdate -format Logic /tb/uut_0/cmnd_D0h
add wave -noupdate -format Logic /tb/uut_0/cmnd_05h
add wave -noupdate -format Logic /tb/uut_0/cmnd_15h
add wave -noupdate -format Logic /tb/uut_0/cmnd_70h
add wave -noupdate -format Logic /tb/uut_0/cmnd_80h
add wave -noupdate -format Logic /tb/uut_0/cmnd_85h
add wave -noupdate -format Logic /tb/uut_0/cmnd_10h
add wave -noupdate -format Logic /tb/uut_0/cmnd_FFh
add wave -noupdate -format Logic /tb/Wp_n
add wave -noupdate -format Logic /tb/uut_0/PowerUp_Complete
add wave -noupdate -format Logic /tb/uut_0/do_read_id_2
add wave -noupdate -format Logic /tb/Ce_n
add wave -noupdate -format Logic /tb/Pre
add wave -noupdate -format Logic /tb/uut_0/saw_cmnd_65h
add wave -noupdate -format Literal /tb/uut_0/addr_start
add wave -noupdate -format Literal /tb/uut_0/addr_stop
add wave -noupdate -format Literal -radix hexadecimal /tb/uut_0/Io_buf
add wave -noupdate -format Logic /tb/uut_0/cmnd_90h
add wave -noupdate -format Logic /tb/uut_0/Cle
add wave -noupdate -format Logic /tb/uut_0/Ce_n
add wave -noupdate -format Logic /tb/uut_0/We_n
add wave -noupdate -format Logic /tb/uut_0/Re_n
add wave -noupdate -format Logic /tb/uut_0/Wp_n
add wave -noupdate -format Logic /tb/uut_0/Pre
add wave -noupdate -format Literal -radix hexadecimal /tb/uut_0/Io_buf
add wave -noupdate -format Literal -radix binary /tb/uut_0/row_addr
add wave -noupdate -format Literal /tb/uut_0/status_register
add wave -noupdate -format Logic /tb/uut_0/row_valid
add wave -noupdate -format Literal /tb/uut_0/cache_counter
add wave -noupdate -format Logic /tb/uut_0/cmnd_31h
add wave -noupdate -format Logic /tb/uut_0/cmnd_31h_first_time
add wave -noupdate -format Logic /tb/uut_0/cmnd_35h
add wave -noupdate -format Logic /tb/uut_0/cmnd_3Fh
add wave -noupdate -format Logic /tb/uut_0/cmnd_60h
add wave -noupdate -format Logic /tb/uut_0/cmnd_65h
add wave -noupdate -format Logic /tb/uut_0/cmnd_90h
add wave -noupdate -format Logic /tb/uut_0/cmnd_D0h
add wave -noupdate -format Logic /tb/uut_0/cmnd_E0h
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {27166 ns} {848198 ns} {412998 ns}
WaveRestoreZoom {640 ns} {1314 ns}
configure wave -namecolwidth 213
configure wave -valuecolwidth 115
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
