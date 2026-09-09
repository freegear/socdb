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
-- File Name              : DmacTrAhbMaster.vhd.rca
-- File Revision          : 1.5
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           DMA controller AHB Master Interface module. This module
--           instantiates the AHB-Lite master for the DMA controller and the
--           Wrapper around it.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity DmacTrAhbMaster is
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB clock
        HRESETn          : in    std_logic; -- AHB Reset
        HGRANTDMACM      : in    std_logic; -- AHB bus grant for master
        HREADYINM        : in    std_logic; -- HREADYIN response from the Slave
        HRESPM           : in    std_logic_vector(1 downto 0);
                                            -- HRESP response from the AHB Slave
        ChHLOCK          : in    std_logic; -- HLOCK Signal for AHB Bus
        ChWRITE          : in    std_logic; -- Write signal for AHB Bus
        ReqForAhbBus     : in    std_logic; -- Request for AHB Bus from Arbiter
        ChHPROT          : in    std_logic_vector(3 downto 0);
                                            -- HPROT information for AHB Bus
        ChHSIZE          : in    std_logic_vector(2 downto 0);
                                            -- HSIZE information for AHB Bus
        ChAddr           : in    std_logic_vector(31 downto 0);
                                            -- Channel Address for AHB Master
        ChAddrIncr       : in    std_logic; -- Address incr for AHB Mas
        ChDisable        : in    std_logic; -- Channel Disable for AHB Mas
        ChPriority       : in    std_logic; -- Channel Priority from router
        ChBeatCount      : in    std_logic_vector(4 downto 0);
                                            -- Channel BeatCount for Master
        HWDATA           : in    std_logic_vector(31 downto 0);
                                            -- Write Data from channel
-- Outputs
        HBUSREQDMACM     : out   std_logic; -- HBUSREQ signal to the protocol
                                            -- checker block
        HLOCKDMACM       : out   std_logic; -- Lock Information for the protocol
                                            -- checker block
        HPROTM           : out   std_logic_vector(3 downto 0);
                                            -- Protection Info on AHB
        HBURSTM          : out   std_logic_vector(2 downto 0);
                                            -- Burst Information
        HTRANSM          : out   std_logic_vector(1 downto 0);
                                            -- Type of transfer on AHB
        HADDRM           : out   std_logic_vector(31 downto 0);
                                            -- Address for Slave
        HSIZEM           : out   std_logic_vector(2 downto 0);
                                            -- Width of the AHB data transfer
        HWRITEM          : out   std_logic; -- Transfer direction for Slave
        HWDATAM          : out   std_logic_vector(31 downto 0);
                                            -- Write Data to AHB Slave
        DataValid        : out   std_logic; -- DataValid information for Channel
        MREADY           : out   std_logic; -- MREADY for Channel
        DisAckMas        : out   std_logic; -- Disable Acknowledge for Channel
        StopArb          : out   std_logic; -- Stop Arbitration indication
        ErrorMas         : out   std_logic  -- Error Information for Channel
       );
end DmacTrAhbMaster;

-- -----------------------------------------------------------------------------
--
--                               DmacTrAhbMaster
--                               ===============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--
--   This structural block integrates the AHB Lite master interface for the
-- DMAC and the wrapper around it to make it full AHB Master interface.
-- This block instantiates the following functional sub-blocks.
--   - DmacTrAhbLite
--   - DmacTrMasWrap
--
-- -----------------------------------------------------------------------------

-- --============================ ARCHITECTURE ===============================--

architecture structural of DmacTrAhbMaster is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------
component DmacTrMasWrap
  port(
       HCLK        : in  std_logic;
       HRESETn     : in  std_logic;
       HRDATA      : in  std_logic_vector(31 downto 0);
       HREADY      : in  std_logic;
       HRESP       : in  std_logic_vector(1 downto 0);
       HGRANT      : in  std_logic;
       HADDR       : out std_logic_vector(31 downto 0);
       HTRANS      : out std_logic_vector(1 downto 0);
       HWRITE      : out std_logic;
       HSIZE       : out std_logic_vector(2 downto 0);
       HBURST      : out std_logic_vector(2 downto 0);
       HPROT       : out std_logic_vector(3 downto 0);
       HWDATA      : out std_logic_vector(31 downto 0);
       HBUSREQ     : out std_logic;
       HLOCK       : out std_logic;
       MADDR       : in std_logic_vector(31 downto 0);
       MTRANS      : in std_logic_vector(1 downto 0);
       MWRITE      : in std_logic;
       MSIZE       : in std_logic_vector(2 downto 0);
       MBURST      : in std_logic_vector(2 downto 0);
       MPROT       : in std_logic_vector(3 downto 0);
       MMASTLOCK   : in std_logic;
       MWDATA      : in std_logic_vector(31 downto 0);
       MRDATA      : out  std_logic_vector(31 downto 0);
       MREADY      : out  std_logic;
       MERROR      : out  std_logic
      );
