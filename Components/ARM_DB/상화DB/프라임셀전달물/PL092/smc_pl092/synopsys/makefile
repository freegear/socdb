#- --=========================================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2000-2001 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#- -----------------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name              : makefile.rca
#- File Revision          : 1.10
#-
#- Release Information    : PrimeCell(TM)-PL092-REL1v1
#-
#- -----------------------------------------------------------------------------
#- Purpose :
#-           A makefile to synthesise the SMC
#-           Product Code : PL092
#-
#- --=========================================================================--

# Note that because we run make with the -e option, these variables
# will get overidden by environment variables.

VERILOG_SOURCE = ../verilog/rtl_source/*.v
VHDL_SOURCE = ../vhdl/rtl_source/*.vhd

clean :
	@rm -rf log
	@rm -rf report
	@rm -rf db
	@rm -rf work

cleandb :
	@rm -f db/DBI_$(TEST_METH)_$(HDL_SOURCE).db
	@rm -f db/TIC_$(TEST_METH)_$(HDL_SOURCE).db
	@rm -f db/SmcCore_$(TEST_METH)_$(HDL_SOURCE).db

netlist : \
         cleandb \
         log/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_$(HDL_NETL)_synth.log

log/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_$(HDL_NETL)_synth.log : \
                       db/DBI_$(TEST_METH)_$(HDL_SOURCE).db \
                       db/TIC_$(TEST_METH)_$(HDL_SOURCE).db \
                       db/SmcCore_$(TEST_METH)_$(HDL_SOURCE).db \
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
	dc_shell < scripts/$(PERIPH).cmd > log/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_$(HDL_NETL)_run.log

db/DBI_$(TEST_METH)_$(HDL_SOURCE).db : \
                       $(GLOBAL)/synopsys_shared/scr_common/*.scr  \
                       scripts/DBI.cmd \
                       scripts/DBI.scr \
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
	dc_shell < scripts/DBI.cmd > log/DBI_$(TEST_METH)_$(HDL_SOURCE)_$(HDL_NETL)_run.log

db/TIC_$(TEST_METH)_$(HDL_SOURCE).db : \
                       $(GLOBAL)/synopsys_shared/scr_common/*.scr  \
                       scripts/TIC.cmd \
                       scripts/TIC.scr \
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
	dc_shell < scripts/TIC.cmd > log/TIC_$(TEST_METH)_$(HDL_SOURCE)_$(HDL_NETL)_run.log

db/SmcCore_$(TEST_METH)_$(HDL_SOURCE).db : \
                       $(GLOBAL)/synopsys_shared/scr_common/*.scr  \
                       scripts/SmcCore.cmd \
                       scripts/SmcCore.scr \
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
	dc_shell < scripts/SmcCore.cmd > log/SmcCore_$(TEST_METH)_$(HDL_SOURCE)_$(HDL_NETL)_run.log

#- --================================= End ===================================--
