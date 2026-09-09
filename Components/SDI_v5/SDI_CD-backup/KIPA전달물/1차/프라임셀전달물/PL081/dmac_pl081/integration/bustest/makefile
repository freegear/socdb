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
#- File Revision          : 1.3
#-
#- Release Information    : PrimeCell(TM)-PL081-REL1v0
#-
#- -----------------------------------------------------------------------------
#- Purpose :
#-           A makefile to build .tif and .sim formatted vectors
#-           from the source 'C' code.
#-
#- --=========================================================================--

#- -----------------------------------------------------------------------------
#- The same makefile can be used to generate .tif, .bif and .sim 
#- vector files from the BusTalk source code.
#-
#- To generate .tif and .sim vectors set VECT_TYPE = TIF.
#- 
#- -----------------------------------------------------------------------------

VECT_TYPE = TIF

ResetTests :  
	make DEFINES="-D resettests" $(PERIPH)

RegisterTests :  
	make DEFINES="-D registertests" $(PERIPH)

IntM2MTests :
	make DEFINES="-D intm2mtests" $(PERIPH)

IntegrationTest :
	make DEFINES="-D integrationtest" $(PERIPH)

include $(GLOBAL)/bustalk_ahb/bustest/BusTalkMakefile.mk

#################################### End #######################################
