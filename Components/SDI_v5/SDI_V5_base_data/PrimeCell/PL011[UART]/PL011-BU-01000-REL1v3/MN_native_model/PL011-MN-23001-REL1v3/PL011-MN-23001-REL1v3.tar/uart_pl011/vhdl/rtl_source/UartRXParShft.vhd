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
--  File Name              : UartRXParShft.vhd.rca
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

entity UartRXParShft is
  port (
        UARTCLK       :	in  std_logic;      --  Main UART Clock
        nUARTRST      :	in  std_logic;	    -- Muxed reset (from nUARTRST)
        
        RXDsampled    :	in  std_logic;	    -- Sampled serial input
        ShiftEn       :	in  std_logic;	    -- Shift next bit
        SampleParity  :	in  std_logic;	    -- Enable Parity sample
        ClearShiftReg :	in  std_logic;	    -- Clear receive shifter
        SPS           : in  std_logic;      -- Stick Parity Select
        EPS           :	in  std_logic;	    -- Even Parity Select
        PEN           :	in  std_logic;	    -- Parity enable
        WLEN          :	in  std_logic_vector(1 downto 0);
                                            -- Bits per word
        
        PEIMSync      : in  std_logic;      --  Parity Error interrupt mask
        UARTPEICSync  : in  std_logic;      -- For Parity Error interrupt clear
        
        RecdDATA      :	out std_logic_vector(7 downto 0);
                                            -- Received Data
        DtPrZero      :	out std_logic;	    -- Data bits and Parity bit zero
        
        ParityError   :	out std_logic;	    -- Parity Error detected
        UARTPERIS     : out std_logic;      -- Parity Error Raw status
        UARTPEMIS     : out std_logic       -- Parity Error Masked status
        );
end UartRXParShft;

--------------------------------------------------------------------------------
-- Purpose     : This block performs serial shifting of received data
--               and performs parity check on the received data
--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
--
--                   UartRXParShft
--                   =============
--
--------------------------------------------------------------------------------
--
-- Overview
-- ========
--
--  This block performs shifting-in of the serial bit stream
-- and parity error checking on the received data. 
--  
--------------------------------------------------------------------------------
--
--=============================== ARCHITECTURE ===============================--
--
--------------------------------------------------------------------------------
-- Architecture Packages
--------------------------------------------------------------------------------

architecture synth of UartRXParShft  is

--------------------------------------------------------------------------------
-- Component Declaration
--------------------------------------------------------------------------------
  
--------------------------------------------------------------------------------
-- Internal Constants
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Internal Signals
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Receive data shift register
--------------------------------------------------------------------------------
  signal RXShiftReg        : std_logic_vector(7 downto 0);
  -- Receive Data shift register

  signal NextRXShiftReg    : std_logic_vector(7 downto 0);
  -- D-input of Shift register

--------------------------------------------------------------------------------
-- Error checking 
--------------------------------------------------------------------------------
  signal iParityError      : std_logic;
  -- Indicates that a Parity Error has been detected

  signal NextParityError   : std_logic;
  -- D-input of iParityError

  signal DelParityError    : std_logic;
  -- Delayed version of ParityError

  signal NextUARTPERIS     : std_logic;
  -- D-input of UARTPERIS
  
  signal DelUARTPEICSync   : std_logic;
  -- Delayed version of UARTPEICSync
  
  signal UARTPEIClr        : std_logic;
  -- Internal version of UARTPEIClr
  
  signal iUARTPERIS        : std_logic;
  -- Internal version of UARTPERIS

  signal ParityEdge        : std_logic;
  -- Detects rising edge on parity error
  
--------------------------------------------------------------------------------
-- Checking for Received Data and Parity Bit being all zeros
--------------------------------------------------------------------------------
  signal DataZero          : std_logic;
  -- Indicates that all data bits in the received character are zero

  signal iDtPrZero         : std_logic;
  -- Indicates that the data bits and the parity bit in the received character
  -- are zero

  signal NextDtPrZero      : std_logic;
  -- D-input of iDtPrZero

  
--------------------------------------------------------------------------------
--
-- Main VHDL code
-- ==============
--
--------------------------------------------------------------------------------

