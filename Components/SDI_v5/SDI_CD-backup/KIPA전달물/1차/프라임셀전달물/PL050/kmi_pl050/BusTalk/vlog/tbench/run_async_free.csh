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
#                       selected block, Verilog RTL,
#
#                       Located in the /BusTalk/vlog/tbench directory.
################################################################################

################################################################################ 
# RUN SIMULATION
################################################################################ 

echo "Sim: free-running asynchronous clocks, VERILOG RTL"
# set the link for the BusTalk test vectors, free-running, async clocks
cd ../reader
rm -f infile.sim
ln -s ../../bustests/invec/$PERIPHERAL\_free_asyncclk.sim infile.sim
cd ..
echo "Compiling  BusTalk/vlog directory"
make clean
cd tbench
# Note: compilation done last for Verilog to update file pointer

echo ======================================
echo RUNNING VERILOG RTL, FREE, ASYNC CLOCKS
echo ======================================
# Run VSIM in command line mode
echo "Running simulation ..."
vsim -c tb_$PERIPHERAL\_free < init.do
#make vsim_rtl_free

mv transcript logs/$PERIPHERAL\_bif_free_async_rtl_verilog_vsim.log
#mv report.untog logs/$PERIPHERAL\_bif_free_async_rtl_verilog_vsim.untog

# Restore free.bif vectors link
cd ../reader
rm -f infile.sim
ln -s ../../bustests/invec/$PERIPHERAL\_free_asyncclk.sim infile.sim
cd ..

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

