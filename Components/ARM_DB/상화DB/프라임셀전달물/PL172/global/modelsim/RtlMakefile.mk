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
#- File Name              : RtlMakefile.mk.rca
#- File Revision          : 1.6
#-
#- Release Information    : PrimeCell(TM)-GLOBAL-REL1v7
#-
#-----------------------------------------------------------------------
#-  Purpose  :
#-             A standardised makefile to be included in other makefiles
#-----------------------------------------------------------------------

all: modelsim.ini work work.mk
	@make -f work.mk

clean:  
	@rm -rf work work.mk modelsim.ini WORK
	@rm -f verilint.* spyglass.*

cover:  
	@rm -rf work
	@chmod a+w modelsim.ini
	@vnlib -simulator modelsim_vhdl5_4 -create work=./work
	@if [ "$(HDL_SOURCE)" = "vhdl" ]; then \
	  for CodeFile in $(MODULES) ; do \
	    vnvhdl -instrument -path -statement -branch \
              -condition -triggering -toggle -simulator \
               modelsim_vhdl5_4 $$CodeFile; \
	  done; \
	else \
	  for CodeFile in $(MODULES) ; do \
	    vnvlog -path -statement -branch -condition \
              -toggle -simulator modelsim_verilog5_4 -- $$CodeFile; \
	  done; \
	fi
	@rm -rf work.mk

check:  
	@if [ ! -d WORK ]; then \
	mkdir WORK ; fi ;
	@if [ "$(HDL_SOURCE)" = "vhdl" ]; then \
	  spyglass *.vhd > spyglass.log; \
	else \
	  spyglass -verilog *.v > spyglass.log; \
          verilint *.v > verilint.log; \
	fi

work.mk: work modelsim.ini
	@for CodeFile in $(MODULES) ; do \
	  ftype=`echo $$CodeFile | awk -F. '{ i = NF }{print $$i}'`; \
	  if [ $$ftype = 'vhd' ]; then \
	    vcom -explicit -just p $$CodeFile; \
	    vcom -explicit -just e $$CodeFile; \
	    vcom -explicit $$CodeFile; \
	  else \
	    vlog -compat $$CodeFile; \
	  fi; \
	done
	@vmake > work.mk

work:
	@vlib work

modelsim.ini: 
	@if [ "$(TEST_ENV)" = "TICTALK" ]; then \
	  cp -f $(GLOBAL)/modelsim/modelsim_tictalk.ini modelsim.ini; \
	elif [ "$(TEST_ENV)" = "BUSTALK" ]; then \
	  cp -f $(GLOBAL)/modelsim/modelsim_bustalk.ini modelsim.ini; \
	else \
	  cp -f $(GLOBAL)/modelsim/modelsim.ini modelsim.ini; \
	fi

################################ End ###################################
