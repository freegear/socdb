-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000-2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : DmacTrAhbArb.vhd.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block is responsible for generating HGRANT to AHB Master
--
-- --=========================================================================--
 
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
 
use work.DmacTrPackage.all;
 
-- -----------------------------------------------------------------------------
 
entity DmacTrAhbArb is
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB clock
        HRESETn          : in    std_logic; -- AHB reset
        HREADYINM        : in    std_logic; -- Transfer done response on AHB
        HBUSREQDMAM      : in    std_logic; -- Bus request signal from AHB
        HBURSTM          : in    std_logic_vector(2 downto 0);
                                            -- Burst length on AHB
        HLOCKDMAM        : in    std_logic; -- Requesting locked transfers
        HGRANTDMAM       : out   std_logic  -- AHB bus grant for master
       );
end DmacTrAhbArb;
-- -----------------------------------------------------------------------------
--
--                              DmacTrAhbArb
--                              ============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--   This block is responsible for driving out HGRANT for Master module.
--
-- -----------------------------------------------------------------------------


-- --=========================== ARCHITECTURE ================================--

architecture behavioural of DmacTrAhbArb is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal iHGRANTDMAM      : std_logic;
-- The internal version of the Grant to the master logic

signal NxtHGRANTDMAM    : std_logic;
-- The D input of HGRANTDMAM  register

-----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- Cobinational assignments
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Sequential processes
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Grant Signal Generation
-- -----------------------------------------------------------------------------
p_GrantGenComb : process (HREADYINM, HBUSREQDMAM, iHGRANTDMAM)
begin
  if (HREADYINM = '1') then
    if (HBUSREQDMAM = '1') then
      NxtHGRANTDMAM    <= HBUSREQDMAM;
    else
      NxtHGRANTDMAM    <= '1';
    end if;
  else
    NxtHGRANTDMAM    <= iHGRANTDMAM;
  end if;
end process p_GrantGenComb;

-- -----------------------------------------------------------------------------
-- Grant Signal Generation sequntial block
-- -----------------------------------------------------------------------------
p_GrantGenSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    iHGRANTDMAM      <= '0';
  elsif (HCLK'event and HCLK = '1') then
    iHGRANTDMAM      <= NxtHGRANTDMAM;
  end if;
end process p_GrantGenSeq;

HGRANTDMAM      <= iHGRANTDMAM;

end behavioural;

-- --================================== End ==================================--
