
# The JTAG clocks in the instrumentation logic need to run at 25 MHz for USB

define_clock {v:jtag_interface|identify_clk} -period 40.0 -clockgroup identify_jtag_group1

define_attribute          {n:iice_inst_0.mdic_link_reg[0:362]} KEEP {1}
