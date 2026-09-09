#- --=================================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2001 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#- ---------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name              : SynMakefile.mk,v
#- File Revision          : 1.14
#-
#- Release Information    : ADK_REL1v1
#-
#- ---------------------------------------------------------------------
#- Purpose :
#-           ADK global makefile, build netlist using synopsys
#-
#- --=================================================================--

clean : 
	@rm -rf work
	@rm -fr *.vdb
	@rm -fr command.log
	@rm -fr run_synth.tcsh

log/$(TOP_NAME)_$(TEST_METH)_vhdl_$(HDL_NETL)_synth.log : \
                       scripts/$(TOP_NAME)_scan.cmd \
                       scripts/$(TOP_NAME).scr \
                       scripts/$(TOP_NAME)_pre_sdf.scr \
                       scripts/$(TOP_NAME)_exceptions.scr \
                       $(VHDL_SOURCE)
	@if [ ! -d work ] ; then \
	  mkdir work ; fi
	@if [ ! -d db ] ; then \
	  mkdir db ; fi
	@if [ ! -d log ] ; then \
	  mkdir log ; fi
	@if [ ! -d report ] ; then \
	  mkdir report ; fi
	@rm -f run_synth.tcsh
	@echo '#!/bin/tcsh -f' > run_synth.tcsh
	@echo 'setenv TOP_NAME  $(TOP_NAME)' >> run_synth.tcsh
	@echo 'setenv OTHER_NAMES  $(OTHER_NAMES)' >> run_synth.tcsh
	@echo 'setenv COMMON_CELLS  $(COMMON_CELLS)' >> run_synth.tcsh
	@echo 'setenv SPECIAL_CELLS  $(SPECIAL_CELLS)' >> run_synth.tcsh
	@echo 'setenv MODULE_TYPE  $(MODULE_TYPE)' >> run_synth.tcsh
	@echo 'setenv USE_TRISTATES  $(USE_TRISTATES)' >> run_synth.tcsh
	@echo 'setenv USE_LATCHES  $(USE_LATCHES)' >> run_synth.tcsh
	@if [ ! "$(CPU_TOP_NAME)" = "" ] ; then \
	  echo 'setenv CPU_TOP_NAME  $(CPU_TOP_NAME)' >> run_synth.tcsh ; fi
	@if [ ! "$(CPU_LIB_MAX)" = "" ] ; then \
	  echo 'setenv CPU_LIB_MAX  $(CPU_LIB_MAX)' >> run_synth.tcsh ; fi
	@if [ ! "$(CPU_LIB_MIN)" = "" ] ; then \
	  echo 'setenv CPU_LIB_MIN  $(CPU_LIB_MIN)' >> run_synth.tcsh ; fi
	@if [ ! "$(CPU_LIB_AREA)" = "" ] ; then \
	  echo 'setenv CPU_LIB_AREA  $(CPU_LIB_AREA)' >> run_synth.tcsh ; fi
	@if [ ! "$(FULLDB)" = "" ] ; then \
	  echo 'setenv FULLDB  $(FULLDB)' >> run_synth.tcsh ; fi
	@if [ ! "$(SYNTH_MAP_EFFORT)" = "" ] ; then \
	  echo 'setenv SYNTH_MAP_EFFORT  $(SYNTH_MAP_EFFORT)' >> run_synth.tcsh ; fi
	@if [ ! "$(SYNTH_AREA_EFFORT)" = "" ] ; then \
	  echo 'setenv SYNTH_AREA_EFFORT  $(SYNTH_AREA_EFFORT)' >> run_synth.tcsh ; fi
	@if [ ! "$(SYNTH_TCLK_PERIOD)" = "" ] ; then \
	  echo 'setenv SYNTH_TCLK_PERIOD  $(SYNTH_TCLK_PERIOD)' >> run_synth.tcsh ; fi
	@(if [ -f $(GLOBAL)/synopsys_shared/dc_shell.csh ]; then \
	  echo '$(GLOBAL)/synopsys_shared/dc_shell.csh -f $(GLOBAL)/synopsys_shared/scr_common/amba.cmd > log/$(TOP_NAME)_$(TEST_METH)_$(HDL_SOURCE)_$(HDL_NETL)_run.log' >> run_synth.tcsh ; \
	else \
	  echo 'dc_shell -f $(GLOBAL)/synopsys_shared/scr_common/amba.cmd > log/$(TOP_NAME)_$(TEST_METH)_$(HDL_SOURCE)_$(HDL_NETL)_run.log' >> run_synth.tcsh ; \
	fi)
	@(if [ "$(HDL_NETL)" = "verilog" ]; then \
	  echo '$(GLOBAL)/synopsys_shared/verilog_net_patch ../verilog/netlist/$(TOP_NAME)_$(TEST_METH)_$(HDL_SOURCE)_net.v' >> run_synth.tcsh ; \
	fi)
	@chmod a+x run_synth.tcsh
	@./run_synth.tcsh

