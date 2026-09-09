#- --=========================================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2000-2001 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#- -----------------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name              : makefile.rca
#- File Revision          : 1.7
#-
#- Release Information    : PrimeCell(TM)-PL092-REL1v1
#-
#- -----------------------------------------------------------------------------
#- Purpose :
#-           A makefile to build TicTalk vectors
#-
#- --=========================================================================--

#- -----------------------------------------------------------------------------
#- The same makefile can be used to generate .tif, .bif and .sim vector files
#- from the BusTalk source code.
#
#- To generate .tif and .sim vectors set VECT_TYPE = TIF.
#-
#- To generate .bif and .sim vectors set VECT_TYPE = BIF.
#-
#- To generate .bif,.tif and .sim vectors don't set VECT_TYPE.
#-
#- -----------------------------------------------------------------------------

VECT_TYPE = TIF

TransferTests :
	make DEFINES="-D transfertests" $(PERIPH)

ResponseTests :
	make DEFINES="-D responsetests" $(PERIPH)

#- To include all test vectors use the 'make all' option

include $(GLOBAL)/bustalk_ahb/bustest/BusTalkMakefile.mk

#- --================================= End ===================================--
