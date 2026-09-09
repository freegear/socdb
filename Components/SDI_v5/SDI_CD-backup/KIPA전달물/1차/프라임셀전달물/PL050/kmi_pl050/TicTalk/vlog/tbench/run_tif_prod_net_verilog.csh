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
# File Name           : run_tif_prod_net_verilog.csh,v
# File Revision       : 1.1
#
# Release Information : PL050-REL1v1
#
################################################################################
# Purpose             : Generic script to run batch local simulation of,
#                       selected block, VERILOG gate-level netlists,
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
# to define environment variables e.g. $PERIPH.
# All simulation test pattern files must exist (be compiled).
# libmap files (library mapping) must default to VERILOG RTL.
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
  echo " Script to run production test vector simulations "
  echo " Usage : "
  echo "       run_tif_prod_rtl_verilog.csh <sim>"
  echo "         where"
  echo "         <sim> = -m, to run ModelSim simulator only"
  echo "         <sim> = -v, to run Verilog-XL only"
  echo "  (eg: run_tif_prod_rtl_verilog.csh -m)  "
  exit(0)
endif

# This script will compile the netlist unless env var $MULTISIM != "" e.g. 1
# Setting $MULTISIM 1 allows concurrent gate-level simulations

# Set Verilog-XL simulator command line options

if ($CELL_LIB == CB25) then

  set VXLNETMAX = " +define+NET_MAX \
    +licq_vxl +neg_tchk +libext+.v \
    -y ../sys -y ../chip ../tbench/ticbox.v \
    -y $LIB_VERILOG -v $LIB_UDP/mtb_verilog.v \
    ../../../verilog/uutNetlist/Kmi_net.v \
    tb_tic.v "

  set VXLNETMIN = " +define+NET_MIN \
    +licq_vxl +neg_tchk +libext+.v \
    -y ../sys -y ../chip ../tbench/ticbox.v \
    -y $LIB_VERILOG -v $LIB_UDP/mtb_verilog.v \
    ../../../verilog/uutNetlist/Kmi_net.v \
    tb_tic.v "

else if ($CELL_LIB == Q1) then

  set VXLNETMAX = "+define+NET_MAX \
    +licq_vxl +neg_tchk +libext+.ismvmd+.v \
    -y ../sys -y ../chip ../tbench/ticbox.v \
    -y $LIB_VERILOG -v $LIB_UDP/udps.vmd \
    ../../../verilog/uutNetlist/Kmi_net.v \
    tb_tic.v "

  set VXLNETMIN = "+define+NET_MIN \
    +licq_vxl +neg_tchk +libext+.ismvmd+.v \
    -y ../sys -y ../chip ../tbench/ticbox.v \
    -y $LIB_VERILOG -v $LIB_UDP/udps.vmd \
    ../../../verilog/uutNetlist/Kmi_net.v \
    tb_tic.v "

endif
#-------------------------------------------------------------------------------

echo "====================================================="
echo "TicTalk Verilog gate-level Netlist (.sim) simulations"
echo "====================================================="

echo ""
echo "Changing to top-level directory"
cd $PERIPH

#-------------------------------------------------------------------------------

if ($1 == "-m") then
  echo "TicTalk VERILOG production tif gate-level simulation, using ModelSim"

  if ($?MULTISIM) then
    echo "No compile of Verilog netlist, assumed done manually"
  else
    echo "Compiling the VERILOG netlist"
    echo "Performing make clean in verilog/uutNetlist directory"
    cd verilog/uutNetlist
    make clean
    cd ../..
  endif

#-------------------------------------------------------------------------------

  echo "Editing modeltech libmap to point to VERILOG Netlist"
  cd TicTalk/vlog/modeltech
  echo "Make backup copy of original libmap"
  cp libmap libmap.orig
  sed s/^uut/\;uut/g libmap > tmp1
  sed s/';uut = $PERIPH\/verilog\/uutNetlist\/'/'uut = $PERIPH\/verilog\/uutNetlist\/'/g tmp1 > tmp2
  mv -f tmp2 libmap
  \rm -f tmp1
  cd ../tbench

  # For ModelSim, replace $finish by $stop in tb_tic.v,
  # else sim aborts when complete, before toggle report is done
  # Note: Verilog-XL needs $finish else sim not exited on completion
  echo "Editing reader.v from Verilog system finish to stop ..."
  cp tb_tic.v tb_tic.orig
  sed 's/\$finish/\$stop/g' tb_tic.orig > tb_tic.v

  # set the link for the TicTalk test vectors
  rm -f infile.sim
  ln -s ../../tictests/invec/$PERIPHERAL\_prod.sim infile.sim
  cd ..

  echo "Compiling TicTalk/vlog directory"
  make clean
  cd tbench

