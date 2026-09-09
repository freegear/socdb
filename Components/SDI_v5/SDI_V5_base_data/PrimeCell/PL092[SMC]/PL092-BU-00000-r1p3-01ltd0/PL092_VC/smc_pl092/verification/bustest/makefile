#- --=========================================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2000-2003 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#- -----------------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name              : makefile.rca
#- File Revision          : 1.19
#-
#- Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
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

BROMTests :
	make DEFINES="-D bromtests" $(PERIPH)

BankCrossingTests :
	make DEFINES="-D bankcrossingtests" $(PERIPH)

BusAccessTests :
	make DEFINES="-D busaccesstests" $(PERIPH)

BROMBusyInsertionTest :
	make DEFINES="-D brombusyinsertiontest" $(PERIPH)

CSTests :
	make DEFINES="-D cstests" $(PERIPH)

Cornercase2 :
	make DEFINES="-D cornercase2" $(PERIPH)

Cornercase3 :
	make DEFINES="-D cornercase3" $(PERIPH)

Cornercase4 :
	make DEFINES="-D cornercase4" $(PERIPH)

Cornercase1 :
	make DEFINES="-D cornercase1" $(PERIPH)

BROMDelayTest :
	make DEFINES="-D bromdelaytest" $(PERIPH)

EbiCornerCase :
	make DEFINES="-D ebicornercase" $(PERIPH)

DelayValueTests :
	make DEFINES="-D delayvaluetests" $(PERIPH)

EndiannessTests :
	make DEFINES="-D endiannesstests" $(PERIPH)

MemProtocolTests :
	make DEFINES="-D memprotocoltests" $(PERIPH)

MemoryBankTests :
	make DEFINES="-D memorybanktests" $(PERIPH)

PerformanceTests :
	make DEFINES="-D performancetests" $(PERIPH)

ProtectionTests :
	make DEFINES="-D protectiontests" $(PERIPH)

RBLETests :
	make DEFINES="-D rbletests" $(PERIPH)

ROMTests :
	make DEFINES="-D romtests" $(PERIPH)

RandomTests :
	make DEFINES="-D randomtests" $(PERIPH)

BigEndHburstTest :
	make DEFINES="-D bigendhbursttest" $(PERIPH)

OneClkAfterReset :
	make DEFINES="-D oneclkafterreset" $(PERIPH)

BROMCornerCase :
	make DEFINES="-D bromcornercase" $(PERIPH)

WPErrorTest :
	make DEFINES="-D wperrortest" $(PERIPH)

Cornercase6 :
	make DEFINES="-D cornercase6" $(PERIPH)

Cornercase7 :
	make DEFINES="-D cornercase7" $(PERIPH)

Cornercase8 :
	make DEFINES="-D cornercase8" $(PERIPH)

Cornercase9 :
	make DEFINES="-D cornercase9" $(PERIPH)

Cornercase10 :
	make DEFINES="-D cornercase10" $(PERIPH)

Cornercase11 :
	make DEFINES="-D cornercase11" $(PERIPH)

Cornercase12 :
	make DEFINES="-D cornercase12" $(PERIPH)

Cornercase14 :
	make DEFINES="-D cornercase14" $(PERIPH)

Cornercase5 :
	make DEFINES="-D cornercase5" $(PERIPH)

BusyInsCornerCase :
	make DEFINES="-D busyinscornercase" $(PERIPH)

NewRandomTest :
	make DEFINES="-D newrandomtest" $(PERIPH)

MixedAccessTests :
	make DEFINES="-D mixedaccesstests" $(PERIPH)

DelayValueROMTests :
	make DEFINES="-D delayvalueromtests" $(PERIPH)

RemapTests :
	make DEFINES="-D remaptests" $(PERIPH)

SMWAITFlagTests :
	make DEFINES="-D smwaitflagtests" $(PERIPH)

SMWAITTests :
	make DEFINES="-D smwaittests" $(PERIPH)

MCReqGntTests :
	make DEFINES="-D mcreqgnttests" $(PERIPH)

