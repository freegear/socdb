/* --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000-2003 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : Smc.cmd.rca
-- File Revision          : 1.20
--
-- Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Synopsys synthesis master compile script for the SMC block.
--
--           Located in the synopsys/scripts directory.        
--
--           This file specifies the order in which commands are executed and
--           it is written to use shell mode.   
--
--           This file uses several other script files.          
--
--           This file can be configured to synthesise either VHDL or Verilog
--           source, and output files in either VHDL or Verilog format.
--
--           This master compile script analyses source files, elaborates the
--           design, applies constraints, compiles to the target library and
--           then generates netlist, timing and report files.
--
-- --=========================================================================*/

/******************************************************************************/
/* Please ensure that the following environment variables are set before      */
/* synthesis invocation.                                                      */
/*                                                                            */
/* GLOBAL       [path to shared files]                                        */
/*                                                                            */
/* PERIPH       [set this to 'Smc']                                           */
/*                                                                            */
/* TEST_METH    [set this to either 'noscan', 'scanready' or 'scaninsert']    */
/*                                                                            */
/* HDL_SOURCE   [set this to either 'vhdl' or 'verilog']                      */
/*                                                                            */
/* HDL_NETL     [set this to either 'vhdl' or 'verilog']                      */
/*                                                                            */
/******************************************************************************/

/******************************************************************************/
/* INCLUDE PROJECT-SPECIFIC SETUP FILE                                        */
/******************************************************************************/

synth_base_area = get_unix_variable("GLOBAL")
scr_common_area = synth_base_area + "/synopsys_shared/scr_common"
include scr_common_area + "/setup.scr"
/* define the synthesis parameters to be used for the synthesis */

/* Note that the scr_common_area contains files that are common to other      */
/* PrimeCell peripherals. These files may require modification to reflect the */
/* technology that the user is targetting to.                                 */

/******************************************************************************/
/* Select the module to be synthesised                                        */
/******************************************************************************/
topname = get_unix_variable("PERIPH")

/******************************************************************************/
/* SELECT SYNTHESIS WITH INPUT AND OUTPUT FORMATS IN VHDL OR VERILOG          */
/******************************************************************************/

/* set variable 'hdl' to 'vhdl' for VHDL or 'verilog' for Verilog RTL input.  */
/* set variable 'hdl_out' to 'vhdl' for VHDL output format or 'verilog' for   */
/* Verilog output format.                                                     */

hdl     = get_unix_variable("HDL_SOURCE")
hdl_out = get_unix_variable("HDL_NETL")

/* Uncomment the following to replace the use of environment variables above, */
/* which determine input and output format selected for synthesis             */

/*
hdl     = vhdl
hdl_out = vhdl
*/

/******************************************************************************/
/* WRITE SYNTHESIS RUN START TIME                                             */
/******************************************************************************/
run_time_log = "log/" + topname + "_" + test_req + "_" + hdl + "_" + \
  hdl_out + "_synth.log"

echo "SMC SYNTHESIS TIME LOG" >  run_time_log
echo "======================" >> run_time_log
echo                          >> run_time_log
echo -n "START TIME -> "      >> run_time_log
sh date                       >> run_time_log
echo                          >> run_time_log

/******************************************************************************/
/* Read in the DBs of the SmcCore, DBI and the  TIC                           */
/******************************************************************************/
/* setting the search path for the db's   */
search_path = search_path + { . db }

read "db/TIC_" + test_req + "_" + hdl + ".db"
read "db/DBI_" + test_req + "_" + hdl + ".db"
read "db/SmcCore_" + test_req + "_" + hdl + ".db"

/******************************************************************************/
/* INCLUDE LIBRARY SETTINGS FILE                                              */
/******************************************************************************/

include scr_common_area + "/library_avanti_cb25_v2.1.scr"
/* If the user is targetting a different technology, the above file needs to  */
/* be edited to include settings specific to that technology. The file should */
/* also be renamed appropriately.                                             */

/******************************************************************************/
/* DEFINE LIST OF SOURCE RTL FILES                                            */
/******************************************************************************/

if (hdl == vhdl) {
  file_list = {}
} else if (hdl == verilog) {
  file_list = {}
}

file_list = file_list + SmcRevAnd
file_list = file_list + Smc

