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
-- File Name              : SsmcTrMemAhbIfReg.vhd.rca
-- File Revision          : 1.8
--
-- Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block interfaces the SSMC Memory model with the AHB bus.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SsmcTrMemAhbIfReg is
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB Clock
        HRESETn          : in    std_logic; -- Bus Reset
        HADDR            : in    std_logic_vector(17 downto 0);
                                            -- AHB Address Bus
        HTRANS           : in    std_logic_vector(1 downto 0);
                                            -- Transfer type
        HWRITETr         : in    std_logic; -- AHB Peripheral Write
        HWRITEREG        : in    std_logic; -- Mirror REG write
        HSIZE            : in    std_logic_vector(2 downto 0);
                                            -- Transfer size
        HBURST           : in    std_logic_vector(2 downto 0);
                                            -- Burst Type
        HREADYINTr       : in    std_logic; -- Multiplexed version of
                                            -- HREADY outputs
        HWDATA           : in    std_logic_vector(31 downto 0);
                                            -- AHB Write Data bus
        HREADYINREG      : in    std_logic; -- Multiplexd version of 
                                            -- mirror registers
        HWDATAREG        : in    std_logic_vector(31 downto 0);
                                            -- Mirrored Register Write Data bus
        HSELSSMCTrMEM    : in    std_logic; -- AHB Peripheral (TrickMem)
                                            -- Select
        HSELSSMCTrREG    : in    std_logic; -- TrickMem mirror register 
                                            -- select
        AhbRdDataDW0     : in    std_logic_vector(31 downto 0);
                                            -- Mem0 Rd data
        AhbRdDataDW1     : in    std_logic_vector(31 downto 0);
                                            -- Mem1 Rd data
        AhbRdDataDW2     : in    std_logic_vector(31 downto 0);
                                            -- Mem2 Rd data
        AhbRdDataDW3     : in    std_logic_vector(31 downto 0);
                                            -- Mem3 Rd data
        AhbRdDataDW4     : in    std_logic_vector(31 downto 0);
                                            -- Mem4 Rd data
        AhbRdDataDW5     : in    std_logic_vector(31 downto 0);
                                            -- Mem5 Rd data
        AhbRdDataDW6     : in    std_logic_vector(31 downto 0);
                                            -- Mem6 Rd data
        AhbRdDataDW7     : in    std_logic_vector(31 downto 0);
                                            -- Mem7 Rd data


-- Outputs
        HRDATATr         : out   std_logic_vector(31 downto 0);
                                            -- AHB Read Data bus
        HREADYOUTTr      : out   std_logic; -- Slave HREADY output
        HRESPTr          : out   std_logic_vector(1 downto 0);
                                            -- Slave response

        SSMCTrMEMARRAY0Wr: out   std_logic; -- SSMCTrMEMARRAY0 Write enable

        SSMCTrMEMARRAY1Wr: out   std_logic; -- SSMCTrMEMARRAY1 Write enable

        SSMCTrMEMARRAY2Wr: out   std_logic; -- SSMCTrMEMARRAY2 Write enable

        SSMCTrMEMARRAY3Wr: out   std_logic; -- SSMCTrMEMARRAY3 Write enable

        SSMCTrMEMARRAY4Wr: out   std_logic; -- SSMCTrMEMARRAY4 Write enable

        SSMCTrMEMARRAY5Wr: out   std_logic; -- SSMCTrMEMARRAY5 Write enable

        SSMCTrMEMARRAY6Wr: out   std_logic; -- SSMCTrMEMARRAY6 Write enable

        SSMCTrMEMARRAY7Wr: out   std_logic; -- SSMCTrMEMARRAY7 Write enable

        LatchHADDR       : out   std_logic_vector(17 downto 0);
                                            -- Latched AHB Address
        SSMCTrBurstWT    : out   std_logic_vector(8  downto 0);
                                            -- SSMCTrBurstWT Register
        SSMCTrMEMBASE0   : out   std_logic_vector(14 downto 0);
                                            -- SMCTrMEMBASE0 Register
        SSMCTrMEMBASE1   : out   std_logic_vector(14 downto 0);
                                            -- SMCTrMEMBASE1 Register
        SSMCTrMEMBASE2   : out   std_logic_vector(14 downto 0);
                                            -- SMCTrMEMBASE2 Register
        SSMCTrMEMBASE3   : out   std_logic_vector(14 downto 0);
                                            -- SMCTrMEMBASE3 Register
        SSMCTrMEMBASE4   : out   std_logic_vector(14 downto 0);
                                            -- SMCTrMEMBASE4 Register
        SSMCTrMEMBASE5   : out   std_logic_vector(14 downto 0);
                                            -- SMCTrMEMBASE5 Register
        SSMCTrMEMBASE6   : out   std_logic_vector(14 downto 0);
                                            -- SMCTrMEMBASE6 Register
        SSMCTrMEMBASE7   : out   std_logic_vector(14 downto 0);
                                            -- SMCTrMEMBASE7 Register
        SMTrBIDCYR0      : out   std_logic_vector(3 downto 0);
                                            -- SMTrBIDCY0 mirror register
        SMTrBIDCYR1      : out   std_logic_vector(3 downto 0);
                                            -- SMTrBIDCY1 mirror register
        SMTrBIDCYR2      : out   std_logic_vector(3 downto 0);
                                            -- SMTrBIDCY2 mirror register
        SMTrBIDCYR3      : out   std_logic_vector(3 downto 0);
                                            -- SMTrBIDCY3 mirror register
        SMTrBIDCYR4      : out   std_logic_vector(3 downto 0);
                                            -- SMTrBIDCY4 mirror register
        SMTrBIDCYR5      : out   std_logic_vector(3 downto 0);
                                            -- SMTrBIDCY5 mirror register
        SMTrBIDCYR6      : out   std_logic_vector(3 downto 0);
                                            -- SMTrBIDCY6 mirror register
        SMTrBIDCYR7      : out   std_logic_vector(3 downto 0);
                                            -- SMTrBIDCY7 mirror register
        SMTrBWSTRDR0     : out   std_logic_vector(4 downto 0);
                                            -- SMTrBWSTRDR0 mirror register
        SMTrBWSTRDR1     : out   std_logic_vector(4 downto 0);
                                            -- SMTrBWSTRDR1 mirror register
        SMTrBWSTRDR2     : out   std_logic_vector(4 downto 0);
                                            -- SMTrBWSTRDR2 mirror register
        SMTrBWSTRDR3     : out   std_logic_vector(4 downto 0);
                                            -- SMTrBWSTRDR3 mirror register
        SMTrBWSTRDR4     : out   std_logic_vector(4 downto 0);
                                            -- SMTrBWSTRDR4 mirror register
        SMTrBWSTRDR5     : out   std_logic_vector(4 downto 0);
                                            -- SMTrBWSTRDR5 mirror register
        SMTrBWSTRDR6     : out   std_logic_vector(4 downto 0);
                                            -- SMTrBWSTRDR6 mirror register
        SMTrBWSTRDR7     : out   std_logic_vector(4 downto 0);
                                            -- SMTrBWSTRDR7 mirror register
        SMTrBWSTWRR0     : out   std_logic_vector(4 downto 0);
                                            -- SMTrBWSTWRR0 mirror register
        SMTrBWSTWRR1     : out   std_logic_vector(4 downto 0);
                                            -- SMTrBWSTWRR1 mirror register
        SMTrBWSTWRR2     : out   std_logic_vector(4 downto 0);
                                            -- SMTrBWSTWRR2 mirror register
        SMTrBWSTWRR3     : out   std_logic_vector(4 downto 0);
                                            -- SMTrBWSTWRR3 mirror register
        SMTrBWSTWRR4     : out   std_logic_vector(4 downto 0);
                                            -- SMTrBWSTWRR4 mirror register
        SMTrBWSTWRR5     : out   std_logic_vector(4 downto 0);
                                            -- SMTrBWSTWRR5 mirror register
        SMTrBWSTWRR6     : out   std_logic_vector(4 downto 0);
                                            -- SMTrBWSTWRR6 mirror register
        SMTrBWSTWRR7     : out   std_logic_vector(4 downto 0);
                                            -- SMTrBWSTWRR7 mirror register
        SMTrBWSTOENR0    : out   std_logic_vector(3 downto 0);
                                            -- SMTrBWSTOENR0 mirror register
        SMTrBWSTOENR1    : out   std_logic_vector(3 downto 0);
                                            -- SMTrBWSTOENR1 mirror register
        SMTrBWSTOENR2    : out   std_logic_vector(3 downto 0);
                                            -- SMTrBWSTOENR2 mirror register
        SMTrBWSTOENR3    : out   std_logic_vector(3 downto 0);
                                            -- SMTrBWSTOENR3 mirror register
        SMTrBWSTOENR4    : out   std_logic_vector(3 downto 0);
                                            -- SMTrBWSTOENR4 mirror register
        SMTrBWSTOENR5    : out   std_logic_vector(3 downto 0);
                                            -- SMTrBWSTOENR5 mirror register
        SMTrBWSTOENR6    : out   std_logic_vector(3 downto 0);
                                            -- SMTrBWSTOENR6 mirror register
        SMTrBWSTOENR7    : out   std_logic_vector(3 downto 0);
                                            -- SMTrBWSTOENR7 mirror register
        SMTrBWSTWENR0    : out   std_logic_vector(3 downto 0);
                                            -- SMTrBWSTWENR0 mirror register
        SMTrBWSTWENR1    : out   std_logic_vector(3 downto 0);
                                            -- SMTrBWSTWENR1 mirror register
        SMTrBWSTWENR2    : out   std_logic_vector(3 downto 0);
                                            -- SMTrBWSTWENR2 mirror register
        SMTrBWSTWENR3    : out   std_logic_vector(3 downto 0);
                                            -- SMTrBWSTWENR3 mirror register
        SMTrBWSTWENR4    : out   std_logic_vector(3 downto 0);
                                            -- SMTrBWSTWENR4 mirror register
        SMTrBWSTWENR5    : out   std_logic_vector(3 downto 0);
                                            -- SMTrBWSTWENR5 mirror register
        SMTrBWSTWENR6    : out   std_logic_vector(3 downto 0);
                                            -- SMTrBWSTWENR6 mirror register
        SMTrBWSTWENR7    : out   std_logic_vector(3 downto 0);
                                            -- SMTrBWSTWENR7 mirror register
        SMTrBWSTBRDR0    : out   std_logic_vector(4 downto 0);
                                            -- SMTrBWSTBRDR0 mirror register
        SMTrBWSTBRDR1    : out   std_logic_vector(4 downto 0);
                                            -- SMTrBWSTBRDR1 mirror register
        SMTrBWSTBRDR2    : out   std_logic_vector(4 downto 0);
                                            -- SMTrBWSTBRDR2 mirror register
        SMTrBWSTBRDR3    : out   std_logic_vector(4 downto 0);
                                            -- SMTrBWSTBRDR3 mirror register
        SMTrBWSTBRDR4    : out   std_logic_vector(4 downto 0);
                                            -- SMTrBWSTBRDR4 mirror register
        SMTrBWSTBRDR5    : out   std_logic_vector(4 downto 0);
                                            -- SMTrBWSTBRDR5 mirror register
        SMTrBWSTBRDR6    : out   std_logic_vector(4 downto 0);
                                            -- SMTrBWSTBRDR6 mirror register
        SMTrBWSTBRDR7    : out   std_logic_vector(4 downto 0);
                                            -- SMTrBWSTBRDR7 mirror register
        SMTrBCR0         : out   std_logic_vector(21 downto 0);
                                            -- SMTrBCR0 mirror register
        SMTrBCR1         : out   std_logic_vector(21 downto 0);
                                            -- SMTrBCR1 mirror register
        SMTrBCR2         : out   std_logic_vector(21 downto 0);
                                            -- SMTrBCR2 mirror register
        SMTrBCR3         : out   std_logic_vector(21 downto 0);
                                            -- SMTrBCR3 mirror register
        SMTrBCR4         : out   std_logic_vector(21 downto 0);
                                            -- SMTrBCR4 mirror register
        SMTrBCR5         : out   std_logic_vector(21 downto 0);
                                            -- SMTrBCR5 mirror register
        SMTrBCR6         : out   std_logic_vector(21 downto 0);
                                            -- SMTrBCR6 mirror register
        SMTrBCR7         : out   std_logic_vector(21 downto 0);
                                            -- SMTrBCR7 mirror register
        SMMemCLKRatio    : out   std_logic_vector(1 downto 0)
                                            -- Memroy clock register

       );
end SsmcTrMemAhbIfReg;

-- -----------------------------------------------------------------------------
--
--                              SsmcTrMemAhbIfReg
--                              ================= 
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- SSMC Tricbox is an AHB slave. This block interfaces the trickbox with the AHB
-- bus. All slave response signals are generated from this module.
-- This module decodes AHB accesses and generates the read/write
-- strobe to the appropriate registers. HCLK period calculation logic also
-- contained in this module.
--
-- -----------------------------------------------------------------------------
--                        SSMC Memory Trickbox Register Map
-- -----------------------------------------------------------------------------
-- Offset    Register        Type   Width    Describtion
-- -----------------------------------------------------------------------------
-- SSMC TrickMEM Base + Offset
--
--          SSMCTrMEMARRAYx  R/W   32-bit   32-bit wide and 2K deep Memory. By
-- 0x00000                0                 changing the MemDeep value in
-- 0x02000                1                 SmcTrConst file it is possible to
-- 0x04000                2                 change the size of the memory array.
-- 0x06000                3
-- 0x08000                4
-- 0x0A000                5
-- 0x0C000                6
-- 0x0E000                7
-- 
--           SSMCTrMEMBASEx  R/W    15-bit   Memory base address register.
-- 0x10000                0
-- 0x12000                1
-- 0x14000                2
-- 0x16000                3
-- 0x18000                4
-- 0x1A000                5
-- 0x1C000                6
-- 0x1E000                7

