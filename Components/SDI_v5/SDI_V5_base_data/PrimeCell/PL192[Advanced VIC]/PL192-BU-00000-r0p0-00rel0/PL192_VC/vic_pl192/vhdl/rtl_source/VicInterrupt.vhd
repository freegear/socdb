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
-- File Name              : VicInterrupt.vhd.rca
-- File Revision          : 1.14
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block is the top level of interrupt processing
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use work.VicPackage.all;

-- -----------------------------------------------------------------------------

entity VicInterrupt is
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB Clock
        HRESETn          : in    std_logic; -- AHB reset
        VICINTSOURCE     : in    std_logic_vector(31 downto 0);
                                            -- Interrupt source
        VICSoftInt       : in    std_logic_vector(31 downto 0);
                                            -- Software interrupt source
        nVICIRQIN        : in    std_logic; -- Daisy chain IRQ input
        nVICFIQIN        : in    std_logic; -- Daisy chain FIQ input
        VICFIQINREG      : in    std_logic; -- Register enable signal
                                            -- for VICFIQIN
        VICIRQINREG      : in    std_logic; -- Register enable signal
                                            -- for VICIRQIN
        VICIntEnable     : in    std_logic_vector(31 downto 0);
                                            -- Interrupt Enable
        VICIntSelect     : in    std_logic_vector(31 downto 0);
                                            -- Interrupt Type
        SWPriorityMask   : in    std_logic_vector(15 downto 0);
                                            -- Software priority level mask
        PLevel0          : in    std_logic_vector(3 downto 0);
                                            -- Priority settings for 0th
                                            -- interrupt source
        PLevel1          : in    std_logic_vector(3 downto 0);
                                            -- Priority settings for 1st
                                            -- interrupt source
        PLevel2          : in    std_logic_vector(3 downto 0);
                                            -- Priority settings for 2nd
                                            -- interrupt source
        PLevel3          : in    std_logic_vector(3 downto 0);
                                            -- Priority settings for 3rd
                                            -- interrupt source
        PLevel4          : in    std_logic_vector(3 downto 0);
                                            -- Priority settings for 4th
                                            -- interrupt source
        PLevel5          : in    std_logic_vector(3 downto 0);
                                            -- Priority settings for 5th
                                            -- interrupt source
        PLevel6          : in    std_logic_vector(3 downto 0);
                                            -- Priority settings for 6th
                                            -- interrupt source
        PLevel7          : in    std_logic_vector(3 downto 0);
                                            -- Priority settings for 7th
                                            -- interrupt source
        PLevel8          : in    std_logic_vector(3 downto 0);
                                            -- Priority settings for 8th
                                            -- interrupt source
        PLevel9          : in    std_logic_vector(3 downto 0);
                                            -- Priority settings for 9th
                                            -- interrupt source
        PLevel10         : in    std_logic_vector(3 downto 0);
                                            -- Priority settings for 10th
                                            -- interrupt source
        PLevel11         : in    std_logic_vector(3 downto 0);
                                            -- Priority settings for 11th
                                            -- interrupt source
        PLevel12         : in    std_logic_vector(3 downto 0);
                                            -- Priority settings for 12th
                                            -- interrupt source
        PLevel13         : in    std_logic_vector(3 downto 0);
                                            -- Priority settings for 13th
                                            -- interrupt source
        PLevel14         : in    std_logic_vector(3 downto 0);
                                            -- Priority settings for 14th
                                            -- interrupt source
        PLevel15         : in    std_logic_vector(3 downto 0);
                                            -- Priority settings for 15th
                                            -- interrupt source
        PLevel16         : in    std_logic_vector(3 downto 0);
                                            -- Priority settings for 16th
                                            -- interrupt source
        PLevel17         : in    std_logic_vector(3 downto 0);
                                            -- Priority settings for 17th
                                            -- interrupt source
        PLevel18         : in    std_logic_vector(3 downto 0);
                                            -- Priority settings for 18th
                                            -- interrupt source
        PLevel19         : in    std_logic_vector(3 downto 0);
                                            -- Priority settings for 19th
                                            -- interrupt source
        PLevel20         : in    std_logic_vector(3 downto 0);
                                            -- Priority settings for 20th
                                            -- interrupt source
        PLevel21         : in    std_logic_vector(3 downto 0);
                                            -- Priority settings for 21st
                                            -- interrupt source
        PLevel22         : in    std_logic_vector(3 downto 0);
                                            -- Priority settings for 22nd
                                            -- interrupt source
        PLevel23         : in    std_logic_vector(3 downto 0);
                                            -- Priority settings for 23rd
                                            -- interrupt source
        PLevel24         : in    std_logic_vector(3 downto 0);
                                            -- Priority settings for 24th
                                            -- interrupt source
        PLevel25         : in    std_logic_vector(3 downto 0);
                                            -- Priority settings for 25th
                                            -- interrupt source
        PLevel26         : in    std_logic_vector(3 downto 0);
                                            -- Priority settings for 26th
                                            -- interrupt source
        PLevel27         : in    std_logic_vector(3 downto 0);
                                            -- Priority settings for 27th
                                            -- interrupt source
        PLevel28         : in    std_logic_vector(3 downto 0);
                                            -- Priority settings for 28th
                                            -- interrupt source
        PLevel29         : in    std_logic_vector(3 downto 0);
                                            -- Priority settings for 29th
                                            -- interrupt source
        PLevel30         : in    std_logic_vector(3 downto 0);
                                            -- Priority settings for 30th
                                            -- interrupt source
        PLevel31         : in    std_logic_vector(3 downto 0);
                                            -- Priority settings for 31st
                                            -- interrupt source
        PLevel32         : in    std_logic_vector(3 downto 0);
                                            -- Priority settings for 32nd
                                            -- interrupt source
        CurrentPriority  : in    std_logic_vector(15 downto 0);
                                            -- Current Interrupt
-- Test signal
        ITEN             : in    std_logic; -- Integration test enable
        nIRQINForceVal   : in    std_logic; -- nVICIRQIN i/p force value
        nFIQINForceVal   : in    std_logic; -- nVICFIQIN i/p force value
        IRQForceVal      : in    std_logic; -- VICIRQ o/p force value
                                            -- (non-invert)
        FIQForceVal      : in    std_logic; -- VICFIQ o/p force value
                                            -- (non-invert)

-- Outputs
-- Test output
        nIRQINTestVal    : out   std_logic; -- nVICIRQIN i/p read back value
        nFIQINTestVal    : out   std_logic; -- nVICFIQIN i/p read back value
        IRQTestVal       : out   std_logic; -- VICIRQ o/p read back value
                                            -- (non-invert)
        FIQTestVal       : out   std_logic; -- VICFIQ o/p read back value
                                            -- (non-invert)
