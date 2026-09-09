onerror {resume}
quietly WaveActivateNextPane {} 0
quietly virtual function -install /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager -env /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager { &{/TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/R0[15], /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/R0[14], /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/R0[13], /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/R0[12], /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/R0[11], /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/R0[10], /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/R0[9], /TBFM_DTSDI002/DTSDI002/uAPB_PowerManager/R0[8] }} ACLKDIV_R0_15_8
quietly virtual function -install /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl -env /TBFM_DTSDI002 { &{/TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/R0[5], /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/R0[4], /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/R0[3], /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/R0[2], /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/R0[1], /TBFM_DTSDI002/DTSDI002/uAPB_ADC_Ctrl/R0[0] }} R0_5_0
add wave -noupdate -divider FileReader
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/HRST_Int_Clr
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/TieOffLow
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/MERROR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/MREADY
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/MRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/MWDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/MMASTLOCK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/MPROT
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/MBURST
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/MSIZE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/MWRITE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/MTRANS
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/MADDR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/HWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/HADDR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/HLOCK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/HWRITE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/HSIZE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/HPROT
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/HBURST
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/HTRANS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/HBUSREQ
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/HRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/HRESP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/HREADY
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/HGRANT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/HRESETn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/HCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/Int_Clrn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/PWCLK
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uFileReader/InputFileName
add wave -noupdate -divider FileReadCore
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/ArrayPt
add wave -noupdate -format Literal -radix unsigned /TBFM_DTSDI002/DTSDI002/uFileReader/U1/LoopNumber
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/FileArray_2d_0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/FileArray
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/DataCompare
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/CurrPollState
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/NextPollState
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U1/PollActive
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U1/EnableReg
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U1/iMWRITEReg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/iMTRANSReg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/iMWDATAReg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/iMADDRReg
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U1/iMWRITE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/Cmd
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U1/iMMLOCKReg
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U1/Lock
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U1/iMMLOCK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/iMTRANS
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/iMWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/iMADDR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U1/NextDataError
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U1/DataError
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U1/SlaveError
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/ResultAddr
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/CalcAddr
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/Boundary
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/AddValue
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U1/NonZero
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U1/DirReg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/ProtReg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/SizeReg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/BurstReg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/MaskReg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/DataReg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/AddrReg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/CmdReg
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U1/Dir
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/Prot
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/Size
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/Burst
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/Mask
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/Data
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/Addr
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U1/RdNext
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U1/NotValid
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/MWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/MADDR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U1/MMASTLOCK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U1/MWRITE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/MSIZE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/MPROT
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/MBURST
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/MTRANS
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/MRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U1/MERROR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U1/MREADY
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U1/HRESETn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U1/HCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U1/InputFileName
add wave -noupdate -divider Lite2AHB
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/LockedTransfer
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U2/NextLockState
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U2/LockState
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/LockIdle
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/NextLockIdle
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U2/HtransHold
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U2/HburstHold
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/HlockHold
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U2/HprotHold
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U2/HsizeHold
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/HwriteHold
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U2/HaddrHold
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/HoldSel
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/NextBusyOverride
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/BusyOverride
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/Wrapped
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/WrappedEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/WrappedNext
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U2/CheckAddr
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U2/OffsetAddr
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/FirstTransfer
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U2/HburstMux
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/NextIncrOverride
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/IncrOverride
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/iHREQReg
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/iMREADY
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U2/iHSIZE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U2/iHADDR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/iHBUSREQ
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/AddrDrive
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/DataDrive
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/ReGrant
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/ReBuild
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/SplitRetry
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/HoldReg
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/NextReGrant
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/NextReBuild
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/NextSplitRetry
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/NextHoldReg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U2/State
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U2/NextState
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/MERROR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/MREADY
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U2/MRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U2/MWDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/MMASTLOCK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U2/MPROT
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U2/MBURST
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U2/MSIZE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/MWRITE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U2/MTRANS
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U2/MADDR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/SCANOUTHCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/HLOCK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/HBUSREQ
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U2/HWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U2/HPROT
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U2/HBURST
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U2/HSIZE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/HWRITE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U2/HTRANS
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U2/HADDR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/SCANINHCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/HGRANT
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U2/HRESP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/HREADY
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uFileReader/U2/HRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/HRESETn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uFileReader/U2/HCLK
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
add wave -noupdate -format Literal -itemcolor Gold -expand /TBFM_DTSDI002/DTSDI002/uAPBif/HTRANS
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
add wave -noupdate -format Literal -radix binary -expand /TBFM_DTSDI002/DTSDI002/uFileReader/HTRANS
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
add wave -noupdate -format Logic -itemcolor Yellow /TBFM_DTSDI002/DTSDI002/uAD_SS1395_px/STBY
add wave -noupdate -format Analog-Step -itemcolor Yellow -offset 3.0 /TBFM_DTSDI002/DTSDI002/uAD_SS1395_px/AIN
add wave -noupdate -format Logic -itemcolor Yellow /TBFM_DTSDI002/DTSDI002/uAD_SS1395_px/AD_CLK
add wave -noupdate -format Literal -itemcolor Yellow -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAD_SS1395_px/ASEL
add wave -noupdate -format Logic -itemcolor Yellow /TBFM_DTSDI002/DTSDI002/uAD_SS1395_px/STC
add wave -noupdate -format Logic -itemcolor Yellow /TBFM_DTSDI002/DTSDI002/uAD_SS1395_px/EOC
add wave -noupdate -format Literal -itemcolor Yellow -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAD_SS1395_px/AD_OUT
add wave -noupdate -format Literal -itemcolor Yellow /TBFM_DTSDI002/DTSDI002/uAD_SS1395_px/Conv_Cnt
add wave -noupdate -divider PWM0_0
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
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/PCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/PRESETn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/PENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/PSEL
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/PWRITE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/PADDR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/R4En
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/ReadRegEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/Timer_Match_Set
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/Prescale_Cnt
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/Prescale_Clock
add wave -noupdate -color White -format Literal -radix unsigned /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/Timer_Cnt
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/Timer_Out
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/PWM_Out
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/Timers_OverFlow
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/TDAT_Value
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/Timers_CLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/Timers_CLR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/OMS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/IVT
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/TPWM
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/R1
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/R2
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/R3
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_0/R4
add wave -noupdate -divider PWM0_1
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/PCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/PRESETn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/PENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/PSEL
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/PWRITE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/PADDR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/R4En
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/ReadRegEn
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/Prescale_Cnt
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/Prescale_Clock
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/Timer_Match_Set
add wave -noupdate -color White -format Literal -radix unsigned /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/Timer_Cnt
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/Timer_Out
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/PWM_Out
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/Timers_OverFlow
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/TDAT_Value
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/Timers_CLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/Timers_CLR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/OMS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/IVT
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/TPWM
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/R1
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/R2
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/R3
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_1/R4
add wave -noupdate -divider PWM0_2
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/PCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/PRESETn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/PENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/PSEL
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/PWRITE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/PADDR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/R4En
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/ReadRegEn
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/Timer_Cnt
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/Timer_Match_Set
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/Prescale_Cnt
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/Prescale_Clock
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/Timer_Out
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/Timers_OverFlow
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/PWM_Out
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/TDAT_Value
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/Timers_CLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/Timers_CLR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/OMS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/IVT
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/TPWM
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/R1
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/R2
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/R3
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_2/R4
add wave -noupdate -divider PWM0_3
add wave -noupdate -color Gold -format Logic -itemcolor Gold /TBFM_DTSDI002/DTSDI002/uAPBif/HCLK
add wave -noupdate -color Gold -format Logic -itemcolor Gold /TBFM_DTSDI002/DTSDI002/uAPBif/HRESETn
add wave -noupdate -color White -format Literal -itemcolor Gold -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPBif/HADDR
add wave -noupdate -format Literal -itemcolor Gold -expand /TBFM_DTSDI002/DTSDI002/uAPBif/HTRANS
add wave -noupdate -color Cyan -format Logic -itemcolor Gold /TBFM_DTSDI002/DTSDI002/uAPBif/HWRITE
add wave -noupdate -color Gold -format Literal -itemcolor Gold -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPBif/HWDATA
add wave -noupdate -color Gold -format Logic -itemcolor Gold /TBFM_DTSDI002/DTSDI002/uAPBif/HSEL
add wave -noupdate -color Gold -format Literal -itemcolor Gold -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPBif/HRDATA
add wave -noupdate -color Gold -format Logic -itemcolor Gold /TBFM_DTSDI002/DTSDI002/uAPBif/HREADYOUT
add wave -noupdate -color Gold -format Literal -itemcolor Gold -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPBif/HRESP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/PCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/PRESETn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/PENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/PSEL
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/PWRITE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/PADDR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/PRDATA
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/R0En
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/R1En
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/R2En
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/R3En
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/R4En
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/R0
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/R1
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/R2
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/R3
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/R4
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/IVT
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/TEN
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/ICS
add wave -noupdate -color Gold -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/OMS
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/TPWM
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/CL_Bit
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/Prescale_Clock
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/TCLK
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/TDAT_Value
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/Timers_CLK
add wave -noupdate -color White -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/TCAP
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/Timer_Cnt
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/Timer_Match_Set
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/Timers_OverFlow
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/INT_TPOUT
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/INT_TOF
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/INT_TMC
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/Timer_Out
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/PWM_Out
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/Valid
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/ReadRegEn
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/Prescale_Cnt
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_3/Timers_CLR
add wave -noupdate -divider PWM0_4
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/PCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/PRESETn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/PENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/PSEL
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/PWRITE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/PADDR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/R4En
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/ReadRegEn
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/Timer_Cnt
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/Timer_Match_Set
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/Prescale_Cnt
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/Prescale_Clock
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/Timer_Out
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/Timers_OverFlow
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/PWM_Out
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/TDAT_Value
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/Timers_CLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/Timers_CLR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/OMS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/IVT
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/TPWM
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/R1
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/R2
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/R3
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_4/R4
add wave -noupdate -divider PWM0_5
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/PCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/PRESETn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/PENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/PSEL
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/PWRITE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/PADDR
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/R4En
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/R4
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/R3
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/R2
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/R1
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/ReadRegEn
add wave -noupdate -color Gold -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/OMS
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/TDAT_Value
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/TPWM
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/Timer_Cnt
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/Timers_CLK
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/Timer_Match_Set
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/Timer_Out
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/PWM_Out
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/Prescale_Cnt
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/Prescale_Clock
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/Timers_OverFlow
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/Timers_CLR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_5/IVT
add wave -noupdate -divider PWM0_6
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/PCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/PRESETn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/PENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/PSEL
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/PWRITE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/PADDR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/R4En
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/R4
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/R3
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/R2
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/R1
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/ReadRegEn
add wave -noupdate -color Gold -format Literal -radix binary /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/OMS
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/TPWM
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/Timers_CLK
add wave -noupdate -color White -format Literal -radix unsigned /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/Timer_Cnt
add wave -noupdate -color White -format Logic -radix unsigned /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/Timer_Match_Set
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/Timer_Out
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/PWM_Out
add wave -noupdate -color White -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/Prescale_Cnt
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/Prescale_Clock
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/Timers_OverFlow
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/TDAT_Value
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/Timers_CLR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_6/IVT
add wave -noupdate -divider PWM0_7
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/PCLK
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/PRESETn
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/PENABLE
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/PSEL
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/PWRITE
add wave -noupdate -color Cyan -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/PADDR
add wave -noupdate -color Cyan -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/R4En
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/R4
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/R3
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/R2
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/R1
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/ReadRegEn
add wave -noupdate -color White -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/OMS
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/TDAT_Value
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/TPWM
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/Timers_CLK
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/Timer_Cnt
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/Timer_Match_Set
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/Timer_Out
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/PWM_Out
add wave -noupdate -color White -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/Prescale_Cnt
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/Prescale_Clock
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/Timers_OverFlow
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/Timers_CLR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM0_7/IVT
add wave -noupdate -divider PWM1_0
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/PCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/PRESETn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/PENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/PSEL
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/PWRITE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/PADDR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/R4En
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/ReadRegEn
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/Timer_Cnt
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/Timer_Match_Set
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/Prescale_Cnt
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/Prescale_Clock
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/Timer_Out
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/PWM_Out
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/Timers_OverFlow
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/TDAT_Value
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/Timers_CLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/Timers_CLR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/OMS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/IVT
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/TPWM
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/R1
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/R2
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/R3
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_0/R4
add wave -noupdate -divider PWM1_1
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/PCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/PRESETn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/PENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/PSEL
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/PWRITE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/PADDR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/R4En
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/R4
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/R3
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/R2
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/R1
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/ReadRegEn
add wave -noupdate -color White -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/Timer_Cnt
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/Timer_Match_Set
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/Timer_Out
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/PWM_Out
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/Prescale_Cnt
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/Prescale_Clock
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/Timers_OverFlow
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/TDAT_Value
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/Timers_CLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/Timers_CLR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/OMS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/IVT
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_1/TPWM
add wave -noupdate -divider PWM1_2
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/PCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/PRESETn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/PENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/PSEL
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/PWRITE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/PADDR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/R4En
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/R4
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/R3
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/R2
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/R1
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/ReadRegEn
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/OMS
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/TDAT_Value
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/TPWM
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/Timers_CLK
add wave -noupdate -color White -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/Timer_Cnt
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/Timer_Match_Set
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/PWM_Out
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/Timer_Out
add wave -noupdate -color White -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/Prescale_Cnt
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/Prescale_Clock
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/Timers_OverFlow
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/Timers_CLR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_2/IVT
add wave -noupdate -divider PWM1_3
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/PCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/PRESETn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/PENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/PSEL
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/PWRITE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/PADDR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/R4En
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/R4
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/R3
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/R2
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/R1
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/ReadRegEn
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/OMS
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/TDAT_Value
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/TPWM
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/Timers_CLK
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/Timer_Cnt
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/Timer_Match_Set
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/Timer_Out
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/PWM_Out
add wave -noupdate -color White -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/Prescale_Cnt
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/Prescale_Clock
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/Timers_OverFlow
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/Timers_CLR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_3/IVT
add wave -noupdate -divider PWM1_4
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/PCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/PRESETn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/PENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/PSEL
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/PWRITE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/PADDR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/R4En
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/R4
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/R3
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/R2
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/R1
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/ReadRegEn
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/OMS
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/TDAT_Value
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/TPWM
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/Timer_Cnt
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/Timers_CLK
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/Timer_Match_Set
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/Timer_Out
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/PWM_Out
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/Prescale_Cnt
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/Prescale_Clock
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/Timers_OverFlow
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/Timers_CLR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_4/IVT
add wave -noupdate -divider PWM1_5
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/PCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/PRESETn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/PENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/PSEL
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/PWRITE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/PADDR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/R4En
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/R4
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/R3
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/R2
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/R1
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/ReadRegEn
add wave -noupdate -color Gold -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/OMS
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/TDAT_Value
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/TPWM
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/Timers_CLK
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/Timer_Cnt
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/Timer_Match_Set
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/Timer_Out
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/PWM_Out
add wave -noupdate -color White -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/Prescale_Cnt
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/Prescale_Clock
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/Timers_OverFlow
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/Timers_CLR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_5/IVT
add wave -noupdate -divider PWM1_6
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/PCLK
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/PRESETn
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/PENABLE
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/PSEL
add wave -noupdate -color Cyan -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/PWRITE
add wave -noupdate -color Cyan -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/PADDR
add wave -noupdate -color Cyan -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/R4En
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/R4
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/R3
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/R2
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/R1
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/ReadRegEn
add wave -noupdate -color Gold -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/OMS
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/TDAT_Value
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/TPWM
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/Timers_CLK
add wave -noupdate -color White -format Literal -radix unsigned /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/Timer_Cnt
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/Timer_Match_Set
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/Timer_Out
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/PWM_Out
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/Prescale_Clock
add wave -noupdate -color White -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/Prescale_Cnt
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/Timers_OverFlow
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/Timers_CLR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_6/IVT
add wave -noupdate -divider PWM1_7
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/PCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/PRESETn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/PENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/PSEL
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/PWRITE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/PADDR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/R4En
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/R4
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/R3
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/R2
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/R1
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/ReadRegEn
add wave -noupdate -color Gold -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/OMS
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/TDAT_Value
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/TPWM
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/Timers_CLK
add wave -noupdate -color White -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/Timer_Cnt
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/Timer_Match_Set
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/Timer_Out
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/PWM_Out
add wave -noupdate -color White -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/Prescale_Cnt
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/Prescale_Clock
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/Timers_OverFlow
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/Timers_CLR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM1_7/IVT
add wave -noupdate -divider PWM2_0
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/PCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/PRESETn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/PENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/PSEL
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/PWRITE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/PADDR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/R4En
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/R4
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/R3
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/R2
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/R1
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/ReadRegEn
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/OMS
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/TDAT_Value
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/TPWM
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/Timers_CLK
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/Timer_Cnt
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/Timer_Match_Set
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/PWM_Out
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/Timer_Out
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/Prescale_Cnt
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/Prescale_Clock
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/Timers_OverFlow
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/Timers_CLR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_0/IVT
add wave -noupdate -divider PWM2_1
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/PCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/PRESETn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/PENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/PSEL
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/PWRITE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/PADDR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/R4En
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/R4
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/R3
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/R2
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/R1
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/ReadRegEn
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/OMS
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/TDAT_Value
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/TPWM
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/Timers_CLK
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/Timer_Cnt
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/Timer_Match_Set
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/Timer_Out
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/PWM_Out
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/Prescale_Cnt
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/Prescale_Clock
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/Timers_OverFlow
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/Timers_CLR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_1/IVT
add wave -noupdate -divider PWM2_2
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/PCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/PRESETn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/PENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/PSEL
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/PWRITE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/PADDR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/R4En
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/R4
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/R3
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/R2
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/R1
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/ReadRegEn
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/OMS
add wave -noupdate -color White -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/TDAT_Value
add wave -noupdate -color White -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/TPWM
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/Timers_CLK
add wave -noupdate -color White -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/Timer_Cnt
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/Timer_Match_Set
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/PWM_Out
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/Timer_Out
add wave -noupdate -color White -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/Prescale_Cnt
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/Prescale_Clock
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/Timers_OverFlow
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/Timers_CLR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_2/IVT
add wave -noupdate -divider PWM2_3
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/PCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/PRESETn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/PENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/PSEL
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/PWRITE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/PADDR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/PRDATA
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/R4En
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/R4
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/R3
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/R2
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/R1
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/ReadRegEn
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/OMS
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/TDAT_Value
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/TPWM
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/Timers_CLK
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/Timer_Cnt
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/Timer_Match_Set
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/Timer_Out
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/PWM_Out
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/Prescale_Cnt
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/Prescale_Clock
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/Timers_OverFlow
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/Timers_CLR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_3/IVT
add wave -noupdate -divider PWM2_4
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/PCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/PRESETn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/PENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/PSEL
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/PWRITE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/PADDR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/R4En
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/R4
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/R3
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/R2
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/R1
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/ReadRegEn
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/OMS
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/TDAT_Value
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/TPWM
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/Timers_CLK
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/Timer_Cnt
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/PWM_Out
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/Timer_Out
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/Timer_Match_Set
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/Prescale_Cnt
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/Prescale_Clock
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/Timers_OverFlow
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/Timers_CLR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_4/IVT
add wave -noupdate -divider PWM2_5
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/PCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/PRESETn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/PENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/PSEL
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/PWRITE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/PADDR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/R4En
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/R4
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/R3
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/R2
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/R1
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/ReadRegEn
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/OMS
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/TDAT_Value
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/TPWM
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/Timers_CLK
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/Timer_Cnt
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/Timer_Match_Set
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/PWM_Out
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/Timer_Out
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/Prescale_Cnt
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/Prescale_Clock
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/Timers_OverFlow
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/Timers_CLR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_5/IVT
add wave -noupdate -divider PWM2_6
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/PCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/PRESETn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/PENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/PSEL
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/PWRITE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/PADDR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/R4En
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/R4
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/R3
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/R2
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/R1
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/ReadRegEn
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/OMS
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/TDAT_Value
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/TPWM
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/Timers_CLK
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/Timer_Cnt
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/Timer_Match_Set
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/Timer_Out
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/PWM_Out
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/Prescale_Cnt
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/Prescale_Clock
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/Timers_OverFlow
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/Timers_CLR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_6/IVT
add wave -noupdate -divider PWM2_7
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/PCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/PRESETn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/PENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/PSEL
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/PWRITE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/PADDR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/R4En
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/R4
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/R3
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/R2
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/R1
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/ReadRegEn
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/OMS
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/TDAT_Value
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/TPWM
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/Timers_CLK
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/Timer_Cnt
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/Timer_Match_Set
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/Timer_Out
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/PWM_Out
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/Prescale_Cnt
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/Prescale_Clock
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/Timers_OverFlow
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/Timers_CLR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM2_7/IVT
add wave -noupdate -divider PWM3_0
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/PCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/PRESETn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/PENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/PSEL
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/PWRITE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/PADDR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/R4En
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/R4
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/R3
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/R2
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/R1
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/ReadRegEn
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/OMS
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/TDAT_Value
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/TPWM
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/Timers_CLK
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/Timer_Cnt
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/Timer_Match_Set
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/Timer_Out
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/PWM_Out
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/Prescale_Cnt
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/Prescale_Clock
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/Timers_OverFlow
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/Timers_CLR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_0/IVT
add wave -noupdate -divider PWM3_1
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/PCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/PRESETn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/PENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/PSEL
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/PWRITE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/PADDR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/R4En
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/R4
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/R3
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/R2
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/R1
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/ReadRegEn
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/OMS
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/TDAT_Value
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/TPWM
add wave -noupdate -color White -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/Timer_Cnt
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/Timers_CLK
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/Timer_Match_Set
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/Timer_Out
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/PWM_Out
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/Prescale_Cnt
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/Prescale_Clock
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/Timers_OverFlow
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/Timers_CLR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_1/IVT
add wave -noupdate -divider PWM3_2
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/PCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/PRESETn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/PENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/PSEL
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/PWRITE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/PADDR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/R4En
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/R4
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/R3
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/R2
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/R1
add wave -noupdate -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/ReadRegEn
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/OMS
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/TDAT_Value
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/TPWM
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/Timers_CLK
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/Timer_Cnt
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/Timer_Match_Set
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/Timer_Out
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/PWM_Out
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/Prescale_Cnt
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/Prescale_Clock
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/Timers_OverFlow
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/Timers_CLR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_2/IVT
add wave -noupdate -divider PWM3_3
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/PCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/PRESETn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/PENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/PSEL
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/PWRITE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/PADDR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/R4En
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/ReadRegEn
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/Timer_Cnt
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/Timer_Match_Set
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/Prescale_Cnt
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/Prescale_Clock
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/Timer_Out
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/PWM_Out
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/Timers_OverFlow
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/TDAT_Value
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/Timers_CLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/Timers_CLR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/OMS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/IVT
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/TPWM
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/R1
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/R2
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/R3
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_3/R4
add wave -noupdate -divider PWM3_4
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/PCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/PRESETn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/PENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/PSEL
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/PWRITE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/PADDR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/R4En
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/R4
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/R3
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/R2
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/R1
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/ReadRegEn
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/OMS
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/TPWM
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/TDAT_Value
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/Timers_CLK
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/Timer_Cnt
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/Timer_Match_Set
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/Timer_Out
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/PWM_Out
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/Prescale_Cnt
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/Prescale_Clock
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/Timers_OverFlow
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/Timers_CLR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_4/IVT
add wave -noupdate -divider PWM3_5
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/PCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/PRESETn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/PENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/PSEL
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/PWRITE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/PADDR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/R4En
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/R4
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/R3
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/R2
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/R1
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/ReadRegEn
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/OMS
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/TPWM
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/Timers_CLK
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/Timer_Cnt
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/Timer_Match_Set
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/Timer_Out
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/PWM_Out
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/Prescale_Cnt
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/Prescale_Clock
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/Timers_OverFlow
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/TDAT_Value
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/Timers_CLR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_5/IVT
add wave -noupdate -divider PWM3_6
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/PCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/PRESETn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/PENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/PSEL
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/PWRITE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/PADDR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/R4En
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/R4
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/R3
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/R2
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/R1
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/ReadRegEn
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/OMS
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/TDAT_Value
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/TPWM
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/Timers_CLK
add wave -noupdate -color White -format Literal -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/Timer_Cnt
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/Timer_Match_Set
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/Timer_Out
add wave -noupdate -color White -format Logic -radix hexadecimal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/PWM_Out
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/Prescale_Cnt
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/Prescale_Clock
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/Timers_OverFlow
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/Timers_CLR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_6/IVT
add wave -noupdate -divider PWM3_7
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/PCLK
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/PRESETn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/PENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/PSEL
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/PWRITE
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/PADDR
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/PWDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/PRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/TCLK
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/TCAP
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/INT_TPOUT
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/INT_TOF
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/INT_TMC
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/SCANENABLE
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/Valid
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/R0En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/R1En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/R2En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/R3En
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/R4En
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/R4
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/R3
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/R2
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/R1
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/R0
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/nextPRDATA
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/ReadRegs
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/iPRDATA
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/ReadRegEn
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/OMS
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/Timers_CLK
add wave -noupdate -color White -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/Timer_Cnt
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/Timer_Match_Set
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/Timer_Out
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/PWM_Out
add wave -noupdate -color White -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/Prescale_Cnt
add wave -noupdate -color White -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/Prescale_Clock
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/TDx_CapEn
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/TDX_Up
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/TDX_CapEn_1Pd
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/TCAP_Reg
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/TCAP_Reg_1d
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/Timers_OverFlow
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/TDAT_Value
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/ICS
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/TEN
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/CL_Bit
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/Timers_CLR
add wave -noupdate -format Logic /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/IVT
add wave -noupdate -format Literal /TBFM_DTSDI002/DTSDI002/uAPB_Timers_PWM3_7/TPWM
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 5} {461262000 ps} 0}
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
WaveRestoreZoom {1129184270 ps} {1149634982 ps}
