onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Literal -radix hexadecimal /VideoTestTop/SSRAM0/addr_width
add wave -noupdate -format Logic -radix hexadecimal /VideoTestTop/SSRAM0/clk0
add wave -noupdate -format Logic -radix hexadecimal /VideoTestTop/SSRAM0/clk1
add wave -noupdate -format Literal -radix hexadecimal /VideoTestTop/SSRAM0/d_width
add wave -noupdate -format Literal -radix hexadecimal /VideoTestTop/SSRAM0/data0
add wave -noupdate -format Literal -radix hexadecimal /VideoTestTop/SSRAM0/data1
add wave -noupdate -format Literal -radix hexadecimal /VideoTestTop/SSRAM0/mem
add wave -noupdate -format Literal -radix hexadecimal /VideoTestTop/SSRAM0/mem_depth
add wave -noupdate -format Literal -radix hexadecimal /VideoTestTop/SSRAM0/q1
add wave -noupdate -format Literal -radix hexadecimal /VideoTestTop/SSRAM0/raddr
add wave -noupdate -format Literal -radix hexadecimal /VideoTestTop/SSRAM0/waddr0
add wave -noupdate -format Literal -radix hexadecimal /VideoTestTop/SSRAM0/waddr1
add wave -noupdate -format Logic -radix hexadecimal /VideoTestTop/SSRAM0/we0
add wave -noupdate -format Logic -radix hexadecimal /VideoTestTop/SSRAM0/we1
add wave -noupdate -format Literal /VideoTestTop/VideoEnC/FIFO_WRITE
add wave -noupdate -format Literal /VideoTestTop/VideoEnC/FIFO_READ
add wave -noupdate -format Literal -radix hexadecimal /VideoTestTop/VideoEnC/MEMADDR
add wave -noupdate -format Logic /VideoTestTop/VideoEnC/RLAST
add wave -noupdate -format Logic /VideoTestTop/VideoEnC/RVALID
add wave -noupdate -format Literal -radix hexadecimal /VideoTestTop/VideoEnC/RDATA
add wave -noupdate -format Logic /VideoTestTop/VideoEnC/FullFIFO
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6029 ps} 0}
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
WaveRestoreZoom {5844 ps} {6316 ps}
