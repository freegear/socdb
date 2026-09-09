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
#- File Revision	  : 1.4
#-
#- Release Information	  : ADK_REL1v1
#-
#-----------------------------------------------------------------------
#-  Purpose  :
#-	       A standardised makefile to be included in other makefiles
#-----------------------------------------------------------------------

rtl all: $(PERIPH)_rtl.vc vxl.files.rtl

$(PERIPH)_rtl.vc:
	@$(GLOBAL)/LDV/RtlPeriphVC.csh $(MODULES)

vxl.files.rtl:
	@$(GLOBAL)/LDV/vxlfilesRTL.csh $(PERIPH) $(COMPONENTS)


netlist: $(PERIPH)_nls.vc vxl.files.nls

$(PERIPH)_nls.vc:
	@$(GLOBAL)/LDV/NLSPeriphVC.csh $(MODULES)

vxl.files.nls:
	@$(GLOBAL)/LDV/vxlfilesNLS.csh $(PERIPH) $(COMPONENTS)


clean:
	@rm -f $(PERIPH)*.vc
	@rm -f vxl.files.*
	@rm -rf work
	@rm -f work.mk
	@rm -f modelsim.ini
	@rm -f EASYlibmap
	@rm -f transcript

cover:	


################################ End ###################################
