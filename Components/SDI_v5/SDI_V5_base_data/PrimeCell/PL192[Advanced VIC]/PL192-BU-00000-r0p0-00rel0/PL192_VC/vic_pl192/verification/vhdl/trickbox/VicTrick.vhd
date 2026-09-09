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
-- File Name              : VicTrick.vhd.rca
-- File Revision          : 1.6
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Top level of the VIC Trickbox.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity VicTrick is
  generic (
           Tclk             : time := 10 ns
          );
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB Clock
        HRESETn          : in    std_logic; -- AHB Reset
        HREADYIN         : in    std_logic; -- Transfer Ready Signal
        HADDR            : in    std_logic_vector(11 downto 2);
                                            -- Address Bus for AHB Slave
        HTRANS           : in    std_logic; -- Transfer signal for
                                            -- AHB Slave
        HSIZE            : in    std_logic_vector(2 downto 0);
                                            -- AHB transfer size
        HWRITE           : in    std_logic; -- Write Signal for AHB
                                            -- Slave
        HPROT            : in    std_logic; -- Protection Control signal
        HWDATA           : in    std_logic_vector(31 downto 0);
                                            -- Write Data input for AHB
                                            -- Slave
        HSELVICTR        : in    std_logic; -- Slave Select Signal for
                                            -- the VIC Trickbox
        HSELVIC          : in    std_logic; -- Slave Select Signal for
                                            -- the VIC
        nVICFIQ          : in    std_logic; -- nVICFIQ output from the
                                            -- VIC
        nVICIRQ          : in    std_logic; -- nVICIRQ output from the
                                            -- VIC
        VICVECTADDROUT   : in    std_logic_vector(31 downto 0);
                                            -- VICVECTADDROUT output
                                            -- from the VIC
        VICVECTADDRV     : in    std_logic; -- VIC Address valid Signal 
                                            -- which indicates Address valid
        VICIRQACKOUT     : in    std_logic; -- VIC Acknowledge signal

-- Outputs
        HCLKTRICK        : out   std_logic; -- Clock to UUT and mirrored 
                                            -- trickbox.
        HRDATA           : out   std_logic_vector(31 downto 0);
                                            -- Read Data output from AHB
                                            -- Slave
        HREADYOUT        : out   std_logic; -- Ready Signal from
                                            -- AHB Slave
        HRESP            : out   std_logic_vector(1 downto 0);
                                            -- Transfer Response from
                                            -- AHB Slave
        VICINTSOURCE     : out   std_logic_vector(31 downto 0);
                                            -- Output lines for raising
                                            -- Interrupt requests to the
                                            -- VIC
        VICSYNCEN        : out   std_logic; -- VIC Synchronization enable 
        VICIRQACK        : out   std_logic; -- Acknowledge signal to the VIC 
        VICVECTADDRIN    : out   std_logic_vector(31 downto 0);
                                            -- VICVECTADDRIN Daisy
                                            -- chain Vector address
                                            -- signal to the VIC
        nVICFIQIN        : out   std_logic; -- nVICFIQIN Daisy chain
                                            -- signal to the VIC
        nVICIRQIN        : out   std_logic; -- nVICIRQIN Daisy chain
                                            -- signal to the VIC
        VICFIQINREG      : out   std_logic; -- Daisy Chain Fiq Interrupt
                                            -- signal to the VIC
        VICIRQINREG      : out   std_logic  -- Daisy Chain Fiq Interrupt 
                                            -- signal to the VIC
       );
end VicTrick;

-- -----------------------------------------------------------------------------
--
--                              VicTrick
--                              ========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- This block is the top level of the VIC Trickbox. This block
-- instantiates the following sub-blocks:
--
-- 1. VicTrAhbif
-- 2. VicMirTrickbox
--    1. VicTrIntReqLog
--    2. VicTrFiqIntrLog
--    3. VicTrIrqIntrLog
--    4. VicTrIrqPriLog
-- 3. VicTrProtChkr
--
-- -----------------------------------------------------------------------------

-- --=========================== ARCHITECTURE ================================--

