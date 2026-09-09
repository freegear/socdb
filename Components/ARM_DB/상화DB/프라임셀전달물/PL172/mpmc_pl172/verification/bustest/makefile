#- --=========================================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2001-2002 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#- -----------------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name              : makefile.rca
#- File Revision          : 1.13
#-
#- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
#-
#- -----------------------------------------------------------------------------
#- Purpose :
#-           A makefile to build BusTalk vectors for MPMC
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

POResetTest :  
	make INFILE=3 DEFINES="-D poresettest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

HResetTest:
	make INFILE=3 DEFINES="-D hresettest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

MpmcRegisterTests:
	make INFILE=3 DEFINES="-D mpmcregistertests" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

MPMCEnableTest :
	make INFILE=3 DEFINES="-D mpmcenabletest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

ControllerBusyTest :
	make INFILE=3 DEFINES="-D controllerbusytest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

LowPwrModeTest :
	make INFILE=3 DEFINES="-D lowpwrmodetest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

AddrToggleTest :  
	make INFILE=3 DEFINES="-D addrtoggletest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

AddrMirrTest :  
	make INFILE=3 DEFINES="-D addrmirrtest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

CSPolarityTest :
	make INFILE=3 DEFINES="-D cspolaritytest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

ClkCtrlTest :
	make INFILE=3 DEFINES="-D clkctrltest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

ClkEnableTest :
	make INFILE=3 DEFINES="-D clkenabletest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

ROMTest :
	make INFILE=3 DEFINES="-D romtest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

DelayValueTests :
	make INFILE=3 DEFINES="-D delayvaluetests" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

StWtPgTest:
	make INFILE=3 DEFINES="-D stwtpgtest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

StWtPgBufEnTest:
	make INFILE=3 DEFINES="-D stwtpgbufentest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

BLSDelayValueTests :
	make INFILE=3 DEFINES="-D blsdelayvaluetests" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

ExdWaitDelTest:
	make INFILE=3 DEFINES="-D exdwaitdeltest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

EndiannessTests :
	make INFILE=3 DEFINES="-D endiannesstests" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

BigEndianPinTest :
	make INFILE=3 DEFINES="-D bigendianpintest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

BusyInsertionTest :
	make INFILE=3 DEFINES="-D busyinsertiontest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

BusDegrantTest :
	make INFILE=3 DEFINES="-D busdegranttest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

SdramInitRtnChk :
	make INFILE=3 DEFINES="-D sdraminitrtnchk" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

LowPwrSdramFunTest :
	make INFILE=3 DEFINES="-D lowpwrsdramfuntest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

RefFreqChk :
	make INFILE=3 DEFINES="-D reffreqchk" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

SelfRefChk :
	make INFILE=3 DEFINES="-D selfrefchk" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

SelRefPriorityTest :
	make INFILE=3 DEFINES="-D selrefprioritytest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

WrProtTest :
	make INFILE=3 DEFINES="-D wrprottest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

RdRefAlnTest :
	make INFILE=3 DEFINES="-D rdrefalntest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

BankCrossTest:
	make INFILE=3 DEFINES="-D bankcrosstest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

WriteMisMatchTest :
	make INFILE=3 DEFINES="-D writemismatchtest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

SyncFlashTest:
	make INFILE=3 DEFINES="-D syncflashtest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

HburstTest :
	make INFILE=3 DEFINES="-D hbursttest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

RandHburstTest :
	make INFILE=3 DEFINES="-D randhbursttest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

RandHburstTest1 :
	make INFILE=3 DEFINES="-D randhbursttest1" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

RandHburstTest2 :
	make INFILE=3 DEFINES="-D randhbursttest2" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

TransferTest:
	make INFILE=3 DEFINES="-D transfertest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

CornerCases1 :
	make INFILE=3 DEFINES="-D cornercases1" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

CornerCases2 :
	make INFILE=3 DEFINES="-D cornercases2" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

CornerCases3 :
	make INFILE=3 DEFINES="-D cornercases3" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

CornerCases4 :
	make INFILE=3 DEFINES="-D cornercases4" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

CornerCases5 :
	make INFILE=3 DEFINES="-D cornercases5" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

CornerCases6 :
	make INFILE=3 DEFINES="-D cornercases6" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

CornerCases7 :
	make INFILE=3 DEFINES="-D cornercases7" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D cornercases7" $(PERIPH)

