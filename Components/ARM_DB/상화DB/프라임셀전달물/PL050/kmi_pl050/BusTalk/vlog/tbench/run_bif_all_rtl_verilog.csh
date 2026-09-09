#!/bin/csh -f

################################################################################
# This confidential and proprietary software may be used only as
# authorised by a licensing agreement from ARM Limited
#   (C) COPYRIGHT 1998 ARM Limited
#       ALL RIGHTS RESERVED
# The entire notice above must be reproduced on all authorised
# copies and copies may only be made to the extent permitted
# by a licensing agreement from ARM Limited.
#
################################################################################
# Version and Release Control Information:
#
# File Name           : run_bif_all_rtl_verilog.csh,v
# File Revision       : 1.1
#
# Release Information : PL050-REL1v1
#
################################################################################
# Purpose             : Generic script to run batch local simulation of,
#                       selected block, VERILOG RTL,
#                       BusTalk tb_$PERIPHERAL, tb_$PERIPHERAL\_free.
#
#                       Located in the /BusTalk/vlog/tbench directory.
################################################################################

################################################################################ 
# RUN SIMULATION
################################################################################ 

# ASSUMPTIONS
# ===========
# Simulation tools must have been sourced
#   e.g. source /eda/tools/modeltech/5.1e/dotcshrc
# source the SourceMe file in top level directory,
# to define environment variables e.g. $PERIPH, etc
# All simulation test pattern files must exist (be compiled).
# All libmap files (library mapping) default to VERILOG RTL.
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
    (($1 != "-m") && ($1 != "-v")))  then
  echo " Script to run BusTalk test vector simulations "
  echo " Usage : "
  echo "       run_all_bif_rtl.csh <sim>"
  echo "         where"
  echo "         <sim> = -m, to run ModelSim simulator only"
  echo "         <sim> = -v, to run Verilog-XL only"
  echo "  (eg: run_all_bif_rtl.csh -m)  "
  exit(0)
endif

# Default 0 for no async clocks simualtions, set non-zero to run async sims.
set ASYNC = 0

echo "======================================"
echo "BusTalk Verilog RTL (.sim) simulations"
echo "======================================"

echo ""

# Change to top-level directory
cd $PERIPH

################################################################################ 

if ($1 == "-m") then

  echo "Compiling the VERILOG RTL source"
  echo "Performing make clean in verilog/uut directory"
  cd $PERIPH/verilog/uut
  make clean
  cd ../..

  echo "BusTalk VERILOG RTL bif simulations, using ModelSim"

  echo "Editing modeltech libmap to point to VERILOG RTL"
  cd BusTalk/vlog/modeltech
  echo "Make backup copy of original libmap"
  cp libmap libmap.orig
  sed s/^uut/\;uut/g libmap > tmp1
  sed s/';uut = $PERIPH\/verilog\/uut\/'/'uut = $PERIPH\/verilog\/uut\/'/g tmp1 > tmp2
  mv -f tmp2 libmap
  \rm -f tmp1

  # For ModelSim, replace $finish by $stop in reader.v,
  # else sim aborts when complete, before toggle report is done
  # Note: Verilog-XL needs $finish else sim not exited on completion
  echo "Editing reader.v from Verilog system finish to stop ..."
  cd ../reader
  cp reader.v reader.orig
  sed 's/\$finish/\$stop/g' reader.orig > reader.v
  cd ../tbench

#-------------------------------------------------------------------------------

  echo "Sim1: production, VERILOG RTL"
  # set the link for the BusTalk test vectors, production
  cd ../reader
  rm -f infile.sim
  ln -s ../../bustests/invec/$PERIPHERAL\_prod.sim infile.sim
  cd ..
  echo "Compiling BusTalk/vlog directory"
  make clean
  cd tbench
# Note: compilation done last for Verilog to update file pointer

  echo ======================================
  echo RUNNING VERILOG RTL, PROD
  echo ======================================
  # Run VSIM in command line mode
  echo "Running simulation ..."
  vsim -c tb_$PERIPHERAL < init.do
