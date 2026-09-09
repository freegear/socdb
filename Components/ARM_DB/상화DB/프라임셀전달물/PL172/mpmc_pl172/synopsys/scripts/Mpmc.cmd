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
-- File Name              : Mpmc.cmd.rca
-- File Revision          : 1.9
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Synopsys synthesis master compile script for the MPMC top-level
--           block.
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
--           This script reads in the db's of MpmcCore and MpmcTIC and  
--           does a top level compile.  A top level compile is required, 
--           as MpmcTIC is synthesized at 10MHz and MpmcCore is synthesized 
--           at 151MHz.
--          
--           The top level block is synthesized at 151MHz, with all the I/O
--           to TIC blocks made as false path.
--
-- --=========================================================================*/

/******************************************************************************/
/* Please ensure that the following environment variables are set before      */
/* synthesis invocation.                                                      */
/*                                                                            */
/* GLOBAL       [path to shared files]                                        */
/*                                                                            */
/* PERIPH       [set this to 'Mpmc']                                          */
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

/* define the synthesis parameters to be used for the synthesis */
synth_base_area = get_unix_variable("GLOBAL")
scr_common_area = synth_base_area + "/synopsys_shared/scr_common"
include scr_common_area + "/setup.scr"

/* Note that the scr_common_area contains the following files that are common */
/* to other PrimeCell peripherals. These files may require modification to    */
/* reflect the technology that the user is targetting to.                     */
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

echo "MPMC SYNTHESIS TIME LOG" > run_time_log
echo "======================" >> run_time_log
echo                          >> run_time_log
echo -n "START TIME -> "      >> run_time_log
sh date                       >> run_time_log
echo                          >> run_time_log

/******************************************************************************/
/* Read in the DBs of the MpmcCore and MpmcTIC                                */
/******************************************************************************/
/* setting the search path for the db's   */
search_path = search_path + { . db }


if (test_req == noscan) {
  read "db/MpmcTIC_" + test_req + "_" + hdl + "_" + hdl_out + ".db"
  read "db/MpmcCore_" + test_req + "_" + hdl + "_" + hdl_out + ".db"
} else if ((test_req == scaninsert) || (test_req == scanready)) {
  read "db/MpmcTIC_scanready_" + hdl + "_" + hdl_out + ".db"
  read "db/MpmcCore_scanready_" + hdl + "_" + hdl_out + ".db"
}


/******************************************************************************/
/* Include library settings file for the library CB18                         */
/******************************************************************************/
include scr_common_area + "/library_avanti_cb18_v1.0.scr"

/* If the user is targetting a different technology, the above file needs to  */
/* be edited to include settings specific to that technology. The file should */
/* also be renamed appropriately.                                             */

/******************************************************************************/
/* DEFINE LIST OF SOURCE RTL FILES                                            */
/******************************************************************************/

if (hdl == vhdl) {
  file_list = {} + MpmcPackage
} else if (hdl == verilog) {
  sh cp ../verilog/rtl_source/MpmcParams.v .
  file_list = {}
}

file_list = file_list + MpmcRevAnd
file_list = file_list + MpmcClockOr
file_list = file_list + Mpmc

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
remove_design MpmcRevAnd
remove_design MpmcClockOr

/* Check that files have been read correctly and that various nodes are       */
/* connected.                                                                 */
echo                >> run_time_log
echo "check_design" >> run_time_log
echo "============" >> run_time_log
echo                >> run_time_log
check_design        >> run_time_log

current_design = topname

/******************************************************************************/
/* Link the MpmcCore and MpmcTIC using their db's                             */
/******************************************************************************/
link

/* Check that files have been read correctly and that various nodes are       */
/* connected.                                                                 */
echo                >> run_time_log
echo "check_design" >> run_time_log
echo "============" >> run_time_log
echo                >> run_time_log
check_design        >> run_time_log

/******************************************************************************/
/* Include library settings file for the library CB18                         */
/******************************************************************************/
include scr_common_area + "/library_avanti_cb18_v1.0.scr"

