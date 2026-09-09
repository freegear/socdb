#-----------------------------------------------------------------------
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2000-2001 ARM Limited
#-	 ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#-----------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name           : DirSimMakefile.mk,v
#- File Revision       : 1.15
#-
#- Release Information : ADK_REL1v1
#-
#-----------------------------------------------------------------------
#-  Purpose  :
#-	       A makefile to initiate simulations 
#-----------------------------------------------------------------------


clean:
	@for i in $(TEST_BENCH)_* ; do \
	  (if [ -r $$i/makefile ] ; then cd $$i ; make PERIPH=$(PERIPH) clean ; rm -f makefile ; fi) \
	done
	@(cd  $(ADK)/design/$(PERIPH) ; \
	  $(MAKE) clean ; \
	)

rtl: uutrtl
	@if [ ! -d $(TEST_BENCH)_rtl ] ; then \
	  mkdir $(TEST_BENCH)_rtl ; fi ;
	@(cd  $(TEST_BENCH)_rtl; \
	  if [ ! -f makefile ] ; then \
	    ln -s $(GLOBAL)/$(SIMULATOR)/SimMakefile.mk makefile ; \
	  fi ; \
	  $(MAKE) PERIPH=$(PERIPH) TEST_BENCH=$(TEST_BENCH) TEST_ENV=$(TEST_ENV) TEST_NAME=$(TEST_NAME) SIM_FLAGS='$(SIM_FLAGS)' rtl; \
	)

uutrtl: 
	@(cd  $(ADK)/design/$(PERIPH) ; \
	  $(MAKE) rtl ; \
	)

net_max : uutnet
	@if [ ! -d $(TEST_BENCH)_$(TEST_METH)_$(HDL_SOURCE)_net_max ] ; then \
	  mkdir $(TEST_BENCH)_$(TEST_METH)_$(HDL_SOURCE)_net_max ; fi ;
	@(cd  $(TEST_BENCH)_$(TEST_METH)_$(HDL_SOURCE)_net_max; \
	  if [ ! -f makefile ] ; then \
	    ln -s $(GLOBAL)/$(SIMULATOR)/SimMakefile.mk makefile ; \
	  fi ; \
	  $(MAKE) PERIPH=$(PERIPH) TEST_BENCH=$(TEST_BENCH) TEST_ENV=$(TEST_ENV) TEST_NAME=$(TEST_NAME) SIM_FLAGS='$(SIM_FLAGS)' net_max; \
	)

net_typ : uutnet
	@if [ ! -d $(TEST_BENCH)_$(TEST_METH)_$(HDL_SOURCE)_net_typ ] ; then \
	  mkdir $(TEST_BENCH)_$(TEST_METH)_$(HDL_SOURCE)_net_typ ; fi ;
	@(cd  $(TEST_BENCH)_$(TEST_METH)_$(HDL_SOURCE)_net_typ; \
	  if [ ! -f makefile ] ; then \
	    ln -s $(GLOBAL)/$(SIMULATOR)/SimMakefile.mk makefile ; \
	  fi ; \
	  $(MAKE) PERIPH=$(PERIPH) TEST_BENCH=$(TEST_BENCH) TEST_ENV=$(TEST_ENV) TEST_NAME=$(TEST_NAME) SIM_FLAGS='$(SIM_FLAGS)' net_typ; \
	)

net_min : uutnet
	@if [ ! -d $(TEST_BENCH)_$(TEST_METH)_$(HDL_SOURCE)_net_min ] ; then \
	  mkdir $(TEST_BENCH)_$(TEST_METH)_$(HDL_SOURCE)_net_min ; fi ;
	@(cd  $(TEST_BENCH)_$(TEST_METH)_$(HDL_SOURCE)_net_min; \
	  if [ ! -f makefile ] ; then \
	    ln -s $(GLOBAL)/$(SIMULATOR)/SimMakefile.mk makefile ; \
	  fi ; \
	  $(MAKE) PERIPH=$(PERIPH) TEST_BENCH=$(TEST_BENCH) TEST_ENV=$(TEST_ENV) TEST_NAME=$(TEST_NAME) SIM_FLAGS='$(SIM_FLAGS)' net_min; \
	)

uutnet: 
	@(cd  $(ADK)/design/$(PERIPH) ; \
	  $(MAKE) netlist ; \
	)

################################ End ###################################
