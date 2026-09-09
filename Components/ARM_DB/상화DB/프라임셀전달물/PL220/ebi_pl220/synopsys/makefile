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
#- File Revision          : 1.3
#-
#- Release Information    : PrimeCell(TM)-PL220-r0p0-00ltd0
#-
#- -----------------------------------------------------------------------------
#- Purpose :
#-           A makefile to synthesise the EBI
#-           Product Code : ebi
#-
#- --=========================================================================--

# Note that because we run make with the -e option, these variables
# will get overidden by environment variables.

clean :
	@rm -rf log
	@rm -rf report
	@rm -rf db
	@rm -rf work

netlist :
	@if [ ! -d work ] ; then \
	mkdir work ; fi ;
	@if [ ! -d db ] ; then \
	mkdir db ; fi ;
	@if [ ! -d log ] ; then \
	mkdir log ; fi ;
	@if [ ! -d report ] ; then \
	mkdir report ; fi ;
	dc_shell < scripts/$(PERIPH).cmd > log/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_$(HDL_NETL)_run.log

#- --================================= End ===================================--
