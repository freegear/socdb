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
-- File Name              : SsmcTrickMem.vhd.rca
-- File Revision          : 1.8
--
-- Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This module is the top level SSMC Trickbox Memory model.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------
entity SsmcTrickMem is
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
        HCLK             : in    std_logic; -- AHB Clock
        HRESETn          : in    std_logic; -- Bus Reset
        HADDR            : in    std_logic_vector(17 downto 0);
                                            -- AHB Address Bus
        HTRANS           : in    std_logic_vector(1 downto 0);
                                            -- Transfer type
        HWRITETr         : in    std_logic; -- AHB Peripheral Write
        HWRITEREG        : in    std_logic; -- AHB Mirror register Write
        HSIZE            : in    std_logic_vector(2 downto 0);
                                            -- Transfer size
        HBURST           : in    std_logic_vector(2 downto 0);
                                            -- Burst Type
        HREADYINTr       : in    std_logic; -- Multiplexed version of
                                            -- HREADY outputs
        HREADYINREG      : in    std_logic; -- Multiplexed version of
                                            -- HREADY for mirror registers
        HWDATA           : in    std_logic_vector(31 downto 0);
                                            -- AHB Write Data bus
        HWDATAREG        : in    std_logic_vector(31 downto 0);
                                            -- Mirrored Register Write Data bus
        HSELSSMCTrMEM    : in    std_logic; -- AHB Peripheral (TrickMem)
                                            -- Select
        HSELSSMCTrREG    : in    std_logic; -- AHB Peripheral (Mirror Register)
                                            -- Select
        SMCLK            : in    std_logic; -- Clock from SSMS  for synchronous
                                            -- memory accesses
        SMADDRVALID      : in    std_logic; -- Address valid signal
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
        nSSMTrCS         : in    std_logic_vector(7 downto 0);
                                            -- The nCS status of all the eight
                                            -- banks connected with the SSMC
        SSMTrCS          : in    std_logic_vector(7 downto 0);
                                            -- The CS status of all the eight
                                            -- banks connected with the SSMC
        SMMemClkRatio    : in    std_logic_vector(1 downto 0);
                                            -- Clock Ratio;
-- Inout
 
        SMDATA           : inout   std_logic_vector(31 downto 0);
                                            -- Inputout memory data Bus

-- Outputs
        HRDATATr         : out   std_logic_vector(31 downto 0);
                                            -- AHB Read Data bus
        HREADYOUTTr      : out   std_logic; -- Slave HREADY output
        HRESPTr          : out   std_logic_vector(1 downto 0);
                                            -- Slave response
        nSMBURSTWAIT     : out   std_logic_vector(7 downto 0);
                                            -- External Burstwait
        nSMIND           : out   std_logic  -- Address limit indicator
       );
end SsmcTrickMem;

-- -----------------------------------------------------------------------------
--
--                                 SsmcTrickMem
--                                 ============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--   This block is the top level of the SSMC Trickbox Memory Model. This block
-- instantiates the following sub-blocks:
--
-- 1. SsmcTrMemAhbIfReg - AHB Interface and Register Block
-- 2. SsmcTrMemory      - Memory Wrapper module
-- 3. SsmcTrPackage     - Constant declaration
--
-- -----------------------------------------------------------------------------

-- --============================= ARCHITECTURE ==============================--

