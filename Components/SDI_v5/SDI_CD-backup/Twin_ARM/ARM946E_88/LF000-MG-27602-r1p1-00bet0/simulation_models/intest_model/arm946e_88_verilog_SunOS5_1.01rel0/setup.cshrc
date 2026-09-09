# DSM setup script
# Copyright ARM Ltd 2002.  All rights reserved.

setenv LMC_HOME $ARM946E_88_HOME/ARM946E_88.sunos5

echo " "

echo "Note that the enviroment variable LMC_HOME is created and points to"

echo "	$ARM946E_88_HOME/ARM946E_88.sunos5"

echo "and this is where your SWIFT model will be installed to by default."

echo " "

echo "If you wish to change where the model is installed, reset LMC_HOME before"

echo "running the installation of the SWIFT model."

echo " "

echo "SPECIAL NOTE: If you plan to run two or more different SWIFT models in the"

echo "simulation then they all need to be installed into the same LMC_HOME. Ensure "

echo "that you set LMC_HOME to be the same location before installing each SWIFT"

echo "model."

echo " "

setenv MG_LIB $ARM946E_88_HOME//ModelManager/SunOS5/MM
setenv DIR_ARM946E_88 $ARM946E_88_HOME//ARM946E_88

if ( ${?LD_LIBRARY_PATH} == 1 ) then 
	setenv LD_LIBRARY_PATH  ${MG_LIB}/cadence_xl_verilog:$LD_LIBRARY_PATH
else
	setenv LD_LIBRARY_PATH  ${MG_LIB}/cadence_xl_verilog
endif
