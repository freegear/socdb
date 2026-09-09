# ******************************************************************* #
# Copyright (c) 1999-2004  Evatronix SA
# ******************************************************************* #
# Please review the terms of the license agreement before using
# this file. If you are not an authorized user, please destroy this
# source code file and notify Evatronix SA immediately that you
# inadvertently received an unauthorized copy.
# ******************************************************************* #

# ------------------------------------------------------------------- #
# Project name         :
# Project description  : 
#
# File name            : m4d32_tests.tcl
# File contents        : Sample script for Cadence's NC-SIM
# Purpose              : Supports tests series PE_TESTS validation
# Design Engineer      : D.B.
# Quality Engineer     : M.B.
# Test version         : 2.02
# Last modification    : 2004-08-16
# ------------------------------------------------------------------- #

# ------------------------------------------------------------------- #
# Directories location
# ------------------------------------------------------------------- #

set tpath        ./tests/d32
set default_test ./tests/default
set rep_dir      ./tools/cadence/nc_reports
 
# ------------------------------------------------------------------- #
# List of tests
# ------------------------------------------------------------------- #
cd $tpath
set tlist [glob *]
set tc_list [ list d32_misc1 d32_misc2 d32_misc3 d32_misc4 \
 d32_misc5  d32_misc6 d32_misc7 d32_misc8 d32_misc9 \
 d32_misc10 d32_misc11 d32_misc12 d32_bd4 d32_bd5 ]

# ------------------------------------------------------------------- #
# List of tests with standard parameter                               #
# ------------------------------------------------------------------- #
set diff_list $tlist
proc ldelete {list value} {
  set ix [lsearch -exact $list $value]
  if { $ix >= 0 } {
    return [lreplace $list $ix $ix]
  } else {
    return $list
  }
}

foreach diff $tc_list {
  set diff_list [ldelete $diff_list $diff]
}

cd ../..
echo $diff_list
file delete -force $rep_dir/d32_tests.rep
set report_test [open $rep_dir/d32_tests.rep a+]
puts $report_test [date]

# ------------------------------------------------------------------- #
# Main loop
# ------------------------------------------------------------------- #

foreach tname $diff_list {  
  set pres_test $tname
   
  # ----------------------------------------------------------------- #  
  # Copying test to default directory                                 #
  # ----------------------------------------------------------------- #
  file delete -force $default_test
  file copy -force $tpath/$pres_test ./tests
  file rename -force ./tests/$pres_test $default_test  
  puts $report_test $pres_test
  puts $report_test {#################################} 
  # ----------------------------------------------------------------- #
  # If test exist run simulation
  # ----------------------------------------------------------------- #
  if {[file exists $default_test/time.txt] == 1} {
        set TIME_FILE $default_test/time.txt
	set fo [open $TIME_FILE r]
	
	while {![eof $fo]} {
          gets $fo RUN_TEMP
          regexp {(run)\s+(\d+)\s+([mun][s])} $RUN_TEMP RUN cmd digits unit
         }
        close $fo
	puts $pres_test
	puts $RUN
	eval $RUN
	reset
     }
  # ----------------------------------------------------------------- #
  # Copying diff file from default directory                          #
  # ----------------------------------------------------------------- #   
     

  file copy -force $default_test/intdiff.txt $tpath/$pres_test
  file copy -force $default_test/linkdiff.txt $tpath/$pres_test
  file copy -force $default_test/ahbdiff.txt $tpath/$pres_test
  file copy -force $default_test/apbdiff.txt $tpath/$pres_test
  
  # ----------------------------------------------------------------- #
  # Writing results in reports file                                   #
  # ----------------------------------------------------------------- # 

  set int [open $tpath/$pres_test/intdiff.txt r]
  set lnk [open $tpath/$pres_test/linkdiff.txt r]
  set ahb [open $tpath/$pres_test/ahbdiff.txt r]
  set apb [open $tpath/$pres_test/apbdiff.txt r]


  puts $report_test {**** int_diff ****}
  while {![eof $int]} {
    gets $int data
    puts $report_test $data
    }
    close $int    
  puts $report_test {---------------------------}  
  puts $report_test {**** link_diff ****}
  while {![eof $lnk]} {
    gets $lnk data
    puts $report_test $data
    }
    close $lnk      
  puts $report_test {---------------------------}  
  puts $report_test {**** ahb_diff ****}
  while {![eof $ahb]} {
    gets $ahb data
    puts $report_test $data
    }
    close $ahb      
  puts $report_test {---------------------------}  
  puts $report_test {**** apb_diff ****}
  while {![eof $apb]} {
    gets $apb data
    puts $report_test $data
    }
    close $apb      
  }
  close $report_test
  [finish]      
