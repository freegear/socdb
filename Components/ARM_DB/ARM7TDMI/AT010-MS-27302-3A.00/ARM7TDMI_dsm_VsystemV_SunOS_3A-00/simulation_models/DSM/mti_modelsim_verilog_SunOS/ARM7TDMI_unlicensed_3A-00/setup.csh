# DSM setup script
# Copyright ARM Ltd 2005.  All rights reserved.


setenv orig_dir `pwd`
cd $ARM7TDMI_HOME/../../../

setenv MG_LIB `pwd`/ModelManager/MMAPI_5.0.1/SunOS/MM
setenv DIR_ARM7TDMI $ARM7TDMI_HOME/ARM7TDMI
cd $orig_dir

echo "Edit modelsim.ini to include the line : "
echo '   Veriuser = $MG_LIB/mti_modelsim_verilog/libmgmm.so '
