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
-- File Name              : VicIntResolver.vhd.rca
-- File Revision          : 1.6
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block resolves the interrupt according to the priority of the
--           interrupt source
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use work.VicPackage.all;

-- -----------------------------------------------------------------------------

entity VicIntResolver is
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB Clock
        HRESETn          : in    std_logic; -- AHB reset
        IrqSync          : in    std_logic_vector(15 downto 0);
                                            -- Synchronous IRQ
        Port0            : in    std_logic_vector(5 downto 0);
                                            -- Priority level of port0
        Port1            : in    std_logic_vector(5 downto 0);
                                            -- Priority level of port1
        Port2            : in    std_logic_vector(5 downto 0);
                                            -- Priority level of port2
        Port3            : in    std_logic_vector(5 downto 0);
                                            -- Priority level of port3
        Port4            : in    std_logic_vector(5 downto 0);
                                            -- Priority level of port4
        Port5            : in    std_logic_vector(5 downto 0);
                                            -- Priority level of port5
        Port6            : in    std_logic_vector(5 downto 0);
                                            -- Priority level of port6
        Port7            : in    std_logic_vector(5 downto 0);
                                            -- Priority level of port7
        Port8            : in    std_logic_vector(5 downto 0);
                                            -- Priority level of port8
        Port9            : in    std_logic_vector(5 downto 0);
                                            -- Priority level of port9
        Port10           : in    std_logic_vector(5 downto 0);
                                            -- Priority level of port10
        Port11           : in    std_logic_vector(5 downto 0);
                                            -- Priority level of port11
        Port12           : in    std_logic_vector(5 downto 0);
                                            -- Priority level of port12
        Port13           : in    std_logic_vector(5 downto 0);
                                            -- Priority level of port13
        Port14           : in    std_logic_vector(5 downto 0);
                                            -- Priority level of port14
        Port15           : in    std_logic_vector(5 downto 0);
                                            -- Priority level of port15
        ITEN             : in    std_logic; -- Integration test enable
        IrqAsync         : in    std_logic_vector(15 downto 0);
                                            -- Asynchronous IRQ
        IRQForceVal      : in    std_logic; -- VICIRQ o/p force value
                                            -- (non-invert)
        CurrentPriority  : in    std_logic_vector(15 downto 0);
                                            -- Current Interrupt priority
        nIRQINForceVal   : in    std_logic; -- nVICIRQIN i/p force value
        nFIQINForceVal   : in    std_logic; -- nVICFIQIN i/p force value
        FIQForceVal      : in    std_logic; -- VICFIQ o/p force value
                                            -- (non-invert)
        nVICIRQIN        : in    std_logic; -- Daisy IRQ chain input
        VICIRQINREG      : in    std_logic; -- IRQ daisy chain input config
        nVICFIQIN        : in    std_logic; -- Daisy FIQ chain input
        VICFIQINREG      : in    std_logic; -- FIQ daisy chain input config
        VICSoftInt       : in    std_logic_vector(31 downto 0);
                                            -- Software interrupt source
        VICINTSOURCE     : in    std_logic_vector(31 downto 0);
                                            -- Interrupt source
        VICIntEnable     : in    std_logic_vector(31 downto 0);
                                            -- Interupt Enable
        VICIntSelect     : in    std_logic_vector(31 downto 0);
                                            -- Interupt Type

-- Outputs
        FIQTestVal       : out   std_logic; -- VICFIQ o/p force value
                                            -- (non-invert)
        nIRQINTestVal    : out   std_logic; -- nVICIRQIN i/p force value
        nFIQINTestVal    : out   std_logic; -- nVICFIQIN i/p force value
        nVICIRQ          : out   std_logic; -- Asynchronous IRQ output
        nVICFIQ          : out   std_logic; -- Asynchronous FIQ output
        IRQPortRes       : out   std_logic_vector(5 downto 0);
                                            -- Resolved IRQ source
        IRQRequestRes    : out   std_logic; -- Synchronized IRQ request
        IRQReqLevelRes   : out   std_logic_vector(3 downto 0);
                                            -- Priority level of current IRQ
                                            -- request
        IRQTestVal       : out   std_logic; -- VICIRQ o/p force value
                                            -- (non-invert)
        DaisyChainIn     : out   std_logic; -- DaisyChain input after mux with
                                            -- test signal
        Sync2DaisyIn     : out   std_logic; -- 2nd flip-flop for
                                            -- synchronization of
                                            -- DaisyChainIn
        Sync2IrqStatus   : out   std_logic_vector(31 downto 0);
                                            -- Second flip-flop stage
        CurrentLevelMask : out   std_logic_vector(15 downto 0);
                                            -- Mask due to current interrupt
                                            -- priority
                                            -- level
        VICFIQStatus     : out   std_logic_vector(31 downto 0);
                                            -- Status of the FIQ after
                                            -- disabling
                                            -- the interrupt
        VICIRQStatus     : out   std_logic_vector(31 downto 0);
                                            -- Status of the FIQ after
                                            -- disabling
                                            -- the interrupt
        VICRawIntr       : out   std_logic_vector(31 downto 0)
                                            -- Status of the interrupts before
                                            -- masking
       );
