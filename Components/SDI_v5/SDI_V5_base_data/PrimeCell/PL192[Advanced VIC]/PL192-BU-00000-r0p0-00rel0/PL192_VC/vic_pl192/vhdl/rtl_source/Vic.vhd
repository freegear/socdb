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
-- File Name              : Vic.vhd.rca
-- File Revision          : 1.13
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block is the top level of the VIC.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity Vic is
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB Clock
        HRESETn          : in    std_logic; -- AHB reset
        HSELVIC          : in    std_logic; -- VIC slave select
        HADDR            : in    std_logic_vector(11 downto 2);
                                            -- AHB address bus
        HWRITE           : in    std_logic; -- AHB operation select
        HREADYIN         : in    std_logic; -- Transfer done response on AHB
                                            -- from previous Slave
        HPROT            : in    std_logic_vector(3 downto 0);
                                            -- AHB protection mode
        HTRANS           : in    std_logic_vector(1 downto 0);
                                            -- AHB transfer type
        HSIZE            : in    std_logic_vector(2 downto 0);
                                            -- AHB transfer size
        HWDATA           : in    std_logic_vector(31 downto 0);
                                            -- AHB write data
        VICINTSOURCE     : in    std_logic_vector(31 downto 0);
                                            -- Peripheral interrupt source
                                            -- input
        nVICSYNCEN       : in    std_logic; -- Synchronous enable signal for
                                            -- the vic port
                                            -- signals
        VICIRQACK        : in    std_logic; -- Acknowledge signal from the CPU
        nVICFIQIN        : in    std_logic; -- FIQ interrupt from the daisy
                                            -- chain VIC
        nVICIRQIN        : in    std_logic; -- IRQ interrupt from the daisy
                                            -- chain VIC
        VICVECTADDRIN    : in    std_logic_vector(31 downto 0);
                                            -- Vector address from the daisy
                                            -- chain VIC
        VICFIQINREG      : in    std_logic; -- Register enable signal for
                                            -- VICFIQIN
        VICIRQINREG      : in    std_logic; -- Register enable signal for
                                            -- VICIRQIN
        SCANENABLE       : in    std_logic; -- Scan enable
        SCANINHCLK       : in    std_logic; -- Scan input for HCLK domain

-- Outputs
        HREADYOUT        : out   std_logic; -- Transfer done response for AHB
        HRESP            : out   std_logic_vector(1 downto 0);
                                            -- Transfer response to AHB
        HRDATA           : out   std_logic_vector(31 downto 0);
                                            -- Read data to AHB
        nVICFIQ          : out   std_logic; -- FIQ to the CPU
        nVICIRQ          : out   std_logic; -- IRQ to the CPU
        VICVECTADDROUT   : out   std_logic_vector(31 downto 0);
                                            -- ISR address to the CPU
        VICVECTADDRV     : out   std_logic; -- Address valid signal
        VICIRQACKOUT     : out   std_logic; -- ACKOUT signal to the daisy chain
                                            -- VIC
        SCANOUTHCLK      : out   std_logic  -- Scan output for HCLK domain
       );
end Vic;

-- -----------------------------------------------------------------------------
--
--                                     Vic
--                                     ===
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--   This block is the top level of the VIC. This block instantiates the
-- following functional sub-blocks in the VIC.
--      - VicAhbif
--          This module is the AHB interface to the VIC.
--      - VicCpuif
--          This module generates the handshake signals to the CPU.
--      - VicInterrupt
--          This module resolves the interrupt priority.
--      - VicRevAnd(4 instances)
--          This module provides the Peripheral Revision number of the VIC.
--
-- -----------------------------------------------------------------------------

-- --============================= ARCHITECTURE ==============================--

