#!/bin/tcsh -f
# Crftester script
# Copyright ARM Ltd 2005.  All rights reserved.

set root = `pwd`

cd $ARM7TDMI_HOME/testing

setenv DIR_ARM7TDMICRFTESTER `pwd`
vcs -Mupdate -P pli.tab -LDFLAGS "-L${MG_LIB}/synopsys_vcs_verilog" -lmgmm  ARM7TDMICRFTESTER.v $DIR_ARM7TDMI/ARM7TDMI.v
ln  -s ../ARM7TDMI/ARM7TDMI.sdf .
./simv +vcs+lic+wait | tee   crftest.log

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