/******************************************************************************/
/* Currently PRESTO enabled reading of verilog files, impacts the synthesis   */
/* timing significantly. Hence PRESTO is disabled.                            */
/******************************************************************************/
if (hdl == verilog) {
hdlin_enable_presto = false
}

/* script to acquire V/HDL-Compiler just before analysis and elaboration.     */
/* This script ensures that the V/HDL-Compiler is acquired only when it is    */
/* necessary.                                                                 */

if (hdl == vhdl) {
  get_license VHDL-Compiler
  while (dc_shell_status == 0)
  {
   get_license VHDL-Compiler
  }
} else if (hdl == verilog) {
  get_license HDL-Compiler
  while (dc_shell_status == 0)
  {
   get_license HDL-Compiler
  }
}

/******************************************************************************/
/* ANALYSE RTL SOURCE FILES                                                   */
/******************************************************************************/

if (hdl == vhdl) {
  /*** VHDL RTL SOURCE ***/
  foreach (filename, file_list) {
    analyze -format vhdl "../" + hdl + "/rtl_source/" + filename + \
    ".vhd" -lib work
  }
} else if (hdl == verilog) {
  /*** VERILOG RTL SOURCE ***/
  foreach (filename, file_list) {
    analyze -format verilog "../" + hdl + "/rtl_source/" + filename + \
    ".v" -lib work
  }
}


/******************************************************************************/
/* ELABORATE THE DESIGN                                                       */
/******************************************************************************/

elaborate -lib work topname

/* release the V/HDL-Compiler once elaboration is over */
if (hdl == vhdl) {
  remove_license VHDL-Compiler
} else if (hdl == verilog) {
  remove_license HDL-Compiler
}

uniquify
/* Separately optimise multiple instantiations within the design, allocating  */
/* unique names to each instance.                                             */

echo                >> run_time_log
echo "check_design" >> run_time_log
echo "============" >> run_time_log
echo                >> run_time_log
check_design        >> run_time_log
/* Check that files have been read correctly and that various nodes are       */
/* connected.                                                                 */

current_design = topname

/******************************************************************************/
/* Link the SmcCore, SmcRevAnd, DBI and TIC using their db's                  */
/******************************************************************************/
link

echo                >> run_time_log
echo "check_design" >> run_time_log
echo "============" >> run_time_log
echo                >> run_time_log
check_design        >> run_time_log
/* Check that files have been read correctly and that various nodes are       */
/* connected.                                                                 */

current_design = topname

/******************************************************************************/
/* APPLY CONSTRAINTS                                                          */
/******************************************************************************/
current_design = topname

include scr_common_area + "/global.scr"
/* global.scr defines the environmental conditions for worst/best case        */
/* library conditions and defines default cell load and drive strength.       */

/******************************************************************************/
/* EXTBUSMUX port tie off value                                               */
/******************************************************************************/
include scripts/Smc_BusMode.scr

/* Define Clock phase time */ 
tclkh = 5.00

/* Clock skew */
tmskewforhalfclk = 0.25

/* minus skew set to 2.5% of clock - for setup checks */
tmskew = tmskewforhalfclk * 2

/* plus  skew set to 40% of tmskew - for hold checks  */
tpskew = tmskew * 0.40

/* subtract tmskew for half clock from half clock period */
tclkh = tclkh - tmskewforhalfclk

/* Define over-constraining margin */
oc_margin = 0.10
/* If the synthesis needs to be performed with an over-constrained clock set  */
/* this parameter to a non-zero value. For example if oc_margin is set to     */
/* 0.5, the clock period will be reduced by 1.0 ns.                           */

/* Note that the phase is reduced (over-constrained) by 0.5 ns */
tclkh = tclkh - oc_margin

/* Clock LOW phase equals clock HIGH phase */
tclkl = tclkh

/* Clock period of HCLK/PCLK, period 20ns for 50.0MHz */
tclk  = tclkl + tclkh

include scripts/amba_params.scr
/* amba_params.scr defines the AHB timing parameters */

include scripts/ahb_slave.scr
/* ahb_slave.scr defines the AHB timing constraints using the above */

/* TIC I/O's are not constrained as it has been compiled separately and       */
/* does not affect the timing                                                 */