-- 0x20000   SSMCTrBurstWT   R/W     9-bit  Busrt wait delay register. 
--
--
-- UUT Base + Offset
--
--           SMTrBIDCYRx    R/W    4-bit    memory data bus arround time.
-- 0x00                0                                                      
-- 0x20                1
-- 0x40                2
-- 0x60                3
-- 0x80                4
-- 0xA0                5
-- 0xC0                6
-- 0xE0                7
--  
--
--           SMTrBWSTRDRx   R/W    4-bit   In case of SRAM and ROM, this field
-- 0x04                 0                  indicates read access time. I case  
-- 0x24                 1                  of burst ROM this indicates initial
-- 0x44                 2                  access time.
-- 0x64                 3
-- 0x84                 4
-- 0xA4                 5
-- 0xC4                 6
-- 0xE4                 7 
--
--
--          SMTrBWSTWRRx    R/W    4-bit   In case of SRAM and ROM, this field
-- 0x08                0                   indicates Write access time. I case
-- 0x28                1                   of RAM this indicates the number of
-- 0x48                2                   wait states for write access,and
-- 0x68                3                   external wait assertion timing for
-- 0x88                4                   writes.
-- 0xA8                5
-- 0xC8                6
-- 0xE8                7    
--
--
--         SMTrBWSTOENRx    R/W    4-bit  Output enable assertion delay from
-- 0x0C                0                  chip select assertion.
-- 0x2C                1
-- 0x4C                2
-- 0x6C                3
-- 0x8C                4
-- 0xAC                5
-- 0xCC                6
-- 0xEC                7
--
--         SMTrBWSTWENRx    R/W    4-bit  Write enable assertion delay from
-- 0x10                0                  chip select assertion.
-- 0x30                1
-- 0x50                2
-- 0x70                3
-- 0x90                4
-- 0xB0                5
-- 0xD0                6
-- 0xF0                7
--
--         SMTrBWSTBRDRx    R/W    5-bit  Burst read state after the first read.
-- 0x14                0                  
-- 0x34                1
-- 0x54                2
-- 0x74                3
-- 0x94                4
-- 0xB4                5
-- 0xD4                6
-- 0xF4                7
--
--              SMTrBCRx    R/W    4-bit  Bank control register
-- 0x1C                0                  
-- 0x3C                1
-- 0x5C                2
-- 0x7C                3
-- 0x9C                4
-- 0xBC                5
-- 0xDC                6
-- 0xFC                7
--
--
--
-- -----------------------------------------------------------------------------

-- --============================ ARCHITECTURE ===============================--

architecture behavioural of SsmcTrMemAhbIfReg is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------
constant IDLE             : std_logic_vector(1 downto 0) := "00";
-- Master IDLE respone

constant BUSY             : std_logic_vector(1 downto 0) := "01";
-- Master BUSY respone

constant OKAY             : std_logic_vector(1 downto 0) := "00";
-- Slave OKAY respone

constant ERROR            : std_logic_vector(1 downto 0) := "01";
-- Slave ERROR respone

constant WORD             : std_logic_vector(2 downto 0) := "010";
-- 32-bit operation

constant INCR             : std_logic_vector(2 downto 0) := "001";
-- Undefined length burst

constant ZEROFILL         : std_logic_vector(31 downto 0)
                            := "00000000000000000000000000000000";

-- -----------------------------------------------------------------------------
-- Trickbox registers address constants. Address decode is for
-- bits 13 to 17 (4 bits)
-- -----------------------------------------------------------------------------
constant HADDR_SSMCTrMEMARRAY0   : std_logic_vector(17 downto 13) := "00000";
-- SSMCTrMEMARRAY at offset 0x0000 to 1FFF

constant HADDR_SSMCTrMEMARRAY1   : std_logic_vector(17 downto 13) := "00001";
-- SSMCTrMEMARRAY at offset 0x0000 to 1FFF

constant HADDR_SSMCTrMEMARRAY2   : std_logic_vector(17 downto 13) := "00010";
-- SSMCTrMEMARRAY at offset 0x0000 to 1FFF

constant HADDR_SSMCTrMEMARRAY3   : std_logic_vector(17 downto 13) := "00011";
-- SSMCTrMEMARRAY at offset 0x0000 to 1FFF

constant HADDR_SSMCTrMEMARRAY4   : std_logic_vector(17 downto 13) := "00100";
-- SSMCTrMEMARRAY at offset 0x0000 to 1FFF

constant HADDR_SSMCTrMEMARRAY5   : std_logic_vector(17 downto 13) := "00101";
-- SSMCTrMEMARRAY at offset 0x0000 to 1FFF

constant HADDR_SSMCTrMEMARRAY6   : std_logic_vector(17 downto 13) := "00110";
-- SSMCTrMEMARRAY at offset 0x0000 to 1FFF

constant HADDR_SSMCTrMEMARRAY7   : std_logic_vector(17 downto 13) := "00111";
-- SSMCTrMEMARRAY at offset 0x0000 to 1FFF

constant HADDR_SSMCTrBurstWT     : std_logic_vector(17 downto 13)  := "10000";
-- SSMCTrBurstWT at offset 0x20000

constant HADDR_SSMCTrMEMBASE0    : std_logic_vector(17 downto 13)  := "01000";
-- SSMCTrMEMB0 at offset 0x2000

constant HADDR_SSMCTrMEMBASE1    : std_logic_vector(17 downto 13)  := "01001";
-- SSMCTrMEMB1 at offset 0x4000

constant HADDR_SSMCTrMEMBASE2    : std_logic_vector(17 downto 13)  := "01010";
-- SSMCTrMEMB2 at offset 0x6000

constant HADDR_SSMCTrMEMBASE3    : std_logic_vector(17 downto 13)  := "01011";
-- SSMCTrMEMB3 at offset 0x8000

constant HADDR_SSMCTrMEMBASE4    : std_logic_vector(17 downto 13)  := "01100";
-- SSMCTrMEMB4 at offset 0xA000

constant HADDR_SSMCTrMEMBASE5    : std_logic_vector(17 downto 13)  := "01101";
-- SSMCTrMEMB5 at offset 0xB000

constant HADDR_SSMCTrMEMBASE6    : std_logic_vector(17 downto 13)  := "01110";
-- SSMCTrMEMB6 at offset 0xC000

constant HADDR_SSMCTrMEMBASE7    : std_logic_vector(17 downto 13)  := "01111";
-- SSMCTrMEMB7 at offset 0xD000

constant HADDR_SMMemCLKRatio     : std_logic_vector(17 downto 13)  := "10010";
-- SMMemCLKRatio at offset 0x24000

-- -----------------------------------------------------------------------------
-- Mirror register constants. Address decode is for bits 10 to 15 (6 bits)
-- -----------------------------------------------------------------------------

constant HADDR_SMTrBIDCYR0   : std_logic_vector(7 downto 2)  := "000000";
-- SMTrBIDCYR0 at offset 0x00

constant HADDR_SMTrBWSTRDR0  : std_logic_vector(9 downto 2)  := "00000001";
-- SMTrBWSTRDR0 at offset 0x04

constant HADDR_SMTrBWSTWRR0  : std_logic_vector(7 downto 2)  := "000010";
-- SMTrBWSTWRR0 at offset 0x08

constant HADDR_SMTrBWSTOENR0 : std_logic_vector(7 downto 2)  := "000011";
-- SMTrBWSTOENR0 at offset 0x0C

constant HADDR_SMTrBWSTWENR0 : std_logic_vector(7 downto 2)  := "000100";
-- SMTrBWSTWENR0 at offset 0x10

constant HADDR_SMTrBCR0      : std_logic_vector(7 downto 2)  := "000101";
-- SMTrBCR0 at offset 0x14

constant HADDR_SMTrBWSTBRDR0 : std_logic_vector(7 downto 2)  := "000111";
-- SMTrBWSTBRDR0  at offset 0x1C

constant HADDR_SMTrBIDCYR1   : std_logic_vector(7 downto 2)  := "001000";
-- SMTrBIDCYR1 at offset 0x20

constant HADDR_SMTrBWSTRDR1  : std_logic_vector(7 downto 2)  := "001001";
-- SMTrBWSTRDR1 at offset 0x24

constant HADDR_SMTrBWSTWRR1  : std_logic_vector(7 downto 2)  := "001010";
-- SMTrBWSTWRR1 at offset 0x28

constant HADDR_SMTrBWSTOENR1 : std_logic_vector(7 downto 2)  := "001011";
-- SMTrBWSTOENR1 at offset 0x2C

constant HADDR_SMTrBWSTWENR1 : std_logic_vector(7 downto 2)  := "001100";
-- SMTrBWSTWENR1 at offset 0x30

constant HADDR_SMTrBCR1      : std_logic_vector(7 downto 2)  := "001101";
-- SMTrBCR1 at offset 0x34

constant HADDR_SMTrBWSTBRDR1 : std_logic_vector(7 downto 2)  := "001111";
-- SMTrBWSTRDR1  at offset 0x3C

constant HADDR_SMTrBIDCYR2   : std_logic_vector(7 downto 2)  := "010000";
-- SMTrBIDCYR2 at offset 0x40

constant HADDR_SMTrBWSTRDR2  : std_logic_vector(7 downto 2)  := "010001";
-- SMTrBWSTRDR2 at offset 0x44

constant HADDR_SMTrBWSTWRR2  : std_logic_vector(7 downto 2)  := "010010";
-- SMTrBWSTWRR2 at offset 0x48

constant HADDR_SMTrBWSTOENR2 : std_logic_vector(7 downto 2)  := "010011";
-- SMTrBWSTOENR2 at offset 0x4C

constant HADDR_SMTrBWSTWENR2 : std_logic_vector(7 downto 2)  := "010100";
-- SMTrBWSTWENR2 at offset 0x50

constant HADDR_SMTrBCR2      : std_logic_vector(7 downto 2)  := "010101";
-- SMTrBCR2 at offset 0x54

constant HADDR_SMTrBWSTBRDR2 : std_logic_vector(7 downto 2)  := "010111";
-- SMTrBWSTRDR3  at offset 0x5C

constant HADDR_SMTrBIDCYR3   : std_logic_vector(7 downto 2)  := "011000";
-- SMTrBIDCYR3 at offset 0x60

constant HADDR_SMTrBWSTRDR3  : std_logic_vector(7 downto 2)  := "011001";
-- SMTrBWSTRDR3 at offset 0x64

constant HADDR_SMTrBWSTWRR3  : std_logic_vector(7 downto 2)  := "011010";
-- SMTrBWSTWRR4 at offset 0x68

constant HADDR_SMTrBWSTOENR3 : std_logic_vector(7 downto 2)  := "011011";
-- SMTrBWSTOENR4 at offset 0x6C

constant HADDR_SMTrBWSTWENR3 : std_logic_vector(7 downto 2)  := "011100";
-- SMTrBWSTWENR4 at offset 0x70

constant HADDR_SMTrBCR3      : std_logic_vector(7 downto 2)  := "011101";
-- SMTrBCR4 at offset 0x74

constant HADDR_SMTrBWSTBRDR3 : std_logic_vector(7 downto 2)  := "011111";
-- SMTrBWSTRDR4  at offset 0x7C

constant HADDR_SMTrBIDCYR4   : std_logic_vector(7 downto 2)  := "100000";
-- SMTrBIDCYR5 at offset 0x80

constant HADDR_SMTrBWSTRDR4  : std_logic_vector(7 downto 2)  := "100001";
-- SMTrBWSTRDR5 at offset 0x84

constant HADDR_SMTrBWSTWRR4  : std_logic_vector(7 downto 2)  := "100010";
-- SMTrBWSTWRR5 at offset 0x88

constant HADDR_SMTrBWSTOENR4 : std_logic_vector(7 downto 2)  := "100011";
-- SMTrBWSTOENR5 at offset 0x8C

constant HADDR_SMTrBWSTWENR4 : std_logic_vector(7 downto 2)  := "100100";
-- SMTrBWSTWENR5 at offset 0x90

constant HADDR_SMTrBCR4      : std_logic_vector(7 downto 2)  := "100101";
-- SMTrBCR5 at offset 0x94

constant HADDR_SMTrBWSTBRDR4 : std_logic_vector(7 downto 2)  := "100111";
-- SMTrBWSTRDR5  at offset 0x9C

constant HADDR_SMTrBIDCYR5   : std_logic_vector(7 downto 2)  := "101000";
-- SMTrBIDCYR6 at offset 0xA0

constant HADDR_SMTrBWSTRDR5  : std_logic_vector(7 downto 2)  := "101001";
-- SMTrBWSTRDR6 at offset 0xA4

constant HADDR_SMTrBWSTWRR5  : std_logic_vector(7 downto 2)  := "101010";
-- SMTrBWSTWRR6 at offset 0xA8

constant HADDR_SMTrBWSTOENR5 : std_logic_vector(7 downto 2)  := "101011";
-- SMTrBWSTOENR6 at offset 0xAC

constant HADDR_SMTrBWSTWENR5 : std_logic_vector(7 downto 2)  := "101100";
-- SMTrBWSTWENR6 at offset 0xB0

constant HADDR_SMTrBCR5      : std_logic_vector(7 downto 2)  := "101101";
-- SMTrBCR6 at offset 0xB4

constant HADDR_SMTrBWSTBRDR5 : std_logic_vector(7 downto 2)  := "101111";
-- SMTrBWSTRDR6  at offset 0xBC