#  make vsim_rtl

  #mv transcript logs/$PERIPHERAL\_bif_prod_rtl_verilog_vsim.log
  mv transcript logs/$PERIPHERAL\.prod.bif.rtl.verilog.vsim.log
  #mv report.untog logs/$PERIPHERAL\_bif_prod_rtl_verilog_vsim.untog
  mv report.untog logs/$PERIPHERAL\.prod.bif.rtl.verilog.vsim.untog

#-------------------------------------------------------------------------------

  echo "Sim2: free-running synchronous clocks, VERILOG RTL"
  # set the link for the BusTalk test vectors, free-running, sync clocks
  cd ../reader
  rm -f infile.sim
  #ln -s ../../bustests/invec/$PERIPHERAL\_free_syncclk.sim infile.sim
  ln -s ../../bustests/invec/$PERIPHERAL\_free.sim infile.sim
  cd ..
  echo "Compiling BusTalk/vlog directory"
  make clean
  cd tbench
# Note: compilation done last for Verilog to update file pointer

  echo ======================================
  echo RUNNING VERILOG RTL, FREE, SYNC CLOCKS
  echo ======================================
  # Run VSIM in command line mode
  vsim -c tb_$PERIPHERAL\_free < init.do
#  make vsim_rtl_free

  #mv transcript logs/$PERIPHERAL\_bif_free_sync_rtl_verilog_vsim.log
  mv transcript logs/$PERIPHERAL\.free.bif.rtl.verilog.vsim.log
  #mv report.untog logs/$PERIPHERAL\_bif_free_sync_rtl_verilog_vsim.untog

#-------------------------------------------------------------------------------
  if (ASYNC == 1) then
    echo "Sim3: free-running pseudo-asynchronous clocks, VERILOG RTL"
    echo "Running simulation ..."
    # set the link for the BusTalk test vectors, free-running, pseudo-async clocks
    cd ../reader
    rm -f infile.sim
    ln -s ../../bustests/invec/$PERIPHERAL\_free_psasyncclk.sim infile.sim
    cd ..
    echo "Compiling  BusTalk/vlog directory"
    make clean
    cd tbench
    # Note: compilation done last for Verilog to update file pointer

    echo ======================================
    echo RUNNING VERILOG RTL, FREE, PSASYNC CLOCKS
    echo ======================================
    # Run VSIM in command line mode
   echo "Running simulation ..."
    vsim -c tb_$PERIPHERAL\_free < init.do
    #make vsim_rtl_free

    mv transcript logs/$PERIPHERAL\_bif_free_psasync_rtl_verilog_vsim.log
    mv report.untog logs/$PERIPHERAL\_bif_free_psasync_rtl_verilog_vsim.untog

#-------------------------------------------------------------------------------

    echo "Sim4: free-running asynchronous clocks, VERILOG RTL"
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
    mv report.untog logs/$PERIPHERAL\_bif_free_async_rtl_verilog_vsim.untog
  endif

################################################################################ 

  echo "Restoring libmap file to default uut to VERILOG RTL ..."
  cd ../modeltech
  sed s/^uut/\;uut/g libmap > tmp1
  sed s/';uut = $PERIPH\/verilog\/uut\/'/'uut = $PERIPH\/verilog\/uut\/'/g tmp1 > tmp2
  mv -f tmp2 libmap
  \rm -f tmp1

  echo "Restoring reader.v file to default system finish ..."
  cd ../reader
  cp reader.v reader.tmp
  sed 's/\$stop/\$finish/g' reader.tmp > reader.v
  \rm -f reader.tmp

endif

################################################################################ 

if ($1 == "-v") then
  echo "BusTalk VERILOG RTL bif simulations, using Verilog-XL"

  echo "Changing to BusTalk/vlog/tbench directory"
  cd $PERIPH/BusTalk/vlog/tbench

