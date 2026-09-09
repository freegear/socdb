-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000-2003 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : Smc.vhd.rca
-- File Revision          : 1.24
--
-- Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This is the top level structural block of the ARM PrimeCell
--           Static Memory Controller Peripheral SMC_PL092.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity Smc is
  port (
-- Inputs
        nHCLK            : in    std_logic; -- Negative AHB Bus Clock
        HCLK             : in    std_logic; -- AHB Bus Clock
        HRESETn          : in    std_logic; -- AHB Bus Reset Signal
        HREADYIN         : in    std_logic; -- Multiplexed HREADY input
                                            -- from all slaves
        HADDR            : in    std_logic_vector(28 downto 0);
                                            -- AHB Address Bus input
                                            -- to SMC
        HBURST           : in    std_logic_vector(2 downto 0);
                                            -- Information about the type of
                                            -- burst transfer from AHB
        HTRANS           : in    std_logic_vector(1 downto 0);
                                            -- AHB Bus Transfer type
                                            -- input to SMC
        HWRITE           : in    std_logic; -- AHB Bus Transfer Direction
                                            -- input to SMC
        HSIZE            : in    std_logic_vector(2 downto 0);
                                            -- AHB Bus Transfer size
                                            -- input to SMC
        HWDATA           : in    std_logic_vector(31 downto 0);
                                            -- AHB Write Data input to SMC
        HSELSMC          : in    std_logic; -- Device Select signal of
                                            -- Memorybank on AHB Bus
        HSELREG          : in    std_logic; -- Device Select signal of
                                            -- Configuration registers on
                                            -- AHB Bus
        HRESPTIC         : in    std_logic_vector(1 downto 0);
                                            -- AHB Bus Transfer Response to TIC
        HRDATATIC        : in    std_logic_vector(31 downto 0);
                                            -- AHB Read Data Input to TIC
        HGRANTTIC        : in    std_logic; -- AHB Bus Grant to the TIC
        BIGENDIAN        : in    std_logic; -- Type of endianness of the system
        REMAP            : in    std_logic; -- Indicates the state of the
                                            -- Memory map

        TICBUSGNTEBI     : in    std_logic; -- Bus Grant input to TIC from
                                            -- external EbiSdram
        SMBUSGNTEBI      : in    std_logic; -- Bus Grant input to SmcCore from
                                            -- external EbiSdram

        SCANENABLE       : in    std_logic; -- Test Mode input
        SCANINHCLK       : in    std_logic; -- Scan chain input with
                                            -- respect to HCLK
        SCANINnHCLK      : in    std_logic; -- Scan chain input with
                                            -- respect to nHCLK

        SMWAIT           : in    std_logic; -- Async Wait signal from
                                            -- external memory controller
        CANCELSMWAIT     : in    std_logic; -- Asynchronous external input pin
                                            -- to signal that the SMWAIT has
                                            -- timed out
        SMMWCS7          : in    std_logic_vector(1 downto 0);
                                            -- Input pins used to program
                                            -- the memory width bit field
                                            -- of SMCBCR1 register
        SMRBLECS7        : in    std_logic; -- Hardwired input pins for
                                            -- configuring RBLE bit of
                                            -- SMCBCR7 register at reset
        SMDATAIN         : in    std_logic_vector(31 downto 0);
                                            -- Data from Memory to Smc

        TESTREQA         : in    std_logic; -- Test bus request A
        TESTREQB         : in    std_logic; -- Test bus request B

        MCBUSREQ         : in    std_logic; -- Bus Request from Additional
                                            -- Memory Controller
        MCADDR           : in    std_logic_vector(25 downto 0);
                                            -- Additional Memory Controller
                                            -- Address Bus
        MCDATAOUT        : in    std_logic_vector(31 downto 0);
                                            -- Additional controller Output
                                            -- Data Bus
        MCDATAEN         : in    std_logic_vector(3 downto 0);
                                            -- Pad enables from Additional
                                            -- Memory Controller

        EXTBUSMUX        : in    std_logic; -- This tied input will determine
                                            -- whether the internal DBI or
                                            -- external EbiSdram will be
                                            -- used for bus arbitration

-- Outputs
        HRDATA           : out   std_logic_vector(31 downto 0);
                                            -- AHB Read Data output
                                            -- from SMC
        HREADYOUT        : out   std_logic; -- Signal from the SMC to indicate
                                            -- the completion of the transfer
        HRESP            : out   std_logic_vector(1 downto 0);
                                            -- AHB Bus Transfer Response
                                            -- from the SMC

        HADDRTIC         : out   std_logic_vector(31 downto 0);
                                            -- AHB Address output from TIC
        HTRANSTIC        : out   std_logic_vector(1 downto 0);
                                            -- AHB Transfer type output
                                            -- from TIC
        HWRITETIC        : out   std_logic; -- AHB Transfer Direction output
                                            -- from TIC
        HSIZETIC         : out   std_logic_vector(2 downto 0);
                                            -- AHB Transfer Size output
                                            -- from TIC
        HBURSTTIC        : out   std_logic_vector(2 downto 0);
                                            -- AHB Burst Type output from TIC
        HPROTTIC         : out   std_logic_vector(3 downto 0);
                                            -- AHB Protection control signal
        HWDATATIC        : out   std_logic_vector(31 downto 0);
                                            -- AHB Write Data output from TIC
        HBUSREQTIC       : out   std_logic; -- AHB Bus Request
        HLOCKTIC         : out   std_logic; -- AHB signal indicating Locked
                                            -- access to the Bus

        TICBUSREQEBI     : out   std_logic; -- External Data bus request signal
                                            -- from TIC to the EbiSdram
        SMBUSREQEBI      : out   std_logic; -- External Data bus request signal
                                            -- from SmcCore to the EbiSdram

        SCANOUTnHCLK     : out   std_logic; -- Scan chain output with
                                            -- respect to nHCLK
        SCANOUTHCLK      : out   std_logic; -- Scan chain output with
                                            -- respect to HCLK

        SMDATAOUT        : out   std_logic_vector(31 downto 0);
                                            -- Data Bus output from SMC
                                            -- to Memory
        nSMDATAEN        : out   std_logic_vector(3 downto 0);
                                            -- Tri-state I/O pad enable for
                                            -- the byte lanes of external
                                            -- memory data bus
        SMADDR           : out   std_logic_vector(25 downto 0);
                                            -- External Memory address bus
        SMCS             : out   std_logic_vector(7 downto 0);
                                            -- Memory bank Chip Select
                                            -- output pins
        nSMBLS           : out   std_logic_vector(3 downto 0);
                                            -- Memory device Byte lane
                                            -- enables
        nSMWEN           : out   std_logic; -- Memory Write Enable
        nSMOEN           : out   std_logic; -- Memory Output Enable

        TICREADEBI       : out   std_logic; -- Pad Enable signal from TIC when
                                            -- EbiSdram is used
        TBUSOUTEBI       : out   std_logic_vector(31 downto 0);
                                            -- Data bus output from the TIC
                                            -- when EbiSdram is used
        TESTACK          : out   std_logic; -- Test acknowledge

        MCBUSGNT         : out   std_logic  -- Bus Grant to Additional
                                            -- Controller
       );