/* If the user is targetting a different technology, the above file needs to  */
/* be edited to include settings specific to that technology. The file should */
/* also be renamed appropriately.         


current_design = topname

/******************************************************************************/
/* APPLY CONSTRAINTS                                                          */
/* -----------------                                                          */
/* Clock details  Frequency tmskew tpskew Description                         */
/* HCLK           151MHz    0.164  0.066  AHB system clock                    */
/* MPMCCLK        151MHz    0.164  0.066  Memory controller clock             */
/* MPMCCLKDELAY   151MHz    0.164  0.066  Delayed version of MPMCCLK          */
/* MPMCFBCLKIN[0:3] 151MHz  0.164  0.066  Feedback clock from Memory Devices  */
/******************************************************************************/
current_design = topname

include scr_common_area + "/global.scr"
/* global.scr defines the environmental conditions */
/* for worst/best case library conditions and      */
/* defines default cell load and drive strength.   */

/******************************************************************************/
/* CLOCK TIMING CONSTRAINTS                                                   */
/******************************************************************************/
/* Define Clock phase time 3.33 ns (151MHz operation) */
tclkh = 3.33

/* Clock skew */
/* minus skew set to 2.5% of clock - for setup checks */
tmskewforhalfclk = 0.082

/* minus skew set to 2.5% of clock - for setup checks */
tmskew = tmskewforhalfclk * 2

/* plus  skew set to 40% of tmskew - for hold checks  */
tpskew = tmskew * 0.40

/* subtract tmskew for half clock from half clock period */
tclkh = tclkh - tmskewforhalfclk

/* Define over-constraining margin */
oc_margin = 0.00

/* If the synthesis needs to be performed with over-constraining,  */
/* set this parameter to a non-zero value. For example if          */
/* oc_margin is set to 0.5 ns, the clock period will be reduced by */
/* 1.0 ns                                                          */

/* Note that the phase is reduced (over-constrained) by 'oc_margin'  */
tclkh = tclkh - oc_margin
 
/* define feedback clock delta */
/* Since the clock period is 6.62 ns (after subtracting tmskew), providing  */
/* 0.5 ns between the ouput of the MPMCFBCLKIN register and the input of the*/
/* HCLK registers                                                           */
feedback = 6.12

/* feed back clock rise time */
tclkfh = tclkh + feedback

/* Define the delay of the delayed clock, with which the commands are clocked */
/* out in command-delayed mode                                                */
/* This will constrain the paths between MPMCCLK domain and MPMCCLKDELAY      */
/* domain as tightly as possible                                              */
delay = 1.0

/* Defining the negative edge of delayed clock                                */
tclkdh = tclkh + delay

/* tclk definition is done along with other AHB timing constraint settings in */
/* the amba_params.scr file                                                   */

/******************************************************************************/
/* AHB TIMING CONSTRAINTS                                                     */
/******************************************************************************/
/* amba_params.scr defines the AHB timing parameters */
include scr_common_area + "/amba_params.scr"

/* ahb_slave.scr defines the AHB timing constraints using the above */
include scr_common_area + "/ahb_slave.scr"

/* ahb_master.scr defines the AHB timing constraints using the above */
include scr_common_area + "/ahb_master.scr"

/******************************************************************************/
/* MPMCCLK DEFINTION                                                          */
/******************************************************************************/
/* period tclk, rise at 0, fall after tclkh High phase */
create_clock -p tclk -w {0 tclkh} find(port, "MPMCCLK")

/* set minus clock skew */
set_clock_skew -ideal -plus_uncertainty tpskew find(clock, MPMCCLK)

/* ignore all transition times as it is an ideal clock */
set_clock_transition 0 MPMCCLK

/* Infinite drive strength clock signal */
set_drive 0 MPMCCLK

/* Zero load clock signal */
set_load 0 MPMCCLK

/* Set no driving cell on clock */
remove_driving_cell find(port, MPMCCLK)

/* Zero resistance for zero net delay(interconnect delay) on */
/* ideal clock net                                           */
set_resistance 0 find(net, MPMCCLK)

/* Preserve the clock net during optimisation */
set_dont_touch_network find(clock, MPMCCLK)

/******************************************************************************/
/* MPMCFBCLKIN0 DEFINITION                                                    */
/******************************************************************************/
/* period tclk, rise at 0, fall after tclkh High phase */
create_clock -p tclk -w {feedback tclkfh} -name MPMCFBCLKIN0 \
                                          find(port, "MPMCFBCLKIN0")

/* set minus clock skew */
set_clock_skew -ideal -plus_uncertainty tpskew find(clock, MPMCFBCLKIN0)

