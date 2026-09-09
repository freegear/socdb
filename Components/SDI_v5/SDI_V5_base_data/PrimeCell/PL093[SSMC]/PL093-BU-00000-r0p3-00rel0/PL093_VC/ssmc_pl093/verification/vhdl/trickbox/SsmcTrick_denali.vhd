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
-- File Name              : SsmcTrick_denali.vhd.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This module is the top level SSMC Trickbox
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SsmcTrick is
  generic (
           Tclk             : time := 7.5 ns;
                                -- HCLK Period
           Tclks            : time;
                                -- Start time for SMSMemCLK
           Tclkl            : time;
           Tclkh            : time
          );
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB Bus Clock
        HRESETn          : in    std_logic; -- Bus Reset
        HADDR            : in    std_logic_vector(5 downto 2);
                                            -- AHB Address Bus
        HTRANS           : in    std_logic_vector(1 downto 0);
                                            -- Transfer type
        HWRITE           : in    std_logic; -- AHB Peripheral Write
        HSIZE            : in    std_logic_vector(2 downto 0);
                                            -- Transfer size
        HREADYINTr       : in    std_logic; -- Multiplexed version of
                                            -- HREADY outputs
        HWDATA           : in    std_logic_vector(31 downto 0);
                                            -- AHB Write Data bus
        HSELSSMCTr       : in    std_logic; -- AHB Peripheral (Trickbox)
                                            -- Select
        SMDATAOUT        : in    std_logic_vector(31 downto 0);
                                            -- SSMC Data Out Bus to Memory
        SMADDR           : in    std_logic_vector(25 downto 0);
                                            -- Memory Address Bus
        SSMTrCS          : in    std_logic_vector(7 downto 0);
                                            -- Memory chip select lines
                                            -- active high
        nSSMTrCS         : in    std_logic_vector(7 downto 0);
                                            -- Memory chip select lines
                                            -- active low
        nSMDATAEN        : in    std_logic_vector(3 downto 0);
                                            -- Memory Data Bus Enable lines
        nSMWEN           : in    std_logic;
                                            -- Memory Write Enable
        nSMBLS           : in    std_logic_vector(3 downto 0);
                                            -- Memory Data Bus Lane Enable
        nSMOEN           : in    std_logic;
                                            -- Memory Output Enable
        SMBUSREQEBI      : in    std_logic; -- SSMC request
        SMTICBUSREQEBI   : in    std_logic; -- TIC request

-- Outputs
        HRDATATr         : out   std_logic_vector(31 downto 0);
                                            -- AHB Read Data bus
        HREADYOUTTr      : out   std_logic;
                                            -- Slave HREADY output
        HRESPTr          : out   std_logic_vector(1 downto 0);
                                            -- Slave response
        BIGENDIAN        : out   std_logic;
                                            -- Endianness of the System
        SMEXTBUSMUX      : out   std_logic;
                                            -- External bus MUX

        SMMWCS7          : out   std_logic_vector(1 downto 0);
                                            -- Boot Memory Bank Width
        SMWAIT           : out   std_logic;
                                            -- External Wait signal routed to
                                            -- the SSMC
        SMCANCELWAIT     : out   std_logic;
                                            -- External Wait time-out signal
        SMBUSGNTEBI      : out   std_logic; -- External bus granted to SSMC
        SMBUSBACKOFFEBI  : out   std_logic; -- Backoff signal for SSMC
        SMTICBUSGNTEBI   : out   std_logic; -- External bus granted to TIC
        SMFBCLK          : out   std_logic; -- Feedback clock
        SMMemCLK         : out   std_logic; -- Memeory clock
        SMMemClkRatio    : out   std_logic_vector(1 downto 0);
                                            -- Memory clock ratio
        SMBLS7POL        : out   std_logic
                                            -- SMBLS Polarity for bank 7
       );
end SsmcTrick;

