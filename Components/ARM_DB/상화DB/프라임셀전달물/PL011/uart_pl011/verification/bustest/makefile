#-------------------------------------------------------------------------------
#-  This confidential and proprietary software may be used only as
#-  authorised by a licensing agreement from ARM Limited
#-    (C) COPYRIGHT 2000 ARM Limited
#-        ALL RIGHTS RESERVED
#-  The entire notice above must be reproduced on all authorised
#-  copies and copies may only be made to the extent permitted
#-  by a licensing agreement from ARM Limited.
#-------------------------------------------------------------------------------
#-  
#-  Version and Release Control Information:
#-  
#-  File Name              : makefile.rca
#-  File Revision          : 1.13
#-  
#-  Release Information    : PrimeCell(TM)-PL011-REL1v3
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

REG_TESTS :
	make DEFINES="-D REG_TESTS" $(PERIPH)

FIFODISABLED_TESTS :
	make DEFINES="-D FIFODISABLED_TESTS" $(PERIPH)

FIFOENABLED_TESTS :
	make DEFINES="-D FIFOENABLED_TESTS" $(PERIPH)

INDEPTXRX_TESTS :
	make DEFINES="-D INDEPTXRX_TESTS" $(PERIPH)

OVERRUN_TESTS :
	make DEFINES="-D OVERRUN_TESTS" $(PERIPH)

BAUD_TESTS :
	make DEFINES="-D BAUD_TESTS" $(PERIPH)

FRACBAUD_TESTS :
	make DEFINES="-D FRACBAUD_TESTS" $(PERIPH)

MODEM_TESTS :
	make DEFINES="-D MODEM_TESTS" $(PERIPH)

PARITY_TESTS :
	make DEFINES="-D PARITY_TESTS" $(PERIPH)

FRAMING_TESTS :
	make DEFINES="-D FRAMING_TESTS" $(PERIPH)

JITTER_TESTS :
	make DEFINES="-D JITTER_TESTS" $(PERIPH)

INTERRUPT_TESTS :
	make DEFINES="-D INTERRUPT_TESTS" $(PERIPH)

IRDA_TESTS:
	make DEFINES="-D IRDA_TESTS" $(PERIPH)

BREAK_TESTS :
	make DEFINES="-D BREAK_TESTS" $(PERIPH)

RTIS_TESTS :
	make DEFINES="-D RTIS_TESTS" $(PERIPH)

DISABLE_TESTS :
	make DEFINES="-D DISABLE_TESTS" $(PERIPH)

HALFDUPLEX_TESTS:
	make DEFINES="-D HALFDUPLEX_TESTS" $(PERIPH)

LOOPBACK_TESTS:
	make DEFINES="-D LOOPBACK_TESTS" $(PERIPH)

BOUNDARY_TESTS:
	make DEFINES="-D BOUNDARY_TESTS" $(PERIPH)

FIFO_TESTS:
	make DEFINES="-D FIFO_TESTS" $(PERIPH)

DMA_TESTS:
	make DEFINES="-D DMA_TESTS" $(PERIPH)

FC_TESTS:
	make DEFINES="-D FC_TESTS" $(PERIPH)

ILLEGALBAUD_TESTS:
	make DEFINES="-D ILLEGALBAUD_TESTS" $(PERIPH)

ALL_TESTS :
	make DEFINES="-D ALL_TESTS" $(PERIPH)

DRIFT_TESTS :
	make DEFINES="-D DRIFT_TESTS" $(PERIPH)



include $(GLOBAL)/bustalk_apb/bustest/BusTalkMakefile.mk

############################## End of file #####################################
