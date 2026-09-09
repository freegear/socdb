#
# Written by : Transcript, Version V-2004.06 -- May 21, 2004
# Date       : Thu Mar  9 16:43:04 2006
#

#
# Translation of script: constraints_template.dcsh
#

#/******************************************************************************/
#/*    Variables definition                                                    */
#/******************************************************************************/
#/*--========================================================================--*/
#/*    Define a top module name variable.                                      */
#/*--========================================================================--*/
set TopDesign IntSRAMController

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

create_clock -name OscClk -period $PERIOD1 -w [list 0 $HALF_PERIOD1] [get_ports ACLK]

#/*--========================================================================--*/
#/*    Set clock uncertainties.                                                */
#/*--========================================================================--*/
set_clock_uncertainty -setup $CLK_UNCERTAINTY1 [get_clocks OscClk]

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
set all_inputs_no_clocks [remove_from_collection [all_inputs] [get_ports ACLK]]

set_input_delay 2.00 -clock OscClk $all_inputs_no_clocks

#/*--========================================================================--*/
#/*    Set transition time of all primary inputs.                              */
#/*--========================================================================--*/
set_input_transition 1.00 $all_inputs_no_clocks

#/*--========================================================================--*/
#/*    Set output delay time at primary outputs.                               */
#/*--========================================================================--*/
set_output_delay 3.00 -clock OscClk [all_outputs]

#/*set_output_delay 3.00 -clock sysclk1 all_outputs() -add_delay*/
#/*set_output_delay 5.00 -clock sysclk2 all_outputs() -add_delay*/

#/*--========================================================================--*/
#/*    Set output load capacitance at all outputs.                             */
#/*--========================================================================--*/
#/*set_load 8 all_outputs()*/
#set_load  [expr ? * slow/DFFX1/D] [all_outputs]
#load_of(slow/DFFX1/D)/0.001913
set_load 0.1 [all_outputs]
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

#/*--========================================================================--*/
#/*    Set exceptions.                                                         */
#/*--========================================================================--*/
#set_multicycle_path 3 -setup -to [list uDTSDI002Top/uAHB_IFMC/fmb/fmr_rdata_*_/D]
#set_multicycle_path 3 -setup -to [list uDTSDI002Top/uAHB_IFMC/fmb/smart_*_/D]
#set_multicycle_path 3 -setup -to [list uDTSDI002Top/uAHB_IFMC/fmb/rdp/D]
#set_multicycle_path 3 -setup -to [list uDTSDI002Top/uAHB_IFMC/fmb/hdp/D]

#/*set_multicycle_path 2 -setup -from {ff1/CP} -to {ff2}*/

#/******************************* End of File **********************************/
