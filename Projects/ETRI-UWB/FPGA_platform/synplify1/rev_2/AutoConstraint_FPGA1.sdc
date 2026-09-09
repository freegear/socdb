
#Begin clock constraint
define_clock -name {p:FPGA1|CLK} -period 4.365 -clockgroup Autoconstr_clkgroup_0 -rise 0.000 -fall 2.183 -route 0.000 
#End clock constraint

#Begin clock constraint
define_clock -name {n:FPGA1|PLL1.CLK0_BUF_derived_clock} -period 4.365 -clockgroup Autoconstr_clkgroup_0 -rise 0.000 -fall 2.183 -route 0.000 
#End clock constraint

#Begin clock constraint
define_clock -name {n:FPGA1|PLL1.CLKDV_BUF_derived_clock} -period 8.731 -clockgroup Autoconstr_clkgroup_0 -rise 0.000 -fall 4.365 -route 0.000 
#End clock constraint

#Begin clock constraint
define_clock -name {n:FPGA1|PLL1.CLK2X_BUF_derived_clock} -period 2.183 -clockgroup Autoconstr_clkgroup_0 -rise 0.000 -fall 1.091 -route 0.000 
#End clock constraint
