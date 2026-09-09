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
#- File Name           : SimMakefile.mk,v
#- File Revision       : 1.12
#-
#- Release Information : ADK_REL1v1
#-
#-----------------------------------------------------------------------
#-  Purpose               :  A makefile to run LDV simulations 
#-----------------------------------------------------------------------

LDV_OPTIONS = +licq_vxl +neg_tchk +libext+.v +access+rwc

RTL_OPTIONS = -l $(TEST_NAME)_$(TEST_NAME_ROM)_$(HDL_SOURCE)_$(LDVSIMULATOR).log

NETL_OPTIONS = +nosdfwarn -y $(DIRS_VERILOG) -v $(FILES_VERILOG) -l $(TEST_NAME)_$(TEST_NAME_ROM)_$(HDL_SOURCE)_$(HDL_NETL)_nls_$(LDVSIMULATOR).log

SDF_FILE = $(ADK)/design/$(EASY)/$(HDL_NETL)/netlist/$(EASY)_$(TEST_METH)_$(HDL_SOURCE).sdf21

TBENCH_RTL_FILE = $(ADK)/design/$(PERIPH)/verilog/rtl_source/$(TEST_BENCH).v

SIM_FLAGS = ''

include $(ADK)/design/$(PERIPH)/Components_$(TEST_BENCH).mk

rtl:  vxl.files.rtl infile
	@echo "$(LDVSIMULATOR) $(SIM_FLAGS) -f vxl.files.rtl $(RTL_OPTIONS) $(LDV_OPTIONS)" > run_command ; \
	chmod a+x run_command
	@if [ ! "$(NOSIM)" = "yes" ] ; then \
	  run_command ; \
	fi

net_min: vxl.files.nls infile sdf_commands
	@if [ "$(LDVSIMULATOR)" = "verilog" ]; then \
	  echo "$(LDVSIMULATOR) $(SIM_FLAGS) -f vxl.files.nls +mindelays -s -i run_sdf.ini $(LDV_OPTIONS) $(NETL_OPTIONS)" > run_command ; \
	else \
	  echo "$(LDVSIMULATOR) $(SIM_FLAGS) -f vxl.files.nls +mindelays +ncsdf_cmd_file+run_sdf.ini $(LDV_OPTIONS) $(NETL_OPTIONS)" > run_command ; \
	fi ; \
	chmod a+x run_command
	@if [ ! "$(NOSIM)" = "yes" ] ; then \
	  run_command ; \
	fi

net_typ: vxl.files.nls infile sdf_commands
	@if [ "$(LDVSIMULATOR)" = "verilog" ]; then \
	  echo "$(LDVSIMULATOR) $(SIM_FLAGS) -f vxl.files.nls +typdelays -s -i run_sdf.ini $(LDV_OPTIONS) $(NETL_OPTIONS)" > run_command ; \
	else \
	  echo "$(LDVSIMULATOR) $(SIM_FLAGS) -f vxl.files.nls +typdelays +ncsdf_cmd_file+run_sdf.ini $(LDV_OPTIONS) $(NETL_OPTIONS)" > run_command ; \
	fi ; \
	chmod a+x run_command
	@if [ ! "$(NOSIM)" = "yes" ] ; then \
	  run_command ; \
	fi

net_max: vxl.files.nls infile sdf_commands
	@if [ "$(LDVSIMULATOR)" = "verilog" ]; then \
	  echo "$(LDVSIMULATOR) $(SIM_FLAGS) -f vxl.files.nls +maxdelays -s -i run_sdf.ini $(LDV_OPTIONS) $(NETL_OPTIONS)" > run_command ; \
	else \
	  echo "$(LDVSIMULATOR) $(SIM_FLAGS) -f vxl.files.nls +maxdelays +ncsdf_cmd_file+run_sdf.ini $(LDV_OPTIONS) $(NETL_OPTIONS)" > run_command ; \
	fi ; \
	chmod a+x run_command
	@if [ ! "$(NOSIM)" = "yes" ] ; then \
	  run_command ; \
	fi

sdf_commands:
	@if [ "$(LDVSIMULATOR)" = "verilog" ]; then \
	  echo '$$sdf_annotate("'$(SDF_FILE)'",u'$(EASY)');' > run_sdf.ini; \
	  echo '.' >> run_sdf.ini; \
	else \
	  ncsdfc $(SDF_FILE); \
	  echo 'COMPILED_SDF_FILE = "'$(SDF_FILE)'.X",' > run_sdf.ini; \
          echo 'SCOPE = '$(TEST_BENCH)'.u'$(EASY)';' >> run_sdf.ini; \
	fi

vxl.files.rtl:
	@$(GLOBAL)/LDV/vxlfilesRTL.csh $(PERIPH) $(COMPONENTS)

vxl.files.nls:
	@$(GLOBAL)/LDV/vxlfilesNLS.csh $(PERIPH) $(COMPONENTS)

infile: 
	@if [ "$(TEST_ENV)" = "TICTALK" ]; then \
	  dir_hdl=`pwd | awk -F/ '{i = NF-1}{print $$i}'`; \
	  if  [ "$$dir_hdl" = "vhdl" ]; then \
	    rm -rf infile.tif; \
	    ln -s $(TIC_DIR)/$(TEST_NAME).tif infile.tif; \
	  else \
	    cp $(ADK)/design/Ticbox/bin/tif2sim* . ; \
	    rm -rf infile.sim; \
	    tif2sim $(TIC_DIR)/$(TEST_NAME).tif > infile.sim; \
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
	@rm -f intram.dat
	@rm -f vxl.files.*
	@rm -f filestim.frd
	@rm -f verilog.key
	@rm -fr INCA_libs
	@rm -f run_sdf.ini
	@rm -f infile.*

################################ End ###################################
