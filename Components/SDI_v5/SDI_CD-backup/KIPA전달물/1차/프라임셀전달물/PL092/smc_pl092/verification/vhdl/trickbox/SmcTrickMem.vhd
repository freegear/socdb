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
-- File Name              : SmcTrickMem.vhd.rca
-- File Revision          : 1.9
--
-- Release Information    : PrimeCell(TM)-PL092-REL1v1
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This module is the top level SMC Trickbox Memory model.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SmcTrickMem is
  generic (
           Tclk             : time := 10.52 ns
                                            -- HCLK Period
          );
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB Clock
        nHCLK            : in    std_logic; -- AHB Clock (Inverted)
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
        HSELSMCTRMEM     : in    std_logic; -- AHB Peripheral (TrickMem)
                                            -- Select
        SMADDR           : in    std_logic_vector(25 downto 0);
                                            -- Memory Address Bus
        nSMDATAEN        : in    std_logic_vector(3 downto 0);
                                            -- Memory Bus Enable
        nSMWEN           : in    std_logic; -- Write Enable for the external
                                            -- Memory bank
        nSMOEN           : in    std_logic; -- Output Enable for the external
                                            -- Memory bank
        nSMBLS           : in    std_logic_vector(3 downto 0);
                                            -- Byte Enables for the external
                                            -- Memory bank
        SMCTrAllCS       : in    std_logic_vector(7 downto 0);
                                            -- The CS status of all the eight
                                            -- banks connected with the SMC
        SMCTrCS          : in    std_logic; -- Individual select line for a
                                            -- TrickMem

-- Inouts
        SMDATA           : inout std_logic_vector(31 downto 0);
                                            -- Memory Data Bus

-- Outputs
        HRDATA           : out   std_logic_vector(31 downto 0);
                                            -- AHB Read Data bus
        HREADYOUT        : out   std_logic; -- Slave HREADY output
        HRESP            : out   std_logic_vector(1 downto 0);
                                            -- Slave response

        SMCActLowCS      : out   std_logic  -- Used for suitably routing the
                                            -- SMCTrWAIT as the final SMWAIT
                                            -- at the top-level of the tbench
       );
end SmcTrickMem;

-- -----------------------------------------------------------------------------
--
--                                 SmcTrickMem
--                                 ===========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--   This block is the top level of the SMC Trickbox Memory Model. This block
-- instantiates the following sub-blocks:
--
-- 1. SmcTrMemAhbifReg - AHB Interface and Register Block
-- 2. SmcTrMemRdWrCtl  - Memory Read/Write Control and Timing checks
-- 3. SmcTrMemArray    - Memory Element
-- 4. SmcTrPackage     - Constant declaration
--
-- -----------------------------------------------------------------------------

-- --============================= ARCHITECTURE ==============================--

