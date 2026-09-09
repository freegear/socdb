#! /bin/sh
action()
{
  $* || exit 1
}

if [ -e work ]; then
	rm -fr work
fi
vlib work
action vlog ../rtl/Convert64to32.v
action vlog ../testbench/IntSRAMController.v
action vlog ../testbench/TestMaster64.v
action vlog ../testbench/tb.v
action vlog ../testbench/SSRAM32bit.v

vsim -c tb -do "run -all"

