#- --=================================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2001 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#- ---------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name              : makefile,v
#- File Revision          : 1.2
#-
#- Release Information    : ADK_REL1v1
#-
#- ---------------------------------------------------------------------
#- Purpose :
#-           A makefile to initiate EASY Multilayer simulations
#-
#- --=================================================================--

PERIPH = EASY_ML

include $(ADK)/design/$(PERIPH)/Components_$(PERIPH).mk

all: components_hdl components_net
	@(cd $(HDL_SOURCE) ; $(MAKE) rtl; )
	@(cd $(HDL_NETL) ; $(MAKE) netlist; )

rtl: components_hdl
	@(cd $(HDL_SOURCE) ; $(MAKE) rtl; )

netlist: components_net
	@(cd $(HDL_NETL) ; $(MAKE) netlist; )

clean: components_clean
	@(cd vhdl ;    $(MAKE) clean; )
	@(cd verilog ; $(MAKE) clean; )
	@(cd synopsys ; $(MAKE) clean; )

include $(GLOBAL)/$(SIMULATOR)/StructMakefile.mk

################################ End ###################################