begin

  p_ShiftSeq : process (UARTCLK, nUARTRST)
  begin
    if (nUARTRST = '0') then
      RXShiftReg      <= (others => '0');
      iParityError    <= '0';
      iDtPrZero       <= '0'; 
      DelParityError  <= '0';
      DelUARTPEICSync <= '0';
      iUARTPERIS      <= '0';
    elsif (UARTCLK'event and UARTCLK = '1') then
      RXShiftReg      <= NextRXShiftReg;
      iParityError    <= NextParityError;
      iDtPrZero       <= NextDtPrZero; 
      DelParityError  <= iParityError;
      DelUARTPEICSync <= UARTPEICSync;
      iUARTPERIS      <= NextUARTPERIS;
    end if;
  end process p_ShiftSeq;

--------------------------------------------------------------------------------
-- Error Checking
-- If 'SampleParity' is asserted then the RXD bit is sampled to
-- get the parity bit and the parity error value is calculated. 
--------------------------------------------------------------------------------
  p_ErrCheck : process (EPS, RXDsampled, RXShiftReg, SampleParity,
                        iParityError, ClearShiftReg, SPS)
  begin
    if (ClearShiftReg = '1') then
      NextParityError  <= '0';
    elsif (SampleParity = '1') then
--------------------------------------------------------------------------------
-- If Stick parity is selected then Xor the actual parity bit with
-- the inverse of the Even Parity Select bit, otherwise Xor the expected parity
-- bit with the actual parity bit received to calculate the parity error
--------------------------------------------------------------------------------
      if (SPS = '1') then
        NextParityError <= RXDsampled xor (not(EPS));
      else    
        NextParityError <=  RXDsampled xor (not(EPS)) xor RXShiftReg(7)
                            xor RXShiftReg(6) xor RXShiftReg(5) xor RXShiftReg(4)
                            xor RXShiftReg(3) xor RXShiftReg(2) xor RXShiftReg(1)
                            xor RXShiftReg(0);
      end if;
    else
      NextParityError <= iParityError;
    end if;
  end process p_ErrCheck;
  
--------------------------------------------------------------------------------
-- Shift register
--------------------------------------------------------------------------------
  p_ShiftComb : process (WLEN, ShiftEn, RXDsampled, RXShiftReg, ClearShiftReg)
  begin
    if (ClearShiftReg = '1') then
      NextRXShiftReg   <= (others => '0');
    elsif (ShiftEn = '1') then
      NextRXShiftReg   <= (others => '0');
      case WLEN is
        when "00" =>
-- 5 bit data 
          NextRXShiftReg <= "000" & RXDsampled & RXShiftReg(4 downto 1);
        when "01" =>
-- 6 bit data
          NextRXShiftReg <= "00" & RXDsampled & RXShiftReg(5 downto 1);        
        when "10" =>
-- 7 bit data
          NextRXShiftReg <= "0" & RXDsampled & RXShiftReg(6 downto 1);        
        when "11" =>
-- 8 bit data
          NextRXShiftReg <= RXDsampled & RXShiftReg(7 downto 1);        
        when others =>
          null;
      end case;
    else
      NextRXShiftReg <= RXShiftReg;    
    end if;
  end process p_ShiftComb;

--------------------------------------------------------------------------------
-- 'Break' is said to have been detected when all bits in a frame - start bit,
-- data bits, parity bit and stop bits - are zeros.
-- This section checks for the Data bits and the parity bit all being zeros.
-- This condition is used in detecting the break condition which is done in
-- the UartTXCntl block.
--------------------------------------------------------------------------------
  DataZero <= '1' when (RXShiftReg = "00000000") 
              else
              '0';

  p_DtPrZero : process(ClearShiftReg, RXDsampled, PEN, DataZero, SampleParity, 
                       iDtPrZero)
  begin
    if(ClearShiftReg = '1') then
      NextDtPrZero <= '0';
    elsif(PEN = '1') then
      if(SampleParity = '1') and (RXDsampled = '0') then
        NextDtPrZero  <= DataZero;
      else
        NextDtPrZero  <= iDtPrZero;
      end if;
    else
      NextDtPrZero    <= DataZero;
    end if;
  end process p_DtPrZero;

  -------------------------------------------------------------------
  -- Detect rising edge in Parity Error
  -------------------------------------------------------------------

  ParityEdge <= iParityError and not(DelParityError);

  -------------------------------------------------------------------
  -- UARTPEIClr is a one PCLK-wide pulse used to clear the UARTPEINTR. 
  -------------------------------------------------------------------
  UARTPEIClr <= UARTPEICSync and not(DelUARTPEICSync);
  

  -------------------------------------------------------------------
  -- Generate a parity  error interrupt when there is a rising edge
  -- on the framing error line. Clear the error when there is a write
  -- to bit 7 of the Interrupt clear register.
  -------------------------------------------------------------------

  p_UARTPEINTR : process (iUARTPERIS, ParityEdge, UARTPEIClr)
  begin
    NextUARTPERIS <= iUARTPERIS;
    if(ParityEdge = '1') then
      NextUARTPERIS <= '1';
    elsif (UARTPEIClr = '1') then
      NextUARTPERIS <= '0';
    end if;
  end process p_UARTPEINTR;  

  UARTPEMIS <= iUARTPERIS and PEIMSync;
  

--------------------------------------------------------------------------------
-- Assign internal signals to Port
--------------------------------------------------------------------------------
  RecdDATA    <= RXShiftReg;  

  ParityError <= iParityError;

  DtPrZero    <= iDtPrZero;
  
  UARTPERIS   <= iUARTPERIS;


end synth;

--========================== End of UartRXParShft ============================--


