architecture synth of Vic is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- VicAhbif
-- -----------------------------------------------------------------------------
component VicAhbif
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HSELVIC          : in    std_logic;
        HADDR            : in    std_logic_vector(11 downto 2);
        HTRANS1          : in    std_logic;
        HWRITE           : in    std_logic;
        HREADYIN         : in    std_logic;
        HPROT1           : in    std_logic;
        HSIZE            : in    std_logic_vector(2 downto 0);
        HWDATA           : in    std_logic_vector(31 downto 0);
        Revision         : in    std_logic_vector(3 downto 0);
        VICFIQStatus     : in    std_logic_vector(31 downto 0);
        VICIRQStatus     : in    std_logic_vector(31 downto 0);
        VICRawIntr       : in    std_logic_vector(31 downto 0);
        VICINTSOURCE     : in    std_logic_vector(31 downto 0);
        VICVectAddrVal   : in    std_logic_vector(31 downto 0);
        IRQACKTestVal    : in    std_logic;
        nIRQINTestVal    : in    std_logic;
        nFIQINTestVal    : in    std_logic;
        VADDRINTestVal   : in    std_logic_vector(31 downto 0);
        VADDRVTestVal    : in    std_logic;
        IRQTestVal       : in    std_logic;
        FIQTestVal       : in    std_logic;
        ACKOUTTestVal    : in    std_logic;
        VADDRTestVal     : in    std_logic_vector(31 downto 0);
        VICFIQINREG      : in    std_logic;
        VICIRQINREG      : in    std_logic;
        HRESP            : out   std_logic_vector(1 downto 0);
        HREADYOUT        : out   std_logic;
        HRDATA           : out   std_logic_vector(31 downto 0);
        VICSoftInt       : out   std_logic_vector(31 downto 0);
        VICIntEnable     : out   std_logic_vector(31 downto 0);
        VICIntSelect     : out   std_logic_vector(31 downto 0);
        SWPriorityMask   : out   std_logic_vector(15 downto 0);
        VectAddr0        : out   std_logic_vector(31 downto 0);
        VectAddr1        : out   std_logic_vector(31 downto 0);
        VectAddr2        : out   std_logic_vector(31 downto 0);
        VectAddr3        : out   std_logic_vector(31 downto 0);
        VectAddr4        : out   std_logic_vector(31 downto 0);
        VectAddr5        : out   std_logic_vector(31 downto 0);
        VectAddr6        : out   std_logic_vector(31 downto 0);
        VectAddr7        : out   std_logic_vector(31 downto 0);
        VectAddr8        : out   std_logic_vector(31 downto 0);
        VectAddr9        : out   std_logic_vector(31 downto 0);
        VectAddr10       : out   std_logic_vector(31 downto 0);
        VectAddr11       : out   std_logic_vector(31 downto 0);
        VectAddr12       : out   std_logic_vector(31 downto 0);
        VectAddr13       : out   std_logic_vector(31 downto 0);
        VectAddr14       : out   std_logic_vector(31 downto 0);
        VectAddr15       : out   std_logic_vector(31 downto 0);
        VectAddr16       : out   std_logic_vector(31 downto 0);
        VectAddr17       : out   std_logic_vector(31 downto 0);
        VectAddr18       : out   std_logic_vector(31 downto 0);
        VectAddr19       : out   std_logic_vector(31 downto 0);
        VectAddr20       : out   std_logic_vector(31 downto 0);
        VectAddr21       : out   std_logic_vector(31 downto 0);
        VectAddr22       : out   std_logic_vector(31 downto 0);
        VectAddr23       : out   std_logic_vector(31 downto 0);
        VectAddr24       : out   std_logic_vector(31 downto 0);
        VectAddr25       : out   std_logic_vector(31 downto 0);
        VectAddr26       : out   std_logic_vector(31 downto 0);
        VectAddr27       : out   std_logic_vector(31 downto 0);
        VectAddr28       : out   std_logic_vector(31 downto 0);
        VectAddr29       : out   std_logic_vector(31 downto 0);
        VectAddr30       : out   std_logic_vector(31 downto 0);
        VectAddr31       : out   std_logic_vector(31 downto 0);
        VectPriority0    : out   std_logic_vector(3 downto 0);
        VectPriority1    : out   std_logic_vector(3 downto 0);
        VectPriority2    : out   std_logic_vector(3 downto 0);
        VectPriority3    : out   std_logic_vector(3 downto 0);
        VectPriority4    : out   std_logic_vector(3 downto 0);
        VectPriority5    : out   std_logic_vector(3 downto 0);
        VectPriority6    : out   std_logic_vector(3 downto 0);
        VectPriority7    : out   std_logic_vector(3 downto 0);
        VectPriority8    : out   std_logic_vector(3 downto 0);
        VectPriority9    : out   std_logic_vector(3 downto 0);
        VectPriority10   : out   std_logic_vector(3 downto 0);
        VectPriority11   : out   std_logic_vector(3 downto 0);
        VectPriority12   : out   std_logic_vector(3 downto 0);
        VectPriority13   : out   std_logic_vector(3 downto 0);
        VectPriority14   : out   std_logic_vector(3 downto 0);
        VectPriority15   : out   std_logic_vector(3 downto 0);
        VectPriority16   : out   std_logic_vector(3 downto 0);
        VectPriority17   : out   std_logic_vector(3 downto 0);
        VectPriority18   : out   std_logic_vector(3 downto 0);
        VectPriority19   : out   std_logic_vector(3 downto 0);
        VectPriority20   : out   std_logic_vector(3 downto 0);
        VectPriority21   : out   std_logic_vector(3 downto 0);
        VectPriority22   : out   std_logic_vector(3 downto 0);
        VectPriority23   : out   std_logic_vector(3 downto 0);
        VectPriority24   : out   std_logic_vector(3 downto 0);
        VectPriority25   : out   std_logic_vector(3 downto 0);
        VectPriority26   : out   std_logic_vector(3 downto 0);
        VectPriority27   : out   std_logic_vector(3 downto 0);
        VectPriority28   : out   std_logic_vector(3 downto 0);
        VectPriority29   : out   std_logic_vector(3 downto 0);
        VectPriority30   : out   std_logic_vector(3 downto 0);
        VectPriority31   : out   std_logic_vector(3 downto 0);
        VectPriority32   : out   std_logic_vector(3 downto 0);
        IRQSWAck         : out   std_logic;
        IRQSWClear       : out   std_logic;
        ITEN             : out   std_logic;
        IRQACKForceVal   : out   std_logic;
        nIRQINForceVal   : out   std_logic;
        nFIQINForceVal   : out   std_logic;
        VECTADDRINFrcVal : out   std_logic_vector(31 downto 0);
        VECTADDRVFrcVal  : out   std_logic;
        IRQForceVal      : out   std_logic;
        FIQForceVal      : out   std_logic;
        IRQACKOUTFrcVal  : out   std_logic;
        VECTADDRFrcVal   : out   std_logic_vector(31 downto 0)
       );
