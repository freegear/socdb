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
#- File Revision          : 1.7
#-
#- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
#-
#- -----------------------------------------------------------------------------
#- Purpose :
#-           A makefile to initiate TicTalk simulations 
#-
#- --=========================================================================--

# list of directories to make. Order is important
DIRS = sys trickbox chip ticbox tbench

TEST_ENV = TICTALK

AMBA = AHB

rtl: uutrtl all
	@if [ ! -d $(PERIPH)_rtl ] ; then \
	mkdir $(PERIPH)_rtl ; \
	fi ;
	(cd  $(PERIPH)_rtl; \
	\cp -f ../tbench/.denalirc . ; \
	rm -f makefile ; \
	ln -s ../tbench/SimMakefile_$(SIMULATOR).mk makefile ; \
	make TEST_ENV=$(TEST_ENV) TBENCH=$(TBENCH) rtl; \
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
	mkdir $(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_net_max ; \
	fi ;
	@(cd  $(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_net_max; \
	\cp -f ../tbench/.denalirc . ; \
	rm -f makefile ; \
	ln -s ../tbench/SimMakefile_$(SIMULATOR).mk makefile ; \
	make TEST_ENV=$(TEST_ENV) TBENCH=$(TBENCH) net_max; \
	)

net_typ : uutnet all 
	@if [ ! -d $(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_net_typ ] ; \
        then \
	mkdir $(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_net_typ ; \
	fi ;
	@(cd  $(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_net_typ; \
	\cp -f ../tbench/.denalirc . ; \
	rm -f makefile ; \
	ln -s ../tbench/SimMakefile_$(SIMULATOR).mk makefile ; \
	make TEST_ENV=$(TEST_ENV) TBENCH=$(TBENCH) net_typ; \
	)

net_min : uutnet all 
	@if [ ! -d $(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_net_min ] ; \
        then \
	mkdir $(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_net_min ; \
	fi ;
	@(cd  $(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_net_min; \
	\cp -f ../tbench/.denalirc . ; \
	rm -f makefile ; \
	ln -s ../tbench/SimMakefile_$(SIMULATOR).mk makefile ; \
	make TEST_ENV=$(TEST_ENV) TBENCH=$(TBENCH) net_min; \
	)

uutnet: 
	@rm -rf uut
	@ln -s ../../$(HDL_NETL)/netlist uut
	@(cd  uut ; \
	if [ "$(HDL_NETL)" = "vhdl" ]; then \
	$(GLOBAL)/bin/vhdl_sdf_patch $(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_src.sdf21 ; \
	elif  [ "$(HDL_NETL)" = "verilog" ]; then \
	$(GLOBAL)/bin/verilog_net_patch $(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_src_net.v ; \
	fi ; \
	make clean all ; \
	)

include $(GLOBAL)/$(SIMULATOR)/DirMakefile.mk

#- --================================= End ===================================--
