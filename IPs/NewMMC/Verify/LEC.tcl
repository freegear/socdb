source /tools/synopsys/fm_2004.06/admin/setup/.synopsys_fm.setup
set verification_set_undriven_signals 0

read_verilog -container r -libname WORK { /LDisk/HomeM1P0/dikwon/NewMMC/Rtl/MMCTop.v }
read_verilog -container r -libname WORK { /LDisk/HomeM1P0/dikwon/NewMMC/Rtl/mmc_CommandControl.v }
read_verilog -container r -libname WORK { /LDisk/HomeM1P0/dikwon/NewMMC/Rtl/mmc_Fifo.v }
read_verilog -container r -libname WORK { /LDisk/HomeM1P0/dikwon/NewMMC/Rtl/mmc_Prescaler.v }
read_verilog -container r -libname WORK { /LDisk/HomeM1P0/dikwon/NewMMC/Rtl/mmc_DataControl.v }
read_verilog -container r -libname WORK { /LDisk/HomeM1P0/dikwon/NewMMC/Rtl/mmc_FifoDmaCtr.v }
read_verilog -container r -libname WORK { /LDisk/HomeM1P0/dikwon/NewMMC/Rtl/mmc_APBRegisterIF.v }
read_verilog -container r -libname WORK { /LDisk/HomeM1P0/dikwon/NewMMC/Rtl/mmc_FeedBackSync.v }
read_verilog -container r -libname WORK { /LDisk/HomeM1P0/dikwon/NewMMC/Rtl/mmc_PSave.v }

read_db -container r { /LDisk/HomeM1P0/dikwon/NewMMC/Syn/SynDB/RF2SH32x32_slow_syn.db } 
read_db -container r { /LDisk/HomeM1P0/dikwon/NewMMC/Syn/SynDB/slow.db } 

set_top r:/WORK/MMCTop
 
read_verilog -container i -libname WORK { /LDisk/HomeM1P0/dikwon/NewMMC/Syn/Net/MMCTop.noscan.v }

read_db -container i { /LDisk/HomeM1P0/dikwon/NewMMC/Syn/SynDB/RF2SH32x32_slow_syn.db } 
read_db -container i { /LDisk/HomeM1P0/dikwon/NewMMC/Syn/SynDB/slow.db } 

set_top i:/WORK/MMCTop

set_reference_design  r:/WORK/MMCTop
set_implementation_design  i:/WORK/MMCTop

#source cutpoint.tcl


#set_constant -type port r:/WORK/CCH_TOP/TEST_MODE 0
#set_constant -type port r:/WORK/CCH_TOP/TEST_SE 0
#set_constant -type port r:/WORK/CCH_TOP/BistMode 0
#set_constant -type port r:/WORK/CCH_TOP/ByPass 0

#set_constant -type port i:/WORK/CCH_TOP/TEST_MODE 0
#set_constant -type port i:/WORK/CCH_TOP/TEST_SE 0
#set_constant -type port i:/WORK/CCH_TOP/BistMode 0
#set_constant -type port i:/WORK/CCH_TOP/ByPass 0


match 

#set_dont_verify r:/WORK/zb_pad_top/VDD_digi_regu 
#set_dont_verify r:/WORK/zb_pad_top/DCCOUP 
#set_dont_verify r:/WORK/zb_pad_top/i_SPY05_TOP_v3/VDD1_8_D_M 
#set_dont_verify r:/WORK/zb_pad_top/i_SPY05_TOP_v3/DCCOUP 


verify 



