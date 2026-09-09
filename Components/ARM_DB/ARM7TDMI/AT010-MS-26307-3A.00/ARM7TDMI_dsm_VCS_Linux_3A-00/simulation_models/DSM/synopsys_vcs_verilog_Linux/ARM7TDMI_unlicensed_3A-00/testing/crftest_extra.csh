#!/bin/tcsh -f
# Crftester script
# Copyright ARM Ltd 2005.  All rights reserved.

set root = `pwd`

cd $ARM7TDMI_HOME/testing

setenv DIR_ARM7TDMICRFTESTER `pwd`
vcs -Mupdate -P pli.tab -LDFLAGS "-L${MG_LIB}/synopsys_vcs_verilog" -lmgmm -ldl  ARM7TDMICRFTESTER.v $DIR_ARM7TDMI/extra_wrapper/ARM7TDMI.v
./simv +vcs+lic+wait | tee   crftest_extra.log

echo ""
echo ""
echo ""

echo "========================================================"
grep " 0 vectors failed" crftest_extra.log > tmp_crftest_extra.log
if ( $status != 0 ) then
	echo " Error : the ARM7TDMI DSM is not correctly setup "
else 
	echo " The ARM7TDMI DSM is correctly setup"
	endif
echo "========================================================"
rm tmp_crftest_extra.log
cd $root
echo ""
echo "" 

rm -f $DIR_ARM7TDMI/ARM7TDMI.tdef
