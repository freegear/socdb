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
#- File Revision          : 1.2
#-
#- Release Information    : PrimeCell(TM)-PL220-r0p0-00ltd0
#-
#- -----------------------------------------------------------------------------
#- Purpose :
#-           A makefile to build BusTalk vectors for EBI
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

EbiMclkEqHclk :
	make DEFINES="-D ebimclkeqhclk" $(PERIPH)

EbiM1M2M3Eq2Hck :
	make DEFINES="-D ebim1m2m3eq2hck" $(PERIPH)

EbiMck1Mck2Eq2Hck :
	make DEFINES="-D ebimck1mck2eq2hck" $(PERIPH)

EbiMck1Mck3Eq2Hck :
	make DEFINES="-D ebimck1mck3eq2hck" $(PERIPH)

EbiMck2Mck3Eq2Hck :
	make DEFINES="-D ebimck2mck3eq2hck" $(PERIPH)

EbiMclk1Eq2Hclk :
	make DEFINES="-D ebimclk1eq2hclk" $(PERIPH)

EbiMclk2Eq2Hclk :
	make DEFINES="-D ebimclk2eq2hclk" $(PERIPH)

EbiMclk3Eq2Hclk :
	make DEFINES="-D ebimclk3eq2hclk" $(PERIPH)

EbiRandom :
	make DEFINES="-D ebirandom" $(PERIPH)

include $(GLOBAL)/bustalk_ahb/bustest/BusTalkMakefile.mk        

#################################### End #######################################
