/* --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : Mmci_scan.cmd.rca
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose : 
--           Synopsys scan-insertion synthesis master compile script 
--           for the MMCI block.                                  
--
--           Located in the synopsys/scripts directory.        
--
--           This file defines the scan configuration parameters 
--           and performs the scan insertion. 
--
-- --=========================================================================*/
 
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
set_resistance 0 PRESETn
set_resistance 0 nMMCIRST

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
set_scan_path ChainPCLK all_registers (-clock PCLK) \
  -dedicated_scan_out true

/* Assign scan signals to existing scan test ports */
set_scan_signal test_scan_enable -port SCANENABLE

set_scan_path ChainMCLK all_registers (-clock MCLK) \
  -dedicated_scan_out true

set_drive 0 SCANENABLE
/* Infinite drive strength Scan Enable signal */

/* Integration Note :                                              */
/* The nMCLK domain contains only 2 F/Fs. This necessitated a      */
/* the selection of one strategy from the following 3 options:     */ 
/* - to treat these 2 F/Fs as non-scannable                        */
/* - to include these 2 F/Fs in the MCLK chain                     */
/* - to create a separate scan chain (containing only 2 F/Fs) for  */
/*   the nMCLK domain.                                             */
/*                                                                 */
/* The first approach wherein the 2 nMCLK domain F/Fs are declared */
/* non-scannable could result in reduced coverage since a          */
/* non-scannable element effectively becomes a black-box. To       */
/* eliminate loss of coverage, these F/Fs will have to be isolated */
/* from the rest of the logic. This leads to script complexity to  */
/* ensure that complete isolation has occured to prevent problems  */
/* during test vector generation.                                  */ 
/*                                                                 */
/* The second approach where clocks are to be mixed results in the */
/* classic "capture problem" to avoid which the nMCLK F/Fs are to  */
/* be placed in the chain preceding the MCLK F/Fs. However, at the */
/* time of chip-level integration the "capture problem" could      */
/* reappear if some MCLK domain F/Fs (external to the MMCI) were   */
/* connected to the MCLK chain since we now again have MCLK F/Fs   */
/* preceding nMCLK F/Fs.                                           */
/*                                                                 */
/* The solution chosen is the creation of a dedicated nMCLK chain. */
/* Even though this chain now calls for new dedicated scan ports   */
/* and contains only 2 elements, the script becomes simple and     */
/* portable, and complete freedom has been given to the system     */
/* integrator in terms of scan-chain ordering.                     */

set_scan_path ChainnMCLK all_registers (-clock nMCLK) \
  -dedicated_scan_out true

set_scan_path ChainMMCIFBCLK all_registers (-clock MMCIFBCLK) \
  -dedicated_scan_out true
              
set_scan_signal test_scan_in     -port SCANINPCLK  \
  -chain ChainPCLK
set_scan_signal test_scan_out    -port SCANOUTPCLK \
  -chain ChainPCLK

set_scan_signal test_scan_in     -port SCANINMCLK  \
  -chain ChainMCLK
set_scan_signal test_scan_out    -port SCANOUTMCLK \
  -chain ChainMCLK

set_scan_signal test_scan_in     -port SCANINnMCLK  \
  -chain ChainnMCLK
set_scan_signal test_scan_out    -port SCANOUTnMCLK \
  -chain ChainnMCLK

set_scan_signal test_scan_in     -port SCANINMMCIFBCLK  \
  -chain ChainMMCIFBCLK
set_scan_signal test_scan_out    -port SCANOUTMMCIFBCLK \
  -chain ChainMMCIFBCLK

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

/*************************** End of Mmci_scan.scr *****************************/
