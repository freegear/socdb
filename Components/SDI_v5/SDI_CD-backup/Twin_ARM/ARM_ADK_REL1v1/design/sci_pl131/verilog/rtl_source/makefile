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

MODULES = $(GLOBAL)/verilog/ SciTxRx.v SciTxRegFile.v SciTxFIFO.v SciTxFCntl.v \
SciTest.v SciSynctoSCICLK.v SciSynctoPCLK.v SciRxRegFile.v SciRxFIFO.v \
SciRxFCntl.v SciRevAnd.v SciRegBlkUpdate.v SciRegBlk.v SciIntGen.v SciDMA.v \
SciCntl.v SciApbif.v Sci.v 

PERIPH = sci_pl131

include $(GLOBAL)/$(SIMULATOR)/RtlMakefile.mk

#################################### End #######################################
