/*--------------------------------------------------------------------
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
----------------------------------------------------------------------
-- 
-- Version and Release Control Information:
-- 
-- File Name           : amba.cmd,v
-- File Revision       : 1.20
-- 
-- Release Information : ADK_REL1v1
-- 
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Purpose : Synopsys synthesis master compile script
--           for all standard AMBA modules.
--
--           Located in global_ADK/synopsys_shared/scr_common directory.
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
--------------------------------------------------------------------*/

/********************************************************************/
/* INCLUDE PROJECT-SPECIFIC SETUP FILE                              */
/********************************************************************/

synth_base_area = get_unix_variable("GLOBAL")
scr_common_area = synth_base_area + "/synopsys_shared/scr_common"
include scr_common_area + "/setup.scr"
/* define the synthesis parameters to be used for the synthesis */

/********************************************************************/
/* WRITE SYNTHESIS RUN START TIME                                   */
/********************************************************************/
run_time_log = "log/" + modname + "_" + test_req + "_" + hdl + "_" + hdl_out + "_synth.log"


echo "SYNTHESIS TIME LOG" > run_time_log
echo "==================" >> run_time_log 
echo >> run_time_log
echo -n "START TIME -> " >> run_time_log
sh date >> run_time_log
echo >> run_time_log

/********************************************************************/
/* PREVENT IMMEDIATE LACK OF LICENSE FROM HALTING SYNTHESIS         */
/********************************************************************/
if (hdl == verilog) {
  got_hdl_license = 0
  while ( ! got_hdl_license ) {
    get_license HDL-Compiler
    got_hdl_license = dc_shell_status
    sh sleep 30
  }
} else if (hdl == vhdl) {
  got_vhdl_license = 0
  while ( ! got_vhdl_license ) {
    get_license VHDL-Compiler
    got_vhdl_license = dc_shell_status
    sh sleep 30
  }
}

if (test_req == scaninsert) {
  got_tc_license = 0
  while ( ! got_tc_license ) {
    get_license Test-Compiler
    got_tc_license = dc_shell_status
    sh sleep 30
  }
}

/********************************************************************/
/* ANALYSE RTL SOURCE FILES                                         */
/********************************************************************/

/* Enable use of translate_on and translate_off pragmas in HDL */
hdlin_translate_off_skip_text = true

/* If specified, read in and analyse the clock gates and other cells */
/* which are exceptions to fast-track design guidelines              */
if (special_cell_list != {}) {
  if (hdl == vhdl) {
    /*** VHDL RTL SOURCE ***/
    foreach (filename, special_cell_list) {
      analyze -format vhdl synth_base_area + "/" + hdl + "/" + filename + ".vhd" -lib work
      elaborate -lib work filename
      include scr_common_area + "/library_avanti_cb18_v1.0.scr"
      compile -map_effort low
    }
  } else if (hdl == verilog) {
    /*** VERILOG RTL SOURCE ***/
    foreach (filename, special_cell_list) {
      analyze -format verilog synth_base_area + "/" + hdl + "/" + filename + ".v" -lib work
      elaborate -lib work filename
      include scr_common_area + "/library_avanti_cb18_v1.0.scr"
      compile -map_effort low
    }
  }
}

/* If specified, read in and analyse those cells stored in the global_ADK */
/* area */
if (common_cell_list != {}) {
  if (hdl == vhdl) {
  /*** VHDL RTL SOURCE ***/
    foreach (filename, common_cell_list) {
      analyze -format vhdl synth_base_area + "/" + hdl + "/" + filename + ".vhd" -lib work
    }
  } else if (hdl == verilog) {
  /*** VERILOG RTL SOURCE ***/
    foreach (filename, common_cell_list) {
      analyze -format verilog synth_base_area + "/" + hdl + "/" + filename + ".v" -lib work
    }
  }
}

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

/********************************************************************/
/* READ IN TOP-LEVEL CPU WRAPPER RTL                                */
/********************************************************************/

