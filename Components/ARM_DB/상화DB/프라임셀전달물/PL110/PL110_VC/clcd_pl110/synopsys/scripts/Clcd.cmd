/* --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
-- 
-- Version and Release Control Information:
-- 
-- File Name              : Clcd.cmd.rca
-- File Revision          : 1.4
-- 
-- Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
-- 
-- -----------------------------------------------------------------------------
-- Purpose :
--           Synopsys synthesis master compile script            
--           for the CLCD block.                                  
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
/* PERIPH       [set this to 'Clcd']                                          */
/*                                                                            */
/* TEST_METH    [set this to either 'noscan',                                 */
/*               'scanready' or 'scaninsert']                                 */
/*                                                                            */
/* HDL_SOURCE   [set this to either 'vhdl' or 'verilog']                      */
/*                                                                            */
/* HDL_NETL     [set this to either 'vhdl' or 'verilog']                      */
/*                                                                            */
/* FIFOTYPE     [set this to 'dtype' for D-Type Synthesisable DMA FIFO]       */ 
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
/* ADD COMPILED RAM DBs AREA TO THE SYNOPSYS SEARCH PATH                      */
/******************************************************************************/
ram_lib_area    = "db"
search_path     = search_path + ram_lib_area

/*****************************************************************************/
/* LIBRARY PATHS AND LIBRARY-SPECIFIC SETUP                                  */
/*****************************************************************************/
link_library = link_library + "./db/cb18_generic_memory_max.db"

/******************************************************************************/
/* Select the module to be synthesised                                        */
/******************************************************************************/
topname = get_unix_variable ("PERIPH")

/******************************************************************************/
/* SELECT SYNTHESIS WITH INPUT AND OUTPUT FORMATS IN VHDL OR VERILOG          */
/******************************************************************************/

/* set variable 'hdl' to 'vhdl' for VHDL or 'verilog' for Verilog RTL input.  */
/* set variable 'hdl_out' to 'vhdl' for VHDL output format or 'verilog' for   */
/* Verilog output format.                                                     */

hdl     = get_unix_variable("HDL_SOURCE")
hdl_out = get_unix_variable("HDL_NETL")

/* Uncomment the following to replace the use of environment                  */
/* variables above, which determine input and output format selected          */
/* for synthesis                                                              */

/*
hdl     = vhdl
hdl_out = verilog
*/

/******************************************************************************/
/* WRITE SYNTHESIS RUN START TIME                                             */
/******************************************************************************/
run_time_log = "log/" + topname + "_" + test_req + "_" + hdl + "_" + \
  hdl_out + "_synth.log"

echo "CLCD SYNTHESIS TIME LOG" >  run_time_log
echo "======================" >> run_time_log
echo                          >> run_time_log
echo -n "START TIME -> "      >> run_time_log
sh date                       >> run_time_log
echo                          >> run_time_log

/******************************************************************************/
/* DEFINE LIST OF SOURCE RTL FILES                                            */
/******************************************************************************/

/*
 *  Assign "null" value to fifo_type variable below if the DMA FIFO is
 *  either Asynchronous RAM or pre-compiled Macrocell
 */

if (hdl == vhdl) {
  file_list = {} + "ClcdConfig" + "ClcdDefine"
} else if (hdl == verilog) {
  sh cp ../verilog/rtl_source/ClcdConfig.v .
  sh cp ../verilog/rtl_source/ClcdDefine.v .
  file_list = {}
}

fifo_type = get_unix_variable("FIFOTYPE")
if (fifo_type == "dtype") {
    echo "    IMPORTANT ARCHITECTURE : Set for D-Type  Synthesizable DMA FIFO"
    echo "                             Implementation ..."
    echo " "
    file_list = file_list + "ClcdFifoReg" + "ClcdDmaFRegWrap"
} else {
    echo "    IMPORTANT ARCHITECTURE : Assuming pre-synthesized Macrocell or"
    echo "                             Asynchronous  RAM  implementation for"
    echo "                             the DMA FIFO ..."
    echo " "
    file_list = file_list + "ClcdDmaFRamWrap"
}

