#- --=========================================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2000 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#- -----------------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name              : makefile.rca
#- File Revision          : 1.2
#-
#- Release Information    : PrimeCell(TM)-PL181-REL1v0
#-
#- -----------------------------------------------------------------------------
#- Purpose : 
#-           A makefile to build TicTalk vectors 
#-           The same makefile can be used to generate .tif and .sim 
#-           vector files from the BusTalk source code.
#-
#- --=========================================================================--

VECT_TYPE = TIF

IntegrationTest :  
	make DEFINES="-D integrationtest" $(PERIPH)

ResetRead :  
	make DEFINES="-D resetread" $(PERIPH)

include $(GLOBAL)/bustalk_apb/bustest/BusTalkMakefile.mk

#################################### End #######################################
