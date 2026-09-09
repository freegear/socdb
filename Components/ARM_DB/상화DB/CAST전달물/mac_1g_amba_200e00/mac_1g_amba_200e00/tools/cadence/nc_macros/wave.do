#!/bin/csh -f

# ******************************************************************* #
# Copyright (c) 2001-2002  Evatronix Ltd.
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
# File name            : wave.do
# File contents        : Sample wave for Cadence's NC-SIM
# Purpose              : MAC test bench
# Design Engineer      : T.T. D.B.
# Quality Engineer     : M.B.
# Test version         : 2.00
# Last modification    : 2003-09-15
# ------------------------------------------------------------------- #

# ------------------------------------------------------------------- #
# Adding signals to the 'Wave' window
# ------------------------------------------------------------------- #

database -open waves -into waves.shm -default
probe -create -ports -shm :UUT:U_MAC_1G_AMBA -waveform

# ******************************************************************* #