file_list = file_list + "Clcd"
file_list = file_list + "ClcdAhbIf"
file_list = file_list + "ClcdAhbMasterIf"
file_list = file_list + "ClcdAhbSlaveIf"
file_list = file_list + "ClcdCPGen"
file_list = file_list + "ClcdCntl"
file_list = file_list + "ClcdDMAFifo"
file_list = file_list + "ClcdFifoCntl"
file_list = file_list + "ClcdFormat"
file_list = file_list + "ClcdGS"
file_list = file_list + "ClcdMain"
file_list = file_list + "ClcdOutMux"
file_list = file_list + "ClcdPalette"
file_list = file_list + "ClcdRevAnd"
file_list = file_list + "ClcdSerialiser"
file_list = file_list + "ClcdSyncCLCDCLK"
file_list = file_list + "ClcdSyncHCLK"
file_list = file_list + "ClcdTest"
file_list = file_list + "ClcdTiming"
file_list = file_list + "ClcdUnpack"

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
/* In 2001.08 Presto HDL compiler is switched on by default. However with     */
/* Presto compiler, the verilog synthesis hangs. Hence the presto compiler is */
/* switched off.                                                              */
/******************************************************************************/
hdlin_enable_presto = false
hdlin_translate_off_skip_text = true

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
  sh rm ClcdConfig.v ClcdDefine.v
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

uniquify
current_design = topname
/* link */

/* Separately optimise multiple instantiations within the design, */
/* allocating unique names to each instance.                      */

echo                >> run_time_log
echo "check_design" >> run_time_log
echo "============" >> run_time_log
echo                >> run_time_log
check_design        >> run_time_log
/* Check that files have been read correctly and that various nodes */
/* are connected.                                                   */

change_names -rules verilog -hierarchy -verbose

/******************************************************************************/
/* INCLUDE LIBRARY SETTINGS FILE                                              */
/******************************************************************************/
include scr_common_area + "/library_avanti_cb18_v1.0.scr"
/* If the user is targetting a different technology, the above file */
/* needs to be edited to include settings specific to that          */
/* technology. The file should also be renamed appropriately.       */ 
 
/*****************************************************************************/
/* LIBRARY PATHS AND LIBRARY-SPECIFIC SETUP                                  */
/* LINK LIBRARY SETTINGS ARE RESET ON INCLUSION OF THE ABOVE LIBRARY         */
/* SETTINGS FILE, HENCE THE LINK_LIBRARY COMMAND IS RE-ISSUED SO THAT THE    */
/* THE RAM CELLS ARE VISIBLE.                                                */
/*****************************************************************************/
link_library = link_library + "./db/cb18_generic_memory_max.db"

/******************************************************************************/
/* APPLY CONSTRAINTS                                                          */
/******************************************************************************/

current_design = topname

include scr_common_area + "/global.scr"
/* global.scr defines the environmental conditions */
/* for worst/best case library conditions and      */
/* defines default cell load and drive strength.   */

/* Define Clock phase time (166MHz)*/ 
tclkh = 3.0

/* Clock skew */
tmskewforhalfclk = tclkh * 0.025
tmskew = tmskewforhalfclk * 2
/* minus skew set to 2.5% of clock period - for setup checks */

tpskew = tmskew * 0.40
/* plus skew set to 40% of tmskew - for hold checks */

tclkh = tclkh - tmskewforhalfclk

/* Define over-constraining margin */
if (hdl == vhdl) {
  oc_margin = 0.01
} else if (hdl == verilog) {
  oc_margin = 0.25
}
/* If the synthesis needs to be performed with an over-constrained */
/* clock set this parameter to a non-zero value. For example if    */
/* oc_margin is set to 0.5, the clock period will be reduced by    */
/* 1.0 ns.                                                         */

/* Note that the phase is reduced (over-constrained) by 0 ns */
tclkh = tclkh - oc_margin

include scr_common_area + "/amba_params.scr"
/* amba_params.scr defines the AHB timing parameters */

include scr_common_area + "/ahb_slave.scr"
/* ahb_slave.scr defines the AHB timing constraints using the above */

include scr_common_area + "/ahb_master.scr"
/* ahb_master.scr defines the AHB timing constraints for the master using */
/* amba_params.scr */

/*****************************************************************************/
/* DEFINE CLOCK CLCDCLK                                                      */
/*****************************************************************************/

/* Set CLCDCLK to half the frequency of HCLK, including clock skew */

/* Define Clock phase time (83MHz)*/ 
tclcdclkh = 6.0

/* Clock skew */
tmskewforhalfclcdclk = tclcdclkh * 0.025
tmskewclcd = tmskewforhalfclcdclk * 2
/* minus skew set to 2.5% of clock period - for setup checks */

tpskewclcd = tmskewclcd * 0.40
/* plus skew set to 40% of tmskewclcd - for hold checks */

tclcdclkh = tclcdclkh - tmskewforhalfclcdclk

/* Define over-constraining margin */
if (hdl == vhdl) {
  oc_margin = 0.01
} else if (hdl == verilog) {
  oc_margin = 0.25
}
/* If the synthesis needs to be performed with an over-constrained */
/* clock set this parameter to a non-zero value. For example if    */
/* oc_margin is set to 0.5, the clock period will be reduced by    */
/* 1.0 ns.                                                         */

/* Note that the phase is reduced (over-constrained) by 0 ns */
tclcdclkh = tclcdclkh - oc_margin

