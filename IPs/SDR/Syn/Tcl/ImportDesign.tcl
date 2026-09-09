analyze -f verilog -lib WORK ../Rtl/SDRWQ.v
analyze -f verilog -lib WORK ../Rtl/SDRRQ.v
analyze -f verilog -lib WORK ../Rtl/SDRBLQ.v
analyze -f verilog -lib WORK ../Rtl/SDRBsm.v
analyze -f verilog -lib WORK ../Rtl/SDRRas.v
analyze -f verilog -lib WORK ../Rtl/SDRCas.v
analyze -f verilog -lib WORK ../Rtl/SDRCtl.v
analyze -f verilog -lib WORK ../Rtl/SDRAi.v
analyze -f verilog -lib WORK ../Rtl/SDRRDS.v
analyze -f verilog -lib WORK ../Rtl/SDRTop.v

elaborate $TopDesign -lib WORK
