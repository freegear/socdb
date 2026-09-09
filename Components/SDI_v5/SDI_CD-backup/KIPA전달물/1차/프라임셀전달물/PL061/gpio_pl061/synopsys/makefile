# Makefile which writes a synthesis script to update the entire netlist.

# Note that because we run make with the -e option, these variables will get overidden
# by env variables.

VERILOG_SOURCE = ../verilog/rtl_source/*.v
VHDL_SOURCE = ../vhdl/rtl_source/*.vhd

clean : 
	@rm -rf log
	@rm -rf report
	@rm -rf db
	@rm -rf work

netlist : log/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_$(HDL_NETL)_synth.log

log/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_$(HDL_NETL)_synth.log : \
                       $(GLOBAL)/synopsys_shared/scr_common/*.scr  \
                       scripts/Gpio.cmd \
                       scripts/Gpio_scan.cmd \
                       scripts/Gpio.scr \
                       $(VERILOG_SOURCE) \
                       $(VHDL_SOURCE)
	@if [ ! -d work ] ; then \
	mkdir work ; fi ;
	@if [ ! -d db ] ; then \
	mkdir db ; fi ;
	@if [ ! -d log ] ; then \
	mkdir log ; fi ;
	@if [ ! -d report ] ; then \
	mkdir report ; fi ;
	$(BATCH_CMD) 'dc_shell < scripts/Gpio.cmd > log/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_$(HDL_NETL)_run.log'

