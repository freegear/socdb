/*------------------------------------------------------------------------------
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
-- 
-- Version and Release Control Information:
-- 
-- File Name              : Rtc.cmd.rca
-- File Revision          : 1.9
-- 
-- Release Information    : PrimeCell(TM)-PL031-REL1v0
-- 
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Purpose : Synopsys synthesis master compile script
--           for the RTC block.
--
--           Located in the synopsys_ref/scr_rtc directory.
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
/* Please ensure that the following environment variables are set before      */
/* synthesis invocation.                                                      */
/*                                                                            */
/* GLOBAL       [path to shared files]                                        */
/*                                                                            */
/* PERIPH       [set this to 'Rtc']                                           */
/*                                                                            */
/* TEST_METH    [set this to either 'noscan', 'scanready' or 'scaninsert']    */
/*                                                                            */
/* HDL_SOURCE   [set this to either 'vhdl' or 'verilog']                      */
/*                                                                            */
/* HDL_NETL     [set this to either 'vhdl' or 'verilog']                      */
/*                                                                            */
/******************************************************************************/

/*****************************************************************************/
/* INCLUDE PROJECT-SPECIFIC SETUP FILE                                       */
/*****************************************************************************/

synth_base_area = get_unix_variable("GLOBAL")
scr_common_area = synth_base_area + "/synopsys_shared/scr_common"
include scr_common_area + "/setup.scr"
/* define the synthesis parameters to be used for the synthesis     */

/******************************************************************************/
/* Select the module to be synthesised                                        */
/******************************************************************************/

topname =  get_unix_variable("PERIPH")
/* specify the top-level module name */

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

run_time_log = "log/" + topname + "_" + test_req + "_" + hdl + "_" + hdl_out + "_synth.log"

echo "RTC SYNTHESIS TIME LOG"  > run_time_log
echo "======================" >> run_time_log 
echo >> run_time_log
echo -n "START TIME -> " >> run_time_log
sh date >> run_time_log
echo >> run_time_log


/******************************************************************************/
/* DEFINE LIST OF SOURCE RTL FILES                                            */
/******************************************************************************/

if (hdl == vhdl) {
  file_list = {} + RtcPackage
} else if (hdl == verilog) {
  sh cp ../verilog/rtl_source/RtcParams.v .
  file_list = {} 
}



file_list = file_list + RtcApbif   + RtcSynctoPCLK + RtcControl
file_list = file_list + RtcCounter + RtcUpdate  + RtcInterrupt  + RtcRevAnd
file_list = file_list + Rtc

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
  sh rm RtcParams.v
}

/******************************************************************************/
/* ELABORATE THE DESIGN                                                       */
/******************************************************************************/
elaborate -lib work topname 

/* Release the V/HDL-Compiler once elaboration is over */
if (hdl == vhdl) {
  remove_license VHDL-Compiler
} else if (hdl == verilog) {
  remove_license HDL-Compiler
}

current_design = topname

uniquify  
 
/* Separately optimise multiple instantiations within the design, */
/* allocating unique names to each instance.                      */
echo                >> run_time_log
echo "check_design" >> run_time_log
echo "============" >> run_time_log 
echo                >> run_time_log
check_design        >> run_time_log
/* Check that files have been read correctly and that various nodes */
/* are connected.                                                   */

/******************************************************************************/
/* INCLUDE LIBRARY SETTINGS FILE                                              */
/******************************************************************************/
include scr_common_area + "/library_avanti_cb25_v2.1.scr"
/* If the user is targetting a different technology, the above file */
/* needs to be edited to include settings specific to that          */
/* technology. The file should also be renamed appropriately.       */ 

/******************************************************************************/
/* APPLY CONSTRAINTS                                                          */
/******************************************************************************/
current_design = topname

include scr_common_area + "/global.scr"
/* global.scr defines the environmental conditions */
/* for worst/best case library conditions and      */
/* defines default cell load and drive strength.   */

/* Define Clock phase time */
tclkh = 5.0

