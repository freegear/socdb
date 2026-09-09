#! /bin/sh
action()
{
  $* || exit 1
}

vsim -c ARM926EJS_ram_testbench -wlf armpf.wlf  -do cmd.do
