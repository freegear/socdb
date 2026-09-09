#
# Written by : Transcript, Version V-2004.06 -- May 21, 2004
# Date       : Thu Mar  9 16:19:39 2006
#

#
# Translation of script: dtsdi002.dcsh
#

#/******************************************************************************/
#/*    Variable Definition                                                     */
#/******************************************************************************/
#/*--========================================================================--*/
#/*    In case of initial synthesis, define these variables.                   */
#/*    These variables are to prohibit reading and writing of caches.          */
#/*    Merit: Turn around time for logic synthesis can be reduced.             */
#/*    Demerit: Better result of re-synthesis may not be achieved.             */
#/*--========================================================================--*/
set cache_read {}
set cache_write {}

set hdlin_enable_presto false

#/*--========================================================================--*/
#/*    Define a top module name variable.                                      */
#/*--========================================================================--*/
set TopDesign DTSDI002

#/*--========================================================================--*/
#/*    Define directory variables                                              */
#/*    to save log files, db files, and report files.                          */
#/*--========================================================================--*/
set LogDir ./log
set DbDir ./db
set RptDir ./rpt
set NetDir ./Netlist

#/*--========================================================================--*/
#/*    Make directories if no directory.                                       */
#/*--========================================================================--*/
set dc_shell_status [ which $LogDir ]
if {  $dc_shell_status == [list] } {
   sh mkdir $LogDir
}

set dc_shell_status [ which $DbDir ]
if {  $dc_shell_status == [list] } {
   sh mkdir $DbDir
}

set dc_shell_status [ which $RptDir ]
if {  $dc_shell_status == [list] } {
   sh mkdir $RptDir
}

set dc_shell_status [ which $NetDir ]
if {  $dc_shell_status == [list] } {
   sh mkdir $NetDir
}

#/******************************************************************************/
#/*    Read design.                                                            */
#/******************************************************************************/

## Begin include: ReadDesign.scr
#

#/* ARM7 */
#/*read -f verilog /home/sdiv5/Rtl/ARM7/ARM7TDMI.v*/
read_verilog  /home/sdiv5/Rtl/ARM7/A7TWrapCtrl.v
read_verilog  /home/sdiv5/Rtl/ARM7/A7WrapSM.v
read_verilog  /home/sdiv5/Rtl/ARM7/A7TWrap.v
read_verilog  /home/sdiv5/Rtl/ARM7/A7WrapMaster.v
read_verilog  /home/sdiv5/Rtl/ARM7/A7TWrapTest.v
read_verilog  /home/sdiv5/Rtl/ARM7/A7TDMI.v

read_verilog  /home/sdiv5/Rtl/ARM7/ClockInv.v
read_verilog  /home/sdiv5/Rtl/ARM7/ClockNand.v
read_verilog  /home/sdiv5/Rtl/ARM7/ClockOr.v
read_verilog  /home/sdiv5/Rtl/ARM7/LAT.v
read_verilog  /home/sdiv5/Rtl/ARM7/LATR.v
read_verilog  /home/sdiv5/Rtl/ARM7/LATS.v

#/* AMBA */
read_verilog  /home/sdiv5/Rtl/AMBA/ArbSchm3.v
read_verilog  /home/sdiv5/Rtl/AMBA/Arbiter3.v
read_verilog  /home/sdiv5/Rtl/AMBA/MuxS2M.v
read_verilog  /home/sdiv5/Rtl/AMBA/MuxM2S.v
read_verilog  /home/sdiv5/Rtl/AMBA/DefaultSlave.v
read_verilog  /home/sdiv5/Rtl/AMBA/MuxP2B.v

read_verilog  /home/sdiv5/Rtl/AMBA/Decoder.v
read_verilog  /home/sdiv5/Rtl/AMBA/APBif.v

#/* FMC */
read_verilog  /home/sdiv5/Rtl/IFMC/ifmc_bus.v
read_verilog  /home/sdiv5/Rtl/IFMC/ifmc_pscal.v
read_verilog  /home/sdiv5/Rtl/IFMC/ifmc_reg.v
read_verilog  /home/sdiv5/Rtl/IFMC/ifmc_wr.v
read_verilog  /home/sdiv5/Rtl/IFMC/ifmc_fmb.v
read_verilog  /home/sdiv5/Rtl/IFMC/ifmc_rd.v
read_verilog  /home/sdiv5/Rtl/IFMC/ifmc_top.v

