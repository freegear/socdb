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
-- File Name              : SsmcTrProtChkr.vhd.rca
-- File Revision          : 1.8
--
-- Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This module does the protocol checks on the SSMC.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------
entity SsmcTrProtChkr is
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB Bus Clock
        HRESETn          : in    std_logic; -- Bus Reset
        SMDATAOUT        : in    std_logic_vector(31 downto 0);
                                            -- Memory Data Out from the SSMC
                                            -- for checking 'X'es on it
        SMADDR           : in    std_logic_vector(25 downto 0);
                                            -- Memory Address from the SSMC for
                                            -- checking 'X'es on it
        nSSMCS           : in    std_logic_vector(7 downto 0);
                                            -- Active low Memory Bank Select
        SSMCS            : in    std_logic_vector(7 downto 0);
                                            -- Memory Bank Select signals from
                                            -- the SMC
        nSMDATAEN        : in    std_logic_vector(3 downto 0);
                                            -- Data Bus enable signal
        nSMWEN           : in    std_logic; -- Memory Write enable
        nSMBLS           : in    std_logic_vector(3 downto 0);
                                            -- Data Bus Lane Enable signal
        nSMOEN           : in    std_logic; -- Memory read enable
        SMBUSREQEBI      : in    std_logic; -- SSMC request
        SMBUSBACKOFFEBI  : in    std_logic  -- Backoff signal for SSMC
       );
end SsmcTrProtChkr;

-- -----------------------------------------------------------------------------
--
--                               SsmcTrProtChkr
--                               ==============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- SSMC Tricbox is an AHB slave. This block performs the following operations:
--   - Captures non-AMBA, non-memory related signals from the SSMC.
--   - Does the protocol checks on the SSMC.
--
-- -----------------------------------------------------------------------------
-- --============================ ARCHITECTURE ===============================--

architecture behavioural of SsmcTrProtChkr is

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

signal DelnSSMCS        : std_logic_vector(7 downto 0);
-- Delayed version of the nSSMCS

signal DelSSMCS         : std_logic_vector(7 downto 0);
-- Delayed version of the SSMCS

signal DelnSMWEN        : std_logic;
-- Delayed version of the nSMWEN

signal DelnSMOEN        : std_logic;
-- Delayed version of the SMOEN

signal DelnSMBLSWR      : std_logic;
-- Delayed version of nSMBLS

signal nSMBLSWR         : std_logic;
-- Memory write enable when byte lane is using as write enable

signal BackOffCount     : unsigned(11 downto 0) := "000000000000";
-- Counter for Core Request line Protocol checking 

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
DelnSSMCS        <= nSSMCS  after 3 ns;
DelSSMCS         <= SSMCS  after 3 ns;     
nSMBLSWR         <= nSMBLS(0) and nSMBLS(1) and nSMBLS(2) and nSMBLS(3);
DelnSMWEN        <= nSMWEN after 2 ns;
DelnSMOEN        <= nSMOEN after 2 ns;
DelnSMBLSWR      <= nSMBLSWR after 2 ns;


-- -----------------------------------------------------------------------------
-- Check for multiple Chip Select assertion(active low)
-- -----------------------------------------------------------------------------
p_MChipSelAlowComb : process (DelnSSMCS)
begin
  if (ResetOver) then
    if (DelnSSMCS = nSSMCS) then
      for i in 7 downto 1 loop
        if (nSSMCS(i) = '0') then
          for j in i-1 downto 0 loop
            if (nSSMCS(j) = '0') then
              assert false
                report "SSMCTB1: Multiple Chip Selects are asserted" &
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
end process p_MChipSelAlowComb;
-- -----------------------------------------------------------------------------
-- Check for multiple Chip Select assertion(active high)
-- -----------------------------------------------------------------------------
p_MChipSelAhiComb : process (DelSSMCS)
begin
  if (ResetOver) then
    if (DelSSMCS = SSMCS) then
      for i in 7 downto 1 loop
        if (SSMCS(i) = '1') then
          for j in i-1 downto 0 loop
            if (SSMCS(j) = '1') then
              assert false
                report "SSMCTB2: Multiple Chip Selects are asserted" &
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
end process p_MChipSelAhiComb;