end Smc;

-- -----------------------------------------------------------------------------
--
--                                   Smc
--                                   ===
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--         The ARM SMC PrimeCell peripheral SMC_PL092 contains the
--         the following main modules :
--         1. SmcCore - This is the main static memory controller core
--         2. TIC - The test interface controller block
--         3. DBI - The data bus interface block arbitrates between the
--                  SmcCore, TIC and additional Memory Controller blocks
--                  for the control of the external data bus
--         4. SmcRevAnd - This is used for the revision number setting
--
-- -----------------------------------------------------------------------------

-- --=========================== ARCHITECTURE ================================--

architecture structural of Smc is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

component DBI
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;

        TICBUSREQ        : in    std_logic;
        SMBUSREQ         : in    std_logic;
        MCBUSREQ         : in    std_logic;
        TICBUSGNTEBI     : in    std_logic;
        SMBUSGNTEBI      : in    std_logic;
        nSMCDATAEN       : in    std_logic_vector(3 downto 0);
        MCDATAEN         : in    std_logic_vector(3 downto 0);
        TICREAD          : in    std_logic;
        SMCDATAOUT       : in    std_logic_vector(31 downto 0);
        MCDATAOUT        : in    std_logic_vector(31 downto 0);
        TBUSOUT          : in    std_logic_vector(31 downto 0);
        SMCADDR          : in    std_logic_vector(25 downto 0);
        MCADDR           : in    std_logic_vector(25 downto 0);
        EXTBUSMUX        : in    std_logic; -- 

        TICBUSREQEBI     : out   std_logic;
        SMBUSREQEBI      : out   std_logic;
        TICBUSGNT        : out   std_logic;
        SMBUSGNT         : out   std_logic;
        MCBUSGNT         : out   std_logic;
        nSMDATAEN        : out   std_logic_vector(3 downto 0);
        TICREADEBI       : out   std_logic;
        SMDATAOUT        : out   std_logic_vector(31 downto 0);
        TBUSOUTEBI       : out   std_logic_vector(31 downto 0);
        SMADDR           : out   std_logic_vector(25 downto 0)
       );
end component;