end component;

-- ----------------------------------------------------------------------------
-- VicCpuif
-- ----------------------------------------------------------------------------
component VicCpuif
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        VectAddr0        : in    std_logic_vector(31 downto 0);
        VectAddr1        : in    std_logic_vector(31 downto 0);
        VectAddr2        : in    std_logic_vector(31 downto 0);
        VectAddr3        : in    std_logic_vector(31 downto 0);
        VectAddr4        : in    std_logic_vector(31 downto 0);
        VectAddr5        : in    std_logic_vector(31 downto 0);
        VectAddr6        : in    std_logic_vector(31 downto 0);
        VectAddr7        : in    std_logic_vector(31 downto 0);
        VectAddr8        : in    std_logic_vector(31 downto 0);
        VectAddr9        : in    std_logic_vector(31 downto 0);
        VectAddr10       : in    std_logic_vector(31 downto 0);
        VectAddr11       : in    std_logic_vector(31 downto 0);
        VectAddr12       : in    std_logic_vector(31 downto 0);
        VectAddr13       : in    std_logic_vector(31 downto 0);
        VectAddr14       : in    std_logic_vector(31 downto 0);
        VectAddr15       : in    std_logic_vector(31 downto 0);
        VectAddr16       : in    std_logic_vector(31 downto 0);
        VectAddr17       : in    std_logic_vector(31 downto 0);
        VectAddr18       : in    std_logic_vector(31 downto 0);
        VectAddr19       : in    std_logic_vector(31 downto 0);
        VectAddr20       : in    std_logic_vector(31 downto 0);
        VectAddr21       : in    std_logic_vector(31 downto 0);
        VectAddr22       : in    std_logic_vector(31 downto 0);
        VectAddr23       : in    std_logic_vector(31 downto 0);
        VectAddr24       : in    std_logic_vector(31 downto 0);
        VectAddr25       : in    std_logic_vector(31 downto 0);
        VectAddr26       : in    std_logic_vector(31 downto 0);
        VectAddr27       : in    std_logic_vector(31 downto 0);
        VectAddr28       : in    std_logic_vector(31 downto 0);
        VectAddr29       : in    std_logic_vector(31 downto 0);
        VectAddr30       : in    std_logic_vector(31 downto 0);
        VectAddr31       : in    std_logic_vector(31 downto 0);
        VICVECTADDRIN    : in    std_logic_vector(31 downto 0);
        IRQRequest       : in    std_logic;
        IRQReqLevel      : in    std_logic_vector(3 downto 0);
        IRQPort          : in    std_logic_vector(5 downto 0);
        IRQSWAck         : in    std_logic;
        IRQSWClear       : in    std_logic;
        nVICSYNCEN       : in    std_logic;
        VICIRQACK        : in    std_logic;
        ITEN             : in    std_logic;
        IRQACKForceVal   : in    std_logic;
        VADDRINForceVal  : in    std_logic_vector(31 downto 0);
        VADDRVForceVal   : in    std_logic;
        ACKOUTForceVal   : in    std_logic;
        VADDRForceVal    : in    std_logic_vector(31 downto 0);
        VICIRQACKOUT     : out   std_logic;
        CurrentPriority  : out   std_logic_vector(15 downto 0);
        VICVectAddrVal   : out   std_logic_vector(31 downto 0);
        VICVECTADDRV     : out   std_logic;
        VICVECTADDROUT   : out   std_logic_vector(31 downto 0);
        IRQACKTestVal    : out   std_logic;
        VADDRINTestVal   : out   std_logic_vector(31 downto 0);
        VADDRVTestVal    : out   std_logic;
        ACKOUTTestVal    : out   std_logic;
        VADDRTestVal     : out   std_logic_vector(31 downto 0)
       );
end component;