#/* SMC */
read_verilog  /home/sdiv5/Rtl/ISMC/ismc_ahb.v

read_verilog  /home/sdiv5/Rtl/ESMC/reg_smc.v
read_verilog  /home/sdiv5/Rtl/ESMC/sram_ctrl.v
read_verilog  /home/sdiv5/Rtl/ESMC/output_ctrl.v
read_verilog  /home/sdiv5/Rtl/ESMC/mem_ctrl.v

#/* UART */
read_verilog  /home/sdiv5/Rtl/UART/UartRegBlock.v
read_verilog  /home/sdiv5/Rtl/UART/UartSynctoUCLK.v
read_verilog  /home/sdiv5/Rtl/UART/UartSynctoPCLK.v
read_verilog  /home/sdiv5/Rtl/UART/UartBaudCntr.v
read_verilog  /home/sdiv5/Rtl/UART/UartApbif.v
read_verilog  /home/sdiv5/Rtl/UART/UartModem.v
read_verilog  /home/sdiv5/Rtl/UART/UartIrDA.v
read_verilog  /home/sdiv5/Rtl/UART/UartRXFCntl.v
read_verilog  /home/sdiv5/Rtl/UART/UartRXRegFile.v
read_verilog  /home/sdiv5/Rtl/UART/UartRXFIFO.v
read_verilog  /home/sdiv5/Rtl/UART/UartDataStp.v
read_verilog  /home/sdiv5/Rtl/UART/UartRXParShft.v
read_verilog  /home/sdiv5/Rtl/UART/UartRXCntl.v
read_verilog  /home/sdiv5/Rtl/UART/UartReceive.v
read_verilog  /home/sdiv5/Rtl/UART/UartTest.v
read_verilog  /home/sdiv5/Rtl/UART/UartTXCntl.v
read_verilog  /home/sdiv5/Rtl/UART/UartTXFCntl.v
read_verilog  /home/sdiv5/Rtl/UART/UartTXRegFile.v
read_verilog  /home/sdiv5/Rtl/UART/UartTXFIFO.v
read_verilog  /home/sdiv5/Rtl/UART/UartDMA.v
read_verilog  /home/sdiv5/Rtl/UART/UartInterrupt.v
read_verilog  /home/sdiv5/Rtl/UART/Uart.v

#/* I2C */
read_verilog  /home/sdiv5/Rtl/I2C/BTransCtl.v
read_verilog  /home/sdiv5/Rtl/I2C/SclCtl.v
read_verilog  /home/sdiv5/Rtl/I2C/I2cCtl.v
read_verilog  /home/sdiv5/Rtl/I2C/SMCtl.v
read_verilog  /home/sdiv5/Rtl/I2C/StartCtl.v
read_verilog  /home/sdiv5/Rtl/I2C/StopCtl.v
read_verilog  /home/sdiv5/Rtl/I2C/I2cBusDet.v
read_verilog  /home/sdiv5/Rtl/I2C/I2cBusFlt.v
read_verilog  /home/sdiv5/Rtl/I2C/I2cClkDiv.v
read_verilog  /home/sdiv5/Rtl/I2C/I2cIOShft.v
read_verilog  /home/sdiv5/Rtl/I2C/I2cCore.v
read_verilog  /home/sdiv5/Rtl/I2C/I2cReg.v
read_verilog  /home/sdiv5/Rtl/I2C/I2C.v

#/* VIC */
read_verilog  /home/sdiv5/Rtl/VIC/APB_vic.v
read_verilog  /home/sdiv5/Rtl/VIC/vic_master_arbiter.v
read_verilog  /home/sdiv5/Rtl/VIC/vic_slave_arbiter.v

#/* GPIO */
read_verilog  /home/sdiv5/Rtl/GPIO/Gpio.v

#/* TIMER */
read_verilog  /home/sdiv5/Rtl/TIMER/timer_pwm.v
read_verilog  /home/sdiv5/Rtl/TIMER/TimerPWM.v

#/* WatchDog */
read_verilog  /home/sdiv5/Rtl/WDT/WatchDog.v

#/* ADC Control */
read_verilog  /home/sdiv5/Rtl/ADCTL/adc_control.v
read_verilog  /home/sdiv5/Rtl/ADCTL/top_adc.v

#/* Glue */
read_verilog  /home/sdiv5/Rtl/GLUE/RstCtl.v
read_verilog  /home/sdiv5/Rtl/GLUE/ClkCtl.v

