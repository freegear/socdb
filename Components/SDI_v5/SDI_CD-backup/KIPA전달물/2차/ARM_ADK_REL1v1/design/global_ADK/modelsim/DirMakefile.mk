#-----------------------------------------------------------------------
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2000-2001 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#-----------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name           : DirMakefile.mk,v
#- File Revision       : 1.11
#-
#- Release Information : ADK_REL1v1
#-
#-----------------------------------------------------------------------
#-  Purpose  :
#-             A makefile to build lower level directories 
#-----------------------------------------------------------------------

all:
	@for i in $(DIRS) ; do \
	  (cd $$i ; \
	  $(MAKE) TEST_ENV=$(TEST_ENV) TEST_BENCH=$(TEST_BENCH) TEST_NAME=$(TEST_NAME) SIM_FLAGS='$(SIM_FLAGS)' all) \
	done

rtl:
	@cd rtl_source ; \
	  $(MAKE) TEST_ENV=$(TEST_ENV) TEST_BENCH=$(TEST_BENCH) TEST_NAME=$(TEST_NAME) SIM_FLAGS='$(SIM_FLAGS)' all

netlist: FORCE
	@(if [ -d netlist ]; then \
	  cd netlist ; \
	else \
	  cd rtl_source ; \
	fi ; \
	  $(MAKE) TEST_ENV=$(TEST_ENV) TEST_BENCH=$(TEST_BENCH) TEST_NAME=$(TEST_NAME) SIM_FLAGS='$(SIM_FLAGS)' netlist)

FORCE:

clean:
	@for i in $(DIRS) ; do \
	  (cd $$i ; \
	  $(MAKE) clean ) \
	done

################################ End ###################################