-- -----------------------------------------------------------------------------
--
--                               SSMC Trick
--                               ==========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- This Block is top level of the SSMC Trick Box model.This Block instantiates
-- the following sub-blocks :
--
-- 1. SsmcTrAhbIfReg   - AHB Interface and Register Block.
-- 2. SsmcTrProtChkr   - SSMC Protocol Checker Block.
-- 3. SsmcTrWaitCntl   - SSMC Wait Control logic Block.
-- 4. SsmcTrExtArb     - External Arbitor.
-- 5. SsmcTrMemClkGen  - Memory clock generator block.
-- -----------------------------------------------------------------------------
-- ======================== ARCHITECTURE =====================================--

architecture behavioural of SsmcTrick is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- The SSMC Trickbox AHB Interface
-- -----------------------------------------------------------------------------
component SsmcTrAhbIfReg
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HADDR            : in    std_logic_vector(5 downto 2);
        HTRANS           : in    std_logic_vector(1 downto 0);
        HWRITE           : in    std_logic;
        HSIZE            : in    std_logic_vector(2 downto 0);
        HREADYINTr       : in    std_logic;
        HWDATA           : in    std_logic_vector(31 downto 0);
        HSELSSMCTr       : in    std_logic;
        HRDATATr         : out   std_logic_vector(31 downto 0);
        HREADYOUTTr      : out   std_logic;
        HRESPTr          : out   std_logic_vector(1 downto 0);
        BIGENDIAN        : out   std_logic;
        SSMCTrExtMux     : out   std_logic_vector(8 downto 0);
        SMMWCS7          : out   std_logic_vector(1 downto 0);
        SSMCTrCS2WTR0    : out   std_logic_vector(11 downto 0);
        SSMCTrCS2WTR1    : out   std_logic_vector(11 downto 0);
        SSMCTrCS2WTR2    : out   std_logic_vector(11 downto 0);
        SSMCTrCS2WTR3    : out   std_logic_vector(11 downto 0);
        SSMCTrCS2WTR4    : out   std_logic_vector(11 downto 0);
        SSMCTrCS2WTR5    : out   std_logic_vector(11 downto 0);
        SSMCTrCS2WTR6    : out   std_logic_vector(11 downto 0);
        SSMCTrCS2WTR7    : out   std_logic_vector(11 downto 0);
        SSMCTrWTCNCL     : out   std_logic_vector(8 downto 0);
        SSMCTrCR         : out   std_logic_vector(2 downto 0);
        SMBLS7POL        : out   std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- The SSMC Protocol Checker module
-- -----------------------------------------------------------------------------
component SsmcTrProtChkr
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        SMDATAOUT        : in    std_logic_vector(31 downto 0);
        SMADDR           : in    std_logic_vector(25 downto 0);
        nSSMCS           : in    std_logic_vector(7 downto 0);
        SSMCS            : in    std_logic_vector(7 downto 0);
        nSMDATAEN        : in    std_logic_vector(3 downto 0);
        nSMWEN           : in    std_logic;
        nSMBLS           : in    std_logic_vector(3 downto 0);
        nSMOEN           : in    std_logic;
        SMBUSREQEBI      : in    std_logic;
        SMBUSBACKOFFEBI  : in    std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- The SSMC SMWAIT Control Logic
