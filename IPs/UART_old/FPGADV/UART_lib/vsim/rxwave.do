onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /RxBlock/baudx16clk
add wave -noupdate -format Logic /RxBlock/clk
add wave -noupdate -format Logic /RxBlock/rxclk
add wave -noupdate -format Literal -radix hexadecimal /RxBlock/rxclkcnt
add wave -noupdate -format Logic /RxBlock/databit
add wave -noupdate -format Logic /RxBlock/fifordb
add wave -noupdate -format Literal /RxBlock/parity
add wave -noupdate -format Logic /RxBlock/rstb
add wave -noupdate -color Magenta -format Logic /RxBlock/rxd
add wave -noupdate -format Logic /RxBlock/statusrstb
add wave -noupdate -format Logic /RxBlock/stopbit
add wave -noupdate -format Logic /RxBlock/swrstb
add wave -noupdate -format Logic /RxBlock/uartenb
add wave -noupdate -format Logic /RxBlock/bytereceivedb
add wave -noupdate -format Literal -radix hexadecimal /RxBlock/fifodata_rx
add wave -noupdate -format Logic /RxBlock/rxsftenb
add wave -noupdate -format Logic /RxBlock/dataphaseb
add wave -noupdate -format Logic /RxBlock/framechkb
add wave -noupdate -format Logic /RxBlock/frameerrorb
add wave -noupdate -format Logic /RxBlock/paritychkb
add wave -noupdate -format Logic /RxBlock/parityint
add wave -noupdate -format Logic /RxBlock/parity_int
add wave -noupdate -format Logic /RxBlock/overrunerrorb
add wave -noupdate -format Logic /RxBlock/parityerrorb
add wave -noupdate -format Literal /RxBlock/rxfifocnt
add wave -noupdate -format Literal -radix hexadecimal /RxBlock/current_state
add wave -noupdate -format Literal -radix hexadecimal /RxBlock/next_state
add wave -noupdate -format Logic /RxBlock/cst_idle
add wave -noupdate -format Logic /RxBlock/cst_wait_startbit
add wave -noupdate -format Logic /RxBlock/cst_detect_startbit0
add wave -noupdate -format Logic /RxBlock/cst_detect_startbit1
add wave -noupdate -format Logic /RxBlock/cst_detect_startbit2
add wave -noupdate -format Logic /RxBlock/cst_data0
add wave -noupdate -format Logic /RxBlock/cst_data1
add wave -noupdate -format Logic /RxBlock/cst_data2
add wave -noupdate -format Logic /RxBlock/cst_data3
add wave -noupdate -format Logic /RxBlock/cst_data4
add wave -noupdate -format Logic /RxBlock/cst_data5
add wave -noupdate -format Logic /RxBlock/cst_data6
add wave -noupdate -format Logic /RxBlock/cst_data7
add wave -noupdate -format Logic /RxBlock/cst_parity
add wave -noupdate -format Logic /RxBlock/cst_stop0
add wave -noupdate -format Logic /RxBlock/cst_stop1
add wave -noupdate -format Logic /RxBlock/cst_fifowrb
add wave -noupdate -format Literal /RxBlock/i
add wave -noupdate -format Logic /RxBlock/fifowrb
add wave -noupdate -format Literal -radix hexadecimal /RxBlock/fifocnt
add wave -noupdate -format Literal -radix hexadecimal /RxBlock/fifo_wrpos
add wave -noupdate -format Literal -radix hexadecimal /RxBlock/fifo_rdpos
add wave -noupdate -format Literal -radix hexadecimal /RxBlock/rxfifo
add wave -noupdate -format Literal -radix hexadecimal /RxBlock/rxsftreg
add wave -noupdate -format Logic /RxBlock/rxclkenb
add wave -noupdate -format Logic /RxBlock/setstateb
add wave -noupdate -format Logic /RxBlock/rstparityb
add wave -noupdate -format Logic /RxBlock/frameerrorb_int
add wave -noupdate -format Logic /RxBlock/parityerrorb_int
add wave -noupdate -format Logic /RxBlock/fifo_dout
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {566510 ps} 0} {{Cursor 2} {39210000 ps} 0}
WaveRestoreZoom {20849010 ps} {41432160 ps}
configure wave -namecolwidth 197
configure wave -valuecolwidth 117
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