CornerCases8 :
	make INFILE=3 DEFINES="-D cornercases8" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D cornercases8" $(PERIPH)

StBufFlushTest:
	make INFILE=3 DEFINES="-D stbufflushtest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

DyBufFlushTest:
	make INFILE=3 DEFINES="-D dybufflushtest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

Arb2DyWrRd:
	make INFILE=3 DEFINES="-D arb2dywrrd" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D arb2dywrrd" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)

RandomTest1:
	make INFILE=3 DEFINES="-D randomtest1" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

BigEndHburstTest:
	make INFILE=3 DEFINES="-D bigendhbursttest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

DyHburstTest1:
	make INFILE=3 DEFINES="-D dyhbursttest1" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

DyHburstTest2:
	make INFILE=3 DEFINES="-D dyhbursttest2" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

DyHburstTestTB5:
	make INFILE=3 DEFINES="-D dyhbursttesttb5" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

DyHburstTestTB7:
	make INFILE=3 DEFINES="-D dyhbursttesttb7" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

DyHburstTestTB8:
	make INFILE=3 DEFINES="-D dyhbursttesttb8" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

DyHburstTestTB9:
	make INFILE=3 DEFINES="-D dyhbursttesttb9" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

DyHburstTestTB10:
	make INFILE=3 DEFINES="-D dyhbursttesttb10" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

DyHburstClkRatTB7Test:
	make INFILE=3 DEFINES="-D dyhburstclkrattb7test" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

DyHburstClkRatTB8Test:
	make INFILE=3 DEFINES="-D dyhburstclkrattb8test" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

DyHburstClkRatTB9Test:
	make INFILE=3 DEFINES="-D dyhburstclkrattb9test" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

MemModelHburstTest:
	make INFILE=3 DEFINES="-D memmodelhbursttest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

Arb2CornerCase4:
	make INFILE=3 DEFINES="-D arb2cornercase4" $(PERIPH)
	make INFILE=2 DEFINES="-D arb2cornercase4" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

Arb2DyStWrRd:
	make INFILE=3 DEFINES="-D arb2dystwrrd" $(PERIPH)
	make INFILE=1 DEFINES="-D arb2dystwrrd" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

Arb2StWrRd:
	make INFILE=3 DEFINES="-D arb2stwrrd" $(PERIPH)
	make INFILE=2 DEFINES="-D arb2stwrrd" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

Arb3DyWrRd :
	make INFILE=3 DEFINES="-D arb3dywrrd" $(PERIPH)
	make INFILE=2 DEFINES="-D arb3dywrrd" $(PERIPH)
	make INFILE=0 DEFINES="-D arb3dywrrd" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)

Arb3StWrRd:
	make INFILE=3 DEFINES="-D arb3stwrrd" $(PERIPH)
	make INFILE=2 DEFINES="-D arb3stwrrd" $(PERIPH)
	make INFILE=1 DEFINES="-D arb3stwrrd" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

Arb4DyStWrRd:
	make INFILE=3 DEFINES="-D arb4dystwrrd" $(PERIPH)
	make INFILE=2 DEFINES="-D arb4dystwrrd" $(PERIPH)
	make INFILE=1 DEFINES="-D arb4dystwrrd" $(PERIPH)
	make INFILE=0 DEFINES="-D arb4dystwrrd" $(PERIPH)

Arb4DyWrRdClkRat:
	make INFILE=3 DEFINES="-D arb4dywrrdclkrat" $(PERIPH)
	make INFILE=2 DEFINES="-D arb4dywrrdclkrat" $(PERIPH)
	make INFILE=1 DEFINES="-D arb4dywrrdclkrat" $(PERIPH)
	make INFILE=0 DEFINES="-D arb4dywrrdclkrat" $(PERIPH)

Arb4DyWrRd :
	make INFILE=3 DEFINES="-D arb4dywrrd" $(PERIPH)
	make INFILE=2 DEFINES="-D arb4dywrrd" $(PERIPH)
	make INFILE=1 DEFINES="-D arb4dywrrd" $(PERIPH)
	make INFILE=0 DEFINES="-D arb4dywrrd" $(PERIPH)

Arb4IdleBusy:
	make INFILE=3 DEFINES="-D arb4idlebusy" $(PERIPH)
	make INFILE=2 DEFINES="-D arb4idlebusy" $(PERIPH)
	make INFILE=1 DEFINES="-D arb4idlebusy" $(PERIPH)
	make INFILE=0 DEFINES="-D arb4idlebusy" $(PERIPH)

