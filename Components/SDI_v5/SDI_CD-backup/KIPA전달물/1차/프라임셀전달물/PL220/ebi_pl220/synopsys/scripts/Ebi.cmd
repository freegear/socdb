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
-- File Name              : Ebi.cmd.rca
-- File Revision          : 1.2
--
-- Release Information    : PrimeCell(TM)-PL220-r0p0-00ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Synopsys synthesis master compile script for the EBI block.
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
/* PERIPH       [set this to Ssmc]                                            */
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
topname = Ebi

/******************************************************************************/
/* SELECT SYNTHESIS WITH INPUT AND OUTPUT FORMATS IN VHDL OR VERILOG          */
/******************************************************************************/

/* set variable 'hdl' to 'vhdl' for VHDL or 'verilog' for Verilog RTL input.  */
/* set variable 'hdl_out' to 'vhdl' for VHDL output format or 'verilog' for   */
/* Verilog output format.                                                     */

hdl     = get_unix_variable("HDL_SOURCE")
hdl_out = get_unix_variable("HDL_NETL")

/******************************************************************************/
/* WRITE SYNTHESIS RUN START TIME                                             */
/******************************************************************************/
run_time_log = "log/" + topname + "_" + test_req + "_" + hdl + "_" + \
  hdl_out + "_synth.log"

echo "EBI SYNTHESIS TIME LOG" >  run_time_log
echo "======================" >> run_time_log
echo                          >> run_time_log
echo -n "START TIME -> "      >> run_time_log
sh date                       >> run_time_log
echo                          >> run_time_log

/******************************************************************************/
/* DEFINE LIST OF SOURCE RTL FILES                                            */
/******************************************************************************/

if (hdl == vhdl) {
  file_list = {} + EbiPackage
} else if (hdl == verilog) {
  sh cp ../verilog/rtl_source/EbiParams.v .
  file_list = {} 
}

file_list = file_list + EbiMux
file_list = file_list + EbiArbCntl
file_list = file_list + Ebi


