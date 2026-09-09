# ******************************************************************* #
# Copyright (c) 1999-2003  Evatronix SA
# ******************************************************************* #
# Please review the terms of the license agreement before using
# this file. If you are not an authorized user, please destroy this
# source code file and notify Evatronix SA immediately that you
# inadvertently received an unauthorized copy.
# ******************************************************************* #

# ------------------------------------------------------------------- #
# Project name         : MAC
# Project description  : Ethernet Media Access Controller
#
# File name            : 32bit_tests.tcl
# File contents        : Sample macro for Aldec
# Purpose              : Supports 32 bit tests series validation
# Design Engineer      : L.C.
# Quality Engineer     : M.B.
# Version              : 2.02
# Last modification    : 2004-08-16
# ------------------------------------------------------------------- #


# ------------------------------------------------------------------- #
# Directories location
# ------------------------------------------------------------------- #

set root    d:/designs/mac_1g_amba/ver_202/mac_1g_amba_202e00
set logpath $root/tools/aldec/log

foreach testgroup {d08_fc d08_g d08_gsc d08_sc d08 d16_fc d16_g d16_gsc d16_sc d16 d32_fc d32_g d32_gsc d32_sc d32} {

# ------------------------------------------------------------------- #
# List of tests
# ------------------------------------------------------------------- #
set tpath $root/tests/$testgroup
cd $tpath
set tlist [glob *]

# ------------------------------------------------------------------- #
# Main loop
# ------------------------------------------------------------------- #

foreach tname $tlist {

  puts "clearing $tpath/$tname"

  file delete -force $tpath/$tname/csrstim.txt
  file delete -force $tpath/$tname/csrcomp.txt
  file delete -force $tpath/$tname/datastim.txt
  file delete -force $tpath/$tname/datacomp.txt
  file delete -force $tpath/$tname/csrdiff.txt
  file delete -force $tpath/$tname/datadiff.txt

  }
}
# ------------------------------------------------------------------- #
# End tests
# ------------------------------------------------------------------- #