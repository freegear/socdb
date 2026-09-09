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
-- File Name              : SsmcTrMemClkGen.vhd.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This module generates the Memory clock SMMemCLK
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SsmcTrMemClkGen is
  generic(
          Tclks  : time;
          Tclkl  : time;
          Tclkh  : time
          );
  port(
       SMMemClkRatio  : in std_logic_vector(1 downto 0);
                                     -- Memory clock to HCLk ratio
       SMMemCLK       : out std_logic -- Memory Clock
       );
end SsmcTrMemClkGen;
-- -----------------------------------------------------------------------------
--
--                             MemClkGen
--                             =========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--   This module generates the Memory clock SMMemCLK by toggling the MemCLK
-- line after a time periods tclkl(denoting low phase) and tclkh (denoting 
-- high phase).
-- The values of tclkl and tclkh are passed as generic parameters.
-- The frequency of the memory clock will be dependent on SMMemClkRatio.
--
-- --========================== ARCHITECTURE =================================--

architecture behavioural of SsmcTrMemClkGen is

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------

signal iSMMemCLK              : std_logic := '0';
-- internal copy of the SMMemCLK signal

signal Start_SMMemCLK         : std_logic := '0';
-- Indicates that SMMemCLK can start toggling

signal Tsclkh                 : time := (Tclkl + Tclkh)/2;
-- SMMemCLK high time

signal Tsclkl                 : time := (Tclkl + Tclkh)/2;
-- SMMemCLK low time


-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------
begin

    -- The SMMemCLK signal will be allowed to toggle only if
    -- the Start_SMMemCLK signal is set. The Start_SMMemCLK signal
    -- will be set after a time duration of Tclks. This is
    -- used to control the initial delay of the first
    -- rising edge of clock.

-- -----------------------------------------------------------------------------
-- SMMemCLK generation
-- -----------------------------------------------------------------------------

   Start_SMMemCLK <= '1' after Tclks;

-- -----------------------------------------------------------------------------
-- This block toggles the output line after a time determined by
-- generic the generic parameters, and SMMemCLK is generated
-- -----------------------------------------------------------------------------
p_SMClkSeq : process (iSMMemCLK, Start_SMMemCLK)
begin
  -- If Start_SMMemCLK is set allow the clock to toggle
  if (Start_SMMemCLK = '1') then 
    if (iSMMemCLK = '0') then
      iSMMemCLK <= '1' after Tsclkl;
    else
      iSMMemCLK <= '0' after Tsclkh;
    end if;
  -- If Start_SMMemCLK is cleared, the clock line will be low
  else
    iSMMemCLK <= '0';
  end if;

  SMMemCLK <= iSMMemCLK;

end process p_SMClkSeq;

-- -----------------------------------------------------------------------------
-- Clock Ratio determination
-- -----------------------------------------------------------------------------
p_ClkRatioSeq : process (iSMMemCLK)
begin
  if (iSMMemCLK'event and iSMMemCLK = '0') then
    if (SMMemClkRatio = "01") then
      Tsclkh      <= (((Tclkl + Tclkh)/2) * 2);
      Tsclkl      <= (((Tclkl + Tclkh)/2) * 2);
    elsif (SMMemClkRatio = "10") then
      Tsclkh      <= (((Tclkl + Tclkh)/2) * 3);
      Tsclkl      <= (((Tclkl + Tclkh)/2) * 3);
    else
      Tsclkh      <= (((Tclkl + Tclkh)/2) * 1);
      Tsclkl      <= (((Tclkl + Tclkh)/2) * 1);
    end if;
  end if;
end process p_ClkRatioSeq;


end behavioural;

-- --============================ End ========================================--

