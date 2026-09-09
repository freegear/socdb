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
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/led_4094str_c_1
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/led_4094str_c_3
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/led_4094str_c_0
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/led_4094str_c_2
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/GpioOut_i_12
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/GpioOut_i_1
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/GpioOut_i_0
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/GpioOut_i_5
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/GpioOut_i_4
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/GpioOut_i_9
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/GpioOut_11
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/GpioOut_12
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/GpioOut_13
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/GpioOut_1
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/GpioOut_0
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/GpioOut_5
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/GpioOut_4
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/GpioOut_9
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/GpioOut_8
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/GpioOut_6
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/div_clk_i_0
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/RESETn_c
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/led_4094d_c
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/RESETn_c_i
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/Clock_c
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/SevenSegmentCtrl/cnt
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/SevenSegmentCtrl/un8_cnt
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/SevenSegmentCtrl/cnt_4
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/SevenSegmentCtrl/div_cnt
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/SevenSegmentCtrl/div_cnt_5
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/SevenSegmentCtrl/un8_div_cnt
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/div_cnt_i_i
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/SevenSegmentCtrl/led_reg_5
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/SevenSegmentCtrl/led_reg
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/SevenSegmentCtrl/seg_reg_1
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/SevenSegmentCtrl/seg_reg_2
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/SevenSegmentCtrl/seg_reg_3
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/SevenSegmentCtrl/seg_reg_4
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/div_clk
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/un2_div_cnt_i
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/N_274
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/un2_div_cnt
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/g0_combout_3
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/un100_led_4094str_1_3
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/N_252_1
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/N_226
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/un100_led_4094str_1_1_9
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/un100_led_4094str_1_1_7
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/un39_led_4094str_1_0
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/un4_cnt_2
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/un100_led_4094str_2_0
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/un8_cnt_carry_15
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/un8_cnt_carry_14
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/un8_cnt_carry_13
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/un8_cnt_carry_12
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/un8_cnt_carry_11
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/un8_cnt_carry_10
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/un8_cnt_carry_9
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/un8_cnt_carry_8
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/un8_cnt_carry_7
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/un8_cnt_carry_6
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/un8_cnt_carry_5
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/un8_cnt_carry_4
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/un8_cnt_carry_3
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/un8_cnt_carry_2
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/un8_cnt_carry_1
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/GND
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/un8_div_cnt_carry_4
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/un8_div_cnt_carry_3
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/un8_div_cnt_carry_2
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/un8_div_cnt_carry_1
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/N_1
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/N_2
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/VCC
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/tridevclrn
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/tridevpor
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/tridevoe
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
WaveRestoreZoom {0 ps} {2510101 ps}