-- Interrupt outputs
        nVICFIQ          : out   std_logic; -- asynchronous FIQ output
        nVICIRQ          : out   std_logic; -- asynchronous IRQ output
-- To VicCpuif
        IRQRequestRes    : out   std_logic; -- Resolved synchronised IRQ
                                            -- request
        IRQPortRes       : out   std_logic_vector(5 downto 0);
                                            -- Resolved IRQ source
                                            -- 0 to 31, VICINTSOURCE(0 to 31)
                                            -- 32, Daisy chain input
        IRQReqLevelRes   : out   std_logic_vector(3 downto 0);
                                            -- Resolved priority level of
                                            -- current
                                            -- IRQ request
-- Status (asynchronous) to AHBif
        VICRawIntr       : out   std_logic_vector(31 downto 0);
                                            -- Status of the interrupts before
                                            -- masking
        VICFIQStatus     : out   std_logic_vector(31 downto 0);
                                            -- Status of the FIQ after
                                            -- disabling
                                            -- the interrupt
        VICIRQStatus     : out   std_logic_vector(31 downto 0)
                                            -- Status of the FIQ after
                                            -- disabling
                                            -- the interrupt
       );
end VicInterrupt;

-- -----------------------------------------------------------------------------
--
--                                VicInterrupt
--                                ============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- In this block, VicPriority module and VicIntResolver module are instantiated.
-- There are sixteen instantiations of VicPriority module. Each instantiation
-- corresponds to one priority level. If there is more than one interrupt with
-- same priority level then interrupts are resolved according to the hardware
-- priority. VicIntResolver resolves the interrupts according to the priority of
-- the interrupt programmed.
--
-- -----------------------------------------------------------------------------

-- --============================= ARCHITECTURE ==============================--