Arb4StWrRd:
	make INFILE=3 DEFINES="-D arb4stwrrd" $(PERIPH)
	make INFILE=2 DEFINES="-D arb4stwrrd" $(PERIPH)
	make INFILE=1 DEFINES="-D arb4stwrrd" $(PERIPH)
	make INFILE=0 DEFINES="-D arb4stwrrd" $(PERIPH)

MemModelStPgModeTest:
	make INFILE=3 DEFINES="-D memmodelstpgmodetest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

MemModelPgROMTest:
	make INFILE=3 DEFINES="-D memmodelpgromtest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

MemModelROMTest:
	make INFILE=3 DEFINES="-D memmodelromtest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

MemModelFlashTest:
	make INFILE=3 DEFINES="-D memmodelflashtest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

Arb3DyStWrRd:
	make INFILE=3 DEFINES="-D arb3dystwrrd" $(PERIPH)
	make INFILE=2 DEFINES="-D arb3dystwrrd" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D arb3dystwrrd" $(PERIPH)

IntegrationTest:
	make INFILE=3 DEFINES="-D integrationtest" $(PERIPH)
	make INFILE=2 DEFINES="-D integrationtest" $(PERIPH)
	make INFILE=1 DEFINES="-D integrationtest" $(PERIPH)
	make INFILE=0 DEFINES="-D integrationtest" $(PERIPH)

DyHburstCmdDelTest1:
	make INFILE=3 DEFINES="-D dyhburstcmddeltest1" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

Rel1HburstTest:
	make INFILE=3 DEFINES="-D rel1hbursttest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

SyncFlashCmdDelTest:
	make INFILE=3 DEFINES="-D syncflashcmddeltest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

Arb2HMastLockTest:
	make INFILE=3 DEFINES="-D arb2hmastlocktest" $(PERIPH)
	make INFILE=2 DEFINES="-D arb2hmastlocktest" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

DirectDyDtFtchTest:
	make INFILE=3 DEFINES="-D directdydtftchtest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

RefreshMissTest:
	make INFILE=3 DEFINES="-D refreshmisstest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

MultiPortWrProtTest:
	make INFILE=3 DEFINES="-D multiportwrprottest" $(PERIPH)
	make INFILE=2 DEFINES="-D multiportwrprottest" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

MultiPortPgAccessTest:
	make INFILE=3 DEFINES="-D multiportpgaccesstest" $(PERIPH)
	make INFILE=0 DEFINES="-D multiportpgaccesstest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)

MultiPortPgAccessTest1:
	make INFILE=3 DEFINES="-D multiportpgaccesstest1" $(PERIPH)
	make INFILE=2 DEFINES="-D multiportpgaccesstest1" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D multiportpgaccesstest1" $(PERIPH)

MultiPortPgAccessTest2:
	make INFILE=3 DEFINES="-D multiportpgaccesstest2" $(PERIPH)
	make INFILE=1 DEFINES="-D multiportpgaccesstest2" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D multiportpgaccesstest2" $(PERIPH)

MultiPortPgAccessTest3:
	make INFILE=3 DEFINES="-D multiportpgaccesstest3" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D multiportpgaccesstest3" $(PERIPH)

MultiPortPgAccessTest4:
	make INFILE=3 DEFINES="-D multiportpgaccesstest4" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D multiportpgaccesstest4" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

MultiPortPgAccessTest5:
	make INFILE=3 DEFINES="-D multiportpgaccesstest5" $(PERIPH)
	make INFILE=2 DEFINES="-D multiportpgaccesstest5" $(PERIPH)
	make INFILE=1 DEFINES="-D multiportpgaccesstest5" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

MultiPortDiffComb1:
	make INFILE=3 DEFINES="-D multiportdiffcomb1" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D multiportdiffcomb1" $(PERIPH)

MultiPortDiffComb2:
	make INFILE=3 DEFINES="-D multiportdiffcomb2" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D multiportdiffcomb2" $(PERIPH)

MultiPortDiffComb3:
	make INFILE=3 DEFINES="-D multiportdiffcomb3" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D multiportdiffcomb3" $(PERIPH)

MultiPortDiffComb4:
	make INFILE=3 DEFINES="-D multiportdiffcomb4" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D multiportdiffcomb4" $(PERIPH)

