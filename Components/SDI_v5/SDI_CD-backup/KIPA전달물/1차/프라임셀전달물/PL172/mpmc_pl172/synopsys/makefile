#- --=========================================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2001-2002 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#- -----------------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name              : makefile.rca
#- File Revision          : 1.5
#-
#- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
#-
#- -----------------------------------------------------------------------------
#- Purpose : 
#-           A makefile to synthesise the MPMC 
#-           Product Code : PL172
#- --=========================================================================--

#- ===========================================================================--
#- Environment variables and their options
#- ===========================================================================--
#-   GLOBAL
#-   ------
#-   The path to the shared files are defined by the 'GLOBAL' variable.
#-   eg : setenv GLOBAL /h/arm/global
#- 
#-   PERIPH
#-   ------
#-   The peripheral name is defined by the 'PERIPH' variable.
#-   eg : setenv PERIPH Mpmc
#- 
#-   SIMULATOR
#-   ---------
#-   The simulator type is defined by the 'SIMULATOR' variable.
#-   It can take the following two values
#-      - modelsim - for ModelSim simulations
#-      - LDV      - for LDV simulations
#- 
#-   eg : setenv SIMULATOR modelsim
#-        setenv SIMULATOR LDV
#- 
#-   TEST_METH
#-   ---------
#-   The scan methodolgoy adopted during synthesis is defined by
#-   the 'TEST_METH' variable.
#-   It can take the following three values
#-      - noscan     - creates a netlist without scan structures.
#-      - scanready  - creates a netlist with scan F/Fs but without scan routing
#-      - scaninsert - creates a fully routed scan netlist.
#- 
#-   eg : setenv TEST_METH noscan
#-        setenv TEST_METH scanready
#-        setenv TEST_METH scaninsert
#- 
#-   HDL_SOURCE
#-   ----------
#-   The source code type is defined by the 'HDL_SOURCE' variable.
#-   It can take the following two values
#-       - vhdl      [VHDL RTL]
#-       - verilog   [Verilog RTL]
#- 
#-   eg : setenv HDL_SOURCE vhdl
#-        setenv HDL_SOURCE verilog
#- 
#-   HDL_NETL
#-   --------
#-   The netlist type is defined by the 'HDL_NETL' variable.
#-   It can take the following two values
#-       - vhdl      [VHDL netlist]
#-       - verilog   [Verilog netlist]
#- 
#-   eg : setenv HDL_NETL vhdl
#-        setenv HDL_NETL verilog
#- ===========================================================================--

# Note that because we run make with the -e option, these variables 
# will get overidden by environment variables.

# Path for RTL files
VERILOG_SOURCE = ../verilog/rtl_source/*.v
VHDL_SOURCE = ../vhdl/rtl_source/*.vhd

# Use clean option to remove the old synthesis log, report, db and work files
clean : 
	@rm -rf log
	@rm -rf report
	@rm -rf db
	@rm -rf work

# Indicate the file where the synthesis log file is to be stored based on
# the environment variables
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

# For a scaninserted synthesis of the Mpmc, the Core and TIC modules are
# synthesised using scanready option (TEST_METH = scanready).
# Then the Top level module is synthesised in the scaninserted mode
# (TEST_METH = scaninsert). This is done since only the Top level module
# has the scan related ports.
	@if [ $$TEST_METH = scaninsert ] ; then \
	  TEST_METH=scanready dc_shell < scripts/$(PERIPH)TIC.cmd > log/$(PERIPH)TIC_scanready_$(HDL_SOURCE)_$(HDL_NETL)_run.log ; \
	  TEST_METH=scanready dc_shell < scripts/$(PERIPH)Core.cmd > log/$(PERIPH)Core_scanready_$(HDL_SOURCE)_$(HDL_NETL)_run.log ; \
	fi

# For a scanready or noscan synthesis run, the Core, TIC and the Top level
# module are synthesised using the same option for the variable TEST_METH
	@if [ $$TEST_METH != scaninsert ] ; then \
	  dc_shell < scripts/$(PERIPH)TIC.cmd > log/$(PERIPH)TIC_$(TEST_METH)_$(HDL_SOURCE)_$(HDL_NETL)_run.log ; \
	  dc_shell < scripts/$(PERIPH)Core.cmd > log/$(PERIPH)Core_$(TEST_METH)_$(HDL_SOURCE)_$(HDL_NETL)_run.log ; \
	fi
	dc_shell < scripts/$(PERIPH).cmd > log/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_$(HDL_NETL)_run.log

#################################### End #######################################
