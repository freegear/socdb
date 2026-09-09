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
# File Name           : run_tif_prod_rtl_vhdl.csh,v
# File Revision       : 1.1
#
# Release Information : PL050-REL1v1
#
################################################################################
# Purpose             : Generic script to run batch local simulation,
#                       Model Technology ModelSim simulation of
#                       selected block, VHDL RTL,
#                       TicTalk tb_tic.
#
#                       Located in the /TicTalk/vhdl/tbench directory.
################################################################################

################################################################################ 
# RUN SIMULATION
################################################################################ 

# ASSUMPTIONS
# ===========
# Simulation tools must have been sourced
#   e.g. source /eda/tools/modeltech/5.1e/dotcshrc
# source the SourceMe file in top level directory,
# to define environment variables e.g. $PERIPH, etc.
# All simulation test pattern files must exist (be compiled).
# libmap files (library mapping) should default to VHDL RTL.
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

echo "==================================="
echo "TicTalk VHDL RTL (.tif) simulations"
echo "==================================="

echo ""
echo "Changing to top-level directory"
cd $PERIPH

echo "Compiling the VHDL RTL source"
echo "Performing make clean in vhdl/uut directory"
cd vhdl/uut
make clean
cd ../..


#-------------------------------------------------------------------------------
echo "TicTalk VHDL production tif simulation"

echo "Editing modeltech libmap to point to VHDL RTL"
cd TicTalk/vhdl/modeltech
echo "Make backup copy of original libmap"
cp libmap libmap.orig
sed s/^uut/\;uut/g libmap > tmp1
sed s/';uut = $PERIPH\/vhdl\/uut\/'/'uut = $PERIPH\/vhdl\/uut\/'/g tmp1 > tmp2
mv -f tmp2 libmap
\rm -f tmp1
cd ../tbench

# set the link for the TicTalk test vectors
rm -f infile.tif
ln -s ../../tictests/invec/$PERIPHERAL\_prod.tif infile.tif
cd ..

echo "Compiling TicTalk/vhdl directory"
make clean
cd tbench

echo ====================================
echo RUNNING VHDL RTL - VSIM
echo ====================================
# Run VSIM in command line mode
vsim -c tb_tic < init.do
#make vsim_rtl

#mv transcript logs/$PERIPHERAL\_tif_prod_rtl_vhdl_vsim.log
mv transcript logs/$PERIPHERAL\.prod.tif.rtl.vhdl.vsim.log
#mv report.untog logs/$PERIPHERAL\_tif_prod_rtl_vhdl_vsim.untog
mv report.untog logs/$PERIPHERAL\.prod.tif.rtl.vhdl.vsim.untog


################################################################################ 
#  RUN INSTRUCTIONS
################################################################################ 

# Firstly set environment variables
# either manually or using SourceMe at top-level directory,
# If it exists, run build_$PERIPHERAL e.g. build_kmi, then source SourceMe.
# Setup the required versions of tools by invoking source SourceTools.
# To run the simulations, execute:

#   run_tif_prod_rtl_vhdl.csh

####################### End ####################################################


