-- -----------------------------------------------------------------------------
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
-- File Name              : SsmcTrMemory.vhd.rca
-- File Revision          : 1.8
--
-- Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This module is the SSMC Trick Memory Wrapper box.this
--           instantiat the memory Read Write control and Memory array module.
--           This module is been instantiated in the top level test bench.  
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SsmcTrMemory is
 generic (
           Tclk             : time := 7.5 ns  -- HCLK Period
          );
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB Bus Clock
        HRESETn          : in    std_logic; -- Bus Reset
        HWDATA           : in    std_logic_vector(31 downto 0);
                                            -- Write data from AHB
        LatchHADDR       : in    std_logic_vector(17 downto 0);
                                            -- Latched AHB Address
        SMADDR           : in    std_logic_vector(25 downto 0);
                                            -- Address Bus to Memory
        nSMDATAEN        : in    std_logic_vector(3 downto 0);
                                            -- Memory Bus Enable
        SSMTrBankCS      : in    std_logic; -- Bank select active high
        
        nSSMTrBankCS     : in    std_logic; -- Bank select active low

        SSMTrCS          : in    std_logic_vector(7 downto 0);
                                            -- The status of all the 8 banks
                                            -- connected with the SMC
                                            -- active high chip select
        nSSMTrCS         : in    std_logic_vector(7 downto 0);
                                            -- The status of all the 8 banks
                                            -- connected with the SMC
                                            -- active low chip select
        nSMWEN           : in    std_logic; -- Write enable
        nSMBLS           : in    std_logic_vector(3 downto 0);
                                            -- Byte lane select
        nSMOEN           : in    std_logic; -- Output enable
        
        SMCLK            : in    std_logic; -- SSMC clock
                                            -- for synchronous memory operation
        SMADDRVALID      : in    std_logic; -- Address valid signal
        SSMCTrMEMARRAYWr : in    std_logic;
                                            -- Write enable to memory from 
                                            -- AHB Interface
        SSMCTrBurstWt    : in    std_logic_vector(8 downto 0);
                                            -- Burst access external delay
        SSMCTrMEMBASE    : in    std_logic_vector(14 downto 0);
                                            -- Memory base address
        SMTrBIDCYR       : in    std_logic_vector(3 downto 0);
                                            -- Memory Data Bus turn
                                            -- around time
        SMTrBWSTRDR      : in    std_logic_vector(4 downto 0);
                                            -- Initial Read acess time

        SMTrBWSTWRR      : in    std_logic_vector(4 downto 0);
                                            -- Write access time
        SMTrBWSTOENR     : in    std_logic_vector(3 downto 0);
                                            -- CS to output enable time
        SMTrBWSTWENR     : in    std_logic_vector(3 downto 0);
                                            -- CS to write enable time
        SMTrBWSTBRDR     : in    std_logic_vector(4 downto 0);
                                            -- Burst read time                                                              -- after initial access
        SMTrBCR          : in    std_logic_vector(21 downto 0);
                                            -- Bank control parameters
        SMMemClkRatio    : in    std_logic_vector(1 downto 0);
                                            -- Clock Ratio;
-- InOut
        SMDATA           :inout  std_logic_vector(31 downto 0);
                                            -- Output data
-- Outputs
        AhbRdDataDW      : out   std_logic_vector(31 downto 0);
                                            -- Read data from AHB Interface
        nSMBURSTWAIT     : out   std_logic;
                                            -- External Burst wait signal to UUT
        SMTrIND          : out   std_logic; -- Indicates Address limit

        SMFBCLK          : out   std_logic
                                            -- Feed back clock
       );
end SsmcTrMemory;


-- -------------------------------------------------------------------------------
--                             SsmcTrMemory
--                             ============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ======== 
-- This Block is top Wrapper module.This Block instantiates memory read write 
-- control sub block and memarray for each bank :
-- 
-- 1. SsmcTrMemRdWrCtl - SSMC Trick memory read write control. 
-- 2. SsmcTrMemArray   - Memory array.
-- 
-- -----------------------------------------------------------------------------

-- --============================ ARCHITECTURE ===============================--               
architecture behavioural of SsmcTrMemory is
 
