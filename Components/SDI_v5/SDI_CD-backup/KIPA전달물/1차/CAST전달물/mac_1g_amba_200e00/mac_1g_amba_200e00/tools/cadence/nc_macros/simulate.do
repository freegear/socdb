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
# File name            : simulate.do
# File contents        : Sample simulation script for Cadence's NC-SIM
# Purpose              : MAC test bench
# Design Engineer      : T.T. D.B.
# Quality Engineer     : M.B.
# Test version         : 2.00
# Last modification    : 2003-09-15
# ------------------------------------------------------------------- #

# ------------------------------------------------------------------- #
# Directories location
# ------------------------------------------------------------------- #

setenv reports_dir      ./tools/cadence/nc_reports
setenv macros_dir       ./tools/cadence/nc_macros
setenv slog             $reports_dir/simulate.log
setenv test_time        ./tests/default/time.txt

# ------------------------------------------------------------------- #
# Loading the Test Bench
# ------------------------------------------------------------------- #

ncsim -gui -logfile $slog -input $macros_dir/wave.do MAC_1G_AMBA_LIB.MAC_1G_AMBA_TB:testbench

# Before simulating make sure to copy the contents of the desired test 
# directory to tests/default (ie. cp tests/m4d32/mkd32_bd1/* tests/default)
#
# run the simulation for the amount shown in the time.txt file for each test.
# ******************************************************************* #
