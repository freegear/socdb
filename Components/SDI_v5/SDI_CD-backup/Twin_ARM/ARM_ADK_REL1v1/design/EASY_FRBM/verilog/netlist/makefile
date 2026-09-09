#- --=========================================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2001 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#- -----------------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name              : makefile,v
#- File Revision          : 1.3
#-
#- Release Information    : ADK_REL1v1
#-
#- -----------------------------------------------------------------------------
#- Purpose :
#-           ADK makefile, compiles verilog netlist for $SIMULATOR
#-
#- --=========================================================================--

MODULES = $(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_net.v

PERIPH = EASY_FRBM

include $(ADK)/design/$(PERIPH)/Components_$(PERIPH).mk

include $(GLOBAL)/$(SIMULATOR)/RtlMakefile.mk

#################################### End #######################################