/* ignore all transition times as it is an ideal clock */
set_clock_transition 0 MPMCFBCLKIN0

/* Zero load clock signal */
set_load 0 MPMCFBCLKIN0

/* Zero resistance for zero net delay(interconnect delay) on */
/* ideal clock net                                           */
set_resistance 0 find(net, MPMCFBCLKIN0)

/* Preserve the clock net during optimisation */
set_dont_touch_network find(clock, MPMCFBCLKIN0)

/******************************************************************************/
/* MPMCFBCLKIN1 DEFINITION                                                    */
/******************************************************************************/
/* period tclk, rise at 0, fall after tclkh High phase */
create_clock -p tclk -w {feedback tclkfh} -name MPMCFBCLKIN1 \
                                          find(port, "MPMCFBCLKIN1")

/* set minus clock skew */
set_clock_skew -ideal -plus_uncertainty tpskew find(clock, MPMCFBCLKIN1)

/* ignore all transition times as it is an ideal clock */
set_clock_transition 0 MPMCFBCLKIN1

/* Zero load clock signal */
set_load 0 MPMCFBCLKIN1

/* Zero resistance for zero net delay(interconnect delay) on */
/* ideal clock net                                           */
set_resistance 0 find(net, MPMCFBCLKIN1)

/* Preserve the clock net during optimisation */
set_dont_touch_network find(clock, MPMCFBCLKIN1)

/******************************************************************************/
/* MPMCFBCLKIN2 DEFINITION                                                    */
/******************************************************************************/
/* period tclk, rise at 0, fall after tclkh High phase */
create_clock -p tclk -w {feedback tclkfh} -name MPMCFBCLKIN2 \
                                          find(port, "MPMCFBCLKIN2")

/* set minus clock skew */
set_clock_skew -ideal -plus_uncertainty tpskew find(clock, MPMCFBCLKIN2)

/* ignore all transition times as it is an ideal clock */
set_clock_transition 0 MPMCFBCLKIN2

/* Zero load clock signal */
set_load 0 MPMCFBCLKIN2

/* Zero resistance for zero net delay(interconnect delay) on */
/* ideal clock net                                           */
set_resistance 0 find(net, MPMCFBCLKIN2)

/* Preserve the clock net during optimisation */
set_dont_touch_network find(clock, MPMCFBCLKIN2)

/******************************************************************************/
/* MPMCFBCLKIN3 DEFINITION                                                    */
/******************************************************************************/
/* period tclk, rise at 0, fall after tclkh High phase */
create_clock -p tclk -w {feedback tclkfh} -name MPMCFBCLKIN3 \
                                          find(port, "MPMCFBCLKIN3")

/* set minus clock skew */
set_clock_skew -ideal -plus_uncertainty tpskew find(clock, MPMCFBCLKIN3)

/* ignore all transition times as it is an ideal clock */
set_clock_transition 0 MPMCFBCLKIN3

/* Zero load clock signal */
set_load 0 MPMCFBCLKIN3

/* Zero resistance for zero net delay(interconnect delay) on */
/* ideal clock net                                           */
set_resistance 0 find(net, MPMCFBCLKIN3)

/* Preserve the clock net during optimisation */
set_dont_touch_network find(clock, MPMCFBCLKIN3)

/******************************************************************************/
/* MPMCCLKDELAY DEFINITION                                                    */
/******************************************************************************/
/* period tclk, rise at delay, fall after tclkh + delay High phase */
create_clock -p tclk -w {delay tclkdh} find(port, "MPMCCLKDELAY")

/* set minus clock skew */
set_clock_skew -ideal -plus_uncertainty tpskew find(clock, MPMCCLKDELAY)

/* ignore all transition times as it is an ideal clock */
set_clock_transition 0 MPMCCLKDELAY

/* Infinite drive strength clock signal */
set_drive 0 MPMCCLKDELAY

/* Zero load clock signal */
set_load 0 MPMCCLKDELAY

/* Set no driving cell on clock */
remove_driving_cell find(port, MPMCCLKDELAY)

/* Zero resistance for zero net delay(interconnect delay) on */
/* ideal clock net                                           */
set_resistance 0 find(net, MPMCCLKDELAY)

/* Preserve the clock net during optimisation */
set_dont_touch_network find(clock, MPMCCLKDELAY)

