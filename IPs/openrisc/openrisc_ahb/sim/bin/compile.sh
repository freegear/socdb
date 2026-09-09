#! /bin/sh
action()
{
  $* || exit 1
}

if [ -e work ]; then
	rm -fr work
fi
vlib work

RTL_PATH=../../rtl

# AHB BUS
action vlog $RTL_PATH/ahb/ArbSchm3.v
action vlog $RTL_PATH/ahb/Arbiter3.v
action vlog $RTL_PATH/ahb/Decoder.v
action vlog $RTL_PATH/ahb/MuxM2S.v
action vlog $RTL_PATH/ahb/MuxS2M.v
action vlog $RTL_PATH/ahb/DefaultSlave.v
action vlog $RTL_PATH/ahb/AHB.v

# openRISC
. ../bin/compile_or1200.sh

# others
action vlog $RTL_PATH/ismc/ismc_ahb_random.v
#action vlog $RTL_PATH/ismc/ismc_ahb.v
action vlog $RTL_PATH/ram_model/ram512Kx32.v
action vlog $RTL_PATH/top/system_top.v
action vlog ../../testbench/tb.v
action vlog +incdir+../../rtl/or1200 ../../testbench/or1200_monitor.v