#-------------------------------------------------------------------------------

  echo "Sim1: production, VERILOG RTL"
  # set the link for the BusTalk production test vectors
  cd ../reader

  echo "Ensure reader.v file defaults to system finish ..."
  # Need $finish in reader.v for verilog-XL, but $stop will not be replaced
  # if abort script in -m ModelSim section.
  cp reader.v reader.tmp
  sed 's/\$stop/\$finish/g' reader.tmp > reader.v
  \rm -f reader.tmp

  rm -f infile.sim
  ln -s ../../bustests/invec/$PERIPHERAL\_prod.sim infile.sim
  cd ../tbench

  echo ====================================
  echo RUNNING VERILOG RTL, PROD - VXL
  echo ====================================
  echo "Running simulation ..."
  make vxl_rtl
  #verilog +licq_vxl -f vxl.rtl tb_$PERIPHERAL\.v
  #mv verilog.log logs/$PERIPHERAL\_bif_prod_rtl_verilog_vxl.log
  mv verilog.log logs/$PERIPHERAL\.prod.bif.rtl.verilog.vxl.log

#-------------------------------------------------------------------------------

  echo "Sim2: free-running synchronous clocks, VERILOG RTL"
  # set the link for the BusTalk free-running test vectors, sync clocks
  cd ../reader
  rm -f infile.sim
  #ln -s ../../bustests/invec/$PERIPHERAL\_free_syncclk.sim infile.sim
  ln -s ../../bustests/invec/$PERIPHERAL\_free.sim infile.sim
  cd ../tbench

  echo ===============================================
  echo RUNNING VERILOG RTL, FREE, SYNC CLOCKS - VXL
  echo ===============================================
  echo "Running simulation ..."
  make vxl_rtl_free
  #verilog +licq_vxl -f vxl.rtl -y ../trickbox tb_$PERIPHERAL\_free.v
  #mv verilog.log logs/$PERIPHERAL\_bif_free_rtl_verilog_vxl.log
  mv verilog.log logs/$PERIPHERAL\.free.bif.rtl.verilog.vxl.log

#-------------------------------------------------------------------------------
  if (ASYNC == 1) then
    echo "Sim3: free-running pseudo-asynchronous clocks, VERILOG RTL"
    # set the link for the BusTalk free-running test vectors, pseudo-async clocks
    cd ../reader
    rm -f infile.sim
    ln -s ../../bustests/invec/$PERIPHERAL\_free_psasyncclk.sim infile.sim
    cd ../tbench

    echo ===============================================
    echo RUNNING VERILOG RTL, FREE, PSASYNC CLOCKS - VXL
    echo ===============================================
    echo "Running simulation ..."
    make vxl_rtl_free
    #verilog +licq_vxl -f vxl.rtl -y ../trickbox tb_$PERIPHERAL\_free.v
    #mv verilog.log logs/$PERIPHERAL\_bif_free_psasync_rtl_verilog_vxl.log
    mv verilog.log logs/$PERIPHERAL\.free.bif.psasync.rtl.verilog.vxl.log

#-------------------------------------------------------------------------------

    echo "Sim4: free-running asynchronous clocks, VERILOG RTL"
    set the link for the BusTalk free-running test vectors, async clocks
    cd ../reader
    rm -f infile.sim
    ln -s ../../bustests/invec/$PERIPHERAL\_free_asyncclk.sim infile.sim
    cd ../tbench

    echo ===============================================
    echo RUNNING VERILOG RTL, FREE, ASYNC CLOCKS - VXL
    echo ===============================================
    echo "Running simulation ..."
    make vxl_rtl_free
    #verilog +licq_vxl -f vxl.rtl -y ../trickbox tb_$PERIPHERAL\_free.v
    #mv verilog.log logs/$PERIPHERAL\_bif_free_async_rtl_verilog_vxl.log
    mv verilog.log logs/$PERIPHERAL\.free.bif.async.rtl.verilog.vxl.log
  endif

endif


################################################################################ 
#  RUN INSTRUCTIONS
################################################################################ 

# Firstly set environment variables
# either manually or using SourceMe at top-level directory,
# If it exists, run build_$PERIPHERAL e.g. build_kmi, then source SourceMe.
# Setup the required versions of tools by invoking source SourceTools.
# To run the simulations, execute:

#   run_bif_all_rtl_verilog.csh -m|-v

####################### End ####################################################

