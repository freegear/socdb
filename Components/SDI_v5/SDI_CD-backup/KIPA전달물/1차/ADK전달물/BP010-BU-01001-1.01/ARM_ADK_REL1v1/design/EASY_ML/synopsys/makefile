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
#- File Name              : makefile,v
#- File Revision          : 1.4
#-
#- Release Information    : ADK_REL1v1
#-
#- ---------------------------------------------------------------------
#- Purpose :
#-           ADK makefile, build netlist using synopsys
#-
#- --=================================================================--

# Note: If make is run with the -e option, these variables 
# will get overidden by environment variables.

VERILOG_SOURCE = ../verilog/rtl_source/*.v
VHDL_SOURCE    = ../vhdl/rtl_source/*.vhd

PERIPH         = EASY_ML
TOP_NAME       = EASY_ML
OTHER_NAMES    = "Inport0 Inport1 Outport0 Outport1 Outport2"
COMMON_CELLS   = "Lite2AHB"
SPECIAL_CELLS  = ""
MODULE_TYPE    = Structural
USE_TRISTATES  = off
USE_LATCHES    = off
CPU_LIB_MAX    = ARM922T_generic_ss_max.db
CPU_LIB_MIN    = ARM922T_generic_ff_min.db
CPU_LIB_AREA   = "../../A922T/synopsys/cell_lib"
SYNTH_MAP_EFFORT  = high
# 10ns clock period -> 100MHz bus operation for ARM922T
SYNTH_TCLK_PERIOD = 10

netlist : log/$(TOP_NAME)_$(TEST_METH)_$(HDL_SOURCE)_$(HDL_NETL)_synth.log

include $(ADK)/design/$(PERIPH)/Components_$(TOP_NAME).mk

include $(GLOBAL)/synopsys_shared/StructSynMakefile.mk

################################ End ###################################
