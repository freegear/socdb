analyze -f verilog -lib WORK ../rtl/pmcon_APBIF.v
analyze -f verilog -lib WORK ../rtl/pmcon_AXIIF.v
analyze -f verilog -lib WORK ../rtl/pmcon_MEMIF.v
analyze -f verilog -lib WORK ../rtl/pmcon_REGIF.v
analyze -f verilog -lib WORK ../rtl/pmcon_STM.v


elaborate $TopDesign -lib WORK
