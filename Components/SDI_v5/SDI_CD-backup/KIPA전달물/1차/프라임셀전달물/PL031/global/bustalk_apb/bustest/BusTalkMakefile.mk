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
#- File Name              : BusTalkMakefile.mk.rca
#- File Revision          : 1.2
#-
#- Release Information    : PrimeCell(TM)-GLOBAL-REL1v2
#-
#- ---------------------------------------------------------------------
#- Purpose : A makefile to build BusTalk vectors.
#-
#- --=================================================================--

#-----------------------------------------------------------------------
# The Awk preprocessor is used to complete the argument list.
#
# The same makefile can be used to generate .tif, .bif or .sim vector
# files from the BusTalk source code.
#
# To generate .tif vectors only set VECT_TYPE = TIF 
# in the block specific makefile.
#
# To generate .bif vectors only set VECT_TYPE = BIF 
# in the block specific makefile.
#
# To generate both .tif and .bif vectors set VECT_TYPE = "" 
# in the block specific makefile.
#                                        
#-----------------------------------------------------------------------

clean: 
	@rm -rf invec
	@rm -f busmacros.h busmacros.c busheader.h 
	@rm -f config.h include.h addargs_script tif2bif bif2sim.awk tif2sim.awk

all:  
	@make DEFINES="-D ALL_TESTS" $(PERIPH)

$(PERIPH) : busmacros.h busmacros.c busheader.h config.h include.h addargs_script tif2bif bif2sim.awk tif2sim.awk
	@gcc -ansi $(DEFINES) -E $(PERIPH).c > $(PERIPH)_Pre.c
	@nawk -f addargs_script $(PERIPH)_Pre.c
#       If the invec directory doesn't exist, create it.
	@if [ ! -d invec ] ; then \
	mkdir invec ; fi ;
#       If not TIF only, create the BIF vectors
	@if [ "$(VECT_TYPE)" != "TIF" ]; then \
	gcc -ansi -include include.h -include $(PERIPH).h -g temp.$(PERIPH)_Pre.c -o $(PERIPH); \
	$(PERIPH) > invec/infile.tif; \
	tif2bif invec/infile; \
	awk -f bif2sim.awk < invec/infile.bif > invec/bif.sim; \
	rm invec/infile.tif; \
	fi ;
#       If not BIF only, create TIF vectors
	@if [ "$(VECT_TYPE)" != "BIF" ]; then \
	gcc -ansi -include include.h -include $(PERIPH).h -D TIF -g temp.$(PERIPH)_Pre.c -o $(PERIPH); \
	$(PERIPH) > invec/infile.tif; \
	awk -f tif2sim.awk < invec/infile.tif > invec/tif.sim;  \
	fi ;
#       Remove intermediary files
	@rm temp.$(PERIPH)_Pre.c $(PERIPH)_Pre.c
	@rm $(PERIPH)

busmacros.h :  $(GLOBAL)/bustalk_apb/bustest/busmacros.h
	@cp -f $(GLOBAL)/bustalk_apb/bustest/busmacros.h .

busmacros.c :  $(GLOBAL)/bustalk_apb/bustest/busmacros.c
	@cp -f $(GLOBAL)/bustalk_apb/bustest/busmacros.c .

busheader.h :  $(GLOBAL)/bustalk_apb/bustest/busheader.h
	@cp -f $(GLOBAL)/bustalk_apb/bustest/busheader.h .

config.h :  $(GLOBAL)/bustalk_apb/bustest/config.h
	@cp -f $(GLOBAL)/bustalk_apb/bustest/config.h .

include.h :  $(GLOBAL)/bustalk_apb/bustest/include.h
	@cp -f $(GLOBAL)/bustalk_apb/bustest/include.h .

addargs_script :  $(GLOBAL)/bustalk_apb/bustest/addargs_script
	@cp -f $(GLOBAL)/bustalk_apb/bustest/addargs_script .

tif2bif :  $(GLOBAL)/bustalk_apb/bustest/tif2bif
	@cp -f $(GLOBAL)/bustalk_apb/bustest/tif2bif .

bif2sim.awk :  $(GLOBAL)/bustalk_apb/bustest/bif2sim.awk
	@cp -f $(GLOBAL)/bustalk_apb/bustest/bif2sim.awk .

tif2sim.awk :  $(GLOBAL)/bustalk_apb/bustest/tif2sim.awk
	@cp -f $(GLOBAL)/bustalk_apb/bustest/tif2sim.awk .

############################## End #####################################
