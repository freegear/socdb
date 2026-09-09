#- --=========================================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2000-2001 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#-------------------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name              : makefile,v
#- File Revision          : 1.4
#-
#- Release Information    : ADK_REL1v1
#-
#-------------------------------------------------------------------------------
#-  Purpose  : 
#-             ADK makefile, compiles verilog rtl for $SIMULATOR
#-
#- --=========================================================================--

MODULES = Ticbox.v 

PERIPH =  Ticbox

.INIT:
	cp $(ADK)/design/Ticbox/bin/tif2sim* . ; \
	rm -rf infile.sim; \
	tif2sim $(TIC_DIR)/$(TEST_NAME).tif > infile.sim


include $(GLOBAL)/$(SIMULATOR)/RtlMakefile.mk

#################################### End #######################################
