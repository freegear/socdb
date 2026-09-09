/* --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000-2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : Smc_scan.cmd.rca
-- File Revision          : 1.16
--
-- Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose : 
--           Synopsys scan-insertion synthesis master compile script 
--           for the SMC block.                                  
--
--           Located in the synopsys/scripts directory.        
--
--           This file defines the scan configuration parameters 
--           and performs the scan insertion. 
--
-- --======================================================================-- */
 
/* Flatten DesignWare hierarchy as per Solvit note    */
/* Synthesis-173.html, to avoid SDF/netlist problems. */
foreach(design_name,find(design,"*")) {
  current_design = design_name
  dw_cell_list = filter(find(cell,"*"),"@is_synlib_operator==true || \
    @is_dw_subblock==true || @is_synlib_module==true ") > /dev/null
  if (dc_shell_status != {}) {
    echo "Info: Found some DW hierarchy in " + design_name + ". \
      Ungrouping.."
    ungroup -flatten dw_cell_list -simple
  }
}
remove_variable dw_cell_list

current_design = topname

/* The ungrouping of DesignWare components would have deleted or */
/* created nets; as a result the zero resistance setting would   */
/* have been lost and has to be restored.                        */
set_resistance 0 HRESETn

test_default_scan_style = multiplexed_flip_flop

set_scan_configuration -style multiplexed_flip_flop
/* Multiplexed Flip Flop is used as the scan cell */

set_scan_configuration -methodology full_scan
/* Full Scan Methodology */

set_scan_configuration -clock_mixing no_mix
/* Individual scan chains for each clock domain */

set_scan_configuration -replace true
/* Replace all flip flops with their equivalent scan cells */

set_scan_configuration -add_lockup false
/* No lockup latches required when no clock mixing in scan chain */

set_scan_configuration -dedicated_scan_ports true
/* Every scan chain has a dedicated output port for the scan out */
/* signals                                                       */

set_scan_configuration -existing_scan false
/* There is no existing scan logic. */

set_scan_configuration -route true
/* All scan related signals (scan in , scan out, scan enable */
/* and scan clocks) to be routed.                            */

/* Scan chain with dedicated scanout ports for HCLK and nHCLK */
set_scan_path ChainHCLK all_registers (-clock HCLK) \
  -dedicated_scan_out true

set_scan_path ChainnHCLK all_registers (-clock nHCLK) \
  -dedicated_scan_out true

/* Assign scan signals to existing scan test ports */
set_scan_signal test_scan_enable -port SCANENABLE

set_scan_signal test_scan_in     -port SCANINHCLK  \
  -chain ChainHCLK
set_scan_signal test_scan_out    -port SCANOUTHCLK \
  -chain ChainHCLK

set_scan_signal test_scan_in     -port SCANINnHCLK  \
  -chain ChainnHCLK
set_scan_signal test_scan_out    -port SCANOUTnHCLK \
  -chain ChainnHCLK

set_drive 0 SCANENABLE
/* Infinite drive strength Scan Enable signal */

set_false_path -from SCANENABLE

remove_driving_cell find(port, SCANENABLE)

/*
remove_attribute find(port, SCANENABLE) max_transition
remove_attribute find(port, SCANENABLE) max_fanout
*/
/* This will make sure that no buffers are added */

echo                                      >> run_time_log
echo "check_test before scan insertion"   >> run_time_log
echo "================================"   >> run_time_log
echo                                      >> run_time_log
check_test -verbose                       >> run_time_log
/* Create test insertion report (test rule check) */ 

/* Generate preview scan report */
preview_scan -script > report_name_base + ".preview_scr"

preview_scan -show all > report_name_base + ".preview_all"

/******************************************************************************/
/* INSERT THE SCAN CHAINS                                                     */
/******************************************************************************/
 
insert_scan -map_effort medium
/* Connect scan cells and optimise scan structure */
 
echo                                     >> run_time_log
echo "check_test after scan insertion"   >> run_time_log
echo "==============================="   >> run_time_log
echo                                     >> run_time_log
check_test -verbose                      >> run_time_log
/* Create test insertion report (test rule check) */ 


/* Resistance constraints set on nets could have been lost following the      */
/* insert_scan. Restore them before generating the final netlist and SDF file.*/

all_connected SCANENABLE
net_name_list = dc_shell_status
foreach (net_name, net_name_list) {
  set_resistance 0 net_name
}

/*
all_connected SCANINHCLK
net_name_list = dc_shell_status
foreach (net_name, net_name_list) {
  set_resistance 0 net_name
}

all_connected SCANINnHCLK
net_name_list = dc_shell_status
foreach (net_name, net_name_list) {
  set_resistance 0 net_name
}
*/

echo                                     >> run_time_log
echo "check_design after scan insertion" >> run_time_log
echo "=================================" >> run_time_log
echo                                     >> run_time_log
check_design                             >> run_time_log
/* Check that files have been read correctly and that various nodes are       */
/* connected.                                                                 */

/******************************************************************************/
/* GENERATE SCAN REPORTS                                                      */
/******************************************************************************/
 
create_test_patterns -dft -sample 11
/* Sample of 11% faults targeted estimates fault coverage within 1-2% */
 
report_test -coverage > report_name_base + ".scan"
/* Report test coverage */
 
report_test -configuration >> report_name_base + ".scan"
/* Report test configuration */
 
report_test -scan_path >> report_name_base + ".scan"
/* List cells on each scan chain */

report_test -port > report_name_base + ".test_area"
/* Report test ports */

report_test -atpg_conflicts > report_name_base + ".test_atpgconf"
/* Report ATPG conflicts */

report_test -faults > report_name_base + ".test_faults"
/* Report faults (debug only) */

report_test -state > report_name_base + ".test_state"
/* Report scan status of current design */

report_test -testsim_timing > report_name_base + ".test_tim"
/* Report test timing for fault simulation */

/************************ End of Smc_scan.cmd *********************************/