constant HADDR_SMTrBIDCYR6   : std_logic_vector(7 downto 2)  := "110000";
-- SMTrBIDCYR7 at offset 0xC0

constant HADDR_SMTrBWSTRDR6  : std_logic_vector(7 downto 2)  := "110001";
-- SMTrBWSTRDR7 at offset 0xC4

constant HADDR_SMTrBWSTWRR6  : std_logic_vector(7 downto 2)  := "110010";
-- SMTrBWSTWRR7 at offset 0xC8

constant HADDR_SMTrBWSTOENR6 : std_logic_vector(7 downto 2)  := "110011";
-- SMTrBWSTOENR7 at offset 0xCC

constant HADDR_SMTrBWSTWENR6 : std_logic_vector(7 downto 2)  := "110100";
-- SMTrBWSTWENR7 at offset 0xD0

constant HADDR_SMTrBCR6      : std_logic_vector(7 downto 2)  := "110101";
-- SMTrBCR7 at offset 0xD4

constant HADDR_SMTrBWSTBRDR6 : std_logic_vector(7 downto 2)  := "110111";
-- SMTrBWSTRDR7  at offset 0xDC

constant HADDR_SMTrBIDCYR7   : std_logic_vector(7 downto 2)  := "111000";
-- SMTrBIDCYR7 at offset 0xE0

constant HADDR_SMTrBWSTRDR7  : std_logic_vector(7 downto 2)  := "111001";
-- SMTrBWSTRDR7 at offset 0xE4

constant HADDR_SMTrBWSTWRR7  : std_logic_vector(7 downto 2)  := "111010";
-- SMTrBWSTWRR7 at offset 0xE8

constant HADDR_SMTrBWSTOENR7 : std_logic_vector(7 downto 2)  := "111011";
-- SMTrBWSTOENR7 at offset 0xEC

constant HADDR_SMTrBWSTWENR7 : std_logic_vector(7 downto 2)  := "111100";
-- SMTrBWSTWENR7 at offset 0xF0

constant HADDR_SMTrBCR7      : std_logic_vector(7 downto 2)  := "111101";
-- SMTrBCR7 at offset 0xF4

constant HADDR_SMTrBWSTBRDR7 : std_logic_vector(7 downto 2)  := "111111";
-- SMTrBWSTRDR7  at offset 0xFC
-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal iLatchHADDR         : std_logic_vector(17 downto 0)
                             := "000000000000000000";
-- Latched version of HADDR

signal iHRESPTr            : std_logic_vector(1 downto 0);
-- Indicates the type of response for a transfer

signal iSMTrBIDCYR0        : std_logic_vector(3 downto 0) := "0000";
-- Internal version of SMCTrIDCYR0 Register

signal iSMTrBIDCYR1        : std_logic_vector(3 downto 0) := "0000";
-- Internal version of SMCTrIDCYR1 Register

signal iSMTrBIDCYR2        : std_logic_vector(3 downto 0) := "0000";
-- Internal version of SMCTrIDCYR2 Register

signal iSMTrBIDCYR3        : std_logic_vector(3 downto 0) := "0000";
-- Internal version of SMCTrIDCYR3 Register

signal iSMTrBIDCYR4       : std_logic_vector(3 downto 0) := "0000";
-- Internal version of SMCTrIDCYR4 Register

signal iSMTrBIDCYR5        : std_logic_vector(3 downto 0) := "0000";
-- Internal version of SMCTrIDCYR5 Register

signal iSMTrBIDCYR6        : std_logic_vector(3 downto 0) := "0000";
-- Internal version of SMCTrIDCYR6 Register

signal iSMTrBIDCYR7        : std_logic_vector(3 downto 0) := "0000";
-- Internal version of SMCTrIDCYR7 Register

signal iSMTrBWSTRDR0       : std_logic_vector(4 downto 0) := "00000";
-- Internal version of SMTrBWSTRDR0

signal iSMTrBWSTRDR1       : std_logic_vector(4 downto 0) := "00000";
-- Internal version of SMTrBWSTRDR1

signal iSMTrBWSTRDR2       : std_logic_vector(4 downto 0) := "00000";
-- Internal version of SMTrBWSTRDR1

signal iSMTrBWSTRDR3       : std_logic_vector(4 downto 0) := "00000";
-- Internal version of SMTrBWSTRDR3

signal iSMTrBWSTRDR4       : std_logic_vector(4 downto 0) := "00000";
-- Internal version of SMTrBWSTRDR4

signal iSMTrBWSTRDR5       : std_logic_vector(4 downto 0) := "00000";
-- Internal version of SMTrBWSTRDR5

signal iSMTrBWSTRDR6       : std_logic_vector(4 downto 0) := "00000";
-- Internal version of SMTrBWSTRDR6

signal iSMTrBWSTRDR7       : std_logic_vector(4 downto 0) := "00000";
-- Internal version of SMTrBWSTRDR7

signal iSMTrBWSTWRR0       : std_logic_vector(4 downto 0) := "00000";
-- Internal version of SMTrBWSTWRR0

signal iSMTrBWSTWRR1       : std_logic_vector(4 downto 0) := "00000";
-- Internal version of SMTrBWSTWRR1

signal iSMTrBWSTWRR2       : std_logic_vector(4 downto 0) := "00000";
-- Internal version of SMTrBWSTWRR2

signal iSMTrBWSTWRR3       : std_logic_vector(4 downto 0) := "00000";
-- Internal version of SMTrBWSTWRR3

signal iSMTrBWSTWRR4       : std_logic_vector(4 downto 0) := "00000";
-- Internal version of SMTrBWSTWRR4

signal iSMTrBWSTWRR5       : std_logic_vector(4 downto 0) := "00000";
-- Internal version of SMTrBWSTWRR5

signal iSMTrBWSTWRR6       : std_logic_vector(4 downto 0) := "00000";
-- Internal version of SMTrBWSTWRR6
         
signal iSMTrBWSTWRR7       : std_logic_vector(4 downto 0) := "00000";
-- Internal version of SMTrBWSTWRR7

signal iSMTrBWSTOENR0      : std_logic_vector(3 downto 0) := "0000";
-- Internal version of SMTrBWSTOENR0

signal iSMTrBWSTOENR1      : std_logic_vector(3 downto 0) := "0000";
-- Internal version of SMTrBWSTOENR1

signal iSMTrBWSTOENR2      : std_logic_vector(3 downto 0) := "0000";
-- Internal version of SMTrBWSTOENR2

signal iSMTrBWSTOENR3      : std_logic_vector(3 downto 0) := "0000";
-- Internal version of SMTrBWSTOENR3

signal iSMTrBWSTOENR4      : std_logic_vector(3 downto 0) := "0000";
-- Internal version of SMTrBWSTOENR4

signal iSMTrBWSTOENR5      : std_logic_vector(3 downto 0) := "0000";
-- Internal version of SMTrBWSTOENR5

signal iSMTrBWSTOENR6      : std_logic_vector(3 downto 0) := "0000";
-- Internal version of SMTrBWSTOENR6

signal iSMTrBWSTOENR7      : std_logic_vector(3 downto 0) := "0000";
-- Internal version of SMTrBWSTOENR7

signal iSMTrBWSTWENR0      : std_logic_vector(3 downto 0) := "0000";
-- Internal version of SMTrBWSTWENR0

signal iSMTrBWSTWENR1      : std_logic_vector(3 downto 0) := "0000";
-- Internal version of SMTrBWSTWENR1

signal iSMTrBWSTWENR2      : std_logic_vector(3 downto 0) := "0000";
-- Internal version of SMTrBWSTWENR2

signal iSMTrBWSTWENR3      : std_logic_vector(3 downto 0) := "0000";
-- Internal version of SMTrBWSTWENR3

signal iSMTrBWSTWENR4      : std_logic_vector(3 downto 0) := "0000";
-- Internal version of SMTrBWSTWENR4

signal iSMTrBWSTWENR5      : std_logic_vector(3 downto 0) := "0000";
-- Internal version of SMTrBWSTWENR5

signal iSMTrBWSTWENR6      : std_logic_vector(3 downto 0) := "0000";
-- Internal version of SMTrBWSTWENR6

signal iSMTrBWSTWENR7      : std_logic_vector(3 downto 0) := "0000";
-- Internal version of SMTrBWSTWENR7

signal iSMTrBWSTBRDR0      : std_logic_vector(4 downto 0) := "00000";
-- Internal version of SMTrBWSTBRDR0

signal iSMTrBWSTBRDR1      : std_logic_vector(4 downto 0) := "00000";
-- Internal version of SMTrBWSTBRDR1

signal iSMTrBWSTBRDR2      : std_logic_vector(4 downto 0) := "00000";
-- Internal version of SMTrBWSTBRDR2

signal iSMTrBWSTBRDR3      : std_logic_vector(4 downto 0) := "00000";
-- Internal version of SMTrBWSTBRDR3

signal iSMTrBWSTBRDR4      : std_logic_vector(4 downto 0) := "00000";
-- Internal version of SMTrBWSTBRDR4

signal iSMTrBWSTBRDR5      : std_logic_vector(4 downto 0) := "00000";
-- Internal version of SMTrBWSTBRDR5

signal iSMTrBWSTBRDR6      : std_logic_vector(4 downto 0) := "00000";
-- Internal version of SMTrBWSTBRDR6

signal iSMTrBWSTBRDR7      : std_logic_vector(4 downto 0) := "00000";
-- Internal version of SMTrBWSTBRDR7

signal iSMTrBCR0  : std_logic_vector(21 downto 0) := "0000000000000000000000";
-- Internal version of SMTrBCR0

signal iSMTrBCR1  : std_logic_vector(21 downto 0) := "0000000000000000000000";
-- Internal version of SMTrBCR1

signal iSMTrBCR2  : std_logic_vector(21 downto 0):=  "0000000000000000000000";
-- Internal version of SMTrBCR2

signal iSMTrBCR3  : std_logic_vector(21 downto 0):=  "0000000000000000000000";
-- Internal version of SMTrBCR3

signal iSMTrBCR4  : std_logic_vector(21 downto 0):=  "0000000000000000000000";
-- Internal version of SMTrBCR4

signal iSMTrBCR5  : std_logic_vector(21 downto 0):=  "0000000000000000000000";
-- Internal version of SMTrBCR5

signal iSMTrBCR6  : std_logic_vector(21 downto 0):=  "0000000000000000000000";
-- Internal version of SMTrBCR6

signal iSMTrBCR7  : std_logic_vector(21 downto 0):=  "0000000000000000000000";
-- Internal version of SMTrBCR7

signal iSSMCTrMEMBASE0     : std_logic_vector(14 downto 0) := "000000000000000";
-- Internal version of SSMCTrMEMBASE0  Register

signal iSSMCTrMEMBASE1     : std_logic_vector(14 downto 0) := "000000000000000";
-- Internal version of SSMCTrMEMBASE1  Register

signal iSSMCTrMEMBASE2     : std_logic_vector(14 downto 0) := "000000000000000";
-- Internal version of SSMCTrMEMBASE2  Register

signal iSSMCTrMEMBASE3     : std_logic_vector(14 downto 0) := "000000000000000";
-- Internal version of SSMCTrMEMBASE3  Register

signal iSSMCTrMEMBASE4     : std_logic_vector(14 downto 0) := "000000000000000";
-- Internal version of SSMCTrMEMBASE4  Register

signal iSSMCTrMEMBASE5     : std_logic_vector(14 downto 0) := "000000000000000";
-- Internal version of SSMCTrMEMBASE5  Register

signal iSSMCTrMEMBASE6     : std_logic_vector(14 downto 0) := "000000000000000";
-- Internal version of SSMCTrMEMBASE6  Register

signal iSSMCTrMEMBASE7     : std_logic_vector(14 downto 0) := "000000000000000";
-- Internal version of SSMCTrMEMBASE7  Register

signal iSSMCTrBurstWT      : std_logic_vector(8 downto 0)  := "000000000";
-- Internal version of SSMCTrBurstWT Register

signal iSMMemCLKRatio      : std_logic_vector(1 downto 0)  := "00";
-- Internal version of SMMemCLKRatio Register

signal NxtSMTrBIDCYR0      : std_logic_vector(3 downto 0);
-- D-input of SMCTrIDCYR0 Register

signal NxtSMTrBIDCYR1      : std_logic_vector(3 downto 0);
-- D-input of SMCTrIDCYR1 Register

signal NxtSMTrBIDCYR2      : std_logic_vector(3 downto 0);
-- D-input of SMCTrIDCYR2 Register

signal NxtSMTrBIDCYR3      : std_logic_vector(3 downto 0);
-- D-input of SMCTrIDCYR3 Register

signal NxtSMTrBIDCYR4      : std_logic_vector(3 downto 0); 
-- D-input of SMCTrIDCYR4 Register

signal NxtSMTrBIDCYR5      : std_logic_vector(3 downto 0);
-- D-input of SMCTrIDCYR5 Register

signal NxtSMTrBIDCYR6      : std_logic_vector(3 downto 0);
-- D-input of SMCTrIDCYR6 Register

signal NxtSMTrBIDCYR7      : std_logic_vector(3 downto 0);
-- D-input of SMCTrIDCYR7 Register

signal NxtSMTrBWSTRDR0     : std_logic_vector(4 downto 0);
-- D-input of SMTrBWSTRDR0

signal NxtSMTrBWSTRDR1     : std_logic_vector(4 downto 0);
-- D-input of SMTrBWSTRDR1

signal NxtSMTrBWSTRDR2     : std_logic_vector(4 downto 0);
-- D-input of SMTrBWSTRDR1