end VicIntResolver;

-- -----------------------------------------------------------------------------
--
--                               VicIntResolver
--                               ==============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- This block does the following functionalities,
-- - Resolves the interrupts according to the priority.
--     When there are more than one interrupts asserted, then the interrupts are
--     resolved according to the priority programmed.
-- - It generates VICRAWINTR, VICIRQSTATUS, VICFIQSTATUS which are the
-- contents of the registers.
-- - It also generates nVICIRQ and nVICFIQ asynchronously.
--
-- -----------------------------------------------------------------------------

-- --============================ ARCHITECTURE ==============================--

architecture synth of VicIntResolver is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal nVICIRQINtmux    : std_logic;
-- Test mux for nVICIRQIN

signal nVICFIQINtmux    : std_logic;
-- Test mux for nVICFIQIN

signal nVICIRQINmux     : std_logic;
-- Clocked or unclocked nVICIRQINtmux depending on VICIRQINREG

signal VICIRQtmux       : std_logic;
-- Test mux for VICIRQ

signal nVICFIQINmux     : std_logic;
-- Clocked or unclocked nVICFIQINtmux depending on VICFIQINREG

signal iDaisyChainIn    : std_logic;
-- Internal version of the DaisyChainIn

signal nVICIRQINQ       : std_logic;
-- Registered nVICIRQIN test mux output

signal nVICFIQINQ       : std_logic;
-- Registered nVICFIQIN test mux output

signal VICFIQtmux       : std_logic;
-- Test mux for VICFIQ

signal Sync1DaisyIn     : std_logic;
-- 1st flip-flop for synchronization of DaisyChainIn

signal MaskedRawIntr    : std_logic_vector(31 downto 0);
-- Masked raw interrupt

signal iIrqStatus       : std_logic_vector(31 downto 0);
-- Internal version of VICIRQStatus

signal iFiqStatus       : std_logic_vector(31 downto 0);
-- Internal version of VICIFQStatus

signal RawIntr          : std_logic_vector(31 downto 0);
-- Raw interrupt status

signal Sync1IrqStatus   : std_logic_vector(31 downto 0);
-- First flip-flop stage

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
-- Determine which level of IRQ to be accepted
-- -----------------------------------------------------------------------------
p_FinalDecodeComb : process (IrqSync, Port0, Port1, Port2, Port3, Port4,
                             Port5, Port6, Port7, Port8, Port9, Port10,
                             Port11, Port12, Port13, Port14, Port15)
begin
  if (IrqSync(0) = '1') then
    IRQPortRes       <= Port0;
    IRQRequestRes    <= '1';
    IRQReqLevelRes   <= "0000";
  elsif (IrqSync(1) = '1') then
    IRQPortRes       <= Port1;
    IRQRequestRes    <= '1';
    IRQReqLevelRes   <= "0001";
  elsif (IrqSync(2) = '1') then
    IRQPortRes       <= Port2;
    IRQRequestRes    <= '1';
    IRQReqLevelRes   <= "0010";
  elsif (IrqSync(3) = '1') then
    IRQPortRes       <= Port3;
    IRQRequestRes    <= '1';
    IRQReqLevelRes   <= "0011";
  elsif (IrqSync(4) = '1') then
    IRQPortRes       <= Port4;
    IRQRequestRes    <= '1';
    IRQReqLevelRes   <= "0100";
  elsif (IrqSync(5) = '1') then
    IRQPortRes       <= Port5;
    IRQRequestRes    <= '1';
    IRQReqLevelRes   <= "0101";
  elsif (IrqSync(6) = '1') then
    IRQPortRes       <= Port6;
    IRQRequestRes    <= '1';
    IRQReqLevelRes   <= "0110";
  elsif (IrqSync(7) = '1') then
    IRQPortRes       <= Port7;
    IRQRequestRes    <= '1';
    IRQReqLevelRes   <= "0111";
  elsif (IrqSync(8) = '1') then
    IRQPortRes       <= Port8;
    IRQRequestRes    <= '1';
    IRQReqLevelRes   <= "1000";
  elsif (IrqSync(9) = '1') then
    IRQPortRes       <= Port9;
    IRQRequestRes    <= '1';
    IRQReqLevelRes   <= "1001";
  elsif (IrqSync(10) = '1') then
    IRQPortRes       <= Port10;
    IRQRequestRes    <= '1';
    IRQReqLevelRes   <= "1010";
  elsif (IrqSync(11) = '1') then
    IRQPortRes       <= Port11;
    IRQRequestRes    <= '1';
    IRQReqLevelRes   <= "1011";
  elsif (IrqSync(12) = '1') then
    IRQPortRes       <= Port12;
    IRQRequestRes    <= '1';
    IRQReqLevelRes   <= "1100";
  elsif (IrqSync(13) = '1') then
    IRQPortRes       <= Port13;
    IRQRequestRes    <= '1';
    IRQReqLevelRes   <= "1101";
  elsif (IrqSync(14) = '1') then
    IRQPortRes       <= Port14;
    IRQRequestRes    <= '1';
    IRQReqLevelRes   <= "1110";
  elsif (IrqSync(15) = '1') then
    IRQPortRes       <= Port15;
    IRQRequestRes    <= '1';
    IRQReqLevelRes   <= "1111";
  else
    IRQPortRes       <= (others => '0');
    IRQRequestRes    <= '0';
    IRQReqLevelRes   <= "1111";
  end if;
