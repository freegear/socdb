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
-- File Name              : VicTrick.vhd.rca
-- File Revision          : 1.6
--
-- Release Information    : PrimeCell(TM)-PL190-REL1v1
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Top level of the VIC Trickbox.
--
-- --=================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- --------------------------------------------------------------------

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
-- Outputs
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
        VICVECTADDRIN    : out   std_logic_vector(31 downto 0);
                                            -- VICVECTADDRIN Daisy
                                            -- chain Vector address
                                            -- signal to the VIC
        nVICFIQIN        : out   std_logic; -- nVICFIQIN Daisy chain
                                            -- signal to the VIC
        nVICIRQIN        : out   std_logic  -- nVICIRQIN Daisy chain
                                            -- signal to the VIC
       );
end VicTrick;

-- ---------------------------------------------------------------------
--
--                              VicTrick
--                              ========
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--   This block is the top level of the VIC Trickbox. This block
-- instantiates the following sub-blocks:
--
-- 1. VicTrAhbif
-- 2. VicTrIntReq
-- 3. VicTrVectBank
-- 4. VicTrProtChkr
--
-- ---------------------------------------------------------------------

-- --======================= ARCHITECTURE ============================--

architecture structural of VicTrick is

-- ---------------------------------------------------------------------
-- Component declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- AHB Interface
-- ---------------------------------------------------------------------
component VicTrAhbif
  generic (
           tovminintsrc     : time;
           tovmaxintsrc     : time;
           tovminnvicfiqin  : time;
           tovmaxnvicfiqin  : time;
           tovminnvicirqin  : time;
           tovmaxnvicirqin  : time;
           tovminvectadin   : time;
           tovmaxvectadin   : time
          );
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HREADYIN         : in    std_logic;
        HADDR            : in    std_logic_vector(11 downto 2);
        HTRANS           : in    std_logic;
        HSIZE            : in    std_logic_vector(2 downto 0);
        HWRITE           : in    std_logic;
        HPROT            : in    std_logic;
        HWDATA           : in    std_logic_vector(31 downto 0);
        HSELVICTR        : in    std_logic;
        HSELVIC          : in    std_logic;
        VICTrVectAddr    : in    std_logic_vector(31 downto 0);
        nVICFIQ          : in    std_logic;
        nVICIRQ          : in    std_logic;
        VICVECTADDROUT   : in    std_logic_vector(31 downto 0);
        HRDATA           : out   std_logic_vector(31 downto 0);
        HREADYOUT        : out   std_logic;
        VICTrTCR         : out   std_logic_vector(2 downto 0);
        HRESP            : out   std_logic_vector(1 downto 0);
        VICINTSOURCE     : out   std_logic_vector(31 downto 0);
        VICVECTADDRIN    : out   std_logic_vector(31 downto 0);
        nVICFIQIN        : out   std_logic;
        nVICIRQIN        : out   std_logic;
        SetCSRBit        : out   std_logic;
        ClearCSRBit      : out   std_logic;
        VICTrSoftInt     : out   std_logic_vector(31 downto 0);
        VICTrIntEnable   : out   std_logic_vector(31 downto 0);
        VICTrIntSelect   : out   std_logic_vector(31 downto 0);
        VICTrDefVectAddr : out   std_logic_vector(31 downto 0);
        VICTrVectAddr0   : out   std_logic_vector(31 downto 0);
        VICTrVectAddr1   : out   std_logic_vector(31 downto 0);
        VICTrVectAddr2   : out   std_logic_vector(31 downto 0);
        VICTrVectAddr3   : out   std_logic_vector(31 downto 0);
        VICTrVectAddr4   : out   std_logic_vector(31 downto 0);
        VICTrVectAddr5   : out   std_logic_vector(31 downto 0);
        VICTrVectAddr6   : out   std_logic_vector(31 downto 0);
        VICTrVectAddr7   : out   std_logic_vector(31 downto 0);
        VICTrVectAddr8   : out   std_logic_vector(31 downto 0);
        VICTrVectAddr9   : out   std_logic_vector(31 downto 0);
        VICTrVectAddr10  : out   std_logic_vector(31 downto 0);
        VICTrVectAddr11  : out   std_logic_vector(31 downto 0);
        VICTrVectAddr12  : out   std_logic_vector(31 downto 0);
        VICTrVectAddr13  : out   std_logic_vector(31 downto 0);
        VICTrVectAddr14  : out   std_logic_vector(31 downto 0);
        VICTrVectAddr15  : out   std_logic_vector(31 downto 0);
        VICTrVectCntl0   : out   std_logic_vector(5 downto 0);
        VICTrVectCntl1   : out   std_logic_vector(5 downto 0);
        VICTrVectCntl2   : out   std_logic_vector(5 downto 0);
        VICTrVectCntl3   : out   std_logic_vector(5 downto 0);
        VICTrVectCntl4   : out   std_logic_vector(5 downto 0);
        VICTrVectCntl5   : out   std_logic_vector(5 downto 0);
        VICTrVectCntl6   : out   std_logic_vector(5 downto 0);
        VICTrVectCntl7   : out   std_logic_vector(5 downto 0);
        VICTrVectCntl8   : out   std_logic_vector(5 downto 0);
        VICTrVectCntl9   : out   std_logic_vector(5 downto 0);
        VICTrVectCntl10  : out   std_logic_vector(5 downto 0);
        VICTrVectCntl11  : out   std_logic_vector(5 downto 0);
        VICTrVectCntl12  : out   std_logic_vector(5 downto 0);
        VICTrVectCntl13  : out   std_logic_vector(5 downto 0);
        VICTrVectCntl14  : out   std_logic_vector(5 downto 0);
        VICTrVectCntl15  : out   std_logic_vector(5 downto 0)
       );
