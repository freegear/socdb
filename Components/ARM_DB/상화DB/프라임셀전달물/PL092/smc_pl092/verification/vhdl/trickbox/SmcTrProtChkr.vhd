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
-- File Name              : SmcTrProtChkr.vhd.rca
-- File Revision          : 1.9
--
-- Release Information    : PrimeCell(TM)-PL092-REL1v1
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This module does the protocol checks on the SMC.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SmcTrProtChkr is
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB Bus Clock
        HRESETn          : in    std_logic; -- Bus Reset
        SMDATAOUT        : in    std_logic_vector(31 downto 0);
                                            -- Memory Data Out from the SMC
                                            -- for checking 'X'es on it
        SMADDR           : in    std_logic_vector(25 downto 0);
                                            -- Memory Address from the SMC for
                                            -- checking 'X'es on it
        SMCActLowCS      : in    std_logic_vector(7 downto 0);
                                            -- Active low Memory Bank Select
        SMCS             : in    std_logic_vector(7 downto 0);
                                            -- Memory Bank Select signals from
                                            -- the SMC
        nSMDATAEN        : in    std_logic_vector(3 downto 0);
                                            -- Data Bus enable signal
        nSMWEN           : in    std_logic; -- Memory Write enable
        nSMBLS           : in    std_logic_vector(3 downto 0);
                                            -- Data Bus Lane Enable signal
        nSMOEN           : in    std_logic  -- Memory read enable
       );
end SmcTrProtChkr;

-- -----------------------------------------------------------------------------
--
--                                SmcTrProtChkr
--                                =============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- SMC Tricbox is an AHB slave. This block performs the following operations:
--   - Captures non-AMBA, non-memory related signals from the SMC.
--   - Does the protocol checks on the SMC.
--
-- -----------------------------------------------------------------------------

-- --============================ ARCHITECTURE ===============================--

architecture behavioural of SmcTrProtChkr is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal ResetAssrtd      : boolean := FALSE;
-- Indicates the start of checks

signal ResetOver        : boolean := FALSE;
-- Indicates the start of checks

signal DelSMCS          : std_logic_vector(7 downto 0);
-- Delayed version of the SMCActLowCS

signal DelSMWEN         : std_logic;
--

signal DelSMOEN         : std_logic;
--

signal DelSMBLSWR       : std_logic;
--
signal nSMBLSWR         : std_logic;
-- Memory write enable when byte lane is using as write enable

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

-- -----------------------------------------------------------------------------
-- Generate Delayed SMCS
-- -----------------------------------------------------------------------------
DelSMCS          <= SMCActLowCS after 3 ns;
nSMBLSWR         <= nSMBLS(0) and nSMBLS(1) and nSMBLS(2) and nSMBLS(3);
DelSMWEN         <= nSMWEN after 2 ns;
DelSMOEN         <= nSMOEN after 2 ns;
DelSMBLSWR       <= nSMBLSWR after 2 ns;


-- -----------------------------------------------------------------------------
-- Check for multiple Chip Select assertion
-- -----------------------------------------------------------------------------
p_MChipSelComb : process (DelSMCS)
begin
  if (ResetOver) then
    if (DelSMCS = SMCActLowCS) then
      for i in 7 downto 1 loop
        if (SMCActLowCS(i) = '0') then
          for j in i-1 downto 0 loop
            if (SMCActLowCS(j) = '0') then
              assert false
                report "SMCTB8: Multiple Chip Selects are asserted" &
                       " simultaneously"
                severity warning;
              exit;
            end if;
          end loop;
          exit;
        end if;
      end loop;
    end if;
  end if;
end process p_MChipSelComb;

-- -----------------------------------------------------------------------------
-- Check for assertion of OE or WE when Chip Select is deasserted
-- -----------------------------------------------------------------------------
p_OeWeChkComb : process (DelSMCS, SMCActLowCS, nSMOEN, nSMWEN, nSMBLSWR)
begin
  if (ResetOver) then
    if (DelSMCS = SMCActLowCS) then
      if (SMCActLowCS = "11111111" and DelSMCS = "11111111") then
        if (DelSMOEN = '0' or DelSMWEN = '0' or DelSMBLSWR = '0') then
              assert false
                report "SMCTB9: OEN/WEN is asserted" &
                       " when Chip Select is deasserted"
                severity warning;
        end if;
      end if;
    end if;
  end if;
end process p_OeWeChkComb;



-- -----------------------------------------------------------------------------
-- StartCheck signal is set once the Reset is applied
-- -----------------------------------------------------------------------------
p_ResetOverComb : process (HCLK, HRESETn, ResetAssrtd)
begin
  if ((ResetAssrtd) and HRESETn = '1') then
    ResetOver <= TRUE;
  end if;
  if (HCLK'event and HCLK = '1') then
    if (HRESETn = '0') then
      ResetAssrtd <= TRUE;
    end if;
  end if;
end process p_ResetOverComb;

-- -----------------------------------------------------------------------------
-- 'X' check on SMC related signal.
-- -----------------------------------------------------------------------------
p_XCheckComb : process (ResetOver, SMDATAOUT, SMADDR, SMCS, nSMDATAEN, nSMWEN,
                        nSMBLS, nSMOEN)
begin
  if (ResetOver) then
    if (SMDATAOUT'event) then
      if (Is_X(SMDATAOUT)) then
        assert false
          report "SMCTB1: X(es) found in SMDATAOUT"
          severity warning;
      end if;
    end if;

    if (SMADDR'event) then
      if (Is_X(SMADDR)) then
        assert false
          report "SMCTB2: X(es) found in SMADDR"
          severity warning;
      end if;
    end if;

    if (SMCS'event) then
    end if;
      if (Is_X(SMCS)) then
        assert false
          report "SMCTB3: X(es) found in SMCS"
          severity warning;
      end if;

    if (nSMDATAEN'event) then
      if (Is_X(nSMDATAEN)) then
        assert false
          report "SMCTB4: X(es) found in nSMDATAEN"
          severity warning;
      end if;
    end if;

    if (nSMWEN'event) then
    end if;
      if (Is_X(nSMWEN)) then
        assert false
          report "SMCTB5: X found in nSMWEN"
          severity warning;
      end if;

    if (nSMBLS'event) then
    end if;
      if (Is_X(nSMBLS)) then
        assert false
          report "SMCTB6: X(es) found in nSMBLS"
          severity warning;
      end if;

    if (nSMOEN'event) then
    end if;
      if (Is_X(nSMOEN)) then
        assert false
          report "SMCTB7: X found in nSMOEN"
          severity warning;
      end if;
  end if;
end process p_XCheckComb;

end behavioural;

-- --================================== End ==================================--
