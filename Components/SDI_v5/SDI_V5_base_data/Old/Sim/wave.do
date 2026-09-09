onerror {resume}
quietly WaveActivateNextPane {} 0
quietly virtual function -install /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager -env /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager { &{/TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/R0[15], /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/R0[14], /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/R0[13], /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/R0[12], /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/R0[11], /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/R0[10], /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/R0[9], /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/R0[8] }} ACLKDIV_R0_15_8
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uFileReader/MTRANS
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uFileReader/MADDR
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uFileReader/HWDATA
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uFileReader/HADDR
add wave -noupdate -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uFileReader/HLOCK
add wave -noupdate -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uFileReader/HWRITE
add wave -noupdate -format Literal -radix binary /TBFM_DTSDI002/DTSDI002/uFileReader/HSIZE
add wave -noupdate -format Literal -radix binary /TBFM_DTSDI002/DTSDI002/uFileReader/HPROT
add wave -noupdate -format Literal -radix binary /TBFM_DTSDI002/DTSDI002/uFileReader/HBURST
add wave -noupdate -format Literal -radix binary /TBFM_DTSDI002/DTSDI002/uFileReader/HTRANS
add wave -noupdate -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uFileReader/HBUSREQ
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uFileReader/HRDATA
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uFileReader/HRESP
add wave -noupdate -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uFileReader/HREADY
add wave -noupdate -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uFileReader/HGRANT
add wave -noupdate -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uFileReader/HRESETn
add wave -noupdate -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uFileReader/HCLK
add wave -noupdate -divider System_Decoder
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uDecoder/HADDR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uDecoder/HSELS0
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uDecoder/HSELS1
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uDecoder/HSELS2
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uDecoder/HSELS3
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uDecoder/HSELS1_0
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uDecoder/HSELS1_1
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uDecoder/HSELS1_2
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uDecoder/HSELS1_3
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uDecoder/HSELSR
add wave -noupdate -divider APBif
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/HCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/HRESETn
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPBif/HADDR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPBif/HTRANS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/HWRITE
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPBif/HWDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/HSEL
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/HREADY
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/SCANENABLE
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPBif/HRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/HREADYOUT
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPBif/HRESP
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPBif/PRDATA
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPBif/PWDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS0
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS1
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS2
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS3
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS4
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS5
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS6
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS7
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS8
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS9
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS10
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS11
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS12
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS13
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS14
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS15
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPBif/PADDR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PWRITE
add wave -noupdate -divider Power_Manager
add wave -noupdate -color Gold -format Logic -itemcolor Gold /TBFM_DTSDI002/DTSDI002/uAPBif/HCLK
add wave -noupdate -color Gold -format Logic -itemcolor Gold /TBFM_DTSDI002/DTSDI002/uAPBif/HRESETn
add wave -noupdate -color Gold -format Literal -itemcolor Gold -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPBif/HADDR
add wave -noupdate -color Gold -format Literal -itemcolor Gold /TBFM_DTSDI002/DTSDI002/uAPBif/HTRANS
add wave -noupdate -color Gold -format Logic -itemcolor Gold /TBFM_DTSDI002/DTSDI002/uAPBif/HWRITE
add wave -noupdate -color Gold -format Literal -itemcolor Gold -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPBif/HWDATA
add wave -noupdate -color Gold -format Logic -itemcolor Gold /TBFM_DTSDI002/DTSDI002/uAPBif/HSEL
add wave -noupdate -color Gold -format Literal -itemcolor Gold -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPBif/HRDATA
add wave -noupdate -color Gold -format Logic -itemcolor Gold /TBFM_DTSDI002/DTSDI002/uAPBif/HREADYOUT
add wave -noupdate -color Gold -format Literal -itemcolor Gold -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPBif/HRESP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/Int_Clrn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/OSC_CLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/EINT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/PCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/PRESETn
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/PADDR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/PSEL
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/PENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/PWRITE
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/PWDATA
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/Sys_CLK_O
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/UART_CLK_O
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/GIE_O
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/UART_INT_SEL
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/AD_CLK_O
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/R1En
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/R0
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/R1
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/ReadRegEn
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/nextPRDATA
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/EINT_OR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/R0_RST
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/Int_Rst_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/Int_Rst_2d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/Int_Clr
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/SCLKDIV_Reg
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/SCLKDIV2
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/SCLKDIV4
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/SCLKDIV8
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/SCLKDIV16
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/SCLKDIV32
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/SCLKDIV128
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/SCLKDIV1024
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/Sys_CLK
add wave -noupdate -format Literal -expand /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/R0_delay4
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/UARTDIV_Reg
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/UARTCLK2
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/UARTCLK4
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/UARTCLK8
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/ACLKDIV_Reg
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/ACLKDIV4
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/ACLKDIV8
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/ACLKDIV16
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/ACLKDIV32
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/ACLKDIV64
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/ACLKDIV128
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/ACLKDIV256
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/ACLKDIV512
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/ACLKDIV_R0_15_8
add wave -noupdate -divider WatchDog
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_WDT/PCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_WDT/PRESETn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_WDT/PENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_WDT/PSEL
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_WDT/PWRITE
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_WDT/PADDR
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_WDT/PWDATA
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_WDT/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_WDT/WDOGRESn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_WDT/WDOGINT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_WDT/WDOGRES
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_WDT/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_WDT/SCANINPCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_WDT/SCANOUTPCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_WDT/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_WDT/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_WDT/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_WDT/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_WDT/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_WDT/R4En
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_WDT/R0
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_WDT/R1
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_WDT/R2
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_WDT/R3
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_WDT/R4
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_WDT/ReadRegs
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_WDT/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_WDT/ReadRegEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_WDT/ReLoad
add wave -noupdate -format Literal -radix unsigned /TBFM_DTSDI002/DTSDI002/uAPB_WDT/WDT_Cnt
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_WDT/WDTISR
add wave -noupdate -format Literal -radix unsigned /TBFM_DTSDI002/DTSDI002/uAPB_WDT/PS_Cnt
add wave -noupdate -format Literal -radix unsigned /TBFM_DTSDI002/DTSDI002/uAPB_WDT/Div_Cnt
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_WDT/DIV
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_WDT/CLKSEL
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_WDT/INTEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_WDT/RSTEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_WDT/WDTEN
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_WDT/PRS_Val
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_WDT/PS_Match
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_WDT/Div_Match
add wave -noupdate -format Literal -radix unsigned /TBFM_DTSDI002/DTSDI002/uAPB_WDT/WDTLDR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_WDT/R2En_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_WDT/R4En_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_WDT/WDTISR_Clr
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_WDT/nRESTOUT_Reg
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_WDT/nRESTOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_WDT/WDT_CLKEN
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 5} {8269666867 ps} 0} {{Cursor 2} {994117 ps} 0}
configure wave -namecolwidth 210
configure wave -valuecolwidth 79
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
WaveRestoreZoom {0 ps} {8683220700 ps}