component TIC
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HREADYIN         : in    std_logic;
        HRESPTIC         : in    std_logic_vector(1 downto 0);
        HGRANTTIC        : in    std_logic;
        HRDATATIC        : in    std_logic_vector(31 downto 0);

        TBUSIN           : in    std_logic_vector(31 downto 0);
        TESTREQA         : in    std_logic;
        TESTREQB         : in    std_logic;
        TICBUSGNT        : in    std_logic;

        HADDRTIC         : out   std_logic_vector(31 downto 0);
        HTRANSTIC        : out   std_logic_vector(1 downto 0);
        HWRITETIC        : out   std_logic;
        HSIZETIC         : out   std_logic_vector(2 downto 0);
        HBURSTTIC        : out   std_logic_vector(2 downto 0);
        HPROTTIC         : out   std_logic_vector(3 downto 0);
        HWDATATIC        : out   std_logic_vector(31 downto 0);
        HBUSREQTIC       : out   std_logic;
        HLOCKTIC         : out   std_logic;
        TBUSOUT          : out   std_logic_vector(31 downto 0);

        TESTACK          : out   std_logic;
        TICBUSREQ        : out   std_logic;
        TICREAD          : out   std_logic
       );
end component;

component SmcCore
  port (
        nHCLK            : in    std_logic;
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HREADYIN         : in    std_logic;
        HADDR            : in    std_logic_vector(28 downto 0);
        HBURST           : in    std_logic_vector(2 downto 0);
        HTRANS           : in    std_logic_vector(1 downto 0);
        HSIZE            : in    std_logic_vector(2 downto 0);
        HWRITE           : in    std_logic;
        HWDATA           : in    std_logic_vector(31 downto 0);
        HSELSMC          : in    std_logic;
        HSELREG          : in    std_logic;
        BIGENDIAN        : in    std_logic;
        REMAP            : in    std_logic;
        Revision         : in    std_logic_vector(3 downto 0);
      
        SMWAIT           : in    std_logic;
        CANCELSMWAIT     : in    std_logic;
        SMMWCS7          : in    std_logic_vector(1 downto 0);
        SMRBLECS7        : in    std_logic;
        SMCDATAIN        : in    std_logic_vector(31 downto 0);
        SMBUSGNT         : in    std_logic;
        HRDATA           : out   std_logic_vector(31 downto 0);
        HREADYOUT        : out   std_logic;
        HRESP            : out   std_logic_vector(1 downto 0);
        nSMCDATAEN       : out   std_logic_vector(3 downto 0);
        nSMWEN           : out   std_logic;
        nSMOEN           : out   std_logic;
        SMBUSREQ         : out   std_logic;
        SMCDATAOUT       : out   std_logic_vector(31 downto 0);
        SMCS             : out   std_logic_vector(7 downto 0);
        nSMBLS           : out   std_logic_vector(3 downto 0);
        SMCADDR          : out   std_logic_vector(25 downto 0)
       );
end component;

component SmcRevAnd
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
signal TICBUSREQ        : std_logic;
-- TIC bus request to DBI

signal SMBUSREQ         : std_logic;
-- Bus request signal from SmcCore to DBI

signal TICBUSGNT        : std_logic;
-- Bus grant signal by the DBI to the TIC

signal SMBUSGNT         : std_logic;
-- Bus grant signal to SmcCore from DBI

signal nSMCDATAEN       : std_logic_vector(3 downto 0);
-- Memory data bus driver enable when SmcCore has the control of the bus

signal TICREAD          : std_logic;
-- Drive AHB read data onto TBUSOUT

signal SMCDATAOUT       : std_logic_vector(31 downto 0);
-- Data from SmcCore to Memory through DBI

signal TBUSOUT          : std_logic_vector(31 downto 0);
-- External test vector output data bus

signal SMCADDR          : std_logic_vector(25 downto 0);
-- Address from SmcCore to Memory through DBI

signal TieOff1          : std_logic_vector(3 downto 0);
-- Input 1 for SmcRevAnd

signal TieOff2          : std_logic_vector(3 downto 0);
-- Input 2 for SmcRevAnd

signal Revision         : std_logic_vector(3 downto 0);
-- Output of SmcRevAnd

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
-- Instantiation of DBI
-- -----------------------------------------------------------------------------
uDBI : DBI
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,

            TICBUSREQ        => TICBUSREQ,
            SMBUSREQ         => SMBUSREQ,
            MCBUSREQ         => MCBUSREQ,
            TICBUSGNTEBI     => TICBUSGNTEBI,
            SMBUSGNTEBI      => SMBUSGNTEBI,
            nSMCDATAEN       => nSMCDATAEN,
            MCDATAEN         => MCDATAEN,
            TICREAD          => TICREAD,
            SMCDATAOUT       => SMCDATAOUT,
            MCDATAOUT        => MCDATAOUT,
            TBUSOUT          => TBUSOUT,
            SMCADDR          => SMCADDR,
            MCADDR           => MCADDR,
            EXTBUSMUX        => EXTBUSMUX,

            TICBUSREQEBI     => TICBUSREQEBI,
            SMBUSREQEBI      => SMBUSREQEBI,
            TICBUSGNT        => TICBUSGNT,
            SMBUSGNT         => SMBUSGNT,
            MCBUSGNT         => MCBUSGNT,
            nSMDATAEN        => nSMDATAEN,
            TICREADEBI       => TICREADEBI,
            SMDATAOUT        => SMDATAOUT,
            TBUSOUTEBI       => TBUSOUTEBI,
            SMADDR           => SMADDR
           );

