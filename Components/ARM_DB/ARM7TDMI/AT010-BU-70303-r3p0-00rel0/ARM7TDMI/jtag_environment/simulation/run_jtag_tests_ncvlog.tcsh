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
#-- File Name           : $RCSfile: run_jtag_tests_ncvlog.tcsh,v $
#-- File Revision       : $Revision: 1.3 $
#--
#-- Release Information : $State: Exp $
#--
#-------------------------------------------------------------------------------
#-- Purpose : Script to run JTAG validation vectors using NC-Verilog
#-------------------------------------------------------------------------------

ncvlog -f files_jtag.vc

foreach i (../../vectors/jtag/verilog/*.vec)
  ncvlog $i
  ncelab -loadpli1 ${MG_LIB}/cadence_nc_verilog/mm_nc_dynamic:mgboot_nc tbench
  ncsim  -nbasync -LICQUEUE tbench -log ${i:t:r}.log
end
