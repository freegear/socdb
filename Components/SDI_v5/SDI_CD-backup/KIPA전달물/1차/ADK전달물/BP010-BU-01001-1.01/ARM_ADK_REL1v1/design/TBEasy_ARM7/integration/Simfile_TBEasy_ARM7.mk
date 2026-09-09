#-----------------------------------------------------------------------
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2000-2001 ARM Limited
#-	 ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#-----------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name           : Simfile_TBEasy_ARM7.mk,v
#- File Revision       : 1.6
#-
#- Release Information : ADK_REL1v1
#-
#-----------------------------------------------------------------------
#-  Purpose            : A makefile to run ADK simulations 
#-----------------------------------------------------------------------

infile: rom extram intram update_modelsim

rom:
	@if [ "$(ADSUNIX)" = "yes" ] ; then \
	   cd $(ADSCODE)/build ; $(MAKE) TEST_NAME_ROM=$(TEST_NAME_ROM) ;\
	fi
	@rm -f rom?.dat
	@ln -s $(ADSCODE)/build/EASY_Data/$(TEST_NAME_ROM)/rom0 rom0.dat
	@ln -s $(ADSCODE)/build/EASY_Data/$(TEST_NAME_ROM)/rom1 rom1.dat
	@ln -s $(ADSCODE)/build/EASY_Data/$(TEST_NAME_ROM)/rom2 rom2.dat
	@ln -s $(ADSCODE)/build/EASY_Data/$(TEST_NAME_ROM)/rom3 rom3.dat

extram:
	@rm -f extram??.dat
	@ln -s ../../extram/extram??.dat .

intram:
	@rm -f intram.dat
	@ln -s ../../intram/intram.dat .

filestim.frd:
	@echo "No filestim.frd required for TBEasy_ARM7"

update_modelsim:
	@-if [ "${SIMULATOR}" = "modelsim" ] ; then \
	  if [ "`basename \`pwd\``" = "${TEST_BENCH}_rtl" ] ; then \
	    hdl_type=${HDL_SOURCE} ; \
	  else \
	    hdl_type=${HDL_NETL} ; \
	  fi ; \
	  if [ "$$hdl_type" = "verilog" ] ; then \
	    Veriuser_exists=`grep Veriuser modelsim.ini` ; \
	    if [ "$$Veriuser_exists" = "" ] ; then \
	      echo "Veriuser = \$$MG_LIB/mti_modelsim_verilog/libmgmm.so" >> modelsim.ini ; \
	    fi ; \
	  fi ; \
	fi