/******************************************************************************/
/* Create virtual clock to be used for constraining the paths                 */
/******************************************************************************/
/* period tclk, rise at delay, fall after tclkh + delay High phase */
create_clock -p tclk -w {delay tclkdh} -name v_MPMCCLKDELAY

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

/* Zero resistance for zero net delay(interconnect delay) on */
/* ideal reset net                                           */
set_resistance 0 find(net, HRESETn)

/* Preserve the reset net during optimisation */
set_dont_touch_network find(port, HRESETn)

/* Constraining system reset signal nPOR with HCLK */
set_input_delay -clock HCLK -max tidmaxresetn -add_delay nPOR
set_input_delay -clock HCLK -min tidminresetn -add_delay nPOR

/* Constraining system reset signal nPOR with MPMCCLK */
set_input_delay -clock MPMCCLK -max tidmaxresetn -add_delay nPOR
set_input_delay -clock MPMCCLK -min tidminresetn -add_delay nPOR

/* Constraining system reset signal nPOR with MPMCFBCLKIN0 */
set_input_delay -clock MPMCFBCLKIN0 -max tidmaxresetn -add_delay nPOR
set_input_delay -clock MPMCFBCLKIN0 -min tidminresetn -add_delay nPOR

/* Constraining system reset signal nPOR with MPMCFBCLKIN3 */
set_input_delay -clock MPMCFBCLKIN1 -max tidmaxresetn -add_delay nPOR
set_input_delay -clock MPMCFBCLKIN1 -min tidminresetn -add_delay nPOR

/* Constraining system reset signal nPOR with MPMCFBCLKIN2 */
set_input_delay -clock MPMCFBCLKIN2 -max tidmaxresetn -add_delay nPOR
set_input_delay -clock MPMCFBCLKIN2 -min tidminresetn -add_delay nPOR

/* Constraining system reset signal nPOR with MPMCFBCLKIN3 */
set_input_delay -clock MPMCFBCLKIN3 -max tidmaxresetn -add_delay nPOR
set_input_delay -clock MPMCFBCLKIN3 -min tidminresetn -add_delay nPOR

/* Constraining system reset signal nPOR with MPMCCLKDELAY */
set_input_delay -clock MPMCCLKDELAY -max tidmaxresetn -add_delay nPOR
set_input_delay -clock MPMCCLKDELAY -min tidminresetn -add_delay nPOR

/* Infinite drive strength reset signal */
set_drive 0 nPOR

/* Zero load reset signal */
set_load 0 nPOR

/* Set no driving cell on reset */
remove_driving_cell find(port, nPOR)

/* Zero resistance for zero net delay(interconnect delay) on */
/* ideal reset net                                           */
set_resistance 0 find(net, nPOR)

/* Preserve the reset net during optimisation */
set_dont_touch_network find(port, nPOR)

/******************************************************************************/
/* NON-AMBA INPUT / OUTPUT PORT CONSTRAINTS                                   */
/******************************************************************************/
/* Mpmc.scr defines the input and output delay constraints for the block  */
include scripts/Mpmc.scr

/* Mpmc_exceptions.scr defines the false paths for Mpmc */
include scripts/Mpmc_exceptions.scr

/* Check whether timing parameters are valid.           */
/* Unconstrained ports, gated clocks etc. are reported. */
echo                >> run_time_log
echo "check_timing" >> run_time_log
echo "============" >> run_time_log
echo                >> run_time_log
check_timing        >> run_time_log

current_design = topname

/******************************************************************************/
/* Fix minimum timing violations                                              */
/******************************************************************************/
set_fix_hold all_clocks()

/* The place where the test reports are to be written out into    */
report_name_base = "report/" + topname + "_" + test_req + "_" + hdl + \
  "_" + hdl_out
 
/******************************************************************************/
/* COMPILE
/******************************************************************************/

if (test_req == scanready) {
/************************/
/* Scan Ready Synthesis */
/************************/
  
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


  /* Compile with scan and incremental effort, as the db's have already been 
   * compiled once */
  compile -scan -map_effort high -inc

}

if (test_req == scaninsert) {
/*************************/
/* Scan Insert Synthesis */
/*************************/

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

  /* Route the scan chain for the scaninsert compile */
  set_scan_configuration -route true

  /* Perform Scan Insertion */
  include scripts/Mpmc_scan.cmd

}

