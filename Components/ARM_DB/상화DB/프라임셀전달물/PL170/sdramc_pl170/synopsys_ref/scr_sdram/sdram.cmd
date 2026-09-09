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
--  File Name              : sdram.cmd,v
--  File Revision          : 1.8
--  
--  Release Information    : PrimeCell(TM)-PL170-REL2v2
--  
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Purpose : Synopsys synthesis master compile script
--           for the SDRAMC block.                                  
--
--           Located in the synopsys_ref/scr_sdram directory.        
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
--           Source files are analysed, the design elaborated,   
--           constraints applied, design compiled and then the  
--           netlist and timing file generated.                
--
------------------------------------------------------------------------------*/

/*****************************************************************************/
/* SELECT SYNTHESIS WITH INPUT AND OUTPUT FORMATS IN VHDL OR VERILOG         */
/*****************************************************************************/

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

stype = ""
/* Set null string for stype report naming naming option, for future use */

/*****************************************************************************/
/* WRITE SYNTHESIS RUN START TIME                                            */
/*****************************************************************************/
run_time_file = "synth_run_time" + "_" + hdl + ".time"

echo "SDRAMC SYNTHESIS TIME LOG" > run_time_file
echo "=========================" >> run_time_file 
echo >> run_time_file
echo -n "START TIME -> " >> run_time_file
sh date >> run_time_file
echo >> run_time_file

/*****************************************************************************/
/* SET DESIGN_ROOT TO THE CORRECT PATH BEFORE SYNTHESIS                      */
/*****************************************************************************/

design_root = get_unix_variable("PERIPH")

/* Alternatively, define an absolute path. REPLACE THIS WITH YOUR OWN PATH   */
/* design_root = /home/nbray/work/tryfan/sdram_pl170 */

/*****************************************************************************/
/* DEFINE DIRECTORY STRUCTURE, REFERENCED TO DESIGN_ROOT                     */
/*****************************************************************************/

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

/* Create link in library_area to point to cell library */

/*****************************************************************************/
/* DEFINE SEARCH PATHS                                                       */
/*****************************************************************************/

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

/*****************************************************************************/
/* DEFINE LOCATION OF INTERMEDIATE FILES                                     */
/*****************************************************************************/

/* Define the directory containing intermediate files generated by Synopsys */

define_design_lib work -path analyzed_area

/*****************************************************************************/
/* INCLUDE LIBRARY/PROJECT-SPECIFIC SETUP FILE                               */
/*****************************************************************************/

include setup.scr
/* EDIT THE ABOVE FILE TO RE-DEFINE YOUR SYNOPSYS CACHE LOCATION. */

/* setup.scr defines library/project-specific setup                 */
/* and anything else which is not specific to this block, including */
/* cell library paths, synopsys cache, 'don't use cells',           */
/* and Synopsys version dependent tool setup commands.              */

/*****************************************************************************/
/* DEFINE LIST OF SOURCE RTL FILES                                           */
/*****************************************************************************/
 
file_list = {}        + SdramDefs      + SdramAhbif     + SdramAhbRegBlk
file_list = file_list + SdramAhbWrBuf0 + SdramAhbWrBuf1 + SdramAhbRdBuf0
file_list = file_list + SdramArbFSM    + SdramArbiter   + SdramDramFSM
file_list = file_list + SdramTimCntl   + SdramDramCntl  + SdramCmdSeq
file_list = file_list + SdramEngine    + SdramPins      + SdramBigEndian
file_list = file_list + Sdram

/* script to acquire V/HDL-Compiler just before analysis / elaboration       */
/* Note: the initial remove_license is needed even though it looks redundant */
/* This script ensures that the V/HDL-Compiler is acquired only when it is   */
/* necessary.                                                                */ 

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

get_license DC-Expert
while (dc_shell_status == 0)
{
  get_license DC-Expert
}

/*****************************************************************************/
/* ANALYSE RTL SOURCE FILES                                                  */
/*****************************************************************************/

if (hdl == vhdl) {
  /*** VHDL RTL SOURCE ***/
  foreach (filename, file_list) {
    analyze -format vhdl vhdl_area + "/" + filename + ".vhd" -lib work
  }
} else if (hdl == verilog) {
  /*** VERILOG RTL SOURCE ***/
  foreach (filename, file_list) {
    analyze -format verilog verilog_area + "/" + filename + ".v" -lib work
  }
}