architecture structural of SmcTrickMem is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- AHB Interface and Register Block
-- -----------------------------------------------------------------------------
component SmcTrMemAhbifReg
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
        HSELSMCTRMEM     : in    std_logic;
        AhbRdDataDW      : in    std_logic_vector(31 downto 0);
        HRDATA           : out   std_logic_vector(31 downto 0);
        HREADYOUT        : out   std_logic;
        HRESP            : out   std_logic_vector(1 downto 0);

        SMCTrMEMRWr      : out   std_logic;
        LatchHADDR       : out   std_logic_vector(15 downto 0);
        SMCTrIDCY        : out   std_logic_vector(4 downto 0);
        SMCTrWST1        : out   std_logic_vector(5 downto 0);
        SMCTrWST2        : out   std_logic_vector(5 downto 0);
        SMCTrMEMT        : out   std_logic_vector(10 downto 0);
        SMCTrMEMB        : out   std_logic_vector(14 downto 0);
        SMCTrCS2OEN      : out   std_logic_vector(4 downto 0);
        SMCTrCS2WEN      : out   std_logic_vector(4 downto 0);
        SMCTrCSPOL       : out   std_logic_vector(7 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- Memory Read/Write Control and Timing checks Block
-- -----------------------------------------------------------------------------
component SmcTrMemRdWrCtl
  generic (
           Tclk             : time
          );
  port (
        HCLK             : in    std_logic;
        nHCLK            : in    std_logic;
        HRESETn          : in    std_logic;
        SMADDR           : in    std_logic_vector(25 downto 0);
        nSMDATAEN        : in    std_logic_vector(3 downto 0);
        SMCTrCS          : in    std_logic;
        SMCTrAllCS       : in    std_logic_vector(7 downto 0);
        nSMWEN           : in    std_logic;
        nSMBLS           : in    std_logic_vector(3 downto 0);
        nSMOEN           : in    std_logic;
        MemRdDataDW      : in    std_logic_vector(31 downto 0);
        SMCTrIDCY        : in    std_logic_vector(4 downto 0);
        SMCTrWST1        : in    std_logic_vector(5 downto 0);
        SMCTrWST2        : in    std_logic_vector(5 downto 0);
        SMCTrMEMT        : in    std_logic_vector(10 downto 0);
        SMCTrMEMB        : in    std_logic_vector(14 downto 0);
        SMCTrCS2OEN      : in    std_logic_vector(4 downto 0);
        SMCTrCS2WEN      : in    std_logic_vector(4 downto 0);
        SMCTrCSPOL       : in    std_logic_vector(7 downto 0);
        SMDATA           : inout std_logic_vector(31 downto 0);
        LatchSMADDR      : out   std_logic_vector(10 downto 0);
        SMCActLowCS      : out   std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- Memory Element
-- -----------------------------------------------------------------------------
component SmcTrMemArray
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        nCS              : in    std_logic;
        nSMBLS           : in    std_logic;
        SMCTrMEMRWr      : in    std_logic;
        LatchHADDR       : in    std_logic_vector(10 downto 0);
        LatchSMADDR      : in    std_logic_vector(10 downto 0);
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

signal SMCTrIDCY        : std_logic_vector(4 downto 0);
-- Memory data bus turn around time count

signal SMCTrWST1        : std_logic_vector(5 downto 0);
-- Initial Access time count in case of BROMs
-- Read Access time count in case of SRAMs or ROMs

signal SMCTrWST2        : std_logic_vector(5 downto 0);
-- Write access time count in case of SRAM
-- Burst access time count in case of BROMs
-- Insignificant in case of ROMs

signal SMCTrMEMT        : std_logic_vector(10 downto 0);
-- Memory type specifier

signal SMCTrMEMB        : std_logic_vector(14 downto 0);
-- Memory Base Address

signal SMCTrMEMRWr      : std_logic;
-- Memory Write Enable

signal SMCTrCS2OEN      : std_logic_vector(4 downto 0);
-- Chip Select to Output Enable delay count

signal SMCTrCS2WEN      : std_logic_vector(4 downto 0);
-- Chip Select to Write Enable delay count

signal SMCTrCSPOL       : std_logic_vector(7 downto 0);
-- Chip Select Polarity Select

signal LatchSMADDR      : std_logic_vector(10 downto 0);
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

signal TrnSMBLS         : std_logic_vector(3 downto 0);
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

MemWrDatab0      <= SMDATA(7 downto 0);
MemWrDatab1      <= SMDATA(15 downto 8);
MemWrDatab2      <= SMDATA(23 downto 16);
MemWrDatab3      <= SMDATA(31 downto 24);
MemRdDataDW      <= MemRdDatab3 & MemRdDatab2 & MemRdDatab1 & MemRdDatab0;
AhbRdDataDW      <= AhbRdDatab3 & AhbRdDatab2 & AhbRdDatab1 & AhbRdDatab0;
RBLE             <= SMCTrMEMT(6);

-- -----------------------------------------------------------------------------
-- Write Enable selection according to the RBLE value
-- -----------------------------------------------------------------------------
p_SMBLSComb : process (RBLE, nSMBLS, nSMWEN)
begin
  if (RBLE = '0') then
    TrnSMBLS <= nSMBLS;
  else
    TrnSMBLS <= nSMBLS or (nSMWEN & nSMWEN & nSMWEN & nSMWEN);
  end if;
end process p_SMBLSComb;

-- -----------------------------------------------------------------------------
-- Instantiation of the SMC TrickMem AHB interface
-- -----------------------------------------------------------------------------
uSmcTrMemAhbifReg : SmcTrMemAhbifReg
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
            HSELSMCTRMEM     => HSELSMCTRMEM,
            AhbRdDataDW      => AhbRdDataDW,
            HRDATA           => HRDATA,
            HREADYOUT        => HREADYOUT,
            HRESP            => HRESP,

            SMCTrMEMRWr      => SMCTrMEMRWr,
            LatchHADDR       => LatchHADDR,
            SMCTrIDCY        => SMCTrIDCY,
            SMCTrWST1        => SMCTrWST1,
            SMCTrWST2        => SMCTrWST2,
            SMCTrMEMT        => SMCTrMEMT,
            SMCTrMEMB        => SMCTrMEMB,
            SMCTrCS2OEN      => SMCTrCS2OEN,
            SMCTrCS2WEN      => SMCTrCS2WEN,
            SMCTrCSPOL       => SMCTrCSPOL
           );

-- -----------------------------------------------------------------------------
-- Instantiation of the SMC TrickMem Read/Write Control Block
-- -----------------------------------------------------------------------------
uSmcTrMemRdWrCtl : SmcTrMemRdWrCtl
  generic map (
               Tclk             => Tclk
              )
  port map (
            HCLK             => HCLK,
            nHCLK            => nHCLK,
            HRESETn          => HRESETn,
            SMADDR           => SMADDR,
            nSMDATAEN        => nSMDATAEN,
            SMCTrCS          => SMCTrCS,
            SMCTrAllCS       => SMCTrAllCS,
            nSMWEN           => nSMWEN,
            nSMBLS           => nSMBLS,
            nSMOEN           => nSMOEN,
            MemRdDataDW      => MemRdDataDW,
            SMCTrIDCY        => SMCTrIDCY,
            SMCTrWST1        => SMCTrWST1,
            SMCTrWST2        => SMCTrWST2,
            SMCTrMEMT        => SMCTrMEMT,
            SMCTrMEMB        => SMCTrMEMB,
            SMCTrCS2OEN      => SMCTrCS2OEN,
            SMCTrCS2WEN      => SMCTrCS2WEN,
            SMCTrCSPOL       => SMCTrCSPOL,
            SMDATA           => SMDATA,
            LatchSMADDR      => LatchSMADDR,
            SMCActLowCS      => nCS
           );

-- -----------------------------------------------------------------------------
-- 4 Instantiations of the Memory Element (Each of 2k depth)
-- -----------------------------------------------------------------------------
u0SmcTrMemArray : SmcTrMemArray
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            nCS              => nCS,
            nSMBLS           => TrnSMBLS(0),
            SMCTrMEMRWr      => SMCTrMEMRWr,
            LatchHADDR       => LatchHADDR(12 downto 2),
            LatchSMADDR      => LatchSMADDR,
            HWDATA           => HWDATA(7 downto 0),
            MemWrDatab       => MemWrDatab0,
            AhbRdDatab       => AhbRdDatab0,
            MemRdDatab       => MemRdDatab0
           );

