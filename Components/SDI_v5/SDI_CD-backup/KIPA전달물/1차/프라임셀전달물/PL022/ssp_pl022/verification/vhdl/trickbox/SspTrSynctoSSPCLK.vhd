-- --========================================================================--
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
--  File Name              : SspTrSynctoSSPCLK.vhd.rca
--  File Revision          : 1.1
--  
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
-- -----------------------------------------------------------------------------
-- Purpose      : Synchronisers for signals crossing from PCLK domain to
--                SSPCLK domain
-- -----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SspTrSynctoSSPCLK is
  port (
        SSPCLK          : in    std_logic;	-- Main SSP clock
        nSSPRES         : in    std_logic;	-- SSPClk Reset 
        TxDataAvlbl     : in    std_logic;	-- TX data available
        CR0Update       : in    std_logic;	-- Ctrl signal for SSPCR0 sync
        CR1Update       : in    std_logic;	-- Ctrl signal for SSPCR1 sync
        SSE             : in    std_logic;	-- SSPTB enable
        TxDataAvlblSync : out   std_logic;	-- To TxRx block
        CR0UpdateSync   : out   std_logic;	-- To Prescaler
        CR1UpdateSync   : out   std_logic;	-- To Prescaler
        SSESync         : out   std_logic	-- SSPTrickbox enable
       );
end SspTrSynctoSSPCLK;

-- -----------------------------------------------------------------------------
--
--                           SspTrSynctoSSPCLK
--                           =================
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--
-- This block implements the synchronisers for signals crossing over from the
-- PCLK domain to the SSPCLK domain. The signals are 'double-synchronise'd using
-- inferred d-type flip-flops.
-- 
-- -----------------------------------------------------------------------------

-- --============================ ARCHITECTURE ===============================--

architecture behavioural of SspTrSynctoSSPCLK is

-- -----------------------------------------------------------------------------
--  Signal declarations
-- -----------------------------------------------------------------------------
signal CR0UpdateSync1   : std_logic;
-- 1st stage synchronised version of SSCRUpdate input

signal CR1UpdateSync1   : std_logic;
-- 1st stage synchronised version of SSCRUpdate input
  
signal TxDataAvlblSync1 : std_logic;
-- 1st stage synchronised version of TxDataAvlbl input

signal SSESync1         : std_logic;
-- 1st stage synchronised version of SSE input

-- -----------------------------------------------------------------------------
-- 
-- Main body of code
-- ==================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- Double-synchronise with inferred D-types 
-- -----------------------------------------------------------------------------
p_SyncSeq: process (SSPCLK, nSSPRES)
begin
  if (nSSPRES = '0') then
    CR0UpdateSync1   <= '0';
    CR1UpdateSync1   <= '0';
    CR1UpdateSync    <= '0';
    CR0UpdateSync    <= '0';
    TxDataAvlblSync1 <= '0';
    TxDataAvlblSync  <= '0';
    SSESync1         <= '0';
    SSESync          <= '0';
  elsif (SSPCLK'event and SSPCLK = '1') then
    CR0UpdateSync1   <= CR0Update;
    CR0UpdateSync    <= CR0UpdateSync1;
    CR1UpdateSync1   <= CR1Update;
    CR1UpdateSync    <= CR1UpdateSync1;
    TxDataAvlblSync1 <= TxDataAvlbl;
    TxDataAvlblSync  <= TxDataAvlblSync1;
    SSESync1         <= SSE;
    SSESync          <= SSESync1;
  end if;
end process p_SyncSeq;

end behavioural;

-- --=========================== End =========================================--



