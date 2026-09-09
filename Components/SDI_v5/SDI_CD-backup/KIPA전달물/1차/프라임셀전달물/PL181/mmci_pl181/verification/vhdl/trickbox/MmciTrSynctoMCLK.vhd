-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : MmciTrSynctoMCLK.vhd.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Describe block function here.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity MmciTrSynctoMCLK is
  port (
-- Inputs
        MCLK             : in    std_logic; -- Main MMCI Clock
        nMMCIRST         : in    std_logic; -- MMCI Reset
        MPUpdate         : in    std_logic; -- Updt sigl for MMCIPower
        MCUpdate         : in    std_logic; -- Updt sigl for MMCIClock
        MCMUpdate        : in    std_logic; -- Updt sigl for MMCICmd
        MDLUpdate        : in    std_logic; -- Updt sigl for
                                            -- MMCIDataLength
        MDCUpdate        : in    std_logic; -- Update signal for
                                            -- MMCIDataCntl
        MTBCUpdate       : in    std_logic; -- Update signal for
                                            -- MMCITBControl
-- Outputs
        MPUpdateSync     : out   std_logic; -- Sync Updt signal for
                                            -- MMCIPower
        MCUpdateSync     : out   std_logic; -- Sync Updt signal for
                                            -- MMCIClock
        MCMUpdateSync    : out   std_logic; -- Sync Updt signal for
                                            -- MMCICommand
        MDLUpdateSync    : out   std_logic; -- Sync Updt signal for
                                            -- MMCIDataLen
        MDCUpdateSync    : out   std_logic; -- Sync Updt signal for
                                            -- MMCIDataCtl
        MTBCUpdateSync   : out   std_logic  -- Sync Updt signal for
                                            -- MMCITBCtrl
       );
end MmciTrSynctoMCLK;

-- -----------------------------------------------------------------------------
--
--                              MmciTrSynctoMCLK
--                              ================
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--
--  In this block the PCLK generated signals are double synchronized
-- using MCLK flops.
--
-- -----------------------------------------------------------------------------

-- --=========================== ARCHITECTURE ================================--

architecture behavioural of MmciTrSynctoMCLK is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal MPUpdateSync1    : std_logic;
-- 1st stage synchronised version of MPUpdate input

signal MCUpdateSync1    : std_logic;
-- 1st stage synchronised version of MCUpdate input

signal MCMUpdateSync1   : std_logic;
-- 1st stage synchronised version of MCMUpdate input

signal MDLUpdateSync1   : std_logic;
-- 1st stage synchronised version of MDLUpdate input

signal MDCUpdateSync1   : std_logic;
-- 1st stage synchronised version of MDCUpdate input

signal MTBCUpdateSync1  : std_logic;
-- 1st stage synchronised version of MTBCUpdate input

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
-- Double-synchronisation
-- -----------------------------------------------------------------------------
p_syncMCLK : process (MCLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    MPUpdateSync1    <= '0';
    MCUpdateSync1    <= '0';
    MCMUpdateSync1   <= '0';
    MDLUpdateSync1   <= '0';
    MDCUpdateSync1   <= '0';
    MTBCUpdateSync1  <= '0';
    MPUpdateSync     <= '0';
    MCUpdateSync     <= '0';
    MCMUpdateSync    <= '0';
    MDLUpdateSync    <= '0';
    MDCUpdateSync    <= '0';
    MTBCUpdateSync   <= '0';
  elsif (MCLK'event and MCLK = '1') then
    MPUpdateSync1    <= MPUpdate;
    MPUpdateSync     <= MPUpdateSync1;

    MCUpdateSync1    <= MCUpdate;
    MCUpdateSync     <= MCUpdateSync1;

    MCMUpdateSync1   <= MCMUpdate;
    MCMUpdateSync    <= MCMUpdateSync1;

    MDLUpdateSync1   <= MDLUpdate;
    MDLUpdateSync    <= MDLUpdateSync1;

    MDCUpdateSync1   <= MDCUpdate;
    MDCUpdateSync    <= MDCUpdateSync1;

    MTBCUpdateSync1  <= MTBCUpdate;
    MTBCUpdateSync   <= MTBCUpdateSync1;
  end if;
end process p_syncMCLK;
end behavioural;

-- --================================== End ==================================--