signal NxtSMTrBWSTRDR3     : std_logic_vector(4 downto 0);
-- D-input of SMTrBWSTRDR3

signal NxtSMTrBWSTRDR4     : std_logic_vector(4 downto 0);
-- D-input of SMTrBWSTRDR4

signal NxtSMTrBWSTRDR5     : std_logic_vector(4 downto 0);
-- D-input of SMTrBWSTRDR5

signal NxtSMTrBWSTRDR6     : std_logic_vector(4 downto 0);
-- D-input of SMTrBWSTRDR6

signal NxtSMTrBWSTRDR7     : std_logic_vector(4 downto 0);
-- D-input of SMTrBWSTRDR7

signal NxtSMTrBWSTWRR0     : std_logic_vector(4 downto 0);
-- D-input of SMTrBWSTWRR0

signal NxtSMTrBWSTWRR1     : std_logic_vector(4 downto 0);
-- D-input of SMTrBWSTWRR1

signal NxtSMTrBWSTWRR2     : std_logic_vector(4 downto 0);
-- D-input of SMTrBWSTWRR2

signal NxtSMTrBWSTWRR3     : std_logic_vector(4 downto 0);
-- D-input of SMTrBWSTWRR3

signal NxtSMTrBWSTWRR4     : std_logic_vector(4 downto 0);
-- D-input of SMTrBWSTWRR4

signal NxtSMTrBWSTWRR5     : std_logic_vector(4 downto 0);
-- D-input of SMTrBWSTWRR5

signal NxtSMTrBWSTWRR6     : std_logic_vector(4 downto 0);
-- D-input of SMTrBWSTWRR6

signal NxtSMTrBWSTWRR7     : std_logic_vector(4 downto 0);
-- D-input of SMTrBWSTWRR7

signal NxtSMTrBWSTOENR0    : std_logic_vector(3 downto 0);
-- D-input of SMTrBWSTOENR0

signal NxtSMTrBWSTOENR1    : std_logic_vector(3 downto 0);
-- D-input of SMTrBWSTOENR1

signal NxtSMTrBWSTOENR2    : std_logic_vector(3 downto 0);
-- D-input of SMTrBWSTOENR2

signal NxtSMTrBWSTOENR3    : std_logic_vector(3 downto 0);
-- D-input of SMTrBWSTOENR3

signal NxtSMTrBWSTOENR4    : std_logic_vector(3 downto 0);
-- D-input of SMTrBWSTOENR4

signal NxtSMTrBWSTOENR5    : std_logic_vector(3 downto 0);
-- D-input of SMTrBWSTOENR5

signal NxtSMTrBWSTOENR6    : std_logic_vector(3 downto 0);
-- D-input of SMTrBWSTOENR6

signal NxtSMTrBWSTOENR7    : std_logic_vector(3 downto 0);
-- D-input of SMTrBWSTOENR7

signal NxtSMTrBWSTWENR0    : std_logic_vector(3 downto 0);
-- D-input of SMTrBWSTWENR0

signal NxtSMTrBWSTWENR1    : std_logic_vector(3 downto 0);
-- D-input of SMTrBWSTWENR1

signal NxtSMTrBWSTWENR2    : std_logic_vector(3 downto 0);
-- D-input of SMTrBWSTWENR2

signal NxtSMTrBWSTWENR3    : std_logic_vector(3 downto 0);
-- D-input of SMTrBWSTWENR3

signal NxtSMTrBWSTWENR4    : std_logic_vector(3 downto 0);
-- D-input of SMTrBWSTWENR4

signal NxtSMTrBWSTWENR5    : std_logic_vector(3 downto 0);
-- D-input of SMTrBWSTWENR5

signal NxtSMTrBWSTWENR6    : std_logic_vector(3 downto 0);
-- D-input of SMTrBWSTWENR6

signal NxtSMTrBWSTWENR7    : std_logic_vector(3 downto 0);
-- D-input of SMTrBWSTWENR7

signal NxtSMTrBWSTBRDR0    : std_logic_vector(4 downto 0);
-- D-input of SMTrBWSTBRDR0

signal NxtSMTrBWSTBRDR1    : std_logic_vector(4 downto 0);
-- D-input of SMTrBWSTBRDR1

signal NxtSMTrBWSTBRDR2    : std_logic_vector(4 downto 0);
-- D-input of SMTrBWSTBRDR2

signal NxtSMTrBWSTBRDR3    : std_logic_vector(4 downto 0);
-- D-input 0f SMTrBWSTBRDR3

signal NxtSMTrBWSTBRDR4    : std_logic_vector(4 downto 0);
-- D-input of SMTrBWSTBRDR4

signal NxtSMTrBWSTBRDR5    : std_logic_vector(4 downto 0);
-- D-input of SMTrBWSTBRDR5

signal NxtSMTrBWSTBRDR6    : std_logic_vector(4 downto 0);
-- D-input of SMTrBWSTBRDR6

signal NxtSMTrBWSTBRDR7    : std_logic_vector(4 downto 0);
-- D-input of SMTrBWSTBRDR7

signal NxtSMTrBCR0         : std_logic_vector(21 downto 0);
-- D-input of SMTrBCR0

signal NxtSMTrBCR1         : std_logic_vector(21 downto 0);
-- D-input of SMTrBCR1

signal NxtSMTrBCR2         : std_logic_vector(21 downto 0);
-- D-input of SMTrBCR2

signal NxtSMTrBCR3  	   : std_logic_vector(21 downto 0);
-- D-input of SMTrBCR3

signal NxtSMTrBCR4  	   : std_logic_vector(21 downto 0);
-- D-input of SMTrBCR4

signal NxtSMTrBCR5  	   : std_logic_vector(21 downto 0);
-- D-input of SMTrBCR5

signal NxtSMTrBCR6  	   : std_logic_vector(21 downto 0);
-- D-input of SMTrBCR6

signal NxtSMTrBCR7  	   : std_logic_vector(21 downto 0);
-- D-input of SMTrBCR7

signal NxtSSMCTrMEMBASE0   : std_logic_vector(14 downto 0);
-- D-input of SSMCTrMEMBASE0  Register

signal NxtSSMCTrMEMBASE1   : std_logic_vector(14 downto 0);
-- D-input of SSMCTrMEMBASE1  Register

signal NxtSSMCTrMEMBASE2   : std_logic_vector(14 downto 0);
-- D-input of SSMCTrMEMBASE2  Register

signal NxtSSMCTrMEMBASE3   : std_logic_vector(14 downto 0);
-- D-input of SSMCTrMEMBASE3  Register

signal NxtSSMCTrMEMBASE4   : std_logic_vector(14 downto 0);
-- D-input of SSMCTrMEMBASE4  Register

signal NxtSSMCTrMEMBASE5   : std_logic_vector(14 downto 0);
-- D-input of SSMCTrMEMBASE5  Register

signal NxtSSMCTrMEMBASE6   : std_logic_vector(14 downto 0);
-- D-input of SSMCTrMEMBASE6  Register

signal NxtSSMCTrMEMBASE7   : std_logic_vector(14 downto 0);
-- D-input of SSMCTrMEMBASE7  Register

signal NxtSSMCTrBurstWT    : std_logic_vector(8 downto 0);
-- D-input of SSMCTrBurstWT Register

signal NxtSMMemCLKRatio    : std_logic_vector(1 downto 0);
-- D-input of SMMemCLKRatio Register
  
signal RdEn                : std_logic;
-- Read enable signal

signal RdRegEn             : std_logic;
-- Read enable signal for mirror registers

signal SSMCTrMEMARRAY0Rd   : std_logic;
-- SSMCTrMEMARRAY Read

signal SSMCTrMEMARRAY1Rd   : std_logic;
-- SSMCTrMEMARRAY Read

signal SSMCTrMEMARRAY2Rd   : std_logic;
-- SSMCTrMEMARRAY Read

signal SSMCTrMEMARRAY3Rd   : std_logic;
-- SSMCTrMEMARRAY Read

signal SSMCTrMEMARRAY4Rd   : std_logic;
-- SSMCTrMEMARRAY Read

signal SSMCTrMEMARRAY5Rd   : std_logic;
-- SSMCTrMEMARRAY Read

signal SSMCTrMEMARRAY6Rd   : std_logic;
-- SSMCTrMEMARRAY Read

signal SSMCTrMEMARRAY7Rd   : std_logic;
-- SSMCTrMEMARRAY Read

signal SMTrBIDCYR0Rd       : std_logic;
-- SMCTrIDCYR0 Read

signal SMTrBIDCYR1Rd       : std_logic;
-- SMCTrIDCYR1 Read

signal SMTrBIDCYR2Rd       : std_logic;
-- SMCTrIDCYR2 Read

signal SMTrBIDCYR3Rd       : std_logic;
-- SMCTrIDCYR3 Read

signal SMTrBIDCYR4Rd       : std_logic;
-- SMCTrIDCYR4 Read

signal SMTrBIDCYR5Rd       : std_logic;
-- SMCTrIDCYR5 Read

signal SMTrBIDCYR6Rd       : std_logic;
-- SMCTrIDCYR6 Read

signal SMTrBIDCYR7Rd       : std_logic;
-- SMCTrIDCYR7 Read

signal SMTrBWSTRDR0Rd      : std_logic;
-- SMTrBWSTRDR0 Read

signal SMTrBWSTRDR1Rd      : std_logic;
--SMTrBWSTRDR1 Read

signal SMTrBWSTRDR2Rd      : std_logic;
-- SMTrBWSTRDR1 Read

signal SMTrBWSTRDR3Rd      : std_logic;
-- SMTrBWSTRDR3 Read

signal SMTrBWSTRDR4Rd      : std_logic;
-- SMTrBWSTRDR4 Read

signal SMTrBWSTRDR5Rd      : std_logic;
-- SMTrBWSTRDR5 Read

signal SMTrBWSTRDR6Rd      : std_logic;
-- SMTrBWSTRDR6 Read

signal SMTrBWSTRDR7Rd      : std_logic;
-- SMTrBWSTRDR7 Read

signal SMTrBWSTWRR0Rd      : std_logic;
-- SMTrBWSTWRR0 Read

signal SMTrBWSTWRR1Rd      : std_logic;
-- SMTrBWSTWRR1 Read

signal SMTrBWSTWRR2Rd      : std_logic;
-- SMTrBWSTWRR2 Read

signal SMTrBWSTWRR3Rd      : std_logic;
-- SMTrBWSTWRR3 Read

signal SMTrBWSTWRR4Rd      : std_logic;
-- SMTrBWSTWRR4 Read

signal SMTrBWSTWRR5Rd      : std_logic;
-- SMTrBWSTWRR5 Read

signal SMTrBWSTWRR6Rd      : std_logic;
-- SMTrBWSTWRR6 Read

signal SMTrBWSTWRR7Rd      : std_logic;
-- SMTrBWSTWRR7 Read

signal SMTrBWSTOENR0Rd     : std_logic;
-- SMTrBWSTOENR0 Read

signal SMTrBWSTOENR1Rd     : std_logic;
-- SMTrBWSTOENR1 Read

signal SMTrBWSTOENR2Rd     : std_logic;
-- SMTrBWSTOENR2 Read

signal SMTrBWSTOENR3Rd     : std_logic;
-- SMTrBWSTOENR3 Read

signal SMTrBWSTOENR4Rd     : std_logic;
-- SMTrBWSTOENR4 Read

signal SMTrBWSTOENR5Rd     : std_logic;
-- SMTrBWSTOENR5 Read

signal SMTrBWSTOENR6Rd     : std_logic;
-- SMTrBWSTOENR6 Read 

signal SMTrBWSTOENR7Rd     : std_logic;
-- SMTrBWSTOENR7 Read

signal SMTrBWSTWENR0Rd     : std_logic;
-- SMTrBWSTWENR0 Read

signal SMTrBWSTWENR1Rd     : std_logic;
-- SMTrBWSTWENR1 Read

signal SMTrBWSTWENR2Rd     : std_logic;
-- SMTrBWSTWENR2 Read

signal SMTrBWSTWENR3Rd     : std_logic;
-- SMTrBWSTWENR3 Read

signal SMTrBWSTWENR4Rd     : std_logic;
-- SMTrBWSTWENR4 Read

signal SMTrBWSTWENR5Rd     : std_logic;
-- SMTrBWSTWENR5 Read

signal SMTrBWSTWENR6Rd     : std_logic;
-- SMTrBWSTWENR6 Read

signal SMTrBWSTWENR7Rd     : std_logic;
-- SMTrBWSTWENR7 Read

signal SMTrBWSTBRDR0Rd     : std_logic;
-- SMTrBWSTBRDR0 Read

signal SMTrBWSTBRDR1Rd     : std_logic;
-- SMTrBWSTBRDR1 Read

signal SMTrBWSTBRDR2Rd     : std_logic;
-- SMTrBWSTBRDR2 Read

signal SMTrBWSTBRDR3Rd     : std_logic;
-- SMTrBWSTBRDR3 Read

signal SMTrBWSTBRDR4Rd     : std_logic;
-- SMTrBWSTBRDR4 Read

signal SMTrBWSTBRDR5Rd     : std_logic;
-- SMTrBWSTBRDR5 Read

signal SMTrBWSTBRDR6Rd     : std_logic;
-- SMTrBWSTBRDR6 Read

signal SMTrBWSTBRDR7Rd     : std_logic;
-- SMTrBWSTBRDR7 Read

signal SMTrBCR0Rd          : std_logic;
-- SMTrBCR0 Read

signal SMTrBCR1Rd          : std_logic;
-- SMTrBCR1 Read

signal SMTrBCR2Rd          : std_logic;
-- SMTrBCR2 Read

