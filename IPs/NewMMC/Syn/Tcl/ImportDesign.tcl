analyze -f verilog -lib WORK ../Rtl/mmc_APBRegisterIF.v
analyze -f verilog -lib WORK ../Rtl/mmc_CommandControl.v
analyze -f verilog -lib WORK ../Rtl/mmc_DataControl.v
analyze -f verilog -lib WORK ../Rtl/mmc_FeedBackSync.v
analyze -f verilog -lib WORK ../Rtl/mmc_Fifo.v
analyze -f verilog -lib WORK ../Rtl/mmc_FifoDmaCtr.v
analyze -f verilog -lib WORK ../Rtl/mmc_PSave.v
analyze -f verilog -lib WORK ../Rtl/mmc_Prescaler.v
analyze -f verilog -lib WORK ../Rtl/MMCTop.v

elaborate $TopDesign -lib WORK
