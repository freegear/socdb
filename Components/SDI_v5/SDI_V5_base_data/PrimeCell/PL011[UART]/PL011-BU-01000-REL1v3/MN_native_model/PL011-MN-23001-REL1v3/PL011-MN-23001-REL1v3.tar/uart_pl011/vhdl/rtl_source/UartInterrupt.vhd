--  ----------------------------------------------------------------------------
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
--  File Name              : UartInterrupt.vhd.rca
--  File Revision          : 1.3
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

entity UartInterrupt is
  port (
        DataStp      : in  std_logic;      -- for UARTRTINTR
        UARTMSINT    : in  std_logic;      -- for UARTMSINTR
        UARTEINTRfbp : in  std_logic;      -- Combined int for break, frame,parity
        UARTTXMIS    : in  std_logic;      -- Transmit Interrupt
        UARTRXMIS    : in  std_logic;      -- Receive Interrupt
        UARTOEMIS    : in  std_logic;      -- Overrun error interrupt

        UARTRTIC     : in  std_logic;      -- RTINTR clear
        UARTDSRIC    : in  std_logic;      -- DSR MSINTR clear
        UARTDCDIC    : in  std_logic;      -- DCD MSINTR clear
        UARTCTSIC    : in  std_logic;      -- CTS MSINTR clear
        UARTRIIC     : in  std_logic;      -- RI MSINTR clear
        UARTOEIC     : in  std_logic;      -- OEINTR clear
        UARTBEIC     : in  std_logic;      -- BEINTR clear
        UARTPEIC     : in  std_logic;      -- PEINTR clear
        UARTFEIC     : in  std_logic;      -- FEINTR clear
        
        RTINTR       : out std_logic;      -- Receive Timeout interrupt
        MSINTR       : out std_logic;      -- Modem status interrupt
        EINTR        : out std_logic;      -- Combined Error interrupt
        UARTINT      : out std_logic       -- Combined interrupt
        );
end UartInterrupt;

--------------------------------------------------------------------------------
-- Purpose     : This block contains the interrupt logic for the UART.
--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
--
--                   UartInterrupt
--                   =============
--
--------------------------------------------------------------------------------
--
-- Overview
-- ========
--  This block contains the aynchronous interrupt logic.  The
--  interrupts from the UARTCLK domain are ANDed with the relevant
--  interrupt clear signal and taken as ouptuts.  The interrupts are
--  generated asynchronously but cleared synchronuosly with PCLK.
--------------------------------------------------------------------------------
--
--=============================== ARCHITECTURE ===============================--
--
--------------------------------------------------------------------------------
-- Architecture Packages
--------------------------------------------------------------------------------

architecture synth of UartInterrupt is

--------------------------------------------------------------------------------
-- Component Declaration
--------------------------------------------------------------------------------
  
--------------------------------------------------------------------------------
-- Internal Constants
--------------------------------------------------------------------------------
  
--------------------------------------------------------------------------------
-- Internal Signals
--------------------------------------------------------------------------------

  signal MSINTRCLR  : std_logic;
  -- Combined Modem interrupt clear signal
  
  signal EINTRCLR   : std_logic;
  -- Combined Error interrupt clear signal
  
  signal ERRINTR    : std_logic;
  -- Combined Error interrupt signal

  signal iRTINTR    : std_logic;
  -- Internal version of RTINTR
  
  signal  iMSINTR   : std_logic;
  -- Internal version of MSINTR
  
  signal  iEINTR    : std_logic;
  -- Internal version of EINTR

--------------------------------------------------------------------------------
--
-- Main VHDL code
-- ==============
--
--------------------------------------------------------------------------------

begin

---------------------------------------------------------------------
-- Generate a combined modem interrupt clear by ORing together the
-- individual modem interrupt clear signals.
---------------------------------------------------------------------

  MSINTRCLR <= UARTDSRIC or UARTDCDIC or UARTCTSIC or UARTRIIC; 

---------------------------------------------------------------------
-- Generate a combined error interrupt clear by ORing together the
-- individual error interrupt clear signals.
---------------------------------------------------------------------

  EINTRCLR  <= UARTOEIC or UARTBEIC or UARTPEIC or UARTFEIC;


---------------------------------------------------------------------
-- OR together the break, frame and parity interrupt with the Overrun
-- interrupt to generate one combimed error interrupt.
---------------------------------------------------------------------
  ERRINTR   <= UARTEINTRfbp or UARTOEMIS;
  
---------------------------------------------------------------------
-- When the relevant interrupt clear signal is asserted, the
-- asynchronous interrupt is cleared.  
---------------------------------------------------------------------

  iRTINTR   <= DataStp and not(UARTRTIC);
  iMSINTR   <= UARTMSINT and not(MSINTRCLR);
  iEINTR    <= ERRINTR and not EINTRCLR;

-------------------------------------------------------------------
-- Combine all interrupts to generate UARTINTR
-------------------------------------------------------------------

  UARTINT   <= iRTINTR or iMSINTR or iEINTR or UARTTXMIS or UARTRXMIS;


  RTINTR    <= iRTINTR;
  MSINTR    <= iMSINTR;
  EINTR     <= iEINTR;
  
end synth;          

--========================== End of UartInterrupt =================================--
