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
#-           A makefile to generate .bif and .sim formatted vectors
#-           from BusTalk source 'C' code 
#-
#- --=================================================================--

VECT_TYPE = BIF

Tx_Call :  
	make DEFINES="-D tx_call" $(PERIPH)

Rx_Call :  
	make DEFINES="-D rx_call" $(PERIPH)

TxRx_FsPCLK_Call :  
	make DEFINES="-D txrx_fspclk_call" $(PERIPH)

TxRx_SlPCLK_Call :  
	make DEFINES="-D txrx_slpclk_call" $(PERIPH)

RegisterTest :  
	make DEFINES="-D registertest" $(PERIPH)

AddrRangeTest :
	make DEFINES="-D addrrangetest" $(PERIPH)

ColdNWarmReset : 
	make DEFINES="-D coldnwarmreset" $(PERIPH)

DataWidthCheck : 
	make DEFINES="-D datawidthcheck" $(PERIPH)

FIFOPointersTest : 
	make DEFINES="-D fifopointerstest" $(PERIPH)

ForcedReset :
	make DEFINES="-D forcedreset" $(PERIPH)

ForcedSync :
	make DEFINES="-D forcedsync" $(PERIPH)

InterruptTest :
	make DEFINES="-D interrupttest" $(PERIPH)

AACITXINTRTests :
	make DEFINES="-D txintrtest" $(PERIPH)

AACIRXINTRTests :
	make DEFINES="-D rxintrtest" $(PERIPH)

AACIORINTRTests :
	make DEFINES="-D orintrtest" $(PERIPH)

AACIURINTRTests :
	make DEFINES="-D urintrtest" $(PERIPH)

AACITXCINTRTests :
	make DEFINES="-D txcintrtest" $(PERIPH)

AACIRXTOINTRTests :
	make DEFINES="-D rxtointrtest" $(PERIPH)

AACIWINTRTest :
	make DEFINES="-D wintrtest" $(PERIPH)

AACIGPIOINTRTest :
	make DEFINES="-D gpiointrtest" $(PERIPH)

AACISnRXINTRTests :
	make DEFINES="-D snrxintrtest" $(PERIPH)

AACISnTXINTRTests :
	make DEFINES="-D sntxintrtest" $(PERIPH)

AACIRXTOFEINTRTests :
	make DEFINES="-D rxtofeintrtest" $(PERIPH)

DMATest :
	make DEFINES="-D dmatest" $(PERIPH)

FIFOTest :
	make DEFINES="-D fifotest" $(PERIPH)

Aaci1 :  
	make DEFINES="-D aaci1" $(PERIPH)

Aaci2 :  
	make DEFINES="-D aaci2" $(PERIPH)

Aaci3 :
	make DEFINES="-D aaci3" $(PERIPH)

include $(GLOBAL)/bustalk_apb/bustest/BusTalkMakefile.mk

################################ End ###################################
