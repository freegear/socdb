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

MODULES = $(GLOBAL)/verilog/ SspTxRegFile.v SspTxLJustify.v \
SspTxFIFO.v SspTxFCntl.v SspTest.v SspSynctoSSPCLK.v SspSynctoPCLK.v \
SspScaleCntr.v SspSTxRxCntl.v  SspRxRegFile.v SspRxFIFO.v SspRxFCntl.v \
SspRevAnd.v SspRegCore.v SspMTxRxCntl.v SspIntGen.v \
SspDataStp.v SspDMA.v SspApbif.v Ssp.v

PERIPH = ssp_pl022

include $(GLOBAL)/$(SIMULATOR)/RtlMakefile.mk

#################################### End #######################################
