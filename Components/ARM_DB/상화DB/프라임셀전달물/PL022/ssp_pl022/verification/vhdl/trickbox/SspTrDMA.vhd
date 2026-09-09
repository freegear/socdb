-- ========================================================================== --
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  ----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--  
--  File Name              : SspTrDMA.vhd.rca
--  File Revision          : 1.2
--  
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
--------------------------------------------------------------------------------
-- Purpose     : This block generates the SSPDMACLR signals
--  
-- ========================================================================== --
--  
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

--  ----------------------------------------------------------------------------

entity SspTrDMA is
  port (PCLK             : in  std_logic;      -- APB Clock
        PRESETn          : in  std_logic;      -- Muxed Reset (from PRESETn)
        SSPTXDMACLRStag1 : in  std_logic;      -- 1st stage for SSPTXDMACLR
        SSPRXDMACLRStag1 : in  std_logic;      -- 1st stage for SSPRXDMACLR
        SSPTXDMACLR      : out std_logic;      -- Transmit DMA request clear
        SSPRXDMACLR      : out std_logic;      -- Receive DMA request clear
        SSPTXDMACLRStag4 : out std_logic;      -- For SSPTXDMACLR
        SSPRXDMACLRStag4 : out std_logic       -- For SSPRXDMACLR
        );
end SspTrDMA;



--------------------------------------------------------------------------------
--
--                   SspTrDMA
--                   =========
--
--------------------------------------------------------------------------------
--
-- Overview
-- ========
-- This module generates the SSPTXDMACLR and SSPRXDMACLR signals.
-- These are used to test the Ssp DMA interface.

--=============================== ARCHITECTURE ===============================--
 
architecture synth of SspTrDMA  is

--------------------------------------------------------------------------------
-- Component declarations
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constant declarations
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Signal declarations
--------------------------------------------------------------------------------


 signal TXDMACLRStag2      : std_logic;
 -- 2nd delayed version of SSPTXDMACLRStag1
 
 signal TXDMACLRStag3      : std_logic;
 -- 3rd delayed version of SSPTXDMACLRStag1
 
 signal iSSPTXDMACLRStag4    : std_logic;
 -- Internal version of 4th delayed version of SSPTXDMACLRStag1

 signal TXDMACLRStag5      : std_logic;
 -- 5th delayed version of SSPTXDMACLRStag1
 
 signal RXDMACLRStag2      : std_logic;
 -- 2nd delayed version of SSPRXDMACLRStag1
 
 signal RXDMACLRStag3      : std_logic;
 -- 3rd delayed version of SSPRXDMACLRStag1
 
 signal iSSPRXDMACLRStag4    : std_logic;
 -- Internal version of 4th delayed version of SSPRXDMACLRStag1

 signal RXDMACLRStag5      : std_logic;
 -- 5th delayed version of SSPTXDMACLRStag1



 --------------------------------------------------------------------------------
-- 
-- Main VHDL code
-- ==============
--
--------------------------------------------------------------------------------

begin

--------------------------------------------------------------------------------
-- Connect local copies of signals to ports
-------------------------------------------------------------------------------- 
 SSPTXDMACLRStag4 <= iSSPTXDMACLRStag4;
 SSPRXDMACLRStag4 <= iSSPRXDMACLRStag4;


--------------------------------------------------------------------------------
-- Sequential process for registers/flip-flops in this block
--------------------------------------------------------------------------------
  p_Seq : process (PCLK, PRESETn)
  begin
    if (PRESETn = '0') then
      TXDMACLRStag2       <= '0';
      TXDMACLRStag3       <= '0';
      iSSPTXDMACLRStag4   <= '0';
      TXDMACLRStag5       <= '0';
      RXDMACLRStag2       <= '0';
      RXDMACLRStag3       <= '0';
      iSSPRXDMACLRStag4   <= '0';
      RXDMACLRStag5       <= '0';
    elsif (PCLK'event and PCLK = '1') then
      TXDMACLRStag2       <= SSPTXDMACLRStag1;
      TXDMACLRStag3       <= TXDMACLRStag2;
      iSSPTXDMACLRStag4   <= TXDMACLRStag3;
      TXDMACLRStag5       <= iSSPTXDMACLRStag4;
      RXDMACLRStag2       <= SSPRXDMACLRStag1;
      RXDMACLRStag3       <= RXDMACLRStag2;
      iSSPRXDMACLRStag4   <= RXDMACLRStag3;
      RXDMACLRStag5       <= iSSPRXDMACLRStag4;
   end if;
  end process p_Seq;
  

  -------------------------------------------------------------------
  -- SSPTXDMACLR is a four PCLK-wide pulse used to clear the
  -- SSPTXDMA requests.
  -------------------------------------------------------------------


  SSPTXDMACLR <= ((SSPTXDMACLRStag1 and not(TXDMACLRStag2) and
                   not(TXDMACLRStag3) and not(iSSPTXDMACLRStag4) and
                   not(TXDMACLRStag5)) or (SSPTXDMACLRStag1 and (TXDMACLRStag2) and
                   not(TXDMACLRStag3) and not(iSSPTXDMACLRStag4) and
                   not(TXDMACLRStag5)) or (SSPTXDMACLRStag1 and (TXDMACLRStag2) and
                   (TXDMACLRStag3) and not(iSSPTXDMACLRStag4) and
                   not(TXDMACLRStag5)) or (SSPTXDMACLRStag1 and (TXDMACLRStag2) and
                   (TXDMACLRStag3) and (iSSPTXDMACLRStag4) and not(TXDMACLRStag5)));  


  -------------------------------------------------------------------
  -- SSPRXDMACLR is a four PCLK-wide pulse used to clear the
  -- SSPRXDMA requests.
  -------------------------------------------------------------------

  SSPRXDMACLR <= ((SSPRXDMACLRStag1 and not(RXDMACLRStag2) and
                   not(RXDMACLRStag3) and not(iSSPRXDMACLRStag4) and
                   not(RXDMACLRStag5)) or (SSPRXDMACLRStag1 and (RXDMACLRStag2) and
                   not(RXDMACLRStag3) and not(iSSPRXDMACLRStag4) and
                   not(RXDMACLRStag5)) or (SSPRXDMACLRStag1 and (RXDMACLRStag2) and
                   (RXDMACLRStag3) and not(iSSPRXDMACLRStag4) and
                   not(RXDMACLRStag5)) or (SSPRXDMACLRStag1 and (RXDMACLRStag2) and
                   (RXDMACLRStag3) and (iSSPRXDMACLRStag4) and not(RXDMACLRStag5)));  
end synth;


--========================== End of SspTrDMA ==============================--