-- -----------------------------------------------------------------------------
-- Check for assertion of OE or WE when Chip Select is deasserted
-- -----------------------------------------------------------------------------
-- p_OeWeChkComb : process (DelnSSMCS,DelSSMCS,nSSMCS,SSMCS,nSMOEN, nSMWEN,
-- nSMBLSWR)
--begin
--  if (ResetOver) then
--    if ((DelSSMCS = SSMCS)and(DelnSSMCS = nSSMCS)) then
--      if (nSSMCS = "11111111" and DelnSSMCS = "11111111"and SSMCS = "00000000"
--            and  DelSSMCS = "00000000") then
--        if (DelnSMOEN = '0' or DelnSMWEN = '0' or DelnSMBLSWR = '0') then
--              assert false
--                report "SSMCTB3: OEN/WEN is asserted" &
--                       " when Chip Select is deasserted"
--                severity warning;
 --       end if;
--      end if;
--    end if;
--  end if;
--end process p_OeWeChkComb;



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
-- Protocol Check for Core request line, that it should not remain high for 
-- more than 500 Clk cycles after backoff signal gets asserted.
-- -----------------------------------------------------------------------------
p_ReqCheckComb : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    BackOffCount <= "000000000000";
  elsif (HCLK'event and HCLK = '1') then
    if ((SMBUSREQEBI = '1') and (SMBUSBACKOFFEBI = '1')) then
      BackOffCount <= BackOffCount + 1;
      if (BackOffCount = 500) then
        assert false
          report "SSMCTB11: SMBUSREQEBI is asserted for more than 500 cycles" &
                 "after SMBUSBACKOFFEBI got asserted"
        severity warning;    
      end if;   
    else
      BackOffCount <= "000000000000";
    end if;
  end if; 
end process p_ReqCheckComb;
  
-- -----------------------------------------------------------------------------
-- 'X' check on SMC related signal.
-- -----------------------------------------------------------------------------
p_XCheckComb : process (ResetOver, SMDATAOUT, SMADDR, SSMCS,nSSMCS, nSMDATAEN,                          nSMWEN, nSMBLS, nSMOEN)
begin
  if (ResetOver) then
    if (SMDATAOUT'event) then
      if (Is_X(SMDATAOUT)) then
        assert false
          report "SSMCTB4: X(es) found in SMDATAOUT"
          severity warning;
      end if;
    end if;

    if (SMADDR'event) then
      if (Is_X(SMADDR)) then
        assert false
          report "SSMCTB5: X(es) found in SMADDR"
          severity warning;
      end if;
    end if;

    if (SSMCS'event) then
    end if;
      if (Is_X(SSMCS)) then
        assert false
          report "SSMCTB6a: X(es) found in SSMCS"
          severity warning;
      end if;
    if (nSSMCS'event) then
    end if;
     if (Is_X(nSSMCS)) then
       assert false
         report "SSMCTB6b: X(es) found in nSSMCS"
         severity warning;
     end if;


    if (nSMDATAEN'event) then
      if (Is_X(nSMDATAEN)) then
        assert false
          report "SSMCTB7: X(es) found in nSMDATAEN"
          severity warning;
      end if;
    end if;

    if (nSMWEN'event) then
    end if;
      if (Is_X(nSMWEN)) then
        assert false
          report "SSMCTB8: X found in nSMWEN"
          severity warning;
      end if;

    if (nSMBLS'event) then
    end if;
      if (Is_X(nSMBLS)) then
        assert false
          report "SSMCTB9: X(es) found in nSMBLS"
          severity warning;
      end if;

    if (nSMOEN'event) then
    end if;
      if (Is_X(nSMOEN)) then
        assert false
          report "SSMCTB10: X found in nSMOEN"
          severity warning;
      end if;
  end if;
end process p_XCheckComb;

end behavioural;

-- --================================== End ==================================--
