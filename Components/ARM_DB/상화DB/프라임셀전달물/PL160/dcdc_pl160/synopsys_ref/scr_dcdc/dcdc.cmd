/*------------------------------------------------------------------------------
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 1999 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
-- 
-- Version and Release Control Information:
-- 
-- File Name              : dcdc.cmd,v
-- File Revision          : 1.1
-- 
-- Release Information    : PL160-REL1v1
-- 
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Purpose : Synopsys synthesis master compile script
--           for the DCDC block.
--
--           Located in the synopsys_ref/scr_dcdc directory.
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

stype = ""
/* Set null string for stype report naming naming option, for future use */

/******************************************************************************/
/* WRITE SYNTHESIS RUN START TIME                                             */
/******************************************************************************/
run_time_file = "synth_run_time" + stype + "_" + hdl + ".time"

echo "DCDC SYNTHESIS TIME LOG" > run_time_file
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

/*topname = get_unix_variable("TOP_NAME") */

/******************************************************************************/
/* DEFINE DIRECTORY STRUCTURE, REFERENCED TO DESIGN_ROOT                      */
/******************************************************************************/

synth_root             = design_root + /synopsys_ref

vhdl_area              = design_root + /vhdl/uut
verilog_area           = design_root + /verilog/uut

scr_common_area        = synth_root + /scr_common
scr_dcdc_area          = synth_root + /scr_dcdc

analyzed_area          = synth_root + /work
library_area           = synth_root + /cell_lib 
db_area                = synth_root + /db 
log_area               = synth_root + /log 
netlist_area           = synth_root + /netlist 
rpt_area               = synth_root + /report

/* Create link in library_area to point to cell library */

/******************************************************************************/
/* DEFINE SEARCH PATHS                                                        */
/******************************************************************************/
search_path = search_path + vhdl_area         
search_path = search_path + verilog_area         
search_path = search_path + scr_common_area         
search_path = search_path + scr_dcdc_area         
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
/* DEFINE LIST OF SOURCE RTL FILES                                            */
/******************************************************************************/

file_list = {}        + DcdcSync
file_list = file_list + DcdcPclkSync
file_list = file_list + DcdcDrive
file_list = file_list + DcdcCntl
file_list = file_list + DcdcClkSync
file_list = file_list + DcdcApbif
file_list = file_list + Dcdc

/******************************************************************************/
/* ANALYSE RTL SOURCE FILES                                                   */
/******************************************************************************/

if (hdl == vhdl) {
  /*** VHDL RTL SOURCE ***/
  foreach (filename, file_list) {
    analyze -format vhdl filename + ".vhd" -lib work
  }
} else if (hdl == verilog) {
  /*** VERILOG RTL SOURCE ***/
  foreach (filename, file_list) {
    analyze -format verilog filename + ".v" -lib work
  }
}

/******************************************************************************/
/* ELABORATE THE DESIGN                                                       */
/******************************************************************************/

elaborate -lib work Dcdc

topname =  Dcdc
/* specify the top-level module name */
               
current_design = topname

include multibit.scr
/* Include multibit command settings */

check_design
/* Check that files have been read correctly and that various nodes */
/* are connected. */

uniquify
/* Separately optimise multiple instantiations within the design, */
/* allocating unique names to each instance. */

/******************************************************************************/
/* APPLY CONSTRAINTS                                                          */
/******************************************************************************/

current_design = topname

include global.scr
/* global.scr defines the environmental conditions */
/* for worst/best case library conditions and */
/* define default cell load and drive strength. */

include apb_params.scr
/* apb_params.scr defines the AMBA APB timing parameters */

include apb_slave.scr
/* apb_slave.scr defines the AMBA APB timing constraints using the above */

include dcdc.scr
/* dcdc.scr defines the input and output delay constraints for the block */

set_max_transition 2.0 topname
/* Set maximum transition for all nets in design,
   to simplify buffering at chip-level. */

check_timing
/* Check timing parameters are valid */

set_max_area 0.0
/* set maximum area to zero so that design is optimised for mimimum area */

/* Wire-load model variables from cell library, */
/* If manually selection used then change according to the size of design */

WL_MOD = "8000"
WL_MOD_MAX = "8000"

WL_MOD_MIN = "8000"

