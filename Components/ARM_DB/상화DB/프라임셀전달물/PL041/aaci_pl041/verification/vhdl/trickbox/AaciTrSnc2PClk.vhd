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
-- File Name              : AaciTrSnc2PClk.vhd.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Synchronisers for signals crossing from BITCLK domain
--           to PCLK domain
--
-- --=================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- ---------------------------------------------------------------------

entity AaciTrSnc2PClk is
  port (
-- Inputs
        PCLK             : in    std_logic; -- APB bus clock
        PRESETn          : in    std_logic; -- APB bus Reset
        TxFRdPtrInc      : in    std_logic; -- TX FIFO read pointer incr
        RxFWr            : in    std_logic; -- RX FIFO write enable
-- Outputs
        TxFRdPtrIncSync  : out   std_logic; -- To TX FIFO
        RxFWrSync        : out   std_logic  -- To RX FIFO
       );
end AaciTrSnc2PClk;

-- ---------------------------------------------------------------------
--
--                           AaciTrSnc2PClk
--                           ==============
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--
-- This block implements the synchronisers for signals crossing over
-- from the BITCLK domain to the PCLK domain. The signals are 'double-
-- synchronise'd using inferred d-type flip-flops.
--
-- ---------------------------------------------------------------------

-- --======================== ARCHITECTURE ===========================--

architecture behavioural of AaciTrSnc2PClk is

-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------
signal TxFRdPtrIncSync1 : std_logic;
-- 1st stage synchronised version of TxFRdPtrInc input

signal RxFWrSync1       : std_logic;
-- 1st stage synchronised version of RxFWr input

-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------

begin

-- ---------------------------------------------------------------------
-- Double-synchronise with inferred D-types
-- ---------------------------------------------------------------------
p_Sync: process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    TxFRdPtrIncSync1 <= '0';
    TxFRdPtrIncSync  <= '0';
    RxFWrSync1       <= '0';
    RxFWrSync        <= '0';
  elsif (PCLK'event and PCLK = '1') then
    TxFRdPtrIncSync1 <= TxFRdPtrInc;
    TxFRdPtrIncSync  <= TxFRdPtrIncSync1;
    RxFWrSync1       <= RxFWr;
    RxFWrSync        <= RxFWrSync1;
  end if;
end process p_Sync;

end behavioural;

-- --============================= End ===============================--
