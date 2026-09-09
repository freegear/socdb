/*------------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : sdram_scan.cmd,v
--  File Revision          : 1.2
--  
--  Release Information    : PrimeCell(TM)-PL170-REL2v2
--  
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Purpose : Synopsys scan-insertion synthesis master compile script
--           for the SDRAMC block.
--
--           Located in the synopsys_ref/scr_scan directory.
--
--           This file specifies the order in which commands
--           are executed and it is written to use shell mode.
--
--           This file uses several other script files.
--
--           This file can be configured to synthesise either
--           VHDL or Verilog source, and output files in either,
--           VHDL or Verilog format.
--
--           Source files are analysed, the design elaborated,
--           constraints applied, design compiled and then the
--           netlist and timing file generated.
--
------------------------------------------------------------------------------*/

/******************************************************************************/
/* CLEAN THE WORK AREA JUST TO AVOID PROBLEMS...                              */
/******************************************************************************/
/* Enable this only if you don't intend to run another synopsys process from
   the same directory. */
 
/* sh rm -f work/* */
 
/******************************************************************************/
/* SELECT SYNTHESIS WITH INPUT AND OUTPUT FORMATS IN VHDL OR VERILOG          */
/******************************************************************************/
 
/* set variable hdl,     to vhdl for VHDL or verilog for Verilog RTL input */
/* set variable hdl_out, to vhdl for VHDL output format, verilog for Verilog,
                         or both for both VHDL and Verilog output formats */
 
hdl     = get_unix_variable("HDL_IN")
hdl_out = get_unix_variable("HDL_OUT")
 
 
/* Uncomment the following to replace the use of environment variables above,
   which determine input and output format selected for synthesis */
/*
hdl = vhdl
hdl_out = vhdl
*/
 
/******************************************************************************/
/* SELECT SCAN INSERTION                                                      */
/******************************************************************************/
/*
 ScanTest = get_unix_variable("SCANTEST")
*/
 
ScanTest = 1
/* 0: no,  1: yes, to scan insert the SDRAMC */
 
if (ScanTest == 1) {
  stype = "_scan"
} else {
  stype = ""
}
 
/******************************************************************************/
/* WRITE SYNTHESIS RUN START TIME                                             */
/******************************************************************************/
run_time_file = "synth_run_time" + stype + "_" + hdl + ".time"
 
echo "SDRAMC SYNTHESIS TIME LOG" > run_time_file
echo "======================" >> run_time_file
echo >> run_time_file
echo -n "START TIME -> " >> run_time_file
sh date >> run_time_file
echo >> run_time_file

/******************************************************************************/
/* SET DESIGN_ROOT TO THE CORRECT PATH BEFORE SYNTHESIS                       */
/******************************************************************************/
 
design_root = get_unix_variable("PERIPH")
/* Specify the top level module name */
 
/* Alternatively, define an absolute path. REPLACE THIS WITH YOUR OWN PATH   */
/* design_root = /home/nbray/work/tryfan/sdram_pl170 */
 
/******************************************************************************/
/* DEFINE DIRECTORY STRUCTURE, REFERENCED TO DESIGN_ROOT                      */
/******************************************************************************/
 
synth_root             = design_root + /synopsys_ref
 
vhdl_area              = design_root + /vhdl/uut
verilog_area           = design_root + /verilog/uut
 
scr_common_area        = synth_root + /scr_common
scr_sdram_area         = synth_root + /scr_sdram
scr_scan_area          = synth_root + /scr_scan
 
analyzed_area          = synth_root + /work
library_area           = synth_root + /cell_lib
db_area                = synth_root + /db
log_area               = synth_root + /log
netlist_area           = synth_root + /netlist
rpt_area               = synth_root + /report
 
/* Create link(s) in library_area to point to cell library */
 
/******************************************************************************/
/* DEFINE SEARCH PATHS                                                        */
/******************************************************************************/
search_path = search_path + vhdl_area
search_path = search_path + verilog_area
search_path = search_path + scr_common_area
search_path = search_path + scr_sdram_area
search_path = search_path + scr_scan_area
search_path = search_path + analyzed_area
search_path = search_path + library_area
search_path = search_path + db_area
search_path = search_path + log_area
search_path = search_path + netlist_area
search_path = search_path + rpt_area
 
