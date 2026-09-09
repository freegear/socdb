-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001-2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : EbiTrMirEbi.vhd.rca
-- File Revision          : 1.2
--
-- Release Information    : PrimeCell(TM)-PL220-r0p0-00ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--          This the Top Level file for Ebi Mirror Trick Box. 
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity EbiTrMirEbi is
  port (
-- Inputs
        EBICLK           : in    std_logic; -- External Bus Interface Clock
        nPOR             : in    std_logic; -- Power On Reset
        EBIREQ1          : in    std_logic; -- EBI request for Port 1,
                                            -- Active high
        EBIREQ2          : in    std_logic; -- EBI request for Port 2,
                                            -- Active high
        EBIREQ3          : in    std_logic; -- EBI request for Port 3,
                                            -- Active high
        EBIADDR1         : in    std_logic_vector(31 downto 0);
                                            -- EBI Address for Port 1
        EBIADDR2         : in    std_logic_vector(31 downto 0);
                                            -- EBI Address for Port 2
        EBIADDR3         : in    std_logic_vector(31 downto 0);
                                            -- EBI Address for Port 3
        nEBIDATAEN1      : in    std_logic_vector(3 downto 0);
                                            -- EBI Data Enable for port 1
        nEBIDATAEN2      : in    std_logic_vector(3 downto 0);
                                            -- EBI Data Enable for port 2
        nEBIDATAEN3      : in    std_logic_vector(3 downto 0);
                                            -- EBI Data Enable for port 3
        EBIDATA1         : in    std_logic_vector(31 downto 0);
                                            -- EBI Data for Port 1
        EBIDATA2         : in    std_logic_vector(31 downto 0);
                                            -- EBI Data for Port 2
        EBIDATA3         : in    std_logic_vector(31 downto 0);
                                            -- EBI Data for Port 3
        EBIEXTDATAIN     : in    std_logic_vector(31 downto 0);
                                            -- External Data input from
                                            -- the pads
        EBITIMEOUTVALUE1 : in    std_logic_vector(9 downto 0);
                                            -- Gives the value to be loaded
                                            -- into timeout counter for port 1.
        EBITIMEOUTVALUE2 : in    std_logic_vector(9 downto 0);
                                            -- Gives the value to be loaded
                                            -- into timeout counter for port 2.
        EBITIMEOUTVALUE3 : in    std_logic_vector(9 downto 0);
                                            -- Gives the value to be loaded
                                            -- into timeout counter for port 3.

-- Outputs
        EbiTrGnt1        : out   std_logic; -- EBI Grant for port 1
        EbiTrGnt2        : out   std_logic; -- EBI Grant for port 2
        EbiTrGnt3        : out   std_logic; -- EBI Grant for port 3
        EbiTrBackoff1    : out   std_logic; -- EBIBACKOFF signal for port 1
                                            -- Indicates to Controller-1
                                            -- that the current transfer
                                            -- should be completed as soon as
                                            -- possible.
        EbiTrBackoff2    : out   std_logic; -- EBIBACKOFF signal for port 2
                                            -- Indicates to Controller-2
                                            -- that the current transfer
                                            -- should be completed as soon as
                                            -- possible.
        EbiTrBackoff3    : out   std_logic; -- EBIBACKOFF signal for port 3
                                            -- Indicates to Controller-3
                                            -- that the current transfer
                                            -- should be completed as soon as
                                            -- possible.
        EbiTrDataIn      : out   std_logic_vector(31 downto 0);
                                            -- Data input connected to all the
                                            -- Controllers
        EbiTrExtAddrOut  : out   std_logic_vector(31 downto 0);
                                            -- Address output to the pads
        EbiTrExtDataOut  : out   std_logic_vector(31 downto 0);
                                            -- Data output to the pads
        nEbiTrExtDataEn  : out   std_logic_vector(3 downto 0)
                                            -- Data Enable to the pads
       );
end EbiTrMirEbi;

-- -----------------------------------------------------------------------------
--
--                                 EbiTrMirEbi
--                                 ===========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- o EbiTrMirEbi block
--     This module is top level file for EBI Mirror Trick box.
--
-- -----------------------------------------------------------------------------

-- --============================= ARCHITECTURE ==============================--

