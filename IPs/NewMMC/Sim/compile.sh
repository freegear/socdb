#! /bin/sh
action()
{
  $* || exit 1
}

if [ -e work ]; then
	rm -fr work
fi
vlib work

action cp -rp ../MMC/* work

#action vlog +incdir+$RTL_PATH/Top TbCT500.v
action vlog tsmc13.v
action vlog ../Rtl/MMCTop.v
action vlog ../Rtl/mmc_APBRegisterIF.v
action vlog ../Rtl/mmc_CommandControl.v
action vlog ../Rtl/mmc_DataControl.v
action vlog ../Rtl/mmc_FeedBackSync.v
action vlog ../Rtl/mmc_Fifo.v
action vlog ../Rtl/mmc_FifoDmaCtr.v
action vlog ../Rtl/mmc_PSave.v
action vlog ../Rtl/mmc_Prescaler.v

action vlog RF2SH32x32_Func.v

action vlog TbMMCTop.v


#vsim -c tb -do "run -all"

