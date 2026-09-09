#! /bin/sh

action()
{
  $* || exit 1
}

if [ -e work ]; then
	rm -fr work
fi
vlib work
# Simple APB interface
#action vlog ../rtl/AXI2APBBridge_Simple.v
#action vlog ../testbench/APB_SRAM.v
#action vlog ../testbench/TestMaster.v
#action vlog ../testbench/tb_simple.v

# PREADY APB interface
#action vlog ../rtl/AXI2APBBridge_PREADY.v
#action vlog ../testbench/APB_SRAM_PREADY.v
#action vlog ../testbench/TestMaster.v
#action vlog ../testbench/tb_pready.v

# Full APB interface
action vlog ../rtl/AXI2APBBridge.v
action vlog ../testbench/APB_SRAM_PREADY.v
action vlog ../testbench/TestMaster.v
action vlog ../testbench/tb_full.v

vsim -c tb -do "run -all"

