#! /bin/sh
action()
{
  $* || exit 1
}

if [ -e work ]; then
	rm -fr work
fi
vlib work

RTL_PATH=../rtl
MOD_PATH=../mod
TEST_PATH=../testbench


#action vlog $RTL_PATH/pmcon_APBregIF.v
#action vlog $RTL_PATH/pmcon_APBmemIF.v
action vlog $RTL_PATH/pmcon_STM.v
action vlog $RTL_PATH/pmcon_MEMIF.v
action vlog $RTL_PATH/pmcon_REGIF.v
action vlog $RTL_PATH/pmcon_APBIF.v
action vlog $RTL_PATH/pmcon_AXIIF.v
action vlog $RTL_PATH/pmcon_AXITop.v
action vlog $MOD_PATH/psram32m.v

action vlog $TEST_PATH/TestMaster.v
action vlog $TEST_PATH/tb_AXIPSRAM.v
