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
# File Name           : run_bif_all_rtl_vhdl.csh,v
# File Revision       : 1.1
#
# Release Information : PL160-REL1v1
#
################################################################################
# Purpose             : Generic script to run batch local simulation,
#                       Model Technology ModelSim simulation of
#                       selected block, VHDL RTL,
#                       BusTalk tb_$PERIPHERAL, tb_$PERIPHERAL\_free.
#
#                       Located in the /BusTalk/vhdl/tbench directory.
################################################################################

################################################################################ 
# RUN SIMULATION
################################################################################ 

# ASSUMPTIONS
# ===========
# Model Technology simulation tools must have been sourced
#   e.g. source /eda/tools/modeltech/5.1e/dotcshrc
# source the SourceMe file in top level directory,
# to define environment variables e.g. $PERIPH, etc
# All simulation test pattern files must exist (be compiled).
# All libmap files (library mapping) default to VHDL RTL.
################################################################################ 
#
# IMPORTANT :
#   A backup copy of the libmap file is made to
#   libmap.orig since libmap is edited by this script.
#
################################################################################ 

################################################################################ 
#
# The following path is set using an environment variable declared by
# the SourceMe file in the top-level directory.
# All subsequent paths are relative to this path definition.
#
################################################################################ 

# Default 0 for no async clocks simualtions, set non-zero to run async sims.
set ASYNC = 0

echo "==================================="
echo "BusTalk VHDL RTL (.bif) simulations"
echo "==================================="

echo ""
echo "Changing to top-level directory"
cd $PERIPH

echo "Compiling the VHDL RTL source"
echo "Performing make clean in vhdl/uut directory"
cd vhdl/uut
make clean
cd ../..

################################################################################ 

echo "Editing modeltech libmap to point to VHDL RTL"
cd BusTalk/vhdl/modeltech
echo "Make backup copy of original libmap"
cp libmap libmap.orig
sed s/^uut/\;uut/g libmap > tmp1
sed s/';uut = $PERIPH\/vhdl\/uut\/'/'uut = $PERIPH\/vhdl\/uut\/'/g tmp1 > tmp2
mv -f tmp2 libmap
\rm -f tmp1
cd ..

echo "Compiling  BusTalk/vhdl directory"
make clean
cd tbench

#-------------------------------------------------------------------------------
echo "Sim1: production, VHDL RTL"
echo "Running simulation ..."
# set the link for the BusTalk test vectors
rm -f infile.bif
ln -s ../../bustests/invec/$PERIPHERAL\_prod.bif infile.bif

echo ======================================
echo RUNNING VHDL RTL, PROD
echo ======================================
# Run VSIM in command line mode
vsim -c tb_$PERIPHERAL < init.do

#mv transcript logs/$PERIPHERAL\_bif_prod_rtl_vhdl_vsim.log
mv transcript logs/$PERIPHERAL\.prod.bif.rtl.vhdl.vsim.log
#mv report.untog logs/$PERIPHERAL\_bif_prod_rtl_vhdl_vsim.untog
mv report.untog logs/$PERIPHERAL\.prod.bif.rtl.vhdl.vsim.untog

#-------------------------------------------------------------------------------
echo "Sim2: free-running synchronous clocks, VHDL RTL"
echo "Running simulation ..."
# set the link for the BusTalk test vectors
rm -f infile.bif
#ln -s ../../bustests/invec/$PERIPHERAL\_free_syncclk.bif infile.bif
ln -s ../../bustests/invec/$PERIPHERAL\_free.bif infile.bif

echo ======================================
echo RUNNING VHDL RTL, FREE, SYNC CLOCKS
echo ======================================
# Run VSIM in command line mode
vsim -c tb_$PERIPHERAL\_free < init.do

#mv transcript logs/$PERIPHERAL\_bif_free_sync_rtl_vhdl_vsim.log
mv transcript logs/$PERIPHERAL\.free.bif.rtl.vhdl.vsim.log
#mv report.untog logs/$PERIPHERAL\_bif_free_sync_rtl_vhdl_vsim.untog

#-------------------------------------------------------------------------------
if (ASYNC == 1) then
  echo "Sim3: free-running pseudo-asynchronous clocks, VHDL RTL"
  echo "Running simulation ..."
  # set the link for the BusTalk test vectors
  rm -f infile.bif
  ln -s ../../bustests/invec/$PERIPHERAL\_free_psasyncclk.bif infile.bif

  echo ======================================
  echo RUNNING VHDL RTL, FREE, PSASYNC CLOCKS
  echo ======================================
  # Run VSIM in command line mode
  vsim -c tb_$PERIPHERAL\_free < init.do

  mv transcript logs/$PERIPHERAL\_bif_free_psasync_rtl_vhdl_vsim.log
  mv report.untog logs/$PERIPHERAL\_bif_free_psasync_rtl_vhdl_vsim.untog

#-------------------------------------------------------------------------------
  echo "Sim4: free-running asynchronous clocks, VHDL RTL"
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
  mv report.untog logs/$PERIPHERAL\_bif_free_async_rtl_vhdl_vsim.untog
endif

################################################################################ 

echo "Restoring libmap file to default uut to VHDL RTL ..."
cd ../modeltech
sed s/^uut/\;uut/g libmap > tmp1
sed s/';uut = $PERIPH\/vhdl\/uut\/'/'uut = $PERIPH\/vhdl\/uut\/'/g tmp1 > tmp2
mv -f tmp2 libmap
\rm -f tmp1

################################################################################ 
#  RUN INSTRUCTIONS
################################################################################ 

# Firstly set environment variables
# either manually or using SourceMe at top-level directory,
# If it exists, run build_$PERIPHERAL e.g. build_dcdc, then source SourceMe.
# Setup the required versions of tools by invoking source SourceTools.
# To run the simulations, execute:

#   run_bif_all_rtl_vhdl.csh

####################### End ####################################################
