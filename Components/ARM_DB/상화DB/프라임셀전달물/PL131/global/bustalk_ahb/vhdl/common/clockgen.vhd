-- --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : clockgen.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v5
--
-- ---------------------------------------------------------------------
-- Purpose :
--           This module generates the bus clock HCLK
--
-- --=================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
 
-- ---------------------------------------------------------------------

entity Clockgen is
  generic(
          Tclks  : time;
          Tclkl  : time;
          Tclkh  : time
          );          
  port(
       HCLK : out std_logic -- AHB bus Clock
       );
end Clockgen;
-- ---------------------------------------------------------------------
--
--                             clockgen
--                             ========
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--   This module generates the main busclock HCLK, by toggling the HCLK
-- line after a time periods tclkl(denoting low phase) and
-- tclkh (denoting high phase). The values of tclkl and tclkh are
-- passed as generic parameters.
-- 
-- --========================== ARCHITECTURE =========================--

architecture behavioural of Clockgen is

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------

signal iHCLK              : std_logic := '0';
-- internal copy of the HCLK signal

signal Start_HCLK         : std_logic := '0';
 
-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------
 
begin

    -- The HCLK signal will be allowed to toggle only if
    -- the Start_HCLK signal is set. The Start_HCLK signal
    -- will be set after a time duration of Tclks. This is
    -- used to control the initial delay of the first
    -- rising edge of clock.
   
   Start_HCLK <= '1' after Tclks;

-- ---------------------------------------------------------------------
-- This block toggles the output line after a time determined by
-- generic the generic parameters, and HCLK is generated
-- ---------------------------------------------------------------------
p_clock : process (iHCLK, Start_HCLK)
begin
     -- If Start_HCLK is set allow the clock to toggle
    if (Start_HCLK = '1') then
      if iHCLK = '0' then
        iHCLK <= '1' after Tclkl;
      else
        iHCLK <= '0' after Tclkh;
      end if;
    -- If Start_HCLK is cleared, the clock line will be low
    else
      iHCLK <= '0';
    end if;
 
    HCLK <= iHCLK;
end process p_clock;

end behavioural;

-- --============================ End ================================--
