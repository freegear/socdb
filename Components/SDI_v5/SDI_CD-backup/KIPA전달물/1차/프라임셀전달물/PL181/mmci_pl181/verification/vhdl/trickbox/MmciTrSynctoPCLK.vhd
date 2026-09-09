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
-- File Name              : MmciTrSynctoPCLK.vhd.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           All MMCICLK domain signals are synchronised to PCLK.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity MmciTrSynctoPCLK is
  port (
-- Inputs
        PCLK             : in    std_logic; -- APB Bus Clock
        PRESETn          : in    std_logic; -- APB Bus reset
        MTBCIUpdate      : in    std_logic; -- Update sig for
                                            -- MMCITBRxdCInd
        MTBCAUpdate      : in    std_logic; -- Update sig for
                                            -- MMCITBRxdCArg
        RxFWr            : in    std_logic; -- Rx FIFO Wr enable
        TxFRd            : in    std_logic; -- Tx FIFO Rd enable
        FifoClear        : in    std_logic; -- Fifo clear signal
-- Outputs
        MTBCIUpdateSync  : out   std_logic; -- Syncd Updt sig for
                                            -- MMCITBRxdCInd
        MTBCAUpdateSync  : out   std_logic; -- Syncd Updt sig for
                                            -- MMCITBRxdCArg
        FifoClearSync    : out   std_logic; -- Syncd clear signal
        RxFWrSync        : out   std_logic; -- Syncd Rx FIFO Wr enable
        TxFRdSync        : out   std_logic  -- Syncd Tx FIFO Rd enable
       );
end MmciTrSynctoPCLK;

-- -----------------------------------------------------------------------------
--
--                              MmciTrSynctoPCLK
--                              ================
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--
--  In this block the MMCICLK generated signals are double synchronised
-- using PCLK.
--
-- -----------------------------------------------------------------------------

-- --=========================== ARCHITECTURE ================================--

architecture behavioural of MmciTrSynctoPCLK is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal MTBCIUpdateSync1 : std_logic;
-- 1st stage synchronised version of MTBCIUpdate input

signal MTBCAUpdateSync1 : std_logic;
-- 1st stage synchronised version of MTBCAUpdate input

signal RxFWrSync1       : std_logic;
-- 1st stage synchronised version of RxFWr

signal TxFRdSync1       : std_logic;
-- 1st stage synchronised version of TxFRd

signal FifoClearSync1   : std_logic;
-- 1st stage synchronised version of FifoClear

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
p_syncPCLK : process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    MTBCIUpdateSync1  <= '0';
    MTBCAUpdateSync1  <= '0';
    RxFWrSync1        <= '0';
    TxFRdSync1        <= '0';
    FifoClearSync1    <= '0';
    MTBCIUpdateSync   <= '0';
    MTBCAUpdateSync   <= '0';
    RxFWrSync         <= '0';
    TxFRdSync         <= '0';
    FifoClearSync     <= '0';
  elsif (PCLK'event and PCLK = '1') then
    MTBCIUpdateSync1  <= MTBCIUpdate;
    MTBCIUpdateSync   <= MTBCIUpdateSync1;

    MTBCAUpdateSync1  <= MTBCAUpdate;
    MTBCAUpdateSync   <= MTBCAUpdateSync1;

    RxFWrSync1        <= RxFWr;
    RxFWrSync         <= RxFWrSync1;

    TxFRdSync1        <= TxFRd;
    TxFRdSync         <= TxFRdSync1;

    FifoClearSync1    <= FifoClear;
    FifoClearSync     <= FifoClearSync1;
  end if;
end process p_syncPCLK;
end behavioural;

-- --================================== End ==================================--
