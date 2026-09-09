/* --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2003 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : Ssmc.cmd.rca
-- File Revision          : 1.14
--
-- Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Synopsys synthesis master compile script for the SSMC block.
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
--           The top level block is synthesized at 133MHz.
--
-- --=========================================================================*/

/******************************************************************************/
/* Please ensure that the following environment variables are set before      */
/* synthesis invocation.                                                      */
/*                                                                            */
/* GLOBAL       [path to shared files]                                        */
/*                                                                            */
/* PERIPH       [set this to 'Ssmc']                                          */
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

/******************************************************************************/
/* WRITE SYNTHESIS RUN START TIME                                             */
/******************************************************************************/
run_time_log = "log/" + topname + "_" + test_req + "_" + hdl + "_" + \
  hdl_out + "_synth.log"

echo "SSMC SYNTHESIS TIME LOG" > run_time_log
echo "======================" >> run_time_log
echo                          >> run_time_log
echo -n "START TIME -> "      >> run_time_log
sh date                       >> run_time_log
echo                          >> run_time_log

/******************************************************************************/
/* DEFINE LIST OF SOURCE RTL FILES                                            */
/******************************************************************************/

if (hdl == vhdl) {
  file_list = {} + SsmcPackage
} else if (hdl == verilog) {
  sh cp ../verilog/rtl_source/SsmcParams.v .
  file_list = {} + SsmcParams
}

file_list = file_list + SsmcAhbSlvRegIf + SsmcAhbSlvMemIf + SsmcSynchroniser
file_list = file_list + SsmcMemTSM + SsmcPadIf + SsmcDerivedClk + SsmcCore
file_list = file_list + SsmcRevAnd + SsmcTIC + SsmcDBI
file_list = file_list + SsmcClockOr
file_list = file_list + SsmcPadMux
file_list = file_list + Ssmc