architecture structural of SsmcTrickMem is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- AHB Interface and Register block
-- -----------------------------------------------------------------------------
component  SsmcTrMemAhbIfReg
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HADDR            : in    std_logic_vector(17 downto 0);
        HTRANS           : in    std_logic_vector(1 downto 0);
        HWRITETr         : in    std_logic;
        HWRITEREG        : in    std_logic;
        HSIZE            : in    std_logic_vector(2 downto 0);
        HBURST           : in    std_logic_vector(2 downto 0);
        HREADYINTr       : in    std_logic;
        HWDATA           : in    std_logic_vector(31 downto 0);
        HREADYINREG      : in    std_logic;
        HWDATAREG        : in    std_logic_vector(31 downto 0);
        HSELSSMCTrMEM    : in    std_logic;
        HSELSSMCTrREG    : in    std_logic;
        AhbRdDataDW0     : in    std_logic_vector(31 downto 0);
        AhbRdDataDW1     : in    std_logic_vector(31 downto 0);
        AhbRdDataDW2     : in    std_logic_vector(31 downto 0);
        AhbRdDataDW3     : in    std_logic_vector(31 downto 0);
        AhbRdDataDW4     : in    std_logic_vector(31 downto 0);
        AhbRdDataDW5     : in    std_logic_vector(31 downto 0);
        AhbRdDataDW6     : in    std_logic_vector(31 downto 0);
        AhbRdDataDW7     : in    std_logic_vector(31 downto 0);
        HRDATATr         : out   std_logic_vector(31 downto 0);
        HREADYOUTTr      : out   std_logic;
        HRESPTr          : out   std_logic_vector(1 downto 0);

        SSMCTrMEMARRAY0Wr : out   std_logic;
        SSMCTrMEMARRAY1Wr : out   std_logic;
        SSMCTrMEMARRAY2Wr : out   std_logic;
        SSMCTrMEMARRAY3Wr : out   std_logic;
        SSMCTrMEMARRAY4Wr : out   std_logic;
        SSMCTrMEMARRAY5Wr : out   std_logic;
        SSMCTrMEMARRAY6Wr : out   std_logic;
        SSMCTrMEMARRAY7Wr : out   std_logic;

        LatchHADDR       : out   std_logic_vector(17 downto 0);
        SSMCTrBurstWT    : out   std_logic_vector(8  downto 0);
        SSMCTrMEMBASE0   : out   std_logic_vector(14 downto 0);
        SSMCTrMEMBASE1   : out   std_logic_vector(14 downto 0);
        SSMCTrMEMBASE2   : out   std_logic_vector(14 downto 0);
        SSMCTrMEMBASE3   : out   std_logic_vector(14 downto 0);
        SSMCTrMEMBASE4   : out   std_logic_vector(14 downto 0);
        SSMCTrMEMBASE5   : out   std_logic_vector(14 downto 0);
        SSMCTrMEMBASE6   : out   std_logic_vector(14 downto 0);
        SSMCTrMEMBASE7   : out   std_logic_vector(14 downto 0);

        SMTrBIDCYR0      : out   std_logic_vector(3 downto 0);
        SMTrBIDCYR1      : out   std_logic_vector(3 downto 0);
        SMTrBIDCYR2      : out   std_logic_vector(3 downto 0);
        SMTrBIDCYR3      : out   std_logic_vector(3 downto 0);
        SMTrBIDCYR4      : out   std_logic_vector(3 downto 0);
        SMTrBIDCYR5      : out   std_logic_vector(3 downto 0);
        SMTrBIDCYR6      : out   std_logic_vector(3 downto 0);
        SMTrBIDCYR7      : out   std_logic_vector(3 downto 0);

        SMTrBWSTRDR0     : out   std_logic_vector(4 downto 0);
        SMTrBWSTRDR1     : out   std_logic_vector(4 downto 0);
        SMTrBWSTRDR2     : out   std_logic_vector(4 downto 0);
        SMTrBWSTRDR3     : out   std_logic_vector(4 downto 0);
        SMTrBWSTRDR4     : out   std_logic_vector(4 downto 0);
        SMTrBWSTRDR5     : out   std_logic_vector(4 downto 0);
        SMTrBWSTRDR6     : out   std_logic_vector(4 downto 0);
        SMTrBWSTRDR7     : out   std_logic_vector(4 downto 0);

        SMTrBWSTWRR0     : out   std_logic_vector(4 downto 0);
        SMTrBWSTWRR1     : out   std_logic_vector(4 downto 0);
        SMTrBWSTWRR2     : out   std_logic_vector(4 downto 0);
        SMTrBWSTWRR3     : out   std_logic_vector(4 downto 0);
        SMTrBWSTWRR4     : out   std_logic_vector(4 downto 0);
        SMTrBWSTWRR5     : out   std_logic_vector(4 downto 0);
        SMTrBWSTWRR6     : out   std_logic_vector(4 downto 0);

        SMTrBWSTWRR7     : out   std_logic_vector(4 downto 0);
        SMTrBWSTOENR0    : out   std_logic_vector(3 downto 0);
        SMTrBWSTOENR1    : out   std_logic_vector(3 downto 0);
        SMTrBWSTOENR2    : out   std_logic_vector(3 downto 0);
        SMTrBWSTOENR3    : out   std_logic_vector(3 downto 0);
        SMTrBWSTOENR4    : out   std_logic_vector(3 downto 0);
        SMTrBWSTOENR5    : out   std_logic_vector(3 downto 0);
        SMTrBWSTOENR6    : out   std_logic_vector(3 downto 0);
        SMTrBWSTOENR7    : out   std_logic_vector(3 downto 0);

        SMTrBWSTWENR0    : out   std_logic_vector(3 downto 0);
        SMTrBWSTWENR1    : out   std_logic_vector(3 downto 0);
        SMTrBWSTWENR2    : out   std_logic_vector(3 downto 0);
        SMTrBWSTWENR3    : out   std_logic_vector(3 downto 0);
        SMTrBWSTWENR4    : out   std_logic_vector(3 downto 0);
        SMTrBWSTWENR5    : out   std_logic_vector(3 downto 0);
        SMTrBWSTWENR6    : out   std_logic_vector(3 downto 0);
        SMTrBWSTWENR7    : out   std_logic_vector(3 downto 0);

        SMTrBWSTBRDR0    : out   std_logic_vector(4 downto 0);
        SMTrBWSTBRDR1    : out   std_logic_vector(4 downto 0);
        SMTrBWSTBRDR2    : out   std_logic_vector(4 downto 0);
        SMTrBWSTBRDR3    : out   std_logic_vector(4 downto 0);
        SMTrBWSTBRDR4    : out   std_logic_vector(4 downto 0);
        SMTrBWSTBRDR5    : out   std_logic_vector(4 downto 0);
        SMTrBWSTBRDR6    : out   std_logic_vector(4 downto 0);
        SMTrBWSTBRDR7    : out   std_logic_vector(4 downto 0);

        SMTrBCR0         : out   std_logic_vector(21 downto 0);
        SMTrBCR1         : out   std_logic_vector(21 downto 0);
        SMTrBCR2         : out   std_logic_vector(21 downto 0);
        SMTrBCR3         : out   std_logic_vector(21 downto 0);
        SMTrBCR4         : out   std_logic_vector(21 downto 0);
        SMTrBCR5         : out   std_logic_vector(21 downto 0);
        SMTrBCR6         : out   std_logic_vector(21 downto 0);
        SMTrBCR7         : out   std_logic_vector(21 downto 0)

       );
end component;

