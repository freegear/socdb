#-----------------------------------------------------------------------
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2000 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#-----------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name              : DirSimMakefile.mk.rca
#- File Revision          : 1.1
#-
#- Release Information    : PrimeCell(TM)-GLOBAL-r8p0-00rel0
#-
#-----------------------------------------------------------------------
#-  Purpose  :
#-             A makefile to initiate simulations 
#-----------------------------------------------------------------------

rtl: uutrtl all 
	@if [ ! -d $(PERIPH)_rtl ] ; then \
	mkdir $(PERIPH)_rtl ; fi ;
	@(cd  $(PERIPH)_rtl; \
	rm -f makefile ; \
	ln -s $(GLOBAL)/$(SIMULATOR)/SimMakefile.mk makefile ; \
	make TEST_ENV=$(TEST_ENV) AMBA=$(AMBA) rtl; \
	)

uutrtl: 
	@rm -rf uut
	@ln -s ../../$(HDL_SOURCE)/rtl_source uut
	@(cd  uut ; \
	make all ; \
	)

net_max : uutnet all 
	@if [ ! -d $(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_net_max ] ; \
        then \
	mkdir $(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_net_max ; fi ;
	@(cd  $(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_net_max; \
	rm -f makefile ; \
	ln -s $(GLOBAL)/$(SIMULATOR)/SimMakefile.mk makefile ; \
	make TEST_ENV=$(TEST_ENV) AMBA=$(AMBA) net_max; \
	)

net_typ : uutnet all 
	@if [ ! -d $(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_net_typ ] ; \
        then \
	mkdir $(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_net_typ ; fi ;
	@(cd  $(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_net_typ; \
	rm -f makefile ; \
	ln -s $(GLOBAL)/$(SIMULATOR)/SimMakefile.mk makefile ; \
	make TEST_ENV=$(TEST_ENV) AMBA=$(AMBA) net_typ; \
	)

net_min : uutnet all 
	@if [ ! -d $(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_net_min ] ; \
        then \
	mkdir $(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_net_min ; fi ;
	@(cd  $(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_net_min; \
	rm -f makefile ; \
	ln -s $(GLOBAL)/$(SIMULATOR)/SimMakefile.mk makefile ; \
	make TEST_ENV=$(TEST_ENV) AMBA=$(AMBA) net_min; \
	)

uutnet: 
	@rm -rf uut
	@ln -s ../../$(HDL_NETL)/netlist uut
	@(cd  uut ; \
	make clean all ; \
	)

include $(GLOBAL)/$(SIMULATOR)/DirMakefile.mk

################################ End ###################################