signal SMTrBCR3Rd          : std_logic;
-- SMTrBCR3 Read

signal SMTrBCR4Rd          : std_logic;
-- SMTrBCR4 Read

signal SMTrBCR5Rd          : std_logic;
-- SMTrBCR5 Read

signal SMTrBCR6Rd          : std_logic;
-- SMTrBCR6 Read

signal SMTrBCR7Rd          : std_logic;
-- SMTrBCR7 Read

signal SSMCTrMEMBASE0Rd    : std_logic;
-- SSMCTrMEMBASE0  Read

signal SSMCTrMEMBASE1Rd    : std_logic;
-- SSMCTrMEMBASE1  Read

signal SSMCTrMEMBASE2Rd    : std_logic;
-- SSMCTrMEMBASE2  Read

signal SSMCTrMEMBASE3Rd    : std_logic;
-- SSMCTrMEMBASE3  Read

signal SSMCTrMEMBASE4Rd    : std_logic;
-- SSMCTrMEMBASE4  Read

signal SSMCTrMEMBASE5Rd    : std_logic;
-- SSMCTrMEMBASE5  Read

signal SSMCTrMEMBASE6Rd    : std_logic;
-- SSMCTrMEMBASE6  Read

signal SSMCTrMEMBASE7Rd    : std_logic;
-- SSMCTrMEMBASE7  Read

signal SSMCTrBurstWTRd     : std_logic;
-- SSMCTrBurstWT Read

signal SMMemCLKRatioRd     : std_logic;
-- SMMemCLKRatio Read

signal WrEn                : std_logic;
-- Write enable signal

signal WrRegEn             : std_logic;
-- Write enable signal for mirror REgisters
 
signal SMTrBIDCYR0Wr       : std_logic;
-- SMCTrIDCYR0 Write

signal SMTrBIDCYR1Wr       : std_logic;
-- SMCTrIDCYR1 Write

signal SMTrBIDCYR2Wr       : std_logic;
-- SMCTrIDCYR2 Write

signal SMTrBIDCYR3Wr       : std_logic;
-- SMCTrIDCYR3 Write

signal SMTrBIDCYR4Wr       : std_logic;
-- SMCTrIDCYR4 Write

signal SMTrBIDCYR5Wr       : std_logic;
-- SMCTrIDCYR5 Write

signal SMTrBIDCYR6Wr       : std_logic;
-- SMCTrIDCYR6 Write

signal SMTrBIDCYR7Wr       : std_logic;
-- SMCTrIDCYR7 Write

signal SMTrBWSTRDR0Wr      : std_logic;
-- SMTrBWSTRDR0 Write

signal SMTrBWSTRDR1Wr      : std_logic;
--SMTrBWSTRDR1 Write

signal SMTrBWSTRDR2Wr      : std_logic;
-- SMTrBWSTRDR1 Write

signal SMTrBWSTRDR3Wr      : std_logic;
-- SMTrBWSTRDR3 Write

signal SMTrBWSTRDR4Wr      : std_logic;
-- SMTrBWSTRDR4 Write

signal SMTrBWSTRDR5Wr      : std_logic;
-- SMTrBWSTRDR5 Write

signal SMTrBWSTRDR6Wr      : std_logic;
-- SMTrBWSTRDR6 Write

signal SMTrBWSTRDR7Wr      : std_logic;
-- SMTrBWSTRDR7 Write

signal SMTrBWSTWRR0Wr      : std_logic;
-- SMTrBWSTWRR0 Write

signal SMTrBWSTWRR1Wr      : std_logic;
-- SMTrBWSTWRR1 Write

signal SMTrBWSTWRR2Wr      : std_logic;
-- SMTrBWSTWRR2 Write

signal SMTrBWSTWRR3Wr      : std_logic;
-- SMTrBWSTWRR3 Write

signal SMTrBWSTWRR4Wr      : std_logic;
-- SMTrBWSTWRR4 Write

signal SMTrBWSTWRR5Wr      : std_logic;
-- SMTrBWSTWRR5 Write

signal SMTrBWSTWRR6Wr      : std_logic;
-- SMTrBWSTWRR6 Write

signal SMTrBWSTWRR7Wr      : std_logic;
-- SMTrBWSTWRR7 Write

signal SMTrBWSTOENR0Wr     : std_logic;
-- SMTrBWSTOENR0 Write

signal SMTrBWSTOENR1Wr     : std_logic;
-- SMTrBWSTOENR1 Write

signal SMTrBWSTOENR2Wr     : std_logic;
-- SMTrBWSTOENR2 Write

signal SMTrBWSTOENR3Wr     : std_logic;
-- SMTrBWSTOENR3 Write

signal SMTrBWSTOENR4Wr     : std_logic;
-- SMTrBWSTOENR4 Write

signal SMTrBWSTOENR5Wr     : std_logic;
-- SMTrBWSTOENR5 Write

signal SMTrBWSTOENR6Wr     : std_logic;
-- SMTrBWSTOENR6 Write

signal SMTrBWSTOENR7Wr     : std_logic;
-- SMTrBWSTOENR7 Write

signal SMTrBWSTWENR0Wr     : std_logic;
-- SMTrBWSTWENR0 Write

signal SMTrBWSTWENR1Wr     : std_logic;
-- SMTrBWSTWENR1 Write

signal SMTrBWSTWENR2Wr     : std_logic;
-- SMTrBWSTWENR2 Write

signal SMTrBWSTWENR3Wr     : std_logic;
-- SMTrBWSTWENR3 Write

signal SMTrBWSTWENR4Wr     : std_logic;
-- SMTrBWSTWENR4 Write

signal SMTrBWSTWENR5Wr     : std_logic;
-- SMTrBWSTWENR5 Write

signal SMTrBWSTWENR6Wr     : std_logic;
-- SMTrBWSTWENR6 Write

signal SMTrBWSTWENR7Wr     : std_logic;
-- SMTrBWSTWENR7 Write

signal SMTrBWSTBRDR0Wr     : std_logic;
-- SMTrBWSTBRDR0 Write

signal SMTrBWSTBRDR1Wr     : std_logic;
-- SMTrBWSTBRDR1 Write

signal SMTrBWSTBRDR2Wr     : std_logic;
-- SMTrBWSTBRDR2 Write

signal SMTrBWSTBRDR3Wr     : std_logic;
-- SMTrBWSTBRDR3 Write

signal SMTrBWSTBRDR4Wr     : std_logic;
-- SMTrBWSTBRDR4 Write

signal SMTrBWSTBRDR5Wr     : std_logic;
-- SMTrBWSTBRDR5 Write

signal SMTrBWSTBRDR6Wr     : std_logic;
-- SMTrBWSTBRDR6 Write

signal SMTrBWSTBRDR7Wr     : std_logic;
-- SMTrBWSTBRDR7 Write

signal SMTrBCR0Wr          : std_logic;
-- SMTrBCR0 Write

signal SMTrBCR1Wr          : std_logic;
-- SMTrBCR1 Write

signal SMTrBCR2Wr          : std_logic;
-- SMTrBCR2 Write

signal SMTrBCR3Wr          : std_logic;
-- SMTrBCR3 Write

signal SMTrBCR4Wr          : std_logic;
-- SMTrBCR4 Write

signal SMTrBCR5Wr          : std_logic;
-- SMTrBCR5 Write

signal SMTrBCR6Wr          : std_logic;
-- SMTrBCR6 Write

signal SMTrBCR7Wr          : std_logic;
-- SMTrBCR7 Write

signal SSMCTrMEMBASE0Wr    : std_logic;
-- SSMCTrMEMBASE0 Write

signal SSMCTrMEMBASE1Wr    : std_logic;
-- SSMCTrMEMBASE1 Write

signal SSMCTrMEMBASE2Wr    : std_logic;
-- SSMCTrMEMBASE2 Write

signal SSMCTrMEMBASE3Wr    : std_logic;
-- SSMCTrMEMBASE3 Write

signal SSMCTrMEMBASE4Wr    : std_logic;
-- SSMCTrMEMBASE4 Write

signal SSMCTrMEMBASE5Wr    : std_logic;
-- SSMCTrMEMBASE5 Write

signal SSMCTrMEMBASE6Wr    : std_logic;
-- SSMCTrMEMBASE6 Write

signal SSMCTrMEMBASE7Wr    : std_logic;
-- SSMCTrMEMBASE7 Write

signal SSMCTrBurstWTWr     : std_logic;
-- SSMCTrBurstWT Write

signal SMMemCLKRatioWr     : std_logic;
-- SMMemCLKRatio Write

signal ErrorLat            : std_logic := '0';
-- Latch error condition


-- ----------------------------------------------------------------------------
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
-- Write enable for registers
-- -----------------------------------------------------------------------------
SSMCTrMEMARRAY0Wr  <= '1' when ((WrEn = '1') and
                            (iLatchHADDR(17 downto 13) = HADDR_SSMCTrMEMARRAY0))
                 else
                    '0';
SSMCTrMEMARRAY1Wr  <= '1' when ((WrEn = '1') and
                            (iLatchHADDR(17 downto 13) = HADDR_SSMCTrMEMARRAY1))
                 else
                    '0';
SSMCTrMEMARRAY2Wr  <= '1' when ((WrEn = '1') and
                            (iLatchHADDR(17 downto 13) = HADDR_SSMCTrMEMARRAY2))
                 else
                    '0';
SSMCTrMEMARRAY3Wr  <= '1' when ((WrEn = '1') and
                            (iLatchHADDR(17 downto 13) = HADDR_SSMCTrMEMARRAY3))
                 else
                    '0';
SSMCTrMEMARRAY4Wr  <= '1' when ((WrEn = '1') and
                            (iLatchHADDR(17 downto 13) = HADDR_SSMCTrMEMARRAY4))
                 else
                    '0';
SSMCTrMEMARRAY5Wr  <= '1' when ((WrEn = '1') and
                            (iLatchHADDR(17 downto 13) = HADDR_SSMCTrMEMARRAY5))
                 else
                    '0';
SSMCTrMEMARRAY6Wr  <= '1' when ((WrEn = '1') and
                            (iLatchHADDR(17 downto 13) = HADDR_SSMCTrMEMARRAY6))
                 else
                    '0';
SSMCTrMEMARRAY7Wr  <= '1' when ((WrEn = '1') and
                            (iLatchHADDR(17 downto 13) = HADDR_SSMCTrMEMARRAY7))
                 else
                    '0';

SMTrBIDCYR0Wr      <= '1' when ((WrRegEn = '1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBIDCYR0))
                 else
                    '0';
SMTrBIDCYR1Wr      <= '1' when ((WrRegEn = '1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBIDCYR1))
                 else
                    '0'; 
SMTrBIDCYR2Wr      <= '1' when ((WrRegEn = '1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBIDCYR2))
                 else
                    '0';
SMTrBIDCYR3Wr      <= '1' when ((WrRegEn = '1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBIDCYR3))
                 else
                    '0';
SMTrBIDCYR4Wr      <= '1' when ((WrRegEn = '1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBIDCYR4))
                 else
                    '0';
SMTrBIDCYR5Wr      <= '1' when ((WrRegEn = '1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBIDCYR5))
                 else
                    '0';
SMTrBIDCYR6Wr      <= '1' when ((WrRegEn = '1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBIDCYR6))
                 else
                    '0';
SMTrBIDCYR7Wr      <= '1' when ((WrRegEn = '1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBIDCYR7))
                 else
                    '0';
SMTrBWSTRDR0Wr     <= '1' when ((WrRegEn = '1') and
                            (iLatchHADDR(9 downto 2) = HADDR_SMTrBWSTRDR0))
                 else
                    '0';
SMTrBWSTRDR1Wr     <= '1' when ((WrRegEn = '1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTRDR1))
                 else
                    '0';
SMTrBWSTRDR2Wr     <= '1' when ((WrRegEn = '1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTRDR2))
                 else
                    '0';
SMTrBWSTRDR3Wr     <= '1' when ((WrRegEn = '1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTRDR3))
                 else
                    '0';
SMTrBWSTRDR4Wr     <= '1' when ((WrRegEn = '1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTRDR4))
                 else
                    '0';
SMTrBWSTRDR5Wr     <= '1' when ((WrRegEn = '1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTRDR5))
                 else
                    '0';
SMTrBWSTRDR6Wr     <= '1' when ((WrRegEn = '1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTRDR6))
                 else
                    '0';
SMTrBWSTRDR7Wr     <= '1' when ((WrRegEn = '1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTRDR7))
                 else
                    '0';
SMTrBWSTWRR0Wr     <= '1' when ((WrRegEn ='1') and 
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTWRR0))
                 else
                    '0';
SMTrBWSTWRR1Wr     <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTWRR1))
                 else
                    '0';
SMTrBWSTWRR2Wr     <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTWRR2))
                 else
                    '0';
SMTrBWSTWRR3Wr     <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTWRR3))
                 else
                    '0';
SMTrBWSTWRR4Wr     <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTWRR4))
                 else
                    '0';
SMTrBWSTWRR5Wr     <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTWRR5))
                 else
                    '0';
SMTrBWSTWRR6Wr     <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTWRR6))
                 else
                    '0';
SMTrBWSTWRR7Wr     <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTWRR7))
                 else
                    '0';
SMTrBWSTOENR0Wr    <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTOENR0))
                 else
                    '0';
SMTrBWSTOENR1Wr    <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTOENR1))
                 else
                    '0';
SMTrBWSTOENR2Wr    <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTOENR2))
                 else
                    '0';
SMTrBWSTOENR3Wr    <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTOENR3))
                 else
                    '0';
SMTrBWSTOENR4Wr    <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTOENR4))
                 else
                    '0';
SMTrBWSTOENR5Wr    <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTOENR5))
                 else
                    '0';
SMTrBWSTOENR6Wr    <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTOENR6))
                 else
                    '0';
SMTrBWSTOENR7Wr    <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTOENR7))
                 else
                    '0';
