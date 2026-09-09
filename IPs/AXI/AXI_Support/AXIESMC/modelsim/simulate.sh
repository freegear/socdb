#! /bin/sh

action()
{
  $* || exit 1
}

if [ -e work ]; then
	rm -fr work
fi
vlib work

action vlog ../rtl/SMC_REG.v
action vlog ../rtl/SRAM_CTRL.v
action vlog ../rtl/AXI_ESMC_interface.v
action vlog ../rtl/SMC_TOP.v
action vlog ../testbench/sram8bit.v
action vlog ../testbench/sram16bit.v
action vlog ../testbench/sram32bit.v
action vlog ../testbench/TestMaster.v
action vlog ../testbench/tb.v

vsim -c tb -do "run -all"

