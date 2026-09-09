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
#- File Revision          : 1.1
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
	@(cd $(HDL_SOURCE)/rtl_source; \
	  $(GLOBAL)/LDV/vxlfilesRTL.csh $(PERIPH) $(COMPONENTS); \
	  )

components_net:
	@for i in $(COMPONENTS) ; do \
	  (cd $(ADK)/design/$$i; \
	   $(MAKE) netlist) \
	done
	@(if [ -d $(HDL_NETL)/netlist ]; then \
	    cd $(HDL_NETL)/netlist; \
	  else \
	    cd $(HDL_NETL)/rtl_source; \
	  fi; \
	  $(GLOBAL)/LDV/vxlfilesNLS.csh $(PERIPH) $(COMPONENTS); \
	  )


tbeasy:
	@(cd $(HDL_SOURCE); \
	  $(MAKE) all ; \
	)

components_clean:
	@for i in $(COMPONENTS) ; do \
	  (cd $(ADK)/design/$$i; \
	   $(MAKE) clean) \
	done

################################ End ###################################
