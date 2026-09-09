#- --=========================================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2000-2001 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#-------------------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name              : makefile,v
#- File Revision          : 1.1
#-
#- Release Information    : ADK_REL1v1
#-
#-------------------------------------------------------------------------------
#-  Purpose  : 
#-             ADK makefile, compiles behavioural vhdl for $SIMULATOR
#-
#- --=========================================================================--

MODULES = EASY_ARM7_$(TEST_METH)_$(HDL_SOURCE)_net.v

PERIPH =  EASY_ARM7

include $(ADK)/design/$(PERIPH)/Components_$(PERIPH).mk

include $(GLOBAL)/$(SIMULATOR)/RtlMakefile.mk

#################################### End #######################################
