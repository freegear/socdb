-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : VicPriority.vhd.rca
-- File Revision          : 1.9
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block resolves the priority of the interrupt
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use work.VicPackage.all;

-- -----------------------------------------------------------------------------

entity VicPriority is
  port (
-- Inputs
        IRQStatusIn      : in    std_logic_vector(31 downto 0);
                                            -- IRQ status input
        DaisyChainIn     : in    std_logic; -- Daisy chain input
        SyncIRQStatusIn  : in    std_logic_vector(31 downto 0);
                                            -- Synchronized IRQ status input
        SyncDaisyChainIn : in    std_logic; -- Synchronized daisy chain input
        SWPriorityMask   : in    std_logic; -- Mask for this level
        CurrentLevelMask : in    std_logic; -- Mask generated from current IRQ
                                            -- PLevel
        PLevel0          : in    std_logic_vector(3 downto 0);
                                            -- Priority Level for 0th interrupt
                                            -- source
        PLevel1          : in    std_logic_vector(3 downto 0);
                                            -- Priority Level for 1st interrupt
                                            -- source
        PLevel2          : in    std_logic_vector(3 downto 0);
                                            -- Priority Level for 2nd interrupt
                                            -- source
        PLevel3          : in    std_logic_vector(3 downto 0);
                                            -- Priority Level for 3rd interrupt
                                            -- source
        PLevel4          : in    std_logic_vector(3 downto 0);
                                            -- Priority Level for 4th interrupt
                                            -- source
        PLevel5          : in    std_logic_vector(3 downto 0);
                                            -- Priority Level for 5th interrupt
                                            -- source
        PLevel6          : in    std_logic_vector(3 downto 0);
                                            -- Priority Level for 6th interrupt
                                            -- source
        PLevel7          : in    std_logic_vector(3 downto 0);
                                            -- Priority Level for 7th interrupt
                                            -- source
        PLevel8          : in    std_logic_vector(3 downto 0);
                                            -- Priority Level for 8th interrupt
                                            -- source
        PLevel9          : in    std_logic_vector(3 downto 0);
                                            -- Priority Level for 9th interrupt
                                            -- source
        PLevel10         : in    std_logic_vector(3 downto 0);
                                            -- Priority Level for 10th
                                            -- interrupt source
        PLevel11         : in    std_logic_vector(3 downto 0);
                                            -- Priority Level for 11th
                                            -- interrupt source
        PLevel12         : in    std_logic_vector(3 downto 0);
                                            -- Priority Level for 12th
                                            -- interrupt source
        PLevel13         : in    std_logic_vector(3 downto 0);
                                            -- Priority Level for 13th
                                            -- interrupt source
        PLevel14         : in    std_logic_vector(3 downto 0);
                                            -- Priority Level for 14th
                                            -- interrupt source
        PLevel15         : in    std_logic_vector(3 downto 0);
                                            -- Priority Level for 15th
                                            -- interrupt source
        PLevel16         : in    std_logic_vector(3 downto 0);
                                            -- Priority Level for 16th
                                            -- interrupt source
        PLevel17         : in    std_logic_vector(3 downto 0);
                                            -- Priority Level for 17th
                                            -- interrupt source
        PLevel18         : in    std_logic_vector(3 downto 0);
                                            -- Priority Level for 18th
                                            -- interrupt source
        PLevel19         : in    std_logic_vector(3 downto 0);
                                            -- Priority Level for 19th
                                            -- interrupt source
        PLevel20         : in    std_logic_vector(3 downto 0);
                                            -- Priority Level for 20th
                                            -- interrupt source
        PLevel21         : in    std_logic_vector(3 downto 0);
                                            -- Priority Level for 21st
                                            -- interrupt source
        PLevel22         : in    std_logic_vector(3 downto 0);
                                            -- Priority Level for 22nd
                                            -- interrupt source
        PLevel23         : in    std_logic_vector(3 downto 0);
                                            -- Priority Level for 23rd
                                            -- interrupt source
        PLevel24         : in    std_logic_vector(3 downto 0);
                                            -- Priority Level for 24th
                                            -- interrupt source
        PLevel25         : in    std_logic_vector(3 downto 0);
                                            -- Priority Level for 25th
                                            -- interrupt source
        PLevel26         : in    std_logic_vector(3 downto 0);
                                            -- Priority Level for 26th
                                            -- interrupt source
        PLevel27         : in    std_logic_vector(3 downto 0);
                                            -- Priority Level for 27th
                                            -- interrupt source
        PLevel28         : in    std_logic_vector(3 downto 0);
                                            -- Priority Level for 28th
                                            -- interrupt source
        PLevel29         : in    std_logic_vector(3 downto 0);
                                            -- Priority Level for 29th
                                            -- interrupt source
        PLevel30         : in    std_logic_vector(3 downto 0);
                                            -- Priority Level for 30th
                                            -- interrupt source
        PLevel31         : in    std_logic_vector(3 downto 0);
                                            -- Priority Level for 31st
                                            -- interrupt source
        PLevel32         : in    std_logic_vector(3 downto 0);
                                            -- Priority Level for 32nd
                                            -- interrupt source
        PriorityLevelCfg : in    std_logic_vector(3 downto 0);
                                            -- Priority Level of this decoder

-- Outputs
        IrqOutput        : out   std_logic; -- asynchronous IRQ output
        SyncIrqOutput    : out   std_logic; -- synchronous IRQ output
        IRQPort          : out   std_logic_vector(5 downto 0)
                                            -- Binary code indicating which
                                            -- interrupt source is used.
                                            -- 0-31=IRQ status in,
                                            -- 32=Daisy Chain
       );
