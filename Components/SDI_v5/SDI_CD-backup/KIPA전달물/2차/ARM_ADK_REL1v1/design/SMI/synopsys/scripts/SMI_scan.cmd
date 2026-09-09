/*------------------------------------------------------------------------------
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
-- 
-- Version and Release Control Information:
-- 
-- File Name           : SMI_scan.cmd,v
-- File Revision       : 1.4
-- 
-- Release Information : ADK_REL1v1
-- 
--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
-- Purpose : Synopsys scan-insertion synthesis master compile script            
--
--           Located in the synopsys directory.        
--
--           This file specifies the order in which commands   
--           are executed and it is written to use shell mode.   
--
------------------------------------------------------------------------------*/

/******************************************************************************/
/* DEFINE THE SCAN CONFIGURATION                                              */
/******************************************************************************/

test_default_scan_style = multiplexed_flip_flop

set_scan_configuration -style multiplexed_flip_flop
/* Multiplexed Flip Flop is used as the scan cell */

set_scan_configuration -methodology full_scan
/* Full Scan Methodology */

/*  set_scan_configuration -clock_mixing no_mix */
/* Indiviual scan chains for each clock domain */

set_scan_configuration -clock_mixing mix_clocks_not_edges
/* Single scan chain for all clock domains */

set_scan_configuration -replace true
/* Replace all flip flops with their equivalent scan cells */

set_scan_configuration -add_lockup false
/* No lockup latches required when no clock mixing in scan chain */

set_scan_configuration -dedicated_scan_ports true
/* Every scan chain has a dedicated output port for the scan out signals */

set_scan_configuration -existing_scan false
/* There is no existing scan logic. */

set_scan_configuration -route true
/* All scan related signals (scan in , scan out, scan enable */
/* and scan clocks ) to be routed. */

/* Scan chain with dedicated scanout ports. */
set_scan_path ChainHCLK all_registers (-clock HCLK) \
  -dedicated_scan_out true

/* Assign scan signals to existing scan test ports */
set_scan_signal test_scan_enable -port SCANENABLE
set_scan_signal test_scan_in     -port SCANINHCLK    -chain ChainHCLK
set_scan_signal test_scan_out    -port SCANOUTHCLK   -chain ChainHCLK

/******************************************************************************/
/* INSERT THE SCAN CHAINS                                                     */
/******************************************************************************/

insert_scan -map_effort medium
/* Connect scan cells and optimise scan structure */

echo >> run_time_log
echo "check_test" >> run_time_log
echo "==========" >> run_time_log 
echo >> run_time_log
check_test -verbose >> run_time_log
/* Check the test insertion has completed */ 

/******************************************************************************/
/* GENERATE SCAN REPORTS                                                      */
/******************************************************************************/

create_test_patterns -dft -sample 11 
/* Sample of 11% faults targeted estimates fault coverage within 1-2% */

report_test -coverage >> report_name_base + ".scan"
/* Report test coverage */

report_test -configuration >> report_name_base + ".scan"
/* Report test configuration */

report_test -scan_path >> report_name_base + ".scan"
/* List cells on each scan chain */

/************************************* End ************************************/

