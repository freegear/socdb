#!/bin/tcsh -f
#-------------------------------------------------------------------------------
#-- The confidential and proprietary information contained in this file may
#-- only be used by a person authorised under and to the extent permitted
#-- by a subsisting licensing agreement from ARM Limited.
#--   (C) COPYRIGHT 2005 ARM Limited
#--       ALL RIGHTS RESERVED
#-- This entire notice must be reproduced on all copies of this file
#-- and copies of this file may only be made by a person if such person is
#-- permitted to do so under the terms of a subsisting license agreement
#-- from ARM Limited.
#-------------------------------------------------------------------------------
#-- Version and Release Control Information:
#--
#-- File Name           : $RCSfile: run_amba_tests_ncvlog.tcsh,v $
#-- File Revision       : $Revision: 1.5 $
#--
#-- Release Information : $State: Exp $
#--
#-------------------------------------------------------------------------------
#-- Purpose : Script to run AMBA validation vectors using NC-Verilog
#-------------------------------------------------------------------------------

# Need a default infile.sim the first time we compile
# as it's read by the Ticbox so create one if it
# doesn't already exist
if !(-e infile.sim) then
touch infile.sim
endif

# Compile all the Verilog
ncvlog -f files_ahb.vc

# Remove infile.sim 
rm infile.sim

# Now iterate through all of the vectors
foreach i (../../vectors/amba/sim/*.sim)
  ln -f -s $i infile.sim
  ncvlog ../verilog/tbench/Ticbox.v
  ncelab -loadpli1 ${MG_LIB}/cadence_nc_verilog/mm_nc_dynamic:mgboot_nc tbench
  ncsim  -nbasync -LICQUEUE tbench -log ${i:t:r}.log
  rm infile.sim
end
