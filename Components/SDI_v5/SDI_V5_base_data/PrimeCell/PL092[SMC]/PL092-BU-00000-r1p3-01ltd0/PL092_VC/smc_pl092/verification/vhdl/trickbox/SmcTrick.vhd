-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000-2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : SmcTrick.vhd.rca
-- File Revision          : 1.14
--
-- Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This module is the top level SMC Trickbox
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SmcTrick is
  generic (
           Tclk             : time := 10.52 ns
                                            -- HCLK Period
          );
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB Bus Clock
        HRESETn          : in    std_logic; -- Bus Reset
        HADDR            : in    std_logic_vector(6 downto 2);
                                            -- AHB Address Bus
        HTRANS           : in    std_logic_vector(1 downto 0);
                                            -- Transfer type
        HWRITE           : in    std_logic; -- AHB Peripheral Write
        HSIZE            : in    std_logic_vector(2 downto 0);
                                            -- Transfer size
        HREADYIN         : in    std_logic; -- Multiplexed version of
                                            -- HREADY outputs
        HWDATA           : in    std_logic_vector(31 downto 0);
                                            -- AHB Write Data bus
        HSELSMCTR        : in    std_logic; -- AHB Peripheral (Trickbox)
                                            -- Select

        SMDATAOUT        : in    std_logic_vector(31 downto 0);
                                            -- SMC Data Out Bus to Memory
        SMADDR           : in    std_logic_vector(25 downto 0);
                                            -- Memory Address Bus
        SMCS             : in    std_logic_vector(7 downto 0);
                                            -- Memory chip select lines
        nSMDATAEN        : in    std_logic_vector(3 downto 0);
                                            -- Memory Data Bus Enable lines
        nSMWEN           : in    std_logic; -- Memory Write Enable
        nSMBLS           : in    std_logic_vector(3 downto 0);
                                            -- Memory Data Bus Lane Enable
        nSMOEN           : in    std_logic; -- Memory Output Enable
        SMCActLowCS      : in    std_logic_vector(7 downto 0);
                                            -- Active low Memory Bank Select
        MCBUSGNT         : in    std_logic; -- MCBUS Grant
        SMBUSREQ         : in    std_logic; -- SMBUS request

-- Outputs
        HRDATA           : out   std_logic_vector(31 downto 0);
                                            -- AHB Read Data bus
        HREADYOUT        : out   std_logic; -- Slave HREADY output
        HRESP            : out   std_logic_vector(1 downto 0);
                                            -- Slave response
        ENDIANCNT        : out   std_logic; -- Endianness of the System
        REMAP            : out   std_logic; -- Reset/Normal Memory map select

        SMMWCS7          : out   std_logic_vector(1 downto 0);
                                            -- Boot Memory Bank Width

        SMWAIT           : out   std_logic; -- External Wait signal routed to
                                            -- the SMC
        nSMWAIT          : out   std_logic; -- External Wait signal routed to
                                            -- the SMC
        CANCELSMWAIT     : out   std_logic; -- External Wait time-out signal

        MCBUSREQ         : out   std_logic; -- MCBUS Access Request signal
        MCADDR           : out   std_logic_vector(25 downto 0);
                                            -- MCBUS Address signals
        MCDATAOUT        : out   std_logic_vector(31 downto 0);
                                            -- MCBUS Data Out signals
        MCDATAEN         : out   std_logic_vector(3 downto 0);
                                            -- MCBUS Data Enable lines
        SMBUSGNT         : out   std_logic; -- SMBUS Grant
        EXTBUSMUX        : out   std_logic
       );
end SmcTrick;

-- -----------------------------------------------------------------------------
--
--                                  SmcTrick
--                                  ========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--   This block is the top level of the SMC Trickbox Memory Model. This block
-- instantiates the following sub-blocks:
--
-- 1. SmcTrAhbifReg - AHB Interface and Register Block
-- 2. SmcTrProtChkr - SMC Protocol Checker
--
-- -----------------------------------------------------------------------------

-- --============================ ARCHITECTURE ===============================--