/* Worst case and best case operating conditions are defined in global.scr */
current_design = topname

/* To disable automatic wire load selection, set the following command false */
auto_wire_load_selection = "true";
set_wire_load -mode enclosed

set_wire_load -library MAX_TECH_LIB_NAME -mode enclosed -max WL_MOD_MAX
/* Set the wire load model to be used for maximum delay analysis */
/* wire load model top is most pessimistic, area entered from first pass */

set_wire_load -library MAX_TECH_LIB_NAME -min WL_MOD_MIN
/* Set the wire load model to be used for minimum delay analysis */

set_fix_multiple_port_nets -all -buffer_constants
/* Prevent feedthroughs, multiple output ports from same net, */
/* or constants driving more than one output port */

/******************************************************************************/
/* SINGLE PASS COMPILATION WITH SETUP AND HOLD FIXING, VERSION >= 1998.02     */
/******************************************************************************/

include cb25dontuse.scr
/* Include the list of library cells that should NOT be used */

set_fix_hold all_clocks()
/* Fix minimum timing violations */

compile -map_effort medium -boundary_optimization
/* Compile using medium effort for mapping of design */
/* and allowing logic optimisation across hierarchy boundaries. */
/* Note : Worst case and best case operating conditions defined in global.scr */

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

/* Fix design rule violations */
compile -only_design_rule 

current_design = topname

report_timing -delay max -path full  -max_paths 100 -nworst 10 \
  > rpt_area + "/" + topname + stype + "_" + hdl + ".max"
/* Output a maximum delay timing report for upto 100 paths, */
/* with upto 10 paths per endpoint, written to the report area. */

report_timing -delay min -path full -max_paths 100 -nworst 10 \
  > rpt_area + "/" + topname + stype + "_" + hdl + ".min"
/* Output a minimum delay timing report for upto 100 paths, */
/* with upto 10 paths per endpoint, written to the report area. */

current_design = topname
 
/* Now report all violators */
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

/******************************************************************************/
/* GENERATE DESIGN REPORT                                                     */
/******************************************************************************/
current_design = topname

check_design      >  rpt_area + "/" + topname + stype + "_" + hdl + ".rpt"
/* 'check_design' checks the internal representation of the current design    */
/* for consistency and issues error and warning messages as appropriate.      */
/* It flags conditions like unconnected pins, cells not driving any nets,     */
/* pins with no loads, nets without drivers, nets with multiple drivers etc.  */

/* The user should examine the output of 'check_design' and ensure that all   */
/* the warnings are acceptable / explainable.                                 */

check_timing      >> rpt_area + "/" + topname + stype + "_" + hdl + ".rpt"
/* 'check_timing' checks for possible timing problems in the current design   */
/* It flags conditions like end-points not being constrained for max delay,   */
/* presence of gated clocks etc.                                              */

report_cell       >> rpt_area + "/" + topname + stype + "_" + hdl + ".rpt"
/* 'report_cell' provides information about all cells in the current design   */

report_reference  >> rpt_area + "/" + topname + stype + "_" + hdl + ".rpt"
/* 'report_reference' provides information about all cell references in the   */
/* current design                                                             */

report_design     >> rpt_area + "/" + topname + stype + "_" + hdl + ".rpt"
/* 'report_design' displays information about the current design and its      */
/* environment. It lists out the library used, operating conditions,          */
/* wireload models used etc.                                                  */

report_hierarchy  >> rpt_area + "/" + topname + stype + "_" + hdl + ".rpt"
/* 'report_hierarchy' lists out the cells used in the design hierarchically.  */

report_area       >> rpt_area + "/" + topname + stype + "_" + hdl + ".rpt"
/* 'report_area' provides the area of the design in standard area units.      */ 
/* The standard area unit will the area of a representative gate (eg: drive1  */
/* inverter or buffer) within the chosen technology.                          */ 

report_clock      >> rpt_area + "/" + topname + stype + "_" + hdl + ".rpt"
/* 'report_clock' provides a summary of all the defined clocks, their period  */
/* ,waveform and any attributes set on them.                                  */

/* The report file should contain no violations, or errors, */
/* and ideally zero or a minimal number of warnings.        */

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
  change_names -rule "CB25CAD_VLOG" -hierarchy
  change_names -rules COLLAPSE -hierarchy
}