-- -----------------------------------------------------------------------------
component SsmcTrWaitCntl
  generic (
           Tclk             : time
          );
  port (
--        HCLK             : in    std_logic;
        SMMemCLK         : in    std_logic;
        HRESETn          : in    std_logic;
        nSSMCS           : in    std_logic_vector(7 downto 0);
        SMADDR           : in    std_logic_vector(25 downto 0);
        SSMCTrCS2WTR0    : in    std_logic_vector(11 downto 0);
        SSMCTrCS2WTR1    : in    std_logic_vector(11 downto 0);
        SSMCTrCS2WTR2    : in    std_logic_vector(11 downto 0);
        SSMCTrCS2WTR3    : in    std_logic_vector(11 downto 0);
        SSMCTrCS2WTR4    : in    std_logic_vector(11 downto 0);
        SSMCTrCS2WTR5    : in    std_logic_vector(11 downto 0);
        SSMCTrCS2WTR6    : in    std_logic_vector(11 downto 0);
        SSMCTrCS2WTR7    : in    std_logic_vector(11 downto 0);
        SSMCTrWTCNCL     : in    std_logic_vector(8 downto 0);
        SMMemClkRatio    : in    std_logic_vector(1 downto 0);
        SMWAIT           : out   std_logic;
        SMCANCELWAIT     : out   std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- The External Arbitor
-- -----------------------------------------------------------------------------
component SsmcTrExtArb
  port (
        SMMemCLK         : in    std_logic;
        HRESETn          : in    std_logic;
        SMBUSREQEBI      : in    std_logic;
        SMTICBUSREQEBI   : in    std_logic;
        SSMCTrExtMux     : in    std_logic_vector(8 downto 0);
        SMBUSGNTEBI      : out   std_logic;
        BackOffSsmc      : out   std_logic;
        SMTICBUSGNTEBI   : out   std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- Memory Clock generation block
-- -----------------------------------------------------------------------------
component  SsmcTrMemClkGen
  generic(
          Tclks  : time;
          Tclkl  : time;
          Tclkh  : time
          );
  port(
       SMMemClkRatio  : in  std_logic_vector(1 downto 0);
       SMMemCLK       : out std_logic
       );
end component;
-- -----------------------------------------------------------------------------
-- Constant declation
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal iSMMemClkRatio  : std_logic_vector(2 downto 0);
-- Memory clock to HCLK  ratio

signal iSMMemCLK       : std_logic;
-- Memory Clock

signal SSMCTrExtMux    : std_logic_vector(8 downto 0);
-- External Mux Request and grant

signal SSMCTrCS2WTR0   : std_logic_vector(11 downto 0);
-- SMWAIT assertion timming for Bank 0

signal SSMCTrCS2WTR1   : std_logic_vector(11 downto 0);
-- SMWAIT assertion timming for Bank 1

signal SSMCTrCS2WTR2   : std_logic_vector(11 downto 0);
-- SMWAIT assertion timming for Bank 2

signal SSMCTrCS2WTR3   : std_logic_vector(11 downto 0);
-- SMWAIT assertion timming for Bank 3

signal SSMCTrCS2WTR4   : std_logic_vector(11 downto 0);
-- SMWAIT assertion timming for Bank 4

signal SSMCTrCS2WTR5   : std_logic_vector(11 downto 0);
-- SMWAIT assertion timming for Bank 5

signal SSMCTrCS2WTR6   : std_logic_vector(11 downto 0);
-- SMWAIT assertion timming for Bank 6

signal SSMCTrCS2WTR7   : std_logic_vector(11 downto 0);
-- SMWAIT assertion timming for Bank 7

signal SSMCTrWTCNCL    : std_logic_vector(8 downto 0);
-- SMCANCELWAIT assertion timming

signal iSMBUSBACKOFFEBI: std_logic;
-- Backoff signal for SSMC

signal iSMWAIT         : std_logic;
-- Internal signal of SMWAIT

signal iSMCANCELWAIT   : std_logic;
-- Internal signal of SMCANCELWAIT

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

SMFBCLK          <= iSMMemCLK after 5 ns;
SMWAIT           <= iSMWAIT after 5 ns;
SMCANCELWAIT     <= iSMCANCELWAIT after 5 ns;

SMMemCLK         <= iSMMemCLK;
SMMemClkRatio    <= iSMMemClkRatio(2 downto 1);

SMEXTBUSMUX      <= SSMCTrExtMux(0);

SMBUSBACKOFFEBI <= iSMBUSBACKOFFEBI;
-- -----------------------------------------------------------------------------
-- The SMC Trickbox AHB Interface Instantiation
-- -----------------------------------------------------------------------------
uSsmcTrAhbIfReg : SsmcTrAhbIfReg
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HADDR            => HADDR,
            HTRANS           => HTRANS,
            HWRITE           => HWRITE,
            HSIZE            => HSIZE,
            HREADYINTr       => HREADYINTr,
            HWDATA           => HWDATA,
            HSELSSMCTr       => HSELSSMCTr,
            HRDATATr         => HRDATATr,
            HREADYOUTTr      => HREADYOUTTr,
            HRESPTr          => HRESPTr,
            BIGENDIAN        => BIGENDIAN,
            SSMCTrExtMux     => SSMCTrExtMux,
            SMMWCS7          => SMMWCS7,
            SSMCTrCS2WTR0    => SSMCTrCS2WTR0,
            SSMCTrCS2WTR1    => SSMCTrCS2WTR1,
            SSMCTrCS2WTR2    => SSMCTrCS2WTR2,
            SSMCTrCS2WTR3    => SSMCTrCS2WTR3,
            SSMCTrCS2WTR4    => SSMCTrCS2WTR4,
            SSMCTrCS2WTR5    => SSMCTrCS2WTR5,
            SSMCTrCS2WTR6    => SSMCTrCS2WTR6,
            SSMCTrCS2WTR7    => SSMCTrCS2WTR7,
            SSMCTrWTCNCL     => SSMCTrWTCNCL,
            SSMCTrCR         => iSMMemClkRatio,
            SMBLS7POL        => SMBLS7POL
           );
-- -----------------------------------------------------------------------------
-- The SMC Protocol Checker module Instantiation
-- -----------------------------------------------------------------------------
uSsmcTrProtChkr : SsmcTrProtChkr
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            SMDATAOUT        => SMDATAOUT,
            SMADDR           => SMADDR,
            nSSMCS           => nSSMTrCS,
            SSMCS            => SSMTrCS,
            nSMDATAEN        => nSMDATAEN,
            nSMWEN           => nSMWEN,
            nSMBLS           => nSMBLS,
            nSMOEN           => nSMOEN,
            SMBUSREQEBI      => SMBUSREQEBI,
            SMBUSBACKOFFEBI  => iSMBUSBACKOFFEBI
           );

