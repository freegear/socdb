#! /bin/sh
action()
{
  $* || exit 1
}

vlib work


#action vlog +incdir+$RTL_PATH/Top TbCT500.v
action vlog ../Syn/Net/Ssp.noscan.v
action vlog tsmc13.v
action vlog TbSsp.sdf.v
action vlog s25fl008a.v

vsim -sdfmax /TbSsp/Ssp=Ssp.noscan.sdf TbSsp

#vsim -c tb -do "run -all"