architecture synth of VicInterrupt is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- VicPriority
-- -----------------------------------------------------------------------------
component VicPriority
  port (
        IRQStatusIn      : in    std_logic_vector(31 downto 0);
        DaisyChainIn     : in    std_logic;
        SyncIRQStatusIn  : in    std_logic_vector(31 downto 0);
        SyncDaisyChainIn : in    std_logic;
        SWPriorityMask   : in    std_logic;
        CurrentLevelMask : in    std_logic;
        PLevel0          : in    std_logic_vector(3 downto 0);
        PLevel1          : in    std_logic_vector(3 downto 0);
        PLevel2          : in    std_logic_vector(3 downto 0);
        PLevel3          : in    std_logic_vector(3 downto 0);
        PLevel4          : in    std_logic_vector(3 downto 0);
        PLevel5          : in    std_logic_vector(3 downto 0);
        PLevel6          : in    std_logic_vector(3 downto 0);
        PLevel7          : in    std_logic_vector(3 downto 0);
        PLevel8          : in    std_logic_vector(3 downto 0);
        PLevel9          : in    std_logic_vector(3 downto 0);
        PLevel10         : in    std_logic_vector(3 downto 0);
        PLevel11         : in    std_logic_vector(3 downto 0);
        PLevel12         : in    std_logic_vector(3 downto 0);
        PLevel13         : in    std_logic_vector(3 downto 0);
        PLevel14         : in    std_logic_vector(3 downto 0);
        PLevel15         : in    std_logic_vector(3 downto 0);
        PLevel16         : in    std_logic_vector(3 downto 0);
        PLevel17         : in    std_logic_vector(3 downto 0);
        PLevel18         : in    std_logic_vector(3 downto 0);
        PLevel19         : in    std_logic_vector(3 downto 0);
        PLevel20         : in    std_logic_vector(3 downto 0);
        PLevel21         : in    std_logic_vector(3 downto 0);
        PLevel22         : in    std_logic_vector(3 downto 0);
        PLevel23         : in    std_logic_vector(3 downto 0);
        PLevel24         : in    std_logic_vector(3 downto 0);
        PLevel25         : in    std_logic_vector(3 downto 0);
        PLevel26         : in    std_logic_vector(3 downto 0);
        PLevel27         : in    std_logic_vector(3 downto 0);
        PLevel28         : in    std_logic_vector(3 downto 0);
        PLevel29         : in    std_logic_vector(3 downto 0);
        PLevel30         : in    std_logic_vector(3 downto 0);
        PLevel31         : in    std_logic_vector(3 downto 0);
        PLevel32         : in    std_logic_vector(3 downto 0);
        PriorityLevelCfg : in    std_logic_vector(3 downto 0);
        IrqOutput        : out   std_logic;
        SyncIrqOutput    : out   std_logic;
        IRQPort          : out   std_logic_vector(5 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- VicIntResolver
-- -----------------------------------------------------------------------------
component VicIntResolver
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        IrqSync          : in    std_logic_vector(15 downto 0);
        Port0            : in    std_logic_vector(5 downto 0);
        Port1            : in    std_logic_vector(5 downto 0);
        Port2            : in    std_logic_vector(5 downto 0);
        Port3            : in    std_logic_vector(5 downto 0);
        Port4            : in    std_logic_vector(5 downto 0);
        Port5            : in    std_logic_vector(5 downto 0);
        Port6            : in    std_logic_vector(5 downto 0);
        Port7            : in    std_logic_vector(5 downto 0);
        Port8            : in    std_logic_vector(5 downto 0);
        Port9            : in    std_logic_vector(5 downto 0);
        Port10           : in    std_logic_vector(5 downto 0);
        Port11           : in    std_logic_vector(5 downto 0);
        Port12           : in    std_logic_vector(5 downto 0);
        Port13           : in    std_logic_vector(5 downto 0);
        Port14           : in    std_logic_vector(5 downto 0);
        Port15           : in    std_logic_vector(5 downto 0);
        ITEN             : in    std_logic;
        IrqAsync         : in    std_logic_vector(15 downto 0);
        IRQForceVal      : in    std_logic;
        CurrentPriority  : in    std_logic_vector(15 downto 0);
        nIRQINForceVal   : in    std_logic;
        nFIQINForceVal   : in    std_logic;
        FIQForceVal      : in    std_logic;
        nVICIRQIN        : in    std_logic;
        VICIRQINREG      : in    std_logic;
        nVICFIQIN        : in    std_logic;
        VICFIQINREG      : in    std_logic;
        VICSoftInt       : in    std_logic_vector(31 downto 0);
        VICINTSOURCE     : in    std_logic_vector(31 downto 0);
        VICIntEnable     : in    std_logic_vector(31 downto 0);
        VICIntSelect     : in    std_logic_vector(31 downto 0);
        FIQTestVal       : out   std_logic;
        nIRQINTestVal    : out   std_logic;
        nFIQINTestVal    : out   std_logic;
        nVICIRQ          : out   std_logic;
        nVICFIQ          : out   std_logic;
        IRQPortRes       : out   std_logic_vector(5 downto 0);
        IRQRequestRes    : out   std_logic;
        IRQReqLevelRes   : out   std_logic_vector(3 downto 0);
        IRQTestVal       : out   std_logic;
        DaisyChainIn     : out   std_logic;
        Sync2DaisyIn     : out   std_logic;
        Sync2IrqStatus   : out   std_logic_vector(31 downto 0);
        CurrentLevelMask : out   std_logic_vector(15 downto 0);
        VICFIQStatus     : out   std_logic_vector(31 downto 0);
        VICIRQStatus     : out   std_logic_vector(31 downto 0);
        VICRawIntr       : out   std_logic_vector(31 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal DaisyChainIn     : std_logic;
-- DaisyChain input after mux with test signal

signal IrqAsync         : std_logic_vector(15 downto 0);
-- asynchronous IRQ

signal IrqSync          : std_logic_vector(15 downto 0);
-- synchronous IRQ

signal Port0            : std_logic_vector(5 downto 0);
-- Priority level of port0

signal Port1            : std_logic_vector(5 downto 0);
-- Priority level of port1

signal Port2            : std_logic_vector(5 downto 0);
-- Priority level of port2

signal Port3            : std_logic_vector(5 downto 0);
-- Priority level of port3

signal Port4            : std_logic_vector(5 downto 0);
-- Priority level of port4

signal Port5            : std_logic_vector(5 downto 0);
-- Priority level of port5

signal Port6            : std_logic_vector(5 downto 0);
-- Priority level of port6

signal Port7            : std_logic_vector(5 downto 0);
-- Priority level of port7

signal Port8            : std_logic_vector(5 downto 0);
-- Priority level of port8

signal Port9            : std_logic_vector(5 downto 0);
-- Priority level of port9

signal Port10           : std_logic_vector(5 downto 0);
-- Priority level of port10

signal Port11           : std_logic_vector(5 downto 0);
-- Priority level of port11

signal Port12           : std_logic_vector(5 downto 0);
-- Priority level of port12

signal Port13           : std_logic_vector(5 downto 0);
-- Priority level of port13

signal Port14           : std_logic_vector(5 downto 0);
-- Priority level of port14

signal Port15           : std_logic_vector(5 downto 0);
-- Priority level of port15

signal Sync2DaisyIn     : std_logic;
-- 2nd flip-flop for synchronisation of DaisyChainIn

signal CurrentLevelMask : std_logic_vector(15 downto 0);
-- Mask due to current interrupt priority level

signal Sync2IrqStatus   : std_logic_vector(31 downto 0);
-- Second flip-flop stage

signal iVICIRQStatus    : std_logic_vector(31 downto 0);
-- Internal version of VICIRQStatus

signal Config0          : std_logic_vector(3 downto 0);
-- Priority level 0

signal Config1          : std_logic_vector(3 downto 0);
-- Priority level 1

signal Config2          : std_logic_vector(3 downto 0);
-- Priority level 2

signal Config3          : std_logic_vector(3 downto 0);
-- Priority level 3

signal Config4          : std_logic_vector(3 downto 0);
-- Priority level 4

signal Config5          : std_logic_vector(3 downto 0);
-- Priority level 5

signal Config6          : std_logic_vector(3 downto 0);
-- Priority level 6

signal Config7          : std_logic_vector(3 downto 0);
-- Priority level 7

signal Config8          : std_logic_vector(3 downto 0);
-- Priority level 8

signal Config9          : std_logic_vector(3 downto 0);
-- Priority level 9

signal Config10         : std_logic_vector(3 downto 0);
-- Priority level 10

signal Config11         : std_logic_vector(3 downto 0);
-- Priority level 11

signal Config12         : std_logic_vector(3 downto 0);
-- Priority level 12

signal Config13         : std_logic_vector(3 downto 0);
-- Priority level 13

signal Config14         : std_logic_vector(3 downto 0);
-- Priority level 14

signal Config15         : std_logic_vector(3 downto 0);
-- Priority level 15

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
-- Priority levels
-- -----------------------------------------------------------------------------
Config0      <= CFG0;
Config1      <= CFG1;
Config2      <= CFG2;
Config3      <= CFG3;
Config4      <= CFG4;
Config5      <= CFG5;
Config6      <= CFG6;
Config7      <= CFG7;
Config8      <= CFG8;
Config9      <= CFG9;
Config10     <= CFG10;
Config11     <= CFG11;
Config12     <= CFG12;
Config13     <= CFG13;
Config14     <= CFG14;
Config15     <= CFG15;
-- -----------------------------------------------------------------------------
-- Priority Encoding for level 0
-- -----------------------------------------------------------------------------
u0VicPriority : VicPriority
  port map (
-- Inputs

-- Interrupt signals
            IRQStatusIn      => iVICIRQStatus,
            DaisyChainIn     => DaisyChainIn,
            SyncIRQStatusIn  => Sync2IrqStatus,
            SyncDaisyChainIn => Sync2DaisyIn,
            SWPriorityMask   => SWPriorityMask(0),
            CurrentLevelMask => CurrentLevelMask(0),
-- Priority levels
            PLevel0          => PLevel0,
            PLevel1          => PLevel1,
            PLevel2          => PLevel2,
            PLevel3          => PLevel3,
            PLevel4          => PLevel4,
            PLevel5          => PLevel5,
            PLevel6          => PLevel6,
            PLevel7          => PLevel7,
            PLevel8          => PLevel8,
            PLevel9          => PLevel9,
            PLevel10         => PLevel10,
            PLevel11         => PLevel11,
            PLevel12         => PLevel12,
            PLevel13         => PLevel13,
            PLevel14         => PLevel14,
            PLevel15         => PLevel15,
            PLevel16         => PLevel16,
            PLevel17         => PLevel17,
            PLevel18         => PLevel18,
            PLevel19         => PLevel19,
            PLevel20         => PLevel20,
            PLevel21         => PLevel21,
            PLevel22         => PLevel22,
            PLevel23         => PLevel23,
            PLevel24         => PLevel24,
            PLevel25         => PLevel25,
            PLevel26         => PLevel26,
            PLevel27         => PLevel27,
            PLevel28         => PLevel28,
            PLevel29         => PLevel29,
            PLevel30         => PLevel30,
            PLevel31         => PLevel31,
            PLevel32         => PLevel32,
            PriorityLevelCfg => Config0,

-- Outputs
            IrqOutput        => IrqAsync(0),
            SyncIrqOutput    => IrqSync(0),
            IRQPort          => Port0
           );
-- -----------------------------------------------------------------------------
-- Priority Encoding for level 1
-- -----------------------------------------------------------------------------
u1VicPriority : VicPriority
  port map (
-- Inputs

-- Interrupt signals
            IRQStatusIn      => iVICIRQStatus,
            DaisyChainIn     => DaisyChainIn,
            SyncIRQStatusIn  => Sync2IrqStatus,
            SyncDaisyChainIn => Sync2DaisyIn,
            SWPriorityMask   => SWPriorityMask(1),
            CurrentLevelMask => CurrentLevelMask(1),
-- Priority levels
            PLevel0          => PLevel0,
            PLevel1          => PLevel1,
            PLevel2          => PLevel2,
            PLevel3          => PLevel3,
            PLevel4          => PLevel4,
            PLevel5          => PLevel5,
            PLevel6          => PLevel6,
            PLevel7          => PLevel7,
            PLevel8          => PLevel8,
            PLevel9          => PLevel9,
            PLevel10         => PLevel10,
            PLevel11         => PLevel11,
            PLevel12         => PLevel12,
            PLevel13         => PLevel13,
            PLevel14         => PLevel14,
            PLevel15         => PLevel15,
            PLevel16         => PLevel16,
            PLevel17         => PLevel17,
            PLevel18         => PLevel18,
            PLevel19         => PLevel19,
            PLevel20         => PLevel20,
            PLevel21         => PLevel21,
            PLevel22         => PLevel22,
            PLevel23         => PLevel23,
            PLevel24         => PLevel24,
            PLevel25         => PLevel25,
            PLevel26         => PLevel26,
            PLevel27         => PLevel27,
            PLevel28         => PLevel28,
            PLevel29         => PLevel29,
            PLevel30         => PLevel30,
            PLevel31         => PLevel31,
            PLevel32         => PLevel32,
            PriorityLevelCfg => Config1,

-- Outputs
            IrqOutput        => IrqAsync(1),
            SyncIrqOutput    => IrqSync(1),
            IRQPort          => Port1
           );

-- -----------------------------------------------------------------------------
-- Priority Encoding for level 2
-- -----------------------------------------------------------------------------
u2VicPriority : VicPriority
  port map (
-- Inputs

-- Interrupt signals
            IRQStatusIn      => iVICIRQStatus,
            DaisyChainIn     => DaisyChainIn,
            SyncIRQStatusIn  => Sync2IrqStatus,
            SyncDaisyChainIn => Sync2DaisyIn,
            SWPriorityMask   => SWPriorityMask(2),
            CurrentLevelMask => CurrentLevelMask(2),
-- Priority levels
            PLevel0          => PLevel0,
            PLevel1          => PLevel1,
            PLevel2          => PLevel2,
            PLevel3          => PLevel3,
            PLevel4          => PLevel4,
            PLevel5          => PLevel5,
            PLevel6          => PLevel6,
            PLevel7          => PLevel7,
            PLevel8          => PLevel8,
            PLevel9          => PLevel9,
            PLevel10         => PLevel10,
            PLevel11         => PLevel11,
            PLevel12         => PLevel12,
            PLevel13         => PLevel13,
            PLevel14         => PLevel14,
            PLevel15         => PLevel15,
            PLevel16         => PLevel16,
            PLevel17         => PLevel17,
            PLevel18         => PLevel18,
            PLevel19         => PLevel19,
            PLevel20         => PLevel20,
            PLevel21         => PLevel21,
            PLevel22         => PLevel22,
            PLevel23         => PLevel23,
            PLevel24         => PLevel24,
            PLevel25         => PLevel25,
            PLevel26         => PLevel26,
            PLevel27         => PLevel27,
            PLevel28         => PLevel28,
            PLevel29         => PLevel29,
            PLevel30         => PLevel30,
            PLevel31         => PLevel31,
            PLevel32         => PLevel32,
            PriorityLevelCfg => Config2,

-- Outputs
            IrqOutput        => IrqAsync(2),
            SyncIrqOutput    => IrqSync(2),
            IRQPort          => Port2
           );

-- -----------------------------------------------------------------------------
-- Priority Encoding for level 3
-- -----------------------------------------------------------------------------
u3VicPriority : VicPriority
  port map (
-- Inputs

-- Interrupt signals
            IRQStatusIn      => iVICIRQStatus,
            DaisyChainIn     => DaisyChainIn,
            SyncIRQStatusIn  => Sync2IrqStatus,
            SyncDaisyChainIn => Sync2DaisyIn,
            SWPriorityMask   => SWPriorityMask(3),
            CurrentLevelMask => CurrentLevelMask(3),
-- Priority levels
            PLevel0          => PLevel0,
            PLevel1          => PLevel1,
            PLevel2          => PLevel2,
            PLevel3          => PLevel3,
            PLevel4          => PLevel4,
            PLevel5          => PLevel5,
            PLevel6          => PLevel6,
            PLevel7          => PLevel7,
            PLevel8          => PLevel8,
            PLevel9          => PLevel9,
            PLevel10         => PLevel10,
            PLevel11         => PLevel11,
            PLevel12         => PLevel12,
            PLevel13         => PLevel13,
            PLevel14         => PLevel14,
            PLevel15         => PLevel15,
            PLevel16         => PLevel16,
            PLevel17         => PLevel17,
            PLevel18         => PLevel18,
            PLevel19         => PLevel19,
            PLevel20         => PLevel20,
            PLevel21         => PLevel21,
            PLevel22         => PLevel22,
            PLevel23         => PLevel23,
            PLevel24         => PLevel24,
            PLevel25         => PLevel25,
            PLevel26         => PLevel26,
            PLevel27         => PLevel27,
            PLevel28         => PLevel28,
            PLevel29         => PLevel29,
            PLevel30         => PLevel30,
            PLevel31         => PLevel31,
            PLevel32         => PLevel32,
            PriorityLevelCfg => Config3,

-- Outputs
            IrqOutput        => IrqAsync(3),
            SyncIrqOutput    => IrqSync(3),
            IRQPort          => Port3
           );

-- -----------------------------------------------------------------------------
-- Priority Encoding for level 4
-- -----------------------------------------------------------------------------
u4VicPriority : VicPriority
  port map (
-- Inputs

-- Interrupt signals
            IRQStatusIn      => iVICIRQStatus,
            DaisyChainIn     => DaisyChainIn,
            SyncIRQStatusIn  => Sync2IrqStatus,
            SyncDaisyChainIn => Sync2DaisyIn,
            SWPriorityMask   => SWPriorityMask(4),
            CurrentLevelMask => CurrentLevelMask(4),
            PLevel0          => PLevel0,
            PLevel1          => PLevel1,
            PLevel2          => PLevel2,
            PLevel3          => PLevel3,
            PLevel4          => PLevel4,
            PLevel5          => PLevel5,
            PLevel6          => PLevel6,
            PLevel7          => PLevel7,
            PLevel8          => PLevel8,
            PLevel9          => PLevel9,
            PLevel10         => PLevel10,
            PLevel11         => PLevel11,
            PLevel12         => PLevel12,
            PLevel13         => PLevel13,
            PLevel14         => PLevel14,
            PLevel15         => PLevel15,
            PLevel16         => PLevel16,
            PLevel17         => PLevel17,
            PLevel18         => PLevel18,
            PLevel19         => PLevel19,
            PLevel20         => PLevel20,
            PLevel21         => PLevel21,
            PLevel22         => PLevel22,
            PLevel23         => PLevel23,
            PLevel24         => PLevel24,
            PLevel25         => PLevel25,
            PLevel26         => PLevel26,
            PLevel27         => PLevel27,
            PLevel28         => PLevel28,
            PLevel29         => PLevel29,
            PLevel30         => PLevel30,
            PLevel31         => PLevel31,
            PLevel32         => PLevel32,
            PriorityLevelCfg => Config4,

-- Outputs
            IrqOutput        => IrqAsync(4),
            SyncIrqOutput    => IrqSync(4),
            IRQPort          => Port4
           );

-- -----------------------------------------------------------------------------
-- Priority Encoding for level 5
-- -----------------------------------------------------------------------------
u5VicPriority : VicPriority
  port map (
-- Inputs

-- Interrupt signals
            IRQStatusIn      => iVICIRQStatus,
            DaisyChainIn     => DaisyChainIn,
            SyncIRQStatusIn  => Sync2IrqStatus,
            SyncDaisyChainIn => Sync2DaisyIn,
            SWPriorityMask   => SWPriorityMask(5),
            CurrentLevelMask => CurrentLevelMask(5),
            PLevel0          => PLevel0,
            PLevel1          => PLevel1,
            PLevel2          => PLevel2,
            PLevel3          => PLevel3,
            PLevel4          => PLevel4,
            PLevel5          => PLevel5,
            PLevel6          => PLevel6,
            PLevel7          => PLevel7,
            PLevel8          => PLevel8,
            PLevel9          => PLevel9,
            PLevel10         => PLevel10,
            PLevel11         => PLevel11,
            PLevel12         => PLevel12,
            PLevel13         => PLevel13,
            PLevel14         => PLevel14,
            PLevel15         => PLevel15,
            PLevel16         => PLevel16,
            PLevel17         => PLevel17,
            PLevel18         => PLevel18,
            PLevel19         => PLevel19,
            PLevel20         => PLevel20,
            PLevel21         => PLevel21,
            PLevel22         => PLevel22,
            PLevel23         => PLevel23,
            PLevel24         => PLevel24,
            PLevel25         => PLevel25,
            PLevel26         => PLevel26,
            PLevel27         => PLevel27,
            PLevel28         => PLevel28,
            PLevel29         => PLevel29,
            PLevel30         => PLevel30,
            PLevel31         => PLevel31,
            PLevel32         => PLevel32,
            PriorityLevelCfg => Config5,

-- Outputs
            IrqOutput        => IrqAsync(5),
            SyncIrqOutput    => IrqSync(5),
            IRQPort          => Port5
           );

-- -----------------------------------------------------------------------------
-- Priority Encoding for level 6
-- -----------------------------------------------------------------------------
u6VicPriority : VicPriority
  port map (
-- Inputs

-- Interrupt signals
            IRQStatusIn      => iVICIRQStatus,
            DaisyChainIn     => DaisyChainIn,
            SyncIRQStatusIn  => Sync2IrqStatus,
            SyncDaisyChainIn => Sync2DaisyIn,
            SWPriorityMask   => SWPriorityMask(6),
            CurrentLevelMask => CurrentLevelMask(6),
            PLevel0          => PLevel0,
            PLevel1          => PLevel1,
            PLevel2          => PLevel2,
            PLevel3          => PLevel3,
            PLevel4          => PLevel4,
            PLevel5          => PLevel5,
            PLevel6          => PLevel6,
            PLevel7          => PLevel7,
            PLevel8          => PLevel8,
            PLevel9          => PLevel9,
            PLevel10         => PLevel10,
            PLevel11         => PLevel11,
            PLevel12         => PLevel12,
            PLevel13         => PLevel13,
            PLevel14         => PLevel14,
            PLevel15         => PLevel15,
            PLevel16         => PLevel16,
            PLevel17         => PLevel17,
            PLevel18         => PLevel18,
            PLevel19         => PLevel19,
            PLevel20         => PLevel20,
            PLevel21         => PLevel21,
            PLevel22         => PLevel22,
            PLevel23         => PLevel23,
            PLevel24         => PLevel24,
            PLevel25         => PLevel25,
            PLevel26         => PLevel26,
            PLevel27         => PLevel27,
            PLevel28         => PLevel28,
            PLevel29         => PLevel29,
            PLevel30         => PLevel30,
            PLevel31         => PLevel31,
            PLevel32         => PLevel32,
            PriorityLevelCfg => Config6,

-- Outputs
            IrqOutput        => IrqAsync(6),
            SyncIrqOutput    => IrqSync(6),
            IRQPort          => Port6
           );

-- -----------------------------------------------------------------------------
-- Priority Encoding for level 7
-- -----------------------------------------------------------------------------
u7VicPriority : VicPriority
  port map (
-- Inputs

-- Interrupt signals
            IRQStatusIn      => iVICIRQStatus,
            DaisyChainIn     => DaisyChainIn,
            SyncIRQStatusIn  => Sync2IrqStatus,
            SyncDaisyChainIn => Sync2DaisyIn,
            SWPriorityMask   => SWPriorityMask(7),
            CurrentLevelMask => CurrentLevelMask(7),
            PLevel0          => PLevel0,
            PLevel1          => PLevel1,
            PLevel2          => PLevel2,
            PLevel3          => PLevel3,
            PLevel4          => PLevel4,
            PLevel5          => PLevel5,
            PLevel6          => PLevel6,
            PLevel7          => PLevel7,
            PLevel8          => PLevel8,
            PLevel9          => PLevel9,
            PLevel10         => PLevel10,
            PLevel11         => PLevel11,
            PLevel12         => PLevel12,
            PLevel13         => PLevel13,
            PLevel14         => PLevel14,
            PLevel15         => PLevel15,
            PLevel16         => PLevel16,
            PLevel17         => PLevel17,
            PLevel18         => PLevel18,
            PLevel19         => PLevel19,
            PLevel20         => PLevel20,
            PLevel21         => PLevel21,
            PLevel22         => PLevel22,
            PLevel23         => PLevel23,
            PLevel24         => PLevel24,
            PLevel25         => PLevel25,
            PLevel26         => PLevel26,
            PLevel27         => PLevel27,
            PLevel28         => PLevel28,
            PLevel29         => PLevel29,
            PLevel30         => PLevel30,
            PLevel31         => PLevel31,
            PLevel32         => PLevel32,
            PriorityLevelCfg => Config7,

-- Outputs
            IrqOutput        => IrqAsync(7),
            SyncIrqOutput    => IrqSync(7),
            IRQPort          => Port7
           );

-- -----------------------------------------------------------------------------
-- Priority Encoding for level 8
-- -----------------------------------------------------------------------------
u8VicPriority : VicPriority
  port map (
-- Inputs

-- Interrupt signals
            IRQStatusIn      => iVICIRQStatus,
            DaisyChainIn     => DaisyChainIn,
            SyncIRQStatusIn  => Sync2IrqStatus,
            SyncDaisyChainIn => Sync2DaisyIn,
            SWPriorityMask   => SWPriorityMask(8),
            CurrentLevelMask => CurrentLevelMask(8),
            PLevel0          => PLevel0,
            PLevel1          => PLevel1,
            PLevel2          => PLevel2,
            PLevel3          => PLevel3,
            PLevel4          => PLevel4,
            PLevel5          => PLevel5,
            PLevel6          => PLevel6,
            PLevel7          => PLevel7,
            PLevel8          => PLevel8,
            PLevel9          => PLevel9,
            PLevel10         => PLevel10,
            PLevel11         => PLevel11,
            PLevel12         => PLevel12,
            PLevel13         => PLevel13,
            PLevel14         => PLevel14,
            PLevel15         => PLevel15,
            PLevel16         => PLevel16,
            PLevel17         => PLevel17,
            PLevel18         => PLevel18,
            PLevel19         => PLevel19,
            PLevel20         => PLevel20,
            PLevel21         => PLevel21,
            PLevel22         => PLevel22,
            PLevel23         => PLevel23,
            PLevel24         => PLevel24,
            PLevel25         => PLevel25,
            PLevel26         => PLevel26,
            PLevel27         => PLevel27,
            PLevel28         => PLevel28,
            PLevel29         => PLevel29,
            PLevel30         => PLevel30,
            PLevel31         => PLevel31,
            PLevel32         => PLevel32,
            PriorityLevelCfg => Config8,

-- Outputs
            IrqOutput        => IrqAsync(8),
            SyncIrqOutput    => IrqSync(8),
            IRQPort          => Port8
           );

-- -----------------------------------------------------------------------------
-- Priority Encoding for level 9
-- -----------------------------------------------------------------------------
u9VicPriority : VicPriority
  port map (
-- Inputs

-- Interrupt signals
            IRQStatusIn      => iVICIRQStatus,
            DaisyChainIn     => DaisyChainIn,
            SyncIRQStatusIn  => Sync2IrqStatus,
            SyncDaisyChainIn => Sync2DaisyIn,
            SWPriorityMask   => SWPriorityMask(9),
            CurrentLevelMask => CurrentLevelMask(9),
            PLevel0          => PLevel0,
            PLevel1          => PLevel1,
            PLevel2          => PLevel2,
            PLevel3          => PLevel3,
            PLevel4          => PLevel4,
            PLevel5          => PLevel5,
            PLevel6          => PLevel6,
            PLevel7          => PLevel7,
            PLevel8          => PLevel8,
            PLevel9          => PLevel9,
            PLevel10         => PLevel10,
            PLevel11         => PLevel11,
            PLevel12         => PLevel12,
            PLevel13         => PLevel13,
            PLevel14         => PLevel14,
            PLevel15         => PLevel15,
            PLevel16         => PLevel16,
            PLevel17         => PLevel17,
            PLevel18         => PLevel18,
            PLevel19         => PLevel19,
            PLevel20         => PLevel20,
            PLevel21         => PLevel21,
            PLevel22         => PLevel22,
            PLevel23         => PLevel23,
            PLevel24         => PLevel24,
            PLevel25         => PLevel25,
            PLevel26         => PLevel26,
            PLevel27         => PLevel27,
            PLevel28         => PLevel28,
            PLevel29         => PLevel29,
            PLevel30         => PLevel30,
            PLevel31         => PLevel31,
            PLevel32         => PLevel32,
            PriorityLevelCfg => Config9,

-- Outputs
            IrqOutput        => IrqAsync(9),
            SyncIrqOutput    => IrqSync(9),
            IRQPort          => Port9
           );

-- -----------------------------------------------------------------------------
-- Priority Encoding for level 10
-- -----------------------------------------------------------------------------
u10VicPriority : VicPriority
  port map (
-- Inputs

-- Interrupt signals
            IRQStatusIn      => iVICIRQStatus,
            DaisyChainIn     => DaisyChainIn,
            SyncIRQStatusIn  => Sync2IrqStatus,
            SyncDaisyChainIn => Sync2DaisyIn,
            SWPriorityMask   => SWPriorityMask(10),
            CurrentLevelMask => CurrentLevelMask(10),
            PLevel0          => PLevel0,
            PLevel1          => PLevel1,
            PLevel2          => PLevel2,
            PLevel3          => PLevel3,
            PLevel4          => PLevel4,
            PLevel5          => PLevel5,
            PLevel6          => PLevel6,
            PLevel7          => PLevel7,
            PLevel8          => PLevel8,
            PLevel9          => PLevel9,
            PLevel10         => PLevel10,
            PLevel11         => PLevel11,
            PLevel12         => PLevel12,
            PLevel13         => PLevel13,
            PLevel14         => PLevel14,
            PLevel15         => PLevel15,
            PLevel16         => PLevel16,
            PLevel17         => PLevel17,
            PLevel18         => PLevel18,
            PLevel19         => PLevel19,
            PLevel20         => PLevel20,
            PLevel21         => PLevel21,
            PLevel22         => PLevel22,
            PLevel23         => PLevel23,
            PLevel24         => PLevel24,
            PLevel25         => PLevel25,
            PLevel26         => PLevel26,
            PLevel27         => PLevel27,
            PLevel28         => PLevel28,
            PLevel29         => PLevel29,
            PLevel30         => PLevel30,
            PLevel31         => PLevel31,
            PLevel32         => PLevel32,
            PriorityLevelCfg => Config10,

-- Outputs
            IrqOutput        => IrqAsync(10),
            SyncIrqOutput    => IrqSync(10),
            IRQPort          => Port10
           );

-- -----------------------------------------------------------------------------
-- Priority Encoding for level 11
-- -----------------------------------------------------------------------------
u11VicPriority : VicPriority
  port map (
-- Inputs

-- Interrupt signals
            IRQStatusIn      => iVICIRQStatus,
            DaisyChainIn     => DaisyChainIn,
            SyncIRQStatusIn  => Sync2IrqStatus,
            SyncDaisyChainIn => Sync2DaisyIn,
            SWPriorityMask   => SWPriorityMask(11),
            CurrentLevelMask => CurrentLevelMask(11),
            PLevel0          => PLevel0,
            PLevel1          => PLevel1,
            PLevel2          => PLevel2,
            PLevel3          => PLevel3,
            PLevel4          => PLevel4,
            PLevel5          => PLevel5,
            PLevel6          => PLevel6,
            PLevel7          => PLevel7,
            PLevel8          => PLevel8,
            PLevel9          => PLevel9,
            PLevel10         => PLevel10,
            PLevel11         => PLevel11,
            PLevel12         => PLevel12,
            PLevel13         => PLevel13,
            PLevel14         => PLevel14,
            PLevel15         => PLevel15,
            PLevel16         => PLevel16,
            PLevel17         => PLevel17,
            PLevel18         => PLevel18,
            PLevel19         => PLevel19,
            PLevel20         => PLevel20,
            PLevel21         => PLevel21,
            PLevel22         => PLevel22,
            PLevel23         => PLevel23,
            PLevel24         => PLevel24,
            PLevel25         => PLevel25,
            PLevel26         => PLevel26,
            PLevel27         => PLevel27,
            PLevel28         => PLevel28,
            PLevel29         => PLevel29,
            PLevel30         => PLevel30,
            PLevel31         => PLevel31,
            PLevel32         => PLevel32,
            PriorityLevelCfg => Config11,

-- Outputs
            IrqOutput        => IrqAsync(11),
            SyncIrqOutput    => IrqSync(11),
            IRQPort          => Port11
           );

-- -----------------------------------------------------------------------------
-- Priority Encoding for level 12
-- -----------------------------------------------------------------------------
u12VicPriority : VicPriority
  port map (
-- Inputs

-- Interrupt signals
            IRQStatusIn      => iVICIRQStatus,
            DaisyChainIn     => DaisyChainIn,
            SyncIRQStatusIn  => Sync2IrqStatus,
            SyncDaisyChainIn => Sync2DaisyIn,
            SWPriorityMask   => SWPriorityMask(12),
            CurrentLevelMask => CurrentLevelMask(12),
            PLevel0          => PLevel0,
            PLevel1          => PLevel1,
            PLevel2          => PLevel2,
            PLevel3          => PLevel3,
            PLevel4          => PLevel4,
            PLevel5          => PLevel5,
            PLevel6          => PLevel6,
            PLevel7          => PLevel7,
            PLevel8          => PLevel8,
            PLevel9          => PLevel9,
            PLevel10         => PLevel10,
            PLevel11         => PLevel11,
            PLevel12         => PLevel12,
            PLevel13         => PLevel13,
            PLevel14         => PLevel14,
            PLevel15         => PLevel15,
            PLevel16         => PLevel16,
            PLevel17         => PLevel17,
            PLevel18         => PLevel18,
            PLevel19         => PLevel19,
            PLevel20         => PLevel20,
            PLevel21         => PLevel21,
            PLevel22         => PLevel22,
            PLevel23         => PLevel23,
            PLevel24         => PLevel24,
            PLevel25         => PLevel25,
            PLevel26         => PLevel26,
            PLevel27         => PLevel27,
            PLevel28         => PLevel28,
            PLevel29         => PLevel29,
            PLevel30         => PLevel30,
            PLevel31         => PLevel31,
            PLevel32         => PLevel32,
            PriorityLevelCfg => Config12,

-- Outputs
            IrqOutput        => IrqAsync(12),
            SyncIrqOutput    => IrqSync(12),
            IRQPort          => Port12
           );

-- -----------------------------------------------------------------------------
-- Priority Encoding for level 13
-- -----------------------------------------------------------------------------
u13VicPriority : VicPriority
  port map (
-- Inputs

-- Interrupt signals
            IRQStatusIn      => iVICIRQStatus,
            DaisyChainIn     => DaisyChainIn,
            SyncIRQStatusIn  => Sync2IrqStatus,
            SyncDaisyChainIn => Sync2DaisyIn,
            SWPriorityMask   => SWPriorityMask(13),
            CurrentLevelMask => CurrentLevelMask(13),
            PLevel0          => PLevel0,
            PLevel1          => PLevel1,
            PLevel2          => PLevel2,
            PLevel3          => PLevel3,
            PLevel4          => PLevel4,
            PLevel5          => PLevel5,
            PLevel6          => PLevel6,
            PLevel7          => PLevel7,
            PLevel8          => PLevel8,
            PLevel9          => PLevel9,
            PLevel10         => PLevel10,
            PLevel11         => PLevel11,
            PLevel12         => PLevel12,
            PLevel13         => PLevel13,
            PLevel14         => PLevel14,
            PLevel15         => PLevel15,
            PLevel16         => PLevel16,
            PLevel17         => PLevel17,
            PLevel18         => PLevel18,
            PLevel19         => PLevel19,
            PLevel20         => PLevel20,
            PLevel21         => PLevel21,
            PLevel22         => PLevel22,
            PLevel23         => PLevel23,
            PLevel24         => PLevel24,
            PLevel25         => PLevel25,
            PLevel26         => PLevel26,
            PLevel27         => PLevel27,
            PLevel28         => PLevel28,
            PLevel29         => PLevel29,
            PLevel30         => PLevel30,
            PLevel31         => PLevel31,
            PLevel32         => PLevel32,
            PriorityLevelCfg => Config13,

-- Outputs
            IrqOutput        => IrqAsync(13),
            SyncIrqOutput    => IrqSync(13),
            IRQPort          => Port13
           );

-- -----------------------------------------------------------------------------
-- Priority Encoding for level 14
-- -----------------------------------------------------------------------------
u14VicPriority : VicPriority
  port map (
-- Inputs

-- Interrupt signals
            IRQStatusIn      => iVICIRQStatus,
            DaisyChainIn     => DaisyChainIn,
            SyncIRQStatusIn  => Sync2IrqStatus,
            SyncDaisyChainIn => Sync2DaisyIn,
            SWPriorityMask   => SWPriorityMask(14),
            CurrentLevelMask => CurrentLevelMask(14),
            PLevel0          => PLevel0,
            PLevel1          => PLevel1,
            PLevel2          => PLevel2,
            PLevel3          => PLevel3,
            PLevel4          => PLevel4,
            PLevel5          => PLevel5,
            PLevel6          => PLevel6,
            PLevel7          => PLevel7,
            PLevel8          => PLevel8,
            PLevel9          => PLevel9,
            PLevel10         => PLevel10,
            PLevel11         => PLevel11,
            PLevel12         => PLevel12,
            PLevel13         => PLevel13,
            PLevel14         => PLevel14,
            PLevel15         => PLevel15,
            PLevel16         => PLevel16,
            PLevel17         => PLevel17,
            PLevel18         => PLevel18,
            PLevel19         => PLevel19,
            PLevel20         => PLevel20,
            PLevel21         => PLevel21,
            PLevel22         => PLevel22,
            PLevel23         => PLevel23,
            PLevel24         => PLevel24,
            PLevel25         => PLevel25,
            PLevel26         => PLevel26,
            PLevel27         => PLevel27,
            PLevel28         => PLevel28,
            PLevel29         => PLevel29,
            PLevel30         => PLevel30,
            PLevel31         => PLevel31,
            PLevel32         => PLevel32,
            PriorityLevelCfg => Config14,

-- Outputs
            IrqOutput        => IrqAsync(14),
            SyncIrqOutput    => IrqSync(14),
            IRQPort          => Port14
           );

-- -----------------------------------------------------------------------------
-- Priority Encoding for level 15
-- -----------------------------------------------------------------------------
u15VicPriority : VicPriority
  port map (
-- Inputs

-- Interrupt signals
            IRQStatusIn      => iVICIRQStatus,
            DaisyChainIn     => DaisyChainIn,
            SyncIRQStatusIn  => Sync2IrqStatus,
            SyncDaisyChainIn => Sync2DaisyIn,
            SWPriorityMask   => SWPriorityMask(15),
            CurrentLevelMask => CurrentLevelMask(15),
            PLevel0          => PLevel0,
            PLevel1          => PLevel1,
            PLevel2          => PLevel2,
            PLevel3          => PLevel3,
            PLevel4          => PLevel4,
            PLevel5          => PLevel5,
            PLevel6          => PLevel6,
            PLevel7          => PLevel7,
            PLevel8          => PLevel8,
            PLevel9          => PLevel9,
            PLevel10         => PLevel10,
            PLevel11         => PLevel11,
            PLevel12         => PLevel12,
            PLevel13         => PLevel13,
            PLevel14         => PLevel14,
            PLevel15         => PLevel15,
            PLevel16         => PLevel16,
            PLevel17         => PLevel17,
            PLevel18         => PLevel18,
            PLevel19         => PLevel19,
            PLevel20         => PLevel20,
            PLevel21         => PLevel21,
            PLevel22         => PLevel22,
            PLevel23         => PLevel23,
            PLevel24         => PLevel24,
            PLevel25         => PLevel25,
            PLevel26         => PLevel26,
            PLevel27         => PLevel27,
            PLevel28         => PLevel28,
            PLevel29         => PLevel29,
            PLevel30         => PLevel30,
            PLevel31         => PLevel31,
            PLevel32         => PLevel32,
            PriorityLevelCfg => Config15,

-- Outputs
            IrqOutput        => IrqAsync(15),
            SyncIrqOutput    => IrqSync(15),
            IRQPort          => Port15
           );

-- -----------------------------------------------------------------------------
-- Instantiation of VicIntResolver
-- -----------------------------------------------------------------------------
uVicIntResolver : VicIntResolver
  port map (
-- Inputs

-- AHB signals
            HCLK             => HCLK,
            HRESETn          => HRESETn,
-- Interrupt signals
            IrqSync          => IrqSync,
            Port0            => Port0,
            Port1            => Port1,
            Port2            => Port2,
            Port3            => Port3,
            Port4            => Port4,
            Port5            => Port5,
            Port6            => Port6,
            Port7            => Port7,
            Port8            => Port8,
            Port9            => Port9,
            Port10           => Port10,
            Port11           => Port11,
            Port12           => Port12,
            Port13           => Port13,
            Port14           => Port14,
            Port15           => Port15,
            ITEN             => ITEN,
            IrqAsync         => IrqAsync,
            IRQForceVal      => IRQForceVal,
            CurrentPriority  => CurrentPriority,
            nIRQINForceVal   => nIRQINForceVal,
            nFIQINForceVal   => nFIQINForceVal,
            FIQForceVal      => FIQForceVal,
            nVICIRQIN        => nVICIRQIN,
            VICIRQINREG      => VICIRQINREG,
            nVICFIQIN        => nVICFIQIN,
            VICFIQINREG      => VICFIQINREG,
            VICSoftInt       => VICSoftInt,
            VICINTSOURCE     => VICINTSOURCE,
            VICIntEnable     => VICIntEnable,
            VICIntSelect     => VICIntSelect,

-- Outputs
            FIQTestVal       => FIQTestVal,
            nIRQINTestVal    => nIRQINTestVal,
            nFIQINTestVal    => nFIQINTestVal,
            nVICIRQ          => nVICIRQ,
            nVICFIQ          => nVICFIQ,
            IRQPortRes       => IRQPortRes,
            IRQRequestRes    => IRQRequestRes,
            IRQReqLevelRes   => IRQReqLevelRes,
            IRQTestVal       => IRQTestVal,
            DaisyChainIn     => DaisyChainIn,
            Sync2DaisyIn     => Sync2DaisyIn,
            Sync2IrqStatus   => Sync2IrqStatus,
            CurrentLevelMask => CurrentLevelMask,
            VICFIQStatus     => VICFIQStatus,
            VICIRQStatus     => iVICIRQStatus,
            VICRawIntr       => VICRawIntr
           );

-- -----------------------------------------------------------------------------
-- Connect to the top level
-- -----------------------------------------------------------------------------
VICIRQStatus <= iVICIRQStatus;

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
