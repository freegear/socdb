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
--  File Name              : UartTrDMA.vhd.rca
--  File Revision          : 1.4
--  
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
--------------------------------------------------------------------------------
-- Purpose     : This block generates the UARTDMACLR signals
--  
-- ========================================================================== --
--  
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

--  ----------------------------------------------------------------------------

entity UartTrDMA is
  port (PCLK          :	in  std_logic;      -- APB Clock
        PRESETn       :	in  std_logic;	    -- AMBA Reset
        TXDMACLRStag1 : in  std_logic;      -- 1st stage for UARTTXDMACLR
        RXDMACLRStag1 : in  std_logic;      -- 1st stage for UARTRXDMACLR
        UARTTXDMACLR  : out std_logic;      -- Transmit DMA request clear
        UARTRXDMACLR  : out std_logic;      -- Receive DMA request clear
        TXDMACLRStag4 : out std_logic;      -- For UARTTXDMACLR
        RXDMACLRStag4 : out std_logic       -- For UARTRXDMACLR
        );
end UartTrDMA;



--------------------------------------------------------------------------------
--
--                   UartTrDMA
--                   =========
--
--------------------------------------------------------------------------------
--
-- Overview
-- ========
-- This module generates the UARTTXDMACLR and UARTRXDMACLR signals.
-- These are used to test the Uart DMA interface.

--=============================== ARCHITECTURE ===============================--
 
architecture synth of UartTrDMA  is

--------------------------------------------------------------------------------
-- Component declarations
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constant declarations
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Signal declarations
--------------------------------------------------------------------------------

  signal TXDMACLRStag2    : std_logic;
 -- 1st delayed version of TXDMACLRStag1

 signal TXDMACLRStag3      : std_logic;
  -- 2nd delayed version of TXDMACLRStag1
  
 signal iTXDMACLRStag4      : std_logic;
  -- 3rd delayed version of TXDMACLRStag1
  
 signal TXDMACLRStag5      : std_logic;
 -- 4th delayed version of TXDMACLRStag1

 signal RXDMACLRStag2    : std_logic;
 -- 1st delayed version of RXDMACLRStag1

 signal RXDMACLRStag3      : std_logic;
 -- 2nd delayed version of RXDMACLRStag1

 signal iRXDMACLRStag4      : std_logic;
 -- 3rd delayed version of RXDMACLRStag1

 signal RXDMACLRStag5      : std_logic;
 -- 4th delayed version of RXDMACLRStag1


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
 TXDMACLRStag4 <= iTXDMACLRStag4;
 RXDMACLRStag4 <= iRXDMACLRStag4;


--------------------------------------------------------------------------------
-- Sequential process for registers/flip-flops in this block
--------------------------------------------------------------------------------
  p_Seq : process (PCLK, PRESETn)
  begin
    if (PRESETn = '0') then
      TXDMACLRStag2    <= '0';
      TXDMACLRStag3    <= '0';
      iTXDMACLRStag4   <= '0';
      TXDMACLRStag5    <= '0';
      RXDMACLRStag2    <= '0';
      RXDMACLRStag3    <= '0';
      iRXDMACLRStag4   <= '0';
      RXDMACLRStag5    <= '0';
    elsif (PCLK'event and PCLK = '1') then
      TXDMACLRStag2    <= TXDMACLRStag1;
      TXDMACLRStag3    <= TXDMACLRStag2;
      iTXDMACLRStag4   <= TXDMACLRStag3;
      TXDMACLRStag5    <= iTXDMACLRStag4;
      RXDMACLRStag2    <= RXDMACLRStag1;
      RXDMACLRStag3    <= RXDMACLRStag2;
      iRXDMACLRStag4   <= RXDMACLRStag3;
      RXDMACLRStag5    <= iRXDMACLRStag4;
    end if;
  end process p_Seq;
  

  -------------------------------------------------------------------
  -- UARTTXDMACLR is a four PCLK-wide pulse used to clear the
  -- UARTTXDMA requests.
  -------------------------------------------------------------------
 
 UARTTXDMACLR <= ((TXDMACLRStag1 and not(TXDMACLRStag2) and
                   not(TXDMACLRStag3) and not(iTXDMACLRStag4) and
                   not(TXDMACLRStag5)) or (TXDMACLRStag1 and (TXDMACLRStag2) and
                   not(TXDMACLRStag3) and not(iTXDMACLRStag4) and
                   not(TXDMACLRStag5)) or (TXDMACLRStag1 and (TXDMACLRStag2) and
                   (TXDMACLRStag3) and not(iTXDMACLRStag4) and
                   not(TXDMACLRStag5)) or (TXDMACLRStag1 and (TXDMACLRStag2) and
                   (TXDMACLRStag3) and (iTXDMACLRStag4) and not(TXDMACLRStag5)));  


  -------------------------------------------------------------------
  -- UARTRXDMACLR is a four PCLK-wide pulse used to clear the
  -- UARTRXDMA requests.
  -------------------------------------------------------------------
 
 UARTRXDMACLR <= ((RXDMACLRStag1 and not(RXDMACLRStag2) and
                   not(RXDMACLRStag3) and not(iRXDMACLRStag4) and
                   not(RXDMACLRStag5)) or (RXDMACLRStag1 and (RXDMACLRStag2) and
                   not(RXDMACLRStag3) and not(iRXDMACLRStag4) and
                   not(RXDMACLRStag5)) or (RXDMACLRStag1 and (RXDMACLRStag2) and
                   (RXDMACLRStag3) and not(iRXDMACLRStag4) and
                   not(RXDMACLRStag5)) or (RXDMACLRStag1 and (RXDMACLRStag2) and
                   (RXDMACLRStag3) and (iRXDMACLRStag4) and not(RXDMACLRStag5)));  


  
end synth;


--========================== End of UartTrDMA ==============================--
