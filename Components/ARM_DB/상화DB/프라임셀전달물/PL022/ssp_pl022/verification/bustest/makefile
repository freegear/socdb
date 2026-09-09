#-------------------------------------------------------------------------------
#-  This confidential and proprietary software may be used only as
#-  authorised by a licensing agreement from ARM Limited
#-    (C) COPYRIGHT 1998 ARM Limited
#-        ALL RIGHTS RESERVED
#-  The entire notice above must be reproduced on all authorised
#-  copies and copies may only be made to the extent permitted
#-  by a licensing agreement from ARM Limited.
#-------------------------------------------------------------------------------
#-  
#-  Version and Release Control Information:
#-  
#-  File Name              : makefile.rca
#-  File Revision          : 1.3
#-  
#-  Release Information    : PrimeCell(TM)-PL022-REL1v2
#-  
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#-  Purpose  : A makefile to build BusTalk vectors.
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# The same makefile can be used to generate .tif, .bif and .sim vector files
# from the BusTalk source code.
#
# To generate .tif and .sim vectors set VECT_TYPE = TIF.
# 
# To generate .bif and .sim vectors set VECT_TYPE = BIF.
#                                        
# To generate .bif,.tif and .sim vectors don't set VECT_TYPE.
#                                        
#-------------------------------------------------------------------------------

VECT_TYPE = BIF


# Example sub-tests
#
#test1 :  
#	make DEFINES="-D test1" $(PERIPH)
#
#test2 :  
#	make DEFINES="-D test2" $(PERIPH)
#

ALL_TESTS :  
	make DEFINES="-D ALL_TESTS" $(PERIPH)
REG_TESTS :  
	make DEFINES="-D REG_TESTS" $(PERIPH)

DATA_TESTS :  
	make DEFINES="-D DATA_TESTS" $(PERIPH)

NON_BACK_TO_BACK_TESTS :  
	make DEFINES="-D NON_BACK_TO_BACK_TESTS" $(PERIPH)

FRAME_FORMAT_TESTS :  
	make DEFINES="-D FRAME_FORMAT_TESTS" $(PERIPH)

BACK_TO_BACK_TESTS :  
	make DEFINES="-D BACK_TO_BACK_TESTS" $(PERIPH)

RIS_INTERRUPT_TESTS :  
	make DEFINES="-D RIS_INTERRUPT_TESTS" $(PERIPH)

TIS_INTERRUPT_TESTS :  
	make DEFINES="-D TIS_INTERRUPT_TESTS" $(PERIPH)

RORIS_INTERRUPT_TESTS :  
	make DEFINES="-D RORIS_INTERRUPT_TESTS" $(PERIPH)

SPI00_RTIS_INTERRUPT_TESTS :  
	make DEFINES="-D SPI00_RTIS_INTERRUPT_TESTS" $(PERIPH)

SPI01_RTIS_INTERRUPT_TESTS :  
	make DEFINES="-D SPI01_RTIS_INTERRUPT_TESTS" $(PERIPH)

SPI10_RTIS_INTERRUPT_TESTS :  
	make DEFINES="-D SPI10_RTIS_INTERRUPT_TESTS" $(PERIPH)

SPI11_RTIS_INTERRUPT_TESTS :  
	make DEFINES="-D SPI11_RTIS_INTERRUPT_TESTS" $(PERIPH)

TI_RTIS_INTERRUPT_TESTS :  
	make DEFINES="-D TI_RTIS_INTERRUPT_TESTS" $(PERIPH)

MW_RTIS_INTERRUPT_TESTS :  
	make DEFINES="-D MW_RTIS_INTERRUPT_TESTS" $(PERIPH)

LOOPBACK_TESTS :  
	make DEFINES="-D LOOPBACK_TESTS" $(PERIPH)

TXRX_FIFO_PTR_TESTS :  
	make DEFINES="-D TXRX_FIFO_PTR_TESTS" $(PERIPH)

TXRX_CRITICAL_TESTS :  
	make DEFINES="-D TXRX_CRITICAL_TESTS" $(PERIPH)

DISABLE_TESTS :  
	make DEFINES="-D DISABLE_TESTS" $(PERIPH)

SLAVE_DATA_TESTS :  
	make DEFINES="-D SLAVE_DATA_TESTS" $(PERIPH)

