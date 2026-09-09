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
-- File Name              : EbiTrClkResGen.vhd.rca
-- File Revision          : 1.2
--
-- Release Information    : PrimeCell(TM)-PL220-r0p0-00ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block generates the EBICLK, MEMCLK1, MEMCLK2, MEMCLK3 and
--           nPOR.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity EbiTrClkResGen is
  generic (
           Tclkl            : time; -- HCLK low time
           Tclkh            : time; -- HCLK high time
           Tclks            : time  -- EBICLK start delay
          );

  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB Bus clock
        EbiTrClk         : in    std_logic_vector(2 downto 0);
                                            -- Indicates MEMCLK speed
        HRESETn          : in    std_logic; -- Bus reset
-- Outputs
        nPOR             : out   std_logic; -- Power On Reset
        MEMCLK1          : out   std_logic; -- Memory clock from Port1
        MEMCLK2          : out   std_logic; -- Memory clock from Port2
        MEMCLK3          : out   std_logic; -- Memory clock from Port3
        EBICLK           : out   std_logic  -- EBICLK output to EBI
       );
end EbiTrClkResGen;

-- -----------------------------------------------------------------------------
--
--                               EbiTrClkResGen
--                               ===============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--   This block generates the EBICLK signal.
--
-- -----------------------------------------------------------------------------

-- --============================ ARCHITECTURE ===============================--

architecture behavioural of EbiTrClkResGen is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------

signal StartMEMCLK1     : std_logic := '0';
-- Indicates the start of MEMCLK1

signal StartMEMCLK2     : std_logic := '0';
-- Indicates the start of MEMCLK2

signal StartMEMCLK3     : std_logic := '0';
-- Indicates the start of MEMCLK3

signal iMEMCLK1         : std_logic := '0';
-- Internal version of MEMCLK1

signal iMEMCLK2         : std_logic := '0';
-- Internal version of MEMCLK2

signal iMEMCLK3         : std_logic := '0';
-- Internal version of MEMCLK3

signal iEBICLK          : std_logic := '0';
-- Internal version of MEMCLK1

signal StartEBICLK      : std_logic := '0';
-- Indicates the start of EBICLK

signal inPOR            : std_logic := '1';
-- Internal version of nPOR
signal Tmclkh           : time := (Tclkl + Tclkh)/2;
-- EBICLK high time

signal Tmclkl           : time := (Tclkl + Tclkh)/2;
-- EBICLK low time

signal Tmclkh1          : time := (Tclkl + Tclkh)/2;
-- MEMCLK1 high time

signal Tmclkl1          : time := (Tclkl + Tclkh)/2;
-- MEMCLK1 low time

signal Tmclkh2          : time := (Tclkl + Tclkh)/2;
-- MEMCLK2 high time

signal Tmclkl2          : time := (Tclkl + Tclkh)/2;
-- MEMCLK2 low time

signal Tmclkh3          : time := (Tclkl + Tclkh)/2;
-- MEMCLK3 high time

signal Tmclkl3          : time := (Tclkl + Tclkh)/2;
-- MEMCLK3 low time

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
--  MEMCLK1 Generation
-- -----------------------------------------------------------------------------
StartMEMCLK1 <= '1' after Tclks;

p_Clk1Seq : process (iMEMCLK1, StartMEMCLK1)
begin
  -- If StartMEMCLK1 is set allow the clock to toggle
  if (StartMEMCLK1 = '1') then
    if (iMEMCLK1 = '0') then
      iMEMCLK1 <= '1' after Tmclkl1;
    else
      iMEMCLK1 <= '0' after Tmclkh1;
    end if;
    -- If StartMEMCLK1 is cleared, the clock line will be low
  else
    iMEMCLK1 <= '0';
  end if;
end process p_Clk1Seq;

-- -----------------------------------------------------------------------------
--  MEMCLK2 Generation
-- -----------------------------------------------------------------------------
StartMEMCLK2     <= '1' after Tclks;

p_Clk2Seq : process (iMEMCLK2, StartMEMCLK2)
begin
  -- If StartMEMCLK2 is set allow the clock to toggle
  if (StartMEMCLK2 = '1') then
    if (iMEMCLK2 = '0') then
      iMEMCLK2 <= '1' after Tmclkl2;
    else
      iMEMCLK2 <= '0' after Tmclkh2;
    end if;
    -- If StartMEMCLK2 is cleared, the clock line will be low
  else
    iMEMCLK2 <= '0';
  end if;
end process p_Clk2Seq;

-- -----------------------------------------------------------------------------
--  MEMCLK3 Generation
-- -----------------------------------------------------------------------------
StartMEMCLK3 <= '1' after Tclks;