-- ----------------------------------------------------------------------------
-- VicInterrupt
-- ----------------------------------------------------------------------------
component VicInterrupt
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        VICINTSOURCE     : in    std_logic_vector(31 downto 0);
        VICSoftInt       : in    std_logic_vector(31 downto 0);
        nVICIRQIN        : in    std_logic;
        nVICFIQIN        : in    std_logic;
        VICFIQINREG      : in    std_logic;
        VICIRQINREG      : in    std_logic;
        VICIntEnable     : in    std_logic_vector(31 downto 0);
        VICIntSelect     : in    std_logic_vector(31 downto 0);
        SWPriorityMask   : in    std_logic_vector(15 downto 0);
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
        CurrentPriority  : in    std_logic_vector(15 downto 0);
        ITEN             : in    std_logic;
        nIRQINForceVal   : in    std_logic;
        nFIQINForceVal   : in    std_logic;
        IRQForceVal      : in    std_logic;
        FIQForceVal      : in    std_logic;
        nIRQINTestVal    : out   std_logic;
        nFIQINTestVal    : out   std_logic;
        IRQTestVal       : out   std_logic;
        FIQTestVal       : out   std_logic;
        nVICFIQ          : out   std_logic;
        nVICIRQ          : out   std_logic;
        IRQRequestRes    : out   std_logic;
        IRQPortRes       : out   std_logic_vector(5 downto 0);
        IRQReqLevelRes   : out   std_logic_vector(3 downto 0);
        VICRawIntr       : out   std_logic_vector(31 downto 0);
        VICFIQStatus     : out   std_logic_vector(31 downto 0);
        VICIRQStatus     : out   std_logic_vector(31 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- VicRevAnd
-- -----------------------------------------------------------------------------
component VicRevAnd
  port (
        TieOff1          : in    std_logic;
        TieOff2          : in    std_logic;
        Revision         : out   std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal VICFIQStatus     : std_logic_vector(31 downto 0);
--  Status of the FIQ after disabling the interrupt

signal VICIRQStatus     : std_logic_vector(31 downto 0);
--  Status of the IRQ after disabling the interrupt

signal VICRawIntr       : std_logic_vector(31 downto 0);
--  RAW interrupt status before masking interrupt

signal VICSoftInt       : std_logic_vector(31 downto 0);
--  Software interrupt

signal VICIntEnable     : std_logic_vector(31 downto 0);
--  Interrupt enable

signal VICIntSelect     : std_logic_vector(31 downto 0);
--  Interrupt type select

signal SWPriorityMask   : std_logic_vector(15 downto 0);
--  Software Priority

signal VectAddr0        : std_logic_vector(31 downto 0);
--  Vector address for 0th interrupt source

signal VectAddr1        : std_logic_vector(31 downto 0);
--  Vector address for 1st interrupt source

signal VectAddr2        : std_logic_vector(31 downto 0);
--  Vector address for 2nd interrupt source

signal VectAddr3        : std_logic_vector(31 downto 0);
--  Vector address for 3rd interrupt source

signal VectAddr4        : std_logic_vector(31 downto 0);
--  Vector address for 4th interrupt source

signal VectAddr5        : std_logic_vector(31 downto 0);
--  Vector address for 5th interrupt source

signal VectAddr6        : std_logic_vector(31 downto 0);
--  Vector address for 6th interrupt source

signal VectAddr7        : std_logic_vector(31 downto 0);
--  Vector address for 7th interrupt source

signal VectAddr8        : std_logic_vector(31 downto 0);
--  Vector address for 8th interrupt source

signal VectAddr9        : std_logic_vector(31 downto 0);
--  Vector address for 9th interrupt source

signal VectAddr10       : std_logic_vector(31 downto 0);
--  Vector address for 10th interrupt source

signal VectAddr11       : std_logic_vector(31 downto 0);
--  Vector address for 11th interrupt source

signal VectAddr12       : std_logic_vector(31 downto 0);
--  Vector address for 12th interrupt source

signal VectAddr13       : std_logic_vector(31 downto 0);
--  Vector address for 13th interrupt source

signal VectAddr14       : std_logic_vector(31 downto 0);
--  Vector address for 14th interrupt source

signal VectAddr15       : std_logic_vector(31 downto 0);
--  Vector address for 15th interrupt source

signal VectAddr16       : std_logic_vector(31 downto 0);
--  Vector address for 16th interrupt source

signal VectAddr17       : std_logic_vector(31 downto 0);
--  Vector address for 17th interrupt source

signal VectAddr18       : std_logic_vector(31 downto 0);
--  Vector address for 18th interrupt source

signal VectAddr19       : std_logic_vector(31 downto 0);
--  Vector address for 19th interrupt source

signal VectAddr20       : std_logic_vector(31 downto 0);
--  Vector address for 20th interrupt source

signal VectAddr21       : std_logic_vector(31 downto 0);
--  Vector address for 21st interrupt source

signal VectAddr22       : std_logic_vector(31 downto 0);
--  Vector address for 22nd interrupt source

signal VectAddr23       : std_logic_vector(31 downto 0);
--  Vector address for 23rd interrupt source

signal VectAddr24       : std_logic_vector(31 downto 0);
--  Vector address for 24th interrupt source

signal VectAddr25       : std_logic_vector(31 downto 0);
--  Vector address for 25th interrupt source

signal VectAddr26       : std_logic_vector(31 downto 0);
--  Vector address for 26th interrupt source

signal VectAddr27       : std_logic_vector(31 downto 0);
--  Vector address for 27th interrupt source

signal VectAddr28       : std_logic_vector(31 downto 0);
--  Vector address for 28th interrupt source

signal VectAddr29       : std_logic_vector(31 downto 0);
--  Vector address for 29th interrupt source

signal VectAddr30       : std_logic_vector(31 downto 0);
--  Vector address for 30th interrupt source

signal VectAddr31       : std_logic_vector(31 downto 0);
--  Vector address for 31st interrupt source

signal VectPriority0    : std_logic_vector(3 downto 0);
--  Vector priority for 0th interrupt source

signal VectPriority1    : std_logic_vector(3 downto 0);
--  Vector priority for 1st interrupt source

signal VectPriority2    : std_logic_vector(3 downto 0);
--  Vector priority for 2nd interrupt source

signal VectPriority3    : std_logic_vector(3 downto 0);
--  Vector priority for 3rd interrupt source

signal VectPriority4    : std_logic_vector(3 downto 0);
--  Vector priority for 4th interrupt source

signal VectPriority5    : std_logic_vector(3 downto 0);
--  Vector priority for 5th interrupt source

signal VectPriority6    : std_logic_vector(3 downto 0);
--  Vector priority for 6th interrupt source

signal VectPriority7    : std_logic_vector(3 downto 0);
--  Vector priority for 7th interrupt source

signal VectPriority8    : std_logic_vector(3 downto 0);
--  Vector priority for 8th interrupt source

signal VectPriority9    : std_logic_vector(3 downto 0);
--  Vector priority for 9th interrupt source

signal VectPriority10   : std_logic_vector(3 downto 0);
--  Vector priority for 10th interrupt source

signal VectPriority11   : std_logic_vector(3 downto 0);
--  Vector priority for 11th interrupt source

signal VectPriority12   : std_logic_vector(3 downto 0);
--  Vector priority for 12th interrupt source

signal VectPriority13   : std_logic_vector(3 downto 0);
--  Vector priority for 13th interrupt source

signal VectPriority14   : std_logic_vector(3 downto 0);
--  Vector priority for 14th interrupt source

signal VectPriority15   : std_logic_vector(3 downto 0);
--  Vector priority for 15th interrupt source

signal VectPriority16   : std_logic_vector(3 downto 0);
--  Vector priority for 16th interrupt source

signal VectPriority17   : std_logic_vector(3 downto 0);
--  Vector priority for 17th interrupt source

signal VectPriority18   : std_logic_vector(3 downto 0);
--  Vector priority for 18th interrupt source

signal VectPriority19   : std_logic_vector(3 downto 0);
--  Vector priority for 19th interrupt source

signal VectPriority20   : std_logic_vector(3 downto 0);
--  Vector priority for 20th interrupt source

signal VectPriority21   : std_logic_vector(3 downto 0);
--  Vector priority for 21st interrupt source

signal VectPriority22   : std_logic_vector(3 downto 0);
--  Vector priority for 22nd interrupt source

signal VectPriority23   : std_logic_vector(3 downto 0);
--  Vector priority for 23rd interrupt source

signal VectPriority24   : std_logic_vector(3 downto 0);
--  Vector priority for 24th interrupt source

signal VectPriority25   : std_logic_vector(3 downto 0);
--  Vector priority for 25th interrupt source

signal VectPriority26   : std_logic_vector(3 downto 0);
--  Vector priority for 26th interrupt source

signal VectPriority27   : std_logic_vector(3 downto 0);
--  Vector priority for 27th interrupt source

signal VectPriority28   : std_logic_vector(3 downto 0);
--  Vector priority for 28th interrupt source

signal VectPriority29   : std_logic_vector(3 downto 0);
--  Vector priority for 29th interrupt source

signal VectPriority30   : std_logic_vector(3 downto 0);
--  Vector priority for 30th interrupt source

signal VectPriority31   : std_logic_vector(3 downto 0);
--  Vector priority for 31st interrupt source

signal VectPriority32   : std_logic_vector(3 downto 0);
--  Vector priority daisy chain interrupt

signal VICVectAddrVal   : std_logic_vector(31 downto 0);
--  VIC vector address of the ISR

signal IRQSWAck         : std_logic;
--  Stack push control

signal IRQSWClear       : std_logic;
--  Stack pop control

signal CurrentPriority  : std_logic_vector(15 downto 0);
--  Current interrupt priority

signal IRQRequest       : std_logic;
--  IRQ request is active

signal IRQPort          : std_logic_vector(5 downto 0);
--  Port number of the interrupt serviced

signal IRQReqLevel      : std_logic_vector(3 downto 0);
--  Priority level of the interrupt serviced

signal ITEN             : std_logic;
--  Integration Test enable

signal nVICIRQINFrcVal  : std_logic;
--  Force value for nVICIRQIN

signal nVICFIQINFrcVal  : std_logic;
--  Force value for nVICFIQIN

signal VICIRQACKFrcVal  : std_logic;
--  Force value for VICIRQACK i/p

signal VECTADDRINFrcVal : std_logic_vector(31 downto 0);
--  Force value for VECTADDRIN

signal VECTADDRVFrcVal  : std_logic;
--  Force value for VICVECTADDRV o/p

signal VICIRQForceVal   : std_logic;
--  Force value for nVICFIQ o/p

signal VICFIQForceVal   : std_logic;
--  Force value for nVICIRQ o/p

signal IRQACKOUTFrcVal  : std_logic;
--  Force value for IRQACKOUT o/p

signal VECTADDRFrcVal   : std_logic_vector(31 downto 0);
--  Force value for VectAddr

signal nVICIRQINTestVal : std_logic;
--  Integration test value of nVICIRQIN

signal nVICFIQINTestVal : std_logic;
--  Integration test value of nVICFIQIN

signal VICIRQACKTestVal : std_logic;
--  Integration test value of VICIRQACK

signal VECTADDRINTstVal : std_logic_vector(31 downto 0);
--  Integration test value of VICVECTADDRIN

signal VECTADDRVTestVal : std_logic;
--  Integration test value of VICVECTADDRV

signal VICIRQTestVal    : std_logic;
--  Integration test value of VICIRQ

signal VICFIQTestVal    : std_logic;
--  Integration test value of VICFIQ

signal IRQACKOUTTestVal : std_logic;
--  Integration test value for VICIRQACKOUT

signal VECTADDRTestVal  : std_logic_vector(31 downto 0);
--  Integration test for VECTADDR

signal Revision         : std_logic_vector(3 downto 0);
--  Revision number for VIC

signal TieOff1          : std_logic_vector(3 downto 0);
--  Tie off1

signal TieOff2          : std_logic_vector(3 downto 0);
--  Tie off2

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
-- Instantiation of the VicInterrupt
-- -----------------------------------------------------------------------------
uVicInterrupt : VicInterrupt
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            VICINTSOURCE     => VICINTSOURCE,
            VICSoftInt       => VICSoftInt,
            nVICIRQIN        => nVICIRQIN,
            nVICFIQIN        => nVICFIQIN,
            VICFIQINREG      => VICFIQINREG,
            VICIRQINREG      => VICIRQINREG,
            VICIntEnable     => VICIntEnable,
            VICIntSelect     => VICIntSelect,
            SWPriorityMask   => SWPriorityMask,
            PLevel0          => VectPriority0,
            PLevel1          => VectPriority1,
            PLevel2          => VectPriority2,
            PLevel3          => VectPriority3,
            PLevel4          => VectPriority4,
            PLevel5          => VectPriority5,
            PLevel6          => VectPriority6,
            PLevel7          => VectPriority7,
            PLevel8          => VectPriority8,
            PLevel9          => VectPriority9,
            PLevel10         => VectPriority10,
            PLevel11         => VectPriority11,
            PLevel12         => VectPriority12,
            PLevel13         => VectPriority13,
            PLevel14         => VectPriority14,
            PLevel15         => VectPriority15,
            PLevel16         => VectPriority16,
            PLevel17         => VectPriority17,
            PLevel18         => VectPriority18,
            PLevel19         => VectPriority19,
            PLevel20         => VectPriority20,
            PLevel21         => VectPriority21,
            PLevel22         => VectPriority22,
            PLevel23         => VectPriority23,
            PLevel24         => VectPriority24,
            PLevel25         => VectPriority25,
            PLevel26         => VectPriority26,
            PLevel27         => VectPriority27,
            PLevel28         => VectPriority28,
            PLevel29         => VectPriority29,
            PLevel30         => VectPriority30,
            PLevel31         => VectPriority31,
            PLevel32         => VectPriority32,
            CurrentPriority  => CurrentPriority,
            ITEN             => ITEN,
            nIRQINForceVal   => nVICIRQINFrcVal,
            nFIQINForceVal   => nVICFIQINFrcVal,
            IRQForceVal      => VICIRQForceVal,
            FIQForceVal      => VICFIQForceVal,
            nIRQINTestVal    => nVICIRQINTestVal,
            nFIQINTestVal    => nVICFIQINTestVal,
            IRQTestVal       => VICIRQTestVal,
            FIQTestVal       => VICFIQTestVal,
            nVICFIQ          => nVICFIQ,
            nVICIRQ          => nVICIRQ,
            IRQRequestRes    => IRQRequest,
            IRQPortRes       => IRQPort,
            IRQReqLevelRes   => IRQReqLevel,
            VICRawIntr       => VICRawIntr,
            VICFIQStatus     => VICFIQStatus,
            VICIRQStatus     => VICIRQStatus
           );

-- -----------------------------------------------------------------------------
-- Instantiation of the VicAhbif
-- -----------------------------------------------------------------------------
uVicAhbif : VicAhbif
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HSELVIC          => HSELVIC,
            HADDR            => HADDR(11 downto 2),
            HTRANS1          => HTRANS(1),
            HWRITE           => HWRITE,
            HREADYIN         => HREADYIN,
            HPROT1           => HPROT(1),
            HSIZE            => HSIZE(2 downto 0),
            HWDATA           => HWDATA,
            Revision         => Revision,
            VICFIQStatus     => VICFIQStatus,
            VICIRQStatus     => VICIRQStatus,
            VICRawIntr       => VICRawIntr,
            VICINTSOURCE     => VICINTSOURCE,
            VICVectAddrVal   => VICVectAddrVal,
            IRQACKTestVal    => VICIRQACKTestVal,
            nIRQINTestVal    => nVICIRQINTestVal,
            nFIQINTestVal    => nVICFIQINTestVal,
            VADDRINTestVal   => VECTADDRINTstVal,
            VADDRVTestVal    => VECTADDRVTestVal,
            IRQTestVal       => VICIRQTestVal,
            FIQTestVal       => VICFIQTestVal,
            ACKOUTTestVal    => IRQACKOUTTestVal,
            VADDRTestVal     => VECTADDRTestVal,
            VICFIQINREG      => VICFIQINREG,
            VICIRQINREG      => VICIRQINREG,
            HRESP            => HRESP,
            HREADYOUT        => HREADYOUT,
            HRDATA           => HRDATA,
            VICSoftInt       => VICSoftInt,
            VICIntEnable     => VICIntEnable,
            VICIntSelect     => VICIntSelect,
            SWPriorityMask   => SWPriorityMask,
            VectAddr0        => VectAddr0,
            VectAddr1        => VectAddr1,
            VectAddr2        => VectAddr2,
            VectAddr3        => VectAddr3,
            VectAddr4        => VectAddr4,
            VectAddr5        => VectAddr5,
            VectAddr6        => VectAddr6,
            VectAddr7        => VectAddr7,
            VectAddr8        => VectAddr8,
            VectAddr9        => VectAddr9,
            VectAddr10       => VectAddr10,
            VectAddr11       => VectAddr11,
            VectAddr12       => VectAddr12,
            VectAddr13       => VectAddr13,
            VectAddr14       => VectAddr14,
            VectAddr15       => VectAddr15,
            VectAddr16       => VectAddr16,
            VectAddr17       => VectAddr17,
            VectAddr18       => VectAddr18,
            VectAddr19       => VectAddr19,
            VectAddr20       => VectAddr20,
            VectAddr21       => VectAddr21,
            VectAddr22       => VectAddr22,
            VectAddr23       => VectAddr23,
            VectAddr24       => VectAddr24,
            VectAddr25       => VectAddr25,
            VectAddr26       => VectAddr26,
            VectAddr27       => VectAddr27,
            VectAddr28       => VectAddr28,
            VectAddr29       => VectAddr29,
            VectAddr30       => VectAddr30,
            VectAddr31       => VectAddr31,
            VectPriority0    => VectPriority0,
            VectPriority1    => VectPriority1,
            VectPriority2    => VectPriority2,
            VectPriority3    => VectPriority3,
            VectPriority4    => VectPriority4,
            VectPriority5    => VectPriority5,
            VectPriority6    => VectPriority6,
            VectPriority7    => VectPriority7,
            VectPriority8    => VectPriority8,
            VectPriority9    => VectPriority9,
            VectPriority10   => VectPriority10,
            VectPriority11   => VectPriority11,
            VectPriority12   => VectPriority12,
            VectPriority13   => VectPriority13,
            VectPriority14   => VectPriority14,
            VectPriority15   => VectPriority15,
            VectPriority16   => VectPriority16,
            VectPriority17   => VectPriority17,
            VectPriority18   => VectPriority18,
            VectPriority19   => VectPriority19,
            VectPriority20   => VectPriority20,
            VectPriority21   => VectPriority21,
            VectPriority22   => VectPriority22,
            VectPriority23   => VectPriority23,
            VectPriority24   => VectPriority24,
            VectPriority25   => VectPriority25,
            VectPriority26   => VectPriority26,
            VectPriority27   => VectPriority27,
            VectPriority28   => VectPriority28,
            VectPriority29   => VectPriority29,
            VectPriority30   => VectPriority30,
            VectPriority31   => VectPriority31,
            VectPriority32   => VectPriority32,
            IRQSWAck         => IRQSWAck,
            IRQSWClear       => IRQSWClear,
            ITEN             => ITEN,
            IRQACKForceVal   => VICIRQACKFrcVal,
            nIRQINForceVal   => nVICIRQINFrcVal,
            nFIQINForceVal   => nVICFIQINFrcVal,
            VECTADDRINFrcVal => VECTADDRINFrcVal,
            VECTADDRVFrcVal  => VECTADDRVFrcVal,
            IRQForceVal      => VICIRQForceVal,
            FIQForceVal      => VICFIQForceVal,
            IRQACKOUTFrcVal  => IRQACKOUTFrcVal,
            VECTADDRFrcVal   => VECTADDRFrcVal
           );

