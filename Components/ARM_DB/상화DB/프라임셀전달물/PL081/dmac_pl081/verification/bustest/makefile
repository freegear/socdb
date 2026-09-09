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
#- File Revision          : 1.5
#-
#- Release Information    : PrimeCell(TM)-PL081-REL1v0
#-
#- -----------------------------------------------------------------------------
#- Purpose :
#-           A makefile to build BusTalk vectors 
#- --=========================================================================--

#- -----------------------------------------------------------------------------
#- The same makefile can be used to generate .tif, .bif and .sim 
#- vector files from the BusTalk source code.
#-
#- To generate .tif and .sim vectors set VECT_TYPE = TIF.
#- 
#- To generate .bif and .sim vectors set VECT_TYPE = BIF.
#-                                        
#- To generate .bif, .tif and .sim vectors don't set VECT_TYPE.
#-                                        
#- -----------------------------------------------------------------------------

VECT_TYPE = BIF

ResetTests :  
	make DEFINES="-D resettests" $(PERIPH)

RegisterTests :  
	make DEFINES="-D registertests" $(PERIPH)

EnabledChannelTests :  
	make DEFINES="-D enabledchanneltests" $(PERIPH)

M2MTests :
	make DEFINES="-D m2mtests" $(PERIPH)

P2MTests :
	make DEFINES="-D p2mtests" $(PERIPH)

M2PTests :
	make DEFINES="-D m2ptests" $(PERIPH)

P2PTests :
	make DEFINES="-D p2ptests" $(PERIPH)

TwoChTests :
	make DEFINES="-D twochtests" $(PERIPH)

#FourChTests :
#	make DEFINES="-D fourchtests" $(PERIPH)

#EightChTests :
#	make DEFINES="-D eightchtests" $(PERIPH)

LLITests     :
	make DEFINES="-D dmacllitests" $(PERIPH)


HaltDisTests :
	make DEFINES="-D dmachaltdistests" $(PERIPH)

IntTests :
	make DEFINES="-D inttests" $(PERIPH)

MasTest :
	make DEFINES="-D mastest" $(PERIPH)

CornerTests :
	make DEFINES="-D cornertests" $(PERIPH)

CornerTests2 :
	make DEFINES="-D cornertests2" $(PERIPH)

include $(GLOBAL)/bustalk_ahb/bustest/BusTalkMakefile.mk

#################################### End #######################################



