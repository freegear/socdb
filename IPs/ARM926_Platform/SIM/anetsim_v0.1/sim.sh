#! /bin/sh
action()
{
  $* || exit 1
}

vsim -c tb -wlf net_armpf.wlf  -do cmd.do
