# DSM setup script
# Copyright ARM Ltd 2005.  All rights reserved.


setenv orig_dir `pwd`
cd $ARM7TDMI_HOME/../../../

setenv MG_LIB `pwd`/ModelManager/MMAPI_5.0.1/Linux/MM
setenv DIR_ARM7TDMI $ARM7TDMI_HOME/ARM7TDMI
cd $orig_dir

if ( ${?LD_LIBRARY_PATH} == 1 ) then 
	setenv LD_LIBRARY_PATH  ${MG_LIB}/synopsys_vcs_verilog:$LD_LIBRARY_PATH
else
	setenv LD_LIBRARY_PATH  ${MG_LIB}/synopsys_vcs_verilog
endif
