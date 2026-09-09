# DSM setup script
# Copyright ARM Ltd 2005.  All rights reserved.

cwd=`pwd`
cd $ARM7TDMI_HOME/../../../

MG_LIB=`pwd`/ModelManager/MMAPI_5.0.1/SunOS/MM ; export MG_LIB
DIR_ARM7TDMI=$ARM7TDMI_HOME/ARM7TDMI ; export DIR_ARM7TDMI
cd $cwd

echo "Edit modelsim.ini to include the line : "
echo '   Veriuser = $MG_LIB/mti_modelsim_verilog/libmgmm.so '
