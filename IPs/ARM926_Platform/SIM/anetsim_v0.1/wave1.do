onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /tb/RESETn
add wave -noupdate -format Logic -radix hexadecimal /tb/Clock
add wave -noupdate -format Literal -radix hexadecimal /tb/EXT_ADDR
add wave -noupdate -format Literal -radix hexadecimal /tb/EXT_DATA
add wave -noupdate -format Logic -radix hexadecimal /tb/EXT_CSb
add wave -noupdate -format Logic -radix hexadecimal /tb/EXT_OEb
add wave -noupdate -format Logic -radix hexadecimal /tb/EXT_WEb
add wave -noupdate -format Literal -radix hexadecimal /tb/EXT_BEb
add wave -noupdate -format Literal -radix hexadecimal /tb/EXT_WBEb
add wave -noupdate -format Logic -radix hexadecimal /tb/SD_CLK
add wave -noupdate -format Logic -radix hexadecimal /tb/SD_nCLK
add wave -noupdate -format Literal -radix hexadecimal /tb/SD_ADDR
add wave -noupdate -format Literal -radix hexadecimal /tb/SD_BADDR
add wave -noupdate -format Logic -radix hexadecimal /tb/SD_CSB
add wave -noupdate -format Logic -radix hexadecimal /tb/SD_RASB
add wave -noupdate -format Logic -radix hexadecimal /tb/SD_CASB
add wave -noupdate -format Logic -radix hexadecimal /tb/SD_WEB
add wave -noupdate -format Literal -radix hexadecimal /tb/SD_DQM
add wave -noupdate -format Logic -radix hexadecimal /tb/SD_CKE
add wave -noupdate -format Literal -radix hexadecimal /tb/SD_DQ
add wave -noupdate -format Literal -radix hexadecimal /tb/SD_DQS
add wave -noupdate -format Logic -radix hexadecimal /tb/UART_TXD
add wave -noupdate -format Logic -radix hexadecimal /tb/I2C_SDA
add wave -noupdate -format Logic -radix hexadecimal /tb/I2C_SCL
add wave -noupdate -format Logic -radix hexadecimal /tb/LCDClk
add wave -noupdate -format Logic -radix hexadecimal /tb/LCDHSync
add wave -noupdate -format Logic -radix hexadecimal /tb/LCDVSync
add wave -noupdate -format Logic -radix hexadecimal /tb/LCDDataEn
add wave -noupdate -format Literal -radix hexadecimal /tb/LCDData
add wave -noupdate -format Logic -radix hexadecimal /tb/led_4094clk
add wave -noupdate -format Logic -radix hexadecimal /tb/led_4094d
add wave -noupdate -format Logic -radix hexadecimal /tb/led_4094oe
add wave -noupdate -format Literal -radix hexadecimal /tb/led_4094str
add wave -noupdate -format Logic -radix hexadecimal /tb/MMC_CLKOUT
add wave -noupdate -format Logic -radix hexadecimal /tb/MMC_CMD
add wave -noupdate -format Literal -radix hexadecimal /tb/MMC_DAT
add wave -noupdate -format Logic -radix hexadecimal /tb/SD_Dq
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
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
WaveRestoreZoom {0 ps} {1 us}
