#!/bin/csh -f

# ******************************************************************* #
# Copyright (c) 1999-2004  Evatronix SA
# ******************************************************************* #
# Please review the terms of the license agreement before using
# this file. If you are not an authorized user, please destroy this
# source code file and notify Evatronix SA immediately that you
# inadvertently received an unauthorized copy.
# ******************************************************************* #

# ------------------------------------------------------------------- #
# Project name         : MAC-1G AMBA
# Project description  : Ethernet Media Access Controller 
#
# File name            : 32bit_tests.sh
# File contents        : Sample script for MTI ModelSim EE
# Purpose              : Supports tests series for 32 bit validation
# Design Engineer      : L.C.
# Quality Engineer     : M.B.
# Version              : 2.02
# Last modification    : 2004-08-16
# ------------------------------------------------------------------- #

# -------------------------------------------------------------------
# work directory location
# -------------------------------------------------------------------

cd ../../../

# -------------------------------------------------------------------
# Default directory location
# -------------------------------------------------------------------

scr_file=tools/mti/ee_scripts/32bit_tests.tcl
log_file=tools/mti/ee_reports/32bit_tests.log

# -------------------------------------------------------------------
# Run compile
# -------------------------------------------------------------------

vsim -c -l $log_file -do $scr_file

# -------------------------------------------------------------------