/******************************************************************************/
/* DEFINE LOCATION OF INTERMEDIATE FILES                                      */
/******************************************************************************/
 
/* Define the directory containing intermediate files generated by Synopsys */
define_design_lib work -path analyzed_area

/******************************************************************************/
/* INCLUDE LIBRARY/PROJECT-SPECIFIC SETUP FILE                                */
/******************************************************************************/
 
include setup.scr
/* EDIT THE ABOVE FILE TO RE-DEFINE YOUR SYNOPSYS CACHE LOCATION. */
 
/* setup.scr defines library/project-specific setup */
/* and anything else which is not specific to this block, including */
/* cell library paths, synopsys cache, */
/* and Synopsys version dependent tool setup commands. */
 
/******************************************************************************/
/* READ IN COMPILED DB FILE OF THE DESIGN                                     */
/******************************************************************************/
 
topname =  Sdram
/* specify the top-level module name */
 
read -format db topname + "_" + hdl + ".db"
 
/*****************************************************************************/
/* NOW RESET DESIGN AND READ IN FRESH CONSTRAINTS                            */
/*****************************************************************************/
 
reset_design
/* Removes from the current_design all user-specified objects and */
/* attributes, except those defined using set_attribute. */

/******************************************************************************/
/* APPLY CONSTRAINTS                                                          */
/******************************************************************************/
 
current_design = topname
 
include global.scr
/* global.scr defines the environmental conditions */
/* for worst/best case library conditions and */
/* define default cell load and drive strength. */
 
oc_margin = 1.0
/* clock period restored to the 100 Mhz target by setting the */
/* over-constraining margin to 0.0                            */
 
include ahb_params.scr
/* ahb_params.scr defines the AMBA AHB timing parameters */
 
include ahb_slave.scr
/* ahb_slave.scr defines the AMBA AHB timing constraints using the above */
 
include sdram.scr
/* sdram.scr defines the input and output delay constraints for the block */
 
set_max_transition 2.0 topname
/* Set maximum transition for all nets in design,
   to simplify buffering at chip-level. */
 
check_timing
/* Check timing parameters are valid */
 
set_max_area 0.0
/* set maximum area to zero so that design is optimised for mimimum area */
 
/* Worst case and best case operating conditions are defined in global.scr */
current_design = topname
 
/* Wire load model variables from cell library */
 
/* If using manual wire load selection, enter model names below */
/* according to the size of design */
 
WL_MOD = "140000"
WL_MOD_MAX = "140000"
 
WL_MOD_MIN = "ForQA"
 
set_wire_load_mode enclosed
/* wire load model enclosed is less pessimistic than top */
 
/* To disable automatic wire load selection, set the following command false */
auto_wire_load_selection = "true";
 
set_wire_load_model -library MAX_TECH_LIB_NAME -name WL_MOD_MAX -max
/* Set the wire load model to be used for maximum delay analysis */
 
set_wire_load_model -library MAX_TECH_LIB_NAME -name WL_MOD_MIN -min
/* Set the wire load model to be used for minimum delay analysis */
 
/* Synopsys DC prior to 1999.05 used the following command syntax */
/* set_wire_load -mode top -max "140000" */
/* set_wire_load -min "ForQA" */
 
set_fix_multiple_port_nets -all -buffer_constants
/* Prevent feedthroughs, multiple output ports from same net, */
/* or constants driving more than one output port */
 
/******************************************************************************/
/* SCAN INSERT                                                                */
/******************************************************************************/
 
include cb25scandontuse.scr
/* Include list of library cells that should  be used for scan insertion */
 
current_design = topname
 
/* Flatten DesignWare hierarchy as per Solvit note Synthesis-173.html,
   to avoid SDF/netlist problems. */
foreach(design_name,find(design,"*")) {
   current_design = design_name
   dw_cell_list = filter(find(cell,"*"),"@is_synlib_operator==true || \
                  @is_dw_subblock==true || @is_synlib_module==true ") > /dev/null
   if ( dc_shell_status != {} ) {
        echo "Info: Found some DW hierarchy in " + design_name + ". Ungrouping..."
        ungroup -flatten dw_cell_list -simple
   }
}
remove_variable dw_cell_list
 
current_design = topname
 
test_default_scan_style = multiplexed_flip_flop
 
set_scan_configuration -style multiplexed_flip_flop
/* Multiplexed Flip Flop is used as the scan cell */
 