end component;

-- ---------------------------------------------------------------------
-- FIQ and IRQ Status Generator
-- ---------------------------------------------------------------------
component VicTrIntReq
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        VICTrIntSource   : in    std_logic_vector(31 downto 0);
        VICTrSoftInt     : in    std_logic_vector(31 downto 0);
        VICTrIntEnable   : in    std_logic_vector(31 downto 0);
        VICTrIntSelect   : in    std_logic_vector(31 downto 0);
        VICTrFIQStatus   : out   std_logic_vector(31 downto 0);
        VICTrIRQStatus   : out   std_logic_vector(31 downto 0);
        VICTrIRQStatSync : out   std_logic_vector(31 downto 0)
       );
end component;

-- ---------------------------------------------------------------------
-- IRQ Priority Resolving Module
-- ---------------------------------------------------------------------
component VicTrVectBank
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        VICTrFIQStatus   : in    std_logic_vector(31 downto 0);
        VICTrIRQStatus   : in    std_logic_vector(31 downto 0);
        VICTrIRQStatSync : in    std_logic_vector(31 downto 0);
        nVICTrFIQIn      : in    std_logic;
        nVICTrIRQIn      : in    std_logic;
        SetCSRBit        : in    std_logic;
        ClearCSRBit      : in    std_logic;
        VICTrVectAddrIn  : in    std_logic_vector(31 downto 0);
        VICTrDefVectAddr : in    std_logic_vector(31 downto 0);
        VICTrVectAddr0   : in    std_logic_vector(31 downto 0);
        VICTrVectAddr1   : in    std_logic_vector(31 downto 0);
        VICTrVectAddr2   : in    std_logic_vector(31 downto 0);
        VICTrVectAddr3   : in    std_logic_vector(31 downto 0);
        VICTrVectAddr4   : in    std_logic_vector(31 downto 0);
        VICTrVectAddr5   : in    std_logic_vector(31 downto 0);
        VICTrVectAddr6   : in    std_logic_vector(31 downto 0);
        VICTrVectAddr7   : in    std_logic_vector(31 downto 0);
        VICTrVectAddr8   : in    std_logic_vector(31 downto 0);
        VICTrVectAddr9   : in    std_logic_vector(31 downto 0);
        VICTrVectAddr10  : in    std_logic_vector(31 downto 0);
        VICTrVectAddr11  : in    std_logic_vector(31 downto 0);
        VICTrVectAddr12  : in    std_logic_vector(31 downto 0);
        VICTrVectAddr13  : in    std_logic_vector(31 downto 0);
        VICTrVectAddr14  : in    std_logic_vector(31 downto 0);
        VICTrVectAddr15  : in    std_logic_vector(31 downto 0);
        VICTrVectCntl0   : in    std_logic_vector(5 downto 0);
        VICTrVectCntl1   : in    std_logic_vector(5 downto 0);
        VICTrVectCntl2   : in    std_logic_vector(5 downto 0);
        VICTrVectCntl3   : in    std_logic_vector(5 downto 0);
        VICTrVectCntl4   : in    std_logic_vector(5 downto 0);
        VICTrVectCntl5   : in    std_logic_vector(5 downto 0);
        VICTrVectCntl6   : in    std_logic_vector(5 downto 0);
        VICTrVectCntl7   : in    std_logic_vector(5 downto 0);
        VICTrVectCntl8   : in    std_logic_vector(5 downto 0);
        VICTrVectCntl9   : in    std_logic_vector(5 downto 0);
        VICTrVectCntl10  : in    std_logic_vector(5 downto 0);
        VICTrVectCntl11  : in    std_logic_vector(5 downto 0);
        VICTrVectCntl12  : in    std_logic_vector(5 downto 0);
        VICTrVectCntl13  : in    std_logic_vector(5 downto 0);
        VICTrVectCntl14  : in    std_logic_vector(5 downto 0);
        VICTrVectCntl15  : in    std_logic_vector(5 downto 0);
        nFIQ             : out   std_logic;
        nIRQ             : out   std_logic;
        VICTrVectAddrOut : out   std_logic_vector(31 downto 0)
       );
