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
# File Name           : run_bif_all_net_scan_verilog.csh,v
# File Revision       : 1.1
#
# Release Information : PL050-REL1v1
#
################################################################################
# Purpose             : Generic script to run batch local simulation,
#                       Model Technology ModelSim simulation of
#                       selected block, VERILOG gate-level scan netlists,
#                       BusTalk tb_$PERIPHERAL, tb_$PERIPHERAL\_free.
#
#                       Located in the /BusTalk/vlog/tbench directory.
################################################################################

################################################################################ 
# RUN SIMULATION
################################################################################ 

# ASSUMPTIONS
# ===========
# Model Technology simulation tools must have been sourced
#   e.g. source /eda/tools/modeltech/5.1e/dotcshrc
# source the SourceMe file in top level directory,
# to define environment variables e.g. $PERIPH.
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
  echo "       run_all_bif_net.csh <sim>"
  echo "         where"
  echo "         <sim> = -m, to run ModelSim simulator only"
  echo "         <sim> = -v, to run Verilog-XL only"
  echo "  (eg: run_all_bif_net.csh -m)  "
  exit(0)
endif

if ($1 == "-v") then
  echo "# NOTE: -v Verilog-XL option is NOT valid yet for scan netlist"
  exit(0)
endif

# Default 0 for no async clocks simulations, set non-zero to run async sims.
set ASYNC = 0

# This script will compile the netlist unless env var $MULTISIM != "" e.g. 1
# Setting $MULTISIM 1 allows concurrent gate-level simulations

#-------------------------------------------------------------------------------
# Set Verilog-XL simulator command line options

if ($CELL_LIB == CB25) then

  # Production tests
  set VXLNETMAX = " +define+NET_MAX \
    +licq_vxl +neg_tchk +libext+.v \
    ../common/clockgen.v ../common/countdown.v \
    ../bid/addrctl_driver.v ../bid/data_driver.v ../bid/penable_driver.v \
    ../bid/buscyc_drivers.v ../bid/busline_drivers.v ../bid/reset_driver.v \
    ../reader/reader.v ../buswatcher/buswatch.v \
    ../vr/reg.v ../vr/linedrv.v ../vr/vio_driver.v ../vr/viregcyc_drivers.v \
    -y $LIB_VERILOG -v $LIB_UDP/mtb_verilog.v \
    ../../../verilog/uutNetlist/Kmi_net.v \
    ../tbench/apbslave_tb.v ../tbench/apbmux.v \
    tb_Kmi.v "

  set VXLNETMIN = " +define+NET_MIN \
    +licq_vxl +neg_tchk +libext+.v \
    ../common/clockgen.v ../common/countdown.v \
    ../bid/addrctl_driver.v ../bid/data_driver.v ../bid/penable_driver.v \
    ../bid/buscyc_drivers.v ../bid/busline_drivers.v ../bid/reset_driver.v \
    ../reader/reader.v ../buswatcher/buswatch.v \
    ../vr/reg.v ../vr/linedrv.v ../vr/vio_driver.v ../vr/viregcyc_drivers.v \
    -y $LIB_VERILOG -v $LIB_UDP/mtb_verilog.v \
    ../../../verilog/uutNetlist/Kmi_net.v \
    ../tbench/apbslave_tb.v ../tbench/apbmux.v \
    tb_Kmi.v "

  # Free running tests
  set VXLNETFREEMAX = " +define+NET_MAX \
    +licq_vxl +neg_tchk +libext+.v \
    -y ../trickbox \
    ../common/clockgen.v ../common/countdown.v \
    ../bid/addrctl_driver.v ../bid/data_driver.v ../bid/penable_driver.v \
    ../bid/buscyc_drivers.v ../bid/busline_drivers.v ../bid/reset_driver.v \
    ../reader/reader.v ../buswatcher/buswatch.v \
    ../vr/reg.v ../vr/linedrv.v ../vr/vio_driver.v ../vr/viregcyc_drivers.v \
    -y $LIB_VERILOG -v $LIB_UDP/mtb_verilog.v \
    ../../../verilog/uutNetlist/Kmi_net.v \
    ../tbench/apbslave_tb.v ../tbench/apbmux.v \
    tb_Kmi_free.v "

  set VXLNETFREEMIN = " +define+NET_MIN \
    +licq_vxl +neg_tchk +libext+.v \
    -y ../trickbox \
    ../common/clockgen.v ../common/countdown.v \
    ../bid/addrctl_driver.v ../bid/data_driver.v ../bid/penable_driver.v \
    ../bid/buscyc_drivers.v ../bid/busline_drivers.v ../bid/reset_driver.v \
    ../reader/reader.v ../buswatcher/buswatch.v \
    ../vr/reg.v ../vr/linedrv.v ../vr/vio_driver.v ../vr/viregcyc_drivers.v \
    -y $LIB_VERILOG -v $LIB_UDP/mtb_verilog.v \
    ../../../verilog/uutNetlist/Kmi_net.v \
    ../tbench/apbslave_tb.v ../tbench/apbmux.v \
    tb_Kmi_free.v "