end VicPriority;

-- -----------------------------------------------------------------------------
--
--                                 VicPriority
--                                 ===========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- - This block resolves the interrupts which are of the same priority level.
-- When there are more than one interrupt of the same priority asserted then,
-- hardware priority is used to resolve the interrupt. Source0 has the highest
-- priority and source32 has the lowest priority. Daisy chain has the lowest
-- priority.
--
-- - This block also returns the asynchronised, synchronised interrupts and
-- port information which are used to generate the nVICIRQ and VICADDRESS.
--
-- -----------------------------------------------------------------------------

-- --============================ ARCHITECTURE ==============================--

architecture synth of VicPriority is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal LevelMatchedIrq  : std_logic_vector(32 downto 0);
-- Each bit corresponding to the enabled asynchronous IRQ of this priority

signal SyncLvMatchedIrq : std_logic_vector(32 downto 0);
-- Each bit corresponding to the enabled synchronous IRQ of this priority

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
-- Check if asynchronous IRQ input match the PLevel level of this decoder.
-- If yes, set the corresponding bit in the LevelMatchedIrq
-- -----------------------------------------------------------------------------
LevelMatchedIrq(0) <= IRQStatusIn(0) when (PLevel0 = PriorityLevelCfg)
                 else
                    '0';
LevelMatchedIrq(1) <= IRQStatusIn(1) when (PLevel1 = PriorityLevelCfg)
                 else
                    '0';
LevelMatchedIrq(2) <= IRQStatusIn(2) when (PLevel2 = PriorityLevelCfg)
                 else
                    '0';
LevelMatchedIrq(3) <= IRQStatusIn(3) when (PLevel3 = PriorityLevelCfg)
                 else
                    '0';
LevelMatchedIrq(4) <= IRQStatusIn(4) when (PLevel4 = PriorityLevelCfg)
                 else
                    '0';
LevelMatchedIrq(5) <= IRQStatusIn(5) when (PLevel5 = PriorityLevelCfg)
                 else
                    '0';
LevelMatchedIrq(6) <= IRQStatusIn(6) when (PLevel6 = PriorityLevelCfg)
                 else
                    '0';
LevelMatchedIrq(7) <= IRQStatusIn(7) when (PLevel7 = PriorityLevelCfg)
                 else
                    '0';
LevelMatchedIrq(8) <= IRQStatusIn(8) when (PLevel8 = PriorityLevelCfg)
                 else
                    '0';
LevelMatchedIrq(9) <= IRQStatusIn(9) when (PLevel9 = PriorityLevelCfg)
                 else
                    '0';
LevelMatchedIrq(10) <= IRQStatusIn(10) when (PLevel10 = PriorityLevelCfg)
                 else
                    '0';
LevelMatchedIrq(11) <= IRQStatusIn(11) when (PLevel11 = PriorityLevelCfg)
                 else
                    '0';
LevelMatchedIrq(12) <= IRQStatusIn(12) when (PLevel12 = PriorityLevelCfg)
                 else
                    '0';
LevelMatchedIrq(13) <= IRQStatusIn(13) when (PLevel13 = PriorityLevelCfg)
                 else
                    '0';
