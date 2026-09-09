-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000-2003 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : SmcRevAnd.vhd.rca
-- File Revision          : 1.22
--
-- Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Revision Designator Module
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SmcRevAnd is
  port (
-- Inputs
        TieOff1          : in    std_logic; -- Tieoff input 1
        TieOff2          : in    std_logic; -- Tieoff input 2
-- Outputs
        Revision         : out   std_logic  -- TieOff1 and TieOff2 ANDed
       );
end SmcRevAnd;

-- -----------------------------------------------------------------------------
--
--                                  SmcRevAnd
--                                  =========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--   This module contains a single AND gate to be used as a
-- place-holder cell to mark the Revision Number of the controller.
-- The 2 input pins will be tied-off at the top level of the
-- hierarchy. These "TieOffs" can be identified during layout
-- and re-wired to "VDD" or "VSS" if needed.
--
-- -----------------------------------------------------------------------------

-- --======================== ARCHITECTURE ===================================--

architecture synth of SmcRevAnd is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- The inputs TieOff1 and TieOff2 are ANDed to generate the Revision
-- number bit.
-- -----------------------------------------------------------------------------
Revision         <= TieOff1 and TieOff2;

end synth;

-- --================================== End ==================================--
