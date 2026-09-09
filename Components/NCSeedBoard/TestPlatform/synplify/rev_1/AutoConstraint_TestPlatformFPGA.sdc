
#Begin clock constraint
define_clock -name {n:ClockResetGen_1s_1s_0.500000_1s|APBClk_derived_clock} -period 15.713 -clockgroup Autoconstr_clkgroup_1 -rise 0.000 -fall 7.857 -route 0.000 
#End clock constraint

#Begin clock constraint
define_clock -name {n:hc4094_7seg|div_clk_derived_clock} -period 3.959 -clockgroup Autoconstr_clkgroup_1 -rise 0.000 -fall 1.980 -route 0.000 
#End clock constraint

#Begin clock constraint
define_clock -name {b:TestPlatformFPGA|Clock} -period 5.101 -clockgroup Autoconstr_clkgroup_0 -rise 0.000 -fall 2.550 -route 0.000 
#End clock constraint