log/$(TOP_NAME)_$(TEST_METH)_verilog_$(HDL_NETL)_synth.log : \
                       scripts/$(TOP_NAME)_scan.cmd \
                       scripts/$(TOP_NAME).scr \
                       scripts/$(TOP_NAME)_pre_sdf.scr \
                       scripts/$(TOP_NAME)_exceptions.scr \
                       $(VERILOG_SOURCE) 
	@if [ ! -d work ] ; then \
	  mkdir work ; fi
	@if [ ! -d db ] ; then \
	  mkdir db ; fi
	@if [ ! -d log ] ; then \
	  mkdir log ; fi
	@if [ ! -d report ] ; then \
	  mkdir report ; fi
	@rm -f run_synth.tcsh
	@echo '#!/bin/tcsh -f' > run_synth.tcsh
	@echo 'setenv TOP_NAME  $(TOP_NAME)' >> run_synth.tcsh
	@echo 'setenv OTHER_NAMES  $(OTHER_NAMES)' >> run_synth.tcsh
	@echo 'setenv COMMON_CELLS  $(COMMON_CELLS)' >> run_synth.tcsh
	@echo 'setenv SPECIAL_CELLS  $(SPECIAL_CELLS)' >> run_synth.tcsh
	@echo 'setenv MODULE_TYPE  $(MODULE_TYPE)' >> run_synth.tcsh
	@echo 'setenv USE_TRISTATES  $(USE_TRISTATES)' >> run_synth.tcsh
	@echo 'setenv USE_LATCHES  $(USE_LATCHES)' >> run_synth.tcsh
	@if [ ! "$(CPU_TOP_NAME)" = "" ] ; then \
	  echo 'setenv CPU_TOP_NAME  $(CPU_TOP_NAME)' >> run_synth.tcsh ; fi
	@if [ ! "$(CPU_LIB_MAX)" = "" ] ; then \
	  echo 'setenv CPU_LIB_MAX  $(CPU_LIB_MAX)' >> run_synth.tcsh ; fi
	@if [ ! "$(CPU_LIB_MIN)" = "" ] ; then \
	  echo 'setenv CPU_LIB_MIN  $(CPU_LIB_MIN)' >> run_synth.tcsh ; fi
	@if [ ! "$(CPU_LIB_AREA)" = "" ] ; then \
	  echo 'setenv CPU_LIB_AREA  $(CPU_LIB_AREA)' >> run_synth.tcsh ; fi
	@if [ ! "$(FULLDB)" = "" ] ; then \
	  echo 'setenv FULLDB  $(FULLDB)' >> run_synth.tcsh ; fi
	@if [ ! "$(SYNTH_MAP_EFFORT)" = "" ] ; then \
	  echo 'setenv SYNTH_MAP_EFFORT  $(SYNTH_MAP_EFFORT)' >> run_synth.tcsh ; fi
	@if [ ! "$(SYNTH_AREA_EFFORT)" = "" ] ; then \
	  echo 'setenv SYNTH_AREA_EFFORT  $(SYNTH_AREA_EFFORT)' >> run_synth.tcsh ; fi
	@if [ ! "$(SYNTH_TCLK_PERIOD)" = "" ] ; then \
	  echo 'setenv SYNTH_TCLK_PERIOD  $(SYNTH_TCLK_PERIOD)' >> run_synth.tcsh ; fi
	@(if [ -f $(GLOBAL)/synopsys_shared/dc_shell.csh ]; then \
	  echo '$(GLOBAL)/synopsys_shared/dc_shell.csh -f $(GLOBAL)/synopsys_shared/scr_common/amba.cmd > log/$(TOP_NAME)_$(TEST_METH)_$(HDL_SOURCE)_$(HDL_NETL)_run.log' >> run_synth.tcsh ; \
	else \
	  echo 'dc_shell -f $(GLOBAL)/synopsys_shared/scr_common/amba.cmd > log/$(TOP_NAME)_$(TEST_METH)_$(HDL_SOURCE)_$(HDL_NETL)_run.log' >> run_synth.tcsh ; \
	fi)
	@(if [ "$(HDL_NETL)" = "verilog" ]; then \
	  echo '$(GLOBAL)/synopsys_shared/verilog_net_patch ../verilog/netlist/$(TOP_NAME)_$(TEST_METH)_$(HDL_SOURCE)_net.v' >> run_synth.tcsh ; \
	fi)
	@chmod a+x run_synth.tcsh
	@./run_synth.tcsh

################################ End ###################################