set_scan_configuration -methodology full_scan
/* Full Scan Methodology */
 
set_scan_configuration -clock_mixing no_mix
/* Indiviual scan chains for each clock domain */
 
set_scan_configuration -replace true
/* Replace all flip flops with their equivalent scan cells */
 
set_scan_configuration -add_lockup false
/* No lockup latches required when no clock mixing in scan chain */
 
set_scan_configuration -dedicated_scan_ports true
/* Every scan chain has a dedicated output port for the scan out signals */
 
create_test_clock -period 100 -waveform {45 55} find(port,"HCLK")
create_test_clock -period 100 -waveform {45 55} find(port,"CLKIn")
/* Test clock defined with period 100 ns, Test-Compiler's default value */

set_scan_signal test_scan_enable -port SCANENABLE
set_scan_signal test_scan_in     -port SCANIN
set_scan_signal test_scan_out    -port SCANOUT
/* Assign scan signals to existing scan test ports */
 
set_scan_configuration -existing_scan false
/* There is no existing scan logic. */
 
set_scan_configuration -route true
/* All scan related signals (scan in , scan out, scan enable */
/* and scan clocks ) to be routed. */
 
/* Scan chain with dedicated scanout ports. */
set_scan_path ChainHCLK all_registers (-clock HCLK) \
  -dedicated_scan_out true

set_scan_path ChainCLKIn all_registers (-clock CLKIn) \
  -dedicated_scan_out true
 
current_design = topname
/* If modified test protocol file created, read it in here. */
/*
 read_init_protocol rpt_area + "/" + topname + stype + "_" + hdl \
   + "_default.tpf"
*/
/*read_init_protocol sdram.tpf */
/* Read in the init. protocol to set the init. signal values */
 
/* Uncomment the following to debug errors reported during */
/* test rule check                                         */

if (hdl == verilog) {
  /* trace_nets { HCLK HRESETn HSELreg HSELmem HWRITE } */
  /* State the nets for test protocol tracing */
} else if (hdl == vhdl) {
  /* trace_nets { HCLK HRESETn HSELreg HSELmem HWRITE } */
  /* State the nets for test protocol tracing */
}
 
/* Use compile -scan if read RTL, insert_scan if read db file. */
/* compile -scan */
/* Insert scan cells and optimise scan structure */
 
check_test -verbose > rpt_area + "/" + topname + stype + "_" + hdl \
  + "_prescan_check_test_rules.rpt"
/* Test rule checking */
 
/* Generate preview scan report */
preview_scan -script > rpt_area + "/" + topname + stype + "_" + hdl \
  + "_preview_scr" + ".rpt"
preview_scan -show all > rpt_area + "/" + topname + stype + "_" + hdl \
  + "_preview_all" + ".rpt"
 
check_design
/* Design rule checking */
 
/******************************************************************************/
/* SAVE THE DATABASE IN SYNOPSYS .DB FORMAT                                   */
/******************************************************************************/
 
current_design = topname
write -format db -hier \
  -out db_area + "/" + topname + stype + "_prescan" + "_" + hdl + ".db"
 
insert_scan -map_effort medium
/* Connect scan cells and optimise scan structure */
 
/******************************************************************************/
/* SAVE THE DATABASE IN SYNOPSYS .DB FORMAT                                   */
/******************************************************************************/
 
current_design = topname
write -format db -hier \
  -out db_area + "/" + topname + stype + "_postscan" + "_" + hdl + ".db"
 
set_input_delay -clock HCLK -min 0.2 SCANENABLE
 
set_input_delay -clock HCLK -min 0.2 SCANIN
set_input_delay -clock HCLK -min 0.2 find(port,"test_si*");
 
set_drive 0 SCANENABLE
 
set_fix_hold all_clocks()
compile -only_design_rule
/* Perform a design rule only compile to fix design rule violations and other */
/* parameters like max_capacitance, max_transition etc. */
 
set_resistance 0 SCANENABLE
set_drive 0 SCANENABLE
 
/******************************************************************************/
/* SAVE THE DATABASE IN SYNOPSYS .DB FORMAT                                   */
/******************************************************************************/
 
current_design = topname
write -format db -hier \
  -out db_area + "/" + topname + stype + "_scanfixed" + "_" + hdl + ".db"
 
