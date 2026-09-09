vlib work
vlog ../../Rtl/slim/NFCtrl.v
vlog ../../Rtl/slim/NFAPBIF.v
vlog ../../Rtl/slim/NFRnBFilter.v

vlog ../../Rtl/slim/NFCmdQ.v
vlog ../../Rtl/slim/NFDFIFO.v
vlog ../../Rtl/slim/NFTop.v
vlog +define+x8 ../../Rtl/slim/Two_NFTop.v




vlog +define+x8 +define+chip_0 +define+Page512  ../../Rtl/slim/Tb_Two_NFTop.v

vlog +incdir+../../Model/ST_NAND512R3A_VG1.0/code ../../Model/ST_NAND512R3A_VG1.0/code/NAND512R3A.v

#vsim tb_NFTop

vsim Tb_Two_NFTop

#do wave.do
destroy .wave
view wave


#do io8wave.do

do wave_1.do

run 20ms

