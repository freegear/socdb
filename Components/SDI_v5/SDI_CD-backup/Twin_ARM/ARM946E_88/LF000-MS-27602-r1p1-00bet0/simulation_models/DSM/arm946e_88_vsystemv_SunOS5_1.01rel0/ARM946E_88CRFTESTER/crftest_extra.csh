#!/bin/csh -f
# Crftester script
# Copyright ARM Ltd 2002.  All rights reserved.

set root = `pwd`

cd $ARM946E_88_HOME/ARM946E_88CRFTESTER

setenv DIR_ARM946E_88CRFTESTER `pwd`

vlib work
vlog $DIR_ARM946E_88/extra/ARM946E_88.v ARM946E_88CRFTESTER.v
ln -s $DIR_ARM946E_88/extra/ARM946E_88.tdef $DIR_ARM946E_88/ARM946E_88.tdef
vsim -t ps -c  ARM946E_88CRFTESTERTOP < do | tee crftest_extra.log

echo ""
echo ""
echo ""

echo "========================================================"
grep " 0 vectors failed" crftest_extra.log > tmp_crftest_extra.log
if ( $status != 0 ) then
	echo " Error : the ARM946E_88 DSM is not correctly setup "
else 
	echo " The ARM946E_88 DSM is correctly setup"
	endif
echo "========================================================"
rm tmp_crftest_extra.log
cd $root
echo ""
echo "" 

rm -f $DIR_ARM946E_88/ARM946E_88.tdef
