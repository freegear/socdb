# DSM setup script
# Copyright ARM Ltd 2005.  All rights reserved.

cwd=`pwd`
cd $ARM7TDMI_HOME/../../../

MG_LIB=`pwd`/ModelManager/MMAPI_5.0.1/Linux/MM ; export MG_LIB
DIR_ARM7TDMI=$ARM7TDMI_HOME/ARM7TDMI ; export DIR_ARM7TDMI
cd $cwd

if [ "x$LD_LIBRARY_PATH" = "x" ] 
then 
	LD_LIBRARY_PATH=${MG_LIB}/synopsys_vcs_verilog ; export LD_LIBRARY_PATH
else
	LD_LIBRARY_PATH=${MG_LIB}/synopsys_vcs_verilog:$LD_LIBRARY_PATH ; export LD_LIBRARY_PATH
fi
