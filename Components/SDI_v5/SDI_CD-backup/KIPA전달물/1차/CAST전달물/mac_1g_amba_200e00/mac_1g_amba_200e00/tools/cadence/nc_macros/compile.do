#!/bin/csh -f

# ******************************************************************* #
# Copyright (c) 2001-2003  Evatronix Ltd.
# ******************************************************************* #
# Please review the terms of the license agreement before using
# this file. If you are not an authorized user, please destroy this
# source code file and notify Evatronix S.A. immediately that you
# inadvertently received an unauthorized copy.
# ******************************************************************* #
#
# ------------------------------------------------------------------- #
# Project name         : MAC_AHB
# Project description  : Media Access Controller for Ethernet
# File name            : compile.do
# File contents        : Sample compilation script for Cadence's NC-SIM
# Purpose              : MAC test bench
# Design Engineer      : T.T. D.B.
# Quality Engineer     : M.B.
# Test version         : 2.00
# Last modification    : 2003-09-15
# ------------------------------------------------------------------- #

# ------------------------------------------------------------------- #
# Directories location
# ------------------------------------------------------------------- #

setenv core_dir         ./src/core
setenv mac_dir          ./src/core/mac_1g
setenv mac2amba_dir      ./src/core/mac2amba
setenv chip_dir         ./src/tb/chip
setenv env_dir          ./src/tb/env
setenv tb_dir           ./src/tb
setenv work_dir         ./tools/cadence/nc_lib
setenv reports_dir      ./tools/cadence/nc_reports
setenv clog             $reports_dir/compile.log
setenv elog             $reports_dir/elaborate.log

# ------------------------------------------------------------------- #
# Library creation
# ------------------------------------------------------------------- #

echo "softinclude $CDS_INST_DIR/tools/inca/files/cds.lib" > cds.lib
echo "define mac_1g_lib $work_dir/mac_1g" >> cds.lib
echo "define mac2amba_lib $work_dir/mac2amba" >> cds.lib
echo "define mac_1g_amba_lib $work_dir/mac_1g_amba" >> cds.lib

echo "DEFINE NCVLOGOPTS -messages" > hdl.var
echo "DEFINE NCELABOPTS -messages -work MAC_1G_LIB" >> hdl.var
echo "DEFINE NCSIMOPTS  -messages" >> hdl.var

# ------------------------------------------------------------------- #
# Compiling components of core
# ------------------------------------------------------------------- #


ncvhdl -append_log -logfile $clog -work MAC_1G_LIB $mac_dir/utility_mac_1g.vhd
ncvhdl -append_log -logfile $clog -work MAC_1G_LIB $mac_dir/rc.vhd
ncvhdl -append_log -logfile $clog -work MAC_1G_LIB $mac_dir/tc.vhd
ncvhdl -append_log -logfile $clog -work MAC_1G_LIB $mac_dir/bd.vhd
ncvhdl -append_log -logfile $clog -work MAC_1G_LIB $mac_dir/tfifo.vhd
ncvhdl -append_log -logfile $clog -work MAC_1G_LIB $mac_dir/rfifo.vhd
ncvhdl -append_log -logfile $clog -work MAC_1G_LIB $mac_dir/tlsm.vhd
ncvhdl -append_log -logfile $clog -work MAC_1G_LIB $mac_dir/rlsm.vhd
ncvhdl -append_log -logfile $clog -work MAC_1G_LIB $mac_dir/dma.vhd
ncvhdl -append_log -logfile $clog -work MAC_1G_LIB $mac_dir/csr.vhd
ncvhdl -append_log -logfile $clog -work MAC_1G_LIB $mac_dir/rstc.vhd
ncvhdl -append_log -logfile $clog -work MAC_1G_LIB $mac_dir/miism.vhd

# ------------------------------------------------------------------- #
# Compiling core
# ------------------------------------------------------------------- #

ncvhdl -append_log -logfile $clog -work MAC_1G_LIB $mac_dir/mac_1g.vhd

# ------------------------------------------------------------------- #
# Compiling components of core
# ------------------------------------------------------------------- #


ncvhdl -append_log -logfile $clog -work MAC2AMBA_LIB $mac2amba_dir/mac2amba_package.vhd
ncvhdl -append_log -logfile $clog -work MAC2AMBA_LIB $mac2amba_dir/macdata2ahb.vhd
ncvhdl -append_log -logfile $clog -work MAC2AMBA_LIB $mac2amba_dir/maccsr2apb.vhd

# ------------------------------------------------------------------- #
# Compiling core
# ------------------------------------------------------------------- #

ncvhdl -append_log -logfile $clog -work MAC2AMBA_LIB $mac2amba_dir/mac2amba.vhd

# ------------------------------------------------------------------- #
# Compiling core
# ------------------------------------------------------------------- #

ncvhdl -append_log -logfile $clog -work MAC_1G_AMBA_LIB $core_dir/mac_1g_amba.vhd

# ------------------------------------------------------------------- #
# Compiling environment components of MAC chip
# ------------------------------------------------------------------- #

ncvhdl -append_log -logfile $clog -work MAC_1G_AMBA_LIB $chip_dir/dualram.vhd
ncvhdl -append_log -logfile $clog -work MAC_1G_AMBA_LIB $chip_dir/tris.vhd
ncvhdl -append_log -logfile $clog -work MAC_1G_AMBA_LIB $chip_dir/chip_mac_1g_amba.vhd
# ------------------------------------------------------------------- #
# Compiling environment components of Test Bench
# ------------------------------------------------------------------- #

ncvhdl -append_log -logfile $clog -work MAC_1G_AMBA_LIB $env_dir/smemstimahb.vhd
ncvhdl -append_log -logfile $clog -work MAC_1G_AMBA_LIB $env_dir/apbcmd.vhd
ncvhdl -append_log -logfile $clog -work MAC_1G_AMBA_LIB $env_dir/ambaarbcmd.vhd
ncvhdl -append_log -logfile $clog -work MAC_1G_AMBA_LIB $env_dir/intmon.vhd
ncvhdl -append_log -logfile $clog -work MAC_1G_AMBA_LIB $env_dir/linkmon.vhd
ncvhdl -append_log -logfile $clog -work MAC_1G_AMBA_LIB $env_dir/cam.vhd
ncvhdl -append_log -logfile $clog -work MAC_1G_AMBA_LIB $env_dir/clkgen.vhd
ncvhdl -append_log -logfile $clog -work MAC_1G_AMBA_LIB $env_dir/rstgen.vhd

# ------------------------------------------------------------------- #
# Compiling Test Bench
# ------------------------------------------------------------------- #

ncvhdl -append_log -logfile $clog -work MAC_1G_AMBA_LIB $tb_dir/mac_1g_amba_tb.vhd

# ------------------------------------------------------------------- #
# Elaborating the Design
# ------------------------------------------------------------------- #
ncelab -logfile $elog -update -status -access +rwc MAC_1G_AMBA_TB:testbench

# ******************************************************************* #
