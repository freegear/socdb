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
#- File Revision          : 1.6
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

PERIPH         = ElementsAHB
TOP_NAME       = MuxM2S
OTHER_NAMES    = ""
COMMON_CELLS   = ""
SPECIAL_CELLS  = ""
MODULE_TYPE    = Other
USE_TRISTATES  = off
USE_LATCHES    = off

netlist :
	$(MAKE) TOP_NAME=MuxM2S component
	$(MAKE) TOP_NAME=MuxS2M component
	$(MAKE) TOP_NAME=Arbiter3 OTHER_NAMES=ArbSchm3 component
	$(MAKE) TOP_NAME=Decoder component
	$(MAKE) TOP_NAME=DefaultSlave MODULE_TYPE=AHB_Slave component


component : log/$(TOP_NAME)_$(TEST_METH)_$(HDL_SOURCE)_$(HDL_NETL)_synth.log

include $(GLOBAL)/synopsys_shared/SynMakefile.mk

################################ End ###################################
