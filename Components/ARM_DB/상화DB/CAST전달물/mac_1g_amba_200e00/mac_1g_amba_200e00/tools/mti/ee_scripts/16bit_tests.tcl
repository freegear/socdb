# ******************************************************************* #
# Copyright (c) 1999-2003  Evatronix SA
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
# File name            : 32bit_tests.tcl
# File contents        : Sample script for MTI ModelSim EE
# Purpose              : Supports tests series for 32 bit validation
# Design Engineer      : L.C.
# Quality Engineer     : M.B.
# Version              : 2.00
# Last modification    : 2003-11-28
# ------------------------------------------------------------------- #


# ------------------------------------------------------------------- #
# Directories location
# ------------------------------------------------------------------- #

set reports_dir tools/mti/ee_reports
set tpath       tests/d16	
set rtest       [open $reports_dir/32bit_tests.log w] 

# ------------------------------------------------------------------- #
# List of tests
# ------------------------------------------------------------------- #
cd $tpath
set tlist [glob *]
cd ../../

# ------------------------------------------------------------------- #
# Main loop
# ------------------------------------------------------------------- #

foreach tname $tlist {

  # ----------------------------------------------------------------- #
  # Run only ff exist time.txt and generic.txt
  # ----------------------------------------------------------------- #
  if {[file exists $tpath/$tname/time.txt]    == 1 &&
      [file exists $tpath/$tname/generic.txt] == 1} { 
	  
	# --------------------------------------------------------------- #
	# Read generics   
	# --------------------------------------------------------------- #
	set glist "-GTESTNAME=\"$tname\" -GTESTPATH=\"$tpath\""
	set generic [open $tpath/$tname/generic.txt r]
	while { [gets $generic gline] >= 0 }  {
		set gline [string trimright $gline]
		if {[string length $gline] == 0} {continue}
		set gline [string trimleft $gline]
		append glist " -$gline"      }
	close $generic 
	
	# --------------------------------------------------------------- #
    # Apppend report file indication
    # --------------------------------------------------------------- #
    append glist " -l $reports_dir/$tname.log"
	
    # --------------------------------------------------------------- #
    # Initialize simulation
    # --------------------------------------------------------------- #
    alias vsim_ext "vsim -c -t ns -quiet $glist"
    vsim_ext -lib MAC_1G_AMBA_LIB TESTBENCH_MAC_1G_AMBA_CONFIGURATION 

    # --------------------------------------------------------------- #
    # Run test
    # --------------------------------------------------------------- #
    do $tpath/$tname/time.txt

    # --------------------------------------------------------------- #
    # Quit simulation
    # --------------------------------------------------------------- #
    quit -sim

    }
  }

# ------------------------------------------------------------------- #
# End tests
# ------------------------------------------------------------------- #
if [batch_mode] {exit}
# ------------------------------------------------------------------- #