#/* TOP */
read_verilog  /home/sdiv5/Rtl/TOP/DTSDI002Top.v
read_verilog  /home/sdiv5/Rtl/TOP/DTSDI002.v
#
## End include: ReadDesign.scr



#/*--========================================================================--*/
#/*    Set current design to a top module.                                     */
#/*--========================================================================--*/
current_design $TopDesign

#/*--========================================================================--*/
#/*    Link design and libraries                                               */
#/*--========================================================================--*/
link_design

#/******************************************************************************/
#/*    Remove HDL-Compiler license.                                            */
#/******************************************************************************/
#/*remove_license HDL-Compiler*/

#/******************************************************************************/
#/*    Write Gtech db of design.                                               */
#/******************************************************************************/
echo {Warning: ignored unsupported 'write' command}
echo {	at or near line 75 in '/home/sdiv5/Syn/Dcsh/dtsdi002.dcsh'}


#/******************************************************************************/
#/*    Check RTL design.                                                       */
#/******************************************************************************/
echo {Warning: ignored unsupported 'check_design' command}
echo {	at or near line 80 in '/home/sdiv5/Syn/Dcsh/dtsdi002.dcsh'}


#/******************************************************************************/
#/*    Perform uniquify before compile.                                        */
#/******************************************************************************/
echo {Warning: ignored unsupported 'uniquify' command}
echo {	at or near line 86 in '/home/sdiv5/Syn/Dcsh/dtsdi002.dcsh'}


#/******************************************************************************/
#/*    Write uniquified Gtech db.                                              */
#/******************************************************************************/
echo {Warning: ignored unsupported 'write' command}
echo {	at or near line 90 in '/home/sdiv5/Syn/Dcsh/dtsdi002.dcsh'}


#/******************************************************************************/
#/*    Set dont touch attribute at net of iddq.                                */
#/******************************************************************************/

## Begin include: dont_touch_net.dcsh
#


#/* CTS clock/reset */
set_dont_touch [list uDTSDI002Top/uAPB_PowerManager/SCKBUF]
set_dont_touch [list uDTSDI002Top/uAPB_PowerManager/UCKBUF]
set_dont_touch [list uDTSDI002Top/uAPB_PowerManager/ACKBUF]

set_dont_touch [list uDTSDI002Top/uResetCntl/SRSTBUF]
set_dont_touch [list uDTSDI002Top/uResetCntl/WRSTBUF]

#
## End include: dont_touch_net.dcsh



#/******************************************************************************/
#/*    Run set_fix_multiple_port_nets command to fix multiple ports and nets   */
#/*    You should set the command to all design to avoid Design Compiler bugs  */
#/******************************************************************************/
echo {Warning: ignored unsupported 'set_fix_multiple_port_nets' command}
echo {	at or near line 101 in '/home/sdiv5/Syn/Dcsh/dtsdi002.dcsh'}

echo {Warning: ignored unsupported 'set_fix_multiple_port_nets' command}
echo {	at or near line 104 in '/home/sdiv5/Syn/Dcsh/dtsdi002.dcsh'}
foreach_in_collection each_design [get_designs "*"] {
  current_design $each_design
  
}
current_design $TopDesign

#/******************************************************************************/
#/*    Set timing constraints with timing exceptions.                          */
#/******************************************************************************/

## Begin include: constraints_template.dcsh
#

#/******************************************************************************/
#/*    Variables definition                                                    */
#/******************************************************************************/
#/*--========================================================================--*/
#/*    Define a top module name variable.                                      */
#/*--========================================================================--*/
set TopDesign DTSDI002

#/*--========================================================================--*/
#/*    Define target period variables.                                         */
#/*--========================================================================--*/
set PERIOD1 13.88
set HALF_PERIOD1 [expr $PERIOD1 / 2]

#/*--========================================================================--*/
#/*    Define clock variation variables.                                       */
#/*     - M18GPL11S							      */
#/*--========================================================================--*/
set CLK_SKEW 0.30
set CLK_UNCERTAINTY1 [expr [expr $PERIOD1 * 0.16] + $CLK_SKEW]

#/*--========================================================================--*/
#/*    Define a clock transition time variable.                                */
#/*--========================================================================--*/
set CLOCK_SLEW 0.40

#/*--========================================================================--*/
#/*    Define an internal maximum fan-out limit variable.                      */
#/*--========================================================================--*/
set MAX_FANOUT 16

