#- --=================================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2001-2002 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#- ---------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name              : BusTalkMakefile.mk.rca
#- File Revision          : 1.8
#-
#- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
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
	@rm -f busmacros.h busheader.h 
	@rm -f config.h include.h addargs_script tif2bif bif2sim.awk tif2sim.awk


$(PERIPH) : busmacros.h busheader.h config.h include.h addargs_script tif2bif bif2sim.awk tif2sim.awk
	@if [ "$(DEFINES)" = "-D mpmcregistertests" ]; then \
	if [ -f ../../verilog/rtl_source/MpmcParams.v ]; then \
	sed "/REGTEST_RUNNING/ s/1'b0/1'b1/" ../../verilog/rtl_source/MpmcParams.v  > TempParams.v; \
	mv TempParams.v ../../verilog/rtl_source/MpmcParams.v; \
	fi; \
	if [ -f ../../vhdl/rtl_source/MpmcPackage.vhd ]; then \
	sed "/REGTEST_RUNNING/ s/0/1/" ../../vhdl/rtl_source/MpmcPackage.vhd  > TempPackage.vhd; \
	mv TempPackage.vhd ../../vhdl/rtl_source/MpmcPackage.vhd; \
	fi; \
	fi;
	@if [ "$(DEFINES)" != "-D mpmcregistertests" ]; then \
	if [ "$(DEFINES)" != "-D idleport" ]; then \
	if [ -f ../../verilog/rtl_source/MpmcParams.v ]; then \
	sed "/REGTEST_RUNNING/ s/1'b1/1'b0/" ../../verilog/rtl_source/MpmcParams.v  > TempParams.v; \
	mv TempParams.v ../../verilog/rtl_source/MpmcParams.v; \
	fi; \
	if [ -f ../../vhdl/rtl_source/MpmcPackage.vhd ]; then \
	sed "/REGTEST_RUNNING/ s/1/0/" ../../vhdl/rtl_source/MpmcPackage.vhd  > TempPackage.vhd; \
	mv TempPackage.vhd ../../vhdl/rtl_source/MpmcPackage.vhd; \
	fi; \
	fi \
	fi;

	@gcc -ansi $(DEFINES) -D INFILE=$(INFILE) -E $(PERIPH).c > $(PERIPH)_Pre.c
	@nawk -f addargs_script $(PERIPH)_Pre.c
#       If the invec directory doesn't exist, create it.
	@if [ ! -d invec ] ; then \
	mkdir invec ; fi ;
#       If not TIF only, create the BIF vectors
	@if [ "$(VECT_TYPE)" != "TIF" ]; then \
	gcc -ansi -include $(PERIPH).h -include include.h -g temp.$(PERIPH)_Pre.c -o $(PERIPH); \
	$(PERIPH) > invec/infile$(INFILE).tif; \
	tif2bif invec/infile$(INFILE); \
	awk -f bif2sim.awk < invec/infile$(INFILE).bif > invec/bif$(INFILE).sim; \
	rm invec/infile$(INFILE).tif; \
	fi ;
#       If not BIF only, create TIF vectors
	@if [ "$(VECT_TYPE)" != "BIF" ]; then \
	gcc -ansi -include $(PERIPH).h -include include.h -D TIF -g temp.$(PERIPH)_Pre.c -o $(PERIPH); \
	$(PERIPH) > invec/infile$(INFILE).tif; \
	awk -f tif2sim.awk < invec/infile$(INFILE).tif > invec/tif$(INFILE).sim;  \
	fi ;
#       Remove intermediary files
	@rm temp.$(PERIPH)_Pre.c $(PERIPH)_Pre.c
	@rm $(PERIPH)

busmacros.h :  $(GLOBAL)/bustalk_ahb/bustest/busmacros.h
	@cp -f $(GLOBAL)/bustalk_ahb/bustest/busmacros.h .

busheader.h :  $(GLOBAL)/bustalk_ahb/bustest/busheader.h
	@cp -f $(GLOBAL)/bustalk_ahb/bustest/busheader.h .

config.h :  $(GLOBAL)/bustalk_ahb/bustest/config.h
	@cp -f $(GLOBAL)/bustalk_ahb/bustest/config.h .

include.h :  $(GLOBAL)/bustalk_ahb/bustest/include.h
	@cp -f $(GLOBAL)/bustalk_ahb/bustest/include.h .

addargs_script :  $(GLOBAL)/bustalk_ahb/bustest/addargs_script
	@cp -f $(GLOBAL)/bustalk_ahb/bustest/addargs_script .

tif2bif :  $(GLOBAL)/bustalk_ahb/bustest/tif2bif
	@cp -f $(GLOBAL)/bustalk_ahb/bustest/tif2bif .

bif2sim.awk :  $(GLOBAL)/bustalk_ahb/bustest/bif2sim.awk
	@cp -f $(GLOBAL)/bustalk_ahb/bustest/bif2sim.awk .

tif2sim.awk :  $(GLOBAL)/bustalk_ahb/bustest/tif2sim.awk
	@cp -f $(GLOBAL)/bustalk_ahb/bustest/tif2sim.awk .

############################## End #####################################
