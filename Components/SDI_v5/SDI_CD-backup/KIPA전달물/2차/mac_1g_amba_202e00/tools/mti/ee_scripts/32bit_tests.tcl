# ******************************************************************* #
# Copyright (c) 1999-2004  Evatronix SA
# ******************************************************************* #
# Please review the terms of the license agreement before using
# this file. If you are not an authorized user, please destroy this
# source code file and notify Evatronix SA immediately that you
# inadvertently received an unauthorized copy.
# ******************************************************************* #

# ------------------------------------------------------------------- #
# Project name         : MAC-1G_AMBA
# Project description  : Ethernet Media Access Controller
#
# File name            : d32_tests.tcl
# File contents        : Sample script for MTI ModelSim EE
# Purpose              :
# Design Engineer      : L.C.
# Quality Engineer     : M.B.
# Version              : 2.02
# Last modification    : 2004-08-16
# ------------------------------------------------------------------- #


# ------------------------------------------------------------------- #
# Directories location
# ------------------------------------------------------------------- #

set reports_dir tools/mti/ee_reports
set tpath       tests

file mkdir $reports_dir
set rtest  [open $reports_dir/tests.log w]


# ------------------------------------------------------------------- #
# List of tests
# ------------------------------------------------------------------- #
cd $tpath
set testclasses [glob d32*]
cd ..

foreach cpath $testclasses {

  #chceck for directory
  if [file isdirectory $tpath/$cpath]==1 {
    # get testnames
    cd $tpath/$cpath
    set tlist [glob -nocomplain -- *]
    cd ../..
  } else {
    # or ignore files
    set tlist ""
  }

# ------------------------------------------------------------------- #
# test class
# ------------------------------------------------------------------- #

foreach tname $tlist {

  puts $rtest "Simulating: $tpath/$cpath/$tname"
  flush $rtest

  # ----------------------------------------------------------------- #
  # If test exist run simulation
  # ----------------------------------------------------------------- #
  if {[file exists $tpath/$cpath/$tname/time.txt] == 1 &&
      [file exists $tpath/$cpath/$tname/generic.txt] == 1} {




    # --------------------------------------------------------------- #
    # Read generic
    # --------------------------------------------------------------- #
    set glist "-GTESTNAME=\"$tname\" -GTESTPATH=\"$tpath/$cpath\" "
    set generic [open $tpath/$cpath/$tname/generic.txt r]
    while { [gets $generic gline] >= 0 }  {
      set gline [string trimright $gline]
      if {[string length $gline] == 0} {continue}
      set gline [string trimleft $gline]
      append glist " -$gline"
      }
    close $generic

    # --------------------------------------------------------------- #
    # Initialize simulation
    # --------------------------------------------------------------- #
    alias vsim_ext "vsim -c -t ns -quiet -l $reports_dir/$tname.log"
    alias vsim_gen "vsim_ext $glist"
    vsim_gen -lib MAC_1G_AMBA_LIB MAC_1G_AMBA_TB

    # --------------------------------------------------------------- #
    # Run test
    # --------------------------------------------------------------- #
    do $tpath/$cpath/$tname/time.txt


    # --------------------------------------------------------------- #
    # Quit simulation
    # --------------------------------------------------------------- #
    quit -sim

    } else {

    puts $rtest "Test $tname failed: generic.txt or time.txt don't exist"
    flush $rtest

    }

  }
}
close $rtest

# ------------------------------------------------------------------- #
# End tests
# ------------------------------------------------------------------- #
if [batch_mode] {exit}
# ------------------------------------------------------------------- #