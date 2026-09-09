-- --=================================================================--
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
-- File Name              : UartRevAnd.vhd.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL011-REL1v3
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Revision Designator Module
--
-- --=================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- ---------------------------------------------------------------------

entity UartRevAnd is
  port (
-- Inputs
        TieOff1   : in  std_logic;      -- AND gate input 1
        TieOff2   : in  std_logic;      -- AND gate input 2
-- Outputs
        Revision  : out std_logic       -- AND gate output
        );
end UartRevAnd;

-- ---------------------------------------------------------------------
--
--                              UartRevAnd
--                              =========
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--   This module contains a single AND gate to be used as a
-- place-holder cell to mark the Revision of the Uart.
-- The 2 input pins will be tied-off at the top level of the
-- hierarchy. These "TieOffs" can be identified during layout
-- and re-wired to "VDD" or "VSS" if needed.
--
-- ---------------------------------------------------------------------

-- --======================== ARCHITECTURE =========================--

architecture synth of UartRevAnd is

-- ---------------------------------------------------------------------
-- Component declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Function declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------

begin

  Revision  <= TieOff1 and TieOff2;

end synth;

-- --============================== End ==============================--
