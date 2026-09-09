/* --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
-- 
-- Version and Release Control Information:
-- 
-- File Name              : Vic.cmd.rca
-- File Revision          : 1.4
-- 
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
-- 
--------------------------------------------------------------------------------
-- Purpose :
--           Synopsys synthesis master compile script            
--           for the VIC block.                                  
--
--           Located in the synopsys/scripts directory.        
--
--           This file specifies the order in which commands   
--           are executed and it is written to use shell mode.   
--
--           This file uses several other script files.          
--
--           This file can be configured to synthesise either
--           VHDL or Verilog source, and output files in either
--           VHDL or Verilog format.
--
--           This master compile script analyses source files,
--           elaborates the design, applies constraints,
--           compiles to the target library and then generates
--           netlist, timing and report files.
--
-- --=========================================================================*/

/******************************************************************************/
/* Please ensure that the following environment variables are set             */
/* before synthesis invocation.                                               */
/*                                                                            */
/* GLOBAL       [path to shared files]                                        */
/*                                                                            */
/* PERIPH       [set this to 'Vic']                                           */
/*                                                                            */
/* TEST_METH    [set this to either 'noscan',                                 */
/*               'scanready' or 'scaninsert']                                 */
/*                                                                            */
/* HDL_SOURCE   [set this to either 'vhdl' or 'verilog']                      */
/*                                                                            */
/* HDL_NETL     [set this to either 'vhdl' or 'verilog']                      */
/*                                                                            */
/******************************************************************************/

/******************************************************************************/
/* INCLUDE PROJECT-SPECIFIC SETUP FILE                                        */
/******************************************************************************/

/* define the synthesis parameters to be used for the synthesis */
synth_base_area = get_unix_variable("GLOBAL")
scr_common_area = synth_base_area + "/synopsys_shared/scr_common"
include scr_common_area + "/setup.scr"

/* Note that the scr_common_area contains files that are common to            */
/* other PrimeCell peripherals. These files may require modification          */
/* to reflect the technology that the user is targetting to.                  */
/* 1. setup.scr                                                               */
/* 2. library_avanti_cb18_v1.0.scr                                            */

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

echo "VIC SYNTHESIS TIME LOG" >  run_time_log
echo "======================" >> run_time_log
echo                          >> run_time_log
echo -n "START TIME -> "      >> run_time_log
sh date                       >> run_time_log
echo                          >> run_time_log

/******************************************************************************/
/* DEFINE LIST OF SOURCE RTL FILES                                            */
/******************************************************************************/

if (hdl == vhdl) {
  file_list = {} + VicPackage
} else if (hdl == verilog) {
  sh cp ../verilog/rtl_source/VicParams.v .
  file_list = {} + VicParams
}

file_list = file_list + VicAhbif + VicCpuif + VicRevAnd
file_list = file_list + VicPriority + VicIntResolver + VicInterrupt
file_list = file_list + Vic

/******************************************************************************/
/* Currently PRESTO enabled reading of verilog files, impacts the synthesis   */
/* timing significantly. Hence PRESTO is disabled.                            */
/******************************************************************************/
hdlin_enable_presto = false

/* Get DC Ultra optimization license */
get_license DC-Ultra-Opt
while (dc_shell_status == 0) {
  sh sleep 30
  get_license DC-Ultra-Opt
}

/* Get designware license*/
get_license DesignWare
while (dc_shell_status == 0) {
  sh sleep 30
  get_license DesignWare
}

set_ultra_optimization true -force 
/******************************************************************************/
/* Acquire V/HDL-Compiler just before analysis and elaboration. This ensures  */
/* that the V/HDL-Compiler is acquired only when it is necessary.             */
/******************************************************************************/
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
  sh rm VicParams.v
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

/* Separately optimise multiple instantiations within the design, allocating  */
/* unique names to each instance.                                             */
uniquify

remove_design VicPriority

/* Check that files have been read correctly and that various nodes are       */
/* connected.                                                                 */
echo                >> run_time_log
echo "check_design" >> run_time_log
echo "============" >> run_time_log
echo                >> run_time_log
check_design        >> run_time_log

/******************************************************************************/
/* INCLUDE LIBRARY SETTINGS FILE                                              */
/******************************************************************************/
 
include scr_common_area + "/library_avanti_cb18_v1.0.scr"

/* If the user is targetting a different technology, the above file needs to  */
/* be edited to include settings specific to that technology. The file should */
/* also be renamed appropriately.                                             */
 
