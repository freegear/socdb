#! /bin/sh
if [ -e work ]; then
	rm -fr work
fi
vlib work
vlog ../rtl/IntSRAMController.v
vlog ../testbench/tb_IntSRAMController.v
vlog ../testbench/SSRAM32bit.v

vsim -c tb_IntSRAMController -do "run 1 us"

