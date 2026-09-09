#- --===============================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2001 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#- -------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name              : makefile,v
#- File Revision          : 1.2
#-
#- Release Information    : ADK_REL1v1
#-
#- -------------------------------------------------------------------
#- Purpose : 
#-           ADK makefile, component top level 
#-
#- --===============================================================--

# all: prepare for simulation all hdl and netlist source files in the
# component world
all:
	@(cd $(HDL_SOURCE) ; $(MAKE) rtl; )
	@(cd $(HDL_NETL) ; $(MAKE) netlist; )

# rtl: prepare only the hdl source files in the component world
rtl:
	@(cd $(HDL_SOURCE) ; $(MAKE) rtl; )

# netlist: prepare only the netlist source files in the component
# world
netlist :  
	@(cd $(HDL_NETL) ; $(MAKE) netlist; )

# clean: removes all files and libraries created during a build
clean :  
	@(cd  vhdl ; $(MAKE) clean; ) 
	@(cd  verilog ; $(MAKE) clean; ) 
	@(cd  synopsys; $(MAKE) clean; )

############################### End ##################################
