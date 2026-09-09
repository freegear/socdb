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
-- File Name              : VicTrIntReq.vhd.rca
-- File Revision          : 1.6
--
-- Release Information    : PrimeCell(TM)-PL190-REL1v1
--
-- ---------------------------------------------------------------------
-- Purpose :
--           This module generates the FIQStatus and IRQStatus.
--
-- --=================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- ---------------------------------------------------------------------

entity VicTrIntReq is
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB Clock
        HRESETn          : in    std_logic; -- AHB Reset
        VICTrIntSource   : in    std_logic_vector(31 downto 0);
                                            -- IntSource for the
                                            -- Mirrored VIC model
        VICTrSoftInt     : in    std_logic_vector(31 downto 0);
                                            -- SoftInt for the
                                            -- Mirrored VIC model
        VICTrIntEnable   : in    std_logic_vector(31 downto 0);
                                            -- IntEnable for the
                                            -- Mirrored VIC
        VICTrIntSelect   : in    std_logic_vector(31 downto 0);
                                            -- IntSelect for the
                                            -- Mirrored VIC model
-- Outputs
        VICTrFIQStatus   : out   std_logic_vector(31 downto 0);
                                            -- FIQStatus output signal
                                            -- to the VicTrVectBank
                                            -- sub-block
        VICTrIRQStatus   : out   std_logic_vector(31 downto 0);
                                            -- IRQStatus output signal
                                            -- to the VicTrVectBank
                                            -- sub-block
        VICTrIRQStatSync : out   std_logic_vector(31 downto 0)
                                            -- Double synchronised IRQ
                                            -- Status
       );
end VicTrIntReq;

-- ---------------------------------------------------------------------
--
--                             VicTrIntReq
--                             ===========
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--    This block recieves Interrupt requests and Software Interrupts
-- from the AHB Interface/Register sub-block (VicTrAhbif) and combines
-- them to generate the Raw Status. The Raw Status is then qualified
-- with the IntEnable and IntSelect vectors to create the FIQ and
-- IRQ Status signals.
--
-- ---------------------------------------------------------------------

-- --========================= ARCHITECTURE ==========================--

architecture behavioural of VicTrIntReq is

-- ---------------------------------------------------------------------
-- Component declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------
signal TrRawInterrupt   : std_logic_vector(31 downto 0);
-- Status of Interrupt requests before masking

signal EnInterrupt      : std_logic_vector(31 downto 0);
-- Status of Interrupt requests after masking

signal iVICFIQStatus    : std_logic_vector(31 downto 0);
-- Internal copy of FIQStatus

signal iVICIRQStatus    : std_logic_vector(31 downto 0);
-- Internal copy of IRQStatus

signal VICIRQStatSync1  : std_logic_vector(31 downto 0);
-- Synchronised version of IRQStatus

--signal VICIRQStatSync  : std_logic_vector(31 downto 0);
-- Double Synchronised version of IRQStatus

-- ---------------------------------------------------------------------
-- Function declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Type declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------

begin

-- ---------------------------------------------------------------------
-- FIQ and IRQ status generation
-- ---------------------------------------------------------------------
TrRawInterrupt   <= VICTrIntSource or VICTrSoftInt;
EnInterrupt      <= TrRawInterrupt and VICTrIntEnable;
iVICFIQStatus    <= EnInterrupt and VICTrIntSelect;
iVICIRQStatus    <= EnInterrupt and not(VICTrIntSelect);

-- ---------------------------------------------------------------------
-- Synchronise IRQStatus
-- ---------------------------------------------------------------------
p_SyncSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    VICIRQStatSync1  <= (others => '0');
    VICTrIRQStatSync <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    VICIRQStatSync1  <= iVICIRQStatus;
    VICTrIRQStatSync <= VICIRQStatSync1;
  end if;
end process p_SyncSeq;

-- ---------------------------------------------------------------------
-- Assign local copies of signals to the outputs
-- ---------------------------------------------------------------------
VICTrFIQStatus   <= iVICFIQStatus;
VICTrIRQStatus   <= iVICIRQStatus;

end behavioural;

-- --============================== End ==============================--
