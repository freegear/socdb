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
# File name            : simulate.sh
# File contents        : Sample batch for Cadence's NC-SIM
# Purpose              : Defualt validation
# Design Engineer      : D.B.
# Quality Engineer     : M.B.
# Test version         : 2.02
# Last modification    : 2004-08-16
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# Simulation run
# -------------------------------------------------------------------

  T_DIR="./tools/cadence/nc_scripts"

  ncsim MAC_AMBA_32 -tcl -input $T_DIR/simulate.tcl

# -------------------------------------------------------------------