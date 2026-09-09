-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2003 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : SsmcClockOr.vhd.rca
-- File Revision          : 1.8
--
-- Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block performs clock gating.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SsmcClockOr is
  port (
-- Inputs
        CLKIN            : in    std_logic; -- Clock input
        ClkStpd          : in    std_logic; -- Signal to indicate that clock
                                            -- output should be stopped
-- Outputs
        CLKOUT           : out   std_logic  -- Clock output
       );
end SsmcClockOr;

-- -----------------------------------------------------------------------------
--
--                                 SsmcClockOr
--                                 ===========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- This module drives CLKOUT from CLKIN, if ClkStpd bit is low. Otherwise it
-- drives high on CLKOUT. The ClkStpd bit is Clocked in SMMEMCLK Domain.
--
-- -----------------------------------------------------------------------------

-- --============================ ARCHITECTURE =============================--

architecture synth of SsmcClockOr is

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

CLKOUT <= ClkStpd or CLKIN;

-- synopsys translate_off
-- -----------------------------------------------------------------------------
-- START OF PROTOCOL CHECKERS
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- END OF PROTOCOL CHECKERS
-- -----------------------------------------------------------------------------
-- synopsys translate_on

end synth;

-- --================================== End ==================================--
