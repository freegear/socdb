#! /bin/sh

action()
{
  $* || exit 1
}

if [ -e work ]; then
	rm -fr work
fi
vlib work
action vlog ../rtl/AHB2AXIBridge.v
action vlog ../testbench/SSRAM32bit.v
action vlog ../testbench/IntSRAMController.v
action vlog ../testbench/AHBTestMaster.v
action vlog ../testbench/tb.v

vsim -c tb -do "run -all"

