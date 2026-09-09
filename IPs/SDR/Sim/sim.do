
### test bench
vlog ./TbSDR.v
#vlog ./tb_sdc.v
vlog ./TM/TestMasterNC.v
#vlog ./TM/TestMasterWrap.v
#vlog ./TM/TestMasterInc.v

vlog ../Mod/mt48lc4m16a2.v
vlog ../Mod/mt48lc8m16a2.v
vlog ../Mod/mt48lc16m16a2.v
vlog ../Mod/mt48lc32m16a2.v
#vlog ../Mod/RF2SH64x32.v
#vlog ../Mod/RF2SH64x4.v
vlog ../Mod/RF2SH256x32.v
vlog ../Mod/RF2SH256x4.v

vlog ../Rtl/SDRTop.v
vlog ../Rtl/SDRRDS.v
vlog ../Rtl/SDRAi.v
vlog ../Rtl/SDRBLQ.v
vlog ../Rtl/SDRWQ.v
vlog ../Rtl/SDRRQ.v
vlog ../Rtl/SDRCtl.v
vlog ../Rtl/SDRBsm.v
#vlog ../Rtl/SDRRas.v
#vlog ../Rtl/SDRCas.v
vlog ../Src/Q4/SDRRas.v
vlog ../Src/Q4/SDRCas.v

vsim TbSDR

destroy .wave
view wave

#do wave0.do
do wave.do

config wave -signalnamewidth 2

#run 1ms
run -all