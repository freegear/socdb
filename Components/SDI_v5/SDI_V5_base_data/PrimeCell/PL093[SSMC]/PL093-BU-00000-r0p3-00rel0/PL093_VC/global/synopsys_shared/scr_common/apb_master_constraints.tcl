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
#-- File Name           : apb_master_constraints.tcl.rca
#-- File Revision       : 1.2
#-- 
#-- Release Information : PrimeCell(TM)-GLOBAL-REL1v7
#-- 
#------------------------------------------------------------------------------
#-- Purpose : Synopsys synthesis script to define AMBA APB Master constraints.
#--
#------------------------------------------------------------------------------
#-- Note    : The following values must be set by the callee.
#--           tclk        : (clock period) in ns.
#--           pclk_tpskew : PCLK tpskew
#--
#------------------------------------------------------------------------------
#-- Structure :
#--
#-- 1. Define clock
#-- 2. Define reset
#-- 3. High fanout nets
#-- 4. APB slave constraints
#------------------------------------------------------------------------------

#==============================================================================
#-- 1. Define clock
#==============================================================================
#-- Define PCLK, including clock skew
#-- Clock period (tclk) and clock plus skew (tpskew)
#-- are already set in the .cmd file.
#-------------------------------------------------------------------------------

pCreateClock PCLK $tclk_rise $tclk_fall $tclk $pclk_tpskew

#==============================================================================
#-- 2. Define reset
#==============================================================================
#-- Define PRESETn
#-------------------------------------------------------------------------------

pCreateReset PRESETn PCLK $tidmaxresetn $tidminresetn

#==============================================================================
#-- 3. High fanout nets
#==============================================================================

#==============================================================================
#-- 4. APB Master constraints
#==============================================================================
#-- Input constraints are not set on PRDATA for the current version of
#-- the APBif as it is passed directly through to HRDATA.  These
#-- constraints should be re-enabled if the APBif is modified to add
#-- registers in this path
#------------------------------------------------------------------------------

#------------------------------------
#-- Output constraints
#------------------------------------

if {[llength [find port PWDATA*]] != 0} {
  if {[llength [[filter [find port PWDATA*] {@port_direction == out}]] != 0} {
    set output_port_list [filter [find port PWDATA*] {@port_direction == out}]
    foreach_in_collection output_port_name $output_port_list {
      set_output_delay -clock HCLK -min $tholdmin $output_port_name
      set_output_delay -clock HCLK -max $todmaxpwdata $output_port_name
    }
    unset output_port_list
  }
}

if {[llength [find port PENABLE*]] != 0} {
  if { [llength [[filter [find port PENABLE*] {@port_direction == out}]] != 0} {
    set output_port_list [filter [find port PENABLE*] {@port_direction == out}]
    foreach_in_collection output_port_name $output_port_list {
      set_output_delay -clock HCLK -min $tholdmin $output_port_name
      set_output_delay -clock HCLK -max $todmaxpenable $output_port_name
    }
    unset output_port_list
  }
} 

if {[llength [find port PSEL*]] != 0} {
  if { [llength [[filter [find port PSEL*] {@port_direction == out}]] != 0} {
    set output_port_list [filter [find port PSEL*] {@port_direction == out}]
    foreach_in_collection output_port_name $output_port_list {
      set_output_delay -clock HCLK -min $tholdmin $output_port_name
      set_output_delay -clock HCLK -max $todmaxpsel $output_port_name
    }
    unset output_port_list
  }
} 

if {[llength [find port PADDR*]] != 0} {
  if { [llength [[filter [find port PADDR*] {@port_direction == out}]] != 0} {
    set output_port_list [filter [find port PADDR*] {@port_direction == out}]
    foreach_in_collection output_port_name $output_port_list {
      set_output_delay -clock HCLK -min $tholdmin $output_port_name
      set_output_delay -clock HCLK -max $todmaxpaddr $output_port_name
    }
    unset output_port_list
  }
} 

if {[llength [find port PWRITE*]] != 0} {
  if { [llength [[filter [find port PWRITE*] {@port_direction == out}]] != 0} {
    set output_port_list [filter [find port PWRITE*] {@port_direction == out}]
    foreach_in_collection output_port_name $output_port_list {
      set_output_delay -clock HCLK -min $tholdmin $output_port_name
      set_output_delay -clock HCLK -max $todmaxpwrite $output_port_name
    }
    unset output_port_list
  }
} 
_
#------------------- End of apb_master_constraints.tcl  -----------------------
