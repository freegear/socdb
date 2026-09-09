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
-- File Name              : Mpmc_scan.cmd.rca
-- File Revision          : 1.8
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose : 
--           Synopsys scan-insertion synthesis master compile script 
--           for the top level MPMC block.                                  
--
--           Located in the synopsys/scripts directory.        
--
--           This file defines the scan configuration parameters 
--           and performs the scan insertion. 
--
-- --=========================================================================*/
 
/******************************************************************************/
/* Flatten DesignWare hierarchy as per Solvit note    */
/* Synthesis-173.html, to avoid SDF/netlist problems. */
/******************************************************************************/
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

/******************************************************************************/
/* The ungrouping of DesignWare components would have deleted or              */
/* created nets; as a result the zero resistance setting would                */
/* have been lost and has to be restored.                                     */
/******************************************************************************/
set_resistance 0 HRESETn

set_resistance 0 nPOR

/******************************************************************************/
/* Set the scan style to full-scan with multiplexed flip-flops                */
/******************************************************************************/
test_default_scan_style = multiplexed_flip_flop

/* Multiplexed Flip Flop is used as the scan cell */
set_scan_configuration -style multiplexed_flip_flop

/* Full Scan Methodology */
set_scan_configuration -methodology full_scan

/* Individual scan chains for each clock domain */
set_scan_configuration -clock_mixing no_mix

/* Replace all flip flops with their equivalent scan cells */
set_scan_configuration -replace true

/* No lockup latches required when no clock mixing in scan chain */
set_scan_configuration -add_lockup false

/* Every scan chain has a dedicated output port for the scan out */
/* signals                                                       */
set_scan_configuration -dedicated_scan_ports true

/* There is no existing scan logic. */
set_scan_configuration -existing_scan false

/* All scan related signals (scan in , scan out, scan enable */
/* and scan clocks) to be routed.                            */
set_scan_configuration -route true

/******************************************************************************/
/* Declare scan chains with dedicated scanout ports.                          */
/******************************************************************************/
set_scan_path ChainHCLK all_registers (-clock HCLK) \
  -dedicated_scan_out true
set_scan_path ChainMPMCCLK all_registers (-clock MPMCCLK) \
  -dedicated_scan_out true
set_scan_path ChainFBCLKIN0 all_registers (-clock MPMCFBCLKIN0) \
  -dedicated_scan_out true
set_scan_path ChainFBCLKIN1 all_registers (-clock MPMCFBCLKIN1) \
  -dedicated_scan_out true
set_scan_path ChainFBCLKIN2 all_registers (-clock MPMCFBCLKIN2) \
  -dedicated_scan_out true
set_scan_path ChainFBCLKIN3 all_registers (-clock MPMCFBCLKIN3) \
  -dedicated_scan_out true
set_scan_path ChainCLKDELAY all_registers (-clock MPMCCLKDELAY) \
  -dedicated_scan_out true

/******************************************************************************/
/* Assign scan signals to existing scan ports                                 */
/******************************************************************************/
/* Declare the scan enable signal */
set_scan_signal test_scan_enable -port SCANENABLE

/***************/
/* HCLK domain */
/***************/

/* Declare the scan input signal for HCLK domain scan chain*/
set_scan_signal test_scan_in     -port SCANINHCLK  \
  -chain ChainHCLK

/* Declare the scan output signal for HCLK domain scan chain*/
set_scan_signal test_scan_out    -port SCANOUTHCLK \
  -chain ChainHCLK

/******************/
/* MPMCCLK domain */
/******************/

/* Declare the scan input signal for MPMCCLK domain scan chain*/
set_scan_signal test_scan_in     -port SCANINMPMCCLK  \
  -chain ChainMPMCCLK

/* Declare the scan output signal for MPMCCLK domain scan chain*/
set_scan_signal test_scan_out    -port SCANOUTMPMCCLK \
  -chain ChainMPMCCLK

/***********************/
/* MPMCFBCLKIN0 domain */
/***********************/

/* Declare the scan input signal for MPMCFBCLKIN0 domain scan chain*/
set_scan_signal test_scan_in     -port SCANINFBCLKIN0  \
  -chain ChainFBCLKIN0