SLAVE_NON_BACK_TO_BACK_TESTS :  
	make DEFINES="-D SLAVE_NON_BACK_TO_BACK_TESTS" $(PERIPH)

SLAVE_FRAME_FORMAT_TESTS :  
	make DEFINES="-D SLAVE_FRAME_FORMAT_TESTS" $(PERIPH)

SLAVE_BACK_TO_BACK_TESTS :  
	make DEFINES="-D SLAVE_BACK_TO_BACK_TESTS" $(PERIPH)

SLAVE_RIS_INTERRUPT_TESTS :  
	make DEFINES="-D SLAVE_RIS_INTERRUPT_TESTS" $(PERIPH)

SLAVE_TIS_INTERRUPT_TESTS :  
	make DEFINES="-D SLAVE_TIS_INTERRUPT_TESTS" $(PERIPH)

SLAVE_RORIS_INTERRUPT_TESTS :  
	make DEFINES="-D SLAVE_RORIS_INTERRUPT_TESTS" $(PERIPH)

SLAVE_SPI00_RTIS_INTERRUPT_TESTS :  
	make DEFINES="-D SLAVE_SPI00_RTIS_INTERRUPT_TESTS" $(PERIPH)

SLAVE_SPI01_RTIS_INTERRUPT_TESTS :  
	make DEFINES="-D SLAVE_SPI01_RTIS_INTERRUPT_TESTS" $(PERIPH)

SLAVE_SPI10_RTIS_INTERRUPT_TESTS :  
	make DEFINES="-D SLAVE_SPI10_RTIS_INTERRUPT_TESTS" $(PERIPH)

SLAVE_SPI11_RTIS_INTERRUPT_TESTS :  
	make DEFINES="-D SLAVE_SPI11_RTIS_INTERRUPT_TESTS" $(PERIPH)

SLAVE_TI_RTIS_INTERRUPT_TESTS :  
	make DEFINES="-D SLAVE_TI_RTIS_INTERRUPT_TESTS" $(PERIPH)

SLAVE_MW_RTIS_INTERRUPT_TESTS :  
	make DEFINES="-D SLAVE_MW_RTIS_INTERRUPT_TESTS" $(PERIPH)

SLAVE_TXRX_FIFO_TESTS :  
	make DEFINES="-D SLAVE_TXRX_FIFO_TESTS" $(PERIPH)

SOD_TESTS :  
	make DEFINES="-D SOD_TESTS" $(PERIPH)

SLAVE_EXTENDED_FRAME_TESTS :  
	make DEFINES="-D SLAVE_EXTENDED_FRAME_TESTS" $(PERIPH)

SLAVE_FREE_RUN_CLOCK_TESTS :  
	make DEFINES="-D SLAVE_FREE_RUN_CLOCK_TESTS" $(PERIPH)

SLAVE_FRAME_DEACT_TESTS :  
	make DEFINES="-D SLAVE_FRAME_DEACT_TESTS" $(PERIPH)

SLAVE_FRAME_FORMAT_CHANGE_TESTS :  
	make DEFINES="-D SLAVE_FRAME_FORMAT_CHANGE_TESTS" $(PERIPH)

SLAVE_DISABLE_TESTS :  
	make DEFINES="-D SLAVE_DISABLE_TESTS" $(PERIPH)

MS_TESTS :  
	make DEFINES="-D MS_TESTS" $(PERIPH)

MSSOD_TESTS :  
	make DEFINES="-D MSSOD_TESTS" $(PERIPH)

DEASSERT_SFRAME_TESTS :  
	make DEFINES="-D DEASSERT_SFRAME_TESTS" $(PERIPH)

DATA_DISCARD_TESTS :  
	make DEFINES="-D DATA_DISCARD_TESTS" $(PERIPH)

DMA_RX_TESTS :  
	make DEFINES="-D DMA_RX_TESTS" $(PERIPH)

DMA_TX_TESTS :  
	make DEFINES="-D DMA_TX_TESTS" $(PERIPH)

MODE_CHANGE_TESTS :  
	make DEFINES="-D MODE_CHANGE_TESTS" $(PERIPH)

DISABLE_MID_TESTS :  
	make DEFINES="-D DISABLE_MID_TESTS" $(PERIPH)

include $(GLOBAL)/bustalk_apb/bustest/BusTalkMakefile.mk

############################## End of file #####################################
