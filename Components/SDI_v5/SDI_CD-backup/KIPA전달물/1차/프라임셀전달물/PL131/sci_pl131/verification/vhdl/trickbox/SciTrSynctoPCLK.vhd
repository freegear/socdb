-- --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  ----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : SciTrSynctoPCLK.vhd.rcaS
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--
--  ----------------------------------------------------------------------------
 
--  ----------------------------------------------------------------------------
--  Purpose : This block synchronises signals crossing over from
--            the SCIREFCLK domain into the PCLK domain.
-- --=========================================================================--
  
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

--------------------------------------------------------------------------------

entity SciTrSynctoPCLK is
  port (
        TxFRdPtrInc     : in   std_logic;  -- Sync Tx FIFO Rd point Inc
        RxFWr           : in   std_logic;  -- RX FIFO write
        PCLK            : in   std_logic;  -- APB bus clock
        PRESETn         : in   std_logic;  -- reset input 
        TxFRdPtrIncSync : out  std_logic;  -- Tx FIFO Rd point Inc 
        RxFWrSync       : out  std_logic   -- Sync for RX FIFO write
       );
end SciTrSynctoPCLK;

--------------------------------------------------------------------------------
--
--                   SciTrSynctoPCLK
--                   ===============
--
--------------------------------------------------------------------------------
-- Overview
-- ========
--
-- This module synchronises signals crossing over from the PCLK
-- domain into the SCIREFCLK domain.
--------------------------------------------------------------------------------

--=============================== ARCHITECTURE ===============================--

--------------------------------------------------------------------------------
-- Architecture Packages
--------------------------------------------------------------------------------

architecture synth of SciTrSynctoPCLK  is

--------------------------------------------------------------------------------
-- Signal declarations
--------------------------------------------------------------------------------

signal DTxFRdPtrInc  : std_logic;
-- Delayed version of TxFRdPtrInc

signal DRxFWr     : std_logic;
-- Delayed  version of RxFWr

--------------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
--------------------------------------------------------------------------------

begin

--------------------------------------------------------------------------------
-- Synchronisers for FIFO-related signals
--------------------------------------------------------------------------------
p_FIFOSeq : process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then  
    DRxFWr       <= '0';
    DTxFRdPtrInc <= '0';
  elsif (PCLK'event and PCLK = '1') then
    DTxFRdPtrInc <= TxFRdPtrInc;
    DRxFWr       <= RxFWr;
  end if;
end process p_FIFOSeq;

--------------------------------------------------------------------------------
-- Genrate a pule of width PCLK if any change in the signal level
--------------------------------------------------------------------------------
TxFRdPtrIncSync  <= TxFRdPtrInc xor DTxFRdPtrInc;
RxFWrSync        <= RxFWr xor DRxFWr; 
 
end synth;

--=============================== End =======================================--














