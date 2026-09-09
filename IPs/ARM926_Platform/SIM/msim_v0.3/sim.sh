#! /bin/sh
action()
{
  $* || exit 1
}

vsim -c tb -wlf armpf.wlf  -do cmd.do
