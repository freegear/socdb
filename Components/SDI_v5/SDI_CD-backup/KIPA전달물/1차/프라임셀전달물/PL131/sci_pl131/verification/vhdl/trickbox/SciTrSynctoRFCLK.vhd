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
--  File Name              : SciTrSynctoRFCLK.vhd.rcaS
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--
--  ----------------------------------------------------------------------------
 
--  ----------------------------------------------------------------------------
--  Purpose : This block synchronises signals crossing over from
--               the PCLK domain into the SCIREFCLK domain.
-- --=========================================================================--
 
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

--------------------------------------------------------------------------------

entity SciTrSynctoRFCLK is
  port (
        SCICLK           : in    std_logic;  -- SCI Reference clock
        PRESETn          : in    std_logic;  -- Reset input
        TxDataAvlbl      : in    std_logic;  -- TX FIFO dada evell
        TrCRUpdate       : in    std_logic;  -- Control Reg update trigger
        TrTXPCUpdate     : in    std_logic;  -- TX retray update trigger
        TrRXPCUpdate     : in    std_logic;  -- RX retray update trigger
        TrCTRLUpdate     : in    std_logic;  -- Error En  update trigger
        TrATUpdate       : in    std_logic;  -- ATIME update trigger
        TrDTUpdate       : in    std_logic;  -- DTIME update trigger
        TrTXBGUpdate     : in    std_logic;  -- TX BLKG update trigger
        TrTXCGUpdate     : in    std_logic;  -- TX CHTG update trigger
        TrCKICUpdate     : in    std_logic;  -- CLKICC update trigger
        TrBAUDUpdate     : in    std_logic;  -- BAUD update trigger
        TrVALUpdate      : in    std_logic;  -- VALUE update trigger
        TrRXCGUpdate     : in    std_logic;  -- RX CHGUR update trigger
        TrRXBGUpdate     : in    std_logic;  -- RX BLKGU update trigger
        TrJitUpdate      : in    std_logic;  -- Jit value update trigger
        TrJitPUpdate     : in    std_logic;  -- Jit Cnt update trigger
        TxDataAvlblSync  : out   std_logic;  -- Sync for Tx data Avilable
        TrCRUpdSync      : out   std_logic;  -- Sync for control Reg Update
        TrTXPCUpdSync    : out   std_logic;  -- Sync for TX Retray Update
        TrRXPCUpdSync    : out   std_logic;  -- Sync for RX Retray Update
        TrCTRLUpdSync    : out   std_logic;  -- Sync for Error En Update
        TrATUpdSync      : out   std_logic;  -- Sync for ATIMEUpdate
        TrDTUpdSync      : out   std_logic;  -- Sync for DTIMEUpdate
        TrTXBLKGUpdSync  : out   std_logic;  -- Sync for TX BLKG Updat
        TrTXCHGUpdSync   : out   std_logic;  -- Sync for TX CHG Update
        TrCKICCUpdSync   : out   std_logic;  -- Sync for CLKICCUpdat
        TrBAUDUpdSync    : out   std_logic;  -- Sync for BAUDUpdate
        TrVALUEUpdSync   : out   std_logic;  -- Sync for VALUEUpdate
        TrRXCHGUpdSync   : out   std_logic;  -- Sync for RX CHG Update
        TrRXBLKGUpdSync  : out   std_logic;  -- Sync for RX BLKG Update
        TrJitUpdSync     : out   std_logic;  -- Sync for Jit value Update
        TrJitPatUpdSync  : out   std_logic   -- Sync for Jit Cnt Update
       );
end SciTrSynctoRFCLK;

--------------------------------------------------------------------------------
--
--                   SciTrSynctoRFCLK
--                   =================
--
--------------------------------------------------------------------------------
-- Overview
-- ========
--
-- This module synchronises signals crossing over from the PCLK
-- domain into the SCICLK domain.
--------------------------------------------------------------------------------

--=============================== ARCHITECTURE ===============================--

architecture synth of SciTrSynctoRFCLK  is

--------------------------------------------------------------------------------
-- Signal declarations
--------------------------------------------------------------------------------

signal TxDataAvlblSync1  : std_logic;
-- 1st stage synchronised version of TxDataAvilabl

signal TrCRUpdSync1      : std_logic;
-- 1st stage synchronised version of Control Update

signal TrTXPCUpdSync1    : std_logic;	
-- 1st stage synchronised version of TrTXPCUpdate

signal TrRXPCUpdSync1    : std_logic;	
-- 1st stage synchronised version of TrRXPCUpdate

signal TrCTRLUpdSync1    : std_logic;	
-- 1st stage synchronised version of TrCTRLUpdate

signal TrATUpdSync1      : std_logic;	
-- 1st stage synchronised version of TrATUpdate

signal TrDTUpdSync1      : std_logic;	
-- 1st stage synchronised version of TrDTUpdate

signal TrTXBLKGUpdSync1  : std_logic;	
-- 1st stage synchronised version of TrTXBGUpdate

signal TrTXCHGUpdSync1   : std_logic;	
-- 1st stage synchronised version of TrTXCGUpdate

signal TrCKICCUpdSync1   : std_logic;	
-- 1st stage synchronised version of TrCKICUpdate

