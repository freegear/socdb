#-------------------------------------------------------------------------------
#-  This confidential and proprietary software may be used only as
#-  authorised by a licensing agreement from ARM Limited
#-    (C) COPYRIGHT 2000-2001 ARM Limited
#-        ALL RIGHTS RESERVED
#-  The entire notice above must be reproduced on all authorised
#-  copies and copies may only be made to the extent permitted
#-  by a licensing agreement from ARM Limited.
#-------------------------------------------------------------------------------
#-
#-  Version and Release Control Information:
#-
#- File Name           : makefile,v
#- File Revision       : 1.5
#-
#- Release Information : ADK_REL1v1
#-
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#-  Purpose  : A makefile to initiate Simulations
#-------------------------------------------------------------------------------

# list of directories to make. Order is important
DIRS = vhdl verilog $(ADSCODE)/build
SIM_FLAGS = ''
PERIPH = TBEasy_ARM7

rtl: 
	@(cd  $(HDL_SOURCE) ; $(MAKE) TEST_ENV=$(TEST_ENV) TEST_BENCH=$(TEST_BENCH) TEST_NAME=$(TEST_NAME) SIM_FLAGS='$(SIM_FLAGS)' rtl; )

net_max :  
	@(cd  $(HDL_NETL) ; $(MAKE) TEST_ENV=$(TEST_ENV) TEST_BENCH=$(TEST_BENCH) TEST_NAME=$(TEST_NAME) SIM_FLAGS='$(SIM_FLAGS)' net_max; )

net_typ : 
	@(cd  $(HDL_NETL) ; $(MAKE) TEST_ENV=$(TEST_ENV) TEST_BENCH=$(TEST_BENCH) TEST_NAME=$(TEST_NAME) SIM_FLAGS='$(SIM_FLAGS)' net_typ; )

net_min : 
	@(cd  $(HDL_NETL) ; $(MAKE) TEST_ENV=$(TEST_ENV) TEST_BENCH=$(TEST_BENCH) TEST_NAME=$(TEST_NAME) SIM_FLAGS='$(SIM_FLAGS)' net_min; )

clean:
	@for i in $(DIRS) ; do \
	  (cd $$i ; \
	  $(MAKE) clean ) \
	done

#################################### End of file ###############################