else if ($CELL_LIB == Q1) then

  # Production tests
  set VXLNETMAX = " +define+NET_MAX \
    +licq_vxl +neg_tchk +libext+.ismvmd+.v \
    ../common/clockgen.v ../common/countdown.v \
    ../bid/addrctl_driver.v ../bid/data_driver.v ../bid/penable_driver.v \
    ../bid/buscyc_drivers.v ../bid/busline_drivers.v ../bid/reset_driver.v \
    ../reader/reader.v ../buswatcher/buswatch.v \
    ../vr/reg.v ../vr/linedrv.v ../vr/vio_driver.v ../vr/viregcyc_drivers.v \
    -y $LIB_VERILOG -v $LIB_UDP/udps.vmd \
    ../../../verilog/uutNetlist/Kmi_net.v \
    ../tbench/apbslave_tb.v ../tbench/apbmux.v \
    tb_Kmi.v "

  set VXLNETMIN = " +define+NET_MIN \
    +licq_vxl +neg_tchk +libext+.ismvmd+.v \
    ../common/clockgen.v ../common/countdown.v \
    ../bid/addrctl_driver.v ../bid/data_driver.v ../bid/penable_driver.v \
    ../bid/buscyc_drivers.v ../bid/busline_drivers.v ../bid/reset_driver.v \
    ../reader/reader.v ../buswatcher/buswatch.v \
    ../vr/reg.v ../vr/linedrv.v ../vr/vio_driver.v ../vr/viregcyc_drivers.v \
    -y $LIB_VERILOG -v $LIB_UDP/udps.vmd \
    ../../../verilog/uutNetlist/Kmi_net.v \
    ../tbench/apbslave_tb.v ../tbench/apbmux.v \
    tb_Kmi.v "

  # Free running tests
  set VXLNETFREEMAX = " +define+NET_MAX \
    +licq_vxl +neg_tchk +libext+.ismvmd+.v \
    -y ../trickbox \
    ../common/clockgen.v ../common/countdown.v \
    ../bid/addrctl_driver.v ../bid/data_driver.v ../bid/penable_driver.v \
    ../bid/buscyc_drivers.v ../bid/busline_drivers.v ../bid/reset_driver.v \
    ../reader/reader.v ../buswatcher/buswatch.v \
    ../vr/reg.v ../vr/linedrv.v ../vr/vio_driver.v ../vr/viregcyc_drivers.v \
    -y $LIB_VERILOG -v $LIB_UDP/udps.vmd \
    ../../../verilog/uutNetlist/Kmi_net.v \
    ../tbench/apbslave_tb.v ../tbench/apbmux.v \
    tb_Kmi_free.v"

  set VXLNETFREEMIN = " +define+NET_MIN \
    +licq_vxl +neg_tchk +libext+.ismvmd+.v \
    -y ../trickbox \
    ../common/clockgen.v ../common/countdown.v \
    ../bid/addrctl_driver.v ../bid/data_driver.v ../bid/penable_driver.v \
    ../bid/buscyc_drivers.v ../bid/busline_drivers.v ../bid/reset_driver.v \
    ../reader/reader.v ../buswatcher/buswatch.v \
    ../vr/reg.v ../vr/linedrv.v ../vr/vio_driver.v ../vr/viregcyc_drivers.v \
    -y $LIB_VERILOG -v $LIB_UDP/udps.vmd \
    ../../../verilog/uutNetlist/Kmi_net.v \
    ../tbench/apbslave_tb.v ../tbench/apbmux.v \
    tb_Kmi_free.v"

