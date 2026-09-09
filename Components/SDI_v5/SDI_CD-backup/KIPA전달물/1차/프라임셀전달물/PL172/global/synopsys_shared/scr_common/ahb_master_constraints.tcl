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
#-------------------------------------------------------------------------------
#--  
#-- Version and Release Control Information:
#-- 
#-- File Name           : ahb_master_constraints.tcl.rca
#-- File Revision       : 1.2
#-- 
#-- Release Information : PrimeCell(TM)-GLOBAL-REL1v7
#-- 
#-------------------------------------------------------------------------------
#-- Purpose : Synopsys synthesis script to define AMBA AHB Master
#--           timing constraints.
#-- 
#-------------------------------------------------------------------------------
#-- Note    : The following values must be set by the callee.
#--           tclk: Clock period in ns. This should be set in the main script.
#--
#-------------------------------------------------------------------------------
#-- Information : 
#--
#-- It is possible for a peripheral to have an AHB Master port as well         
#-- as an AHB slave port. In such cases, the same base name could              
#-- lead to two different port names - one of which could be an input          
#-- connecting to the AHB Slave interface, while the other could be an         
#-- output from the AHB Master interface. For example, HADDR[31:0] is         
#-- an input to the AHB Slave interface, whereas HADDRM[31:0] is an            
#-- output from the AHB Master interface. Since the base name of HADDR         
#-- is known, to set constraints on the Master interface port, the             
#-- port_direction attribute is checked.                                       
#-------------------------------------------------------------------------------
#-- Structure : 
#-- 
#-- 1. Define HCLK
#-- 2. Define HRESETn
#-- 3. High fanout nets
#-- 4. AHB master constraints
#-------------------------------------------------------------------------------

#===============================================================================
#-- 1. Define HCLK
#===============================================================================
#-- Define HCLK, including clock skew
#-- Clock period (tclk) and clock plus skew (tpskew)
#-- are already set in the .cmd file.
#-------------------------------------------------------------------------------

pCreateClock HCLK $tclk_rise $tclk_fall $tclk $hclk_tpskew

#===============================================================================
#-- 2. Define HRESETn
#===============================================================================
#-- Define HRESETn
#------------------------------------------------------------------------------

pCreateReset HRESETn HCLK $tidmaxresetn $tidminresetn

#===============================================================================
#-- 3. High fanout nets
#===============================================================================
#-- The peripheral should present only a single load to the AHB.
#-- For peripherals that have an AHB Slave interface as well as a AHB
#-- Master interface, the command below would include the HREADYIN port 
#-- on the AHB Slave interface. This would override any constraints 
#-- previously set on this port in the ahb_slave_scr.tcl script. This is 
#-- not a problem since it is the same constraint that is being re-applied.
#-------------------------------------------------------------------------------
set_max_fanout 1.0 [find port HREADYIN*]

#===============================================================================
#-- 4. AHB master constraints
#===============================================================================
#-- AHB Slave port names could clash with those of an AHB Master block
#-- in the same module. Hence, the port_direction attribute is used
#-- to filter out Slave ports from Master ports.
#-------------------------------------------------------------------------------

#------------------------------------
#-- Input constraints
#------------------------------------

if {[llength [find port HREADY*]] != 0} {
  if {[llength [filter [find port HREADY*] {@port_direction == in} ]] != 0} {
    set input_port_list [filter [find port HREADY*] {@port_direction == in}]
    foreach_in_collection input_port_name $input_port_list {
      set_input_delay -clock HCLK -min $tholdmax $input_port_name
      set_input_delay -clock HCLK -max $tidmaxhready $input_port_name
    }
    unset input_port_list
  }
}

if {[llength [find port HRESP*]] != 0} {
  if {[llength [filter [find port HRESP*] {@port_direction == in} ]] != 0} { 
    set input_port_list [filter [find port HRESP*] {@port_direction == in}]
    foreach_in_collection input_port_name $input_port_list {
      set_input_delay -clock HCLK -min $tholdmax $input_port_name
      set_input_delay -clock HCLK -max $tidmaxhresp $input_port_name
    }
    unset input_port_list
  }
} 

if {[llength [find port HRDATA*]] != 0} {
  if {[llength [filter [find port HRDATA*] {@port_direction == in} ]] != 0} {
    set input_port_list [filter [find port HRDATA*] {@port_direction == in}]
    foreach_in_collection input_port_name $input_port_list {
      set_input_delay -clock HCLK -min $tholdmax $input_port_name
      set_input_delay -clock HCLK -max $tidmaxhrdata $input_port_name
    }
    unset input_port_list
  }
} 