if (module_type == CPU_Wrapper) {
  /* READ IN TOP LEVEL RTL SOURCE FILE */
  if (hdl == vhdl) {
  /*** VHDL RTL SOURCE ***/
    analyze -format vhdl "../" + hdl + "/rtl_source/" + topname + ".vhd" -lib work
  } else if (hdl == verilog) {
  /*** VERILOG RTL SOURCE ***/
    analyze -format verilog "../" + hdl + "/rtl_source/" + topname + ".v" -lib work
  }
}

/********************************************************************/
/* READ IN SUB-BLOCKS FOR STRUCTURAL COMPONENT                      */
/********************************************************************/
/* This auto-generated script will load all sub-blocks in the EASY */
/* system. */

if (module_type == Structural) {
  include modname + "_subload.cmd"
}

/********************************************************************/
/* ELABORATE THE DESIGN                                             */
/********************************************************************/

elaborate -lib work topname

current_design = topname

/********************************************************************/
/* INCLUDE LIBRARY SETTINGS FILE                                    */
/********************************************************************/
include scr_common_area + "/library_avanti_cb18_v1.0.scr"
/* include cell library variables */

/********************************************************************/
/* LINK THE DESIGN                                                  */
/********************************************************************/

link

/********************************************************************/
/* CHECK DESIGN AND FLATTEN HIERARCHY                               */
/********************************************************************/
echo >> run_time_log
echo "check_design" >> run_time_log
echo "============" >> run_time_log 
echo >> run_time_log
check_design  >> run_time_log
/* Check that files have been read correctly and that various nodes */
/* are connected. */

current_design = modname
uniquify
/* Make multiple instantiations unique to allow ungrouping */

/* All special cells (clock gates, RevAnd components, etc) are now set */
/* as dont_touch so that they do not get flattened, and can therefore */
/* still be identified in the final netlist */

foreach (name, special_cell_list) {
  set_dont_touch (find(design, name + "*"))
}

ungroup -all
/* Removes hierarchy in the module. */

/********************************************************************/
/* APPLY CONSTRAINTS                                                */
/********************************************************************/

current_design = topname

include scr_common_area + "/global.scr"
/* global.scr defines the environmental conditions */
/* for worst/best case library conditions and */
/* define default cell load and drive strength. */

include scr_common_area + "/amba_params.scr"
/* amba_params.scr defines the AMBA timing parameters for both APB and AHB */

if (module_type == APB_Slave) {
  include scr_common_area + "/apb_slave.scr"
} else if (module_type == APB_Master) {
  include scr_common_area + "/ahb_slave.scr"
  include scr_common_area + "/apb_master.scr"
} else if (module_type == AHB_Slave) {
  include scr_common_area + "/ahb_slave.scr"
} else if (module_type == AHB_Master) {
  include scr_common_area + "/ahb_master.scr"
}
/* Used to select the generic module port constraints for the current module */

include "scripts/" + modname + ".scr"
/* modname.scr defines the input and output delay constraints for the */
/* block */

include "scripts/" + modname + "_exceptions.scr"
/* modname_exceptions.scr defines the point-to-point exceptions set on */
/* the block */

if (module_type == Structural) {
  propagate_constraints -false_path -multicycle_path -disable_timing
}
/* Propagate the exceptions from sub-blocks up to the top level */

/* Ensure that SCAN signals are not considered for timing violations, */
/* and that the SCANENABLE signal (if present) is treated as ideal    */

scan_list = find(port,"SCAN*") > /dev/null

if ( dc_shell_status != {} ) {
     echo "Disabling timing checks for SCAN input pins"
     scan_inport_list = filter(scan_list,"@port_direction == in") > /dev/null
     set_disable_timing scan_inport_list
     set_load 0 find(port, SCANENABLE)
     set_drive 0 find(port, SCANENABLE)
     remove_driving_cell find(port, SCANENABLE)
     echo ""
     echo "Disabling timing checks for SCAN output pins"
     scan_outport_list = filter(scan_list,"@port_direction == out") > /dev/null
     set_false_path -to scan_outport_list
     echo ""
}

