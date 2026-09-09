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
# File Name           : run_tif_prod_net_vhdl.csh,v
# File Revision       : 1.1
#
# Release Information : PL050-REL1v1
#
################################################################################
# Purpose             : Generic script to run batch local simulation of,
#                       selected block, VHDL gate-level netlists,
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
# to define environment variables e.g. $PERIPH.
# All simulation test pattern files must exist (be compiled).
# libmap files (library mapping) must default to VHDL RTL.
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


# This script will compile the netlist unless env var $MULTISIM != "" e.g. 1
# Setting $MULTISIM 1 allows concurrent gate-level simulations

# Set ModelSim command line options
set VSIMOPT = " -c -lic_vhdl +no_glitch_msg "

echo "=================================================="
echo "TicTalk VHDL gate-level Netlist (.tif) simulations"
echo "=================================================="

echo ""
echo "Changing to top-level directory"
cd $PERIPH

if ($?MULTISIM) then
  echo "No compile of VHDL netlist, assumed done manually"
else
  echo "Compiling the VHDL gate-level netlist"
  echo "Performing make clean in vhdl/uutNetlist directory"
  cd vhdl/uutNetlist
  make clean
  cd ../..
endif

#-------------------------------------------------------------------------------

echo "TicTalk VHDL production tif gate-level simulation"

echo "Editing modeltech libmap to point to VHDL Netlist"
cd TicTalk/vhdl/modeltech
echo "Make backup copy of original libmap"
cp libmap libmap.orig
sed s/^uut/\;uut/g libmap > tmp1
sed s/';uut = $PERIPH\/vhdl\/uutNetlist\/'/'uut = $PERIPH\/vhdl\/uutNetlist\/'/g tmp1 > tmp2
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

echo ==========================================
echo RUNNING VHDL NETLIST, MAX TIMING - VSIM
echo ==========================================
# Run VSIM in command line mode for SDF max
vsim $VSIMOPT \
 -sdfmax u_easy/u_rps/u$PERIPHERAL=../../../vhdl/uutNetlist/$PERIPHERAL\_Vhdl.sdf21 \
 -L libvhdl \
 tb_tic < init.do
#make vsim_net_max

#mv transcript logs/$PERIPHERAL\_tif_prod_net_vhdl_max_vsim.log
mv transcript logs/$PERIPHERAL\.prod.tif.net.vhdl.max.vsim.log
mv report.untog logs/$PERIPHERAL\.prod.tif.net.vhdl.max.vsim.untog

echo ==========================================
echo RUNNING VHDL NETLIST, MIN TIMING - VSIM
echo ==========================================
# Run VSIM in command line mode for SDF min
vsim $VSIMOPT \
 -sdfmin u_easy/u_rps/u$PERIPHERAL=../../../vhdl/uutNetlist/$PERIPHERAL\_Vhdl.sdf21 \
 -L libvhdl \
 tb_tic < init.do
#make vsim_net_min

#mv transcript logs/$PERIPHERAL\_tif_prod_net_vhdl_min_vsim.log
mv transcript logs/$PERIPHERAL\.prod.tif.net.vhdl.min.vsim.log
#mv report.untog logs/$PERIPHERAL\_tif_prod_net_vhdl_vsim.untog
mv report.untog logs/$PERIPHERAL\.prod.tif.net.vhdl.min.vsim.untog

#-------------------------------------------------------------------------------

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
# If it exists, run build_$PERIPHERAL e.g. build_kmi, then source SourceMe.
# Setup the required versions of tools by invoking source SourceTools.
# To run the simulations, execute:

#   run_tif_prod_net_vhdl.csh

###################################### End #####################################