include scripts/Smc.scr
/* Smc.scr defines the input and output delay constraints for the block  */

include scripts/Smc_exceptions.scr
/* Smc.scr defines the false paths for TIC and tied pins of SmcCore */

echo                >> run_time_log
echo "check_timing" >> run_time_log
echo "============" >> run_time_log
echo                >> run_time_log
check_timing        >> run_time_log
/* Check whether timing parameters are valid.           */
/* Unconstrained ports, gated clocks etc. are reported. */

current_design = topname

/******************************************************************************/
/* Fix minimum timing violations                                              */
/******************************************************************************/
set_fix_hold all_clocks()

/* The place where the test reports are to be written out into    */
report_name_base = "report/" + topname + "_" + test_req + "_" + hdl + \
  "_" + hdl_out
 
if (test_req == scanready) {
  /* script to acquire Test-Compiler */
  remove_license Test-Compiler
  get_license Test-Compiler
  while (dc_shell_status == 0)
  {
    sh sleep 30;
    get_license Test-Compiler
  }

  set_scan_configuration -route false
  /* Do not route the scan chain for the scanready compile */

  compile -scan -map_effort high -inc

} else if (test_req == scaninsert) {
  /* script to acquire Test-Compiler */
  remove_license Test-Compiler
  get_license Test-Compiler
  while (dc_shell_status == 0)
  {
    sh sleep 30;
    get_license Test-Compiler
  }

  compile -scan -map_effort high -inc

  set_scan_configuration -route true
  /* Route the scan chain for the scaninsert compile */

  include scripts/Smc_scan.cmd

} else {
  compile -map_effort high -inc
  /* Incremental compile using high CPU effort on the complete design */
}

 
/* Restore clock period to reflect actual target frequency */

/* Define Clock phase time */ 
tclkh = 5.00

/* Clock skew */
tmskewforhalfclk = 0.25

/* minus skew set to 2.5% of clock - for setup checks */
tmskew = tmskewforhalfclk * 2

/* plus  skew set to 40% of tmskew - for hold checks  */
tpskew = tmskew * 0.40

/* subtract tmskew for half clock from half clock period */
tclkh = tclkh - tmskewforhalfclk

/* Restore clock period to reflect actual target frequency */
oc_margin = 0.0
/* If the synthesis needs to be performed with an over-constrained */
/* clock set this parameter to a non-zero value. For example if    */
/* oc_margin is set to 0.5, the clock period will be reduced by    */
/* 1.0 ns.                                                         */

tclkh = tclkh - oc_margin

/* Clock LOW phase equals clock HIGH phase */
tclkl = tclkh

/* Clock period of HCLK/PCLK, period 20ns for 50.0MHz */
tclk  = tclkl + tclkh

include scripts/amba_params.scr
/* amba_params.scr defines the AHB timing parameters */

include scripts/ahb_slave.scr
/* ahb_slave.scr defines the AHB timing constraints for slave      */
/* using the above                                                 */

include scripts/Smc.scr
/* Smc.scr defines the input and output delay constraints for the */
/* block                                                          */

include scripts/Smc_exceptions.scr
/* Smc.scr defines the false paths for TIC and tied pins of the SmcCore */

/* The place where the test reports are to be written out into    */
report_name_base = "report/" + topname + "_" + test_req + "_" + hdl + \
  "_" + hdl_out
 
set_resistance 0 HRESETn
set_drive 0 HRESETn

/******************************************************************************/
/* GENERATE VIOLATION REPORT                                                  */
/******************************************************************************/

report_constraint -verbose -all_violators > report_name_base + ".vio"
/* Output a detailed constraints report listing all violations */
/* in descending order, written to the report area.            */

/******************************************************************************/
/* GENERATE TIMING REPORTS                                                    */
/******************************************************************************/

report_timing -delay max -path full -max_paths 100 -nworst 10 \
  > report_name_base + ".max"
/* Output a maximum delay timing report for upto 100 paths,     */
/* with upto 10 paths per endpoint, written to the report area. */

report_timing -delay min -path full -max_paths 100 -nworst 10 \
  > report_name_base + ".min"
/* Output a minimum delay timing report for upto 100 paths,     */
/* with upto 10 paths per endpoint, written to the report area. */