/********************************************************************/
/* COMPILATION WITH SETUP AND HOLD FIXING                           */
/********************************************************************/

current_design = topname

/* The two LIB files (MIN and MAX timing) describing ARM CPU cores */
/* cannot both be loaded into dc_shell at the same time due to */
/* limitations in the LIB language.  A two-pass approach is therefore */
/* used for synthesis of the CPU AHB wrappers: the first pass */
/* references the MAX timing library and compiles for critical timing; */
/* the second pass references the MIN timing library and fixes any */
/* hold violations */
if (cpulibmin != {}) {
  set_fix_hold all_clocks()
}
/* Fix minimum timing violations */

current_design = topname

/* Top-level blocks (e.g. an EASY system) are declared as Structural. */
/* These do not require full effort during compile: all sub-blocks    */
/* have already been read in as db files, and only the top-level      */
/* hook-up remains. The selection of the map and area effort to use   */
/* is made in setup.scr based on environment variable settings.       */

if (module_type == Structural) {
   /* Compile using low effort for mapping of structural design */
   if (test_req == scaninsert) {
       compile -map_effort synth_map_effort -incremental_mapping -area_effort synth_area_effort -scan
   } else  {
       compile -map_effort synth_map_effort -incremental_mapping -area_effort synth_area_effort
   }
} else  {
   /* Compile using high effort for mapping of design */
   if (test_req == scaninsert) {
       compile -map_effort synth_map_effort -area_effort synth_area_effort -scan
   } else  {
       compile -map_effort synth_map_effort -area_effort synth_area_effort
   }
}

/* Flatten DesignWare hierarchy as per Solvit note Synthesis-173.html, */
/* to avoid SDF/netlist problems. */
current_design = modname
dw_cell_list = filter(find(cell,"*"),"@is_synlib_operator==true || \
               @is_dw_subblock==true || @is_synlib_module==true ") > /dev/null
if ( dc_shell_status != {} ) {
     echo "Info: Found some DW hierarchy in " + modname + ". Ungrouping..."
     ungroup -flatten dw_cell_list -simple
}
remove_variable dw_cell_list

current_design = topname

/*******************************************************************/
/* Set name base for report generation                             */
/*******************************************************************/
report_name_base = "report/" + modname + "_" + test_req + "_" + hdl + "_" + hdl_out

/*******************************************************************/
/* Second pass compile for CPU AHB wrappers only                   */
/*******************************************************************/
if (cpulibmin != {}) {

  /* Un-link max CPU library and link in min library */
  if (cpulibmin != {}) {
    link_library = link_library - cpulibmax
    link_library = link_library + cpulibmin
    link
  }

  /* Fix minimum timing violations */
  set_fix_hold all_clocks()

  /* Propagate constraints to sub-block */
  characterize u + modname
  
  /* Fix violations visible from sub-level */
  current_design = modname
  
  /* Re-apply constraints on HRESETn as characterize does not propagate */
  /* all of them */
  set_false_path -from HRESETn
  set_disable_timing find(port, HRESETn)
  set_load 0 HRESETn
  set_resistance 0 find(net, HRESETn)
  set_drive 0 HRESETn
  remove_driving_cell find(port, HRESETn)
  set_ideal_net find(net, HRESETn)
  
  /* Compile using only_design_rule to fix violations */
  if (test_req == scaninsert) {
      compile -only_design_rule -scan
      /* Compile using medium effort for mapping of design */
  } else  {
      compile -only_design_rule
      /* Compile with no scan insertion*/
  }

  current_design = topname
  
  report_timing -delay min -path full -max_paths 100 -nworst 10 \
    > report_name_base + ".min"
  
  /* Un-link min CPU library and link in max library */
  if (cpulibmin != {}) {
    link_library = link_library - cpulibmin
    link_library = link_library + cpulibmax
    link
  }

}

