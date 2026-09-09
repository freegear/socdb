onerror {resume}
quietly WaveActivateNextPane {} 0
quietly virtual signal -install /tb/Top/Core/cpu/DAHB2AXI { (context /tb/Top/Core/cpu/DAHB2AXI )&{DHADDR_0 , DHADDR_1 , DHADDR_2 , DHADDR_3 , DHADDR_4 , DHADDR_5 , DHADDR_6 , DHADDR_7 , DHADDR_8 , DHADDR_9 , DHADDR_10 , DHADDR_11 , DHADDR_12 , DHADDR_13 , DHADDR_14 , DHADDR_15 , DHADDR_16 , DHADDR_17 , DHADDR_18 , DHADDR_19 , DHADDR_20 , DHADDR_21 , DHADDR_22 , DHADDR_23 , DHADDR_24 , DHADDR_25 , DHADDR_26 , DHADDR_27 , DHADDR_28 , DHADDR_29 , DHADDR_30 , DHADDR_31 }} DHADDR
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
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/SevenSegmentCtrl/Clock_c
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
add wave -noupdate -format Literal /tb/Top/Core/cpu/DAHB2AXI/DHADDR
add wave -noupdate -format Logic /tb/Top/Core/cpu/WDATA_ARMD_0
add wave -noupdate -format Logic /tb/Top/Core/cpu/WDATA_ARMD_1
add wave -noupdate -format Logic /tb/Top/Core/cpu/WDATA_ARMD_2
add wave -noupdate -format Logic /tb/Top/Core/cpu/WDATA_ARMD_3
add wave -noupdate -format Logic /tb/Top/Core/cpu/WDATA_ARMD_4
add wave -noupdate -format Logic /tb/Top/Core/cpu/WDATA_ARMD_5
add wave -noupdate -format Logic /tb/Top/Core/cpu/WDATA_ARMD_6
add wave -noupdate -format Logic /tb/Top/Core/cpu/WDATA_ARMD_7
add wave -noupdate -format Logic /tb/Top/Core/cpu/WDATA_ARMD_8
add wave -noupdate -format Logic /tb/Top/Core/cpu/WDATA_ARMD_9
add wave -noupdate -format Logic /tb/Top/Core/cpu/WDATA_ARMD_10
add wave -noupdate -format Logic /tb/Top/Core/cpu/WDATA_ARMD_11
add wave -noupdate -format Logic /tb/Top/Core/cpu/WDATA_ARMD_12
add wave -noupdate -format Logic /tb/Top/Core/cpu/WDATA_ARMD_13
add wave -noupdate -format Logic /tb/Top/Core/cpu/WDATA_ARMD_14
add wave -noupdate -format Logic /tb/Top/Core/cpu/WDATA_ARMD_15
add wave -noupdate -format Logic /tb/Top/Core/cpu/WDATA_ARMD_16
add wave -noupdate -format Logic /tb/Top/Core/cpu/WDATA_ARMD_17
add wave -noupdate -format Logic /tb/Top/Core/cpu/WDATA_ARMD_18
add wave -noupdate -format Logic /tb/Top/Core/cpu/WDATA_ARMD_19
add wave -noupdate -format Logic /tb/Top/Core/cpu/WDATA_ARMD_20
add wave -noupdate -format Logic /tb/Top/Core/cpu/WDATA_ARMD_21
add wave -noupdate -format Logic /tb/Top/Core/cpu/WDATA_ARMD_22
add wave -noupdate -format Logic /tb/Top/Core/cpu/WDATA_ARMD_23
add wave -noupdate -format Logic /tb/Top/Core/cpu/WDATA_ARMD_24
add wave -noupdate -format Logic /tb/Top/Core/cpu/WDATA_ARMD_25
add wave -noupdate -format Logic /tb/Top/Core/cpu/WDATA_ARMD_26
add wave -noupdate -format Logic /tb/Top/Core/cpu/WDATA_ARMD_27
add wave -noupdate -format Logic /tb/Top/Core/cpu/WDATA_ARMD_28
add wave -noupdate -format Logic /tb/Top/Core/cpu/WDATA_ARMD_29
add wave -noupdate -format Logic /tb/Top/Core/cpu/WDATA_ARMD_30
add wave -noupdate -format Logic /tb/Top/Core/cpu/WDATA_ARMD_31
add wave -noupdate -format Logic /tb/Top/Core/cpu/DAHB2AXI/DHTRANS_0
add wave -noupdate -format Logic /tb/Top/Core/cpu/DAHB2AXI/DHTRANS_1
add wave -noupdate -format Logic /tb/Top/Core/cpu/DAHB2AXI/DHSIZE_0
add wave -noupdate -format Logic /tb/Top/Core/cpu/DAHB2AXI/DHSIZE_1
add wave -noupdate -format Logic /tb/Top/Core/cpu/DAHB2AXI/DHBL_0
add wave -noupdate -format Logic /tb/Top/Core/cpu/DAHB2AXI/DHBL_1
add wave -noupdate -format Logic /tb/Top/Core/cpu/DAHB2AXI/DHBL_2
add wave -noupdate -format Logic /tb/Top/Core/cpu/DAHB2AXI/DHBL_3
add wave -noupdate -format Logic /tb/Top/Core/cpu/DAHB2AXI/DHBURST_1
add wave -noupdate -format Logic /tb/Top/Core/cpu/DAHB2AXI/DHBURST_0
add wave -noupdate -format Logic /tb/Top/Core/cpu/DAHB2AXI/DHBURST_2
add wave -noupdate -format Logic /tb/Top/Core/cpu/DAHB2AXI/DHWRITE
add wave -noupdate -format Logic /tb/Top/Core/cpu/DAHB2AXI/DHREADY_OUT
add wave -noupdate -format Literal /tb/Top/Core/cpu/DAHB2AXI/HTRANS_r
add wave -noupdate -format Logic /tb/Top/Core/cpu/RDATA_ARMI_0
add wave -noupdate -format Logic /tb/Top/Core/cpu/RDATA_ARMI_1
add wave -noupdate -format Logic /tb/Top/Core/cpu/RDATA_ARMI_2
add wave -noupdate -format Logic /tb/Top/Core/cpu/RDATA_ARMI_3
add wave -noupdate -format Logic /tb/Top/Core/cpu/RDATA_ARMI_4
add wave -noupdate -format Logic /tb/Top/Core/cpu/RDATA_ARMI_5
add wave -noupdate -format Logic /tb/Top/Core/cpu/RDATA_ARMI_6
add wave -noupdate -format Logic /tb/Top/Core/cpu/RDATA_ARMI_7
add wave -noupdate -format Logic /tb/Top/Core/cpu/RDATA_ARMI_8
add wave -noupdate -format Logic /tb/Top/Core/cpu/RDATA_ARMI_9
add wave -noupdate -format Logic /tb/Top/Core/cpu/RDATA_ARMI_10
add wave -noupdate -format Logic /tb/Top/Core/cpu/RDATA_ARMI_11
add wave -noupdate -format Logic /tb/Top/Core/cpu/RDATA_ARMI_12
add wave -noupdate -format Logic /tb/Top/Core/cpu/RDATA_ARMI_13
add wave -noupdate -format Logic /tb/Top/Core/cpu/RDATA_ARMI_14
add wave -noupdate -format Logic /tb/Top/Core/cpu/RDATA_ARMI_15
add wave -noupdate -format Logic /tb/Top/Core/cpu/RDATA_ARMI_16
add wave -noupdate -format Logic /tb/Top/Core/cpu/RDATA_ARMI_17
add wave -noupdate -format Logic /tb/Top/Core/cpu/RDATA_ARMI_18
add wave -noupdate -format Logic /tb/Top/Core/cpu/RDATA_ARMI_19
add wave -noupdate -format Logic /tb/Top/Core/cpu/RDATA_ARMI_20
add wave -noupdate -format Logic /tb/Top/Core/cpu/RDATA_ARMI_21
add wave -noupdate -format Logic /tb/Top/Core/cpu/RDATA_ARMI_22
add wave -noupdate -format Logic /tb/Top/Core/cpu/RDATA_ARMI_23
add wave -noupdate -format Logic /tb/Top/Core/cpu/RDATA_ARMI_24
add wave -noupdate -format Logic /tb/Top/Core/cpu/RDATA_ARMI_25
add wave -noupdate -format Logic /tb/Top/Core/cpu/RDATA_ARMI_26
add wave -noupdate -format Logic /tb/Top/Core/cpu/RDATA_ARMI_27
add wave -noupdate -format Logic /tb/Top/Core/cpu/RDATA_ARMI_28
add wave -noupdate -format Logic /tb/Top/Core/cpu/RDATA_ARMI_29
add wave -noupdate -format Logic /tb/Top/Core/cpu/RDATA_ARMI_30
add wave -noupdate -format Logic /tb/Top/Core/cpu/RDATA_ARMI_31
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {12864840 ps} 0}
configure wave -namecolwidth 241
configure wave -valuecolwidth 49
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
WaveRestoreZoom {12149214 ps} {13591038 ps}
