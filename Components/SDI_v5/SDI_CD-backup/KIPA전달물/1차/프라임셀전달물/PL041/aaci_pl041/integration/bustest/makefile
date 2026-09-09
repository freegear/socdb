#- --=================================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2000 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#- ---------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name              : makefile.rca
#- File Revision          : 1.4
#-
#- Release Information    : PrimeCell(TM)-PL041-REL1v0
#-
#- ---------------------------------------------------------------------
#- Purpose :
#-           A makefile to build .tif and .sim formatted vectors 
#-           from the source 'C' code.
#-
#- --=================================================================--

VECT_TYPE = TIF

IntegrationTest :  
	make DEFINES="-D integrationtest" $(PERIPH)

AddrRangeTest :  
	make DEFINES="-D addrrangetest" $(PERIPH)

RegisterTest : 
	make DEFINES="-D registertest" $(PERIPH)

include $(GLOBAL)/bustalk_apb/bustest/BusTalkMakefile.mk

################################ End ###################################