SMTrBWSTWENR0Wr    <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTWENR0))
                 else
                    '0';
SMTrBWSTWENR1Wr    <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTWENR1))
                 else
                    '0';
SMTrBWSTWENR2Wr    <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTWENR2))
                 else
                    '0';
SMTrBWSTWENR3Wr    <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTWENR3))
                 else
                    '0';
SMTrBWSTWENR4Wr    <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTWENR4))
                 else
                    '0';
SMTrBWSTWENR5Wr    <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTWENR5))
                 else
                    '0';
SMTrBWSTWENR6Wr    <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTWENR6))
                 else
                    '0';
SMTrBWSTWENR7Wr    <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTWENR7))
                 else
                    '0';
SMTrBWSTBRDR0Wr    <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTBRDR0))
                 else
                    '0';
SMTrBWSTBRDR1Wr    <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTBRDR1))
                 else
                    '0';
SMTrBWSTBRDR2Wr    <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTBRDR2))
                 else
                    '0';
SMTrBWSTBRDR3Wr    <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTBRDR3))
                 else
                    '0';
SMTrBWSTBRDR4Wr    <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTBRDR4))
                 else
                    '0';
SMTrBWSTBRDR5Wr    <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTBRDR5))
                 else
                    '0';
SMTrBWSTBRDR6Wr    <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTBRDR6))
                 else
                    '0';
SMTrBWSTBRDR7Wr    <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBWSTBRDR7))
                 else
                    '0';
SMTrBCR0Wr         <= '1' when ((WrRegEn ='1') and 
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBCR0 ))
                 else 
                    '0';
SMTrBCR1Wr         <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBCR1 ))
                 else
                    '0';
SMTrBCR2Wr         <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBCR2 ))
                 else
                    '0';
SMTrBCR3Wr         <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBCR3 ))
                 else
                    '0';
SMTrBCR4Wr         <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBCR4 ))
                 else
                    '0';
SMTrBCR5Wr         <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBCR5 ))
                 else
                    '0';
SMTrBCR6Wr         <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBCR6 ))
                 else
                    '0';
SMTrBCR7Wr         <= '1' when ((WrRegEn ='1') and
                            (iLatchHADDR(7 downto 2) = HADDR_SMTrBCR7 ))
                 else
                    '0';
SSMCTrMEMBASE0Wr   <= '1' when ((WrEn ='1') and
                            (iLatchHADDR(17 downto 13) = HADDR_SSMCTrMEMBASE0 ))
                 else    
                    '0';
SSMCTrMEMBASE1Wr   <= '1' when ((WrEn ='1') and
                            (iLatchHADDR(17 downto 13) = HADDR_SSMCTrMEMBASE1 ))
                 else
                    '0';
SSMCTrMEMBASE2Wr   <= '1' when ((WrEn ='1') and
                            (iLatchHADDR(17 downto 13) = HADDR_SSMCTrMEMBASE2 ))
                 else
                    '0';
SSMCTrMEMBASE3Wr   <= '1' when ((WrEn ='1') and
                            (iLatchHADDR(17 downto 13) = HADDR_SSMCTrMEMBASE3 ))
                 else
                    '0';
SSMCTrMEMBASE4Wr   <= '1' when ((WrEn ='1') and
                            (iLatchHADDR(17 downto 13) = HADDR_SSMCTrMEMBASE4 ))
                 else
                    '0';
SSMCTrMEMBASE5Wr   <= '1' when ((WrEn ='1') and
                            (iLatchHADDR(17 downto 13) = HADDR_SSMCTrMEMBASE5 ))
                 else
                    '0';
SSMCTrMEMBASE6Wr   <= '1' when ((WrEn ='1') and
                            (iLatchHADDR(17 downto 13) = HADDR_SSMCTrMEMBASE6 ))
                 else
                    '0';
SSMCTrMEMBASE7Wr   <= '1' when ((WrEn ='1') and
                            (iLatchHADDR(17 downto 13) = HADDR_SSMCTrMEMBASE7 ))
                 else
                    '0';
SSMCTrBurstWTWr    <= '1' when ((WrEn ='1') and
                            (iLatchHADDR(17 downto 13) = HADDR_SSMCTrBurstWT  ))
                 else
                    '0';
SMMemCLKRatioWr    <= '1' when ((WrEn = '1') and
                            (iLatchHADDR(17 downto 13) = HADDR_SMMemCLKRatio  ))
                 else
                    '0';
-- -----------------------------------------------------------------------------
-- Read enable for registers
-- -----------------------------------------------------------------------------
SSMCTrMEMARRAY0Rd   <= '1' when ((RdEn = '1') and
                            (iLatchHADDR(17 downto 13) = HADDR_SSMCTrMEMARRAY0))
                 else
                    '0';
SSMCTrMEMARRAY1Rd   <= '1' when ((RdEn = '1') and
                            (iLatchHADDR(17 downto 13) = HADDR_SSMCTrMEMARRAY1))
                 else
                    '0';
SSMCTrMEMARRAY2Rd   <= '1' when ((RdEn = '1') and
                            (iLatchHADDR(17 downto 13) = HADDR_SSMCTrMEMARRAY2))
                 else
                    '0';
SSMCTrMEMARRAY3Rd   <= '1' when ((RdEn = '1') and
                            (iLatchHADDR(17 downto 13) = HADDR_SSMCTrMEMARRAY3))
                 else
                    '0';
SSMCTrMEMARRAY4Rd   <= '1' when ((RdEn = '1') and
                            (iLatchHADDR(17 downto 13) = HADDR_SSMCTrMEMARRAY4))
                 else
                    '0';
SSMCTrMEMARRAY5Rd   <= '1' when ((RdEn = '1') and
                            (iLatchHADDR(17 downto 13) = HADDR_SSMCTrMEMARRAY5))
                 else
                    '0';
SSMCTrMEMARRAY6Rd   <= '1' when ((RdEn = '1') and
                            (iLatchHADDR(17 downto 13) = HADDR_SSMCTrMEMARRAY6))
                 else
                    '0';
SSMCTrMEMARRAY7Rd   <= '1' when ((RdEn = '1') and
                            (iLatchHADDR(17 downto 13) = HADDR_SSMCTrMEMARRAY7))
                 else
                    '0';
SSMCTrMEMBASE0Rd    <= '1' when ((RdEn ='1') and
                            (iLatchHADDR(17 downto 13) = HADDR_SSMCTrMEMBASE0 ))
                 else
                    '0';
SSMCTrMEMBASE1Rd    <= '1' when ((RdEn ='1') and
                            (iLatchHADDR(17 downto 13) = HADDR_SSMCTrMEMBASE1 ))
                 else
                    '0';
SSMCTrMEMBASE2Rd    <= '1' when ((RdEn ='1') and
                            (iLatchHADDR(17 downto 13) = HADDR_SSMCTrMEMBASE2 ))
                 else
                    '0';
SSMCTrMEMBASE3Rd    <= '1' when ((RdEn ='1') and
                            (iLatchHADDR(17 downto 13) = HADDR_SSMCTrMEMBASE3 ))
                 else
                    '0';
SSMCTrMEMBASE4Rd    <= '1' when ((RdEn ='1') and
                            (iLatchHADDR(17 downto 13) = HADDR_SSMCTrMEMBASE4 ))
                 else
                    '0';
SSMCTrMEMBASE5Rd    <= '1' when ((RdEn ='1') and
                            (iLatchHADDR(17 downto 13) = HADDR_SSMCTrMEMBASE5 ))
                 else
                    '0';
SSMCTrMEMBASE6Rd    <= '1' when ((RdEn ='1') and
                            (iLatchHADDR(17 downto 13) = HADDR_SSMCTrMEMBASE6 ))
                 else
                    '0';
SSMCTrMEMBASE7Rd    <= '1' when ((RdEn ='1') and
                            (iLatchHADDR(17 downto 13) = HADDR_SSMCTrMEMBASE7 ))
                 else
                    '0';
SSMCTrBurstWTRd     <= '1' when ((RdEn ='1') and
                            (iLatchHADDR(17 downto 13) = HADDR_SSMCTrBurstWT  ))
                 else
                    '0';
SMMemCLKRatioRd     <= '1' when ((RdEn ='1') and 
                            (iLatchHADDR(17 downto 13) = HADDR_SMMemCLKRatio  ))
                  else
                     '0'; 

-- -----------------------------------------------------------------------------
-- Output Mux
-- When the peripheral is not being accessed, '0's are driven
-- on the Read Databus (HRDATA)
-- -----------------------------------------------------------------------------
HRDATATr          <= AhbRdDataDW0 when
                                (SSMCTrMEMARRAY0Rd = '1')
                 else
                     AhbRdDataDW1 when
                                (SSMCTrMEMARRAY1Rd = '1')
                 else
                     AhbRdDataDW2 when
                                (SSMCTrMEMARRAY2Rd = '1')
                 else
                     AhbRdDataDW3 when
                                (SSMCTrMEMARRAY3Rd = '1')
                 else
                     AhbRdDataDW4 when
                                (SSMCTrMEMARRAY4Rd = '1')
                 else
                     AhbRdDataDW5 when
                                (SSMCTrMEMARRAY5Rd = '1')
                 else
                     AhbRdDataDW6 when
                                (SSMCTrMEMARRAY6Rd = '1')
                 else
                     AhbRdDataDW7 when
                                (SSMCTrMEMARRAY7Rd = '1')
                 else

                    ZEROFILL(31 downto 15) & iSSMCTrMEMBASE0 when
                                (SSMCTrMEMBASE0Rd = '1')
                 else
                    ZEROFILL(31 downto 15) & iSSMCTrMEMBASE1 when
                                (SSMCTrMEMBASE1Rd = '1')
                 else
                    ZEROFILL(31 downto 15) & iSSMCTrMEMBASE2 when
                                (SSMCTrMEMBASE2Rd = '1')
                 else
                    ZEROFILL(31 downto 15) & iSSMCTrMEMBASE3 when
                                (SSMCTrMEMBASE3Rd = '1')
                 else
                    ZEROFILL(31 downto 15) & iSSMCTrMEMBASE4 when
                                (SSMCTrMEMBASE4Rd = '1')
                 else
                    ZEROFILL(31 downto 15) & iSSMCTrMEMBASE5 when
                                (SSMCTrMEMBASE5Rd = '1')
                 else
                    ZEROFILL(31 downto 15) & iSSMCTrMEMBASE6 when
                                (SSMCTrMEMBASE6Rd = '1')
                 else
                    ZEROFILL(31 downto 15) & iSSMCTrMEMBASE7 when
                                (SSMCTrMEMBASE7Rd = '1')
                 else
                    ZEROFILL(31 downto 9)  & iSSMCTrBurstWT when
                                (SSMCTrBurstWTRd = '1')
                 else
                    ZEROFILL(31 downto 2)  & iSMMemCLKRatio when
                                (SMMemCLKRatioRd ='1')
                 else 
                    ZEROFILL;
-- -----------------------------------------------------------------------------
-- Combinational logic for all functional registers. When the respective
-- write enable input is asserted, copy the contents of the HWDATA Bus into
-- the corresponding registers.
-- -----------------------------------------------------------------------------
NxtSMTrBIDCYR0   <= HWDATAREG(3 downto 0) when (SMTrBIDCYR0Wr = '1')
                 else
                    iSMTrBIDCYR0;
NxtSMTrBIDCYR1   <= HWDATAREG(3 downto 0) when (SMTrBIDCYR1Wr = '1')
                 else
                    iSMTrBIDCYR1;
NxtSMTrBIDCYR2   <= HWDATAREG(3 downto 0) when (SMTrBIDCYR2Wr = '1')
                 else
                    iSMTrBIDCYR2;
NxtSMTrBIDCYR3   <= HWDATAREG(3 downto 0) when (SMTrBIDCYR3Wr = '1')
                 else
                    iSMTrBIDCYR3;
NxtSMTrBIDCYR4   <= HWDATAREG(3 downto 0) when (SMTrBIDCYR4Wr = '1')
                 else
                    iSMTrBIDCYR4;
NxtSMTrBIDCYR5   <= HWDATAREG(3 downto 0) when (SMTrBIDCYR5Wr = '1')
                 else
                    iSMTrBIDCYR5;
NxtSMTrBIDCYR6   <= HWDATAREG(3 downto 0) when (SMTrBIDCYR6Wr = '1')
                 else
                    iSMTrBIDCYR6;
NxtSMTrBIDCYR7   <= HWDATAREG(3 downto 0) when (SMTrBIDCYR7Wr = '1')
                 else
                    iSMTrBIDCYR7;

NxtSMTrBWSTRDR0  <= HWDATAREG(4 downto 0) when (SMTrBWSTRDR0Wr = '1')
                 else
                    iSMTrBWSTRDR0;
NxtSMTrBWSTRDR1  <= HWDATAREG(4 downto 0) when (SMTrBWSTRDR1Wr = '1')
                 else
                    iSMTrBWSTRDR1;
NxtSMTrBWSTRDR2  <= HWDATAREG(4 downto 0) when (SMTrBWSTRDR2Wr = '1')
                 else
                    iSMTrBWSTRDR2;
NxtSMTrBWSTRDR3  <= HWDATAREG(4 downto 0) when (SMTrBWSTRDR3Wr = '1')
                 else
                    iSMTrBWSTRDR3;
