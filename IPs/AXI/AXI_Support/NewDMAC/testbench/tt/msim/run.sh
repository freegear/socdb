#! /bin/sh

action()
{
  $* || exit 1
}

if [ -e work ]; then
    rm -fr work
fi
action vlib work

action vlog ../rtl/BUS/ReadChannel/s0_ReqCnt.v
action vlog ../rtl/BUS/ReadChannel/s1_ReqCnt.v
action vlog ../rtl/BUS/ReadChannel/s2_ReqCnt.v
action vlog ../rtl/BUS/ReadChannel/s3_ReqCnt.v
action vlog ../rtl/BUS/ReadChannel/s4_ReqCnt.v
action vlog ../rtl/BUS/ReadChannel/default_ReqCnt.v
action vlog ../rtl/BUS/ReadChannel/s0_LockCtlRdmi.v
action vlog ../rtl/BUS/ReadChannel/s1_LockCtlRdmi.v
action vlog ../rtl/BUS/ReadChannel/s2_LockCtlRdmi.v
action vlog ../rtl/BUS/ReadChannel/s3_LockCtlRdmi.v
action vlog ../rtl/BUS/ReadChannel/s4_LockCtlRdmi.v
action vlog ../rtl/BUS/ReadChannel/default_LockCtlRdmi.v
action vlog ../rtl/BUS/ReadChannel/s0_ReadChannelmi.v
action vlog ../rtl/BUS/ReadChannel/s1_ReadChannelmi.v
action vlog ../rtl/BUS/ReadChannel/s2_ReadChannelmi.v
action vlog ../rtl/BUS/ReadChannel/s3_ReadChannelmi.v
action vlog ../rtl/BUS/ReadChannel/s4_ReadChannelmi.v
action vlog ../rtl/BUS/ReadChannel/default_ReadChannelmi.v
action vlog ../rtl/BUS/ReadChannel/m0_ReadChannelsi.v
action vlog ../rtl/BUS/ReadChannel/RDCH_m0_PermitCtl.v
action vlog ../rtl/BUS/ReadChannel/m1_ReadChannelsi.v
action vlog ../rtl/BUS/ReadChannel/RDCH_m1_PermitCtl.v
action vlog ../rtl/BUS/ReadChannel/m2_ReadChannelsi.v
action vlog ../rtl/BUS/ReadChannel/RDCH_m2_PermitCtl.v
action vlog ../rtl/BUS/ReadChannel/m3_ReadChannelsi.v
action vlog ../rtl/BUS/ReadChannel/RDCH_m3_PermitCtl.v
action vlog ../rtl/BUS/ReadChannel/TOP/ReadChannel.v
action vlog ../rtl/BUS/WriteChannel/s0_ReqInter.v
action vlog ../rtl/BUS/WriteChannel/s1_ReqInter.v
action vlog ../rtl/BUS/WriteChannel/s2_ReqInter.v
action vlog ../rtl/BUS/WriteChannel/s3_ReqInter.v
action vlog ../rtl/BUS/WriteChannel/s4_ReqInter.v
action vlog ../rtl/BUS/WriteChannel/default_ReqInter.v
action vlog ../rtl/BUS/WriteChannel/s0_LockCtlWrmi.v
action vlog ../rtl/BUS/WriteChannel/s1_LockCtlWrmi.v
action vlog ../rtl/BUS/WriteChannel/s2_LockCtlWrmi.v
action vlog ../rtl/BUS/WriteChannel/s3_LockCtlWrmi.v
action vlog ../rtl/BUS/WriteChannel/s4_LockCtlWrmi.v
action vlog ../rtl/BUS/WriteChannel/default_LockCtlWrmi.v
action vlog ../rtl/BUS/WriteChannel/s0_WriteChannelmi.v
action vlog ../rtl/BUS/WriteChannel/s1_WriteChannelmi.v
action vlog ../rtl/BUS/WriteChannel/s2_WriteChannelmi.v
action vlog ../rtl/BUS/WriteChannel/s3_WriteChannelmi.v
action vlog ../rtl/BUS/WriteChannel/s4_WriteChannelmi.v
action vlog ../rtl/BUS/WriteChannel/default_WriteChannelmi.v
action vlog ../rtl/BUS/WriteChannel/m0_WriteChannelsi.v
action vlog ../rtl/BUS/WriteChannel/WRCH_m0_PermitCtl.v
action vlog ../rtl/BUS/WriteChannel/m1_WriteChannelsi.v
action vlog ../rtl/BUS/WriteChannel/WRCH_m1_PermitCtl.v
action vlog ../rtl/BUS/WriteChannel/m2_WriteChannelsi.v
action vlog ../rtl/BUS/WriteChannel/WRCH_m2_PermitCtl.v
action vlog ../rtl/BUS/WriteChannel/m3_WriteChannelsi.v
action vlog ../rtl/BUS/WriteChannel/WRCH_m3_PermitCtl.v
action vlog ../rtl/BUS/WriteChannel/TOP/WriteChannel.v
action vlog ../rtl/BUS/WriteChannel/m0_RS_WriteChannelsi.v
action vlog ../rtl/BUS/ReadChannel/m0_RS_ReadChannelsi.v
action vlog ../rtl/BUS/WriteChannel/m1_RS_WriteChannelsi.v
action vlog ../rtl/BUS/ReadChannel/m1_RS_ReadChannelsi.v
action vlog ../rtl/BUS/WriteChannel/m2_RS_WriteChannelsi.v
action vlog ../rtl/BUS/ReadChannel/m2_RS_ReadChannelsi.v
action vlog ../rtl/BUS/WriteChannel/m3_RS_WriteChannelsi.v
action vlog ../rtl/BUS/ReadChannel/m3_RS_ReadChannelsi.v
action vlog ../rtl/BUS/WriteChannel/s0_RS_WriteChannelmi.v
action vlog ../rtl/BUS/ReadChannel/s0_RS_ReadChannelmi.v
action vlog ../rtl/BUS/WriteChannel/s1_RS_WriteChannelmi.v
action vlog ../rtl/BUS/ReadChannel/s1_RS_ReadChannelmi.v
action vlog ../rtl/BUS/WriteChannel/s2_RS_WriteChannelmi.v
action vlog ../rtl/BUS/ReadChannel/s2_RS_ReadChannelmi.v
action vlog ../rtl/BUS/WriteChannel/s3_RS_WriteChannelmi.v
action vlog ../rtl/BUS/ReadChannel/s3_RS_ReadChannelmi.v
action vlog ../rtl/BUS/WriteChannel/s4_RS_WriteChannelmi.v
action vlog ../rtl/BUS/ReadChannel/s4_RS_ReadChannelmi.v
action vlog ../rtl/BUS/WriteChannel/default_RS_WriteChannelmi.v
action vlog ../rtl/BUS/ReadChannel/default_RS_ReadChannelmi.v
action vlog ../rtl/BUS/TOP/SBUS.v
action vlog ../bench/tb.v
action vlog ../bench/m0_TestMaster_bus.v
action vlog ../bench/m1_TestMaster_bus.v
action vlog ../bench/m2_TestMaster_bus.v
action vlog ../bench/m3_TestMaster_bus.v
action vlog ../bench/DefaultSlave.v
action vlog ../bench/SSRAM32bit.v
action vlog ../bench/IntSRAMController.v
vsim -c tb -do "run -all"