LevelMatchedIrq(14) <= IRQStatusIn(14) when (PLevel14 = PriorityLevelCfg)
                 else
                    '0';
LevelMatchedIrq(15) <= IRQStatusIn(15) when (PLevel15 = PriorityLevelCfg)
                 else
                    '0';
LevelMatchedIrq(16) <= IRQStatusIn(16) when (PLevel16 = PriorityLevelCfg)
                 else
                    '0';
LevelMatchedIrq(17) <= IRQStatusIn(17) when (PLevel17 = PriorityLevelCfg)
                 else
                    '0';
LevelMatchedIrq(18) <= IRQStatusIn(18) when (PLevel18 = PriorityLevelCfg)
                 else
                    '0';
LevelMatchedIrq(19) <= IRQStatusIn(19) when (PLevel19 = PriorityLevelCfg)
                 else
                    '0';
LevelMatchedIrq(20) <= IRQStatusIn(20) when (PLevel20 = PriorityLevelCfg)
                 else
                    '0';
LevelMatchedIrq(21) <= IRQStatusIn(21) when (PLevel21 = PriorityLevelCfg)
                 else
                    '0';
LevelMatchedIrq(22) <= IRQStatusIn(22) when (PLevel22 = PriorityLevelCfg)
                 else
                    '0';
LevelMatchedIrq(23) <= IRQStatusIn(23) when (PLevel23 = PriorityLevelCfg)
                 else
                    '0';
LevelMatchedIrq(24) <= IRQStatusIn(24) when (PLevel24 = PriorityLevelCfg)
                 else
                    '0';
LevelMatchedIrq(25) <= IRQStatusIn(25) when (PLevel25 = PriorityLevelCfg)
                 else
                    '0';
LevelMatchedIrq(26) <= IRQStatusIn(26) when (PLevel26 = PriorityLevelCfg)
                 else
                    '0';
LevelMatchedIrq(27) <= IRQStatusIn(27) when (PLevel27 = PriorityLevelCfg)
                 else
                    '0';
LevelMatchedIrq(28) <= IRQStatusIn(28) when (PLevel28 = PriorityLevelCfg)
                 else
                    '0';
LevelMatchedIrq(29) <= IRQStatusIn(29) when (PLevel29 = PriorityLevelCfg)
                 else
                    '0';
LevelMatchedIrq(30) <= IRQStatusIn(30) when (PLevel30 = PriorityLevelCfg)
                 else
                    '0';
LevelMatchedIrq(31) <= IRQStatusIn(31) when (PLevel31 = PriorityLevelCfg)
                 else
                    '0';
LevelMatchedIrq(32) <= DaisyChainIn when (PLevel32 = PriorityLevelCfg)
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Check if synchronous IRQ input match the PLevel level of this decoder.
-- If yes, set the corresponding bit in the SyncLvMatchedIrq
-- -----------------------------------------------------------------------------
SyncLvMatchedIrq(0) <= SyncIRQStatusIn(0) when (PLevel0 = PriorityLevelCfg)
                 else
                    '0';
SyncLvMatchedIrq(1) <= SyncIRQStatusIn(1) when (PLevel1 = PriorityLevelCfg)
                 else
                    '0';
SyncLvMatchedIrq(2) <= SyncIRQStatusIn(2) when (PLevel2 = PriorityLevelCfg)
                 else
                    '0';
SyncLvMatchedIrq(3) <= SyncIRQStatusIn(3) when (PLevel3 = PriorityLevelCfg)
                 else
                    '0';
SyncLvMatchedIrq(4) <= SyncIRQStatusIn(4) when (PLevel4 = PriorityLevelCfg)
                 else
                    '0';
SyncLvMatchedIrq(5) <= SyncIRQStatusIn(5) when (PLevel5 = PriorityLevelCfg)
                 else
                    '0';
SyncLvMatchedIrq(6) <= SyncIRQStatusIn(6) when (PLevel6 = PriorityLevelCfg)
                 else
                    '0';
SyncLvMatchedIrq(7) <= SyncIRQStatusIn(7) when (PLevel7 = PriorityLevelCfg)
                 else
                    '0';
SyncLvMatchedIrq(8) <= SyncIRQStatusIn(8) when (PLevel8 = PriorityLevelCfg)
                 else
                    '0';
SyncLvMatchedIrq(9) <= SyncIRQStatusIn(9) when (PLevel9 = PriorityLevelCfg)
                 else
                    '0';
