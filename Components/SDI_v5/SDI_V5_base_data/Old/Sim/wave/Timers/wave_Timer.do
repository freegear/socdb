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
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PwriteNext
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS15
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS14
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS13
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS12
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS11
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS10
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS9
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS8
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS7
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS6
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS5
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS4X7
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS4X6
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS4X5
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS4X4
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS4X3
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS4X2
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS4X1
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS4X0
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS4
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS3
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS2
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS1
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iPSELS0
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS15Mux
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS14Mux
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS13Mux
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS12Mux
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS11Mux
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS10Mux
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS9Mux
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS8Mux
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS7Mux
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS6Mux
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS5Mux
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS4Mux7
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS4Mux6
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS4Mux5
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS4Mux4
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS4Mux3
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS4Mux2
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS4Mux1
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS4Mux0
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS4Mux
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS3Mux
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS2Mux
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS1Mux
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS0Mux
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PenableNext
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PWDATAEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/APBEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS15Int
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS14Int
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS13Int
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS12Int
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS11Int
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS10Int
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS9Int
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS8Int
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS7Int
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS6Int
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS5Int
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS4IntX7
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS4IntX6
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS4IntX5
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS4IntX4
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS4IntX3
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS4IntX2
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS4IntX1
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS4IntX0
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS4Int
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS3Int
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS2Int
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS1Int
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PselS0Int
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/iHREADYOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/HreadyNext
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPBif/CurrentState
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPBif/NextState
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPBif/HaddrMux
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/HwriteReg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPBif/HaddrReg
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/ACRegEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS15
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS14
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS4
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PWRITE
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPBif/PADDR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS13
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS12
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS11
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS10
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS9
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS8
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS7
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS6
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS5
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS4X7
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS4X6
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS4X5
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS4X4
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS4X3
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS4X2
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS4X1
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS4X0
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS3
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS2
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS1
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PSELS0
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/PENABLE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPBif/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPBif/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPBif/SCANENABLE
add wave -noupdate -color Gold -format Literal -itemcolor Gold -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPBif/HADDR
add wave -noupdate -color Gold -format Literal -itemcolor Gold -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPBif/HWDATA
add wave -noupdate -color Gold -format Literal -itemcolor Gold /TBFM_DTSDI002/DTSDI002/uAPBif/HTRANS
add wave -noupdate -color Gold -format Logic -itemcolor Gold /TBFM_DTSDI002/DTSDI002/uAPBif/HWRITE
add wave -noupdate -color Gold -format Logic -itemcolor Gold /TBFM_DTSDI002/DTSDI002/uAPBif/HSEL
add wave -noupdate -color Gold -format Logic -itemcolor Gold /TBFM_DTSDI002/DTSDI002/uAPBif/HREADY
add wave -noupdate -color Gold -format Literal -itemcolor Gold /TBFM_DTSDI002/DTSDI002/uAPBif/HRESP
add wave -noupdate -color Gold -format Logic -itemcolor Gold /TBFM_DTSDI002/DTSDI002/uAPBif/HREADYOUT
add wave -noupdate -color Gold -format Literal -itemcolor Gold -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPBif/HRDATA
add wave -noupdate -color Gold -format Logic -itemcolor Gold /TBFM_DTSDI002/DTSDI002/uAPBif/HRESETn
add wave -noupdate -color Gold -format Logic -itemcolor Gold /TBFM_DTSDI002/DTSDI002/uAPBif/HCLK
add wave -noupdate -divider MUXP2B
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uMuxP2B/PselBus
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uMuxP2B/PRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uMuxP2B/PRDATAS13
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uMuxP2B/PRDATAS12
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uMuxP2B/PRDATAS11
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uMuxP2B/PRDATAS10
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uMuxP2B/PRDATAS9
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uMuxP2B/PRDATAS4X7
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uMuxP2B/PRDATAS4X6
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uMuxP2B/PRDATAS4X5
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uMuxP2B/PRDATAS4X4
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uMuxP2B/PRDATAS4X3
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uMuxP2B/PRDATAS4X2
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uMuxP2B/PRDATAS4X1
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uMuxP2B/PRDATAS4X0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uMuxP2B/PRDATAS3
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uMuxP2B/PRDATAS2
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uMuxP2B/PRDATAS1
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uMuxP2B/PRDATAS0
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uMuxP2B/PSELS13
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uMuxP2B/PSELS12
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uMuxP2B/PSELS11
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uMuxP2B/PSELS10
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uMuxP2B/PSELS9
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uMuxP2B/PSELS4X7
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uMuxP2B/PSELS4X6
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uMuxP2B/PSELS4X5
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uMuxP2B/PSELS4X4
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uMuxP2B/PSELS4X3
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uMuxP2B/PSELS4X2
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uMuxP2B/PSELS4X1
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uMuxP2B/PSELS4X0
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uMuxP2B/PSELS3
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uMuxP2B/PSELS2
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uMuxP2B/PSELS1
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uMuxP2B/PSELS0
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
add wave -noupdate -divider Timers0
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
add wave -noupdate -color Turquoise -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/PCLK
add wave -noupdate -color Turquoise -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/PRESETn
add wave -noupdate -color Turquoise -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/PENABLE
add wave -noupdate -color Turquoise -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/PSEL
add wave -noupdate -color Turquoise -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/PWRITE
add wave -noupdate -color Turquoise -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/PADDR
add wave -noupdate -color Turquoise -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/PWDATA
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/R4En
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/nextPRDATA
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/ReadRegs
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/ReadRegEn
add wave -noupdate -color Turquoise -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/PCLK
add wave -noupdate -color Gold -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/OMS
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/TDAT_Value
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/TPWM
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/Timers_CLK
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/Timer_Cnt
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/Timer_Match_Set
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/Timer_Out
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/PWM_Out
add wave -noupdate -color White -format Literal -radix unsigned /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/Prescale_Cnt
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/Prescale_Clock
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/Timers_OverFlow
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/Timers_CLR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/IVT
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/R1
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/R2
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/R3
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX0/R4
add wave -noupdate -divider Timer1
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/PCLK
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/PRESETn
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/PENABLE
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/PSEL
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/PWRITE
add wave -noupdate -color Cyan -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/PADDR
add wave -noupdate -color Cyan -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/R4En
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/R4
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/R3
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/R2
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/R1
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/ReadRegEn
add wave -noupdate -color Gold -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/OMS
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/TDAT_Value
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/TPWM
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/PCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/Timers_CLK
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/Timer_Cnt
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/Timer_Match_Set
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/Timer_Out
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/PWM_Out
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/Prescale_Cnt
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/Prescale_Clock
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/Timers_OverFlow
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/Timers_CLR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX1/IVT
add wave -noupdate -divider Timer2
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/PCLK
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/PRESETn
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/PENABLE
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/PSEL
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/PWRITE
add wave -noupdate -color Cyan -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/PADDR
add wave -noupdate -color Cyan -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/R4En
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/ReadRegEn
add wave -noupdate -color Gold -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/OMS
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/TDAT_Value
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/TPWM
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/PCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/Timers_CLK
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/Timer_Cnt
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/Timer_Match_Set
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/Timer_Out
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/PWM_Out
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/Prescale_Cnt
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/Prescale_Clock
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/Timers_OverFlow
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/Timers_CLR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/IVT
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/R1
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/R2
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/R3
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX2/R4
add wave -noupdate -divider Timer3
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/PCLK
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/PRESETn
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/PENABLE
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/PSEL
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/PWRITE
add wave -noupdate -color Cyan -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/PADDR
add wave -noupdate -color Cyan -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/R4En
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/ReadRegEn
add wave -noupdate -color Gold -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/OMS
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/TDAT_Value
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/TPWM
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/PCLK
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/Timers_CLK
add wave -noupdate -color White -format Literal -radix unsigned /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/Timer_Cnt
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/Timer_Match_Set
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/Timer_Out
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/PWM_Out
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/Prescale_Clock
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/Prescale_Cnt
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/Timers_OverFlow
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/Timers_CLR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/IVT
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/R1
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/R2
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/R3
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX3/R4
add wave -noupdate -divider Timer4
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/PCLK
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/PRESETn
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/PENABLE
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/PSEL
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/PWRITE
add wave -noupdate -color Cyan -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/PADDR
add wave -noupdate -color Cyan -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/R4En
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/ReadRegEn
add wave -noupdate -color Gold -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/OMS
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/TPWM
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/TDAT_Value
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/PCLK
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/Timers_CLK
add wave -noupdate -color White -format Literal -radix unsigned /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/Timer_Cnt
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/Timer_Match_Set
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/Timer_Out
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/PWM_Out
add wave -noupdate -color White -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/Prescale_Cnt
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/Prescale_Clock
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/Timers_OverFlow
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/Timers_CLR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/IVT
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/R1
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/R2
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/R3
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX4/R4
add wave -noupdate -divider Timer5
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/PCLK
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/PRESETn
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/PENABLE
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/PSEL
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/PWRITE
add wave -noupdate -color Cyan -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/PADDR
add wave -noupdate -color Cyan -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/R4En
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/R4
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/R3
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/R2
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/R1
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/ReadRegEn
add wave -noupdate -color Gold -format Literal -radix binary /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/OMS
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/TDAT_Value
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/TPWM
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/PCLK
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/Timers_CLK
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/PCLK
add wave -noupdate -color White -format Literal -radix unsigned /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/Timer_Cnt
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/Timer_Match_Set
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/PWM_Out
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/Timer_Out
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/Prescale_Cnt
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/Prescale_Clock
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/Timers_OverFlow
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/Timers_CLR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX5/IVT
add wave -noupdate -divider Timer6
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/PCLK
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/PRESETn
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/PENABLE
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/PSEL
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/PWRITE
add wave -noupdate -color Cyan -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/PADDR
add wave -noupdate -color Cyan -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/R4En
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/R4
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/R3
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/R2
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/R1
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/ReadRegEn
add wave -noupdate -color Gold -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/OMS
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/TDAT_Value
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/TPWM
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/PCLK
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/Timers_CLK
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/Timer_Cnt
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/Timer_Match_Set
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/Timer_Out
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/PWM_Out
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/Prescale_Cnt
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/Prescale_Clock
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/Timers_OverFlow
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/Timers_CLR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX6/IVT
add wave -noupdate -divider Timer7
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/PCLK
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/PRESETn
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/PENABLE
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/PSEL
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/PWRITE
add wave -noupdate -color Cyan -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/PADDR
add wave -noupdate -color Cyan -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/PWDATA
add wave -noupdate -color Yellow -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/R4En
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/R4
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/R3
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/R2
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/R1
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/ReadRegEn
add wave -noupdate -color Gold -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/OMS
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/TDAT_Value
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/TPWM
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/PCLK
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/Timers_CLK
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/Timer_Cnt
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/Timer_Match_Set
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/PWM_Out
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/Timer_Out
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/Prescale_Cnt
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/Prescale_Clock
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/Timers_OverFlow
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/Timers_CLR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_EAX7/IVT
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 5} {39257988 ps} 0} {{Cursor 2} {174559681 ps} 0}
configure wave -namecolwidth 474
configure wave -valuecolwidth 40
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
WaveRestoreZoom {178365888 ps} {252325312 ps}
