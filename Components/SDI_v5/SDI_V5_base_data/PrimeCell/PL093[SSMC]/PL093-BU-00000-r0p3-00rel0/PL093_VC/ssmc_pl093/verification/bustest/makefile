#- --=========================================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2003 ARM Limited
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
#- Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
#-
#- -----------------------------------------------------------------------------
#- Purpose :
#-           A makefile to build BusTalk vectors
#-
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

AddrToggleTests :
	make DEFINES="-D addrtoggletests" $(PERIPH)

AddrAdvanceTests :
	make DEFINES="-D addradvancetests" $(PERIPH)

AddrValidTests :
	make DEFINES="-D addrvalidtests" $(PERIPH)

BROMTests :
	make DEFINES="-D bromtests" $(PERIPH)

AsyBankCrossingTests :
	make DEFINES="-D asybankcrossingtests" $(PERIPH)

BusAccessTests :
	make DEFINES="-D busaccesstests" $(PERIPH)

CSTests :
	make DEFINES="-D cstests" $(PERIPH)

WrapReadTests :
	make DEFINES="-D wrapreadtests" $(PERIPH)

PerformanceTests :
	make DEFINES="-D performancetests" $(PERIPH)

DelayValueTests :
	make DEFINES="-D delayvaluetests" $(PERIPH)

MemoryBankTests :
	make DEFINES="-D memorybanktests" $(PERIPH)

SMWAITFlagTests :
	make DEFINES="-D smwaitflagtests" $(PERIPH)

ProtectionTests :
	make DEFINES="-D protectiontests" $(PERIPH)

SyROMTests :
	make DEFINES="-D syromtests" $(PERIPH)

ROMTests :
	make DEFINES="-D romtests" $(PERIPH)

TransferTests :
	make DEFINES="-D transfertests" $(PERIPH)

AsyWRRDTests :
	make DEFINES="-D asywrrdtests" $(PERIPH)

SsmcEndianTests :
	make DEFINES="-D ssmcendiantests" $(PERIPH)

SsmcSMWAITTests :
	make DEFINES="-D ssmcsmwaittests" $(PERIPH)

RBLETests :
	make DEFINES="-D rbletests" $(PERIPH)

SyAddrToggleTests :
	make DEFINES="-D syaddrtoggletests" $(PERIPH)

SyBROMTests :
	make DEFINES="-D sybromtests" $(PERIPH)

SyBankCrossingTests :
	make DEFINES="-D sybankcrossingtests" $(PERIPH)

SyBusAccessTests :
	make DEFINES="-D sybusaccesstests" $(PERIPH)

SyCSTests :
	make DEFINES="-D sycstests" $(PERIPH)

SyMemoryBankTests :
	make DEFINES="-D symemorybanktests" $(PERIPH)

SyBurstWaitTests :
	make DEFINES="-D syburstwaittests" $(PERIPH)

SsmcTranSeqTests :
	make DEFINES="-D ssmctranseqtests" $(PERIPH)

SyWRRDTests :
	make DEFINES="-D sywrrdtests" $(PERIPH)

SyEndianTests :
	make DEFINES="-D syendiantests" $(PERIPH)

SyRandomTests :
	make DEFINES="-D syrandomtests" $(PERIPH)

RandomTests :
	make DEFINES="-D randomtests" $(PERIPH)

BankCrossingTests :
	make DEFINES="-D bankcrossingtests" $(PERIPH)

BusGntTests :
	make DEFINES="-D busgnttests" $(PERIPH)

DenaliTests :
	make DEFINES="-D denalitests" $(PERIPH)

DenaliTests1:
	make DEFINES="-D denalitests1" $(PERIPH)

DenaliTests3:
	make DEFINES="-D denalitests3" $(PERIPH)

Ssmc1 :
	 make DEFINES="-D Ssmc1" $(PERIPH)

Ssmc2 :
	 make DEFINES="-D Ssmc2" $(PERIPH)

Ssmc3 :
	 make DEFINES="-D Ssmc3" $(PERIPH)

Ssmc4 :
	 make DEFINES="-D Ssmc4" $(PERIPH)

     
include $(GLOBAL)/bustalk_ahb/bustest/BusTalkMakefile.mk

#- --=============================== End =====================================--
