source /tools/synopsys/fm_2004.06/admin/setup/.synopsys_fm.setup
set verification_set_undriven_signals 0

read_verilog -container r -libname WORK { /LDisk/HomeM1P0/dikwon/FastSPI/Rtl/Ssp.v }
read_verilog -container r -libname WORK { /LDisk/HomeM1P0/dikwon/FastSPI/Rtl/SspApbif.v }
read_verilog -container r -libname WORK { /LDisk/HomeM1P0/dikwon/FastSPI/Rtl/SspDataStp.v }
read_verilog -container r -libname WORK { /LDisk/HomeM1P0/dikwon/FastSPI/Rtl/SspDefs.v }
read_verilog -container r -libname WORK { /LDisk/HomeM1P0/dikwon/FastSPI/Rtl/SspIntGen.v }
read_verilog -container r -libname WORK { /LDisk/HomeM1P0/dikwon/FastSPI/Rtl/SspMTxRxCntl.v }
read_verilog -container r -libname WORK { /LDisk/HomeM1P0/dikwon/FastSPI/Rtl/SspNewDMA.v }
read_verilog -container r -libname WORK { /LDisk/HomeM1P0/dikwon/FastSPI/Rtl/SspRxFCntl.v }
read_verilog -container r -libname WORK { /LDisk/HomeM1P0/dikwon/FastSPI/Rtl/SspRxFIFO.v }
read_verilog -container r -libname WORK { /LDisk/HomeM1P0/dikwon/FastSPI/Rtl/SspRxRegFile.v }
read_verilog -container r -libname WORK { /LDisk/HomeM1P0/dikwon/FastSPI/Rtl/SspSTxRxCntl.v }
read_verilog -container r -libname WORK { /LDisk/HomeM1P0/dikwon/FastSPI/Rtl/SspScaleCntr.v }
read_verilog -container r -libname WORK { /LDisk/HomeM1P0/dikwon/FastSPI/Rtl/SspTest.v }
read_verilog -container r -libname WORK { /LDisk/HomeM1P0/dikwon/FastSPI/Rtl/SspTxFCntl.v }
read_verilog -container r -libname WORK { /LDisk/HomeM1P0/dikwon/FastSPI/Rtl/SspTxFIFO.v }
read_verilog -container r -libname WORK { /LDisk/HomeM1P0/dikwon/FastSPI/Rtl/SspTxLJustify.v }
read_verilog -container r -libname WORK { /LDisk/HomeM1P0/dikwon/FastSPI/Rtl/SspTxRegFile.v }

read_db -container r { /LDisk/HomeM1P0/dikwon/FastSPI/Syn/SynDB/slow.db } 

set_top r:/WORK/Ssp
 
read_verilog -container i -libname WORK { /LDisk/HomeM1P0/dikwon/FastSPI/Syn/Net/Ssp.noscan.v }

read_db -container i { /LDisk/HomeM1P0/dikwon/FastSPI/Syn/SynDB/slow.db } 

set_top i:/WORK/Ssp

set_reference_design  r:/WORK/Ssp
set_implementation_design  i:/WORK/Ssp

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



