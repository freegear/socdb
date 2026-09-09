-- --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : ICSynctoHCLK.vhd,v
-- File Revision          : 1.6
--
-- Release Information    : ADK_REL1v1
--
-- ---------------------------------------------------------------------
-- Purpose :
--           This module synchronises signals ICRawIntrCo,
-- ICIRQStatusCo, ICFIQStatus to the HCLK domain to remove
-- metastability problems.
--
-- --=================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- ---------------------------------------------------------------------

entity ICSynctoHCLK is
  port (
-- Inputs
        HCLK            : in    std_logic; -- AHB Bus Clock
        HRESETn         : in    std_logic; -- AHB Bus Reset
        ICRawIntrCo     : in    std_logic_vector(31 downto 0);
                                            -- IC Raw Interrupt
        ICIRQStatusCo   : in    std_logic_vector(31 downto 0);
                                            -- IRQ Status
        ICFIQStatusCo   : in    std_logic_vector(31 downto 0);
                                            -- FIQ Status
-- Outputs
        ICRawIntrSync   : out   std_logic_vector(31 downto 0);
                                            -- Synced ICRawIntr
        ICIRQStatusSync : out   std_logic_vector(31 downto 0);
                                            -- Synced ICIRQStatus
        ICFIQStatusSync : out   std_logic_vector(31 downto 0)
                                            -- Synced ICFIQStatus
       );
end ICSynctoHCLK;

-- ---------------------------------------------------------------------
--
--                            ICSynctoHCLK
--                            =============
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--   This block synchronises the asynchronous input signals
-- ICRawIntrCo, ICIRQStatusCo and ICFIQStatusCo to the HCLK domain.
-- Synchronisation is achieved by passing each bit of the input signals
-- through 2 D-types clocked by HCLK.
--
-- ---------------------------------------------------------------------

-- --======================== ARCHITECTURE ===========================--

architecture synth of ICSynctoHCLK is

-- ---------------------------------------------------------------------
-- Component declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------

-- Zero fill for register reads to return zeros in unused bit positions
constant ZEROFILL             : std_logic_vector(31 downto 0)
                              := "00000000000000000000000000000000";

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------
signal ICRawIntrSync1  : std_logic_vector(31 downto 0);
-- 1st stage synchronised verion of the ICRawIntr input

signal ICIRQStatSync1  : std_logic_vector(31 downto 0);
-- 1st stage synchronised verion of the ICIRQStatus input

signal ICFIQStatSync1  : std_logic_vector(31 downto 0);
-- 1st stage synchronised verion of the ICFIQStatus input

-- ---------------------------------------------------------------------
-- Function declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------

begin

-- ---------------------------------------------------------------------
-- Double-synchronisers for ICRawIntr, ICIRQStatus, ICFIQStatus.
-- ---------------------------------------------------------------------

p_SyncHCLKSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    ICRawIntrSync1  <= ZEROFILL;
    ICRawIntrSync   <= ZEROFILL;

    ICIRQStatSync1  <= ZEROFILL;
    ICIRQStatusSync <= ZEROFILL;

    ICFIQStatSync1  <= ZEROFILL;
    ICFIQStatusSync <= ZEROFILL;
  elsif (HCLK'event and HCLK = '1') then
    ICRawIntrSync1  <= ICRawIntrCo;
    ICRawIntrSync   <= ICRawIntrSync1;

    ICIRQStatSync1  <= ICIRQStatusCo;
    ICIRQStatusSync <= ICIRQStatSync1;

    ICFIQStatSync1  <= ICFIQStatusCo;
    ICFIQStatusSync <= ICFIQStatSync1;
  end if;
end process p_SyncHCLKSeq;

end synth;

-- --============================== End ==============================--
