/* --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001-2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
-- 
-- Version and Release Control Information:
-- 
-- File Name              : MpmcCore.cmd.rca
-- File Revision          : 1.10
-- 
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
-- 
-- -----------------------------------------------------------------------------
-- Purpose :
--           Synopsys synthesis master compile script            
--           for the MPMCCore block, which is the core memory controller part
--           of the MPMC.
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
--           This block is compiled seperately at 151MHz, and TIC
--           is compiled seperately at 10MHz. These two blocks are
--           then compiled together in a top level script.
--
-- --=========================================================================*/

/******************************************************************************/
/* Please ensure that the following environment variables are set             */
/* before synthesis invocation.                                               */
/*                                                                            */
/* GLOBAL       [path to shared files]                                        */
/*                                                                            */
/* PERIPH       [set this to 'Mpmc']                                          */
/*                                                                            */
/* TEST_METH    [set this to either 'noscan' or                               */
/*               'scanready']                                                 */
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
/* FLAG ERROR AND QUIT IF SCANINSERT SYNTHESIS IS ATTEMPTED                   */
/******************************************************************************/
if (test_req == scaninsert) {
  echo "SCANINSERT SYNTHESIS NOT ALLOWED FOR MPMCCORE"
  echo "Please change the TEST_METH environment variable to scanready or noscan"
  quit
}

/******************************************************************************/
/* Select the module to be synthesised                                        */
/******************************************************************************/
topname = MpmcCore

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
hdl_out = vhdl
*/

/******************************************************************************/
/* WRITE SYNTHESIS RUN START TIME                                             */
/******************************************************************************/
run_time_log = "log/" + topname + "_" + test_req + "_" + hdl + "_" + \
  hdl_out + "_synth.log"

echo "MPMC SYNTHESIS TIME LOG" >  run_time_log
echo "======================" >> run_time_log
echo                          >> run_time_log
echo -n "START TIME -> "      >> run_time_log
sh date                       >> run_time_log
echo                          >> run_time_log

/******************************************************************************/
/* DEFINE LIST OF SOURCE RTL FILES                                            */
/******************************************************************************/

if (hdl == vhdl) {
  file_list = {} + MpmcPackage
} else if (hdl == verilog) {
  sh cp ../verilog/rtl_source/MpmcParams.v .
  file_list = {}
}

file_list = file_list + MpmcRegIf
file_list = file_list + MpmcAhbif
file_list = file_list + MpmcEndian
file_list = file_list + MpmcAhbTop
file_list = file_list + MpmcArbiter
file_list = file_list + MpmcBuffer
file_list = file_list + MpmcBufCntrl
file_list = file_list + MpmcBufUnit
file_list = file_list + MpmcStRegBlk
file_list = file_list + MpmcStTSM
file_list = file_list + MpmcStExtIf
file_list = file_list + MpmcStIntIf
file_list = file_list + MpmcStTimCntl
file_list = file_list + MpmcStMemCntl
file_list = file_list + MpmcDyRegBlk
file_list = file_list + MpmcDyRegFile
file_list = file_list + MpmcDyFCntl
file_list = file_list + MpmcDyFBtoH
file_list = file_list + MpmcDyFIFO
file_list = file_list + MpmcDyIntRegBlk
file_list = file_list + MpmcDyIntRdGen
file_list = file_list + MpmcDyAxsSM1
file_list = file_list + MpmcDyAxsSM2
file_list = file_list + MpmcDyRefSM
file_list = file_list + MpmcDyModSM
file_list = file_list + MpmcDySyFlash
file_list = file_list + MpmcDyLatCntr
file_list = file_list + MpmcDyMemCntl
file_list = file_list + MpmcMemCntlIf
file_list = file_list + MpmcMemBGnt
file_list = file_list + MpmcMemCntl
file_list = file_list + MpmcPadIf
file_list = file_list + MpmcCore

/******************************************************************************/
/* Currently PRESTO enabled reading of verilog files, impacts the synthesis   */
/* timing significantly. Hence PRESTO is disabled.                            */
/******************************************************************************/
hdlin_enable_presto = false

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
  sh rm MpmcParams.v
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

