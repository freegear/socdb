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
-- File Name              : SmcSynchroniser.vhd.rca
-- File Revision          : 1.22
--
-- Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
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

entity SmcSynchroniser is
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB Bus Clock
        HRESETn          : in    std_logic; -- AHB Bus Reset Signal
        SMWAIT           : in    std_logic; -- Asynchronous Wait signal from
                                            -- external memory controller
        CANCELSMWAIT     : in    std_logic; -- Asynchronous external input pin
                                            -- to signal that the SMWAIT has
                                            -- timed out

-- Outputs
        SmWaitS2         : out   std_logic; -- Double syncronized SMWAIT
        CnclSmWaitS2     : out   std_logic  -- Double syncronised CanSMWAIT
       );
end SmcSynchroniser;

-- -----------------------------------------------------------------------------
--
--                               SmcSynchroniser
--                               ===============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--         The external asynchronous SMWAIT input and CANCELSMWAIT input are
--         double synchronised in this module and routed to the Timer module.
--
-- -----------------------------------------------------------------------------

-- --============================== ARCHITECTURE =============================--

architecture synth of SmcSynchroniser is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------

signal SmWaitS1         : std_logic;
-- First level syncronization of the async SMWAIT

signal CnclSmWaitS1     : std_logic;
-- First level synchronisation of the async CanSMWAIT

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
-- In this process the external asynchronous SMWAIT and CANCELSMWAIT signals
-- from the external controller are double synchronized before use.
-- The polarity of SMWAIT input is programmable. So by default the SMWAIT is
-- assumed to be active low
-- The CANCELSMWAIT input is an active high signal which indicates that
-- after assertion of the SMWAIT input, the time out for the de-assertion has
-- occured. The SmcCore will then abort this transfer with an error response.
-- -----------------------------------------------------------------------------
p_SMWaitSyncSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    SmWaitS1         <= '1';
    SmWaitS2         <= '1';
    CnclSmWaitS1     <= '0';
    CnclSmWaitS2     <= '0';
  elsif (HCLK'event and HCLK = '1') then
    SmWaitS1         <= SMWAIT;
    SmWaitS2         <= SmWaitS1;
    CnclSmWaitS1     <= CANCELSMWAIT;
    CnclSmWaitS2     <= CnclSmWaitS1;
  end if;
end process p_SMWaitSyncSeq;

end synth;

-- --================================== End ==================================--