-- -----------------------------------------------------------------------------
-- Component declations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- SsmcTrMemRdWrCtl
-- -----------------------------------------------------------------------------
component SsmcTrMemRdWrCtl
  generic (
           Tclk             : time
          );
  port (
-- Inputs
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        SMADDR           : in    std_logic_vector(25 downto 0);
        nSMDATAEN        : in    std_logic_vector(3 downto 0);
        SSMTrBankCS      : in    std_logic;
        nSSMTrBankCS     : in    std_logic;
        SSMTrCS          : in    std_logic_vector(7 downto 0);
        nSSMTrCS         : in    std_logic_vector(7 downto 0);
        nSMWEN           : in    std_logic;
        nSMBLS           : in    std_logic_vector(3 downto 0);
        nSMOEN           : in    std_logic;
        MemRdDataDW      : in    std_logic_vector(31 downto 0);
        SMCLK            : in    std_logic;
        SMADDRVALID      : in    std_logic;
        SSMCTrBurstWt    : in    std_logic_vector(8 downto 0);
        SSMCTrMEMBASE    : in    std_logic_vector(14 downto 0);
        SMTrBIDCYR       : in    std_logic_vector(3 downto 0);
        SMTrBWSTRDR      : in    std_logic_vector(4 downto 0);
        SMTrBWSTWRR      : in    std_logic_vector(4 downto 0);
        SMTrBWSTOENR     : in    std_logic_vector(3 downto 0);
        SMTrBWSTWENR     : in    std_logic_vector(3 downto 0);
        SMTrBWSTBRDR     : in    std_logic_vector(4 downto 0);
        SMTrBCR          : in    std_logic_vector(21 downto 0);
        SMMemClkRatio    : in    std_logic_vector(1 downto 0);
-- Inout
        SMDATA           :inout    std_logic_vector(31 downto 0);
                                           
-- Outputs
        LatchSMADDR      : out   std_logic_vector(10 downto 0);
        nSMBURSTWAIT     : out   std_logic;
        SMFBCLK          : out   std_logic;
        SMTrIND          : out   std_logic;
        TrnSMBLS         : out   std_logic_vector(3 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- SsmcTrMemArray
-- -----------------------------------------------------------------------------
component SsmcTrMemArray
  port (
-- Inputs
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        nCS              : in    std_logic;
        nSMBLS           : in    std_logic;
        SMFBCLK          : in    std_logic;
        SSMCTrMEMARRAYWr : in    std_logic;
        LatchHADDR       : in    std_logic_vector(10 downto 0);
        LatchSMADDR      : in    std_logic_vector(10 downto 0);
        HWDATA           : in    std_logic_vector(7 downto 0);
        MemWrDatab       : in    std_logic_vector(7 downto 0);

-- Outputs
        AhbRdDatab       : out   std_logic_vector(7 downto 0);
        MemRdDatab       : out   std_logic_vector(7 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- Constant declation
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal TrnSMBLS         : std_logic_vector(3 downto 0);
-- Byte Lane Select signal whose value depend on RBLE

signal RBLE             : std_logic;
-- Read Byte Lane Enable signal

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

signal LatchSMADDR      : std_logic_vector(10 downto 0);
-- Latched Memory Address Bus

signal iSMFBCLK         : std_logic;
-- internal feedback clock

signal inSMBLS          : std_logic_vector(3 downto 0);
-- Internal version of nSMBLS signal after concidering polarity
  
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
SMFBCLK          <= iSMFBCLK;

inSMBLS          <= (not(nSMBLS)) when (SMTrBCR(6) = '1')
                    else
                    (nSMBLS);

-- -----------------------------------------------------------------------------
-- component instantiations
-- -----------------------------------------------------------------------------

uSsmcTrMemRdWrCtl : SsmcTrMemRdWrCtl
  generic map (
               Tclk             => Tclk
              )
  port map (
-- Inputs
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            SMADDR           => SMADDR,
            nSMDATAEN        => nSMDATAEN,
            SSMTrBankCS      => SSMTrBankCS,
            nSSMTrBankCS     => nSSMTrBankCS,
            SSMTrCS          => SSMTrCS,
            nSSMTrCS         => nSSMTrCS,
            nSMWEN           => nSMWEN,
--            nSMBLS           => nSMBLS,
            nSMBLS           => inSMBLS,
            nSMOEN           => nSMOEN,
            MemRdDataDW      => MemRdDataDW,
            SMCLK            => SMCLK,
            SMADDRVALID      => SMADDRVALID,
            SSMCTrBurstWt    => SSMCTrBurstWt,
            SSMCTrMEMBASE    => SSMCTrMEMBASE,
            SMTrBIDCYR       => SMTrBIDCYR,
            SMTrBWSTRDR      => SMTrBWSTRDR,
            SMTrBWSTWRR      => SMTrBWSTWRR,
            SMTrBWSTOENR     => SMTrBWSTOENR,
            SMTrBWSTWENR     => SMTrBWSTWENR,
            SMTrBWSTBRDR     => SMTrBWSTBRDR,
            SMTrBCR          => SMTrBCR,
            SMMemClkRatio    => SMMemClkRatio,                                
-- InOut
            SMDATA           => SMDATA,
                                           
-- Outputs
            LatchSMADDR      => LatchSMADDR,
            nSMBURSTWAIT     => nSMBURSTWAIT,
            SMFBCLK          => iSMFBCLK,
            SMTrIND          => SMTrIND,
            TrnSMBLS         => TrnSMBLS
           );

-- -----------------------------------------------------------------------------
-- 4 Memory array instantiation
-- -----------------------------------------------------------------------------

u0SsmcTrMemArray : SsmcTrMemArray
  port map (
-- Inputs
        HCLK             => HCLK,
        HRESETn          => HRESETn,
        nCS              => nSSMTrBankCS,
        nSMBLS           => TrnSMBLS(0),
        SMFBCLK          => iSMFBCLK,
        SSMCTrMEMARRAYWr => SSMCTrMEMARRAYWr,
        LatchHADDR       => LatchHADDR(12 downto 2),
      --  LatchHADDR       => LatchHADDR(10 downto 0),
        LatchSMADDR      => LatchSMADDR,
        HWDATA           => HWDATA(7 downto 0),
        MemWrDatab       => MemWrDatab0,

-- Outputs
        AhbRdDatab       => AhbRdDatab0,
        MemRdDatab       => MemRdDatab0
       );

u1SsmcTrMemArray : SsmcTrMemArray
  port map (
-- Inputs
        HCLK             => HCLK,
        HRESETn          => HRESETn,
        nCS              => nSSMTrBankCS,
        nSMBLS           => TrnSMBLS(1),
        SMFBCLK          => iSMFBCLK,
        SSMCTrMEMARRAYWr => SSMCTrMEMARRAYWr,
        LatchHADDR       => LatchHADDR(12 downto 2),
--        LatchHADDR       => LatchHADDR(10 downto 0),
        LatchSMADDR      => LatchSMADDR,
        HWDATA           => HWDATA(15 downto 8),
        MemWrDatab       => MemWrDatab1,

-- Outputs
        AhbRdDatab       => AhbRdDatab1,
        MemRdDatab       => MemRdDatab1
       );

u2SsmcTrMemArray : SsmcTrMemArray
  port map (
-- Inputs
        HCLK             => HCLK,
        HRESETn          => HRESETn,
        nCS              => nSSMTrBankCS,
        nSMBLS           => TrnSMBLS(2),
        SMFBCLK          => iSMFBCLK,
        SSMCTrMEMARRAYWr => SSMCTrMEMARRAYWr,
        LatchHADDR       => LatchHADDR(12 downto 2),
    --    LatchHADDR       => LatchHADDR(10 downto 0),
        LatchSMADDR      => LatchSMADDR,
        HWDATA           => HWDATA(23 downto 16),
        MemWrDatab       => MemWrDatab2,

-- Outputs
        AhbRdDatab       => AhbRdDatab2,
        MemRdDatab       => MemRdDatab2
       );

u3SsmcTrMemArray : SsmcTrMemArray
  port map (
-- Inputs
        HCLK             => HCLK,
        HRESETn          => HRESETn,
        nCS              => nSSMTrBankCS,
        nSMBLS           => TrnSMBLS(3),
        SMFBCLK          => iSMFBCLK,
        SSMCTrMEMARRAYWr => SSMCTrMEMARRAYWr,
        LatchHADDR       => LatchHADDR(12 downto 2),
  --      LatchHADDR       => LatchHADDR(10 downto 0),
        LatchSMADDR      => LatchSMADDR,
        HWDATA           => HWDATA(31 downto 24),
        MemWrDatab       => MemWrDatab3,

-- Outputs
        AhbRdDatab       => AhbRdDatab3,
        MemRdDatab       => MemRdDatab3
       );

end behavioural;

-- --================================= End ===================================--               