/******************************************************************************/
/* GENERATE SCAN REPORTS                                                      */
/******************************************************************************/
current_design = topname
 
/* Create test insertion report for each design (test rule check) */
/* or */
/* Create test insertion report for Sdramc design (test rule check) */
check_test -verbose > rpt_area + "/" + topname + stype + "_" \
  + hdl + "_check_test_rules.rpt"
 
create_test_patterns -dft -sample 11 -no_compaction -backtrack_effort high \
  -output rpt_area + "/" + topname + stype + "_" + hdl + "_patterns" \
  > rpt_area + "/" + topname + stype + "_" + hdl + "_fault_coverage.rpt"
/* Sample of 11% faults targeted estimates fault coverage within 1-2% */
/* and reduces run time, if not accurate enough run full sample set below. */
/*
create_test_patterns -backtrack_effort high \
  -output rpt_area + "/" + topname + stype + "_" + hdl + "_patterns" \
  > rpt_area + "/" + topname + stype + "_" + hdl + "_fault_coverage.rpt"
*/
 
/* uncomment the following to create the vectors, need Test_Sim license */
/*
fault_simulate \
  -input rpt_area + "/" + topname + stype + "_" \
    + hdl + "_patterns.vdb" \
  -output rpt_area + "/" + topname + stype + "_" + hdl + "_output_patterns" \
  -eval_probables keep \
  -format tds \
  -report_contention true \
  -report_float true \
  -save_testsim_model rpt_area + "/" + topname + stype + "_" \
    + hdl + "_testsim_model.db" \
    > rpt_area + "/" + topname + stype + "_" + hdl + "_fault_simulate.rpt"
 
fault_simulate \
  -input rpt_area + "/" + topname + stype + "_" \
    + hdl + "_patterns.vdb" \
  -output rpt_area + "/" + topname + stype + "_" \
    + hdl + "_output_patterns" \
  -eval_probables keep \
  -format wgl
*/
 
current_design = topname
 
write_test_protocol -out rpt_area + "/" + topname + stype + "_" + hdl \
  + "_default.tpf"
/* Write out a default test protocol */
 
write_script -hierarchy -full_path_lib_names > rpt_area + "/" + topname \
  + stype + "_" + hdl + "_write_script.rpt"
/* Create scripted attributes, constraints, etc.
   for all designs in hierarchy, for possible future use. */
 
report_test -port \
  > rpt_area + "/" + topname + stype + "_" + hdl + "_test" + ".rpt"
/* Report test ports */
report_test -assertions \
  >> rpt_area + "/" + topname + stype + "_" + hdl + "_test" + ".rpt"
/* Report all test assertions, set_test_hold, etc */
report_test -atpg_conflicts \
  >> rpt_area + "/" + topname + stype + "_" + hdl + "_test" + ".rpt"
/* Report ATPG conflicts */
report_test -configuration \
  >> rpt_area + "/" + topname + stype + "_" + hdl + "_test" + ".rpt"
/* Report test configuration */
report_test -constraints \
  >> rpt_area + "/" + topname + stype + "_" + hdl + "_test" + ".rpt"
/* Report test constraints if any */
report_test -coverage \
  >> rpt_area + "/" + topname + stype + "_" + hdl + "_test" + ".rpt"
/* Report test coverage */
 
report_test -faults \
  >> rpt_area + "/" + topname + stype + "_" + hdl + "_test" + ".rpt"
 
/* Report faults (debug only) */
report_test -trace_nets \
  >> rpt_area + "/" + topname + stype + "_" + hdl + "_test" + ".rpt"
/* Report nets being traced (debug only) */
report_test -methodology \
  >> rpt_area + "/" + topname + stype + "_" + hdl + "_test" + ".rpt"
/* Report test methodology */
report_test -state \
  >> rpt_area + "/" + topname + stype + "_" + hdl + "_test" + ".rpt"
/* Report scan status of current design */
report_test -scan_path \
  >> rpt_area + "/" + topname + stype + "_" + hdl + "_test" + ".rpt"
/* List cells on each scan chain */
report_test -testsim_timing \
  >> rpt_area + "/" + topname + stype + "_" + hdl + "_test" + ".rpt"
/* Report test timing for fault simulation */
 
current_design = topname
/* set_operating_conditions "WCCOM" */
 
