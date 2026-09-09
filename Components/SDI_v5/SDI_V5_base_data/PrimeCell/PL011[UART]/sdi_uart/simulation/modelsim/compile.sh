#!/bin/sh
action()
{
  $* || exit 1
}
if [ -d ./work ]; then
	rm -fr ./work
fi

vlib work


action vlog  ../../rtl_verilog/Uart.v \
	../../rtl_verilog/UartIrDA.v       \
	../../rtl_verilog/UartRXRegFile.v   \
	../../rtl_verilog/UartTXCntl.v\
	../../rtl_verilog/UartApbif.v      \
	../../rtl_verilog/UartModem.v      \
	../../rtl_verilog/UartReceive.v     \
	../../rtl_verilog/UartTXFCntl.v \
	../../rtl_verilog/UartBaudCntr.v   \
	../../rtl_verilog/UartRXCntl.v     \
	../../rtl_verilog/UartRegBlock.v   \
	../../rtl_verilog/UartTXFIFO.v\
	../../rtl_verilog/UartDMA.v        \
	../../rtl_verilog/UartRXFCntl.v    \
	../../rtl_verilog/UartRevAnd.v     \
	../../rtl_verilog/UartTXRegFile.v  \
	../../rtl_verilog/UartDataStp.v    \
	../../rtl_verilog/UartRXFIFO.v     \
	../../rtl_verilog/UartSynctoPCLK.v \
	../../rtl_verilog/UartTest.v	 \
	../../rtl_verilog/UartInterrupt.v  \
	../../rtl_verilog/UartRXParShft.v  \
	../../rtl_verilog/UartSynctoUCLK.v  