/******************************************************************************/
/* Generate input and output port reports.                                    */
/* No reports are generated for the clock and reset inputs, TIC, ports, scan  */
/* ports, and the tied off inputs.                                            */
/******************************************************************************/

design_inputs = all_inputs() - HCLK - nHCLK - HRESETn - SCANENABLE - SCANINHCLK
design_inputs = design_inputs - SCANINnHCLK - find(port, SMMWCS7) - BIGENDIAN
design_inputs = design_inputs - find(port, SMRBLECS7)
design_inputs = design_inputs - TESTREQA - TESTREQB - find(port, HRESPTIC)
design_inputs = design_inputs - find(port, HRDATATIC) - HGRANTTIC

design_outputs = all_outputs()  - SCANOUTnHCLK - SCANOUTHCLK
design_outputs = design_outputs - find(port, HADDRTIC) - find(port, HTRANSTIC)
design_outputs = design_outputs - HWRITETIC - find(port, HSIZETIC)
design_outputs = design_outputs - find(port, HBURSTTIC) - find(port, HWDATATIC)
design_outputs = design_outputs - HBUSREQTIC - HLOCKTIC - TESTACK

echo "Inputs - Max Timing" > report_name_base + ".inputs_max"
echo "Inputs - Min Timing" > report_name_base + ".inputs_min"

foreach (ipport, design_inputs) {
  report_timing -from ipport -input_pins -nets -delay max \
    -max_paths 2 -nworst 5 -nosplit -transition_time \
      >> report_name_base + ".inputs_max"

  report_timing -from ipport -input_pins -nets -delay min \
    -max_paths 2 -nworst 5 -nosplit -transition_time \
      >> report_name_base + ".inputs_min"
}

echo "Outputs - Max Timing" > report_name_base + ".outputs_max"
echo "Outputs - Min Timing" > report_name_base + ".outputs_min"

foreach (opport, design_outputs) {
  report_timing -to opport -input_pins -nets -delay max \
    -max_paths 2 -nworst 5 -nosplit -transition_time \
      >> report_name_base + ".outputs_max"

  report_timing -to opport -input_pins -nets -delay min \
    -max_paths 2 -nworst 5 -nosplit -transition_time \
      >> report_name_base + ".outputs_min"
}


/******************************************************************************/
/* GENERATE AREA REPORTS                                                      */
/******************************************************************************/

/* Create area reports of the current design modules */
current_design = topname
echo " AREA REPORT FOR DESIGN : " + current_design > \
  report_name_base + ".area"
foreach (design_name, find("design","*")) {
  current_design = design_name
  echo "    " >> report_name_base + ".area" 
  report_area >> report_name_base + ".area"
}
 
/******************************************************************************/
/* GENERATE CONSTRAINT REPORTS                                                */
/******************************************************************************/

current_design = topname

report_design > report_name_base + ".constr"
/* 'report_design' displays information about the current design and */
/* its environment. It lists out the library used, operating         */
/* conditions, wireload models used etc.                             */

report_constraint >> report_name_base + ".constr"
/* 'report_constraint' displays constraint-related information about */
/* the design.                                                       */

report_clock >> report_name_base + ".constr" 
/* 'report_clock' provides a summary of all the defined clocks, */
/* their period waveform and any attributes set on them.        */

report_attribute -design  >> report_name_base + ".constr"
/* 'report_attribute' reports attribute related to the design */

report_port -verbose  > report_name_base + ".ports"
/* Report information about ports of design */

/******************************************************************************/
/* GENERATE  REPORTS for Clock + Reset tree information, abouts Cells used    */
/* and their heirarchy                                                        */
/******************************************************************************/
report_transitive_fanout -clock_tree -nosplit > report_name_base + ".ClockTree"
/* Report the Clock Tree information to check if any buffers present */

report_transitive_fanout -from HRESETn -nosplit > report_name_base + \
  ".ResetTree"
/* Report the Reset Tree information to check if any buffers present */

report_cell  > report_name_base + ".Cell"
/* 'report_cell' provides information about all cells in the current design   */

report_reference > report_name_base + ".Ref"
/* 'report_reference' provides information about all cell references in the   */
/* current design                                                             */

report_hierarchy > report_name_base + ".Hier"
/* 'report_hierarchy' lists out the cells used in the design hierarchically   */

