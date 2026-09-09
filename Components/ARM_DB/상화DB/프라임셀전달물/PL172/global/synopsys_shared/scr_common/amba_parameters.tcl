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
#-- File Name           : amba_parameters.tcl.rca
#-- File Revision       : 1.2
#-- 
#-- Release Information : PrimeCell(TM)-GLOBAL-REL1v7
#-- 
#------------------------------------------------------------------------------
#-- Purpose : Synopsys synthesis script for AMBA timing parameters.
#--
#------------------------------------------------------------------------------
#-- Note    : The following values must be set before this script is called.
#--           tclk (clock period) must be set in the library file  
#--                
#-------------------------------------------------------------------------------
#-- Information : 
#--
#-- This file contains a generic set of parameters for synthesis of        
#-- AHB/APB modules.                                                      
#--                                                                       
#-- A number of timing parameters are defined for each AMBA module and    
#-- these use the following nomenclature:                                 
#--                                                                       
#--  Tis - Input setup time                                               
#--  Tih - Input hold time                                                
#--  Tov - Output valid time                                              
#--  Toh - Output hold time                                               
#--                                                                       
#-- For the purpose of synthesis the following nomenclature is used:        
#--                                                                     
#--  Tidmax - Input delay maximum                                       
#--  Tidmin - Input delay minimum                                       
#--  Todmax - Output delay maximum                                      
#--  Todmin - Output delay minimum                                     
#--                                                                    
#-- Where conversion between the target module parameters and the synthesis  
#-- constraints is done using the following equations:                 
#--                                                                    
#--  Tidmax = tclk * (1 - Tis)                                         
#--  Tidmin = Tih                                                    
#--  Todmax = tclk * (1 - Tov)                                       
#--  Todmin = Toh                                                   
#--
#-------------------------------------------------------------------------------
#-- 
#--  The system timing budget is split as follows:
#-- 
#--  Point to point signals:
#--   40% output valid   Todmax = 0.6
#--   30% input setup    Tidmax = 0.5
#--   30% spare slack               
#--                                 
#--  Multiplexed signals:            
#--   40% output valid   Todmax = 0.6
#--   20% multiplexer                
#--   30% input setup    Tidmax = 0.7
#--   10% spare slack                
#--                                          
#--  The timing parameters are only defined as Tidmax and Todmax, taking
#--  into account the multiplexer delays and 10% slack.
#-- 
#--  Two signals paths do not use the default timings:
#--   - HADDR to HSEL   
#--   - PRDATA to HRDATA.
#-- 
#--  As HSEL is generated from HADDR, which passes through the M2S
#--  multiplexer and the Decoder, it would be valid relatively late in the
#--  cycle. So to simplify the system timing, the default slack of 10% on
#--  all signals is used for the Decoder to slave path, so tidmaxhsel is
#--  valid after 70% of the cycle, the same as all other AHB inputs.
#--  Similarly for the PRDATA to HRDATA path, the 10% signal slack is used
#--  by MuxP2B
#-- 
#--  If extra time is required, the 10% slack included on the address timing
#--  may also be removed.
#-- 
#--  The path from PRDATA on the APB to HRDATA on the AHB is long, including:
#--   - output delay of APB slave         
#--   - multiplexer delay of MuxP2B       
#--   - bridge delay from PRDATA to HRDATA
#--   - multiplexer delay of MuxS2M       
#--   - slack on both multiplexer paths.  
#--  To reduce the input timing on HRDATA, the default slack of 10% on the two
#--  multiplexer paths is removed, and the delay through the APB bridge
#--  set to 0 (since it is not required - PRDATA can be connected
#--  directly to MuxM2S instead) therefore allowing:
#--   - 40% APB slave output delay
#--   - 10% MuxP2B delay         
#--   - 10%  bridge delay        
#--   - 20% MuxS2M delay       
#--  giving a total HRDATA input delay of 80%.
#--
#-------------------------------------------------------------------------------
#--
#-- AHB and APB Slave devices
#--
#-- Using the above values means that AHB Slave devices can use 30% input setup
#-- and 40% output delay.
#-- 
#--     _________           _________           ____
#--  __|         |_________|         |_________|     HCLK/PCLK
#--    |              _____|                   |
#--  XXXXXXXXXXXXXXXXX_____XXXXXXXXXXXXXXXXXXXXXXXXX AHB/APB slave inputs -
#--                                                  30% setup, 0% hold
#--
#--    |-------------|-----|                   |     tidmax = 30% = clk * 0.7
#--       70%           30%|                   |
#--                        |                   |
#--                        |                   |
#--                        |       ____________|
#--  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX____________XXXXX AHB/APB slave outputs -
#--                                                  40% setup, 0% hold
#--
#--                        |-------|-----------|     todmax = 40% = clk * 0.6
#--                         40%      60% 
#--
#-------------------------------------------------------------------------------
#-- Structure :
#--
#-- 1. Hold time
#-- 2. AHB Parameters
#-- 3. APB Parameters
#-- 4. Reset Parameters
#--
#------------------------------------------------------------------------------