/******************************************************************************/
/* The MpmcAhbTop module is a structural module consisting of 2               */
/* submodules. There are combinational paths passing through the              */
/* modules. So to optimise these combinational paths MpmcAhbTop               */
/* module is ungrouped and flattened                                          */
/******************************************************************************/
current_design = MpmcAhbTop
ungroup -all -flatten

/******************************************************************************/
/* The designs are now flattened to a single entity. So the bottom            */
/* level designs are not required anymore. These are removed from the         */
/* the data base to avoid 'unwanted references to gtech library' and          */
/* 'black boxes' in the area report                                           */
/******************************************************************************/
remove_design MpmcAhbif
remove_design MpmcEndian

/******************************************************************************/
/* The MpmcBufUnit module is a structural module consisting of 2              */
/* submodules. There are combinational paths passing through the              */
/* modules. So to optimise these combinational paths MpmcBufUnit              */
/* module is ungrouped and flattened                                          */
/******************************************************************************/
current_design = MpmcBufUnit
ungroup -all -flatten

/******************************************************************************/
/* The designs are now flattened to a single entity. So the bottom            */
/* level designs are not required anymore. These are removed from the         */
/* the data base to avoid 'unwanted references to gtech library' and          */
/* 'black boxes' in the area report                                           */
/******************************************************************************/
remove_design MpmcBuffer
remove_design MpmcBufCntrl

/******************************************************************************/
/* The MpmcStMemCntl module is a structural module consisting of 5            */
/* submodules. There are combinational paths passing through the              */
/* modules. So to optimise these combinational paths MpmcStMemCntl            */
/* module is ungrouped and flattened                                          */
/******************************************************************************/
current_design = MpmcStMemCntl
ungroup -all -flatten

/******************************************************************************/
/* The designs are now flattened to a single entity. So the bottom            */
/* level designs are not required anymore. These are removed from the         */
/* the data base to avoid 'unwanted references to gtech library' and          */
/* 'black boxes' in the area report                                           */
/******************************************************************************/
remove_design MpmcStRegBlk
remove_design MpmcStTSM
remove_design MpmcStTimCntl
remove_design MpmcStExtIf
remove_design MpmcStIntIf

/******************************************************************************/
/* The MpmcDyMemCntl module is a structural module consisting of 13           */
/* submodules. There are combinational paths passing through the              */
/* modules. So to optimise these combinational paths MpmcDyMemCntl            */
/* module is ungrouped and flattened                                          */
/******************************************************************************/
current_design = MpmcDyMemCntl
ungroup -all -flatten

/******************************************************************************/
/* The designs are now flattened to a single entity. So the bottom            */
/* level designs are not required anymore. These are removed from the         */
/* the data base to avoid 'unwanted references to gtech library' and          */
/* 'black boxes' in the area report                                           */
/******************************************************************************/
remove_design MpmcDyRegBlk
remove_design MpmcDyAxsSM1
remove_design MpmcDyAxsSM2
remove_design MpmcDyIntRegBlk
remove_design MpmcDyIntRdGen
remove_design MpmcDyLatCntr
remove_design MpmcDyModSM
remove_design MpmcDyRefSM
remove_design MpmcDySyFlash
remove_design MpmcDyFIFO
remove_design MpmcDyRegFile
remove_design MpmcDyFCntl
remove_design MpmcDyFBtoH

current_design = topname

/* Check that files have been read correctly and that various nodes */
/* are connected.                                                   */
echo                >> run_time_log
echo "check_design" >> run_time_log
echo "============" >> run_time_log
echo                >> run_time_log
check_design        >> run_time_log

/******************************************************************************/
/* Include library settings file for the library CB18                         */
/******************************************************************************/
include scr_common_area + "/library_avanti_cb18_v1.0.scr"

