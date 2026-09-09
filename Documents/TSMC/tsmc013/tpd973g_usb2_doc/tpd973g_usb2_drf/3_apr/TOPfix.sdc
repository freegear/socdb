#####################################################
#
#  Created by Design Compiler write_sdc on Wed Jun 16 15:02:21 2004
#
#####################################################
set sdc_version 1.3

#create_clock -period 166.4 -waveform {0 83.2} [get_ports {FREF}]
create_clock -name PLL480 -period 2.08 -waveform {0 1.04} [get_pins {X1/PLL480}]
create_clock -name CLKP -period 16.64 -waveform {0 8.32} [get_pins {X1/CLKP}]
create_generated_clock -name CLK -source [get_pins {X1/CLKP}] -divide_by 1 -invert [get_pins {X1/CLK}]
set_output_delay 5 [get_ports {END}]
#set_clock_uncertainty  0.3 [get_clocks {FREF}]
set_clock_uncertainty  0.3 [get_clocks {CLKP}]
set_clock_uncertainty  0.3 [get_clocks {CLK}]
set_clock_latency  0.3 [get_clocks {CLK}]
set_clock_latency -source  0.5 [get_clocks {CLK}]
set_max_transition 0.2 [current_design]
set_driving_cell -lib_cell INVX4 [get_ports {FREF}]
set_driving_cell -lib_cell INVX4 [get_ports {PADP}]
set_driving_cell -lib_cell INVX4 [get_ports {PADM}]
set_driving_cell -lib_cell INVX4 [get_ports {Reset_IN}]
