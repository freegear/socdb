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
#- File Revision          : 1.3
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

VERILOG_SOURCE    = ../verilog/rtl_source/*.v
VHDL_SOURCE       = ../vhdl/rtl_source/*.vhd

PERIPH            = A7TDMI
TOP_NAME          = A7TWrap
OTHER_NAMES       = "A7WrapSM A7WrapMaster A7TWrapCtrl A7TWrapTest"
COMMON_CELLS      = ""
SPECIAL_CELLS     = "ClockNand ClockInv LATS"
MODULE_TYPE       = CPU_Wrapper 
USE_TRISTATES     = off
USE_LATCHES       = on
CPU_TOP_NAME      = A7TDMI
CPU_LIB_MAX       = arm7tdmir3_generic_66.max.ss.db
CPU_LIB_MIN       = arm7tdmir3_generic_66.min.ff.db
CPU_LIB_AREA      = "cell_lib"
SYNTH_MAP_EFFORT  = high
SYNTH_AREA_EFFORT = high
# 20ns clock period -> 50MHz bus operation for ARM7TDMI
SYNTH_TCLK_PERIOD = 20

netlist : log/$(TOP_NAME)_$(TEST_METH)_$(HDL_SOURCE)_$(HDL_NETL)_synth.log

include $(GLOBAL)/synopsys_shared/SynMakefile.mk

################################ End ###################################
