#!/usr/bin/csh -f

if  ($#argv > 0)  then
   set install_dir=$1
else 
   set install_dir=$LMC_HOME
endif

$ARM946E_88_HOME/ARM946E_88.sunos5/solaris/sl_admin -install $ARM946E_88_HOME/ARM946E_88.sunos5 $install_dir  -platform solaris -edav other $ARM946E_88_HOME/ARM946E_88.sunos5/swift_models.lst 