#==============================================================================
#-- 1. Hold time
#==============================================================================
#--
#-- Max and Min hold times applied to the input and output ports respectively 
#-- These values should be changed if a default hold delay is required. 
#-------------------------------------------------------------------------------

set tholdmax [expr 0.00 * $tclk]
set tholdmin [expr -0.00 * $tclk]

#==============================================================================
#-- 2. AHB PARAMETERS                                                             
#==============================================================================
#--
#-- This section defines the timing parameters for all AHB signals.           
#-------------------------------------------------------------------------------

#------------------------------------
#-- AHB Slave 
#------------------------------------
#-- 30% input, 40% output
#------------------------------------

#------------------------------------
#-- Inputs 
#------------------------------------

#-- From AHB Master
set tidmaxhaddr  [expr $tclk * 0.7]
set tidmaxhtrans [expr $tclk * 0.7]
set tidmaxhwrite [expr $tclk * 0.7]
set tidmaxhsize  [expr $tclk * 0.7]
set tidmaxhburst [expr $tclk * 0.7]
set tidmaxhprot  [expr $tclk * 0.7]
set tidmaxhwdata [expr $tclk * 0.7]

#-- From AHB Decoder 
set tidmaxhsel [expr $tclk * 0.7]

#-- From Arbiter (point-to-point) 
set tidmaxhmastlock [expr $tclk * 0.7]

#------------------------------------
#-- Outputs 
#------------------------------------

#-- To Master
set todmaxhrdata [expr $tclk * 0.6]
set todmaxhready [expr $tclk * 0.6]
set todmaxhresp  [expr $tclk * 0.6]
set todmaxhsplit [expr $tclk * 0.6]

#------------------------
#-- AHB Master
#------------------------
#-- 30% input, 40% output
#------------------------

#------------------------------------
#-- Inputs 
#------------------------------------

#-- From Slave
set tidmaxhrdata [expr $tclk * 0.7]
set tidmaxhready [expr $tclk * 0.7]
set tidmaxhresp  [expr $tclk * 0.7]

#-- From Arbiter (point-to-point) 
set tidmaxhgrant  [expr $tclk * 0.7]
set tidmaxhmaster [expr $tclk * 0.7]

#------------------------------------
#-- Outputs 
#------------------------------------

#-- To Slave 
set todmaxhaddr  [expr $tclk * 0.6]
set todmaxhtrans [expr $tclk * 0.6]
set todmaxhwrite [expr $tclk * 0.6]
set todmaxhsize  [expr $tclk * 0.6]
set todmaxhburst [expr $tclk * 0.6]
set todmaxhprot  [expr $tclk * 0.6]
set todmaxhwdata [expr $tclk * 0.6]

