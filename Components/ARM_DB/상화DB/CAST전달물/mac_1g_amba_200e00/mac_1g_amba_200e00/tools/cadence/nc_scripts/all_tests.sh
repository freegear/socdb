#!/bin/sh

# ******************************************************************* #
# Copyright (c) 1999-2003  Evatronix SA
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
# Version              : 2.00
# Last modification    : 2003-09-15
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# Simulation run
# -------------------------------------------------------------------

  T_DIR="./tools/cadence/nc_scripts"

# 32 bit 
#-------  

  ncsim MAC_AMBA_32 -tcl -input $T_DIR/m4d32_tests.tcl
  ncsim MAC_AMBA_32_a -tcl -input $T_DIR/m4d32_a_tests.tcl  
  ncsim MAC_AMBA_32_b -tcl -input $T_DIR/m4d32_b_tests.tcl
  ncsim MAC_AMBA_32_c -tcl -input $T_DIR/m4d32_c_tests.tcl
  ncsim MAC_AMBA_32_d -tcl -input $T_DIR/m4d32_d_tests.tcl

# 16 bit
#-------

  ncsim MAC_AMBA_16 -tcl -input $T_DIR/m4d16_tests.tcl
  ncsim MAC_AMBA_16_a -tcl -input $T_DIR/m4d16_a_tests.tcl
  ncsim MAC_AMBA_16_b -tcl -input $T_DIR/m4d16_b_tests.tcl
  ncsim MAC_AMBA_16_c -tcl -input $T_DIR/m4d16_c_tests.tcl
  ncsim MAC_AMBA_16_d -tcl -input $T_DIR/m4d16_d_tests.tcl

# 8 bit
#-------

  ncsim MAC_AMBA_8 -tcl -input $T_DIR/m4d8_tests.tcl
  ncsim MAC_AMBA_8_a -tcl -input $T_DIR/m4d8_a_tests.tcl
  ncsim MAC_AMBA_8_b -tcl -input $T_DIR/m4d8_b_tests.tcl
  ncsim MAC_AMBA_8_c -tcl -input $T_DIR/m4d8_c_tests.tcl
  ncsim MAC_AMBA_8_d -tcl -input $T_DIR/m4d8_d_tests.tcl


# -------------------------------------------------------------------