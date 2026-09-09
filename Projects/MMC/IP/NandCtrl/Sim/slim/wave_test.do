onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Orange -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/NState
add wave -noupdate -color Orange -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/CState
add wave -noupdate -color Orange -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/TNState
add wave -noupdate -color Orange -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/TCState
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/PCLK
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/PRESETn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/PADDR
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/PSEL
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/PENABLE
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/PWRITE
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/PWDATA
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/PRDATA
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/NFDMAReqOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/NFINTOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/NFBootPinIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/IOWidthPinIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/NandWidthPinIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/BootCfgPinIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/OutDtmnPinIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/AddrCnt
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/NFDataIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/NFDataOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/NFDataOutEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/CLE
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/ALE
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/nNFCE0
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/nNFCE1
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/nNFRE
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/nNFWE
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/RnB0
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/RnB1
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/PageSize
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/NFIO
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/EccErr
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/Ecc512En
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/Correctable
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/ErrBitNum
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/NandData
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/BytePos
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/wnum
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/rnum
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/i
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/fifo_level
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/rddata
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/TransferByte
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/num
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFRnBFilter/Clk
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFRnBFilter/nRst
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFRnBFilter/RnB1In
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFRnBFilter/RnB0In
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFRnBFilter/FiltRnB1Out
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFRnBFilter/FiltRnB0Out
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFRnBFilter/Dly0
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFRnBFilter/Dly1
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/PCLK
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/PRESETn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/PADDR
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/PSEL
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/PENABLE
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/PWRITE
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/PWDATA
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/PRDATA
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/NFBootPinIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/IOWidthPinIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/NandWidthPinIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/BootCfgPinIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/OutDtmnPinIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/IntReqOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/NFCtrlBusyIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/NFStatValidIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/NFStatusIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/WrEndIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/RdEndIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/RdFIFOReadyIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/WrFIFOReadyIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/FiltRnB1In
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/FiltRnB0In
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/FIFOFlushIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/FIFORdDataOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/FIFORdDataEnIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/FIFOWrDataIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/FIFOWrDataEnIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/BeforeFullOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/FIFORdReadyOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/FIFOFullOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/FIFOHalfFullOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/FIFOEmpty0Out
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/FIFOEmpty1Out
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/WrRdyOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/RdRdyOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/NFOpRdEnIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/NFOpOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/QLevelOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/ControlOut0
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/ControlOut1
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/ConfigOut0
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/ConfigOut1
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/ConfigOut2
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/NFOPER0
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/NFOPER1
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/NFOPER2
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/NFOPER3
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/NFCONF0
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/NFCONF1
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/NFCONF2
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/NFCTRL0
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/NFCTRL1
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/NFSTAT0
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/NFSTAT1
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/NFSTAT2
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/NFSTAT3
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/NFFIFOSTAT0
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/NFFIFOSTAT1
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/QLevel
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/Timing0
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/Timing1
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/Ctrl0
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/Ctrl1
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/NFStatValid
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/WrEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/RdEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/RnBDetect1
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/RnBDetect0
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/RnB1
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/RnB0
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/FIFOLevel
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/FIFOWrEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/FIFORdEn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/FIFOWrData
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/FIFORdData
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/QWrData
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/FIFOWrCnt
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/FIFORdCnt
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/FIFOWrCollect
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/FIFOData
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/DivRdEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/NFCtrlRst
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/APBWriteEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/APBReadEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/QWrEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/FIFORst
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/FIFOCnt1
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/FIFOCnt0
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/WrEnd_Dly
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/RdEnd_Dly
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/WrFIFOReady_Dly
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/RdFIFOReady_Dly
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/RnB1_Dly
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/RnB0_Dly
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/Timing_conf0
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/Timing_conf1
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/Control0
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/Control1
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/PCLK
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/PRESETn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/PADDR
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/PSEL
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/PENABLE
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/PWRITE
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/PWDATA
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/PRDATA
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/Clk
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/nRst
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/NFCtrlRstIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/QWrEnIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/QRdEnIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/QWrDataIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/QRdDataOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/QLevelOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/WrPtr
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/RdPtr
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/QCnt
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/QFull
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFCmdQ/QEmpty
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/QWrCnt
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/Clk
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/nRst
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOFlushIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOLevelIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOWrEnIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFORdEnIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOWrDataIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFORdDataOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOCnt1
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOCnt0
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/WrRdyOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/RdRdyOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/BeforeFullOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOFullOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOHalfFullOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFORdReadyOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOEmpty1Out
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOEmpty0Out
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/WrPtr0
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/WrPtr1
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/RdPtr0
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/RdPtr1
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/Level
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOSelRd
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOSelWr
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOFull0
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOFull1
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOEmpty0
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/FIFOEmpty1
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFAPBIF/uNFDFIFO/i
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/Clk
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/nRst
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/DMAReqOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFCtrlBusyOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFStatValidOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFStatusOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/WrEndOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/RdEndOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/WrFIFOReadyOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/RdFIFOReadyOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FIFOFlushOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FIFORdDataIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FIFORdDataEnOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FIFOWrDataOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FIFOWrDataEnOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/BeforeFullIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FIFORdReadyIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FIFOFullIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FIFOHalfFullIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FIFOEmpty1In
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FIFOEmpty0In
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/WrRdyIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/RdRdyIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFOpRdEnOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFOpIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/QLevelIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFCTRL0In
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFCTRL1In
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFCONF0In
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFCONF1In
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFCONF2In
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFDataIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFDataOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFDataOutEnOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CLEOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/ALEOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/nNFCE1Out
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/nNFCE0Out
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/nNFREOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/nNFWEOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FiltRnB1In
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FiltRnB0In
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CurrentState
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NextState
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/TNextSt
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/TCurrentSt
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/BootOpRdEnOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/BootOpReadyIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/BootOpIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/BootEndIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFCtrlRst
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/Ecc512En
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/AutoEccWr
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/DMAEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/WrEndIntEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/RdEndINTEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FIFOintEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/RnBIntEn1
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/RnBIntEn0
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFBootEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/IOWidth
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NandWidth
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/BootCfg
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/OutDtmn
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/TADLTWB
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/TCALS
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/TRWLP
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/TRWHP
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/Two8BitNand
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FirstOper
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CmdAddr1
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CmdAddr2
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/ChipSel
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/RnBWait
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/AutoRdStat
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/Continue
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/DataSize
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/TransSize
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CmdAddrTransByte
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CmdAddrFlag
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/ReadData
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/ReadStatus
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/ReadID
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/WriteData
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NOP
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/LoadEnd
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NextCmd
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CmdAddrTransCnt
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/DataSizeCnt
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/TadlTwbEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/TrwhpEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/TrwlpEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/TcalsEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CST_Idle
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CST_Load
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CST_Cmd
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CST_Addr
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CST_RnBCheck
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CST_Wait2Clk
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CST_Wdata
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CST_Rdata
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NST_Idle
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NST_Load
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NST_Cmd
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NST_Addr
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NST_RnBCheck
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NST_Wait2Clk
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NST_Wdata
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NST_Rdata
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CTST_Idle
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CTST_TadlTwb
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CTST_Tcals
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CTST_Trwlp
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CTST_Trwhp
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NTST_Idle
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NTST_TadlTwb
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NTST_Tcals
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NTST_Trwlp
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NTST_Trwhp
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFOutData
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/PackingCnt
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/ParsingCnt
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/TCALSCnt
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/TRWLPCnt
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/TRWHPCnt
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/TADLTWBCnt
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/DataEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/PageSize
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/RdRdy_Dly
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FIFORdData
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/RdDataEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/RdDataEnDly
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/WrReady
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFWrDataReady
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/FIFOWrEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFWrEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFWrDataLoad
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/Byte_8bitBus
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/Byte_16bitBus
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/HalfWord_8bitBus
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/HalfWord_16bitBus
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/Word_8bitBus
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/Word_16bitBus
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/WaitCnt
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CmdTimingEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/AddrTimingEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/WrDataEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/CmdAddrTransEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/RnBHigh
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/RdStatusEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/WaitEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/RnBCheckBeforeNextCmd
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/BootStart
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/RdDataEnd
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/LoadCnt
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/OperRdEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/OperRdEnDly
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/NFOpWordNum
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/OpRdEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/GoTcals
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/GoTrwhp
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/GoIdle
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/BFull
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/GoTadl
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/GoTrwlp
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/GoTrwlp0
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/GoTrwlp1
add wave -noupdate -format Logic -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/GoTrwlp2
add wave -noupdate -format Literal -radix hexadecimal /Tb_NFTop/uNFTop/uNFCtrl/ByteShift
add wave -noupdate -color Orange -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/NState
add wave -noupdate -color Orange -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/CState
add wave -noupdate -color Orange -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/TNState
add wave -noupdate -color Orange -format Literal -radix ascii /Tb_NFTop/uNFTop/uNFCtrl/TCState
add wave -noupdate -format Literal /Tb_NFTop/uut0/Io
add wave -noupdate -format Logic /Tb_NFTop/uut0/Cle
add wave -noupdate -format Logic /Tb_NFTop/uut0/Ale
add wave -noupdate -format Logic /Tb_NFTop/uut0/Ce_n
add wave -noupdate -format Logic /Tb_NFTop/uut0/We_n
add wave -noupdate -format Logic /Tb_NFTop/uut0/Re_n
add wave -noupdate -format Logic /Tb_NFTop/uut0/Wp_n
add wave -noupdate -format Logic /Tb_NFTop/uut0/Pre
add wave -noupdate -format Logic /Tb_NFTop/uut0/Rb_n
add wave -noupdate -format Logic /Tb_NFTop/uut0/PowerUp_Complete
add wave -noupdate -format Literal /Tb_NFTop/uut0/Io_buf
add wave -noupdate -format Logic /Tb_NFTop/uut0/cmnd_00h
add wave -noupdate -format Logic /Tb_NFTop/uut0/cmnd_05h
add wave -noupdate -format Logic /Tb_NFTop/uut0/cmnd_10h
add wave -noupdate -format Logic /Tb_NFTop/uut0/cmnd_15h
add wave -noupdate -format Logic /Tb_NFTop/uut0/cmnd_30h
add wave -noupdate -format Logic /Tb_NFTop/uut0/cmnd_31h
add wave -noupdate -format Logic /Tb_NFTop/uut0/cmnd_35h
add wave -noupdate -format Logic /Tb_NFTop/uut0/cmnd_3Fh
add wave -noupdate -format Logic /Tb_NFTop/uut0/cmnd_60h
add wave -noupdate -format Logic /Tb_NFTop/uut0/cmnd_65h
add wave -noupdate -format Logic /Tb_NFTop/uut0/cmnd_70h
add wave -noupdate -format Logic /Tb_NFTop/uut0/cmnd_80h
add wave -noupdate -format Logic /Tb_NFTop/uut0/cmnd_85h
add wave -noupdate -format Logic /Tb_NFTop/uut0/cmnd_90h
add wave -noupdate -format Logic /Tb_NFTop/uut0/cmnd_D0h
add wave -noupdate -format Logic /Tb_NFTop/uut0/cmnd_E0h
add wave -noupdate -format Logic /Tb_NFTop/uut0/cmnd_FFh
add wave -noupdate -format Logic /Tb_NFTop/uut0/saw_cmnd_65h
add wave -noupdate -format Logic /Tb_NFTop/uut0/saw_cmnd_00h
add wave -noupdate -format Logic /Tb_NFTop/uut0/do_read_id_2
add wave -noupdate -format Logic /Tb_NFTop/uut0/do_read_unique
add wave -noupdate -format Logic /Tb_NFTop/uut0/cmnd_31h_first_time
add wave -noupdate -format Logic /Tb_NFTop/uut0/intRb_state
add wave -noupdate -format Logic /Tb_NFTop/uut0/debug
add wave -noupdate -format Logic /Tb_NFTop/uut0/command_debug
add wave -noupdate -format Literal /Tb_NFTop/uut0/col_addr
add wave -noupdate -format Literal /Tb_NFTop/uut0/row_addr
add wave -noupdate -format Literal /Tb_NFTop/uut0/status_register
add wave -noupdate -format Logic /Tb_NFTop/uut0/col_valid
add wave -noupdate -format Logic /Tb_NFTop/uut0/row_valid
add wave -noupdate -format Logic /Tb_NFTop/uut0/data_valid
add wave -noupdate -format Logic /Tb_NFTop/uut0/cache_valid
add wave -noupdate -format Literal /Tb_NFTop/uut0/col_counter
add wave -noupdate -format Literal /Tb_NFTop/uut0/cache_counter
add wave -noupdate -format Literal /Tb_NFTop/uut0/addr_start
add wave -noupdate -format Literal /Tb_NFTop/uut0/addr_stop
add wave -noupdate -format Literal /Tb_NFTop/uut0/delay
add wave -noupdate -format Literal /Tb_NFTop/uut0/j
add wave -noupdate -format Literal /Tb_NFTop/uut0/k
add wave -noupdate -format Literal /Tb_NFTop/uut0/erablk
add wave -noupdate -format Literal /Tb_NFTop/uNFTop/uNFAPBIF/QWrCnt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {570000 ps} 0}
configure wave -namecolwidth 337
configure wave -valuecolwidth 55
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
WaveRestoreZoom {147940 ps} {917564 ps}
