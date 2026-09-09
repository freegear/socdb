#! /bin/sh
action()
{
  $* || exit 1
}

if [ -e work ]; then
	rm -fr work
fi
vlib work

# DMA Controller Design
action vlog +incdir+../rtl_Fifo4 ../rtl_Fifo4/Dma2DCtrl.v
action vlog +incdir+../rtl_Fifo4 ../rtl_Fifo4/Dma2DFifo.v
action vlog +incdir+../rtl_Fifo4 ../rtl_Fifo4/Dma2DReg.v
action vlog +incdir+../rtl_Fifo4 ../rtl_Fifo4/Dma2D.v

# Test Bench Compile

# AXI BUS
action vlog +incdir+../testbench/BUS_AdvRs/Rtl/Def ../testbench/BUS_AdvRs/Rtl/LockCtlRdmi.v
action vlog +incdir+../testbench/BUS_AdvRs/Rtl/Def ../testbench/BUS_AdvRs/Rtl/ReadChannelmi.v
action vlog +incdir+../testbench/BUS_AdvRs/Rtl/Def ../testbench/BUS_AdvRs/Rtl/ReqInterBuff.v
action vlog +incdir+../testbench/BUS_AdvRs/Rtl/Def ../testbench/BUS_AdvRs/Rtl/WriteChannelsi.v
action vlog +incdir+../testbench/BUS_AdvRs/Rtl/Def ../testbench/BUS_AdvRs/Rtl/LockCtlWrmi.v
action vlog +incdir+../testbench/BUS_AdvRs/Rtl/Def ../testbench/BUS_AdvRs/Rtl/ReadChannelsi_RS.v
action vlog +incdir+../testbench/BUS_AdvRs/Rtl/Def ../testbench/BUS_AdvRs/Rtl/WriteChannelmi_RS.v
action vlog +incdir+../testbench/BUS_AdvRs/Rtl/Def ../testbench/BUS_AdvRs/Rtl/PermitCtl.v
action vlog +incdir+../testbench/BUS_AdvRs/Rtl/Def ../testbench/BUS_AdvRs/Rtl/ReadChannelsi.v
action vlog +incdir+../testbench/BUS_AdvRs/Rtl/Def ../testbench/BUS_AdvRs/Rtl/WriteChannelmi.v
action vlog +incdir+../testbench/BUS_AdvRs/Rtl/Def ../testbench/BUS_AdvRs/Rtl/ReadChannelmi_RS.v
action vlog +incdir+../testbench/BUS_AdvRs/Rtl/Def ../testbench/BUS_AdvRs/Rtl/ReqCnt.v
action vlog +incdir+../testbench/BUS_AdvRs/Rtl/Def ../testbench/BUS_AdvRs/Rtl/WriteChannelsi_RS.v
action vlog +incdir+../testbench/BUS_AdvRs/Rtl/Def ../testbench/BUS_AdvRs/Rtl/RegisterSlice/AR_fully_registered.v
action vlog +incdir+../testbench/BUS_AdvRs/Rtl/Def ../testbench/BUS_AdvRs/Rtl/RegisterSlice/RD_fully_registered.v
action vlog +incdir+../testbench/BUS_AdvRs/Rtl/Def ../testbench/BUS_AdvRs/Rtl/RegisterSlice/WR_fully_registered.v
action vlog +incdir+../testbench/BUS_AdvRs/Rtl/Def ../testbench/BUS_AdvRs/Rtl/RegisterSlice/ARmi_fully_registered.v
action vlog +incdir+../testbench/BUS_AdvRs/Rtl/Def ../testbench/BUS_AdvRs/Rtl/RegisterSlice/RDmi_fully_registered.v
action vlog +incdir+../testbench/BUS_AdvRs/Rtl/Def ../testbench/BUS_AdvRs/Rtl/RegisterSlice/WRmi_fully_registered.v
action vlog +incdir+../testbench/BUS_AdvRs/Rtl/Def ../testbench/BUS_AdvRs/Rtl/RegisterSlice/AW_fully_registered.v
action vlog +incdir+../testbench/BUS_AdvRs/Rtl/Def ../testbench/BUS_AdvRs/Rtl/RegisterSlice/WD_fully_registered.v
action vlog +incdir+../testbench/BUS_AdvRs/Rtl/Def ../testbench/BUS_AdvRs/Rtl/RegisterSlice/AWmi_fully_registered.v
action vlog +incdir+../testbench/BUS_AdvRs/Rtl/Def ../testbench/BUS_AdvRs/Rtl/RegisterSlice/WDmi_fully_registered.v
action vlog +incdir+../testbench/BUS_AdvRs/Rtl/Def ../testbench/BUS_AdvRs/Rtl/TOP_ReadCH/ReadChannel.v
action vlog +incdir+../testbench/BUS_AdvRs/Rtl/Def ../testbench/BUS_AdvRs/Rtl/TOP_WriteCH/WriteChannel.v
action vlog +incdir+../testbench/BUS_AdvRs/Rtl/Def ../testbench/BUS_AdvRs/Rtl/TOP/SBUS.v

# top integrated parts
action vlog ../testbench/DefaultSlave.v
action vlog ../testbench/AXI2APBBridge_PREADY.v
action vlog ../testbench/IntSRAMController.v
action vlog ../testbench/SSRAM32bit.v
action vlog ../testbench/TestMaster.v
action vlog +incdir+../testbench/BUS_AdvRs/Rtl/Def ../testbench/tb.v

#vsim -c tb -do "run -all"