architecture behavioural of SmcTrick is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- The SMC Trickbox AHB Interface
-- -----------------------------------------------------------------------------
component SmcTrAhbifReg
  port (
        -- AHB bus signals
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HADDR            : in    std_logic_vector(6 downto 2);
        HTRANS           : in    std_logic_vector(1 downto 0);
        HWRITE           : in    std_logic;
        HSIZE            : in    std_logic_vector(2 downto 0);
        HREADYIN         : in    std_logic;
        HWDATA           : in    std_logic_vector(31 downto 0);
        HSELSMCTR        : in    std_logic;
        HRDATA           : out   std_logic_vector(31 downto 0);
        HREADYOUT        : out   std_logic;
        HRESP            : out   std_logic_vector(1 downto 0);
        ENDIANCNT        : out   std_logic;
        REMAP            : out   std_logic;

        -- SMC related signals
        SMMWCS7          : out   std_logic_vector(1 downto 0);
        SMCTrCS2WTR0     : out   std_logic_vector(25 downto 0);
        SMCTrCEWTR0      : out   std_logic_vector(23 downto 0);
        SMCTrCS2WTR1     : out   std_logic_vector(25 downto 0);
        SMCTrCEWTR1      : out   std_logic_vector(23 downto 0);
        SMCTrCS2WTR2     : out   std_logic_vector(25 downto 0);
        SMCTrCEWTR2      : out   std_logic_vector(23 downto 0);
        SMCTrCS2WTR3     : out   std_logic_vector(25 downto 0);
        SMCTrCEWTR3      : out   std_logic_vector(23 downto 0);
        SMCTrCS2WTR4     : out   std_logic_vector(25 downto 0);
        SMCTrCEWTR4      : out   std_logic_vector(23 downto 0);
        SMCTrCS2WTR5     : out   std_logic_vector(25 downto 0);
        SMCTrCEWTR5      : out   std_logic_vector(23 downto 0);
        SMCTrCS2WTR6     : out   std_logic_vector(25 downto 0);
        SMCTrCEWTR6      : out   std_logic_vector(23 downto 0);
        SMCTrCS2WTR7     : out   std_logic_vector(25 downto 0);
        SMCTrCEWTR7      : out   std_logic_vector(23 downto 0);
        SMCTrMCREQD      : out   std_logic_vector(4 downto 0);
        SMCTrGNT2RMREQ   : out   std_logic_vector(4 downto 0);
        SMCTrMCADDR      : out   std_logic_vector(25 downto 0);
        SMCTrMCDATAOUT   : out   std_logic_vector(31 downto 0);
        SMCTrCNCLWAIT    : out   std_logic_vector(5 downto 0);
        SMCTrEBICntl     : out   std_logic_vector(11 downto 0);
        SMCTrMCBUSRRd    : out   std_logic;
        SMCTrMCBUSRWr    : out   std_logic;
        SMCTrCNCLWAITRd  : out   std_logic;
        SMCTrCNCLWAITWr  : out   std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- The SMC Protocol Checker module
-- -----------------------------------------------------------------------------
component SmcTrProtChkr
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        SMDATAOUT        : in    std_logic_vector(31 downto 0);
        SMADDR           : in    std_logic_vector(25 downto 0);
        SMCActLowCS      : in    std_logic_vector(7 downto 0);
        SMCS             : in    std_logic_vector(7 downto 0);
        nSMDATAEN        : in    std_logic_vector(3 downto 0);
        nSMWEN           : in    std_logic;
        nSMBLS           : in    std_logic_vector(3 downto 0);
        nSMOEN           : in    std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- The SMC SMWAIT Control Logic
-- -----------------------------------------------------------------------------
component SmcTrWaitCntl
  generic (
           Tclk             : time
          );
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        SMCActLowCS      : in    std_logic_vector(7 downto 0);
        SMADDR           : in    std_logic_vector(25 downto 0);
        SMCTrCS2WTR0     : in    std_logic_vector(25 downto 0);
        SMCTrCEWTR0      : in    std_logic_vector(23 downto 0);
        SMCTrCS2WTR1     : in    std_logic_vector(25 downto 0);
        SMCTrCEWTR1      : in    std_logic_vector(23 downto 0);
        SMCTrCS2WTR2     : in    std_logic_vector(25 downto 0);
        SMCTrCEWTR2      : in    std_logic_vector(23 downto 0);
        SMCTrCS2WTR3     : in    std_logic_vector(25 downto 0);
        SMCTrCEWTR3      : in    std_logic_vector(23 downto 0);
        SMCTrCS2WTR4     : in    std_logic_vector(25 downto 0);
        SMCTrCEWTR4      : in    std_logic_vector(23 downto 0);
        SMCTrCS2WTR5     : in    std_logic_vector(25 downto 0);
        SMCTrCEWTR5      : in    std_logic_vector(23 downto 0);
        SMCTrCS2WTR6     : in    std_logic_vector(25 downto 0);
        SMCTrCEWTR6      : in    std_logic_vector(23 downto 0);
        SMCTrCS2WTR7     : in    std_logic_vector(25 downto 0);
        SMCTrCEWTR7      : in    std_logic_vector(23 downto 0);
        SMCTrCNCLWAIT    : in    std_logic_vector(5 downto 0);
        SMWAIT           : out   std_logic;
        nSMWAIT          : out   std_logic;
        CANCELSMWAIT     : out   std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- The MCBUS Block
-- -----------------------------------------------------------------------------
component SmcTrMCBusBlk
  generic (
           Tclk             : time
          );
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        SMADDR           : in    std_logic_vector(25 downto 0);
        SMDATAOUT        : in    std_logic_vector(31 downto 0);
        nSMDATAEN        : in    std_logic_vector(3 downto 0);
        MCBUSGNT         : in    std_logic;
        SMCTrMCREQD      : in    std_logic_vector(4 downto 0);
        SMCTrGNT2RMREQ   : in    std_logic_vector(4 downto 0);
        SMCTrMCADDR      : in    std_logic_vector(25 downto 0);
        SMCTrMCDATAOUT   : in    std_logic_vector(31 downto 0);
        SMCTrMCBUSRRd    : in    std_logic;
        SMCTrMCBUSRWr    : in    std_logic;
        SMCTrEBICntl     : in    std_logic_vector(11 downto 0);
        SMBUSREQ         : in    std_logic;
        MCBUSREQ         : out   std_logic;
        MCADDR           : out   std_logic_vector(25 downto 0);
        MCDATAOUT        : out   std_logic_vector(31 downto 0);
        MCDATAEN         : out   std_logic_vector(3 downto 0);
        SMBUSGNT         : out   std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal SMCTrCS2WTR0     : std_logic_vector(25 downto 0);
-- SMCTrCS2WT Register for Bank 0

signal SMCTrCEWTR0      : std_logic_vector(23 downto 0);
-- SMCTrCEWT Register for Bank 0

signal SMCTrCS2WTR1     : std_logic_vector(25 downto 0);
-- SMCTrCS2WT Register for Bank 1

signal SMCTrCEWTR1      : std_logic_vector(23 downto 0);
-- SMCTrCEWT Register for Bank 1

signal SMCTrCS2WTR2     : std_logic_vector(25 downto 0);
-- SMCTrCS2WT Register for Bank 2

signal SMCTrCEWTR2      : std_logic_vector(23 downto 0);
-- SMCTrCEWT Register for Bank 2

signal SMCTrCS2WTR3     : std_logic_vector(25 downto 0);
-- SMCTrCS2WT Register for Bank 3

signal SMCTrCEWTR3      : std_logic_vector(23 downto 0);
-- SMCTrCEWT Register for Bank 3

signal SMCTrCS2WTR4     : std_logic_vector(25 downto 0);
-- SMCTrCS2WT Register for Bank 4

signal SMCTrCEWTR4      : std_logic_vector(23 downto 0);
-- SMCTrCEWT Register for Bank 4

signal SMCTrCS2WTR5     : std_logic_vector(25 downto 0);
-- SMCTrCS2WT Register for Bank 5

signal SMCTrCEWTR5      : std_logic_vector(23 downto 0);
-- SMCTrCEWT Register for Bank 5

signal SMCTrCS2WTR6     : std_logic_vector(25 downto 0);
-- SMCTrCS2WT Register for Bank 6

signal SMCTrCEWTR6      : std_logic_vector(23 downto 0);
-- SMCTrCEWT Register for Bank 6

signal SMCTrCS2WTR7     : std_logic_vector(25 downto 0);
-- SMCTrCS2WT Register for Bank 7

signal SMCTrCEWTR7      : std_logic_vector(23 downto 0);
-- SMCTrCEWT Register for Bank 7

signal SMCTrMCREQD      : std_logic_vector(4 downto 0);
-- SMCTrMCREQD Register

signal SMCTrGNT2RMREQ   : std_logic_vector(4 downto 0);
-- SMCTrGNT2RMREQ Register

signal SMCTrMCADDR      : std_logic_vector(25 downto 0);
-- SMCTrMCADDR Register

signal SMCTrMCDATAOUT   : std_logic_vector(31 downto 0);
-- SMCTrMCDATAOUT Register

signal SMCTrCNCLWAIT    : std_logic_vector(5 downto 0);
-- SMCTrCNCLWAIT Register

signal SMCTrMCBUSRRd    : std_logic;
-- SMCTrMCBUSR Read

signal SMCTrMCBUSRWr    : std_logic;
-- SMCTrMCBUSR Write

signal SMCTrCNCLWAITRd  : std_logic;

signal SMCTrCNCLWAITWr  : std_logic;

signal SMCTrEBICntl     : std_logic_vector(11 downto 0);

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
-- The SMC Trickbox AHB Interface Instantiation
-- -----------------------------------------------------------------------------
uSmcTrAhbifReg : SmcTrAhbifReg
  port map (
            -- AHB bus signals
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HADDR            => HADDR,
            HTRANS           => HTRANS,
            HWRITE           => HWRITE,
            HSIZE            => HSIZE,
            HREADYIN         => HREADYIN,
            HWDATA           => HWDATA,
            HSELSMCTR        => HSELSMCTR,
            HRDATA           => HRDATA,
            HREADYOUT        => HREADYOUT,
            HRESP            => HRESP,
            ENDIANCNT        => ENDIANCNT,
            REMAP            => REMAP,

            -- SMC related signals
            SMMWCS7          => SMMWCS7,
            SMCTrCS2WTR0     => SMCTrCS2WTR0,
            SMCTrCEWTR0      => SMCTrCEWTR0,
            SMCTrCS2WTR1     => SMCTrCS2WTR1,
            SMCTrCEWTR1      => SMCTrCEWTR1,
            SMCTrCS2WTR2     => SMCTrCS2WTR2,
            SMCTrCEWTR2      => SMCTrCEWTR2,
            SMCTrCS2WTR3     => SMCTrCS2WTR3,
            SMCTrCEWTR3      => SMCTrCEWTR3,
            SMCTrCS2WTR4     => SMCTrCS2WTR4,
            SMCTrCEWTR4      => SMCTrCEWTR4,
            SMCTrCS2WTR5     => SMCTrCS2WTR5,
            SMCTrCEWTR5      => SMCTrCEWTR5,
            SMCTrCS2WTR6     => SMCTrCS2WTR6,
            SMCTrCEWTR6      => SMCTrCEWTR6,
            SMCTrCS2WTR7     => SMCTrCS2WTR7,
            SMCTrCEWTR7      => SMCTrCEWTR7,
            SMCTrMCREQD      => SMCTrMCREQD,
            SMCTrGNT2RMREQ   => SMCTrGNT2RMREQ,
            SMCTrMCADDR      => SMCTrMCADDR,
            SMCTrMCDATAOUT   => SMCTrMCDATAOUT,
            SMCTrMCBUSRRd    => SMCTrMCBUSRRd,
            SMCTrCNCLWAIT    => SMCTrCNCLWAIT,
            SMCTrEBICntl     => SMCTrEBICntl,
            SMCTrCNCLWAITRd  => SMCTrCNCLWAITRd,
            SMCTrCNCLWAITWr  => SMCTrCNCLWAITWr,
            SMCTrMCBUSRWr    => SMCTrMCBUSRWr
           );

-- -----------------------------------------------------------------------------
-- The SMC Protocol Checker module Instantiation
-- -----------------------------------------------------------------------------
uSmcTrProtChkr : SmcTrProtChkr
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            SMDATAOUT        => SMDATAOUT,
            SMADDR           => SMADDR,
            SMCActLowCS      => SMCActLowCS,
            SMCS             => SMCS,
            nSMDATAEN        => nSMDATAEN,
            nSMWEN           => nSMWEN,
            nSMBLS           => nSMBLS,
            nSMOEN           => nSMOEN
           );

