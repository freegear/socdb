-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2003 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : SsmcTrExtArb.vhd.rca
-- File Revision          : 1.8
--
-- Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This module act as external bus arbitor for TIC and SSMC.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------
entity SsmcTrExtArb is
  port (
-- Inputs
        -- AHB bus signals
        SMMemCLK         : in    std_logic; -- Memeory clock
        HRESETn          : in    std_logic; -- Bus Reset
        SMBUSREQEBI      : in    std_logic; -- SSMC request
        SMTICBUSREQEBI   : in    std_logic; -- TIC request
        SSMCTrExtMux     : in    std_logic_vector(8 downto 0);
                                            -- External Arbitor register
-- Outputs
        SMBUSGNTEBI      : out   std_logic; -- External bus granted to SSMC
        BackOffSsmc      : out   std_logic; -- Backoff signal for SSMC
        SMTICBUSGNTEBI   : out   std_logic  -- External bus granted to TIC
       );
end SsmcTrExtArb;

-- -----------------------------------------------------------------------------
--
--                                SsmcTrExtArb
--                                ============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- SSMC Tricbox is an AHB slave. This block performs the following operations:
--   - Implements the external bus arbitor.
--   - Takes the request from SSMC and TIC, with TIC has highest priority.
--   - Genarates the grant signal for TIC and SSMC saperately.
--   - Generate and simulate for the external controler Request and Grant.
--
-- -----------------------------------------------------------------------------

-- --============================ ARCHITECTURE ===============================--

architecture behavioural of SsmcTrExtArb is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal iSMTICBUSGNTEBI : std_logic;
-- Internal version of SMTICBUSGNTEBI

signal NextSMTICGNTEBI : std_logic;
-- D-Input of SMTICBUSGNTEBI

signal iSMBUSGNTEBI    : std_logic;
-- Internal version of SMBUSGNTEBI

signal NextSMBUSGNTEBI : std_logic;
-- D-Input of SMBUSGNTEBI

signal iBackOffSsmc    : std_logic;
-- Internal version of BackOffSsmc

signal NextBackOffSsmc : std_logic;
-- D-Input of BackOffSsmc


-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

SMTICBUSGNTEBI <= iSMTICBUSGNTEBI;
SMBUSGNTEBI    <= iSMBUSGNTEBI;
BackOffSsmc    <= iBackOffSsmc;

-- -----------------------------------------------------------------------------
-- Arbitration logic
-- -----------------------------------------------------------------------------

p_GntLogicComb : process (iSMTICBUSGNTEBI, iSMBUSGNTEBI, iBackOffSsmc,
                          SSMCTrExtMux, SMTICBUSREQEBI, SMBUSREQEBI)
begin
  NextSMTICGNTEBI <= iSMTICBUSGNTEBI;
  NextSMBUSGNTEBI <= iSMBUSGNTEBI;
  NextBackOffSsmc <= iBackOffSsmc;
  if (SSMCTrExtMux(0) = '1') then
    if (SMTICBUSREQEBI = '1') then
      NextSMTICGNTEBI <= '1';
    elsif (SMBUSREQEBI = '1') then
      NextSMBUSGNTEBI <= '1';
      NextSMTICGNTEBI <= '0';
      if (iSMBUSGNTEBI = '1') then
        NextBackOffSsmc <= '1';
      end if;
    else
      NextSMBUSGNTEBI <= '0';
      NextBackOffSsmc <= '0';
      NextSMTICGNTEBI <= '0';
    end if;
  end if;
end process p_GntLogicComb;

p_GntLogicSeq : process (SMMemClk, HRESETn)
begin
  if (HRESETn = '0') then
    iSMTICBUSGNTEBI <= '1';
    iSMBUSGNTEBI    <= '0';
    iBackOffSsmc    <= '0';
  elsif (SMMemClk'event and SMMemClk = '1') then
    iSMTICBUSGNTEBI <= NextSMTICGNTEBI;
    iSMBUSGNTEBI    <= NextSMBUSGNTEBI;
    iBackOffSsmc    <= NextBackOffSsmc;
  end if;
end process p_GntLogicSeq;

end behavioural;

-- --================================= END ===================================--
