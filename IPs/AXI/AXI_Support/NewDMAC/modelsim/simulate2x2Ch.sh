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
action vlog +incdir+../rtl ../rtl/DmacControl.v
action vlog +incdir+../rtl ../rtl/DmacFifo.v
action vlog +incdir+../rtl ../rtl/DmacEngine.v
action vlog +incdir+../rtl ../rtl/DmacChReg.v
action vlog +incdir+../rtl ../rtl/DmacRegFile2Ch.v
action vlog +incdir+../rtl ../rtl/DmacReqAck2Ch.v
action vlog +incdir+../rtl ../rtl/Dmac2Ch.v
action vlog +incdir+../rtl ../rtl/DmacAPBMux.v
action vlog +incdir+../rtl ../rtl/DmacAXIArbiter.v
action vlog +incdir+../rtl ../rtl/Dmac2x2Ch.v

# Test Bench Compile

# AXI BUS
action vlog ../testbench/BUS/ReadChannel/s0_ReqCnt.v
action vlog ../testbench/BUS/ReadChannel/s1_ReqCnt.v
action vlog ../testbench/BUS/ReadChannel/s2_ReqCnt.v
action vlog ../testbench/BUS/ReadChannel/s3_ReqCnt.v
action vlog ../testbench/BUS/ReadChannel/s4_ReqCnt.v
action vlog ../testbench/BUS/ReadChannel/default_ReqCnt.v
action vlog ../testbench/BUS/ReadChannel/s0_LockCtlRdmi.v
action vlog ../testbench/BUS/ReadChannel/s1_LockCtlRdmi.v
action vlog ../testbench/BUS/ReadChannel/s2_LockCtlRdmi.v
action vlog ../testbench/BUS/ReadChannel/s3_LockCtlRdmi.v
action vlog ../testbench/BUS/ReadChannel/s4_LockCtlRdmi.v
action vlog ../testbench/BUS/ReadChannel/default_LockCtlRdmi.v
action vlog ../testbench/BUS/ReadChannel/s0_ReadChannelmi.v
action vlog ../testbench/BUS/ReadChannel/s1_ReadChannelmi.v
action vlog ../testbench/BUS/ReadChannel/s2_ReadChannelmi.v
action vlog ../testbench/BUS/ReadChannel/s3_ReadChannelmi.v
action vlog ../testbench/BUS/ReadChannel/s4_ReadChannelmi.v
action vlog ../testbench/BUS/ReadChannel/default_ReadChannelmi.v
action vlog ../testbench/BUS/ReadChannel/m0_ReadChannelsi.v
action vlog ../testbench/BUS/ReadChannel/RDCH_m0_PermitCtl.v
action vlog ../testbench/BUS/ReadChannel/m1_ReadChannelsi.v
action vlog ../testbench/BUS/ReadChannel/RDCH_m1_PermitCtl.v
action vlog ../testbench/BUS/ReadChannel/m2_ReadChannelsi.v
action vlog ../testbench/BUS/ReadChannel/RDCH_m2_PermitCtl.v
action vlog ../testbench/BUS/ReadChannel/m3_ReadChannelsi.v
action vlog ../testbench/BUS/ReadChannel/RDCH_m3_PermitCtl.v
action vlog ../testbench/BUS/ReadChannel/TOP/ReadChannel.v
action vlog ../testbench/BUS/WriteChannel/s0_ReqInter.v
action vlog ../testbench/BUS/WriteChannel/s1_ReqInter.v
action vlog ../testbench/BUS/WriteChannel/s2_ReqInter.v
action vlog ../testbench/BUS/WriteChannel/s3_ReqInter.v
action vlog ../testbench/BUS/WriteChannel/s4_ReqInter.v
action vlog ../testbench/BUS/WriteChannel/default_ReqInter.v
action vlog ../testbench/BUS/WriteChannel/s0_LockCtlWrmi.v
action vlog ../testbench/BUS/WriteChannel/s1_LockCtlWrmi.v
action vlog ../testbench/BUS/WriteChannel/s2_LockCtlWrmi.v
action vlog ../testbench/BUS/WriteChannel/s3_LockCtlWrmi.v
action vlog ../testbench/BUS/WriteChannel/s4_LockCtlWrmi.v
action vlog ../testbench/BUS/WriteChannel/default_LockCtlWrmi.v
action vlog ../testbench/BUS/WriteChannel/s0_WriteChannelmi.v
action vlog ../testbench/BUS/WriteChannel/s1_WriteChannelmi.v
action vlog ../testbench/BUS/WriteChannel/s2_WriteChannelmi.v
action vlog ../testbench/BUS/WriteChannel/s3_WriteChannelmi.v
action vlog ../testbench/BUS/WriteChannel/s4_WriteChannelmi.v
action vlog ../testbench/BUS/WriteChannel/default_WriteChannelmi.v
action vlog ../testbench/BUS/WriteChannel/m0_WriteChannelsi.v
action vlog ../testbench/BUS/WriteChannel/WRCH_m0_PermitCtl.v
action vlog ../testbench/BUS/WriteChannel/m1_WriteChannelsi.v
action vlog ../testbench/BUS/WriteChannel/WRCH_m1_PermitCtl.v
action vlog ../testbench/BUS/WriteChannel/m2_WriteChannelsi.v
action vlog ../testbench/BUS/WriteChannel/WRCH_m2_PermitCtl.v
action vlog ../testbench/BUS/WriteChannel/m3_WriteChannelsi.v
action vlog ../testbench/BUS/WriteChannel/WRCH_m3_PermitCtl.v
action vlog ../testbench/BUS/WriteChannel/TOP/WriteChannel.v
action vlog ../testbench/BUS/WriteChannel/m0_RS_WriteChannelsi.v
action vlog ../testbench/BUS/ReadChannel/m0_RS_ReadChannelsi.v
action vlog ../testbench/BUS/WriteChannel/m1_RS_WriteChannelsi.v
action vlog ../testbench/BUS/ReadChannel/m1_RS_ReadChannelsi.v
action vlog ../testbench/BUS/WriteChannel/m2_RS_WriteChannelsi.v
action vlog ../testbench/BUS/ReadChannel/m2_RS_ReadChannelsi.v
action vlog ../testbench/BUS/WriteChannel/m3_RS_WriteChannelsi.v
action vlog ../testbench/BUS/ReadChannel/m3_RS_ReadChannelsi.v
action vlog ../testbench/BUS/WriteChannel/s0_RS_WriteChannelmi.v
action vlog ../testbench/BUS/ReadChannel/s0_RS_ReadChannelmi.v
action vlog ../testbench/BUS/WriteChannel/s1_RS_WriteChannelmi.v
action vlog ../testbench/BUS/ReadChannel/s1_RS_ReadChannelmi.v
action vlog ../testbench/BUS/WriteChannel/s2_RS_WriteChannelmi.v
action vlog ../testbench/BUS/ReadChannel/s2_RS_ReadChannelmi.v
action vlog ../testbench/BUS/WriteChannel/s3_RS_WriteChannelmi.v
action vlog ../testbench/BUS/ReadChannel/s3_RS_ReadChannelmi.v
action vlog ../testbench/BUS/WriteChannel/s4_RS_WriteChannelmi.v
action vlog ../testbench/BUS/ReadChannel/s4_RS_ReadChannelmi.v
action vlog ../testbench/BUS/WriteChannel/default_RS_WriteChannelmi.v
action vlog ../testbench/BUS/ReadChannel/default_RS_ReadChannelmi.v
action vlog ../testbench/BUS/TOP/SBUS.v

# top integrated parts
action vlog ../testbench/DefaultSlave.v
action vlog ../testbench/AXI2APBBridge_PREADY.v
action vlog ../testbench/DMAPeri.v
action vlog ../testbench/IntSRAMController.v
action vlog ../testbench/SSRAM32bit.v
action vlog ../testbench/TestMaster2x2Ch.v
action vlog ../testbench/tb2x2Ch.v

#vsim -c tb -do "run -all"

