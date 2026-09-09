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
#- File Revision          : 1.4
#-
#- Release Information    : ADK_REL1v1
#-
#-------------------------------------------------------------------------------
#-  Purpose  : 
#-             ADK makefile, compiles behavioural vhdl for $SIMULATOR
#-
#- --=========================================================================--

MODULES = $(GLOBAL)/vhdl/Lite2AHB.vhd \
          Inport0.vhd \
          Inport1.vhd \
          Outport0.vhd \
          Outport1.vhd \
          Outport2.vhd \
          EASY_ML.vhd

PERIPH =  EASY_ML

include $(ADK)/design/$(PERIPH)/Components_$(PERIPH).mk

include $(GLOBAL)/$(SIMULATOR)/RtlMakefile.mk

#################################### End #######################################
