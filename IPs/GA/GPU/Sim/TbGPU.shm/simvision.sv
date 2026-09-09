# SimVision Command Script (Fri Nov 10 10:57:56 KST 2006)

#
# databases
#
if {[database find -match exact -name "TbGPU"] == {}} {
    database open /home/eastbrt2/Project/MyGPU/Sim/TbGPU.shm/TbGPU.trn -name "TbGPU"
}

#
# mmaps
#
mmap new -reuse -name "Example Map" -contents {
{%b=11???? -bgcolor orange -label REG:%x -linecolor yellow -shape bus}
{%x=1F -bgcolor red -label ERROR -linecolor white -shape EVENT}
{%x=2C -bgcolor red -label ERROR -linecolor white -shape EVENT}
{%x=* -label %x -linecolor gray -shape bus}
}

#
# Design Browser windows
#
if {[window find -match exact -name "Design Browser 1"] == {}} {
    window new DesignBrowser -name "Design Browser 1" -geometry 834x672+32+120
} else {
    window geometry "Design Browser 1" 834x672+32+120
}
window target "Design Browser 1" on
browser using "Design Browser 1"
browser set \
    -scope {TbGPU::TbGPU}
browser yview see {TbGPU::TbGPU}

#
# Waveform windows
#
if {[window find -match exact -name "Waveform 1"] == {}} {
    window new WaveWindow -name "Waveform 1" -geometry 1095x672+72+30
} else {
    window geometry "Waveform 1" 1095x672+72+30
}
window target "Waveform 1" on
waveform using "Waveform 1"
waveform sidebar visibility partial
waveform set \
    -primarycursor "TimeA" \
    -signalnames name \
    -signalwidth 175 \
    -units ns \
    -valuewidth 75
cursor set -using "TimeA" -time 246,599,601ps
waveform baseline set -time 249039.56ns

