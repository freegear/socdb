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
#- File Revision          : 1.6
#-
#- Release Information    : PrimeCell(TM)-PL190-REL1v1
#-
#- ---------------------------------------------------------------------
#- Purpose :
#-           A makefile to build BusTalk vectors 
#- --=================================================================--

#- ---------------------------------------------------------------------
#- The same makefile can be used to generate .tif, .bif and .sim 
#- vector files from the BusTalk source code.
#-
#- To generate .tif and .sim vectors set VECT_TYPE = TIF.
#- 
#- To generate .bif and .sim vectors set VECT_TYPE = BIF.
#-                                        
#- To generate .bif, .tif and .sim vectors don't set VECT_TYPE.
#-                                        
#- ---------------------------------------------------------------------

VECT_TYPE = BIF

ResetTests :  
	make DEFINES="-D resettests" $(PERIPH)

RegisterTests :  
	make DEFINES="-D registertests" $(PERIPH)

ProtectionTests :
	make DEFINES="-D protectiontests" $(PERIPH)

ProtModeIntTests :
	make DEFINES="-D protmodeinttests" $(PERIPH)

ErrorRespTests :
	make DEFINES="-D errorresptests" $(PERIPH)

TransferTests :
	make DEFINES="-D transfertests" $(PERIPH)

UserOneIntTests :
	make DEFINES="-D useroneinttests" $(PERIPH)

TwoFourIntTests :
	make DEFINES="-D twofourinttests" $(PERIPH)

EightAllIntTests :
	make DEFINES="-D eightallinttests" $(PERIPH)

CSRTests :
	make DEFINES="-D csrtests" $(PERIPH)

Vic1 :
	 make DEFINES="-D Vic1" $(PERIPH)

Vic2 :
	 make DEFINES="-D Vic2" $(PERIPH)

include $(GLOBAL)/bustalk_ahb/bustest/BusTalkMakefile.mk

################################ End ###################################
