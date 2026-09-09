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
#- File Name           : SimMakefile.mk,v
#- File Revision       : 1.26
#-
#- Release Information : ADK_REL1v1
#-
#-----------------------------------------------------------------------
#-  Purpose            : A makefile to run ADK simulations 
#-----------------------------------------------------------------------

SIM_FLAGS = ''

include $(ADK)/design/$(PERIPH)/Components_$(TEST_BENCH).mk

rtl: modelsim.ini init.do infile
	@$(GLOBAL)/modelsim/$(HDL_SOURCE)RTLlibmap.csh $(PERIPH) $(COMPONENTS)
	@if [ "$(HDL_SOURCE)" = "vhdl" ]; then \
	  echo "vsim -l $(TEST_NAME)_$(TEST_NAME_ROM)_$(HDL_SOURCE)_transcript $(SIM_FLAGS) -do init.do -lib $(PERIPH) $(TEST_BENCH)" > run_command ; \
	else \
	  echo "vsim -l $(TEST_NAME)_$(TEST_NAME_ROM)_$(HDL_SOURCE)_transcript -f EASYlibmap $(SIM_FLAGS) -do init.do -lib $(ADK)/design/$(PERIPH)/$(HDL_SOURCE)/rtl_source/work $(TEST_BENCH)" > run_command ; \
	fi ; \
	chmod a+x run_command
	@if [ ! "$(NOSIM)" = "yes" ] ; then \
	  run_command ; \
	fi

infile: modelsim.ini
	@-if [ "$(TEST_ENV)" = "TICTALK" ]; then \
	  dir_hdl=`pwd | awk -F/ '{i = NF-1}{print $$i}'`; \
	  if  [ "$$dir_hdl" = "vhdl" ]; then \
	    rm -rf infile.tif; \
	    ln -s $(TIC_DIR)/$(TEST_NAME).tif infile.tif; \
	  else \
	    if ( [ "${SIMULATOR}" = "modelsim" ] && [ "${HDL_SOURCE}" = "verilog" ] ) ; then \
	      Veriuser_exists=`grep Veriuser modelsim.ini` ; \
	      if [ "$$Veriuser_exists" = "" ] ; then \
		echo "Veriuser = \$$MG_LIB/mti_modelsim_verilog/libmgmm.so" >> modelsim.ini ; \
	      fi ; \
	    fi; \
	    (cd $(ADK)/design/Ticbox/verilog/rtl_source; \
	    cp $(ADK)/design/Ticbox/bin/tif2sim* . ; \
	    rm -rf infile.sim; \
	    tif2sim $(TIC_DIR)/$(TEST_NAME).tif > infile.sim; \
	    $(MAKE) clean; \
	    $(MAKE) rtl); \
	  fi; \
	  touch filestim.frd; \
	  touch intram.dat; \
	elif  [ "$(TEST_ENV)" = "FRBM" ]; then \
	  rm -rf filestim.frd; \
	  (cd ../../frbmtests ; $(MAKE) $(TEST_NAME) ); \
	  ln -s ../../frbmtests/$(TEST_NAME).frd filestim.frd; \
	  touch intram.dat; \
	elif [ -f ../../Simfile_$(TEST_BENCH).mk ]; then \
	  make -f ../../Simfile_$(TEST_BENCH).mk infile; \
	fi

clean:
	@rm -f modelsim.ini init.do
	@rm -f intram.dat
	@rm -f extram??.dat
	@rm -f rom?.dat
	@rm -f EASYlibmap
	@rm -f filestim.frd
	@rm -f vsim.wlf
	@rm -f infile.*

net_min: modelsim.ini init.do infile
	@$(GLOBAL)/modelsim/$(HDL_NETL)NLSlibmap.csh $(PERIPH) $(COMPONENTS)
	@if [ "$(HDL_NETL)" = "verilog" ]; then \
	  echo "vsim -l $(TEST_NAME)_$(TEST_NAME_ROM)_$(HDL_SOURCE)_$(HDL_NETL)_nls_transcript $(SIM_FLAGS) -sdfmin u$(EASY)=$(ADK)/design/$(EASY)/$(HDL_NETL)/netlist/$(EASY)_$(TEST_METH)_$(HDL_SOURCE).sdf21 -f EASYlibmap -L $(DIRS_VERILOG)/work -sdfnoerror -noglitch -lib $(ADK)/design/$(PERIPH)/$(HDL_NETL)/rtl_source/work $(TEST_BENCH) -do init.do" > run_command ; \
	else \
	  echo "vsim -l $(TEST_NAME)_$(TEST_NAME_ROM)_$(HDL_SOURCE)_$(HDL_NETL)_nls_transcript $(SIM_FLAGS) -sdfmin u$(EASY)=$(ADK)/design/$(EASY)/$(HDL_NETL)/netlist/$(EASY)_$(TEST_METH)_$(HDL_SOURCE).sdf21 -L $(LIB_VHDL)/work -sdfnoerror -noglitch -lib $(PERIPH) $(TEST_BENCH) -do init.do" > run_command ; \
	fi ; \
	chmod a+x run_command
	@if [ ! "$(NOSIM)" = "yes" ] ; then \
	  run_command ; \
	fi