set id [waveform add -signals {TbGPU::TbGPU.ACLK}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.PADDR[9:2]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.PSEL[1:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.PENABLE}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.PWRITE}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.PRDATA[31:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.PWDATA[31:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.RSA[31:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.DnEnable}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.DnAddr[10:0]}}]
waveform format $id -radix %d -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.DnWrite}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.DnData[31:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.DnRData[31:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GPU.or1200_qmem_top.or1200_qmem_ram.rst}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.AWADDR[31:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.AWBURST[1:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.AWID[3:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.AWLEN[3:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.AWREADY}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.AWSIZE[2:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.AWVALID}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.WDATA[31:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.WID[3:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.WLAST}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.WREADY}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.WSTRB[3:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.WVALID}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.BID[3:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.BREADY}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.BRESP[1:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.BVALID}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.OR1200Reg.GpuCmdQ.Clk}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.OR1200Reg.GpuCmdQ.DatCnt[2:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.OR1200Reg.GpuCmdQ.EmptyFlag}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.OR1200Reg.GpuCmdQ.FullFlag}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.OR1200Reg.GpuCmdQ.WriteEn}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.OR1200Reg.GpuCmdQ.WrData[31:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.OR1200Reg.GpuCmdQ.WrCnt[2:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.OR1200Reg.GpuCmdQ.ReadEn}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.OR1200Reg.GpuCmdQ.RdCnt[2:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.OR1200Reg.GpuCmdQ.RdData[31:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.SPRCs}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.SPRAddr[31:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.SPRWrite}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.SPRDataIn[31:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.SPRDataOut[31:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.OR1200Reg.rCQSTSSel}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.OR1200Reg.rCQDATSel}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.OR1200Reg.rCBCONSel}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.OR1200Reg.rCBRSASel}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.OR1200Reg.rCBDATSel}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.GpuRDma.CBEmpty}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.GpuRDma.CBFull}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.GpuRDma.CBHalfFull}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.GpuRDma.BBLQFull}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.GpuRDma.BBLQHFull}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.GpuRDma.BBLQQFull}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.GpuRDma.BBLQEmpty}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.GpuRDma.BurstCnt[3:0]}}]
waveform format $id -radix %d -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.GpuRDma.BurstEnd}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.GpuRDma.BBLQWrite}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.GpuRDma.BBLQWrData[2:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.GpuRDma.BBLQRead}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.GpuRDma.BBLQRdData[2:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.GpuRDma.CBWrite}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.GpuRDma.CBWrData[63:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.GpuRDma.CBRead}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.GpuRDma.CBFIFO.FIFORdData[63:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.GpuRDma.iCBRead}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.GpuRDma.ReqCnt}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.GpuRDma.CBReadData[31:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.GpuRDma.DMAEn}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.RSA[31:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.GpuRDma.tBIdle}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.GpuRDma.tBDCal}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.GpuRDma.tBDReq}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.GpuRDma.tBDEnd}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.GpuRDma.BurstSiz[2:0]}}]
waveform format $id -radix %d -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.GpuRDma.CBSize[4:0]}}]
waveform format $id -radix %d -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.GpuRDma.XDmaReqCnt[4:0]}}]
waveform format $id -radix %d -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.GpuRDma.XDmaReqEnd}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.GpuRDma.DMARCmd}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.GpuRDma.DMARCmdAck}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.GpuRDma.DMARAddr[31:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.GpuRDma.DMARBurstLen[4:0]}}]
waveform format $id -radix %d -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.GpuRDma.DMARData[63:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.GpuRDma.DMARDataValid}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.ga_axir.grsize[4:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.ga_axir.rest_len[5:0]}}]
waveform format $id -radix %d -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.ga_axir.rest_lenm1[4:0]}}]
waveform format $id -radix %d -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.ga_axir.need_wd[5:0]}}]
waveform format $id -radix %d -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.ga_axir.burst_len[2:0]}}]
waveform format $id -radix %d -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.ga_axir.now_len[2:0]}}]
waveform format $id -radix %d -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.ga_axir.sm_aidle}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.ga_axir.sm_await}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.ga_axir.sm_idle}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.ga_axir.sm_calc_len}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.ga_axir.sm_rd_cmd}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.ga_axir.sm_rd_data}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.ga_axir.ARADDR[31:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.ga_axir.ARBURST[1:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.ga_axir.ARID[3:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.ga_axir.ARLEN[3:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.ga_axir.ARREADY}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.ga_axir.ARSIZE[2:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.ga_axir.ARVALID}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.ga_axir.BBLBuf.WriteEn}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.ga_axir.BBLBuf.WrData[8:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.ga_axir.BBLBuf.ReadEn}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.ga_axir.BBLBuf.RdCnt[2:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.ga_axir.BBLQEmpty}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.ga_axir.BBLQFull}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.ga_axir.BBLQHFull}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.ga_axir.BBLQWrite}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.ga_axir.BBLQWrData[8:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.ga_axir.BBLQRead}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.ga_axir.BBLQRdData[8:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.ga_axir.rest_addr[2:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.ga_axir.now_byte[5:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.ga_axir.sm_didle}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.ga_axir.sm_ddata}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.ga_axir.RDATA[63:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.ga_axir.RID[3:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.ga_axir.RREADY}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.ga_axir.RVALID}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TbGPU::TbGPU.GpuIf.ga_axir.RLAST}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TbGPU::TbGPU.GpuIf.ga_axir.RRESP[1:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}

waveform xview limits 246599.601ns 249039.56ns