if (test_req == noscan) {
/********************/
/* No scan synthesis*/
/********************/

  /* Compile without scan and incremental effort, as the db's have already been 
   * compiled once */
  compile -map_effort high -inc
  /* Incremental compile using high CPU effort on the complete design */
}

/******************************************************************************/
/* Create virtual clock to be used for constraining the paths                 */
/******************************************************************************/
/* period tclk, rise at delay, fall after tclkh + delay High phase */
create_clock -p tclk -w {delay tclkdh} -name v_MPMCCLKDELAY

/******************************************************************************/
/* APPLY CONSTRAINTS AT CORRECT FREQUENCY - REMOVING OVERCONSTRAINING         */
/******************************************************************************/
/* Restore clock period to reflect actual target frequency                    */
/* Define Clock phase time 3.33 ns (151MHz operaiton) */ 
tclkh = 3.33
tclkh = tclkh - tmskewforhalfclk

/* Restore clock period to reflect actual target frequency */
oc_margin = 0.0

/* If the synthesis needs to be performed with an over-constrained */
/* clock set this parameter to a non-zero value. For example if    */
/* oc_margin is set to 0.5 ns, the clock period will be reduced by */
/* 1.0 ns.                                                         */

tclkh = tclkh - oc_margin

/* define feedback clock delta */
/* Since the clock period is 6.62 ns (after subtracting tmskew), providing  */
/* 0.5 ns between the ouput of the MPMCFBCLKIN register and the input of the*/
/* HCLK registers                                                           */
feedback = 6.12

/* feed back clock rise time */
tclkfh = tclkh + feedback

/* Define the delay of the delayed clock, with which the commands are clocked */
/* out in command-delayed mode                                                */
/* This will constrain the paths between MPMCCLK domain and MPMCCLKDELAY      */
/* domain as tightly as possible                                              */
delay = 1.0

/* Defining the negative edge of delayed clock                                */
tclkdh = tclkh + delay

/******************************************************************************/
/* AMBA SIGNAL CONSTRAINTS                                                    */
/******************************************************************************/
/* amba_params.scr defines the AHB timing parameters */
include scr_common_area + "/amba_params.scr"

/* ahb_slave.scr defines the AHB timing constraints using the above */
include scr_common_area + "/ahb_slave.scr"

/* ahb_master.scr defines the AHB timing constraints using the above */
include scr_common_area + "/ahb_master.scr"

/******************************************************************************/
/* MPMCCLK DEFINTION                                                          */
/******************************************************************************/
/* period tclk, rise at 0, fall after tclkh High phase */
create_clock -p tclk -w {0 tclkh} find(port, "MPMCCLK")

/* set minus clock skew */
set_clock_skew -ideal -plus_uncertainty tpskew find(clock, MPMCCLK)

/* ignore all transition times as it is an ideal clock */
set_clock_transition 0 MPMCCLK

/* Infinite drive strength clock signal */
set_drive 0 MPMCCLK

/* Zero load clock signal */
set_load 0 MPMCCLK

/* Set no driving cell on clock */
remove_driving_cell find(port, MPMCCLK)

/* Zero resistance for zero net delay(interconnect delay) on */
/* ideal clock net                                           */
set_resistance 0 find(net, MPMCCLK)

/* Preserve the clock net during optimisation */
set_dont_touch_network find(clock, MPMCCLK)

/******************************************************************************/
/* MPMCFBCLKIN0 DEFINITION                                                    */
/******************************************************************************/
/* period tclk, rise at feedback, fall after tclkh + feedback High phase */
create_clock -p tclk -w {feedback tclkfh} -name MPMCFBCLKIN0 \
                                          find(port, "MPMCFBCLKIN0")

/* set minus clock skew */
set_clock_skew -ideal -plus_uncertainty tpskew find(clock, MPMCFBCLKIN0)

/* ignore all transition times as it is an ideal clock */
set_clock_transition 0 MPMCFBCLKIN0

/* Zero load clock signal */
set_load 0 MPMCFBCLKIN0

/* Zero resistance for zero net delay(interconnect delay) on */
/* ideal clock net                                           */
set_resistance 0 find(net, MPMCFBCLKIN0)

/* Preserve the clock net during optimisation */
set_dont_touch_network find(clock, MPMCFBCLKIN0)

/******************************************************************************/
/* MPMCFBCLKIN1 DEFINITION                                                    */
/******************************************************************************/
/* period tclk, rise at feedback, fall after tclkh + feedback High phase */
create_clock -p tclk -w {feedback tclkfh} -name MPMCFBCLKIN1 \
                                          find(port, "MPMCFBCLKIN1")

