#- --=========================================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2000-2001 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#- -----------------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name              : makefile,v
#- File Revision          : 1.4
#-
#- Release Information    : ADK_REL1v1
#-
#- -----------------------------------------------------------------------------
#- Purpose : 
#-           ADK makefile, behavioural component top level 
#-
#- --=========================================================================--

# all: makes all hdl source files in the component world
all:
	@(cd $(HDL_SOURCE) ; $(MAKE) rtl; )
	@(cd $(HDL_NETL) ; $(MAKE) rtl; )

# rtl: makes only the hdl source files in the component world
rtl:
	@(cd $(HDL_SOURCE) ; $(MAKE) rtl; )

# netlist: no netlist to create for behavioural component
netlist :  
	@(cd $(HDL_NETL) ; $(MAKE) rtl; )

# clean: removes all files and libraries created during a build
clean :  
	@(cd  vhdl ; $(MAKE) clean; ) 
	@(cd  verilog ; $(MAKE) clean; ) 

#################################### End #######################################
