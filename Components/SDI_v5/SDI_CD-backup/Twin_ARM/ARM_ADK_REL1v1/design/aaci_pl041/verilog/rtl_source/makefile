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

MODULES = $(GLOBAL)/verilog/ AaciTxRegFile.v AaciTxFCntl.v AaciTxCntl.v \
AaciTxChannel.v AaciTmgCntl.v AaciSlot0Gen.v AaciRxRegFile.v \
AaciRxFCntl.v AaciRxCntl.v AaciRxChannel.v AaciRevAnd.v AaciPtoBSync.v \
AaciIntrGen.v AaciFrmGen.v AaciFrmDec.v AaciDMATxFCntl.v AaciDMATChannel.v \
AaciDMARxFCntl.v AaciDMARChannel.v AaciBtoPSync.v AaciApbifReg.v Aaci.v \

PERIPH = aaci_pl041

include $(GLOBAL)/$(SIMULATOR)/RtlMakefile.mk

#################################### End #######################################