/******************************************************************************/
/* GENERATE GATE-LEVEL NETLIST AND SDF TIMING FILE                            */
/******************************************************************************/

/* Note that the netlist and the sdf generation is controlled by the 'hdl', */
/* and 'hdl_out' variables. */

/* SynopsysVersion = V9802, both best case and worst case timing values */
/* are written out into the same sdf file. */

if (hdl_out == vhdl) {
  /*** VHDL OUTPUT FORMAT ***/
  current_design = topname
  if (hdl == vhdl) {
    vhdlout_preserve_hierarchical_types = user
    /*** VHDL OUTPUT FORMAT FROM VHDL RTL SOURCE ***/
    write -format vhdl -hier -out netlist_area + "/" + topname + stype \
      + "_net.vhd"
    write_timing -format sdf-v2.1 -context vhdl \
      -out netlist_area + "/" + topname + stype + "_Vhdl.sdf21"
  } else if (hdl == verilog) {
    /*** VHDL OUTPUT FORMAT BUT FROM VERILOG RTL SOURCE ***/
    write -format vhdl -hier \
      -out netlist_area + "/" + topname + stype + "_FromVerilogToVhdl_net.vhd"
    write_timing -format sdf-v2.1 -context vhdl \
      -out netlist_area + "/" + topname + stype + "_FromVerilogToVhdl.sdf21"
  }
} else if (hdl_out == verilog) {
  /*** VERILOG OUTPUT FORMAT ***/
  current_design = topname
  if (hdl == verilog) {
    /*** VERILOG OUTPUT FORMAT FROM VERILOG RTL SOURCE ***/
    write -format verilog -hier -out netlist_area + "/" + topname + stype \
      + "_net.v"
    write_timing -format sdf-v2.1 -context verilog \
      -out netlist_area + "/" + topname + stype + "_Verilog.sdf21"
  } else if (hdl == vhdl) {
    /*** VERILOG OUTPUT FORMAT BUT FROM VHDL RTL SOURCE ***/
    write -format verilog -hier \
      -out netlist_area + "/" + topname + stype + "_FromVhdlToVerilog_net.v"
    write_timing -format sdf-v2.1 -context verilog \
      -out netlist_area + "/" + topname + stype + "_FromVhdlToVerilog.sdf21"
  }
} else if (hdl_out == both) {
  /*** VHDL+VERILOG OUTPUT FORMAT ***/
  /* you may need the verilog view for later stages in the design flow */
  current_design = topname
  if (hdl == verilog) {
    write -format verilog -hier -out netlist_area + "/" + topname + stype \
      + "_net.v"
    write -format vhdl -hier -out netlist_area + "/" + topname + stype \
      + "_FromVerilogRtl.vhd"      
    write_timing -load_delay cell -format sdf-v2.1 -context vhdl \
      -out netlist_area + "/" + topname + stype + "_FromVerilogToVhdl.sdf21"
    write_timing -load_delay cell -format sdf-v2.1 -context verilog \
      -out netlist_area + "/" + topname + stype + "_verilog.sdf21"
  } else if (hdl == vhdl) {
    /*** VERILOG OUTPUT FORMAT BUT FROM VHDL RTL SOURCE ***/
    write -format verilog -hier -out netlist_area + "/" + topname + stype \
      + "_FromVhdlRtl.v"
    write -format vhdl -hier -out netlist_area + "/" + topname + stype \
      + "_net.vhd"
    write_timing -load_delay cell -format sdf-v2.1 -context vhdl \
      -out netlist_area + "/" + topname + stype + "_Vhdl.sdf21"
    write_timing -load_delay cell -format sdf-v2.1 -context verilog \
      -out netlist_area + "/" + topname + stype + "_FromVhdlToVerilog.sdf21"
  }
}

if (hdl == verilog) {
  remove_license HDL-compiler
} else if (hdl == vhdl) {
  remove_license VHDL-compiler
}

/******************************************************************************/
/* WRITE SYNTHESIS RUN END TIME                                               */
/******************************************************************************/

echo -n "END TIME   -> " >> run_time_file
sh date >> run_time_file
echo "=========================" >> run_time_file 
echo >> run_time_file

quit

/************************************* End ************************************/
