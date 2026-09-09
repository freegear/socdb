#------------------------------------------------------------------------------
#-- The confidential and proprietary information contained in this file may
#-- only be used by a person authorised under and to the extent permitted
#-- by a subsisting licensing agreement from ARM Limited.
#--
#--   (C) COPYRIGHT 2002 ARM Limited
#--       ALL RIGHTS RESERVED
#--
#-- This entire notice must be reproduced on all copies of this file
#-- and copies of this file may only be made by a person if such person is
#-- permitted to do so under the terms of a subsisting license agreement
#-- from ARM Limited.
#------------------------------------------------------------------------------
#--  
#-- Version and Release Control Information:
#-- 
#-- File Name           : functions.tcl.rca
#-- File Revision       : 1.2
#-- 
#-- Release Information : PrimeCell(TM)-GLOBAL-REL1v7
#------------------------------------------------------------------------------
#-- Purpose : Synopsys functions
#--
#------------------------------------------------------------------------------
#-- Functions : 
#--
#-- 1. Define clock (pCreateClock clock_name clock_rise clock_fall clock_period
#--                    clock_tpskew)
#-- 2. Define reset (pCreateReset reset_name tidmax tholdmax)
#-- 3. Define scan (pCreateScan scan_name) 
#-- 4. Acquire HDL compiler (pAcquireHDLCompiler hdl)
#-- 5. Release HDL Compiler (pReleaseHDLCompiler hdl)
#-- 6. Acquire Test Compiler (pAcquireTestCompiler)
#-- 7. Print start time (pStartTime run_time_log)
#-- 8. Print end time (pEndTime run_time_log)
#-- 9. Generate pre-scan report (pGeneratePreScanReport run_time_log 
#--                               report_name_base)
#-- 10.WriteResults (pWriteResults hdl topname run_time_log test_req)
#-- 11. Generate post-scan report (pGeneratePostScanReport run_time_log
#--                               report_name_base)
#-- 12. Generate report (pGenerateReport run_time_log report_name_base 
#--                        use_clock_gating)
#-- 13. Analyse HDL (pAnalyseHDL hdl file_list)
#-- 14. Acquire Power Compiler (pAcquirePowerCompiler)
#-- 15. Release Power Compiler (pReleasePowerCompiler)
#------------------------------------------------------------------------------

#============================================================================
#-- 1. Define clock
#============================================================================
#--   Minus clock skew must be subtracted from the clock period before
#-- being provided to this script.

proc pCreateClock { clock_name clock_rise clock_fall clock_period clock_tpskew } {

  #------------------------
  #-- Define clock
  #------------------------

  #-- clock, rise at clock_rise, fall at clock_fall
  create_clock -p $clock_period -w [list $clock_rise $clock_fall] \
                                         [find port $clock_name]

  #----------------------------
  #-- Plus clock skew (tpskew)
  #----------------------------   
  #-- Performed by using 
  #-- plus_uncertainty parameter
  #-----------------------------

  set_clock_skew -ideal -plus_uncertainty $clock_tpskew [find clock $clock_name]

  #-------------------------------
  #-- Ensure clock is not buffered
  #-------------------------------

  #-- Ignore all transition times as it is an ideal clock 
  set_clock_transition 0 $clock_name
  
  #-- Infinite drive strength clock signal 
  set_drive 0 $clock_name
  
  #-- Zero load clock signal 
  set_load 0 $clock_name
  
  #-- Set no driving cell on clock 
  remove_driving_cell [find port $clock_name]
  
  #-- Zero resistance for zero net delay(interconnect delay) on ideal clock net
  set_resistance 0 [find net $clock_name]
  
  #-- Preserve the clock net during optimisation 
  set_dont_touch_network [find clock $clock_name]
}

#============================================================================
#-- 2. Create reset pCreateReset (reset_name reset_clock tidmax tholdmax)
#============================================================================

proc pCreateReset { reset_name reset_clock tidmax tholdmax } {

  #----------------------------
  #-- Define reset
  #----------------------------

  set_input_delay -clock $reset_clock -rise -max $tidmax $reset_name
  set_input_delay -clock $reset_clock -rise -min $tholdmax $reset_name

  #----------------------------
  #-- Ensure reset is not buffered
  #----------------------------

  #-- Do not check reset timing during synthesis 
  set_disable_timing [find port $reset_name]
  
  #-- Zero load reset signal 
  set_load 0 $reset_name
  
  #-- Zero resistance for zero net delay(interconnect delay) on ideal reset net
  set_resistance 0 [find net $reset_name]
  
  #-- Infinite drive strength reset signal 
  set_drive 0 $reset_name
  
  #-- Set no driving cell on reset 
  remove_driving_cell [find port $reset_name]
  
  #-- Define an ideal net for the reset net 
  set_ideal_net [find net $reset_name]
  
  #-- Define an ideal net for the reset net 
  set_dont_touch_network [find port $reset_name]

}

