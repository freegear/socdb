--  ----------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999-2000 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  ----------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : UartDMA.vhd.rca
--  File Revision          : 1.10
--  
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
--  ----------------------------------------------------------------------------
--  
--  
--  
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity UartDMA is
  port (
        PCLK             : in  std_logic;      -- APB Clock
        PRESETn          : in  std_logic;      -- AMBA Bus reset
        
        UARTEN           : in  std_logic;      --  Uart Enable
        TXDMAE           : in  std_logic;      --  Transmit DMA Enable
        RXDMAE           : in  std_logic;      --  Receive DMA Enable
        DMAONERR         : in  std_logic;      --  DMA on Error signal
        TXE              : in  std_logic;      -- Transmit Enable
        RXE              : in  std_logic;      -- Receive Enable
        FEN              : in  std_logic;      -- Fifo enable bit
        
        TESTFIFO         : in  std_logic;      -- Test FIFO mode
        TXIntLevel       : in  std_logic;      --  Transmit burst length
        RXIntLevel       : in  std_logic;      --  Receive burst length
        TXFLTE15Full     : in  std_logic;      -- TX FIFO has 1 or more spaces
        RXFGTE1Full      : in  std_logic;      -- RX FIFO contains data
        UARTTXDMACLRSync : in  std_logic;      --  DMA clear signal
        UARTRXDMACLRSync : in  std_logic;      --  DMA clear signal
        UARTREINTR       : in  std_logic;      -- Raw Uart Error Interrupt
        
        TXDMASREQ        : out std_logic;      -- Transmit single request
        TXDMABREQ        : out std_logic;      -- Transmit burst request
        RXDMASREQ        : out std_logic;      -- Receive single request
        RXDMABREQ        : out std_logic       -- Receive burst request
        );
end UartDMA;

---------------------------------------------------------------------
-- Purpose    :  This block contains the logic for the DMA Interface.
---------------------------------------------------------------------
--
---------------------------------------------------------------------
--
--                          UartDMA
--                          =======
--                          
---------------------------------------------------------------------
--
-- Overview
-- ========
-- This block conatins the logic for the DMA interface. It generates the
-- 4 DMA request signals, UARTTXDMASREQ, UARTRXDMASREQ,  and UARTRXDMABREQ
-- depending on the amount of data in the FIFO's.
-- 
--  Architecture Packages
--  =====================
-- 
-- -----------------------------------------------------------------------------


architecture synth of UartDMA is
  
  -- -----------------------------------------------------------------------------
  --  Internal Constants
  -- -----------------------------------------------------------------------------

  -- -----------------------------------------------------------------------------
  --  Internal Signals
  -- -----------------------------------------------------------------------------
  signal nextTXDMASREQ  : std_logic;
  -- D-input of TXDMASREQ
  
  signal nextTXDMABREQ  : std_logic;
  -- D-input of TXDMABREQ
  
  signal nextRXDMASREQ  : std_logic;
  -- D-input of RXDMASREQ
  
  signal nextRXDMABREQ  : std_logic;
  -- D-input of RXDMABREQ
  
  signal iTXDMABREQ     : std_logic;
  -- Internal version of TXDMABREQ
  
  signal iRXDMABREQ     : std_logic;
  -- Internal version of RXDMABREQ

  signal iTXDMASREQ     : std_logic;
  -- Internal version of TXDMASREQ
  
  signal iRXDMASREQ     : std_logic;
  -- Internal version of RXDMASREQ

  signal DMATXEn        : std_logic;
  --  DMA Transmit enable

  signal DMARXEn        : std_logic;
  --  DMA Receive enabe
  
  -- -----------------------------------------------------------------------------
  -- Main VHDL code
  -- ==============
  -- -----------------------------------------------------------------------------

begin

  --------------------------------------------------------------------------------
-- Connect local copies of signals to ports
--------------------------------------------------------------------------------
  TXDMABREQ <= iTXDMABREQ;
  RXDMABREQ <= iRXDMABREQ;
  TXDMASREQ <= iTXDMASREQ;
  RXDMASREQ <= iRXDMASREQ;
  
