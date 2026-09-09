#! /bin/sh
if [ -e work ]; then
	rm -fr work
fi
vlib work
vlog ../rtl/fully_registered.v
vlog ../testbench/tb_fully_registered.v
vlog ../rtl/registered_forward.v
vlog ../testbench/tb_registered_forward.v

vsim -c tb_fully_registered -do "run -all"
vsim -c tb_registered_forward -do "run -all"