-- -----------------------------------------------------------------------------
-- Instantiation of TIC
-- -----------------------------------------------------------------------------
uTIC : TIC
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HREADYIN         => HREADYIN,
            HRESPTIC         => HRESPTIC,
            HGRANTTIC        => HGRANTTIC,
            HRDATATIC        => HRDATATIC,

            TBUSIN           => SMDATAIN,
            TESTREQA         => TESTREQA,
            TESTREQB         => TESTREQB,
            TICBUSGNT        => TICBUSGNT,

            HADDRTIC         => HADDRTIC,
            HTRANSTIC        => HTRANSTIC,
            HWRITETIC        => HWRITETIC,
            HSIZETIC         => HSIZETIC,
            HBURSTTIC        => HBURSTTIC,
            HPROTTIC         => HPROTTIC,
            HWDATATIC        => HWDATATIC,
            HBUSREQTIC       => HBUSREQTIC,
            HLOCKTIC         => HLOCKTIC,

            TBUSOUT          => TBUSOUT,
            TESTACK          => TESTACK,
            TICBUSREQ        => TICBUSREQ,
            TICREAD          => TICREAD
           );

-- -----------------------------------------------------------------------------
-- Instantiation of SmcCore
-- -----------------------------------------------------------------------------
uSmcCore : SmcCore
  port map (
            nHCLK            => nHCLK,
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HREADYIN         => HREADYIN,
            HADDR            => HADDR,
            HBURST           => HBURST,
            HTRANS           => HTRANS,
            HSIZE            => HSIZE,
            HWRITE           => HWRITE,
            HWDATA           => HWDATA,
            HSELSMC          => HSELSMC,
            HSELREG          => HSELREG,
            BIGENDIAN        => BIGENDIAN,
            REMAP            => REMAP,
            Revision         => Revision,
            SMWAIT           => SMWAIT,
            CANCELSMWAIT     => CANCELSMWAIT,
            SMMWCS7          => SMMWCS7,
            SMRBLECS7        => SMRBLECS7,
            SMCDATAIN        => SMDATAIN,
            SMBUSGNT         => SMBUSGNT,

            HRDATA           => HRDATA,
            HREADYOUT        => HREADYOUT,
            HRESP            => HRESP,
            nSMCDATAEN       => nSMCDATAEN,
            nSMWEN           => nSMWEN,
            nSMOEN           => nSMOEN,
            SMBUSREQ         => SMBUSREQ,
            SMCDATAOUT       => SMCDATAOUT,
            SMCS             => SMCS,
            nSMBLS           => nSMBLS,
            SMCADDR          => SMCADDR
           );

-- -----------------------------------------------------------------------------
-- Instantiation of SmcRevAnd for bit 0 of Revision
-- -----------------------------------------------------------------------------
u0SmcRevAnd : SmcRevAnd
  port map (
            TieOff1          => TieOff1(0),
            TieOff2          => TieOff2(0),

            Revision         => Revision(0)
           );

-- -----------------------------------------------------------------------------
-- Instantiation of SmcRevAnd for bit 1 of Revision
-- -----------------------------------------------------------------------------
u1SmcRevAnd : SmcRevAnd
  port map (
            TieOff1          => TieOff1(1),
            TieOff2          => TieOff2(1),

            Revision         => Revision(1)
           );

-- -----------------------------------------------------------------------------
-- Instantiation of SmcRevAnd for bit 2 of Revision
-- -----------------------------------------------------------------------------
u2SmcRevAnd : SmcRevAnd
  port map (
            TieOff1          => TieOff1(2),
            TieOff2          => TieOff2(2),

            Revision         => Revision(2)
           );

-- -----------------------------------------------------------------------------
-- Instantiation of SmcRevAnd for bit 3 of Revision
-- -----------------------------------------------------------------------------
u3SmcRevAnd : SmcRevAnd
  port map (
            TieOff1          => TieOff1(3),
            TieOff2          => TieOff2(3),

            Revision         => Revision(3)
           );

-- -----------------------------------------------------------------------------
-- Assign values to inputs of RevAnd
-- -----------------------------------------------------------------------------
TieOff1         <= "0011";
TieOff2         <= "1111";

end structural;

-- --============================= End Smc.vhd  ==============================--
