###############################################################################
#
# Created by PrimeTime write_sdc on Fri Jul  1 14:14:26 2005
#
###############################################################################

set sdc_version 1.4

###############################################################################
#  
# Units
# capacitive_load_unit           : 1 pF
# current_unit                   : 1e-06 A
# resistance_unit                : 1 kOhm
# time_unit                      : 1 ns
# voltage_unit                   : 1 V
###############################################################################
set_operating_conditions  -min_library [get_libs {fast.db:fast}]  -max_library \
 [get_libs {slow.db:slow}]  -min fast  -max slow 
###############################################################################
# Clock Related Information
###############################################################################
create_clock -name clk -period 20 -waveform { 0 10 } [get_ports {clk}]
set_clock_latency -min  1.5 [get_clocks {clk}]
set_clock_latency -max  1.5 [get_clocks {clk}]
set_clock_latency -source  1 [get_clocks {clk}]
set_clock_uncertainty  0.3 [get_clocks {clk}]
set_clock_transition -rise -max  0.5 [get_clocks {clk}]
set_clock_transition -fall -max  0.5 [get_clocks {clk}]
set_clock_transition -rise -min  0.5 [get_clocks {clk}]
set_clock_transition -fall -min  0.5 [get_clocks {clk}]
###############################################################################
# External Delay Information
###############################################################################
set_input_delay  1 -clock [get_clocks {clk}] [get_ports {BistMode}]
set_input_delay  1 -clock [get_clocks {clk}] [get_ports {{p1_io[0]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{p1_io[0]}}]
set_input_delay  1 -clock [get_clocks {clk}] [get_ports {{p1_io[1]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{p1_io[1]}}]
set_input_delay  1 -clock [get_clocks {clk}] [get_ports {{p1_io[2]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{p1_io[2]}}]
set_input_delay  1 -clock [get_clocks {clk}] [get_ports {{p1_io[3]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{p1_io[3]}}]
set_input_delay  1 -clock [get_clocks {clk}] [get_ports {{p1_io[4]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{p1_io[4]}}]
set_input_delay  1 -clock [get_clocks {clk}] [get_ports {{p1_io[5]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{p1_io[5]}}]
set_input_delay  1 -clock [get_clocks {clk}] [get_ports {{p1_io[6]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{p1_io[6]}}]
set_input_delay  1 -clock [get_clocks {clk}] [get_ports {{p1_io[7]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{p1_io[7]}}]
set_input_delay  1 -clock [get_clocks {clk}] [get_ports {{in_xdat_a[0]}}]
set_input_delay  1 -clock [get_clocks {clk}] [get_ports {{in_xdat_a[1]}}]
set_input_delay  1 -clock [get_clocks {clk}] [get_ports {{in_xdat_a[2]}}]
set_input_delay  1 -clock [get_clocks {clk}] [get_ports {{in_xdat_a[3]}}]
set_input_delay  1 -clock [get_clocks {clk}] [get_ports {{in_xdat_a[4]}}]
set_input_delay  1 -clock [get_clocks {clk}] [get_ports {{in_xdat_a[5]}}]
set_input_delay  1 -clock [get_clocks {clk}] [get_ports {{in_xdat_a[6]}}]
set_input_delay  1 -clock [get_clocks {clk}] [get_ports {{in_xdat_a[7]}}]
set_input_delay  1.5 -clock [get_clocks {clk}] [get_ports {{rom_data_i[0]}}]
set_input_delay  1.5 -clock [get_clocks {clk}] [get_ports {{rom_data_i[1]}}]
set_input_delay  1.5 -clock [get_clocks {clk}] [get_ports {{rom_data_i[2]}}]
set_input_delay  1.5 -clock [get_clocks {clk}] [get_ports {{rom_data_i[3]}}]
set_input_delay  1.5 -clock [get_clocks {clk}] [get_ports {{rom_data_i[4]}}]
set_input_delay  1.5 -clock [get_clocks {clk}] [get_ports {{rom_data_i[5]}}]
set_input_delay  1.5 -clock [get_clocks {clk}] [get_ports {{rom_data_i[6]}}]
set_input_delay  1.5 -clock [get_clocks {clk}] [get_ports {{rom_data_i[7]}}]
set_input_delay  1 -clock [get_clocks {clk}] [get_ports {all_rxd_i}]
set_input_delay  1 -clock [get_clocks {clk}] [get_ports {all_t1_i}]
set_input_delay  1 -clock [get_clocks {clk}] [get_ports {all_t0_i}]
set_input_delay  1 -clock [get_clocks {clk}] [get_ports {int1_i}]
set_input_delay  1 -clock [get_clocks {clk}] [get_ports {int0_i}]
set_input_delay  1 -clock [get_clocks {clk}] [get_ports {rst_p}]
set_input_delay  1 -clock [get_clocks {clk}] [get_ports {clk}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {ErrMap}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {Finish}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {BistFail}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {rd_xdat}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {wr_xdat_d1}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {en_xdat}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{out_xdat[0]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{out_xdat[1]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{out_xdat[2]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{out_xdat[3]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{out_xdat[4]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{out_xdat[5]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{out_xdat[6]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{out_xdat[7]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{addr_xdat[0]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{addr_xdat[1]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{addr_xdat[2]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{addr_xdat[3]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{addr_xdat[4]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{addr_xdat[5]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{addr_xdat[6]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{addr_xdat[7]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{addr_xdat[8]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{addr_xdat[9]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{addr_xdat[10]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{addr_xdat[11]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{addr_xdat[12]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{addr_xdat[13]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{addr_xdat[14]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{addr_xdat[15]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{rom_adr_o[0]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{rom_adr_o[1]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{rom_adr_o[2]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{rom_adr_o[3]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{rom_adr_o[4]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{rom_adr_o[5]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{rom_adr_o[6]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{rom_adr_o[7]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{rom_adr_o[8]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{rom_adr_o[9]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{rom_adr_o[10]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{rom_adr_o[11]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{rom_adr_o[12]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{rom_adr_o[13]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{rom_adr_o[14]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {{rom_adr_o[15]}}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {clkb}]
set_output_delay  1 -clock [get_clocks {clk}] [get_ports {all_txd_o}]
set_case_analysis 0 [get_ports {BistMode}]
set_wire_load_mode enclosed
set_max_transition  1 [current_design]
