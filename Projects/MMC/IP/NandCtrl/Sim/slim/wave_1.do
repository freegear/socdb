onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Ctrl_0
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/IOWidthPinIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/PCLK
add wave -noupdate -color Gold -format Literal -itemcolor Gold -radix ascii /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NState
add wave -noupdate -color Gold -format Literal -itemcolor Gold -radix ascii /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CState
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/WaitCnt
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOWrDataEnIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFOPER0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFOPER1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFOPER2
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFOPER3
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/TransSize
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOWrEn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOWrCnt
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOWrData
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/FIFOWrDataOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/PRESETn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFDataIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFDataOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOWrDataIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RegWriteEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/CS
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/CS
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/CS_0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOData
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/We_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Oe_0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/WDATA_0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/RDATA_0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/data_read/rdata
add wave -noupdate -divider {New Divider}
add wave -noupdate -color Magenta -format Literal -itemcolor Magenta -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/EXT_SFR_DIN
add wave -noupdate -color Magenta -format Literal -itemcolor Magenta -radix hexadecimal /Tb_Two_NFTop/EXT_SFR_DOUT
add wave -noupdate -color Magenta -format Literal -itemcolor Magenta -radix hexadecimal /Tb_Two_NFTop/EXT_SFR_ADDR
add wave -noupdate -color Magenta -format Logic -itemcolor Magenta -radix hexadecimal /Tb_Two_NFTop/EXT_SFR_WR
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/rddata
add wave -noupdate -divider Ctrl_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/PCLK
add wave -noupdate -color Gold -format Literal -itemcolor Gold -radix ascii /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NState
add wave -noupdate -color Gold -format Literal -itemcolor Gold -radix ascii /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CState
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/WaitCnt
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/FIFOWrDataEnIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/NFOPER0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/NFOPER1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/NFOPER2
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/NFOPER3
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/TransSize
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/FIFOWrEn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/FIFOWrCnt
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/FIFOWrData
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/FIFOWrDataOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFDataIn_1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFDataOut_1
add wave -noupdate -format Literal /Tb_Two_NFTop/NFIO_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFDataOutEn_1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/FIFOWrDataIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/RegWriteEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/CS
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/CS_1
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/We_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/Oe_1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/WDATA_1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/RDATA_1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/data_read_1/rdata
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/NFINTOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/IOWidthPinIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/NFDataIn_0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/NFDataOut_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/NFDataOutEn_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/CLE_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/ALE_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/nNFCE3_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/nNFCE2_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/nNFCE0_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/nNFCE1_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/nNFRE_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/nNFWE_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/RnB3_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/RnB2_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/RnB0_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/RnB1_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/We_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Oe_1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/NFDataIn_1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/NFDataOut_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/NFDataOutEn_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/CLE_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/ALE_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/nNFCE3_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/nNFCE2_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/nNFCE0_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/nNFCE1_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/nNFRE_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/nNFWE_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/RnB3_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/RnB2_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/RnB1_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/RnB0_1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/PageSize
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/wnum
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/rnum
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/i
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/fifo_level
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/rddata
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/TransferByte
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/num
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/data_read/rdata
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/CS_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/PCLK
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/PRESETn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/EXT_SFR_ADDR
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/EXT_SFR_WR
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/EXT_SFR_DOUT
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/CS_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/CS_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/We_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/Oe_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/IOWidthPinIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFDataIn_0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFDataOut_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFDataOutEn_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/CLE_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/ALE_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/nNFCE0_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/nNFCE1_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/nNFCE2_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/nNFCE3_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/nNFRE_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/nNFWE_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/RnB0_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/RnB1_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/RnB2_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/RnB3_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/We_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/Oe_1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFDataIn_1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFDataOut_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFDataOutEn_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/CLE_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/ALE_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/nNFCE3_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/nNFCE2_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/nNFCE1_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/nNFCE0_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/nNFRE_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/nNFWE_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/RnB3_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/RnB2_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/RnB1_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/RnB0_1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/WDATA_0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/RDATA_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/PCLK
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/PRESETn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/EXT_SFR_ADDR
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/EXT_SFR_WR
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/EXT_SFR_DOUT
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/EXT_SFR_DIN
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/CS
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/WDATA
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/RDATA
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/We
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/Oe
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/NFDMAReqOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/NFINTOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/NFDataIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/NFDataOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/NFDataOutEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/CLE
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/ALE
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/nNFCE0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/nNFCE1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/nNFCE2
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/nNFCE3
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/nNFRE
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/nNFWE
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/RnB0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/RnB1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/RnB2
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/RnB3
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/NFStatValid
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/NFStatus
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/WrEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/RdEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/FIFOFlush
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/FIFORdData
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/FIFORdDataEn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/FIFOWrData
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/FIFOWrDataEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/FIFOFull
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/FIFOEmpty0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/FIFOEmpty1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/NFOpRdEn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/NFOp
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/QLevel
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/ControlOut0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/ControlOut1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/ConfigOut0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/ConfigOut1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/ConfigOut2
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/BootOp
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/Ecc
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/TransSize
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/FiltRnB3
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/FiltRnB2
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/FiltRnB1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/FiltRnB0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/NFCtrlBusy
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/WrFIFOReady
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/RdFIFOReady
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/BeforeFull
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/FIFORdReady
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/FIFOHalfFull
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/WrRdy
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/RdRdy
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFRnBFilter/Clk
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFRnBFilter/nRst
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFRnBFilter/RnB3In
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFRnBFilter/RnB2In
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFRnBFilter/RnB1In
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFRnBFilter/RnB0In
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFRnBFilter/FiltRnB3Out
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFRnBFilter/FiltRnB2Out
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFRnBFilter/FiltRnB1Out
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFRnBFilter/FiltRnB0Out
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFRnBFilter/Dly0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFRnBFilter/Dly1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFRnBFilter/Dly2
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFRnBFilter/Dly3
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/EXT_SFR_ADDR
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/EXT_SFR_WR
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/EXT_SFR_DOUT
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/EXT_SFR_DIN
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/CS
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/WDATA
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RDATA
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/We
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/Oe
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFBootPinIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/IOWidthPinIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NandWidthPinIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/BootCfgPinIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/OutDtmnPinIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/IntReqOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFCtrlBusyIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFStatValidIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFStatusIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/WrEndIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RdEndIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RdFIFOReadyIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/WrFIFOReadyIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FiltRnB3In
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FiltRnB2In
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FiltRnB1In
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FiltRnB0In
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOFlushIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFORdDataOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFORdDataEnIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOWrDataIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOWrDataEnIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/BeforeFullOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFORdReadyOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOFullOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOHalfFullOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOEmpty0Out
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOEmpty1Out
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/WrRdyOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RdRdyOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFOpRdEnIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFOpOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/QLevelOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/ControlOut0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/ControlOut1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/ConfigOut0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/ConfigOut1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/ConfigOut2
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/TransSize
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFOPER0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFOPER1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFOPER2
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFOPER3
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFCONF0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFCONF1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFCONF2
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFCTRL0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFCTRL1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFSTAT0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFSTAT1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFSTAT2
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFSTAT3
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFFIFOSTAT0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFFIFOSTAT1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/QLevel
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/Timing0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/Timing1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/Ctrl0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/Ctrl1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFStatValid
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/WrEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RdEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RnBDetect3
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RnBDetect2
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RnBDetect1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RnBDetect0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RnB3
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RnB2
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RnB1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RnB0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOLevel
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOWrEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFORdEn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOWrData
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFORdData
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/QWrData
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOWrCnt
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFORdCnt
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOWrCollect
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOData
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/DivRdEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFCtrlRst
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RegWriteEn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/QWrCnt
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/QWrEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFORst
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOCnt1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOCnt0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/WrEnd_Dly
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RdEnd_Dly
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/WrFIFOReady_Dly
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RdFIFOReady_Dly
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RnB3_Dly
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RnB2_Dly
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RnB1_Dly
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RnB0_Dly
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/Timing_conf0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/Timing_conf1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/Control0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/Control1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFCmdQ/Clk
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFCmdQ/nRst
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFCmdQ/NFCtrlRstIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFCmdQ/QWrEnIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFCmdQ/QRdEnIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFCmdQ/QWrDataIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFCmdQ/QRdDataOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFCmdQ/QLevelOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFCmdQ/WrPtr
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFCmdQ/RdPtr
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFCmdQ/QCnt
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFCmdQ/QFull
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFCmdQ/QEmpty
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFCmdQ/i
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/Clk
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/nRst
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFOFlushIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFOLevelIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFOWrEnIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFORdEnIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFOWrDataIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFORdDataOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFOCnt1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFOCnt0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/WrRdyOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/RdRdyOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/BeforeFullOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFOFullOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFOHalfFullOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFORdReadyOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFOEmpty1Out
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFOEmpty0Out
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/WrPtr0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/WrPtr1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/RdPtr0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/RdPtr1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/Level
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFOSelRd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFOSelWr
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFOFull0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFOFull1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFOEmpty0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFOEmpty1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/i
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/Clk
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/nRst
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/DMAReqOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/BootOpRdEnOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/BootOpReadyIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/BootOpIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/BootEndIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFCtrlBusyOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFStatValidOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFStatusOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/WrEndOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/RdEndOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/WrFIFOReadyOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/RdFIFOReadyOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/FIFOFlushOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/FIFORdDataIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/FIFORdDataEnOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/FIFOWrDataOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/FIFOWrDataEnOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/BeforeFullIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/FIFORdReadyIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/FIFOFullIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/FIFOHalfFullIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/FIFOEmpty1In
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/FIFOEmpty0In
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/WrRdyIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/RdRdyIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFOpRdEnOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFOpIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/QLevelIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFCTRL0In
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFCTRL1In
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFCONF0In
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFCONF1In
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFCONF2In
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/EccIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/AutoEccWrEnIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/BoundaryIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NST_RdataOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CST_RdataOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CST_WdataOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/EccDataOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/EccDataEnOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/AddrValidOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/ColumnAddrOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFDataIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFDataOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFDataOutEnOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CLEOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/ALEOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/nNFCE3Out
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/nNFCE2Out
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/nNFCE1Out
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/nNFCE0Out
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/nNFREOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/nNFWEOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/FiltRnB3In
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/FiltRnB2In
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/FiltRnB1In
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/FiltRnB0In
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/TransSize
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CurrentState
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NextState
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/TNextSt
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/TCurrentSt
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFCtrlRst
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/Ecc512En
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/AutoEccWr
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/DMAEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/WrEndIntEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/RdEndINTEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/FIFOintEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/RnBIntEn3
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/RnBIntEn2
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/RnBIntEn1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/RnBIntEn0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFBootEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/IOWidth
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NandWidth
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/BootCfg
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/OutDtmn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/TADLTWB
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/TCALS
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/TRWLP
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/TRWHP
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/Two8BitNand
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/FirstOper
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CmdAddr1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CmdAddr2
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/ChipSel
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/RnBWait
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/AutoRdStat
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/Continue
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/DataSize
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CmdAddrTransByte
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CmdAddrFlag
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/ReadData
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/ReadStatus
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/ReadID
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/WriteData
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NOP
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/LoadEnd
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NextCmd
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CmdAddrTransCnt
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/DataSizeCnt
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/TadlTwbEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/TrwhpEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/TrwlpEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/TcalsEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CST_Idle
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CST_Load
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CST_Cmd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CST_Addr
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CST_RnBCheck
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CST_Wait2Clk
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CST_Wdata
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CST_Rdata
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NST_Idle
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NST_Load
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NST_Cmd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NST_Addr
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NST_RnBCheck
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NST_Wait2Clk
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NST_Wdata
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NST_Rdata
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CTST_Idle
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CTST_TadlTwb
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CTST_Tcals
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CTST_Trwlp
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CTST_Trwhp
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NTST_Idle
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NTST_TadlTwb
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NTST_Tcals
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NTST_Trwlp
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NTST_Trwhp
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFOutData
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/PackingCnt
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/ParsingCnt
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/TCALSCnt
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/TRWLPCnt
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/TRWHPCnt
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/TADLTWBCnt
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/DataEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/PageSize
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/AddrCycleCnt
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/RdRdy_Dly
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/FIFORdData
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/RdDataEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/RdDataEnDly
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/WrReady
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFWrDataReady
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/FIFOWrEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFWrEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFWrDataLoad
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/Byte_8bitBus
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/Byte_16bitBus
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/HalfWord_8bitBus
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/HalfWord_16bitBus
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/WaitCnt
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CmdTimingEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/AddrTimingEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/WrDataEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CmdAddrTransEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/RnBHigh
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/RdStatusEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/WaitEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/RnBCheckBeforeNextCmd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/BootStart
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/RdDataEnd
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/LoadCnt
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/OperRdEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/OperRdEnDly
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFOpWordNum
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/OpRdEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/tAREn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/tAREnDly
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/GoTcals
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/GoTrwhp
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/GoIdle
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/BFull
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/GoTadl
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/GoTrwlp
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/GoTrwlp0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/GoTrwlp1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/GoTrwlp2
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/GoTrwlp3
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/ByteShift
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NState
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CState
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/TNState
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/TCState
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/PCLK
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/PRESETn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/EXT_SFR_ADDR
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/EXT_SFR_WR
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/EXT_SFR_DOUT
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/We_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Oe_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/CS_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/CS_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/NFINTOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/IOWidthPinIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/NFDataIn_0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/NFDataOut_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/NFDataOutEn_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/CLE_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/ALE_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/nNFCE3_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/nNFCE2_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/nNFCE0_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/nNFCE1_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/nNFRE_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/nNFWE_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/RnB3_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/RnB2_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/RnB0_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/RnB1_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/We_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Oe_1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/NFDataIn_1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/NFDataOut_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/NFDataOutEn_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/CLE_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/ALE_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/nNFCE3_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/nNFCE2_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/nNFCE0_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/nNFCE1_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/nNFRE_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/nNFWE_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/RnB3_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/RnB2_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/RnB0_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/RnB1_1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/PageSize
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/wnum
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/rnum
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/i
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/fifo_level
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/rddata
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/TransferByte
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/num
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/PCLK
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/PRESETn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/EXT_SFR_ADDR
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/EXT_SFR_WR
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/EXT_SFR_DOUT
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/CS_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/CS_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/We_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/Oe_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/IOWidthPinIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFDataIn_0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFDataOut_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFDataOutEn_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/CLE_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/ALE_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/nNFCE0_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/nNFCE1_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/nNFCE2_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/nNFCE3_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/nNFRE_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/nNFWE_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/RnB0_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/RnB1_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/RnB2_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/RnB3_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/We_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/Oe_1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFDataIn_1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFDataOut_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFDataOutEn_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/CLE_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/ALE_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/nNFCE3_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/nNFCE2_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/nNFCE1_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/nNFCE0_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/nNFRE_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/nNFWE_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/RnB3_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/RnB2_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/RnB1_1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/RnB0_1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/WDATA_0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/RDATA_0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/PCLK
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/PRESETn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/EXT_SFR_ADDR
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/EXT_SFR_WR
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/EXT_SFR_DOUT
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/EXT_SFR_DIN
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/CS
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/WDATA
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/RDATA
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/We
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/Oe
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/NFDMAReqOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/NFINTOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/NFDataIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/NFDataOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/NFDataOutEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/CLE
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/ALE
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/nNFCE0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/nNFCE1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/nNFCE2
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/nNFCE3
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/nNFRE
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/nNFWE
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/RnB0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/RnB1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/RnB2
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/RnB3
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/NFStatValid
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/NFStatus
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/WrEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/RdEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/FIFOFlush
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/FIFORdData
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/FIFORdDataEn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/FIFOWrData
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/FIFOWrDataEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/FIFOFull
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/FIFOEmpty0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/FIFOEmpty1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/NFOpRdEn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/NFOp
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/QLevel
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/ControlOut0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/ControlOut1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/ConfigOut0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/ConfigOut1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/ConfigOut2
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/BootOp
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/Ecc
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/TransSize
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/FiltRnB3
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/FiltRnB2
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/FiltRnB1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/FiltRnB0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/NFCtrlBusy
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/WrFIFOReady
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/RdFIFOReady
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/BeforeFull
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/FIFORdReady
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/FIFOHalfFull
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/WrRdy
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/RdRdy
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFRnBFilter/Clk
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFRnBFilter/nRst
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFRnBFilter/RnB3In
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFRnBFilter/RnB2In
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFRnBFilter/RnB1In
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFRnBFilter/RnB0In
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFRnBFilter/FiltRnB3Out
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFRnBFilter/FiltRnB2Out
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFRnBFilter/FiltRnB1Out
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFRnBFilter/FiltRnB0Out
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFRnBFilter/Dly0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFRnBFilter/Dly1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFRnBFilter/Dly2
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFRnBFilter/Dly3
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/EXT_SFR_ADDR
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/EXT_SFR_WR
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/EXT_SFR_DOUT
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/EXT_SFR_DIN
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/CS
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/WDATA
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RDATA
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/We
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/Oe
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFBootPinIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/IOWidthPinIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NandWidthPinIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/BootCfgPinIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/OutDtmnPinIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/IntReqOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFCtrlBusyIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFStatValidIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFStatusIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/WrEndIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RdEndIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RdFIFOReadyIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/WrFIFOReadyIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FiltRnB3In
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FiltRnB2In
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FiltRnB1In
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FiltRnB0In
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOFlushIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFORdDataOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFORdDataEnIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOWrDataIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOWrDataEnIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/BeforeFullOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFORdReadyOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOFullOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOHalfFullOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOEmpty0Out
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOEmpty1Out
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/WrRdyOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RdRdyOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFOpRdEnIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFOpOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/QLevelOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/ControlOut0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/ControlOut1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/ConfigOut0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/ConfigOut1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/ConfigOut2
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/TransSize
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFOPER0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFOPER1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFOPER2
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFOPER3
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFCONF0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFCONF1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFCONF2
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFCTRL0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFCTRL1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFSTAT0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFSTAT1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFSTAT2
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFSTAT3
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFFIFOSTAT0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFFIFOSTAT1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/QLevel
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/Timing0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/Timing1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/Ctrl0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/Ctrl1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFStatValid
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/WrEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RdEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RnBDetect3
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RnBDetect2
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RnBDetect1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RnBDetect0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RnB3
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RnB2
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RnB1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RnB0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOLevel
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOWrEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFORdEn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOWrData
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFORdData
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/QWrData
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOWrCnt
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFORdCnt
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOWrCollect
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOData
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/DivRdEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFCtrlRst
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RegWriteEn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/QWrCnt
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/QWrEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFORst
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOCnt1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOCnt0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/WrEnd_Dly
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RdEnd_Dly
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/WrFIFOReady_Dly
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RdFIFOReady_Dly
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RnB3_Dly
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RnB2_Dly
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RnB1_Dly
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RnB0_Dly
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/Timing_conf0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/Timing_conf1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/Control0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/Control1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFCmdQ/Clk
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFCmdQ/nRst
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFCmdQ/NFCtrlRstIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFCmdQ/QWrEnIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFCmdQ/QRdEnIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFCmdQ/QWrDataIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFCmdQ/QRdDataOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFCmdQ/QLevelOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFCmdQ/WrPtr
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFCmdQ/RdPtr
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFCmdQ/QCnt
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFCmdQ/QFull
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFCmdQ/QEmpty
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFCmdQ/i
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/Clk
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/nRst
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFOFlushIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFOLevelIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFOWrEnIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFORdEnIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFOWrDataIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFORdDataOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFOCnt1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFOCnt0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/WrRdyOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/RdRdyOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/BeforeFullOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFOFullOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFOHalfFullOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFORdReadyOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFOEmpty1Out
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFOEmpty0Out
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/WrPtr0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/WrPtr1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/RdPtr0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/RdPtr1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/Level
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFOSelRd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFOSelWr
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFOFull0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFOFull1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFOEmpty0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/FIFOEmpty1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/uNFDFIFO/i
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/Clk
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/nRst
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/DMAReqOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/BootOpRdEnOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/BootOpReadyIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/BootOpIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/BootEndIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFCtrlBusyOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFStatValidOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFStatusOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/WrEndOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/RdEndOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/WrFIFOReadyOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/RdFIFOReadyOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/FIFOFlushOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/FIFORdDataIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/FIFORdDataEnOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/FIFOWrDataOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/FIFOWrDataEnOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/BeforeFullIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/FIFORdReadyIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/FIFOFullIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/FIFOHalfFullIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/FIFOEmpty1In
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/FIFOEmpty0In
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/WrRdyIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/RdRdyIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFOpRdEnOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFOpIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/QLevelIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFCTRL0In
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFCTRL1In
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFCONF0In
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFCONF1In
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFCONF2In
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/EccIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/AutoEccWrEnIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/BoundaryIn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NST_RdataOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CST_RdataOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CST_WdataOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/EccDataOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/EccDataEnOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/AddrValidOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/ColumnAddrOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFDataIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFDataOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFDataOutEnOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CLEOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/ALEOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/nNFCE3Out
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/nNFCE2Out
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/nNFCE1Out
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/nNFCE0Out
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/nNFREOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/nNFWEOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/FiltRnB3In
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/FiltRnB2In
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/FiltRnB1In
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/FiltRnB0In
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/TransSize
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CurrentState
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NextState
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/TNextSt
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/TCurrentSt
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFCtrlRst
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/Ecc512En
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/AutoEccWr
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/DMAEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/WrEndIntEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/RdEndINTEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/FIFOintEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/RnBIntEn3
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/RnBIntEn2
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/RnBIntEn1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/RnBIntEn0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFBootEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/IOWidth
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NandWidth
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/BootCfg
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/OutDtmn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/TADLTWB
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/TCALS
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/TRWLP
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/TRWHP
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/Two8BitNand
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/FirstOper
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CmdAddr1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CmdAddr2
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/ChipSel
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/RnBWait
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/AutoRdStat
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/Continue
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/DataSize
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CmdAddrTransByte
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CmdAddrFlag
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/ReadData
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/ReadStatus
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/ReadID
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/WriteData
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NOP
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/LoadEnd
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NextCmd
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CmdAddrTransCnt
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/DataSizeCnt
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/TadlTwbEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/TrwhpEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/TrwlpEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/TcalsEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CST_Idle
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CST_Load
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CST_Cmd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CST_Addr
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CST_RnBCheck
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CST_Wait2Clk
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CST_Wdata
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CST_Rdata
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NST_Idle
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NST_Load
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NST_Cmd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NST_Addr
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NST_RnBCheck
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NST_Wait2Clk
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NST_Wdata
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NST_Rdata
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CTST_Idle
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CTST_TadlTwb
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CTST_Tcals
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CTST_Trwlp
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CTST_Trwhp
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NTST_Idle
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NTST_TadlTwb
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NTST_Tcals
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NTST_Trwlp
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NTST_Trwhp
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFOutData
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/PackingCnt
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/ParsingCnt
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/TCALSCnt
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/TRWLPCnt
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/TRWHPCnt
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/TADLTWBCnt
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/DataEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/PageSize
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/AddrCycleCnt
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/RdRdy_Dly
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/FIFORdData
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/RdDataEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/RdDataEnDly
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/WrReady
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFWrDataReady
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/FIFOWrEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFWrEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFWrDataLoad
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/Byte_8bitBus
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/Byte_16bitBus
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/HalfWord_8bitBus
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/HalfWord_16bitBus
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/WaitCnt
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CmdTimingEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/AddrTimingEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/WrDataEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CmdAddrTransEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/RnBHigh
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/RdStatusEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/WaitEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/RnBCheckBeforeNextCmd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/BootStart
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/RdDataEnd
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/LoadCnt
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/OperRdEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/OperRdEnDly
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NFOpWordNum
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/OpRdEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/tAREn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/tAREnDly
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/GoTcals
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/GoTrwhp
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/GoIdle
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/BFull
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/GoTadl
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/GoTrwlp
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/GoTrwlp0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/GoTrwlp1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/GoTrwlp2
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/GoTrwlp3
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/ByteShift
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/NState
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/CState
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/TNState
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFCtrl/TCState
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/PCLK
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/PRESETn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/EXT_SFR_ADDR
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/EXT_SFR_WR
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/EXT_SFR_DOUT
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/EXT_SFR_DIN
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/CS
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/WDATA
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/RDATA
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/We
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/Oe
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/NFDMAReqOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/NFINTOut
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/NFDataIn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/NFDataOut
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/NFDataOutEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/CLE
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/ALE
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/nNFCE0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/nNFCE1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/nNFCE2
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/nNFCE3
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/nNFRE
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/nNFWE
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/RnB0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/RnB1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/RnB2
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/RnB3
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/NFStatValid
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/NFStatus
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/WrEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/RdEnd
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/FIFOFlush
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/FIFORdData
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/FIFORdDataEn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/FIFOWrData
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/FIFOWrDataEn
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/FIFOFull
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/FIFOEmpty0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/FIFOEmpty1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/NFOpRdEn
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/NFOp
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/QLevel
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/ControlOut0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/ControlOut1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/ConfigOut0
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/ConfigOut1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/ConfigOut2
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/BootOp
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/Ecc
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/TransSize
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/FiltRnB3
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/FiltRnB2
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/FiltRnB1
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/FiltRnB0
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/NFCtrlBusy
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/WrFIFOReady
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/RdFIFOReady
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/BeforeFull
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/FIFORdReady
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/FIFOHalfFull
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/WrRdy
add wave -noupdate -format Logic -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/RdRdy
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/PCLK
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/PRESETn
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/EXT_SFR_ADDR
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/EXT_SFR_WR
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/EXT_SFR_DOUT
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/EXT_SFR_DIN
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/CS
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/WDATA
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/RDATA
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/We
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/Oe
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/NFDMAReqOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/NFINTOut
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/NFDataIn
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/NFDataOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/NFDataOutEn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/CLE
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/ALE
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/nNFCE0
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/nNFCE1
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/nNFCE2
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/nNFCE3
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/nNFRE
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/nNFWE
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/RnB0
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/RnB1
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/RnB2
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/RnB3
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/NFStatValid
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/NFStatus
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/WrEnd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/RdEnd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/FIFOFlush
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/FIFORdData
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/FIFORdDataEn
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/FIFOWrData
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/FIFOWrDataEn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/FIFOFull
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/FIFOEmpty0
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/FIFOEmpty1
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/NFOpRdEn
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/NFOp
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/QLevel
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/ControlOut0
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/ControlOut1
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/ConfigOut0
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/ConfigOut1
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/ConfigOut2
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/BootOp
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/Ecc
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/TransSize
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/FiltRnB3
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/FiltRnB2
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/FiltRnB1
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/FiltRnB0
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/NFCtrlBusy
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/WrFIFOReady
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/RdFIFOReady
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/BeforeFull
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/FIFORdReady
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/FIFOHalfFull
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/WrRdy
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/RdRdy
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFRnBFilter/Clk
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFRnBFilter/nRst
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFRnBFilter/RnB3In
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFRnBFilter/RnB2In
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFRnBFilter/RnB1In
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFRnBFilter/RnB0In
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFRnBFilter/FiltRnB3Out
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFRnBFilter/FiltRnB2Out
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFRnBFilter/FiltRnB1Out
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFRnBFilter/FiltRnB0Out
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFRnBFilter/Dly0
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFRnBFilter/Dly1
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFRnBFilter/Dly2
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFRnBFilter/Dly3
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/EXT_SFR_ADDR
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/EXT_SFR_WR
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/EXT_SFR_DOUT
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/EXT_SFR_DIN
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/CS
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/WDATA
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/RDATA
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/We
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/Oe
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/NFBootPinIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/IOWidthPinIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/NandWidthPinIn
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/BootCfgPinIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/OutDtmnPinIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/IntReqOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/NFCtrlBusyIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/NFStatValidIn
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/NFStatusIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/WrEndIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/RdEndIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/RdFIFOReadyIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/WrFIFOReadyIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/FiltRnB3In
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/FiltRnB2In
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/FiltRnB1In
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/FiltRnB0In
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/FIFOFlushIn
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/FIFORdDataOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/FIFORdDataEnIn
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/FIFOWrDataIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/FIFOWrDataEnIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/BeforeFullOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/FIFORdReadyOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/FIFOFullOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/FIFOHalfFullOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/FIFOEmpty0Out
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/FIFOEmpty1Out
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/WrRdyOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/RdRdyOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/NFOpRdEnIn
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/NFOpOut
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/QLevelOut
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/ControlOut0
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/ControlOut1
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/ConfigOut0
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/ConfigOut1
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/ConfigOut2
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/TransSize
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/NFOPER0
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/NFOPER1
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/NFOPER2
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/NFOPER3
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/NFCONF0
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/NFCONF1
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/NFCONF2
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/NFCTRL0
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/NFCTRL1
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/NFSTAT0
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/NFSTAT1
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/NFSTAT2
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/NFSTAT3
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/NFFIFOSTAT0
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/NFFIFOSTAT1
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/QLevel
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/Timing0
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/Timing1
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/Ctrl0
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/Ctrl1
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/NFStatValid
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/WrEnd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/RdEnd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/RnBDetect3
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/RnBDetect2
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/RnBDetect1
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/RnBDetect0
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/RnB3
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/RnB2
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/RnB1
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/RnB0
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/FIFOLevel
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/FIFOWrEn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/FIFORdEn
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/FIFOWrData
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/FIFORdData
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/QWrData
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/FIFOWrCnt
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/FIFORdCnt
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/FIFOWrCollect
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/FIFOData
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/DivRdEn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/NFCtrlRst
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/RegWriteEn
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/QWrCnt
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/QWrEn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/FIFORst
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/FIFOCnt1
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/FIFOCnt0
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/WrEnd_Dly
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/RdEnd_Dly
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/WrFIFOReady_Dly
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/RdFIFOReady_Dly
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/RnB3_Dly
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/RnB2_Dly
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/RnB1_Dly
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/RnB0_Dly
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/Timing_conf0
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/Timing_conf1
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/Control0
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/Control1
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFCmdQ/Clk
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFCmdQ/nRst
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFCmdQ/NFCtrlRstIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFCmdQ/QWrEnIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFCmdQ/QRdEnIn
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFCmdQ/QWrDataIn
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFCmdQ/QRdDataOut
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFCmdQ/QLevelOut
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFCmdQ/WrPtr
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFCmdQ/RdPtr
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFCmdQ/QCnt
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFCmdQ/QFull
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFCmdQ/QEmpty
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFCmdQ/i
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFDFIFO/Clk
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFDFIFO/nRst
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFDFIFO/FIFOFlushIn
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFDFIFO/FIFOLevelIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFDFIFO/FIFOWrEnIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFDFIFO/FIFORdEnIn
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFDFIFO/FIFOWrDataIn
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFDFIFO/FIFORdDataOut
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFDFIFO/FIFOCnt1
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFDFIFO/FIFOCnt0
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFDFIFO/WrRdyOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFDFIFO/RdRdyOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFDFIFO/BeforeFullOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFDFIFO/FIFOFullOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFDFIFO/FIFOHalfFullOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFDFIFO/FIFORdReadyOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFDFIFO/FIFOEmpty1Out
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFDFIFO/FIFOEmpty0Out
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFDFIFO/WrPtr0
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFDFIFO/WrPtr1
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFDFIFO/RdPtr0
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFDFIFO/RdPtr1
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFDFIFO/Level
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFDFIFO/FIFOSelRd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFDFIFO/FIFOSelWr
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFDFIFO/FIFOFull0
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFDFIFO/FIFOFull1
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFDFIFO/FIFOEmpty0
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFDFIFO/FIFOEmpty1
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFAPBIF/uNFDFIFO/i
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/Clk
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/nRst
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/DMAReqOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/BootOpRdEnOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/BootOpReadyIn
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/BootOpIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/BootEndIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFCtrlBusyOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFStatValidOut
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFStatusOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/WrEndOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/RdEndOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/WrFIFOReadyOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/RdFIFOReadyOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/FIFOFlushOut
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/FIFORdDataIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/FIFORdDataEnOut
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/FIFOWrDataOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/FIFOWrDataEnOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/BeforeFullIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/FIFORdReadyIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/FIFOFullIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/FIFOHalfFullIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/FIFOEmpty1In
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/FIFOEmpty0In
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/WrRdyIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/RdRdyIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFOpRdEnOut
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFOpIn
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/QLevelIn
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFCTRL0In
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFCTRL1In
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFCONF0In
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFCONF1In
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFCONF2In
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/EccIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/AutoEccWrEnIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/BoundaryIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NST_RdataOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CST_RdataOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CST_WdataOut
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/EccDataOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/EccDataEnOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/AddrValidOut
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/ColumnAddrOut
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFDataIn
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFDataOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFDataOutEnOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CLEOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/ALEOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/nNFCE3Out
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/nNFCE2Out
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/nNFCE1Out
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/nNFCE0Out
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/nNFREOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/nNFWEOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/FiltRnB3In
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/FiltRnB2In
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/FiltRnB1In
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/FiltRnB0In
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/TransSize
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CurrentState
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NextState
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/TNextSt
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/TCurrentSt
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFCtrlRst
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/Ecc512En
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/AutoEccWr
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/DMAEn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/WrEndIntEn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/RdEndINTEn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/FIFOintEn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/RnBIntEn3
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/RnBIntEn2
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/RnBIntEn1
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/RnBIntEn0
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFBootEn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/IOWidth
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NandWidth
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/BootCfg
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/OutDtmn
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/TADLTWB
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/TCALS
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/TRWLP
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/TRWHP
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/Two8BitNand
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/FirstOper
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CmdAddr1
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CmdAddr2
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/ChipSel
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/RnBWait
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/AutoRdStat
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/Continue
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/DataSize
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CmdAddrTransByte
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CmdAddrFlag
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/ReadData
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/ReadStatus
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/ReadID
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/WriteData
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NOP
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/LoadEnd
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NextCmd
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CmdAddrTransCnt
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/DataSizeCnt
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/TadlTwbEnd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/TrwhpEnd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/TrwlpEnd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/TcalsEnd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CST_Idle
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CST_Load
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CST_Cmd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CST_Addr
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CST_RnBCheck
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CST_Wait2Clk
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CST_Wdata
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CST_Rdata
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NST_Idle
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NST_Load
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NST_Cmd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NST_Addr
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NST_RnBCheck
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NST_Wait2Clk
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NST_Wdata
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NST_Rdata
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CTST_Idle
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CTST_TadlTwb
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CTST_Tcals
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CTST_Trwlp
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CTST_Trwhp
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NTST_Idle
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NTST_TadlTwb
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NTST_Tcals
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NTST_Trwlp
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NTST_Trwhp
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFOutData
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/PackingCnt
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/ParsingCnt
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/TCALSCnt
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/TRWLPCnt
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/TRWHPCnt
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/TADLTWBCnt
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/DataEnd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/PageSize
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/AddrCycleCnt
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/RdRdy_Dly
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/FIFORdData
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/RdDataEn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/RdDataEnDly
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/WrReady
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFWrDataReady
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/FIFOWrEn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFWrEnd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFWrDataLoad
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/Byte_8bitBus
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/Byte_16bitBus
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/HalfWord_8bitBus
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/HalfWord_16bitBus
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/WaitCnt
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CmdTimingEnd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/AddrTimingEnd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/WrDataEnd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CmdAddrTransEnd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/RnBHigh
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/RdStatusEnd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/WaitEnd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/RnBCheckBeforeNextCmd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/BootStart
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/RdDataEnd
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/LoadCnt
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/OperRdEn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/OperRdEnDly
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFOpWordNum
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/OpRdEnd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/tAREn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/tAREnDly
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/GoTcals
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/GoTrwhp
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/GoIdle
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/BFull
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/GoTadl
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/GoTrwlp
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/GoTrwlp0
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/GoTrwlp1
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/GoTrwlp2
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/GoTrwlp3
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/ByteShift
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NState
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CState
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/TNState
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/TCState
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/Clk
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/nRst
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/DMAReqOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/BootOpRdEnOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/BootOpReadyIn
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/BootOpIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/BootEndIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFCtrlBusyOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFStatValidOut
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFStatusOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/WrEndOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/RdEndOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/WrFIFOReadyOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/RdFIFOReadyOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/FIFOFlushOut
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/FIFORdDataIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/FIFORdDataEnOut
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/FIFOWrDataOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/FIFOWrDataEnOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/BeforeFullIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/FIFORdReadyIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/FIFOFullIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/FIFOHalfFullIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/FIFOEmpty1In
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/FIFOEmpty0In
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/WrRdyIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/RdRdyIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFOpRdEnOut
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFOpIn
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/QLevelIn
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFCTRL0In
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFCTRL1In
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFCONF0In
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFCONF1In
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFCONF2In
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/EccIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/AutoEccWrEnIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/BoundaryIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NST_RdataOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CST_RdataOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CST_WdataOut
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/EccDataOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/EccDataEnOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/AddrValidOut
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/ColumnAddrOut
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFDataIn
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFDataOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFDataOutEnOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CLEOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/ALEOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/nNFCE3Out
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/nNFCE2Out
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/nNFCE1Out
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/nNFCE0Out
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/nNFREOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/nNFWEOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/FiltRnB3In
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/FiltRnB2In
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/FiltRnB1In
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/FiltRnB0In
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/TransSize
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CurrentState
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NextState
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/TNextSt
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/TCurrentSt
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFCtrlRst
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/Ecc512En
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/AutoEccWr
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/DMAEn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/WrEndIntEn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/RdEndINTEn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/FIFOintEn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/RnBIntEn3
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/RnBIntEn2
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/RnBIntEn1
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/RnBIntEn0
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFBootEn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/IOWidth
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NandWidth
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/BootCfg
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/OutDtmn
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/TADLTWB
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/TCALS
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/TRWLP
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/TRWHP
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/Two8BitNand
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/FirstOper
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CmdAddr1
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CmdAddr2
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/ChipSel
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/RnBWait
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/AutoRdStat
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/Continue
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/DataSize
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CmdAddrTransByte
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CmdAddrFlag
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/ReadData
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/ReadStatus
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/ReadID
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/WriteData
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NOP
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/LoadEnd
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NextCmd
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CmdAddrTransCnt
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/DataSizeCnt
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/TadlTwbEnd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/TrwhpEnd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/TrwlpEnd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/TcalsEnd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CST_Idle
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CST_Load
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CST_Cmd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CST_Addr
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CST_RnBCheck
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CST_Wait2Clk
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CST_Wdata
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CST_Rdata
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NST_Idle
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NST_Load
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NST_Cmd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NST_Addr
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NST_RnBCheck
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NST_Wait2Clk
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NST_Wdata
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NST_Rdata
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CTST_Idle
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CTST_TadlTwb
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CTST_Tcals
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CTST_Trwlp
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CTST_Trwhp
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NTST_Idle
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NTST_TadlTwb
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NTST_Tcals
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NTST_Trwlp
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NTST_Trwhp
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFOutData
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/PackingCnt
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/ParsingCnt
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/TCALSCnt
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/TRWLPCnt
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/TRWHPCnt
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/TADLTWBCnt
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/DataEnd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/PageSize
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/AddrCycleCnt
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/RdRdy_Dly
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/FIFORdData
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/RdDataEn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/RdDataEnDly
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/WrReady
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFWrDataReady
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/FIFOWrEn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFWrEnd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFWrDataLoad
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/Byte_8bitBus
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/Byte_16bitBus
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/HalfWord_8bitBus
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/HalfWord_16bitBus
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/WaitCnt
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CmdTimingEnd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/AddrTimingEnd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/WrDataEnd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CmdAddrTransEnd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/RnBHigh
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/RdStatusEnd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/WaitEnd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/RnBCheckBeforeNextCmd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/BootStart
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/RdDataEnd
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/LoadCnt
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/OperRdEn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/OperRdEnDly
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NFOpWordNum
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/OpRdEnd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/tAREn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/tAREnDly
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/GoTcals
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/GoTrwhp
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/GoIdle
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/BFull
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/GoTadl
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/GoTrwlp
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/GoTrwlp0
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/GoTrwlp1
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/GoTrwlp2
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/GoTrwlp3
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/ByteShift
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/NState
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/CState
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/TNState
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/NFTop_1/uNFCtrl/TCState
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/WDATA_1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/Two_NFTop_0/RDATA_1
add wave -noupdate -format Literal -radix hexadecimal /Tb_Two_NFTop/data_read_1/rdata
add wave -noupdate -format Literal /Tb_Two_NFTop/NFIO_1
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/CLK
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RESETn
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/EXT_SFR_ADDR
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/EXT_SFR_WR
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/EXT_SFR_DOUT
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/EXT_SFR_DIN
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/CS
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/WDATA
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RDATA
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/We
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/Oe
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/IntReqOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFCtrlBusyIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFStatValidIn
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFStatusIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/WrEndIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RdEndIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RdFIFOReadyIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/WrFIFOReadyIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FiltRnB3In
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FiltRnB2In
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FiltRnB1In
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FiltRnB0In
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOFlushIn
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFORdDataOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFORdDataEnIn
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOWrDataIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOWrDataEnIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/BeforeFullOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFORdReadyOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOFullOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOHalfFullOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOEmpty0Out
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOEmpty1Out
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/WrRdyOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RdRdyOut
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFOpRdEnIn
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFOpOut
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/QLevelOut
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/ControlOut0
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/ControlOut1
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/ConfigOut0
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/ConfigOut1
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/ConfigOut2
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/TransSize
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFOPER0
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFOPER1
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFOPER2
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFOPER3
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFCONF0
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFCONF1
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFCONF2
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFCTRL0
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFCTRL1
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFSTAT0
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFSTAT1
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFSTAT2
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFSTAT3
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFFIFOSTAT0
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFFIFOSTAT1
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/QLevel
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/Timing0
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/Timing1
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/Ctrl0
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/Ctrl1
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFStatValid
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/WrEnd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RdEnd
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RnBDetect3
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RnBDetect2
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RnBDetect1
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RnBDetect0
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RnB3
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RnB2
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RnB1
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RnB0
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOLevel
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOWrEn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFORdEn
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOWrData
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFORdData
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/QWrData
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOWrCnt
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFORdCnt
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOWrCollect
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOData
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/DivRdEn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFCtrlRst
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RegWriteEn
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/QWrCnt
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFOPER0_adr
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFOPER1_adr
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFOPER2_adr
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFOPER3_adr
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFCONF0_adr
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFCONF1_adr
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFCONF2_adr
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFCTRL0_adr
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFCTRL1_adr
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFSTAT0_adr
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFSTAT1_adr
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFSTAT2_adr
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFSTAT3_adr
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFFIFOSTAT0_adr
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFFIFOSTAT1_adr
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/QWrEn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFORst
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOCnt1
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/FIFOCnt0
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/WrEnd_Dly
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RdEnd_Dly
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/WrFIFOReady_Dly
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RdFIFOReady_Dly
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RnB3_Dly
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RnB2_Dly
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RnB1_Dly
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/RnB0_Dly
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NFBootPinIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/IOWidthPinIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/NandWidthPinIn
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/BootCfgPinIn
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/OutDtmnPinIn
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/Timing_conf0
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/Timing_conf1
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/Control0
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFTop_0/uNFAPBIF/Control1
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/PCLK
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/PRESETn
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/EXT_SFR_ADDR
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/EXT_SFR_WR
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/EXT_SFR_DOUT
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/EXT_SFR_DIN_0
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/CS_0
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/WDATA_0
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/RDATA_0
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/We_0
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/Oe_0
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFDMAReqOut_0
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFINTOut_0
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFDataIn_0
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFDataOut_0
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFDataOutEn_0
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/CLE_0
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/ALE_0
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/nNFCE0_0
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/nNFCE1_0
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/nNFCE2_0
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/nNFCE3_0
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/nNFRE_0
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/nNFWE_0
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/RnB0_0
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/RnB1_0
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/RnB2_0
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/RnB3_0
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/EXT_SFR_DIN_1
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/CS_1
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/WDATA_1
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/RDATA_1
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/We_1
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/Oe_1
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFDMAReqOut_1
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFINTOut_1
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFDataIn_1
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFDataOut_1
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFDataOutEn_1
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/CLE_1
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/ALE_1
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/nNFCE3_1
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/nNFCE2_1
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/nNFCE1_1
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/nNFCE0_1
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/nNFRE_1
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/nNFWE_1
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/RnB3_1
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/RnB2_1
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/RnB1_1
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/RnB0_1
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFDataIn_0_Sel
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFDataOut_0_Sel
add wave -noupdate -format Literal /Tb_Two_NFTop/Two_NFTop_0/NFDataOut_1_Sel
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/NFDataOutEn_Sel
add wave -noupdate -format Logic /Tb_Two_NFTop/Two_NFTop_0/IOWidthPinIn
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2050000 ps} 0}
configure wave -namecolwidth 408
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
WaveRestoreZoom {0 ps} {3950080 ps}
