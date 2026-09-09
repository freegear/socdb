onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/Clk
add wave -noupdate -color Goldenrod -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/NState
add wave -noupdate -color Goldenrod -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/CState
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/WaitCnt
add wave -noupdate -divider {New Divider}
add wave -noupdate -color Yellow -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/TNState
add wave -noupdate -color Yellow -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/TCState
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/QLevelIn
add wave -noupdate -divider {First OPER}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RdFIFOReadyOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/WrFIFOReadyOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/RdFIFOReady
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/WrFIFOReady
add wave -noupdate -divider {First OPER}
add wave -noupdate -format Logic /Tb_NFTop/NFDMAReqOut
add wave -noupdate -format Logic /Tb_NFTop/NFINTOut
add wave -noupdate -divider {First OPER}
add wave -noupdate -format Literal /Tb_NFTop/write_data/i
add wave -noupdate -format Literal /Tb_NFTop/write_data/j
add wave -noupdate -format Literal /Tb_NFTop/Data_Read/i
add wave -noupdate -format Literal /Tb_NFTop/Data_Read/j
add wave -noupdate -divider {First OPER}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/ChipSel
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RnBWait
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/AutoRdStat
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/Continue
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/DataSize
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/TransSize
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/CmdAddrTransByte
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/CmdAddrFlag
add wave -noupdate -divider {CMD or ADDR}
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FirstOper
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CmdAddr1
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CmdAddr2
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RdIDEnd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RnBCheckBeforeNextCmd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/WaitEnd
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FirstOper
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/TADLTWBCnt
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CmdTimingEnd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/AddrTimingEnd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CmdAddrTransEnd
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/CmdAddrTransCnt
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/CmdAddrTransByte
add wave -noupdate -color Cyan -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/DataSizeCnt
add wave -noupdate -color Cyan -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/DataSize
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/AddrCntIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/AutoEccWrEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/BoundaryIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/EccDataEnOut
add wave -noupdate -divider {NF Interface}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/DMAReqOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/NFCtrlBusyIn
add wave -noupdate -divider {NF Interface}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/RnB0_Dly
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FiltRnB0In
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/RnB1_Dly
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FiltRnB1In
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/nNFCE0Out
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/nNFCE1Out
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CLEOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/ALEOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/Clk
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/nNFWEOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/nNFREOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFDataIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFDataOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFOutData
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/EccIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFDataOutEnOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal /Tb_NFTop/Data_Read/i
add wave -noupdate -color Goldenrod -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/NState
add wave -noupdate -color Goldenrod -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/CState
add wave -noupdate -divider {NF Data Output}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/BeforeFullIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOFullOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOHalfFullOut
add wave -noupdate -divider {NF Data Output}
add wave -noupdate -color Goldenrod -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/QLevelIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FIFORdDataIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PCLK
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PRESETn
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/PADDR
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PSEL
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PENABLE
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PWRITE
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/PRDATA
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/PWDATA
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uut0/Io
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/PackingCnt
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/ParsingCnt
add wave -noupdate -color {Medium Aquamarine} -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFStatusOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FIFOWrDataEnOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FIFOWrDataOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/TRWHPCnt
add wave -noupdate -color Yellow -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/TNState
add wave -noupdate -color Yellow -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/TCState
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFOutData
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/NextCmd
add wave -noupdate -color Goldenrod -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFWrEnd
add wave -noupdate -color Goldenrod -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RdDataEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FIFORdDataEnOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RdDataEnDly
add wave -noupdate -color Goldenrod -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFWrDataLoad
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/REnReadyCnt
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFORdReadyOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/Clk
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFWrDataReady
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/WrReady
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/Byte_8bitBus
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/Byte_16bitBus
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/HalfWord_8bitBus
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/HalfWord_16bitBus
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/Word_8bitBus
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/Word_16bitBus
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FIFOWrDataOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FIFORdDataEnOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FIFOWrDataOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FIFOWrDataEnOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FIFOFullIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/FIFOLevelSetOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOFullOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOHalfFullOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FIFOEmpty0In
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FIFOEmpty1In
add wave -noupdate -divider {Timing Cnt END}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/TcalsEnd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/TrwlpEnd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/TrwhpEnd
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/ByteShift
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/NextCmd
add wave -noupdate -divider OPMode
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/ReadData
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/ReadStatus
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/ReadID
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/WriteData
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NOP
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/TransSize
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/IOWidth
add wave -noupdate -divider {CMD LOAD}
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/QLevelIn
add wave -noupdate -color Goldenrod -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/NState
add wave -noupdate -color Goldenrod -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/CState
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/LoadCnt
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/LoadEnd
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFOpIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFOpRdEnOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/OperRdEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/OperRdEnDly
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/NFOpWordNum
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FirstOper
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CmdAddr1
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CmdAddr2
add wave -noupdate -divider NFCONF
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFBootEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/IOWidth
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/BootCfg
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/OutDtmn
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/TCALS
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/TRWLP
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/TRWHP
add wave -noupdate -divider NFCTRL
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFCtrlRst
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/AutoEccWr
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/DMAEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/WrEndIntEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RdEndINTEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/EccErrIntEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FIFOintEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RnBIntEn1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RnBIntEn0
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/Clk
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/nRst
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/BootOpRdEnOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/BootOpReadyIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/BootOpIn
add wave -noupdate -divider STATUS
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFIDValidOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFStatValidOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFStatusOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/WrEndOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RdEndOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/NFCTRLIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/NFCONFIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/CurrentState
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/NextState
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/TNextSt
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/TCurrentSt
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFCtrlRst
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/AutoEccWr
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/DMAEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/WrEndIntEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RdEndINTEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/EccErrIntEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FIFOintEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RnBIntEn1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RnBIntEn0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFBootEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/IOWidth
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/BootCfg
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/OutDtmn
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/FirstOper
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CmdAddr1
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CmdAddr2
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CmdTimingEnd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/AddrTimingEnd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RnBHigh
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/WrDataEnd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RdDataEnd
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/NextCmd
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/CmdAddrTransCnt
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CST_Idle
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CST_Load
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CST_Cmd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CST_Addr
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CST_RnBCheck
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CST_Wdata
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CST_Rdata
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CST_Wait2Clk
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NST_Wait2Clk
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NST_Idle
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NST_Load
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NST_Cmd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NST_Addr
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NST_RnBCheck
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NST_Wdata
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NST_Rdata
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFWrEnd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NandWidth
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CTST_Idle
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CTST_TadlTwb
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CTST_Tcals
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CTST_Trwlp
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CTST_Trwhp
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NTST_Idle
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NTST_TadlTwb
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NTST_Tcals
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NTST_Trwlp
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NTST_Trwhp
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/Flush
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/FIFORdData
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RdStatusEnd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/GoTcals
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/GoTrwhp
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/GoIdle
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/GoTadl
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/GoTrwlp0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/GoTrwlp1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/GoTrwlp2
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/GoTrwlp
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/Clk
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/TCALS
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/TRWLP
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/TRWHP
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/TCALSCnt
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/TRWLPCnt
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/TRWHPCnt
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/LoadCnt
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/ByteShift
add wave -noupdate -color Yellow -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/TNState
add wave -noupdate -color Yellow -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/TCState
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/Level
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/nRst
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOFlushIn
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOLevelIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOWrEnIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFORdEnIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOWrDataIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFORdDataOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOFullOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOHalfFullOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/Level
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFORdReadyOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -color Sienna -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOSelRd
add wave -noupdate -color Sienna -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOSelWr
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOCnt0
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/WrPtr0
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/RdPtr0
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOCnt1
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/WrPtr1
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/RdPtr1
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOFull0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOFull1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOEmpty0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOEmpty1
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/Clk
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/nRst
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/QWrEnIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/QRdEnIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/QWrDataIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/QRdDataOut
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/QLevelOut
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/WrPtr
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/RdPtr
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/QCnt
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/QFull
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/QEmpty
add wave -noupdate -divider {New Divider}
add wave -noupdate -color Goldenrod -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/NState
add wave -noupdate -color Goldenrod -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/CState
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/ReadData
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/WriteData
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/RdFIFOReady
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/WrFIFOReady
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PCLK
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PRESETn
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/PADDR
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PSEL
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PENABLE
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PWRITE
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/PWDATA
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/NFSTAT
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/PRDATA
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/nNFBootPinIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/IOWidthPinIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/BootCfgPinIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/OutDtmnPinIn
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/Timing
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/Ctrl
add wave -noupdate -color Gold -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/Control
add wave -noupdate -color Gold -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/Timing_conf
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/ECCSECTOR0
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/ECCSECTOR1
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/ECCSECTOR2
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/ECCSECTOR3
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/ECCSECTOR4
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/ECCSECTOR5
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/ECCSECTOR6
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/ECCSECTOR7
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/SECCSECTOR0
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/SECCSECTOR1
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/SECCSECTOR2
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/SECCSECTOR3
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/SECCSECTOR4
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/SECCSECTOR5
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/SECCSECTOR6
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/SECCSECTOR7
add wave -noupdate -color Orchid -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/EccErrValid
add wave -noupdate -color Orchid -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/MEccErrIn
add wave -noupdate -color Orchid -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/SEccErrIn
add wave -noupdate -color Orchid -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/MECCERR
add wave -noupdate -color Orchid -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/SECCERR
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/NFIDValidIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/NFStatValidIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/NFStatusIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/WrEndIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/RdEndIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/FiltRnB1In
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/FiltRnB0In
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/FIFOFlushIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/FIFORdDataOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/FIFORdDataEnIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/FIFOWrDataIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/FIFOWrDataEnIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/FIFOFullOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/FIFOHalfFullOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/FIFOEmpty0Out
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/FIFOEmpty1Out
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/FIFOLevelSetIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/NFOpRdEnIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/NFOpOut
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/QLevelOut
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/ControlOut
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/ConfigOut
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/NFDATA
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/NFCONF
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/NFCTRL
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/NFSTAT
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/QLevel
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/NFIDValid
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/NFStatValid
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/NFStatus
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/WrEnd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/RdEnd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/RnBDetect1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/RnBDetect0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/RnB1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/RnB0
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/FIFOLevel
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/FIFOWrEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/FIFORdEn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/FIFOWrData
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/FIFORdData
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/APBWriteEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/APBReadEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/QWrEn
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uut0/Io
add wave -noupdate -format Logic /Tb_NFTop/uut0/Cle
add wave -noupdate -format Logic /Tb_NFTop/uut0/Ale
add wave -noupdate -format Logic /Tb_NFTop/uut0/Ce_n
add wave -noupdate -format Logic /Tb_NFTop/uut0/We_n
add wave -noupdate -format Logic /Tb_NFTop/uut0/Re_n
add wave -noupdate -format Logic /Tb_NFTop/uut0/Wp_n
add wave -noupdate -format Logic /Tb_NFTop/uut0/Pre
add wave -noupdate -format Logic /Tb_NFTop/uut0/Rb_n
add wave -noupdate -format Logic /Tb_NFTop/uut0/PowerUp_Complete
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uut0/Io_buf
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/NState
add wave -noupdate -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/CState
add wave -noupdate -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/TNState
add wave -noupdate -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/TCState
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/nNFCE1Out
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CLEOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/ALEOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/nNFWEOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/nNFREOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFDataIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFDataOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFDataOutEnOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/FIFORdDataIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FIFORdDataEnOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FIFOWrDataOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FIFOWrDataEnOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FIFOFullIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/FIFOLevelSetOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/ColumnAddrOut
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/AddrCycleCnt
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/DataSizeCnt
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/EccDataEnOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/AddrValidOut
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/EccDataOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/NFSTAT
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/DMAReqOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/IntReqOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -color Goldenrod -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/NState
add wave -noupdate -color Goldenrod -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/CState
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFboot/Clk
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFboot/nRst
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFboot/NandWidthIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFboot/NFBootIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFboot/IOWidthIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFboot/BootCfgIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFboot/BootOpRdEnIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFboot/BootOpReadyOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFboot/BootOpOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFboot/NFBootEnd
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFboot/SendCnt
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFboot/IterationCnt
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFboot/IterationSize
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFboot/DataSize
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFboot/CmdorAddr
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFboot/Analyze
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFboot/CAddr1
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFboot/CAddr2
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFboot/RAddr1
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFboot/RAddr2
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFboot/RAddr3
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFboot/SendWord
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFboot/TransferByte
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFboot/CmdAddrFlag
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFboot/WhatOper
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/BootEndIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFboot/BootEndOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -color Yellow -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFEcc/AddrCntOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecc_a_Last_256
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecc_a_Last_1024
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecc_b_Last_16bitNand
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SEccLast_256
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SEccLast_1024
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecc_a_Last_512
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecc_a_Last_2048
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecc_b_Last_8bitNand
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SEccLast_512
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SEccLast_2048
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecc_a_LastLoc
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecc_b_LastLoc
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/MEccCalcEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SEccCalcEn
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Clk
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/nRst
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/AddrIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/AddrLoadEnIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/IOWidthIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/NandWidthIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/PageSizeIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/EccRstIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/ErrDetectEnIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecc512EnIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/EccOut
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/AddrCntOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/BoundaryOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/NST_RdataIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/CST_RdataIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/CST_WdataIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/EccDataIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/EccDataEnIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR0
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR1
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR2
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR3
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR4
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR5
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR6
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR7
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR8
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR9
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR10
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR11
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR12
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR13
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR14
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR15
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SECCSECTOR0
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SECCSECTOR1
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SECCSECTOR2
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SECCSECTOR3
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SECCSECTOR4
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SECCSECTOR5
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SECCSECTOR6
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SECCSECTOR7
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/EccErrValid
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/MEccErrOut
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SEccErrOut
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/MainEcc8_0
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/MainEcc8_1
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/MainEcc16
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SpareEcc8_0
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SpareEcc8_1
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SpareEcc16
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/AddrCnt
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/EccErrEn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/MainRegNum_512
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/MainRegNum_256
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/MECCERR
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SECCERR
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/LoopCnt
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/LocCnt
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SpareLoc
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/EccEn8_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/EccEn8_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/EccEn16
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/DataCnt
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Two8BitNand
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SpareEccEn0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SpareEccEn1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/MainEccEn8_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/MainEccEn8_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/LsnLoc
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/AddrCntBit10_Dly
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/AddrCntBit9_Dly
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/AddrCntBit8_Dly
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/AddrCntBit7_Dly
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecc512Init
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecc256Init
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecc128Init
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/MEccInit8
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/MEccInit16
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SEccInit
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/EccInit8
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/EccInit16
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/MainEccValid
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/MainEcc8_H
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SpareEcc8_H
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Nand_512
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Nand_2048
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Nand_256
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Nand_1024
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/RWState
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SpareLoc512
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SpareLoc2048
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SpareLoc256
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SpareLoc1024
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/FirstLsnLoc
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecca512
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecca2048
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/MEccReg_L
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/MEccReg_H
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SEccReg_H
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SEccReg_L
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/MErrStatus_L
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/MErrStatus_H
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SErrStatus_L
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SErrStatus_H
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/MEccCalcEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SEccCalcEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/EccaLastLoc
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/EccbLastLoc
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SEccLastLoc
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/AddrCntBit9_7Dly
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/MErrValid
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SErrValid
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Clk
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/nRst
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/DCntIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/EccRstIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/EccEnIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Ecc512EnIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/EccDataIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/EccInitIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/MainEccOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/SpareEccOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity1_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity1_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity2_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity2_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity4_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity4_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity8_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity8_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity16_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity16_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity32_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity32_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity64_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity64_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity128_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity128_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity256_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity256_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity512_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity512_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity1024_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity1024_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity2048_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity2048_1
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Ecc0
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Ecc1
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Ecc2
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/SEcc0
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/SEcc1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/bit7
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/bit6
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/bit5
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/bit4
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/bit3
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/bit2
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/bit1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/bit0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/LineParity
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Clk
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/nRst
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/DCntIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/EccRstIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/EccEnIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Ecc512EnIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/EccDataIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/EccInitIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/MainEccOut
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/SpareEccOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity1_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity1_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity2_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity2_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity4_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity4_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity8_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity8_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity16_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity16_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity32_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity32_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity64_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity64_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity128_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity128_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity256_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity256_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity512_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity512_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity1024_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity1024_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity2048_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity2048_1
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Ecc0
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Ecc1
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Ecc2
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/SEcc0
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/SEcc1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/bit7
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/bit6
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/bit5
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/bit4
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/bit3
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/bit2
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/bit1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/bit0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/LineParity
add wave -noupdate -divider {New Divider}
add wave -noupdate -color Goldenrod -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFEcc/AddrCntOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/Clk
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/nRst
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/MEccReg_L
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/MEccReg_H
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/SEccReg_L
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/SEccReg_H
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/NandWidthIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/Ecc512EnIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/PageSizeIn
add wave -noupdate -format Literal -radix binary /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/MErrStatus_L
add wave -noupdate -format Literal -radix binary /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/MErrStatus_H
add wave -noupdate -format Literal -radix binary /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/SErrStatus_L
add wave -noupdate -format Literal -radix binary /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/SErrStatus_H
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/MErrValid
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/SErrValid
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/EccXor_L
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/EccXor_H
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SEccLastLoc
add wave -noupdate -color Goldenrod -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFEcc/AddrCntOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/RdDataIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/RdDataEnIn
add wave -noupdate -color Yellow -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/StoredEcc_L
add wave -noupdate -color Yellow -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/StoredEcc_H
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/Correctable_L
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/Correctable_H
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/CntRst8
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/CntRst16
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/EccbCalc
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/CalcMErr
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/MErrDetect
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/MErrValid
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/CalcSErr
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/SErrDetect
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/SErrValid
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/StoredMEcc_L
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/StoredMEcc_H
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/StoredSEcc_L
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/StoredSEcc_H
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/StoredEcc16Nand_256Ecc
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/StoredEcc16Nand_512Ecc
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Clk
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/nRst
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/DCntIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/EccRstIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/EccEnIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Ecc512EnIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/EccDataIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/EccInitIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/MainEccOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/SpareEccOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity1_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity1_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity2_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity2_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity4_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity4_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity8_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity8_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity16_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity16_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity32_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity32_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity64_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity64_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity128_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity128_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity256_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity256_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity512_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity512_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity1024_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity1024_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity2048_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity2048_1
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Ecc0
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Ecc1
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Ecc2
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/SEcc0
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/SEcc1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit15
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit14
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit13
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit12
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit11
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit10
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit9
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit8
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit7
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit6
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit5
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit4
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit3
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit2
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/LineParity
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/Clk
add wave -noupdate -color Goldenrod -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/NState
add wave -noupdate -color Goldenrod -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/CState
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/WaitCnt
add wave -noupdate -divider {New Divider}
add wave -noupdate -color Yellow -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/TNState
add wave -noupdate -color Yellow -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/TCState
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/QLevelIn
add wave -noupdate -divider {First OPER}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RdFIFOReadyOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/WrFIFOReadyOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/RdFIFOReady
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/WrFIFOReady
add wave -noupdate -divider {First OPER}
add wave -noupdate -format Logic /Tb_NFTop/NFDMAReqOut
add wave -noupdate -format Logic /Tb_NFTop/NFINTOut
add wave -noupdate -divider {First OPER}
add wave -noupdate -format Literal /Tb_NFTop/write_data/i
add wave -noupdate -format Literal /Tb_NFTop/write_data/j
add wave -noupdate -format Literal /Tb_NFTop/Data_Read/i
add wave -noupdate -format Literal /Tb_NFTop/Data_Read/j
add wave -noupdate -divider {First OPER}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/ChipSel
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RnBWait
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/AutoRdStat
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/Continue
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/DataSize
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/TransSize
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/CmdAddrTransByte
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/CmdAddrFlag
add wave -noupdate -divider {CMD or ADDR}
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FirstOper
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CmdAddr1
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CmdAddr2
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RdIDEnd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RnBCheckBeforeNextCmd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/WaitEnd
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FirstOper
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/TADLTWBCnt
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CmdTimingEnd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/AddrTimingEnd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CmdAddrTransEnd
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/CmdAddrTransCnt
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/CmdAddrTransByte
add wave -noupdate -color Cyan -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/DataSizeCnt
add wave -noupdate -color Cyan -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/DataSize
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/AddrCntIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/AutoEccWrEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/BoundaryIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/EccDataEnOut
add wave -noupdate -divider {NF Interface}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/DMAReqOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/NFCtrlBusyIn
add wave -noupdate -divider {NF Interface}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/RnB0_Dly
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FiltRnB0In
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/RnB1_Dly
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FiltRnB1In
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/nNFCE0Out
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/nNFCE1Out
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CLEOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/ALEOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/Clk
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/nNFWEOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/nNFREOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFDataIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFDataOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFOutData
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/EccIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFDataOutEnOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal /Tb_NFTop/Data_Read/i
add wave -noupdate -color Goldenrod -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/NState
add wave -noupdate -color Goldenrod -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/CState
add wave -noupdate -divider {NF Data Output}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/BeforeFullIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOFullOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOHalfFullOut
add wave -noupdate -divider {NF Data Output}
add wave -noupdate -color Goldenrod -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/QLevelIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FIFORdDataIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PCLK
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PRESETn
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/PADDR
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PSEL
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PENABLE
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PWRITE
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/PRDATA
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/PWDATA
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uut0/Io
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/PackingCnt
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/ParsingCnt
add wave -noupdate -color {Medium Aquamarine} -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFStatusOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FIFOWrDataEnOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FIFOWrDataOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/TRWHPCnt
add wave -noupdate -color Yellow -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/TNState
add wave -noupdate -color Yellow -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/TCState
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFOutData
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/NextCmd
add wave -noupdate -color Goldenrod -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFWrEnd
add wave -noupdate -color Goldenrod -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RdDataEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FIFORdDataEnOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RdDataEnDly
add wave -noupdate -color Goldenrod -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFWrDataLoad
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/REnReadyCnt
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFORdReadyOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/Clk
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFWrDataReady
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/WrReady
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/Byte_8bitBus
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/Byte_16bitBus
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/HalfWord_8bitBus
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/HalfWord_16bitBus
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/Word_8bitBus
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/Word_16bitBus
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FIFOWrDataOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FIFORdDataEnOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FIFOWrDataOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FIFOWrDataEnOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FIFOFullIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/FIFOLevelSetOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOFullOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOHalfFullOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FIFOEmpty0In
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FIFOEmpty1In
add wave -noupdate -divider {Timing Cnt END}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/TcalsEnd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/TrwlpEnd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/TrwhpEnd
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/ByteShift
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/NextCmd
add wave -noupdate -divider OPMode
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/ReadData
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/ReadStatus
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/ReadID
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/WriteData
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NOP
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/TransSize
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/IOWidth
add wave -noupdate -divider {CMD LOAD}
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/QLevelIn
add wave -noupdate -color Goldenrod -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/NState
add wave -noupdate -color Goldenrod -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/CState
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/LoadCnt
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/LoadEnd
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFOpIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFOpRdEnOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/OperRdEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/OperRdEnDly
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/NFOpWordNum
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FirstOper
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CmdAddr1
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CmdAddr2
add wave -noupdate -divider NFCONF
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFBootEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/IOWidth
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/BootCfg
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/OutDtmn
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/TCALS
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/TRWLP
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/TRWHP
add wave -noupdate -divider NFCTRL
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFCtrlRst
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/AutoEccWr
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/DMAEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/WrEndIntEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RdEndINTEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/EccErrIntEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FIFOintEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RnBIntEn1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RnBIntEn0
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/Clk
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/nRst
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/BootOpRdEnOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/BootOpReadyIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/BootOpIn
add wave -noupdate -divider STATUS
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFIDValidOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFStatValidOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFStatusOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/WrEndOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RdEndOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/NFCTRLIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/NFCONFIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/CurrentState
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/NextState
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/TNextSt
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/TCurrentSt
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFCtrlRst
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/AutoEccWr
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/DMAEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/WrEndIntEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RdEndINTEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/EccErrIntEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FIFOintEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RnBIntEn1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RnBIntEn0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFBootEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/IOWidth
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/BootCfg
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/OutDtmn
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/FirstOper
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CmdAddr1
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CmdAddr2
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CmdTimingEnd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/AddrTimingEnd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RnBHigh
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/WrDataEnd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RdDataEnd
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/NextCmd
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/CmdAddrTransCnt
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CST_Idle
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CST_Load
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CST_Cmd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CST_Addr
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CST_RnBCheck
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CST_Wdata
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CST_Rdata
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CST_Wait2Clk
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NST_Wait2Clk
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NST_Idle
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NST_Load
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NST_Cmd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NST_Addr
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NST_RnBCheck
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NST_Wdata
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NST_Rdata
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFWrEnd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NandWidth
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CTST_Idle
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CTST_TadlTwb
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CTST_Tcals
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CTST_Trwlp
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CTST_Trwhp
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NTST_Idle
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NTST_TadlTwb
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NTST_Tcals
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NTST_Trwlp
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NTST_Trwhp
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/Flush
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/FIFORdData
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RdStatusEnd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/GoTcals
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/GoTrwhp
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/GoIdle
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/GoTadl
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/GoTrwlp0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/GoTrwlp1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/GoTrwlp2
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/GoTrwlp
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/Clk
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/TCALS
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/TRWLP
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/TRWHP
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/TCALSCnt
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/TRWLPCnt
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/TRWHPCnt
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/LoadCnt
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/ByteShift
add wave -noupdate -color Yellow -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/TNState
add wave -noupdate -color Yellow -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/TCState
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/Level
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/nRst
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOFlushIn
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOLevelIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOWrEnIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFORdEnIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOWrDataIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFORdDataOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOFullOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOHalfFullOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/Level
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFORdReadyOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -color Sienna -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOSelRd
add wave -noupdate -color Sienna -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOSelWr
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOCnt0
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/WrPtr0
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/RdPtr0
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOCnt1
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/WrPtr1
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/RdPtr1
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOFull0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOFull1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOEmpty0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOEmpty1
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/Clk
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/nRst
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/QWrEnIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/QRdEnIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/QWrDataIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/QRdDataOut
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/QLevelOut
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/WrPtr
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/RdPtr
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/QCnt
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/QFull
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/QEmpty
add wave -noupdate -divider {New Divider}
add wave -noupdate -color Goldenrod -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/NState
add wave -noupdate -color Goldenrod -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/CState
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/ReadData
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/WriteData
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/RdFIFOReady
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/WrFIFOReady
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PCLK
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PRESETn
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/PADDR
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PSEL
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PENABLE
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PWRITE
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/PWDATA
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/NFSTAT
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/PRDATA
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/nNFBootPinIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/IOWidthPinIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/BootCfgPinIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/OutDtmnPinIn
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/Timing
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/Ctrl
add wave -noupdate -color Gold -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/Control
add wave -noupdate -color Gold -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/Timing_conf
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/ECCSECTOR0
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/ECCSECTOR1
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/ECCSECTOR2
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/ECCSECTOR3
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/ECCSECTOR4
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/ECCSECTOR5
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/ECCSECTOR6
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/ECCSECTOR7
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/SECCSECTOR0
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/SECCSECTOR1
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/SECCSECTOR2
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/SECCSECTOR3
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/SECCSECTOR4
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/SECCSECTOR5
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/SECCSECTOR6
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/SECCSECTOR7
add wave -noupdate -color Orchid -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/EccErrValid
add wave -noupdate -color Orchid -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/MEccErrIn
add wave -noupdate -color Orchid -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/SEccErrIn
add wave -noupdate -color Orchid -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/MECCERR
add wave -noupdate -color Orchid -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/SECCERR
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/NFIDValidIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/NFStatValidIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/NFStatusIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/WrEndIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/RdEndIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/FiltRnB1In
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/FiltRnB0In
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/FIFOFlushIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/FIFORdDataOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/FIFORdDataEnIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/FIFOWrDataIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/FIFOWrDataEnIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/FIFOFullOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/FIFOHalfFullOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/FIFOEmpty0Out
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/FIFOEmpty1Out
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/FIFOLevelSetIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/NFOpRdEnIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/NFOpOut
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/QLevelOut
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/ControlOut
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/ConfigOut
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/NFDATA
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/NFCONF
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/NFCTRL
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/NFSTAT
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/QLevel
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/NFIDValid
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/NFStatValid
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/NFStatus
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/WrEnd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/RdEnd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/RnBDetect1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/RnBDetect0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/RnB1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/RnB0
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/FIFOLevel
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/FIFOWrEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/FIFORdEn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/FIFOWrData
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/FIFORdData
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/APBWriteEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/APBReadEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/QWrEn
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uut0/Io
add wave -noupdate -format Logic /Tb_NFTop/uut0/Cle
add wave -noupdate -format Logic /Tb_NFTop/uut0/Ale
add wave -noupdate -format Logic /Tb_NFTop/uut0/Ce_n
add wave -noupdate -format Logic /Tb_NFTop/uut0/We_n
add wave -noupdate -format Logic /Tb_NFTop/uut0/Re_n
add wave -noupdate -format Logic /Tb_NFTop/uut0/Wp_n
add wave -noupdate -format Logic /Tb_NFTop/uut0/Pre
add wave -noupdate -format Logic /Tb_NFTop/uut0/Rb_n
add wave -noupdate -format Logic /Tb_NFTop/uut0/PowerUp_Complete
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uut0/Io_buf
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/NState
add wave -noupdate -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/CState
add wave -noupdate -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/TNState
add wave -noupdate -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/TCState
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/nNFCE1Out
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CLEOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/ALEOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/nNFWEOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/nNFREOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFDataIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFDataOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFDataOutEnOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/FIFORdDataIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FIFORdDataEnOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FIFOWrDataOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FIFOWrDataEnOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FIFOFullIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/FIFOLevelSetOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/ColumnAddrOut
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/AddrCycleCnt
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/DataSizeCnt
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/EccDataEnOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/AddrValidOut
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/EccDataOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/NFSTAT
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/DMAReqOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/IntReqOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -color Goldenrod -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/NState
add wave -noupdate -color Goldenrod -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/CState
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFboot/Clk
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFboot/nRst
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFboot/NandWidthIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFboot/NFBootIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFboot/IOWidthIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFboot/BootCfgIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFboot/BootOpRdEnIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFboot/BootOpReadyOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFboot/BootOpOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFboot/NFBootEnd
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFboot/SendCnt
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFboot/IterationCnt
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFboot/IterationSize
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFboot/DataSize
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFboot/CmdorAddr
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFboot/Analyze
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFboot/CAddr1
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFboot/CAddr2
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFboot/RAddr1
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFboot/RAddr2
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFboot/RAddr3
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFboot/SendWord
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFboot/TransferByte
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFboot/CmdAddrFlag
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFboot/WhatOper
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/BootEndIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFboot/BootEndOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -color Yellow -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFEcc/AddrCntOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecc_a_Last_256
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecc_a_Last_1024
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecc_b_Last_16bitNand
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SEccLast_256
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SEccLast_1024
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecc_a_Last_512
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecc_a_Last_2048
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecc_b_Last_8bitNand
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SEccLast_512
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SEccLast_2048
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecc_a_LastLoc
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecc_b_LastLoc
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/MEccCalcEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SEccCalcEn
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Clk
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/nRst
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/AddrIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/AddrLoadEnIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/IOWidthIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/NandWidthIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/PageSizeIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/EccRstIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/ErrDetectEnIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecc512EnIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/EccOut
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/AddrCntOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/BoundaryOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/NST_RdataIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/CST_RdataIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/CST_WdataIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/EccDataIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/EccDataEnIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR0
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR1
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR2
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR3
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR4
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR5
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR6
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR7
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR8
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR9
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR10
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR11
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR12
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR13
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR14
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR15
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/SECCSECTOR0
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/SECCSECTOR1
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/SECCSECTOR2
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/SECCSECTOR3
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/SECCSECTOR4
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/SECCSECTOR5
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/SECCSECTOR6
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/SECCSECTOR7
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/EccErrValid
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/MEccErrOut
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SEccErrOut
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/MainEcc8_0
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/MainEcc8_1
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/MainEcc16
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SpareEcc8_0
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SpareEcc8_1
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SpareEcc16
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/AddrCnt
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/EccErrEn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/MainRegNum_512
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/MainRegNum_256
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/MECCERR
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SECCERR
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/LoopCnt
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/LocCnt
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SpareLoc
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/EccEn8_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/EccEn8_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/EccEn16
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/DataCnt
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Two8BitNand
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SpareEccEn0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SpareEccEn1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/MainEccEn8_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/MainEccEn8_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/LsnLoc
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/AddrCntBit10_Dly
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/AddrCntBit9_Dly
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/AddrCntBit8_Dly
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/AddrCntBit7_Dly
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecc512Init
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecc256Init
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecc128Init
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/MEccInit8
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/MEccInit16
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SEccInit
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/EccInit8
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/EccInit16
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/MainEccValid
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/MainEcc8_H
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SpareEcc8_H
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Nand_512
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Nand_2048
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Nand_256
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Nand_1024
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/RWState
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SpareLoc512
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SpareLoc2048
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SpareLoc256
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SpareLoc1024
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/FirstLsnLoc
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecca512
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecca2048
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/MEccReg_L
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/MEccReg_H
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SEccReg_H
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SEccReg_L
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/MErrStatus_L
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/MErrStatus_H
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SErrStatus_L
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SErrStatus_H
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/MEccCalcEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SEccCalcEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/EccaLastLoc
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/EccbLastLoc
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SEccLastLoc
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/AddrCntBit9_7Dly
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/MErrValid
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SErrValid
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Clk
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/nRst
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/DCntIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/EccRstIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/EccEnIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Ecc512EnIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/EccDataIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/EccInitIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/MainEccOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/SpareEccOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity1_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity1_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity2_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity2_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity4_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity4_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity8_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity8_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity16_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity16_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity32_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity32_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity64_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity64_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity128_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity128_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity256_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity256_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity512_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity512_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity1024_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity1024_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity2048_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity2048_1
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Ecc0
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Ecc1
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Ecc2
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/SEcc0
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/SEcc1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/bit7
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/bit6
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/bit5
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/bit4
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/bit3
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/bit2
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/bit1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/bit0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/LineParity
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Clk
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/nRst
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/DCntIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/EccRstIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/EccEnIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Ecc512EnIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/EccDataIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/EccInitIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/MainEccOut
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/SpareEccOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity1_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity1_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity2_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity2_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity4_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity4_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity8_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity8_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity16_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity16_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity32_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity32_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity64_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity64_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity128_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity128_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity256_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity256_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity512_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity512_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity1024_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity1024_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity2048_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity2048_1
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Ecc0
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Ecc1
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Ecc2
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/SEcc0
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/SEcc1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/bit7
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/bit6
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/bit5
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/bit4
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/bit3
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/bit2
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/bit1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/bit0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/LineParity
add wave -noupdate -divider {New Divider}
add wave -noupdate -color Goldenrod -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFEcc/AddrCntOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/Clk
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/nRst
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/MEccReg_L
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/MEccReg_H
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/SEccReg_L
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/SEccReg_H
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/NandWidthIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/Ecc512EnIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/PageSizeIn
add wave -noupdate -format Literal -radix binary /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/MErrStatus_L
add wave -noupdate -format Literal -radix binary /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/MErrStatus_H
add wave -noupdate -format Literal -radix binary /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/SErrStatus_L
add wave -noupdate -format Literal -radix binary /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/SErrStatus_H
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/MErrValid
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/SErrValid
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/EccXor_L
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/EccXor_H
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SEccLastLoc
add wave -noupdate -color Goldenrod -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFEcc/AddrCntOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/RdDataIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/RdDataEnIn
add wave -noupdate -color Yellow -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/StoredEcc_L
add wave -noupdate -color Yellow -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/StoredEcc_H
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/Correctable_L
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/Correctable_H
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/CntRst8
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/CntRst16
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/EccbCalc
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/CalcMErr
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/MErrDetect
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/MErrValid
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/CalcSErr
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/SErrDetect
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/SErrValid
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/StoredMEcc_L
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/StoredMEcc_H
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/StoredSEcc_L
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/StoredSEcc_H
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/StoredEcc16Nand_256Ecc
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/StoredEcc16Nand_512Ecc
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Clk
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/nRst
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/DCntIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/EccRstIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/EccEnIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Ecc512EnIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/EccDataIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/EccInitIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/MainEccOut
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/SpareEccOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity1_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity1_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity2_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity2_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity4_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity4_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity8_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity8_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity16_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity16_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity32_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity32_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity64_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity64_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity128_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity128_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity256_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity256_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity512_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity512_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity1024_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity1024_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity2048_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity2048_1
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Ecc0
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Ecc1
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Ecc2
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/SEcc0
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/SEcc1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit15
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit14
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit13
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit12
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit11
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit10
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit9
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit8
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit7
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit6
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit5
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit4
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit3
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit2
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/LineParity
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/Clk
add wave -noupdate -color Goldenrod -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/NState
add wave -noupdate -color Goldenrod -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/CState
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/WaitCnt
add wave -noupdate -divider {New Divider}
add wave -noupdate -color Yellow -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/TNState
add wave -noupdate -color Yellow -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/TCState
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/QLevelIn
add wave -noupdate -divider {First OPER}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RdFIFOReadyOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/WrFIFOReadyOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/RdFIFOReady
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/WrFIFOReady
add wave -noupdate -divider {First OPER}
add wave -noupdate -format Logic /Tb_NFTop/NFDMAReqOut
add wave -noupdate -format Logic /Tb_NFTop/NFINTOut
add wave -noupdate -divider {First OPER}
add wave -noupdate -format Literal /Tb_NFTop/write_data/i
add wave -noupdate -format Literal /Tb_NFTop/write_data/j
add wave -noupdate -format Literal /Tb_NFTop/Data_Read/i
add wave -noupdate -format Literal /Tb_NFTop/Data_Read/j
add wave -noupdate -divider {First OPER}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/ChipSel
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RnBWait
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/AutoRdStat
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/Continue
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/DataSize
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/TransSize
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/CmdAddrTransByte
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/CmdAddrFlag
add wave -noupdate -divider {CMD or ADDR}
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FirstOper
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CmdAddr1
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CmdAddr2
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RdIDEnd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RnBCheckBeforeNextCmd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/WaitEnd
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FirstOper
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/TADLTWBCnt
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CmdTimingEnd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/AddrTimingEnd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CmdAddrTransEnd
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/CmdAddrTransCnt
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/CmdAddrTransByte
add wave -noupdate -color Cyan -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/DataSizeCnt
add wave -noupdate -color Cyan -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/DataSize
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/AddrCntIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/AutoEccWrEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/BoundaryIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/EccDataEnOut
add wave -noupdate -divider {NF Interface}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/DMAReqOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/NFCtrlBusyIn
add wave -noupdate -divider {NF Interface}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/RnB0_Dly
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FiltRnB0In
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/RnB1_Dly
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FiltRnB1In
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/nNFCE0Out
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/nNFCE1Out
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CLEOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/ALEOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/Clk
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/nNFWEOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/nNFREOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFDataIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFDataOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFOutData
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/EccIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFDataOutEnOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal /Tb_NFTop/Data_Read/i
add wave -noupdate -color Goldenrod -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/NState
add wave -noupdate -color Goldenrod -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/CState
add wave -noupdate -divider {NF Data Output}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/BeforeFullIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOFullOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOHalfFullOut
add wave -noupdate -divider {NF Data Output}
add wave -noupdate -color Goldenrod -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/QLevelIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FIFORdDataIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PCLK
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PRESETn
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/PADDR
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PSEL
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PENABLE
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PWRITE
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/PRDATA
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/PWDATA
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uut0/Io
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/PackingCnt
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/ParsingCnt
add wave -noupdate -color {Medium Aquamarine} -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFStatusOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FIFOWrDataEnOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FIFOWrDataOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/TRWHPCnt
add wave -noupdate -color Yellow -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/TNState
add wave -noupdate -color Yellow -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/TCState
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFOutData
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/NextCmd
add wave -noupdate -color Goldenrod -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFWrEnd
add wave -noupdate -color Goldenrod -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RdDataEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FIFORdDataEnOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RdDataEnDly
add wave -noupdate -color Goldenrod -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFWrDataLoad
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/REnReadyCnt
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFORdReadyOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/Clk
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFWrDataReady
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/WrReady
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/Byte_8bitBus
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/Byte_16bitBus
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/HalfWord_8bitBus
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/HalfWord_16bitBus
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/Word_8bitBus
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/Word_16bitBus
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FIFOWrDataOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FIFORdDataEnOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FIFOWrDataOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FIFOWrDataEnOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FIFOFullIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/FIFOLevelSetOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOFullOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOHalfFullOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FIFOEmpty0In
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FIFOEmpty1In
add wave -noupdate -divider {Timing Cnt END}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/TcalsEnd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/TrwlpEnd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/TrwhpEnd
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/ByteShift
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/NextCmd
add wave -noupdate -divider OPMode
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/ReadData
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/ReadStatus
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/ReadID
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/WriteData
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NOP
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/TransSize
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/IOWidth
add wave -noupdate -divider {CMD LOAD}
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/QLevelIn
add wave -noupdate -color Goldenrod -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/NState
add wave -noupdate -color Goldenrod -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/CState
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/LoadCnt
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/LoadEnd
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFOpIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFOpRdEnOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/OperRdEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/OperRdEnDly
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/NFOpWordNum
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FirstOper
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CmdAddr1
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CmdAddr2
add wave -noupdate -divider NFCONF
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFBootEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/IOWidth
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/BootCfg
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/OutDtmn
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/TCALS
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/TRWLP
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/TRWHP
add wave -noupdate -divider NFCTRL
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFCtrlRst
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/AutoEccWr
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/DMAEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/WrEndIntEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RdEndINTEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/EccErrIntEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FIFOintEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RnBIntEn1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RnBIntEn0
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/Clk
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/nRst
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/BootOpRdEnOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/BootOpReadyIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/BootOpIn
add wave -noupdate -divider STATUS
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFIDValidOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFStatValidOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFStatusOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/WrEndOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RdEndOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/NFCTRLIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/NFCONFIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/CurrentState
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/NextState
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/TNextSt
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/TCurrentSt
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFCtrlRst
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/AutoEccWr
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/DMAEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/WrEndIntEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RdEndINTEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/EccErrIntEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FIFOintEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RnBIntEn1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RnBIntEn0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFBootEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/IOWidth
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/BootCfg
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/OutDtmn
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/FirstOper
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CmdAddr1
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CmdAddr2
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CmdTimingEnd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/AddrTimingEnd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RnBHigh
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/WrDataEnd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RdDataEnd
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/NextCmd
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/CmdAddrTransCnt
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CST_Idle
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CST_Load
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CST_Cmd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CST_Addr
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CST_RnBCheck
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CST_Wdata
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CST_Rdata
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CST_Wait2Clk
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NST_Wait2Clk
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NST_Idle
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NST_Load
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NST_Cmd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NST_Addr
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NST_RnBCheck
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NST_Wdata
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NST_Rdata
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFWrEnd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NandWidth
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CTST_Idle
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CTST_TadlTwb
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CTST_Tcals
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CTST_Trwlp
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CTST_Trwhp
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NTST_Idle
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NTST_TadlTwb
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NTST_Tcals
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NTST_Trwlp
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NTST_Trwhp
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/Flush
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/FIFORdData
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RdStatusEnd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/GoTcals
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/GoTrwhp
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/GoIdle
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/GoTadl
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/GoTrwlp0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/GoTrwlp1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/GoTrwlp2
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/GoTrwlp
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/Clk
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/TCALS
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/TRWLP
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/TRWHP
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/TCALSCnt
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/TRWLPCnt
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/TRWHPCnt
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/LoadCnt
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/ByteShift
add wave -noupdate -color Yellow -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/TNState
add wave -noupdate -color Yellow -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/TCState
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/Level
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/nRst
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOFlushIn
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOLevelIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOWrEnIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFORdEnIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOWrDataIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFORdDataOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOFullOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOHalfFullOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/Level
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFORdReadyOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -color Sienna -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOSelRd
add wave -noupdate -color Sienna -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOSelWr
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOCnt0
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/WrPtr0
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/RdPtr0
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOCnt1
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/WrPtr1
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/RdPtr1
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOFull0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOFull1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOEmpty0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOEmpty1
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/Clk
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/nRst
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/QWrEnIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/QRdEnIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/QWrDataIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/QRdDataOut
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/QLevelOut
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/WrPtr
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/RdPtr
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/QCnt
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/QFull
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/QEmpty
add wave -noupdate -divider {New Divider}
add wave -noupdate -color Goldenrod -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/NState
add wave -noupdate -color Goldenrod -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/CState
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/ReadData
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/WriteData
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/RdFIFOReady
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/WrFIFOReady
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PCLK
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PRESETn
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/PADDR
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PSEL
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PENABLE
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PWRITE
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/PWDATA
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/NFSTAT
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/PRDATA
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/nNFBootPinIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/IOWidthPinIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/BootCfgPinIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/OutDtmnPinIn
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/Timing
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/Ctrl
add wave -noupdate -color Gold -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/Control
add wave -noupdate -color Gold -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/Timing_conf
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/ECCSECTOR0
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/ECCSECTOR1
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/ECCSECTOR2
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/ECCSECTOR3
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/ECCSECTOR4
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/ECCSECTOR5
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/ECCSECTOR6
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/ECCSECTOR7
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/SECCSECTOR0
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/SECCSECTOR1
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/SECCSECTOR2
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/SECCSECTOR3
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/SECCSECTOR4
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/SECCSECTOR5
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/SECCSECTOR6
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/SECCSECTOR7
add wave -noupdate -color Orchid -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/EccErrValid
add wave -noupdate -color Orchid -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/MEccErrIn
add wave -noupdate -color Orchid -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/SEccErrIn
add wave -noupdate -color Orchid -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/MECCERR
add wave -noupdate -color Orchid -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/SECCERR
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/NFIDValidIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/NFStatValidIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/NFStatusIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/WrEndIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/RdEndIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/FiltRnB1In
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/FiltRnB0In
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/FIFOFlushIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/FIFORdDataOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/FIFORdDataEnIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/FIFOWrDataIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/FIFOWrDataEnIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/FIFOFullOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/FIFOHalfFullOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/FIFOEmpty0Out
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/FIFOEmpty1Out
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/FIFOLevelSetIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/NFOpRdEnIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/NFOpOut
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/QLevelOut
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/ControlOut
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/ConfigOut
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/NFDATA
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/NFCONF
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/NFCTRL
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/NFSTAT
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/QLevel
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/NFIDValid
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/NFStatValid
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/NFStatus
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/WrEnd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/RdEnd
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/RnBDetect1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/RnBDetect0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/RnB1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/RnB0
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/FIFOLevel
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/FIFOWrEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/FIFORdEn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/FIFOWrData
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/FIFORdData
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/APBWriteEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/APBReadEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/QWrEn
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uut0/Io
add wave -noupdate -format Logic /Tb_NFTop/uut0/Cle
add wave -noupdate -format Logic /Tb_NFTop/uut0/Ale
add wave -noupdate -format Logic /Tb_NFTop/uut0/Ce_n
add wave -noupdate -format Logic /Tb_NFTop/uut0/We_n
add wave -noupdate -format Logic /Tb_NFTop/uut0/Re_n
add wave -noupdate -format Logic /Tb_NFTop/uut0/Wp_n
add wave -noupdate -format Logic /Tb_NFTop/uut0/Pre
add wave -noupdate -format Logic /Tb_NFTop/uut0/Rb_n
add wave -noupdate -format Logic /Tb_NFTop/uut0/PowerUp_Complete
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uut0/Io_buf
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/NState
add wave -noupdate -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/CState
add wave -noupdate -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/TNState
add wave -noupdate -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/TCState
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/nNFCE1Out
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/CLEOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/ALEOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/nNFWEOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/nNFREOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFDataIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFDataOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFDataOutEnOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/FIFORdDataIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FIFORdDataEnOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FIFOWrDataOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FIFOWrDataEnOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/FIFOFullIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/FIFOLevelSetOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/ColumnAddrOut
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/AddrCycleCnt
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/DataSizeCnt
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/EccDataEnOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/AddrValidOut
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/EccDataOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/NFSTAT
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/DMAReqOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/IntReqOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -color Goldenrod -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/NState
add wave -noupdate -color Goldenrod -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/CState
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFboot/Clk
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFboot/nRst
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFboot/NandWidthIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFboot/NFBootIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFboot/IOWidthIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFboot/BootCfgIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFboot/BootOpRdEnIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFboot/BootOpReadyOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFboot/BootOpOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFboot/NFBootEnd
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFboot/SendCnt
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFboot/IterationCnt
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFboot/IterationSize
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFboot/DataSize
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFboot/CmdorAddr
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFboot/Analyze
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFboot/CAddr1
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFboot/CAddr2
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFboot/RAddr1
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFboot/RAddr2
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFboot/RAddr3
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFboot/SendWord
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFboot/TransferByte
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFboot/CmdAddrFlag
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFboot/WhatOper
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/BootEndIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFboot/BootEndOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -color Yellow -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFEcc/AddrCntOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecc_a_Last_256
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecc_a_Last_1024
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecc_b_Last_16bitNand
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SEccLast_256
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SEccLast_1024
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecc_a_Last_512
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecc_a_Last_2048
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecc_b_Last_8bitNand
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SEccLast_512
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SEccLast_2048
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecc_a_LastLoc
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecc_b_LastLoc
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/MEccCalcEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SEccCalcEn
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Clk
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/nRst
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/AddrIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/AddrLoadEnIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/IOWidthIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/NandWidthIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/PageSizeIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/EccRstIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/ErrDetectEnIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecc512EnIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/EccOut
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/AddrCntOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/BoundaryOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/NST_RdataIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/CST_RdataIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/CST_WdataIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/EccDataIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/EccDataEnIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR0
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR1
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR2
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR3
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR4
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR5
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR6
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR7
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR8
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR9
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR10
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR11
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR12
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR13
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR14
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/ECCSECTOR15
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SECCSECTOR0
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SECCSECTOR1
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SECCSECTOR2
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SECCSECTOR3
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SECCSECTOR4
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SECCSECTOR5
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SECCSECTOR6
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SECCSECTOR7
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/EccErrValid
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/MEccErrOut
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SEccErrOut
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/MainEcc8_0
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/MainEcc8_1
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/MainEcc16
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SpareEcc8_0
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SpareEcc8_1
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SpareEcc16
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/AddrCnt
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/EccErrEn
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFEcc/MainRegNum_512
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFEcc/MainRegNum_256
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/MECCERR
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SECCERR
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/LoopCnt
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/LocCnt
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SpareLoc
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/EccEn8_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/EccEn8_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/EccEn16
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/DataCnt
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Two8BitNand
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SpareEccEn0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SpareEccEn1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/MainEccEn8_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/MainEccEn8_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/LsnLoc
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/AddrCntBit10_Dly
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/AddrCntBit9_Dly
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/AddrCntBit8_Dly
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/AddrCntBit7_Dly
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecc512Init
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecc256Init
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecc128Init
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/MEccInit8
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/MEccInit16
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SEccInit
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/EccInit8
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/EccInit16
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/MainEccValid
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/MainEcc8_H
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SpareEcc8_H
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Nand_512
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Nand_2048
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Nand_256
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Nand_1024
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/RWState
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SpareLoc512
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SpareLoc2048
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SpareLoc256
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SpareLoc1024
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/FirstLsnLoc
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecca512
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/Ecca2048
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/MEccReg_L
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/MEccReg_H
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SEccReg_H
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SEccReg_L
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/MErrStatus_L
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/MErrStatus_H
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SErrStatus_L
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/SErrStatus_H
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/MEccCalcEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SEccCalcEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/EccaLastLoc
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/EccbLastLoc
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SEccLastLoc
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/AddrCntBit9_7Dly
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/MErrValid
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SErrValid
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Clk
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/nRst
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/DCntIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/EccRstIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/EccEnIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Ecc512EnIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/EccDataIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/EccInitIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/MainEccOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/SpareEccOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity1_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity1_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity2_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity2_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity4_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity4_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity8_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity8_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity16_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity16_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity32_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity32_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity64_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity64_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity128_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity128_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity256_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity256_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity512_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity512_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity1024_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity1024_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity2048_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Parity2048_1
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Ecc0
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Ecc1
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/Ecc2
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/SEcc0
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/SEcc1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/bit7
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/bit6
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/bit5
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/bit4
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/bit3
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/bit2
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/bit1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/bit0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U0Ecc8/LineParity
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Clk
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/nRst
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/DCntIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/EccRstIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/EccEnIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Ecc512EnIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/EccDataIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/EccInitIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/MainEccOut
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/SpareEccOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity1_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity1_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity2_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity2_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity4_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity4_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity8_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity8_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity16_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity16_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity32_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity32_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity64_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity64_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity128_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity128_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity256_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity256_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity512_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity512_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity1024_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity1024_1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity2048_0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Parity2048_1
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Ecc0
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Ecc1
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/Ecc2
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/SEcc0
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/SEcc1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/bit7
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/bit6
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/bit5
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/bit4
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/bit3
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/bit2
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/bit1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/bit0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc8/LineParity
add wave -noupdate -divider {New Divider}
add wave -noupdate -color Goldenrod -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFEcc/AddrCntOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/Clk
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/nRst
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/MEccReg_L
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/MEccReg_H
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/SEccReg_L
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/SEccReg_H
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/NandWidthIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/Ecc512EnIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/PageSizeIn
add wave -noupdate -format Literal -radix binary /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/MErrStatus_L
add wave -noupdate -format Literal -radix binary /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/MErrStatus_H
add wave -noupdate -format Literal -radix binary /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/SErrStatus_L
add wave -noupdate -format Literal -radix binary /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/SErrStatus_H
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/MErrValid
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/SErrValid
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/EccXor_L
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/EccXor_H
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SEccLastLoc
add wave -noupdate -color Goldenrod -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFEcc/AddrCntOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/RdDataIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/RdDataEnIn
add wave -noupdate -color Yellow -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/StoredEcc_L
add wave -noupdate -color Yellow -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/StoredEcc_H
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/Correctable_L
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/Correctable_H
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/CntRst8
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/CntRst16
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/EccbCalc
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/CalcMErr
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/MErrDetect
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/MErrValid
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/CalcSErr
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/SErrDetect
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/SErrValid
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/StoredMEcc_L
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/StoredMEcc_H
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/StoredSEcc_L
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/StoredSEcc_H
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/StoredEcc16Nand_256Ecc
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U2ErrDetect/StoredEcc16Nand_512Ecc
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Clk
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/nRst
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/SpareEccValid
add wave -noupdate -color Goldenrod -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFEcc/AddrCntOut
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/DCntIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/EccRstIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/EccEnIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Ecc512EnIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/EccDataIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/EccInitIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/MainEccOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/SpareEccOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity1_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity1_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity2_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity2_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity4_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity4_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity8_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity8_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity16_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity16_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity32_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity32_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity64_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity64_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity128_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity128_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity256_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity256_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity512_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity512_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity1024_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity1024_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity2048_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Parity2048_1
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Ecc0
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Ecc1
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/Ecc2
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/SEcc0
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/SEcc1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit15
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit14
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit13
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit12
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit11
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit10
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit9
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit8
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit7
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit6
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit5
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit4
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit3
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit2
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit1
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/bit0
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFEcc/U1Ecc16/LineParity
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {13732926380 ps} 0} {{Cursor 2} {72790460 ps} 0} {{Cursor 3} {335340 ps} 0} {{Cursor 4} {3931097560 ps} 0}
configure wave -namecolwidth 384
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
WaveRestoreZoom {0 ps} {10500 us}