end component;

-- ---------------------------------------------------------------------
-- Output Comparator
-- ---------------------------------------------------------------------
component VicTrProtChkr
  port (
        HCLK             : in std_logic;
        HRESETn          : in std_logic;
        VICTrTCR         : in std_logic_vector(2 downto 0);
        nVICFIQ          : in std_logic;
        nFIQ             : in std_logic;
        nVICIRQ          : in std_logic;
        nIRQ             : in std_logic;
        VICVECTADDROUT   : in std_logic_vector(31 downto 0);
        VICTrVectAddrOut : in std_logic_vector(31 downto 0)
       );
end component;

-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------

------------------------------------------------------------------------
-- Timing Parameters of Trickbox
------------------------------------------------------------------------
constant tovminintsrc     : time := 0.0 * Tclk;
-- VICINTSOURCE valid time (min) after HCLK rising edge

constant tovmaxintsrc     : time := 0.05 * Tclk;
-- VICINTSOURCE valid time (max) after HCLK rising edge

constant tovminnvicfiqin  : time := 0.0 * Tclk;
-- nVICFIQIN valid time (min) after HCLK rising edge

constant tovmaxnvicfiqin  : time := 0.2 * Tclk;
-- nVICFIQIN valid time (max) after HCLK rising edge

constant tovminnvicirqin  : time := 0.0 * Tclk;
-- nVICIRQIN valid time (min) after HCLK rising edge

constant tovmaxnvicirqin  : time := 0.2 * Tclk;
-- nVICIRQIN valid time (max) after HCLK rising edge

constant tovminvectadin   : time := 0.0 * Tclk;
-- VICVECTADDRIN valid time (min) after HCLK rising edge

constant tovmaxvectadin   : time := 0.2 * Tclk;
-- VICVECTADDRIN valid time (max) after HCLK rising edge

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------
signal VICTrVectAddrOut  : std_logic_vector(31 downto 0);
-- VectAddrOut from the internal mirrored model

signal SetCSRBit         : std_logic;
-- Current Service Register Set enable signal

signal ClearCSRBit       : std_logic;
-- Current Service Register Clear enable signal

signal VICTrSoftInt      : std_logic_vector(31 downto 0);
-- SoftInt register

signal VICTrIntEnable    : std_logic_vector(31 downto 0);
-- IntEnable register

signal VICTrIntSelect    : std_logic_vector(31 downto 0);
-- IntSelect register

signal VICTrDefVectAddr  : std_logic_vector(31 downto 0);
-- Default Vector Address register

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

signal VICTrVectCntl0    : std_logic_vector(5 downto 0);
-- Vector Control 0 register

