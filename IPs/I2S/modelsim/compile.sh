#! /bin/sh
action()
{
  $* || exit 1
}

if [ -e work ]; then
	rm -fr work
fi
vlib work
action vlog ../rtl/I2S_Control.v
action vlog ../rtl/I2S_DTO.v
action vlog ../rtl/I2S_ClockMgr.v
action vlog ../rtl/I2S_Serializer.v
action vlog ../rtl/I2S_Deserializer.v
action vlog ../rtl/I2S_FIFO.v
action vlog ../rtl/I2S_FIFO_RAM.v
action vlog ../model/RF2SH32x32.v
action vlog ../rtl/I2S_Top.v

action vlog ../testbench/I2S_tbtop.v
action vlog ../testbench/I2S_DAC.v
action vlog ../testbench/I2S_ADC.v
action vlog ../testbench/tb.v

#vsim -c tb -do "run -all"