/* Clock LOW phase equals clock HIGH phase */
tclcdclkl = tclcdclkh

/* Clock period of HCLK/PCLK, period 20ns for 50.0MHz */
tclcdclk  = tclcdclkl + tclcdclkh

create_clock -p tclcdclk -w {0 tclcdclkh} find(port, "CLCDCLK")
/* period tlclk, rise at 0, fall after tclkh High phase */

set_clock_skew -plus_uncertainty tpskewclcd find(clock, CLCDCLK)
/* set plus clock skew */

set_dont_touch_network find(clock, CLCDCLK)
/* Preserve the clock net during optimisation */

set_resistance 0 CLCDCLK
/* model 0 path resistance to avoid false timing violations  */
/* in pre-layout timing analysis                             */

remove_driving_cell CLCDCLK
/* Ideal driving cell */

set_drive 0 CLCDCLK
/* Infinite drive strength clock signal */

/*****************************************************************************/
/* DEFINE CLOCK nCLCDCLK                                                      */
/*****************************************************************************/
 
/* Set nCLCDCLK to half the frequency of HCLK, including clock skew */
 
create_clock -p tclcdclk -w {tclcdclkh tclcdclk} find(port, "nCLCDCLK")
/* period tlclk, rise at 5, fall after tlclkh High phase */
 
set_clock_skew -plus_uncertainty tpskewclcd find(clock, nCLCDCLK)
/* set plus clock skew */

set_dont_touch_network find(clock, nCLCDCLK)
/* Preserve the clock net during optimisation */
 
set_resistance 0 nCLCDCLK
/* model 0 path resistance to avoid false timing violations  */
/* in pre-layout timing analysis                             */
 
remove_driving_cell nCLCDCLK
/* Ideal driving cell */
 
set_drive 0 nCLCDCLK
/* Infinite drive strength clock signal */

/*****************************************************************************/
/* Reset signal Constraints                                                  */
/*****************************************************************************/
 
set_input_delay -clock CLCDCLK -max tidmaxresetn nCLCLKRESET
set_input_delay -clock CLCDCLK -min tidminresetn nCLCLKRESET

set_dont_touch_network nCLCLKRESET
/* Preserve the clock net during optimisation */
 
set_resistance 0 find(net,"nCLCLKRESET")

set_drive 0 nCLCLKRESET
/* Infinite drive strength clock signal */

include scripts/Clcd.scr
/* Clcd.scr defines the input and output delay constraints for the */
/* block                                                           */

include scripts/Clcd_exceptions.scr 
/* Clcd_exceptions.scr defines the point-to-point exceptions set   */
/* on the CLCD block. These may be false_paths or multicycle_paths */

current_design = topname

/******************************************************************************/
/* Fix minimum timing violations                                              */
/******************************************************************************/
set_fix_hold all_clocks()
/* Fix minimum timing violations */

set_critical_range 1.0 topname

/* Location of reports */
report_name_base = "report/" + topname + "_" + test_req + "_" + hdl + \
  "_" + hdl_out

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

if (test_req == noscan) {

  current_design = topname

  compile -map_effort high
  /* Compile using medium CPU effort for mapping of design */
  /* This compile does NOT perform scan replacement      */


  current_design = topname

  compile -map_effort high -incr
  /* Compile using high CPU effort for mapping of design */
  /* This compile does NOT perform scan replacement      */
}

if (test_req == scaninsert) {
  /* script to acquire Test-Compiler */
  remove_license Test-Compiler
  get_license Test-Compiler
  while (dc_shell_status == 0) {
    sh sleep 30
    get_license Test-Compiler
  }

  current_design = topname

  compile -scan -map_effort high
  /* Compile for an initial mapping of the design, so as to get the */
  /* DesignWare components in place. This compile performs scan     */
  /* replacement                                                    */

  current_design = topname

  /* Flatten DesignWare hierarchy to allow for better logical */
  /* optimization for the following compile                   */
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

  current_design = topname

  compile -map_effort high -incr

  /* Perform Scan Insertion */
  include scripts/Clcd_scan.cmd
}
 
/* Restore clock period taking into account the negative clock skew */

/* Define Clock phase time */
tclkh = 3.0 - tmskewforhalfclk

include scr_common_area + "/amba_params.scr"
/* amba_params.scr defines the AHB timing parameters */

include scr_common_area + "/ahb_slave.scr"
/* ahb_slave.scr defines the AHB timing constraints using the above */

/*****************************************************************************/
/* DEFINE CLOCK CLCDCLK                                                      */
/*****************************************************************************/

/* Set CLCDCLK to half the frequency of HCLK, including clock skew */

create_clock -p tclcdclk -w {0 tclcdclkh} find(port, "CLCDCLK")
/* period tlclk, rise at 0, fall after tclkh High phase */

