--  ---------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  ----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : $RCS: $
--  File Revision          : 1.2
--
--  Release Information    : PrimeCell(TM)-PL170-REL2v2
--
--  ----------------------------------------------------------------------------
--
--  ----------------------------------------------------------------------------
--  Purpose       : This module generates the ExtBusGnt Signal to the UUT
--                  
--  ----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity SdramTrBusGnt is
port (
      HCLK          : in   std_logic; -- AHB Clock Input
      nReset        : in   std_logic; -- Trickbox Reset
      ExtBusReq     : in   std_logic; -- Bus Request driven by the UUT
      BusGntMode    : in   std_logic; -- Selects Deterministic/Random 
                                      -- ExtBusGntDelay
      BusGntHigh    : in   std_logic; -- Bit to pull the ExtBusGnt High
      BusGntClk     : in   std_logic_vector(4 downto 0);
                                      -- Delay between ExtBusGnt Assertion and 
                                      -- Request

      ExtBusGnt     : out  std_logic  -- Bus Grant Output to the UUT
     );
end SdramTrBusGnt; 

--  ----------------------------------------------------------------------------
--
--                    SdramTrBusGnt 
--                    ==============
--
--  ----------------------------------------------------------------------------
--  Overview
--  ========
--   This module implements the following ExtBusGnt generation modes:
-- - ExtBusGnt high at the start
-- - Deterministic, programmable delay between ExtBusReq and ExtBusGnt
-- - Random delay between ExtBusReq and ExtBusGnt
--
--===========================ARCHITECTURE=======================================
--
--------------------------------------------------------------------------------
-- Architecture Packages
--------------------------------------------------------------------------------
 
architecture behavioural of SdramTrBusGnt is

--------------------------------------------------------------------------------
-- Signal declarations
--------------------------------------------------------------------------------
signal  LstCount      : std_logic_vector(2 downto 0);
signal  NextLstCount  : std_logic_vector(2 downto 0);

signal  DetCount      : std_logic_vector(4 downto 0);
signal  NextDetCount  : std_logic_vector(4 downto 0);

signal  RandCount     : std_logic_vector(4 downto 0);
signal  NextRandCount : std_logic_vector(4 downto 0);

signal  iExtBusGnt    : std_logic;

--  ---------------------------------------------------------------------------
--  ExtBusGnt Generation Constants
--  ---------------------------------------------------------------------------
constant  BUSGNTDELAYHIG   : std_logic_vector(4 downto 0) := "11000";
constant  BUSGNTDELAYLOW   : std_logic_vector(2 downto 0) := "000";

begin

p_ExtBusGntComb : process (DetCount, RandCount, BusGntMode, ExtBusReq, 
                           BusGntClk, LstCount, BusGntHigh)
begin
  if (BusGntHigh = '1') then
    iExtBusGnt <= '1';
  elsif (BusGntMode = '0') then
    if ((DetCount = BusGntClk) and ExtBusReq = '1') then
      iExtBusGnt <= '1';
    elsif (ExtBusReq = '0' and (LstCount = BUSGNTDELAYLOW)) then 
      iExtBusGnt <= '0';
    end if;
  else
    if ((RandCount = BUSGNTDELAYHIG) and ExtBusReq = '1') then
      iExtBusGnt <= '1';
    elsif (ExtBusReq = '0' and (LstCount = BUSGNTDELAYLOW)) then
      iExtBusGnt <= '0';
    end if;
  end if;
end process p_ExtBusGntComb;

ExtBusGnt <= iExtBusGnt;

--  ---------------------------------------------------------------------------
--  ExtBusGntLst Counter
--  ---------------------------------------------------------------------------
p_ExtBusGntLstComb : process (LstCount, ExtBusReq, iExtBusGnt) 
begin
  if ((ExtBusReq = '1' and iExtBusGnt = '1') or iExtBusGnt = '0') then
    NextLstCount <= "000";
  elsif (ExtBusReq = '0' and iExtBusGnt = '1') then
    NextLstCount <= unsigned(LstCount) + 1;
  else
    NextLstCount <= LstCount;
  end if;
end process p_ExtBusGntLstComb;

p_ExtBusGntLstSeq : process (HCLK, nReset)
begin
  if (nReset = '0') then
    LstCount <= "000";
  elsif (HCLK'event and HCLK = '1') then
    LstCount <= NextLstCount;
  end if;
end process p_ExtBusGntLstSeq;

--  ---------------------------------------------------------------------------
--  Sequential Counter
--  ---------------------------------------------------------------------------
p_DetCountComb : process (DetCount, ExtBusReq, BusGntMode, iExtBusGnt)
begin
  if (BusGntMode = '1' or (ExtBusReq = '1' and iExtBusGnt = '1') or
      (ExtBusReq = '0' and ExtBusReq = '0')) then
    NextDetCount <= (others => '0');
  elsif (ExtBusReq = '1' and iExtBusGnt = '0') then
    NextDetCount <= unsigned(DetCount) + 1;
  else
    NextDetCount <= DetCount;
  end if;
end process p_DetCountComb;

p_DetCountSeq : process (HCLK, nReset)
begin
  if (nReset = '0') then
    DetCount <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    DetCount <= NextDetCount;
  end if;
end process p_DetCountSeq;

--  ---------------------------------------------------------------------------
--  Random Counter
--  ---------------------------------------------------------------------------
p_RandCountComb : process (RandCount)
begin
  NextRandCount(4)          <= RandCount(0) xor RandCount(1);
  NextRandCount(3 downto 0) <= RandCount(4 downto 1);
end process p_RandCountComb;

p_RandCountSeq : process (HCLK, nReset)
begin
  if (nReset = '0') then
    RandCount <= "00001";
  elsif (HCLK'event and HCLK = '1') then
    RandCount <= NextRandCount;
  end if;
end process p_RandCountSeq;

end behavioural;

--==================================== End ===================================--