/******************************************************************************/
/* APPLY CONSTRAINTS                                                          */
/* Clock details  Frequency tmskew tpskew Description                         */
/* HCLK           166 MHz   0.15   0.06   AHB system clock                    */
/******************************************************************************/

current_design = topname

/* global.scr defines the environmental conditions for worst/best case        */
/* library conditions and defines default cell load and drive strength.       */
include scr_common_area + "/global.scr"

/******************************************************************************/
/* CLOCK TIMING CONSTRAINTS                                                   */
/******************************************************************************/
/* Define Clock phase time 3.0 ns (166 MHz operation) */ 
tclkh = 3.0

/* Clock skew */
/* minus skew set to 2.5% of clock - for setup checks */
tmskewforhalfclk = (0.025 * tclkh)

/* minus skew set to 2.5% of clock - for setup checks */
tmskew = tmskewforhalfclk * 2

/* plus  skew set to 40% of tmskew - for hold checks  */
tpskew = tmskew * 0.40

/* subtract tmskew for half clock from half clock period */
tclkh = tclkh - tmskewforhalfclk

/* Define over-constraining margin */
oc_margin = 0.05

/* If the synthesis needs to be performed with an over-constrained clock set  */
/* this parameter to a non-zero value. For example if oc_margin is set to 0.5,*/
/* the clock period will be reduced by 1.0 ns.                                */

/* Note that the phase is reduced (over-constrained) by 'oc_margin' */
tclkh = tclkh - oc_margin

/* tclk definition is done along with other AHB timing constraint settings in */
/* the amba_params.scr file                                                   */

/******************************************************************************/
/* AHB TIMING CONSTRAINTS                                                     */
/******************************************************************************/
/* amba_params.scr defines the AHB timing parameters */
include scr_common_area + "/amba_params.scr"

/* ahb_slave.scr defines the AHB timing constraints using the above */
include scr_common_area + "/ahb_slave.scr"

/******************************************************************************/
/* RESET SIGNAL CONSTRAINTS                                                   */
/******************************************************************************/

/* Constraining AHB reset signal HRESETn */
set_input_delay -clock HCLK -max tidmaxresetn HRESETn
set_input_delay -clock HCLK -min tidminresetn HRESETn

/* Infinite drive strength reset signal */
set_drive 0 HRESETn

/* Zero load reset signal */
set_load 0 HRESETn

/* Set no driving cell on reset */
remove_driving_cell find(port, HRESETn)

/* Zero resistance for zero net delay(interconnect delay) on ideal reset net  */
set_resistance 0 find(net, HRESETn)

/* Preserve the reset net during optimisation */
set_dont_touch_network find(port, HRESETn)

/******************************************************************************/
/* NON-AMBA INPUT / OUTPUT PORT CONSTRAINTS                                   */
/******************************************************************************/
/* Vic.scr defines the input and output delay constraints for the block */
include scripts/Vic.scr

/* Check whether timing parameters are valid.           */
/* Unconstrained ports, gated clocks etc. are reported. */
echo                >> run_time_log
echo "check_timing" >> run_time_log
echo "============" >> run_time_log
echo                >> run_time_log
check_timing        >> run_time_log

/* Vic_exceptions.scr defines the point-to-point exceptions set on the VIC    */
/* block. These may be false_paths or multicycle_paths                        */
include scripts/Vic_exceptions.scr 

/* Check whether timing parameters are valid.           */
/* Unconstrained ports, gated clocks etc. are reported. */
echo                >> run_time_log 
echo "check_timing" >> run_time_log
echo "============" >> run_time_log 
echo                >> run_time_log
check_timing        >> run_time_log 

current_design = topname

/******************************************************************************/
/* Setup and Hold fixing                                                      */
/******************************************************************************/
 
/* Fix minimum timing violations */
set_fix_hold all_clocks()

set_critical_range 0.5 topname

/******************************************************************************/
/* COMPILE                                                                    */
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

current_design = topname

/************************/
/* Scan Ready Synthesis */
/************************/
if (test_req == scanready) {

  /* script to acquire Test-Compiler */
  remove_license Test-Compiler
  get_license Test-Compiler
  while (dc_shell_status == 0)
  {
    sh sleep 30;
    get_license Test-Compiler
  }

  /* Do not route the scan chain for the scanready compile */
  set_scan_configuration -route false

  /* Compile with scan using high CPU effort for mapping of design */
  /* This compile performs scan replacement              */
  compile -scan -map_effort high

  /* Compile with incremental effort */
  compile -scan -map_effort high -inc 

}

