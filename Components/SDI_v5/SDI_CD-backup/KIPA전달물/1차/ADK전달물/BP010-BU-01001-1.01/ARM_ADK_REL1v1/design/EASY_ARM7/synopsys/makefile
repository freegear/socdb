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

PERIPH         = EASY_ARM7
TOP_NAME       = EASY_ARM7
OTHER_NAMES    = ""
COMMON_CELLS   = "Lite2AHB"
SPECIAL_CELLS  = ""
MODULE_TYPE    = Structural
USE_TRISTATES  = off
USE_LATCHES    = off
CPU_LIB_MAX    = arm7tdmir3_generic_66.max.ss.db
CPU_LIB_MIN    = arm7tdmir3_generic_66.min.ff.db
CPU_LIB_AREA   = "../../A7TDMI/synopsys/cell_lib"
# 20ns clock period -> 50MHz bus operation for ARM7TDMI
SYNTH_TCLK_PERIOD = 20

netlist : log/$(TOP_NAME)_$(TEST_METH)_$(HDL_SOURCE)_$(HDL_NETL)_synth.log

include $(ADK)/design/$(PERIPH)/Components_$(TOP_NAME).mk

include $(GLOBAL)/synopsys_shared/StructSynMakefile.mk

################################ End ###################################