/*****************************************************************************/
/* GENERATE TIMING REPORTS                                                   */
/*****************************************************************************/
 
current_design = topname
 
oc_margin = - 0.5
/* clock period restored to the 90 Mhz target by setting the  */
/* over-constraining margin to -0.5                           */
 
include ahb_params.scr
/* ahb_params.scr defines the AHB timing parameters */
 
include ahb_slave.scr
/* ahb_slave.scr defines the AHB timing constraints using the above */
 
include sdram.scr
/* sdram.scr defines the input and output delay constraints for the block */
 
report_timing -delay max -path full  -max_paths 100 -nworst 10 \
  > rpt_area + "/" + topname + stype + "_" + hdl + ".max"
/* Output a maximum delay timing report for upto 100 paths, */
/* with upto 10 paths per endpoint, written to the report area. */
 
report_timing -delay min -path full -max_paths 100 -nworst 10 \
  > rpt_area + "/" + topname + stype + "_" + hdl + ".min"
/* Output a minimum delay timing report for upto 100 paths, */
/* with upto 10 paths per endpoint, written to the report area. */
 
report_constraint -verbose -all_violators \
 > rpt_area + "/" + topname + stype + "_" + hdl + ".vio"
/* Output a detailed constraints report listing all violations */
/* in descending order, written to the report area. */
 
/* Create area reports of the current design modules */
current_design = topname
echo " AREA REPORT FOR DESIGN : " + current_design > rpt_area + "/" \
  + topname + stype + "_" + hdl + "_area.rpt"
foreach (design_name,find("design","*")){
  current_design = design_name
  echo "    " >> rpt_area + "/" + topname + stype + "_" + hdl + "_area.rpt"
  report_area >> rpt_area + "/" + topname + stype + "_" + hdl + "_area.rpt"
}
 
current_design = topname
 
report_port -verbose \
  > rpt_area + "/" + topname + stype + "_" + hdl + "_ports" + ".rpt"
/* Report information about ports of design */
 
/*****************************************************************************/
/* GENERATE DESIGN REPORTS                                                   */
/*****************************************************************************/
current_design = topname
 
check_design      >  rpt_area + "/" + topname + stype + "_" + hdl + ".rpt"
/* 'check_design' checks the internal representation of the current design   */
/* for consistency and issues error and warning messages as appropriate.     */
/* It flags conditions like unconnected pins, cells not driving any nets,    */
/* pins with no loads, nets without drivers, nets with multiple drivers etc. */
 
/* The user should examine the output of 'check_design' and ensure that all  */
/* the warnings are acceptable / explainable.                                */
 
check_timing      >> rpt_area + "/" + topname + stype + "_" + hdl + ".rpt"
/* 'check_timing' checks for possible timing problems in the current design  */
/* It flags conditions like end-points not being constrained for max delay,  */
/* presence of gated clocks etc.                                             */
 
report_cell       >> rpt_area + "/" + topname + stype + "_" + hdl + ".rpt"
/* 'report_cell' provides information about all cells in the current design  */
 
report_reference  >> rpt_area + "/" + topname + stype + "_" + hdl + ".rpt"
/* 'report_reference' provides information about all cell references in the  */
/* current design                                                            */
 
report_design     >> rpt_area + "/" + topname + stype + "_" + hdl + ".rpt"
/* 'report_design' displays information about the current design and its     */
/* environment. It lists out the library used, operating conditions,         */
/* wireload models used etc.                                                 */
 
report_hierarchy  >> rpt_area + "/" + topname + stype + "_" + hdl + ".rpt"
/* 'report_hierarchy' lists out the cells used in the design hierarchically. */
 
report_area       >> rpt_area + "/" + topname + stype + "_" + hdl + ".rpt"
/* 'report_area' provides the area of the design in standard area units.     */
/* The standard area unit will the area of a representative gate (eg: drive1 */
/* inverter or buffer) within the chosen technology.                         */
 
report_clock      >> rpt_area + "/" + topname + stype + "_" + hdl + ".rpt"
/* 'report_clock' provides a summary of all the defined clocks, their period */
/* waveform and any attributes set on them.                                  */
 
/*****************************************************************************/
/* GENERATE CHECK REPORT                                                     */
/*****************************************************************************/
 
echo "CHECK FOR LATCHES " \
  > rpt_area + "/" + topname + stype + "_" + hdl + "_check" + ".rpt"