endif
################################################################################ 

echo "=========================================================="
echo "BusTalk Verilog gate-level scan Netlist (.sim) simulations"
echo "=========================================================="

echo ""
echo "Changing to top-level directory"
cd $PERIPH

#-------------------------------------------------------------------------------

if ($1 == "-m") then
  echo "BusTalk VERILOG gate-level bif simulations, using ModelSim"

  if ($?MULTISIM) then
    echo "No compile of Verilog netlist, assumed done manually"
  else
    echo "Compiling the Verilog netlist"
    echo "Performing make clean in verilog/uutNetlist_scan directory"
    cd verilog/uutNetlist_scan
    make clean
    cd ../..
  endif

  echo "Editing modeltech libmap to point to VERILOG Netlist"
  cd BusTalk/vlog/modeltech
  echo "Make backup copy of original libmap"
  cp libmap libmap.orig
  sed s/^uut/\;uut/g libmap > tmp1
  sed s/';uut = $PERIPH\/verilog\/uutNetlist_scan\/'/'uut = $PERIPH\/verilog\/uutNetlist_scan\/'/g tmp1 > tmp2
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
  echo "Sim1: production, VERILOG Netlist"
  echo "Running simulation ..."
  # set the link for the BusTalk test vectors, production
  cd ../reader
  rm -f infile.sim
  ln -s ../../bustests/invec/$PERIPHERAL\_prod.sim infile.sim
  cd ..
  echo "Compiling BusTalk/vlog directory"
  make clean
  cd tbench
  # Note: compilation done last for Verilog to update file pointer

  echo =========================================
  echo RUNNING VERILOG NETLIST, PROD, MAX TIMING
  echo =========================================
  # Run VSIM in command line mode for SDF max
  vsim -c \
   -sdfmax u_$PERIPHERAL=../../../verilog/uutNetlist_scan/$PERIPHERAL\_scan_Verilog.sdf21 \
   -L libverilog \
   -L UDP \
   tb_$PERIPHERAL < init_scan.do
  #make vsim_net_max

  #mv transcript logs/$PERIPHERAL\_bif_prod_net_scan_verilog_max_vsim.log
  mv transcript logs/$PERIPHERAL\.prod.bif.net.scan.verilog.max.vsim.log
  mv report.untog logs/$PERIPHERAL\.prod.bif.net.scan.verilog.max.vsim.untog

  echo =========================================
  echo RUNNING VERILOG NETLIST, PROD, MIN TIMING
  echo =========================================
  # Run VSIM in command line mode for SDF min
  vsim -c \
   -sdfmin u_$PERIPHERAL=../../../verilog/uutNetlist_scan/$PERIPHERAL\_scan_Verilog.sdf21 \
   -L libverilog \
   -L UDP \
   tb_$PERIPHERAL < init_scan.do
  #make vsim_net_min

  #mv transcript logs/$PERIPHERAL\_bif_prod_net_scan_verilog_min_vsim.log
  mv transcript logs/$PERIPHERAL\.prod.bif.net.scan.verilog.min.vsim.log
  #mv report.untog logs/$PERIPHERAL\_bif_prod_net_scan_verilog_vsim.untog
  mv report.untog logs/$PERIPHERAL\.prod.bif.net.scan.verilog.min.vsim.untog