-- -----------------------------------------------------------------------------
-- Memory Read/Write Control and Timing checks Block
-- -----------------------------------------------------------------------------
component SsmcTrMemory
  generic (
           Tclk             : time
          );
  port (
-- Inputs
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HWDATA           : in    std_logic_vector(31 downto 0);
        LatchHADDR       : in    std_logic_vector(17 downto 0);
        SMADDR           : in    std_logic_vector(25 downto 0);
        nSMDATAEN        : in    std_logic_vector(3 downto 0);
        SSMTrBankCS      : in    std_logic;
        nSSMTrBankCS     : in    std_logic;
        SSMTrCS          : in    std_logic_vector(7 downto 0);
        nSSMTrCS         : in    std_logic_vector(7 downto 0);
        nSMWEN           : in    std_logic;
        nSMBLS           : in    std_logic_vector(3 downto 0);
        nSMOEN           : in    std_logic;
        SMCLK            : in    std_logic;
        SMADDRVALID      : in    std_logic;
        SSMCTrMEMARRAYWr : in    std_logic;
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
-- InOut
        SMDATA           :inout  std_logic_vector(31 downto 0);
-- Outputs
        AhbRdDataDW      : out   std_logic_vector(31 downto 0);
        nSMBURSTWAIT     : out   std_logic;
        SMTrIND          : out   std_logic; 
        SMFBCLK          : out   std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal SMFBCLK            : std_logic; 
-- Feedback clock

signal iSMMemCLK          : std_logic;
-- Memory Clock

signal inSSMTrCS          : std_logic_vector(7 downto 0);
-- Internal version of nSSMTrCS lines

signal iSSMTrCS           : std_logic_vector(7 downto 0);
-- Internal version of SSMTrCS lines

signal LatchHADDR         : std_logic_vector(17 downto 0);
-- Latched AHB Address. This is used when the memory is accessed via AHB

signal SSMCTrMEMARRAY0Wr  : std_logic;
-- Memory Write Enable

signal SSMCTrMEMARRAY1Wr  : std_logic;
-- Memory Write Enable

signal SSMCTrMEMARRAY2Wr  : std_logic;
-- Memory Write Enable

signal SSMCTrMEMARRAY3Wr  : std_logic;
-- Memory Write Enable

signal SSMCTrMEMARRAY4Wr  : std_logic;
-- Memory Write Enable

signal SSMCTrMEMARRAY5Wr  : std_logic;
-- Memory Write Enable

signal SSMCTrMEMARRAY6Wr  : std_logic;
-- Memory Write Enable

signal SSMCTrMEMARRAY7Wr  : std_logic;
-- Memory Write Enable

signal SSMCTrBurstWt      :   std_logic_vector(8  downto 0); 
-- External Burst wait time

signal SMTrBIDCYR0        : std_logic_vector(3 downto 0);
-- Memory data bus turn around time count for bank 0

signal SMTrBIDCYR1        : std_logic_vector(3 downto 0);
--  Memory data bus turn around time count for bank 1

signal SMTrBIDCYR2        : std_logic_vector(3 downto 0);
--  Memory data bus turn around time count for bank 2

signal SMTrBIDCYR3        : std_logic_vector(3 downto 0);
--   Memory data bus turn around time count for bank 3

signal SMTrBIDCYR4        : std_logic_vector(3 downto 0);
--  Memory data bus turn around time count for bank 4

signal SMTrBIDCYR5        : std_logic_vector(3 downto 0);
--  Memory data bus turn around time count for bank 5

signal SMTrBIDCYR6        : std_logic_vector(3 downto 0);
--  Memory data bus turn around time count for bank 6

signal SMTrBIDCYR7        : std_logic_vector(3 downto 0);
--  Memory data bus turn around time count for bank 7

signal SMTrBWSTRDR0       : std_logic_vector(4 downto 0);
-- Read initial access time for bank 0

signal SMTrBWSTRDR1       : std_logic_vector(4 downto 0);
--  Read initial access time for bank 1

signal SMTrBWSTRDR2       : std_logic_vector(4 downto 0);
--  Read initial access time for bank 2

signal SMTrBWSTRDR3       : std_logic_vector(4 downto 0);
--  Read initial access time for bank 3

signal SMTrBWSTRDR4       : std_logic_vector(4 downto 0);
--   Read initial access time for bank 4

signal SMTrBWSTRDR5       : std_logic_vector(4 downto 0);
--   Read initial access time for bank 5

signal SMTrBWSTRDR6       : std_logic_vector(4 downto 0);
--  Read initial access time for bank 6

signal SMTrBWSTRDR7       : std_logic_vector(4 downto 0);
--  Read initial access time for bank 7 

signal SMTrBWSTWRR0       : std_logic_vector(4 downto 0);
--  Write eccess time for bank 0

signal SMTrBWSTWRR1       : std_logic_vector(4 downto 0);
--  Write eccess time for bank 1

signal SMTrBWSTWRR2       : std_logic_vector(4 downto 0);
-- Write eccess time for bank 2

signal SMTrBWSTWRR3       : std_logic_vector(4 downto 0);
-- Write eccess time for bank 3

signal SMTrBWSTWRR4       : std_logic_vector(4 downto 0);
-- Write eccess time for bank 4

signal SMTrBWSTWRR5       : std_logic_vector(4 downto 0);
-- Write eccess time for bank 5

signal SMTrBWSTWRR6       : std_logic_vector(4 downto 0);
-- Write eccess time for bank 6

signal SMTrBWSTWRR7       : std_logic_vector(4 downto 0);
-- Write eccess time for bank 7

signal SMTrBWSTOENR0      : std_logic_vector(3 downto 0);
--  Chip Select to Output Enable delay count for bank 0

signal SMTrBWSTOENR1      : std_logic_vector(3 downto 0);
-- Chip Select to Output Enable delay count for bank 1

signal SMTrBWSTOENR2      : std_logic_vector(3 downto 0);
-- Chip Select to Output Enable delay count for bank 2

signal SMTrBWSTOENR3      : std_logic_vector(3 downto 0);
-- Chip Select to Output Enable delay count for bank 3

signal SMTrBWSTOENR4      : std_logic_vector(3 downto 0);
-- Chip Select to Output Enable delay count for bank 4

signal SMTrBWSTOENR5      : std_logic_vector(3 downto 0);
-- Chip Select to Output Enable delay count for bank 5

signal SMTrBWSTOENR6      : std_logic_vector(3 downto 0);
-- Chip Select to Output Enable delay count for bank 6

signal SMTrBWSTOENR7      : std_logic_vector(3 downto 0);
-- Chip Select to Output Enable delay count for bank 7

signal SMTrBWSTWENR0      : std_logic_vector(3 downto 0);
-- Chip Select to Write Enable delay count for bank 0

signal SMTrBWSTWENR1      : std_logic_vector(3 downto 0);
-- Chip Select to Write Enable delay count for bank 1

signal SMTrBWSTWENR2      : std_logic_vector(3 downto 0);
-- Chip Select to Write Enable delay count for bank 2

signal SMTrBWSTWENR3      : std_logic_vector(3 downto 0);
-- Chip Select to Write Enable delay count for bank 3

signal SMTrBWSTWENR4      : std_logic_vector(3 downto 0);
-- Chip Select to Write Enable delay count for bank 4

signal SMTrBWSTWENR5      : std_logic_vector(3 downto 0);
-- Chip Select to Write Enable delay count for bank 5

signal SMTrBWSTWENR6      : std_logic_vector(3 downto 0);
-- Chip Select to Write Enable delay count for bank 6

signal SMTrBWSTWENR7      : std_logic_vector(3 downto 0);
-- Chip Select to Write Enable delay count for bank 7

signal SMTrBWSTBRDR0      : std_logic_vector(4 downto 0);
-- Burst Access time after first access for bank 0 

signal SMTrBWSTBRDR1      : std_logic_vector(4 downto 0);
-- Burst Access time after first access for bank 1

signal SMTrBWSTBRDR2      : std_logic_vector(4 downto 0);
-- Burst Access time after first access for bank 2

signal SMTrBWSTBRDR3      : std_logic_vector(4 downto 0);
-- Burst Access time after first access for bank 3

signal SMTrBWSTBRDR4      : std_logic_vector(4 downto 0);
-- Burst Access time after first access for bank 4

signal SMTrBWSTBRDR5      : std_logic_vector(4 downto 0);
-- Burst Access time after first access for bank 5

signal SMTrBWSTBRDR6      : std_logic_vector(4 downto 0);
-- Burst Access time after first access for bank 6

signal SMTrBWSTBRDR7      : std_logic_vector(4 downto 0);
-- Burst Access time after first access for bank 7

signal SMTrBCR0           : std_logic_vector(21 downto 0);
-- Memory type specifier for bank 0

signal SMTrBCR1           : std_logic_vector(21 downto 0);
-- Memory type specifier for bank 1

signal SMTrBCR2           : std_logic_vector(21 downto 0);
-- Memory type specifier for bank 2

signal SMTrBCR3           : std_logic_vector(21 downto 0);
-- Memory type specifier for bank 3

signal SMTrBCR4           : std_logic_vector(21 downto 0);
-- Memory type specifier for bank 4

signal SMTrBCR5           : std_logic_vector(21 downto 0);
-- Memory type specifier for bank 5

signal SMTrBCR6           : std_logic_vector(21 downto 0);
-- Memory type specifier for bank 6

signal SMTrBCR7           : std_logic_vector(21 downto 0);
-- Memory type specifier for bank 7

signal SSMCTrMEMBASE0     : std_logic_vector(14 downto 0);
-- Memory Base Address for bank 0

signal SSMCTrMEMBASE1     : std_logic_vector(14 downto 0);
-- Memory Base Address for bank 1

signal SSMCTrMEMBASE2     : std_logic_vector(14 downto 0);
-- Memory Base Address for bank 2

signal SSMCTrMEMBASE3     : std_logic_vector(14 downto 0);
-- Memory Base Address for bank 3

signal SSMCTrMEMBASE4     : std_logic_vector(14 downto 0);
-- Memory Base Address for bank 4

signal SSMCTrMEMBASE5     : std_logic_vector(14 downto 0);
-- Memory Base Address for bank 5

signal SSMCTrMEMBASE6     : std_logic_vector(14 downto 0);
-- Memory Base Address for bank 6

signal SSMCTrMEMBASE7     : std_logic_vector(14 downto 0);
-- Memory Base Address for bank 7

--signal SSMCTrBurstWT    : std_logic_vector(8 downto 0);
-- Assertion time for nBURSTWAIT signal

signal LatchSMADDR        : std_logic_vector(10 downto 0);
-- Latched Memory Address Bus

signal AhbRdDatab0        : std_logic_vector(7 downto 0);
-- BYTE0 of 32 bits AHB Read Data

signal AhbRdDatab1        : std_logic_vector(7 downto 0);
-- BYTE1 of 32 bits AHB Read Data

signal AhbRdDatab2        : std_logic_vector(7 downto 0);
-- BYTE2 of 32 bits AHB Read Data

signal AhbRdDatab3        : std_logic_vector(7 downto 0);
-- BYTE3 of 32 bits AHB Read Data

signal MemRdDatab0        : std_logic_vector(7 downto 0);
-- BYTE0 of 32 bits Memory Read Data

signal MemRdDatab1        : std_logic_vector(7 downto 0);
-- BYTE1 of 32 bits Memory Read Data

signal MemRdDatab2        : std_logic_vector(7 downto 0);
-- BYTE2 of 32 bits Memory Read Data

signal MemRdDatab3        : std_logic_vector(7 downto 0);
-- BYTE3 of 32 bits Memory Read Data

signal MemWrDatab0        : std_logic_vector(7 downto 0);
-- BYTE0 of 32 bits Memory Write Data

signal MemWrDatab1        : std_logic_vector(7 downto 0);
-- BYTE1 of 32 bits Memory Write Data

signal MemWrDatab2        : std_logic_vector(7 downto 0);
-- BYTE2 of 32 bits Memory Write Data

signal MemWrDatab3        : std_logic_vector(7 downto 0);
-- BYTE3 of 32 bits Memory Write Data

signal MemRdDataDW        : std_logic_vector(31 downto 0);
-- 32 Bits Memory Read Data (Concatenation of MemRdDatab0-3)

signal AhbRdDataDW0       : std_logic_vector(31 downto 0);
-- 32 Bits AHB Read Data (Concatenation of AhbRdDatab0-3)

signal AhbRdDataDW1       : std_logic_vector(31 downto 0);
-- 32 Bits AHB Read Data (Concatenation of AhbRdDatab0-3)

signal AhbRdDataDW2       : std_logic_vector(31 downto 0);
-- 32 Bits AHB Read Data (Concatenation of AhbRdDatab0-3)

signal AhbRdDataDW3       : std_logic_vector(31 downto 0);
-- 32 Bits AHB Read Data (Concatenation of AhbRdDatab0-3)

signal AhbRdDataDW4       : std_logic_vector(31 downto 0);
-- 32 Bits AHB Read Data (Concatenation of AhbRdDatab0-3)

signal AhbRdDataDW5       : std_logic_vector(31 downto 0);
-- 32 Bits AHB Read Data (Concatenation of AhbRdDatab0-3)

signal AhbRdDataDW6       : std_logic_vector(31 downto 0);
-- 32 Bits AHB Read Data (Concatenation of AhbRdDatab0-3)

signal AhbRdDataDW7       : std_logic_vector(31 downto 0);
-- 32 Bits AHB Read Data (Concatenation of AhbRdDatab0-3)

-- signal TrnSMBLS        : std_logic_vector(3 downto 0);
-- Byte Lane Select signal whose value depend on RBLE

signal RBLE               : std_logic;
-- Read Byte Lane Enable signal

--signal nSMBURSTWAIT0      : std_logic;
-- burst wait signal from memory 0

--signal nSMBURSTWAIT1      : std_logic;
-- burst wait signal from memory 1

--signal nSMBURSTWAIT2      : std_logic;
-- burst wait signal from memory 2

--signal nSMBURSTWAIT3      : std_logic;
-- burst wait signal from memory 3

--signal nSMBURSTWAIT4      : std_logic;
-- burst wait signal from memory 4

--signal nSMBURSTWAIT5      : std_logic;
-- burst wait signal from memory 5

--signal nSMBURSTWAIT6      : std_logic;
-- burst wait signal from memory 6

--signal nSMBURSTWAIT7      : std_logic;
-- burst wait signal from memory 7

signal SMTrIND0           : std_logic;
-- Address limit indicator for bank 0

signal SMTrIND1           : std_logic;
-- Address limit indicator for bank 1

signal SMTrIND2           : std_logic;
-- Address limit indicator for bank 2

signal SMTrIND3           : std_logic;
-- Address limit indicator for bank 3

signal SMTrIND4           : std_logic;
-- Address limit indicator for bank 4

signal SMTrIND5           : std_logic;
-- Address limit indicator for bank 5

signal SMTrIND6           : std_logic;
-- Address limit indicator for bank 6

signal SMTrIND7           : std_logic;
-- Address limit indicator for bank 7

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

--nSMBURSTWAIT     <= nSMBURSTWAIT0 and nSMBURSTWAIT1 and nSMBURSTWAIT2 and
--                    nSMBURSTWAIT3 and nSMBURSTWAIT4 and nSMBURSTWAIT5 and
--                    nSMBURSTWAIT6 and nSMBURSTWAIT7;

nSMIND           <= SMTrIND0 and SMTrIND1 and SMTrIND2 and SMTrIND3 and 
                    SMTrIND4 and SMTrIND5 and SMTrIND6 and SMTrIND7;

inSSMTrCS        <= nSSMTrCS after 1 ps;
iSSMTrCS         <= SSMTrCS after 1 ps;

-- -----------------------------------------------------------------------------
-- Instantiation of the SMC TrickMem AHB interface
-- -----------------------------------------------------------------------------
uSsmcTrMemAhbIfReg : SsmcTrMemAhbIfReg
  port map(
        HCLK             => HCLK, 
        HRESETn          => HRESETn,
        HADDR            => HADDR,
        HTRANS           => HTRANS, 
        HWRITETr         => HWRITETr,        
        HWRITEREG        => HWRITEREG,
        HSIZE            => HSIZE,
        HBURST           => HBURST,
        HREADYINTr       => HREADYINTr,
        HWDATA           => HWDATA,
        HREADYINREG      => HREADYINREG,
        HWDATAREG        => HWDATAREG,
        HSELSSMCTrMEM    => HSELSSMCTrMEM,
        HSELSSMCTrREG    => HSELSSMCTrREG,
        AhbRdDataDW0     => AhbRdDataDW0,
        AhbRdDataDW1     => AhbRdDataDW1,
        AhbRdDataDW2     => AhbRdDataDW2,
        AhbRdDataDW3     => AhbRdDataDW3,
        AhbRdDataDW4     => AhbRdDataDW4,
        AhbRdDataDW5     => AhbRdDataDW5,
        AhbRdDataDW6     => AhbRdDataDW6,
        AhbRdDataDW7     => AhbRdDataDW7,
        HRDATATr         => HRDATATr,
        HREADYOUTTr      => HREADYOUTTr,
        HRESPTr          => HRESPTr,

        SSMCTrMEMARRAY0Wr => SSMCTrMEMARRAY0Wr,
        SSMCTrMEMARRAY1Wr => SSMCTrMEMARRAY1Wr,
        SSMCTrMEMARRAY2Wr => SSMCTrMEMARRAY2Wr,
        SSMCTrMEMARRAY3Wr => SSMCTrMEMARRAY3Wr,
        SSMCTrMEMARRAY4Wr => SSMCTrMEMARRAY4Wr,
        SSMCTrMEMARRAY5Wr => SSMCTrMEMARRAY5Wr,
        SSMCTrMEMARRAY6Wr => SSMCTrMEMARRAY6Wr,
        SSMCTrMEMARRAY7Wr => SSMCTrMEMARRAY7Wr,

        LatchHADDR       => LatchHADDR,
        SSMCTrBurstWT    => SSMCTrBurstWt,

        SSMCTrMEMBASE0   => SSMCTrMEMBASE0,
        SSMCTrMEMBASE1   => SSMCTrMEMBASE1,
        SSMCTrMEMBASE2   => SSMCTrMEMBASE2,
        SSMCTrMEMBASE3   => SSMCTrMEMBASE3,
        SSMCTrMEMBASE4   => SSMCTrMEMBASE4,
        SSMCTrMEMBASE5   => SSMCTrMEMBASE5,
        SSMCTrMEMBASE6   => SSMCTrMEMBASE6,
        SSMCTrMEMBASE7   => SSMCTrMEMBASE7,

        SMTrBIDCYR0      => SMTrBIDCYR0,
        SMTrBIDCYR1      => SMTrBIDCYR1,
        SMTrBIDCYR2      => SMTrBIDCYR2,
        SMTrBIDCYR3      => SMTrBIDCYR3,
        SMTrBIDCYR4      => SMTrBIDCYR4,
        SMTrBIDCYR5      => SMTrBIDCYR5,
        SMTrBIDCYR6      => SMTrBIDCYR6,
        SMTrBIDCYR7      => SMTrBIDCYR7,

        SMTrBWSTRDR0     => SMTrBWSTRDR0,
        SMTrBWSTRDR1     => SMTrBWSTRDR1,
        SMTrBWSTRDR2     => SMTrBWSTRDR2,
        SMTrBWSTRDR3     => SMTrBWSTRDR3,
        SMTrBWSTRDR4     => SMTrBWSTRDR4,
        SMTrBWSTRDR5     => SMTrBWSTRDR5,
        SMTrBWSTRDR6     => SMTrBWSTRDR6,
        SMTrBWSTRDR7     => SMTrBWSTRDR7,

        SMTrBWSTWRR0     => SMTrBWSTWRR0,
        SMTrBWSTWRR1     => SMTrBWSTWRR1,
        SMTrBWSTWRR2     => SMTrBWSTWRR2,
        SMTrBWSTWRR3     => SMTrBWSTWRR3,
        SMTrBWSTWRR4     => SMTrBWSTWRR4,
        SMTrBWSTWRR5     => SMTrBWSTWRR5,
        SMTrBWSTWRR6     => SMTrBWSTWRR6,
        SMTrBWSTWRR7     => SMTrBWSTWRR7,

        SMTrBWSTOENR0    => SMTrBWSTOENR0,
        SMTrBWSTOENR1    => SMTrBWSTOENR1,
        SMTrBWSTOENR2    => SMTrBWSTOENR2,
        SMTrBWSTOENR3    => SMTrBWSTOENR3,
        SMTrBWSTOENR4    => SMTrBWSTOENR4,
        SMTrBWSTOENR5    => SMTrBWSTOENR5,
        SMTrBWSTOENR6    => SMTrBWSTOENR6,
        SMTrBWSTOENR7    => SMTrBWSTOENR7,

        SMTrBWSTWENR0    => SMTrBWSTWENR0,
        SMTrBWSTWENR1    => SMTrBWSTWENR1,
        SMTrBWSTWENR2    => SMTrBWSTWENR2,
        SMTrBWSTWENR3    => SMTrBWSTWENR3,
        SMTrBWSTWENR4    => SMTrBWSTWENR4,
        SMTrBWSTWENR5    => SMTrBWSTWENR5,
        SMTrBWSTWENR6    => SMTrBWSTWENR6,
        SMTrBWSTWENR7    => SMTrBWSTWENR7,

        SMTrBWSTBRDR0    => SMTrBWSTBRDR0,
        SMTrBWSTBRDR1    => SMTrBWSTBRDR1,
        SMTrBWSTBRDR2    => SMTrBWSTBRDR2,
        SMTrBWSTBRDR3    => SMTrBWSTBRDR3,
        SMTrBWSTBRDR4    => SMTrBWSTBRDR4,
        SMTrBWSTBRDR5    => SMTrBWSTBRDR5,
        SMTrBWSTBRDR6    => SMTrBWSTBRDR6,
        SMTrBWSTBRDR7    => SMTrBWSTBRDR7,

        SMTrBCR0         => SMTrBCR0,
        SMTrBCR1         => SMTrBCR1,
        SMTrBCR2         => SMTrBCR2,
        SMTrBCR3         => SMTrBCR3,
        SMTrBCR4         => SMTrBCR4,
        SMTrBCR5         => SMTrBCR5,
        SMTrBCR6         => SMTrBCR6,
        SMTrBCR7         => SMTrBCR7

        );
-- -----------------------------------------------------------------------------
-- 8 Instantiation of the SMC TrickMem Read/Write Control Block for each bank
-- -----------------------------------------------------------------------------
u0SsmcTrMemory : SsmcTrMemory
  generic map (
           Tclk             => Tclk
          )
  port map (
-- Inputs
        HCLK             => HCLK,
        HRESETn          => HRESETn,
        HWDATA           => HWDATA,
        LatchHADDR       => LatchHADDR,
        SMADDR           => SMADDR,
        nSMDATAEN        => nSMDATAEN,
        SSMTrBankCS      => iSSMTrCS(0),
        nSSMTrBankCS     => inSSMTrCS(0),
        SSMTrCS          => iSSMTrCS,
        nSSMTrCS         => inSSMTrCS,
        nSMWEN           => nSMWEN,
        nSMBLS           => nSMBLS,
        nSMOEN           => nSMOEN,
        SMCLK            => SMCLK,
        SMADDRVALID      => SMADDRVALID,
        SSMCTrMEMARRAYWr => SSMCTrMEMARRAY0Wr,
        SSMCTrBurstWt    => SSMCTrBurstWt,
        SSMCTrMEMBASE    => SSMCTrMEMBASE0,
        SMTrBIDCYR       => SMTrBIDCYR0,
        SMTrBWSTRDR      => SMTrBWSTRDR0,
        SMTrBWSTWRR      => SMTrBWSTWRR0,
        SMTrBWSTOENR     => SMTrBWSTOENR0,
        SMTrBWSTWENR     => SMTrBWSTWENR0,
        SMTrBWSTBRDR     => SMTrBWSTBRDR0,
        SMTrBCR          => SMTrBCR0,
        SMMemClkRatio    => SMMemClkRatio, 
-- InOut
        SMDATA           => SMDATA,
                                           
-- Outputs
        AhbRdDataDW      => AhbRdDataDW0,
        nSMBURSTWAIT     => nSMBURSTWAIT(0),
        SMTrIND          => SMTrIND0,
        SMFBCLK          => SMFBCLK
       );

u1SsmcTrMemory : SsmcTrMemory
  generic map (
           Tclk             => Tclk
          )
  port map (
-- Inputs
        HCLK             => HCLK,
        HRESETn          => HRESETn,
        HWDATA           => HWDATA,
        LatchHADDR       => LatchHADDR,
        SMADDR           => SMADDR,
        nSMDATAEN        => nSMDATAEN,
        SSMTrBankCS      => iSSMTrCS(1),
        nSSMTrBankCS     => inSSMTrCS(1),
        SSMTrCS          => iSSMTrCS,
        nSSMTrCS         => inSSMTrCS,
        nSMWEN           => nSMWEN,
        nSMBLS           => nSMBLS,
        nSMOEN           => nSMOEN,
        SMCLK            => SMCLK,
        SMADDRVALID      => SMADDRVALID,
        SSMCTrMEMARRAYWr => SSMCTrMEMARRAY1Wr,
        SSMCTrBurstWt    => SSMCTrBurstWt,
        SSMCTrMEMBASE    => SSMCTrMEMBASE1,
        SMTrBIDCYR       => SMTrBIDCYR1,
        SMTrBWSTRDR      => SMTrBWSTRDR1,
        SMTrBWSTWRR      => SMTrBWSTWRR1,
        SMTrBWSTOENR     => SMTrBWSTOENR1,
        SMTrBWSTWENR     => SMTrBWSTWENR1,
        SMTrBWSTBRDR     => SMTrBWSTBRDR1,
        SMTrBCR          => SMTrBCR1,
        SMMemClkRatio    => SMMemClkRatio,
-- InOut
        SMDATA           => SMDATA,
                                           
-- Outputs
        AhbRdDataDW      => AhbRdDataDW1,
        nSMBURSTWAIT     => nSMBURSTWAIT(1),
        SMTrIND          => SMTrIND1,
        SMFBCLK          => SMFBCLK
       );

u2SsmcTrMemory : SsmcTrMemory
  generic map (
           Tclk             => Tclk
          )
  port map (
-- Inputs
        HCLK             => HCLK,
        HRESETn          => HRESETn,
        HWDATA           => HWDATA,
        LatchHADDR       => LatchHADDR,
        SMADDR           => SMADDR,
        nSMDATAEN        => nSMDATAEN,
        SSMTrBankCS      => iSSMTrCS(2),
        nSSMTrBankCS     => inSSMTrCS(2),
        SSMTrCS          => iSSMTrCS,
        nSSMTrCS         => inSSMTrCS,
        nSMWEN           => nSMWEN,
        nSMBLS           => nSMBLS,
        nSMOEN           => nSMOEN,
        SMCLK            => SMCLK,
        SMADDRVALID      => SMADDRVALID,
        SSMCTrMEMARRAYWr => SSMCTrMEMARRAY2Wr,
        SSMCTrBurstWt    => SSMCTrBurstWt,
        SSMCTrMEMBASE    => SSMCTrMEMBASE2,
        SMTrBIDCYR       => SMTrBIDCYR2,
        SMTrBWSTRDR      => SMTrBWSTRDR2,
        SMTrBWSTWRR      => SMTrBWSTWRR2,
        SMTrBWSTOENR     => SMTrBWSTOENR2,
        SMTrBWSTWENR     => SMTrBWSTWENR2,
        SMTrBWSTBRDR     => SMTrBWSTBRDR2,
        SMTrBCR          => SMTrBCR2,
        SMMemClkRatio    => SMMemClkRatio,
                                           
-- InOut
        SMDATA           => SMDATA,
                                           
-- Outputs
        AhbRdDataDW      => AhbRdDataDW2,
        nSMBURSTWAIT     => nSMBURSTWAIT(2),
        SMTrIND          => SMTrIND2,
        SMFBCLK          => SMFBCLK
       );

u3SsmcTrMemory : SsmcTrMemory
  generic map (
           Tclk             => Tclk
          )
  port map (
-- Inputs
        HCLK             => HCLK,
        HRESETn          => HRESETn,
        HWDATA           => HWDATA,
        LatchHADDR       => LatchHADDR,
        SMADDR           => SMADDR,
        nSMDATAEN        => nSMDATAEN,
        SSMTrBankCS      => iSSMTrCS(3),
        nSSMTrBankCS     => inSSMTrCS(3),
        SSMTrCS          => iSSMTrCS,
        nSSMTrCS         => inSSMTrCS,
        nSMWEN           => nSMWEN,
        nSMBLS           => nSMBLS,
        nSMOEN           => nSMOEN,
        SMCLK            => SMCLK,
        SMADDRVALID      => SMADDRVALID,
        SSMCTrMEMARRAYWr => SSMCTrMEMARRAY3Wr,
        SSMCTrBurstWt    => SSMCTrBurstWt,
        SSMCTrMEMBASE    => SSMCTrMEMBASE3,
        SMTrBIDCYR       => SMTrBIDCYR3,
        SMTrBWSTRDR      => SMTrBWSTRDR3,
        SMTrBWSTWRR      => SMTrBWSTWRR3,
        SMTrBWSTOENR     => SMTrBWSTOENR3,
        SMTrBWSTWENR     => SMTrBWSTWENR3,
        SMTrBWSTBRDR     => SMTrBWSTBRDR3,
        SMTrBCR          => SMTrBCR3,
        SMMemClkRatio    => SMMemClkRatio,
-- InOut
        SMDATA           => SMDATA,
                                           
-- Outputs
        AhbRdDataDW      => AhbRdDataDW3,
        nSMBURSTWAIT     => nSMBURSTWAIT(3),
        SMTrIND          => SMTrIND3,
        SMFBCLK          => SMFBCLK
       );

u4SsmcTrMemory : SsmcTrMemory
  generic map (
           Tclk             => Tclk
          )
  port map (
-- Inputs
        HCLK             => HCLK,
        HRESETn          => HRESETn,
        HWDATA           => HWDATA,
        LatchHADDR       => LatchHADDR,
        SMADDR           => SMADDR,
        nSMDATAEN        => nSMDATAEN,
        SSMTrBankCS      => iSSMTrCS(4),
        nSSMTrBankCS     => inSSMTrCS(4),
        SSMTrCS          => iSSMTrCS,
        nSSMTrCS         => inSSMTrCS,
        nSMWEN           => nSMWEN,
        nSMBLS           => nSMBLS,
        nSMOEN           => nSMOEN,
        SMCLK            => SMCLK,
        SMADDRVALID      => SMADDRVALID,
        SSMCTrMEMARRAYWr => SSMCTrMEMARRAY4Wr,
        SSMCTrBurstWt    => SSMCTrBurstWt,
        SSMCTrMEMBASE    => SSMCTrMEMBASE4,
        SMTrBIDCYR       => SMTrBIDCYR4,
        SMTrBWSTRDR      => SMTrBWSTRDR4,
        SMTrBWSTWRR      => SMTrBWSTWRR4,
        SMTrBWSTOENR     => SMTrBWSTOENR4,
        SMTrBWSTWENR     => SMTrBWSTWENR4,
        SMTrBWSTBRDR     => SMTrBWSTBRDR4,
        SMTrBCR          => SMTrBCR4,
        SMMemClkRatio    => SMMemClkRatio,
-- InOut
        SMDATA           => SMDATA,
                                           
-- Outputs
        AhbRdDataDW      => AhbRdDataDW4,
        nSMBURSTWAIT     => nSMBURSTWAIT(4),
        SMTrIND          => SMTrIND4,
        SMFBCLK          => SMFBCLK
       );

u5SsmcTrMemory : SsmcTrMemory
  generic map (
           Tclk             => Tclk
          )
  port map (
-- Inputs
        HCLK             => HCLK,
        HRESETn          => HRESETn,
        HWDATA           => HWDATA,
        LatchHADDR       => LatchHADDR,
        SMADDR           => SMADDR,
        nSMDATAEN        => nSMDATAEN,
        SSMTrBankCS      => iSSMTrCS(5),
        nSSMTrBankCS     => inSSMTrCS(5),
        SSMTrCS          => iSSMTrCS,
        nSSMTrCS         => inSSMTrCS,
        nSMWEN           => nSMWEN,
        nSMBLS           => nSMBLS,
        nSMOEN           => nSMOEN,
        SMCLK            => SMCLK,
        SMADDRVALID      => SMADDRVALID,
        SSMCTrMEMARRAYWr => SSMCTrMEMARRAY5Wr,
        SSMCTrBurstWt    => SSMCTrBurstWt,
        SSMCTrMEMBASE    => SSMCTrMEMBASE5,
        SMTrBIDCYR       => SMTrBIDCYR5,
        SMTrBWSTRDR      => SMTrBWSTRDR5,
        SMTrBWSTWRR      => SMTrBWSTWRR5,
        SMTrBWSTOENR     => SMTrBWSTOENR5,
        SMTrBWSTWENR     => SMTrBWSTWENR5,
        SMTrBWSTBRDR     => SMTrBWSTBRDR5,
        SMTrBCR          => SMTrBCR5,
        SMMemClkRatio    => SMMemClkRatio,
-- InOut
        SMDATA           => SMDATA,
                                           
-- Outputs
        AhbRdDataDW      => AhbRdDataDW5,
        nSMBURSTWAIT     => nSMBURSTWAIT(5),
        SMTrIND          => SMTrIND5,
        SMFBCLK          => SMFBCLK
       );

u6SsmcTrMemory : SsmcTrMemory
  generic map (
           Tclk             => Tclk
          )
  port map (
-- Inputs
        HCLK             => HCLK,
        HRESETn          => HRESETn,
        HWDATA           => HWDATA,
        LatchHADDR       => LatchHADDR,
        SMADDR           => SMADDR,
        nSMDATAEN        => nSMDATAEN,
        SSMTrBankCS      => iSSMTrCS(6),
        nSSMTrBankCS     => inSSMTrCS(6),
        SSMTrCS          => iSSMTrCS,
        nSSMTrCS         => inSSMTrCS,
        nSMWEN           => nSMWEN,
        nSMBLS           => nSMBLS,
        nSMOEN           => nSMOEN,
        SMCLK            => SMCLK,
        SMADDRVALID      => SMADDRVALID,
        SSMCTrMEMARRAYWr => SSMCTrMEMARRAY6Wr,
        SSMCTrBurstWt    => SSMCTrBurstWt,
        SSMCTrMEMBASE    => SSMCTrMEMBASE6,
        SMTrBIDCYR       => SMTrBIDCYR6,
        SMTrBWSTRDR      => SMTrBWSTRDR6,
        SMTrBWSTWRR      => SMTrBWSTWRR6,
        SMTrBWSTOENR     => SMTrBWSTOENR6,
        SMTrBWSTWENR     => SMTrBWSTWENR6,
        SMTrBWSTBRDR     => SMTrBWSTBRDR6,
        SMTrBCR          => SMTrBCR6,
        SMMemClkRatio    => SMMemClkRatio,
-- InOut
        SMDATA           => SMDATA,
                                           
-- Outputs
        AhbRdDataDW      => AhbRdDataDW6,
        nSMBURSTWAIT     => nSMBURSTWAIT(6),
        SMTrIND          => SMTrIND6,
        SMFBCLK          => SMFBCLK
       );

u7SsmcTrMemory : SsmcTrMemory
  generic map (
           Tclk             => Tclk
          )
  port map (
-- Inputs
        HCLK             => HCLK,
        HRESETn          => HRESETn,
        HWDATA           => HWDATA,
        LatchHADDR       => LatchHADDR,
        SMADDR           => SMADDR,
        nSMDATAEN        => nSMDATAEN,
        SSMTrBankCS      => iSSMTrCS(7),
        nSSMTrBankCS     => inSSMTrCS(7),
        SSMTrCS          => iSSMTrCS,
        nSSMTrCS         => inSSMTrCS,
        nSMWEN           => nSMWEN,
        nSMBLS           => nSMBLS,
        nSMOEN           => nSMOEN,
        SMCLK            => SMCLK,
        SMADDRVALID      => SMADDRVALID,
        SSMCTrMEMARRAYWr => SSMCTrMEMARRAY7Wr,
        SSMCTrBurstWt    => SSMCTrBurstWt,
        SSMCTrMEMBASE    => SSMCTrMEMBASE7,
        SMTrBIDCYR       => SMTrBIDCYR7,
        SMTrBWSTRDR      => SMTrBWSTRDR7,
        SMTrBWSTWRR      => SMTrBWSTWRR7,
        SMTrBWSTOENR     => SMTrBWSTOENR7,
        SMTrBWSTWENR     => SMTrBWSTWENR7,
        SMTrBWSTBRDR     => SMTrBWSTBRDR7,
        SMTrBCR          => SMTrBCR7,
        SMMemClkRatio    => SMMemClkRatio,
-- InOut
        SMDATA           => SMDATA,
                                           
-- Outputs
        AhbRdDataDW      => AhbRdDataDW7,
        nSMBURSTWAIT     => nSMBURSTWAIT(7),
        SMTrIND          => SMTrIND7,
        SMFBCLK          => SMFBCLK
       );

-- SMMemCLKRatio    <= iSMMemCLKRatio;

end structural;

-- --================================== End ==================================--
