/*----------------------------------------------------------------------
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
------------------------------------------------------------------------
-- 
-- Version and Release Control Information:
-- 
-- File Name              : Gpio.cmd.rca
-- File Revision          : 1.2
-- 
-- Release Information    : PrimeCell(TM)-PL061-REL1v0
-- 
------------------------------------------------------------------------

------------------------------------------------------------------------
-- Purpose : Synopsys synthesis master compile script
--           for the PERIPH block.
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
--           Source files are analysed, the design elaborated,
--           constraints applied, design compiled and then the
--           netlist and timing file generated.
----------------------------------------------------------------------*/


/******************************************************************************/
/* INCLUDE PROJECT-SPECIFIC SETUP FILE                                        */
/******************************************************************************/

synth_base_area = get_unix_variable("GLOBAL")
scr_common_area = synth_base_area + "/synopsys_shared/scr_common"
include scr_common_area + "/setup.scr"
/* define the synthesis parameters to be used for the synthesis               */

/******************************************************************************/
/* DEFINE LIST OF SOURCE RTL FILES                                            */
/******************************************************************************/

topname =  get_unix_variable("PERIPH")
/* specify the top-level module name */
               

/******************************************************************************/
/* define the source files to be synthesised                                  */
/******************************************************************************/
file_list = {}        + GpioRevAnd + GpioInt + GpioAfm + GpioApbif + Gpio


/******************************************************************************/
/* WRITE SYNTHESIS RUN START TIME                                            **/
/******************************************************************************/

run_time_log = "log/" + topname + "_" + test_req + "_" + hdl + "_" + hdl_out + "_synth.log"

echo "PERIPH SYNTHESIS LOG" > run_time_log
echo "====================" >> run_time_log 
echo >> run_time_log
echo -n "START TIME -> " >> run_time_log
sh date >> run_time_log
echo >> run_time_log

/******************************************************************************/
/* ANALYSE RTL SOURCE FILES                                                   */
/******************************************************************************/

if (hdl == vhdl) {
  /*** VHDL RTL SOURCE ***/
  foreach (filename, file_list) {
    analyze -format vhdl "../" + hdl + "/rtl_source/" + filename + ".vhd" -lib work
  }
} else if (hdl == verilog) {
  /*** VERILOG RTL SOURCE ***/
  foreach (filename, file_list) {
    analyze -format verilog "../" + hdl + "/rtl_source/" + filename + ".v" -lib work
  }
}

/******************************************************************************/
/* ELABORATE THE DESIGN                                                       */
/******************************************************************************/

elaborate -lib work topname

current_design = topname

echo >> run_time_log
echo "check_design" >> run_time_log
echo "============" >> run_time_log 
echo >> run_time_log
check_design  >> run_time_log
/* Check that files have been read correctly and that various nodes */
/* are connected. */

uniquify
/* Separately optimise multiple instantiations within the design, */
/* allocating unique names to each instance. */

/******************************************************************************/
/* INCLUDE LIBRARY SETTINGS FILE                                              */
/******************************************************************************/

include scr_common_area + "/library_avanti_cb25_v2.1.scr"

/******************************************************************************/
/* APPLY CONSTRAINTS                                                          */
/******************************************************************************/

include scr_common_area + "/global.scr"
/* define default area/slope constraint    */

/* Define Clock phase time */
tclkh = 5.0  

include scr_common_area + "/apb_params.scr"
/* apb_params.scr defines the AMBA APB timing parameters */

include scr_common_area + "/apb_slave.scr"
/* apb_slave.scr defines the AMBA APB timing constraints using the above */

include scripts/Gpio.scr
/* Gpio.scr defines the input and output delay constraints for the block */

include scripts/Gpio_exceptions.scr
/* Gpio_exceptions.scr defines the point-to-point exceptions set on the block */

/******************************************************************************/
/* SINGLE PASS COMPILATION WITH SETUP AND HOLD FIXING, VERSION >= 1998.02     */
/******************************************************************************/

set_fix_hold all_clocks()
/* Fix minimum timing violations */

if ((test_req == scaninsert) || (test_req == scanready)) {
    compile -map_effort medium -scan
    /* Compile using medium CPU effort for mapping of design                  */
} else  {
    compile -map_effort medium
    /* Compile with no scan insertion*/
}

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
/* Set name base for report generation, before Gpio_scan.cmd is called       */
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
    include scripts/Gpio_scan.cmd
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
if (hdl == vhdl) {
  change_names -rule "CB25CAD_VHDL" -hierarchy
  change_names -rules SPECIAL_VHDL -hierarchy
} else if (hdl == verilog) {
  change_names -rule "CB25CAD_VLOG" -hierarchy
}

/******************************************************************************/
/* GENERATE GATE-LEVEL NETLIST AND SDF TIMING FILE                            */
/******************************************************************************/

/* Note that the netlist and the sdf generation is controlled by the 'hdl', */
/* and 'hdl_out' variables. */

/* SynopsysVersion = V9802, both best case and worst case timing values */
/* are written out into the same sdf file. */

netlist_name_base = "../" + hdl_out + "/netlist/" + topname + "_" + test_req + "_" + hdl

/* The resistance of the Gpio reset nets must be set after the design has     */
/* been compiled to ensure that the Gpio module sdf is written out with zero  */
/* delay on the reset nets.                                                   */

set_resistance 0 find(net, PRESETn)


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

/************************************* End ************************************/