/* Declare the scan output signal for MPMCFBCLKIN0 domain scan chain*/
set_scan_signal test_scan_out    -port SCANOUTFBCLKIN0 \
  -chain ChainFBCLKIN0

/***********************/
/* MPMCFBCLKIN1 domain */
/***********************/

/* Declare the scan input signal for MPMCFBCLKIN1 domain scan chain*/
set_scan_signal test_scan_in     -port SCANINFBCLKIN1  \
  -chain ChainFBCLKIN1

/* Declare the scan output signal for MPMCFBCLKIN1 domain scan chain*/
set_scan_signal test_scan_out    -port SCANOUTFBCLKIN1 \
  -chain ChainFBCLKIN1


/***********************/
/* MPMCFBCLKIN2 domain */
/***********************/

/* Declare the scan input signal for MPMCFBCLKIN2 domain scan chain*/
set_scan_signal test_scan_in     -port SCANINFBCLKIN2  \
  -chain ChainFBCLKIN2

/* Declare the scan output signal for MPMCFBCLKIN2 domain scan chain*/
set_scan_signal test_scan_out    -port SCANOUTFBCLKIN2 \
  -chain ChainFBCLKIN2

/***********************/
/* MPMCFBCLKIN3 domain */
/***********************/

/* Declare the scan input signal for MPMCFBCLKIN3 domain scan chain*/
set_scan_signal test_scan_in     -port SCANINFBCLKIN3  \
  -chain ChainFBCLKIN3

/* Declare the scan output signal for MPMCFBCLKIN3 domain scan chain*/
set_scan_signal test_scan_out    -port SCANOUTFBCLKIN3 \
  -chain ChainFBCLKIN3

/***********************/
/* MPMCFBCLKIN0 domain */
/***********************/

/* Declare the scan input signal for MPMCCLKDELAY domain scan chain*/
set_scan_signal test_scan_in     -port SCANINCLKDELAY  \
  -chain ChainCLKDELAY

/* Declare the scan output signal for MPMCCLKDELAY domain scan chain*/
set_scan_signal test_scan_out    -port SCANOUTCLKDELAY \
  -chain ChainCLKDELAY

/******************************************************************************/
/* Set scan enable signal as an ideal net                                     */
/******************************************************************************/
/* Infinite drive strength Scan Enable signal */
set_drive 0 SCANENABLE

/* Zero load Scan enable signal */
set_load 0 SCANENABLE

/* Set no driving cell on Scan enable */
remove_driving_cell find(port, SCANENABLE)

/******************************************************************************/
/* Create pre-scan reports                                                    */
/******************************************************************************/
echo                            >> run_time_log
echo "check_test before scan"   >> run_time_log
echo "======================"   >> run_time_log
echo                            >> run_time_log
check_test -verbose             >> run_time_log

/* Generate a dc_shell script that specifies the defined scan configuration */
preview_scan -script > report_name_base + ".PreviewScript"
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

/* Create test insertion report (test rule check) */ 
echo                >> run_time_log
echo "check_test"   >> run_time_log
echo "=========="   >> run_time_log
echo                >> run_time_log
check_test -verbose >> run_time_log

/**********************************************************************/
/* GENERATE SCAN REPORTS                                              */
/**********************************************************************/
 
/* Sample of 11% faults targeted estimates fault coverage within 1-2% */
create_test_patterns -dft -sample 11
 
/* Report test coverage */
report_test -coverage > report_name_base + ".scan"
 
/* Report test configuration */
report_test -configuration >> report_name_base + ".scan"
 
/* List cells on each scan chain */
report_test -scan_path >> report_name_base + ".scan"

/* Write out a default test protocol */
write_test_protocol -out report_name_base + ".default.tpf"

/* Report test ports */
report_test -port > report_name_base + ".TestArea"

/* Report ATPG conflicts */
report_test -atpg_conflicts > report_name_base + ".TestAtpgConf"

/* Report faults (debug only) */
report_test -faults > report_name_base + ".TestFaults"

/* Report scan status of current design */
report_test -state > report_name_base + ".TestState"

/* Report test timing for fault simulation */
report_test -testsim_timing > report_name_base + ".TestTim"

/************************ End of Mpmc_scan.cmd ************************/
