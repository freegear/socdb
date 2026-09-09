--====================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
-- 
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
-- 
-- File Name           : timing.vhd.rca 
-- File Revision       : 1.2
-- 
-- Release Information : PrimeCell(TM)-PL061-REL1v0 
-- 
-- ---------------------------------------------------------------------
-- Purpose             : Example timing file
-- --=================================================================--

library ieee;
use     ieee.std_logic_1164.all;

package timing is
  
------------------------------------------------------------------------
-- TIMING PARAMETERS
------------------------------------------------------------------------

      -- Define the low phase of clock
      constant Tclkl       : time   := 5 ns;

      -- Define the high phase of clock
      constant Tclkh       : time   := 5 ns;

      -- Define the initial delay of the first clock edge
 
      -- The clock line will remain low at the start of 
      -- simulation. The first rising edge of clock will
      -- occur Tclks after simulation start. This parameter
      -- can be varied to eliminate false violations at the 
      -- start of simulations during netlist simulations.  

      constant Tclks       : time   := 5 ns;
  
   ---------------------------------------------------------------------
   --  APB Slave Output Parameters
   ---------------------------------------------------------------------
      constant Tovpdr       : time   := (0.2 * (Tclkl + Tclkh));
      constant Tohpdr       : time   :=  0 ns ;
 
   ---------------------------------------------------------------------
   --  APB Slave Input Parameters
   ---------------------------------------------------------------------
      constant Tisnres     : time := 1 ns;
      constant Tihnres     : time := 1 ns;
      constant reset_del   : time := 1 ns; 
   -- reset is asserted asynchronously but Test bench needs a value
 
   ---------------------------------------------------------------------
   -- The input setup time for the APB bus signals is set at 40% of the
   -- time period of the bus clock. The setup times are measured from 
   -- the following rising edge of clock. Since the APB testbench takes
   -- the falling edge of clock as reference, the times have been ]
   -- adjusted by subtracting the low phase time of the clock.
   ---------------------------------------------------------------------
      constant Tispen       : time   := (0.4 * (Tclkl + Tclkh) - Tclkl);
      constant Tihpen       : time   := 0 ns;
      constant Tispsel      : time   := (0.4 * (Tclkl + Tclkh) - Tclkl);
      constant Tihpsel      : time   := 0 ns;
      constant Tispaddr     : time   := (0.4 * (Tclkl + Tclkh) - Tclkl);
      constant Tihpaddr     : time   := 0 ns;
      constant Tispw        : time   := (0.4 * (Tclkl + Tclkh) - Tclkl);
      constant Tihpw        : time   := 0 ns;
      constant Tispdw       : time   := (0.4 * (Tclkl + Tclkh) - Tclkl);
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

--=============================== End ================================--