MultiPortDiffComb5:
	make INFILE=3 DEFINES="-D multiportdiffcomb5" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D multiportdiffcomb5" $(PERIPH)

MultiPortDiffComb6:
	make INFILE=3 DEFINES="-D multiportdiffcomb6" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D multiportdiffcomb6" $(PERIPH)

MultiPortDiffComb7:
	make INFILE=3 DEFINES="-D multiportdiffcomb7" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D multiportdiffcomb7" $(PERIPH)

MultiPortDiffComb8:
	make INFILE=3 DEFINES="-D multiportdiffcomb8" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D multiportdiffcomb8" $(PERIPH)

MultiPortRandomTest2:
	make INFILE=3 DEFINES="-D multiportrandomtest2" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D multiportrandomtest2" $(PERIPH)

MemBGntTest:
	make INFILE=3 DEFINES="-D membgnttest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

LatencyTest1:
	make INFILE=3 DEFINES="-D latencytest1" $(PERIPH)
	make INFILE=2 DEFINES="-D latencytest1" $(PERIPH)
	make INFILE=1 DEFINES="-D latencytest1" $(PERIPH)
	make INFILE=0 DEFINES="-D latencytest1" $(PERIPH)

LatencyTest2:
	make INFILE=3 DEFINES="-D latencytest2" $(PERIPH)
	make INFILE=2 DEFINES="-D latencytest2" $(PERIPH)
	make INFILE=1 DEFINES="-D latencytest2" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)

LatencyTest3_1:
	make INFILE=3 DEFINES="-D latencytest3_1" $(PERIPH)
	make INFILE=2 DEFINES="-D latencytest3_1" $(PERIPH)
	make INFILE=0 DEFINES="-D latencytest3_1" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)

LatencyTest3_2:
	make INFILE=3 DEFINES="-D latencytest3_2" $(PERIPH)
	make INFILE=2 DEFINES="-D latencytest3_2" $(PERIPH)
	make INFILE=1 DEFINES="-D latencytest3_2" $(PERIPH)
	make INFILE=0 DEFINES="-D latencytest3_2" $(PERIPH)

LatencyTest4_1:
	make INFILE=3 DEFINES="-D latencytest4_1" $(PERIPH)
	make INFILE=2 DEFINES="-D latencytest4_1" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D latencytest4_1" $(PERIPH)

LatencyTest4_2:
	make INFILE=3 DEFINES="-D latencytest4_2" $(PERIPH)
	make INFILE=2 DEFINES="-D latencytest4_2" $(PERIPH)
	make INFILE=1 DEFINES="-D latencytest4_2" $(PERIPH)
	make INFILE=0 DEFINES="-D latencytest4_2" $(PERIPH)

LatencyTest5_1:
	make INFILE=3 DEFINES="-D latencytest5_1" $(PERIPH)
	make INFILE=2 DEFINES="-D latencytest5_1" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D latencytest5_1" $(PERIPH)

LatencyTest5_2:
	make INFILE=3 DEFINES="-D latencytest5_2" $(PERIPH)
	make INFILE=2 DEFINES="-D latencytest5_2" $(PERIPH)
	make INFILE=1 DEFINES="-D latencytest5_2" $(PERIPH)
	make INFILE=0 DEFINES="-D latencytest5_2" $(PERIPH)

LatencyTest6_1:
	make INFILE=3 DEFINES="-D latencytest6_1" $(PERIPH)
	make INFILE=2 DEFINES="-D latencytest6_1" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D latencytest6_1" $(PERIPH)

LatencyTest6_2:
	make INFILE=3 DEFINES="-D latencytest6_2" $(PERIPH)
	make INFILE=2 DEFINES="-D latencytest6_2" $(PERIPH)
	make INFILE=1 DEFINES="-D latencytest6_2" $(PERIPH)
	make INFILE=0 DEFINES="-D latencytest6_2" $(PERIPH)

LatencyTest7:
	make INFILE=3 DEFINES="-D latencytest7" $(PERIPH)
	make INFILE=2 DEFINES="-D latencytest7" $(PERIPH)
	make INFILE=1 DEFINES="-D latencytest7" $(PERIPH)
	make INFILE=0 DEFINES="-D latencytest7" $(PERIPH)

LatencyTest8:
	make INFILE=3 DEFINES="-D latencytest8" $(PERIPH)
	make INFILE=2 DEFINES="-D latencytest8" $(PERIPH)
	make INFILE=1 DEFINES="-D latencytest8" $(PERIPH)
	make INFILE=0 DEFINES="-D latencytest8" $(PERIPH)