-- -----------------------------------------------------------------------------
-- Instantiation of the VicCpuif
-- -----------------------------------------------------------------------------
uVicCpuif : VicCpuif
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            VectAddr0        => VectAddr0,
            VectAddr1        => VectAddr1,
            VectAddr2        => VectAddr2,
            VectAddr3        => VectAddr3,
            VectAddr4        => VectAddr4,
            VectAddr5        => VectAddr5,
            VectAddr6        => VectAddr6,
            VectAddr7        => VectAddr7,
            VectAddr8        => VectAddr8,
            VectAddr9        => VectAddr9,
            VectAddr10       => VectAddr10,
            VectAddr11       => VectAddr11,
            VectAddr12       => VectAddr12,
            VectAddr13       => VectAddr13,
            VectAddr14       => VectAddr14,
            VectAddr15       => VectAddr15,
            VectAddr16       => VectAddr16,
            VectAddr17       => VectAddr17,
            VectAddr18       => VectAddr18,
            VectAddr19       => VectAddr19,
            VectAddr20       => VectAddr20,
            VectAddr21       => VectAddr21,
            VectAddr22       => VectAddr22,
            VectAddr23       => VectAddr23,
            VectAddr24       => VectAddr24,
            VectAddr25       => VectAddr25,
            VectAddr26       => VectAddr26,
            VectAddr27       => VectAddr27,
            VectAddr28       => VectAddr28,
            VectAddr29       => VectAddr29,
            VectAddr30       => VectAddr30,
            VectAddr31       => VectAddr31,
            VICVECTADDRIN    => VICVECTADDRIN,
            IRQRequest       => IRQRequest,
            IRQReqLevel      => IRQReqLevel,
            IRQPort          => IRQPort,
            IRQSWAck         => IRQSWAck,
            IRQSWClear       => IRQSWClear,
            nVICSYNCEN       => nVICSYNCEN,
            VICIRQACK        => VICIRQACK,
            ITEN             => ITEN,
            IRQACKForceVal   => VICIRQACKFrcVal,
            VADDRINForceVal  => VECTADDRINFrcVal,
            VADDRVForceVal   => VECTADDRVFrcVal,
            ACKOUTForceVal   => IRQACKOUTFrcVal,
            VADDRForceVal    => VECTADDRFrcVal,
            VICIRQACKOUT     => VICIRQACKOUT,
            CurrentPriority  => CurrentPriority,
            VICVectAddrVal   => VICVectAddrVal,
            VICVECTADDRV     => VICVECTADDRV,
            VICVECTADDROUT   => VICVECTADDROUT,
            IRQACKTestVal    => VICIRQACKTestVal,
            VADDRINTestVal   => VECTADDRINTstVal,
            VADDRVTestVal    => VECTADDRVTestVal,
            ACKOUTTestVal    => IRQACKOUTTestVal,
            VADDRTestVal     => VECTADDRTestVal
           );

