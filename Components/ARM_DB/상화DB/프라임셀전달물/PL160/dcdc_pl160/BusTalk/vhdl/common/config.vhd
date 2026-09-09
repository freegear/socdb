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
-- File Name           : config.vhd,v 
-- File Revision       : 1.3 
-- 
-- Release Information : PL160-REL1v1 
-- 
-- -----------------------------------------------------------------------------
-- Purpose             : Configuration file for APB Slave test bench.
--                       Contains timing parameter declarations and values.
--                       These values should be modified for each APB Slave
--                       being tested.
-- 
-- --=========================================================================--

library ieee;
use     ieee.std_logic_1164.all;

library Std_DevelopersKit;
use     std_developerskit.std_IOpak.all;

package config is
  

  -- BCLK frequency
   
      constant Tclkl       : time := 10 ns;
      constant Tclkh       : time := 10 ns;

  -- used for running on after the test end.  Min value of period reccommended.
  
  constant extra_run_time : time := 20 ns;

  --  Test vector input filename (.bif = "bus interface format")

  file INFILE               : ascii_text is in "infile.bif";

  --  Defines if the simulation should stop after an error (FALSE means don't
  --  interrupt simulation)

  constant HaltOnMismatch   : boolean := FALSE;

  --  Defines the size of PA bus on the UUT. 

  constant PA_width   : integer := 8;

  --  Sets whether information messages should be printed out during simulation
  --  (Error messages are not affected)
 
  constant Verbosity  : boolean := TRUE;

--  The following constant is used to enable (FALSE) or disable (TRUE) the
--  monitor of tha AMBA signals while BnRES is asserted (LOW).

  constant SuppressOnReset : boolean := TRUE;

  -- The following constants configure virtual registers number and size
  
  constant vregbank_size    : integer := 4;   --  Number of VR
  constant vreg_size        : integer := 16;  --  size (global for all VR)

  subtype T_vreg is std_logic_vector((vreg_size - 1) downto 0);
  type T_vio is array (0 to (vregbank_size-1)) of T_vreg;
  type T_mode is (m_in,m_out);
  type T_vregbank is array (0 to (vregbank_size-1)) of T_mode;

  -- This constant defines the mode (direction) of each virtual register as an
  -- array of either m_in or m_out
  
  constant vreg_setup : T_vregbank := (m_out, m_out, m_in, m_in);

-------------------------------------------------------------------------------
-- TIMING PARAMETERS
--------------------------------------------------------------------------------

   ----------------------------------------------------------------------
   --  APB Slave Output Parameters
   ----------------------------------------------------------------------
      constant Tovpdr       : time   := tclkh;
      constant Tohpdr       : time   := 0 ns ;

   ----------------------------------------------------------------------
   --  APB Slave Input Parameters
   ----------------------------------------------------------------------
  
      --  These values are just examples.

      constant Tisnres     : time := 2 ns;
      constant Tihnres     : time := 2 ns;
      constant reset_del   : time := 2 ns; -- reset is asserted asynchronously
                                           -- but Test bench  needs a value
 
      constant Tispen       : time   := 4 ns;
      constant Tihpen       : time   := 4 ns;
      constant Tispsel      : time   := 4 ns;
      constant Tihpsel      : time   := 2 ns;
      constant Tispa        : time   := 4 ns;
      constant Tihpa        : time   := 1 ns;
      constant Tispw        : time   := 4 ns;
      constant Tihpw        : time   := 1 ns;
      constant Tispdw       : time   := 4 ns;
      constant Tihpdw       : time   := 1 ns;


--  Propagation delays for virtual register (only valid for write-only 
--  registers. Single delay to the whole register)

  type t_array is array(0 to vregbank_size-1) of time;

  constant vio_del    : t_array := (5 ns, 5 ns, 5 ns, 5 ns);
 
end config;

-- --================================= End ===================================--
