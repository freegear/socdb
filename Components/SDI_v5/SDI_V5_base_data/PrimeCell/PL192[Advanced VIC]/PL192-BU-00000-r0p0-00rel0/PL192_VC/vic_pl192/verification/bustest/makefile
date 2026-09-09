#- --=========================================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2002 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#- -----------------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name              : makefile.rca
#- File Revision          : 1.8
#-
#- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
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

ProtectionTests :
	make DEFINES="-D protectiontests" $(PERIPH)

ProtModeIntTests :
	make DEFINES="-D protmodeinttests" $(PERIPH)

ErrorRespTests :
	make DEFINES="-D errorresptests" $(PERIPH)

TransferTests :
	make DEFINES="-D transfertests" $(PERIPH)

UserOneIntTests7 :
	make DEFINES="-D useroneinttests7" $(PERIPH)

UserOneIntTests6 :
	make DEFINES="-D useroneinttests6" $(PERIPH)

UserOneIntTests5 :
	make DEFINES="-D useroneinttests5" $(PERIPH)

UserOneIntTests4 :
	make DEFINES="-D useroneinttests4" $(PERIPH)

UserOneIntTests3 :
	make DEFINES="-D useroneinttests3" $(PERIPH)

UserOneIntTests2 :
	make DEFINES="-D useroneinttests2" $(PERIPH)

UserOneIntTests1 :
	make DEFINES="-D useroneinttests1" $(PERIPH)

UserOneIntTests0 :
	make DEFINES="-D useroneinttests0" $(PERIPH)

TwoFourIntTests :
	make DEFINES="-D twofourinttests" $(PERIPH)

EightAllIntTests :
	make DEFINES="-D eightallinttests" $(PERIPH)

AllIntTest :
	make DEFINES="-D allinttest" $(PERIPH)

VicEnAllIntTest :
	make DEFINES="-D vicenallinttest" $(PERIPH)

VicEnTwoFourIntTests :
	make DEFINES="-D vicentwofourinttests" $(PERIPH)

VicEnEightAllIntTests :
	make DEFINES="-D viceneightallinttests" $(PERIPH)

Stack16Test :
	make DEFINES="-D stack16test" $(PERIPH)

VicEnStack16Test :
	make DEFINES="-D vicenstack16test" $(PERIPH)

RandomTest :
	make DEFINES="-D randomtest" $(PERIPH)

VicEnUserOneIntTests7 :
	make DEFINES="-D vicenuseroneinttests7" $(PERIPH)

VicEnUserOneIntTests6 :
	make DEFINES="-D vicenuseroneinttests6" $(PERIPH)

VicEnUserOneIntTests5 :
	make DEFINES="-D vicenuseroneinttests5" $(PERIPH)

VicEnUserOneIntTests4 :
	make DEFINES="-D vicenuseroneinttests4" $(PERIPH)

VicEnUserOneIntTests3 :
	make DEFINES="-D vicenuseroneinttests3" $(PERIPH)

VicEnUserOneIntTests2 :
	make DEFINES="-D vicenuseroneinttests2" $(PERIPH)

VicEnUserOneIntTests1 :
	make DEFINES="-D vicenuseroneinttests1" $(PERIPH)

VicEnUserOneIntTests0 :
	make DEFINES="-D vicenuseroneinttests0" $(PERIPH)

ClockOffTest :
	make DEFINES="-D clockofftest" $(PERIPH)

VicSyncEnTest :
	make DEFINES="-D vicsyncentest" $(PERIPH)

VicEnDaisyPriTest :
	make DEFINES="-D vicendaisypritest" $(PERIPH)

PriConsistency :
	make DEFINES="-D priconsistency" $(PERIPH)

Vic1 :
	make DEFINES="-D Vic1" $(PERIPH)

Vic2 :
	make DEFINES="-D Vic2" $(PERIPH)

Vic3 :
	make DEFINES="-D Vic3" $(PERIPH)

include $(GLOBAL)/bustalk_ahb/bustest/BusTalkMakefile.mk

#################################### End #######################################