/*************************/
/* Scan Insert Synthesis */
/*************************/
if (test_req == scaninsert) {

  /* script to acquire Test-Compiler */
  remove_license Test-Compiler
  get_license Test-Compiler
  while (dc_shell_status == 0)
  {
    sh sleep 30;
    get_license Test-Compiler
  }

  /* Route the scan chain for the scaninsert compile */
  set_scan_configuration -route true

  /* Compile with scan using high CPU effort for mapping of design */
  /* This compile performs scan replacement                        */
  compile -scan -map_effort high

  /* Compile with incremental effort */
  compile -scan -map_effort high -inc 

  /* Perform Scan Insertion */
  include scripts/Vic_scan.cmd

}

if (test_req == noscan) {
/********************/
/* No scan synthesis*/
/********************/

  /* Compile using high CPU effort for mapping of design */
  /* This compile does NOT perform scan replacement      */
  compile -map_effort high

  /* Compile with incremental effort */
  compile -map_effort high -inc 
}
 
/******************************************************************************/
/* NON-AMBA INPUT / OUTPUT PORT CONSTRAINTS                                   */
/******************************************************************************/
/* Vic.scr defines the input and output delay constraints for the block */
include scripts/Vic.scr

/* Check whether timing parameters are valid.           */
/* Unconstrained ports, gated clocks etc. are reported. */
echo                >> run_time_log
echo "check_timing" >> run_time_log
echo "============" >> run_time_log
echo                >> run_time_log
check_timing        >> run_time_log

/* Vic_exceptions.scr defines the point-to-point exceptions set on the Vic    */
/* block. These may be false_paths or multicycle_paths                        */
include scripts/Vic_exceptions.scr

/* Check whether timing parameters are valid.           */
/* Unconstrained ports, gated clocks etc. are reported. */
echo                >> run_time_log
echo "check_timing" >> run_time_log
echo "============" >> run_time_log
echo                >> run_time_log
check_timing        >> run_time_log

current_design = topname

/******************************************************************************/
/* APPLY CONSTRAINTS AT CORRECT FREQUENCY - REMOVING OVERCONSTRAINING         */
/******************************************************************************/
/* Restore clock period to reflect actual target frequency */

/* Define Clock phase time 3.0 ns (166 MHz) */ 
tclkh = 3.0

tclkh = tclkh - tmskewforhalfclk

/* Restore clock period to reflect actual target frequency */
oc_margin = 0.0

/* If the synthesis needs to be performed with an over-constrained clock set  */
/* this parameter to a non-zero value. For example if oc_margin is set to 0.5,*/
/* the clock period will be reduced by 1.0 ns.                                */

tclkh = tclkh - oc_margin

/******************************************************************************/
/* AMBA SIGNAL CONSTRAINTS                                                    */
/******************************************************************************/
/* amba_params.scr defines the AHB timing parameters */
include scr_common_area + "/amba_params.scr"

/* ahb_slave.scr defines the AHB timing constraints using the above */
include scr_common_area + "/ahb_slave.scr"

/******************************************************************************/
/* NON-AMBA INPUT / OUTPUT PORT CONSTRAINTS                                   */
/******************************************************************************/
/* Vic.scr defines the input and output delay constraints for the block */
include scripts/Vic.scr

/* Vic_exceptions.scr defines the point-to-point exceptions set on the VIC    */
/* block. These may be false_paths or multicycle_paths                        */
include scripts/Vic_exceptions.scr 

/* Set the name for report directory                               */
report_name_base = "report/" + topname + "_" + test_req + "_" + hdl + \
  "_" + hdl_out
 
/* Check for any test problems */
if (test_req == scanready) {
  echo              >> run_time_log
  echo "check_test" >> run_time_log
  echo "==========" >> run_time_log
  echo              >> run_time_log
  check_test        >> run_time_log
} else if (test_req == scaninsert) {
  /* Insert scan if required */
  include scripts/Vic_scan.cmd
}

if ((test_req == noscan) || (test_req == scanready)) {

/* Perform a design rule only compile to fix design rule violations and other */
/* parameters like max_capacitance, max_transition etc.                       */
compile -only_design_rule

/* resistance constraints set on nets could have been lost following the      */
/* design_rule compile. Restore them before generating the the final netlist  */
/* and SDF file.                                                              */
set_resistance 0 HRESETn
set_drive 0 HRESETn

}

