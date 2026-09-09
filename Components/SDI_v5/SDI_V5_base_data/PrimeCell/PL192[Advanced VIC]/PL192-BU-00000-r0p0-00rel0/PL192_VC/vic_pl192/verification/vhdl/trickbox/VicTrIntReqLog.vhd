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
-- File Name              : VicTrIntReqLog.vhd.rca
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This module generates the FIQStatus and IRQStatus.
--
-- --=========================================================================--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity VicTrIntReqLog is
  port (
-- Inputs
        HCLK             : in std_logic;  -- AHB Clock
        HRESETn          : in std_logic;  -- AHB Reset
        VicTrIntSource   : in std_logic_vector(31 downto 0); 
                                          -- IntSource 
        VicTrSoftInt     : in std_logic_vector(31 downto 0); 
                                          -- SoftInt 
        VicTrIntEn       : in std_logic_vector(31 downto 0); 
                                          -- IntEnable 
        VicTrIntSelect   : in std_logic_vector(31 downto 0); 
                                          -- IntSelect 
        nVicTrIrqIn      : in std_logic;  -- Daisy Chain Input
 
-- Outputs
        VicTrFiqStatus   : out std_logic_vector(31 downto 0);   
                                          -- FIQStatus output signal 
        VicTrIrqStatus   : out std_logic_vector(31 downto 0);  
                                          -- IRQStatus output signal 
        TrIrqStatus      : out std_logic_vector(31 downto 0);  
                                          -- IRQStatus output 
        TrnIrq           : out std_logic; -- IRQ Interrupt 
        TrFiqStatus      : out std_logic_vector(31 downto 0); 
                                         --  IRQStatus output 
        VicTrRawIntr     : out std_logic_vector(31 downto 0)
                                         -- Raw Interrupts
       );   
end VicTrIntReqLog;

-- -----------------------------------------------------------------------------
--
--                             VicTrIntReqLog
--                             ==============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--    This block receives Interrupt requests and Software Interrupts
-- from the AHB Interface/Register sub-block (VicTrAhbif) and combines
-- them to generate the Raw Status. The Raw Status is then qualified
-- with the IntEnable and IntSelect vectors to create the FIQ and
-- IRQ Status signals.
--
-- -----------------------------------------------------------------------------

-- --============================= ARCHITECTURE ==============================--

architecture behavioural of VicTrIntReqLog is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal EnInterrupt     :  std_logic_vector(31 downto 0);   
-- Status of Interrupt requests after masking

signal iVicTrFiqStatus :  std_logic_vector(31 downto 0);   
-- FIQStatus output

signal iVicTrIrqStatus :  std_logic_vector(31 downto 0);   
-- IRQStatus output

signal iVicTrRawIntr   :  std_logic_vector(31 downto 0);   
-- Raw Interrupts

signal iTrIrqStatus    :  std_logic_vector(31 downto 0);   
-- IRQStatus output

signal iTrFiqStatus    :  std_logic_vector(31 downto 0);   
-- FIQStatus output

signal iTrnIrq         :  std_logic;   
-- IRQ Interrupt

signal RTrIrqStatus    :  std_logic;   
-- Internal signal or reduce IrqStatus

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
-- Local copy assignments 
-- -----------------------------------------------------------------------------
VicTrFiqStatus <= iVicTrFiqStatus;
VicTrIrqStatus <= iVicTrIrqStatus;
VicTrRawIntr   <= iVicTrRawIntr;
TrIrqStatus    <= iTrIrqStatus;
TrFiqStatus    <= iTrFiqStatus;
TrnIrq         <= iTrnIrq;
   
-- -----------------------------------------------------------------------------
-- FIQ and IRQ status generation
-- -----------------------------------------------------------------------------
iVicTrRawIntr   <= "00000000000000000000000000000000" when (HRESETn = '0') 
                 else 
                   (VicTrIntSource or VicTrSoftInt);

EnInterrupt     <= "00000000000000000000000000000000" when (HRESETn = '0') 
                 else 
                   (iVicTrRawIntr and VicTrIntEn);

iVicTrFiqStatus <= "00000000000000000000000000000000" when (HRESETn = '0') 
                 else 
                   (EnInterrupt and VicTrIntSelect);

iTrFiqStatus    <= "00000000000000000000000000000000" when (HRESETn = '0') 
                 else 
                   (EnInterrupt and VicTrIntSelect);

iVicTrIrqStatus <= "00000000000000000000000000000000" when (HRESETn = '0') 
                 else 
                   (EnInterrupt and not (VicTrIntSelect));

iTrIrqStatus    <= "00000000000000000000000000000000" when (HRESETn = '0') 
                 else 
                   (EnInterrupt and not (VicTrIntSelect));

RTrIrqStatus    <= iTrIrqStatus(31) or iTrIrqStatus(30) or iTrIrqStatus(29) or
                   iTrIrqStatus(28) or iTrIrqStatus(27) or iTrIrqStatus(26) or
                   iTrIrqStatus(25) or iTrIrqStatus(24) or iTrIrqStatus(23) or
                   iTrIrqStatus(22) or iTrIrqStatus(21) or iTrIrqStatus(20) or
                   iTrIrqStatus(19) or iTrIrqStatus(18) or iTrIrqStatus(17) or
                   iTrIrqStatus(16) or iTrIrqStatus(15) or iTrIrqStatus(14) or
                   iTrIrqStatus(13) or iTrIrqStatus(12) or iTrIrqStatus(11) or
                   iTrIrqStatus(10) or iTrIrqStatus(9)  or iTrIrqStatus(8)  or
                   iTrIrqStatus(7)  or iTrIrqStatus(6)  or iTrIrqStatus(5)  or
                   iTrIrqStatus(4)  or iTrIrqStatus(3)  or iTrIrqStatus(2)  or
                   iTrIrqStatus(1)  or iTrIrqStatus(0);

iTrnIrq         <= '0' when (HRESETn = '0') 
                 else 
                   RTrIrqStatus or not nVicTrIrqIn;

end behavioural;

-- --================================== End ==================================--
