#!/bin/sh

# ******************************************************************* #
# Copyright (c) 1999-2004  Evatronix SA
# ******************************************************************* #
# Please review the terms of the license agreement before using
# this file. If you are not an authorized user, please destroy this
# source code file and notify Evatronix SA immediately that you
# inadvertently received an unauthorized copy.
# *******************************************************************
# -------------------------------------------------------------------
# Project name         : 
# Project description  : 
#
# File name            : all_tests.sh
# File contents        : Sample batch for Cadence's NC-SIM
# Purpose              : All tests series validation
# Design Engineer      : D.B.
# Quality Engineer     : M.B.
# Test version         : 2.02
# Last modification    : 2004-08-16
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# Simulation run
# -------------------------------------------------------------------

  T_DIR="./tools/cadence/nc_scripts"

# 32 bit 
#-------  

  ncsim MAC_AMBA_32   -tcl -input $T_DIR/d32_fc_tests.tcl
  ncsim MAC_AMBA_32   -tcl -input $T_DIR/d32_sc_tests.tcl
  ncsim MAC_AMBA_32_g -tcl -input $T_DIR/d32_g_tests.tcl
  ncsim MAC_AMBA_32_g -tcl -input $T_DIR/d32_gsc_tests.tcl
  ncsim MAC_AMBA_32   -tcl -input $T_DIR/d32_tests.tcl
  ncsim MAC_AMBA_32_a -tcl -input $T_DIR/d32_a_tests.tcl  
  ncsim MAC_AMBA_32_b -tcl -input $T_DIR/d32_b_tests.tcl
  ncsim MAC_AMBA_32_c -tcl -input $T_DIR/d32_c_tests.tcl
  ncsim MAC_AMBA_32_d -tcl -input $T_DIR/d32_d_tests.tcl

# 16 bit
#-------

  ncsim MAC_AMBA_16   -tcl -input $T_DIR/d16_fc_tests.tcl
  ncsim MAC_AMBA_16   -tcl -input $T_DIR/d16_sc_tests.tcl
  ncsim MAC_AMBA_16_g -tcl -input $T_DIR/d16_g_tests.tcl
  ncsim MAC_AMBA_16_g -tcl -input $T_DIR/d16_gsc_tests.tcl
  ncsim MAC_AMBA_16   -tcl -input $T_DIR/d16_tests.tcl
  ncsim MAC_AMBA_16_a -tcl -input $T_DIR/d16_a_tests.tcl
  ncsim MAC_AMBA_16_b -tcl -input $T_DIR/d16_b_tests.tcl
  ncsim MAC_AMBA_16_c -tcl -input $T_DIR/d16_c_tests.tcl
  ncsim MAC_AMBA_16_d -tcl -input $T_DIR/d16_d_tests.tcl

# 8 bit
#-------

  ncsim MAC_AMBA_8   -tcl -input $T_DIR/d08_fc_tests.tcl
  ncsim MAC_AMBA_8   -tcl -input $T_DIR/d08_sc_tests.tcl
  ncsim MAC_AMBA_8_g -tcl -input $T_DIR/d08_g_tests.tcl
  ncsim MAC_AMBA_8_g -tcl -input $T_DIR/d08_gsc_tests.tcl
  ncsim MAC_AMBA_8   -tcl -input $T_DIR/d08_tests.tcl
  ncsim MAC_AMBA_8_a -tcl -input $T_DIR/d08_a_tests.tcl
  ncsim MAC_AMBA_8_b -tcl -input $T_DIR/d08_b_tests.tcl
  ncsim MAC_AMBA_8_c -tcl -input $T_DIR/d08_c_tests.tcl
  ncsim MAC_AMBA_8_d -tcl -input $T_DIR/d08_d_tests.tcl


# -------------------------------------------------------------------