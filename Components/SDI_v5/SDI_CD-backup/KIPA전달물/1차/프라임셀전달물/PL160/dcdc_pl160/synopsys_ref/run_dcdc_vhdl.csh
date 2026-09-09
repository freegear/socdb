#!/bin/csh -f

################################################################################
# This confidential and proprietary software may be used only as
# authorised by a licensing agreement from ARM Limited
#   (C) COPYRIGHT 1999 ARM Limited
#       ALL RIGHTS RESERVED
# The entire notice above must be reproduced on all authorised
# copies and copies may only be made to the extent permitted
# by a licensing agreement from ARM Limited.
#
################################################################################
# Version and Release Control Information:
#
# File Name           : run_dcdc_vhdl.csh,v
# File Revision       : 1.1
#
# Release Information : PL160-REL1v1
#
################################################################################
# Purpose             : Synopsys synthesis batch mode run script
#                       for DCDC VHDL block.
#
#                       Located in the /synopsys_ref directory.         
#                                                                        
################################################################################
#                       This file runs a synthesis job using dc_shell in
#                       a local work area.
#                                                                        
################################################################################ 

################################################################################ 
#  RUN DC_SHELL LOCALLY
################################################################################ 

echo "Ensure environment variables are set, for example by running UNIX"
echo "source command on file ../SourceMe"
#source ../SourceMe

setenv HDL_IN  vhdl
setenv HDL_OUT vhdl

#setenv TOP_NAME Dcdc
#setenv DESIGN_NAME dcdc

echo "Ensure correct version of synthesis tool has been configured,"
echo "for example, sourcing the appropriate setup file e.g. dotcshrc"
#source /eda/tools/synopsys/1998.02/dotcshrc

cd $PERIPH/synopsys_ref

echo "Synthesizing DCDC block from VHDL source.."
dc_shell -checkout "VHDL-Compiler" < scr_dcdc/dcdc.cmd > log/dcdc_vhdl.log

################################################################################ 
# TO RUN THE SYNTHESIS IN LOCAL SHELL MODE
################################################################################ 
#
# Change to the $PERIPH/synopsys_ref directory and type:
#   run_dcdc_vhdl.csh
#
# Note: For use with design_analyser, the '\' line continuation character
#       will need to be removed.
#

################################## End #########################################
