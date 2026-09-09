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
-- File Name              : MpmcTrickMem.vhd.rca
-- File Revision          : 1.6
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This module is the top level MPMC Trickbox Memory model.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity MpmcTrickMem is
  generic (
           Tclk             : time := 10.52 ns
                                            -- HCLK Period
          );
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB Clock
        HRESETn          : in    std_logic; -- Bus Reset
        HADDR            : in    std_logic_vector(15 downto 0);
                                            -- AHB Address Bus
        HTRANS           : in    std_logic_vector(1 downto 0);
                                            -- Transfer type
        HWRITE           : in    std_logic; -- AHB Peripheral Write
        HSIZE            : in    std_logic_vector(2 downto 0);
                                            -- Transfer size
        HBURST           : in    std_logic_vector(2 downto 0);
                                            -- Burst Type
        HREADYIN         : in    std_logic; -- Multiplexed version of
                                            -- HREADY outputs
        HWDATA           : in    std_logic_vector(31 downto 0);
                                            -- AHB Write Data bus
        HSELMPMCTRMEM    : in    std_logic; -- AHB Peripheral (TrickMem)
                                            -- Select
        MPMCADDR         : in    std_logic_vector(27 downto 0);
                                            -- Memory Address Bus
        nMPMCDATAEN      : in    std_logic_vector(3 downto 0);
                                            -- Memory Bus Enable
        nMPMCWEN         : in    std_logic; -- Write Enable for the external
                                            -- Memory bank
        nMPMCOEN         : in    std_logic; -- Output Enable for the external
                                            -- Memory bank
        nMPMCBLS         : in    std_logic_vector(3 downto 0);
                                            -- Byte Enables for the external
                                            -- Memory bank
        MPMCTrAllCS      : in    std_logic_vector(7 downto 0);
                                            -- The CS status of all the eight
                                            -- banks connected with the MPMC
        MPMCTrCS         : in    std_logic; -- Individual select line for a
                                            -- TrickMem
        MPMCTrStExtWt    : in    std_logic_vector(9 downto 0);
                                            -- MPMCTrExtWait Register

-- Inouts
        MPMCDATA         : inout std_logic_vector(31 downto 0);
                                            -- Memory Data Bus

-- Outputs
        HRDATA           : out   std_logic_vector(31 downto 0);
                                            -- AHB Read Data bus
        HREADYOUT        : out   std_logic; -- Slave HREADY output
        HRESP            : out   std_logic_vector(1 downto 0);
                                            -- Slave response

        MPMCActLowCS     : out   std_logic  -- Used for suitably routing the
                                            -- MPMCTrWAIT as the final MPMCWAIT
                                            -- at the top-level of the tbench
       );
end MpmcTrickMem;

-- -----------------------------------------------------------------------------
--
--                                MpmcTrickMem
--                                ============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--   This block is the top level of the MPMC Trickbox Memory Model. This block
-- instantiates the following sub-blocks:
--
-- 1. MpmcTrMemAhbifReg - AHB Interface and Register Block
-- 2. MpmcTrMemRdWrCtl  - Memory Read/Write Control and Timing checks
-- 3. MpmcTrMemArray    - Memory Element
-- 4. MpmcTrPackage     - Constant declaration
--
-- -----------------------------------------------------------------------------

-- --============================= ARCHITECTURE ==============================--