#/*--========================================================================--*/
#/*    Define an internal transition time variable.                            */
#/*--========================================================================--*/
set MAX_SLEW 1.00

#/******************************************************************************/
#/*    Clock description                                                       */
#/******************************************************************************/

#/*--========================================================================--*/
#/*    Target period : 13.88ns                                                 */
#/*--========================================================================--*/
create_clock -name OscClk -period $PERIOD1 -w [list 0 $HALF_PERIOD1] ARM_OSCi
create_generated_clock -name SysClk -source ARM_OSCi -divide_by 1 uDTSDI002Top/uAPB_PowerManager/SCKBUF/Y
create_generated_clock -name UartClk -source uDTSDI002Top/uAPB_PowerManager/SCKBUF/Y -divide_by 1 uDTSDI002Top/uAPB_PowerManager/UCKBUF/Y
create_generated_clock -name AdcClk -source uDTSDI002Top/uAPB_PowerManager/SCKBUF/Y -divide_by 1 uDTSDI002Top/uAPB_PowerManager/ACKBUF/Y

#/*--========================================================================--*/
#/*    Set clock uncertainties.                                                */
#/*--========================================================================--*/
set_clock_uncertainty -setup $CLK_UNCERTAINTY1 [get_clocks OscClk]
set_clock_uncertainty -setup $CLK_UNCERTAINTY1 [get_clocks SysClk]
set_clock_uncertainty -setup $CLK_UNCERTAINTY1 [get_clocks UartClk]
set_clock_uncertainty -setup $CLK_UNCERTAINTY1 [get_clocks AdcClk]

#/*--========================================================================--*/
#/*    Set clock transition time of FF's CK pin.                               */
#/*--========================================================================--*/
set_clock_transition $CLOCK_SLEW [all_clocks]

#/*--========================================================================--*/
#/*    Set dont_touch attribute of clock network.                              */
#/*--========================================================================--*/
set_dont_touch_network [all_clocks]

#/******************************************************************************/
#/*    Boundary conditions                                                     */
#/******************************************************************************/
#/*--========================================================================--*/
#/*    Set input delay time of primary inputs except clock inputs.             */
#/*--========================================================================--*/
set all_inputs_no_clocks [remove_from_collection [all_inputs] [get_ports OscClk]]

set_input_delay 2.00 -clock SysClk $all_inputs_no_clocks

#/*--========================================================================--*/
#/*    Set transition time of all primary inputs.                              */
#/*--========================================================================--*/
set_input_transition 1.00 $all_inputs_no_clocks

#/*--========================================================================--*/
#/*    Set output delay time at primary outputs.                               */
#/*--========================================================================--*/
set_output_delay 3.00 -clock SysClk [all_outputs]

#/*set_output_delay 3.00 -clock sysclk1 all_outputs() -add_delay*/
#/*set_output_delay 5.00 -clock sysclk2 all_outputs() -add_delay*/

#/*--========================================================================--*/
#/*    Set output load capacitance at all outputs.                             */
#/*--========================================================================--*/
#/*set_load 8 all_outputs()*/
set_load  [expr 30 * [get_attribute -class lib_pin [format "%s%s"  slow /DFFX1/D] pin_capacitance]] [all_outputs]
set_driving_cell -cell DFFX1 -pin Q [all_inputs]

#/******************************************************************************/
#/*    Timing restrictions                                                     */
#/******************************************************************************/
#/*--========================================================================--*/
#/*    Set a maximum fan-out of internal design.                               */
#/*--========================================================================--*/
set_max_fanout $MAX_FANOUT $TopDesign

#/*--========================================================================--*/
#/*    Set a  max transition of internal design.                               */
#/*--========================================================================--*/
set_max_transition $MAX_SLEW $TopDesign

#/*--========================================================================--*/
#/*    Set normal mode.                                                        */
#/*    The followings are reference only.                                      */
#/*--========================================================================--*/
#/*remove_input_delay find(port,"clk*")*/
#/*remove_attribute find(port,"clk*") max_fanout*/
#/*remove_attribute find(port,"clk*") max_transition*/

set_case_analysis 0 TEST_MODE
set_case_analysis 1 ARM_TRST
set_case_analysis 1 ARM_TMS
set_case_analysis 1 ARM_TCK
set_case_analysis 1 ARM_TDI
set_case_analysis 1 ARM_RESETi

