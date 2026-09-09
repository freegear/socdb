onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Literal /TestTop/DumpCnt
add wave -noupdate -format Logic /TestTop/VideoEncTop/HSYNCn
add wave -noupdate -format Literal -radix unsigned /TestTop/VideoEncTop/Core/TimingGen/H_CNT
add wave -noupdate -format Logic /TestTop/VideoEncTop/Core/TimingGen/ACT_DISPLAY_INTER
add wave -noupdate -format Logic /TestTop/VideoEncTop/VSYNCn
add wave -noupdate -format Logic /TestTop/VideoEncTop/BLANKn
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /TestTop/VideoEncTop/Core/TimingGen/HSYNC_ENABLE
add wave -noupdate -format Literal -radix unsigned /TestTop/VideoEncTop/Core/TimingGen/V_CNT
add wave -noupdate -format Logic /TestTop/VideoEncTop/Core/TimingGen/CLK
add wave -noupdate -format Literal -radix hexadecimal /TestTop/VideoEncTop/Core/Rin
add wave -noupdate -format Literal -radix hexadecimal /TestTop/VideoEncTop/Core/Gin
add wave -noupdate -format Literal -radix hexadecimal /TestTop/VideoEncTop/Core/Bin
add wave -noupdate -format Logic /TestTop/VideoEncTop/Core/TimingGen/V_SET0
add wave -noupdate -format Logic /TestTop/VideoEncTop/Core/TimingGen/V_SET1
add wave -noupdate -format Literal -radix hexadecimal /TestTop/VideoEncTop/Core/RGB2YUV/Rgen
add wave -noupdate -format Literal -radix hexadecimal /TestTop/VideoEncTop/Core/RGB2YUV/Ggen
add wave -noupdate -format Literal -radix hexadecimal /TestTop/VideoEncTop/Core/RGB2YUV/Bgen
add wave -noupdate -format Literal -radix hexadecimal /TestTop/VideoEncTop/Core/RGB2YUV/Y
add wave -noupdate -format Literal -radix hexadecimal /TestTop/VideoEncTop/Core/RGB2YUV/V
add wave -noupdate -format Literal -radix hexadecimal /TestTop/VideoEncTop/Core/RGB2YUV/U
add wave -noupdate -format Literal -radix hexadecimal /TestTop/VideoEncTop/Core/Rout
add wave -noupdate -format Literal -radix hexadecimal /TestTop/VideoEncTop/Core/Gout
add wave -noupdate -format Literal -radix hexadecimal /TestTop/VideoEncTop/Core/Bout
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {721947270 ps} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
update
WaveRestoreZoom {710224725 ps} {726399387 ps}
