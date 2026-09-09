onerror {resume}
quietly WaveActivateNextPane {} 0
quietly virtual function -install /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager -env /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager { &{/TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/R0[15], /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/R0[14], /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/R0[13], /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/R0[12], /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/R0[11], /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/R0[10], /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/R0[9], /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/R0[8] }} ACLKDIV_R0_15_8
quietly virtual function -install /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl -env /TBFM_DTSDI002 { &{/TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/R0[5], /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/R0[4], /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/R0[3], /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/R0[2], /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/R0[1], /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/R0[0] }} R0_5_0
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
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uDecoder/Remap
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uDecoder/HADDR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uDecoder/LoMem
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uDecoder/HSELS_Abort
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uDecoder/HSELS_Resv3
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uDecoder/HSELS_Resv2
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uDecoder/HSELS_Resv1
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uDecoder/HSELS7
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uDecoder/HSELS6
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uDecoder/HSELS5
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uDecoder/HSELS4
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uDecoder/HSELS3
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uDecoder/HSELS2
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uDecoder/HSELS1
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uDecoder/HSELS0
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uDecoder/HSELS0IF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uDecoder/HSELS0EM
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uDecoder/HSELS0R
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uDecoder/HSELS0B
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
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/ACRegEn
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPBif/HaddrReg
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/HwriteReg
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPBif/HaddrMux
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPBif/NextState
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPBif/CurrentState
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/HreadyNext
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iHREADYOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS0Int
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS1Int
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS2Int
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS3Int
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS4Int
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS5Int
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS6Int
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS7Int
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS8Int
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS9Int
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS10Int
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS11Int
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS12Int
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS13Int
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS14Int
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS15Int
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/APBEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PWDATAEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PenableNext
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS0Mux
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS1Mux
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS2Mux
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS3Mux
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS4Mux
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS5Mux
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS6Mux
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS7Mux
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS8Mux
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS9Mux
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS10Mux
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS11Mux
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS12Mux
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS13Mux
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS14Mux
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS15Mux
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS0
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS1
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS2
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS3
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS4
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS5
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS6
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS7
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS8
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS9
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS10
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS11
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS12
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS13
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS14
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS15
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PwriteNext
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
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/PENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/PSEL
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/PWRITE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/PADDR
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
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/nextPRDATA
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/ReadRegs
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/ReadRegEn
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
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/R0_delay4
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
add wave -noupdate -divider ADC_Ctrl
add wave -noupdate -format Logic -itemcolor Gold /TBFM_DTSDI002/DTSDI002/uAPBif/HCLK
add wave -noupdate -format Logic -itemcolor Gold /TBFM_DTSDI002/DTSDI002/uAPBif/HRESETn
add wave -noupdate -format Literal -itemcolor Gold -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPBif/HADDR
add wave -noupdate -format Literal -itemcolor Gold /TBFM_DTSDI002/DTSDI002/uAPBif/HTRANS
add wave -noupdate -format Logic -itemcolor Gold /TBFM_DTSDI002/DTSDI002/uAPBif/HWRITE
add wave -noupdate -format Literal -itemcolor Gold -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPBif/HWDATA
add wave -noupdate -format Logic -itemcolor Gold /TBFM_DTSDI002/DTSDI002/uAPBif/HSEL
add wave -noupdate -format Literal -itemcolor Gold -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPBif/HRDATA
add wave -noupdate -format Logic -itemcolor Gold /TBFM_DTSDI002/DTSDI002/uAPBif/HREADYOUT
add wave -noupdate -format Literal -itemcolor Gold -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPBif/HRESP
add wave -noupdate -color Turquoise -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/PWRITE
add wave -noupdate -color Turquoise -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/PSEL
add wave -noupdate -color Turquoise -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/PENABLE
add wave -noupdate -color Turquoise -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/PRESETn
add wave -noupdate -color Turquoise -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/PCLK
add wave -noupdate -color Turquoise -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/PWDATA
add wave -noupdate -color Turquoise -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/PADDR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/ADC_CKIN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/STC_O_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/STC_Pulse
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/R1
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/R0
add wave -noupdate -format Literal -radix unsigned /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/STC_Cnt
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/ADC_CKIN_Det
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/ADC_CKIN_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/STC_En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/Flag_Neg_Det_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/Flag_Neg_Det
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/Flag_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/ADC_Clock_STBY
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/Interrupt19
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/ReadRegEn
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/iPRDATA
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/ReadRegs
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/nextPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/INV_ADK_CKIN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/Valid
add wave -noupdate -color Yellow -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/STC_O
add wave -noupdate -color Yellow -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/AIN_SEL
add wave -noupdate -color Yellow -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/STBY
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/AD_Data
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/ADC_Flag
add wave -noupdate -color Yellow -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/PRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/ADCDAT_Bit
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/Cycle_Count
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/R0_5_0
add wave -noupdate -divider ADC1395_px
add wave -noupdate -format Literal -itemcolor Yellow /TBFM_DTSDI002/DTSDI002/uAD_SS1395_px/Cycle_Time
add wave -noupdate -format Literal -itemcolor Yellow /TBFM_DTSDI002/DTSDI002/uAD_SS1395_px/AIN_Bit
add wave -noupdate -format Literal -itemcolor Yellow /TBFM_DTSDI002/DTSDI002/uAD_SS1395_px/DOU_Bit
add wave -noupdate -format Literal -itemcolor Yellow /TBFM_DTSDI002/DTSDI002/uAD_SS1395_px/Ch_Sel
add wave -noupdate -format Literal -itemcolor Yellow /TBFM_DTSDI002/DTSDI002/uAD_SS1395_px/A0
add wave -noupdate -format Literal -itemcolor Yellow /TBFM_DTSDI002/DTSDI002/uAD_SS1395_px/A1
add wave -noupdate -format Literal -itemcolor Yellow /TBFM_DTSDI002/DTSDI002/uAD_SS1395_px/A2
add wave -noupdate -format Literal -itemcolor Yellow /TBFM_DTSDI002/DTSDI002/uAD_SS1395_px/A3
add wave -noupdate -format Literal -itemcolor Yellow /TBFM_DTSDI002/DTSDI002/uAD_SS1395_px/A4
add wave -noupdate -format Literal -itemcolor Yellow /TBFM_DTSDI002/DTSDI002/uAD_SS1395_px/A5
add wave -noupdate -format Literal -itemcolor Yellow /TBFM_DTSDI002/DTSDI002/uAD_SS1395_px/A6
add wave -noupdate -format Literal -itemcolor Yellow /TBFM_DTSDI002/DTSDI002/uAD_SS1395_px/A7
add wave -noupdate -format Literal -itemcolor Yellow /TBFM_DTSDI002/DTSDI002/uAD_SS1395_px/A_hiz
add wave -noupdate -format Logic -itemcolor Yellow /TBFM_DTSDI002/DTSDI002/uAD_SS1395_px/STBY
add wave -noupdate -format Analog-Step -itemcolor Yellow -offset 3.0 /TBFM_DTSDI002/DTSDI002/uAD_SS1395_px/AIN
add wave -noupdate -format Logic -itemcolor Yellow /TBFM_DTSDI002/DTSDI002/uAD_SS1395_px/AD_CLK
add wave -noupdate -format Literal -itemcolor Yellow -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAD_SS1395_px/ASEL
add wave -noupdate -format Logic -itemcolor Yellow /TBFM_DTSDI002/DTSDI002/uAD_SS1395_px/STC
add wave -noupdate -format Logic -itemcolor Yellow /TBFM_DTSDI002/DTSDI002/uAD_SS1395_px/EOC
add wave -noupdate -format Literal -itemcolor Yellow -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAD_SS1395_px/AD_OUT
add wave -noupdate -format Literal -itemcolor Yellow /TBFM_DTSDI002/DTSDI002/uAD_SS1395_px/AD_O_nude
add wave -noupdate -format Literal -itemcolor Yellow /TBFM_DTSDI002/DTSDI002/uAD_SS1395_px/Conv_Cnt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 5} {1001178000 ps} 0} {{Cursor 2} {13230000 ps} 0}
configure wave -namecolwidth 388
configure wave -valuecolwidth 63
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
WaveRestoreZoom {33473513 ps} {40894678 ps}
