#- --=========================================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2001-2002 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#-------------------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name              : makefile.rca
#- File Revision          : 1.30
#-
#- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
#-
#-------------------------------------------------------------------------------
#-  Purpose  : 
#-             Standard Verilog Library Makefile
#-
#- --=========================================================================--

MODULES = MpmcRegIf.v \
          MpmcAhbif.v \
          MpmcEndian.v \
          MpmcAhbTop.v \
          MpmcArbiter.v \
          MpmcBuffer.v \
          MpmcBufCntrl.v \
          MpmcBufUnit.v \
          MpmcStRegBlk.v \
          MpmcStTSM.v \
          MpmcStExtIf.v \
          MpmcStIntIf.v \
          MpmcStTimCntl.v \
          MpmcStMemCntl.v \
          MpmcDyRegBlk.v \
          MpmcDyRegFile.v \
          MpmcDyFCntl.v \
          MpmcDyFBtoH.v \
          MpmcDyFIFO.v \
          MpmcDyIntRegBlk.v \
          MpmcDyIntRdGen.v \
          MpmcDyAxsSM1.v \
          MpmcDyAxsSM2.v \
          MpmcDyRefSM.v \
          MpmcDyModSM.v \
          MpmcDySyFlash.v \
          MpmcDyLatCntr.v \
          MpmcDyMemCntl.v \
          MpmcMemCntlIf.v \
          MpmcMemBGnt.v \
          MpmcMemCntl.v \
          MpmcPadIf.v \
          MpmcRevAnd.v \
          MpmcClockOr.v \
          MpmcCore.v \
          MpmcTIC.v \
          Mpmc.v

include $(GLOBAL)/$(SIMULATOR)/RtlMakefile.mk

#################################### End #######################################
