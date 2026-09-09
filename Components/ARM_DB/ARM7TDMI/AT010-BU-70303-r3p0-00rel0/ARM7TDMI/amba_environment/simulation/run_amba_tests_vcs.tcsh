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
#-- File Name           : $RCSfile: run_amba_tests_vcs.tcsh,v $
#-- File Revision       : $Revision: 1.5 $
#--
#-- Release Information : $State: Exp $
#--
#-------------------------------------------------------------------------------
#-- Purpose : Script to run AMBA validation vectors using VCS
#-------------------------------------------------------------------------------

# Remove any previous simulation snapshot
if (-e simv) then
  rm -rf simv
endif

# Remove any previous infile.sim
if (-e infile.sim) then
  rm infile.sim
endif

# Now iterate through all of the vectors
foreach i (../../vectors/amba/sim/*.sim)
  ln -f -s $i infile.sim
  vcs -Mupdate -P pli.tab -LDFLAGS "-L${MG_LIB}/synopsys_vcs_verilog/" -lmgmm -f files_ahb.vc 
  ./simv +vcs+lic+wait -l ${i:t:r}.log
  rm infile.sim
end
