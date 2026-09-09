#!/bin/csh -f
# Crftester script
# Copyright ARM Ltd 2002.  All rights reserved.

set root = `pwd`

cd $ARM946E_88_HOME/ARM946E_88CRFTESTER

setenv DIR_ARM946E_88CRFTESTER `pwd`
ln  -s  $DIR_ARM946E_88/ARM946E_88.sdf  ARM946E_88.sdf
verilog  -s -i do_sdf  ARM946E_88CRFTESTER.v $DIR_ARM946E_88/ARM946E_88.v | tee crftest.log

#+loadpli1=${MG_LIB}/cadence_xl_verilog/mm_xl_dynamic:mgmm_bootstrap 

echo ""
echo ""
echo ""

echo "========================================================"
grep " 0 vectors failed" crftest.log > tmp_crftest.log
if ( $status != 0 ) then
	echo " Error : the ARM946E_88 Model is not correctly setup "
else 
	echo " The ARM946E_88 Model is correctly setup"
	endif
echo "========================================================"
rm tmp_crftest.log
cd $root
echo ""
echo "" 

