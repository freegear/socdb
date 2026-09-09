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
#-- File Name           : $RCSfile: run_amba_tests_modelsim.tcsh,v $
#-- File Revision       : $Revision: 1.5 $
#--
#-- Release Information : $State: Exp $
#--
#-------------------------------------------------------------------------------
#-- Purpose : Script to run AMBA validation vectors using Modelsim
#-------------------------------------------------------------------------------

# Need a default infile.sim the first time we compile
# as it's read by the Ticbox so create one if it
# doesn't already exist
if !(-e infile.sim) then
touch infile.sim
endif

# Remove work directory if it already exists
if (-e work) then
  rm -rf work
endif

# Create work library and compile the Verilog
vlib work
vlog -f files_ahb.vc

# Remove infile.sim
rm infile.sim

# Now iterate through all of the vectors
foreach i (../../vectors/amba/sim/*.sim)
  ln -f -s $i infile.sim
  vlog ../verilog/tbench/Ticbox.v
  vsim tbench -c -do "run -all" -l ${i:t:r}.log
  rm infile.sim
end