-- -----------------------------------------------------------------------------
-- The SMC SMWAIT Control Logic Instantiation
-- -----------------------------------------------------------------------------
uSsmcTrWaitCntl : SsmcTrWaitCntl
 generic map (
               Tclk             => Tclk
             )
  port map (
--            HCLK             => HCLK,
            SMMemCLK         => iSMMemCLK, 
            HRESETn          => HRESETn,
            nSSMCS           => nSSMTrCS,
            SMADDR           => SMADDR,
            SSMCTrCS2WTR0    => SSMCTrCS2WTR0,
            SSMCTrCS2WTR1    => SSMCTrCS2WTR1,
            SSMCTrCS2WTR2    => SSMCTrCS2WTR2,
            SSMCTrCS2WTR3    => SSMCTrCS2WTR3,
            SSMCTrCS2WTR4    => SSMCTrCS2WTR4,
            SSMCTrCS2WTR5    => SSMCTrCS2WTR5,
            SSMCTrCS2WTR6    => SSMCTrCS2WTR6,
            SSMCTrCS2WTR7    => SSMCTrCS2WTR7,
            SSMCTrWTCNCL     => SSMCTrWTCNCL,
            SMMemClkRatio    => iSMMemClkRatio(2 downto 1),
            SMWAIT           => iSMWAIT,
            SMCANCELWAIT     => iSMCANCELWAIT
           );

-- -----------------------------------------------------------------------------
-- The External Arbitor logic instantiation
-- -----------------------------------------------------------------------------
uSsmcTrExtArb : SsmcTrExtArb
  port map (
            SMMemCLK         => iSMMemCLK,
            HRESETn          => HRESETn,
            SMBUSREQEBI      => SMBUSREQEBI,
            SMTICBUSREQEBI   => SMTICBUSREQEBI,
            SSMCTrExtMux     => SSMCTrExtMux,
            SMBUSGNTEBI      => SMBUSGNTEBI,
            BackOffSsmc      => iSMBUSBACKOFFEBI,
            SMTICBUSGNTEBI   => SMTICBUSGNTEBI
           );
-- -----------------------------------------------------------------------------
-- Memory Clock genrator block instantiation
-- -----------------------------------------------------------------------------
uSsmcTrMemClkGen : SsmcTrMemClkGen
 generic map (
              Tclks         => Tclks,
              Tclkl         => Tclkl,
              Tclkh         => Tclkh
             )
  port map (
-- Input
            SMMemClkRatio => iSMMemClkRatio(2 downto 1),
-- output
            SMMemCLK      => iSMMemCLK
           );


end behavioural;
-- ============================= End =========================================--