/*******************************************************************/
/* Do test checks/scan insertion                                   */
/*******************************************************************/

current_design = topname

/* Check for any test problems */
if (test_req == scaninsert) {
  /* Insert scan if required  */
  include "scripts/" + modname + "_scan.cmd"
}

/*******************************************************************/
/* Ensure correct SDF timings                                      */
/*******************************************************************/

/*  The resistance of clock and reset nets must be set after the design */
/*  has been compiled, to ensure that the sdf is written out with zero */
/*  delay on the clock and reset nets. */
current_design = modname
include "scripts/" + modname + "_pre_sdf.scr"

/*******************************************************************/
/* GENERATE VIOLATION REPORT                                       */
/*******************************************************************/

current_design = topname

report_constraint -verbose -all_violators > report_name_base + ".vio"
/* Output a detailed constraints report listing all violations */
/* in descending order, written to the report area. */

/*******************************************************************/
/* GENERATE TIMING REPORTS                                         */
/*******************************************************************/
report_timing -delay max -path full -max_paths 100 -nworst 10 \
  > report_name_base + ".max"
/* Output a maximum delay timing report for upto 100 paths, */
/* with upto 10 paths per endpoint, written to the report area. */

if (cpulibmin == {}) {
  report_timing -delay min -path full -max_paths 100 -nworst 10 \
    > report_name_base + ".min"
}
/* Output a minimum delay timing report for upto 100 paths, */
/* with upto 10 paths per endpoint, written to the report area. */

/********************************************************************/
/* GENERATE AREA REPORTS                                            */
/********************************************************************/

/* Create area reports of the current design modules */

echo " AREA REPORT FOR DESIGN : " + current_design > \
  report_name_base + ".area"
foreach (design_name,find("design","*")) {
  current_design = design_name
  echo ""     >> report_name_base + ".area"
  echo " MODULE : " + current_design >> \
    report_name_base + ".area"
  report_area >> report_name_base + ".area"
}

/********************************************************************/
/* GENERATE PER-PORT TIMING REPORT                                  */
/********************************************************************/
current_design = topname

echo "TIMING REPORT LOG" > report_name_base + ".port_timing"

echo ""  >> report_name_base + ".port_timing"
echo "OUTPUTS - MAX"  >> report_name_base + ".port_timing"
echo "-------------" >> report_name_base + ".port_timing"
echo ""  >> report_name_base + ".port_timing"

foreach (outport, all_outputs()) {
  report_timing -delay max -to outport >> report_name_base + ".port_timing"
}

echo ""  >> report_name_base + ".port_timing"
echo "INPUTS - MAX"  >> report_name_base + ".port_timing"
echo "------------" >> report_name_base + ".port_timing"
echo ""  >> report_name_base + ".port_timing"

foreach (inport, all_inputs()) {
  report_timing -delay max -to inport >> report_name_base + ".port_timing"
}

echo ""  >> report_name_base + ".port_timing"
echo "OUTPUTS - MIN"  >> report_name_base + ".port_timing"
echo "-------------" >> report_name_base + ".port_timing"
echo ""  >> report_name_base + ".port_timing"

if (cpulibmin != {}) {
  link_library = link_library - cpulibmax
  link_library = link_library + cpulibmin
  link
}

foreach (outport, all_outputs()) {
  report_timing -delay min -to outport >> report_name_base + ".port_timing"
}

echo ""  >> report_name_base + ".port_timing"
echo "INPUTS - MIN"  >> report_name_base + ".port_timing"
echo "------------" >> report_name_base + ".port_timing"
echo ""  >> report_name_base + ".port_timing"

foreach (inport, all_inputs()) {
  report_timing -delay min -to inport >> report_name_base + ".port_timing"
}

if (cpulibmin != {}) {
  link_library = link_library - cpulibmin
  link_library = link_library + cpulibmax
  link
}

