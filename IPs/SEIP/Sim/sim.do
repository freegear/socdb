# test bench
vlog +libext+.v +incdir+../Rtl ./TbSEIP.v

vlog ../Rtl/RA1SH256x16.v
vlog ../Rtl/RA1SH512x16.v
vlog ../Rtl/RA1SH512x24.v
vlog ../Rtl/RODSH512x8.v
vlog ../Mod/RA1SH16384x32.v

vlog ../Rtl/SEIP_xi.v
vlog +libext+.v +incdir+../Rtl ../Rtl/SEIPApbIf.v
vlog +libext+.v +incdir+../Rtl ../Rtl/PcmFIFO.v
vlog +libext+.v +incdir+../Rtl ../Rtl/SEIPDmaIf.v
vlog +libext+.v +incdir+../Rtl ../Rtl/SEIPTop.v

vsim TbSEIP

destroy .wave
view wave

do wave.do

config wave -signalnamewidth 2

run -all