/* set minus clock skew */
set_clock_skew -ideal -plus_uncertainty tpskew find(clock, MPMCFBCLKIN1)

/* ignore all transition times as it is an ideal clock */
set_clock_transition 0 MPMCFBCLKIN1

/* Zero load clock signal */
set_load 0 MPMCFBCLKIN1

/* Zero resistance for zero net delay(interconnect delay) on */
/* ideal clock net                                           */
set_resistance 0 find(net, MPMCFBCLKIN1)

/* Preserve the clock net during optimisation */
set_dont_touch_network find(clock, MPMCFBCLKIN1)

/******************************************************************************/
/* MPMCFBCLKIN2 DEFINITION                                                    */
/******************************************************************************/
/* period tclk, rise at feedback, fall after tclkh + feedback High phase */
create_clock -p tclk -w {feedback tclkfh} -name MPMCFBCLKIN2 \
                                          find(port, "MPMCFBCLKIN2")

/* set minus clock skew */
set_clock_skew -ideal -plus_uncertainty tpskew find(clock, MPMCFBCLKIN2)

/* ignore all transition times as it is an ideal clock */
set_clock_transition 0 MPMCFBCLKIN2

/* Zero load clock signal */
set_load 0 MPMCFBCLKIN2

/* Zero resistance for zero net delay(interconnect delay) on */
/* ideal clock net                                           */
set_resistance 0 find(net, MPMCFBCLKIN2)

/* Preserve the clock net during optimisation */
set_dont_touch_network find(clock, MPMCFBCLKIN2)

/******************************************************************************/
/* MPMCFBCLKIN3 DEFINITION                                                    */
/******************************************************************************/
/* period tclk, rise at feedback, fall after tclkh + feedback High phase */
create_clock -p tclk -w {feedback tclkfh} -name MPMCFBCLKIN3 \
                                          find(port, "MPMCFBCLKIN3")

/* set minus clock skew */
set_clock_skew -ideal -plus_uncertainty tpskew find(clock, MPMCFBCLKIN3)

/* ignore all transition times as it is an ideal clock */
set_clock_transition 0 MPMCFBCLKIN3

/* Zero load clock signal */
set_load 0 MPMCFBCLKIN3

/* Zero resistance for zero net delay(interconnect delay) on */
/* ideal clock net                                           */
set_resistance 0 find(net, MPMCFBCLKIN3)

/* Preserve the clock net during optimisation */
set_dont_touch_network find(clock, MPMCFBCLKIN3)

/******************************************************************************/
/* MPMCCLKDELAY DEFINTION                                                     */
/******************************************************************************/
/* period tclk, rise at delay, fall after tclkh + delay High phase */
create_clock -p tclk -w {delay tclkdh} find(port, "MPMCCLKDELAY")

/* set minus clock skew */
set_clock_skew -ideal -plus_uncertainty tpskew find(clock, MPMCCLKDELAY)

/* ignore all transition times as it is an ideal clock */
set_clock_transition 0 MPMCCLKDELAY

/* Infinite drive strength clock signal */
set_drive 0 MPMCCLKDELAY

/* Zero load clock signal */
set_load 0 MPMCCLKDELAY

/* Set no driving cell on clock */
remove_driving_cell find(port, MPMCCLKDELAY)

/* Zero resistance for zero net delay(interconnect delay) on */
/* ideal clock net                                           */
set_resistance 0 find(net, MPMCCLKDELAY)

/* Preserve the clock net during optimisation */
set_dont_touch_network find(clock, MPMCCLKDELAY)

/******************************************************************************/
/* Create virtual clock to be used for constraining the paths                 */
/******************************************************************************/
/* period tclk, rise at delay, fall after tclkh + delay High phase */
create_clock -p tclk -w {delay tclkdh} -name v_MPMCCLKDELAY

/******************************************************************************/
/* NON-AMBA INPUT / OUTPUT PORT CONSTRAINTS                                   */
/******************************************************************************/

/* Mpmc.scr defines the input and output delay constraints for the */
/* block                                                          */
include scripts/Mpmc.scr

/* Mpmc_exceptions.scr defines the point-to-point exceptions set   */
/* on the Mpmc block. These may be false_paths or multicycle_paths */
include scripts/Mpmc_exceptions.scr 

