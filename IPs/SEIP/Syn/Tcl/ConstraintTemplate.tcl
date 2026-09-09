#
#--------------------------------------------------------------------------------
#--    Variables definition                                                    --
#--------------------------------------------------------------------------------
#----========================================================================----
#--    Define a top module name variable.                                      --
#----========================================================================----
set TopDesign SEIPTop

#----========================================================================----
#--    Define target period variables.                                         --
#----========================================================================----
set PERIOD1 10.00
set HALF_PERIOD1 [expr $PERIOD1 / 2]
set POS_PERIOD1  [expr 0]
set NEG_PERIOD1  [expr $HALF_PERIOD1]

#----========================================================================----
#--    Define clock variation variables.                                       --
#----========================================================================----
#-- 5% Clock Uncertainty Include Clock Skew and PLL Jitter and Clock Variables
set CLK_SKEW 0.30
set CLK_UNCERTAINTY1 [expr [expr $PERIOD1 * 0.05] + $CLK_SKEW]

#----========================================================================----
#--    Define a clock transition time variable.                                --
#----========================================================================----
set CLOCK_SLEW 0.40

#----========================================================================----
#--    Define an internal maximum fan-out limit variable.                      --
#----========================================================================----
set MAX_FANOUT 4

#----========================================================================----
#--    Define an internal transition time variable.                            --
#----========================================================================----
set MAX_SLEW [expr 2] 

#----========================================================================----
#--    Set output load capacitance at all outputs.                             --
#----========================================================================----
set MAX_TECH_LIB_NAME slow
set_load [expr [load_of [format "%s%s"  $MAX_TECH_LIB_NAME /SDFFHQX4/D]] * 4] [all_outputs]
set_driving_cell -library $MAX_TECH_LIB_NAME -cell SDFFHQX4 -pin Q [all_inputs]

#--------------------------------------------------------------------------------
#--    Clock description                                                       --
#--------------------------------------------------------------------------------

#----========================================================================----
#--    Target Frequency : 133MHz                                               --
#----========================================================================----

pCreateClock MCK  $PERIOD1 $POS_PERIOD1 $NEG_PERIOD1 $CLK_UNCERTAINTY1

#----========================================================================----
#--    Set Reset attributes.                                                --
#----========================================================================----
#-- AXI ARESETB
set tidminresetb [expr $PERIOD1 * 0.05]
set tidmaxresetb [expr $PERIOD1 * 0.5]

pCreateReset XRST  MCK $tidmaxresetb $tidminresetb

#--------------------------------------------------------------------------------
#--    Boundary conditions                                                     --
#--------------------------------------------------------------------------------
#----========================================================================----
#--    Set input delay time of primary inputs except clock inputs.             --
#----========================================================================----
set all_inputs_no_clocks [remove_from_collection [all_inputs] [list MCK]]

set tholdmax [expr  0.00 * $PERIOD1]
set tholdmin [expr -0.00 * $PERIOD1]

#-- AXI Interface
#-- Maximum allowable Input Delay 
set tidmax  [expr $PERIOD1 * 0.7]
#set tidmax  [expr $PERIOD1 * 0.2]

#-- Maximum allowable Output Delay 
set tdomax  [expr $PERIOD1 * 0.6]
#set tdomax  [expr $PERIOD1 * 0.3]

#-- APB Interface
#-- Maximum allowable Input Delay 
set tapbidmax  [expr $PERIOD1 * 0.6]

#-- Maximum allowable Output Delay 
set tapbdomax  [expr $PERIOD1 * 0.8]
#set tapbdomax  [expr $PERIOD1 * 0.2]

#-- SDRAM Interface
#-- The offchip primary inputs require a setup time which is 20% of clock
#-- Calculating the maximum allowable input delay on the inputs
set tidprimaryipmax [expr 0.8 * $PERIOD1]

#-- Minimum input delay on the primary inputs
set tihprimaryip 0.0

#-- Minimum input delay on the inputs
set tidprimaryipmin $tihprimaryip

#-- The output-valid time for primary output ports is 15% of PERIOD1
#-- Calculating the maximum allowable output delay on primary outputs
#set todprimaryopmax [expr 0.75 * $PERIOD1]
set todprimaryopmax [expr 0.3 * $PERIOD1]

#-- Minimum output delay on the primary outputs
set todprimaryopmin 0

#set_input_delay -clock ACLK -min $tholdmax $all_inputs_no_clocks
#set_input_delay -clock ACLK -max $tidmax   $all_inputs_no_clocks

if {[llength [find port P*]] != 0} {
  if {[llength [filter [find port P*] {@port_direction == in} ]] != 0} {
    set input_port_list [filter [find port P*] {@port_direction == in}]
    foreach_in_collection input_port_name $input_port_list {
      set_input_delay -clock MCK -min $tholdmax  $input_port_name
      set_input_delay -clock MCK -max $tapbidmax $input_port_name
    }
    unset input_port_list
  }
}

#----========================================================================----
#--    Set transition time of all primary inputs.                              --
#----========================================================================----
set_input_transition 1.00 $all_inputs_no_clocks

if {[llength [find port P*]] != 0} {
  if {[llength [filter [find port P*] {@port_direction == out} ]] != 0} {
    set output_port_list [filter [find port P*] {@port_direction == out}]
    foreach_in_collection output_port_name $output_port_list {
      set_output_delay -clock MCK -min $tholdmin  $output_port_name
      set_output_delay -clock MCK -max $tapbdomax $output_port_name
    }
    unset output_port_list
  }
}

#----========================================================================----
#--    Set output delay time at primary outputs.                               --
#----========================================================================----

#--------------------------------------------------------------------------------
#--    Timing restrictions                                                     --
#--------------------------------------------------------------------------------
#----========================================================================----
#--    Set a maximum fan-out of internal design.                               --
#----========================================================================----
#set_max_fanout $MAX_FANOUT $TopDesign

#set_max_fanout 1.0 PENABLE
#set_max_fanout 1.0 PSEL
#set_max_fanout 1.0 PWRITE
#----========================================================================----
#--    Set a  max transition of internal design.                               --
#----========================================================================----
set_max_transition $MAX_SLEW $TopDesign

#----========================================================================----
#--    Set exceptions.                                                         --
#----========================================================================----

#--set_multicycle_path 2 -setup -from {ff1/CP} -to {ff2}
#set_multicycle_path 2 -setup -from PCLK
#set_multicycle_path 1 -hold -to PCLK

#-------------------------------- End of File -----------------------------------
