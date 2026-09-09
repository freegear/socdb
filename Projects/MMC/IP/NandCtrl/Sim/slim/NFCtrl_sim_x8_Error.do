vlib work
vlog ../../Rtl/slim/NFCtrl.v
vlog ../../Rtl/slim/NFBoot.v
vlog ../../Rtl/slim/NFAPBIF.v
vlog ../../Rtl/slim/NFRnBFilter.v

vlog ../../Rtl/slim/EccErrDetect.v

#vlog ../../Rtl/slim/NFCmdQ.v
vlog +define+CHIP ../../Rtl/slim/NFCmdQ.v

#vlog ../../Rtl/slim/NFDFIFO.v
vlog +define+CHIP ../../Rtl/slim/NFDFIFO.v

#vlog +define+EccErrTest ../../Rtl/slim/NFEcc.v
vlog ../../Rtl/slim/NFEcc.v

vlog ../../Rtl/slim/NFEcc8.v
vlog ../../Rtl/slim/NFEcc16.v
vlog ../../Rtl/slim/NFTop.v

vlog +define+x8 +define+ECCERRTEST ../../Rtl/slim/tb_NFTop.v
vlog +define+x8 +define+V33 +define+G2 ../../Model/nand_model_0.v 
vlog ../../Model/RF2SH8x32_on.v





vsim tb_NFTop

#do wave.do
destroy .wave
view wave

do io8wave.do

run 10ms