end process p_FinalDecodeComb;

-- -----------------------------------------------------------------------------
-- Generate the VICIRQtmux, pre inverted version of nVICIRQ.
-- When ITEN is high pass the force value. Else if there is any interrupt
-- then, assert the VICIRQtmux. Once the interrupt gets the acknowledge from the
-- CPU for the address read then the interrupt is deasserted.
-- If there is any interrupt higher than the currently servicing interrupt is
-- asserted then VICIRQtmux is asserted.
-- -----------------------------------------------------------------------------
VICIRQtmux       <= IRQForceVal when (ITEN = '1')
                 else
                    '0' when (IrqAsync = "0000000000000000")
                 else
                    '1';

-- -----------------------------------------------------------------------------
-- Connect to top level
-- -----------------------------------------------------------------------------
nVICIRQ  <= not(VICIRQtmux);
IRQTestVal  <= VICIRQtmux;

-- -----------------------------------------------------------------------------
-- Generate current priority mask depending on the priority of the currently
-- servicing interrupt.
-- -----------------------------------------------------------------------------
p_CurrLvlMaskComb : process (CurrentPriority)
begin
  if (CurrentPriority(0) = '1') then
    CurrentLevelMask <= "0000000000000000";
  elsif (CurrentPriority(1) = '1') then
    CurrentLevelMask <= "0000000000000001";
  elsif (CurrentPriority(2) = '1') then
    CurrentLevelMask <= "0000000000000011";
  elsif (CurrentPriority(3) = '1') then
    CurrentLevelMask <= "0000000000000111";
  elsif (CurrentPriority(4) = '1') then
    CurrentLevelMask <= "0000000000001111";
  elsif (CurrentPriority(5) = '1') then
    CurrentLevelMask <= "0000000000011111";
  elsif (CurrentPriority(6) = '1') then
    CurrentLevelMask <= "0000000000111111";
  elsif (CurrentPriority(7) = '1') then
    CurrentLevelMask <= "0000000001111111";
  elsif (CurrentPriority(8) = '1') then
    CurrentLevelMask <= "0000000011111111";
  elsif (CurrentPriority(9) = '1') then
    CurrentLevelMask <= "0000000111111111";
  elsif (CurrentPriority(10) = '1') then
    CurrentLevelMask <= "0000001111111111";
  elsif (CurrentPriority(11) = '1') then
    CurrentLevelMask <= "0000011111111111";
  elsif (CurrentPriority(12) = '1') then
    CurrentLevelMask <= "0000111111111111";
  elsif (CurrentPriority(13) = '1') then
    CurrentLevelMask <= "0001111111111111";
  elsif (CurrentPriority(14) = '1') then
    CurrentLevelMask <= "0011111111111111";
  elsif (CurrentPriority(15) = '1') then
    CurrentLevelMask <= "0111111111111111";
  else
    CurrentLevelMask <= "1111111111111111";
  end if;
end process p_CurrLvlMaskComb;

-- -----------------------------------------------------------------------------
-- IRQ daisy chain input Integration Test multiplexer
-- -----------------------------------------------------------------------------
nVICIRQINtmux    <= nIRQINForceVal when (ITEN = '1')
                 else
                    nVICIRQIN;

