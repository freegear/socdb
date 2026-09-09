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
-- File Name              : SsmcDerivedClk.vhd.rca
-- File Revision          : 1.9
--
-- Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           In this Block SlowClkM is derived from HCLK and SMMEMCLK
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SsmcDerivedClk is
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB Bus Clock
        SMMEMCLK         : in    std_logic; -- Memory Clock
        HRESETn          : in    std_logic; -- AHB system level Reset
        ClockRatio       : in    std_logic_vector(1 downto 0);
                                            -- Clock Ratio indication
        MemClkRegTogl    : in    std_logic; -- Toggle signal indicating that
                                            -- write happened to Clock Register
-- Outputs
        SlowClkM         : out   std_logic  -- Slow clock indicator to HCLK side
       );
end SsmcDerivedClk;

-- -----------------------------------------------------------------------------
--
--                               SsmcDerivedClk
--                               ==============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--           Generation of SlowClkM is the main function of this Block.
--
-- -----------------------------------------------------------------------------

-- --============================= ARCHITECTURE ==============================--

architecture synth of SsmcDerivedClk is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal FrstEdgeAfterRes : std_logic;
-- Signal used for synchronizing with the Memory Clock

signal SMMEMCLKDiv2     : std_logic;
-- Divide by 2 clock signal

signal NextSMMEMCLKDiv2 : std_logic;
-- D_Input of SMMEMCLKDiv2

signal SMMEMCLKDiv3     : std_logic;
-- Divide by 3 clock signal

signal NextSMMEMCLKDiv3 : std_logic;
-- D_Input of SMMEMCLKDiv3

signal Count3           : std_logic_vector(1 downto 0);
-- Counter to control the Duty Cycle for Divide by 3 clock

signal NextCount3       : std_logic_vector(1 downto 0);
-- D_Input of Count3

signal NextFirstEdge    : std_logic;
-- Signal used for synchronizing with the Memory Clock

signal ToggleReg        : std_logic;
-- Signal used for synchronizing with the Memory Clock


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
-- Internal Signal Assignments
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
--                              Assignments
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- The signal FrstEdgeAfterRes goes high on the fist SMMEMCLK edge after
-- application of HRESETn, or after the Register is getting Programmed.
-- -----------------------------------------------------------------------------
p_FstEdgeGenComb : process (FrstEdgeAfterRes, ToggleReg, MemClkRegTogl)
begin
  NextFirstEdge <= FrstEdgeAfterRes;
  if ((ToggleReg xor MemClkRegTogl) = '1') then
    NextFirstEdge <= '0';
  else
    NextFirstEdge <= '1';
  end if;
end process p_FstEdgeGenComb;

-- -----------------------------------------------------------------------------
-- Registering all Next state signals
-- -----------------------------------------------------------------------------
p_FstEdgeGenSeq : process (HRESETn, SMMEMCLK)
begin
  if (HRESETn = '0') then
    FrstEdgeAfterRes <= '0';
    ToggleReg        <= '0';
  elsif (SMMEMCLK'event and SMMEMCLK = '1') then
    FrstEdgeAfterRes <= NextFirstEdge;
    ToggleReg        <= MemClkRegTogl;
  end if;
end process p_FstEdgeGenSeq;

-- -----------------------------------------------------------------------------
-- Combinational logic for generating SMMEMCLKDiv2.
-- -----------------------------------------------------------------------------
p_MemClkDv3Comb : process (FrstEdgeAfterRes, SMMEMCLKDiv2, Count3,
                              SMMEMCLKDiv3)
begin
  if (FrstEdgeAfterRes = '1') then
    NextSMMEMCLKDiv2 <= not(SMMEMCLKDiv2);
    if (Count3 < "10") then
      NextCount3 <= unsigned(Count3) + '1';
    else
      NextCount3 <= "00";
    end if;
    if ((Count3 = "01") and (SMMEMCLKDiv3 ='0')) then
      NextSMMEMCLKDiv3 <= '1';
    else
      NextSMMEMCLKDiv3 <= '0';
    end if;
  else
    NextSMMEMCLKDiv3 <= '0';
    NextSMMEMCLKDiv2 <= '0';
    NextCount3 <= "00";
  end if;

end process p_MemClkDv3Comb;
-- -----------------------------------------------------------------------------
-- Sequential logic for generating SMMEMCLKDiv2
-- -----------------------------------------------------------------------------
p_MemClkDv2Seq : process (HRESETn, HCLK)
begin
  if (HRESETn = '0') then
    SMMEMCLKDiv2 <= '0';
    SMMEMCLKDiv3 <= '0';
    Count3       <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    SMMEMCLKDiv2 <= NextSMMEMCLKDiv2;
    SMMEMCLKDiv3 <= NextSMMEMCLKDiv3;
    Count3       <= NextCount3;
  end if;
end process p_MemClkDv2Seq;

-- -----------------------------------------------------------------------------
-- Generate Slow Clocks to SMMem and SMMEMCLKDiv2.
-- -----------------------------------------------------------------------------
p_GenSlowClkComb : process (ClockRatio, SMMEMCLKDiv2, SMMEMCLKDiv3)
begin
  case ClockRatio is
    when "01" =>
      SlowClkM    <= SMMEMCLKDiv2;
    when "10" =>
      SlowClkM    <= SMMEMCLKDiv3;
    when others =>
      SlowClkM    <= '1';
  end case;
end process p_GenSlowClkComb;


-- synopsys translate_off
-- ----------------------------------------------------------------------------
-- START OF PROTOCOL CHECKERS
-- ----------------------------------------------------------------------------


-- Protocol checkers can be used for debugging purposes.


-- ----------------------------------------------------------------------------
-- END OF PROTOCOL CHECKERS
-- ----------------------------------------------------------------------------
-- synopsys translate_on

end synth;

-- --================================== End ==================================--