TransferTests :
	make DEFINES="-D transfertests" $(PERIPH)

DenaliTests :
	make DEFINES="-D denalitests" $(PERIPH)

Smc1 :
	 make DEFINES="-D Smc1" $(PERIPH)

Smc2 :
	 make DEFINES="-D Smc2" $(PERIPH)

Smc3 :
	 make DEFINES="-D Smc3" $(PERIPH)

Smc4 :
	 make DEFINES="-D Smc4" $(PERIPH)

Smc5 :
	 make DEFINES="-D Smc5" $(PERIPH)

Smc6 :
	 make DEFINES="-D Smc6" $(PERIPH)
clean: 
	@rm -rf invec
	@rm -f busmacros.h busmacros.c busheader.h 
	@rm -f config.h include.h addargs_script tif2bif bif2sim.awk tif2sim.awk

$(PERIPH) : busmacros.h busmacros.c busheader.h config.h include.h addargs_script tif2bif bif2sim.awk tif2sim.awk
	@gcc -ansi $(DEFINES) -E $(PERIPH).c > $(PERIPH)_Pre.c
	@nawk -f addargs_script $(PERIPH)_Pre.c
#       If the invec directory doesn't exist, create it.
	@if [ ! -d invec ] ; then \
	mkdir invec ; fi ;
#       If not TIF only, create the BIF vectors
	@if [ "$(VECT_TYPE)" != "TIF" ]; then \
	gcc -ansi -include $(PERIPH).h -include include.h -g temp.$(PERIPH)_Pre.c -o $(PERIPH); \
	$(PERIPH) > invec/infile.tif; \
	tif2bif invec/infile; \
	awk -f bif2sim.awk < invec/infile.bif > invec/bif.sim; \
	rm invec/infile.tif; \
	fi ;
#       If not BIF only, create TIF vectors
	@if [ "$(VECT_TYPE)" != "BIF" ]; then \
	gcc -ansi -include $(PERIPH).h -include include.h -D TIF -g temp.$(PERIPH)_Pre.c -o $(PERIPH); \
	$(PERIPH) > invec/infile.tif; \
	awk -f tif2sim.awk < invec/infile.tif > invec/tif.sim;  \
	fi ;
#       Remove intermediary files
	@rm temp.$(PERIPH)_Pre.c $(PERIPH)_Pre.c
	@rm $(PERIPH)

busmacros.h :  $(GLOBAL)/bustalk_ahb/bustest/busmacros.h
	@cp -f $(GLOBAL)/bustalk_ahb/bustest/busmacros.h .

busmacros.c :  $(GLOBAL)/bustalk_ahb/bustest/busmacros.c
	@cp -f $(GLOBAL)/bustalk_ahb/bustest/busmacros.c .

busheader.h :  $(GLOBAL)/bustalk_ahb/bustest/busheader.h
	@cp -f $(GLOBAL)/bustalk_ahb/bustest/busheader.h .

config.h :  $(GLOBAL)/bustalk_ahb/bustest/config.h
	@cp -f $(GLOBAL)/bustalk_ahb/bustest/config.h .

include.h :  $(GLOBAL)/bustalk_ahb/bustest/include.h
	@cp -f $(GLOBAL)/bustalk_ahb/bustest/include.h .

addargs_script :  $(GLOBAL)/bustalk_ahb/bustest/addargs_script
	@cp -f $(GLOBAL)/bustalk_ahb/bustest/addargs_script .

tif2bif :  $(GLOBAL)/bustalk_ahb/bustest/tif2bif
	@cp -f $(GLOBAL)/bustalk_ahb/bustest/tif2bif .

bif2sim.awk :  $(GLOBAL)/bustalk_ahb/bustest/bif2sim.awk
	@cp -f $(GLOBAL)/bustalk_ahb/bustest/bif2sim.awk .

tif2sim.awk :  $(GLOBAL)/bustalk_ahb/bustest/tif2sim.awk
	@cp -f $(GLOBAL)/bustalk_ahb/bustest/tif2sim.awk .

#- --=============================== End =====================================--
