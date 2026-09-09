#-----------------------------------------------------------------------
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2000-2001 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#-----------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name              : StructMakefile.mk,v
#- File Revision          : 1.3
#-
#- Release Information    : ADK_REL1v1
#-
#-----------------------------------------------------------------------
#-  Purpose  :
#-             A makefile to build the EASY world ready for simulation 
#-----------------------------------------------------------------------


components_hdl:
	@for i in $(COMPONENTS) ; do \
	  (cd $(ADK)/design/$$i; \
	   $(MAKE) rtl) \
	done

components_net:
	@for i in $(COMPONENTS) ; do \
	  (cd $(ADK)/design/$$i; \
	   $(MAKE) netlist) \
	done

components_clean:
	@for i in $(COMPONENTS) ; do \
	  (cd $(ADK)/design/$$i; \
	   $(MAKE) clean) \
	done

################################ End ###################################