/* Check for any test problems */
if ((test_req == scanready) || (test_req == scaninsert)){
  echo              >> run_time_log
  echo "check_test" >> run_time_log
  echo "==========" >> run_time_log
  echo              >> run_time_log
  check_test        >> run_time_log
}
 
current_design = topname

/* Fix minimum timing violations */
set_fix_hold all_clocks()

/* Make the reset signals as ideal nets */
set_resistance 0 HRESETn
set_drive 0 HRESETn

set_resistance 0 nPOR
set_drive 0 nPOR

/* The place where the test reports are to be written out into    */
report_name_base = "report/" + topname + "_" + test_req + "_" + hdl + \
  "_" + hdl_out

/******************************************************************************/
/* GENERATE VIOLATION REPORT                                                  */
/******************************************************************************/

/* Output a detailed constraints report listing all violations */
/* in descending order, written to the report area.            */
report_constraint -verbose -all_violators > report_name_base + ".vio"

/******************************************************************************/
/* GENERATE TIMING REPORTS                                                    */
/******************************************************************************/

/* Output a maximum delay timing report for upto 100 paths,     */
/* with upto 10 paths per endpoint, written to the report area. */
report_timing -delay max -path full -max_paths 100 -nworst 10 \
  > report_name_base + ".max"

/* Output a minimum delay timing report for upto 100 paths,     */
/* with upto 10 paths per endpoint, written to the report area. */
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

/* 'report_design' displays information about the current design and */
/* its environment. It lists out the library used, operating         */
/* conditions, wireload models used etc.                             */
report_design > report_name_base + ".constr"

/* 'report_constraint' displays constraint-related information about */
/* the design.                                                       */
report_constraint >> report_name_base + ".constr"

/* 'report_clock' provides a summary of all the defined clocks, */
/* their period waveform and any attributes set on them.        */
report_clock >> report_name_base + ".constr" 

/* 'report_attribute' reports attribute related to the design */
report_attribute -design  >> report_name_base + ".constr"

/* Report information about ports of design */
report_port -verbose  > report_name_base + ".ports"

/******************************************************************************/
/* GENERATE  REPORTS for Clock + Reset tree information, abouts Cells used    */
/* and their heirarchy                                                        */
/******************************************************************************/
/* Report the Clock Tree information to check if any buffers present */
report_transitive_fanout -clock_tree -nosplit > report_name_base + ".clocktree"

/* Report the Reset Tree information to check if any buffers present */
report_transitive_fanout -from HRESETn -nosplit > report_name_base + \
  ".resettree"
report_transitive_fanout -from nPOR -nosplit >> report_name_base + \
  ".resettree"

/* 'report_cell' provides information about all cells in the current design   */
report_cell  > report_name_base + ".cell"

/* 'report_reference' provides information about all cell references in the   */
/* current design                                                             */
report_reference > report_name_base + ".ref"

/* 'report_hierarchy' lists out the cells used in the design hierarchically   */
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
/* Check for combinational loops */ 
echo " CHECK FOR COMBINATIONAL LOOPS " >> report_name_base + ".latch"
report_timing -loops >> report_name_base + ".latch"

/* The report files should contain no violations or errors */
/* and ideally zero or a minimal number of warnings        */

/******************************************************************************/
/* ACQUIRE HDL COMPILER                                                       */
/******************************************************************************/
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

/* Naming rules are defined in the name_rules_cb18.scr file residing in  */
/* scr_common_area. If any alternate naming rules are to be defined      */
/* please include them in the name_rules_cb18.scr file.                  */

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

/* Compatibility Note :                                                       */
/* Synopsys 1999.05 write_sdf supersedes write_timing                         */
/* Pre-1999.05 command syntax is shown below                                  */
/* For vhdl netlist:                                                          */
/*    write_timing -format sdf-v2.1 -context vhdl \                           */
/*      -out netlist_area + "/" + topname + stype + "_Vhdl.sdf21"             */
/* For verilog netlist:                                                       */
/*    write_timing -format sdf-v2.1 -context verilog \                        */
/*      -out netlist_area + "/" + topname + stype + "_Verilog.sdf21"          */

/* v2.1 SDF output format is produced */

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
echo " MPMC DONE "

/************************** End of Mpmc.cmd ***********************************/
