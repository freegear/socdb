analyze -f verilog -lib WORK ../Rtl/SspApbif.v
analyze -f verilog -lib WORK ../Rtl/SspDataStp.v
analyze -f verilog -lib WORK ../Rtl/SspDefs.v
analyze -f verilog -lib WORK ../Rtl/SspIntGen.v
analyze -f verilog -lib WORK ../Rtl/SspMTxRxCntl.v
analyze -f verilog -lib WORK ../Rtl/SspNewDMA.v
analyze -f verilog -lib WORK ../Rtl/SspRxFCntl.v
analyze -f verilog -lib WORK ../Rtl/SspRxFIFO.v
analyze -f verilog -lib WORK ../Rtl/SspRxRegFile.v
analyze -f verilog -lib WORK ../Rtl/SspSTxRxCntl.v
analyze -f verilog -lib WORK ../Rtl/SspScaleCntr.v
analyze -f verilog -lib WORK ../Rtl/SspTest.v
analyze -f verilog -lib WORK ../Rtl/SspTxFCntl.v
analyze -f verilog -lib WORK ../Rtl/SspTxFIFO.v
analyze -f verilog -lib WORK ../Rtl/SspTxLJustify.v
analyze -f verilog -lib WORK ../Rtl/SspTxRegFile.v
analyze -f verilog -lib WORK ../Rtl/Ssp.v

elaborate $TopDesign -lib WORK
