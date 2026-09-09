
#! /bin/sh

action()
{
  $* || exit 1
}

if [ -e work ]; then
    rm -fr work
fi
action vlib work

action vlog ../../Rtl/PermitCtl.v
action vlog ../../Rtl/LockCtlRdmi.v
action vlog ../../Rtl/LockCtlWrmi.v
action vlog ../../Rtl/ReqCnt.v

action vlog ../../Rtl/ReadChannelsi.v
action vlog ../../Rtl/ReadChannelmi.v
action vlog ../../Rtl/WriteChannelsi.v
action vlog ../../Rtl/WriteChannelmi.v
action vlog ../../Rtl/ReqInterBuff.v
action vlog ../../Rtl/TOP_ReadCH/ReadChannel.v
action vlog ../../Rtl/TOP_WriteCH/WriteChannel.v
action vlog ../../Rtl/TOP/SBUS.v

action vlog ../../Bench/TestMaster_bus.v
action vlog ../../Bench/IntSRAMController.v
action vlog ../../Bench/SSRAM32bit.v
action vlog ../../Bench/DefaultSlave.v
action vlog ../../Bench/TestSlaveBuffer.v
action vlog ../../Bench/TestSlave_bus.v
action vlog ../../Bench/tb.v

vsim -c tb -do "run -all"