architecture behavioural of EbiTrMirEbi is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- Ebi Arbitration and Control Block
-- -----------------------------------------------------------------------------
component EbiTrArbtCtl
  port (
        EBICLK           : in    std_logic;
        nPOR             : in    std_logic;
        EBIREQ1          : in    std_logic;
        EBIREQ2          : in    std_logic;
        EBIREQ3          : in    std_logic;
        EBITIMEOUTVALUE1 : in    std_logic_vector(9 downto 0);
        EBITIMEOUTVALUE2 : in    std_logic_vector(9 downto 0);
        EBITIMEOUTVALUE3 : in    std_logic_vector(9 downto 0);
        EbiTrBackoff     : out   std_logic_vector(2 downto 0);
        EbiTrGnt         : out   std_logic_vector(2 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- Ebi Multiplexing Block
-- -----------------------------------------------------------------------------
component EbiTrMultBlk
  port (
        EBICLK           : in    std_logic;
        nPOR             : in    std_logic;
        EbiTrGnt         : in    std_logic_vector(2 downto 0);
        EBIADDR1         : in    std_logic_vector(31 downto 0);
        EBIADDR2         : in    std_logic_vector(31 downto 0);
        EBIADDR3         : in    std_logic_vector(31 downto 0);
        nEBIDATAEN1      : in    std_logic_vector(3 downto 0);
        nEBIDATAEN2      : in    std_logic_vector(3 downto 0);
        nEBIDATAEN3      : in    std_logic_vector(3 downto 0);
        EBIDATA1         : in    std_logic_vector(31 downto 0);
        EBIDATA2         : in    std_logic_vector(31 downto 0);
        EBIDATA3         : in    std_logic_vector(31 downto 0);
        EBIEXTDATAIN     : in    std_logic_vector(31 downto 0);
        EbiTrDataIn      : out   std_logic_vector(31 downto 0);
        EbiTrExtAddrOut  : out   std_logic_vector(31 downto 0);
        EbiTrExtDataOut  : out   std_logic_vector(31 downto 0);
        nEbiTrExtDataEn  : out   std_logic_vector(3 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal iEbiGnt          : std_logic_vector(2 downto 0);
-- Internal Signal for Port Mapping

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
-- Assigning Local Copies to the OutPut Grant Signal.
-- -----------------------------------------------------------------------------
EbiTrGnt1 <= iEbiGnt(0);
EbiTrGnt2 <= iEbiGnt(1);
EbiTrGnt3 <= iEbiGnt(2);

-- -----------------------------------------------------------------------------
-- Port mapping of Ebi Arbitration and Control Block.
-- -----------------------------------------------------------------------------
uEbiTrArbtCtl : EbiTrArbtCtl
  port map (
            EBICLK           => EBICLK,
            nPOR             => nPOR,
            EBIREQ1          => EBIREQ1,
            EBIREQ2          => EBIREQ2,
            EBIREQ3          => EBIREQ3,
            EBITIMEOUTVALUE1 => EBITIMEOUTVALUE1,
            EBITIMEOUTVALUE2 => EBITIMEOUTVALUE2,
            EBITIMEOUTVALUE3 => EBITIMEOUTVALUE3,
            EbiTrBackoff(2)  => EbiTrBackoff3,
            EbiTrBackoff(1)  => EbiTrBackoff2,
            EbiTrBackoff(0)  => EbiTrBackoff1,
            EbiTrGnt         => iEbiGnt
           );
-- -----------------------------------------------------------------------------
-- Port mapping of Ebi Multiplexing Block.
-- -----------------------------------------------------------------------------
uEbiTrMultBlk : EbiTrMultBlk
  port map (
            EBICLK           => EBICLK,
            nPOR             => nPOR,
            EbiTrGnt         => iEbiGnt,
            EBIADDR1         => EBIADDR1,
            EBIADDR2         => EBIADDR2,
            EBIADDR3         => EBIADDR3,
            nEBIDATAEN1      => nEBIDATAEN1,
            nEBIDATAEN2      => nEBIDATAEN2,
            nEBIDATAEN3      => nEBIDATAEN3,
            EBIDATA1         => EBIDATA1,
            EBIDATA2         => EBIDATA2,
            EBIDATA3         => EBIDATA3,
            EBIEXTDATAIN     => EBIEXTDATAIN,
            EbiTrDataIn      => EbiTrDataIn,
            EbiTrExtAddrOut  => EbiTrExtAddrOut,
            EbiTrExtDataOut  => EbiTrExtDataOut,
            nEbiTrExtDataEn  => nEbiTrExtDataEn
           );

end behavioural;

-- --================================== End ==================================--