-- -----------------------------------------------------------------------------
-- Determine if input should be registered
-- -----------------------------------------------------------------------------
nVICIRQINmux     <= nVICIRQINQ when (VICIRQINREG = '1')
                 else
                    nVICIRQINtmux;

-- -----------------------------------------------------------------------------
-- Connect to priority encoding logic
-- -----------------------------------------------------------------------------
iDaisyChainIn  <= not(nVICIRQINmux);

-- -----------------------------------------------------------------------------
-- Connect to top level for read back
-- -----------------------------------------------------------------------------
nIRQINTestVal  <= nVICIRQINmux;

-- -----------------------------------------------------------------------------
-- Registered daisy chain IRQ and FIQ.
-- -----------------------------------------------------------------------------
p_RegDaisyChainSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    nVICIRQINQ       <= '1';
    nVICFIQINQ       <= '1';
  elsif (HCLK'event and HCLK = '1') then
    nVICFIQINQ       <= nVICFIQINtmux;
    nVICIRQINQ       <= nVICIRQINtmux;
  end if;
end process p_RegDaisyChainSeq;

-- -----------------------------------------------------------------------------
-- FIQ daisy chain input Integration Test multiplexer
-- -----------------------------------------------------------------------------
nVICFIQINtmux    <= nFIQINForceVal when (ITEN = '1')
                 else
                    nVICFIQIN;

-- -----------------------------------------------------------------------------
-- Determine if input should be registered
-- -----------------------------------------------------------------------------
nVICFIQINmux     <= nVICFIQINQ when (VICFIQINREG = '1')
                 else
                    nVICFIQINtmux;

-- -----------------------------------------------------------------------------
-- Connect to top level for read back
-- -----------------------------------------------------------------------------
nFIQINTestVal  <= nVICFIQINmux;

-- -----------------------------------------------------------------------------
-- Combine with Software interrupt
-- -----------------------------------------------------------------------------
RawIntr  <= (VICINTSOURCE or VICSoftInt);

-- -----------------------------------------------------------------------------
-- Interrupt enable mask
-- -----------------------------------------------------------------------------
MaskedRawIntr  <= (RawIntr and VICIntEnable);

-- -----------------------------------------------------------------------------
-- FIQ group
-- -----------------------------------------------------------------------------
iFiqStatus  <= (MaskedRawIntr and VICIntSelect);

-- -----------------------------------------------------------------------------
-- IRQ group
-- -----------------------------------------------------------------------------
iIrqStatus  <= (MaskedRawIntr and not(VICIntSelect));

-- -----------------------------------------------------------------------------
-- Connecting status to top level
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- FIQ status for read back
-- -----------------------------------------------------------------------------
VICFIQStatus  <= iFiqStatus;

-- -----------------------------------------------------------------------------
-- IRQ status for read back
-- -----------------------------------------------------------------------------
VICIRQStatus  <= iIrqStatus;

-- -----------------------------------------------------------------------------
-- RAW interrupt status for read back
-- -----------------------------------------------------------------------------
VICRawIntr  <= RawIntr;

-- -----------------------------------------------------------------------------
-- FIQ output
-- In test mode, select the integration test value. If any one of the interrupt
-- is asserted, assert the FIQ. If the daisy chain interrupt is asserted select
-- the daisy chain FIQ.
-- -----------------------------------------------------------------------------
p_FIQoutputComb : process (iFiqStatus, nVICFIQINmux, ITEN, FIQForceVal)
begin
  if (ITEN = '1') then
    VICFIQtmux       <= FIQForceVal;
  else
    if (iFiqStatus /= ZERO32) then
      VICFIQtmux       <= '1';
    else
      VICFIQtmux       <= not(nVICFIQINmux);
    end if;
  end if;
end process p_FIQoutputComb;

-- -----------------------------------------------------------------------------
-- Connect to top level
-- -----------------------------------------------------------------------------
FIQTestVal   <= VICFIQtmux;
nVICFIQ      <= not(VICFIQtmux);
DaisyChainIn <= iDaisyChainIn;

-- -----------------------------------------------------------------------------
-- Synchronize interrupt signals to HCLK
-- -----------------------------------------------------------------------------
p_Sync2HCLKSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    Sync1DaisyIn     <= '0';
    Sync2DaisyIn     <= '0';
    Sync1IrqStatus   <= (others => '0');
    Sync2IrqStatus   <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    Sync1DaisyIn     <= iDaisyChainIn;
    Sync2DaisyIn     <= Sync1DaisyIn;
    Sync1IrqStatus   <= iIrqStatus;
    Sync2IrqStatus   <= Sync1IrqStatus;
  end if;
end process p_Sync2HCLKSeq;

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