all_registers -level_sensitive \
  >> rpt_area + "/" + topname + stype + "_" + hdl + "_check" + ".rpt"
/* Check no latches inferred */
 
echo "CHECK FOR COMBINATIONAL LOOPS " \
  >> rpt_area + "/" + topname + stype + "_" + hdl + "_check" + ".rpt"
report_timing -loops \
  >> rpt_area + "/" + topname + stype + "_" + hdl + "_check" + ".rpt"
/* Check no combinational loops present */
 
/* The report files should contain no violations, or errors, */
/* and ideally zero or a minimal number of warnings.         */
 
/* script to acquire V/HDL-Compiler just before netlist write-out            */
/* Note: the initial remove_license is needed even though it looks redundant */
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
write -format db -hier -out db_area + "/" + topname + stype + "_" + hdl + ".db"
 
/******************************************************************************/
/* APPLY NAMING RULES                                                         */
/******************************************************************************/
 
/* Apply change_names to avoid naming problems in design flow,
   refer to Solvit note METH-148274.html */
if (hdl == vhdl) {
  change_names -rule "CB25CAD_VHDL" -hierarchy
  change_names -rules SPECIAL_VHDL -hierarchy
} else if (hdl == verilog) {
/*
  change_names -rule "CB25CAD_VLOG" -hierarchy
  change_names -rules COLLAPSE -hierarchy
*/
}
 
/*****************************************************************************/
/* GENERATE GATE-LEVEL NETLIST AND SDF TIMING FILE                           */
/*****************************************************************************/
 
/* Note that the netlist and the sdf generation is controlled by the 'hdl', */
/* and 'hdl_out' variables. */
 
/* SynopsysVersion 1998.02 onwards, both best case and worst case timing */
/* values are written out into the same sdf file. */
 
if (hdl_out == vhdl) {
  /*** VHDL OUTPUT FORMAT ***/
  current_design = topname
  if (hdl == vhdl) {
    vhdlout_preserve_hierarchical_types = user
    /*** VHDL OUTPUT FORMAT FROM VHDL RTL SOURCE ***/
    write -format vhdl -hier -out netlist_area + "/" + topname + stype \
      + "_net.vhd"
    write_sdf -version 2.1 \
      netlist_area + "/" + topname + stype + "_Vhdl.sdf21"
  } else if (hdl == verilog) {
    /*** VHDL OUTPUT FORMAT BUT FROM VERILOG RTL SOURCE ***/
    write -format vhdl -hier \
      -out netlist_area + "/" + topname + stype + "_FromVerilogToVhdl_net.vhd"
    write_sdf -version 2.1 \
      netlist_area + "/" + topname + stype + "_FromVerilogToVhdl.sdf21"
  }
} else if (hdl_out == verilog) {
  /*** VERILOG OUTPUT FORMAT ***/
  current_design = topname
  if (hdl == verilog) {
    /*** VERILOG OUTPUT FORMAT FROM VERILOG RTL SOURCE ***/
    write -format verilog -hier -out netlist_area + "/" + topname + stype \
      + "_net.v"
    write_sdf -version 2.1 \
      netlist_area + "/" + topname + stype + "_Verilog.sdf21"
  } else if (hdl == vhdl) {
    /*** VERILOG OUTPUT FORMAT BUT FROM VHDL RTL SOURCE ***/
    write -format verilog -hier \
      -out netlist_area + "/" + topname + stype + "_FromVhdlToVerilog_net.v"
    write_sdf -version 2.1 \
      netlist_area + "/" + topname + stype + "_FromVhdlToVerilog.sdf21"
  }
}
/* Synopsys 1999.05 write_sdf supersedes write_timing */
/* Pre-1999.05 command syntax shown below */
/*    write_timing -format sdf-v2.1 -context vhdl \ */
/*      -out netlist_area + "/" + topname + stype + "_Vhdl.sdf21" */
 
/* v2.1 SDF output format produced */
 
/*****************************************************************************/
/* WRITE SYNTHESIS RUN END TIME                                              */
/*****************************************************************************/
 
echo -n "END TIME   -> " >> run_time_file
sh date >> run_time_file
echo "=========================" >> run_time_file
echo >> run_time_file
 
quit
 
/*************************** End of sdram_scan.cmd ***************************/