architecture structural of VicTrick is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- AHB Interface
-- -----------------------------------------------------------------------------
component VicTrAhbif
  generic (
           tovmaxintsrc     : time;
           tovmaxnvicfiqin  : time;
           tovmaxnvicirqin  : time;
           tovmaxvectadin   : time
          );
  port (
        HCLK             : in  std_logic;
        HRESETn          : in  std_logic;
        HREADYIN         : in  std_logic;
        HADDR            : in  std_logic_vector(11 downto 2);
        HTRANS           : in  std_logic;
        HSIZE            : in  std_logic_vector(2 downto 0);
        HWRITE           : in  std_logic;
        HPROT            : in  std_logic;
        HWDATA           : in  std_logic_vector(31 downto 0);
        HSELVICTR        : in  std_logic;
        HSELVIC          : in  std_logic;
        VICTrVectAddr    : in  std_logic_vector(31 downto 0);
        nVICFIQ          : in  std_logic;
        nVICIRQ          : in  std_logic;
        VICVECTADDROUT   : in  std_logic_vector(31 downto 0);
        VICVECTADDRV     : in  std_logic;
        HRDATA           : out std_logic_vector(31 downto 0);
        HREADYOUT        : out std_logic;
        HRESP            : out std_logic_vector(1 downto 0);
        VICTrTCR         : out std_logic_vector(8 downto 0);
        VICINTSOURCE     : out std_logic_vector(31 downto 0);
        VICVECTADDRIN    : out std_logic_vector(31 downto 0);
        nVICFIQIN        : out std_logic;
        nVICIRQIN        : out std_logic;
        VICIRQINREG      : out std_logic;
        VICFIQINREG      : out std_logic;
        nVICSYNCEN       : out std_logic;
        VICTrSoftInt     : out std_logic_vector(31 downto 0);
        VICTrIntEnable   : out std_logic_vector(31 downto 0);
        VICTrIntSelect   : out std_logic_vector(31 downto 0);
        VICTrSwPriMask   : out std_logic_vector(15 downto 0);
        VICTrVectPriDsy  : out std_logic_vector(3 downto 0);
        VICTrVectAddr0   : out std_logic_vector(31 downto 0);
        VICTrVectAddr1   : out std_logic_vector(31 downto 0);
        VICTrVectAddr2   : out std_logic_vector(31 downto 0);
        VICTrVectAddr3   : out std_logic_vector(31 downto 0);
        VICTrVectAddr4   : out std_logic_vector(31 downto 0);
        VICTrVectAddr5   : out std_logic_vector(31 downto 0);
        VICTrVectAddr6   : out std_logic_vector(31 downto 0);
        VICTrVectAddr7   : out std_logic_vector(31 downto 0);
        VICTrVectAddr8   : out std_logic_vector(31 downto 0);
        VICTrVectAddr9   : out std_logic_vector(31 downto 0);
        VICTrVectAddr10  : out std_logic_vector(31 downto 0);
        VICTrVectAddr11  : out std_logic_vector(31 downto 0);
        VICTrVectAddr12  : out std_logic_vector(31 downto 0);
        VICTrVectAddr13  : out std_logic_vector(31 downto 0);
        VICTrVectAddr14  : out std_logic_vector(31 downto 0);
        VICTrVectAddr15  : out std_logic_vector(31 downto 0);
        VICTrVectAddr16  : out std_logic_vector(31 downto 0);
        VICTrVectAddr17  : out std_logic_vector(31 downto 0);
        VICTrVectAddr18  : out std_logic_vector(31 downto 0);
        VICTrVectAddr19  : out std_logic_vector(31 downto 0);
        VICTrVectAddr20  : out std_logic_vector(31 downto 0);
        VICTrVectAddr21  : out std_logic_vector(31 downto 0);
        VICTrVectAddr22  : out std_logic_vector(31 downto 0);
        VICTrVectAddr23  : out std_logic_vector(31 downto 0);
        VICTrVectAddr24  : out std_logic_vector(31 downto 0);
        VICTrVectAddr25  : out std_logic_vector(31 downto 0);
        VICTrVectAddr26  : out std_logic_vector(31 downto 0);
        VICTrVectAddr27  : out std_logic_vector(31 downto 0);
        VICTrVectAddr28  : out std_logic_vector(31 downto 0);
        VICTrVectAddr29  : out std_logic_vector(31 downto 0);
        VICTrVectAddr30  : out std_logic_vector(31 downto 0);
        VICTrVectAddr31  : out std_logic_vector(31 downto 0);
        VICTrVectPrity0  : out std_logic_vector(3 downto 0);
        VICTrVectPrity1  : out std_logic_vector(3 downto 0);
        VICTrVectPrity2  : out std_logic_vector(3 downto 0);
        VICTrVectPrity3  : out std_logic_vector(3 downto 0);
        VICTrVectPrity4  : out std_logic_vector(3 downto 0);
        VICTrVectPrity5  : out std_logic_vector(3 downto 0);
        VICTrVectPrity6  : out std_logic_vector(3 downto 0);
        VICTrVectPrity7  : out std_logic_vector(3 downto 0);
        VICTrVectPrity8  : out std_logic_vector(3 downto 0);
        VICTrVectPrity9  : out std_logic_vector(3 downto 0);
        VICTrVectPrity10 : out std_logic_vector(3 downto 0);
        VICTrVectPrity11 : out std_logic_vector(3 downto 0);
        VICTrVectPrity12 : out std_logic_vector(3 downto 0);
        VICTrVectPrity13 : out std_logic_vector(3 downto 0);
        VICTrVectPrity14 : out std_logic_vector(3 downto 0);
        VICTrVectPrity15 : out std_logic_vector(3 downto 0);
        VICTrVectPrity16 : out std_logic_vector(3 downto 0);
        VICTrVectPrity17 : out std_logic_vector(3 downto 0);
        VICTrVectPrity18 : out std_logic_vector(3 downto 0);
        VICTrVectPrity19 : out std_logic_vector(3 downto 0);
        VICTrVectPrity20 : out std_logic_vector(3 downto 0);
        VICTrVectPrity21 : out std_logic_vector(3 downto 0);
        VICTrVectPrity22 : out std_logic_vector(3 downto 0);
        VICTrVectPrity23 : out std_logic_vector(3 downto 0);
        VICTrVectPrity24 : out std_logic_vector(3 downto 0);
        VICTrVectPrity25 : out std_logic_vector(3 downto 0);
        VICTrVectPrity26 : out std_logic_vector(3 downto 0);
        VICTrVectPrity27 : out std_logic_vector(3 downto 0);
        VICTrVectPrity28 : out std_logic_vector(3 downto 0);
        VICTrVectPrity29 : out std_logic_vector(3 downto 0);
        VICTrVectPrity30 : out std_logic_vector(3 downto 0);
        VICTrVectPrity31 : out std_logic_vector(3 downto 0);
        VICACKOUT        : out std_logic;
        HCLKTRICK        : out std_logic;
        VectAddrWrTrig   : out std_logic;
        VectAddrRdTrig   : out std_logic;
        AsyncRdEn        : out std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- VIC Mirror Trickbox 
-- -----------------------------------------------------------------------------
component VicMirTrickbox
  port (
        HCLK             : in  std_logic;
        HRESETn          : in  std_logic;
        VicTrIntSource   : in  std_logic_vector(31 downto 0);
        nVicTrFiqIn      : in  std_logic;
        nVicTrIrqIn      : in  std_logic;
        VicTrVectAddrIn  : in  std_logic_vector(31 downto 0);
        VicTrIrqInReg    : in  std_logic;
        VicTrFiqInReg    : in  std_logic;
        VicTrIrqAck      : in  std_logic;
        nVicTrSyncEn     : in  std_logic;
        VicTrSoftInt     : in  std_logic_vector(31 downto 0);
        VicTrIntEn       : in  std_logic_vector(31 downto 0);
        VicTrIntSelect   : in  std_logic_vector(31 downto 0);
        VicTrSwPriMask   : in  std_logic_vector(15 downto 0);
        VicTrVectPriDsy  : in  std_logic_vector(3 downto 0);
        VicTrVectPrity0  : in  std_logic_vector(3 downto 0);
        VicTrVectPrity1  : in  std_logic_vector(3 downto 0);
        VicTrVectPrity2  : in  std_logic_vector(3 downto 0);
        VicTrVectPrity3  : in  std_logic_vector(3 downto 0);
        VicTrVectPrity4  : in  std_logic_vector(3 downto 0);
        VicTrVectPrity5  : in  std_logic_vector(3 downto 0);
        VicTrVectPrity6  : in  std_logic_vector(3 downto 0);
        VicTrVectPrity7  : in  std_logic_vector(3 downto 0);
        VicTrVectPrity8  : in  std_logic_vector(3 downto 0);
        VicTrVectPrity9  : in  std_logic_vector(3 downto 0);
        VicTrVectPrity10 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity11 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity12 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity13 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity14 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity15 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity16 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity17 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity18 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity19 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity20 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity21 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity22 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity23 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity24 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity25 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity26 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity27 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity28 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity29 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity30 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity31 : in  std_logic_vector(3 downto 0);
        VicTrVectAddr0   : in  std_logic_vector(31 downto 0);
        VicTrVectAddr1   : in  std_logic_vector(31 downto 0);
        VicTrVectAddr2   : in  std_logic_vector(31 downto 0);
        VicTrVectAddr3   : in  std_logic_vector(31 downto 0);
        VicTrVectAddr4   : in  std_logic_vector(31 downto 0);
        VicTrVectAddr5   : in  std_logic_vector(31 downto 0);
        VicTrVectAddr6   : in  std_logic_vector(31 downto 0);
        VicTrVectAddr7   : in  std_logic_vector(31 downto 0);
        VicTrVectAddr8   : in  std_logic_vector(31 downto 0);
        VicTrVectAddr9   : in  std_logic_vector(31 downto 0);
        VicTrVectAddr10  : in  std_logic_vector(31 downto 0);
        VicTrVectAddr11  : in  std_logic_vector(31 downto 0);
        VicTrVectAddr12  : in  std_logic_vector(31 downto 0);
        VicTrVectAddr13  : in  std_logic_vector(31 downto 0);
        VicTrVectAddr14  : in  std_logic_vector(31 downto 0);
        VicTrVectAddr15  : in  std_logic_vector(31 downto 0);
        VicTrVectAddr16  : in  std_logic_vector(31 downto 0);
        VicTrVectAddr17  : in  std_logic_vector(31 downto 0);
        VicTrVectAddr18  : in  std_logic_vector(31 downto 0);
        VicTrVectAddr19  : in  std_logic_vector(31 downto 0);
        VicTrVectAddr20  : in  std_logic_vector(31 downto 0);
        VicTrVectAddr21  : in  std_logic_vector(31 downto 0);
        VicTrVectAddr22  : in  std_logic_vector(31 downto 0);
        VicTrVectAddr23  : in  std_logic_vector(31 downto 0);
        VicTrVectAddr24  : in  std_logic_vector(31 downto 0);
        VicTrVectAddr25  : in  std_logic_vector(31 downto 0);
        VicTrVectAddr26  : in  std_logic_vector(31 downto 0);
        VicTrVectAddr27  : in  std_logic_vector(31 downto 0);
        VicTrVectAddr28  : in  std_logic_vector(31 downto 0);
        VicTrVectAddr29  : in  std_logic_vector(31 downto 0);
        VicTrVectAddr30  : in  std_logic_vector(31 downto 0);
        VicTrVectAddr31  : in  std_logic_vector(31 downto 0);
        VectAddrWrTrig   : in  std_logic;
        VectAddrRdTrig   : in  std_logic;
        AsyncRdEn        : in  std_logic;
        VicTrRawIntr     : out std_logic_vector(31 downto 0);
        VicTrIrqStatus   : out std_logic_vector(31 downto 0);
        VicTrFiqStatus   : out std_logic_vector(31 downto 0);
        nVicTrFiq        : out std_logic;
        nVicTrIrq        : out std_logic;
        VicTrIrqAckOut   : out std_logic;
        VicTrVectAddrv   : out std_logic;
        VicTrVectAddr    : out std_logic_vector(31 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- Output Comparator
-- -----------------------------------------------------------------------------
component VicTrProtChkr
  port (
        HCLK             : in std_logic;
        HRESETn          : in std_logic;
        VICTrTCR         : in std_logic_vector(8 downto 0);
        nVICFIQ          : in std_logic;
        nFIQ             : in std_logic;
        nVICIRQ          : in std_logic;
        nIRQ             : in std_logic;
        VICVECTADDRV     : in std_logic;
        VICTrVectAddrv   : in std_logic;
        VICIRQACKOUT     : in std_logic;
        VicTrIrqAckOut   : in std_logic;
        VICVECTADDROUT   : in std_logic_vector(31 downto 0);
        VICTrVectAddrOut : in std_logic_vector(31 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Timing Parameters of Trickbox
--------------------------------------------------------------------------------
constant tovmaxintsrc     : time := 0.05 * Tclk;
-- VICINTSOURCE valid time (max) after HCLK rising edge

constant tovmaxnvicfiqin  : time := 0.2 * Tclk;
-- nVICFIQIN valid time (max) after HCLK rising edge

constant tovmaxnvicirqin  : time := 0.2 * Tclk;
-- nVICIRQIN valid time (max) after HCLK rising edge

constant tovmaxvectadin   : time := 0.2 * Tclk;
-- VICVECTADDRIN valid time (max) after HCLK rising edge

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------
signal VICTrSoftInt      : std_logic_vector(31 downto 0);
-- SoftInt register

signal VICTrIntEnable    : std_logic_vector(31 downto 0);
-- IntEnable register

signal VICTrIntSelect    : std_logic_vector(31 downto 0);
-- IntSelect register

signal VICTrSwPriMask    : std_logic_vector(15 downto 0);
-- Software Priority Mask register

signal VICTrVectPriDsy   : std_logic_vector(3 downto 0);
-- Priority Programmable register for Daisy chain Irq Interrupt

signal VICTrVectPrity0   : std_logic_vector(3 downto 0);
-- Priority Programmable register0

signal VICTrVectPrity1   : std_logic_vector(3 downto 0);
-- Priority Programmable register1

signal VICTrVectPrity2   : std_logic_vector(3 downto 0);
-- Priority Programmable register2

signal VICTrVectPrity3   : std_logic_vector(3 downto 0);
-- Priority Programmable register3

signal VICTrVectPrity4   : std_logic_vector(3 downto 0);
-- Priority Programmable register4

signal VICTrVectPrity5   : std_logic_vector(3 downto 0);
-- Priority Programmable register5

signal VICTrVectPrity6   : std_logic_vector(3 downto 0);
-- Priority Programmable register6

signal VICTrVectPrity7   : std_logic_vector(3 downto 0);
-- Priority Programmable register7

signal VICTrVectPrity8   : std_logic_vector(3 downto 0);
-- Priority Programmable register8

signal VICTrVectPrity9   : std_logic_vector(3 downto 0);
-- Priority Programmable register9

signal VICTrVectPrity10  : std_logic_vector(3 downto 0);
-- Priority Programmable register10

signal VICTrVectPrity11  : std_logic_vector(3 downto 0);
-- Priority Programmable register11

signal VICTrVectPrity12  : std_logic_vector(3 downto 0);
-- Priority Programmable register12

signal VICTrVectPrity13  : std_logic_vector(3 downto 0);
-- Priority Programmable register13

signal VICTrVectPrity14  : std_logic_vector(3 downto 0);
-- Priority Programmable register14

signal VICTrVectPrity15  : std_logic_vector(3 downto 0);
-- Priority Programmable register15

signal VICTrVectPrity16  : std_logic_vector(3 downto 0);
-- Priority Programmable register16

signal VICTrVectPrity17  : std_logic_vector(3 downto 0);
-- Priority Programmable register17

signal VICTrVectPrity18  : std_logic_vector(3 downto 0);
-- Priority Programmable register18

signal VICTrVectPrity19  : std_logic_vector(3 downto 0);
-- Priority Programmable register19

signal VICTrVectPrity20  : std_logic_vector(3 downto 0);
-- Priority Programmable register20

signal VICTrVectPrity21  : std_logic_vector(3 downto 0);
-- Priority Programmable register21

signal VICTrVectPrity22  : std_logic_vector(3 downto 0);
-- Priority Programmable register22

signal VICTrVectPrity23  : std_logic_vector(3 downto 0);
-- Priority Programmable register23

signal VICTrVectPrity24  : std_logic_vector(3 downto 0);
-- Priority Programmable register24

signal VICTrVectPrity25  : std_logic_vector(3 downto 0);
-- Priority Programmable register25

signal VICTrVectPrity26  : std_logic_vector(3 downto 0);
-- Priority Programmable register26

signal VICTrVectPrity27  : std_logic_vector(3 downto 0);
-- Priority Programmable register27

signal VICTrVectPrity28  : std_logic_vector(3 downto 0);
-- Priority Programmable register28

signal VICTrVectPrity29  : std_logic_vector(3 downto 0);
-- Priority Programmable register29

signal VICTrVectPrity30  : std_logic_vector(3 downto 0);
-- Priority Programmable register30

signal VICTrVectPrity31  : std_logic_vector(3 downto 0);
-- Priority Programmable register31

signal VICTrVectAddr0    : std_logic_vector(31 downto 0);
-- VectorAddress 0 register

signal VICTrVectAddr1    : std_logic_vector(31 downto 0);
-- VectorAddress 1 register

signal VICTrVectAddr2    : std_logic_vector(31 downto 0);
-- VectorAddress 2 register

signal VICTrVectAddr3    : std_logic_vector(31 downto 0);
-- VectorAddress 3 register

signal VICTrVectAddr4    : std_logic_vector(31 downto 0);
-- VectorAddress 4 register

signal VICTrVectAddr5    : std_logic_vector(31 downto 0);
-- VectorAddress 5 register

signal VICTrVectAddr6    : std_logic_vector(31 downto 0);
-- VectorAddress 6 register

signal VICTrVectAddr7    : std_logic_vector(31 downto 0);
-- VectorAddress 7 register

signal VICTrVectAddr8    : std_logic_vector(31 downto 0);
-- VectorAddress 8 register

signal VICTrVectAddr9    : std_logic_vector(31 downto 0);
-- VectorAddress 9 register

signal VICTrVectAddr10   : std_logic_vector(31 downto 0);
-- VectorAddress 10 register

signal VICTrVectAddr11   : std_logic_vector(31 downto 0);
-- VectorAddress 11 register

signal VICTrVectAddr12   : std_logic_vector(31 downto 0);
-- VectorAddress 12 register

signal VICTrVectAddr13   : std_logic_vector(31 downto 0);
-- VectorAddress 13 register

signal VICTrVectAddr14   : std_logic_vector(31 downto 0);
-- VectorAddress 14 register

signal VICTrVectAddr15   : std_logic_vector(31 downto 0);
-- VectorAddress 15 register

signal VICTrVectAddr16   : std_logic_vector(31 downto 0);
-- VectorAddress 16 register

signal VICTrVectAddr17   : std_logic_vector(31 downto 0);
-- VectorAddress 17 register

signal VICTrVectAddr18   : std_logic_vector(31 downto 0);
-- VectorAddress 18 register

signal VICTrVectAddr19   : std_logic_vector(31 downto 0);
-- VectorAddress 19 register

signal VICTrVectAddr20   : std_logic_vector(31 downto 0);
-- VectorAddress 20 register

signal VICTrVectAddr21   : std_logic_vector(31 downto 0);
-- VectorAddress 21 register

signal VICTrVectAddr22   : std_logic_vector(31 downto 0);
-- VectorAddress 22 register

signal VICTrVectAddr23   : std_logic_vector(31 downto 0);
-- VectorAddress 23 register

signal VICTrVectAddr24   : std_logic_vector(31 downto 0);
-- VectorAddress 24 register

signal VICTrVectAddr25   : std_logic_vector(31 downto 0);
-- VectorAddress 25 register

signal VICTrVectAddr26   : std_logic_vector(31 downto 0);
-- VectorAddress 26 register

signal VICTrVectAddr27   : std_logic_vector(31 downto 0);
-- VectorAddress 27 register

signal VICTrVectAddr28   : std_logic_vector(31 downto 0);
-- VectorAddress 28 register

signal VICTrVectAddr29   : std_logic_vector(31 downto 0);
-- VectorAddress 29 register

signal VICTrVectAddr30   : std_logic_vector(31 downto 0);
-- VectorAddress 30 register

signal VICTrVectAddr31   : std_logic_vector(31 downto 0);
-- VectorAddress 31 register

signal VICTrIntSource    : std_logic_vector(31 downto 0);
-- Interrupt source register

signal VICTrVectAddrIn   : std_logic_vector(31 downto 0);
-- Vector AddressIn register

signal nVICTrFiqIn       : std_logic;
-- nVICFIQIN Daisy chain signal

signal nVICTrIrqIn       : std_logic;
-- nVICIRQIN Daisy chain signal

signal VICTrFiqInReg    : std_logic;
-- nVICFIQIN Daisy chain signal

signal VICTrIrqInReg    : std_logic;
-- nVICIRQIN Daisy chain signal

signal VICTrRawIntr      : std_logic_vector(31 downto 0);
-- Raw Interrupt register

signal VICTrFiqStatus    : std_logic_vector(31 downto 0);
-- FIQ Status register

signal VICTrIrqStatus    : std_logic_vector(31 downto 0);
-- IRQ Status register

signal nVICTrFiq         : std_logic;
-- nFIQ from Mirrored VIC model

signal nVICTrIrq         : std_logic;
-- nIRQ from Mirrored VIC model

signal VICTrVectAddr     : std_logic_vector(31 downto 0);
-- Updated Vector address for selected Interrupt source

signal VICTrVectAddrOut  : std_logic_vector(31 downto 0);
-- VectAddrOut from the internal mirrored model

signal VICTrTcr          : std_logic_vector(8 downto 0);
-- Error Message Enabling signal

signal VectAddrWrTrig    : std_logic;
-- Write Enable signal on VICADDRESS register implemented in AHB Block

signal VectAddrRdTrig    : std_logic;
-- Read Enable signal on VICADDRESS register implemented in AHB Block

signal AsyncRdEn         : std_logic;
-- Asynchronous Read Enable

signal VICTrIrqAck       : std_logic;
-- Acknowledge signal internally generated to Mirror Trickbox and uut

signal VICTrIrqAckOut    : std_logic;
-- Acknowledge Out signal from Mirrored VIC model

signal nVICTrSyncEn      : std_logic;
-- Synchronous Enable signal

signal iHCLKTRICK        : std_logic;
-- HCLK Internal

signal VICTrVectAddrv    : std_logic;
-- Vector Address Valid signal

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- Assigns output signals of the VIC Trickbox
-- -----------------------------------------------------------------------------
VICINTSOURCE     <= VICTrIntSource;
VICVECTADDRIN    <= VICTrVectAddrIn;
nVICFIQIN        <= nVICTrFIQIn;
nVICIRQIN        <= nVICTrIRQIn;
VICFIQINREG      <= VICTrFiqInReg;
VICIRQINREG      <= VICTrIrqInReg;
VICIRQACK        <= VICTrIrqAck;
VICSYNCEN        <= nVICTrSyncEn;
HCLKTRICK        <= iHCLKTRICK;
-- -----------------------------------------------------------------------------
-- Instantiation of Trickbox-AHB Interface Block
-- -----------------------------------------------------------------------------
uVicTrAhbif : VicTrAhbif
  generic map (
               tovmaxintsrc     => tovmaxintsrc,
               tovmaxnvicfiqin  => tovmaxnvicfiqin,
               tovmaxnvicirqin  => tovmaxnvicirqin,
               tovmaxvectadin   => tovmaxvectadin
              )
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HREADYIN         => HREADYIN,
            HADDR            => HADDR,
            HTRANS           => HTRANS,
            HSIZE            => HSIZE,
            HWRITE           => HWRITE,
            HPROT            => HPROT,
            HWDATA           => HWDATA,
            HSELVICTR        => HSELVICTR,
            HSELVIC          => HSELVIC,
            VICTrVectAddr    => VICTrVectAddrOut,
            nVICFIQ          => nVICFIQ,
            nVICIRQ          => nVICIRQ,
            VICVECTADDROUT   => VICVECTADDROUT,
            VICVECTADDRV     => VICVECTADDRV,
            HRDATA           => HRDATA,
            HREADYOUT        => HREADYOUT,
            HRESP            => HRESP,
            VICTrTCR         => VICTrTcr,
            VICINTSOURCE     => VICTrIntSource,
            VICVECTADDRIN    => VICTrVectAddrIn,
            nVICFIQIN        => nVICTrFiqIn,
            nVICIRQIN        => nVICTrIrqIn,
            VICIRQINREG      => VICTrIrqInReg,
            VICFIQINREG      => VICTrFiqInReg,
            nVICSYNCEN       => nVICTrSyncEn,
            VICTrSoftInt     => VICTrSoftInt,
            VICTrIntEnable   => VICTrIntEnable,
            VICTrIntSelect   => VICTrIntSelect,
            VICTrSwPriMask   => VICTrSwPriMask,
            VICTrVectPriDsy  => VICTrVectPriDsy,
            VICTrVectPrity0  => VICTrVectPrity0,
            VICTrVectPrity1  => VICTrVectPrity1,
            VICTrVectPrity2  => VICTrVectPrity2,
            VICTrVectPrity3  => VICTrVectPrity3,
            VICTrVectPrity4  => VICTrVectPrity4,
            VICTrVectPrity5  => VICTrVectPrity5,
            VICTrVectPrity6  => VICTrVectPrity6,
            VICTrVectPrity7  => VICTrVectPrity7,
            VICTrVectPrity8  => VICTrVectPrity8,
            VICTrVectPrity9  => VICTrVectPrity9,
            VICTrVectPrity10 => VICTrVectPrity10,
            VICTrVectPrity11 => VICTrVectPrity11,
            VICTrVectPrity12 => VICTrVectPrity12,
            VICTrVectPrity13 => VICTrVectPrity13,
            VICTrVectPrity14 => VICTrVectPrity14,
            VICTrVectPrity15 => VICTrVectPrity15,
            VICTrVectPrity16 => VICTrVectPrity16,
            VICTrVectPrity17 => VICTrVectPrity17,
            VICTrVectPrity18 => VICTrVectPrity18,
            VICTrVectPrity19 => VICTrVectPrity19,
            VICTrVectPrity20 => VICTrVectPrity20,
            VICTrVectPrity21 => VICTrVectPrity21,
            VICTrVectPrity22 => VICTrVectPrity22,
            VICTrVectPrity23 => VICTrVectPrity23,
            VICTrVectPrity24 => VICTrVectPrity24,
            VICTrVectPrity25 => VICTrVectPrity25,
            VICTrVectPrity26 => VICTrVectPrity26,
            VICTrVectPrity27 => VICTrVectPrity27,
            VICTrVectPrity28 => VICTrVectPrity28,
            VICTrVectPrity29 => VICTrVectPrity29,
            VICTrVectPrity30 => VICTrVectPrity30,
            VICTrVectPrity31 => VICTrVectPrity31,
            VICTrVectAddr0   => VICTrVectAddr0,
            VICTrVectAddr1   => VICTrVectAddr1,
            VICTrVectAddr2   => VICTrVectAddr2,
            VICTrVectAddr3   => VICTrVectAddr3,
            VICTrVectAddr4   => VICTrVectAddr4,
            VICTrVectAddr5   => VICTrVectAddr5,
            VICTrVectAddr6   => VICTrVectAddr6,
            VICTrVectAddr7   => VICTrVectAddr7,
            VICTrVectAddr8   => VICTrVectAddr8,
            VICTrVectAddr9   => VICTrVectAddr9,
            VICTrVectAddr10  => VICTrVectAddr10,
            VICTrVectAddr11  => VICTrVectAddr11,
            VICTrVectAddr12  => VICTrVectAddr12,
            VICTrVectAddr13  => VICTrVectAddr13,
            VICTrVectAddr14  => VICTrVectAddr14,
            VICTrVectAddr15  => VICTrVectAddr15,
            VICTrVectAddr16  => VICTrVectAddr16,
            VICTrVectAddr17  => VICTrVectAddr17,
            VICTrVectAddr18  => VICTrVectAddr18,
            VICTrVectAddr19  => VICTrVectAddr19,
            VICTrVectAddr20  => VICTrVectAddr20,
            VICTrVectAddr21  => VICTrVectAddr21,
            VICTrVectAddr22  => VICTrVectAddr22,
            VICTrVectAddr23  => VICTrVectAddr23,
            VICTrVectAddr24  => VICTrVectAddr24,
            VICTrVectAddr25  => VICTrVectAddr25,
            VICTrVectAddr26  => VICTrVectAddr26,
            VICTrVectAddr27  => VICTrVectAddr27,
            VICTrVectAddr28  => VICTrVectAddr28,
            VICTrVectAddr29  => VICTrVectAddr29,
            VICTrVectAddr30  => VICTrVectAddr30,
            VICTrVectAddr31  => VICTrVectAddr31,
            VICACKOUT        => VICTrIrqAck,
            HCLKTRICK        => iHCLKTRICK,
            VectAddrWrTrig   => VectAddrWrTrig,
            VectAddrRdTrig   => VectAddrRdTrig,
            AsyncRdEn        => AsyncRdEn
           );

-- -----------------------------------------------------------------------------
-- Instantiation of VIC Mirror Trickbox
-- -----------------------------------------------------------------------------
uVicMirTrickbox : VicMirTrickbox 
  port map (
            HCLK             => iHCLKTRICK,
            HRESETn          => HRESETn,
            VicTrIntSource   => VICTrIntSource,
            nVicTrFiqIn      => nVICTrFiqIn,
            nVicTrIrqIn      => nVICTrIrqIn,
            VicTrVectAddrIn  => VICTrVectAddrIn,
            VicTrIrqInReg    => VICTrIrqInReg,
            VicTrFiqInReg    => VICTrFiqInReg,
            VicTrIrqAck      => VICTrIrqAck,
            nVicTrSyncEn     => nVICTrSyncEn,
            VicTrSoftInt     => VICTrSoftInt,
            VicTrIntEn       => VICTrIntEnable,
            VicTrIntSelect   => VICTrIntSelect,
            VicTrSwPriMask   => VICTrSwPriMask,
            VicTrVectPriDsy  => VICTrVectPriDsy,
            VicTrVectPrity0  => VICTrVectPrity0,
            VicTrVectPrity1  => VICTrVectPrity1,
            VicTrVectPrity2  => VICTrVectPrity2,
            VicTrVectPrity3  => VICTrVectPrity3,
            VicTrVectPrity4  => VICTrVectPrity4,
            VicTrVectPrity5  => VICTrVectPrity5,
            VicTrVectPrity6  => VICTrVectPrity6,
            VicTrVectPrity7  => VICTrVectPrity7,
            VicTrVectPrity8  => VICTrVectPrity8,
            VicTrVectPrity9  => VICTrVectPrity9,
            VicTrVectPrity10 => VICTrVectPrity10,
            VicTrVectPrity11 => VICTrVectPrity11,
            VicTrVectPrity12 => VICTrVectPrity12,
            VicTrVectPrity13 => VICTrVectPrity13,
            VicTrVectPrity14 => VICTrVectPrity14,
            VicTrVectPrity15 => VICTrVectPrity15,
            VicTrVectPrity16 => VICTrVectPrity16,
            VicTrVectPrity17 => VICTrVectPrity17,
            VicTrVectPrity18 => VICTrVectPrity18,
            VicTrVectPrity19 => VICTrVectPrity19,
            VicTrVectPrity20 => VICTrVectPrity20,
            VicTrVectPrity21 => VICTrVectPrity21,
            VicTrVectPrity22 => VICTrVectPrity22,
            VicTrVectPrity23 => VICTrVectPrity23,
            VicTrVectPrity24 => VICTrVectPrity24,
            VicTrVectPrity25 => VICTrVectPrity25,
            VicTrVectPrity26 => VICTrVectPrity26,
            VicTrVectPrity27 => VICTrVectPrity27,
            VicTrVectPrity28 => VICTrVectPrity28,
            VicTrVectPrity29 => VICTrVectPrity29,
            VicTrVectPrity30 => VICTrVectPrity30,
            VicTrVectPrity31 => VICTrVectPrity31,
            VicTrVectAddr0   => VICTrVectAddr0,
            VicTrVectAddr1   => VICTrVectAddr1,
            VicTrVectAddr2   => VICTrVectAddr2,
            VicTrVectAddr3   => VICTrVectAddr3,
            VicTrVectAddr4   => VICTrVectAddr4,
            VicTrVectAddr5   => VICTrVectAddr5,
            VicTrVectAddr6   => VICTrVectAddr6,
            VicTrVectAddr7   => VICTrVectAddr7,
            VicTrVectAddr8   => VICTrVectAddr8,
            VicTrVectAddr9   => VICTrVectAddr9,
            VicTrVectAddr10  => VICTrVectAddr10,
            VicTrVectAddr11  => VICTrVectAddr11,
            VicTrVectAddr12  => VICTrVectAddr12,
            VicTrVectAddr13  => VICTrVectAddr13,
            VicTrVectAddr14  => VICTrVectAddr14,
            VicTrVectAddr15  => VICTrVectAddr15,
            VicTrVectAddr16  => VICTrVectAddr16,
            VicTrVectAddr17  => VICTrVectAddr17,
            VicTrVectAddr18  => VICTrVectAddr18,
            VicTrVectAddr19  => VICTrVectAddr19,
            VicTrVectAddr20  => VICTrVectAddr20,
            VicTrVectAddr21  => VICTrVectAddr21,
            VicTrVectAddr22  => VICTrVectAddr22,
            VicTrVectAddr23  => VICTrVectAddr23,
            VicTrVectAddr24  => VICTrVectAddr24,
            VicTrVectAddr25  => VICTrVectAddr25,
            VicTrVectAddr26  => VICTrVectAddr26,
            VicTrVectAddr27  => VICTrVectAddr27,
            VicTrVectAddr28  => VICTrVectAddr28,
            VicTrVectAddr29  => VICTrVectAddr29,
            VicTrVectAddr30  => VICTrVectAddr30,
            VicTrVectAddr31  => VICTrVectAddr31,
            VectAddrWrTrig   => VectAddrWrTrig,
            VectAddrRdTrig   => VectAddrRdTrig,
            AsyncRdEn        => AsyncRdEn,
            VicTrRawIntr     => VICTrRawIntr,
            VicTrIrqStatus   => VICTrIrqStatus,
            VicTrFiqStatus   => VICTrFiqStatus,
            nVicTrFiq        => nVICTrFiq,
            nVicTrIrq        => nVICTrIrq,
            VicTrIrqAckOut   => VICTrIrqAckOut,
            VicTrVectAddrv   => VICTrVectAddrv,
            VicTrVectAddr    => VICTrVectAddrOut
           );

-- -----------------------------------------------------------------------------
-- Instantiation of output comparator
-- -----------------------------------------------------------------------------
uVicTrProtChkr : VicTrProtChkr
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            VICTrTCR         => VICTrTcr,
            nVICFIQ          => nVICFIQ,
            nFIQ             => nVICTrFiq,
            nVICIRQ          => nVICIRQ,
            nIRQ             => nVICTrIrq,
            VICVECTADDRV     => VICVECTADDRV,
            VICTrVectAddrv   => VICTrVectAddrv,
            VICIRQACKOUT     => VICIRQACKOUT,
            VicTrIrqAckOut   => VICTrIrqAckOut,
            VICVECTADDROUT   => VICVECTADDROUT,
            VICTrVectAddrOut => VICTrVectAddrOut
           );

end structural;

-- --============================ End ========================================--