#============================================================================
#-- 3. Create reset pCreateScan (scan_name)
#============================================================================

proc pCreateScan {scan_name} {

  #----------------------------
  #-- Ensure scan signal is not buffered
  #----------------------------

  #-- Do not check scan timing during synthesis 
  set_disable_timing [find port $scan_name]
  
  #-- Zero load scan signal 
  set_load 0 [find port $scan_name]
  
  #-- Infinite drive strength scan signal 
  set_drive 0 [find port $scan_name]
  
  #-- Set no driving cell on scan signal 
  remove_driving_cell [find port $scan_name]
  
  #-- Preserve the net during optimisation 
  set_dont_touch_network [find port $scan_name]

}

#============================================================================
#-- 4. Acquire HDL Compiler pAcquireHDLCompiler hdl
#============================================================================
#-- Note: The initial remove_license is needed even though it looks
#-- redundant. This is to account for cases where the V/HDL-Compiler
#-- is automatically checked out during the compile phase.

proc pAcquireHDLCompiler {hdl} {

  #----------------------------
  #-- Acquire HDL compiler
  #----------------------------


  if {$hdl == {vhdl}} {
    #Get VHDL Compiler license
    redirect -append /dev/null {remove_license VHDL-Compiler}
    redirect -append /dev/null {set dc_shell_status \
      [ get_license VHDL-Compiler ]}
    while {  $dc_shell_status == 0 } {
      sh sleep 30
      redirect -append /dev/null {set dc_shell_status \
        [get_license VHDL-Compiler]}
    }
  } else {
    if {$hdl == {verilog}} {
      #Get Verilog Compiler license
      redirect -append /dev/null {remove_license HDL-Compiler}
      redirect -append /dev/null {set dc_shell_status \
        [ get_license HDL-Compiler ]}
      while {  $dc_shell_status == 0 } {
        sh sleep 30
        redirect -append /dev/null {set dc_shell_status \
          [get_license HDL-Compiler]}
      }
    }
  }
}

#============================================================================
#-- 5. Release HDL Compiler pReleaseHDLCompiler hdl
#============================================================================

proc pReleaseHDLCompiler {hdl} {

  #----------------------------
  #-- Release HDL compiler
  #---------------------------- 

  if {$hdl == {vhdl}} {
    redirect -append /dev/null {remove_license VHDL-Compiler}
  } else {
    if {$hdl == {verilog}} {
      redirect -append /dev/null {remove_license HDL-Compiler}
    }
  }
}

#============================================================================
#-- 6. Acquire Test Compiler pAcquireTestCompiler 
#============================================================================
#-- Note: The initial remove_license is needed even though it looks
#-- redundant. This is to account for cases where the licence
#-- is automatically checked out.

proc pAcquireTestCompiler {} {

  #----------------------------
  #-- Acquire test compiler
  #----------------------------

  #-- Remove test compiler licence
  redirect -append /dev/null { remove_license Test-Compiler }
  #-- Acquire test compiler license
  set dc_shell_status [ get_license Test-Compiler ]
  while {  $dc_shell_status == 0 } {
    sh sleep 30
    redirect -append /dev/null {set dc_shell_status \
      [get_license Test-Compiler]}
  }
}

#============================================================================
#-- 7. Print start time pStartTime
#============================================================================
                              
proc pStartTime {run_time_log} {          
                   
  #------------------------------------
  #-- Write synthesis run start time
  #------------------------------------
                              
  redirect $run_time_log         { echo [concat {Peripheral synthesis log}] }
  redirect -append $run_time_log { echo [concat ==========================] }
  redirect -append $run_time_log { echo [concat] }
  redirect -append $run_time_log { echo [concat {Start time   -> }] }
  redirect -append $run_time_log { sh date }
  redirect -append $run_time_log { echo [concat =========================] }
  redirect -append $run_time_log { echo [concat] }
}                             
                              
#============================================================================
#-- 8. Print end time pEndTime
#============================================================================
                              
proc pEndTime {run_time_log} {
                 
  #------------------------------------
  #-- Write synthesis run end time
  #------------------------------------
                              
  redirect -append $run_time_log { echo [concat {End time   -> }] }
  redirect -append $run_time_log { sh date }
  redirect -append $run_time_log { echo [concat =========================] }
  redirect -append $run_time_log { echo [concat] }
}

