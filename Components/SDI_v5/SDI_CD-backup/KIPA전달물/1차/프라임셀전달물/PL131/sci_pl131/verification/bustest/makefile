#- --=========================================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2001 ARM Limited
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
#- Release Information    : PrimeCell(TM)-PL131-REL1v0
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

ALL_TESTS :  
	make DEFINES="-D ALL_TESTS" $(PERIPH)

REG_TESTS :  
	make DEFINES="-D REG_TESTS" $(PERIPH)

DEBOUNCE_TESTS :  
	make DEFINES="-D DEBOUNCE_TESTS" $(PERIPH)

ACT_DEACT_TESTS :  
	make DEFINES="-D ACT_DEACT_TESTS" $(PERIPH)

ATR_TESTS :  
	make DEFINES="-D ATR_TESTS" $(PERIPH)

RX_NON_BACK_TO_BACK_TESTS :  
	make DEFINES="-D RX_NON_BACK_TO_BACK_TESTS" $(PERIPH)

RX_BACK_TO_BACK_TESTS :  
	make DEFINES="-D RX_BACK_TO_BACK_TESTS" $(PERIPH)

RX_INTERRUPT_TESTS :  
	make DEFINES="-D RX_INTERRUPT_TESTS" $(PERIPH)

RX_PARITY_TESTS :  
	make DEFINES="-D RX_PARITY_TESTS" $(PERIPH)

CH_TIMEOUT_TESTS :  
	make DEFINES="-D CH_TIMEOUT_TESTS" $(PERIPH)

BLK_TIMEOUT_TESTS :  
	make DEFINES="-D BLK_TIMEOUT_TESTS" $(PERIPH)

SYNC_MODE_TX_TESTS :  
	make DEFINES="-D SYNC_MODE_TX_TESTS" $(PERIPH)

SYNC_MODE_RX_TESTS :  
	make DEFINES="-D SYNC_MODE_RX_TESTS" $(PERIPH)

NON_EMV_TESTS :  
	make DEFINES="-D NON_EMV_TESTS" $(PERIPH)

CLKZ1_TESTS :  
	make DEFINES="-D CLKZ1_TESTS" $(PERIPH)

TX_NON_BACK_TO_BACK_TESTS :  
	make DEFINES="-D TX_NON_BACK_TO_BACK_TESTS" $(PERIPH)

TX_BACK_TO_BACK_TESTS :  
	make DEFINES="-D TX_BACK_TO_BACK_TESTS" $(PERIPH)

TX_INTERRUPT_TESTS :  
	make DEFINES="-D TX_INTERRUPT_TESTS" $(PERIPH)

TX_PARITY_TESTS :  
	make DEFINES="-D TX_PARITY_TESTS" $(PERIPH)

CH_GUARD_TESTS :  
	make DEFINES="-D CH_GUARD_TESTS" $(PERIPH)

TX_ERROR_INTERRUPT_TESTS :  
	make DEFINES="-D TX_ERROR_INTERRUPT_TESTS" $(PERIPH)

DMA_TX_TESTS             :
	make DEFINES="-D DMA_TX_TESTS" $(PERIPH)

DMA_RX_TESTS             :
	make DEFINES="-D DMA_RX_TESTS" $(PERIPH)

CLOCKSTOP_TESTS             :
	make DEFINES="-D CLOCKSTOP_TESTS" $(PERIPH)

RXOVERRUN_TESTS             :
	make DEFINES="-D RXOVERRUN_TESTS" $(PERIPH)

STATE_TESTS             :
	make DEFINES="-D STATE_TESTS" $(PERIPH)


include $(GLOBAL)/bustalk_apb/bustest/BusTalkMakefile.mk

#################################### End #######################################
