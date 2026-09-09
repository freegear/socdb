#-------------------------------------------------------------------------------
#-  This confidential and proprietary software may be used only as
#-  authorised by a licensing agreement from ARM Limited
#-    (C) COPYRIGHT 1999 ARM Limited
#-        ALL RIGHTS RESERVED
#-  The entire notice above must be reproduced on all authorised
#-  copies and copies may only be made to the extent permitted
#-  by a licensing agreement from ARM Limited.
#-------------------------------------------------------------------------------
#-
#-  Version and Release Control Information:
#-
#-  File Name              : makefile,v
#-  File Revision          : 1.7
#-
#-  Release Information    : PrimeCell(TM)-PL170-REL2v2
#-
#-------------------------------------------------------------------------------
 
#-------------------------------------------------------------------------------
#-  Purpose  : A makefile to build the Verilog world for the SDRAMC block 
#-             Product Code : PL170
#-------------------------------------------------------------------------------

# use make CHECK_OUT=co $@ to check out latest versions
CHECK_OUT = @echo Newer version of $$@ in CVS

# list of directories to make. Order is important
DIRS = uut uutNetlist uutNetlist_scan

targets:
	@echo "#        **** ${PERIPHERAL} ${PRODUCT} Verilog Makefile ****"
	@echo "# Usage:"
	@echo "# make <build|clean|nowork>"
	@echo "#"
	@echo "#   clean  - cleanup the libraries and rebuild Verilog world"
	@echo "#   build  - same as clean except update new files from CVS"
	@echo "#   nowork - removes 'work' directories - useful before backups."
	@echo "#"

# clean will delete the contents of the library first
clean:
	@echo "############################################"
	@echo "Making ${PERIPHERAL} Verilog directories ..."
	@echo "############################################"
	for i in $(DIRS) ; do \
		(echo Making $$i; cd $$i ; \
		 $(MAKE) $(MAKE_OPTS) clean CHECK_OUT='$(CHECK_OUT)') \
	done

# build is the same as clean except newer files in CVS are checked out
build:
	@echo "##############################################"
	@echo "Updating ${PERIPHERAL} Verilog directories ..."
	@echo "##############################################"
	cvs update .
	@echo "############################################"
	@echo "Making ${PERIPHERAL} Verilog directories ..."
	@echo "############################################"
	for i in $(DIRS) ; do \
		(echo Making $$i; cd $$i ; \
		$(MAKE) $(MAKE_OPTS) clean CHECK_OUT='$(CHECK_OUT)' ) \
	done

# nowork deletes 'work' directories from the entire tree
nowork:
	@echo "################################################"
	@echo "Cleaning up ${PERIPHERAL} Verilog directories..."
	@echo "################################################"
	for i in $(DIRS) ; do \
		(echo Cleaning up $$i; cd $$i ; \
		$(MAKE) $(MAKE_OPTS) nowork CHECK_OUT='$(CHECK_OUT)' ) \
	done

############################# End of file ######################################
