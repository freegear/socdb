onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /tb/RESETn
add wave -noupdate -format Logic -radix hexadecimal /tb/Clock
add wave -noupdate -divider prom
add wave -noupdate -format Literal -radix hexadecimal /tb/EXT_ADDR
add wave -noupdate -format Literal -radix hexadecimal /tb/EXT_DATA
add wave -noupdate -format Logic -radix hexadecimal /tb/EXT_CSb
add wave -noupdate -format Logic -radix hexadecimal /tb/EXT_OEb
add wave -noupdate -format Logic -radix hexadecimal /tb/EXT_WEb
add wave -noupdate -format Literal -radix hexadecimal /tb/EXT_BEb
add wave -noupdate -format Literal -radix hexadecimal /tb/EXT_WBEb
add wave -noupdate -divider {Core Input signals}
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/CLK
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/nFIQ
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/nIRQ
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/EXTEST
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/VINITHI
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/BIGENDINIT
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/INTEST
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/TAPID
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/HRESETn
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/DHCLKEN
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/SCANENABLE
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/IRDMAADDR
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/IRDMACS
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/IRDMAEN
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/DRDMAADDR
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/DRDMACS
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/DRDMAEN
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/DHGRANT
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/DHREADY
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/DHRESP
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/INITRAM
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/DHRDATA
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/IRSIZE
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/IRWAIT
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/IHCLKEN
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/IRRD
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/DRSIZE
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/DRWAIT
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/DRRD
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/FIFOFULL
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/ETMEN
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/IHGRANT
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/IHREADY
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/IHRESP
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/IHRDATA
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/DBGSDOUT
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/TESTMODE
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/DBGTMS
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/DBGTDI
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/DBGTCKEN
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/CPDIN
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/DBGnTRST
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/DBGDEWPT
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/CHSDE
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/CHSEX
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/DBGIEBKPT
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/DBGEXT
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/EDBGRQ
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/CPBURST
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/DBGEN
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/CPEN
add wave -noupdate -divider DDR
add wave -noupdate -format Logic -radix hexadecimal /tb/SD_CLK
add wave -noupdate -format Logic -radix hexadecimal /tb/SD_nCLK
add wave -noupdate -format Literal -radix hexadecimal /tb/SD_ADDR
add wave -noupdate -format Literal -radix hexadecimal /tb/SD_BADDR
add wave -noupdate -format Logic -radix hexadecimal /tb/SD_CSB
add wave -noupdate -format Logic -radix hexadecimal /tb/SD_RASB
add wave -noupdate -format Logic -radix hexadecimal /tb/SD_CASB
add wave -noupdate -format Logic -radix hexadecimal /tb/SD_WEB
add wave -noupdate -format Literal -radix hexadecimal /tb/SD_DQM
add wave -noupdate -format Logic -radix hexadecimal /tb/SD_CKE
add wave -noupdate -format Literal -radix hexadecimal /tb/SD_DQ
add wave -noupdate -format Literal -radix hexadecimal /tb/SD_DQS
add wave -noupdate -format Logic -radix hexadecimal /tb/UART_TXD
add wave -noupdate -format Logic -radix hexadecimal /tb/I2C_SDA
add wave -noupdate -format Logic -radix hexadecimal /tb/I2C_SCL
add wave -noupdate -format Logic -radix hexadecimal /tb/LCDClk
add wave -noupdate -format Logic -radix hexadecimal /tb/LCDHSync
add wave -noupdate -format Logic -radix hexadecimal /tb/LCDVSync
add wave -noupdate -format Logic -radix hexadecimal /tb/LCDDataEn
add wave -noupdate -format Literal -radix hexadecimal /tb/LCDData
add wave -noupdate -format Logic -radix hexadecimal /tb/led_4094clk
add wave -noupdate -format Logic -radix hexadecimal /tb/led_4094d
add wave -noupdate -format Logic -radix hexadecimal /tb/led_4094oe
add wave -noupdate -format Literal -radix hexadecimal /tb/led_4094str
add wave -noupdate -format Logic -radix hexadecimal /tb/MMC_CLKOUT
add wave -noupdate -format Logic -radix hexadecimal /tb/MMC_CMD
add wave -noupdate -format Literal -radix hexadecimal /tb/MMC_DAT
add wave -noupdate -format Logic -radix hexadecimal /tb/ertclk
add wave -noupdate -format Logic -radix hexadecimal /tb/etdo
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/IEXTClk
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/CP15DbgClkEn
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/CP15PipeClkEn
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/ARM9ClkEn
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/DCClkEn
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/DEXTClkEn
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/DTCMClkEn
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/ICClkEn
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/IEXTClkEn
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/ITCMClkEn
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/MMUClkEn
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/GCLK
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/CLK
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/SnReset
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/InMREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/IKILL
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/InTRANS
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ISEQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DnMREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DKILL
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/u9EJ/uARM9/uDbg/uDbgctl/uTapScanctl/TCkEn
add wave -noupdate -format Literal /tb/Top/Core/cpu/CPU/uCORE/u9EJ/uARM9/uDbg/uDbgctl/uTapScanctl/SCSelRegE
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/u9EJ/uARM9/uDbg/uDbgctl/uTapScanctl/TestLogicReset
add wave -noupdate -format Literal /tb/Top/Core/cpu/CPU/uCORE/u9EJ/uARM9/uDbg/uDbgctl/uTapScanctl/SCSelShftReg
add wave -noupdate -format Literal /tb/Top/Core/cpu/CPU/uCORE/u9EJ/uARM9/uDbg/uDbgctl/uTapScanctl/SCSelRegInt
add wave -noupdate -format Literal /tb/Top/Core/cpu/CPU/uCORE/u9EJ/uARM9/uDbg/uDbgctl/uTapScanctl/SCSelShftRegE
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/u9EJ/uARM9/uDbg/uDbgctl/uTapScanctl/ScanN
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/u9EJ/uARM9/uDbg/uDbgctl/uTapScanctl/CaptureDR
add wave -noupdate -format Literal /tb/Top/Core/cpu/CPU/uCORE/u9EJ/uARM9/uDbg/uDbgctl/uTapScanctl/InstrReg
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/u9EJ/uARM9/uDbg/uDbgctl/uTapScanctl/TestLogicReset
add wave -noupdate -format Literal /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DBURST
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DMORE
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DnRW
add wave -noupdate -format Literal /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DMAS
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DnTRANS
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DLOCK
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/nIRQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ETMInMREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ETMIKILL
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/PASS
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DBGRQI
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/EDBGRQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DBGACK
add wave -noupdate -format Literal /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DBGSCREG
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DBGTCKEN
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/nFIQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/FIFOFULL
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/IBIUIdle
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DBIUIdle
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/BIGEND
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ForceNCNB
add wave -noupdate -format Literal /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DAME
add wave -noupdate -format Literal /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/IAFE
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/SampleInt
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/MMUIdle
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DTCMEn
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ITCMEn
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DLookupStall
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DTLBReady
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DTCMRegion
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DCRegion
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DNCBRegion
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DNCNBRegion
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DtoITCM
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DMMUAbort
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/TraceMaskFIQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ILookupStall
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ITLBReady
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ITCMRegion
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ICRegion
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/INCRegion
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/IMMUAbort
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/TraceMaskIRQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/CP15DWB
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/CP15WFI
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/CP15IPrefetch
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/CP15IHazard
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/IEXTReady
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/IEXTError
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/IEXTNoFinish
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/IEXTBlocked
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/IEXTIdle
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/CP15Active
add wave -noupdate -format Literal /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/CPBURSTEX
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/MRCinME
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/MCRinME
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/STCinME
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/LDCinME
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/CP15Idle
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ICIdle
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ICNoFinish
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/EXTEST
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DEXTReady
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DEXTError
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DEXTNoFinish
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DEXTBlocked
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DEXTIdle
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ICReady
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DCIdle
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DCNoFinish
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DCReady
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ITCMBUSY
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ITCMReady
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DTCMBUSY
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DTCMReady
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/MMUReady
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/SysReady
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/SysStall
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/PotentialXAbort
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/UIExtAbortHeld
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/IExtAbortHeld
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/IEXTWordAborted
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ClrDExtAbortHeld
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/WFIStall
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/CP15CacheOpStall
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/UDExtAbortHeld
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DExtWordAborted
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DExtAbortHeld
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DExtAbortAccum
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/EnDExtAbort
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/pDCReady
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/pDTCMReady
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/pDEXTReady
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/pICReady
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/pITCMReady
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/FIFOFULLStall
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/EnFIFOFULLStall
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/pnIRQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/pIEXTReady
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/pDtoITCMPending
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/pDTCMPending
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/pnFIQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/nIRQCLKEN
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/nFIQdelayed
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/pDCPending
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/nIRQdelayed
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/pDEXTPending
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/InstrBoundaryDE
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/InstrBoundaryEXNoKill
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/InstrBoundaryEX
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/UIPrefetchDone
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/UCP15DWBDone
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/SystemIdle
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/UCP15WFIDone
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/USTANDBYWFI
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/pITCMPending
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/UWFIWakeUp
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/pICPending
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/EndianStall
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/pIEXTPending
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/UEndianStall
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/SetEndianStall
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ClrEndianStall
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/EndianChange
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/WriteBufHazard
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/UpdateCFGBIGEND
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/OldBIGEND
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/SampleBIGEND
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/USampleBIGEND
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/pCP15Active
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/nFIQCLKEN
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ITCMPending
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ICPending
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/IEXTPending
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DtoITCMPending
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DTCMPending
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DCPending
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DEXTPending
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/StopCP15PipeClk
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/StopDCClk
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/StopDTCMClk
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/StopDEXTClk
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/StopITCMClk
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/StopICClk
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/StopIEXTClk
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/StopARM9Clk
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ForceClkEn
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/NoFinish
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ITCMIdle
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DTCMIdle
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DCancelME
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ICancelFE
add wave -noupdate -format Literal /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/EnDEXTBURST4
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/EnDEXTBURST
add wave -noupdate -format Literal /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/BurstInitial
add wave -noupdate -format Literal /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/BurstRaw
add wave -noupdate -format Literal /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/USplitBurstXPage
add wave -noupdate -format Literal /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/SplitBurstXPage
add wave -noupdate -format Literal /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/SplitBurstInitial
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/SplitBurstME
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DNearBoundaryME
add wave -noupdate -format Literal /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/EndLowerME
add wave -noupdate -format Literal /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/BURST1stEX
add wave -noupdate -format Literal /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/BURSTME
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ScanChain15Sel
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DMREQMENoKill
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DMREQME
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DMOREME
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DSEQEX
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DSEQME
add wave -noupdate -format Literal /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DMASME
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DnRWME
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DLOCKME
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DFirstWordME
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DLastWordME
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/IMREQFENoKill
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/IMREQFE
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/pSysCLKEN
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/IMREQIssuedCA
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/IMREQIssuedFE
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/INonSeqCA
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/INonSeqFE
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/pCP15IPrefetch
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/IPrefetchMREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/IPrefetchMREQFE
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ICPrefetchMREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DEXTRegion
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DuTLBLookup
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/IuTLBLookup
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/IRegenEnable
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/IEXTRegenMREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ICRegenMREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ITCMRegenMREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DRegenEnable
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DtoITCMRegenMREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DEXTRegenMREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DCRegenMREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DTCMRegenMREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DRegenReqIssued
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/EnIEXTCoreMREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/IEXTCoreMREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/EnICCoreMREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ICCoreMREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/EnITCMCoreMREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ITCMCoreMREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/EnDEXTCoreMREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DEXTCoreMREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/EnDCCoreMREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DCCoreMREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/EnDTCMCoreMREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DTCMCoreMREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DTCMREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ITCMREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/pDTCMREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/pITCMREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/pIEXTMREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/pDEXTMREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/pDCMREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/pICMREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/pDtoITCMRegenMREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DtoITCMAccess
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DtoITCMAccessRaw
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/NextDtoITCMRaw
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/SampleDtoITCMRaw
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/pDtoISelDPA
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/pIMMUAbort
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/pDMMUAbort
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DSysState
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ISysState
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DNextSysState
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/INextSysState
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DRegenComplete
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ITCMComplete
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DRegen
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/IRegen
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DorIRegen
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ILastInPageFE
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/IForceNonSeq
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/pIForceNonSeq
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/SetIForceNonSeq
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ClrIForceNonSeq
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/EnISEQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DLastInPageME
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DFirstInPageME
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DSingleTransferEX
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DSingleTransferME
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/EnDSEQ
add wave -noupdate -format Literal /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/BURSTEX
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/MMUClkEn
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ARM9ClkEn
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/CP15DbgClkEn
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/CP15PipeClkEn
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DEXTClkEn
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/IEXTClkEn
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DTCMClkEn
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ITCMClkEn
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DCClkEn
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ICClkEn
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/INSTRCapture
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/INSTRSelHold
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/INSTRSelITCMRD
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/INSTRSelIEXTRD
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/INSTRSelICRD
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/CPWDCapture
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/CPWDSelHold
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/CPWDSelITCMRD
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/CPWDSelDTCMRD
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/CPWDSelDEXTRD
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/CPWDSelDCRD
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/CPWDSelWDATA
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/WDSelWDATA
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/WDSelCP15RD
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/RDCapture
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/RDSelHold
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/RDSelITCMRD
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/RDSelDTCMRD
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/RDSelDEXTRD
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/RDSelDCRD
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/RDSelCP15RD
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/CFGBIGEND
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/STANDBYWFI
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/CP15DWBDone
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/CP15WFIDone
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/IPrefetchDone
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/CP15CLKEN
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/SysBIGEND
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ICCancel
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ICSEQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ICMREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DCCancel
add wave -noupdate -format Literal /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DCMAS
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DCnRW
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DCSEQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DCMREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ITCMSelIAHeld
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DTCMSelDAHeld
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DTCMSampleDA
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ITCMSampleIA
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DtoISelDPA
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ITCMNoReq
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ITCMCancel
add wave -noupdate -format Literal /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ITCMAS
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ITCMnRW
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ITCMSEQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ITCMWRREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/ITCMRDREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DTCMNoReq
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DTCMCancel
add wave -noupdate -format Literal /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DTCMAS
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DTCMnRW
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DTCMSEQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DTCMWRREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DTCMRDREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DEXTSwap
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DPrivileged
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DEXTCancel
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DEXTCached
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DEXTBuffered
add wave -noupdate -format Literal /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DEXTMAS
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DEXTnRW
add wave -noupdate -format Literal /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DEXTBURST
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DEXTSEQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DEXTMREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/IPrivileged
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/IEXTCancel
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/IEXTSEQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/IEXTMREQ
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/IExtAbort
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DExtAbort
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/SysCLKEN
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/IVASelIAHeld
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/DVASelDAHeld
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/FCSESampleDA
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/FCSESampleIA
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/nIRQARM9
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/nFIQARM9
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/CLKEN
add wave -noupdate -format Logic /tb/Top/Core/cpu/CPU/uCORE/uSysCtl/WFIWakeUp
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uClkBlk/CLK
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uClkBlk/HRESETn
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uClkBlk/DisableBlkClkGate
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uClkBlk/WFIWakeUp
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uClkBlk/STANDBYWFI
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uClkBlk/ICClkEn
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uClkBlk/DCClkEn
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uClkBlk/ITCMClkEn
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uClkBlk/DTCMClkEn
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uClkBlk/IEXTClkEn
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uClkBlk/DEXTClkEn
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uClkBlk/CP15PipeClkEn
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uClkBlk/CP15DbgClkEn
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uClkBlk/ARM9ClkEn
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uClkBlk/MMUClkEn
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uClkBlk/ETMEN
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uClkBlk/TESTMODE
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uClkBlk/GCLK
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uClkBlk/ARM9Clk
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uClkBlk/IEXTClk
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uClkBlk/DEXTClk
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uClkBlk/ICClk
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uClkBlk/DCClk
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uClkBlk/DTCMClk
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uClkBlk/ITCMClk
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uClkBlk/CP15PipeClk
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uClkBlk/CP15DebugClk
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uClkBlk/MMUClk
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uClkBlk/ETMIFClk
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uClkBlk/pETMEN
add wave -noupdate -divider {ARM926 Wrapper}
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/ARESETn
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/ACLK
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/BusClockEn
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/VINITHI
add wave -noupdate -divider {AHB Instruction}
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IHCLKEN
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IHBUSREQ
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IHBUSREQ_ff
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IHGRANT
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IHADDR
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IHTRANS
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IHWRITE
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IHSIZE
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IHBURST
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IHPROT
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IHWDATA
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IHRDATA
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IHREADY_IN
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IHREADY_OUT
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IHRESP
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IHSEL
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IHLOCK
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IHMASTLOCK
add wave -noupdate -divider {AXI Instruction}
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/ARMnFIQ
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/ARMnIRQ
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/ARADDR_ARMI
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/ARLEN_ARMI
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/ARSIZE_ARMI
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/ARBURST_ARMI
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/ARLOCK_ARMI
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/ARVALID_ARMI
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/ARREADY_2_ARMI
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/RRESP_2_ARMI
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/RDATA_2_ARMI
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/RLAST_2_ARMI
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/RVALID_2_ARMI
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/RREADY_ARMI
add wave -noupdate -divider {AHB Data}
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/DHADDR
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/DHTRANS
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/DHWRITE
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/DHSIZE
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/DHBL
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/DHBURST
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/DHPROT
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/DHWDATA
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/DHRDATA
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/DHREADY_IN
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/DHREADY_OUT
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/DHRESP
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/DHSEL
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/DHMASTLOCK
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/DHCLKEN
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/DHBUSREQ
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/DHBUSREQ_ff
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/DHGRANT
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/DHLOCK
add wave -noupdate -divider {AXI Data}
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/ARADDR_ARMD
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/ARLEN_ARMD
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/ARSIZE_ARMD
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/ARBURST_ARMD
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/ARLOCK_ARMD
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/ARVALID_ARMD
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/ARREADY_2_ARMD
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/RRESP_2_ARMD
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/RDATA_2_ARMD
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/RLAST_2_ARMD
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/RVALID_2_ARMD
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/RREADY_ARMD
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/AWADDR_ARMD
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/AWLEN_ARMD
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/AWSIZE_ARMD
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/AWBURST_ARMD
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/AWLOCK_ARMD
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/AWVALID_ARMD
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/AWREADY_2_ARMD
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/WDATA_ARMD
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/WSTRB_ARMD
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/WLAST_ARMD
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/WVALID_ARMD
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/WREADY_2_ARMD
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/BRESP_2_ARMD
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/BVALID_2_ARMD
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/BREADY_ARMD
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/SCANENABLE
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/INTEST
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/EXTEST
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/TESTMODE
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/DBGnTRST
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/DBGTCKEN
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/DBGTDI
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/DBGTMS
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/DBGTDO
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/STANDBYWFI
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/BIGENDINIT
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CFGBIGEND
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/TAPID
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPCLKEN
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPINSTR
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPDOUT
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPDIN
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPPASS
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPLATECANCEL
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CHSDE
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CHSEX
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/nCPINSTRVALID
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/nCPMREQ
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/nCPTRANS
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPBURST
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPABORT
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPEN
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/COMMRX
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/COMMTX
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/DBGACK
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/DBGEN
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/DBGRQI
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/EDBGRQ
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/DBGEXT
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/DBGINSTREXEC
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/DBGRNG
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/DBGIEBKPT
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/DBGDEWPT
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/DBGIR
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/DBGSCREG
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/DBGTAPSM
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/DBGnTDOEN
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/DBGSDIN
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/DBGSDOUT
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/ETMEN
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/FIFOFULL
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/ETMBIGEND
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/ETMHIVECS
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/ETMIA
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/ETMInMREQ
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/ETMISEQ
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/ETMITBIT
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/ETMIJBIT
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/ETMZIFIRST
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/ETMZILAST
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/ETMIABORT
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/ETMDA
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/ETMDMAS
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/ETMDMORE
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/ETMDnMREQ
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/ETMDnRW
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/ETMDSEQ
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/ETMRDATA
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/ETMDABORT
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/ETMWDATA
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/ETMnWAIT
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/ETMDBGACK
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/ETMINSTREXEC
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/ETMRNGOUT
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/ETMID31To25
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/ETMID15To11
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/ETMCHSD
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/ETMCHSE
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/ETMPASS
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/ETMLATECANCEL
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/ETMPROCID
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/ETMPROCIDWR
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/ETMINSTRVALID
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/DRnRW
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/DRADDR
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/DRWD
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/DRIDLE
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/DRCS
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/DRWBL
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/DRSEQ
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/DRRD
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/DRWAIT
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/DRSIZE
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IRnRW
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IRADDR
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IRWD
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IRIDLE
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IRCS
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IRWBL
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IRSEQ
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IRRD
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IRWAIT
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IRSIZE
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/INITRAM
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/DRDMAEN
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/DRDMACS
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/DRDMAADDR
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IRDMAEN
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IRDMACS
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IRDMAADDR
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/BREADY_2_ARMD
add wave -noupdate -divider {AHB2AXI Instruction}
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/CLK
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/RESETn
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HADDR
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HTRANS
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HWRITE
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HSIZE
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HBL
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HBURST
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HPROT
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HWDATA
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HRDATA
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HREADY_IN
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HREADY_OUT
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HRESP
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HSEL
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HMASTLOCK
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/AWADDR
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/AWLEN
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/AWSIZE
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/AWBURST
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/AWLOCK
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/AWCACHE
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/AWPROT
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/AWVALID
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/AWREADY
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/WDATA
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/WSTRB
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/WLAST
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/WVALID
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/WREADY
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/BRESP
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/BVALID
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/BREADY
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/ARADDR
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/ARLEN
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/ARSIZE
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/ARBURST
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/ARLOCK
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/ARCACHE
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/ARPROT
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/ARVALID
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/ARREADY
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/RDATA
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/RRESP
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/RLAST
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/RVALID
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/RREADY
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/State
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/NextState
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/StateIsIDLE
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/StateIsREAD
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/StateIsWRITE
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/StateIsWRITE_RESP
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HTRANS_VALID
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/CommandLatchEn
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HADDR_r
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HADDR_lower_r
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/BurstLen
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/Len
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HTRANS_r
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HSIZE_r
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HBL_r
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HPROT_r
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HMASTLOCK_r
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/WrapBurst
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/NewCommandArrived
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HBURST2Len
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/DecreaseLen
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/ErrorDetected
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/ErrorDetected_1d
add wave -noupdate -divider {JTAG Sync}
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/arm_jtag_sync/clk
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/arm_jtag_sync/rstb
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/arm_jtag_sync/etrstb
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/arm_jtag_sync/etclk
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/arm_jtag_sync/ertclk
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/arm_jtag_sync/etms
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/arm_jtag_sync/etdi
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/arm_jtag_sync/etdo
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/arm_jtag_sync/DBGnTRST
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/arm_jtag_sync/DBGTCKEN
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/arm_jtag_sync/DBGTDI
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/arm_jtag_sync/DBGTMS
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/arm_jtag_sync/DBGTDO
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/arm_jtag_sync/tclk_sync
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/arm_jtag_sync/tclk_en
add wave -noupdate -divider ITLB
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/GCLK
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UTLBnReset
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UTLBreadyout
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/SysCLKEN
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/LookupStall
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/CacheEn
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/SysProt
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/ROMProt
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/AlignCheck
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UTLBreq
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UTLBreadyin
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UTLBidleabortout
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UTLBabortout
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UTLBfs
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UTLBntrans
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UTLBlock
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UTLBnrw
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UTLBabortin
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UTLBdfault
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UTLBdomain
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UTLBcommit
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UTLBpa
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UTLBclient
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UTLBap
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UTLBsize
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UTLBcbL1
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UTLBcbL2
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UTLBregion
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UTLBpage
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/A
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/nMREQ
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/nRW
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/MAS
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/SEQ
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/LOCK
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/nTRANS
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/KILL
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/ABORT
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/PA
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/CP15prefetch
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/TCMregion
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/TCMpagesize
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/TCMnewpage
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/DtoITCM
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/Cregion
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/Writeback
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/NCNBregion
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/NCBregion
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/MMUabort
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/ExtAbort
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/L2Cacheable
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/L2Bufferable
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UTLBinvalidate
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UTLBmatch
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UTLBload
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/CbitD1
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/SbitD1
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/RbitD1
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/AbitD1
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/RegionD1
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/cbL2D1
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/WritebackD1
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/AD1
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/PAD1
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/APfaultC1
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/DfaultC1
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/MfaultC2
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/MfaultD1
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/MASD1
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/nMREQD1
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/AfaultC1
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/SEQabortC2
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/SEQabortD1
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/StallAbortC2
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/StallAbortD1
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/SysClkEnD1
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/MaskC2
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/MaskD1
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/MaskC1
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UTLBreqSetC2
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UTLBreqC2
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UTLBreadyoutC2
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UloadC1
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UloadC2
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UloadD1
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UnTRANS
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/ULOCK
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UnRW
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/APselC2
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/LookupC1
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/LookupD1
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UpdateC2
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/TCMmissC1
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/PageSizeD1
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UreqC1
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UhitEnC2
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UhitEnD1
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UmatchEnC2
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UmatchEnD1
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UmissC1
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UhitC1
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UhitD1
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UinvalC1
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/CP15prefetchD1
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/CP15inval
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UTLBinvalC2
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UTLBinvalD1
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UTLBinval
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UrepcntC2
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UrepcntD1
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/URD
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/URD0
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/URD1
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/URD2
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/URD3
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/URD4
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/URD5
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/URD6
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/URD7
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/URD8
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UWD
add wave -noupdate -format Literal /tb/Top/Core/cpu/CPU/uCORE/uIuTLB/UhitC1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2124367 ps} 0}
configure wave -namecolwidth 178
configure wave -valuecolwidth 118
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
WaveRestoreZoom {0 ps} {14700 ns}