set_clock_skew -plus_uncertainty tpskewclcd find(clock, CLCDCLK)
/* set plus clock skew */

set_dont_touch_network find(clock, CLCDCLK)
/* Preserve the clock net during optimisation */

set_resistance 0 CLCDCLK
/* model 0 path resistance to avoid false timing violations  */
/* in pre-layout timing analysis                             */

remove_driving_cell CLCDCLK
/* Ideal driving cell */

set_drive 0 CLCDCLK
/* Infinite drive strength clock signal */

/*****************************************************************************/
/* DEFINE CLOCK nCLCDCLK                                                      */
/*****************************************************************************/
 
/* Set nCLCDCLK to half the frequency of HCLK, including clock skew */
 
create_clock -p tclcdclk -w {tclcdclkh tclcdclk} find(port, "nCLCDCLK")
/* period tlclk, rise at 5, fall after tlclkh High phase */
 
set_clock_skew -plus_uncertainty tpskewclcd find(clock, nCLCDCLK)
/* set plus clock skew */

set_dont_touch_network find(clock, nCLCDCLK)
/* Preserve the clock net during optimisation */
 
set_resistance 0 nCLCDCLK
/* model 0 path resistance to avoid false timing violations  */
/* in pre-layout timing analysis                             */
 
remove_driving_cell nCLCDCLK
/* Ideal driving cell */
 
set_drive 0 nCLCDCLK
/* Infinite drive strength clock signal */

/*****************************************************************************/
/* Reset signal Constraints                                                  */
/*****************************************************************************/
 
set_input_delay -clock CLCDCLK -max tidmaxresetn nCLCLKRESET
set_input_delay -clock CLCDCLK -min tidminresetn nCLCLKRESET

set_dont_touch_network nCLCLKRESET
/* Preserve the clock net during optimisation */
 
set_resistance 0 find(net,"nCLCLKRESET")

set_drive 0 nCLCLKRESET
/* Infinite drive strength clock signal */

include scripts/Clcd.scr
/* Clcd.scr defines the input and output delay constraints for the */
/* block                                                           */

include scripts/Clcd_exceptions.scr 
/* Clcd_exceptions.scr defines the point-to-point exceptions set   */
/* on the CLCD block. These may be false_paths or multicycle_paths */

include scr_common_area + "/ahb_master.scr"
/* ahb_master.scr defines the AHB timing constraints for the master using */
/* amba_params.scr                                                        */

current_design = topname

set_fix_hold all_clocks()
/* Fix minimum timing violations */

compile -only_design_rule

compile -incr

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
/* GENERATE AREA REPORTS                                                      */
/******************************************************************************/

design_list = find("design","*");

/* Create area reports of the current design modules */
current_design = topname
echo " AREA REPORT FOR DESIGN : " + current_design > \
  report_name_base + ".area"

foreach (design_name, design_list) {
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

report_port -verbose  >> report_name_base + ".ports"
/* Report information about ports of design */

echo                >> run_time_log 
echo "check_timing" >> run_time_log
echo "============" >> run_time_log 
echo                >> run_time_log
check_timing        >> run_time_log 
/* Check whether timing parameters are valid.           */
/* Unconstrained ports, gated clocks etc. are reported. */

/******************************************************************************/
/* GENERATE  REPORTS for Clock + Reset tree information, abouts Cells used    */
/* and their heirarchy                                                        */
/******************************************************************************/
report_transitive_fanout -clock_tree -nosplit > report_name_base + ".clocktree"
/* Report the Clock Tree information to check if any buffers present */

report_transitive_fanout -from HRESETn -nosplit > report_name_base +\
                                                  ".resettree"
/* Report the Reset Tree information to check if any buffers present */

report_hierarchy > report_name_base + ".hier"
/* 'report_hierarchy' lists out the cells used in the design hierarchically. */

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

/* script to acquire V/HDL-Compiler just before netlist write-out    */
/* Note: the initial remove_license is needed even though it looks   */
/* redundant. This is to account for cases where the V/HDL-Compiler  */
/* is automatically checked out during the compile phase.            */

/* For getting the HDL-Compiler license */
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
/* Apply change_names to avoid naming problems in design flow,                */
/* refer to Solvit note METH-148274.html                                      */


/******************************************************************************/
/* GENERATE GATE-LEVEL NETLIST AND SDF TIMING FILE                            */
/******************************************************************************/

/* Note that the netlist and the sdf generation is controlled by the */
/* 'hdl' and 'hdl_out' variables.                                    */

/* From SynopsysVersion 1998.02 onwards, both best case and worst    */
/* case timing values are written out into the same sdf file.        */

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

/****************************** End of Clcd.cmd *******************************/