#/*--========================================================================--*/
#/*    Set exceptions.                                                         */
#/*--========================================================================--*/
set_multicycle_path 3 -setup -to [list {uDTSDI002Top/uAHB_IFMC/fmb/fmr_rdata_reg[*]/D}]
set_multicycle_path 3 -setup -to [list {uDTSDI002Top/uAHB_IFMC/fmb/smart_reg[*]/D}]
set_multicycle_path 3 -setup -to [list uDTSDI002Top/uAHB_IFMC/fmb/rdp_reg/D]
set_multicycle_path 3 -setup -to [list uDTSDI002Top/uAHB_IFMC/fmb/hdp_reg/D]

#/*set_multicycle_path 2 -setup -from {ff1/CP} -to {ff2}*/

#/******************************* End of File **********************************/
#
## End include: constraints_template.dcsh



#/******************************************************************************/
#/*    Write the design including timing constraints.                          */
#/******************************************************************************/
echo {Warning: ignored unsupported 'write' command}
echo {	at or near line 116 in '/home/sdiv5/Syn/Dcsh/dtsdi002.dcsh'}


#/******************************************************************************/
#/*    First, run fastest compile to perform release check.                    */
#/*    Don't run simple mode compile (set_simple_mode_compile_mode command)    */
#/*    that release checker creates many warning and error messages.           */
#/******************************************************************************/
echo {Warning: ignored unsupported 'compile' command}
echo {	at or near line 123 in '/home/sdiv5/Syn/Dcsh/dtsdi002.dcsh'}


#/******************************************************************************/
#/*    Write the first compiled design.                                        */
#/******************************************************************************/
echo {Warning: ignored unsupported 'write' command}
echo {	at or near line 128 in '/home/sdiv5/Syn/Dcsh/dtsdi002.dcsh'}


#/******************************************************************************/
#/*    Check design and constraints.                                           */
#/******************************************************************************/
#/*--========================================================================--*/
#/*    Check design after synthesis.                                           */
#/*--========================================================================--*/
echo {Warning: ignored unsupported 'check_design' command}
echo {	at or near line 136 in '/home/sdiv5/Syn/Dcsh/dtsdi002.dcsh'}


#/*--========================================================================--*/
#/*    Check timing after synthesis.                                           */
#/*--========================================================================--*/
redirect [format "%s%s"  [format "%s%s"  [format "%s%s"  $LogDir "/"] $TopDesign] ".check_timing.Net.log"] { check_timing }

#/*--========================================================================--*/
#/*    Check timing exceptions after synthesis.                                */
#/*--========================================================================--*/
#/*report_timing_requirements -ignored \*/
#                          /*> LogDir + "/" + TopDesign + ".exceptions.Net.log"*/

#/******************************************************************************/
#/*    Perform ungroup DesignWare                                              */
#/*    to avoid an equivalent input cell circuit and a chopper circuit.        */
#/******************************************************************************/

## Begin include: UngroupDW.dcsh
#

#/*--========================================================================--*/
#/*    Save a top design name.                                                 */
#/*--========================================================================--*/
set dc_shell_status [ set SavePlace [current_design] ]

#/*--========================================================================--*/
#/*    Find all designs.                                                       */
#/*--========================================================================--*/
echo {Warning: ignored unsupported 'ungroup' command}
echo {	at or near line 32 in '/home/sdiv5/Syn/Dcsh/UngroupDW.dcsh'}
foreach_in_collection DesignName [get_designs "*"] {
  current_design $DesignName
  set dc_shell_status [ redirect /dev/null { set DwCellList [filter_collection [get_cells "*"] "@is_synlib_operator==true ||                @is_dw_subblock==true || @is_synlib_module==true"] } ]
  if {  $dc_shell_status != [list] } {
     echo [concat [format "%s%s"  [format "%s%s"  {Info: Found some DW hierarchy in } [get_object_name $DesignName]] {. Ungrouping...}]]
    
  }
}

#/*--========================================================================--*/
#/*    Return to top design.                                                   */
#/*--========================================================================--*/
current_design $SavePlace

#/*--========================================================================--*/
#/*    Remove variables.                                                       */
#/*--========================================================================--*/
unset SavePlace
unset DwCellList

#/******************************* End of File **********************************/
#
## End include: UngroupDW.dcsh



#/******************************************************************************/
#/*    Write the design after performing ungroup DesignWare.                   */
#/******************************************************************************/
echo {Warning: ignored unsupported 'write' command}
echo {	at or near line 158 in '/home/sdiv5/Syn/Dcsh/dtsdi002.dcsh'}


