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
# File Name           : run_dcdc_scan_verilog.csh,v
# File Revision       : 1.1
#
# Release Information : PL160-REL1v1
#
################################################################################
# Purpose             : Synopsys synthesis batch mode run script
#                       for DCDC VERILOG block.
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

setenv HDL_IN  verilog
setenv HDL_OUT verilog

#setenv TOP_NAME Dcdc
#setenv DESIGN_NAME dcdc
#setenv SCANTEST 1

echo "Ensure correct version of synthesis tool has been configured,"
echo "for example, sourcing the appropriate setup file e.g. dotcshrc"
#source /eda/tools/synopsys/1998.02/dotcshrc

cd $PERIPH/synopsys_ref

echo "Synthesizing DCDC block from VERILOG source.."
dc_shell -checkout "Test-Compiler" < scr_scan/dcdc_scan.cmd > log/dcdc_scan_verilog.log


################################################################################ 
# TO RUN THE SYNTHESIS IN LOCAL SHELL MODE
################################################################################ 
#
# Change to the $PERIPH/synopsys_ref directory and for non-scan synthesis type:
#   run_dcdc_scan_verilog.csh
#
# To submit internal ARM Batch job using LSF (Load Sharing Facility) type:
#   bsub -R " solaris && TestCompiler > 0 " -q synopsys -o job.log run_dcdc_scan_verilog.csh
#
# Note: For use with design_analyser, the '\' line continuation character
#       will need to be removed.
#

################################## End #########################################
