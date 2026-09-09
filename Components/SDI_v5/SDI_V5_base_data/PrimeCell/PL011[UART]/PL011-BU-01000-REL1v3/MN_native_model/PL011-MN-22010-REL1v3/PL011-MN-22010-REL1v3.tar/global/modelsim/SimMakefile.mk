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
#- File Revision          : 1.5
#-
#- Release Information    : PrimeCell(TM)-GLOBAL-REL1v1
#-
#-----------------------------------------------------------------------
#-  Purpose  :
#-             A makefile to run Modelsim simulations 
#-----------------------------------------------------------------------

rtl: modelsim.ini init.do 
	@vsim tbench.tbench < init.do

cover: modelsim.ini init.do 
	@chmod a+w modelsim.ini
	@vnlib -simulator modelsim_vhdl5_2 -create work=./work
	@if [ "$(HDL_SOURCE)" = "vhdl" ]; then \
	  vnsim -overwrite -simulator modelsim_vhdl5_2 tbench.tbench < init.do; \
	else \
	  vnsim -overwrite -simulator modelsim_verilog5_2 tbench.tbench < init.do; \
	fi
	@vnresults -summary

net_min: modelsim.ini init.do 
	@if [ "$(TEST_ENV)" = "TICTALK" ]; then \
          if [ "$(AMBA)" = "AHB" ]; then \
            if [ "$(HDL_NETL)" = "verilog" ]; then \
	      vsim -c -sdfmin u_easy/u_rps/uut=../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE).sdf21 -L $(DIRS_VERILOG)/work -sdfnoerror -noglitch tbench.tbench < init.do ; \
            else \
	      vsim -c -sdfmin u_easy/u_rps/uut=../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE).sdf21 -L $(LIB_VHDL)/work -sdfnoerror -noglitch tbench.tbench < init.do ; \
            fi \
          else \
            if [ "$(HDL_NETL)" = "verilog" ]; then \
	      vsim -c -sdfmin u_easy/u_rps/uut=../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE).sdf21 -L $(DIRS_VERILOG)/work -sdfnoerror -noglitch tbench.tbench < init.do ; \
            else \
	      vsim -c -sdfmin u_easy/u_rps/uut=../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE).sdf21 -L $(LIB_VHDL)/work -sdfnoerror -noglitch tbench.tbench < init.do ; \
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
          if [ "$(AMBA)" = "AHB" ]; then \
            if [ "$(HDL_NETL)" = "verilog" ]; then \
	      vsim -c -sdftyp u_easy/u_rps/uut=../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE).sdf21 -L $(DIRS_VERILOG)/work -sdfnoerror -noglitch tbench.tbench < init.do ; \
            else \
	      vsim -c -sdftyp u_easy/u_rps/uut=../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE).sdf21 -L $(LIB_VHDL)/work -sdfnoerror -noglitch tbench.tbench < init.do ; \
            fi \
          else \
            if [ "$(HDL_NETL)" = "verilog" ]; then \
	      vsim -c -sdftyp u_easy/u_rps/uut=../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE).sdf21 -L $(DIRS_VERILOG)/work -sdfnoerror -noglitch tbench.tbench < init.do ; \
            else \
	      vsim -c -sdftyp u_easy/u_rps/uut=../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE).sdf21 -L $(LIB_VHDL)/work -sdfnoerror -noglitch tbench.tbench < init.do ; \
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
          if [ "$(AMBA)" = "AHB" ]; then \
            if [ "$(HDL_NETL)" = "verilog" ]; then \
	      vsim -c -sdfmax u_easy/u_rps/uut=../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE).sdf21 -L $(DIRS_VERILOG)/work -sdfnoerror -noglitch tbench.tbench < init.do ; \
            else \
	      vsim -c -sdfmax u_easy/u_rps/uut=../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE).sdf21 -L $(LIB_VHDL)/work -sdfnoerror -noglitch tbench.tbench < init.do ; \
            fi \
          else \
            if [ "$(HDL_NETL)" = "verilog" ]; then \
	      vsim -c -sdfmax u_easy/u_rps/uut=../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE).sdf21 -L $(DIRS_VERILOG)/work -sdfnoerror -noglitch tbench.tbench < init.do ; \
            else \
	      vsim -c -sdfmax u_easy/u_rps/uut=../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE).sdf21 -L $(LIB_VHDL)/work -sdfnoerror -noglitch tbench.tbench < init.do ; \
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