net_typ: modelsim.ini init.do infile
	@$(GLOBAL)/modelsim/$(HDL_NETL)NLSlibmap.csh $(PERIPH) $(COMPONENTS)
	@if [ "$(HDL_NETL)" = "verilog" ]; then \
	  echo "vsim -l $(TEST_NAME)_$(TEST_NAME_ROM)_$(HDL_SOURCE)_$(HDL_NETL)_nls_transcript $(SIM_FLAGS) -sdftyp u$(EASY)=$(ADK)/design/$(EASY)/$(HDL_NETL)/netlist/$(EASY)_$(TEST_METH)_$(HDL_SOURCE).sdf21 -f EASYlibmap -L $(DIRS_VERILOG)/work -sdfnoerror -noglitch -lib $(ADK)/design/$(PERIPH)/$(HDL_NETL)/rtl_source/work $(TEST_BENCH) -do init.do" > run_command ; \
	else \
	  echo "vsim -l $(TEST_NAME)_$(TEST_NAME_ROM)_$(HDL_SOURCE)_$(HDL_NETL)_nls_transcript $(SIM_FLAGS) -sdftyp u$(EASY)=$(ADK)/design/$(EASY)/$(HDL_NETL)/netlist/$(EASY)_$(TEST_METH)_$(HDL_SOURCE).sdf21 -L $(LIB_VHDL)/work -sdfnoerror -noglitch -lib $(PERIPH) $(TEST_BENCH) -do init.do" > run_command ; \
	fi ; \
	chmod a+x run_command
	@if [ ! "$(NOSIM)" = "yes" ] ; then \
	  run_command ; \
	fi

net_max: modelsim.ini init.do infile
	@$(GLOBAL)/modelsim/$(HDL_NETL)NLSlibmap.csh $(PERIPH) $(COMPONENTS)
	@if [ "$(HDL_NETL)" = "verilog" ]; then \
	  echo "vsim -l $(TEST_NAME)_$(TEST_NAME_ROM)_$(HDL_SOURCE)_$(HDL_NETL)_nls_transcript $(SIM_FLAGS) -sdfmax u$(EASY)=$(ADK)/design/$(EASY)/$(HDL_NETL)/netlist/$(EASY)_$(TEST_METH)_$(HDL_SOURCE).sdf21 -f EASYlibmap -L $(DIRS_VERILOG)/work -sdfnoerror -noglitch -lib $(ADK)/design/$(PERIPH)/$(HDL_NETL)/rtl_source/work $(TEST_BENCH) -do init.do" > run_command ; \
	else \
	  echo "vsim -l $(TEST_NAME)_$(TEST_NAME_ROM)_$(HDL_SOURCE)_$(HDL_NETL)_nls_transcript $(SIM_FLAGS) -sdfmax u$(EASY)=$(ADK)/design/$(EASY)/$(HDL_NETL)/netlist/$(EASY)_$(TEST_METH)_$(HDL_SOURCE).sdf21 -L $(LIB_VHDL)/work -sdfnoerror -noglitch -lib $(PERIPH) $(TEST_BENCH) -do init.do" > run_command ; \
	fi ; \
	chmod a+x run_command
	@if [ ! "$(NOSIM)" = "yes" ] ; then \
	  run_command ; \
	fi

modelsim.ini:  
	@dir_hdl=`pwd | awk -F/ '{i = NF-1}{print $$i}'`; \
	cp -f $(GLOBAL)/modelsim/modelsim.$$dir_hdl modelsim.ini; \

init.do: $(GLOBAL)/modelsim/init.do
	@cp $(GLOBAL)/modelsim/init.do .

.IGNORE:

################################ End ###################################
