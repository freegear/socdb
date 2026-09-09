-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 1999 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
-- 
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
-- 
-- File Name           : timing.vhd,v 
-- File Revision       : 1.3 
-- 
-- Release Information : PL160-REL1v1 
-- 
-- -----------------------------------------------------------------------------
-- Purpose             : Example timing file.
-- 
-- --=========================================================================--

library ieee;
use     ieee.std_logic_1164.all;

package timing is
  
-------------------------------------------------------------------------------
-- TIMING PARAMETERS
--------------------------------------------------------------------------------
   ----------------------------------------------------------------------
   --  APB Slave Output Parameters
   ----------------------------------------------------------------------

      constant Tovpdr       : time   := 10 ns ;
      constant Tohpdr       : time   :=  0 ns ;
 
   ----------------------------------------------------------------------
   --  APB Slave Input Parameters
   ----------------------------------------------------------------------
  
      constant Tisnres     : time := 2 ns;
      constant Tihnres     : time := 2 ns;
      constant reset_del   : time := 2 ns; -- reset is asserted asynchronously
                                           -- but Test bench  needs a value
 
      constant Tispen       : time   := -2 ns;
      constant Tihpen       : time   := 0 ns;
      constant Tispsel      : time   := -2 ns;
      constant Tihpsel      : time   := 0 ns;
      constant Tispaddr     : time   := -2 ns;
      constant Tihpaddr     : time   := 0 ns;
      constant Tispw        : time   := -2 ns;
      constant Tihpw        : time   := 0 ns;
      constant Tispdw       : time   := -2 ns;
      constant Tihpdw       : time   := 0 ns;


--  Propagation delays for virtual register (only valid for write-only 
--  registers. Single delay to the whole register)

      constant vrg0_del    : time := 5 ns;
      constant vrg1_del    : time := 5 ns;
      constant vrg2_del    : time := 5 ns;
      constant vrg3_del    : time := 5 ns;
      constant vrg4_del    : time := 5 ns;
      constant vrg5_del    : time := 5 ns;
      constant vrg6_del    : time := 5 ns;
      constant vrg7_del    : time := 5 ns;
   
end timing;

-- --================================= End ===================================--