architecture structural of MpmcTrickMem is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- AHB Interface and Register Block
-- -----------------------------------------------------------------------------
component MpmcTrMemAhbifReg
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HADDR            : in    std_logic_vector(15 downto 0);
        HTRANS           : in    std_logic_vector(1 downto 0);
        HWRITE           : in    std_logic;
        HSIZE            : in    std_logic_vector(2 downto 0);
        HBURST           : in    std_logic_vector(2 downto 0);
        HREADYIN         : in    std_logic;
        HWDATA           : in    std_logic_vector(31 downto 0);
        HSELMPMCTRMEM    : in    std_logic;
        AhbRdDataDW      : in    std_logic_vector(31 downto 0);
        HRDATA           : out   std_logic_vector(31 downto 0);
        HREADYOUT        : out   std_logic;
        HRESP            : out   std_logic_vector(1 downto 0);

        MPMCTrMEMRWr     : out   std_logic;
        LatchHADDR       : out   std_logic_vector(15 downto 0);
        MPMCTrIDCY       : out   std_logic_vector(4 downto 0);
        MPMCTrWaitRd     : out   std_logic_vector(5 downto 0);
        MPMCTrWaitWr     : out   std_logic_vector(5 downto 0);
        MPMCTrWaitPg     : out   std_logic_vector(5 downto 0);
        MPMCTrMEMT       : out   std_logic_vector(10 downto 0);
        MPMCTrMEMB       : out   std_logic_vector(16 downto 0);
        MPMCTrCS2OEN     : out   std_logic_vector(4 downto 0);
        MPMCTrCS2WEN     : out   std_logic_vector(4 downto 0);
        MPMCTrCSPOL      : out   std_logic_vector(7 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- Memory Read/Write Control and Timing checks Block
-- -----------------------------------------------------------------------------
component MpmcTrMemRdWrCtl
  generic (
           Tclk             : time
          );
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        MPMCADDR         : in    std_logic_vector(27 downto 0);
        nMPMCDATAEN      : in    std_logic_vector(3 downto 0);
        MPMCTrCS         : in    std_logic;
        MPMCTrAllCS      : in    std_logic_vector(7 downto 0);
        nMPMCWEN         : in    std_logic;
        nMPMCBLS         : in    std_logic_vector(3 downto 0);
        nMPMCOEN         : in    std_logic;
        MemRdDataDW      : in    std_logic_vector(31 downto 0);
        MPMCTrIDCY       : in    std_logic_vector(4 downto 0);
        MPMCTrWaitRd     : in    std_logic_vector(5 downto 0);
        MPMCTrWaitWr     : in    std_logic_vector(5 downto 0);
        MPMCTrWaitPg     : in    std_logic_vector(5 downto 0);
        MPMCTrMEMT       : in    std_logic_vector(10 downto 0);
        MPMCTrMEMB       : in    std_logic_vector(16 downto 0);
        MPMCTrCS2OEN     : in    std_logic_vector(4 downto 0);
        MPMCTrCS2WEN     : in    std_logic_vector(4 downto 0);
        MPMCTrExtWait    : in    std_logic_vector(9 downto 0);
        MPMCTrCSPOL      : in    std_logic_vector(7 downto 0);
        MPMCDATA         : inout std_logic_vector(31 downto 0);
        LatchMCADDR      : out   std_logic_vector(10 downto 0);
        MPMCActLowCS     : out   std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- Memory Element
-- -----------------------------------------------------------------------------
component MpmcTrMemArray
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        nCS              : in    std_logic;
        nMPMCBLS         : in    std_logic;
        MPMCTrMEMRWr     : in    std_logic;
        LatchHADDR       : in    std_logic_vector(10 downto 0);
        LatchMCADDR      : in    std_logic_vector(10 downto 0);
        HWDATA           : in    std_logic_vector(7 downto 0);
        MemWrDatab       : in    std_logic_vector(7 downto 0);
        AhbRdDatab       : out   std_logic_vector(7 downto 0);
        MemRdDatab       : out   std_logic_vector(7 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal LatchHADDR       : std_logic_vector(15 downto 0);
-- Latched AHB Address. This is used when the memory is accessed via AHB

signal MPMCTrIDCY       : std_logic_vector(4 downto 0);
-- Memory data bus turn around time count

signal MPMCTrWaitRd     : std_logic_vector(5 downto 0);
-- Initial Access time count in case of BROMs
-- Read Access time count in case of SRAMs or ROMs

signal MPMCTrWaitWr     : std_logic_vector(5 downto 0);
-- Write access time count in case of SRAM
-- Burst access time count in case of BROMs
-- Insignificant in case of ROMs

signal MPMCTrWaitPg     : std_logic_vector(5 downto 0);
-- Page mode access delay

signal MPMCTrMEMT       : std_logic_vector(10 downto 0);
-- Memory type specifier

signal MPMCTrMEMB       : std_logic_vector(16 downto 0);
-- Memory Base Address

signal MPMCTrMEMRWr     : std_logic;
-- Memory Write Enable

signal MPMCTrCS2OEN     : std_logic_vector(4 downto 0);
-- Chip Select to Output Enable delay count

signal MPMCTrCS2WEN     : std_logic_vector(4 downto 0);
-- Chip Select to Write Enable delay count

signal MPMCTrCSPOL      : std_logic_vector(7 downto 0);
-- Chip Select Polarity Select

signal LatchMCADDR      : std_logic_vector(10 downto 0);
-- Latched Memory Address Bus

signal AhbRdDatab0      : std_logic_vector(7 downto 0);
-- BYTE0 of 32 bits AHB Read Data

signal AhbRdDatab1      : std_logic_vector(7 downto 0);
-- BYTE1 of 32 bits AHB Read Data

signal AhbRdDatab2      : std_logic_vector(7 downto 0);
-- BYTE2 of 32 bits AHB Read Data

signal AhbRdDatab3      : std_logic_vector(7 downto 0);
-- BYTE3 of 32 bits AHB Read Data

signal MemRdDatab0      : std_logic_vector(7 downto 0);
-- BYTE0 of 32 bits Memory Read Data

signal MemRdDatab1      : std_logic_vector(7 downto 0);
-- BYTE1 of 32 bits Memory Read Data

signal MemRdDatab2      : std_logic_vector(7 downto 0);
-- BYTE2 of 32 bits Memory Read Data

signal MemRdDatab3      : std_logic_vector(7 downto 0);
-- BYTE3 of 32 bits Memory Read Data

signal MemWrDatab0      : std_logic_vector(7 downto 0);
-- BYTE0 of 32 bits Memory Write Data

signal MemWrDatab1      : std_logic_vector(7 downto 0);
-- BYTE1 of 32 bits Memory Write Data

signal MemWrDatab2      : std_logic_vector(7 downto 0);
-- BYTE2 of 32 bits Memory Write Data

signal MemWrDatab3      : std_logic_vector(7 downto 0);
-- BYTE3 of 32 bits Memory Write Data

signal MemRdDataDW      : std_logic_vector(31 downto 0);
-- 32 Bits Memory Read Data (Concatenation of MemRdDatab0-3)

signal AhbRdDataDW      : std_logic_vector(31 downto 0);
-- 32 Bits AHB Read Data (Concatenation of AhbRdDatab0-3)

signal TrnMCBLS         : std_logic_vector(3 downto 0);
-- Byte Lane Select signal whose value depend on RBLE

signal RBLE             : std_logic;
-- Read Byte Lane Enable signal

signal nCS              : std_logic;
-- Memory Chip Select signal (Active Low)

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

MemWrDatab0      <= MPMCDATA(7 downto 0);
MemWrDatab1      <= MPMCDATA(15 downto 8);
MemWrDatab2      <= MPMCDATA(23 downto 16);
MemWrDatab3      <= MPMCDATA(31 downto 24);
MemRdDataDW      <= MemRdDatab3 & MemRdDatab2 & MemRdDatab1 & MemRdDatab0;
AhbRdDataDW      <= AhbRdDatab3 & AhbRdDatab2 & AhbRdDatab1 & AhbRdDatab0;
RBLE             <= MPMCTrMEMT(6);

-- -----------------------------------------------------------------------------
-- Write Enable selection according to the RBLE value
-- -----------------------------------------------------------------------------
p_MPMCBLSComb : process (RBLE, nMPMCBLS, nMPMCWEN)
begin
  if (RBLE = '0') then
    TrnMCBLS <= nMPMCBLS;
  else
    TrnMCBLS <= nMPMCBLS or (nMPMCWEN & nMPMCWEN & nMPMCWEN & nMPMCWEN);
  end if;
end process p_MPMCBLSComb;

-- -----------------------------------------------------------------------------
-- Instantiation of the MPMC TrickMem AHB interface
-- -----------------------------------------------------------------------------
uMpmcTrMemAhbifReg : MpmcTrMemAhbifReg
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HADDR            => HADDR,
            HTRANS           => HTRANS,
            HWRITE           => HWRITE,
            HSIZE            => HSIZE,
            HBURST           => HBURST,
            HREADYIN         => HREADYIN,
            HWDATA           => HWDATA,
            HSELMPMCTRMEM    => HSELMPMCTRMEM,
            AhbRdDataDW      => AhbRdDataDW,
            HRDATA           => HRDATA,
            HREADYOUT        => HREADYOUT,
            HRESP            => HRESP,

            MPMCTrMEMRWr     => MPMCTrMEMRWr,
            LatchHADDR       => LatchHADDR,
            MPMCTrIDCY       => MPMCTrIDCY,
            MPMCTrWaitRd     => MPMCTrWaitRd,
            MPMCTrWaitWr     => MPMCTrWaitWr,
            MPMCTrWaitPg     => MPMCTrWaitPg,
            MPMCTrMEMT       => MPMCTrMEMT,
            MPMCTrMEMB       => MPMCTrMEMB,
            MPMCTrCS2OEN     => MPMCTrCS2OEN,
            MPMCTrCS2WEN     => MPMCTrCS2WEN,
            MPMCTrCSPOL      => MPMCTrCSPOL
           );

-- -----------------------------------------------------------------------------
-- Instantiation of the MPMC TrickMem Read/Write Control Block
-- -----------------------------------------------------------------------------
uMpmcTrMemRdWrCtl : MpmcTrMemRdWrCtl
  generic map (
               Tclk             => Tclk
              )
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            MPMCADDR         => MPMCADDR,
            nMPMCDATAEN      => nMPMCDATAEN,
            MPMCTrCS         => MPMCTrCS,
            MPMCTrAllCS      => MPMCTrAllCS,
            nMPMCWEN         => nMPMCWEN,
            nMPMCBLS         => nMPMCBLS,
            nMPMCOEN         => nMPMCOEN,
            MemRdDataDW      => MemRdDataDW,
            MPMCTrIDCY       => MPMCTrIDCY,
            MPMCTrWaitRd     => MPMCTrWaitRd,
            MPMCTrWaitWr     => MPMCTrWaitWr,
            MPMCTrWaitPg     => MPMCTrWaitPg,
            MPMCTrMEMT       => MPMCTrMEMT,
            MPMCTrMEMB       => MPMCTrMEMB,
            MPMCTrCS2OEN     => MPMCTrCS2OEN,
            MPMCTrCS2WEN     => MPMCTrCS2WEN,
            MPMCTrExtWait    => MPMCTrStExtWt,
            MPMCTrCSPOL      => MPMCTrCSPOL,
            MPMCDATA         => MPMCDATA,
            LatchMCADDR      => LatchMCADDR,
            MPMCActLowCS     => nCS
           );