signal VICTrVectCntl1    : std_logic_vector(5 downto 0);
-- Vector Control 1 register

signal VICTrVectCntl2    : std_logic_vector(5 downto 0);
-- Vector Control 2 register

signal VICTrVectCntl3    : std_logic_vector(5 downto 0);
-- Vector Control 3 register

signal VICTrVectCntl4    : std_logic_vector(5 downto 0);
-- Vector Control 4 register

signal VICTrVectCntl5    : std_logic_vector(5 downto 0);
-- Vector Control 5 register

signal VICTrVectCntl6    : std_logic_vector(5 downto 0);
-- Vector Control 6 register

signal VICTrVectCntl7    : std_logic_vector(5 downto 0);
-- Vector Control 7 register

signal VICTrVectCntl8    : std_logic_vector(5 downto 0);
-- Vector Control 8 register

signal VICTrVectCntl9    : std_logic_vector(5 downto 0);
-- Vector Control 9 register

signal VICTrVectCntl10   : std_logic_vector(5 downto 0);
-- Vector Control 10 register

signal VICTrVectCntl11   : std_logic_vector(5 downto 0);
-- Vector Control 11 register

signal VICTrVectCntl12   : std_logic_vector(5 downto 0);
-- Vector Control 12 register

signal VICTrVectCntl13   : std_logic_vector(5 downto 0);
-- Vector Control 13 register

signal VICTrVectCntl14   : std_logic_vector(5 downto 0);
-- Vector Control 14 register

signal VICTrVectCntl15   : std_logic_vector(5 downto 0);
-- Vector Control 15 register

signal VICTrIntSource    : std_logic_vector(31 downto 0);
-- Interrupt source register

signal VICTrFIQStatus    : std_logic_vector(31 downto 0);
-- FIQ Status register

signal VICTrIRQStatus    : std_logic_vector(31 downto 0);
-- IRQ Status register

signal VICTrIRQStatSync  : std_logic_vector(31 downto 0);
-- Double synchronised IRQ Status register

signal VICTrVectAddrIn   : std_logic_vector(31 downto 0);
-- Vector AddressIn register

signal nFIQ              : std_logic;
-- nFIQ from Mirrored VIC model

signal nIRQ              : std_logic;
-- nIRQ from Mirrored VIC model

signal nVICTrFIQIn       : std_logic;
-- nVICFIQIN Daisy chain signal

signal nVICTrIRQIn       : std_logic;
-- nVICIRQIN Daisy chain signal

signal VICTrTCR          : std_logic_vector(2 downto 0);
-- Error Message Enabling signal

-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------

begin

-- ---------------------------------------------------------------------
-- Assigns output signals of the VIC Trickbox
-- ---------------------------------------------------------------------
nVICFIQIN        <= nVICTrFIQIn;
nVICIRQIN        <= nVICTrIRQIn;
VICINTSOURCE     <= VICTrIntSource;
VICVECTADDRIN    <= VICTrVectAddrIn;

-- ---------------------------------------------------------------------
-- Instantiation of Trickbox-AHB Interface Block
-- ---------------------------------------------------------------------
uVicTrAhbif : VicTrAhbif
  generic map (
               tovminintsrc     => tovminintsrc,
               tovmaxintsrc     => tovmaxintsrc,
               tovminnvicfiqin  => tovminnvicfiqin,
               tovmaxnvicfiqin  => tovmaxnvicfiqin,
               tovminnvicirqin  => tovminnvicirqin,
               tovmaxnvicirqin  => tovmaxnvicirqin,
               tovminvectadin   => tovminvectadin,
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
            HRDATA           => HRDATA,
            HREADYOUT        => HREADYOUT,
            VICTrTCR         => VICTrTCR,
            HRESP            => HRESP,
            VICINTSOURCE     => VICTrIntSource,
            VICVECTADDRIN    => VICTrVectAddrIn,
            nVICFIQIN        => nVICTrFIQIn,
            nVICIRQIN        => nVICTrIRQIn,
            SetCSRBit        => SetCSRBit,
            ClearCSRBit      => ClearCSRBit,
            VICTrSoftInt     => VICTrSoftInt,
            VICTrIntEnable   => VICTrIntEnable,
            VICTrIntSelect   => VICTrIntSelect,
            VICTrDefVectAddr => VICTrDefVectAddr,
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
            VICTrVectCntl0   => VICTrVectCntl0,
            VICTrVectCntl1   => VICTrVectCntl1,
            VICTrVectCntl2   => VICTrVectCntl2,
            VICTrVectCntl3   => VICTrVectCntl3,
            VICTrVectCntl4   => VICTrVectCntl4,
            VICTrVectCntl5   => VICTrVectCntl5,
            VICTrVectCntl6   => VICTrVectCntl6,
            VICTrVectCntl7   => VICTrVectCntl7,
            VICTrVectCntl8   => VICTrVectCntl8,
            VICTrVectCntl9   => VICTrVectCntl9,
            VICTrVectCntl10  => VICTrVectCntl10,
            VICTrVectCntl11  => VICTrVectCntl11,
            VICTrVectCntl12  => VICTrVectCntl12,
            VICTrVectCntl13  => VICTrVectCntl13,
            VICTrVectCntl14  => VICTrVectCntl14,
            VICTrVectCntl15  => VICTrVectCntl15
           );

