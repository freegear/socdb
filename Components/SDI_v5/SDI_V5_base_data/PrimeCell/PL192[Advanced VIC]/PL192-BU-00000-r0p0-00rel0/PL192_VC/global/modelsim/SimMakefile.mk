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
#- File Name              : SimMakefile.mk.rca
#- File Revision          : 1.4
#-
#- Release Information    : PrimeCell(TM)-GLOBAL-r8p0-00rel0
#-
#-----------------------------------------------------------------------
#-  Purpose  :
#-             A makefile to run Modelsim simulations 
#-----------------------------------------------------------------------
#
# Note on coverage modifications:
#
#	@if [ -f accumulate.history ]; then \
#         # For all simulations except the 1st one, we use vnmanager to merge
#         # the code coverage results to accumulate.history.
#	  vnmerge vnavigator.history accumulate.history -save accumulate.history ; \
#	else \
#         # After the first simulation, the file accumulate.history does not exist.
#         # So we copy the history file of the 1st run to the accumulate.history
#         #
#	  cp vnavigator.history accumulate.history ; \
#	fi
#       # Generate summary report (Use this one if you want to overwrite the
#       # result of individual test. Normally commented out)
#	#@vnresults accumulate.history -summary -summary_file accumulate.summary
#
#       # Generate summary report (Use this one if you want to create detailed 
#       # coverage result in a single file)
#	@vnmanager accumulate.history -summary  > accumulative_coverage.summary
#	@vnmanager accumulate.history -coverage > accumulative_coverage.details
#
#
#
#   For a clean coverage test, the accumulate.history should be deleted before
#   the simulation start.
#


rtl: modelsim.ini init.do 
	@vsim tbench.tbench < init.do

cover: modelsim.ini init.do 
	@chmod a+w modelsim.ini
	@vnlib -simulator modelsim_vhdl5_4 -create work=./work
	@if [ "$(HDL_SOURCE)" = "vhdl" ]; then \
	  vnsim -overwrite -simulator modelsim_vhdl5_4 tbench.tbench < init.do; \
	else \
	  vnsim -overwrite -simulator modelsim_verilog5_4 tbench.tbench < init.do; \
	fi
	@vnresults -summary
	@if [ -f accumulate.history ]; then \
	  vnmerge vnavigator.history accumulate.history -save accumulate.history ; \
	else \
	  cp vnavigator.history accumulate.history ; \
	fi
        # Use this to overwrite individual test coverage
	#@vnresults accumulate.history -summary -summary_file accumulate.summary
	
	@vnmanager accumulate.history -summary  > accumulative_coverage.summary
	@vnmanager accumulate.history -coverage > accumulative_coverage.details


net_min: modelsim.ini init.do 
	@if [ "$(TEST_ENV)" = "TICTALK" ]; then \
          if [ "$(AMBA)" = "APB" ]; then \
            if [ "$(HDL_NETL)" = "verilog" ]; then \
	      vsim -c -sdfmin u_easy/u_rps/uut=../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE).sdf21 -L $(DIRS_VERILOG)/work -sdfnoerror -noglitch tbench.tbench < init.do ; \
            else \
	      vsim -c -sdfmin u_easy/u_rps/uut=../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE).sdf21 -L $(LIB_VHDL)/work -sdfnoerror -noglitch tbench.tbench < init.do ; \
            fi \
          else \
            if [ "$(HDL_NETL)" = "verilog" ]; then \
	      vsim -c -sdfmin u_easy/uut=../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE).sdf21 -L $(DIRS_VERILOG)/work -sdfnoerror -noglitch tbench.tbench < init.do ; \
            else \
	      vsim -c -sdfmin u_easy/uut=../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE).sdf21 -L $(LIB_VHDL)/work -sdfnoerror -noglitch tbench.tbench < init.do ; \
            fi \
          fi \
	elif  [ "$(TEST_ENV)" = "BUSTALK" ]; then \
          if [ "$(HDL_NETL)" = "verilog" ]; then \
	    vsim -c -sdfmin uut=../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE).sdf21 -L $(DIRS_VERILOG)/work -sdfnoerror -noglitch tbench.tbench < init.do ; \
          else \
	    vsim -c -sdfmin uut=../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE).sdf21 -L $(LIB_VHDL)/work -sdfnoerror -noglitch tbench.tbench < init.do ; \
          fi \
	fi