/* If the user is targetting a different technology, the above file */
/* needs to be edited to include settings specific to that          */
/* technology. The file should also be renamed appropriately.       */ 
 
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
/* Define Clock phase time 3.33 ns (151MHz operation)*/
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
oc_margin = 0.05

/* If the synthesis needs to be performed with over-constraining,  */
/* set this parameter to a non-zero value. For example if          */
/* oc_margin is set to 0.5 ns, the clock period will be reduced by */
/* 1.0 ns                                                          */

/* Note that the phase is reduced (over-constrained) by 'oc_margin'  */
tclkh = tclkh - oc_margin
 
/* define feedback clock delta */
/* Since the clock period is 6.62 ns (after subtracting tmskew), providing  */
/* 0.5 ns between the ouput of the MPMCFBCLKIN register and  the input of   */
/* the HCLK registers                                                       */
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
/* MPMCFBCLKIN0 DEFINITION
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
/* MPMCFBCLKIN1 DEFINITION
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
/* MPMCFBCLKIN2 DEFINITION
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
/* MPMCFBCLKIN3 DEFINITION
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
/* MPMCCLKDELAY DEFINITION
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

/* Constraining system reset signal nPOR with MPMCFBCLKIN1 */
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
/* MpmcCore.scr defines the input and output delay constraints for the */
/* block                                                           */
include scripts/MpmcCore.scr

/* Check whether timing parameters are valid.           */
/* Unconstrained ports, gated clocks etc. are reported. */
echo                >> run_time_log
echo "check_timing" >> run_time_log
echo "============" >> run_time_log
echo                >> run_time_log
check_timing        >> run_time_log

/* MpmcCore_exceptions.scr defines the point-to-point exceptions set   */
/* on the MpmcCore block. These may be false_paths or multicycle_paths */
include scripts/MpmcCore_exceptions.scr 

/* Check whether timing parameters are valid.           */
/* Unconstrained ports, gated clocks etc. are reported. */
echo                >> run_time_log 
echo "check_timing" >> run_time_log
echo "============" >> run_time_log 
echo                >> run_time_log
check_timing        >> run_time_log 

current_design = topname

/******************************************************************************/
/* HIGH FANOUT NETS                                                           */
/******************************************************************************/

/* The peripheral should present only a single load to the AHB                */
/* For peripherals that have an AHB Slave interface as well, the command      */
/* below would include the HREADYIN port on the AHB Slave interface. This     */
/* would override any constraints previously set on this port in the          */
/* ahb_slave.scr script. This is not a problem since it is only the same      */
/* constraint that is being re-applied                                        */
set_max_fanout 1.0 HREADYIN*

/* Fix minimum timing violations */
set_fix_hold all_clocks()

set_critical_range 0.5 topname

/******************************************************************************/
/* COMPILE
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

/* Separately optimise multiple instantiations within the design, allocating  */
/* unique names to each instance.                                             */
current_design = topname
uniquify

/***********************/
/* Scanready synthesis */
/***********************/
if (test_req == scanready) {
  /* script to acquire Test-Compiler */

  remove_license Test-Compiler
  get_license Test-Compiler
  while (dc_shell_status == 0) {
    sh sleep 30
    get_license Test-Compiler
  }

  /* For the first pass of compile, limit the amount of time spent */
  /* to flatten the DesignWare components before the actual compile*/
  compile_cpu_limit = 1.0

  compile -scan -map_effort high
  /* Compile for an initial mapping of the design, so as to get the */
  /* DesignWare components in place. This compile performs scan     */
  /* replacement                                                    */

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

  /* For the second pass of compile remove the limit on the amount of */
  /* time spent                                                       */
  compile_cpu_limit = 0.0

  current_design = topname

  /* Compile using high CPU effort for mapping of design */
  /* This compile performs scan replacement              */
  compile -scan -map_effort high

  current_design = topname

  /* Compile incremental using high CPU effort */
  /* This compile performs scan replacement    */
  compile -scan -map_effort high -inc

}

