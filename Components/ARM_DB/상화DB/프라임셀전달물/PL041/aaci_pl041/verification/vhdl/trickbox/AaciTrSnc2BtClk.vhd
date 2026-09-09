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
-- File Name              : AaciTrSnc2BtClk.vhd.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Synchronisers for signals crossing from PCLK domain
--           to BITCLK domain
--
-- --=================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- ---------------------------------------------------------------------

entity AaciTrSnc2BtClk is
  port (
-- Inputs
        BITCLKIn         : in    std_logic; -- BITCLK serial clock
        nAACIBITCLKRST   : in    std_logic; -- BITCLK domain reset
        AACITrTxEn       : in    std_logic; -- Transmit Enable
        AACITrRxEn       : in    std_logic; -- Receive Enable
        AACITrEn         : in    std_logic; -- Trickbox enable
        AACITrBtClkE     : in    std_logic; -- BITCLK Enable
        AACITrWintGen    : in    std_logic; -- Wake up interrupt gen
        AACITrWidChkEn   : in    std_logic; -- Data width check enable
-- Outputs
        AACITrEnBSync    : out   std_logic; -- Trickbox Enable
        TxEnSync         : out   std_logic; -- Transmit Enable
        RxEnSync         : out   std_logic; -- Receive Enable
        BtClkESync       : out   std_logic; -- BITCLK Enable
        WintGenSync      : out   std_logic; -- Wake up interrupt gen
        WidChkEnSync     : out   std_logic  -- Data width check enable
       );
end AaciTrSnc2BtClk;

-- ---------------------------------------------------------------------
--
--                           AaciTrSnc2BtClk
--                           ===============
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--
-- This block implements the synchronisers for signals crossing over
-- from the PCLK domain to the BITCLK domain. The signals are 'double-
-- synchronise'd using inferred d-type flip-flops.
--
-- ---------------------------------------------------------------------

-- --======================== ARCHITECTURE ===========================--

architecture behavioural of AaciTrSnc2BtClk is

-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------
signal TxEnSync1        : std_logic;
-- 1st stage synchronised version of AACITrTxEn input

signal AACITrEnSync1    : std_logic;
-- 1st stage synchronised version of AACITrEn input

signal RxEnSync1        : std_logic;
-- 1st stage synchronised version of AACITrRxEn input

signal BtClkESync1      : std_logic;
-- 1st stage synchronised version of AACITrBtClkE input

signal WintGenSync1     : std_logic;
-- 1st stage synchronised version of AACITrWintGen input

signal WidChkEnSync1    : std_logic;
-- 1st stage synchronised version of AACITrWidChkEn input

-- ---------------------------------------------------------------------
--
-- Main body of Code
-- =================
--
-- ---------------------------------------------------------------------

begin

-- ---------------------------------------------------------------------
-- Double-synchronise with inferred D-types
-- ---------------------------------------------------------------------
p_SyncBtClk: process (BITCLKIn, nAACIBITCLKRST)
begin
  if (nAACIBITCLKRST = '0') then
    AACITrEnSync1    <= '0';
    TxEnSync1        <= '0';
    RxEnSync1        <= '0';
    BtClkESync1      <= '0';
    WintGenSync1     <= '0';
    WidChkEnSync1    <= '0';
    AACITrEnBSync    <= '0';
    TxEnSync         <= '0';
    RxEnSync         <= '0';
    BtClkESync       <= '0';
    WintGenSync      <= '0';
    WidChkEnSync     <= '0';
  elsif (BITCLKIn'event and BITCLKIn = '1') then
    AACITrEnSync1    <= AACITrEn;
    TxEnSync1        <= AACITrTxEn;
    RxEnSync1        <= AACITrRxEn;
    BtClkESync1      <= AACITrBtClkE;
    WintGenSync1     <= AACITrWintGen;
    WidChkEnSync1    <= AACITrWidChkEn;
    AACITrEnBSync    <= AACITrEnSync1;
    TxEnSync         <= TxEnSync1;
    RxEnSync         <= RxEnSync1;
    BtClkESync       <= BtClkESync1;
    WintGenSync      <= WintGenSync1;
    WidChkEnSync     <= WidChkEnSync1;
  end if;
end process p_SyncBtClk;

end behavioural;

-- --============================ End ================================--
