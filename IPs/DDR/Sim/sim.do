
### test bench
vlog ./TbSDR.v
#vlog ./tb_sdc.v
vlog ./TM/TestMaster.v
#vlog ./TM/TestMasterEast.v
#vlog ./TM/TestMasterWrap.v
#vlog ./TM/TestMasterInc.v

vlog ./model/ddr.v
vlog ../Rtl/SDRTop.v
vlog ../Rtl/SDRSpi.v
vlog ../Rtl/SDRAi.v
vlog ../Rtl/SDRWQ.v
vlog ../Rtl/SDRRQ.v
vlog ../Rtl/SDRBLQ.v
vlog ../Rtl/SDRCtl.v
vlog ../Rtl/SDRBsm.v
vlog ../Rtl/SDRRas.v
vlog ../Rtl/SDRCas.v

vsim TbSDR

destroy .wave
view wave

#do wave0.do
do wave.do

config wave -signalnamewidth 2

#run 1ms
run -all