/******************************************************************************/
/* Currently PRESTO enabled reading of verilog files, impacts the synthesis   */
/* timing significantly. Hence PRESTO is disabled.                            */
/******************************************************************************/
if (hdl == vhdl) {
   hdlin_enable_presto = true
} else if (hdl == verilog) {
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

/* Separately optimise multiple instantiations within the design, allocating  */
/* unique names to each instance.                                             */
uniquify

/* Removing the lower reference design*/
remove_design SsmcAhbSlvRegIf
remove_design SsmcAhbSlvMemIf
remove_design SsmcSynchroniser
remove_design SsmcMemTSM
remove_design SsmcPadIf
remove_design SsmcDerivedClk
remove_design SsmcTIC
remove_design SsmcDBI

remove_design SsmcRevAnd
remove_design SsmcClockOr

/* Check that files have been read correctly and that various nodes are       */
/* connected.                                                                 */
echo                >> run_time_log
echo "check_design" >> run_time_log
echo "============" >> run_time_log
echo                >> run_time_log
check_design        >> run_time_log
current_design = topname

/******************************************************************************/
/* INCLUDE LIBRARY SETTINGS FILE                                              */
/******************************************************************************/

include scr_common_area + "/library_avanti_cb18_v1.0.scr"
/* If the user is targetting a different technology, the above file needs to  */
/* be edited to include settings specific to that technology. The file should */
/* also be renamed appropriately.                                             */

current_design = topname

/******************************************************************************/
/* APPLY CONSTRAINTS                                                          */
/******************************************************************************/

include scr_common_area + "/global.scr"
/* global.scr defines the environmental conditions */
/* for worst/best case library conditions and      */
/* defines default cell load and drive strength.   */

/* Define Clock phase time 3.75ns(133MHz operation) */
tclkh = 3.75

/* Clock skew */
tmskewforhalfclk = tclkh * 0.0125
/* minus skew set to 2.5% of clock - for setup checks */

tmskew = tmskewforhalfclk * 2
/* minus skew set to 2.5% of clock - for setup checks */

tpskew = tmskew * 0.40 /* plus  skew set to 40% of tmskew - for hold checks  */

tclkh = tclkh - tmskewforhalfclk

/* Define over-constraining margin */
oc_margin = 0.3

/* If the synthesis needs to be performed with over-constraining,  */
/* set this parameter to a non-zero value. For example if          */
/* oc_margin is set to 0.5, the clock period will be reduced by    */
/* 1.0 ns                                                          */

/* Note that the phase is reduced (over-constrained) by 'oc_margin'  */
tclkh = tclkh - oc_margin
 
/* define feedback clock delta for SMFBCLK */
feedback = 2

/* define feedback clock delta for SMMEMCLKDELAY */
feedbackdelay = tclkh

/* feed back clock rise time for SMFBCLK */
tclkfh = tclkh + feedback

/* feed back clock rise time for SMFBCLKDELAY */
tclkfdelayh = tclkh + feedbackdelay

include scr_common_area + "/amba_params.scr"
/* amba_params.scr defines the AHB timing parameters */

include scr_common_area + "/ahb_slave.scr"
/* ahb_slave.scr defines the AHB timing constraints using the above */

include scr_common_area + "/ahb_master.scr"
/* ahb_master.scr defines the AHB timing constraints using the above */

/******************************************************************************/
/* SMMEMCLK DEFINTION                                                         */
/******************************************************************************/
create_clock -p tclk -w {0 tclkh} find(port, "SMMEMCLK")
/* period tclk, rise at 0, fall after tclkh High phase */

set_clock_skew -ideal -plus_uncertainty tpskew find(clock, SMMEMCLK)
/* set plus clock skew */

set_clock_transition 0 SMMEMCLK
/* ignore all transition times as it is an ideal clock */

set_drive 0 SMMEMCLK
/* Infinite drive strength clock signal */

set_load 0 SMMEMCLK
/* Zero load clock signal */

remove_driving_cell find(port, SMMEMCLK)
/* Set no driving cell on clock */

set_resistance 0 find(net, SMMEMCLK)
/* Zero resistance for zero net delay(interconnect delay) on */
/* ideal clock net                                           */

set_dont_touch_network find(clock, SMMEMCLK)
/* Preserve the clock net during optimisation */

/******************************************************************************/
/* SMMEMCLKDELAY DEFINITION
/******************************************************************************/

create_clock -p tclk -w {feedbackdelay tclkfdelayh} -name SMMEMCLKDELAY \
                                          find(port, "SMMEMCLKDELAY")
/* period tclk, rise at feedbackdelay, fall after tclkfdelayh High phase */

set_clock_skew -ideal -plus_uncertainty tpskew find(clock, SMMEMCLKDELAY)
/* set plus clock skew */

set_clock_transition 0 SMMEMCLKDELAY
/* ignore all transition times as it is an ideal clock */

set_load 0 SMMEMCLKDELAY
/* Zero load clock signal */

set_resistance 0 find(net, SMMEMCLKDELAY)
/* Zero resistance for zero net delay(interconnect delay) on */
/* ideal clock net                                           */

set_dont_touch_network find(clock, SMMEMCLKDELAY)
/* Preserve the clock net during optimisation */

/******************************************************************************/
/* nSMMEMCLK DEFINITION
/******************************************************************************/

create_clock -p tclk -w {feedbackdelay tclkfdelayh} -name nSMMEMCLK \
                                          find(port, "nSMMEMCLK")
/* period tclk, rise at feedbackdelay, fall after tclkfdelayh High phase */

set_clock_skew -ideal -plus_uncertainty tpskew find(clock, nSMMEMCLK)
/* set plus clock skew */

set_clock_transition 0 nSMMEMCLK
/* ignore all transition times as it is an ideal clock */

set_load 0 nSMMEMCLK
/* Zero load clock signal */

set_resistance 0 find(net, nSMMEMCLK)
/* Zero resistance for zero net delay(interconnect delay) on */
/* ideal clock net                                           */

set_dont_touch_network find(clock, nSMMEMCLK)
/* Preserve the clock net during optimisation */

/******************************************************************************/
/* SMFBCLK0 DEFINITION
/******************************************************************************/

create_clock -p tclk -w {feedback tclkfh} -name SMFBCLK0 \
                                          find(port, "SMFBCLK0")
/* period tclk, rise at feedback, fall after tclkfh High phase */

set_clock_skew -ideal -plus_uncertainty tpskew find(clock, SMFBCLK0)
/* set plus clock skew */

set_clock_transition 0 SMFBCLK0
/* ignore all transition times as it is an ideal clock */

set_load 0 SMFBCLK0
/* Zero load clock signal */

set_resistance 0 find(net, SMFBCLK0)
/* Zero resistance for zero net delay(interconnect delay) on */
/* ideal clock net                                           */

set_dont_touch_network find(clock, SMFBCLK0)
/* Preserve the clock net during optimisation */


/******************************************************************************/
/* SMFBCLK1 DEFINITION
/******************************************************************************/
create_clock -p tclk -w {feedback tclkfh} -name SMFBCLK1 \
                                          find(port, "SMFBCLK1")
/* period tclk, rise at 0, fall after tclkh High phase */

set_clock_skew -ideal -plus_uncertainty tpskew find(clock, SMFBCLK1)
/* set plus clock skew */

set_clock_transition 0 SMFBCLK1
/* ignore all transition times as it is an ideal clock */

set_load 0 SMFBCLK1
/* Zero load clock signal */

set_resistance 0 find(net, SMFBCLK1)
/* Zero resistance for zero net delay(interconnect delay) on */
/* ideal clock net                                           */

set_dont_touch_network find(clock, SMFBCLK1)
/* Preserve the clock net during optimisation */


/******************************************************************************/
/* SMFBCLK2 DEFINITION
/******************************************************************************/
create_clock -p tclk -w {feedback tclkfh} -name SMFBCLK2 \
                                          find(port, "SMFBCLK2")
/* period tclk, rise at 0, fall after tclkh High phase */

set_clock_skew -ideal -plus_uncertainty tpskew find(clock, SMFBCLK2)
/* set plus clock skew */

set_clock_transition 0 SMFBCLK2
/* ignore all transition times as it is an ideal clock */

set_load 0 SMFBCLK2
/* Zero load clock signal */

set_resistance 0 find(net, SMFBCLK2)
/* Zero resistance for zero net delay(interconnect delay) on */
/* ideal clock net                                           */

set_dont_touch_network find(clock, SMFBCLK2)
/* Preserve the clock net during optimisation */


/******************************************************************************/
/* SMFBCLK3 DEFINITION
/******************************************************************************/
create_clock -p tclk -w {feedback tclkfh} -name SMFBCLK3 \
                                          find(port, "SMFBCLK3")
/* period tclk, rise at 0, fall after tclkh High phase */

set_clock_skew -ideal -plus_uncertainty tpskew find(clock, SMFBCLK3)
/* set plus clock skew */

set_clock_transition 0 SMFBCLK3
/* ignore all transition times as it is an ideal clock */

set_load 0 SMFBCLK3
/* Zero load clock signal */

set_resistance 0 find(net, SMFBCLK3)
/* Zero resistance for zero net delay(interconnect delay) on */
/* ideal clock net                                           */

set_dont_touch_network find(clock, SMFBCLK3)
/* Preserve the clock net during optimisation */


/******************************************************************************/
/* RESET SIGNAL CONSTRAINTS                                                   */
/******************************************************************************/

/* Constraining AHB reset signal HRESETn */
set_input_delay -clock HCLK -max tidmaxresetn HRESETn
set_input_delay -clock HCLK -min tidminresetn HRESETn

set_drive 0 HRESETn
/* Infinite drive strength reset signal */

set_load 0 HRESETn
/* Zero load reset signal */

remove_driving_cell find(port, HRESETn)
/* Set no driving cell on reset */

set_resistance 0 find(net, HRESETn)
/* Zero resistance for zero net delay(interconnect delay) on */
/* ideal reset net                                           */

set_dont_touch_network find(port, HRESETn)
/* Preserve the reset net during optimisation */

include scripts/Ssmc.scr
/* Ssmc.scr defines the input and output delay constraints for the block  */

include scripts/Ssmc_exceptions.scr
/* Ssmc_exceptions.scr defines the false paths for Ssmc */

current_design = topname

/******************************************************************************/
/* Fix minimum timing violations                                              */
/******************************************************************************/
set_fix_hold all_clocks()

/******************************************************************************/
/* Change the naming style for verilog netlist                                */
/******************************************************************************/
change_names -rules verilog -hierarchy -verbose

/* The place where the test reports are to be written out into    */
report_name_base = "report/" + topname + "_" + test_req + "_" + hdl + \
  "_" + hdl_out
 
/******************************************************************************/
/* COMPILE
/******************************************************************************/
if (test_req == scaninsert) {
/* Scan Insert Synthesis */

  /* script to acquire Test-Compiler */
  remove_license Test-Compiler
  get_license Test-Compiler
  while (dc_shell_status == 0)
  {
    sh sleep 30;
    get_license Test-Compiler
  }

  uniquify

  /* Compile with scan */
  compile -scan -map_effort high

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

  /* Compile incremental using high CPU effort */
  /* This compile performs scan replacement    */
  compile -scan -map_effort high -inc

  set_scan_configuration -route true
  /* Route the scan chain for the scaninsert compile */

  /* Perform Scan Insertion */
  include scripts/Ssmc_scan.cmd

} else {
/* no scan synthesis*/

  uniquify

  /* Compile without scan */
  compile -map_effort high

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

  compile -map_effort high -inc


}

/* Check whether timing parameters are valid.           */
/* Unconstrained ports, gated clocks etc. are reported. */
echo                >> run_time_log
echo "check_timing" >> run_time_log
echo "============" >> run_time_log
echo                >> run_time_log
check_timing        >> run_time_log


current_design = topname
 
/* Restore clock period to reflect actual target frequency */
/* Define Clock phase time */
tclkh = 3.75

/* Clock skew */
tmskewforhalfclk = tclkh * 0.0125
/* minus skew set to 2.5% of clock - for setup checks */

tmskew = tmskewforhalfclk * 2
/* minus skew set to 2.5% of clock - for setup checks */

tpskew = tmskew * 0.40 /* plus  skew set to 40% of tmskew - for hold checks  */

tclkh = tclkh - tmskewforhalfclk

oc_margin = 0.0
/* If the synthesis needs to be performed with an over-constrained */
/* clock set this parameter to a non-zero value. For example if    */
/* oc_margin is set to 0.5, the clock period will be reduced by    */
/* 1.0 ns.                                                         */

tclkh = tclkh - oc_margin

/* define feedback clock delta for SMFBCLK */
feedback = 2

/* define feedback clock delta for SMMEMCLKDELAY */
feedbackdelay = tclkh

/* feed back clock rise time for SMFBCLK */
tclkfh = tclkh + feedback

/* feed back clock rise time for SMFBCLKDELAY */
tclkfdelayh = tclkh + feedbackdelay

include scr_common_area + "/amba_params.scr"
/* amba_params.scr defines the AHB timing parameters */

include scr_common_area + "/ahb_slave.scr"
/* ahb_slave.scr defines the AHB timing constraints using the above */

include scr_common_area + "/ahb_master.scr"
/* ahb_master.scr defines the AHB timing constraints using the above */

current_design = topname

/******************************************************************************/
/* SMMEMCLK DEFINTION                                                         */
/******************************************************************************/
create_clock -p tclk -w {0 tclkh} find(port, "SMMEMCLK")
/* period tclk, rise at 0, fall after tclkh High phase */

set_clock_skew -ideal -plus_uncertainty tpskew find(clock, SMMEMCLK)
/* set plus clock skew */

set_clock_transition 0 SMMEMCLK
/* ignore all transition times as it is an ideal clock */

set_drive 0 SMMEMCLK
/* Infinite drive strength clock signal */

set_load 0 SMMEMCLK
/* Zero load clock signal */

remove_driving_cell find(port, SMMEMCLK)
/* Set no driving cell on clock */

set_resistance 0 find(net, SMMEMCLK)
/* Zero resistance for zero net delay(interconnect delay) on */
/* ideal clock net                                           */

set_dont_touch_network find(clock, SMMEMCLK)
/* Preserve the clock net during optimisation */

/******************************************************************************/
/* SMMEMCLKDELAY DEFINITION
/******************************************************************************/

create_clock -p tclk -w {feedbackdelay tclkfdelayh} -name SMMEMCLKDELAY \
                                          find(port, "SMMEMCLKDELAY")
/* period tclk, rise at feedbackdelay, fall after tclkfdelayh High phase */

set_clock_skew -ideal -plus_uncertainty tpskew find(clock, SMMEMCLKDELAY)
/* set plus clock skew */

set_clock_transition 0 SMMEMCLKDELAY
/* ignore all transition times as it is an ideal clock */

set_load 0 SMMEMCLKDELAY
/* Zero load clock signal */

set_resistance 0 find(net, SMMEMCLKDELAY)
/* Zero resistance for zero net delay(interconnect delay) on */
/* ideal clock net                                           */

set_dont_touch_network find(clock, SMMEMCLKDELAY)
/* Preserve the clock net during optimisation */

/******************************************************************************/
/* nSMMEMCLK DEFINITION
/******************************************************************************/

create_clock -p tclk -w {feedbackdelay tclkfdelayh} -name nSMMEMCLK \
                                          find(port, "nSMMEMCLK")
/* period tclk, rise at feedbackdelay, fall after tclkfdelayh High phase */

set_clock_skew -ideal -plus_uncertainty tpskew find(clock, nSMMEMCLK)
/* set plus clock skew */

set_clock_transition 0 nSMMEMCLK
/* ignore all transition times as it is an ideal clock */

set_load 0 nSMMEMCLK
/* Zero load clock signal */

set_resistance 0 find(net, nSMMEMCLK)
/* Zero resistance for zero net delay(interconnect delay) on */
/* ideal clock net                                           */

set_dont_touch_network find(clock, nSMMEMCLK)
/* Preserve the clock net during optimisation */

/******************************************************************************/
/* SMFBCLK0 DEFINITION
/******************************************************************************/

create_clock -p tclk -w {feedback tclkfh} -name SMFBCLK0 \
                                          find(port, "SMFBCLK0")
/* period tclk, rise at 0, fall after tclkh High phase */

set_clock_skew -ideal -plus_uncertainty tpskew find(clock, SMFBCLK0)
/* set plus clock skew */

set_clock_transition 0 SMFBCLK0
/* ignore all transition times as it is an ideal clock */

set_load 0 SMFBCLK0
/* Zero load clock signal */

set_resistance 0 find(net, SMFBCLK0)
/* Zero resistance for zero net delay(interconnect delay) on */
/* ideal clock net                                           */

set_dont_touch_network find(clock, SMFBCLK0)
/* Preserve the clock net during optimisation */


/******************************************************************************/
/* SMFBCLK1 DEFINITION
/******************************************************************************/
create_clock -p tclk -w {feedback tclkfh} -name SMFBCLK1 \
                                          find(port, "SMFBCLK1")
/* period tclk, rise at 0, fall after tclkh High phase */

set_clock_skew -ideal -plus_uncertainty tpskew find(clock, SMFBCLK1)
/* set plus clock skew */

set_clock_transition 0 SMFBCLK1
/* ignore all transition times as it is an ideal clock */

set_load 0 SMFBCLK1
/* Zero load clock signal */

set_resistance 0 find(net, SMFBCLK1)
/* Zero resistance for zero net delay(interconnect delay) on */
/* ideal clock net                                           */

set_dont_touch_network find(clock, SMFBCLK1)
/* Preserve the clock net during optimisation */


/******************************************************************************/
/* SMFBCLK2 DEFINITION
/******************************************************************************/
create_clock -p tclk -w {feedback tclkfh} -name SMFBCLK2 \
                                          find(port, "SMFBCLK2")
/* period tclk, rise at 0, fall after tclkh High phase */

set_clock_skew -ideal -plus_uncertainty tpskew find(clock, SMFBCLK2)
/* set plus clock skew */

set_clock_transition 0 SMFBCLK2
/* ignore all transition times as it is an ideal clock */

set_load 0 SMFBCLK2
/* Zero load clock signal */

set_resistance 0 find(net, SMFBCLK2)
/* Zero resistance for zero net delay(interconnect delay) on */
/* ideal clock net                                           */

set_dont_touch_network find(clock, SMFBCLK2)
/* Preserve the clock net during optimisation */


/******************************************************************************/
/* SMFBCLK3 DEFINITION
/******************************************************************************/
create_clock -p tclk -w {feedback tclkfh} -name SMFBCLK3 \
                                          find(port, "SMFBCLK3")
/* period tclk, rise at 0, fall after tclkh High phase */

set_clock_skew -ideal -plus_uncertainty tpskew find(clock, SMFBCLK3)
/* set plus clock skew */

set_clock_transition 0 SMFBCLK3
/* ignore all transition times as it is an ideal clock */

set_load 0 SMFBCLK3
/* Zero load clock signal */

set_resistance 0 find(net, SMFBCLK3)
/* Zero resistance for zero net delay(interconnect delay) on */
/* ideal clock net                                           */

set_dont_touch_network find(clock, SMFBCLK3)
/* Preserve the clock net during optimisation */



include scripts/Ssmc.scr
/* Ssmc.scr defines the input and output delay constraints for the */
/* block                                                          */

include scripts/Ssmc_exceptions.scr
/* Ssmc_exceptions.scr defines the false paths for Ssmc */

/* The place where the test reports are to be written out into    */
report_name_base = "report/" + topname + "_" + test_req + "_" + hdl + \
  "_" + hdl_out
 
set_resistance 0 HRESETn
set_drive 0 HRESETn

current_design = topname

/******************************************************************************/
/* INCREMENTAL COMPILE
/******************************************************************************/
if (test_req == scaninsert) {
/* Scan Insert Synthesis */

  /* script to acquire Test-Compiler */
  remove_license Test-Compiler
  get_license Test-Compiler
  while (dc_shell_status == 0)
  {
    sh sleep 30;
    get_license Test-Compiler
  }

  /* Incremental compile using high CPU effort on the complete design */
  compile -scan -map_effort high -inc

} else {
/* no scan synthesis*/

  current_design = topname
  /* Compile incremental using high CPU effort */
  compile -map_effort high -inc
}

current_design = topname

set_resistance 0 HRESETn
set_drive 0 HRESETn

current_design = topname

/******************************************************************************/
/* Change the naming style for verilog netlist                                */
/******************************************************************************/
change_names -rules verilog -hierarchy -verbose

current_design = topname

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
report_transitive_fanout -clock_tree -nosplit > report_name_base + ".clocktree"
/* Report the Clock Tree information to check if any buffers present */

report_transitive_fanout -from HRESETn -nosplit > report_name_base + \
  ".resettree"
/* Report the Reset Tree information to check if any buffers present */

report_cell  > report_name_base + ".cell"
/* 'report_cell' provides information about all cells in the current design   */

report_reference > report_name_base + ".ref"
/* 'report_reference' provides information about all cell references in the   */
/* current design                                                             */

report_hierarchy > report_name_base + ".hier"
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

if (hdl_out == vhdl) { /*
  change_names -rule "CB25CAD_VHDL" -hierarchy
  change_names -rules SPECIAL_VHDL -hierarchy */
} else if (hdl_out == verilog) { /*
  change_names -rule "CB25CAD_VLOG" -hierarchy
  change_names -rules COLLAPSE -hierarchy */
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
echo " SSMC DONE "

/************************** End of Ssmc.cmd ***********************************/