#
# preferences
#
preferences set ams-show-flow {1}
preferences set ams-show-potential {1}
preferences set analog-height {5}
preferences set color-verilog-by-value {1}
preferences set create-cursor-for-new-window {0}
preferences set cv-num-lines {25}
preferences set cv-show-only {1}
preferences set db-scope-gen-compnames {0}
preferences set db-scope-gen-icons {1}
preferences set db-scope-gen-sort {name}
preferences set db-scope-gen-tracksb {0}
preferences set db-scope-systemc-processes {1}
preferences set db-scope-verilog-cells {1}
preferences set db-scope-verilog-functions {1}
preferences set db-scope-verilog-namedbegins {1}
preferences set db-scope-verilog-namedforks {1}
preferences set db-scope-verilog-tasks {1}
preferences set db-scope-vhdl-assertions {1}
preferences set db-scope-vhdl-assignments {1}
preferences set db-scope-vhdl-blocks {1}
preferences set db-scope-vhdl-breakstatements {1}
preferences set db-scope-vhdl-calls {1}
preferences set db-scope-vhdl-generates {1}
preferences set db-scope-vhdl-processstatements {1}
preferences set db-scope-vhdl-unnamedprocesses {1}
preferences set db-show-editbuf {0}
preferences set db-show-modnames {0}
preferences set db-show-values {simulator}
preferences set db-signal-filter-constants {1}
preferences set db-signal-filter-generics {1}
preferences set db-signal-filter-other {1}
preferences set db-signal-filter-quantities {1}
preferences set db-signal-filter-signals {1}
preferences set db-signal-filter-terminals {1}
preferences set db-signal-filter-variables {1}
preferences set db-signal-gen-radix {default}
preferences set db-signal-gen-showdetail {0}
preferences set db-signal-gen-showstrength {0}
preferences set db-signal-gen-sort {name}
preferences set db-signal-show-assertions {1}
preferences set db-signal-show-errorsignals {1}
preferences set db-signal-show-fibers {1}
preferences set db-signal-show-inouts {1}
preferences set db-signal-show-inputs {1}
preferences set db-signal-show-internal {1}
preferences set db-signal-show-live {1}
preferences set db-signal-show-mutexes {1}
preferences set db-signal-show-outputs {1}
preferences set db-signal-show-semaphores {1}
preferences set db-signal-vlogfilter-branches {1}
preferences set db-signal-vlogfilter-memories {1}
preferences set db-signal-vlogfilter-parameters {1}
preferences set db-signal-vlogfilter-registers {1}
preferences set db-signal-vlogfilter-variables {1}
preferences set db-signal-vlogfilter-wires {1}
preferences set default-ams-formatting {potential}
preferences set default-time-units {ar}
preferences set delete-unused-cursors-on-exit {1}
preferences set delete-unused-groups-on-exit {1}
preferences set enable-toolnet {0}
preferences set initial-zoom-out-full {0}
preferences set key-bindings {
	Edit>Undo "Ctrl+Z"
	Edit>Redo "Ctrl+Y"
	Edit>Copy "Ctrl+C"
	Edit>Cut "Ctrl+X"
	Edit>Paste "Ctrl+V"
	Edit>Delete "Del"
        Select>All "Ctrl+A"
        Edit>Select>All "Ctrl+A"
        Edit>SelectAll "Ctrl+A"
      	openDB "Ctrl+O"
        Simulation>Run "F2"
        Simulation>Next "F6"
        Simulation>Step "F5"
        #Schematic window
        View>Zoom>Fit "Alt+="
        View>Zoom>In "Alt+I"
        View>Zoom>Out "Alt+O"
        #Waveform Window
	View>Zoom>InX "Alt+I"
	View>Zoom>OutX "Alt+O"
	View>Zoom>FullX "Alt+="
	View>Zoom>InX_widget "I"
	View>Zoom>OutX_widget "O"
	View>Zoom>FullX_widget "="
	View>Zoom>FullY_widget "Y"
	View>Zoom>Cursor-Baseline "Alt+Z"
	View>Center "Alt+C"
	View>ExpandSequenceTime>AtCursor "Alt+X"
	View>CollapseSequenceTime>AtCursor "Alt+S"
	Edit>Create>Group "Ctrl+G"
	Edit>Ungroup "Ctrl+Shift+G"
	Edit>Create>Marker "Ctrl+M"
	Edit>Create>Condition "Ctrl+E"
	Edit>Create>Bus "Ctrl+W"
	Explore>NextEdge "Ctrl+]"
	Explore>PreviousEdge "Ctrl+["
	ScrollRight "Right arrow"
	ScrollLeft "Left arrow"
	ScrollUp "Up arrow"
	ScrollDown "Down arrow"
	PageUp "PageUp"
	PageDown "PageDown"
	TopOfPage "Home"
	BottomOfPage "End"
}
preferences set marching-waveform {1}
preferences set prompt-exit {1}
preferences set prompt-on-reinvoke {1}
preferences set respond-to-simvision-command {1}
preferences set restore-state-on-startup {0}
preferences set save-state-on-startup {0}
preferences set sb-double-click-command {@goto-definition}
preferences set sb-editor-command {xterm -e vi +%L %F}
preferences set sb-history-size {10}
preferences set sb-radix {default}
preferences set sb-show-strength {1}
preferences set sb-syntax-highlight {1}
preferences set sb-syntax-types {
    {-name "VHDL/VHDL-AMS" -cleanname "vhdl" -extensions {.vhd .vhdl}}
    {-name "Verilog/Verilog-AMS" -cleanname "verilog" -extensions {.v .vams .vms .va}}
    {-name "C" -cleanname "c" -extensions {.c}}
    {-name "C++" -cleanname "c++" -extensions {.h .hpp .cc .cpp .CC}}
    {-name "SystemC" -cleanname "systemc" -extensions {.h .hpp .cc .cpp .CC}}
}
preferences set sb-tab-size {8}
preferences set schematic-show-values {simulator}
preferences set search-toolbar {1}
preferences set seq-time-width {30}
preferences set sfb-colors {
    register #beded1
    variable #beded1
    assignStmt gray85
    force #faa385
}
preferences set sfb-default-tree {0}
preferences set sfb-max-cell-width {40}
preferences set show-database-names {0}
preferences set show-full-signal-names {0}
preferences set show-strength {0}
preferences set show-times-on-cursors {1}
preferences set show-times-on-markers {1}
preferences set signal-type-colors {
	group #0000FF
	overlay #0000FF
	input #FFFF00
	output #FFA500
	inout #00FFFF
	internal #00FF00
	fiber #FF99FF
	errorsignal #FF0000
	assertion #FF0000
	unknown #FFFFFF
}
preferences set snap-to-edge {1}
preferences set toolbars-style {icon}
preferences set transaction-height {3}
preferences set txe-locate-add-fibers {yes}
preferences set txe-locate-create-waveform {sometimes}
preferences set txe-locate-pop-waveform {yes}
preferences set txe-locate-scroll-x {yes}
preferences set txe-locate-scroll-y {yes}
preferences set txe-man-doubleclick-search {edit}
preferences set txe-navigate-search-locate {no}
preferences set txe-navigate-waveform-locate {yes}
preferences set txe-navigate-waveform-next-child {no}
preferences set txe-search-default-form {built_in.basic}
preferences set txe-search-result-limit {200}
preferences set txe-search-reuse-window {never}
preferences set txe-search-show-linenumbers {yes}
preferences set txe-search-style {form}
preferences set txe-view-hold {off}
preferences set use-signal-type-colors {0}
preferences set use-signal-type-icons {1}
preferences set verilog-colors {
	HiZ #ff9900
	StrX #ff0000
	Sm #00ff99
	Me #0000ff
	We #00ffff
	La #ff00ff
	Pu #9900ff
	St ""
	Su #ff0099
	0 ""
	1 ""
	X #ff0000
	Z #ff9900
	other #ffff00
}
preferences set vhdl-colors {
	U #9900ff 
	X #ff0000 
	0 ""
	1 ""
	Z #ff9900 
	W #ff0000
	L #00ffff 
	H #00ffff
	- ""
}
preferences set waveform-banding {1}
preferences set waveform-height {10}
preferences set waveform-space {2}
