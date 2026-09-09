#read_verilog ../Rtl/SEIP15_0915.v
#analyze -f verilog -lib WORK  ../Rtl/SEIP_modi.v
analyze -f verilog -lib WORK  ../Rtl/SEIP_noscan.v
analyze -f verilog -lib WORK  ../Rtl/SEIPApbIf.v
analyze -f verilog -lib WORK  ../Rtl/PcmFIFO.v
analyze -f verilog -lib WORK  ../Rtl/SEIPDmaIf.v
analyze -f verilog -lib WORK  ../Rtl/SEIPTop.v

elaborate $TopDesign -lib WORK
