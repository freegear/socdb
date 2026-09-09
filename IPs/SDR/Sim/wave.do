onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/PCLK
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/PADDR
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/PENABLE
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/PSEL
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/PWDATA
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/PRDATA
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRCtl/tcl
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRCtl/tclp
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRCtl/tmrs
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRCtl/trcd
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRCtl/trrd
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRCtl/trasmin
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRCtl/trp
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRCtl/trc
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRCtl/tmrs_cnt
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRCtl/trc_cnt
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRCtl/trp_cnt
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRCtl/trefresh
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRCtl/refresh_cnt
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRCtl/ar_cnt
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/SelfRefEn
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRCtl/selfref_cnt
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/SDREn
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRCtl/stable_cnt
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/mask1
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/mask2
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/mask3
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/mask4
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/mask5
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/ercmd
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B0SM/ERCMD
add wave -noupdate -format Logic -height 15 -radix hexadecimal {/TbSDR/sdram16bit/Addr[10]}
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/sdram16bit/Addr
add wave -noupdate -format Literal -radix unsigned /TbSDR/sdram16bit/Ba
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/ClrPwDnCnt
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/IncPwDnCnt
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRCtl/PwDnCnt
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/PwDnFlag
add wave -noupdate -format Logic /TbSDR/sdram16bit/Cke
add wave -noupdate -format Logic /TbSDR/sdram16bit/Clk
add wave -noupdate -format Logic /TbSDR/sdram16bit/Sys_clk
add wave -noupdate -format Logic /TbSDR/sdram16bit/Cs_n
add wave -noupdate -format Logic /TbSDR/sdram16bit/Ras_n
add wave -noupdate -format Logic /TbSDR/sdram16bit/Cas_n
add wave -noupdate -format Logic /TbSDR/sdram16bit/We_n
add wave -noupdate -format Literal /TbSDR/sdram16bit/Dqm
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRCtl/ras_0_ba
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRCtl/cas_0_ba
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRCtl/last_ba
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/sdram16bit/Dq
add wave -noupdate -format Logic /TbSDR/sdram16bit/Mode_reg_enable
add wave -noupdate -format Logic /TbSDR/sdram16bit/Aref_enable
add wave -noupdate -format Logic /TbSDR/sdram16bit/Active_enable
add wave -noupdate -format Logic /TbSDR/sdram16bit/Read_enable
add wave -noupdate -format Logic /TbSDR/sdram16bit/Write_enable
add wave -noupdate -format Logic /TbSDR/sdram16bit/Prech_enable
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/rs_state
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/read_bstop
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/rw_bstop
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/bf_tcasbusy
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/bf_tlast
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/bf_tidle
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/cmd_mask
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/WriteReq
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/ReadReq
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/RWCollision
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/rw_stop0
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/rw_bstop0
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/rw_stop1
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/rw_bstop1
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/rw_stop2
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/rw_bstop2
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/rescmd
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/cas_0_rw
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRAi/BA_ID
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/i_ba_req
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRAi/BA_RW
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/cas_0_id
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/do_id_0
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/do_valid_0
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/bf_tlast
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/cas_0_pm
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/cas_pm_0
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/bf_last_0
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/bf_last_1
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/bf_last_2
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/bf_last_3
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/bf_last
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/RdIdMem
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/RdLastMem
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/RdDataMem
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRCtl/RasQ/ras_cnt
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRCtl/CasQ/cas_cnt
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/cas_empty
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/cas_full
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/ras_empty
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/ras_full
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -height 15 -radix hexadecimal {/TbSDR/TestMaster/WTRANS_CNT[15]}
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/TestMaster/WTRANS_CNT
add wave -noupdate -divider {Data Path}
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/di_request
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/do_valid
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/ARESETB
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/PORESETB
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/RQFull
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/WQFull
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/AWAddr
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/AWId
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/AWLen
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/AWValid
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/AWReady
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/WId
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/WReady
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/WValid
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/WLast
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/BReady
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/BValid
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/BId
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/WriteAck
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/tWIdle
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/tWWDat
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/tWWAck
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/tWWReq
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/tWWSpi
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/RespAck
add wave -noupdate -format Literal /TbSDR/SDRTop/SDRAi/BResp
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/ARAddr
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/ARValid
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/ARReady
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/ARId
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/RReady
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/RValid
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/RId
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/RData
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/RLast
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/ReadAck
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/tRIdle
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/tRRReq
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/tRRSpi
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/DiValid
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/WPageMisCal
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRAi/WPageMisCon
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/WSpi1Addr
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/WSpi1Len
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/WSpi2Addr
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/WSpi2Len
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRAi/WriteRequest
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRAi/WriteReqRW
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/WriteReqAA
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/WriteReqID
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/WriteReqTT
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/ReadLatAA
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRAi/ReadLatchEnFd
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/ReadLatID
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/ReadLatTT
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/RPageMisCal
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRAi/RPageMisCon
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/RSpi1Addr
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/RSpi1Len
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/RSpi2Addr
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/RSpi2Len
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRAi/ReadRequest
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRAi/ReadReqRW
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/ReadReqAA
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/ReadReqID
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/ReadReqTT
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/WriteReq
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/ReadReq
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/BA_PM
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRAi/BA_REQ
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRAi/BA_RW
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/BA_ID
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/BA_AA
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/CasQ/BA_BA
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/CasQ/BA_RA
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/CasQ/BA_CA
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/BA_TT
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/BA_STS
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/WrId
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/WQWrite
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRAi/WDatBuf/WrCnt
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/WQWrData
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRAi/WDatBuf/IncRdCnt
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRAi/WDatBuf/RdCnt
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRAi/WDatBuf/DatCnt
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/WriteLatA0
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/WriteLatBB
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/WriteLatID
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/WriteLatTT
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRAi/WBLQEmpty
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRAi/WBLQFull
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/WBLQW
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/tWWReq
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRAi/WBLQWrite
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/WBLQWrData
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRAi/WBLQRead
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/WBLQRdData
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRAi/WBLBuf/WrCnt
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRAi/WBLBuf/RdCnt
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRAi/LatchedWBL
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/WrWrapAddrSt
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRAi/WrWrapCnt
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/WQRead
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/WQRdData
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/SD_DQE
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/SD_DQO
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/FCLK
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/SD_DQI
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/RdId
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/RdLast
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/ReadLatchEnFd
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/RdDataMemFd
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/iDelayReadFlag
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/RdDataRdy
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRAi/RDatBuf/WrCnt
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRAi/RDatBuf/RdCnt
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/RBLBuf/WriteEn
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/RBLBuf/ReadEn
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRAi/RBLBuf/WrCnt
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRAi/RBLBuf/RdCnt
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/RdWrapAddrSt
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRAi/RdWrapCnt
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRAi/LatchedRBL
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRAi/RBurstCnt
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/RdIdMem
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/RdLastMem
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/RdDataMem
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/RQEmpty
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/RBLQEmpty
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/IncRdLastCnt
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/DecRdLastCnt
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRAi/RdLastCnt
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/ReadDatEn
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRAi/tRDIdle
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRAi/tRDReq
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/RQRead
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/RReady
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/RValid
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/RId
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRAi/RData
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRAi/RLast
add wave -noupdate -divider {Bank0 SM}
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/B0SM/ARESETB
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/B0SM/cbs_idle
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/B0SM/cbs_rasing
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/B0SM/cbs_rowopen
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/B0SM/cbs_casing
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/B0SM/cbs_pcing
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/B0SM/BA_REQ
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRAi/BA_RW
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRCtl/B0SM/BA_TT
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B0SM/BA_BA
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B0SM/BA_RA
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B0SM/CAS_0_TT
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/B0SM/CAS_0_FINAL
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/B0SM/CAS_0_NEWROW
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B0SM/LAST_RA
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B0SM/RAS_0_TT
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B0SM/BF_NO
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B0SM/RAS_0_BA
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B0SM/CAS_0_BA
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B0SM/RAS_0_RA
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B0SM/CAS_0_RA
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B0SM/i_bf_reqcmd
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B0SM/BF_REQCMD
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B0SM/BF_CMD
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B0SM/ECMD
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/B0SM/CAS_EMPTY
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/B0SM/RAS_EMPTY
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRCtl/B0SM/trasmin_cnt
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/B0SM/BF_CASBUSY
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/B0SM/BF_TCASBUSY
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B0SM/length
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/B0SM/BF_RASBUSY
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/B0SM/BF_TRASBUSY
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/B0SM/BF_READY
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/B0SM/BF_TREADY
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/B0SM/BF_IDLE
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRCtl/B0SM/trp_cnt
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRCtl/B0SM/trrd_cnt
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRCtl/B0SM/trcd_cnt
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/B0SM/newrowenable
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/B0SM/newrowexist
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/B0SM/cas_0_final_l
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/B0SM/cas_0_newrow_l
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B0SM/openedrow
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/BA_BA
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/BA_TT
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/BA_REQ
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/CAS_0_TT
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/CAS_0_FINAL
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/CAS_0_NEWROW
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/RAS_0_TT
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/BF_NO
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/BF_CASBUSY
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/BF_TCASBUSY
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/BF_RASBUSY
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/BF_TRASBUSY
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/BF_READY
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/BF_TREADY
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/BF_IDLE
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/BF_LAST
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/BF_REQCMD
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/BF_CMD
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/ERCMD
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/ECMD
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/cbs_idle
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/cbs_rasing
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/cbs_rowopen
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/cbs_casing
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/cbs_pcing
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/trp_cnt
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/trrd_cnt
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/trcd_cnt
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/trasmin_cnt
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/length
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/CAS_0_BA
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/CAS_EMPTY
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/RAS_0_BA
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/RAS_EMPTY
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/i_bf_reqcmd
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/RAS_0_RA
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/CAS_0_RA
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/openedrow
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/BA_RA
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/LAST_RA
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/newrowenable
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/newrowexist
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/cas_0_final_l
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRCtl/B2SM/cas_0_newrow_l
add wave -noupdate -divider RasQ
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/RasQ/ARESETB
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/BA_AA
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRCtl/RasQ/BA_REQ
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRCtl/RasQ/ras_cnt
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/RasQ/BA_BA
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/RasQ/BA_RA
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/RasQ/BA_TT
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/RasQ/CMD
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRCtl/RasQ/CLOSING
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/RasQ/B0_LAST_RA
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/B0SM/cbs_rowopen
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/B0SM/cbs_casing
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/RasQ/B1_LAST_RA
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/B1SM/cbs_rasing
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/B1SM/cbs_rowopen
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/B1SM/cbs_casing
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/RasQ/B2_LAST_RA
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/B2SM/cbs_rasing
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/B2SM/cbs_rowopen
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/B2SM/cbs_casing
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/RasQ/B3_LAST_RA
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/B3SM/cbs_rasing
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/B3SM/cbs_rowopen
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/B3SM/cbs_casing
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRCtl/RasQ/RAS_EMPTY
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRCtl/RasQ/RAS_FULL
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/RasQ/l_b0_last_ra
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/RasQ/l_b1_last_ra
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/RasQ/l_b2_last_ra
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/RasQ/l_b3_last_ra
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/RasQ/RAS_0_BA
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/RasQ/RAS_0_RA
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/RasQ/RAS_0_TT
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/RasQ/ras_1_data
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/RasQ/ras_2_data
add wave -noupdate -divider CasQ
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/CasQ/ARESETB
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/CasQ/BA_BA
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/CasQ/BA_RA
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/CasQ/BA_CA
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/CasQ/BA_TT
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRCtl/CasQ/BA_REQ
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRCtl/CasQ/BA_RW
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRCtl/CasQ/cas_cnt
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/CasQ/CMD
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/CasQ/B0_LAST_RA
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/CasQ/B1_LAST_RA
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/CasQ/B2_LAST_RA
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/CasQ/B3_LAST_RA
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/CasQ/CAS_0_BA
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/CasQ/CAS_0_RA
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/CasQ/CAS_0_CA
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/CasQ/CAS_0_TT
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRCtl/CasQ/CAS_0_RW
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRCtl/CasQ/CAS_0_FINAL
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRCtl/CasQ/CAS_0_NEWROW
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRCtl/CasQ/CAS_EMPTY
add wave -noupdate -format Logic -radix hexadecimal /TbSDR/SDRTop/SDRCtl/CasQ/CAS_FULL
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/CasQ/cas_1_data
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/CasQ/cas_2_data
add wave -noupdate -format Literal -radix hexadecimal /TbSDR/SDRTop/SDRCtl/CasQ/cas_3_data
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/CasQ/cas_1_final
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/CasQ/cas_1_newrow
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/CasQ/cas_2_final
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/CasQ/cas_2_newrow
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/CasQ/cas_3_final
add wave -noupdate -format Logic /TbSDR/SDRTop/SDRCtl/CasQ/cas_3_newrow
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRCtl/CasQ/cas_cnt_pos
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRCtl/CasQ/cas_cnt_b0_pos
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRCtl/CasQ/cas_cnt_b1_pos
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRCtl/CasQ/cas_cnt_b2_pos
add wave -noupdate -format Literal -radix unsigned /TbSDR/SDRTop/SDRCtl/CasQ/cas_cnt_b3_pos
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {150036604 ps} 0} {{Cursor 2} {140878543981 ps} 0} {{Cursor 3} {2704766250 ps} 0} {{Cursor 6} {6079923750 ps} 0}
configure wave -namecolwidth 218
configure wave -valuecolwidth 64
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
WaveRestoreZoom {150008393 ps} {150090015 ps}
