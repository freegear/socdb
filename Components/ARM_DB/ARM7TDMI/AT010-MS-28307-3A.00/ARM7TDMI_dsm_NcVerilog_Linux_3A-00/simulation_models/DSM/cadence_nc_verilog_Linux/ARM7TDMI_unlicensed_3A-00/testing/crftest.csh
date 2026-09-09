#!/bin/tcsh -f
# Crftester script
# Copyright ARM Ltd 2005.  All rights reserved.

set root = `pwd`

cd $ARM7TDMI_HOME/testing

setenv DIR_ARM7TDMICRFTESTER `pwd`
rm -r work
mkdir work
ncvlog $DIR_ARM7TDMI/ARM7TDMI.v 
ncvlog ARM7TDMICRFTESTER.v
ncsdfc $DIR_ARM7TDMI/ARM7TDMI.sdf -o ARM7TDMI.sdf.X
ncelab -loadpli1 ${MG_LIB}/cadence_nc_verilog/mm_nc_dynamic:mgboot_nc -SDF_CMD_FILE ARM7TDMICRFTESTER.scf ARM7TDMICRFTESTERTOP
ln  -s ../ARM7TDMI/ARM7TDMI.sdf .
ncsim  -nbasync -LICQUEUE ARM7TDMICRFTESTERTOP | tee  crftest.log

echo ""
echo ""
echo ""

echo "========================================================"
grep " 0 vectors failed" crftest.log > tmp_crftest.log
if ( $status != 0 ) then
	echo " Error : the ARM7TDMI DSM is not correctly setup "
else 
	echo " The ARM7TDMI DSM is correctly setup"
	endif
echo "========================================================"
rm tmp_crftest.log
cd $root
echo ""
echo "" 