#-------------------------------------------------------------------------------
  echo "Sim2: free-running synchronous clocks, VERILOG Netlist"
  echo "Running simulation ..."
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

  # For synthesis with VERILOG in, VERILOG output netlist and SDF, use $PERIPHERAL\_scan_Verilog.sdf21
  # but for VERILOG in , Verilog output, use $PERIPHERAL\_FromVerilogToVerilog.sdf21
  # and add -L UDP

  echo =======================================================
  echo RUNNING VERILOG NETLIST, FREE, MAX TIMING - SYNC CLOCKS
  echo =======================================================
  # Run VSIM in command line mode for SDF max
  vsim -c \
   -sdfmax u_$PERIPHERAL\=../../../verilog/uutNetlist_scan/$PERIPHERAL\_scan_Verilog.sdf21 \
   -L libverilog \
   -L UDP \
   tb_$PERIPHERAL\_free < init_scan.do
  #make vsim_net_free_max

  #mv transcript logs/$PERIPHERAL\_bif_free_sync_net_scan_verilog_max_vsim.log
  mv transcript logs/$PERIPHERAL\.free.bif.net.scan.verilog.max.vsim.log

  echo =======================================================
  echo RUNNING VERILOG NETLIST, FREE, MIN TIMING - SYNC CLOCKS
  echo =======================================================
  # Run VSIM in command line mode for SDF min
  vsim -c \
   -sdfmin u_$PERIPHERAL\=../../../verilog/uutNetlist_scan/$PERIPHERAL\_scan_Verilog.sdf21 \
   -L libverilog \
   -L UDP \
   tb_$PERIPHERAL\_free < init_scan.do
  #make vsim_net_free_min

  #mv transcript logs/$PERIPHERAL\_bif_free_sync_net_scan_verilog_min_vsim.log
  mv transcript logs/$PERIPHERAL\.free.bif.net.scan.verilog.min.vsim.log
  #mv report.untog logs/$PERIPHERAL\_bif_free_sync_net_scan_verilog_vsim.untog

#-------------------------------------------------------------------------------
  if (ASYNC == 1) then
    echo "Sim3: free-running pseudo-asynchronous clocks, VERILOG Netlist"
    echo "Running simulation ..."
    # set the link for the BusTalk test vectors
    cd ../reader
    rm -f infile.sim
    ln -s ../../bustests/invec/$PERIPHERAL\_free_psasyncclk.sim infile.sim
    cd ..
    echo "Compiling BusTalk/vlog directory"
    make clean
    cd tbench
    # Note: compilation done last for Verilog to update file pointer

    # For synthesis with VERILOG in, VERILOG output netlist and SDF, use $PERIPHERAL\_scan_Verilog.sdf21
    # but for VERILOG in , Verilog output, use $PERIPHERAL\_FromVerilogToVerilog.sdf21
    # and add -L UDP

    echo =======================================================
    echo RUNNING VERILOG NETLIST, FREE, MAX TIMING - PSASYNC CLOCKS
    echo =======================================================
    # Run VSIM in command line mode for SDF max
    vsim -c \
     -sdfmax u_$PERIPHERAL\=../../../verilog/uutNetlist_scan/$PERIPHERAL\_scan_Verilog.sdf21 \
     -L libverilog \
     -L UDP \
     tb_$PERIPHERAL\_free < init_scan.do
    #make vsim_net_free_max

    #mv transcript logs/$PERIPHERAL\_bif_free_psasync_net_scan_verilog_max_vsim.log

    echo =======================================================
    echo RUNNING VERILOG NETLIST, FREE, MIN TIMING - PSASYNC CLOCKS
    echo =======================================================
    # Run VSIM in command line mode for SDF min 
    vsim -c \
     -sdfmin u_$PERIPHERAL\="../../../verilog/uutNetlist_scan/$PERIPHERAL\_scan_Verilog.sdf21" \
     -L libverilog \
     -L UDP \
     tb_$PERIPHERAL\_free < init_scan.do
    #make vsim_net_free_min

    #mv transcript logs/$PERIPHERAL\_bif_free_psasync_net_scan_verilog_min_vsim.log
    #mv report.untog logs/$PERIPHERAL\_bif_free_psasync_net_scan_verilog_vsim.untog

