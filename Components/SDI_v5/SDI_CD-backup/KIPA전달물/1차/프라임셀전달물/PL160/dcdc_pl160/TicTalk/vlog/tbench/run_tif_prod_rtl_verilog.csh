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
# File Name           : run_tif_prod_rtl_verilog.csh,v
# File Revision       : 1.1
#
# Release Information : PL160-REL1v1
#
################################################################################
# Purpose             : Generic script to run batch local simulation,
#                       Model Technology ModelSim simulation of
#                       selected block, Verilog RTL,
#                       TicTalk tb_tic.
#
#                       Located in the /TicTalk/vlog/tbench directory.
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
# libmap files (library mapping) should default to VERILOG RTL.
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

if (($1 == "") || ($1 == "-h") || \
    (($1 != "-m") && ($1 != "-v"))) then
  echo " Script to run production test vector simulations "
  echo " Usage : "
  echo "       run_tif_prod_rtl_verilog.csh <sim>"
  echo "         where"
  echo "         <sim> = -m, to run ModelSim simulator only"
  echo "         <sim> = -v, to run Verilog-XL only"
  echo "  (eg: run_tif_prod_rtl_verilog.csh -m)  "
  exit(0)
endif

echo "======================================"
echo "TicTalk Verilog RTL (.sim) simulations"
echo "======================================"

echo ""

# Change to top-level directory
cd $PERIPH

#-------------------------------------------------------------------------------

if ($1 == "-m") then

  echo "Compiling the Verilog RTL source"
  echo "Performing make clean in verilog/uut directory"
  cd $PERIPH/verilog/uut
  make clean
  cd ../..

  echo "TicTalk VERILOG RTL production test simulation, using ModelSim"

  echo "Editing modeltech libmap to point to VERILOG RTL"
  cd TicTalk/vlog/modeltech
  echo "Make backup copy of original libmap"
  cp libmap libmap.orig
  sed s/^uut/\;uut/g libmap > tmp1
  sed s/';uut = $PERIPH\/verilog\/uut\/'/'uut = $PERIPH\/verilog\/uut\/'/g tmp1 > tmp2
  mv -f tmp2 libmap
  \rm -f tmp1
  cd ../tbench

  # For ModelSim, replace $finish by $stop in tb_tic.v,
  # else sim aborts when complete, before toggle report is done
  # Note: Verilog-XL needs $finish else sim not exited on completion
  echo "Editing reader.v from Verilog system finish to stop ..."
  cp tb_tic.v tb_tic.orig
  sed 's/\$finish/\$stop/g' tb_tic.orig > tb_tic.v

  echo "Create link to the TicTalk test vectors"
  rm -f infile.sim
  ln -s ../../tictests/invec/$PERIPHERAL\_prod.sim infile.sim
  cd ..

  echo "Compiling  TicTalk/vlog directory"
  make clean
  cd tbench

  echo ====================================
  echo RUNNING VERILOG RTL - VSIM
  echo ====================================
  # Run VSIM in command line mode
  vsim -c -lic_vlog tb_tic < init.do
  #make vsim_rtl

  #mv transcript logs/$PERIPHERAL\_tif_prod_rtl_verilog_vsim.log
  mv transcript logs/$PERIPHERAL\.prod.tif.rtl.verilog.vsim.log
  #mv report.untog logs/$PERIPHERAL\_tif_prod_rtl_verilog_vsim.untog
  mv report.untog logs/$PERIPHERAL\.prod.tif.rtl.verilog.vsim.untog

#-------------------------------------------------------------------------------

  echo "Restoring tb_tic.v file to default system finish ..."
  cp tb_tic.v tb_tic.tmp
  sed 's/\$stop/\$finish/g' tb_tic.tmp > tb_tic.v
  \rm -f tb_tic.tmp
endif

#-------------------------------------------------------------------------------

if ($1 == "-v") then
  echo "TicTalk VERILOG RTL production test simulation, using Verilog-XL"

  cd $PERIPH/TicTalk/vlog/tbench

  echo "Create link to the TicTalk test vectors"
  rm -f infile.sim
  ln -s ../../tictests/invec/$PERIPHERAL\_prod.sim infile.sim

  echo "Ensure tb_tic.v file defaults to system finish ..."
  # Need $finish in tb_tic.v for verilog-XL, but $stop will not be replaced
  # if abort script in -m ModelSim section.
  cp tb_tic.v tb_tic.tmp
  sed 's/\$stop/\$finish/g' tb_tic.tmp > tb_tic.v
  \rm -f tb_tic.tmp

  echo ====================================
  echo RUNNING VERILOG RTL - VXL
  echo ====================================
  make vxl_rtl
  #verilog +licq_vxl -f vxl.rtl tb_tic.v
  #mv verilog.log logs/$PERIPHERAL\_prod_tif_rtl_verilog_vxl.log
  mv verilog.log logs/$PERIPHERAL\.prod.tif.rtl.verilog.vxl.log
endif

################################################################################ 
#  RUN INSTRUCTIONS
################################################################################ 

# Firstly set environment variables
# either manually or using SourceMe at top-level directory,
# If it exists, run build_$PERIPHERAL e.g. build_dcdc, then source SourceMe.
# Setup the required versions of tools by invoking source SourceTools.
# To run the simulations, execute:

#   run_tif_prod_rtl_verilog.csh -m|-v

####################### End ####################################################