-- -----------------------------------------------------------------------------
-- Instantiation of VicRevAnd for bit 0 of Revision
-- -----------------------------------------------------------------------------
u0VicRevAnd : VicRevAnd
  port map (
            TieOff1          => TieOff1(0),
            TieOff2          => TieOff2(0),
            Revision         => Revision(0)
           );

-- -----------------------------------------------------------------------------
-- Instantiation of VicRevAnd for bit 1 of Revision
-- -----------------------------------------------------------------------------
u1VicRevAnd : VicRevAnd
  port map (
            TieOff1          => TieOff1(1),
            TieOff2          => TieOff2(1),
            Revision         => Revision(1)
           );

-- -----------------------------------------------------------------------------
-- Instantiation of VicRevAnd for bit 2 of Revision
-- -----------------------------------------------------------------------------
u2VicRevAnd : VicRevAnd
  port map (
            TieOff1          => TieOff1(2),
            TieOff2          => TieOff2(2),
            Revision         => Revision(2)
           );

-- -----------------------------------------------------------------------------
-- Instantiation of VicRevAnd for bit 3 of Revision
-- -----------------------------------------------------------------------------
u3VicRevAnd : VicRevAnd
  port map (
            TieOff1          => TieOff1(3),
            TieOff2          => TieOff2(3),
            Revision         => Revision(3)
           );

-- -----------------------------------------------------------------------------
-- Assign the Revision Number
--
-- The Revision Number of the VIC is determined by the values assigned
-- to the TieOff1 and TieOff2 signals. A TieOff1 = TieOff2 = 0000 value
-- will set the Revision field of the VIC Peripheral ID to 0000. This
-- is the default.
--
-- If a different Revision number is to be used, change the values
-- assigned to the TieOff1 and TieOff2 signals. For example, to
-- use a Revision Number of 0001, change TieOff1 and TieOff2 to 0001.
-- -----------------------------------------------------------------------------
TieOff1  <= "0000";
TieOff2  <= "0000";

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