-- ---------------------------------------------------------------------
-- Instantiation of FIQ/IRQ Status Generator
-- ---------------------------------------------------------------------
uVicTrIntReq : VicTrIntReq
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            VICTrIntSource   => VICTrIntSource,
            VICTrSoftInt     => VICTrSoftInt,
            VICTrIntEnable   => VICTrIntEnable,
            VICTrIntSelect   => VICTrIntSelect,
            VICTrFIQStatus   => VICTrFIQStatus,
            VICTrIRQStatus   => VICTrIRQStatus,
            VICTrIRQStatSync => VICTrIRQStatSync
           );

-- ---------------------------------------------------------------------
-- Instantiation of IRQ Priority Resolver Block
-- ---------------------------------------------------------------------
uVicTrVectBank : VicTrVectBank
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            VICTrFIQStatus   => VICTrFIQStatus,
            VICTrIRQStatus   => VICTrIRQStatus,
            VICTrIRQStatSync => VICTrIRQStatSync,
            nVICTrFIQIn      => nVICTrFIQIn,
            nVICTrIRQIn      => nVICTrIRQIn,
            SetCSRBit        => SetCSRBit,
            ClearCSRBit      => ClearCSRBit,
            VICTrVectAddrIn  => VICTrVectAddrIn,
            VICTrDefVectAddr => VICTrDefVectAddr,
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
            VICTrVectCntl0   => VICTrVectCntl0,
            VICTrVectCntl1   => VICTrVectCntl1,
            VICTrVectCntl2   => VICTrVectCntl2,
            VICTrVectCntl3   => VICTrVectCntl3,
            VICTrVectCntl4   => VICTrVectCntl4,
            VICTrVectCntl5   => VICTrVectCntl5,
            VICTrVectCntl6   => VICTrVectCntl6,
            VICTrVectCntl7   => VICTrVectCntl7,
            VICTrVectCntl8   => VICTrVectCntl8,
            VICTrVectCntl9   => VICTrVectCntl9,
            VICTrVectCntl10  => VICTrVectCntl10,
            VICTrVectCntl11  => VICTrVectCntl11,
            VICTrVectCntl12  => VICTrVectCntl12,
            VICTrVectCntl13  => VICTrVectCntl13,
            VICTrVectCntl14  => VICTrVectCntl14,
            VICTrVectCntl15  => VICTrVectCntl15,
            nFIQ             => nFIQ,
            nIRQ             => nIRQ,
            VICTrVectAddrOut => VICTrVectAddrOut
           );

-- ---------------------------------------------------------------------
-- Instantiation of output comparator
-- ---------------------------------------------------------------------
uVicTrProtChkr : VicTrProtChkr
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            VICTrTCR         => VICTrTCR,
            nVICFIQ          => nVICFIQ,
            nFIQ             => nFIQ,
            nVICIRQ          => nVICIRQ,
            nIRQ             => nIRQ,
            VICVECTADDROUT   => VICVECTADDROUT,
            VICTrVectAddrOut => VICTrVectAddrOut
           );

end structural;

-- --======================== End ====================================--
