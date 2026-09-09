onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/spi_slave/csn
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/spi_slave/sck
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/spi_slave/di
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/spi_slave/do
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/spi_slave/cpol
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/spi_slave/cpha
add wave -noupdate -format Literal -radix hexadecimal /TbSSP/spi_slave/mem_adr
add wave -noupdate -format Literal -radix hexadecimal /TbSSP/spi_slave/sri
add wave -noupdate -format Literal -radix hexadecimal /TbSSP/spi_slave/sro
add wave -noupdate -format Literal -radix hexadecimal /TbSSP/spi_slave/bit_cnt
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/spi_slave/ld
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/spi_slave/clk
add wave -noupdate -format Logic /TbSSP/PCLK
add wave -noupdate -format Logic /TbSSP/PRESETn
add wave -noupdate -format Logic /TbSSP/PSEL
add wave -noupdate -format Logic /TbSSP/PENABLE
add wave -noupdate -format Logic /TbSSP/PWRITE
add wave -noupdate -format Literal -radix hexadecimal /TbSSP/PADDR
add wave -noupdate -format Literal -radix hexadecimal /TbSSP/PRDATA
add wave -noupdate -format Literal -radix hexadecimal /TbSSP/PWDATA
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/SSPFSSIN
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/SSPCLKIN
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/SSPTXDMACLR
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/SSPRXDMACLR
add wave -noupdate -format Literal /TbSSP/Ssp/uSspMTxRxCntl/SspMTxRxNextState
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/SSPFSSOUT
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/SSPCLKOUT
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/SSPRXD
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/SSPTXD
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/nSSPOE
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/nSSPCTLOE
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/SSPINTR
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/SSPRXINTR
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/SSPTXINTR
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/SSPRORINTR
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/SSPRTINTR
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/SSPTXDMASREQ
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/SSPTXDMABREQ
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/SSPRXDMASREQ
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/SSPRXDMABREQ
add wave -noupdate -format Literal -radix hexadecimal /TbSSP/Ssp/PWDATAIn
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/RNE
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/TNF
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/TxFRdPtrInc
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/TxDataAvlbl
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/SPH
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/SPO
add wave -noupdate -format Literal -radix hexadecimal /TbSSP/Ssp/SCR
add wave -noupdate -format Literal -radix hexadecimal /TbSSP/Ssp/FRF
add wave -noupdate -format Literal -radix hexadecimal /TbSSP/Ssp/DSS
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/SSPCLKDIV
add wave -noupdate -format Literal -radix unsigned /TbSSP/Ssp/uSspTxFIFO/uSspTxFCntl/TxFFillLevel
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/RxFWr
add wave -noupdate -format Literal -radix hexadecimal /TbSSP/Ssp/MRxFWrData
add wave -noupdate -format Literal -radix hexadecimal /TbSSP/Ssp/SRxFWrData
add wave -noupdate -format Literal -radix unsigned /TbSSP/Ssp/uSspRxFIFO/uSspRxFCntl/RxFFillLevel
add wave -noupdate -format Literal -radix unsigned /TbSSP/Ssp/uSspRxFIFO/uSspRxRegFile/WrPtr
add wave -noupdate -format Literal -radix unsigned /TbSSP/Ssp/uSspRxFIFO/uSspRxRegFile/RdPtr
add wave -noupdate -format Literal -radix hexadecimal /TbSSP/Ssp/RxFRdData
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/RxFRdPtrInc
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/TFE
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/RFF
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/TxRxBSY
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/BSY
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/CR0Update
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/CPSRUpdate
add wave -noupdate -format Literal -radix hexadecimal /TbSSP/Ssp/SSPCR0
add wave -noupdate -format Literal -radix hexadecimal /TbSSP/Ssp/SSPCR1
add wave -noupdate -format Literal -radix hexadecimal /TbSSP/Ssp/SSPIMSC
add wave -noupdate -format Literal -radix hexadecimal /TbSSP/Ssp/SSPDMACR
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/SSPCR0Wr
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/SSPCR1Wr
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/SSPCPSRWr
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/SSPDRWr
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/SSPIMSCWr
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/SSPICRWr
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/SSPDMACRWr
add wave -noupdate -format Literal -radix hexadecimal /TbSSP/Ssp/TxFRdData
add wave -noupdate -format Literal -radix hexadecimal /TbSSP/Ssp/TxFRdDataIn
add wave -noupdate -format Literal -radix hexadecimal /TbSSP/Ssp/SSPCPSR
add wave -noupdate -format Literal -radix hexadecimal /TbSSP/Ssp/SSPCPSC
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/LBM
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/SSE
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/MS
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/SOD
add wave -noupdate -format Literal -radix hexadecimal /TbSSP/Ssp/DSSPCLK
add wave -noupdate -format Literal -radix hexadecimal /TbSSP/Ssp/FRFPCLK
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/RXRIS
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/RXMIS
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/TXRIS
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/TXMIS
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/RORRIS
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/RORMIS
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/RTMIS
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/TXIM
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/RXIM
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/RTIM
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/RORIM
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/NextSTXD
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/NextnSOE
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/NextSTxRxBSY
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/NxtSTxFRdPtrInc
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/NextSRxFWr
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/TXDMAE
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/RXDMAE
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/FIFOLTE7Full
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/DataStp
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/FSSOUT
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/CLKOUT
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/TXD
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/nCTLOE
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/nOE
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/RORINTR
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/RTINTR
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/INTR
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/IntSSPRXD
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/IntSSPTXINTR
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/IntSSPRXINTR
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/IntSSPRORINTR
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/IntSSPRTINTR
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/IntSSPINTR
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/IntSSPFSSOUT
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/IntSSPCLKOUT
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/IntSSPTXD
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/IntnSSPCTLOE
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/IntnSSPOE
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/TXDMASREQ
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/TXDMABREQ
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/RXDMASREQ
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/RXDMABREQ
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/IntSSPTXDMASREQ
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/IntSSPTXDMABREQ
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/IntSSPRXDMASREQ
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/IntSSPRXDMABREQ
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/IntTXDMACLR
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/IntRXDMACLR
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/RORIC
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/RTIC
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/MRxRT
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/SRxRT
add wave -noupdate -format Logic -radix hexadecimal /TbSSP/Ssp/IncRxTimeOut
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {737535889 ps} 0} {{Cursor 2} {4842894 ps} 0} {{Cursor 6} {635381220 ps} 0} {{Cursor 4} {217930236 ps} 0}
configure wave -namecolwidth 188
configure wave -valuecolwidth 71
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
WaveRestoreZoom {0 ps} {495589500 ps}