#-------------------------------------------------------------------------------

  echo ==========================================
  echo RUNNING VERILOG NETLIST, MAX TIMING - VSIM
  echo ==========================================
  # Run VSIM in command line mode for SDF max
  vsim -c -lic_vlog \
   -sdfmax u_easy/u_rps/u$PERIPHERAL=../../../verilog/uutNetlist/$PERIPHERAL\_Verilog.sdf21 \
   -L libverilog \
   -L UDP \
   tb_tic < init.do
  #make vsim_net_max

  #mv transcript logs/$PERIPHERAL\_tif_prod_net_verilog_max_vsim.log
  mv transcript logs/$PERIPHERAL\.prod.tif.net.verilog.max.vsim.log
  mv report.untog logs/$PERIPHERAL\.prod.tif.net.verilog.max.vsim.untog

  echo ==========================================
  echo RUNNING VERILOG NETLIST, MIN TIMING - VSIM
  echo ==========================================
  # Run VSIM in command line mode for SDF min
  vsim -c -lic_vlog \
   -sdfmin u_easy/u_rps/u$PERIPHERAL=../../../verilog/uutNetlist/$PERIPHERAL\_Verilog.sdf21 \
   -L libverilog \
   -L UDP \
   tb_tic < init.do
  #make vsim_net_min

  #mv transcript logs/$PERIPHERAL\_tif_prod_net_verilog_min_vsim.log
  mv transcript logs/$PERIPHERAL\.prod.tif.net.verilog.min.vsim.log
  #mv report.untog logs/$PERIPHERAL\_tif_prod_net_verilog_vsim.untog
  mv report.untog logs/$PERIPHERAL\.prod.tif.net.verilog.min.vsim.untog

#-------------------------------------------------------------------------------

  echo "Restoring libmap file to default uut to VERILOG RTL ..."
  cd ../modeltech
  sed s/^uut/\;uut/g libmap > tmp1
  sed s/';uut = $PERIPH\/verilog\/uut\/'/'uut = $PERIPH\/verilog\/uut\/'/g tmp1 > tmp2
  mv -f tmp2 libmap
  \rm -f tmp1

  echo "Restoring tb_tic.v file to default system finish ..."
  cd ../tbench
  cp tb_tic.v tb_tic.tmp
  sed 's/\$stop/\$finish/g' tb_tic.tmp > tb_tic.v
  \rm -f tb_tic.tmp
endif

################################################################################ 

if ($1 == "-v") then
  echo "TicTalk VERILOG production tif gate-level simulation, using Verilog-XL"

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

  echo ==========================================
  echo RUNNING VERILOG NETLIST, MAX TIMING - VXL
  echo ==========================================
  verilog $VXLNETMAX
    #make vxl_net_max_cb25
    #verilog +licq_vxl +define+NET_MAX +neg_tchk -f vxl.net.cb25 tb_tic.v
  #mv verilog.log ./logs/$PERIPHERAL\_prod_tif_net_verilog_max_vxl.log
  mv verilog.log ./logs/$PERIPHERAL\.prod.tif.net.verilog.max.vxl.log
  echo ==========================================
  echo RUNNING VERILOG NETLIST, MIN TIMING - VXL
  echo ==========================================
  verilog $VXLNETMIN
    #make vxl_net_min_cb25
    #verilog +licq_vxl +define+NET_MIN +neg_tchk -f vxl.net.cb25 tb_tic.v
  #mv verilog.log ./logs/$PERIPHERAL\_prod_tif_net_verilog_min_vxl.log
  mv verilog.log ./logs/$PERIPHERAL\.prod.tif.net.verilog.min.vxl.log
endif


################################################################################ 
#  RUN INSTRUCTIONS
################################################################################ 

# Firstly set environment variables
# either manually or using SourceMe at top-level directory,
# If it exists, run build_$PERIPHERAL e.g. build_kmi, then source SourceMe.
# Setup the required versions of tools by invoking source SourceTools.
# To run the simulations, execute:

#   run_tif_prod_net_verilog.csh -m|-v

####################### End ####################################################









