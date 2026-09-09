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
-- File Name              : MpmcTrClkResGen.vhd.rca
-- File Revision          : 1.6
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block generates the MPMCCLK, MPMCFBCLKIN, MPMCCSREFREQ
--           and nPOR signals for the MPMC
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity MpmcTrClkResGen is
  generic (
           Tclkl            : time := 10 ns; -- HCLK low time
           Tclkh            : time := 10 ns; -- HCLK high time
           Tclks            : time := 10 ns  -- MPMCCLK start delay
          );

  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB Bus clock
        MPMCCLKOUT       : in    std_logic_vector(3 downto 0);
                                            -- MPMC Clock
        HRESETn          : in    std_logic; -- Bus reset
        MPMCTrCR         : in    std_logic_vector(3 downto 0);
                                            -- MPMCTrCR register
        MPMCTrConfig     : in    std_logic_vector(9 downto 0);
                                            -- Mirror register of MPMCConfig
        MPMCSREFACK      : in    std_logic; -- Self referesh acknowledge from
                                            -- MPMC
-- Outputs
        MPMCCLK          : out   std_logic; -- MPMCCLK output to MPMC
        MPMCCLKDELAY     : out   std_logic; -- Inverted MPMCCLK output to MPMC
        nPOR             : out   std_logic; -- Power on Reset to MPMC
        nReset           : out   std_logic; -- Trickbox internal reset signal
        MPMCSREFREQ      : out   std_logic  -- Self refersh request from
                                            -- Trickbox
       );
end MpmcTrClkResGen;

-- -----------------------------------------------------------------------------
--
--                               MpmcTrClkResGen
--                               ===============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--   This block generates the MPMCCLK, MPMCFBCLKIN, MPMCCSREFREQ and the nPOR
-- signals. The MPMCTrCR register bits are interpreted in this block.
--
-- -----------------------------------------------------------------------------

-- --============================ ARCHITECTURE ===============================--

architecture behavioural of MpmcTrClkResGen is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------
constant MPMCCLK_TO_MPMCCLKDELAY_DELAY    : time := 4 ns;
constant PORDELAY         : time := 1 ns;

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal NxtMPMCSREFREQ   : std_logic;
-- D-Input for MPMCSREFREQ

signal iMPMCSREFREQ     : std_logic;
-- Internal signal for MPMCSREFREQ

signal POR              : std_logic;
-- Power on Reset bit of MPMCTrCR register

signal inPOR            : std_logic := '1';
-- Internal signal for nPOR

signal SREFREQ          : std_logic;
-- Self refersh bit of MPMCTrCR register

signal ClkRatio         : std_logic_vector(1 downto 0);
-- Define the ratio between HCLK and MPMCCLK

signal inReset          : std_logic;
-- Internal signal for nReset

signal ResetAssrtd      : boolean := FALSE;
-- Indicates the start of checks

signal ResetOver        : boolean := FALSE;
-- Indicates the start of checks

signal iMPMCCLK         : std_logic := '0';
-- Internal version of MPMCCLK

signal StartMPMCCLK     : std_logic := '0';
-- Indicates the start of MPMCCLK

signal Tmclkh           : time := (Tclkl + Tclkh)/2;
-- MPMCCLK high time

signal Tmclkl           : time := (Tclkl + Tclkh)/2;
-- MPMCCLK low time

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
-- Connect local copies to output ports
-- -----------------------------------------------------------------------------
nPOR             <= inPOR after 2 ns;
MPMCSREFREQ      <= iMPMCSREFREQ;
nReset           <= inReset;

-- -----------------------------------------------------------------------------
-- nReset Generation
-- -----------------------------------------------------------------------------
inReset          <= inPOR and HRESETn;

-- -----------------------------------------------------------------------------
-- inPOR Generation using the MPMCTrCR register bit
-- -----------------------------------------------------------------------------
POR              <= MPMCTrCR(1);

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
-- Clocking out the nPOR
-- -----------------------------------------------------------------------------
p_nPORSeq : process (HCLK, POR, HRESETn)
begin
  if ((HRESETn = '0') and (ResetOver = FALSE)) then
    inPOR <= '0';
  elsif (POR = '1') then
    inPOR <= '0' after PORDELAY;
  elsif (HCLK'event and HCLK = '1') then
    inPOR <= '1';
  end if;
end process p_nPORSeq;

-- -----------------------------------------------------------------------------
-- MPMCSREFREQ Generation
-- -----------------------------------------------------------------------------
SREFREQ          <= MPMCTrCR(0);

-- -----------------------------------------------------------------------------
-- MPMCSREFREQ set/clear logic
-- -----------------------------------------------------------------------------
p_SRefReqComb : process (SREFREQ, MPMCSREFACK, iMPMCSREFREQ)
begin
  if (MPMCSREFACK = '1') then
    NxtMPMCSREFREQ <= SREFREQ;
  elsif (SREFREQ = '1') then
    NxtMPMCSREFREQ <= '1';
  else
    NxtMPMCSREFREQ <= iMPMCSREFREQ;
  end if;
end process p_SRefReqComb;

-- -----------------------------------------------------------------------------
-- Clocking out MPMCSREFREQ
-- -----------------------------------------------------------------------------
p_SRefReqSeq : process (HCLK, inReset)
begin
  if (inReset = '0') then
    iMPMCSREFREQ <= '0';
  elsif (HCLK'event and HCLK = '1') then
    iMPMCSREFREQ <= NxtMPMCSREFREQ;
  end if;
end process p_SRefReqSeq;

-- -----------------------------------------------------------------------------
--  ClkRatio and MemClkEn Generation
-- -----------------------------------------------------------------------------
ClkRatio         <= MPMCTrConfig(9 downto 8);

-- -----------------------------------------------------------------------------
--  MPMCCLK Generation
-- -----------------------------------------------------------------------------
StartMPMCCLK <= '1' after Tclks;

p_MpmcClkSeq : process (iMPMCCLK, StartMPMCCLK)
begin
     -- If StartMPMCCLK is set allow the clock to toggle
    if (StartMPMCCLK = '1') then
      if iMPMCCLK = '0' then
        iMPMCCLK <= '1' after Tmclkl;
      else
        iMPMCCLK <= '0' after Tmclkh;
      end if;
    -- If StartMPMCCLK is cleared, the clock line will be low
    else
      iMPMCCLK <= '0';
    end if;
    MPMCCLK <= iMPMCCLK;
end process p_MpmcClkSeq;

-- -----------------------------------------------------------------------------
-- Determine the MPMCCLK frequency
-- -----------------------------------------------------------------------------
p_ClkRatSeq : process (iMPMCCLK)
begin
  if (iMPMCCLK'event and iMPMCCLK = '0') then
    if (ClkRatio = "11") then
      Tmclkh           <= (Tclkl + Tclkh)/4;
      Tmclkl           <= (Tclkl + Tclkh)/4;
    else
      Tmclkh           <= (Tclkl + Tclkh)/2;
      Tmclkl           <= (Tclkl + Tclkh)/2;
    end if;
  end if;
end process p_ClkRatSeq;
                    
-- -----------------------------------------------------------------------------
-- MPMCCLKDELAY Generation
-- -----------------------------------------------------------------------------
MPMCCLKDELAY     <= iMPMCCLK after MPMCCLK_TO_MPMCCLKDELAY_DELAY;

end behavioural;

-- --================================== End ==================================--