-- -----------------------------------------------------------------------------
-- The SMC SMWAIT Control Logic Instantiation
-- -----------------------------------------------------------------------------
uSmcTrWaitCntl : SmcTrWaitCntl
  generic map (
               Tclk             => Tclk
              )
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            SMCActLowCS      => SMCActLowCS,
            SMADDR           => SMADDR,
            SMCTrCS2WTR0     => SMCTrCS2WTR0,
            SMCTrCEWTR0      => SMCTrCEWTR0,
            SMCTrCS2WTR1     => SMCTrCS2WTR1,
            SMCTrCEWTR1      => SMCTrCEWTR1,
            SMCTrCS2WTR2     => SMCTrCS2WTR2,
            SMCTrCEWTR2      => SMCTrCEWTR2,
            SMCTrCS2WTR3     => SMCTrCS2WTR3,
            SMCTrCEWTR3      => SMCTrCEWTR3,
            SMCTrCS2WTR4     => SMCTrCS2WTR4,
            SMCTrCEWTR4      => SMCTrCEWTR4,
            SMCTrCS2WTR5     => SMCTrCS2WTR5,
            SMCTrCEWTR5      => SMCTrCEWTR5,
            SMCTrCS2WTR6     => SMCTrCS2WTR6,
            SMCTrCEWTR6      => SMCTrCEWTR6,
            SMCTrCS2WTR7     => SMCTrCS2WTR7,
            SMCTrCEWTR7      => SMCTrCEWTR7,
            SMCTrCNCLWAIT    => SMCTrCNCLWAIT,
            SMWAIT           => SMWAIT,
            nSMWAIT          => nSMWAIT,
            CANCELSMWAIT     => CANCELSMWAIT
           );