u1SmcTrMemArray : SmcTrMemArray
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            nCS              => nCS,
            nSMBLS           => TrnSMBLS(1),
            SMCTrMEMRWr      => SMCTrMEMRWr,
            LatchHADDR       => LatchHADDR(12 downto 2),
            LatchSMADDR      => LatchSMADDR,
            HWDATA           => HWDATA(15 downto 8),
            MemWrDatab       => MemWrDatab1,
            AhbRdDatab       => AhbRdDatab1,
            MemRdDatab       => MemRdDatab1
           );

u2SmcTrMemArray : SmcTrMemArray
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            nCS              => nCS,
            nSMBLS           => TrnSMBLS(2),
            SMCTrMEMRWr      => SMCTrMEMRWr,
            LatchHADDR       => LatchHADDR(12 downto 2),
            LatchSMADDR      => LatchSMADDR,
            HWDATA           => HWDATA(23 downto 16),
            MemWrDatab       => MemWrDatab2,
            AhbRdDatab       => AhbRdDatab2,
            MemRdDatab       => MemRdDatab2
           );

u3SmcTrMemArray : SmcTrMemArray
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            nCS              => nCS,
            nSMBLS           => TrnSMBLS(3),
            SMCTrMEMRWr      => SMCTrMEMRWr,
            LatchHADDR       => LatchHADDR(12 downto 2),
            LatchSMADDR      => LatchSMADDR,
            HWDATA           => HWDATA(31 downto 24),
            MemWrDatab       => MemWrDatab3,
            AhbRdDatab       => AhbRdDatab3,
            MemRdDatab       => MemRdDatab3
           );

-- -----------------------------------------------------------------------------
-- Assign local copies of signals to the outputs
-- -----------------------------------------------------------------------------
SMCActLowCS      <= nCS;

end structural;

-- --================================== End ==================================--