#-------------------------------------------------------------------------------
    echo "Sim4: free-running asynchronous clocks, VERILOG Netlist"
    echo "Running simulation ..."
    # set the link for the BusTalk test vectors
    cd ../reader
    rm -f infile.sim
    ln -s ../../bustests/invec/$PERIPHERAL\_free_asyncclk.sim infile.sim
    cd ..
    echo "Compiling BusTalk/vlog directory"
    make clean
    cd tbench
    # Note: compilation done last for Verilog to update file pointer

    # For synthesis with VERILOG in, VERILOG output netlist and SDF, use $PERIPHERAL\_scan_Verilog.sdf21
    # but for VERILOG in , Verilog output, use $PERIPHERAL\_FromVerilogToVerilog.sdf21
    # and add -L UDP

    echo =======================================================
    echo RUNNING VERILOG NETLIST, FREE, MAX TIMING - ASYNC CLOCKS
    echo =======================================================
    # Run VSIM in command line mode for SDF max
    vsim -c \
     -sdfmax u_$PERIPHERAL\=../../../verilog/uutNetlist_scan/$PERIPHERAL\_scan_Verilog.sdf21 \
     -L libverilog \
     -L UDP \
     tb_$PERIPHERAL\_free < init_scan.do
    #make vsim_net_free_max

    #mv transcript logs/$PERIPHERAL\_bif_free_async_net_scan_verilog_max_vsim.log

    echo =======================================================
    echo RUNNING VERILOG NETLIST, FREE, MIN TIMING - ASYNC CLOCKS
    echo =======================================================
    # Run VSIM in command line mode for SDF min
    vsim -c \
     -sdfmin u_$PERIPHERAL\="../../../verilog/uutNetlist_scan/$PERIPHERAL\_scan_Verilog.sdf21" \
     -L libverilog \
     -L UDP \
     tb_$PERIPHERAL\_free < init_scan.do
    #make vsim_net_free_min

    #mv transcript logs/$PERIPHERAL\_bif_free_async_net_scan_verilog_min_vsim.log
    #mv report.untog logs/$PERIPHERAL\_bif_free_async_net_scan_verilog_vsim.untog
  endif

#-------------------------------------------------------------------------------

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
  echo "BusTalk VERILOG gate-level bif simulations, using Verilog-XL"

  echo "Changing to BusTalk/vlog/tbench directory"
  cd $PERIPH/BusTalk/vlog/tbench

  echo "Sim1: production, VERILOG Netlist"
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

  echo ===============================================
  echo RUNNING VERILOG NETLIST, PROD, MAX TIMING - VXL
  echo ===============================================
  echo "Running simulation ..."
  verilog $VXLNETMAX
  #make vxl_net_max
  #verilog +licq_vxl +define+NET_MAX +neg_tchk -f vxl.net tb_Kmi.v
  #mv verilog.log logs/$PERIPHERAL\_bif_prod_net_verilog_max_vxl.log
  mv verilog.log logs/$PERIPHERAL\.prod.bif.net.verilog.max.vxl.log

  echo ===============================================
  echo RUNNING VERILOG NETLIST, PROD, MIN TIMING - VXL
  echo ===============================================
  echo "Running simulation ..."
  verilog $VXLNETMIN
  #make vxl_net_min
  #verilog +licq_vxl +define+NET_MIN +neg_tchk -f vxl.net tb_Kmi.v
  #mv verilog.log logs/$PERIPHERAL\_bif_prod_net_verilog_min_vxl.log
  mv verilog.log logs/$PERIPHERAL\.prod.bif.net.verilog.min.vxl.log

#-------------------------------------------------------------------------------

  echo "Sim2: free-running synchronous clocks, VERILOG Netlist"
  echo "Running simulation ..."
  # set the link for the BusTalk free-running test vectors, sync clocks
  cd ../reader
  rm -f infile.sim
  #ln -s ../../bustests/invec/$PERIPHERAL\_free_syncclk.sim infile.sim
  ln -s ../../bustests/invec/$PERIPHERAL\_free.sim infile.sim
  cd ../tbench

  echo ============================================================
  echo RUNNING VERILOG NETLIST, FREE, MAX TIMING, SYNC CLOCKS - VXL
  echo ============================================================
  echo "Running simulation ..."
  verilog $VXLNETFREEMAX
  #make vxl_net_free_max
  #verilog +licq_vxl +define+NET_MAX +neg_tchk -y ../trickbox -f vxl.net tb_Kmi_free.v
  #mv verilog.log logs/$PERIPHERAL\_bif_free_net_verilog_max_vxl.log
  mv verilog.log logs/$PERIPHERAL\.free.bif.net.verilog.max.vxl.log

  echo ============================================================
  echo RUNNING VERILOG NETLIST, FREE, MIN TIMING, SYNC CLOCKS - VXL
  echo ============================================================
  echo "Running simulation ..."
  verilog $VXLNETFREEMIN
  #make vxl_net_free_min
  #verilog +licq_vxl +define+NET_MIN +neg_tchk -y ../trickbox -f vxl.net tb_Kmi_free.v
  #mv verilog.log logs/$PERIPHERAL\_bif_free_net_verilog_min_vxl.log
  mv verilog.log logs/$PERIPHERAL\.free.bif.net.verilog.min.vxl.log