if {[llength [find port HGRANT*]] != 0} {
  if {[llength [filter [find port HGRANT*] {@port_direction == in} ]] != 0} {
    set input_port_list [filter [find port HGRANT*] {@port_direction == in}]
    foreach_in_collection input_port_name $input_port_list {
      set_input_delay -clock HCLK -min $tholdmax $input_port_name
      set_input_delay -clock HCLK -max $tidmaxhgrant $input_port_name
    }
    unset input_port_list
  }
} 

#------------------------------------
#-- Output constraints
#------------------------------------

if {[llength [find port HBUSREQ*]] != 0} {
  if {[llength [filter [find port HBUSREQ*] {@port_direction == out} ]] != 0} {
    set output_port_list [filter [find port HBUSREQ*] {@port_direction == out}]
    foreach_in_collection output_port_name $output_port_list {
      set_output_delay -clock HCLK -min $tholdmin $output_port_name
      set_output_delay -clock HCLK -max $todmaxhbusreq $output_port_name
    }
    unset output_port_list
  }
}

if {[llength [find port HLOCK*]] != 0} {
  if {[llength [filter [find port HLOCK*] {@port_direction == out} ]] != 0} {
    set output_port_list [filter [find port HLOCK*] {@port_direction == out}]
    foreach_in_collection output_port_name $output_port_list {
      set_output_delay -clock HCLK -min $tholdmin $output_port_name
      set_output_delay -clock HCLK -max $todmaxhlock $output_port_name
    }
    unset output_port_list
  }
}

if {[llength [find port HPROT*]] != 0} {
  if {[llength [filter [find port HPROT*] {@port_direction == out} ]] != 0} {
    set output_port_list [filter [find port HPROT*] {@port_direction == out}]
    foreach_in_collection output_port_name $output_port_list {
      set_output_delay -clock HCLK -min $tholdmin $output_port_name
      set_output_delay -clock HCLK -max $todmaxhprot $output_port_name
    }
    unset output_port_list
  }
}

if {[llength [find port HBURST*]] != 0} {
  if {[llength [filter [find port HBURST*] {@port_direction == out} ]] != 0} {
    set output_port_list [filter [find port HBURST*] {@port_direction == out}]
    foreach_in_collection output_port_name $output_port_list {
      set_output_delay -clock HCLK -min $tholdmin $output_port_name
      set_output_delay -clock HCLK -max $todmaxhburst $output_port_name
    }
    unset output_port_list
  }
}

if {[llength [find port HTRANS*]] != 0} {
  if {[llength [filter [find port HTRANS*] {@port_direction == out} ]] != 0} {
    set output_port_list [filter [find port HTRANS*] {@port_direction == out}]
    foreach_in_collection output_port_name $output_port_list {
      set_output_delay -clock HCLK -min $tholdmin $output_port_name
      set_output_delay -clock HCLK -max $todmaxhtrans $output_port_name
    }
    unset output_port_list
  }
}

if {[llength [find port HADDR*]] != 0} {
  if {[llength [filter [find port HADDR*] {@port_direction == out} ]] != 0} {
    set output_port_list [filter [find port HADDR*] {@port_direction == out}]
    foreach_in_collection output_port_name $output_port_list {
      set_output_delay -clock HCLK -min $tholdmin $output_port_name
      set_output_delay -clock HCLK -max $todmaxhaddr $output_port_name
    }
    unset output_port_list
  }
}

if {[llength [find port HSIZE*]] != 0} {
  if { [llength [filter [find port HSIZE*] {@port_direction == out} ]] != 0} {
    set output_port_list [filter [find port HSIZE*] {@port_direction == out}]
    foreach_in_collection output_port_name $output_port_list {
      set_output_delay -clock HCLK -min $tholdmin $output_port_name
      set_output_delay -clock HCLK -max $todmaxhsize $output_port_name
    }
    unset output_port_list
  }
}

if {[llength [find port HWRITE*]] != 0} {
  if { [llength [filter [find port HWRITE*] {@port_direction == out} ]] != 0} {
    set output_port_list [filter [find port HWRITE*] {@port_direction == out}]
    foreach_in_collection output_port_name $output_port_list {
      set_output_delay -clock HCLK -min $tholdmin $output_port_name
      set_output_delay -clock HCLK -max $todmaxhwrite $output_port_name
    }
    unset output_port_list
  }
}

if {[llength [find port HWDATA*]] != 0} {
  if { [llength [filter [find port HWDATA*] {@port_direction == out} ]] != 0} {
    set output_port_list [filter [find port HWDATA*] {@port_direction == out}]
    foreach_in_collection output_port_name $output_port_list {
      set_output_delay -clock HCLK -min $tholdmin $output_port_name
      set_output_delay -clock HCLK -max $todmaxhwdata $output_port_name
    }
    unset output_port_list
  }
}

#------------------------- End ahb_master_constraints.tcl ----------------------