/******************************************************************************/
/* GENERATE LATCH REPORTS                                                     */
/******************************************************************************/

echo " CHECK FOR LATCHES " > report_name_base + ".latch"
all_registers -level_sensitive 
list dc_shell_status >> report_name_base + ".latch"
/* Check for inferred latches */ 

echo " CHECK FOR COMBINATIONAL LOOPS " >> report_name_base + ".latch"

report_timing -loops >> report_name_base + ".latch"
/* Check for combinational loops */ 

/* The report files should contain no violations or errors */
/* and ideally zero or a minimal number of warnings        */

/* script to acquire V/HDL-Compiler just before netlist write-out   */
/* Note: the initial remove_license is needed even though it looks  */
/* redundant. This is to account for cases where the V/HDL-Compiler */
/* is automatically checked out during the compile phase.           */
if (hdl == vhdl) {
  remove_license VHDL-Compiler
  get_license VHDL-Compiler
  while (dc_shell_status == 0)
  {
   get_license VHDL-Compiler
  }
} else if (hdl == verilog) {
  remove_license HDL-Compiler
  get_license HDL-Compiler
  while (dc_shell_status == 0)
  {
   get_license HDL-Compiler
  }
}

/******************************************************************************/
/* SAVE THE DATABASE IN SYNOPSYS .DB FORMAT                                   */
/******************************************************************************/

current_design = topname
write -format db -hier -out "db/" + topname + "_" + test_req + "_" \
 + hdl + "_" + hdl_out + ".db"

/******************************************************************************/
/* APPLY NAMING RULES                                                         */
/******************************************************************************/
/* Apply change_names to avoid naming problems in design flow, */
/* refer to Solvit note METH-148274.html                       */

/* Naming rules are defined in the name_rules.scr file residing in  */
/* scr_common_area. If any alternate naming rules are to be defined */
/* please include them in the name_rules.scr file.                  */

if (hdl == vhdl) {
  change_names -rule "CB25CAD_VHDL" -hierarchy
  change_names -rules SPECIAL_VHDL -hierarchy
} else if (hdl == verilog) {
/*
  change_names -rule "CB25CAD_VLOG" -hierarchy
  change_names -rules COLLAPSE -hierarchy
*/
}

/******************************************************************************/
/* GENERATE GATE-LEVEL NETLIST AND SDF TIMING FILE                            */
/******************************************************************************/

/* Note that the netlist and the sdf generation is controlled by the */
/* 'hdl' and 'hdl_out' variables.                                    */

/* From SynopsysVersion 1998.02 onwards, both best case and worst */
/* case timing values are written out into the same sdf file.     */

netlist_name_base = "../" + hdl_out + "/netlist/" + topname + "_" + \
  test_req + "_" + hdl

if (hdl_out == vhdl) {
  /*** VHDL OUTPUT FORMAT ***/
  write -format vhdl -hier -out netlist_name_base + "_net.vhd"
  write_sdf -version 2.1 netlist_name_base + ".sdf21"
} else if (hdl_out == verilog) {
  /*** VERILOG OUTPUT FORMAT ***/
  write -format verilog -hier -out netlist_name_base + "_net.v"
  write_sdf -version 2.1 netlist_name_base + ".sdf21"
}

/* Compatibility Note :                                                       */
/* Synopsys 1999.05 write_sdf supersedes write_timing                         */
/* Pre-1999.05 command syntax is shown below                                  */
/* For vhdl netlist:                                                          */
/*    write_timing -format sdf-v2.1 -context vhdl \                           */
/*      -out netlist_area + "/" + topname + stype + "_Vhdl.sdf21"             */
/* For verilog netlist:                                                       */
/*    write_timing -format sdf-v2.1 -context verilog \                        */
/*      -out netlist_area + "/" + topname + stype + "_Verilog.sdf21"          */

/* v2.1 SDF output format is produced */

/******************************************************************************/
/* WRITE SYNTHESIS RUN END TIME                                               */
/******************************************************************************/

echo -n "END TIME   -> "         >> run_time_log
sh date                          >> run_time_log
echo "=========================" >> run_time_log 
echo                             >> run_time_log

/*
quit
*/
echo " SMC DONE "

/************************** End of Smc.cmd ************************************/