-- -----------------------------------------------------------------------------
-- The MCBUS Block Instantiation
-- -----------------------------------------------------------------------------
uSmcTrMCBusBlk : SmcTrMCBusBlk
  generic map (
               Tclk             => Tclk
              )
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            SMADDR           => SMADDR,
            SMDATAOUT        => SMDATAOUT,
            nSMDATAEN        => nSMDATAEN,
            MCBUSGNT         => MCBUSGNT,
            SMCTrMCREQD      => SMCTrMCREQD,
            SMCTrGNT2RMREQ   => SMCTrGNT2RMREQ,
            SMCTrMCADDR      => SMCTrMCADDR,
            SMCTrMCDATAOUT   => SMCTrMCDATAOUT,
            SMCTrMCBUSRRd    => SMCTrMCBUSRRd,
            SMCTrMCBUSRWr    => SMCTrMCBUSRWr,
            SMCTrEBICntl     => SMCTrEBICntl,
            SMBUSREQ         => SMBUSREQ,
            MCBUSREQ         => MCBUSREQ,
            MCADDR           => MCADDR,
            MCDATAOUT        => MCDATAOUT,
            MCDATAEN         => MCDATAEN,
            SMBUSGNT         => SMBUSGNT
           );

-- -----------------------------------------------------------------------------
-- assigning local copies to output
-- -----------------------------------------------------------------------------
EXTBUSMUX <= SMCTrEBICntl(11);

end behavioural;

-- --================================== End ==================================--
