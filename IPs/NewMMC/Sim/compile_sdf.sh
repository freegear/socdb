#! /bin/sh
action()
{
  $* || exit 1
}

vlib work


#action vlog +incdir+$RTL_PATH/Top TbCT500.v
action vlog ../Syn/Net/MMCTop.noscan.v
action vlog RF2SH32x32.v
action vlog tsmc13.v
action vlog TbMMCTop.sdf.v

vsim -sdfmax /TbMMCTop/MMC=../Syn/Sdf/MMCTop.noscan.sdf TbMMCTop

#vsim -c tb -do "run -all"