--------------------------------------------------------------------------------
-- Sequential process for registers/flip-flops in this block
--------------------------------------------------------------------------------
  p_Seq : process (PCLK, PRESETn)
  begin
    if (PRESETn = '0') then
      iTXDMASREQ <= '0';
      iTXDMABREQ <= '0';
      iRXDMASREQ <= '0';
      iRXDMABREQ <= '0';
    elsif (PCLK'event and PCLK = '1') then
      iTXDMASREQ <= nextTXDMASREQ;
      iTXDMABREQ <= nextTXDMABREQ;
      iRXDMASREQ <= nextRXDMASREQ;
      iRXDMABREQ <= nextRXDMABREQ;
    end if;   
  end process p_Seq;

  
---------------------------------------------------------------------
-- The DMATXEn is asserted when the UART is enabled and the Transmit
-- enable  bit is set, and the Transmit DMA bit is set in the
-- UARTDMACR register. This can also be asserted when the FIFOs need
-- to be tested with DMA.
---------------------------------------------------------------------

  DMATXEn <= '1' when ((UARTEN = '1' and TXE = '1') or
                       (TESTFIFO = '1')) and (TXDMAE = '1')
             else
             '0';
-------------------------------------------------------------------
-- The transmit single request is set when there is atleast one space
-- in the transmit FIFO. It is cleared when either there is a UARTTXDMACLRSync
-- signal or when the DMATXEn is not asserted.
-------------------------------------------------------------------

  p_TXDMASREQ : process (DMATXEn, UARTTXDMACLRSync, TXFLTE15Full, iTXDMASREQ) 
  begin
    if ((DMATXEn = '0') or  (UARTTXDMACLRSync = '1')) then 
      nextTXDMASREQ <= '0';
    elsif(TXFLTE15Full = '1') then
      nextTXDMASREQ <= '1';
    else
      nextTXDMASREQ <= iTXDMASREQ;
    end if;
  end process p_TXDMASREQ;


---------------------------------------------------------------------
-- The transmit burst request is set when there are more spaces than
-- the watermark level in the transmit FIFO. It is cleared when
-- either there is a UARTTXDMACLRSync signal or when the DMATXEn is
-- not asserted.
---------------------------------------------------------------------

  p_TXDMABREQ : process (DMATXEn, UARTTXDMACLRSync,TXIntLevel, FEN, iTXDMABREQ)
  begin
    if ((DMATXEn = '0') or  (UARTTXDMACLRSync = '1') or (FEN = '0')) then 
      nextTXDMABREQ <= '0';
    elsif(TXIntLevel = '1') then
      nextTXDMABREQ <= '1';
    else
      nextTXDMABREQ <= iTXDMABREQ;
    end if;
  end process p_TXDMABREQ;
  

---------------------------------------------------------------------
-- The DMARXEn is asserted when the UART is enabled and the Receive
-- enable  bit is set, and the Receive DMA bit is set in the
-- UARTDMACR register. This can also be aserted when the FIFOs need
-- to be tested with DMA. 
---------------------------------------------------------------------
  
  DMARXEn <= '1' when ((UARTEN = '1' and RXE = '1') or
                       (TESTFIFO = '1')) and (RXDMAE = '1')
             else
             '0';

-------------------------------------------------------------------
-- The receive single request is set when there is atleast one character
-- in the receive FIFO. It is cleared when either there is a UARTRXDMACLRSync
-- signal or when the DMARXEn is not asserted. 
-------------------------------------------------------------------
  
  p_RXDMASREQ : process (DMARXEn, UARTRXDMACLRSync, DMAONERR,
                         UARTREINTR, RXFGTE1Full, iRXDMASREQ) 
  begin
    if ((DMARXEn = '0') or  (UARTRXDMACLRSync = '1') or
        ((DMAONERR = '1') and (UARTREINTR = '1'))) then
      nextRXDMASREQ <= '0';
    elsif(RXFGTE1Full = '1') then
      nextRXDMASREQ <= '1';
    else
      nextRXDMASREQ <= iRXDMASREQ;
    end if;
  end process p_RXDMASREQ;


---------------------------------------------------------------------
-- The receive burst request is set when there are more characters than
-- the watermark level in the receive FIFO. It is cleared when
-- either:
--   - there is a UARTRXDMACLRSync signal
--   - the DMARXEn is not asserted or
--   - the DMAONERR bit is set and the error interrupt line is asserted.
---------------------------------------------------------------------
  
  p_RXDMABREQ : process (DMARXEn, UARTRXDMACLRSync, RXIntLevel, DMAONERR,
                         UARTREINTR, FEN, iRXDMABREQ)
  begin
    if ((DMARXEn = '0') or  (UARTRXDMACLRSync = '1') or
        ((DMAONERR = '1') and (UARTREINTR = '1')) or (FEN = '0')) then 
      nextRXDMABREQ <= '0';
    elsif(RXIntLevel = '1') then
      nextRXDMABREQ <= '1';
    else
      nextRXDMABREQ <= iRXDMABREQ;
    end if; 
  end process p_RXDMABREQ;


end synth;

-- --================================== End ==================================--



