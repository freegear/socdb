#!/bin/sh
# ******************************************************************* #
# Copyright (c) 1999-2004  Evatronix SA
# ******************************************************************* #
# Please review the terms of the license agreement before using
# this file. If you are not an authorized user, please destroy this
# source code file and notify Evatronix SA immediately that you
# inadvertently received an unauthorized copy.
# ******************************************************************* #
#
# ------------------------------------------------------------------- #
# Project name         : MAC-1G_AMBA
# Project description  : Media Access Controller for Ethernet
# File name            : compile.sh
# File contents        : Sample compilation script for Cadence's NC-SIM
# Purpose              : MAC_1G_AMBA core compilation
#                        MAC_1G_AMBA environment compilation
#                        MAC_1G_AMBA test bench compilation
# Design Engineer      : D.B.
# Quality Engineer     : M.B.
# Test version         : 2.02
# Last modification    : 2004-08-16
# ------------------------------------------------------------------- #


# ------------------------------------------------------------------- #
# Directories location and variables
# ------------------------------------------------------------------- #

TOP="MAC_AMBA"
ROOT_NAME="top"
ROOT_SRC="./src"
SRC_DIR="$ROOT_SRC/core"
MAC_DIR="$SRC_DIR/mac_1g"
MAC2AMBA_DIR=""$SRC_DIR/mac2amba

TB_DIR="$ROOT_SRC/tb"
TB_NAME="mac_1g_amba_tb.vhd"
CHIP_DIR="$TB_DIR/chip"
CHIP_NAME="chip_mac_1g_amba.vhd"
ENV_DIR="$ROOT_SRC/tb/env"

if [ ! -d ./tools/cadence/nc_raports ] 
  then
    mkdir ./tools/cadence/nc_reports
  fi

if [ ! -d ./tools/cadence/nc_lib ] 
  then
    mkdir ./tools/cadence/nc_lib
  fi

if [ ! -d ./tools/cadence/nc_lib/mac_1g ] 
  then
    mkdir ./tools/cadence/nc_lib/mac_1g
  fi
  
if [ ! -d ./tools/cadence/nc_lib/mac2amba ] 
  then
    mkdir ./tools/cadence/nc_lib/mac2amba
  fi

if [ ! -d ./tools/cadence/nc_lib/mac_1g_amba ] 
  then
    mkdir ./tools/cadence/nc_lib/mac_1g_amba
  fi


# ------------------------------------------------------------------- #
# Library creation
# ------------------------------------------------------------------- #

echo "**** create cds.lib file ****"
echo "include $CDS_INST_DIR/tools/inca/files/cds.lib" > cds.lib
echo "define mac_1g_lib ./tools/cadence/nc_lib/mac_1g" >> cds.lib
echo "define mac2amba_lib ./tools/cadence/nc_lib/mac2amba" >> cds.lib
echo "define mac_1g_amba_lib ./tools/cadence/nc_lib/mac_1g_amba" >> cds.lib

echo "**** create hdl.var file ****"
echo "DEFINE NCELABOPTS -messages -work MAC_1G_AMBA_LIB" >> hdl.var
echo "DEFINE NCSIMOPTS  -messages" >> hdl.var
  
# ------------------------------------------------------------------- #
# Compiling components of core
# ------------------------------------------------------------------- #

echo "***************core***************"
ncvhdl -work MAC_1G_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $MAC_DIR/utility_mac_1g.vhd
ncvhdl -work MAC_1G_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $MAC_DIR/rc.vhd
ncvhdl -work MAC_1G_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $MAC_DIR/tc.vhd
ncvhdl -work MAC_1G_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $MAC_DIR/bd.vhd
ncvhdl -work MAC_1G_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $MAC_DIR/tfifo.vhd
ncvhdl -work MAC_1G_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $MAC_DIR/rfifo.vhd
ncvhdl -work MAC_1G_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $MAC_DIR/tlsm.vhd
ncvhdl -work MAC_1G_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $MAC_DIR/rlsm.vhd
ncvhdl -work MAC_1G_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $MAC_DIR/dma.vhd
ncvhdl -work MAC_1G_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $MAC_DIR/csr.vhd
ncvhdl -work MAC_1G_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $MAC_DIR/rstc.vhd
ncvhdl -work MAC_1G_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $MAC_DIR/miism.vhd
ncvhdl -work MAC_1G_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $MAC_DIR/miism.vhd
ncvhdl -work MAC_1G_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $MAC_DIR/dom.vhd
ncvhdl -work MAC_1G_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $MAC_DIR/domack.vhd
ncvhdl -work MAC_1G_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $MAC_DIR/domreq.vhd
ncvhdl -work MAC_1G_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $MAC_DIR/bp.vhd
ncvhdl -work MAC_1G_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $MAC_DIR/fcr.vhd
ncvhdl -work MAC_1G_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $MAC_DIR/fct.vhd
ncvhdl -work MAC_1G_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $MAC_DIR/fcstat.vhd
ncvhdl -work MAC_1G_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $MAC_DIR/sc.vhd
ncvhdl -work MAC_1G_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $MAC_DIR/mac_1g.vhd