/* Define over-constraining margin */
oc_margin = 0.0
/* If the synthesis needs to be performed with an over-constrained */
/* clock set this parameter to a non-zero value. For example if    */
/* oc_margin is set to 0.5, the clock period will be reduced by    */
/* 1.0 ns.                                                         */

/* Note that the phase is reduced (over-constrained) by 0 ns */
tclkh = tclkh - oc_margin

include scr_common_area + "/apb_params.scr"
/* apb_params.scr defines the AMBA APB timing parameters */

include scr_common_area + "/apb_slave.scr"
/* apb_slave.scr defines the AMBA APB timing constraints using the above */

include scripts/Rtc.scr
/* periph.scr defines the input and output delay constraints for the block */

echo                >> run_time_log
echo "check_timing" >> run_time_log
echo "============" >> run_time_log
echo                >> run_time_log
check_timing        >> run_time_log
/* Check whether timing parameters are valid.           */
/* Unconstrained ports, gated clocks etc. are reported. */

current_design = topname

set_max_transition 1.0 topname
/* Set maximum transition for all nets in design,
   to simplify buffering at chip-level. */

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


set_fix_hold all_clocks()
/* Fix minimum timing violations */

if ((test_req == scaninsert) || (test_req == scanready)) {
    compile -map_effort high -scan
    /* Compile using medium CPU effort for mapping of design               */
} else  {
    compile -map_effort high
    /* Compile with no scan insertion*/
}

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

echo >> run_time_log
echo "check_timing" >> run_time_log
echo "============" >> run_time_log 
echo >> run_time_log
check_timing  >> run_time_log
/* Check timing parameters are valid */


/*****************************************************************************/
/* Set name base for report generation, before Rtc_scan.cmd is called       */
/*****************************************************************************/
report_name_base = "report/" + topname + "_" + test_req + "_" + hdl + "_" + hdl_out


/*****************************************************************************/
/* Do test checks/ scan insertion                                            */
/*****************************************************************************/

/* Check for any test problems */
if (test_req == scanready) {
  echo >> run_time_log
  echo "check_test" >> run_time_log
  echo "==========" >> run_time_log 
  echo >> run_time_log
  check_test  >> run_time_log 
} else if (test_req == scaninsert) {
   /* Insert scan if required  */
    include scripts/Rtc_scan.cmd
}

/*****************************************************************************/
/* GENERATE VIOLATION REPORT                                                 */
/*****************************************************************************/

report_constraint -verbose -all_violators > report_name_base + ".vio"
/* Output a detailed constraints report listing all violations */
/* in descending order, written to the report area. */

/*****************************************************************************/
/* GENERATE TIMING REPORTS                                                   */
/*****************************************************************************/
 
report_timing -delay max -path full -nworst 10 > report_name_base + ".max"
/* Output a maximum delay timing report for upto 10 paths, written to the    */
/* report area.                                                              */

report_timing -delay min -path full -nworst 10 > report_name_base + ".min"
/* Output a minimum delay timing report for upto 10 paths, written to the    */
/* report area.                                                              */

/*****************************************************************************/
/* GENERATE AREA REPORT                                                      */
/*****************************************************************************/
 
/* Create area reports of the current design modules */
echo " AREA REPORT FOR DESIGN : " + current_design > report_name_base + ".area"
foreach (design_name,find("design","*")){
  current_design = design_name
  echo "    " >> report_name_base + ".area"
  report_area >> report_name_base + ".area"
}
current_design = topname

/*****************************************************************************/
/* GENERATE CONSTRAINT REPORTS                                               */
/*****************************************************************************/

report_design     > report_name_base + ".constr"
/* 'report_design' displays information about the current design and its     */
/* environment. It lists out the library used, operating conditions,         */
/* wireload models used etc.                                                 */

report_constraint >> report_name_base + ".constr"
/* 'report_constraint' displays constraint-related information about the     */
/* design                                                                    */