/*****************************************************************************/
/* ELABORATE THE DESIGN                                                      */
/*****************************************************************************/

elaborate -lib work Sdram 

/* release the HDL-Compiler once elaboration is over */
if (hdl == vhdl) {
  remove_license VHDL-Compiler
} else if (hdl == verilog) {
  remove_license HDL-Compiler
}

topname = Sdram
/* Specify the top level module name */

current_design = topname

include multibit.scr
/* Include multibit command settings */

check_design
/* Check that files have been read correctly and that various nodes */
/* are connected.                                                   */

uniquify
/* Separately optimise multiple instantiations within the design, */
/* allocating unique names to each instance. */

/*****************************************************************************/
/* APPLY CONSTRAINTS                                                         */
/*****************************************************************************/

current_design = topname

include global.scr
/* global.scr defines the environmental conditions */
/* for worst/best case library conditions and      */
/* defines default cell load and drive strength.   */

oc_margin = 1.0
/* clock phase reduced by oc_margin for an over-constrained compile */

include ahb_params.scr
/* ahb_params.scr defines the AHB timing parameters */

include ahb_slave.scr
/* ahb_slave.scr defines the AHB timing constraints using the above */

include sdram.scr
/* sdram.scr defines the input and output delay constraints for the block */

set_max_transition 2.0 topname
/* set maximum transition for all nets in design */

check_timing
/* Check timing parameters are valid */

set_max_area 0.0
/* set maximum area to zero so that design is optimised for minimum area */

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
/* set_wire_load -mode top -max "16000" */
/* set_wire_load -min "ForQA" */
 
set_fix_multiple_port_nets -all -buffer_constants
/* Prevent feedthroughs, multiple output ports from same net, */
/* or constants driving more than one output port */

/*****************************************************************************/
/* SINGLE PASS COMPILATION WITH SETUP AND HOLD FIXING IF VERSION >= 98.02    */
/*****************************************************************************/

include cb25dontuse.scr
/* Include the list of library cells that should NOT be used */

set_fix_hold all_clocks() 
/* Fix minimum timing violations */

/* Ungrouping AHB interface improves the timing */
find(design,"*SdramAhbif*")
foreach(design_name,dc_shell_status) {
  current_design = design_name
  buffers = find(cell,"uSdramAhb*Buf*")
  ungroup -flatten buffers
}

current_design = topname

compile -map_effort high
/* Compile using high CPU effort for mapping of design                 */
/* Note : Worst case and best case operating conditions are defined in */
/* global.scr                                                          */
 
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

report_timing -delay max -path full -max_paths 100 -nworst 10 \
  > rpt_area + "/" + topname + stype + "_" + hdl + ".max"
/* Output a maximum delay timing report for upto 100 paths,     */
/* with upto 10 paths per endpoint, written to the report area. */

report_timing -delay min -path full -max_paths 100 -nworst 10 \
  > rpt_area + "/" + topname + stype + "_" + hdl + ".min"
/* Output a minimum delay timing report for upto 100 paths,     */
/* with upto 10 paths per endpoint, written to the report area. */

report_constraint -verbose -all_violators \
  > rpt_area + "/" + topname + stype + "_" + hdl + ".vio"
/* Output a detailed constraints report listing all violations */
/* in descending order, written to the report area.            */

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
/* GENERATE DESIGN REPORT                                                    */
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
/* waveform and any attributes set on them.                                 */

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

/* script to acquire V/HDL-Compiler just before netlist write-out        */
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

/*****************************************************************************/
/* SAVE THE DATABASE IN SYNOPSYS .DB FORMAT                                  */
/*****************************************************************************/

current_design = topname
write -format db -hier -out db_area + "/" + topname + stype + "_" + hdl + ".db"

/*****************************************************************************/
/* APPLY NAMING RULES                                                        */
/*****************************************************************************/
/* Apply change_names to avoid naming problems in design flow, */
/* refer to Solvit note METH-148274.html                       */
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

/*********************** End of sdram.cmd ***********************************/
