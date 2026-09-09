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
# File name            : all_tests.tcl
# File contents        : Sample macro for Aldec
# Purpose              : Supports all tests validation
# Design Engineer      : L.C.
# Quality Engineer     : M.B.
# Version              : 2.00
# Last modification    : 2003-11-29
# ------------------------------------------------------------------- #


# ------------------------------------------------------------------- #
# Directories location
# ------------------------------------------------------------------- #

set root    e:/designs/core_mac/core_mac_1g/mac_1g_amba_200e00
set logpath $root/tools/aldec/log
foreach testgroup {d32 d16 d08} {

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

  puts "testing $path"

  # ----------------------------------------------------------------- #
  # If test exist run simulation
  # ----------------------------------------------------------------- #
  if {[file exists $tpath/$tname/time.txt] == 1 &&
      [file exists $tpath/$tname/generic.txt] == 1} {

    # --------------------------------------------------------------- #
    # Read generic
    # --------------------------------------------------------------- #
    set glist "-GTESTNAME=\"$tname\" -GTESTPATH=\"$tpath\""
    set generic [open $tpath/$tname/generic.txt r]
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
    eval vsim -t ns $glist -lib MAC_1G_AMBA_LIB TESTBENCH_MAC_1G_AMBA_CONFIGURATION

    # --------------------------------------------------------------- #
    # Run test
    # --------------------------------------------------------------- #
    set time_txt [open $tpath/$tname/time.txt r]
    while {[gets $time_txt time_line] >= 0} {
      if {[scan $time_line {%[run] %d %[muns]} cmd_s time_d unit_s] == 3} {
        eval $cmd_s $time_d $unit_s
        }
      }

    # --------------------------------------------------------------- #
    # Quit simulation
    # --------------------------------------------------------------- #
    endsim

    # --------------------------------------------------------------- #
    # Read diff files
    # --------------------------------------------------------------- #
    set logfile  [open $logpath/$tname.log w]
    set linkdiff [open $tpath/$tname/linkdiff.txt r]
    set ahbdiff  [open $tpath/$tname/ahbdiff.txt r]
    set apbdiff [open $tpath/$tname/apbdiff.txt r]
    set intdiff  [open $tpath/$tname/intdiff.txt r]
    puts $logfile "Link monitor"
    while { [gets $linkdiff diffline] >= 0 }  {
      puts $logfile $diffline
      }													  
	puts $logfile "--------------------------------------"  
    puts $logfile "AHB monitor"
    while { [gets $ahbdiff diffline] >= 0 }  {
      puts $logfile $diffline
      }													  
	puts $logfile "--------------------------------------"  
    puts $logfile "APB monitor"
    while { [gets $apbdiff diffline] >= 0 }  {
      puts $logfile $diffline							 
      }													 
	puts $logfile "--------------------------------------"  
    puts $logfile "Interupt monitor"
    while { [gets $intdiff diffline] >= 0 }  {
      puts $logfile $diffline
      }
    close $linkdiff
    close $ahbdiff
    close $apbdiff
    close $intdiff
    close $logfile

    }

  }
}
# ------------------------------------------------------------------- #
# End tests
# ------------------------------------------------------------------- #