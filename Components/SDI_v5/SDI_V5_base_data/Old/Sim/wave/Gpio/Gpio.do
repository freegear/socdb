onerror {resume}
quietly WaveActivateNextPane {} 0
quietly virtual function -install /TBFM_DTSDI002/DTSDI002/uAPB_Gpio -env /TBFM_DTSDI002/DTSDI002/uAPB_Gpio { &{/TBFM_DTSDI002/DTSDI002/uAPB_Gpio/R1[6], /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/R1[4], /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/R1[2], /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/R1[0] }} R16_4_2_0
quietly virtual signal -install /TBFM_DTSDI002/DTSDI002/uAPB_Gpio { (context /TBFM_DTSDI002/DTSDI002/uAPB_Gpio )&{Tout[6] , Tout[4] , Tout[2] , Tout[0] }} Tout_ori6_4_2_0
quietly virtual function -install /TBFM_DTSDI002/DTSDI002/uAPB_Gpio -env /TBFM_DTSDI002 { &{/TBFM_DTSDI002/DTSDI002/uAPB_Gpio/Mux_Out0[6], /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/Mux_Out0[4], /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/Mux_Out0[2], /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/Mux_Out0[0] }} Tout6_4_2_0
quietly virtual signal -install /TBFM_DTSDI002 { (context /TBFM_DTSDI002 )&{EINT_Gpio0[7] , EINT_Gpio0[5] , EINT_Gpio0[3] , EINT_Gpio0[1] }} Gpio0_BBBB
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
add wave -noupdate -divider ResetCtrl
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uResetCntl/HCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uResetCntl/TieHig
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uResetCntl/nPOReset
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uResetCntl/WresState
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uResetCntl/NextWdState
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uResetCntl/HresState
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uResetCntl/NextHrState
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uResetCntl/SyncWDR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uResetCntl/WDOGRES
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uResetCntl/nSyncPOR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uResetCntl/WDOGRESn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uResetCntl/HRESETn
add wave -noupdate -divider APB_Gpio
add wave -noupdate -format Logic /TBFM_DTSDI002/GPAD_En0
add wave -noupdate -format Literal /TBFM_DTSDI002/GPAD_En1
add wave -noupdate -format Logic /TBFM_DTSDI002/GPAD_En2
add wave -noupdate -format Logic /TBFM_DTSDI002/GPAD_En3
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/GPADatain0
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/GPADatain1
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/GPADatain2
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/GPADatain3
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/EINT_Gpio0
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/TCAP_Gpio1
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/PWM_Gpio2
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/UART_Gpio3
add wave -noupdate -color Gold -format Logic -itemcolor Gold /TBFM_DTSDI002/DTSDI002/uAPBif/HCLK
add wave -noupdate -color Gold -format Logic -itemcolor Gold /TBFM_DTSDI002/DTSDI002/uAPBif/HRESETn
add wave -noupdate -color Gold -format Literal -itemcolor Gold -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPBif/HADDR
add wave -noupdate -format Literal -itemcolor Gold -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPBif/HTRANS
add wave -noupdate -color Gold -format Logic -itemcolor Gold -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPBif/HWRITE
add wave -noupdate -color Gold -format Literal -itemcolor Gold -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPBif/HWDATA
add wave -noupdate -color Gold -format Logic -itemcolor Gold -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPBif/HSEL
add wave -noupdate -color Gold -format Literal -itemcolor Gold -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPBif/HRDATA
add wave -noupdate -color Gold -format Logic -itemcolor Gold -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPBif/HREADYOUT
add wave -noupdate -color Gold -format Literal -itemcolor Gold -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPBif/HRESP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/PCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/PRESETn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/PENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/PSEL
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/PWRITE
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/PADDR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/PWDATA
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/PRDATA
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/Gpio_IN0
add wave -noupdate -format Literal -radix hexadecimal -expand /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/Gpio_IN1
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/Gpio_IN2
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/Gpio_IN3
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/MEM_ADR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/MEM_BE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/POUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/UART_RXD
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/UART_TXD
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/IrDA_RXD
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/IrDA_TXD
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/MEM_WBE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/MEM_CS
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/GPIO_En0
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/GPIO_En1
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/GPIO_En2
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/GPIO_En3
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/Mux_Out1
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/Mux_Out2
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/Mux_Out3
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/SCANENABLE
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/i
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/R4En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/R5En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/R6En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/R7En
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/R0
add wave -noupdate -format Literal -radix hexadecimal -expand /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/R1
add wave -noupdate -format Literal -radix binary /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/R16_4_2_0
add wave -noupdate -format Logic -height 15 -radix hexadecimal {/TBFM_DTSDI002/DTSDI002/uAPB_Gpio/R1[6]}
add wave -noupdate -format Logic -height 15 -radix hexadecimal {/TBFM_DTSDI002/DTSDI002/uAPB_Gpio/R1[4]}
add wave -noupdate -format Logic -height 15 -radix hexadecimal {/TBFM_DTSDI002/DTSDI002/uAPB_Gpio/R1[2]}
add wave -noupdate -format Logic -height 15 -radix hexadecimal {/TBFM_DTSDI002/DTSDI002/uAPB_Gpio/R1[0]}
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/R2
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/R3
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/R4
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/R5
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/R6
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/R7
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/R0
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/Tout
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/Tout_ori6_4_2_0
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/Tout6_4_2_0
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/Gpio0_BBBB
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/EINT_Gpio0
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/Mux_Out0
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/nextPRDATA
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/ReadRegs
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/iPRDATA
add wave -noupdate -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/ReadRegEn
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/MEM_ADR_BE
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Gpio/UART_MEMBC
add wave -noupdate -divider IO_PAD
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uIO_PAD/Data_Width
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uIO_PAD/Dir_En0
add wave -noupdate -format Literal -radix hexadecimal -expand /TBFM_DTSDI002/DTSDI002/uIO_PAD/Dir_En1
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uIO_PAD/Dir_En2
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uIO_PAD/Dir_En3
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uIO_PAD/Data_Out0
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uIO_PAD/Data_Out1
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uIO_PAD/Data_Out2
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uIO_PAD/Data_Out3
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uIO_PAD/Data_In0
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uIO_PAD/Data_In1
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uIO_PAD/Data_In2
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uIO_PAD/Data_In3
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uIO_PAD/BI_PAD0
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uIO_PAD/BI_PAD1
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uIO_PAD/BI_PAD2
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uIO_PAD/BI_PAD3
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 5} {1158160243 ps} 0}
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
WaveRestoreZoom {1157793365 ps} {1158422566 ps}