ncvhdl -work MAC2AMBA_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $MAC2AMBA_DIR/mac2amba_package.vhd
ncvhdl -work MAC2AMBA_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $MAC2AMBA_DIR/maccsr2apb.vhd
ncvhdl -work MAC2AMBA_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $MAC2AMBA_DIR/macdata2ahb.vhd
ncvhdl -work MAC2AMBA_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $MAC2AMBA_DIR/mac2amba.vhd

ncvhdl -work MAC_1G_AMBA_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $SRC_DIR/mac_1g_amba.vhd

# ------------------------------------------------------------------- #
# Compiling components of sample unit
# ------------------------------------------------------------------- #

echo "***************chip***************"
ncvhdl -work MAC_1G_AMBA_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $CHIP_DIR/dualram.vhd
ncvhdl -work MAC_1G_AMBA_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $CHIP_DIR/scdram.vhd
ncvhdl -work MAC_1G_AMBA_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $CHIP_DIR/tris.vhd
ncvhdl -work MAC_1G_AMBA_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $CHIP_DIR/chip_mac_1g_amba.vhd

# ------------------------------------------------------------------- #
# Compiling Test Bench
# ------------------------------------------------------------------- #

echo "***************env****************"
ncvhdl -work MAC_1G_AMBA_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $ENV_DIR/smemstimahb.vhd
ncvhdl -work MAC_1G_AMBA_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $ENV_DIR/apbcmd.vhd
ncvhdl -work MAC_1G_AMBA_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $ENV_DIR/ambaarbcmd.vhd
ncvhdl -work MAC_1G_AMBA_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $ENV_DIR/intmon.vhd
ncvhdl -work MAC_1G_AMBA_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $ENV_DIR/linkmon.vhd
ncvhdl -work MAC_1G_AMBA_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $ENV_DIR/cam.vhd
ncvhdl -work MAC_1G_AMBA_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $ENV_DIR/clkgen.vhd
ncvhdl -work MAC_1G_AMBA_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $ENV_DIR/rstgen.vhd

# ------------------------------------------------------------------- #
# Compiling Test Bench
# ------------------------------------------------------------------- #

echo "***************tb****************"
ncvhdl -work MAC_1G_AMBA_LIB -logfile ncvhdl.log -errormax 15 -update -linedebug -status $TB_DIR/mac_1g_amba_tb.vhd

# ------------------------------------------------------------------- #
# Elaborating the Design
# ------------------------------------------------------------------- #

echo "************elaborate*************"