end component;

component DmacTrAhbLite
  port(
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        MREADY           : in    std_logic;
        MERROR           : in    std_logic;
        ChHLOCK          : in    std_logic;
        ChWRITE          : in    std_logic;
        ReqForAhbBus     : in    std_logic;
        ChHPROT          : in    std_logic_vector(3 downto 0);
        ChHSIZE          : in    std_logic_vector(2 downto 0);
        ChAddr           : in    std_logic_vector(31 downto 0);
        ChAddrIncr       : in    std_logic;
        ChDisable        : in    std_logic;
        ChPriority       : in    std_logic;
        ChBeatCount      : in    std_logic_vector(4 downto 0);
        MLOCK            : out   std_logic;
        MPROT            : out   std_logic_vector(3 downto 0);
        MBURST           : out   std_logic_vector(2 downto 0);
        MTRANS           : out   std_logic_vector(1 downto 0);
        MADDR            : out   std_logic_vector(31 downto 0);
        MSIZE            : out   std_logic_vector(2 downto 0);
        MWRITE           : out   std_logic;
        DataValid        : out   std_logic;
        DisAckMas        : out   std_logic;
        StopArb          : out   std_logic;
        ErrorMas         : out   std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal MADDR            : std_logic_vector(31 downto 0);
signal MTRANS           : std_logic_vector(1 downto 0);
signal MWRITE           : std_logic;
signal MSIZE            : std_logic_vector(2 downto 0);
signal MBURST           : std_logic_vector(2 downto 0);
signal MPROT            : std_logic_vector(3 downto 0);
signal MLOCK            : std_logic;
signal iMREADY          : std_logic;
signal MERROR           : std_logic;
signal HRDATAIN         : std_logic_vector(31 downto 0)
                                          := "00000000000000000000000000000000";
signal MRDATA           : std_logic_vector(31 downto 0);

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

MREADY <= iMREADY;
-- -----------------------------------------------------------------------------
-- Instantiation of DmacTrMasWrap
-- -----------------------------------------------------------------------------
uDmacTrMasWrap : DmacTrMasWrap
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HRDATA           => HRDATAIN,
            HREADY           => HREADYINM,
            HRESP            => HRESPM,
            HGRANT           => HGRANTDMACM,
            HADDR            => HADDRM,
            HTRANS           => HTRANSM,
            HWRITE           => HWRITEM,
            HSIZE            => HSIZEM,
            HBURST           => HBURSTM,
            HPROT            => HPROTM,
            HWDATA           => HWDATAM,
            HBUSREQ          => HBUSREQDMACM,
            HLOCK            => HLOCKDMACM,
            MADDR            => MADDR,
            MTRANS           => MTRANS,
            MWRITE           => MWRITE,
            MSIZE            => MSIZE,
            MBURST           => MBURST,
            MPROT            => MPROT,
            MMASTLOCK        => MLOCK,
            MWDATA           => HWDATA,
            MRDATA           => MRDATA,
            MREADY           => iMREADY,
            MERROR           => MERROR
           );

-- -----------------------------------------------------------------------------
-- Instantiation of DmacTrAhbLite
-- -----------------------------------------------------------------------------
uDmacTrAhbLite : DmacTrAhbLite
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            MREADY           => iMREADY,
            MERROR           => MERROR,
            ChHLOCK          => ChHLOCK,
            ChWRITE          => ChWRITE,
            ReqForAhbBus     => ReqForAhbBus,
            ChHPROT          => ChHPROT,
            ChHSIZE          => ChHSIZE,
            ChAddr           => ChAddr,
            ChAddrIncr       => ChAddrIncr,
            ChDisable        => ChDisable,
            ChPriority       => ChPriority,
            ChBeatCount      => ChBeatCount,
            MLOCK            => MLOCK,
            MPROT            => MPROT,
            MBURST           => MBURST,
            MTRANS           => MTRANS,
            MADDR            => MADDR,
            MSIZE            => MSIZE,
            MWRITE           => MWRITE,
            DataValid        => DataValid,
            DisAckMas        => DisAckMas,
            StopArb          => StopArb,
            ErrorMas         => ErrorMas
           );

end structural;

-- --================================== End ==================================--
