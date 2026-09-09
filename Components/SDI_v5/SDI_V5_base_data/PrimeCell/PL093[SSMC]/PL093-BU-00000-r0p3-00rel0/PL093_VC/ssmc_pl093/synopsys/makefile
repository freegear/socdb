#- --=========================================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2003 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#- -----------------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name              : makefile.rca
#- File Revision          : 1.9
#-
#- Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
#-
#- -----------------------------------------------------------------------------
#- Purpose :
#-           A makefile to synthesise the Ssmc 
#-           Product Code : PL093
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
	@if [ $$TEST_METH = scaninsert ] ; then \
          dc_shell < scripts/$(PERIPH).cmd > log/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_$(HDL_NETL)_run.log; \
        fi ;

	@if [ $$TEST_METH = noscan ] ; then \
          dc_shell < scripts/$(PERIPH).cmd > log/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_$(HDL_NETL)_run.log; \
        fi ;

#################################### End #######################################
