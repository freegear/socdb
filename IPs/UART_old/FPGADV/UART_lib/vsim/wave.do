onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Literal -radix hexadecimal /UART_TOP/PADDR
add wave -noupdate -format Logic -radix hexadecimal /UART_TOP/PENABLE
add wave -noupdate -format Logic -radix hexadecimal /UART_TOP/PSEL
add wave -noupdate -format Literal -radix hexadecimal /UART_TOP/PWDATA
add wave -noupdate -format Logic -radix hexadecimal /UART_TOP/PWRITE
add wave -noupdate -format Logic -radix hexadecimal /UART_TOP/clk
add wave -noupdate -format Logic -radix hexadecimal /UART_TOP/rstb
add wave -noupdate -format Logic -radix hexadecimal /UART_TOP/rxd
add wave -noupdate -format Logic -radix hexadecimal /UART_TOP/RegBlock/baudx16clk_int
add wave -noupdate -format Literal -radix hexadecimal /UART_TOP/RegBlock/clkdiv
add wave -noupdate -format Literal -radix hexadecimal /UART_TOP/RegBlock/clkdivcnt
add wave -noupdate -format Literal -radix hexadecimal /UART_TOP/TxBLK/txfifo
add wave -noupdate -format Literal /UART_TOP/TxBLK/fifodata_tx
add wave -noupdate -format Logic /UART_TOP/txd
add wave -noupdate -format Literal -radix hexadecimal /UART_TOP/TxBLK/txfifocnt
add wave -noupdate -format Literal -radix hexadecimal /UART_TOP/RegBlock/txwaterlevel_int
add wave -noupdate -format Literal -radix hexadecimal /UART_TOP/PRDATA
add wave -noupdate -format Literal -radix hexadecimal /UART_TOP/RegBlock/PRDATA_INT
add wave -noupdate -format Literal /UART_TOP/RegBlock/reg_0x0004
add wave -noupdate -format Logic /UART_TOP/RxBLK/loopbackenb
add wave -noupdate -format Literal /UART_TOP/RxBLK/rxfifo
add wave -noupdate -format Logic /UART_TOP/RxBLK/rxd
add wave -noupdate -format Logic /UART_TOP/RxBLK/rxd_loopback
add wave -noupdate -color Red -format Logic /UART_TOP/RxBLK/rx_lpfd
add wave -noupdate -format Logic /UART_TOP/RxBLK/rxclk
add wave -noupdate -format Logic /UART_TOP/RxBLK/baudx16clk
add wave -noupdate -format Literal /UART_TOP/RxBLK/rxsftreg
add wave -noupdate -format Logic /UART_TOP/RxBLK/rxsftenb
add wave -noupdate -format Literal -radix hexadecimal /UART_TOP/RxBLK/current_state
add wave -noupdate -format Literal -radix hexadecimal /UART_TOP/RxBLK/next_state
add wave -noupdate -format Logic /UART_TOP/rxdmareqb
add wave -noupdate -format Logic /UART_TOP/txdmareqb
add wave -noupdate -format Literal /UART_TOP/RegBlock/rxfifocnt
add wave -noupdate -format Literal /UART_TOP/RegBlock/rxwaterlevel_int
add wave -noupdate -divider RxPart
add wave -noupdate -format Logic /UART_TOP/RxBLK/fifowrb
add wave -noupdate -format Literal -radix unsigned /UART_TOP/RxBLK/fifocnt
add wave -noupdate -format Logic /UART_TOP/RxBLK/fifordb
add wave -noupdate -format Literal -radix unsigned /UART_TOP/RxBLK/fifo_rdpos
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4051990000 ps} 0} {{Cursor 2} {7200000 ps} 0}
configure wave -namecolwidth 188
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
WaveRestoreZoom {6032940 ps} {56020120 ps}
