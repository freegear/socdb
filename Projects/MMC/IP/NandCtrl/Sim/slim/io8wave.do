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
add wave -noupdate -divider {First OPER}
add wave -noupdate -format Logic /Tb_NFTop/NFDMAReqOut
add wave -noupdate -format Logic /Tb_NFTop/NFINTOut
add wave -noupdate -divider {First OPER}
add wave -noupdate -format Literal /Tb_NFTop/write_data/remain
add wave -noupdate -format Literal /Tb_NFTop/Data_Read/remain
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
add wave -noupdate -divider {NF Interface}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/DMAReqOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/NFCtrlBusyIn
add wave -noupdate -divider {NF Interface}
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/NandData
add wave -noupdate -format Logic /Tb_NFTop/EccErr
add wave -noupdate -format Logic /Tb_NFTop/Correctable
add wave -noupdate -format Literal /Tb_NFTop/ErrBitNum
add wave -noupdate -format Literal /Tb_NFTop/BytePos
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
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/FIFOWrCollect
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
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFStatValidOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFStatusOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/WrEndOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RdEndOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/CurrentState
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/NextState
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/TNextSt
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/TCurrentSt
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFCtrlRst
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/AutoEccWr
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/DMAEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/WrEndIntEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RdEndINTEn
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
add wave -noupdate -divider {First OPER}
add wave -noupdate -divider {First OPER}
add wave -noupdate -format Logic /Tb_NFTop/NFDMAReqOut
add wave -noupdate -format Logic /Tb_NFTop/NFINTOut
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
add wave -noupdate -color Wheat -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/RdRdyOut
add wave -noupdate -color Wheat -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/WrRdyOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/Level
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFORdReadyOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -color {Light Steel Blue} -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RdFIFOReadyOut
add wave -noupdate -color Goldenrod -format Logic /Tb_NFTop/uNFTop/uNFCtrl/WrFIFOReadyOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -color {Light Steel Blue} -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOSelRd
add wave -noupdate -color Goldenrod -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOSelWr
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOCnt0
add wave -noupdate -color Goldenrod -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/WrPtr0
add wave -noupdate -color {Light Steel Blue} -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/RdPtr0
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOCnt1
add wave -noupdate -color Goldenrod -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/WrPtr1
add wave -noupdate -color {Light Steel Blue} -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/RdPtr1
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
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PCLK
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PRESETn
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/PADDR
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PSEL
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PENABLE
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PWRITE
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/PWDATA
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/PRDATA
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/IOWidthPinIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/BootCfgPinIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/OutDtmnPinIn
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
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
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/NFOpRdEnIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/NFOpOut
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/QLevelOut
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/QLevel
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/NFStatValid
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
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/DataSizeCnt
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/DMAReqOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/IntReqOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -color Goldenrod -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/NState
add wave -noupdate -color Goldenrod -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/CState
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/BootEndIn
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
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
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFStatValidOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFStatusOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/WrEndOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RdEndOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/CurrentState
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/NextState
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/TNextSt
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/TCurrentSt
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFCtrlRst
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/AutoEccWr
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/DMAEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/WrEndIntEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RdEndINTEn
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
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PCLK
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PRESETn
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/PADDR
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PSEL
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PENABLE
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PWRITE
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/PWDATA
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/PRDATA
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/IOWidthPinIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/BootCfgPinIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/OutDtmnPinIn
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
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
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/NFOpRdEnIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/NFOpOut
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/QLevelOut
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/QLevel
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/NFStatValid
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
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/DataSizeCnt
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/DMAReqOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/IntReqOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -color Goldenrod -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/NState
add wave -noupdate -color Goldenrod -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/CState
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/BootEndIn
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
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
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFStatValidOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFStatusOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/WrEndOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RdEndOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/CurrentState
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/NextState
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/TNextSt
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFCtrl/TCurrentSt
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/NFCtrlRst
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/AutoEccWr
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/DMAEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/WrEndIntEn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/RdEndINTEn
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
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PCLK
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PRESETn
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFAPBIF/PADDR
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PSEL
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PENABLE
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/PWRITE
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/PWDATA
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/PRDATA
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/IOWidthPinIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/BootCfgPinIn
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/OutDtmnPinIn
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
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
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/NFOpRdEnIn
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/NFOpOut
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/QLevelOut
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/QLevel
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/NFStatValid
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
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix unsigned /Tb_NFTop/uNFTop/uNFCtrl/DataSizeCnt
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/DMAReqOut
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFAPBIF/IntReqOut
add wave -noupdate -divider {New Divider}
add wave -noupdate -color Goldenrod -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/NState
add wave -noupdate -color Goldenrod -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/CState
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /Tb_NFTop/uNFTop/uNFCtrl/BootEndIn
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFDataIn
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/FIFOWrCollect
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {12771408478 ps} 0} {{Cursor 2} {973170732 ps} 0} {{Cursor 3} {335340 ps} 0} {{Cursor 4} {5825710000 ps} 0}
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
WaveRestoreZoom {5824502699 ps} {5827049963 ps}