/*********************/
/* No scan synthesis */
/*********************/
if (test_req == noscan) {

  /* For the first pass of compile, limit the amount of time spent */
  compile_cpu_limit = 1.0

  /* Compile using high CPU effort for mapping of design */
  /* This compile does NOT perform scan replacement      */
  compile -map_effort high

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

  /* For the second pass of compile remove the limit on the amount of */
  /* time spent                                                       */
  compile_cpu_limit = 0.0

  current_design = topname

  /* Compile using high CPU effort for mapping of design */
  /* This compile does NOT perform scan replacement      */
  compile -map_effort high

  /* Compile incremental using high CPU effort          */
  /* This compile does NOT performs scan replacement    */
  compile -map_effort high -inc
}

/******************************************************************************/
/* NON-AMBA INPUT / OUTPUT PORT CONSTRAINTS                                   */
/******************************************************************************/
/* MpmcCore.scr defines the input and output delay constraints for the */
/* block                                                           */
include scripts/MpmcCore.scr

/* Check whether timing parameters are valid.           */
/* Unconstrained ports, gated clocks etc. are reported. */
echo                >> run_time_log
echo "check_timing" >> run_time_log
echo "============" >> run_time_log
echo                >> run_time_log
check_timing        >> run_time_log

/* MpmcCore_exceptions.scr defines the point-to-point exceptions set   */
/* on the MpmcCore block. These may be false_paths or multicycle_paths */
include scripts/MpmcCore_exceptions.scr

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

/* Define Clock phase time 3.33ns (151MHz operation)*/
tclkh = 3.33
tclkh = tclkh - tmskewforhalfclk

/* define feedback clock delta */
/* Since the clock period is 6.62 ns (after subtracting tmskew), providing  */
/* 0.5 ns between the ouput of the MPMCFBCLKIN register and  the input of   */
/* the HCLK registers                                                       */
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

/* MpmcCore.scr defines the input and output delay constraints for the */
/* block                                                           */
include scripts/MpmcCore.scr

/* MpmcCore_exceptions.scr defines the point-to-point exceptions set   */
/* on the MpmcCore block. These may be false_paths or multicycle_paths */
include scripts/MpmcCore_exceptions.scr 

/* Set the name for report directory                                   */
report_name_base = "report/" + topname + "_" + test_req + "_" + hdl + \
  "_" + hdl_out
 
/* Check for any test problems */
if (test_req == scanready) {
  echo              >> run_time_log
  echo "check_test" >> run_time_log
  echo "==========" >> run_time_log
  echo              >> run_time_log
  check_test        >> run_time_log
}

current_design = topname

/* Fix minimum timing violations */
set_fix_hold all_clocks()

compile -only_design_rule

if ((test_req == noscan) || (test_req == scanready)) {
/* resistance constraints set on nets could have been lost following */
/* the design_rule compile. Restore them before generating the       */
/* the final netlist and SDF file.                                   */
set_resistance 0 HRESETn
set_drive 0 HRESETn

set_resistance 0 nPOR
set_drive 0 nPOR

}

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
report_port -verbose  >> report_name_base + ".ports"

/* Report the Clock Tree information to check if any buffers present */
report_transitive_fanout -clock_tree -nosplit > report_name_base + ".clocktree"

/* Report the Reset Tree information to check if any buffers present */
report_transitive_fanout -from HRESETn -nosplit > report_name_base +\
                                                  ".resettree"
report_transitive_fanout -from nPOR -nosplit >> report_name_base +\
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
/* Check for combinational loops */
echo " CHECK FOR COMBINATIONAL LOOPS " >> report_name_base + ".latch"

report_timing -loops >> report_name_base + ".latch"

/* The report files should contain no violations or errors */
/* and ideally zero or a minimal number of warnings        */

/******************************************************************************/
/* ACQUIRE HDL COMPILER                                                       */
/******************************************************************************/
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

/* Naming rules are defined in the name_rules.scr file residing in  */
/* scr_common_area. If any alternate naming rules are to be defined */
/* please include them in the name_rules.scr file.                  */

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

/****************************** End of MpmcCore.cmd ***************************/
