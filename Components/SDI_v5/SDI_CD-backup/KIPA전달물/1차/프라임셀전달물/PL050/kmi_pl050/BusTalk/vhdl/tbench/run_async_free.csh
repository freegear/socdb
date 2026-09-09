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
# File Name           : run_async_free.csh,v
# File Revision       : 1.1
#
# Release Information : PL050-REL1v1
#
################################################################################
# Purpose             : Generic script to run batch local simulation,
#                       async clocks, BusTalk free-running test,
#                       Model Technology ModelSim simulation of
#                       selected block, VHDL RTL.
#
#                       Located in the /BusTalk/vhdl/tbench directory.
################################################################################

################################################################################ 
# RUN SIMULATION
################################################################################ 

echo "Sim: free-running asynchronous clocks, VHDL RTL"
echo "Running simulation ..."
# set the link for the BusTalk test vectors
rm -f infile.bif
ln -s ../../bustests/invec/$PERIPHERAL\_free_asyncclk.bif infile.bif

echo ======================================
echo RUNNING VHDL RTL, FREE, ASYNC CLOCKS
echo ======================================
# Run VSIM in command line mode
vsim -c tb_$PERIPHERAL\_free < init.do

mv transcript logs/$PERIPHERAL\_bif_free_async_rtl_vhdl_vsim.log
#mv report.untog logs/$PERIPHERAL\_bif_free_async_rtl_vhdl_vsim.untog

# Restore free.bif vectors link
rm -f infile.bif
ln -s ../../bustests/invec/$PERIPHERAL\_free.bif infile.bif

################################################################################ 
#  RUN INSTRUCTIONS
################################################################################ 

# Firstly set environment variables
# either manually or using SourceMe at top-level directory,
# If it exists, run build_$PERIPHERAL e.g. build_kmi, then source SourceMe.
# Setup the required versions of tools by invoking source SourceTools.
# To run the simulations, execute:

#   run_async_free.csh 

####################### End ####################################################