LatencyTest9:
	make INFILE=3 DEFINES="-D latencytest9" $(PERIPH)
	make INFILE=2 DEFINES="-D latencytest9" $(PERIPH)
	make INFILE=1 DEFINES="-D latencytest9" $(PERIPH)
	make INFILE=0 DEFINES="-D latencytest9" $(PERIPH)

LatencyTest10:
	make INFILE=3 DEFINES="-D latencytest10" $(PERIPH)
	make INFILE=2 DEFINES="-D latencytest10" $(PERIPH)
	make INFILE=1 DEFINES="-D latencytest10" $(PERIPH)
	make INFILE=0 DEFINES="-D latencytest10" $(PERIPH)

AHBLockIdleInsertTest1:
	make INFILE=3 DEFINES="-D ahblockidleinserttest1" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D ahblockidleinserttest1" $(PERIPH)
	make INFILE=0 DEFINES="-D ahblockidleinserttest1" $(PERIPH)

AHBLockIdleInsertTest2:
	make INFILE=3 DEFINES="-D ahblockidleinserttest2" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D ahblockidleinserttest2" $(PERIPH)
	make INFILE=0 DEFINES="-D ahblockidleinserttest2" $(PERIPH)

CoherencyDifBnkRowTest:
	make INFILE=3 DEFINES="-D coherencydifbnkrowtest" $(PERIPH)
	make INFILE=2 DEFINES="-D coherencydifbnkrowtest" $(PERIPH)
	make INFILE=1 DEFINES="-D coherencydifbnkrowtest" $(PERIPH)
	make INFILE=0 DEFINES="-D coherencydifbnkrowtest" $(PERIPH)

CoherencyDifBnkSameRowTest:
	make INFILE=3 DEFINES="-D coherencydifbnksamerowtest" $(PERIPH)
	make INFILE=2 DEFINES="-D coherencydifbnksamerowtest" $(PERIPH)
	make INFILE=1 DEFINES="-D coherencydifbnksamerowtest" $(PERIPH)
	make INFILE=0 DEFINES="-D coherencydifbnksamerowtest" $(PERIPH)

CoherencyDifBnkTest:
	make INFILE=3 DEFINES="-D coherencydifbnktest" $(PERIPH)
	make INFILE=2 DEFINES="-D coherencydifbnktest" $(PERIPH)
	make INFILE=1 DEFINES="-D coherencydifbnktest" $(PERIPH)
	make INFILE=0 DEFINES="-D coherencydifbnktest" $(PERIPH)

CoherencySmeBnkDifRowTest1:
	make INFILE=3 DEFINES="-D coherencysmebnkdifrowtest1" $(PERIPH)
	make INFILE=2 DEFINES="-D coherencysmebnkdifrowtest1" $(PERIPH)
	make INFILE=1 DEFINES="-D coherencysmebnkdifrowtest1" $(PERIPH)
	make INFILE=0 DEFINES="-D coherencysmebnkdifrowtest1" $(PERIPH)

CoherencySmeBnkDifRowTest2:
	make INFILE=3 DEFINES="-D coherencysmebnkdifrowtest2" $(PERIPH)
	make INFILE=2 DEFINES="-D coherencysmebnkdifrowtest2" $(PERIPH)
	make INFILE=1 DEFINES="-D coherencysmebnkdifrowtest2" $(PERIPH)
	make INFILE=0 DEFINES="-D coherencysmebnkdifrowtest2" $(PERIPH)

CoherencySmeBnkTest:
	make INFILE=3 DEFINES="-D coherencysmebnktest" $(PERIPH)
	make INFILE=2 DEFINES="-D coherencysmebnktest" $(PERIPH)
	make INFILE=1 DEFINES="-D coherencysmebnktest" $(PERIPH)
	make INFILE=0 DEFINES="-D coherencysmebnktest" $(PERIPH)

CoherencyTest:
	make INFILE=3 DEFINES="-D coherencytest" $(PERIPH)
	make INFILE=2 DEFINES="-D idleport" $(PERIPH)
	make INFILE=1 DEFINES="-D idleport" $(PERIPH)
	make INFILE=0 DEFINES="-D idleport" $(PERIPH)
all:
	Error!!! : "all" OPTION NOT SUPPORTED

include BusTalkMakefile.mk

#################################### End #######################################
