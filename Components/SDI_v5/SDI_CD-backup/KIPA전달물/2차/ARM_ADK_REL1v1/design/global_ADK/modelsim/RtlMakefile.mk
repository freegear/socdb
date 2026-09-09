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
#- File Name		  : RtlMakefile.mk,v
#- File Revision	  : 1.20
#-
#- Release Information	  : ADK_REL1v1
#-
#-----------------------------------------------------------------------
#-  Purpose  :
#-	       A standardised makefile to be included in other makefiles
#-----------------------------------------------------------------------

all rtl netlist: work.mk
	@$(MAKE) -f work.mk whole_library

clean:	
	@rm -rf work
	@rm -f work.mk
	@rm -f modelsim.ini
	@rm -f EASYlibmap
	@rm -f transcript
	@rm -f $(PERIPH).vc
	@rm -f vxl.files.*

work.mk: work/_info
	@vmake > work.mk

work/_info: EASYlibmap modelsim.ini $(MODULES)
	@\rm -fr work
	@vlib work
	@for CodeFile in $(MODULES) ; do \
	  ftype=`echo $$CodeFile | awk -F. '{ i = NF }{print $$i}'`; \
	  if [ $$ftype = 'vhd' ]; then \
	    if [ -s $$CodeFile ]; then \
	      echo "Compiling " $$CodeFile; \
	      vcom -explicit -just p $$CodeFile; \
	      vcom -explicit -just e $$CodeFile; \
	      vcom -explicit $$CodeFile; \
	    else \
	      echo "** ADK: WARNING: File $$CodeFile does not exist"; \
	    fi;\
	  else \
	    if [ -s $$CodeFile ]; then \
	      echo "Compiling " $$CodeFile; \
	      vlog -compat $$CodeFile; \
	    else \
	      echo "** ADK: WARNING: File $$CodeFile does not exist"; \
	    fi;\
	  fi; \
	done

modelsim.ini:
	@dir_hdl=`pwd | awk -F/ '{i = NF-1}{print $$i}'`; \
	cp -f $(GLOBAL)/modelsim/modelsim.$$dir_hdl modelsim.ini; \

EASYlibmap:
	@dir_hdl=`pwd | awk -F/ '{ i = NF-1 }{print $$i}'`; \
	dir_type=`pwd | awk -F/ '{ i = NF }{print $$i}'`; \
	if [ $$dir_type = "rtl_source" ]; then \
	  $(GLOBAL)/modelsim/$${dir_hdl}RTLlibmap.csh $(PERIPH) $(COMPONENTS); \
	else \
	  $(GLOBAL)/modelsim/$${dir_hdl}NLSlibmap.csh $(PERIPH) $(COMPONENTS); \
	fi


################################ End ###################################
