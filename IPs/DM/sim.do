
### test bench
vlog ./TbLCD.v

# FPGA
vlog ../Mod/BLKMEMSP_V6_1.v
vlog ../Mod/spram2048x8.v
vlog ../Mod/spram2048x16.v

vlog ../Mod/RF2SH64x32.v
vlog ../Mod/RF2SH64x4.v

vlog ../Mod/ddr.v

vlog ../Mod/RF2SH16x32.v
vlog ../Mod/RF2SH32x32.v
vlog ../Mod/RF2SH64x24.v
vlog ../Mod/RA2SH2048x16.v
vlog ../Mod/RA1SH2048x8.v
vlog ../Mod/RA1SH2048x16.v
vlog ../Mod/RA1SH512x24.v

vlog +libext+.v +incdir+../Rtl/DDR ../Rtl/DDR/SDRTop.v
vlog +libext+.v +incdir+../Rtl/DDR ../Rtl/DDR/SDRRds.v
vlog +libext+.v +incdir+../Rtl/DDR ../Rtl/DDR/SDRSpi.v
vlog +libext+.v +incdir+../Rtl/DDR ../Rtl/DDR/SDRAi.v
vlog +libext+.v +incdir+../Rtl/DDR ../Rtl/DDR/SDRWQ.v
vlog +libext+.v +incdir+../Rtl/DDR ../Rtl/DDR/SDRRQ.v
vlog +libext+.v +incdir+../Rtl/DDR ../Rtl/DDR/SDRBLQ.v
vlog +libext+.v +incdir+../Rtl/DDR ../Rtl/DDR/SDRCtl.v
vlog +libext+.v +incdir+../Rtl/DDR ../Rtl/DDR/SDRBsm.v
vlog +libext+.v +incdir+../Rtl/DDR ../Rtl/DDR/SDRRas.v
vlog +libext+.v +incdir+../Rtl/DDR ../Rtl/DDR/SDRCas.v

vlog ../Mod/SSRAM32bit.v
vlog ../Mod/IntSRAMController.v.no4KBcheck

vlog +libext+.v +incdir+../Rtl/SC ../Rtl/SC/DnCF.v
vlog +libext+.v +incdir+../Rtl/SC ../Rtl/SC/DnOC.v
vlog +libext+.v +incdir+../Rtl/SC ../Rtl/SC/DnScHdc.v
vlog +libext+.v +incdir+../Rtl/SC ../Rtl/SC/DnScHdto.v
vlog +libext+.v +incdir+../Rtl/SC ../Rtl/SC/DnScPF.v
vlog +libext+.v +incdir+../Rtl/SC ../Rtl/SC/DnScVdto.v
vlog +libext+.v +incdir+../Rtl/SC ../Rtl/SC/UpScHdto.v
vlog +libext+.v +incdir+../Rtl/SC ../Rtl/SC/UpScPF.v
vlog +libext+.v +incdir+../Rtl/SC ../Rtl/SC/UpScRd.v
vlog +libext+.v +incdir+../Rtl/SC ../Rtl/SC/UpScSG.v
vlog +libext+.v +incdir+../Rtl/SC ../Rtl/SC/UpScVdto.v
vlog +libext+.v +incdir+../Rtl/SC ../Rtl/SC/ScHF.v
vlog +libext+.v +incdir+../Rtl/SC ../Rtl/SC/ScHmux.v
vlog +libext+.v +incdir+../Rtl/SC ../Rtl/SC/ScVmc.v
vlog +libext+.v +incdir+../Rtl/SC ../Rtl/SC/ScVF.v
vlog +libext+.v +incdir+../Rtl/SC ../Rtl/SC/ScCore.v
vlog +libext+.v +incdir+../Rtl/SC ../Rtl/SC/ScTop.v

#vlog ../Rtl/DM64/DmR64to32.v
vlog +libext+.v +incdir+../Rtl/DM ../Rtl/DM/DmTop.v
vlog +libext+.v +incdir+../Rtl/DM ../Rtl/DM/DmReg.v
vlog +libext+.v +incdir+../Rtl/DM ../Rtl/DM/LcdReg.v
vlog +libext+.v +incdir+../Rtl/DM ../Rtl/DM/DmARIf.v
vlog +libext+.v +incdir+../Rtl/DM ../Rtl/DM/DmRDmaArb.v
vlog +libext+.v +incdir+../Rtl/DM ../Rtl/DM/PlaneGamma.v
vlog +libext+.v +incdir+../Rtl/DM ../Rtl/DM/DmaBLQ.v
vlog +libext+.v +incdir+../Rtl/DM ../Rtl/DM/ScFIFO16x32.v
vlog +libext+.v +incdir+../Rtl/DM ../Rtl/DM/ScFIFO32x32.v
vlog +libext+.v +incdir+../Rtl/DM ../Rtl/DM/ScFIFO64x32.v
vlog +libext+.v +incdir+../Rtl/DM ../Rtl/DM/ScFIFO2048x16.v
vlog +libext+.v +incdir+../Rtl/DM ../Rtl/DM/VScInF.v
vlog +libext+.v +incdir+../Rtl/DM ../Rtl/DM/VideoCSC.v
vlog +libext+.v +incdir+../Rtl/DM ../Rtl/DM/VideoFC.v
vlog +libext+.v +incdir+../Rtl/DM ../Rtl/DM/VideoDma.v
vlog +libext+.v +incdir+../Rtl/DM ../Rtl/DM/VideoPlane.v
vlog +libext+.v +incdir+../Rtl/DM ../Rtl/DM/PaletteMem.v
vlog +libext+.v +incdir+../Rtl/DM ../Rtl/DM/GraphicDma.v
vlog +libext+.v +incdir+../Rtl/DM ../Rtl/DM/GraphicPlane.v
vlog +libext+.v +incdir+../Rtl/DM ../Rtl/DM/CursorDma.v
vlog +libext+.v +incdir+../Rtl/DM ../Rtl/DM/CursorPlane.v
vlog +libext+.v +incdir+../Rtl/DM ../Rtl/DM/MixerFIFO.v
vlog +libext+.v +incdir+../Rtl/DM ../Rtl/DM/PlaneMixer.v
vlog +libext+.v +incdir+../Rtl/DM ../Rtl/DM/LcdTG.v
vlog +libext+.v +incdir+../Rtl/DM ../Rtl/DM/LcdOutMux.v
vlog +libext+.v +incdir+../Rtl/DM ../Rtl/DM/LcdSyncSysClk.v

vsim TbLCD

destroy .wave
view wave

do wave.do

config wave -signalnamewidth 2

run -all