#============================================================================
#-- 9. Generate pre-scan report 
#-- pGeneratePreScanReport run_time_log report_name_base
#============================================================================
                         
proc pGeneratePreScanReport {run_time_log report_name_base} {       
                
  #------------------------------------
  #-- Generate pre-scan report
  #------------------------------------

  redirect -append $run_time_log { echo [concat] }
  redirect -append $run_time_log { echo [concat check_test before scan] }
  redirect -append $run_time_log { echo [concat ======================] }
  redirect -append $run_time_log { echo [concat] }
  redirect -append $run_time_log { check_dft -verbose }

  #-- Generate a dc_shell script that specifies the defined scan configuration 
  redirect [format "%s%s"  $report_name_base .PreviewScript] \
    {preview_scan -script}

  redirect [format "%s%s"  $report_name_base .PreviewAll] \
    {preview_scan -show all}
}    
                   

#============================================================================
#-- 10. Write results pWriteResults run_time_log
#============================================================================

proc pWriteResults {hdl topname run_time_log test_req} {

  #-- Netlist name base
  set netlist_name_base [format "%s%s" [format "%s%s" [format "%s%s" \
    [format "%s%s"  [format "%s%s" [format "%s%s" \
    ../verilog/netlist/ $topname] _] $test_req] _] $hdl] _src]

  #------------------------------------
  #-- Save database in .db format
  #------------------------------------
  #-- Save the database in Synopsys .DB format
  
  write -format db -hier -out [format "%s%s"  [format "%s%s"  \
    [format "%s%s"  [format "%s%s" [format "%s%s" [format "%s%s" \
    [format "%s%s" \
   db/ $topname] _] $test_req] _] $hdl] _src ] .db] 
  
  #------------------------------------
  #-- Generate gate-level netlist and sdf timing file
  #------------------------------------
  #-- SynopsysVersion = V9802, both best case and worst case timing values
  #-- are written out into the same sdf file.
  
  #Write verilog netlist and sdf
  write -format verilog -hier -out [format "%s%s" $netlist_name_base _net.v]
  write_sdf -version 2.1 [format "%s%s" $netlist_name_base .sdf21]
}

#============================================================================
#-- 11. Generate scan report 
#--     pGeneratePostScanReport run_time_log report_name_base
#============================================================================

proc pGeneratePostScanReport {run_time_log report_name_base} {

  redirect -append $run_time_log { echo [concat] }
  redirect -append $run_time_log { echo [concat check_test] }
  redirect -append $run_time_log { echo [concat ==========] }
  redirect -append $run_time_log { echo [concat] }
  redirect -append $run_time_log { check_test -verbose }
                                         
  #-- Sample of 11% faults targeted estimates fault coverage within 1-2%
  estimate_test_coverage -sample 11      
                                         
  #-- Report test configuration   
  redirect -append [format "%s%s" $report_name_base .scan] \
    { report_test -configuration }       
                                         
  #-- List cells on each scan chain
  redirect -append [format "%s%s" $report_name_base .scan] \
    { report_test -scan_path }           
                                         
  #-- Report test ports      
  redirect -append [format "%s%s" $report_name_base .TestArea ] \
    { report_test -port }                
                                         
  #-- Report scan status of current design
  redirect -append [format "%s%s" $report_name_base .TestState ] \
    { report_test -state }               
                                         
  #-- Write out a default test protocol
  set test_stil_netlist_format {verilog} 
  write_test_protocol -format stil -out "${report_name_base}.default_spf" 


}

#============================================================================
#-- 12. Generate report pGenerateReport topname report_name_base use_clock_gating
#============================================================================

