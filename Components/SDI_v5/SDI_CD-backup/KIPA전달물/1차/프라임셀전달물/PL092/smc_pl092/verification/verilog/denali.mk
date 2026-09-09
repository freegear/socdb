#-------------------------------------------------------------------------------
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2000-2001 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#-------------------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name              : denali.mk.rca
#- File Revision          : 1.6
#-
#- Release Information    : PrimeCell(TM)-PL092-REL1v1
#-
#-------------------------------------------------------------------------------
#-  Purpose  :
#-             A makefile to initiate simulations 
#-------------------------------------------------------------------------------

#- List of directories to make. Order is important
DIRS = common bid reader buswatcher vr uut trickbox tbench

TEST_ENV = BUSTALK

rtl: uutrtl all
	@if [ ! -d $(PERIPH)_rtl ] ; then \
	mkdir $(PERIPH)_rtl ; fi ;
	(cd  $(PERIPH)_rtl; \
         if [ "$(SIMULATOR)" = "modelsim" ]; then \
	   make -f denali.mk TEST_ENV=$(TEST_ENV) rtl; \
         else \
           make -f denali_LDV.mk TEST_ENV=$(TEST_ENV) rtl; \
         fi \
	)

uutrtl: 
	@rm -rf uut
	@ln -s ../../$(HDL_SOURCE)/rtl_source uut
	@(cd  uut ; \
	make all ; \
	)

cover: coveruutrtl all 
	@if [ ! -d $(PERIPH)_rtl ] ; then \
	mkdir $(PERIPH)_rtl ; fi ;
	@(cd  $(PERIPH)_rtl; \
         if [ "$(SIMULATOR)" = "modelsim" ]; then \
	   make -f denali.mk TEST_ENV=$(TEST_ENV) cover; \
         else \
	   make -f denali_LDV.mk TEST_ENV=$(TEST_ENV) cover; \
         fi \
	 )

coveruutrtl: 
	@rm -rf uut
	@ln -s ../../$(HDL_SOURCE)/rtl_source uut
	@(cd  uut ; \
	make cover ; \
	)

net_max : uutnet all 
	@if [ ! -d $(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_net_max ] ; \
        then \
	mkdir $(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_net_max ; fi ;
	@(cd  $(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_net_max; \
          if [ "$(SIMULATOR)" = "modelsim" ]; then \
	    make -f denali.mk TEST_ENV=$(TEST_ENV) net_max; \
          else \
	    make -f denali_LDV.mk TEST_ENV=$(TEST_ENV) net_max; \
          fi \
	)

net_typ : uutnet all 
	@if [ ! -d $(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_net_typ ] ; \
        then \
	mkdir $(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_net_typ ; fi ;
	@(cd  $(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_net_typ; \
          if [ "$(SIMULATOR)" = "modelsim" ]; then \
	    make -f denali.mk TEST_ENV=$(TEST_ENV) net_typ; \
          else \
	    make -f denali_LDV.mk TEST_ENV=$(TEST_ENV) net_typ; \
          fi \
	)

net_min : uutnet all 
	@if [ ! -d $(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_net_min ] ; \
        then \
	mkdir $(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_net_min ; fi ;
	@(cd  $(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_net_min; \
          if [ "$(SIMULATOR)" = "modelsim" ]; then \
	    make -f denali.mk TEST_ENV=$(TEST_ENV) net_min; \
          else \
	    make -f denali_LDV.mk TEST_ENV=$(TEST_ENV) net_min; \
          fi \
	)

uutnet: 
	@rm -rf uut
	@ln -s ../../$(HDL_NETL)/netlist uut
	@(cd  uut ; \
	if [ "$(HDL_NETL)" = "vhdl" ]; then \
	$(GLOBAL)/bin/vhdl_sdf_patch $(PERIPH)_$(TEST_METH)_$(HDL_SOURCE).sdf21 ; \
	elif  [ "$(HDL_NETL)" = "verilog" ]; then \
	$(GLOBAL)/bin/verilog_net_patch $(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_net.v ; \
	fi ; \
	make clean all ; \
	)

include $(GLOBAL)/$(SIMULATOR)/DirMakefile.mk

################################### End ########################################