net_typ: modelsim.ini init.do 
	@if [ "$(TEST_ENV)" = "TICTALK" ]; then \
          if [ "$(AMBA)" = "APB" ]; then \
            if [ "$(HDL_NETL)" = "verilog" ]; then \
	      vsim -c -sdftyp u_easy/u_rps/uut=../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE).sdf21 -L $(DIRS_VERILOG)/work -sdfnoerror -noglitch tbench.tbench < init.do ; \
            else \
	      vsim -c -sdftyp u_easy/u_rps/uut=../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE).sdf21 -L $(LIB_VHDL)/work -sdfnoerror -noglitch tbench.tbench < init.do ; \
            fi \
          else \
            if [ "$(HDL_NETL)" = "verilog" ]; then \
	      vsim -c -sdftyp u_easy/uut=../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE).sdf21 -L $(DIRS_VERILOG)/work -sdfnoerror -noglitch tbench.tbench < init.do ; \
            else \
	      vsim -c -sdftyp u_easy/uut=../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE).sdf21 -L $(LIB_VHDL)/work -sdfnoerror -noglitch tbench.tbench < init.do ; \
            fi \
          fi \
	elif  [ "$(TEST_ENV)" = "BUSTALK" ]; then \
          if [ "$(HDL_NETL)" = "verilog" ]; then \
	    vsim -c -sdftyp uut=../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE).sdf21 -L $(DIRS_VERILOG)/work -sdfnoerror -noglitch tbench.tbench < init.do ; \
          else \
	    vsim -c -sdftyp uut=../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE).sdf21 -L $(LIB_VHDL)/work -sdfnoerror -noglitch tbench.tbench < init.do ; \
          fi \
	fi

net_max: modelsim.ini init.do 
	@if [ "$(TEST_ENV)" = "TICTALK" ]; then \
          if [ "$(AMBA)" = "APB" ]; then \
            if [ "$(HDL_NETL)" = "verilog" ]; then \
	      vsim -c -sdfmax u_easy/u_rps/uut=../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE).sdf21 -L $(DIRS_VERILOG)/work -sdfnoerror -noglitch tbench.tbench < init.do ; \
            else \
	      vsim -c -sdfmax u_easy/u_rps/uut=../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE).sdf21 -L $(LIB_VHDL)/work -sdfnoerror -noglitch tbench.tbench < init.do ; \
            fi \
          else \
            if [ "$(HDL_NETL)" = "verilog" ]; then \
	      vsim -c -sdfmax u_easy/uut=../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE).sdf21 -L $(DIRS_VERILOG)/work -sdfnoerror -noglitch tbench.tbench < init.do ; \
            else \
	      vsim -c -sdfmax u_easy/uut=../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE).sdf21 -L $(LIB_VHDL)/work -sdfnoerror -noglitch tbench.tbench < init.do ; \
            fi \
          fi \
	elif  [ "$(TEST_ENV)" = "BUSTALK" ]; then \
          if [ "$(HDL_NETL)" = "verilog" ]; then \
	    vsim -c -sdfmax uut=../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE).sdf21 -L $(DIRS_VERILOG)/work -sdfnoerror -noglitch tbench.tbench < init.do ; \
          else \
	    vsim -c -sdfmax uut=../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE).sdf21 -L $(LIB_VHDL)/work -sdfnoerror -noglitch tbench.tbench < init.do ; \
          fi \
	fi

modelsim.ini:  
	@if [ "$(TEST_ENV)" = "TICTALK" ]; then \
	  cp -f $(GLOBAL)/modelsim/modelsim_tictalk.ini modelsim.ini; \
	elif  [ "$(TEST_ENV)" = "BUSTALK" ]; then \
	  cp -f $(GLOBAL)/modelsim/modelsim_bustalk.ini modelsim.ini; \
	else \
	  cp -f $(GLOBAL)/modelsim/modelsim.ini modelsim.ini; \
	fi

init.do: $(GLOBAL)/modelsim/init.do
	@cp $(GLOBAL)/modelsim/init.do .

.IGNORE:

################################ End ###################################