NxtSMTrBWSTRDR4  <= HWDATAREG(4 downto 0) when (SMTrBWSTRDR4Wr = '1')
                 else
                    iSMTrBWSTRDR4;
NxtSMTrBWSTRDR5  <= HWDATAREG(4 downto 0) when (SMTrBWSTRDR5Wr = '1')
                 else
                    iSMTrBWSTRDR5;
NxtSMTrBWSTRDR6  <= HWDATAREG(4 downto 0) when (SMTrBWSTRDR6Wr = '1')
                 else
                    iSMTrBWSTRDR6;
NxtSMTrBWSTRDR7  <= HWDATAREG(4 downto 0) when (SMTrBWSTRDR7Wr = '1')
                 else
                    iSMTrBWSTRDR7;

NxtSMTrBWSTWRR0  <= HWDATAREG(4 downto 0) when (SMTrBWSTWRR0Wr = '1')
                 else
                    iSMTrBWSTWRR0;
NxtSMTrBWSTWRR1  <= HWDATAREG(4 downto 0) when (SMTrBWSTWRR1Wr = '1')
                 else
                    iSMTrBWSTWRR1;
NxtSMTrBWSTWRR2  <= HWDATAREG(4 downto 0) when (SMTrBWSTWRR2Wr = '1')
                 else
                    iSMTrBWSTWRR2;
NxtSMTrBWSTWRR3  <= HWDATAREG(4 downto 0) when (SMTrBWSTWRR3Wr = '1')
                 else
                    iSMTrBWSTWRR3;
NxtSMTrBWSTWRR4  <= HWDATAREG(4 downto 0) when (SMTrBWSTWRR4Wr = '1')
                 else
                    iSMTrBWSTWRR4;
NxtSMTrBWSTWRR5  <= HWDATAREG(4 downto 0) when (SMTrBWSTWRR5Wr = '1')
                 else
                    iSMTrBWSTWRR5;
NxtSMTrBWSTWRR6  <= HWDATAREG(4 downto 0) when (SMTrBWSTWRR6Wr = '1')
                 else
                    iSMTrBWSTWRR6;
NxtSMTrBWSTWRR7  <= HWDATAREG(4 downto 0) when (SMTrBWSTWRR7Wr = '1')
                 else
                    iSMTrBWSTWRR7;

NxtSMTrBWSTOENR0  <= HWDATAREG(3 downto 0) when (SMTrBWSTOENR0Wr = '1')
                 else
                    iSMTrBWSTOENR0;
NxtSMTrBWSTOENR1  <= HWDATAREG(3 downto 0) when (SMTrBWSTOENR1Wr = '1')
                 else
                    iSMTrBWSTOENR1;
NxtSMTrBWSTOENR2  <= HWDATAREG(3 downto 0) when (SMTrBWSTOENR2Wr = '1')
                 else
                    iSMTrBWSTOENR2;
NxtSMTrBWSTOENR3  <= HWDATAREG(3 downto 0) when (SMTrBWSTOENR3Wr = '1')
                 else
                    iSMTrBWSTOENR3;
NxtSMTrBWSTOENR4  <= HWDATAREG(3 downto 0) when (SMTrBWSTOENR4Wr = '1')
                 else
                    iSMTrBWSTOENR4;
NxtSMTrBWSTOENR5  <= HWDATAREG(3 downto 0) when (SMTrBWSTOENR5Wr = '1')
                 else
                    iSMTrBWSTOENR5;
NxtSMTrBWSTOENR6  <= HWDATAREG(3 downto 0) when (SMTrBWSTOENR6Wr = '1')
                 else
                    iSMTrBWSTOENR6;
NxtSMTrBWSTOENR7  <= HWDATAREG(3 downto 0) when (SMTrBWSTOENR7Wr = '1')
                 else
                    iSMTrBWSTOENR7;

NxtSMTrBWSTWENR0  <= HWDATAREG(3 downto 0) when (SMTrBWSTWENR0Wr = '1')
                 else
                    iSMTrBWSTWENR0;
NxtSMTrBWSTWENR1  <= HWDATAREG(3 downto 0) when (SMTrBWSTWENR1Wr = '1')
                 else
                    iSMTrBWSTWENR1;
NxtSMTrBWSTWENR2  <= HWDATAREG(3 downto 0) when (SMTrBWSTWENR2Wr = '1')
                 else
                    iSMTrBWSTWENR2;
NxtSMTrBWSTWENR3  <= HWDATAREG(3 downto 0) when (SMTrBWSTWENR3Wr = '1')
                 else
                    iSMTrBWSTWENR3;
NxtSMTrBWSTWENR4  <= HWDATAREG(3 downto 0) when (SMTrBWSTWENR4Wr = '1')
                 else
                    iSMTrBWSTWENR4;
NxtSMTrBWSTWENR5  <= HWDATAREG(3 downto 0) when (SMTrBWSTWENR5Wr = '1')
                 else
                    iSMTrBWSTWENR5;
NxtSMTrBWSTWENR6  <= HWDATAREG(3 downto 0) when (SMTrBWSTWENR6Wr = '1')
                 else
                    iSMTrBWSTWENR6;
NxtSMTrBWSTWENR7  <= HWDATAREG(3 downto 0) when (SMTrBWSTWENR7Wr = '1')
                 else
                    iSMTrBWSTWENR7;

NxtSMTrBWSTBRDR0  <= HWDATAREG(4 downto 0) when (SMTrBWSTBRDR0Wr = '1')
                 else
                    iSMTrBWSTBRDR0;
NxtSMTrBWSTBRDR1  <= HWDATAREG(4 downto 0) when (SMTrBWSTBRDR1Wr = '1')
                 else
                    iSMTrBWSTBRDR1;
NxtSMTrBWSTBRDR2  <= HWDATAREG(4 downto 0) when (SMTrBWSTBRDR2Wr = '1')
                 else
                    iSMTrBWSTBRDR2;
NxtSMTrBWSTBRDR3  <= HWDATAREG(4 downto 0) when (SMTrBWSTBRDR3Wr = '1')
                 else
                    iSMTrBWSTBRDR3;
NxtSMTrBWSTBRDR4  <= HWDATAREG(4 downto 0) when (SMTrBWSTBRDR4Wr = '1')
                 else
                    iSMTrBWSTBRDR4;
NxtSMTrBWSTBRDR5  <= HWDATAREG(4 downto 0) when (SMTrBWSTBRDR5Wr = '1')
                 else
                    iSMTrBWSTBRDR5;
NxtSMTrBWSTBRDR6  <= HWDATAREG(4 downto 0) when (SMTrBWSTBRDR6Wr = '1')
                 else
                    iSMTrBWSTBRDR6;
NxtSMTrBWSTBRDR7  <= HWDATAREG(4 downto 0) when (SMTrBWSTBRDR7Wr = '1')
                 else
                    iSMTrBWSTBRDR7;

NxtSMTrBCR0       <= HWDATAREG(21 downto 0) when (SMTrBCR0Wr = '1')
                 else
                    iSMTrBCR0;
NxtSMTrBCR1       <= HWDATAREG(21 downto 0) when (SMTrBCR1Wr = '1')
                 else
                    iSMTrBCR1;
NxtSMTrBCR2       <= HWDATAREG(21 downto 0) when (SMTrBCR2Wr = '1')
                 else
                    iSMTrBCR2;
NxtSMTrBCR3       <= HWDATAREG(21 downto 0) when (SMTrBCR3Wr = '1')
                 else
                    iSMTrBCR3;
NxtSMTrBCR4       <= HWDATAREG(21 downto 0) when (SMTrBCR4Wr = '1')
                 else
                    iSMTrBCR4;
NxtSMTrBCR5       <= HWDATAREG(21 downto 0) when (SMTrBCR5Wr = '1')
                 else
                    iSMTrBCR5;
NxtSMTrBCR6       <= HWDATAREG(21 downto 0) when (SMTrBCR6Wr = '1')
                 else
                    iSMTrBCR6;
NxtSMTrBCR7       <= HWDATAREG(21 downto 0) when (SMTrBCR7Wr = '1')
                 else
                    iSMTrBCR7;

NxtSSMCTrMEMBASE0 <= HWDATA(14 downto 0) when (SSMCTrMEMBASE0Wr = '1')
                 else
                    iSSMCTrMEMBASE0;
NxtSSMCTrMEMBASE1 <= HWDATA(14 downto 0) when (SSMCTrMEMBASE1Wr = '1')
                 else
                    iSSMCTrMEMBASE1;
NxtSSMCTrMEMBASE2 <= HWDATA(14 downto 0) when (SSMCTrMEMBASE2Wr = '1')
                 else
                    iSSMCTrMEMBASE2;
NxtSSMCTrMEMBASE3 <= HWDATA(14 downto 0) when (SSMCTrMEMBASE3Wr = '1')
                 else
                    iSSMCTrMEMBASE3;
NxtSSMCTrMEMBASE4 <= HWDATA(14 downto 0) when (SSMCTrMEMBASE4Wr = '1')
                 else
                    iSSMCTrMEMBASE4;
NxtSSMCTrMEMBASE5 <= HWDATA(14 downto 0) when (SSMCTrMEMBASE5Wr = '1')
                 else
                    iSSMCTrMEMBASE5;
NxtSSMCTrMEMBASE6 <= HWDATA(14 downto 0) when (SSMCTrMEMBASE6Wr = '1')
                 else
                    iSSMCTrMEMBASE6;
NxtSSMCTrMEMBASE7 <= HWDATA(14 downto 0) when (SSMCTrMEMBASE7Wr = '1')
                 else
                    iSSMCTrMEMBASE7;
NxtSSMCTrBurstWT  <= HWDATA(8 downto 0)  when (SSMCTrBurstWTWr  = '1')
                 else
                    iSSMCTrBurstWT;
NxtSMMemCLKRatio  <= HWDATA(1 downto 0)  when (SMMemCLKRatioWr  ='1' )
                 else 
                    iSMMemCLKRatio; 

-- -----------------------------------------------------------------------------
-- This process generate the bus response required for an AHB slave.
-- SSMC trickbox is designed for an HBURST of INCR type and an HSIZE of 32-bit.
-- So this process will generate an ERROR response when the master try to access
-- it in some other mode. Also it display an error message to the output.
-- Trickbox always provides a ZERO wait state OKAY response for IDLE and BUSY
-- HTRANS of the master.
-- -----------------------------------------------------------------------------
p_BusRespSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
     iHRESPTr        <= "00";
     HREADYOUTTr     <= '1';
     WrEn            <= '0';
     WrRegEn         <= '0';
     RdEn            <= '0';
     RdRegEn         <= '0';
     ErrorLat        <= '0';
     iLatchHADDR     <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    if ((iHRESPTr = ERROR) and (HREADYINTr = '0') and (ErrorLat = '1')) then
      iHRESPTr      <= ERROR;
      HREADYOUTTr   <= '1';
      WrEn          <= '0';
      RdEn          <= '0';
      ErrorLat      <= '0';
    elsif (((HTRANS = IDLE) or (HTRANS = BUSY)) and
          (HSELSSMCTrMEM = '1') and (HREADYINTr = '1')) then
      iHRESPTr      <= OKAY;
      HREADYOUTTr   <= '1';
    elsif ((HREADYINTr = '1') and (HSELSSMCTrMEM = '1')) then
      if ((HBURST = INCR) and (HSIZE = WORD)) then
        HREADYOUTTr <= '1';
        iLatchHADDR <= HADDR;
        iHRESPTr    <= OKAY;
        if (HWRITETr = '1') then
          WrEn      <= '1';
          RdEn      <= '0';
        else
          WrEn      <= '0';
          RdEn      <= '1';
        end if;
      else
        iHRESPTr    <= ERROR;
        HREADYOUTTr <= '0';
        WrEn        <= '0';
        RdEn        <= '0';
        ErrorLat    <= '1';
        assert false
          report "Error Response from SSMC TrickMem slave"
        severity warning;
      end if;
 
    elsif ((HREADYINREG = '1') and (HSELSSMCTrREG = '1')) then
      if ((HBURST = INCR) and (HSIZE = WORD)) then
        HREADYOUTTr <= '1';
        iLatchHADDR <= HADDR;
        iHRESPTr    <= OKAY;
        if (HWRITEREG = '1') then
          WrRegEn    <= '1';
          RdRegEn    <= '0';
        else
          WrRegEn    <= '0';
          RdRegEn    <= '1';
        end if;
      else
        WrRegEn     <= '0';
        RdRegEn     <= '0';
      end if;
    else
      WrEn          <= '0';
      WrRegEn       <= '0';
      RdEn          <= '0';
      RdRegEn       <= '0';
      iHRESPTr      <= "00";
      HREADYOUTTr   <= '1';
      ErrorLat      <= '0';
    end if;
  end if;
end process p_BusRespSeq;

