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
-- File Name              : SsmcSynchroniser.vhd.rca
-- File Revision          : 1.10
--
-- Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Asynchronous external inputs are double synchronised in
--           this module.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SsmcSynchroniser is
  port (
-- Inputs
        SMMEMCLK         : in    std_logic; -- AHB Bus Clock
        HRESETn          : in    std_logic; -- AHB Bus Reset Signal
        SMWAIT           : in    std_logic; -- Asynchronous Wait signal from
                                            -- external memory controller
        SMCANCELWAIT     : in    std_logic; -- Asynchronous external input pin
                                            -- to signal that the SMWAIT has
                                            -- timed out
        WaitPol          : in    std_logic; -- Indication of the Wait polarity
-- Outputs
        SmWaitSync       : out   std_logic; -- Double synchronised SMWAIT
        SmCancelWaitSync : out   std_logic  -- Double synchronised CanSMWAIT
       );
end SsmcSynchroniser;

-- -----------------------------------------------------------------------------
--
--                              SsmcSynchroniser
--                              ================
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--         The external asynchronous SMWAIT input and SMCANCELWAIT input are
--         double synchronised in this module and routed to SsmcTSM module
--
-- -----------------------------------------------------------------------------

-- --============================== ARCHITECTURE =============================--

architecture synth of SsmcSynchroniser is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------

signal SmWaitSync1      : std_logic;
-- First level Synchronisation of the Async SMWAIT

signal SmWaitSync2      : std_logic;
-- Second level Synchronisation of the Async SMWAIT

signal SmCnclWaitSync1  : std_logic;
-- First level Synchronisation of the Async SMCANCELWAIT

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
-- In this process the external asynchronous SMWAIT and SMCANCELWAIT signals
-- from the external controller are double synchronised before use.
-- The polarity of SMWAIT input is programmable. So by default the SMWAIT is
-- assumed to be active low.
-- The SMCANCELWAIT input is an active high signal which indicates that
-- after assertion of the SMWAIT input, the time out for the de-assertion has
-- occured. The SsmcCore will then abort this transfer with an error response.
-- -----------------------------------------------------------------------------
p_SMWaitSyncSeq : process (SMMEMCLK, HRESETn)
begin
  if (HRESETn = '0') then
    SmWaitSync1      <= '1';
    SmWaitSync2      <= '1';
    SmCnclWaitSync1  <= '0';
    SmCancelWaitSync <= '0';
  elsif (SMMEMCLK'event and SMMEMCLK = '1') then
    SmWaitSync1      <= SMWAIT;
    SmWaitSync2      <= SmWaitSync1;
    SmCnclWaitSync1  <= SMCANCELWAIT;
    SmCancelWaitSync <= SmCnclWaitSync1;
  end if;
end process p_SMWaitSyncSeq;

SmWaitSync <= SmWaitSync2 when (WaitPol = '0')
           else
              not SmWaitSync2;
end synth;

-- --================================== End ==================================--
