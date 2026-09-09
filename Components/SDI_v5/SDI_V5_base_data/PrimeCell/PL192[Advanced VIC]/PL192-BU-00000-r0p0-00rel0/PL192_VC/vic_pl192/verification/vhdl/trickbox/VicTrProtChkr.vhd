-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : VicTrProtChkr.vhd.rca
-- File Revision          : 1.5
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This module compares the actual interrupt outputs from
--           the VIC with the expected outputs.
--
-- --=========================================================================--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity VicTrProtChkr is
  port (
-- Inputs
        HCLK             : in std_logic; -- AHB Clock
        HRESETn          : in std_logic; -- AHB Reset
        VICTrTCR         : in std_logic_vector(8 downto 0);
                                         -- Compare-Enable signals
        nVICFIQ          : in std_logic; -- nVICFIQ output from the VIC
        nFIQ             : in std_logic; -- Expected nFIQ from the 
                                         -- VICTrMirTrickbox
        nVICIRQ          : in std_logic; -- nVICIRQ output from the VIC
        nIRQ             : in std_logic; -- Expected nIRQ from the 
                                         -- VICTrMirTrickbox
        VICVECTADDRV     : in std_logic; -- VIC Address valid Signal 
                                         -- which indicates
                                         -- Address valid from VIC
        VICTrVectAddrv   : in std_logic; -- VIC Address valid Signal 
                                         -- which indicates
                                         -- Address valid from VICTrMirTrickbox
        VICIRQACKOUT     : in std_logic; --  VIC Acknowledge signal
        VicTrIrqAckOut   : in std_logic; --  VICTrMirTrickbox Acknowledge signal
        VICVECTADDROUT   : in std_logic_vector(31 downto 0);
                                         --  VICVECTADDROUT output from the VIC
        VICTrVectAddrOut : in std_logic_vector(31 downto 0)
                                         -- Expected TrVectAddrOut output from
                                         -- VICTrMirTrickbox     
       );   
end VicTrProtChkr;

-- -----------------------------------------------------------------------------
--
--                            VicTrProtChkr
--                            =============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--   This module compares the interrupt and interrupt vector outputs
-- from the VIC with the corresponding internally generated signals.
-- Error messages are flagged when there is a mismatch.
--
-- -----------------------------------------------------------------------------

-- --============================= ARCHITECTURE ==============================--

architecture behavioural of VicTrProtChkr is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal FIQCompEn        :  std_logic;   
-- FIQ compare Enable signal

signal IRQCompEn        :  std_logic;   
-- IRQ compare Enable signal

signal VectAdCompEn     :  std_logic;   
-- VectAddrOut compare Enable signal

signal VectAdvCompEn    :  std_logic;   
-- VectAddr Valid compare Enable signal

signal VectAckCompEn    :  std_logic;   
-- VectAck compare Enable signal

signal FIQError         :  std_logic;   
-- FIQ Error Message generator Enable signal

signal IRQError         :  std_logic;   
-- IRQ Error Message generator Enable signal

signal VectAddrError    :  std_logic;   
-- VectAddrOut Error Message generator Enable signal

signal VectAdVldError   :  std_logic;   
-- VectAddrOut Error Message generator Enable signal

signal VectAckError     :  std_logic;   
-- VectAddrOut Error Message generator Enable signal

-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Type declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin
   
-- -----------------------------------------------------------------------------
-- Enable-signals Assignment
-- -----------------------------------------------------------------------------
FIQCompEn      <= VICTrTCR(0);
IRQCompEn      <= VICTrTCR(1);
VectAdCompEn   <= VICTrTCR(2);
VectAdvCompEn  <= VICTrTCR(3);
VectAckCompEn  <= VICTrTCR(4);
FIQError       <= FIQCompEn when (nFIQ /= nVICFIQ) 
                else 
                  '0';
IRQError       <= IRQCompEn when (nIRQ /= nVICIRQ) 
                else 
                  '0';
VectAddrError  <= VectAdCompEn when (VICTrVectAddrOut /= VICVECTADDROUT) 
                else 
                  '0' ;
VectAdVldError <= VectAdvCompEn when (VICTrVectAddrv /= VICVECTADDRV) 
                else 
                  '0' ;
VectAckError   <= VectAckCompEn when (VicTrIrqAckOut /= VICIRQACKOUT) 
                else 
                  '0' ;

-- -----------------------------------------------------------------------------
-- FIQ Error Message generator
-- -----------------------------------------------------------------------------
p_FIQErrorProt : process (HCLK)
begin
   if (HCLK'event and HCLK = '1') then
      if (FIQError = '1') then
        assert false
        report "VICTB1: Error in received nVICFIQ"
        severity error;
      end if;
   end if;
end process p_FIQErrorProt;
   
-- -----------------------------------------------------------------------------
-- IRQ Error Message generator
-- -----------------------------------------------------------------------------
p_IRQErrorProt : process (HCLK)
begin
   if (HCLK'event and HCLK = '1') then
      if (IRQError = '1') then
        assert false
        report "VICTB2: Error in received nVICIRQ"
        severity error;
      end if;
   end if;
end process p_IRQErrorProt;
   
-- -----------------------------------------------------------------------------
-- VectAddrOut Error Message generator
-- -----------------------------------------------------------------------------
p_VectAdErrorProt : process (HCLK)
begin
   if (HCLK'event and HCLK = '1') then
      if (VectAddrError = '1') then
        assert false
        report "VICTB3: Error in received VICVECTADDROUT"
        severity error;
      end if;
   end if;
end process p_VectAdErrorProt;

-- -----------------------------------------------------------------------------
-- VectAddrValid Error Message generator
-- -----------------------------------------------------------------------------
p_VectAVldErrorProt : process (HCLK)
begin
   if (HCLK'event and HCLK = '1') then
      if (VectAdVldError = '1') then
        assert false
        report "VICTB4: Error in received VICVECTADDRV"
        severity error;
      end if;
   end if;
end process p_VectAVldErrorProt;
   
-- -----------------------------------------------------------------------------
-- VectAddrOut Error Message generator
-- -----------------------------------------------------------------------------
p_VectAckErrorProt : process (HCLK)
begin
   if (HCLK'event and HCLK = '1') then
      if (VectAckError = '1') then
        assert false
        report "VICTB5: Error in received VICIRQACKOUT"
        severity error;
      end if;
   end if;
end process p_VectAckErrorProt;

end behavioural;

-- --================================== End ==================================--