p_Clk3Seq : process (iMEMCLK3, StartMEMCLK3)
begin
  -- If StartMEMCLK3 is set allow the clock to toggle
  if (StartMEMCLK3 = '1') then
    if (iMEMCLK3 = '0') then
      iMEMCLK3 <= '1' after Tmclkl3;
    else
      iMEMCLK3 <= '0' after Tmclkh3;
    end if;
  -- If StartMEMCLK3 is cleared, the clock line will be low
  else
    iMEMCLK3 <= '0';
  end if;
end process p_Clk3Seq;

-- -----------------------------------------------------------------------------
--  EBICLK Generation
-- -----------------------------------------------------------------------------
StartEBICLK <= '1' after Tclks;

p_EbiClkSeq : process (iEBICLK, StartEBICLK)
begin
  -- If StartEBICLK is set allow the clock to toggle
  if (StartEBICLK = '1') then
    if (iEBICLK = '0') then
      iEBICLK <= '1' after Tmclkl;
    else
      iEBICLK <= '0' after Tmclkh;
    end if;
  -- If StartEBICLK is cleared, the clock line will be low
  else
    iEBICLK <= '0';
  end if;
end process p_EbiClkSeq;

-- -----------------------------------------------------------------------------
-- Determine the EBICLK frequency
-- -----------------------------------------------------------------------------
p_ClkRatSeq : process (iEBICLK, EbiTrClk)
begin
  if (iEBICLK'event and iEBICLK = '0') then
    if (EbiTrClk /= "000") then
      Tmclkh           <= (Tclkl + Tclkh)/4;
      Tmclkl           <= (Tclkl + Tclkh)/4;
    else
      Tmclkh           <= (Tclkl + Tclkh)/2;
      Tmclkl           <= (Tclkl + Tclkh)/2;
    end if;
  end if;
end process p_ClkRatSeq;

-- -----------------------------------------------------------------------------
-- Determine the MEMCLK1 frequency
-- -----------------------------------------------------------------------------
p_MemClk1Seq : process (iMEMCLK1, EbiTrClk)
begin
  if (iMEMCLK1'event and iMEMCLK1 = '0') then
    if (EbiTrClk(0) = '1') then
      Tmclkh1          <= (Tclkl + Tclkh)/4;
      Tmclkl1          <= (Tclkl + Tclkh)/4;
    else
      Tmclkh1          <= (Tclkl + Tclkh)/2;
      Tmclkl1          <= (Tclkl + Tclkh)/2;
    end if;
  end if;
end process p_MemClk1Seq;

-- -----------------------------------------------------------------------------
-- Determine the MEMCLK2 frequency
-- -----------------------------------------------------------------------------
p_MemClk2Seq : process (iMEMCLK2, EbiTrClk)
begin
  if (iMEMCLK2'event and iMEMCLK2 = '0') then
    if (EbiTrClk(1) = '1') then
      Tmclkh2          <= (Tclkl + Tclkh)/4;
      Tmclkl2          <= (Tclkl + Tclkh)/4;
    else
      Tmclkh2          <= (Tclkl + Tclkh)/2;
      Tmclkl2          <= (Tclkl + Tclkh)/2;
    end if;
  end if;
end process p_MemClk2Seq;

-- -----------------------------------------------------------------------------
-- Determine the MEMCLK3 frequency
-- -----------------------------------------------------------------------------
p_MemClk3Seq : process (iMEMCLK3, EbiTrClk)
begin
  if (iMEMCLK3'event and iMEMCLK3 = '0') then
    if (EbiTrClk(2) = '1') then
      Tmclkh3          <= (Tclkl + Tclkh)/4;
      Tmclkl3          <= (Tclkl + Tclkh)/4;
    else
      Tmclkh3          <= (Tclkl + Tclkh)/2;
      Tmclkl3          <= (Tclkl + Tclkh)/2;
    end if;
  end if;
end process p_MemClk3Seq;

-- -----------------------------------------------------------------------------
-- Generation of nPOR
-- -----------------------------------------------------------------------------
p_PORGenSeq : process (HRESETn, HCLK)
begin
   if(HRESETn = '0') then
     inPOR <= '0';
   elsif(HCLK'event and HCLK = '1') then
     inPOR <= '1';
   end if;
end process p_PORGenSeq;

-- -----------------------------------------------------------------------------
-- Assigning internal copy of inPOR to output
-- -----------------------------------------------------------------------------
nPOR             <= inPOR after 3 ns;
EBICLK           <= iEBICLK;
MEMCLK1          <= iMEMCLK1;
MEMCLK2          <= iMEMCLK2;
MEMCLK3          <= iMEMCLK3;

end behavioural;

-- --================================== End ==================================--