signal TrBAUDUpdSync1    : std_logic;	
-- 1st stage synchronised version of TrBAUDUpdate

signal TrVALUEUpdSync1   : std_logic;	
-- 1st stage synchronised version of TrVALUpdate

signal TrRXCHGUpdSync1   : std_logic;	
-- 1st stage synchronised version of TrRXCGUpdate

signal TrRXBLKGUpdSync1  : std_logic;	
-- 1st stage synchronised version of TrRXBGUpdate

signal TrJitUpdSync1     : std_logic;	
-- 1st stage synchronised version of TrJitUpdate

signal TrJitPatUpdSync1  : std_logic;	
-- 1st stage synchronised version of TrJitPUpdate

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
p_FIFOSeq : process (SCICLK, PRESETn)
begin
  if (PRESETn = '0') then  
    TxDataAvlblSync1 <= '0';
    TxDataAvlblSync <= '0';
  elsif (SCICLK'event and SCICLK = '1') then
    TxDataAvlblSync1 <= TxDataAvlbl;
    TxDataAvlblSync  <= TxDataAvlblSync1;
  end if;
end process p_FIFOSeq;

--------------------------------------------------------------------------------
-- Synchronisers for the all Update signals.
--------------------------------------------------------------------------------
p_UpdateSeq : process(SCICLK,PRESETn)
begin
  if (PRESETn = '0') then  
    TrCRUpdSync1      <= '0';	
    TrCRUpdSync       <= '0';	
    TrTXPCUpdSync1    <= '0';	
    TrTXPCUpdSync     <= '0';	
    TrRXPCUpdSync1    <= '0';	
    TrRXPCUpdSync     <= '0';	
    TrCTRLUpdSync1    <= '0';	
    TrCTRLUpdSync     <= '0';	
    TrATUpdSync1      <= '0';	
    TrATUpdSync       <= '0';	
    TrDTUpdSync1      <= '0';	
    TrDTUpdSync       <= '0';	
    TrTXBLKGUpdSync1  <= '0';	
    TrTXBLKGUpdSync   <= '0';	
    TrTXCHGUpdSync1   <= '0';	
    TrTXCHGUpdSync    <= '0';	
    TrCKICCUpdSync1   <= '0';	
    TrCKICCUpdSync    <= '0';	
    TrBAUDUpdSync1    <= '0';	
    TrBAUDUpdSync     <= '0';	
    TrVALUEUpdSync1   <= '0';	
    TrVALUEUpdSync    <= '0';	
    TrRXCHGUpdSync1   <= '0';	
    TrRXCHGUpdSync    <= '0';	
    TrRXBLKGUpdSync1  <= '0';	
    TrRXBLKGUpdSync   <= '0';	
    TrJitUpdSync      <= '0';
    TrJitUpdSync1     <= '0';
    TrJitPatUpdSync   <= '0';
    TrJitPatUpdSync1  <= '0';
  elsif (SCICLK'event and SCICLK = '1') then
    TrCRUpdSync1      <= TrCRUpdate; 
    TrCRUpdSync       <= TrCRUpdSync1; 
    TrTXPCUpdSync1    <= TrTXPCUpdate;
    TrTXPCUpdSync     <= TrTXPCUpdSync1;
    TrRXPCUpdSync1    <= TrRXPCUpdate;
    TrRXPCUpdSync     <= TrRXPCUpdSync1;
    TrCTRLUpdSync1    <= TrCTRLUpdate;
    TrCTRLUpdSync     <= TrCTRLUpdSync1;
    TrATUpdSync1      <= TrATUpdate;
    TrATUpdSync       <= TrATUpdSync1;
    TrDTUpdSync1      <= TrDTUpdate;
    TrDTUpdSync       <= TrDTUpdSync1;
    TrTXBLKGUpdSync1  <= TrTXBGUpdate;
    TrTXBLKGUpdSync   <= TrTXBLKGUpdSync1;
    TrTXCHGUpdSync1   <= TrTXCGUpdate;
    TrTXCHGUpdSync    <= TrTXCHGUpdSync1;
    TrCKICCUpdSync1   <= TrCKICUpdate;
    TrCKICCUpdSync    <= TrCKICCUpdSync1; 
    TrBAUDUpdSync1    <= TrBAUDUpdate; 
    TrBAUDUpdSync     <= TrBAUDUpdSync1; 
    TrVALUEUpdSync1   <= TrVALUpdate;
    TrVALUEUpdSync    <= TrVALUEUpdSync1;
    TrRXCHGUpdSync1   <= TrRXCGUpdate;
    TrRXCHGUpdSync    <= TrRXCHGUpdSync1;
    TrRXBLKGUpdSync1  <= TrRXBGUpdate;
    TrRXBLKGUpdSync   <= TrRXBLKGUpdSync1;
    TrJitUpdSync1     <= TrJitUpdate;
    TrJitUpdSync      <= TrJitUpdSync1;
    TrJitPatUpdSync1  <= TrJitPUpdate;
    TrJitPatUpdSync   <= TrJitPatUpdSync1;
  end if;
end process p_UpdateSeq;

end synth;

--=============================== End =======================================--