ncelab -snapshot $TOP"_32" -timescale 1ns/1ns -logfile ncelab.log -errormax 15 -update -access +wc -messages -nowarn CUVWSP -status MAC_1G_AMBA_TB:TESTBENCH
#---------------------------
# 32 bit
# CLKMII_PERIOD => 8 ns 
# CLKAPB_PERIOD => 24 ns 
# CLKAHB_PERIOD => 24 ns
#---------------------------
ncelab -snapshot $TOP"_32_g" -generic "CLKMII_PERIOD => 8 ns" -generic "CLKAPB_PERIOD => 24 ns" \
-generic "CLKAHB_PERIOD => 24 ns" -logfile ncelab.log -errormax 15 -update \
-access +wc -messages -nowarn CUVWSP -status MAC_1G_AMBA_TB:TESTBENCH
#---------------------------
# 32 bit
# CLKMII_PERIOD => 40 ns 
# CLKAPB_PERIOD => 400 ns 
# CLKAHB_PERIOD => 400 ns
#---------------------------
ncelab -snapshot $TOP"_32_a" -generic "CLKMII_PERIOD => 40 ns" -generic "CLKAPB_PERIOD => 400 ns" \
-generic "CLKAHB_PERIOD => 400 ns"  -logfile ncelab.log -errormax 15 -update \
-access +wc -messages -nowarn CUVWSP -status MAC_1G_AMBA_TB:TESTBENCH
#---------------------------
# 32 bit
# CLKMII_PERIOD => 400 ns 
# CLKAPB_PERIOD => 40 ns 
# CLKAHB_PERIOD => 40 ns
#---------------------------
ncelab -snapshot $TOP"_32_b" -generic "CLKMII_PERIOD => 400 ns" -generic "CLKAPB_PERIOD => 40 ns" \
-generic "CLKAHB_PERIOD => 40 ns" -logfile ncelab.log -errormax 15 -update \
-access +wc -messages -nowarn CUVWSP -status MAC_1G_AMBA_TB:TESTBENCH
#---------------------------
# 32 bit
# CLKMII_PERIOD => 40 ns 
# CLKAPB_PERIOD => 400 ns 
# CLKAHB_PERIOD => 40 ns
#---------------------------
ncelab -snapshot $TOP"_32_c" -generic "CLKMII_PERIOD => 40 ns" -generic "CLKAPB_PERIOD => 400 ns" \
-generic "CLKAHB_PERIOD => 40 ns" -logfile ncelab.log -errormax 15 -update \
-access +wc -messages -nowarn CUVWSP -status MAC_1G_AMBA_TB:TESTBENCH
#---------------------------
# 32 bit
# CLKMII_PERIOD => 400 ns 
# CLKAPB_PERIOD => 40 ns 
# CLKAHB_PERIOD => 400 ns
#---------------------------
ncelab -snapshot $TOP"_32_d" -generic "CLKMII_PERIOD => 400 ns" -generic "CLKAPB_PERIOD => 40 ns" \
-generic "CLKAHB_PERIOD => 400 ns" -logfile ncelab.log -errormax 15 -update \
-access +wc -messages -nowarn CUVWSP -status MAC_1G_AMBA_TB:TESTBENCH
 # ------------------------------------------------------------------- #
