#!/bin/csh -f
# Crftester script
# Copyright ARM Ltd 2002.  All rights reserved.

set root = `pwd`

cd $ARM946E_88_HOME/ARM946E_88CRFTESTER

setenv DIR_ARM946E_88CRFTESTER `pwd`
ln -s $DIR_ARM946E_88/extra/ARM946E_88.tdef $DIR_ARM946E_88/ARM946E_88.tdef
verilog +loadpli1=${MG_LIB}/cadence_xl_verilog/mm_xl_dynamic:mgmm_bootstrap -s -i do      ARM946E_88CRFTESTER.v $DIR_ARM946E_88/extra/ARM946E_88.v | tee crftest_extra.log

echo ""
echo ""
echo ""

echo "========================================================"
grep " 0 vectors failed" crftest_extra.log > tmp_crftest_extra.log
if ( $status != 0 ) then
	echo " Error : the ARM946E_88 Model is not correctly setup "
else 
	echo " The ARM946E_88 Model is correctly setup"
	endif
echo "========================================================"
rm tmp_crftest_extra.log
cd $root
echo ""
echo "" 

rm -f $DIR_ARM946E_88/ARM946E_88.tdef
