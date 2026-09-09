#- --=========================================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2002 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#- -----------------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name              : makefile.rca
#- File Revision          : 1.7
#-
#- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
#-
#- -----------------------------------------------------------------------------
#- Purpose :
#-           A makefile to synthesise the VIC 
#-           Product Code : PL192
#- --=========================================================================--

# Note that because we run make with the -e option, these variables 
# will get overridden by environment variables.

VERILOG_SOURCE = ../verilog/rtl_source/*.v
VHDL_SOURCE = ../vhdl/rtl_source/*.vhd

clean : 
	@rm -rf log/Vic*.log
	@rm -rf report/Vic*
	@rm -rf db/Vic*
	@rm -rf work/*

netlist : log/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_$(HDL_NETL)_synth.log

log/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_$(HDL_NETL)_synth.log : \
                       $(GLOBAL)/synopsys_shared/scr_common/*.scr  \
                       scripts/$(PERIPH).cmd \
                       scripts/$(PERIPH)_scan.cmd \
                       scripts/$(PERIPH).scr \
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
	$(BATCH_CMD) dc_shell < scripts/$(PERIPH).cmd > log/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_$(HDL_NETL)_run.log

#################################### End #######################################