#/* check result */
#/*current_design TopDesign*/
#/*write -f verilog -h -o NetDir + "/" + TopDesign + ".FirstCom.vnet"*/

#/******************************************************************************/
#/*    Perform incremental synthesis                                           */
#/*    to avoid an equivalent input cell circuit and a chopper circuit.        */
#/******************************************************************************/
#/*compile -inc -map_effort low -area_effort none -no_design_rule*/
echo {Warning: ignored unsupported 'compile' command}
echo {	at or near line 169 in '/home/sdiv5/Syn/Dcsh/dtsdi002.dcsh'}


#/******************************************************************************/
current_design $TopDesign
echo {Warning: ignored unsupported 'change_names' command}
echo {	at or near line 173 in '/home/sdiv5/Syn/Dcsh/dtsdi002.dcsh'}


#/******************************************************************************/
#/*    Write the incremental optimized design.                                 */
#/******************************************************************************/
echo {Warning: ignored unsupported 'write' command}
echo {	at or near line 178 in '/home/sdiv5/Syn/Dcsh/dtsdi002.dcsh'}

echo {Warning: ignored unsupported 'write' command}
echo {	at or near line 179 in '/home/sdiv5/Syn/Dcsh/dtsdi002.dcsh'}


#/******************************************************************************/
#/*current_design TopDesign*/
#/*change_names*/

#/******************************************************************************/
#/* compile scan */
#/******************************************************************************/
#/*compile -map_effort high -area_effort none -scan*/

#/******************************************************************************/
#/*current_design TopDesign
#/*change_names*/

#/******************************************************************************/
#/*    Write the incremental optimized design for scan.                        */
#/******************************************************************************/
#/*write -f db -h -o DbDir + "/" + TopDesign + ".db"*/
#/*write -f verilog -h -o NetDir + "/" + TopDesign + ".v"*/

#/******************************************************************************/
#/*    Report about your design.                                               */
#/******************************************************************************/
#/*--========================================================================--*/
#/*    Report quality of results.                                              */
#/*--========================================================================--*/
echo {Warning: ignored unsupported 'report_qor' command}
echo {	at or near line 206 in '/home/sdiv5/Syn/Dcsh/dtsdi002.dcsh'}


#/*--========================================================================--*/
#/*    Report area of design.                                                  */
#/*--========================================================================--*/
echo {Warning: ignored unsupported 'report_area' command}
echo {	at or near line 211 in '/home/sdiv5/Syn/Dcsh/dtsdi002.dcsh'}


#/*--========================================================================--*/
#/*    Report high fan-out nets of design.                                     */
#/*--========================================================================--*/
#/*report_net_fanout -threshold 100 > RptDir + "/" + TopDesign + ".high_fanout.rpt"*/
echo {Warning: ignored unsupported 'report_net_fanout' command}
echo {	at or near line 217 in '/home/sdiv5/Syn/Dcsh/dtsdi002.dcsh'}


#/*--========================================================================--*/
#/*    Report all violations of design.                                        */
#/*--========================================================================--*/
redirect [format "%s%s"  [format "%s%s"  [format "%s%s"  $RptDir "/"] $TopDesign] ".all_viol.rpt"] { report_constraint -all_violators }

#/*--========================================================================--*/
#/*    Report all violation paths of design.                                   */
#/*--========================================================================--*/
redirect [format "%s%s"  [format "%s%s"  [format "%s%s"  $RptDir "/"] $TopDesign] ".all_viol.verbose.rpt"] { report_constraint -all_violators -verbose }

#/*--========================================================================--*/
#/*    Report timing paths with setup violation.                               */
#/*--========================================================================--*/
redirect [format "%s%s"  [format "%s%s"  [format "%s%s"  $RptDir "/"] $TopDesign] ".max.rpt"] { report_timing -tran -cap -net -input -nworst 10 }

#/*--========================================================================--*/
#/*    Report timing paths with hold violation.                                */
#/*--========================================================================--*/
redirect [format "%s%s"  [format "%s%s"  [format "%s%s"  $RptDir "/"] $TopDesign] ".min.rpt"] { report_timing -delay min -tran -cap -net -input -nworst 10 }

write_sdc dtsdi002.sdc
#/******************************************************************************/
#/*    Exit Design Compiler.                                                   */
#/******************************************************************************/
quit