/*******************************************************************/
/* GENERATE CONSTRAINT REPORTS                                     */
/*******************************************************************/

report_design     > report_name_base + ".constr"
/* 'report_design' displays information about the current design and its */
/* environment. It lists out the library used, operating conditions,     */
/* wireload models used etc.                                             */

report_constraint >> report_name_base + ".constr"
/* 'report_constraint' displays constraint-related information about the */
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

report_transitive_fanout -from find(port, "*RESET*") -nosplit >> report_name_base + ".transitive_fanout"

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

/********************************************************************/
/* GENERATE DESIGN REPORT                                           */
/********************************************************************/
current_design = modname

check_design     >  report_name_base + ".rpt"
/* 'check_design' checks the internal representation of the current design    */
/* for consistency and issues error and warning messages as appropriate.      */
/* It flags conditions like unconnected pins, cells not driving any nets,     */
/* pins with no loads, nets without drivers, nets with multiple drivers etc.  */

/* The user should examine the output of 'check_design' and ensure that all   */
/* the warnings are acceptable / explainable.                       */

echo "************" >> report_name_base + ".rpt"
echo "check_timing" >> report_name_base + ".rpt"
echo "************" >> report_name_base + ".rpt"
echo "" >> report_name_base + ".rpt"
check_timing     >> report_name_base + ".rpt"
echo "" >> report_name_base + ".rpt"
/* 'check_timing' checks for possible timing problems in the current design   */
/* It flags conditions like end-points not being constrained for max delay,   */
/* presence of gated clocks etc.                                              */

echo "***********" >> report_name_base + ".rpt"
echo "report_cell" >> report_name_base + ".rpt"
echo "***********" >> report_name_base + ".rpt"
echo "" >> report_name_base + ".rpt"
report_cell      >> report_name_base + ".rpt"
echo "" >> report_name_base + ".rpt"
/* 'report_cell' provides information about all cells in the current design   */

echo "****************" >> report_name_base + ".rpt"
echo "report_reference" >> report_name_base + ".rpt"
echo "****************" >> report_name_base + ".rpt"
echo "" >> report_name_base + ".rpt"
report_reference >> report_name_base + ".rpt"
echo "" >> report_name_base + ".rpt"
/* 'report_reference' provides information about all cell references in the   */
/* current design                                                             */

echo "****************" >> report_name_base + ".rpt"
echo "report_hierarchy" >> report_name_base + ".rpt"
echo "****************" >> report_name_base + ".rpt"
echo "" >> report_name_base + ".rpt"
report_hierarchy >> report_name_base + ".rpt"
echo "" >> report_name_base + ".rpt"
/* 'report_hierarchy' lists out the cells used in the design hierarchically.  */

echo "***********" >> report_name_base + ".rpt"
echo "report_area" >> report_name_base + ".rpt"
echo "***********" >> report_name_base + ".rpt"
echo "" >> report_name_base + ".rpt"
report_area      >> report_name_base + ".rpt"
echo "" >> report_name_base + ".rpt"
/* 'report_area' provides the area of the design in standard area units.      */ 
/* The standard area unit will the area of a representative gate (eg: drive1  */
/* inverter or buffer) within the chosen technology.                          */ 

/********************************************************************/
/* SAVE THE DATABASE IN SYNOPSYS .DB FORMAT                         */
/********************************************************************/

current_design = modname
write -format db -hier -out "db/" + modname + "_" + test_req + "_" + hdl + "_" + hdl_out + ".db"

/* For CPU wrappers, also write out a db file for the top-level */
if (module_type == CPU_Wrapper) {
  current_design = topname
  write -format db -hier -out "db/" + topname + "_" + test_req + "_" + hdl + "_" + hdl_out + ".db"
}

/********************************************************************/
/* APPLY NAMING RULES                                               */
/********************************************************************/
/* Apply change_names to avoid naming problems in design flow, refer to */
/* Solvit note METH-148274.html and SIM-1144.html*/

