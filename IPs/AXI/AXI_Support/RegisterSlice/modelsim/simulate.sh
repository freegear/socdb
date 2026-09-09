#! /bin/sh

action()
{
  $* || exit 1
}

if [ -e work ]; then
	rm -fr work
fi
vlib work
action vlog ../rtl/fully_registered.v
action vlog ../testbench/tb_fully_registered.v
action vlog ../rtl/registered_forward.v
action vlog ../testbench/tb_registered_forward.v

vsim -c tb_fully_registered -do "run -all"
vsim -c tb_registered_forward -do "run -all"