/* INCLUDE LIBRARY SETTINGS FILE  */
/******************************************************************************/
/* Acquire V/HDL-Compiler just before analysis and elaboration. This ensures  */
/* that the V/HDL-Compiler is acquired only when it is necessary.             */
/******************************************************************************/
if (hdl == vhdl) {
  get_license VHDL-Compiler
  while (dc_shell_status == 0) {
   sh sleep 30
   get_license VHDL-Compiler
  }
} else if (hdl == verilog) {
  get_license HDL-Compiler
  while (dc_shell_status == 0) {
   sh sleep 30
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

current_design = topname

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

/******************************************************************************/
/* INCLUDE LIBRARY SETTINGS FILE                                              */
/******************************************************************************/
include scr_common_area + "/library_avanti_cb18_v1.0.scr"
/* This is for 190MHZ */

/* If the user is targetting a different technology, the above file needs to  */
/* be edited to include settings specific to that technology. The file should */
/* also be renamed appropriately.                                             */
 
/******************************************************************************/
/* APPLY CONSTRAINTS                                                          */
/******************************************************************************/

current_design = topname

include scr_common_area + "/global.scr"
/* global.scr defines the environmental conditions */
/* for worst/best case library conditions and      */
/* defines default cell load and drive strength.   */

/* Define Clock phase time (190 MHz operation)*/ 
tclkh = 2.625

/* Clock skew */
tmskewforhalfclk = 0.07
/* minus skew set to 2.5% of the highest frequency clock - for setup checks */

tmskew = tmskewforhalfclk * 2
/* minus skew set to 2.5% of the highest frequency  clock - for setup checks */

tpskew = tmskew * 0.40 /* plus  skew set to 40% of tmskew - for hold checks  */

tclkh = tclkh - tmskewforhalfclk

/* Define over-constraining margin */
oc_margin = 0.0

/* If the synthesis needs to be performed with an over-constrained */
/* clock set this parameter to a non-zero value. For example if    */
/* oc_margin is set to 0.5, the clock period will be reduced by    */
/* 1.0 ns.                                                         */

/* Note that the phase is reduced (over-constrained) by 0 ns */
tclkh = tclkh - oc_margin

include scr_common_area + "/amba_params.scr"
/* amba_params.scr defines the AHB timing parameters */

/******************************************************************************/
/* EBICLK DEFINTION                                                             */
/******************************************************************************/
create_clock -p tclk -w {0 tclkh} find(port, "EBICLK")
/* period tclk, rise at 0, fall after tclkh High phase */

set_clock_skew -ideal -plus_uncertainty tpskew find(clock, EBICLK)
/* set minus clock skew */

set_clock_transition 0 EBICLK
/* ignore all transition times as it is an ideal clock */

set_drive 0 EBICLK
/* Infinite drive strength clock signal */

set_load 0 EBICLK
/* Zero load clock signal */

remove_driving_cell find(port, EBICLK)
/* Set no driving cell on clock */

set_resistance 0 find(net, EBICLK)
/* Zero resistance for zero net delay(interconnect delay) on */
/* ideal clock net                                           */

set_dont_touch_network find(clock, EBICLK)
/* Preserve the clock net during optimisation */

/******************************************************************************/
/* RESET SIGNAL CONSTRAINTS                                                   */
/******************************************************************************/

set_input_delay -clock EBICLK -max tidmaxresetn nPOR
set_input_delay -clock EBICLK -min tidminresetn nPOR

set_drive 0 nPOR
/* Infinite drive strength reset signal */

set_load 0 nPOR
/* Zero load reset signal */

remove_driving_cell find(port, nPOR)
/* Set no driving cell on reset */

set_resistance 0 find(net, nPOR)
/* Zero resistance for zero net delay(interconnect delay) on */
/* ideal reset net                                           */

set_dont_touch_network find(port, nPOR)
/* Preserve the reset net during optimisation */

include scripts/Ebi.scr
/* Ebi.scr defines the input and output delay constraints for the block   */

include scripts/Ebi_exceptions.scr
/* Ebi_exceptions.scr defines the false paths in the Ebi block        */

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

set_critical_range 0.5 topname

/* The place where the test reports are to be written out into    */
report_name_base = "report/" + topname + "_" + test_req + "_" + hdl + \
  "_" + hdl_out
/******************************************************************************/
/* COMPILE
/******************************************************************************/
/******************************************************************************/
/* The following variable is set to "true" to avoid getting an error message  */
/* (VO-5) while writing out a verilog netlist, because of a synopsys internal */
/* database corruption. The number of bits on a bus attached to a port of a   */
/* DesignWare component does not equal the number of bits on the port.        */
/* This often happens to the DesignWare library's add, subtract, increment    */
/* and decrement elements. This defect manifests itself in version 2000.05-1. */
/* Releases prior to 2000.05 do not have this problem. Synopsys claims that   */
/* the defect is fixed in version 2000.11.                                    */
/* Thus users NOT using version 2000.05-1 can comment out the following       */
/* variable assignment.                                                       */
/* Please refer to SolvNET doc Star-41.html for further details.              */
/******************************************************************************/
compile_disable_hierarchical_inverter_opt = true

/* Prevent introduction of hierarchy for muxes */
compile_create_mux_op_hierarchy = false

if (test_req == scanready) {
/* Scan Ready Synthesis */

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

  /* Compile with scan and incremental effort, as the db's have already been
   * compiled once */
  compile -scan -map_effort high -inc

} else if (test_req == scaninsert) {
/* Scan Insert Synthesis */

  /* script to acquire Test-Compiler */
  remove_license Test-Compiler
  get_license Test-Compiler
  while (dc_shell_status == 0)
  {
    sh sleep 30;
    get_license Test-Compiler
  }

  /* Compile with scan and incremental effort, as the db's have already been
   * compiled once */
  compile -scan -map_effort high -inc

  set_scan_configuration -route true
  /* Route the scan chain for the scaninsert compile */

  /* Perform Scan Insertion */
  include scripts/Ebi_scan.cmd

} else {
/* no scan synthesis*/

  /* Compile without scan and incremental effort, as the db's have already been
   * compiled once */
  compile -map_effort high -inc
  /* Incremental compile using high CPU effort on the complete design */
}

/* Restore clock period to reflect actual target frequency */

/* Define Clock phase time */ 
tclkh = 2.625
tclkh = tclkh - tmskewforhalfclk

/******************************************************************************/
/* AMBA SIGNAL CONSTRAINTS                                                    */
/******************************************************************************/
include scr_common_area + "/amba_params.scr"
/* amba_params.scr defines the AHB timing parameters */

include scripts/Ebi.scr
/* Ebi.scr defines the input and output delay constraints for the block */

include scripts/Ebi_exceptions.scr
/* Ebi_exceptions.scr defines the false paths in the Ebi block      */

report_name_base = "report/" + topname + "_" + test_req + "_" + hdl + \
  "_" + hdl_out
 
/* Check for any test problems */
if (test_req == scanready) {
  echo              >> run_time_log
  echo "check_test" >> run_time_log
  echo "==========" >> run_time_log
  echo              >> run_time_log
  check_test        >> run_time_log
}

current_design = topname

set_fix_hold all_clocks()
/* Fix minimum timing violations */

compile -only_design_rule
/* Perform a design rule only compile to fix design rule violations */
/* and other parameters like max_capacitance, max_transition etc.   */
 
/* resistance constraints set on nets could have been lost following */
/* the design_rule compile. Restore them before generating the       */
/* the final netlist and SDF file.                                   */
set_resistance 0 nPOR
set_drive 0 nPOR

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
/* GENERATE AREA REPORTS                                                      */
/******************************************************************************/

design_list = find("design","*");

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

report_transitive_fanout -from nPOR -nosplit > report_name_base + \
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
  while (dc_shell_status == 0) {
   sh sleep 30
   get_license VHDL-Compiler
  }
} else if (hdl == verilog) {
  remove_license HDL-Compiler
  get_license HDL-Compiler
  while (dc_shell_status == 0) {
   sh sleep 30
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
  change_names -rule "CB25CAD_VLOG" -hierarchy
  change_names -rules COLLAPSE -hierarchy
}

/******************************************************************************/
/* GENERATE GATE-LEVEL NETLIST AND SDF TIMING FILE                            */
/******************************************************************************/

/* Note that the netlist and the sdf generation is controlled by the */
/* 'hdl' and 'hdl_out' variables.                                    */

/* From Synopsys Version 1998.02 onwards, both best case and worst */
/* case timing values are written out into the same sdf file.      */

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

/* Compatibility Note :                                              */
/* Synopsys 1999.05 write_sdf supersedes write_timing                */
/* Pre-1999.05 command syntax is shown below                         */
/* For vhdl netlist:                                                 */
/*    write_timing -format sdf-v2.1 -context vhdl \                  */
/*      -out netlist_area + "/" + topname + stype + "_Vhdl.sdf21"    */
/* For verilog netlist:                                              */
/*    write_timing -format sdf-v2.1 -context verilog \               */
/*      -out netlist_area + "/" + topname + stype + "_Verilog.sdf21" */

/* v2.1 SDF output format is produced */


/******************************************************************************/
/* WRITE SYNTHESIS RUN END TIME                                               */
/******************************************************************************/

echo -n "END TIME   -> "         >> run_time_log
sh date                          >> run_time_log
echo "=========================" >> run_time_log 
echo                             >> run_time_log

quit

/************************** End of Ebi.cmd ********************************/