-- -----------------------------------------------------------------------------
-- Sequential process for all functional registers writes.
-- -----------------------------------------------------------------------------
p_RegUpdateSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    iSMTrBIDCYR0   <= (others => '1');
    iSMTrBIDCYR1   <= (others => '1');
    iSMTrBIDCYR2   <= (others => '1');
    iSMTrBIDCYR3   <= (others => '1');
    iSMTrBIDCYR4   <= (others => '1');
    iSMTrBIDCYR5   <= (others => '1');
    iSMTrBIDCYR6   <= (others => '1');
    iSMTrBIDCYR7   <= (others => '1');

    iSMTrBWSTRDR0  <= "11111";
    iSMTrBWSTRDR1  <= "11111";
    iSMTrBWSTRDR2  <= "11111";
    iSMTrBWSTRDR3  <= "11111";
    iSMTrBWSTRDR4  <= "11111";
    iSMTrBWSTRDR5  <= "11111";
    iSMTrBWSTRDR6  <= "11111";
    iSMTrBWSTRDR7  <= "11111";

    iSMTrBWSTWRR0  <= "11111";
    iSMTrBWSTWRR1  <= "11111";
    iSMTrBWSTWRR2  <= "11111";
    iSMTrBWSTWRR3  <= "11111";
    iSMTrBWSTWRR4  <= "11111";
    iSMTrBWSTWRR5  <= "11111";
    iSMTrBWSTWRR6  <= "11111";
    iSMTrBWSTWRR7  <= "11111";

    iSMTrBWSTOENR0 <= "0000" ;
    iSMTrBWSTOENR1 <= "0000" ;
    iSMTrBWSTOENR2 <= "0000" ;
    iSMTrBWSTOENR3 <= "0000" ; 
    iSMTrBWSTOENR4 <= "0000" ;
    iSMTrBWSTOENR5 <= "0000" ;
    iSMTrBWSTOENR6 <= "0000" ;
    iSMTrBWSTOENR7 <= "0000" ;

    iSMTrBWSTWENR0 <= "0001" ;
    iSMTrBWSTWENR1 <= "0001" ;
    iSMTrBWSTWENR2 <= "0001" ;
    iSMTrBWSTWENR3 <= "0001" ;
    iSMTrBWSTWENR4 <= "0001" ;
    iSMTrBWSTWENR5 <= "0001" ;
    iSMTrBWSTWENR6 <= "0001" ;
    iSMTrBWSTWENR7 <= "0001" ;

    iSMTrBWSTBRDR0 <= "11111";
    iSMTrBWSTBRDR1 <= "11111";
    iSMTrBWSTBRDR2 <= "11111";
    iSMTrBWSTBRDR3 <= "11111";
    iSMTrBWSTBRDR4 <= "11111";
    iSMTrBWSTBRDR5 <= "11111";
    iSMTrBWSTBRDR6 <= "11111";
    iSMTrBWSTBRDR7 <= "11111";

    iSMTrBCR0      <= "1100000011000000100000";
    iSMTrBCR1      <= "1100000011000000000000";
    iSMTrBCR2      <= "1100000011000000010000";
    iSMTrBCR3      <= "1100000011000000000000";
    iSMTrBCR4      <= "1100000011000000100000";
    iSMTrBCR5      <= "1100000011000000100000";
    iSMTrBCR6      <= "1100000011000000010000";
    iSMTrBCR7      <= "1100000011000000000000";

    iSSMCTrBurstWT <= "111111111";
    iSMMemCLKRatio <= "00";

    iSSMCTrMEMBASE0 <= (others => '0');
    iSSMCTrMEMBASE1 <= (others => '0');
    iSSMCTrMEMBASE2 <= (others => '0');
    iSSMCTrMEMBASE3 <= (others => '0');
    iSSMCTrMEMBASE4 <= (others => '0');
    iSSMCTrMEMBASE5 <= (others => '0');
    iSSMCTrMEMBASE6 <= (others => '0');
    iSSMCTrMEMBASE7 <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    iSMTrBIDCYR0   <= NxtSMTrBIDCYR0;
    iSMTrBIDCYR1   <= NxtSMTrBIDCYR1;
    iSMTrBIDCYR2   <= NxtSMTrBIDCYR2;
    iSMTrBIDCYR3   <= NxtSMTrBIDCYR3;
    iSMTrBIDCYR4   <= NXtSMTrBIDCYR4;
    iSMTrBIDCYR5   <= NxtSMTrBIDCYR5;
    iSMTrBIDCYR6   <= NxtSMTrBIDCYR6;
    iSMTrBIDCYR7   <= NxtSMTrBIDCYR7;

    iSMTrBWSTRDR0  <= NxtSMTrBWSTRDR0;
    iSMTrBWSTRDR1  <= NxtSMTrBWSTRDR1;
    iSMTrBWSTRDR2  <= NxtSMTrBWSTRDR2;
    iSMTrBWSTRDR3  <= NxtSMTrBWSTRDR3;
    iSMTrBWSTRDR4  <= NxtSMTrBWSTRDR4;
    iSMTrBWSTRDR5  <= NxtSMTrBWSTRDR5;
    iSMTrBWSTRDR6  <= NxtSMTrBWSTRDR6;
    iSMTrBWSTRDR7  <= NxtSMTrBWSTRDR7;

    iSMTrBWSTWRR0  <= NxtSMTrBWSTWRR0;
    iSMTrBWSTWRR1  <= NxtSMTrBWSTWRR1;
    iSMTrBWSTWRR2  <= NxtSMTrBWSTWRR2;
    iSMTrBWSTWRR3  <= NxtSMTrBWSTWRR3;
    iSMTrBWSTWRR4  <= NxtSMTrBWSTWRR4;
    iSMTrBWSTWRR5  <= NxtSMTrBWSTWRR5;
    iSMTrBWSTWRR6  <= NxtSMTrBWSTWRR6;
    iSMTrBWSTWRR7  <= NxtSMTrBWSTWRR7;

    iSMTrBWSTOENR0 <= NxtSMTrBWSTOENR0;
    iSMTrBWSTOENR1 <= NxtSMTrBWSTOENR1;
    iSMTrBWSTOENR2 <= NxtSMTrBWSTOENR2;
    iSMTrBWSTOENR3 <= NxtSMTrBWSTOENR3;
    iSMTrBWSTOENR4 <= NxtSMTrBWSTOENR4;
    iSMTrBWSTOENR5 <= NxtSMTrBWSTOENR5;
    iSMTrBWSTOENR6 <= NxtSMTrBWSTOENR6;
    iSMTrBWSTOENR7 <= NxtSMTrBWSTOENR7;
    iSMTrBWSTWENR0 <= NxtSMTrBWSTWENR0;

    iSMTrBWSTWENR1 <= NxtSMTrBWSTWENR1;
    iSMTrBWSTWENR2 <= NxtSMTrBWSTWENR2;
    iSMTrBWSTWENR3 <= NxtSMTrBWSTWENR3;
    iSMTrBWSTWENR4 <= NxtSMTrBWSTWENR4;
    iSMTrBWSTWENR5 <= NxtSMTrBWSTWENR5;
    iSMTrBWSTWENR6 <= NxtSMTrBWSTWENR6;
    iSMTrBWSTWENR7 <= NxtSMTrBWSTWENR7;
    iSMTrBWSTBRDR0 <= NxtSMTrBWSTBRDR0;

    iSMTrBWSTBRDR1 <= NxtSMTrBWSTBRDR1;
    iSMTrBWSTBRDR2 <= NxtSMTrBWSTBRDR2;
    iSMTrBWSTBRDR3 <= NxtSMTrBWSTBRDR3;
    iSMTrBWSTBRDR4 <= NxtSMTrBWSTBRDR4;
    iSMTrBWSTBRDR5 <= NxtSMTrBWSTBRDR5;
    iSMTrBWSTBRDR6 <= NxtSMTrBWSTBRDR6;
    iSMTrBWSTBRDR7 <= NxtSMTrBWSTBRDR7;

    iSMTrBCR0      <= NxtSMTrBCR0;
    iSMTrBCR1      <= NxtSMTrBCR1;
    iSMTrBCR2      <= NxtSMTrBCR2;
    iSMTrBCR3      <= NxtSMTrBCR3;
    iSMTrBCR4      <= NxtSMTrBCR4;
    iSMTrBCR5      <= NxtSMTrBCR5;
    iSMTrBCR6      <= NxtSMTrBCR6;
    iSMTrBCR7      <= NxtSMTrBCR7;

    iSSMCTrBurstWT <= NxtSSMCTrBurstWT;
    iSMMemCLKRatio <= NxtSMMemCLKRatio;

    iSSMCTrMEMBASE0 <= NxtSSMCTrMEMBASE0;
    iSSMCTrMEMBASE1 <= NxtSSMCTrMEMBASE1;
    iSSMCTrMEMBASE2 <= NxtSSMCTrMEMBASE2;
    iSSMCTrMEMBASE3 <= NxtSSMCTrMEMBASE3;
    iSSMCTrMEMBASE4 <= NxtSSMCTrMEMBASE4;
    iSSMCTrMEMBASE5 <= NxtSSMCTrMEMBASE5;
    iSSMCTrMEMBASE6 <= NxtSSMCTrMEMBASE6;
    iSSMCTrMEMBASE7 <= NxtSSMCTrMEMBASE7;
   
  end if;
end process p_RegUpdateSeq;

-- -----------------------------------------------------------------------------
-- Assign local copies of signals to the outputs
-- -----------------------------------------------------------------------------
    HRESPTr       <= iHRESPTr;
    LatchHADDR    <= iLatchHADDR;
    SMTrBIDCYR0   <= iSMTrBIDCYR0;
    SMTrBIDCYR1   <= iSMTrBIDCYR1;
    SMTrBIDCYR2   <= iSMTrBIDCYR2;
    SMTrBIDCYR3   <= iSMTrBIDCYR3;
    SMTrBIDCYR4   <= iSMTrBIDCYR4;
    SMTrBIDCYR5   <= iSMTrBIDCYR5;
    SMTrBIDCYR6   <= iSMTrBIDCYR6;
    SMTrBIDCYR7   <= iSMTrBIDCYR7;

    SMTrBWSTRDR0  <= iSMTrBWSTRDR0;
    SMTrBWSTRDR1  <= iSMTrBWSTRDR1;
    SMTrBWSTRDR2  <= iSMTrBWSTRDR2;
    SMTrBWSTRDR3  <= iSMTrBWSTRDR3;
    SMTrBWSTRDR4  <= iSMTrBWSTRDR4;
    SMTrBWSTRDR5  <= iSMTrBWSTRDR5;
    SMTrBWSTRDR6  <= iSMTrBWSTRDR6;
    SMTrBWSTRDR7  <= iSMTrBWSTRDR7;

    SMTrBWSTWRR0  <= iSMTrBWSTWRR0;
    SMTrBWSTWRR1  <= iSMTrBWSTWRR1;
    SMTrBWSTWRR2  <= iSMTrBWSTWRR2;
    SMTrBWSTWRR3  <= iSMTrBWSTWRR3;
    SMTrBWSTWRR4  <= iSMTrBWSTWRR4;
    SMTrBWSTWRR5  <= iSMTrBWSTWRR5;
    SMTrBWSTWRR6  <= iSMTrBWSTWRR6;
    SMTrBWSTWRR7  <= iSMTrBWSTWRR7;

    SMTrBWSTOENR0 <= iSMTrBWSTOENR0;
    SMTrBWSTOENR1 <= iSMTrBWSTOENR1;
    SMTrBWSTOENR2 <= iSMTrBWSTOENR2;
    SMTrBWSTOENR3 <= iSMTrBWSTOENR3;
    SMTrBWSTOENR4 <= iSMTrBWSTOENR4;
    SMTrBWSTOENR5 <= iSMTrBWSTOENR5;
    SMTrBWSTOENR6 <= iSMTrBWSTOENR6;
    SMTrBWSTOENR7 <= iSMTrBWSTOENR7;

    SMTrBWSTWENR0 <= iSMTrBWSTWENR0;
    SMTrBWSTWENR1 <= iSMTrBWSTWENR1;
    SMTrBWSTWENR2 <= iSMTrBWSTWENR2;
    SMTrBWSTWENR3 <= iSMTrBWSTWENR3;
    SMTrBWSTWENR4 <= iSMTrBWSTWENR4;
    SMTrBWSTWENR5 <= iSMTrBWSTWENR5;
    SMTrBWSTWENR6 <= iSMTrBWSTWENR6;
    SMTrBWSTWENR7 <= iSMTrBWSTWENR7;

    SMTrBWSTBRDR0 <= iSMTrBWSTBRDR0;
    SMTrBWSTBRDR1 <= iSMTrBWSTBRDR1;
    SMTrBWSTBRDR2 <= iSMTrBWSTBRDR2;
    SMTrBWSTBRDR3 <= iSMTrBWSTBRDR3;
    SMTrBWSTBRDR4 <= iSMTrBWSTBRDR4;
    SMTrBWSTBRDR5 <= iSMTrBWSTBRDR5;
    SMTrBWSTBRDR6 <= iSMTrBWSTBRDR6;
    SMTrBWSTBRDR7 <= iSMTrBWSTBRDR7;

    SMTrBCR0      <= iSMTrBCR0;
    SMTrBCR1      <= iSMTrBCR1;
    SMTrBCR2      <= iSMTrBCR2;
    SMTrBCR3      <= iSMTrBCR3;
    SMTrBCR4      <= iSMTrBCR4;
    SMTrBCR5      <= iSMTrBCR5;
    SMTrBCR6      <= iSMTrBCR6;
    SMTrBCR7      <= iSMTrBCR7;

    SSMCTrBurstWT <= iSSMCTrBurstWT;
    SMMemCLKRatio <= iSMMemCLKRatio;

    SSMCTrMEMBASE0 <= iSSMCTrMEMBASE0;
    SSMCTrMEMBASE1 <= iSSMCTrMEMBASE1;
    SSMCTrMEMBASE2 <= iSSMCTrMEMBASE2;
    SSMCTrMEMBASE3 <= iSSMCTrMEMBASE3;
    SSMCTrMEMBASE4 <= iSSMCTrMEMBASE4;
    SSMCTrMEMBASE5 <= iSSMCTrMEMBASE5;
    SSMCTrMEMBASE6 <= iSSMCTrMEMBASE6;
    SSMCTrMEMBASE7 <= iSSMCTrMEMBASE7;

end behavioural;

-- --================================== End ==================================--
