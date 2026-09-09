#-------------------------------------------------------------------------------
#-  This confidential and proprietary software may be used only as
#-  authorised by a licensing agreement from ARM Limited
#-    (C) COPYRIGHT 2001 ARM Limited
#-        ALL RIGHTS RESERVED
#-  The entire notice above must be reproduced on all authorised
#-  copies and copies may only be made to the extent permitted
#-  by a licensing agreement from ARM Limited.
#-------------------------------------------------------------------------------
#-  
#-  Version and Release Control Information:
#-  
#-  File Name              : makefile.rca
#-  File Revision          : 1.7
#-  
#-  Release Information    : PrimeCell(TM)-PL031-REL1v0
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

RST_TESTS :
	make DEFINES="-D RST_TESTS" $(PERIPH)

INITREG_TESTS :
	make DEFINES="-D INITREG_TESTS" $(PERIPH)

REG_TESTS :
	make DEFINES="-D REG_TESTS" $(PERIPH)

UPDATE_TESTS :
	make DEFINES="-D UPDATE_TESTS" $(PERIPH)

INT_TESTS :
	make DEFINES="-D INT_TESTS" $(PERIPH)

COUNT_TESTS :
	make DEFINES="-D COUNT_TESTS" $(PERIPH)

ALL_TESTS :
	make DEFINES="-D ALL_TESTS" $(PERIPH)



include $(GLOBAL)/bustalk_apb/bustest/BusTalkMakefile.mk

############################## End of file #####################################
