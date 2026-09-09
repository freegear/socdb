vlib work
vlog ../../Rtl/slim/NFCtrl.v
vlog ../../Rtl/slim/NFAPBIF.v
vlog ../../Rtl/slim/NFRnBFilter.v

vlog ../../Rtl/slim/NFCmdQ.v
vlog ../../Rtl/slim/NFDFIFO.v
vlog ../../Rtl/slim/NFTop.v
vlog ../../Rtl/slim/Two_NFTop.v



vlog +define+x16 ../../Rtl/slim/tb_NFTop.v
vlog +define+x16 +define+x16nf ../../Rtl/slim/Tb_Two_NFTop.v

vlog +incdir+../../Model +define+x16 +define+V33 +define+G2 ../../Model/nand_model_0.v 

#vsim tb_NFTop

vsim Tb_Two_NFTop

#do wave.do
destroy .wave
view wave


#do io8wave.do

do wave_1.do

run 20ms

