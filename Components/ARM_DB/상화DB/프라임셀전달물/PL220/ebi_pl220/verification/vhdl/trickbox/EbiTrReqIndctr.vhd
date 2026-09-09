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
-- File Name              : EbiTrReqIndctr.vhd.rca
-- File Revision          : 1.2
--
-- Release Information    : PrimeCell(TM)-PL220-r0p0-00ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Gives details of the assertion of the signals EBIREQ1, EBIREQ2
--           and EBIREQ3
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity EbiTrReqIndctr is
  port (
-- Inputs
        EBICLK           : in    std_logic; -- Bus Clock
        nPOR             : in    std_logic; -- Power on Reset
        ClkFlag          : in    std_logic; -- Clk by Clk status indicator
        EventFlag        : in    std_logic; -- Event status indicator
        EBIREQ1          : in    std_logic; -- Ebi Request from Port1
        EBIREQ2          : in    std_logic; -- Ebi Request from Port2
        EBIREQ3          : in    std_logic  -- Ebi Request from Port3
       );
end EbiTrReqIndctr;

-- -----------------------------------------------------------------------------
--
--                               EbiTrReqIndctr
--                               ==============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- This block gives details of the assertion of the signals EBIREQ1, EBIREQ2
-- and EBIREQ3 with respect to EBICLK and Request event. It helps to identify
-- the required test condition hit or not
-- 
-- -----------------------------------------------------------------------------

-- --============================= ARCHITECTURE ==============================--

architecture behavioural of EbiTrReqIndctr is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal EBIREQ1Q         : std_logic;
-- Clocked EBIREQ1

signal EBIREQ2Q         : std_logic;
-- Clocked EBIREQ2

signal EBIREQ3Q         : std_logic;
-- Clocked EBIREQ3

-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------

-- synopsys translate_off
-- -----------------------------------------------------------------------------
-- Type declarations
-- -----------------------------------------------------------------------------

-- synopsys translate_on
-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- This block gives details of the assertion of the signals EBIREQ1, EBIREQ2
-- and EBIREQ3 with respect to EBICLK. It helps to identify the required test
-- condition hit or not
-- -----------------------------------------------------------------------------
p_ClkStatus : process (EBICLK,ClkFlag)
begin
  if (ClkFlag = '1') then
    if (EBICLK'event and EBICLK = '1') then
      if (EBIREQ1Q = EBIREQ1) then
        assert FALSE
        report "Clkflag : No change in the value of EBIREQ1 since last clock"
        severity note;
      elsif (EBIREQ1 = '1' and EBIREQ1Q = '0') then
        assert FALSE
        report "Clkflag : EBIREQ1 changed to high from low"
        severity note;
      elsif (EBIREQ1 = '0' and EBIREQ1Q = '1') then
        assert FALSE
        report "Clkflag : EBIREQ1 changed to low from high"
        severity note;
      end if;
      if (EBIREQ2Q = EBIREQ2) then
        assert FALSE
        report "Clkflag : No change in the value of EBIREQ2 since last clock"
        severity note;
      elsif (EBIREQ2 = '1' and EBIREQ2Q = '0') then
        assert FALSE
        report "Clkflag : EBIREQ2 changed to high from low"
        severity note;
      elsif (EBIREQ2 = '0' and EBIREQ2Q = '1') then
        assert FALSE
        report "Clkflag : EBIREQ2 changed to low from high"
        severity note;
      end if;
      if (EBIREQ3Q = EBIREQ3) then
        assert FALSE
        report "Clkflag : No change in the value of EBIREQ3 since last clock"
        severity note;
      elsif (EBIREQ3 = '1' and EBIREQ3Q = '0') then
        assert FALSE
        report "Clkflag : EBIREQ3 changed to high from low"
        severity note;
      elsif (EBIREQ3 = '0' and EBIREQ3Q = '1') then
        assert FALSE
         report "Clkflag : EBIREQ3 changed to low from high"
       severity note;
      end if;
    end if;
  end if;
end process p_ClkStatus;

-- -----------------------------------------------------------------------------
-- This block gives details of the assertion of the signals EBIREQ1, EBIREQ2
-- and EBIREQ3 with respect to request event. It helps to identify the
-- required test condition hit or not
-- -----------------------------------------------------------------------------
p_EventStatus : process(EventFlag, EBIREQ1, EBIREQ2, EBIREQ3)
begin
  if (EventFlag = '1') then
    if (EBIREQ1'event and EBIREQ1 = '1') then
      assert FALSE
      report "EventFlag : EBIREQ1 changed to high from low"
      severity note;
    elsif (EBIREQ1'event and EBIREQ1 = '0') then
      assert FALSE
      report "EventFlag : EBIREQ1 changed to low from high"
      severity note;
    end if;
    if (EBIREQ2'event and EBIREQ2 = '1') then
      assert FALSE
      report "EventFlag : EBIREQ2 changed to high from low"
      severity note;
    elsif (EBIREQ2'event and EBIREQ2 = '0') then
      assert FALSE
      report "EventFlag : EBIREQ2 changed to low from high"
      severity note;
    end if;
    if (EBIREQ3'event and EBIREQ3 = '1') then
      assert FALSE
      report "EventFlag : EBIREQ3 changed to high from low"
      severity note;
    elsif (EBIREQ3'event and EBIREQ3 = '0') then
      assert FALSE
      report "EventFlag : EBIREQ3 changed to low from high"
      severity note;
    end if;
  end if;
end process p_EventStatus;

-- -----------------------------------------------------------------------------
-- Sequential process for the EBIREQ1Q, EBIREQ2Q and EBIREQ3Q
-- -----------------------------------------------------------------------------
p_EbiReqSeq : process (EBICLK, nPOR)
begin
  if (nPOR = '0') then
    EBIREQ1Q  <= '0';
    EBIREQ2Q  <= '0';
    EBIREQ3Q  <= '0';
  elsif (EBICLK'event and EBICLK = '1') then
     EBIREQ1Q <= EBIREQ1;
     EBIREQ2Q <= EBIREQ2;
     EBIREQ3Q <= EBIREQ3;
  end if;
end process p_EbiReqSeq;

-- synopsys translate_off
-- -----------------------------------------------------------------------------
-- START OF PROTOCOL CHECKERS
-- -----------------------------------------------------------------------------

-- Protocol checkers can be used for debugging purposes.

-- -----------------------------------------------------------------------------
-- END OF PROTOCOL CHECKERS
-- -----------------------------------------------------------------------------
-- synopsys translate_on

end behavioural;

-- --================================== End ==================================--