/******************************************************************************/
/* GENERATE VIOLATION REPORT                                                  */
/******************************************************************************/

/* Output a detailed constraints report listing all violations in descending  */
/* order, written to the report area.                                         */
report_constraint -verbose -all_violators > report_name_base + ".vio"

/******************************************************************************/
/* GENERATE TIMING REPORTS                                                    */
/******************************************************************************/

/* Output a maximum delay timing report for upto 100 paths, with upto 10 paths*/
/* per endpoint, written to the report area.                                  */
report_timing -delay max -path full -max_paths 100 -nworst 10 \
  > report_name_base + ".max"

/* Output a minimum delay timing report for upto 100 paths, with upto 10 paths*/
/* per endpoint, written to the report area.                                  */
report_timing -delay min -path full -max_paths 100 -nworst 10 \
  > report_name_base + ".min"

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

/* 'report_design' displays information about the current design and its      */
/* environment. It lists out the library used, operating conditions, wireload */
/* models used etc.                                                           */
report_design > report_name_base + ".constr"

/* 'report_constraint' displays constraint-related information about the      */
/* current design                                                             */
report_constraint >> report_name_base + ".constr"

/* 'report_clock' provides a summary of all the defined clocks, their period  */
/* waveform and any attributes set on them.                                   */
report_clock >> report_name_base + ".constr" 

/* 'report_attribute' reports attribute related to the design */
report_attribute -design  >> report_name_base + ".constr"

/* Report information about ports of design */
report_port -verbose  >> report_name_base + ".ports"

/* Report the Clock Tree information to check if any buffers present */
report_transitive_fanout -clock_tree -nosplit > report_name_base + ".clocktree"

/* Report the Reset Tree information to check if any buffers present */
report_transitive_fanout -from HRESETn -nosplit > report_name_base +\
                                                  ".resettree"

/* 'report_hierarchy' lists out the cells used in the design hierarchically. */
report_hierarchy > report_name_base + ".hier"

/******************************************************************************/
/* GENERATE LATCH REPORTS                                                     */
/******************************************************************************/

/* Check for inferred latches */ 
echo " CHECK FOR LATCHES " > report_name_base + ".latch"
all_registers -level_sensitive 
list dc_shell_status >> report_name_base + ".latch"

/******************************************************************************/
/* GENERATE COMBINATIONAL LOOP REPORTS                                        */
/******************************************************************************/
echo " CHECK FOR COMBINATIONAL LOOPS " >> report_name_base + ".latch"

/* Check for combinational loops */ 
report_timing -loops >> report_name_base + ".latch"

/* The report files should contain no violations or errors and ideally zero   */
/* or a minimal number of warnings                                            */

/******************************************************************************/
/* ACQUIRE HDL COMPILER                                                       */
/******************************************************************************/
/* Acquire V/HDL-Compiler just before netlist write-out                       */
/* Note: the initial remove_license is needed even though it looks redundant. */
/* This is to account for cases where the V/HDL-Compiler is automatically     */
/* checked out during the compile phase.                                      */

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
/* Apply change_names to avoid naming problems in design flow, refer to       */
/* Solvit note METH-148274.html                                               */

/* Naming rules are defined in the name_rules.scr file residing in            */
/* scr_common_area. If any alternate naming rules are to be defined please    */
/* include them in the name_rules.scr file.                                   */

if (hdl_out == vhdl) {
  change_names -rule "NAMING_RULES_VHDL" -hierarchy
  change_names -rules SPECIAL_VHDL -hierarchy
} else if (hdl_out == verilog) {
  change_names -rule "NAMING_RULES_VLOG" -hierarchy
  change_names -rules COLLAPSE -hierarchy
}

/******************************************************************************/
/* GENERATE GATE-LEVEL NETLIST AND SDF TIMING FILE                            */
/******************************************************************************/

/* Note that the netlist and the sdf generation is controlled by the 'hdl'    */
/* and 'hdl_out' variables.                                                   */

/* From SynopsysVersion 1998.02 onwards, both best case and worst case timing */
/* values are written out into the same sdf file.                             */

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

/* v2.1 SDF output format is produced                                         */

/******************************************************************************/
/* WRITE SYNTHESIS RUN END TIME                                               */
/******************************************************************************/

echo -n "END TIME   -> "         >> run_time_log
sh date                          >> run_time_log
echo "=========================" >> run_time_log 
echo                             >> run_time_log

quit

/************************** End of Vic.cmd ************************************/