proc pGenerateReport {topname report_name_base use_clock_gating} {

  #------------------------------------
  #-- Generate violation report
  #------------------------------------
  #-- Output a detailed constraints report listing all violations
  #-- in descending order, written to the report area.
  redirect [format "%s%s"  $report_name_base .vio] \
    { report_constraint -verbose -all_violators }
  
  #------------------------------------
  #-- Generate timing reports
  #------------------------------------
  #-- Output a maximum delay timing report for upto 10 paths, written to the
  #-- report area.
  
  redirect [format "%s%s" $report_name_base .max] \
    { report_timing -delay max -path full -nworst 10 }
  
  #-- Output a minimum delay timing report for upto 10 paths, written to the
  #-- report area.
  redirect [format "%s%s" $report_name_base .min] \
    { report_timing -delay min -path full -nworst 10 }
  
  #------------------------------------
  #-- Generate area report
  #------------------------------------
  #-- Create area reports of the current design modules
  
  redirect [format "%s%s" $report_name_base .area] \
    { echo [concat [format "%s%s" { AREA REPORT FOR DESIGN : } \
      [current_design]]] }
  
  foreach_in_collection design_name [find design *] {
    current_design $design_name
    redirect -append [format "%s%s" $report_name_base .area] \
    { echo [concat {    }] }
    redirect -append [format "%s%s" $report_name_base .area] \
    { report_area }
  }
  current_design $topname
  
  #------------------------------------
  #-- Generate constraint report
  #------------------------------------
  #-- 'report_design' displays information about the current design and its
  #-- environment. It lists out the library used, operating conditions,
  #-- wireload models used etc.
  
  redirect [format "%s%s" $report_name_base .constr] { report_design }
  
  #-- 'report_constraint' displays constraint-related information about the
  #-- design
  redirect -append [format "%s%s" $report_name_base .constr] { report_constraint }
  
  #-- 'report_clock' provides a summary of all the defined clocks, their period
  #-- waveform and any attributes set on them.
  redirect -append [format "%s%s" $report_name_base .constr] { report_clock }
  
  #-- 'report_attribute - design' reports attribute related to the design
  redirect -append [format "%s%s" $report_name_base .constr] \
    { report_attribute -design }
  
  #------------------------------------
  #-- Generate port report
  #------------------------------------
  #-- Report information about ports of design
  redirect [format "%s%s" $report_name_base .ports] { report_port -verbose }
  
  #------------------------------------
  #-- Generate latch report
  #------------------------------------
  #-- Check for inferred latches
  
  redirect [format "%s%s" $report_name_base .latch] \
    { echo [concat { CHECK FOR LATCHES }] }
  set dc_shell_status [ all_registers -level_sensitive ]
  redirect -append [format "%s%s" $report_name_base .latch] \
    { printvar dc_shell_status }
  
  #------------------------------------
  #-- Generate combinational loop report
  #------------------------------------
  #-- Check for combinational loops
  
  redirect -append [format "%s%s"  $report_name_base .latch] \
    { echo [concat { CHECK FOR COMBINATIONAL LOOPS }] }
  
  set dc_shell_status [ redirect -append \
    [format "%s%s"  $report_name_base .latch] \
    { report_timing -loops } -preserve_result ]

  #------------------------------------
  #-- Generate clock gating report
  #------------------------------------
  #-- Generate clock gating report if 
  #-- clock gating is enabled

  if {$use_clock_gating == 1 } {
    redirect -append [format "%s%s"  $report_name_base .clk_gating] \
      {report_clock_gating -gating_elements -verbose -gated -hier}
  }
}   

#============================================================================
#-- 13. AnalyseHDL (pAnalyseHDL hdl file_list)
#============================================================================

proc pAnalyseHDL {hdl file_list} {

  #------------------------------------
  #-- Analyze files
  #------------------------------------


  if {$hdl == {vhdl}} {
    #Analyse VHDL files
    foreach filename $file_list {
      analyze -format vhdl [format "%s%s"  [format "%s%s"  [format "%s%s"  \
        [format "%s%s"  ../ $hdl] /rtl_source/] $filename] .vhd] -lib work
    }
  } else {
    if {$hdl == {verilog}} {
      #Analyse Verilog files
      foreach filename $file_list {
        analyze -format verilog [format "%s%s"  [format "%s%s"  [format "%s%s"  \
          [format "%s%s"  ../ $hdl] /rtl_source/] $filename] .v] -lib work
      }  
    }    
  }   
}

#============================================================================
#-- 14. Acquire Power Compiler pAcquirePowerCompiler 
#============================================================================
#-- Note: The initial remove_license is needed even though it looks
#-- redundant. This is to account for cases where the license is 
#-- is automatically checked out.

proc pAcquirePowerCompiler {} {

  #----------------------------
  #-- Acquire Power compiler
  #----------------------------

  redirect -append /dev/null {remove_license Power-Optimization}
  redirect -append /dev/null {set dc_shell_status \
      [ get_license Power-Optimization ]}
  while {  $dc_shell_status == 0 } {
    sh sleep 30
    redirect -append /dev/null {set dc_shell_status \
      [get_license Power-Optimization]}
  }
}

#============================================================================
#-- 15. Release Power Compiler pReleasePowerCompiler 
#============================================================================

proc pReleasePowerCompiler {} {

  #----------------------------
  #-- Release Power compiler
  #---------------------------- 

  redirect -append /dev/null {remove_license Power-Optimization}

}

#--------------------------- End of functions.tcl ---------------------------
