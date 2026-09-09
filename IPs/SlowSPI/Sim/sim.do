
### test bench
vlog +libext+.v +incdir+../Rtl/ ./TbSSP.v

vlog +libext+.v +incdir+../Rtl ../Rtl/Ssp.v
vlog +libext+.v +incdir+../Rtl ../Rtl/SspApbif.v
vlog +libext+.v +incdir+../Rtl ../Rtl/SspDataStp.v
vlog +libext+.v +incdir+../Rtl ../Rtl/SspDMA.v
vlog +libext+.v +incdir+../Rtl ../Rtl/SspIntGen.v
vlog +libext+.v +incdir+../Rtl ../Rtl/SspMTxRxCntl.v
vlog +libext+.v +incdir+../Rtl ../Rtl/SspRegCore.v
vlog +libext+.v +incdir+../Rtl ../Rtl/SspRxFCntl.v
vlog +libext+.v +incdir+../Rtl ../Rtl/SspRxFIFO.v
vlog +libext+.v +incdir+../Rtl ../Rtl/SspRxRegFile.v
vlog +libext+.v +incdir+../Rtl ../Rtl/SspScaleCntr.v
vlog +libext+.v +incdir+../Rtl ../Rtl/SspSTxRxCntl.v
vlog +libext+.v +incdir+../Rtl ../Rtl/SspTest.v
vlog +libext+.v +incdir+../Rtl ../Rtl/SspTxFCntl.v
vlog +libext+.v +incdir+../Rtl ../Rtl/SspTxFIFO.v
vlog +libext+.v +incdir+../Rtl ../Rtl/SspTxLJustify.v
vlog +libext+.v +incdir+../Rtl ../Rtl/SspTxRegFile.v

vlog ../Mod/spi_slave_model.v

vsim TbSSP

destroy .wave
view wave

do wave.do

config wave -signalnamewidth 2

#run 1ms
run -all