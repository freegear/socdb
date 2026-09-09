#- --=================================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2002 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#- ---------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name              : makefile.rca
#- File Revision          : 1.1
#-
#- Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
#-
#- ---------------------------------------------------------------------
#- Purpose : 
#-           A makefile to build BusTalk vectors.
#-           The same makefile can be used to generate .bif and .sim 
#-           vector files from the BusTalk source code.
#-
#- --=================================================================--

VECT_TYPE = BIF

ALL_TESTS :
	make DEFINES="-D ALL_TESTS" $(PERIPH)

CHECK_INTRTEST :
	make DEFINES="-D CHECK_INTRTEST" $(PERIPH)

CHECK_PWRSEQ :
	make DEFINES="-D CHECK_PWRSEQ" $(PERIPH)

CHECK_RETRY :
	make DEFINES="-D CHECK_RETRY" $(PERIPH)

CHECK_FREQTEST :
	make DEFINES="-D CHECK_FREQTEST" $(PERIPH)

CHECK_STNDUALCLR :
	make DEFINES="-D CHECK_STNDUALCLR" $(PERIPH)

CHECK_STNDUALM :
	make DEFINES="-D CHECK_STNDUALM" $(PERIPH)

CHECK_STNSINGLECLR :
	make DEFINES="-D CHECK_STNSINGLECLR" $(PERIPH)

CHECK_STNSINGLEM :
	make DEFINES="-D CHECK_STNSINGLEM" $(PERIPH)

CHECK_TFT :
	make DEFINES="-D CHECK_TFT" $(PERIPH)

CHECK_TFT_1 :
	make DEFINES="-D CHECK_TFT_1" $(PERIPH)

CHECK_FLAT :
	make DEFINES="-D CHECK_FLAT" $(PERIPH)

CHECK_VERTICAL :
	make DEFINES="-D CHECK_VERTICAL" $(PERIPH)

CHECK_LARGE :
	make DEFINES="-D CHECK_LARGE" $(PERIPH)

include $(GLOBAL)/bustalk_ahb/bustest/BusTalkMakefile.mk

########################### End of file ################################