#---------------------------
# 16 bit
# APBDATAWIDTH => 16 
# AHBDATAWIDTH => 16
# TFIFODEPTH   => 10 
# RFIFODEPTH   => 10
#---------------------------
ncelab -snapshot $TOP"_16" -generic "APBDATAWIDTH => 16" -generic "AHBDATAWIDTH => 16" \
-generic "TFIFODEPTH => 10" -generic "RFIFODEPTH => 10" -logfile ncelab.log \
-errormax 15 -update -access +wc -nowarn CUVWSP MAC_1G_AMBA_TB:TESTBENCH
#---------------------------
# 16 bit
# APBDATAWIDTH  => 16 
# AHBDATAWIDTH  => 16
# TFIFODEPTH    => 10 
# RFIFODEPTH    => 10
# CLKMII_PERIOD => 8 ns 
# CLKAPB_PERIOD => 24 ns 
# CLKAHB_PERIOD => 24 ns
#---------------------------
ncelab -snapshot $TOP"_16_g" -generic "APBDATAWIDTH => 16" -generic "AHBDATAWIDTH => 16" \
-generic "TFIFODEPTH => 10" -generic "RFIFODEPTH => 10" -generic "CLKMII_PERIOD => 8 ns" \
-generic "CLKAPB_PERIOD => 24 ns" -generic "CLKAHB_PERIOD => 24 ns" \
-logfile ncelab.log -errormax 15 -update -access +wc -messages -nowarn CUVWSP -status MAC_1G_AMBA_TB:TESTBENCH
#---------------------------
# 16 bit
# APBDATAWIDTH  => 16 
# AHBDATAWIDTH  => 16
# TFIFODEPTH    => 10 
# RFIFODEPTH    => 10
# CLKMII_PERIOD => 40 ns 
# CLKAPB_PERIOD => 400 ns 
# CLKAHB_PERIOD => 400 ns
#---------------------------
ncelab -snapshot $TOP"_16_a" -generic "APBDATAWIDTH => 16" -generic "AHBDATAWIDTH => 16" \
-generic "TFIFODEPTH => 10" -generic "RFIFODEPTH => 10" -generic "CLKMII_PERIOD => 40 ns" \
-generic "CLKAPB_PERIOD => 400 ns" -generic "CLKAHB_PERIOD => 400 ns" \
-logfile ncelab.log -errormax 15 -update -access +wc -messages -nowarn CUVWSP -status MAC_1G_AMBA_TB:TESTBENCH
#---------------------------
# 16 bit
# APBDATAWIDTH  => 16 
# AHBDATAWIDTH  => 16
# TFIFODEPTH    => 10 
# RFIFODEPTH    => 10
# CLKMII_PERIOD => 400 ns 
# CLKAPB_PERIOD => 40 ns 
# CLKAHB_PERIOD => 40 ns
#---------------------------
ncelab -snapshot $TOP"_16_b" -generic "APBDATAWIDTH => 16" -generic "AHBDATAWIDTH => 16" \
-generic "TFIFODEPTH => 10" -generic "RFIFODEPTH => 10" -generic "CLKMII_PERIOD => 400 ns" \
-generic "CLKAPB_PERIOD => 40 ns" -generic "CLKAHB_PERIOD => 40 ns" \
-logfile ncelab.log -errormax 15 -update -access +wc -messages -nowarn CUVWSP -status MAC_1G_AMBA_TB:TESTBENCH
#---------------------------
# 16 bit
# APBDATAWIDTH  => 16 
# AHBDATAWIDTH  => 16
# TFIFODEPTH    => 10 
# RFIFODEPTH    => 10
# CLKMII_PERIOD => 40 ns 
# CLKAPB_PERIOD => 400 ns 
# CLKAHB_PERIOD => 40 ns
#---------------------------
ncelab -snapshot $TOP"_16_c" -generic "APBDATAWIDTH => 16" -generic "AHBDATAWIDTH => 16" \
-generic "TFIFODEPTH => 10" -generic "RFIFODEPTH => 10" -generic "CLKMII_PERIOD => 40 ns" \
-generic "CLKAPB_PERIOD => 400 ns" -generic "CLKAHB_PERIOD => 40 ns" \
-logfile ncelab.log -errormax 15 -update -access +wc -messages -nowarn CUVWSP -status MAC_1G_AMBA_TB:TESTBENCH
#---------------------------
# 16 bit
# APBDATAWIDTH  => 16 
# AHBDATAWIDTH  => 16
# TFIFODEPTH    => 10 
# RFIFODEPTH    => 10
# CLKMII_PERIOD => 400 ns 
# CLKAPB_PERIOD => 40 ns 
# CLKAHB_PERIOD => 400 ns
#---------------------------
ncelab -snapshot $TOP"_16_d" -generic "APBDATAWIDTH => 16" -generic "AHBDATAWIDTH => 16" \
-generic "TFIFODEPTH => 10" -generic "RFIFODEPTH => 10" -generic "CLKMII_PERIOD => 400 ns" \
-generic "CLKAPB_PERIOD => 40 ns" -generic "CLKAHB_PERIOD => 400 ns" \
-logfile ncelab.log -errormax 15 -update -access +wc -messages -nowarn CUVWSP -status MAC_1G_AMBA_TB:TESTBENCH
#-------------------------------------------------------------------- #
#---------------------------
# 8 bit
# APBDATAWIDTH  => 8 
# AHBDATAWIDTH  => 8
# TFIFODEPTH    => 11 
# RFIFODEPTH    => 11
#---------------------------
ncelab -snapshot $TOP"_8" -generic "APBDATAWIDTH => 8" -generic "AHBDATAWIDTH => 8" \
-generic "TFIFODEPTH => 11" -generic "RFIFODEPTH => 11" -timescale 1ns/1ns -logfile ncelab.log \
-errormax 15 -update -access +wc -messages -nowarn CUVWSP -status MAC_1G_AMBA_TB:TESTBENCH
#---------------------------
# 8 bit
# APBDATAWIDTH  => 8 
# AHBDATAWIDTH  => 8
# TFIFODEPTH    => 11 
# RFIFODEPTH    => 11
# CLKMII_PERIOD => 8 ns 
# CLKAPB_PERIOD => 24 ns 
# CLKAHB_PERIOD => 24 ns
#---------------------------
ncelab -snapshot $TOP"_8_g" -generic "APBDATAWIDTH => 8" -generic "AHBDATAWIDTH => 8" \
-generic "TFIFODEPTH => 11" -generic "RFIFODEPTH => 11" -generic "CLKMII_PERIOD => 8 ns" \
-generic "CLKAPB_PERIOD => 24 ns" -generic "CLKAHB_PERIOD => 24 ns" \
-logfile ncelab.log -errormax 15 -update -access +wc -messages -nowarn CUVWSP -status MAC_1G_AMBA_TB:TESTBENCH
#---------------------------
# 8 bit
# APBDATAWIDTH  => 8 
# AHBDATAWIDTH  => 8
# TFIFODEPTH    => 11 
# RFIFODEPTH    => 11
# CLKMII_PERIOD => 40 ns 
# CLKAPB_PERIOD => 400 ns 
# CLKAHB_PERIOD => 400 ns
#---------------------------
ncelab -snapshot $TOP"_8_a" -generic "APBDATAWIDTH => 8" -generic "AHBDATAWIDTH => 8" \
-generic "TFIFODEPTH => 11" -generic "RFIFODEPTH => 11" -generic "CLKMII_PERIOD => 40 ns" \
-generic "CLKAPB_PERIOD => 400 ns" -generic "CLKAHB_PERIOD => 400 ns" \
-logfile ncelab.log -errormax 15 -update -access +wc -messages -nowarn CUVWSP -status MAC_1G_AMBA_TB:TESTBENCH
#---------------------------
# 8 bit
# APBDATAWIDTH  => 8 
# AHBDATAWIDTH  => 8
# TFIFODEPTH    => 11 
# RFIFODEPTH    => 11
# CLKMII_PERIOD => 400 ns 
# CLKAPB_PERIOD => 40 ns 
# CLKAHB_PERIOD => 40 ns
#---------------------------
ncelab -snapshot $TOP"_8_b" -generic "APBDATAWIDTH => 8" -generic "AHBDATAWIDTH => 8" \
-generic "TFIFODEPTH => 11" -generic "RFIFODEPTH => 11" -generic "CLKMII_PERIOD => 400 ns" \
-generic "CLKAPB_PERIOD => 40 ns" -generic "CLKAHB_PERIOD => 40 ns" \
-logfile ncelab.log -errormax 15 -update -access +wc -messages -nowarn CUVWSP -status MAC_1G_AMBA_TB:TESTBENCH
#---------------------------
# 8 bit
# APBDATAWIDTH  => 8 
# AHBDATAWIDTH  => 8
# TFIFODEPTH    => 11 
# RFIFODEPTH    => 11
# CLKMII_PERIOD => 40 ns 
# CLKAPB_PERIOD => 400 ns 
# CLKAHB_PERIOD => 40 ns
#---------------------------
ncelab -snapshot $TOP"_8_c" -generic "APBDATAWIDTH => 8" -generic "AHBDATAWIDTH => 8" \
-generic "TFIFODEPTH => 11" -generic "RFIFODEPTH => 11" -generic "CLKMII_PERIOD => 40 ns" \
-generic "CLKAPB_PERIOD => 400 ns" -generic "CLKAHB_PERIOD => 40 ns" \
-logfile ncelab.log -errormax 15 -update -access +wc -messages -nowarn CUVWSP -status MAC_1G_AMBA_TB:TESTBENCH
#---------------------------
# 8 bit
# APBDATAWIDTH  => 8 
# AHBDATAWIDTH  => 8
# TFIFODEPTH    => 11 
# RFIFODEPTH    => 11
# CLKMII_PERIOD => 400 ns 
# CLKAPB_PERIOD => 40 ns 
# CLKAHB_PERIOD => 400 ns
#---------------------------
ncelab -snapshot $TOP"_8_d" -generic "APBDATAWIDTH => 8" -generic "AHBDATAWIDTH => 8" \
-generic "TFIFODEPTH => 11" -generic "RFIFODEPTH => 11" -generic "CLKMII_PERIOD => 400 ns" \
-generic "CLKAPB_PERIOD => 40 ns" -generic "CLKAHB_PERIOD => 400 ns" \
-logfile ncelab.log -errormax 15 -update -access +wc -messages -nowarn CUVWSP -status MAC_1G_AMBA_TB:TESTBENCH
