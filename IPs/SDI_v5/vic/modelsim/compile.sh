#!/bin/sh
action()
{
  $* || exit 1
}
if [ -d ./work ]; then
	rm -fr ./work
fi

vlib work

action vlog ../rtl/APB_vic.v
action vlog ../rtl/vic_slave_arbiter.v
action vlog ../rtl/vic_master_arbiter.v
action vlog ../testbench/tb_vic.v
