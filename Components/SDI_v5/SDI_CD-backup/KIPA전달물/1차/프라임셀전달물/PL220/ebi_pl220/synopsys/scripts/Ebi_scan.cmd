/* --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001-2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : Ebi_scan.cmd.rca
-- File Revision          : 1.5
--
-- Release Information    : PrimeCell(TM)-PL220-r0p0-00ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose : 
--           Synopsys scan-insertion synthesis master compile script 
--           for the top level Ebi block.                                  
--
--           Located in the synopsys/scripts directory.        
--
--           This file defines the scan configuration parameters 
--           and performs the scan insertion. 
--
-- --=========================================================================*/
 
current_design = topname

/* The ungrouping of DesignWare components would have deleted or */
/* created nets; as a result the zero resistance setting would   */
/* have been lost and has to be restored.                        */
set_resistance 0 nPOR

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

/* Scan chain with dedicated scanout ports. */
set_scan_path ChainEBICLK all_registers (-clock EBICLK) \
  -dedicated_scan_out true

/* Assign scan signals to existing scan test ports */
set_scan_signal test_scan_enable -port SCANENABLE

set_scan_signal test_scan_in     -port SCANINEBICLK  \
  -chain ChainEBICLK
set_scan_signal test_scan_out    -port SCANOUTEBICLK \
  -chain ChainEBICLK

set_drive 0 SCANENABLE
/* Infinite drive strength Scan Enable signal */

set_load 0 SCANENABLE
/* Zero load Scan enable signal */

remove_driving_cell find(port, SCANENABLE)
/* Set no driving cell on Scan enable */

echo                            >> run_time_log
echo "check_test before scan"   >> run_time_log
echo "======================"   >> run_time_log
echo                            >> run_time_log
check_test -verbose             >> run_time_log
/* Create pre-scan reports */

preview_scan -script > report_name_base + ".PreviewScript"
/* Generate a dc_shell script that specifies the defined scan configuration */

preview_scan -show all > report_name_base + ".PreviewAll"

/******************************************************************************/
/* INSERT THE SCAN CHAINS                                                     */
/******************************************************************************/
 
insert_scan -map_effort medium
/* Connect scan cells and optimise scan structure */
 
/* resistance constraints set on nets could have been lost following */
/* the insert_scan. Restore them before generating the final netlist */
/* and SDF file.                                                     */
all_connected SCANENABLE
net_name_list = dc_shell_status
foreach (net_name, net_name_list) {
  set_resistance 0 net_name
}

echo                >> run_time_log
echo "check_test"   >> run_time_log
echo "=========="   >> run_time_log
echo                >> run_time_log
check_test -verbose >> run_time_log
/* Create test insertion report (test rule check) */ 

/**********************************************************************/
/* GENERATE SCAN REPORTS                                              */
/**********************************************************************/
 
create_test_patterns -dft -sample 11
/* Sample of 11% faults targeted estimates fault coverage within 1-2% */
 
report_test -coverage > report_name_base + ".scan"
/* Report test coverage */
 
report_test -configuration >> report_name_base + ".scan"
/* Report test configuration */
 
report_test -scan_path >> report_name_base + ".scan"
/* List cells on each scan chain */

test_stil_netlist_format = verilog
write_test_protocol -format stil -out report_name_base + ".stil"
/* Write out a default test protocol */

report_test -port > report_name_base + ".TestArea"
/* Report test ports */

report_test -state > report_name_base + ".TestState"
/* Report scan status of current design */

report_test -testsim_timing > report_name_base + ".TestTim"
/* Report test timing for fault simulation */

/************************ End of Ebi_scan.cmd *************************/