SyncLvMatchedIrq(10) <= SyncIRQStatusIn(10) when (PLevel10 = PriorityLevelCfg)
                 else
                    '0';
SyncLvMatchedIrq(11) <= SyncIRQStatusIn(11) when (PLevel11 = PriorityLevelCfg)
                 else
                    '0';
SyncLvMatchedIrq(12) <= SyncIRQStatusIn(12) when (PLevel12 = PriorityLevelCfg)
                 else
                    '0';
SyncLvMatchedIrq(13) <= SyncIRQStatusIn(13) when (PLevel13 = PriorityLevelCfg)
                 else
                    '0';
SyncLvMatchedIrq(14) <= SyncIRQStatusIn(14) when (PLevel14 = PriorityLevelCfg)
                 else
                    '0';
SyncLvMatchedIrq(15) <= SyncIRQStatusIn(15) when (PLevel15 = PriorityLevelCfg)
                 else
                    '0';
SyncLvMatchedIrq(16) <= SyncIRQStatusIn(16) when (PLevel16 = PriorityLevelCfg)
                 else
                    '0';
SyncLvMatchedIrq(17) <= SyncIRQStatusIn(17) when (PLevel17 = PriorityLevelCfg)
                 else
                    '0';
SyncLvMatchedIrq(18) <= SyncIRQStatusIn(18) when (PLevel18 = PriorityLevelCfg)
                 else
                    '0';
SyncLvMatchedIrq(19) <= SyncIRQStatusIn(19) when (PLevel19 = PriorityLevelCfg)
                 else
                    '0';
SyncLvMatchedIrq(20) <= SyncIRQStatusIn(20) when (PLevel20 = PriorityLevelCfg)
                 else
                    '0';
SyncLvMatchedIrq(21) <= SyncIRQStatusIn(21) when (PLevel21 = PriorityLevelCfg)
                 else
                    '0';
SyncLvMatchedIrq(22) <= SyncIRQStatusIn(22) when (PLevel22 = PriorityLevelCfg)
                 else
                    '0';
SyncLvMatchedIrq(23) <= SyncIRQStatusIn(23) when (PLevel23 = PriorityLevelCfg)
                 else
                    '0';
SyncLvMatchedIrq(24) <= SyncIRQStatusIn(24) when (PLevel24 = PriorityLevelCfg)
                 else
                    '0';
SyncLvMatchedIrq(25) <= SyncIRQStatusIn(25) when (PLevel25 = PriorityLevelCfg)
                 else
                    '0';
SyncLvMatchedIrq(26) <= SyncIRQStatusIn(26) when (PLevel26 = PriorityLevelCfg)
                 else
                    '0';
SyncLvMatchedIrq(27) <= SyncIRQStatusIn(27) when (PLevel27 = PriorityLevelCfg)
                 else
                    '0';
SyncLvMatchedIrq(28) <= SyncIRQStatusIn(28) when (PLevel28 = PriorityLevelCfg)
                 else
                    '0';
SyncLvMatchedIrq(29) <= SyncIRQStatusIn(29) when (PLevel29 = PriorityLevelCfg)
                 else
                    '0';
SyncLvMatchedIrq(30) <= SyncIRQStatusIn(30) when (PLevel30 = PriorityLevelCfg)
                 else
                    '0';
SyncLvMatchedIrq(31) <= SyncIRQStatusIn(31) when (PLevel31 = PriorityLevelCfg)
                 else
                    '0';
SyncLvMatchedIrq(32) <= SyncDaisyChainIn when (PLevel32 = PriorityLevelCfg)
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- nIRQ output.
-- If any enabled interrupt is asserted then assert the IrqOutput.
-- -----------------------------------------------------------------------------
p_IrqOutComb : process (LevelMatchedIrq, SWPriorityMask, CurrentLevelMask)
begin
  if (((LevelMatchedIrq /= ZERO33) and (SWPriorityMask = '1')) and
        (CurrentLevelMask = '1')) then
    IrqOutput        <= '1';
  else
    IrqOutput        <= '0';
  end if;
end process p_IrqOutComb;

-- -----------------------------------------------------------------------------
-- nIRQ synchronised output.
-- If any enabled interrupt is asserted then assert the SyncIrqOutput.
-- -----------------------------------------------------------------------------
p_SyncIrqOutComb : process (SyncLvMatchedIrq, SWPriorityMask, CurrentLevelMask)
begin
  if (((SyncLvMatchedIrq /= ZERO33) and (SWPriorityMask = '1')) and
        (CurrentLevelMask = '1')) then
    SyncIrqOutput    <= '1';
  else
    SyncIrqOutput    <= '0';
  end if;
