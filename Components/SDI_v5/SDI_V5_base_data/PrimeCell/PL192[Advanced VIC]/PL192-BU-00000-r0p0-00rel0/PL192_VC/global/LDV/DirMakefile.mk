#-----------------------------------------------------------------------
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2000 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#-----------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name              : DirMakefile.mk.rca
#- File Revision          : 1.1
#-
#- Release Information    : PrimeCell(TM)-GLOBAL-r8p0-00rel0
#-
#-----------------------------------------------------------------------
#-  Purpose  :
#-             A makefile to build lower level directories
#-----------------------------------------------------------------------

all:
	@for i in $(DIRS) ; do \
	  (cd $$i ; \
	  make all) \
	done

clean:
	@for i in $(DIRS) ; do \
	  (cd $$i ; \
	  make clean ) \
	done

################################ End ###################################