check_timing      >> report_name_base + ".constr"
/* 'check_timing' checks for possible timing problems in the current design   */
/* It flags conditions like end-points not being constrained for max delay,   */
/* presence of gated clocks etc.                                              */

report_cell       >> report_name_base + ".constr"
/* 'report_cell' provides information about all cells in the current design   */

report_reference  >> report_name_base + ".constr"
/* 'report_reference' provides information about all cell references in the   */
/* current design                                                             */

report_design     >> report_name_base + ".constr"
/* 'report_design' displays information about the current design and its      */
/* environment. It lists out the library used, operating conditions,          */
/* wireload models used etc.                                                  */

report_hierarchy  >> report_name_base + ".constr"
/* 'report_hierarchy' lists out the cells used in the design hierarchically.  */

report_area       >> report_name_base + ".constr"
/* 'report_area' provides the area of the design in standard area units.      */ 
/* The standard area unit will the area of a representative gate (eg: drive1  */
/* inverter or buffer) within the chosen technology.                          */


report_clock      >> report_name_base + ".constr"
/* 'report_clock' provides a summary of all the defined clocks, their period */
/* waveform and any attributes set on them.                                  */


report_attribute -design  >> report_name_base + ".constr"
/* 'report_attribute - design' reports attribute related to the design       */

report_port -verbose  > report_name_base + ".ports"
/* Report information about ports of design */


report_transitive_fanout -clock_tree -nosplit >  report_name_base + ".transitive_fanout"
/* Report the Clock Tree information to check if any buffers present */

report_transitive_fanout -from PRESETn -nosplit >> report_name_base + ".transitive_fanout"
/* Report the Resets Tree information to check if any buffers present */

/*****************************************************************************/
/* GENERATE LATCH REPORTS                                                    */
/*****************************************************************************/

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
write -format db -hier -out "db/" + topname + "_" + test_req + "_" + hdl + "_" + hdl_out + ".db"

/******************************************************************************/
/* APPLY NAMING RULES                                                         */
/******************************************************************************/

/* Apply change_names to avoid naming problems in design flow,
   refer to Solvit note METH-148274.html */
if (hdl_out == vhdl) {
  change_names -rule "CB25CAD_VHDL" -hierarchy
  change_names -rules SPECIAL_VHDL -hierarchy
} else if (hdl_out == verilog) {
  change_names -rule "CB25CAD_VLOG" -hierarchy
}

/******************************************************************************/
/* GENERATE GATE-LEVEL NETLIST AND SDF TIMING FILE                            */
/******************************************************************************/

/* Note that the netlist and the sdf generation is controlled by the 'hdl', */
/* and 'hdl_out' variables. */

/* SynopsysVersion = V9802, both best case and worst case timing values */
/* are written out into the same sdf file. */

netlist_name_base = "../" + hdl_out + "/netlist/" + topname + "_" + \
                    test_req + "_" + hdl

/* The resistance of the Rtc reset nets must be set after the design has      */
/* been compiled to ensure that the Rtc module sdf is written out with zero   */
/* delay on the reset nets.                                                   */

set_resistance 0 find(net, PRESETn)
set_resistance 0 find(net, nRTCRST)
set_resistance 0 find(net, nPOR)

if (hdl_out == vhdl) {
  /*** VHDL OUTPUT FORMAT ***/
  write -format vhdl -hier -out netlist_name_base + "_net.vhd"
  write_sdf -version 2.1 netlist_name_base + ".sdf21"
} else if (hdl_out == verilog) {
  /*** VERILOG OUTPUT FORMAT ***/
  write -format verilog -hier -out netlist_name_base + "_net.v"
  write_sdf -version 2.1 netlist_name_base + ".sdf21"
}


/******************************************************************************/
/* WRITE SYNTHESIS RUN END TIME                                               */
/******************************************************************************/

echo -n "END TIME   -> " >> run_time_log
sh date >> run_time_log
echo "=========================" >> run_time_log 
echo >> run_time_log

quit

/******************************* End of Rtc.cmd *******************************/
