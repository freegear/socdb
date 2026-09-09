-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001-2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : EbiTrProChkr.vhd.rca
-- File Revision          : 1.2
--
-- Release Information    : PrimeCell(TM)-PL220-r0p0-00ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This module does the protocol checks on the EBI.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity EbiTrProChkr is
  port (
-- Inputs
        EBICLK           : in    std_logic; -- Clock Input
        HRESETn          : in    std_logic; -- Reset from AHB
        EBIGNT1          : in    std_logic; -- Grant to Port1
        EBIGNT2          : in    std_logic; -- Grant to Port2
        EBIGNT3          : in    std_logic; -- Grant to Port3
        EBIBACKOFF1      : in    std_logic; -- Backoff signal to Port1
        EBIBACKOFF2      : in    std_logic; -- Backoff signal to Port2
        EBIBACKOFF3      : in    std_logic; -- Backoff signal to Port3
        EBIDATAIN        : in    std_logic_vector(31 downto 0);
                                            -- data in from EBI
        EBIEXTADDROUT    : in    std_logic_vector(31 downto 0);
                                            -- Address from EBI
        EBIEXTDATAOUT    : in    std_logic_vector(31 downto 0);
                                            -- Data from EBI
        nEBIEXTDATAEN    : in    std_logic_vector(3 downto 0)
                                            -- DataEn from EBI
       );
end EbiTrProChkr;

-- -----------------------------------------------------------------------------
--
--                                EbiTrProChkr
--                                ============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--   This module does the following functionality
--    o Checks EBI signals going to 'X's
--    o Checks for multiple assertion of grant and backoff signals
--
-- -----------------------------------------------------------------------------

-- --============================== ARCHITECTURE =============================--

architecture behavioural of EbiTrProChkr is

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

-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
--
-- Main body of Code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- StartCheck signal is set once the Reset is applied
-- -----------------------------------------------------------------------------
p_ResetOverComb : process (EBICLK, HRESETn, ResetAssrtd)
begin
  if ((ResetAssrtd) and HRESETn = '1') then
    ResetOver <= TRUE;
  end if;
  if (EBICLK'event and EBICLK = '1') then
    if (HRESETn = '0') then
      ResetAssrtd <= TRUE;
    end if;
  end if;
end process p_ResetOverComb;

-- -----------------------------------------------------------------------------
-- This combinational logic checks for X-s on EBI output lines. If there is
-- 'X' on the signal lines then warning message will be displayed
-- -----------------------------------------------------------------------------
p_XCheckComb : process (EBIGNT1, EBIGNT2, EBIGNT3, EBIBACKOFF1, EBIBACKOFF2,
                        EBIBACKOFF3, EBIEXTADDROUT, EBIEXTDATAOUT,
                        nEBIEXTDATAEN, EBIDATAIN, ResetOver)
begin
  if (ResetOver) then
    if (Is_X(EBIGNT1)) then
      assert false
      report "EBITR1: X(es) found in EBIGNT1"
      severity warning;
    end if;

    if (Is_X(EBIGNT2)) then
      assert false
      report "EBITR2: X(es) found in EBIGNT2"
      severity warning;
    end if;

    if (Is_X(EBIGNT3)) then
      assert false
      report "EBITR3: X(es) found in EBIGNT3"
      severity warning;
    end if;

    if (Is_X(EBIBACKOFF1)) then
      assert false
      report "EBITR4: X(es) found in EBIBACKOFF1"
      severity warning;
    end if;

    if (Is_X(EBIBACKOFF2)) then
      assert false
      report "EBITR5: X(es) found in EBIBACKOFF2"
      severity warning;
    end if;

    if (Is_X(EBIBACKOFF3)) then
      assert false
      report "EBITR6: X found in EBIBACKOFF3"
      severity warning;
    end if;

    if (Is_X(EBIEXTADDROUT)) then
      assert false
      report "EBITR7: X(es) found in EBIEXTADDROUT"
      severity warning;
    end if;

    if (Is_X(EBIEXTDATAOUT)) then
      assert false
      report "EBITR8: X found in EBIEXTDATAOUT"
      severity warning;
    end if;

    if (Is_X(nEBIEXTDATAEN)) then
      assert false
      report "EBITR9: X found in nEBIEXTDATAEN"
      severity warning;
    end if;

    if (Is_X(EBIDATAIN)) then
      assert false
      report "EBITR10: X(es) found in EBIDATAIN"
      severity warning;
    end if;
  end if;
end process p_XCheckComb;

-- -----------------------------------------------------------------------------
-- This combination logic checks for multiple assertion of grant and backoff
-- signal. If there is any violation of protocol then Error message will be
-- displayed.
-- -----------------------------------------------------------------------------
p_MuitiAssertComb : process (EBICLK)
begin
  if (EBICLK'event and EBICLK = '1') then
    if ((EBIGNT1 = '1' and (EBIGNT2 = '1' or EBIGNT3 = '1')) or
        (EBIGNT2 = '1' and (EBIGNT1 = '1' or EBIGNT3 = '1')) or
        (EBIGNT3 = '1' and (EBIGNT1 = '1' or EBIGNT2 = '1'))) then
      assert false
        report "EBITR11 : Multiple assertion of EBIGNT signal"
      severity error;
    end if;
    if ((EBIBACKOFF1 = '1' and (EBIBACKOFF2 = '1' or EBIBACKOFF3 = '1')) or
        (EBIBACKOFF2 = '1' and (EBIBACKOFF1 = '1' or EBIBACKOFF3 = '1')) or
        (EBIBACKOFF3 = '1' and (EBIBACKOFF1 = '1' or EBIBACKOFF2 = '1'))) then
      assert false
        report "EBITR12 : Multiple assertion of EBIBACKOFF signal"
      severity error;
    end if;
  end if;
end process p_MuitiAssertComb;

end behavioural;

-- --================================== End ==================================--
