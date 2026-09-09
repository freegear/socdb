#- --=========================================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2001-2002 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#- -----------------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name              : makefile.rca
#- File Revision          : 1.7
#-
#- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
#-
#- -----------------------------------------------------------------------------
#- Purpose :
#-           A makefile to control peripheral development 
#-
#- -----------------------------------------------------------------------------
#- 
#- Note    : 
#-           The environment variables, and EDA tools as specified in the 
#-           User Guide (or the README file) must be setup before this 
#-           makefile can be used.
#-
#- --=========================================================================--

# ------------------------------------------------------------------------------
# Make all
#
# Compile the RTL and/or netlist.
# The compilation target is dependant on the TEST_METH, HDL_SOURCE and 
# HDL_NETL environment variables.

all:
	@(cd $(HDL_SOURCE) ; make all; )

# ------------------------------------------------------------------------------
# Make netlist
#
# Synthesise the design.
# The synthesis target is dependant on the TEST_METH, HDL_SOURCE and HDL_NETL
# environment variables.

netlist :
	@(cd  synopsys; make netlist; )

# ------------------------------------------------------------------------------
# Make rtl
#
# Compile the RTL and verification testbench code and execute a verification
# test.
#
# Prerequisites: 
# A verification test must be built prior to executing this command.
# Verification tests are built by 'cd'ing into the verification/bustest
# directory and making an appropriate test.
#
# The compilation target is dependant on the HDL_SOURCE environment variable.

rtl: 
	@(cd  verification ; make rtl; ) 

# ------------------------------------------------------------------------------
# Make net_max
#
# Compile the HDL and verification testbench code and execute a verification 
# test on the netlist using the maximum SDF.
#
# Prerequisites: 
# The appropriate netlist must be synthesised, and verification test built
# prior to running this command.
# A netlist can be synthesised by using the 'make netlist' command.
# Verification tests are built by 'cd'ing into the verification/bustest
# directory and making an appropriate test.
#
# The compilation target is dependant on the TEST_METH, HDL_SOURCE and 
# HDL_NETL environment variables. 

net_max :  
	@(cd  verification ; make net_max; ) 

# ------------------------------------------------------------------------------
# Make net_typ
#
# Compile the HDL and verification testbench code and execute a verification 
# test on the netlist using the typical SDF.
#
# Prerequisites: 
# The appropriate netlist must be synthesised, and verification test built
# prior to running this command.
# A netlist can be synthesised by using the 'make netlist' command.
# Verification tests are built by 'cd'ing into the verification/bustest
# directory and making an appropriate test.
#
# The compilation target is dependant on the TEST_METH, HDL_SOURCE and 
# HDL_NETL environment variables.

net_typ : 
	@(cd  verification ; make net_typ; ) 

# ------------------------------------------------------------------------------
# Make net_min
#
# Compile the HDL and verification testbench code and execute a verification 
# test on the netlist using the minimum SDF.
#
# Prerequisites: 
# The appropriate netlist must be synthesised, and verification test built
# prior to running this command.
# A netlist can be synthesised by using the 'make netlist' command.
# Verification tests are built by 'cd'ing into the verification/bustest
# directory and making an appropriate test.
#
# The compilation target is dependant on the TEST_METH, HDL_SOURCE and 
# HDL_NETL environment variables.

net_min : 
	@(cd  verification ; make net_min; ) 

# ------------------------------------------------------------------------------
# Make cover
#
# Compile the RTL and verification testbench code, execute a verification
# test providing code coverage values.
#
# Prerequisites:
# A verification test must be built prior to executing this command.
# Verification tests are built by 'cd'ing into the verification/bustest
# directory and making an appropriate test.
#
# The compilation target is dependant on the HDL_SOURCE environment variable.

cover :  
	@(cd  verification; make cover; )


# ------------------------------------------------------------------------------
# Make clean
#
# Clean files.
#
# vhdl deletes the subdirectories: 
#   rtl_source/work, netlist/work
# verilog deletes the subdirectories: 
#   rtl_source/work, netlist/work
# verification deletes the subdirectories: 
#   verification/bustest/invec
#   verification/verilog/bid/work, verification/verilog/buswatcher/work, 
#   verification/verilog/common/work, verification/verilog/tbench/vr/work, 
#   verification/verilog/trickbox/vr/work, verification/verilog/vr/work
# integration deletes the subdirectories: 
#   integration/bustest/invec, 
#   integration/verilog/chip/work, integration/verilog/sys/work, 
#   integration/verilog/tbench/work, integration/verilog/ticbox/work,
#   integration/verilog/trickbox/work
#   integration/vhdl/chip/work, integration/vhdl/sys/work, 
#   integration/vhdl/tbench/work, integration/vhdl/ticbox/work,
#   integration/vhdl/trickbox/work
# synopsys deletes the subdirectories: 
#   synopsys/log, synopsys/report, synopsys/db and synopsys/work.
#
# To clean only individual directories, 'cd' to the appropriate directory
# and type 'make clean'.

clean :  
	@(cd  vhdl ; make clean; ) 
	@(cd  verilog ; make clean; ) 
	@(cd  verification ; make clean; ) 
	@(cd  integration ; make clean; ) 
	@(cd  synopsys; make clean; )

#################################### End #######################################
