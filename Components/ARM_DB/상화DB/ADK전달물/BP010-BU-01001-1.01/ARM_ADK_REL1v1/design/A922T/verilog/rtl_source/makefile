#- --=========================================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2001 ARM Limited
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
#-  Purpose  : ADK makefile, compiles verilog rtl for $SIMULATOR
#-
#- --=========================================================================--

MODULES = $(GLOBAL)/verilog/ClockInv.v \
          $(GLOBAL)/verilog/LATR.v \
          A920TWrapMaster.v \
          A920TWrapSM.v \
          A920TWrapSlave.v \
          A920TWrap.v \
          A922T.v

PERIPH =  A922T

include $(GLOBAL)/$(SIMULATOR)/RtlMakefile.mk

#################################### End #######################################