#-------------------------------------------------------------------------------

  if (ASYNC == 1) then
    echo "Sim3: free-running pseudo-asynchronous clocks, VERILOG Netlist"
    echo "Running simulation ..."
    # set the link for the BusTalk free-running test vectors, pseudo-async clocks
    cd ../reader
    rm -f infile.sim
    ln -s ../../bustests/invec/$PERIPHERAL\_free_psasyncclk.sim infile.sim
    cd ../tbench

    echo ===============================================================
    echo RUNNING VERILOG NETLIST, FREE, MAX TIMING, PSASYNC CLOCKS - VXL
    echo ===============================================================
    echo "Running simulation ..."
    verilog $VXLNETFREEMAX
    #make vxl_net_free_max
    #verilog +licq_vxl +define+NET_MAX +neg_tchk -y ../trickbox -f vxl.net tb_Kmi_free.v

    #mv verilog.log logs/$PERIPHERAL\_bif_free_psasync_net_verilog_max_vxl.log
    mv verilog.log logs/$PERIPHERAL\.free.bif.psasync.net.verilog.max.vxl.log

    echo ===============================================================
    echo RUNNING VERILOG NETLIST, FREE, MIN TIMING, PSASYNC CLOCKS - VXL
    echo ===============================================================
    echo "Running simulation ..."
    verilog $VXLNETFREEMIN
    #make vxl_net_free_min
    #verilog +licq_vxl +define+NET_MIN +neg_tchk -y ../trickbox -f vxl.net tb_Kmi_free.v
    #mv verilog.log logs/$PERIPHERAL\_bif_free_psasync_net_verilog_min_vxl.log
    mv verilog.log logs/$PERIPHERAL\.free.bif.psasync.net.verilog.min.vxl.log

#-------------------------------------------------------------------------------

    echo "Sim4: free-running asynchronous clocks, VERILOG Netlist"
    echo "Running simulation ..."
    # set the link for the BusTalk free-running test vectors, async clocks
    cd ../reader
    rm -f infile.sim
    ln -s ../../bustests/invec/$PERIPHERAL\_free_asyncclk.sim infile.sim
    cd ../tbench

    echo =============================================================
    echo RUNNING VERILOG NETLIST, FREE, MAX TIMING, ASYNC CLOCKS - VXL
    echo =============================================================
    echo "Running simulation ..."
    verilog $VXLNETFREEMAX
    #make vxl_net_free_max
    #verilog +licq_vxl +define+NET_MAX +neg_tchk -y ../trickbox -f vxl.net tb_Kmi_free.v
    #mv verilog.log logs/$PERIPHERAL\_bif_free_async_net_verilog_max_vxl.log
    mv verilog.log logs/$PERIPHERAL\.free.bif.async.net.verilog.max.vxl.log

    echo =============================================================
    echo RUNNING VERILOG NETLIST, FREE, MIN TIMING, ASYNC CLOCKS - VXL
    echo =============================================================
    echo "Running simulation ..."
    verilog $VXLNETFREEMIN
    #make vxl_net_free_min
    #verilog +licq_vxl +define+NET_MIN +neg_tchk -y ../trickbox -f vxl.net tb_Kmi_free.v
    #mv verilog.log logs/$PERIPHERAL\_bif_free_async_net_verilog_min_vxl.log
    mv verilog.log logs/$PERIPHERAL\.free.bif.async.net.verilog.min.vxl.log
  endif
#-------------------------------------------------------------------------------

endif


################################################################################ 
#  RUN INSTRUCTIONS
################################################################################ 


# Firstly set environment variables
# either manually or using SourceMe at top-level directory,
# If it exists, run build_$PERIPHERAL e.g. build_kmi, then source SourceMe.
# Setup the required versions of tools by invoking source SourceTools.
# To run the simulations, execute:

#   run_bif_all_net_verilog.csh -m|-v

###################################### End #####################################