-- -----------------------------------------------------------------------------
-- 4 Instantiations of the Memory Element (Each of 2k depth)
-- -----------------------------------------------------------------------------
u0MpmcTrMemArray : MpmcTrMemArray
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            nCS              => nCS,
            nMPMCBLS         => TrnMCBLS(0),
            MPMCTrMEMRWr     => MPMCTrMEMRWr,
            LatchHADDR       => LatchHADDR(12 downto 2),
            LatchMCADDR      => LatchMCADDR,
            HWDATA           => HWDATA(7 downto 0),
            MemWrDatab       => MemWrDatab0,
            AhbRdDatab       => AhbRdDatab0,
            MemRdDatab       => MemRdDatab0
           );

u1MpmcTrMemArray : MpmcTrMemArray
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            nCS              => nCS,
            nMPMCBLS         => TrnMCBLS(1),
            MPMCTrMEMRWr     => MPMCTrMEMRWr,
            LatchHADDR       => LatchHADDR(12 downto 2),
            LatchMCADDR      => LatchMCADDR,
            HWDATA           => HWDATA(15 downto 8),
            MemWrDatab       => MemWrDatab1,
            AhbRdDatab       => AhbRdDatab1,
            MemRdDatab       => MemRdDatab1
           );

u2MpmcTrMemArray : MpmcTrMemArray
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            nCS              => nCS,
            nMPMCBLS         => TrnMCBLS(2),
            MPMCTrMEMRWr     => MPMCTrMEMRWr,
            LatchHADDR       => LatchHADDR(12 downto 2),
            LatchMCADDR      => LatchMCADDR,
            HWDATA           => HWDATA(23 downto 16),
            MemWrDatab       => MemWrDatab2,
            AhbRdDatab       => AhbRdDatab2,
            MemRdDatab       => MemRdDatab2
           );

u3MpmcTrMemArray : MpmcTrMemArray
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            nCS              => nCS,
            nMPMCBLS         => TrnMCBLS(3),
            MPMCTrMEMRWr     => MPMCTrMEMRWr,
            LatchHADDR       => LatchHADDR(12 downto 2),
            LatchMCADDR      => LatchMCADDR,
            HWDATA           => HWDATA(31 downto 24),
            MemWrDatab       => MemWrDatab3,
            AhbRdDatab       => AhbRdDatab3,
            MemRdDatab       => MemRdDatab3
           );

-- -----------------------------------------------------------------------------
-- Assign local copies of signals to the outputs
-- -----------------------------------------------------------------------------
MPMCActLowCS     <= nCS;

end structural;

-- --================================== End ==================================--
