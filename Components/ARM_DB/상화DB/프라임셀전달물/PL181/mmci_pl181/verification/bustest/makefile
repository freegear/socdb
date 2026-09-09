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
#- File Revision          : 1.3
#-
#- Release Information    : PrimeCell(TM)-PL181-REL1v0
#-
#- -----------------------------------------------------------------------------
#- Purpose : 
#-           A makefile to build BusTalk vectors.
#-           The same makefile can be used to generate .bif and .sim 
#-           vector files from the BusTalk source code.
#-
#- --=========================================================================--

VECT_TYPE = BIF

CPSMDisableTest :
	make DEFINES="-D cpsmdisabletest" $(PERIPH)

ClockTest :
	make DEFINES="-D clocktest" $(PERIPH)

CommandFSMTestCall :
	make DEFINES="-D commandfsmtestcall" $(PERIPH)

DMATest :
	make DEFINES="-D dmatest" $(PERIPH)

DPSMDisableTest :
	make DEFINES="-D dpsmdisabletest" $(PERIPH)

DataCounterTest :
	make DEFINES="-D datacountertest" $(PERIPH)

DataFlagSyncTest :
	make DEFINES="-D dataflagsynctest" $(PERIPH)

DivlevelCpsmStSyncTest :
	make DEFINES="-D divlevelcpsmstsynctest" $(PERIPH)

FIFOReceiveTest :
	make DEFINES="-D fiforeceivetest" $(PERIPH)

FIFOTransmitTest :
	make DEFINES="-D fifotransmittest" $(PERIPH)

FifoCounterTest :
	make DEFINES="-D fifocountertest" $(PERIPH)

FifoPtrCrossOverTest :
	make DEFINES="-D fifoptrcrossovertest" $(PERIPH)

InterruptTests :
	make DEFINES="-D interrupttests" $(PERIPH)

PendingModeTest :
	make DEFINES="-D pendingmodetest" $(PERIPH)

PowerControlTest :
	make DEFINES="-D powercontroltest" $(PERIPH)

RxOverruninWaitRTest :
	make DEFINES="-D rxoverruninwaitrtest" $(PERIPH)

RegTests :  
	make DEFINES="-D regtests" $(PERIPH)

BlockLengthTest :  
	make DEFINES="-D blocklengthtest" $(PERIPH)

TxDataFSMTestCall :
	make DEFINES="-D txdatafsmtestcall" $(PERIPH)

RxDataFSMTestCall :
	make DEFINES="-D rxdatafsmtestcall" $(PERIPH)

Mmci1 :
	make DEFINES="-D Mmci1" $(PERIPH)

Mmci2 :
	make DEFINES="-D Mmci2" $(PERIPH)

Mmci3 :
	make DEFINES="-D Mmci3" $(PERIPH)

include $(GLOBAL)/bustalk_apb/bustest/BusTalkMakefile.mk

############################### End of file ####################################
