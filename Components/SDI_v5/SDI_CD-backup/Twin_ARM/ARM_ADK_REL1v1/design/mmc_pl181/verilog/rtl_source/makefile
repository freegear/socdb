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
#-  Purpose  : 
#-             ADK makefile, compiles verilog rtl for $SIMULATOR
#-
#- --=========================================================================--

MODULES = $(GLOBAL)/verilog/ MmciSynctoMCLK.v MmciSynctoPCLK.v  \
       MmciRevAnd.v  MmciRegUpd.v MmciPwrClkCtr.v MmciOPReSync.v \
       MmciIntGen.v MmciFifoDmaCtr.v MmciFIFOReg.v MmciDPSM.v MmciClockMux.v \
       MmciClockAnd.v MmciCPSM.v MmciApbifReg.v Mmci.v

PERIPH = mmc_pl181

include $(GLOBAL)/$(SIMULATOR)/RtlMakefile.mk

#################################### End #######################################