end process p_SyncIrqOutComb;

-- -----------------------------------------------------------------------------
-- PLevel tree
-- If more than one enabled interrupt is asserted then the highest interrupt
-- will be selected and source of the interrupt is stored in the IRQPort.
-- -----------------------------------------------------------------------------
p_DecodeTreeComb : process (SyncLvMatchedIrq, SWPriorityMask, CurrentLevelMask)
begin
  if ((SWPriorityMask = '0') or (CurrentLevelMask = '0')) then
    IRQPort          <= (others => '0');
  elsif (SyncLvMatchedIrq(0) = '1') then
    IRQPort          <= "000000";
  elsif (SyncLvMatchedIrq(1) = '1') then
    IRQPort          <= "000001";
  elsif (SyncLvMatchedIrq(2) = '1') then
    IRQPort          <= "000010";
  elsif (SyncLvMatchedIrq(3) = '1') then
    IRQPort          <= "000011";
  elsif (SyncLvMatchedIrq(4) = '1') then
    IRQPort          <= "000100";
  elsif (SyncLvMatchedIrq(5) = '1') then
    IRQPort          <= "000101";
  elsif (SyncLvMatchedIrq(6) = '1') then
    IRQPort          <= "000110";
  elsif (SyncLvMatchedIrq(7) = '1') then
    IRQPort          <= "000111";
  elsif (SyncLvMatchedIrq(8) = '1') then
    IRQPort          <= "001000";
  elsif (SyncLvMatchedIrq(9) = '1') then
    IRQPort          <= "001001";
  elsif (SyncLvMatchedIrq(10) = '1') then
    IRQPort          <= "001010";
  elsif (SyncLvMatchedIrq(11) = '1') then
    IRQPort          <= "001011";
  elsif (SyncLvMatchedIrq(12) = '1') then
    IRQPort          <= "001100";
  elsif (SyncLvMatchedIrq(13) = '1') then
    IRQPort          <= "001101";
  elsif (SyncLvMatchedIrq(14) = '1') then
    IRQPort          <= "001110";
  elsif (SyncLvMatchedIrq(15) = '1') then
    IRQPort          <= "001111";
  elsif (SyncLvMatchedIrq(16) = '1') then
    IRQPort          <= "010000";
  elsif (SyncLvMatchedIrq(17) = '1') then
    IRQPort          <= "010001";
  elsif (SyncLvMatchedIrq(18) = '1') then
    IRQPort          <= "010010";
  elsif (SyncLvMatchedIrq(19) = '1') then
    IRQPort          <= "010011";
  elsif (SyncLvMatchedIrq(20) = '1') then
    IRQPort          <= "010100";
  elsif (SyncLvMatchedIrq(21) = '1') then
    IRQPort          <= "010101";
  elsif (SyncLvMatchedIrq(22) = '1') then
    IRQPort          <= "010110";
  elsif (SyncLvMatchedIrq(23) = '1') then
    IRQPort          <= "010111";
  elsif (SyncLvMatchedIrq(24) = '1') then
    IRQPort          <= "011000";
  elsif (SyncLvMatchedIrq(25) = '1') then
    IRQPort          <= "011001";
  elsif (SyncLvMatchedIrq(26) = '1') then
    IRQPort          <= "011010";
  elsif (SyncLvMatchedIrq(27) = '1') then
    IRQPort          <= "011011";
  elsif (SyncLvMatchedIrq(28) = '1') then
    IRQPort          <= "011100";
  elsif (SyncLvMatchedIrq(29) = '1') then
    IRQPort          <= "011101";
  elsif (SyncLvMatchedIrq(30) = '1') then
    IRQPort          <= "011110";
  elsif (SyncLvMatchedIrq(31) = '1') then
    IRQPort          <= "011111";
  elsif (SyncLvMatchedIrq(32) = '1') then
    IRQPort          <= "100000";
  else
    IRQPort          <= "000000";
  end if;
end process p_DecodeTreeComb;

-- synopsys translate_off
-- -----------------------------------------------------------------------------
-- START OF PROTOCOL CHECKERS
-- -----------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
-- END OF PROTOCOL CHECKERS
-- -----------------------------------------------------------------------------
-- synopsys translate_on

end synth;

-- --================================== End ==================================--