current_design = modname

if (hdl_out == vhdl) {
/*   change_names -rule "EASY_VHDL" -hierarchy */
  change_names -rule "VHDL_simple_names" -hierarchy
  change_names -rules "SPECIAL_VHDL" -hierarchy
} else if (hdl_out == verilog) {
/*   change_names -rule "EASY_VLOG" -hierarchy */
  change_names -rule "VLOG_simple_names" -hierarchy
  change_names -rules COLLAPSE -hierarchy
}

/********************************************************************/
/* GENERATE GATE-LEVEL NETLIST AND SDF TIMING FILE                  */
/********************************************************************/

/* Note that the netlist and the sdf generation is controlled by the */
/* 'HDL_SOURCE' and 'HDL_NETL' variables. */

/* SynopsysVersion = V9802, both best case and worst case timing values */
/* are written out into the same sdf file. */

netlist_name_base = "../" + hdl_out + "/netlist/" + modname + "_" + test_req + "_" + hdl
top_name_base = "../" + hdl_out + "/netlist/" + topname + "_" + test_req + "_" + hdl


if (module_type == Structural) {
  /* For structural components, write out netlists for the top-level */
  /* only, and the whole design.  SDF can only be created for the whole */
  /* design */
  if (hdl_out == vhdl) {
    /*** VHDL OUTPUT FORMAT ***/
    write -format vhdl -out netlist_name_base + "_net.vhd"
    write -format vhdl -hier -out netlist_name_base + "_net_all.vhd"
    write_sdf -version 2.1 netlist_name_base + ".sdf21"
  } else if (hdl_out == verilog) {
    /*** VERILOG OUTPUT FORMAT ***/
    write -format verilog -out netlist_name_base + "_net.v"
    write -format verilog -hier -out netlist_name_base + "_net_all.v"
    write_sdf -version 2.1 netlist_name_base + ".sdf21"
  }
} else if (module_type == CPU_Wrapper) {
  /* For CPU wrappers, write out netlist and SDF for both the */
  /* top-level, and only the wrapper itself */
  if (hdl_out == vhdl) {
    /*** VHDL OUTPUT FORMAT ***/
    current_design = modname
    write -format vhdl -hier -out netlist_name_base + "_net.vhd"
    write_sdf -version 2.1 netlist_name_base + ".sdf21"
    current_design = topname
    write -format vhdl -hier -out top_name_base + "_net.vhd"
    write_sdf -version 2.1 top_name_base + ".sdf21"
  } else if (hdl_out == verilog) {
    /*** VERILOG OUTPUT FORMAT ***/
    current_design = modname
    write -format verilog -hier -out netlist_name_base + "_net.v"
    write_sdf -version 2.1 netlist_name_base + ".sdf21"
    current_design = topname
    write -format verilog -hier -out top_name_base + "_net.v"
    write_sdf -version 2.1 top_name_base + ".sdf21"
  }
} else {
  /* For non-structural blocks, write out netlist and SDF for the */
  /* whole hierarchy */
  if (hdl_out == vhdl) {
    /*** VHDL OUTPUT FORMAT ***/
    write -format vhdl -hier -out netlist_name_base + "_net.vhd"
    write_sdf -version 2.1 netlist_name_base + ".sdf21"
  } else if (hdl_out == verilog) {
    /*** VERILOG OUTPUT FORMAT ***/
    write -format verilog -hier -out netlist_name_base + "_net.v"
    write_sdf -version 2.1 netlist_name_base + ".sdf21"
  }
}

if (hdl == verilog) {
  remove_license HDL-compiler
} else if (hdl == vhdl) {
  remove_license VHDL-compiler
}

/********************************************************************/
/* WRITE SYNTHESIS RUN END TIME                                     */
/********************************************************************/

echo -n "END TIME   -> " >> run_time_log
sh date >> run_time_log
echo "=========================" >> run_time_log 
echo >> run_time_log

quit

/******************************** End *******************************/
