-- --========================================================================---
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
--  Version and Release Control Information:
--  
--  File Name              : SspTrSynctoPCLK.vhd.rca
--  File Revision          : 1.1
--  
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
-- -----------------------------------------------------------------------------
-- Purpose      : Synchronisers for signals crossing from SSPCLK domain to
--                PCLK domain
-- -----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SspTrSynctoPCLK is
  port (
        PCLK            : in    std_logic;  -- APB bus clock
        PRESETn         : in    std_logic;  -- APB bus Reset 
        TxRxBSY         : in    std_logic;  -- SSPTRickbox Tx/Rx controller busy
        TxFRdPtrInc     : in    std_logic;  -- TX FIFO read pointer incr for MT
        STxFRdPtrInc    : in    std_logic;  -- TX FIFO read pointer incr for ST.
        RxFWr           : in    std_logic;  -- RX FIFO write enable
        SRxFWr          : in    std_logic;  -- RX FIFO write enable
        TxRxBSYSync     : out   std_logic;  -- To TX FIFO
        TxFRdPtrIncSync : out   std_logic;  -- To TX FIFO
        STxFRdPtrIncSync: out   std_logic;  -- To TX FIFO
        RxFWrSync       : out   std_logic;  -- To RX FIFO
        SRxFWrSync      : out   std_logic   -- To RX FIFO
       );
end SspTrSynctoPCLK;

-- -----------------------------------------------------------------------------
--
--                               SspTrSynctoPCLK
--                               ===============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--
-- This block implements the synchronisers for signals crossing over from the
-- SSPCLK domain to the PCLK domain. The signals are 'double-synchronise'd 
-- using inferred d-type flip-flops.
-- 
-- -----------------------------------------------------------------------------

-- --============================ ARCHITECTURE ===============================--

architecture behavioural of SspTrSynctoPCLK  is

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal TxFRdPtrIncSync1  : std_logic;
-- 1st stage synchronised version of TxFRdPtrInc input 

signal STxFRdPtrIncSync1 : std_logic;
-- 1st stage synchronised version of TxFRdPtrInc1 input 

signal RxFWrSync1        : std_logic;
-- 1st stage synchronised version of RxFWr input

signal SRxFWrSync1       : std_logic;
-- 1st stage synchronised version of SRxFWr input

signal TxRxBSYSync1      : std_logic;
-- 1st stage synchronised version of TxRxBSY input

-- ---------------------------------------------------------------------------
-- 
-- Main body of Code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- Double-synchronise with inferred D-types 
-- -----------------------------------------------------------------------------
p_Sync: process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    TxFRdPtrIncSync1  <= '0';
    STxFRdPtrIncSync1 <= '0';
    TxFRdPtrIncSync   <= '0';
    STxFRdPtrIncSync  <= '0';
    RxFWrSync1        <= '0';
    SRxFWrSync1       <= '0';
    RxFWrSync         <= '0';
    SRxFWrSync        <= '0';
    TxRxBSYSync1      <= '0';
    TxRxBSYSync       <= '0';
  elsif (PCLK'event and PCLK = '1') then
    TxFRdPtrIncSync1  <= TxFRdPtrInc;
    STxFRdPtrIncSync1 <= STxFRdPtrInc;
    TxFRdPtrIncSync   <= TxFRdPtrIncSync1;
    STxFRdPtrIncSync  <= STxFRdPtrIncSync1;
    RxFWrSync1        <= RxFWr;
    SRxFWrSync1       <= SRxFWr;
    RxFWrSync         <= RxFWrSync1;
    SRxFWrSync        <= SRxFWrSync1;
    TxRxBSYSync1      <= TxRxBSY;
    TxRxBSYSync       <= TxRxBSYSync1;
  end if;
end process p_Sync;

end behavioural;

-- --========================= End ===========================================--








