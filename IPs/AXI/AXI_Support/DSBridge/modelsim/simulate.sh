#! /bin/sh

action()
{
  $* || exit 1
}

if [ -e work ]; then
	rm -fr work
fi
vlib work
action vlog ../rtl/F2SSlice_Simple.v
action vlog ../testbench/tb_F2SSlice_Simple.v
action vlog ../rtl/F2SSlice_Advanced.v
action vlog ../testbench/tb_F2SSlice_Advanced.v
action vlog ../rtl/S2FSlice.v
action vlog ../testbench/tb_S2FSlice.v

vsim -c tb_F2SSlice_Simple -do "run -all"
vsim -c tb_F2SSlice_Advanced -do "run -all"
vsim -c tb_S2FSlice -do "run -all"