#-- To Arbiter 
set todmaxhbusreq [expr $tclk * 0.6]
set todmaxhlock   [expr $tclk * 0.6]

#------------------------
#-- AHB Decoder
#------------------------

#------------------------
#-- Inputs 
#------------------------

#-- From Master
#------------------------
#--  The HADDR path from the Master to the 
#-- Decoder does not include the usual 15% slack 
#------------------------

#------------------------
#-- Outputs 
#------------------------

#-- To Slave
set todmaxhsel [expr $tclk * 0.3]

#------------------------
#-- AHB Arbiter
#------------------------
#-- 30% input, 40% output
#------------------------

#------------------------
#-- Inputs 
#------------------------

#-- From Master (point-to-point) 
set tidmaxhbusreq [expr $tclk * 0.7]
set tidmaxhlock   [expr $tclk * 0.7]

#-- From Slave 
set tidmaxhsplit [expr $tclk * 0.7]

#------------------------
#-- Outputs 
#------------------------

#-- To Master
set todmaxhgrant  [expr $tclk * 0.6]
set todmaxhmaster [expr $tclk * 0.6]

#-- To Slave
set todmaxhmastlock [expr $tclk * 0.6]


#------------------------
#-- Multiplexer Parameters
#------------------------
#-- As the three system multiplexers have fully combinatorial paths
#-- from the inputs to the outputs, the specific signal timing is not
#-- required.
#-- A default input delay of 20% and a default output delay of 60% are
#-- used for all multiplexer signals, allowing 20% for the multiplexer
#-- io path.
#------------------------

#-- AHB muxes
set tidmaxmux [expr $tclk * 0.2]
set todmaxmux [expr $tclk * 0.6]


#==============================================================================
#-- 3. APB Parameters
#==============================================================================
#-- This section defines the timing parameters for all APB signals.
#-- All APB output timing assumes registered outputs, so the default values
#-- must be changed if combinational APB outputs are used.
#-- Only PRDATA passes through the central P2B multiplexers. Due to
#-- the long path from PRDATA to HRDATA, the APB central multiplexer
#-- delay value is set at 10% instead of the standard 20% for a    
#-- multiplexer, so effectively becomes valid at the same time as the
#-- other APB signals, which include a 10% slack value.
#-------------------------------------------------------------------------------

#------------------------
#-- APB Slave
#------------------------
#-- 30% input, 40% output
#------------------------

#------------------------
#-- Inputs 
#------------------------

#-- From APB Bridge
set tidmaxpenable [expr $tclk * 0.7]
set tidmaxpsel    [expr $tclk * 0.7]
set tidmaxpaddr   [expr $tclk * 0.7]
set tidmaxpwrite  [expr $tclk * 0.7]
set tidmaxpwdata  [expr $tclk * 0.7]

#------------------------
#--  Outputs 
#------------------------

#-- To APB Bridge
set todmaxprdata [expr $tclk * 0.6]

#------------------------
#-- APB Bridge
#------------------------
#-- 30% input, 40% output
#------------------------

#------------------------
#-- Inputs 
#------------------------

#-- From APB Slave
set tidmaxprdata [expr $tclk * 0.7]

#------------------------
#-- Outputs 
#------------------------

#-- To APB Slave
set todmaxpenable [expr $tclk * 0.6]
set todmaxpsel    [expr $tclk * 0.6]
set todmaxpaddr   [expr $tclk * 0.6]
set todmaxpwrite  [expr $tclk * 0.6]
set todmaxpwdata  [expr $tclk * 0.6]

#==============================================================================
#-- 4. Reset parameters
#==============================================================================
#-- These should be confirmed against the reset controller specification                                                   
set tidminresetn [expr $tclk * 0.05] 
#-- Defined output hold time of reset signal
set tidmaxresetn [expr $tclk * 0.5]  

#-- Registered de-assertion of reset
set todmaxresetn [expr $tclk * 0.6]

#----------------------- End of amba_parameters.tcl ---------------------------
