vlib work
vlog ../../Rtl/slim/NFCtrl.v
vlog ../../Rtl/slim/NFAPBIF.v
vlog ../../Rtl/slim/NFRnBFilter.v

vlog ../../Rtl/slim/NFCmdQ.v
vlog ../../Rtl/slim/NFDFIFO.v
vlog ../../Rtl/slim/NFTop.v

vlog +define+x16 +define+Page512 ../../Rtl/slim/tb_NFTop.v

vlog +incdir+../../Model/ST_NAND512R3A_VG1.0/code ../../Model/ST_NAND512R3A_VG1.0/code/NAND512R3A.v



vsim tb_NFTop


#destroy .wave

view wave
do wave.do

#do wave512.do

run 10ms


