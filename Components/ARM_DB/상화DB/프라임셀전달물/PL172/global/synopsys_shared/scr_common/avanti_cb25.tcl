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
#-- Version and Release Control Information:
#--
#-- File Name              : avanti_cb25.tcl.rca
#-- File Revision          : 1.3
#--
#-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v7
#--
#------------------------------------------------------------------------------
#-- Purpose : Avanti! Passport cb25 synthesis cell library settings.
#--
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
#-- Timing Units 
#------------------------------------------------------------------------------
#-- If Library file uses nanoseconds as timing unit then keep the variable ns 
#-- set to 1.0, if however the library file uses a different timing base such 
#-- as picoseconds then the variable has to be changed accordingly so the 
#-- timing calculations remain true, ie if library used picoseconds the 
#-- variable would need to be changed to 1000 so timing calculations remain 
#-- constant (ie equivalent value in nanoseconds)
#------------------------------------------------------------------------------
set ns 1.0

#------------------------------------------------------------------------------
#-- This script is based on use of the Avanti! Passport cb25 cell library v2.1
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
#-- Set library parameters
#------------------------------------------------------------------------------

#-- Set technology library variable --
set MAX_TECH_LIB_NAME cb25os163_max
set MIN_TECH_LIB_NAME cb25os163_min
set TYP_TECH_LIB_NAME cb25os163_typ

#-- Set library filename variable --
set MAX_LIB_FILENAME cb25os163_max.db
set MIN_LIB_FILENAME cb25os163_min.db
set TYP_LIB_FILENAME cb25os163_typ.db

#-- Set names for library best and worst case condition names --
set BC_NAME BCCOM
set WC_NAME WCCOM

#-- Set library symbols filename variable --
set LIB_SYMBOL_FILE cb25os163.sdb

#-- Set wire-load model libraries change according to the size of --
#-- the design. Wire-load models exist in the main libraries      --     

set MAX_WL_LIB cb25os163_max.db
set MIN_WL_LIB cb25os163_min.db
set TYP_WL_LIB cb25os163_typ.db

#------------------------------------------------------------------------------
#-- Library paths and library specific setup
#------------------------------------------------------------------------------

set target_library [list $MAX_LIB_FILENAME]
#-- target set to technology library which DC maps to when producing netlists 

set link_library [list * $MAX_LIB_FILENAME]
#-- link library allows for netlist translation into a different library --

set_min_library $MAX_LIB_FILENAME -min_version $MIN_LIB_FILENAME
#-- Multiple libraries, define min version of the library --

set symbol_library [list $LIB_SYMBOL_FILE]
#-- symbol library contains graphic definitions of cells used for schematics   

#------------------------------------------------------------------------------

#-- Wire load model variables from cell library --
set WL_MOD 16000
set WL_MOD_MAX 16000
set WL_MOD_MIN ForQA

#-- To disable automatic wire load selection, set the following command false  
set auto_wire_load_selection true

set_wire_load_mode enclosed
#-- wire load model enclosed is less pessimistic than top --

set_wire_load_model -library $MAX_TECH_LIB_NAME -name $WL_MOD_MAX -max
#-- Set the wire load model to be used for maximum delay analysis --

set_wire_load_model -library $MAX_TECH_LIB_NAME -name $WL_MOD_MIN -min
#-- Set the wire load model to be used for minimum delay analysis --

#------------------------------------------------------------------------------
#-- Set operating conditions
#------------------------------------------------------------------------------

set_operating_conditions -min $BC_NAME -min_library [format "%s%s"  [format "%s%s"  $MIN_LIB_FILENAME :] $MIN_TECH_LIB_NAME] -max $WC_NAME -max_library [format "%s%s"  [format "%s%s"  $MAX_LIB_FILENAME :] $MAX_TECH_LIB_NAME]

#------------------------------------------------------------------------------
#-- Define worst case and best case commercial operating conditions 
#-- Version >=1998.02 allows min and max conditions to be specified 
#-- together                                                        
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
#-- Set default cell load
#------------------------------------------------------------------------------

set_load [expr [load_of [format "%s%s"  $MAX_TECH_LIB_NAME /inv0d0/I]] * 5] [all_outputs]

#------------------------------------------------------------------------------
#-- Set default cell drive strength
#------------------------------------------------------------------------------

set_driving_cell -library $MAX_TECH_LIB_NAME -cell dfnrb1 -pin Q [all_inputs]

#------------------------------------------------------------------------------
#-- Define library cells that should NOT be used
#------------------------------------------------------------------------------

#-- normal DFF dont_use falling clock --
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /dfbfb1]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /dfbfb2]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /dfcfb1]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /dfcfb2]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /dfcfq1]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /dfcfq2]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /dfnfb1]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /dfnfb2]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /dfpfb1]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /dfpfb2]

#-- enable DFF dont_use falling clock --
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /decfq1]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /decfq2]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /depfq1]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /depfq2]

#-- JKFF dont_use --
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /jkbrb1]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /jkbrb2]

#-- Scan normal DFF dont_use QN output only - problems with hold time --
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /sdnrn1]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /sdnrn2]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /sdcrn1]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /sdcrn2]

#-- Latches dont_use --
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /labhb1]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /labhb2]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /lachq1]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /lachq2]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /laclq1]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /laclq2]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /lanhb1]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /lanhb2]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /lanhn1]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /lanhn2]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /lanhq1]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /lanhq2]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /lanht1]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /lanht2]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /lanlb1]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /lanlb2]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /lanln1]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /lanln2]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /lanlq1]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /lanlq2]

#-- SR latch dont_use --
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /srlab1]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /srlab2]

#-- Scan normal DFF QN output only dont use problems with hold time --
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /sdnrn1]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /sdnrn2]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /sdcrn1]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /sdcrn2]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /sdcrq1]

#------------------------------------------------------------------------------
#-- Define library cells that should NOT be used when not inserting scan
#------------------------------------------------------------------------------

if {  $test_req == {noscan} } {
   set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /sdbrb1]
  set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /sdbrb2]
  set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /sdcfq1]
  set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /sdcfq2]
  set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /sdcrb1]
  set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /sdcrb2]
  set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /sdcrn1]
  set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /sdcrn2]
  set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /sdcrq1]
  set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /sdcrq2]
  set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /sdnrb1]
  set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /sdnrb2]
  set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /sdnrn1]
  set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /sdnrn2]
  set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /sdnrq1]
  set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /sdnrq2]
  set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /sdprb1]
  set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /sdprb2]
  set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /secrq1]
  set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /secrq2]
  set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /senrq1]
  set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /senrq2]
  set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /seprq1]
  set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /seprq2]
}

#--------------------------- End of avanti_cb25.tcl ----------------------------
