#!/bin/csh -f
# Crftester script
# Copyright ARM Ltd 2002.  All rights reserved.

set root = `pwd`

cd $ARM946E_88_HOME/ARM946E_88CRFTESTER

setenv DIR_ARM946E_88CRFTESTER `pwd`
rm -r work

vlib work
vlog $DIR_ARM946E_88/ARM946E_88.v ARM946E_88CRFTESTER.v
vsim -t ps -c  -sdftyp theARM946E_88=${DIR_ARM946E_88}/ARM946E_88.sdf ARM946E_88CRFTESTERTOP < do | tee crftest.log

echo ""
echo ""
echo ""

echo "========================================================"
grep " 0 vectors failed" crftest.log > tmp_crftest.log
if ( $status != 0 ) then
	echo " Error : the ARM946E_88 DSM is not correctly setup "
else 
	echo " The ARM946E_88 DSM is correctly setup"
	endif
echo "========================================================"
rm tmp_crftest.log
cd $root
echo ""
echo "" 

