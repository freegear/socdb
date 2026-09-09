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
-- File Name              : SsmcPadMux.vhd.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This module includes the registers and mux that drive the SMC
--           outputs. Including all three registers and the mux in one module
--           will ease timing and avoid glitches.
--
-- --=========================================================================--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity SsmcPadMux is
  generic(
    WIDTH : integer := 0    -- I/P width
    );
  port(
    SMMEMCLKDELAY   : in   std_logic;
    SMMEMCLK        : in   std_logic;
    HRESETn         : in   std_logic; 
    NextAsynAxs     : in   std_logic;
    SmCtrlIn        : in   std_logic_vector(WIDTH downto 0);
    SmCtrlInit      : in   std_logic;
    SmCtrlOut       : out  std_logic_vector(WIDTH downto 0)
    );
end SsmcPadMux;

-- --============================== ARCHITECTURE =============================--

architecture synth of SsmcPadMux is

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
  signal AsynAxs           : std_logic;
  signal SmCtrlInReg       : std_logic_vector(WIDTH downto 0);
  signal SmCtrlInRegRes    : std_logic_vector(WIDTH downto 0);
  signal SmCtrlInRegPre    : std_logic_vector(WIDTH downto 0);
  signal SmCtrlInRegDel    : std_logic_vector(WIDTH downto 0);
  signal SmCtrlInRegDelPre : std_logic_vector(WIDTH downto 0);
  signal SmCtrlInRegDelRes : std_logic_vector(WIDTH downto 0);

begin  -- synth

-- -----------------------------------------------------------------------------
-- Main Code
-- -----------------------------------------------------------------------------

-- Mux control signal
p_AsynAxsSeq : process (SMMEMCLK, HRESETn)
begin
  if (HRESETn = '0') then
    AsynAxs   <= '1';
  elsif (SMMEMCLK'event and SMMEMCLK = '1') then
    AsynAxs   <= NextAsynAxs;
  end if;
end process p_AsynAxsSeq;

-- Reset Mux Input Register
p_SmCtrlRegSeq0 : process (SMMEMCLK, HRESETn)
begin
  if (HRESETn = '0') then
    SmCtrlInRegRes <= (others => '0');
  elsif (SMMEMCLK'event and SMMEMCLK = '1') then
    SmCtrlInRegRes <= SmCtrlIn;
  end if;
end process p_SmCtrlRegSeq0;

-- Preset Mux Input Register
p_SmCtrlRegSeq1 : process (SMMEMCLK, HRESETn)
begin
  if (HRESETn = '0') then
    SmCtrlInRegPre <= (others => '1');
  elsif (SMMEMCLK'event and SMMEMCLK = '1') then
    SmCtrlInRegPre <= SmCtrlIn;
  end if;
end process p_SmCtrlRegSeq1;

-- Select either the preset or reset register. This mux will be optimised out
-- during synthesis as SmCtrlInit is tied off at the level above, SsmcPadIf.
SmCtrlInReg <= SmCtrlInRegPre when (SmCtrlInit = '1') else SmCtrlInRegRes;

-- Mux Input Register
p_SmCtrlRegDelResSeq : process (SMMEMCLKDELAY, HRESETn)
begin
  if (HRESETn = '0') then
    SmCtrlInRegDelRes <= (others => '0');
  elsif (SMMEMCLKDELAY'event and SMMEMCLKDELAY = '1') then
    SmCtrlInRegDelRes <= SmCtrlInReg;
  end if;
end process p_SmCtrlRegDelResSeq;

p_SmCtrlRegDelPreSeq : process (SMMEMCLKDELAY, HRESETn)
begin
  if (HRESETn = '0') then
    SmCtrlInRegDelPre <= (others => '1');
  elsif (SMMEMCLKDELAY'event and SMMEMCLKDELAY = '1') then
    SmCtrlInRegDelPre <= SmCtrlInReg;
  end if;
end process p_SmCtrlRegDelPreSeq;

SmCtrlInRegDel <= SmCtrlInRegDelPre when (SmCtrlInit = '1') else
               SmCtrlInRegDelRes;

-- Output Mux
SmCtrlOut <= SmCtrlInReg when (AsynAxs = '1') else SmCtrlInRegDel;

end synth;
