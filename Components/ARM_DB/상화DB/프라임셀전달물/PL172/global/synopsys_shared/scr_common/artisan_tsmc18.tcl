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
#-- File Name              : artisan_tsmc18.tcl.rca
#-- File Revision          : 1.3
#--
#-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v7
#--
#------------------------------------------------------------------------------
#-- Purpose : Artisan TSMC .18u synthesis cell library settings.
#--
#------------------------------------------------------------------------------
#-- Information :
#--   If clock gating is required then a specific clock gating cell should
#-- be specified. 
#--   However for test synthesis latches are used for clock gating. 
#--
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
#-- SET LIBRARY PARAMETERS
#------------------------------------------------------------------------------

#-- Set technology library variable --
set MAX_TECH_LIB_NAME slow
set MIN_TECH_LIB_NAME fast
set TYP_TECH_LIB_NAME typical

#-- Set library filename variable --
set MAX_LIB_FILENAME slow.db
set MIN_LIB_FILENAME fast.db
set TYP_LIB_FILENAME typical.db

#-- Set names for library best and worst case condition names --
set BC_NAME fast
set WC_NAME slow

#-- Set library symbols filename variable --
set LIB_SYMBOL_FILE tsmc18.sdb

#-- Set wire-load model libraries change according to the size of --
#-- the design. Wire-load models exist in the main libraries      --     

set MAX_WL_LIB slow.db
set MIN_WL_LIB fast.db
set TYP_WL_LIB typical.db

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
set WL_MOD ForQA
set WL_MOD_MAX ForQA
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
#-- SET OPERATING CONDITIONS
#------------------------------------------------------------------------------

set_operating_conditions -min $BC_NAME -min_library [format "%s%s"  [format "%s%s"  $MIN_LIB_FILENAME :] $MIN_TECH_LIB_NAME] -max $WC_NAME -max_library [format "%s%s"  [format "%s%s"  $MAX_LIB_FILENAME :] $MAX_TECH_LIB_NAME]

#------------------------------------------------------------------------------
#-- Define worst case and best case commercial operating conditions 
#-- Version >=1998.02 allows min and max conditions to be specified 
#-- together                                                        
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
#-- SET DEFAULT CELL LOAD 
#------------------------------------------------------------------------------

set_load [expr [load_of [format "%s%s"  $MAX_TECH_LIB_NAME /SDFFHQX4/D]] * 4] [all_outputs]

#------------------------------------------------------------------------------
#-- SET DEFAULT CELL DRIVE STRENGTH
#------------------------------------------------------------------------------

set_driving_cell -library $MAX_TECH_LIB_NAME -cell SDFFHQX4 -pin Q [all_inputs]

#------------------------------------------------------------------------------
#-- Clock gating
#------------------------------------------------------------------------------
#-- For test synthesis latches are allowed in the design for clock gating.
#-- However for production synthesis all latches should be marked dont_use
#-- and a specific clock gate cell should be defined.

#-- If clock gating is not required do not use latches
if { $use_clock_gating == 0 } {
  set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /TLAT*]
  set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /TTLAT*]
}

#------------------------------------------------------------------------------
#-- Define library cells that should NOT be used
#------------------------------------------------------------------------------

#-- normal DFF dont_use falling clock --
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /DFFN*]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /DLY*]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /JKFF*]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /RSLAT*]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /SDFFN*]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /TBUFIX12]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /TBUFIX16]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /TBUFX12]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /TBUFX16]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /CLKBUFX12]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /CLKBUFX16]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /CLKINVX12]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /CLKINVX16]
set_dont_use [format "%s%s"  $MAX_TECH_LIB_NAME /CLK*]

#------------------------- End of artisan_tsmc18.tcl ---------------------------
