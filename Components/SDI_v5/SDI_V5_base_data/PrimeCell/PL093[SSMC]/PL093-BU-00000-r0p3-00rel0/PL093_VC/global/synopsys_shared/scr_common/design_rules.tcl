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
#-- File Name           : design_rules.tcl.rca
#-- File Revision       : 1.2
#-- 
#-- Release Information : PrimeCell(TM)-GLOBAL-REL1v7
#-- 
#------------------------------------------------------------------------------
#-- Purpose : Synopsys synthesis design rules script.
#--
#------------------------------------------------------------------------------
#-- Information :
#--   This file applies synthesis design rules.
#--
#------------------------------------------------------------------------------
#--   Order commands are executed:
#--
#-- 1. Set maximum transition
#-- 2. Set maximum area
#-- 3. Multibit registers
#------------------------------------------------------------------------------

#==============================================================================
#-- 1. Set maximum transition 
#==============================================================================
#-- set maximum transition for all nets in design --

#-----------------------------------
#-- Max transition time varible
#-----------------------------------
set ns 1.0

set max_trans_time [expr 2 * $ns]

set_max_transition $max_trans_time $topname

#==============================================================================
#-- 2. Set maximum area
#==============================================================================
#-- Set maximum area to zero so that design is optimised for minimum area

set_max_area 0.0

#==============================================================================
#-- 3. Multibit registers
#==============================================================================

#-- This variable controls multibit inference for bused registers 
#-- Updated  for 2000.11
set hdlin_infer_multibit default_all
 
#-- width=2 is default, multibit components >= width will be optimised
set_multibit_options -minimum_width 2

#-- Prevent feedthroughs, multiple output ports from same net 
#-- or constants driving more than one output port            
set_fix_multiple_port_nets -all -buffer_constants

#--------------------------- End of design_rules_scr.tcl ----------------------
