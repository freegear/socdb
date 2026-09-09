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
-- File Name              : SsmcAhbSlvRegIf.vhd.rca
-- File Revision          : 1.17
--
-- Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Provides CPU access to the SSMC Controller control and timing
--           registers.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use work.SsmcPackage.all;

-- -----------------------------------------------------------------------------

entity SsmcAhbSlvRegIf is
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB Bus Clock
        HRESETn          : in    std_logic; -- AHB system level Reset
        HADDRREG         : in    std_logic_vector(11 downto 2);
                                            -- The address bus input from AHB
                                            -- for Register accesses
        HTRANSREG        : in    std_logic_vector(1 downto 0);
                                            -- Indicates current transfer type
                                            -- for Register accesses.
        HWRITEREG        : in    std_logic; -- Indicates direction of transfer
                                            -- (R/W) for Register accesses
        HSIZEREG         : in    std_logic_vector(2 downto 0);
                                            -- Transfer size indication for
                                            -- Register accesses
        HWDATAREG        : in    std_logic_vector(31 downto 0);
                                            -- Write data bus input from AHB
                                            -- for Register accesses
        HSELREG          : in    std_logic; -- Select signal for Register
                                            -- transfer
        HREADYINREG      : in    std_logic; -- Transfer completion input signal
        SMMWCS7          : in    std_logic_vector(1 downto 0);
                                            -- Static Input pins used to program
                                            -- the memory width bit field
                                            -- of Bank7 register
        SMBLS7POL        : in    std_logic; -- Static Input pin used to program
                                            -- the polarity of SMBLS bit field
                                            -- of Bank7 register
        Revision         : in    std_logic_vector(3 downto 0);
                                            -- Revision number from SsmcRevAnd
        WaitStatus       : in    std_logic; -- Wait status for enabled transfer
        WaitToutErr      : in    std_logic; -- Waited access Error indication
        HTRANSSMC        : in    std_logic; -- Indicates current transfer type
                                            -- for Memory accesses
        HSELSMC          : in    std_logic_vector(7 downto 0);
                                            -- Select signal for Memory transfer
                                            -- to SSMCCore. One select line for
                                            -- each Memory Bank
        HREADYINSMC      : in    std_logic; -- Transfer completion input signal
        HselMemBuf1      : in    std_logic_vector(7 downto 0);
                                            -- 1st level registered HSELSMC
        SMBUSREQExt      : in    std_logic; -- Request EBI for Memory Transfer
        SMTICBUSREQExt   : in    std_logic; -- Request EBI for TIC Transfer
        SMMEMCLKRATIO    : in    std_logic_vector(1 downto 0);
                                            -- Indicates ratio of Memory Clock
                                            -- with respect to HCLK
        SMBIGENDIAN      : in    std_logic; -- Indicates Endian mode of the
                                            -- System
        SMEXTBUSMUX      : in    std_logic; -- Indication to either use Internal
                                            -- DBI or External EBI
        SMTICBUSGNTEBI   : in    std_logic; -- External bus granted for TIC
                                            -- Transfer
        SMBUSGNTEBI      : in    std_logic; -- External bus granted for Memory
                                            -- Transfer
        SMBUSBACKOFFEBI  : in    std_logic; -- EBI backoff for Memory accesses.
                                            -- Indication that the current 
                                            -- transfer should be completed as
                                            -- soon as possible
-- Outputs
        HRDATAREG        : out   std_logic_vector(31 downto 0);
                                            -- AHB Read Data output for
                                            -- Register accesses
        HREADYOUTREG     : out   std_logic; -- Indicates completion of Register
                                            -- accesses
        HRESPREG         : out   std_logic_vector(1 downto 0);
                                            -- SSMCCore response output, for
                                            -- Register accesses
        SMTICBUSGNTExt   : out   std_logic; -- External bus granted for TIC
                                            -- Transfer
        SMBUSGNTExt      : out   std_logic; -- External bus granted for Memory
                                            -- Transfer
        SmBusBackOffExt  : out   std_logic; -- BackOff indication from EBI
        BUSMUXEXT        : out   std_logic; -- Indication to either use Internal
                                            -- DBI or External EBI
        BIGENDIAN        : out   std_logic; -- Indicates Endianness of the
                                            -- System
        SMBUSREQEBI      : out   std_logic; -- Request EBI for Memory Transfer
        SMTICBUSREQEBI   : out   std_logic; -- Request EBI for TIC Transfer
        ClockRatio       : out   std_logic_vector(1 downto 0);
                                            -- Indicates ratio of Memory Clock
                                            -- with respect to HCLK
        MemClkRegTogl    : out   std_logic; -- Toggle signal indicating that
                                            -- write happened to Clock Register
        MW1              : out   std_logic_vector(1 downto 0);
                                            -- 1st level registered memory
                                            -- width bits selection from one of
                                            -- the bank registers
        SMBLSPol1        : out   std_logic; -- 1st level registered memory
                                            -- Byte lane polarity bit from one
                                            -- of the bank registers
        BMRead1          : out   std_logic; -- 1st level Burst Mode read
        BIWriteEn1       : out   std_logic; -- Indication that SMBAA active
                                            -- during Synchronous Burst Write
                                            -- access, 1st level buffered
        BIReadEn1        : out   std_logic; -- Indication that SMBAA and nSMIND
                                            -- active during Synchronous Burst
                                            -- Read access, 1st level buffered
        WrapRead         : out   std_logic; -- Enables the wrapping burst
                                            -- feature from memory
        BMWrite1         : out   std_logic; -- 1st level Burst Mode Write
        SyncEnRead1      : out   std_logic; -- 1st level Sync burst Mode read
        SyncEnWrite1     : out   std_logic; -- 1st level Sync burst Mode Write
        BurstLenRead1    : out   std_logic_vector(1 downto 0);
                                            -- 1st level Burst transfer length,
                                            -- by Burst devices for Read
        BurstLenWrite1   : out   std_logic_vector(1 downto 0);
                                            -- 1st level Burst transfer length,
                                            -- by Burst devices for Write
        AddrValidReadEn1 : out   std_logic; -- 1st level SMADDRVALID enable
                                            -- during Read
        AddrValWriteEn1  : out   std_logic; -- 1st level SMADDRVALID enable
                                            -- during Write
        SMClockEn        : out   std_logic; -- Zero on this bit indicates that
                                            -- Clock should be active during
                                            -- Memory accesses. One on this bit
                                            -- indicates that clock is always
                                            -- running
        WP1              : out   std_logic; -- 1st level Write protection
        RBLE1            : out   std_logic; -- 1st level Byte lane enable
        WaitEn1          : out   std_logic; -- 1st level Wait Enable indication
        WaitPol1         : out   std_logic; -- 1st level Indication of the
                                            -- polarity of SMWAIT
        WSTRD1           : out   std_logic_vector(4 downto 0);
                                            -- 1st level Single Read access
                                            -- count
        WSTBRD1          : out   std_logic_vector(4 downto 0);
                                            -- 1st level Burst Read access count
        WSTWR1           : out   std_logic_vector(4 downto 0);
                                            -- 1st level Write access count
        WSTOEN1          : out   std_logic_vector(3 downto 0);
                                            -- 1st level Delay value for the
                                            -- assertion of the OEN
        WSTWEN1          : out   std_logic_vector(3 downto 0);
                                            -- 1st level Delay value for the
                                            -- assertion of the WEN and nSMCS
        IDCYC1           : out   std_logic_vector(3 downto 0)
                                            -- 1st level Count value for the
                                            -- turnaround cycles
       );
end SsmcAhbSlvRegIf;

-- -----------------------------------------------------------------------------
--
--                               SsmcAhbSlvRegIf
--                               ===============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--           It consists of the AHB response generation logic, the memory
--           device parameter registers, control registers and status registers.
--
-- -----------------------------------------------------------------------------
--                         SSMC Control Register Map
-- -----------------------------------------------------------------------------
-- Offset  Read (Width)         Write (Width)       Description
-- -----------------------------------------------------------------------------
--                              Memory Bank 0

-- 0x000 SMBIDCYR0(4-bit)     SMIDCYR0(4-bit)      Idle Cycle
-- 0x004 SMBWSTRDR0(5-bit)    SMBWSTRDR0(5-bit)    Wait State for Long Read
-- 0x008 SMBWSTWRR0(5-bit)    SMBWSTWRR0(5-bit)    Wait State for Write
-- 0x00C SMBWSTOENR0(4-bit)   SMBWSTOENR0(4-bit)   OE Assertion Delay
-- 0x010 SMBWSTWENR0(4-bit)   SMBWSTWENR0(4-bit)   WE Assertion Delay
-- 0x014 SMBCR0(22-bit)       SMBCR0(22-bit)       Control Register
-- 0x018 SMBSR0(1-bit)        SMBSR0(1-bit)        Status Register
-- 0x01C SMBWSTBRDR0(5-bit)   SMBWSTBRDR0(5-bit)   Wait State for Burst Read

--                              Memory Bank 1

-- 0x020 SMBIDCYR1(4-bit)     SMIDCYR1(4-bit)      Idle Cycle
-- 0x024 SMBWSTRDR1(5-bit)    SMBWSTRDR1(5-bit)    Wait State for Long Read
-- 0x028 SMBWSTWRR1(5-bit)    SMBWSTWRR1(5-bit)    Wait State for Write
-- 0x02C SMBWSTOENR1(4-bit)   SMBWSTOENR1(4-bit)   OE Assertion Delay
-- 0x030 SMBWSTWENR1(4-bit)   SMBWSTWENR1(4-bit)   WE Assertion Delay
-- 0x034 SMBCR1(22-bit)       SMBCR1(22-bit)       Control Register
-- 0x038 SMBSR1(1-bit)        SMBSR1(1-bit)        Status Register
-- 0x03C SMBWSTBRDR1(5-bit)   SMBWSTBRDR1(5-bit)   Wait State for Burst Read

--                              Memory Bank 2

-- 0x040 SMBIDCYR2(4-bit)     SMIDCYR2(4-bit)      Idle Cycle
-- 0x044 SMBWSTRDR2(5-bit)    SMBWSTRDR2(5-bit)    Wait State for Long Read
-- 0x048 SMBWSTWRR2(5-bit)    SMBWSTWRR2(5-bit)    Wait State for Write
-- 0x04C SMBWSTOENR2(4-bit)   SMBWSTOENR2(4-bit)   OE Assertion Delay
-- 0x050 SMBWSTWENR2(4-bit)   SMBWSTWENR2(4-bit)   WE Assertion Delay
-- 0x054 SMBCR2(22-bit)       SMBCR2(22-bit)       Control Register
-- 0x058 SMBSR2(1-bit)        SMBSR2(1-bit)        Status Register
-- 0x05C SMBWSTBRDR2(5-bit)   SMBWSTBRDR2(5-bit)   Wait State for Burst Read

--                              Memory Bank 3

-- 0x060 SMBIDCYR3(4-bit)     SMIDCYR3(4-bit)      Idle Cycle
-- 0x064 SMBWSTRDR3(5-bit)    SMBWSTRDR3(5-bit)    Wait State for Long Read
-- 0x068 SMBWSTWRR3(5-bit)    SMBWSTWRR3(5-bit)    Wait State for Write
-- 0x06C SMBWSTOENR3(4-bit)   SMBWSTOENR3(4-bit)   OE Assertion Delay
-- 0x070 SMBWSTWENR3(4-bit)   SMBWSTWENR3(4-bit)   WE Assertion Delay
-- 0x074 SMBCR3(22-bit)       SMBCR3(22-bit)       Control Register
-- 0x078 SMBSR3(1-bit)        SMBSR3(1-bit)        Status Register
-- 0x07C SMBWSTBRDR3(5-bit)   SMBWSTBRDR3(5-bit)   Wait State for Burst Read

--                              Memory Bank 4

-- 0x080 SMBIDCYR4(4-bit)     SMIDCYR4(4-bit)      Idle Cycle
-- 0x084 SMBWSTRDR4(5-bit)    SMBWSTRDR4(5-bit)    Wait State for Long Read
-- 0x088 SMBWSTWRR4(5-bit)    SMBWSTWRR4(5-bit)    Wait State for Write
-- 0x08C SMBWSTOENR4(4-bit)   SMBWSTOENR4(4-bit)   OE Assertion Delay
-- 0x090 SMBWSTWENR4(4-bit)   SMBWSTWENR4(4-bit)   WE Assertion Delay
-- 0x094 SMBCR4(22-bit)       SMBCR4(22-bit)       Control Register
-- 0x098 SMBSR4(1-bit)        SMBSR4(1-bit)        Status Register
-- 0x09C SMBWSTBRDR4(5-bit)   SMBWSTBRDR4(5-bit)   Wait State for Burst Read

--                              Memory Bank 5

-- 0x0A0 SMBIDCYR5(4-bit)     SMIDCYR5(4-bit)      Idle Cycle
-- 0x0A4 SMBWSTRDR5(5-bit)    SMBWSTRDR5(5-bit)    Wait State for Long Read
-- 0x0A8 SMBWSTWRR5(5-bit)    SMBWSTWRR5(5-bit)    Wait State for Write
-- 0x0AC SMBWSTOENR5(4-bit)   SMBWSTOENR5(4-bit)   OE Assertion Delay
-- 0x0B0 SMBWSTWENR5(4-bit)   SMBWSTWENR5(4-bit)   WE Assertion Delay
-- 0x0B4 SMBCR5(22-bit)       SMBCR5(22-bit)       Control Register
-- 0x0B8 SMBSR5(1-bit)        SMBSR5(1-bit)        Status Register
-- 0x0BC SMBWSTBRDR5(5-bit)   SMBWSTBRDR5(5-bit)    Wait State for Burst Read

--                              Memory Bank 6

-- 0x0C0 SMBIDCYR6(4-bit)     SMIDCYR6(4-bit)      Idle Cycle
-- 0x0C4 SMBWSTRDR6(5-bit)    SMBWSTRDR6(5-bit)    Wait State for Long Read
-- 0x0C8 SMBWSTWRR6(5-bit)    SMBWSTWRR6(5-bit)    Wait State for Write
-- 0x0CC SMBWSTOENR6(4-bit)   SMBWSTOENR6(4-bit)   OE Assertion Delay
-- 0x0D0 SMBWSTWENR6(4-bit)   SMBWSTWENR6(4-bit)   WE Assertion Delay
-- 0x0D4 SMBCR6(22-bit)       SMBCR6(22-bit)       Control Register
-- 0x0D8 SMBSR6(1-bit)        SMBSR6(1-bit)        Status Register
-- 0x0DC SMBWSTBRDR6(5-bit)   SMBWSTBRDR6(5-bit)   Wait State for Burst Read

--                              Memory Bank 7

-- 0x0E0 SMBIDCYR7(4-bit)     SMIDCYR7(4-bit)      Idle Cycle
-- 0x0E4 SMBWSTRDR7(5-bit)    SMBWSTRDR7(5-bit)    Wait State for Long Read
-- 0x0E8 SMBWSTWRR7(5-bit)    SMBWSTWRR7(5-bit)    Wait State for Write
-- 0x0EC SMBWSTOENR7(4-bit)   SMBWSTOENR7(4-bit)   OE Assertion Delay
-- 0x0F0 SMBWSTWENR7(4-bit)   SMBWSTWENR7(4-bit)   WE Assertion Delay
-- 0x0F4 SMBCR7(22-bit)       SMBCR7(22-bit)       Control Register
-- 0x0F8 SMBSR7(1-bit)        SMBSR7(1-bit)        Status Register
-- 0x0FC SMBWSTBRDR7(5-bit)   SMBWSTBRDR7(5-bit)   Wait State for Burst Read

--                 External Wait Status bit after a timeout error
-- 0x200 SSMCCSR(1-bit)       SMBEWS(RO)           External Wait Status bit

--                 SSMC Control Register
-- 0x204 SSMCCR(3-bit)        SSMCCR(3-bit)        Control register

--                 SSMC Test Control Register
-- 0x208 SSMCITCR(1-bit)      SSMCITCR(1-bit)      Test Control register

--                 SSMC Test Input Register
-- 0x20C SSMCITIP(7-bit)      SSMCITIP(7-bit)      Test Input

--                 SSMC Test Output Register
-- 0x210 SSMCITOP(2-bit)      SSMCITOP(2-bit)      Test Output

--                        SSMC Identification Registers

-- 0xFE0 SSMCPERIPHID0(8-bit)          -            Peripheral Id register0
-- 0xFE4 SSMCPERIPHID1(8-bit)          -            Peripheral Id register1
-- 0xFE8 SSMCPERIPHID2(8-bit)          -            Peripheral Id register2
-- 0xFEC SSMCPERIPHID3(8-bit)          -            Peripheral Id register3
-- 0xFF0 SSMCPCELLID0(8-bit)           -            Prime Cell Id register0
-- 0xFF4 SSMCPCELLID1(8-bit)           -            Prime Cell Id register1
-- 0xFF8 SSMCPCELLID2(8-bit)           -            Prime Cell Id register2
-- 0xFFC SSMCPCELLID3(8-bit)           -            Prime Cell Id register3
--
-- -----------------------------------------------------------------------------

-- --============================== ARCHITECTURE =============================--

architecture synth of SsmcAhbSlvRegIf is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal WRITECYCREG      : std_logic;
-- Decode of Write state in SM

signal Bank0IDCYCWen    : std_logic;
-- Bank0 IDCYC register write enable

signal Bank0WSTRDWen    : std_logic;
-- Bank0 WSTRD register write enable

signal Bank0WSTWRWen    : std_logic;
-- Bank0 WSTWR register write enable

signal Bank0WSTOENWen   : std_logic;
-- Bank0 WSTOEN register write enable

signal Bank0WSTWENWen   : std_logic;
-- Bank0 WSTWEN register write enable

signal Bank0CtrlWen     : std_logic;
-- Bank0 Control register write enable

signal Bank0StatWen     : std_logic;
-- Bank0 Status register write enable

signal Bank0WSTBRDWen   : std_logic;
-- Bank0 BURST Read register write enable

signal Bank1IDCYCWen    : std_logic;
-- Bank1 IDCYC register write enable

signal Bank1WSTRDWen    : std_logic;
-- Bank1 WSTRD register write enable

signal Bank1WSTWRWen    : std_logic;
-- Bank1 WSTWR register write enable

signal Bank1WSTOENWen   : std_logic;
-- Bank1 WSTOEN register write enable

signal Bank1WSTWENWen   : std_logic;
-- Bank1 WSTWEN register write enable

signal Bank1CtrlWen     : std_logic;
-- Bank1 Control register write enable

signal Bank1StatWen     : std_logic;
-- Bank1 Status register write enable

signal Bank1WSTBRDWen   : std_logic;
-- Bank1 BURST Read register write enable

signal Bank2IDCYCWen    : std_logic;
-- Bank2 IDCYC register write enable

signal Bank2WSTRDWen    : std_logic;
-- Bank2 WSTRD register write enable

signal Bank2WSTWRWen    : std_logic;
-- Bank2 WSTWR register write enable

signal Bank2WSTOENWen   : std_logic;
-- Bank2 WSTOEN register write enable

signal Bank2WSTWENWen   : std_logic;
-- Bank2 WSTWEN register write enable

signal Bank2CtrlWen     : std_logic;
-- Bank2 Control register write enable

signal Bank2StatWen     : std_logic;
-- Bank2 Status register write enable

signal Bank2WSTBRDWen   : std_logic;
-- Bank2 BURST Read register write enable

signal Bank3IDCYCWen    : std_logic;
-- Bank3 IDCYC register write enable

signal Bank3WSTRDWen    : std_logic;
-- Bank3 WSTRD register write enable

signal Bank3WSTWRWen    : std_logic;
-- Bank3 WSTWR register write enable

signal Bank3WSTOENWen   : std_logic;
-- Bank3 WSTOEN register write enable

signal Bank3WSTWENWen   : std_logic;
-- Bank3 WSTWEN register write enable

signal Bank3CtrlWen     : std_logic;
-- Bank3 Control register write enable

signal Bank3StatWen     : std_logic;
-- Bank3 Status register write enable

signal Bank3WSTBRDWen   : std_logic;
-- Bank3 BURST Read register write enable

signal Bank4IDCYCWen    : std_logic;
-- Bank4 IDCYC register write enable

signal Bank4WSTRDWen    : std_logic;
-- Bank4 WSTRD register write enable

signal Bank4WSTWRWen    : std_logic;
-- Bank4 WSTWR register write enable

signal Bank4WSTOENWen   : std_logic;
-- Bank4 WSTOEN register write enable

signal Bank4WSTWENWen   : std_logic;
-- Bank4 WSTWEN register write enable

signal Bank4CtrlWen     : std_logic;
-- Bank4 Control register write enable

signal Bank4StatWen     : std_logic;
-- Bank4 Status register write enable

signal Bank4WSTBRDWen   : std_logic;
-- Bank4 BURST Read register write enable

signal Bank5IDCYCWen    : std_logic;
-- Bank5 IDCYC register write enable

signal Bank5WSTRDWen    : std_logic;
-- Bank5 WSTRD register write enable

signal Bank5WSTWRWen    : std_logic;
-- Bank5 WSTWR register write enable

signal Bank5WSTOENWen   : std_logic;
-- Bank5 WSTOEN register write enable

signal Bank5WSTWENWen   : std_logic;
-- Bank5 WSTWEN register write enable

signal Bank5CtrlWen     : std_logic;
-- Bank5 Control register write enable

signal Bank5StatWen     : std_logic;
-- Bank5 Status register write enable

signal Bank5WSTBRDWen   : std_logic;
-- Bank5 BURST Read register write enable

signal Bank6IDCYCWen    : std_logic;
-- Bank6 IDCYC register write enable

signal Bank6WSTRDWen    : std_logic;
-- Bank6 WSTRD register write enable

signal Bank6WSTWRWen    : std_logic;
-- Bank6 WSTWR register write enable

signal Bank6WSTOENWen   : std_logic;
-- Bank6 WSTOEN register write enable

signal Bank6WSTWENWen   : std_logic;
-- Bank6 WSTWEN register write enable

signal Bank6CtrlWen     : std_logic;
-- Bank6 Control register write enable

signal Bank6StatWen     : std_logic;
-- Bank6 Status register write enable

signal Bank6WSTBRDWen   : std_logic;
-- Bank6 BURST Read register write enable

signal Bank7IDCYCWen    : std_logic;
-- Bank7 IDCYC register write enable

signal Bank7WSTRDWen    : std_logic;
-- Bank7 WSTRD register write enable

signal Bank7WSTWRWen    : std_logic;
-- Bank7 WSTWR register write enable

signal Bank7WSTOENWen   : std_logic;
-- Bank7 WSTOEN register write enable

signal Bank7WSTWENWen   : std_logic;
-- Bank7 WSTWEN register write enable

signal Bank7CtrlWen     : std_logic;
-- Bank7 Control register write enable

signal Bank7StatWen     : std_logic;
-- Bank7 Status register write enable

signal Bank7WSTBRDWen   : std_logic;
-- Bank7 BURST Read register write enable


signal SMClockWen       : std_logic;
-- SMCLK register write enable

signal TestCtrlWen      : std_logic;
-- Test control register write enable

signal TestCtrlInWen    : std_logic;
-- Test control input register write enable

signal TestCtrlOutWen   : std_logic;
-- Test control output register write enable


signal SMBIDCYCR0       : std_logic_vector(3 downto 0);
-- Bank0 IDCYC register

signal SMBWSTRDR0       : std_logic_vector(4 downto 0);
-- Bank0 WSTRD register

signal SMBWSTWRR0       : std_logic_vector(4 downto 0);
-- Bank0 WSTWR register

signal SMBWSTOENR0      : std_logic_vector(3 downto 0);
-- Bank0 WSTOEN register

signal SMBWSTWENR0      : std_logic_vector(3 downto 0);
-- Bank0 WSTWEN register

signal SMBCR0           : std_logic_vector(21 downto 0);
-- Bank0 Control register

signal SMBWSTBRDR0      : std_logic_vector(4 downto 0);
-- Bank0 WSTBRD register


signal NextSMBIDCYCR0   : std_logic_vector(3 downto 0);
-- D-input of SMBIDCYCR0 register

signal NextSMBWSTRDR0   : std_logic_vector(4 downto 0);
-- D-input of SMBWSTRDR0 register

signal NextSMBWSTWRR0   : std_logic_vector(4 downto 0);
-- D-input of SMBWSTWRR0 register

signal NextSMBWSTOENR0  : std_logic_vector(3 downto 0);
-- D-input of SMBWSTOENR0 register

signal NextSMBWSTWENR0  : std_logic_vector(3 downto 0);
-- D-input of SMBWSTWENR0 register

signal NextSMBCR0       : std_logic_vector(21 downto 0);
-- D-input of SMBCR0 register

signal NextSMBWSTBRDR0  : std_logic_vector(4 downto 0);
-- D-input of SMBWSTBRDR0 register


signal SMBIDCYCR1       : std_logic_vector(3 downto 0);
-- Bank1 IDCYC register

signal SMBWSTRDR1       : std_logic_vector(4 downto 0);
-- Bank1 WSTRD register

signal SMBWSTWRR1       : std_logic_vector(4 downto 0);
-- Bank1 WSTWR register

signal SMBWSTOENR1      : std_logic_vector(3 downto 0);
-- Bank1 WSTOEN register

signal SMBWSTWENR1      : std_logic_vector(3 downto 0);
-- Bank1 WSTWEN register

signal SMBCR1           : std_logic_vector(21 downto 0);
-- Bank1 Control register

signal SMBWSTBRDR1      : std_logic_vector(4 downto 0);
-- Bank1 WSTBRD register


signal NextSMBIDCYCR1   : std_logic_vector(3 downto 0);
-- D-input of SMBIDCYCR1 register

signal NextSMBWSTRDR1   : std_logic_vector(4 downto 0);
-- D-input of SMBWSTRDR1 register

signal NextSMBWSTWRR1   : std_logic_vector(4 downto 0);
-- D-input of SMBWSTWRR1 register

signal NextSMBWSTOENR1  : std_logic_vector(3 downto 0);
-- D-input of SMBWSTOENR1 register

signal NextSMBWSTWENR1  : std_logic_vector(3 downto 0);
-- D-input of SMBWSTWENR1 register

signal NextSMBCR1       : std_logic_vector(21 downto 0);
-- D-input of SMBCR1 register

signal NextSMBWSTBRDR1  : std_logic_vector(4 downto 0);
-- D-input of SMBWSTBRDR1 register


signal SMBIDCYCR2       : std_logic_vector(3 downto 0);
-- Bank2 IDCYC register

signal SMBWSTRDR2       : std_logic_vector(4 downto 0);
-- Bank2 WSTRD register

signal SMBWSTWRR2       : std_logic_vector(4 downto 0);
-- Bank2 WSTWR register

signal SMBWSTOENR2      : std_logic_vector(3 downto 0);
-- Bank2 WSTOEN register

signal SMBWSTWENR2      : std_logic_vector(3 downto 0);
-- Bank2 WSTWEN register

signal SMBCR2           : std_logic_vector(21 downto 0);
-- Bank2 Control register

signal SMBWSTBRDR2      : std_logic_vector(4 downto 0);
-- Bank2 WSTBRD register


signal NextSMBIDCYCR2   : std_logic_vector(3 downto 0);
-- D-input of SMBIDCYCR2 register

signal NextSMBWSTRDR2   : std_logic_vector(4 downto 0);
-- D-input of SMBWSTRDR2 register

signal NextSMBWSTWRR2   : std_logic_vector(4 downto 0);
-- D-input of SMBWSTWRR2 register

signal NextSMBWSTOENR2  : std_logic_vector(3 downto 0);
-- D-input of SMBWSTOENR2 register

signal NextSMBWSTWENR2  : std_logic_vector(3 downto 0);
-- D-input of SMBWSTWENR2 register

signal NextSMBCR2       : std_logic_vector(21 downto 0);
-- D-input of SMBCR2 register

signal NextSMBWSTBRDR2  : std_logic_vector(4 downto 0);
-- D-input of SMBWSTBRDR2 register


signal SMBIDCYCR3       : std_logic_vector(3 downto 0);
-- Bank3 IDCYC register

signal SMBWSTRDR3       : std_logic_vector(4 downto 0);
-- Bank3 WSTRD register

signal SMBWSTWRR3       : std_logic_vector(4 downto 0);
-- Bank3 WSTWR register

signal SMBWSTOENR3      : std_logic_vector(3 downto 0);
-- Bank3 WSTOEN register

signal SMBWSTWENR3      : std_logic_vector(3 downto 0);
-- Bank3 WSTWEN register

signal SMBCR3           : std_logic_vector(21 downto 0);
-- Bank3 Control register

signal SMBWSTBRDR3      : std_logic_vector(4 downto 0);
-- Bank3 WSTBRD register


signal NextSMBIDCYCR3   : std_logic_vector(3 downto 0);
-- D-input of SMBIDCYCR3 register

signal NextSMBWSTRDR3   : std_logic_vector(4 downto 0);
-- D-input of SMBWSTRDR3 register

signal NextSMBWSTWRR3   : std_logic_vector(4 downto 0);
-- D-input of SMBWSTWRR3 register

signal NextSMBWSTOENR3  : std_logic_vector(3 downto 0);
-- D-input of SMBWSTOENR3 register

signal NextSMBWSTWENR3  : std_logic_vector(3 downto 0);
-- D-input of SMBWSTWENR3 register

signal NextSMBCR3       : std_logic_vector(21 downto 0);
-- D-input of SMBCR3 register

signal NextSMBWSTBRDR3  : std_logic_vector(4 downto 0);
-- D-input of SMBWSTBRDR3 register


signal SMBIDCYCR4       : std_logic_vector(3 downto 0);
-- Bank4 IDCYC register

signal SMBWSTRDR4       : std_logic_vector(4 downto 0);
-- Bank4 WSTRD register

signal SMBWSTWRR4       : std_logic_vector(4 downto 0);
-- Bank4 WSTWR register

signal SMBWSTOENR4      : std_logic_vector(3 downto 0);
-- Bank4 WSTOEN register

signal SMBWSTWENR4      : std_logic_vector(3 downto 0);
-- Bank4 WSTWEN register

signal SMBCR4           : std_logic_vector(21 downto 0);
-- Bank4 Control register

signal SMBWSTBRDR4      : std_logic_vector(4 downto 0);
-- Bank4 WSTBRD register


signal NextSMBIDCYCR4   : std_logic_vector(3 downto 0);
-- D-input of SMBIDCYCR4 register

signal NextSMBWSTRDR4   : std_logic_vector(4 downto 0);
-- D-input of SMBWSTRDR4 register

signal NextSMBWSTWRR4   : std_logic_vector(4 downto 0);
-- D-input of SMBWSTWRR4 register

signal NextSMBWSTOENR4  : std_logic_vector(3 downto 0);
-- D-input of SMBWSTOENR4 register

signal NextSMBWSTWENR4  : std_logic_vector(3 downto 0);
-- D-input of SMBWSTWENR4 register

signal NextSMBCR4       : std_logic_vector(21 downto 0);
-- D-input of SMBCR4 register

signal NextSMBWSTBRDR4  : std_logic_vector(4 downto 0);
-- D-input of SMBWSTBRDR4 register


signal SMBIDCYCR5       : std_logic_vector(3 downto 0);
-- Bank5 IDCYC register

signal SMBWSTRDR5       : std_logic_vector(4 downto 0);
-- Bank5 WSTRD register

signal SMBWSTWRR5       : std_logic_vector(4 downto 0);
-- Bank5 WSTWR register

signal SMBWSTOENR5      : std_logic_vector(3 downto 0);
-- Bank5 WSTOEN register

signal SMBWSTWENR5      : std_logic_vector(3 downto 0);
-- Bank5 WSTWEN register

signal SMBCR5           : std_logic_vector(21 downto 0);
-- Bank5 Control register

signal SMBWSTBRDR5      : std_logic_vector(4 downto 0);
-- Bank5 WSTBRD register


signal NextSMBIDCYCR5   : std_logic_vector(3 downto 0);
-- D-input of SMBIDCYCR5 register

signal NextSMBWSTRDR5   : std_logic_vector(4 downto 0);
-- D-input of SMBWSTRDR5 register

signal NextSMBWSTWRR5   : std_logic_vector(4 downto 0);
-- D-input of SMBWSTWRR5 register

signal NextSMBWSTOENR5  : std_logic_vector(3 downto 0);
-- D-input of SMBWSTOENR5 register

signal NextSMBWSTWENR5  : std_logic_vector(3 downto 0);
-- D-input of SMBWSTWENR5 register

signal NextSMBCR5       : std_logic_vector(21 downto 0);
-- D-input of SMBCR5 register

signal NextSMBWSTBRDR5  : std_logic_vector(4 downto 0);
-- D-input of SMBWSTBRDR5 register


signal SMBIDCYCR6       : std_logic_vector(3 downto 0);
-- Bank6 IDCYC register

signal SMBWSTRDR6       : std_logic_vector(4 downto 0);
-- Bank6 WSTRD register

signal SMBWSTWRR6       : std_logic_vector(4 downto 0);
-- Bank6 WSTWR register

signal SMBWSTOENR6      : std_logic_vector(3 downto 0);
-- Bank6 WSTOEN register

signal SMBWSTWENR6      : std_logic_vector(3 downto 0);
-- Bank6 WSTWEN register

signal SMBCR6           : std_logic_vector(21 downto 0);
-- Bank6 Control register

signal SMBWSTBRDR6      : std_logic_vector(4 downto 0);
-- Bank6 WSTBRD register


signal NextSMBIDCYCR6   : std_logic_vector(3 downto 0);
-- D-input of SMBIDCYCR6 register

signal NextSMBWSTRDR6   : std_logic_vector(4 downto 0);
-- D-input of SMBWSTRDR6 register

signal NextSMBWSTWRR6   : std_logic_vector(4 downto 0);
-- D-input of SMBWSTWRR6 register

signal NextSMBWSTOENR6  : std_logic_vector(3 downto 0);
-- D-input of SMBWSTOENR6 register

signal NextSMBWSTWENR6  : std_logic_vector(3 downto 0);
-- D-input of SMBWSTWENR6 register

signal NextSMBCR6       : std_logic_vector(21 downto 0);
-- D-input of SMBCR6 register

signal NextSMBWSTBRDR6  : std_logic_vector(4 downto 0);
-- D-input of SMBWSTBRDR6 register


signal SMBIDCYCR7       : std_logic_vector(3 downto 0);
-- Bank7 IDCYC register

signal SMBWSTRDR7       : std_logic_vector(4 downto 0);
-- Bank7 WSTRD register

signal SMBWSTWRR7       : std_logic_vector(4 downto 0);
-- Bank7 WSTWR register

signal SMBWSTOENR7      : std_logic_vector(3 downto 0);
-- Bank7 WSTOEN register

signal SMBWSTWENR7      : std_logic_vector(3 downto 0);
-- Bank7 WSTWEN register

signal SMBCR7           : std_logic_vector(21 downto 0);
-- Bank7 Control register

signal SMBWSTBRDR7      : std_logic_vector(4 downto 0);
-- Bank7 WSTBRD register


signal NextSMBIDCYCR7   : std_logic_vector(3 downto 0);
-- D-input of SMBIDCYCR7 register

signal NextSMBWSTRDR7   : std_logic_vector(4 downto 0);
-- D-input of SMBWSTRDR7 register

signal NextSMBWSTWRR7   : std_logic_vector(4 downto 0);
-- D-input of SMBWSTWRR7 register

signal NextSMBWSTOENR7  : std_logic_vector(3 downto 0);
-- D-input of SMBWSTOENR7 register

signal NextSMBWSTWENR7  : std_logic_vector(3 downto 0);
-- D-input of SMBWSTWENR7 register

signal NextSMBCR7       : std_logic_vector(21 downto 0);
-- D-input of SMBCR7 register

signal NextSMBWSTBRDR7  : std_logic_vector(4 downto 0);
-- D-input of SMBWSTBRDR7 register


signal SMClockEnReg     : std_logic_vector(2 downto 0);
-- SMCLK enable register

signal NextSMClockEnReg : std_logic_vector(2 downto 0);
-- D-input of SMClockEnReg register

signal TestCtrlReg      : std_logic;
-- Test Control register

signal NextTestCtrlReg  : std_logic;
-- D-input of TestCtrlReg register

signal TestCtrlInReg    : std_logic_vector(6 downto 0);
-- Test Control input register

signal NextTestCtrlIn   : std_logic_vector(6 downto 0);
-- D-input of TestCtrlInReg register

signal TestCtrlOutReg   : std_logic_vector(1 downto 0);
-- Test Control output register

signal NextTestCtrlOut  : std_logic_vector(1 downto 0);
-- D-input of TestCtrlOutReg register


signal iHRESPREG        : std_logic_vector(1 downto 0);
-- Internal version of HRESPS

signal NextHRESPREG     : std_logic_vector(1 downto 0);
-- D-input of iHRESPS register

signal iHREADYOUTREG    : std_logic;
-- Internal version of HREADYOUT

signal NextHREADYOUTREG : std_logic;
-- D-input of iHREADYOUT register

signal AddressBuf       : std_logic_vector(9 downto 0);
-- Reg to hold the offset address(for Latching)

signal NextAddressBuf   : std_logic_vector(9 downto 0);
-- input of the offset address(for Latching)

signal SmSlaveState     : std_logic_vector(3 downto 0);
-- input vector to control the state machine

signal NextSmSlaveState : std_logic_vector(3 downto 0);
-- D-input of SmSlaveState signal

signal SSMCPERIPHID0    : std_logic_vector(7 downto 0);
-- Peripheral ID Register0 Bits

signal SSMCPERIPHID1    : std_logic_vector(7 downto 0);
-- Peripheral ID Register1 Bits

signal SSMCPERIPHID2    : std_logic_vector(3 downto 0);
-- Peripheral ID Register2 Bits

signal SSMCPERIPHID3    : std_logic_vector(7 downto 0);
-- Peripheral ID Register3 Bits

signal SSMCPCELLID0     : std_logic_vector(7 downto 0);
-- Prime Cell ID Register0 Bits

signal SSMCPCELLID1     : std_logic_vector(7 downto 0);
-- Prime Cell ID Register1 Bits

signal SSMCPCELLID2     : std_logic_vector(7 downto 0);
-- Prime Cell ID Register2 Bits

signal SSMCPCELLID3     : std_logic_vector(7 downto 0);
-- Prime Cell ID Register3 Bits

signal SMBTOUTR0        : std_logic;
-- Status for Bank0 Time out Error indication during Memory accesses

signal NextSMBTOUTR0    : std_logic;
-- D-input of SMBTOUTR0 register

signal SMBTOUTR1        : std_logic;
-- Status for Bank1 Time out Error indication during Memory accesses

signal NextSMBTOUTR1    : std_logic;
-- D-input of SMBTOUTR1 register

signal SMBTOUTR2        : std_logic;
-- Status for Bank2 Time out Error indication during Memory accesses

signal NextSMBTOUTR2    : std_logic;
-- D-input of SMBTOUTR2 register

signal SMBTOUTR3        : std_logic;
-- Status for Bank3 Time out Error indication during Memory accesses

signal NextSMBTOUTR3    : std_logic;
-- D-input of SMBTOUTR3 register

signal SMBTOUTR4        : std_logic;
-- Status for Bank4 Time out Error indication during Memory accesses

signal NextSMBTOUTR4    : std_logic;
-- D-input of SMBTOUTR4 register

signal SMBTOUTR5        : std_logic;
-- Status for Bank5 Time out Error indication during Memory accesses

signal NextSMBTOUTR5    : std_logic;
-- D-input of SMBTOUTR5 register

signal SMBTOUTR6        : std_logic;
-- Status for Bank6 Time out Error indication during Memory accesses

signal NextSMBTOUTR6    : std_logic;
-- D-input of SMBTOUTR6 register

signal SMBTOUTR7        : std_logic;
-- Status for Bank7 Time out Error indication during Memory accesses

signal NextSMBTOUTR7    : std_logic;
-- D-input of SMBTOUTR7 register

signal Bank0ToutClr     : std_logic;
-- Clear signal for Bank0 WaitToutErr status bit

signal Bank1ToutClr     : std_logic;
-- Clear signal for Bank1 WaitToutErr status bit

signal Bank2ToutClr     : std_logic;
-- Clear signal for Bank2 WaitToutErr status bit

signal Bank3ToutClr     : std_logic;
-- Clear signal for Bank3 WaitToutErr status bit

signal Bank4ToutClr     : std_logic;
-- Clear signal for Bank4 WaitToutErr status bit

signal Bank5ToutClr     : std_logic;
-- Clear signal for Bank5 WaitToutErr status bit

signal Bank6ToutClr     : std_logic;
-- Clear signal for Bank6 WaitToutErr status bit

signal Bank7ToutClr     : std_logic;
-- Clear signal for Bank7 WaitToutErr status bit

signal Bank0ToutErr     : std_logic;
-- Error indication for Bank0 TimeOut condition

signal Bank1ToutErr     : std_logic;
-- Error indication for Bank1 TimeOut condition

signal Bank2ToutErr     : std_logic;
-- Error indication for Bank2 TimeOut condition

signal Bank3ToutErr     : std_logic;
-- Error indication for Bank3 TimeOut condition

signal Bank4ToutErr     : std_logic;
-- Error indication for Bank4 TimeOut condition

signal Bank5ToutErr     : std_logic;
-- Error indication for Bank5 TimeOut condition

signal Bank6ToutErr     : std_logic;
-- Error indication for Bank6 TimeOut condition

signal Bank7ToutErr     : std_logic;
-- Error indication for Bank7 TimeOut condition

signal SoftWrClkReg     : std_logic;
-- Indication that Clock frequency in  Control register was programmed
-- by software

signal NextSoftWrClkReg : std_logic;
-- D-input of SoftWrClkReg register

signal SoftWrMW7Reg     : std_logic;
-- Indication that Width in  Control register was programmed by software

signal NextSoftWrMW7Reg : std_logic;
-- D-input of SoftWrMW7Reg register

signal SoftWrBLS7Reg    : std_logic;
-- Indication that SMBLS polarity in  Control register was programmed by
-- software

signal NxtSoftWrBLS7Reg : std_logic;
-- D-input of SoftWrBLS7Reg register

signal iMemClkRegTogl   : std_logic;
-- Internal signal of MemClkRegTogl

signal NextMemClkTogl   : std_logic;
-- D-input of iMemClkRegTogl register

signal DelMemClkRegTogl : std_logic;
-- Delayed version of MemClkRegTogl

signal iSMTICBUSGNTExt  : std_logic;
-- Internal version of SMTICBUSGNTExt

signal iSMBUSGNTExt     : std_logic;
-- Internal version of SMBUSGNTExt

signal NextSMBUSGNTExt     : std_logic;
-- D-input of iSMBUSGNTExt

signal iBUSMUXEXT       : std_logic;
-- Internal version of BUSMUXEXT

signal IntClockRatio    : std_logic_vector(1 downto 0);
-- Mux output between Clock Ratio pins and ITIP register

signal iBIGENDIAN       : std_logic;
-- Internal version of BIGENDIAN

signal iSMTICBUSREQEBI  : std_logic;
-- Internal version of SMTICBUSREQEBI

signal iSMBUSREQEBI     : std_logic;
-- Internal version of SMBUSREQEBI

signal iHRDATAREG       : std_logic_vector(31 downto 0);
-- Internal Version of HRDATAREG

signal NextHrdataReg    : std_logic_vector(31 downto 0);
-- D-input of iHRDATAREG register

signal SmBusGntEbiReg   : std_logic;
-- Registered version of SMBUSGNTEBI

signal SMBUSGNTTest     : std_logic;
-- Multiplexed SMBUSGNTEBI for test input register read path

signal SmTicGntEbiReg   : std_logic;
-- Registered version of SMTICBUSGNTEBI

signal SmBusBackOffReg  : std_logic;
-- Registered version of SMBUSBACKOFFEBI

signal iSmBusBackOffExt : std_logic;
-- Internal version of SmBusBackOffExt

signal iMW1             : std_logic_vector(1 downto 0);
-- Internal version of MW

signal NextMW1          : std_logic_vector(1 downto 0);
-- D-Input of iMW1

signal iWrapRead        : std_logic;
-- Internal version of WrapRead

signal NextWrapRead     : std_logic;
-- D-Input of iWrapRead

signal iSyncEnRead1     : std_logic;
-- Internal version of SyncEnRead1

signal NextSyncEnRead1  : std_logic;
-- D-Input of iSyncEnRead1

signal iWaitEn1         : std_logic;
-- Internal version of WaitEn1

signal NextWaitEn1      : std_logic;
-- D-Input of iWaitEn1

signal iWP1             : std_logic;
-- Internal version of WP1

signal NextWP1          : std_logic;
-- D-Input of iWP1

signal iSyncEnWrite1    : std_logic;
-- Internal version of SyncEnWrite1

signal NextSyncEnWrite1 : std_logic;
-- D-Input of iSyncEnWrite1

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

-- ----------------------------------------------------------------------------
-- Assign the SSMC Peripheral ID
--
-- The SSMC Peripheral ID is a 32-bit value composed of the
-- following 4 fields:
-- Bits [11:0] -> Part Number used to identify the peripheral
--                For the SSMC this is 0x093
-- Bits[19:12] -> Designer ID (ARM)
--                ARM is designated 0x41
-- Bits[23:20] -> Peripheral Revision Number
--                For the SSMC this is 0x00
-- Bits[31:24] -> Peripheral Configuration Options
--                For the SSMC this is 0x00
--
-- The 32-bits are readable via 4 separate address locations with
-- each location returning 8 valid bits at positions [7:0]. The
-- values returned by the 4 Peripheral ID registers are given below:
--
-- SSMCPERIPHID0 = 0x93
-- SSMCPERIPHID1 = 0x10
-- SSMCPERIPHID2 = 0x04
-- SSMCPERIPHID3 = 0x00
-- -----------------------------------------------------------------------------
SSMCPERIPHID0     <= "10010011";
SSMCPERIPHID1     <= "00010000";
SSMCPERIPHID2     <= "0100";
SSMCPERIPHID3     <= "00000000";

-- -----------------------------------------------------------------------------
-- Assign the SSMC PrimeCell ID
--
-- SSMCPCELLID0 = 0x0D
-- SSMCPCELLID1 = 0xF0
-- SSMCPCELLID2 = 0x05
-- SSMCPCELLID3 = 0xB1
-- These PrimeCell ID values should not be changed.
-- -----------------------------------------------------------------------------
SSMCPCELLID0      <= "00001101";
SSMCPCELLID1      <= "11110000";
SSMCPCELLID2      <= "00000101";
SSMCPCELLID3      <= "10110001";

-- -----------------------------------------------------------------------------
-- Generation of State Decode's
-- -----------------------------------------------------------------------------
WRITECYCREG <= SmSlaveState(1);

-- -----------------------------------------------------------------------------
-- Internal Signal Assignments
-- -----------------------------------------------------------------------------
HREADYOUTREG    <= iHREADYOUTREG;
HRESPREG        <= iHRESPREG;
HRDATAREG       <= iHRDATAREG;
SMClockEn       <= SMClockEnReg(0);
ClockRatio      <= SMClockEnReg(2 downto 1);
BIGENDIAN       <= iBIGENDIAN;
BUSMUXEXT       <= iBUSMUXEXT;
SMBUSGNTExt     <= iSMBUSGNTExt;
SmBusBackOffExt <= iSmBusBackOffExt;
SMTICBUSGNTExt  <= iSMTICBUSGNTExt;
MemClkRegTogl   <= iMemClkRegTogl;
SMBUSREQEBI     <= iSMBUSREQEBI;
SMTICBUSREQEBI  <= iSMTICBUSREQEBI;
MW1             <= iMW1;
WaitEn1         <= iWaitEn1;
WrapRead        <= iWrapRead;
SyncEnRead1     <= iSyncEnRead1;
WP1             <= iWP1;
SyncEnWrite1    <= iSyncEnWrite1;

-- -----------------------------------------------------------------------------
--                              Assignments
-- -----------------------------------------------------------------------------
NextSMBUSGNTExt  <= SMBUSGNTEBI and SMBUSREQExt;

-- -----------------------------------------------------------------------------
--    S L A V E    S E L E C T    S T A T E    M A C H I N E
-- -----------------------------------------------------------------------------
--
-- Summary: State Machine to control the AHB Slave interface for Register
--          accesses.
--
-- Overview: This state machine will control the AHB slave interface for
--           register accesses.
--
-- Summary State Description:
-- ==========================
--
-- ST_REG_NOT_SEL: Register Not Selected State.
-- Description   : Default state when interface is not selected.
-- Entry         : HSELREG is sampled de-asserted or if HTRANSREG is sampled
--                 BUSY or IDLE and the end of any given bus cycle.
-- Exit          : When there is a read or write access.
-- No change     : Until the HSELREG and HREADYINREG is sampled asserted.
--
-- ST_REG_READ   : Register Read State.
-- Description   : Read access in progress.
-- Entry         : When 32 bit read is initiated.
-- Exit          : When read is completed and HTRANSREG is sampled BUSY or IDLE
--                 at the end of given bus cycle OR when Write transfer is
--                 sampled asserted at the end of given bus cycle.
-- No Change     : During read access(Until HREADYINREG is sampled asserted).
--
-- ST_REG_WRITE  : Register Write State.
-- Description   : Write access in progress.
-- Entry         : When 32 bit write is initiated.
-- Exit          : When write is complete and HTRANSREG is sampled BUSY or IDLE
--                 at the end of given bus cycle OR when Read transfer is
--                 sampled asserted at the end of given bus cycle.
-- No Change     : During write access(Until HREADYINREG is sampled asserted).
--
-- ST_REG_ERROR  : Register Error State.
-- Description   : Error condition state.
-- Entry         : Invalid access attempted where HSIZEREG is not equal to WORD.
-- Exit          : After ERROR has been flagged on AHB.
-- No change     : While ERROR response is driven on HRESP.
--
-- Detailed Description:
-- =====================
-- The logic has a separate address buffer that latches in the address on the
-- HADDRREG lines at the end of every bus cycle. This latched address is used
-- for further decoding. The data transfers from registers to the AHB bus occur
-- only in the ST_REG_READ state. The data transfers to registers from the AHB
-- bus occur only in the ST_REG_WRITE state.
-- 
-- The buffered address is decoded and if the access is a Write to registers a
-- combinatorial decode of ST_REG_WRITE state bit and the buffered address
-- directly forms the Write Enable for the registers. The Writes to registers
-- terminate with one wait cycle response.
--
-- Whenever a read/write access is initiated with NSEQ or SEQ on the SSMC, the
-- SM always inserts a Wait state for the cycle. This Wait period is of only one
-- clock. At the end of the Wait period the SM drives HREADYOUTREG high with
-- OKAY response.
-- 
-- When an error occurs HRESPREG will be driven to ERROR and HREADYOUT will be
-- low for 1 cycle followed by 1 cycle high. An ERROR is caused by any access
-- that is not 32 bits wide.
-- 
-- -----------------------------------------------------------------------------
p_RegSMComb : process (SmSlaveState, AddressBuf, HREADYINREG, HTRANSREG,
                       HADDRREG, HWRITEREG, iHREADYOUTREG, iHRESPREG,
                       HSELREG, HSIZEREG)
begin
  NextSmSlaveState <= SmSlaveState;
  NextHREADYOUTREG <= iHREADYOUTREG;
  NextHRESPREG     <= iHRESPREG;
  NextAddressBuf   <= AddressBuf;
  case SmSlaveState is
    when ST_REG_NOT_SEL | ST_REG_WRITE | ST_REG_READ =>
      if (HREADYINREG = '1') then
        if (HSELREG = '1') then
          case HTRANSREG is
            when HTRANS_IDLE | HTRANS_BUSY =>
              NextSmSlaveState <= ST_REG_NOT_SEL;
              NextHREADYOUTREG <= '1';
              NextHRESPREG     <= HRESP_OKAY;
              NextAddressBuf   <= HADDRREG;

            when HTRANS_NSEQ | HTRANS_SEQ =>
              NextHRESPREG     <= HRESP_OKAY;
              NextAddressBuf   <= HADDRREG;
              NextHREADYOUTREG <= '0';
              if (HSIZEREG /= "010") then
                NextSmSlaveState <= ST_REG_ERROR;
                NextHRESPREG     <= HRESP_ERROR;
              elsif (HWRITEREG = '1') then
                NextSmSlaveState <= ST_REG_WRITE;
              else
                NextSmSlaveState <= ST_REG_READ;
              end if;

            when others =>
              null;
          end case;
        else
          NextSmSlaveState <= ST_REG_NOT_SEL;
          NextHREADYOUTREG <= '1';
          NextHRESPREG     <= HRESP_OKAY;
        end if;
      else
        NextHREADYOUTREG <= '1';
      end if;

    when ST_REG_ERROR =>
      NextHRESPREG     <= HRESP_ERROR;
      NextHREADYOUTREG <= '1';
      NextSmSlaveState <= ST_REG_NOT_SEL;

    when others =>
      null;

  end case;
end process p_RegSMComb;

-- -----------------------------------------------------------------------------
-- Registering all Next state signals
-- -----------------------------------------------------------------------------
p_RegSMSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    SmSlaveState     <= ST_REG_NOT_SEL;
    iHREADYOUTREG    <= '1';
    iHRESPREG        <= HRESP_OKAY;
    AddressBuf       <= (others => '0');
    SoftWrClkReg     <= '0';
    SoftWrMW7Reg     <= '0';
    SoftWrBLS7Reg    <= '0';
    iMemClkRegTogl   <= '0';
    DelMemClkRegTogl <= '0';
    iSMBUSGNTExt     <= '0';
    SmBusGntEbiReg   <= '0';
    SmTicGntEbiReg   <= '1';
    SmBusBackOffReg  <= '0';
  elsif (HCLK'event and HCLK = '1') then
    SmSlaveState     <= NextSmSlaveState;
    iHREADYOUTREG    <= NextHREADYOUTREG;
    iHRESPREG        <= NextHRESPREG;
    AddressBuf       <= NextAddressBuf;
    SoftWrClkReg     <= NextSoftWrClkReg;
    SoftWrMW7Reg     <= NextSoftWrMW7Reg;
    SoftWrBLS7Reg    <= NxtSoftWrBLS7Reg;
    iMemClkRegTogl   <= NextMemClkTogl;
    DelMemClkRegTogl <= iMemClkRegTogl;
    iSMBUSGNTExt     <= NextSMBUSGNTExt;
    SmBusGntEbiReg   <= SMBUSGNTEBI;
    SmTicGntEbiReg   <= SMTICBUSGNTEBI;
    SmBusBackOffReg  <= SMBUSBACKOFFEBI;
  end if;
end process p_RegSMSeq;

-- -----------------------------------------------------------------------------
-- Register Write Logic
-- This always block controls the enable signal for the registers depending on
-- which address the CPU is trying to access.
-- -----------------------------------------------------------------------------
p_RegWriteComb : process (AddressBuf, WRITECYCREG, SoftWrClkReg, SoftWrMW7Reg,
                          SoftWrBLS7Reg)
begin
  Bank0IDCYCWen    <= '0';
  Bank0WSTRDWen    <= '0';
  Bank0WSTBRDWen   <= '0';
  Bank0WSTWRWen    <= '0';
  Bank0WSTOENWen   <= '0';
  Bank0WSTWENWen   <= '0';
  Bank0CtrlWen     <= '0';
  Bank0StatWen     <= '0';
  Bank1IDCYCWen    <= '0';
  Bank1WSTRDWen    <= '0';
  Bank1WSTBRDWen   <= '0';
  Bank1WSTWRWen    <= '0';
  Bank1WSTOENWen   <= '0';
  Bank1WSTWENWen   <= '0';
  Bank1CtrlWen     <= '0';
  Bank1StatWen     <= '0';
  Bank2IDCYCWen    <= '0';
  Bank2WSTRDWen    <= '0';
  Bank2WSTBRDWen   <= '0';
  Bank2WSTWRWen    <= '0';
  Bank2WSTOENWen   <= '0';
  Bank2WSTWENWen   <= '0';
  Bank2CtrlWen     <= '0';
  Bank2StatWen     <= '0';
  Bank3IDCYCWen    <= '0';
  Bank3WSTRDWen    <= '0';
  Bank3WSTBRDWen   <= '0';
  Bank3WSTWRWen    <= '0';
  Bank3WSTOENWen   <= '0';
  Bank3WSTWENWen   <= '0';
  Bank3CtrlWen     <= '0';
  Bank3StatWen     <= '0';
  Bank4IDCYCWen    <= '0';
  Bank4WSTRDWen    <= '0';
  Bank4WSTBRDWen   <= '0';
  Bank4WSTWRWen    <= '0';
  Bank4WSTOENWen   <= '0';
  Bank4WSTWENWen   <= '0';
  Bank4CtrlWen     <= '0';
  Bank4StatWen     <= '0';
  Bank5IDCYCWen    <= '0';
  Bank5WSTRDWen    <= '0';
  Bank5WSTBRDWen   <= '0';
  Bank5WSTWRWen    <= '0';
  Bank5WSTOENWen   <= '0';
  Bank5WSTWENWen   <= '0';
  Bank5CtrlWen     <= '0';
  Bank5StatWen     <= '0';
  Bank6IDCYCWen    <= '0';
  Bank6WSTRDWen    <= '0';
  Bank6WSTBRDWen   <= '0';
  Bank6WSTWRWen    <= '0';
  Bank6WSTOENWen   <= '0';
  Bank6WSTWENWen   <= '0';
  Bank6CtrlWen     <= '0';
  Bank6StatWen     <= '0';
  Bank7IDCYCWen    <= '0';
  Bank7WSTRDWen    <= '0';
  Bank7WSTBRDWen   <= '0';
  Bank7WSTWRWen    <= '0';
  Bank7WSTOENWen   <= '0';
  Bank7WSTWENWen   <= '0';
  Bank7CtrlWen     <= '0';
  Bank7StatWen     <= '0';
  SMClockWen       <= '0';
  TestCtrlWen      <= '0';
  TestCtrlInWen    <= '0';
  TestCtrlOutWen   <= '0';
  NextSoftWrClkReg <= SoftWrClkReg;
  NextSoftWrMW7Reg <= SoftWrMW7Reg;
  NxtSoftWrBLS7Reg <= SoftWrBLS7Reg;
  if (WRITECYCREG = '1') then
    case AddressBuf is
      when HADDR_SMBIDCYR0   => Bank0IDCYCWen  <= '1';
      when HADDR_SMBWSTRDR0  => Bank0WSTRDWen  <= '1';
      when HADDR_SMBWSTBRDR0 => Bank0WSTBRDWen <= '1';
      when HADDR_SMBWSTOENR0 => Bank0WSTOENWen <= '1';
      when HADDR_SMBWSTWRR0  => Bank0WSTWRWen  <= '1';
      when HADDR_SMBWSTWENR0 => Bank0WSTWENWen <= '1';
      when HADDR_SMBCR0      => Bank0CtrlWen   <= '1';
      when HADDR_SMBSR0      => Bank0StatWen   <= '1';
      when HADDR_SMBIDCYR1   => Bank1IDCYCWen  <= '1';
      when HADDR_SMBWSTRDR1  => Bank1WSTRDWen  <= '1';
      when HADDR_SMBWSTBRDR1 => Bank1WSTBRDWen <= '1';
      when HADDR_SMBWSTOENR1 => Bank1WSTOENWen <= '1';
      when HADDR_SMBWSTWRR1  => Bank1WSTWRWen  <= '1';
      when HADDR_SMBWSTWENR1 => Bank1WSTWENWen <= '1';
      when HADDR_SMBCR1      => Bank1CtrlWen   <= '1';
      when HADDR_SMBSR1      => Bank1StatWen   <= '1';
      when HADDR_SMBIDCYR2   => Bank2IDCYCWen  <= '1';
      when HADDR_SMBWSTRDR2  => Bank2WSTRDWen  <= '1';
      when HADDR_SMBWSTBRDR2 => Bank2WSTBRDWen <= '1';
      when HADDR_SMBWSTOENR2 => Bank2WSTOENWen <= '1';
      when HADDR_SMBWSTWRR2  => Bank2WSTWRWen  <= '1';
      when HADDR_SMBWSTWENR2 => Bank2WSTWENWen <= '1';
      when HADDR_SMBCR2      => Bank2CtrlWen   <= '1';
      when HADDR_SMBSR2      => Bank2StatWen   <= '1';
      when HADDR_SMBIDCYR3   => Bank3IDCYCWen  <= '1';
      when HADDR_SMBWSTRDR3  => Bank3WSTRDWen  <= '1';
      when HADDR_SMBWSTBRDR3 => Bank3WSTBRDWen <= '1';
      when HADDR_SMBWSTOENR3 => Bank3WSTOENWen <= '1';
      when HADDR_SMBWSTWRR3  => Bank3WSTWRWen  <= '1';
      when HADDR_SMBWSTWENR3 => Bank3WSTWENWen <= '1';
      when HADDR_SMBCR3      => Bank3CtrlWen   <= '1';
      when HADDR_SMBSR3      => Bank3StatWen   <= '1';
      when HADDR_SMBIDCYR4   => Bank4IDCYCWen  <= '1';
      when HADDR_SMBWSTRDR4  => Bank4WSTRDWen  <= '1';
      when HADDR_SMBWSTBRDR4 => Bank4WSTBRDWen <= '1';
      when HADDR_SMBWSTOENR4 => Bank4WSTOENWen <= '1';
      when HADDR_SMBWSTWRR4  => Bank4WSTWRWen  <= '1';
      when HADDR_SMBWSTWENR4 => Bank4WSTWENWen <= '1';
      when HADDR_SMBCR4      => Bank4CtrlWen   <= '1';
      when HADDR_SMBSR4      => Bank4StatWen   <= '1';
      when HADDR_SMBIDCYR5   => Bank5IDCYCWen  <= '1';
      when HADDR_SMBWSTRDR5  => Bank5WSTRDWen  <= '1';
      when HADDR_SMBWSTBRDR5 => Bank5WSTBRDWen <= '1';
      when HADDR_SMBWSTOENR5 => Bank5WSTOENWen <= '1';
      when HADDR_SMBWSTWRR5  => Bank5WSTWRWen  <= '1';
      when HADDR_SMBWSTWENR5 => Bank5WSTWENWen <= '1';
      when HADDR_SMBCR5      => Bank5CtrlWen   <= '1';
      when HADDR_SMBSR5      => Bank5StatWen   <= '1';
      when HADDR_SMBIDCYR6   => Bank6IDCYCWen  <= '1';
      when HADDR_SMBWSTRDR6  => Bank6WSTRDWen  <= '1';
      when HADDR_SMBWSTBRDR6 => Bank6WSTBRDWen <= '1';
      when HADDR_SMBWSTOENR6 => Bank6WSTOENWen <= '1';
      when HADDR_SMBWSTWRR6  => Bank6WSTWRWen  <= '1';
      when HADDR_SMBWSTWENR6 => Bank6WSTWENWen <= '1';
      when HADDR_SMBCR6      => Bank6CtrlWen   <= '1';
      when HADDR_SMBSR6      => Bank6StatWen   <= '1';
      when HADDR_SMBIDCYR7   => Bank7IDCYCWen  <= '1';
      when HADDR_SMBWSTRDR7  => Bank7WSTRDWen  <= '1';
      when HADDR_SMBWSTBRDR7 => Bank7WSTBRDWen <= '1';
      when HADDR_SMBWSTOENR7 => Bank7WSTOENWen <= '1';
      when HADDR_SMBWSTWRR7  => Bank7WSTWRWen  <= '1';
      when HADDR_SMBWSTWENR7 => Bank7WSTWENWen <= '1';
      when HADDR_SMBCR7      =>
        Bank7CtrlWen     <= '1';
        NextSoftWrMW7Reg <= '1';
        NxtSoftWrBLS7Reg <= '1';
      when HADDR_SMBSR7      => Bank7StatWen   <= '1';
      when HADDR_SMCR        =>
        SMClockWen       <= '1';
        NextSoftWrClkReg <= '1';
      when HADDR_SMITCR      => TestCtrlWen    <= '1';
      when HADDR_SMITIP      => TestCtrlInWen  <= '1';
      when HADDR_SMITOP      => TestCtrlOutWen <= '1';
      when others => null;
    end case;
  end if;
end process p_RegWriteComb;

-- -----------------------------------------------------------------------------
-- The Concurrent assignments controls the actual write in HCLK domain. Here
-- depending on the register enable signals the data from the data bus is
-- registered on to the corresponding registers.
-- -----------------------------------------------------------------------------
NextSMBIDCYCR0(3 downto 0)  <= HWDATAREG(3 downto 0) when (Bank0IDCYCWen = '1')
                            else
                               SMBIDCYCR0;

NextSMBWSTRDR0(4 downto 0)  <= HWDATAREG(4 downto 0) when (Bank0WSTRDWen = '1')
                            else
                               SMBWSTRDR0;

NextSMBWSTBRDR0(4 downto 0) <= HWDATAREG(4 downto 0) when (Bank0WSTBRDWen = '1')
                            else
                               SMBWSTBRDR0;

NextSMBWSTWRR0(4 downto 0)  <= HWDATAREG(4 downto 0) when (Bank0WSTWRWen = '1')
                            else
                               SMBWSTWRR0;

NextSMBWSTOENR0(3 downto 0) <= HWDATAREG(3 downto 0) when (Bank0WSTOENWen = '1')
                            else
                               SMBWSTOENR0;

NextSMBWSTWENR0(3 downto 0) <= HWDATAREG(3 downto 0) when (Bank0WSTWENWen = '1')
                            else
                               SMBWSTWENR0;

NextSMBCR0(21 downto 0)     <= HWDATAREG(21 downto 0) when (Bank0CtrlWen = '1')
                            else
                               SMBCR0;

Bank0ToutClr                <= HWDATAREG(0) when (Bank0StatWen = '1')
                            else
                               '0';

NextSMBIDCYCR1(3 downto 0)  <= HWDATAREG(3 downto 0) when (Bank1IDCYCWen = '1')
                            else
                               SMBIDCYCR1;

NextSMBWSTRDR1(4 downto 0)  <= HWDATAREG(4 downto 0) when (Bank1WSTRDWen = '1')
                            else
                               SMBWSTRDR1;

NextSMBWSTBRDR1(4 downto 0) <= HWDATAREG(4 downto 0) when (Bank1WSTBRDWen = '1')
                            else
                               SMBWSTBRDR1;

NextSMBWSTWRR1(4 downto 0)  <= HWDATAREG(4 downto 0) when (Bank1WSTWRWen = '1')
                            else
                               SMBWSTWRR1;

NextSMBWSTOENR1(3 downto 0) <= HWDATAREG(3 downto 0) when (Bank1WSTOENWen = '1')
                            else
                               SMBWSTOENR1;

NextSMBWSTWENR1(3 downto 0) <= HWDATAREG(3 downto 0) when (Bank1WSTWENWen = '1')
                            else
                               SMBWSTWENR1;

NextSMBCR1(21 downto 0)     <= HWDATAREG(21 downto 0) when (Bank1CtrlWen = '1')
                            else
                               SMBCR1;

Bank1ToutClr                <= HWDATAREG(0) when (Bank1StatWen = '1')
                            else
                               '0';

NextSMBIDCYCR2(3 downto 0)  <= HWDATAREG(3 downto 0) when (Bank2IDCYCWen = '1')
                            else
                               SMBIDCYCR2;

NextSMBWSTRDR2(4 downto 0)  <= HWDATAREG(4 downto 0) when (Bank2WSTRDWen = '1')
                            else
                               SMBWSTRDR2;

NextSMBWSTBRDR2(4 downto 0) <= HWDATAREG(4 downto 0) when (Bank2WSTBRDWen = '1')
                            else
                               SMBWSTBRDR2;

NextSMBWSTWRR2(4 downto 0)  <= HWDATAREG(4 downto 0) when (Bank2WSTWRWen = '1')
                            else
                               SMBWSTWRR2;

NextSMBWSTOENR2(3 downto 0) <= HWDATAREG(3 downto 0) when (Bank2WSTOENWen = '1')
                            else
                               SMBWSTOENR2;

NextSMBWSTWENR2(3 downto 0) <= HWDATAREG(3 downto 0) when (Bank2WSTWENWen = '1')
                            else
                               SMBWSTWENR2;

NextSMBCR2(21 downto 0)     <= HWDATAREG(21 downto 0) when (Bank2CtrlWen = '1')
                            else
                               SMBCR2;

Bank2ToutClr                <= HWDATAREG(0) when (Bank2StatWen = '1')
                            else
                               '0';

NextSMBIDCYCR3(3 downto 0)  <= HWDATAREG(3 downto 0) when (Bank3IDCYCWen = '1')
                            else
                               SMBIDCYCR3;

NextSMBWSTRDR3(4 downto 0)  <= HWDATAREG(4 downto 0) when (Bank3WSTRDWen = '1')
                            else
                               SMBWSTRDR3;

NextSMBWSTBRDR3(4 downto 0) <= HWDATAREG(4 downto 0) when (Bank3WSTBRDWen = '1')
                            else
                               SMBWSTBRDR3;

NextSMBWSTWRR3(4 downto 0)  <= HWDATAREG(4 downto 0) when (Bank3WSTWRWen = '1')
                            else
                               SMBWSTWRR3;

NextSMBWSTOENR3(3 downto 0) <= HWDATAREG(3 downto 0) when (Bank3WSTOENWen = '1')
                            else
                               SMBWSTOENR3;

NextSMBWSTWENR3(3 downto 0) <= HWDATAREG(3 downto 0) when (Bank3WSTWENWen = '1')
                            else
                               SMBWSTWENR3;

NextSMBCR3(21 downto 0)     <= HWDATAREG(21 downto 0) when (Bank3CtrlWen = '1')
                            else
                               SMBCR3;

Bank3ToutClr                <= HWDATAREG(0) when (Bank3StatWen = '1')
                            else
                               '0';

NextSMBIDCYCR4(3 downto 0)  <= HWDATAREG(3 downto 0) when (Bank4IDCYCWen = '1')
                            else
                               SMBIDCYCR4;

NextSMBWSTRDR4(4 downto 0)  <= HWDATAREG(4 downto 0) when (Bank4WSTRDWen = '1')
                            else
                               SMBWSTRDR4;

NextSMBWSTBRDR4(4 downto 0) <= HWDATAREG(4 downto 0) when (Bank4WSTBRDWen = '1')
                            else
                               SMBWSTBRDR4;

NextSMBWSTWRR4(4 downto 0)  <= HWDATAREG(4 downto 0) when (Bank4WSTWRWen = '1')
                            else
                               SMBWSTWRR4;

NextSMBWSTOENR4(3 downto 0) <= HWDATAREG(3 downto 0) when (Bank4WSTOENWen = '1')
                            else
                               SMBWSTOENR4;

NextSMBWSTWENR4(3 downto 0) <= HWDATAREG(3 downto 0) when (Bank4WSTWENWen = '1')
                            else
                               SMBWSTWENR4;

NextSMBCR4(21 downto 0)     <= HWDATAREG(21 downto 0) when (Bank4CtrlWen = '1')
                            else
                               SMBCR4;

Bank4ToutClr                <= HWDATAREG(0) when (Bank4StatWen = '1')
                            else
                               '0';

NextSMBIDCYCR5(3 downto 0)  <= HWDATAREG(3 downto 0) when (Bank5IDCYCWen = '1')
                            else
                               SMBIDCYCR5;

NextSMBWSTRDR5(4 downto 0)  <= HWDATAREG(4 downto 0) when (Bank5WSTRDWen = '1')
                            else
                               SMBWSTRDR5;

NextSMBWSTBRDR5(4 downto 0) <= HWDATAREG(4 downto 0) when (Bank5WSTBRDWen = '1')
                            else
                               SMBWSTBRDR5;

NextSMBWSTWRR5(4 downto 0)  <= HWDATAREG(4 downto 0) when (Bank5WSTWRWen = '1')
                            else
                               SMBWSTWRR5;

NextSMBWSTOENR5(3 downto 0) <= HWDATAREG(3 downto 0) when (Bank5WSTOENWen = '1')
                            else
                               SMBWSTOENR5;

NextSMBWSTWENR5(3 downto 0) <= HWDATAREG(3 downto 0) when (Bank5WSTWENWen = '1')
                            else
                               SMBWSTWENR5;

NextSMBCR5(21 downto 0)     <= HWDATAREG(21 downto 0) when (Bank5CtrlWen = '1')
                            else
                               SMBCR5;

Bank5ToutClr                <= HWDATAREG(0) when (Bank5StatWen = '1')
                            else
                               '0';

NextSMBIDCYCR6(3 downto 0)  <= HWDATAREG(3 downto 0) when (Bank6IDCYCWen = '1')
                            else
                               SMBIDCYCR6;

NextSMBWSTRDR6(4 downto 0)  <= HWDATAREG(4 downto 0) when (Bank6WSTRDWen = '1')
                            else
                               SMBWSTRDR6;

NextSMBWSTBRDR6(4 downto 0) <= HWDATAREG(4 downto 0) when (Bank6WSTBRDWen = '1')
                            else
                               SMBWSTBRDR6;

NextSMBWSTWRR6(4 downto 0)  <= HWDATAREG(4 downto 0) when (Bank6WSTWRWen = '1')
                            else
                               SMBWSTWRR6;

NextSMBWSTOENR6(3 downto 0) <= HWDATAREG(3 downto 0) when (Bank6WSTOENWen = '1')
                            else
                               SMBWSTOENR6;

NextSMBWSTWENR6(3 downto 0) <= HWDATAREG(3 downto 0) when (Bank6WSTWENWen = '1')
                            else
                               SMBWSTWENR6;

NextSMBCR6(21 downto 0)     <= HWDATAREG(21 downto 0) when (Bank6CtrlWen = '1')
                            else
                               SMBCR6;

Bank6ToutClr                <= HWDATAREG(0) when (Bank6StatWen = '1')
                            else
                               '0';

NextSMBIDCYCR7(3 downto 0)  <= HWDATAREG(3 downto 0) when (Bank7IDCYCWen = '1')
                            else
                               SMBIDCYCR7;

NextSMBWSTRDR7(4 downto 0)  <= HWDATAREG(4 downto 0) when (Bank7WSTRDWen = '1')
                            else
                               SMBWSTRDR7;

NextSMBWSTBRDR7(4 downto 0) <= HWDATAREG(4 downto 0) when (Bank7WSTBRDWen = '1')
                            else
                               SMBWSTBRDR7;

NextSMBWSTWRR7(4 downto 0)  <= HWDATAREG(4 downto 0) when (Bank7WSTWRWen = '1')
                            else
                               SMBWSTWRR7;

NextSMBWSTOENR7(3 downto 0) <= HWDATAREG(3 downto 0) when (Bank7WSTOENWen = '1')
                            else
                               SMBWSTOENR7;

NextSMBWSTWENR7(3 downto 0) <= HWDATAREG(3 downto 0) when (Bank7WSTWENWen = '1')
                            else
                               SMBWSTWENR7;

Bank7ToutClr                <= HWDATAREG(0) when (Bank7StatWen = '1')
                            else
                               '0';

NextMemClkTogl              <= not iMemClkRegTogl
                                 when ((SMClockWen = '1') and
                                       (SMClockEnReg(2 downto 1) /=
                                        HWDATAREG(2 downto 1)) and
                                       (iMemClkRegTogl = DelMemClkRegTogl))
                            else
                               iMemClkRegTogl;

NextTestCtrlReg             <= HWDATAREG(0) when (TestCtrlWen = '1')
                            else
                               TestCtrlReg;

NextTestCtrlIn(6 downto 0)  <= HWDATAREG(6 downto 0) when (TestCtrlInWen = '1')
                            else
                               TestCtrlInReg;

NextTestCtrlOut(1 downto 0) <= HWDATAREG(1 downto 0) when (TestCtrlOutWen = '1')
                            else
                               TestCtrlOutReg;

-- -----------------------------------------------------------------------------
-- This block controls the actual write in HCLK domain. Here depending
-- on the register enable signals the data from the data bus is registered
-- on to the corresponding register(SMBCR7).
-- -----------------------------------------------------------------------------
p_WriteComb1 : process (Bank7CtrlWen, HWDATAREG, SMMWCS7, SMBCR7, SMBLS7POL,
                        SoftWrMW7Reg, SoftWrBLS7Reg)
begin
  NextSMBCR7       <= SMBCR7;
  if (Bank7CtrlWen = '1') then
    NextSMBCR7(21 downto 0) <= HWDATAREG(21 downto 0);
  else
    if (SoftWrMW7Reg = '0') then
      NextSMBCR7(5 downto 4) <= SMMWCS7;
    end if;

    if (SoftWrBLS7Reg = '0') then
      NextSMBCR7(6) <= SMBLS7POL;
    end if;
  end if;
end process p_WriteComb1;

-- -----------------------------------------------------------------------------
-- This block controls the actual write in HCLK domain. Here depending
-- on the register enable signals the data from the data bus is registered
-- on to the corresponding register(SMClockEnReg).
-- -----------------------------------------------------------------------------
p_WriteComb2 : process (SMClockWen, HWDATAREG, SMClockEnReg,
                        SoftWrClkReg, IntClockRatio)
begin
  NextSMClockEnReg <= SMClockEnReg;
  if (SMClockWen = '1') then
    NextSMClockEnReg             <= HWDATAREG(2 downto 0);
  elsif (SoftWrClkReg = '0') then
    NextSMClockEnReg(2 downto 1) <= IntClockRatio;
  end if;
end process p_WriteComb2;

-- -----------------------------------------------------------------------------
-- Registering the next state inputs
-- -----------------------------------------------------------------------------
p_WriteSeq : process (HCLK, HRESETn) begin
  if (HRESETn = '0') then
    SMBIDCYCR0     <= (others => '1');
    SMBWSTRDR0     <= (others => '1');
    SMBWSTBRDR0    <= (others => '1');
    SMBWSTWRR0     <= (others => '1');
    SMBWSTOENR0    <= (others => '0');
    SMBWSTWENR0    <= "0001";
    SMBCR0         <= "1100000011000000100000";

    SMBIDCYCR1     <= (others => '1');
    SMBWSTRDR1     <= (others => '1');
    SMBWSTBRDR1    <= (others => '1');
    SMBWSTWRR1     <= (others => '1');
    SMBWSTOENR1    <= (others => '0');
    SMBWSTWENR1    <= "0001";
    SMBCR1         <= "1100000011000000000000";

    SMBIDCYCR2     <= (others => '1');
    SMBWSTRDR2     <= (others => '1');
    SMBWSTBRDR2    <= (others => '1');
    SMBWSTWRR2     <= (others => '1');
    SMBWSTOENR2    <= (others => '0');
    SMBWSTWENR2    <= "0001";
    SMBCR2         <= "1100000011000000010000";

    SMBIDCYCR3     <= (others => '1');
    SMBWSTRDR3     <= (others => '1');
    SMBWSTBRDR3    <= (others => '1');
    SMBWSTWRR3     <= (others => '1');
    SMBWSTOENR3    <= (others => '0');
    SMBWSTWENR3    <= "0001";
    SMBCR3         <= "1100000011000000000000";

    SMBIDCYCR4     <= (others => '1');
    SMBWSTRDR4     <= (others => '1');
    SMBWSTBRDR4    <= (others => '1');
    SMBWSTWRR4     <= (others => '1');
    SMBWSTOENR4    <= (others => '0');
    SMBWSTWENR4    <= "0001";
    SMBCR4         <= "1100000011000000100000";

    SMBIDCYCR5     <= (others => '1');
    SMBWSTRDR5     <= (others => '1');
    SMBWSTBRDR5    <= (others => '1');
    SMBWSTWRR5     <= (others => '1');
    SMBWSTOENR5    <= (others => '0');
    SMBWSTWENR5    <= "0001";
    SMBCR5         <= "1100000011000000100000";

    SMBIDCYCR6     <= (others => '1');
    SMBWSTRDR6     <= (others => '1');
    SMBWSTBRDR6    <= (others => '1');
    SMBWSTWRR6     <= (others => '1');
    SMBWSTOENR6    <= (others => '0');
    SMBWSTWENR6    <= "0001";
    SMBCR6         <= "1100000011000000010000";

    SMBIDCYCR7     <= (others => '1');
    SMBWSTRDR7     <= (others => '1');
    SMBWSTBRDR7    <= (others => '1');
    SMBWSTWRR7     <= (others => '1');
    SMBWSTOENR7    <= (others => '0');
    SMBWSTWENR7    <= "0001";
    SMBCR7         <= "1100000011000000000000";

    SMClockEnReg   <= "001";

    TestCtrlReg    <= '0';
    TestCtrlInReg  <= (others => '0');
    TestCtrlOutReg <= (others => '0');

    SMBTOUTR0      <= '0';
    SMBTOUTR1      <= '0';
    SMBTOUTR2      <= '0';
    SMBTOUTR3      <= '0';
    SMBTOUTR4      <= '0';
    SMBTOUTR5      <= '0';
    SMBTOUTR6      <= '0';
    SMBTOUTR7      <= '0';

    iHRDATAREG     <= (others => '0');
    iMW1           <= (others => '0');
    iWaitEn1       <= '0';
    iWrapRead      <= '0';
    iSyncEnRead1   <= '0';
    iWP1           <= '0';
    iSyncEnWrite1  <= '0';

  elsif (HCLK'event and HCLK = '1') then
    SMBIDCYCR0     <= NextSMBIDCYCR0;
    SMBWSTRDR0     <= NextSMBWSTRDR0;
    SMBWSTBRDR0    <= NextSMBWSTBRDR0;
    SMBWSTWRR0     <= NextSMBWSTWRR0;
    SMBWSTOENR0    <= NextSMBWSTOENR0;
    SMBWSTWENR0    <= NextSMBWSTWENR0;
    SMBCR0         <= NextSMBCR0;

    SMBIDCYCR1     <= NextSMBIDCYCR1;
    SMBWSTRDR1     <= NextSMBWSTRDR1;
    SMBWSTBRDR1    <= NextSMBWSTBRDR1;
    SMBWSTWRR1     <= NextSMBWSTWRR1;
    SMBWSTOENR1    <= NextSMBWSTOENR1;
    SMBWSTWENR1    <= NextSMBWSTWENR1;
    SMBCR1         <= NextSMBCR1;

    SMBIDCYCR2     <= NextSMBIDCYCR2;
    SMBWSTRDR2     <= NextSMBWSTRDR2;
    SMBWSTBRDR2    <= NextSMBWSTBRDR2;
    SMBWSTWRR2     <= NextSMBWSTWRR2;
    SMBWSTOENR2    <= NextSMBWSTOENR2;
    SMBWSTWENR2    <= NextSMBWSTWENR2;
    SMBCR2         <= NextSMBCR2;

    SMBIDCYCR3     <= NextSMBIDCYCR3;
    SMBWSTRDR3     <= NextSMBWSTRDR3;
    SMBWSTBRDR3    <= NextSMBWSTBRDR3;
    SMBWSTWRR3     <= NextSMBWSTWRR3;
    SMBWSTOENR3    <= NextSMBWSTOENR3;
    SMBWSTWENR3    <= NextSMBWSTWENR3;
    SMBCR3         <= NextSMBCR3;

    SMBIDCYCR4     <= NextSMBIDCYCR4;
    SMBWSTRDR4     <= NextSMBWSTRDR4;
    SMBWSTBRDR4    <= NextSMBWSTBRDR4;
    SMBWSTWRR4     <= NextSMBWSTWRR4;
    SMBWSTOENR4    <= NextSMBWSTOENR4;
    SMBWSTWENR4    <= NextSMBWSTWENR4;
    SMBCR4         <= NextSMBCR4;

    SMBIDCYCR5     <= NextSMBIDCYCR5;
    SMBWSTRDR5     <= NextSMBWSTRDR5;
    SMBWSTBRDR5    <= NextSMBWSTBRDR5;
    SMBWSTWRR5     <= NextSMBWSTWRR5;
    SMBWSTOENR5    <= NextSMBWSTOENR5;
    SMBWSTWENR5    <= NextSMBWSTWENR5;
    SMBCR5         <= NextSMBCR5;

    SMBIDCYCR6     <= NextSMBIDCYCR6;
    SMBWSTRDR6     <= NextSMBWSTRDR6;
    SMBWSTBRDR6    <= NextSMBWSTBRDR6;
    SMBWSTWRR6     <= NextSMBWSTWRR6;
    SMBWSTOENR6    <= NextSMBWSTOENR6;
    SMBWSTWENR6    <= NextSMBWSTWENR6;
    SMBCR6         <= NextSMBCR6;

    SMBIDCYCR7     <= NextSMBIDCYCR7;
    SMBWSTRDR7     <= NextSMBWSTRDR7;
    SMBWSTBRDR7    <= NextSMBWSTBRDR7;
    SMBWSTWRR7     <= NextSMBWSTWRR7;
    SMBWSTOENR7    <= NextSMBWSTOENR7;
    SMBWSTWENR7    <= NextSMBWSTWENR7;
    SMBCR7         <= NextSMBCR7;

    SMClockEnReg   <= NextSMClockEnReg;
    TestCtrlReg    <= NextTestCtrlReg;
    TestCtrlInReg  <= NextTestCtrlIn;
    TestCtrlOutReg <= NextTestCtrlOut;

    SMBTOUTR0      <= NextSMBTOUTR0;
    SMBTOUTR1      <= NextSMBTOUTR1;
    SMBTOUTR2      <= NextSMBTOUTR2;
    SMBTOUTR3      <= NextSMBTOUTR3;
    SMBTOUTR4      <= NextSMBTOUTR4;
    SMBTOUTR5      <= NextSMBTOUTR5;
    SMBTOUTR6      <= NextSMBTOUTR6;
    SMBTOUTR7      <= NextSMBTOUTR7;

    iHRDATAREG     <= NextHrdataReg;
    iMW1           <= NextMW1;
    iWaitEn1       <= NextWaitEn1;
    iWrapRead      <= NextWrapRead;
    iSyncEnRead1   <= NextSyncEnRead1;
    iWP1           <= NextWP1;
    iSyncEnWrite1  <= NextSyncEnWrite1;

  end if;
end process p_WriteSeq;

-- -----------------------------------------------------------------------------
-- Read data path logic
-- This  block controls the actual read operation.
-- Depending on the address location for which the Master wants to read,
-- corresponding data from that register is put on the data bus.
-- -----------------------------------------------------------------------------
p_ReadComb : process (SMBIDCYCR0, SMBWSTRDR0, SMBWSTBRDR0,
                      SMBWSTWRR0, SMBWSTOENR0, SMBWSTWENR0,
                      SMBCR0,
                      SMBIDCYCR1, SMBWSTRDR1, SMBWSTBRDR1,
                      SMBWSTWRR1, SMBWSTOENR1, SMBWSTWENR1,
                      SMBCR1,
                      SMBIDCYCR2, SMBWSTRDR2, SMBWSTBRDR2,
                      SMBWSTWRR2, SMBWSTOENR2, SMBWSTWENR2,
                      SMBCR2,
                      SMBIDCYCR3, SMBWSTRDR3, SMBWSTBRDR3,
                      SMBWSTWRR3, SMBWSTOENR3, SMBWSTWENR3,
                      SMBCR3,
                      SMBIDCYCR4, SMBWSTRDR4, SMBWSTBRDR4,
                      SMBWSTWRR4, SMBWSTOENR4, SMBWSTWENR4,
                      SMBCR4,
                      SMBIDCYCR5, SMBWSTRDR5, SMBWSTBRDR5,
                      SMBWSTWRR5, SMBWSTOENR5, SMBWSTWENR5,
                      SMBCR5,
                      SMBIDCYCR6, SMBWSTRDR6, SMBWSTBRDR6,
                      SMBWSTWRR6, SMBWSTOENR6, SMBWSTWENR6,
                      SMBCR6,
                      SMBIDCYCR7, SMBWSTRDR7, SMBWSTBRDR7,
                      SMBWSTWRR7, SMBWSTOENR7, SMBWSTWENR7,
                      SMBCR7, AddressBuf,
                      SSMCPERIPHID0, SSMCPERIPHID1, SSMCPERIPHID2,
                      SSMCPERIPHID3, SSMCPCELLID0, SSMCPCELLID1,
                      SSMCPCELLID2, SSMCPCELLID3, WaitStatus, SMClockEnReg,
                      TestCtrlReg, iSMTICBUSREQEBI, iSMBUSREQEBI,
                      iSMTICBUSGNTExt, SMBUSGNTTest, iBUSMUXEXT, iHRDATAREG,
                      IntClockRatio, iBIGENDIAN, Revision, iSmBusBackOffExt,
                      SMBTOUTR0, SMBTOUTR1, SMBTOUTR2, SMBTOUTR3, 
                      SMBTOUTR4, SMBTOUTR5, SMBTOUTR6, SMBTOUTR7)
begin
  NextHrdataReg <= iHRDATAREG;
  case AddressBuf is
    when HADDR_SMBIDCYR0   =>
      NextHrdataReg <= (ZEROFILL(27 downto 0) & SMBIDCYCR0);

    when HADDR_SMBWSTRDR0  =>
      NextHrdataReg <= (ZEROFILL(26 downto 0) & SMBWSTRDR0);

    when HADDR_SMBWSTWRR0  =>
      NextHrdataReg <= (ZEROFILL(26 downto 0) & SMBWSTWRR0);

    when HADDR_SMBWSTOENR0 =>
      NextHrdataReg <= (ZEROFILL(27 downto 0) & SMBWSTOENR0);

    when HADDR_SMBWSTWENR0 =>
      NextHrdataReg <= (ZEROFILL(27 downto 0) & SMBWSTWENR0);

    when HADDR_SMBCR0      =>
      NextHrdataReg <= (ZEROFILL(9 downto 0) & SMBCR0);

    when HADDR_SMBSR0      =>
      NextHrdataReg <= (ZEROFILL(30 downto 0) & SMBTOUTR0);

    when HADDR_SMBWSTBRDR0 =>
      NextHrdataReg <= (ZEROFILL(26 downto 0) & SMBWSTBRDR0);

    when HADDR_SMBIDCYR1   =>
      NextHrdataReg <= (ZEROFILL(27 downto 0) & SMBIDCYCR1);

    when HADDR_SMBWSTRDR1  =>
      NextHrdataReg <= (ZEROFILL(26 downto 0) & SMBWSTRDR1);

    when HADDR_SMBWSTWRR1  =>
      NextHrdataReg <= (ZEROFILL(26 downto 0) & SMBWSTWRR1);

    when HADDR_SMBWSTOENR1 =>
      NextHrdataReg <= (ZEROFILL(27 downto 0) & SMBWSTOENR1);

    when HADDR_SMBWSTWENR1 =>
      NextHrdataReg <= (ZEROFILL(27 downto 0) & SMBWSTWENR1);

    when HADDR_SMBCR1      =>
      NextHrdataReg <= (ZEROFILL(9 downto 0) & SMBCR1);

    when HADDR_SMBSR1      =>
      NextHrdataReg <= (ZEROFILL(30 downto 0) & SMBTOUTR1);

    when HADDR_SMBWSTBRDR1 =>
      NextHrdataReg <= (ZEROFILL(26 downto 0) & SMBWSTBRDR1);

    when HADDR_SMBIDCYR2   =>
      NextHrdataReg <= (ZEROFILL(27 downto 0) & SMBIDCYCR2);

    when HADDR_SMBWSTRDR2  =>
      NextHrdataReg <= (ZEROFILL(26 downto 0) & SMBWSTRDR2);

    when HADDR_SMBWSTOENR2 =>
      NextHrdataReg <= (ZEROFILL(27 downto 0) & SMBWSTOENR2);

    when HADDR_SMBWSTWRR2  =>
      NextHrdataReg <= (ZEROFILL(26 downto 0) & SMBWSTWRR2);

    when HADDR_SMBWSTWENR2 =>
      NextHrdataReg <= (ZEROFILL(27 downto 0) & SMBWSTWENR2);

    when HADDR_SMBCR2      =>
      NextHrdataReg <= (ZEROFILL(9 downto 0) & SMBCR2);

    when HADDR_SMBSR2      =>
      NextHrdataReg <= (ZEROFILL(30 downto 0) & SMBTOUTR2);

    when HADDR_SMBWSTBRDR2 =>
      NextHrdataReg <= (ZEROFILL(26 downto 0) & SMBWSTBRDR2);

    when HADDR_SMBIDCYR3   =>
      NextHrdataReg <= (ZEROFILL(27 downto 0) & SMBIDCYCR3);

    when HADDR_SMBWSTRDR3  =>
      NextHrdataReg <= (ZEROFILL(26 downto 0) & SMBWSTRDR3);

    when HADDR_SMBWSTOENR3 =>
      NextHrdataReg <= (ZEROFILL(27 downto 0) & SMBWSTOENR3);

    when HADDR_SMBWSTWRR3  =>
      NextHrdataReg <= (ZEROFILL(26 downto 0) & SMBWSTWRR3);

    when HADDR_SMBWSTWENR3 =>
      NextHrdataReg <= (ZEROFILL(27 downto 0) & SMBWSTWENR3);

    when HADDR_SMBCR3      =>
      NextHrdataReg <= (ZEROFILL(9 downto 0) & SMBCR3);

    when HADDR_SMBSR3      =>
      NextHrdataReg <= (ZEROFILL(30 downto 0) & SMBTOUTR3);

    when HADDR_SMBWSTBRDR3 =>
      NextHrdataReg <= (ZEROFILL(26 downto 0) & SMBWSTBRDR3);

    when HADDR_SMBIDCYR4   =>
      NextHrdataReg <= (ZEROFILL(27 downto 0) & SMBIDCYCR4);

    when HADDR_SMBWSTRDR4  =>
      NextHrdataReg <= (ZEROFILL(26 downto 0) & SMBWSTRDR4);

    when HADDR_SMBWSTOENR4 =>
      NextHrdataReg <= (ZEROFILL(27 downto 0) & SMBWSTOENR4);

    when HADDR_SMBWSTWRR4  =>
      NextHrdataReg <= (ZEROFILL(26 downto 0) & SMBWSTWRR4);

    when HADDR_SMBWSTWENR4 =>
      NextHrdataReg <= (ZEROFILL(27 downto 0) & SMBWSTWENR4);

    when HADDR_SMBCR4      =>
      NextHrdataReg <= (ZEROFILL(9 downto 0) & SMBCR4);

    when HADDR_SMBSR4      =>
      NextHrdataReg <= (ZEROFILL(30 downto 0) & SMBTOUTR4);

    when HADDR_SMBWSTBRDR4 =>
      NextHrdataReg <= (ZEROFILL(26 downto 0) & SMBWSTBRDR4);

    when HADDR_SMBIDCYR5   =>
      NextHrdataReg <= (ZEROFILL(27 downto 0) & SMBIDCYCR5);

    when HADDR_SMBWSTRDR5  =>
      NextHrdataReg <= (ZEROFILL(26 downto 0) & SMBWSTRDR5);

    when HADDR_SMBWSTOENR5 =>
      NextHrdataReg <= (ZEROFILL(27 downto 0) & SMBWSTOENR5);

    when HADDR_SMBWSTWRR5  =>
      NextHrdataReg <= (ZEROFILL(26 downto 0) & SMBWSTWRR5);

    when HADDR_SMBWSTWENR5 =>
      NextHrdataReg <= (ZEROFILL(27 downto 0) & SMBWSTWENR5);

    when HADDR_SMBCR5      =>
      NextHrdataReg <= (ZEROFILL(9 downto 0) & SMBCR5);

    when HADDR_SMBSR5      =>
      NextHrdataReg <= (ZEROFILL(30 downto 0) & SMBTOUTR5);

    when HADDR_SMBWSTBRDR5 =>
      NextHrdataReg <= (ZEROFILL(26 downto 0) & SMBWSTBRDR5);

    when HADDR_SMBIDCYR6   =>
      NextHrdataReg <= (ZEROFILL(27 downto 0) & SMBIDCYCR6);

    when HADDR_SMBWSTRDR6  =>
      NextHrdataReg <= (ZEROFILL(26 downto 0) & SMBWSTRDR6);

    when HADDR_SMBWSTOENR6 =>
      NextHrdataReg <= (ZEROFILL(27 downto 0) & SMBWSTOENR6);

    when HADDR_SMBWSTWRR6  =>
      NextHrdataReg <= (ZEROFILL(26 downto 0) & SMBWSTWRR6);

    when HADDR_SMBWSTWENR6 =>
      NextHrdataReg <= (ZEROFILL(27 downto 0) & SMBWSTWENR6);

    when HADDR_SMBCR6      =>
      NextHrdataReg <= (ZEROFILL(9 downto 0) & SMBCR6);

    when HADDR_SMBSR6      =>
      NextHrdataReg <= (ZEROFILL(30 downto 0) & SMBTOUTR6);

    when HADDR_SMBWSTBRDR6 =>
      NextHrdataReg <= (ZEROFILL(26 downto 0) & SMBWSTBRDR6);

    when HADDR_SMBIDCYR7   =>
      NextHrdataReg <= (ZEROFILL(27 downto 0) & SMBIDCYCR7);

    when HADDR_SMBWSTRDR7  =>
      NextHrdataReg <= (ZEROFILL(26 downto 0) & SMBWSTRDR7);

    when HADDR_SMBWSTOENR7 =>
      NextHrdataReg <= (ZEROFILL(27 downto 0) & SMBWSTOENR7);

    when HADDR_SMBWSTWRR7  =>
      NextHrdataReg <= (ZEROFILL(26 downto 0) & SMBWSTWRR7);

    when HADDR_SMBWSTWENR7 =>
      NextHrdataReg <= (ZEROFILL(27 downto 0) & SMBWSTWENR7);

    when HADDR_SMBCR7      =>
      NextHrdataReg <= (ZEROFILL(9 downto 0) & SMBCR7);

    when HADDR_SMBSR7      =>
      NextHrdataReg <= (ZEROFILL(30 downto 0) & SMBTOUTR7);

    when HADDR_SMBWSTBRDR7 =>
      NextHrdataReg <= (ZEROFILL(26 downto 0) & SMBWSTBRDR7);

    when HADDR_SMCR        =>
      NextHrdataReg <= (ZEROFILL(28 downto 0) & SMClockEnReg);

    when HADDR_SMSR =>
      NextHrdataReg <= (ZEROFILL(30 downto 0) & WaitStatus);

    when HADDR_SMITCR =>
      NextHrdataReg <= (ZEROFILL(30 downto 0) & TestCtrlReg);

    when HADDR_SMITIP =>
      NextHrdataReg <= (ZEROFILL(24 downto 0) & iSmBusBackOffExt &
                        iSMTICBUSGNTExt & SMBUSGNTTest &
                        iBUSMUXEXT & IntClockRatio & iBIGENDIAN);

    when HADDR_SMITOP =>
      NextHrdataReg <= (ZEROFILL(29 downto 0) & iSMTICBUSREQEBI & iSMBUSREQEBI);

    when HADDR_SSMCPERIPHID0 =>
      NextHrdataReg <= (ZEROFILL(23 downto 0) & SSMCPERIPHID0);

    when HADDR_SSMCPERIPHID1 =>
      NextHrdataReg <= (ZEROFILL(23 downto 0) & SSMCPERIPHID1);

    when HADDR_SSMCPERIPHID2 =>
      NextHrdataReg <= (ZEROFILL(23 downto 0) & Revision & SSMCPERIPHID2);

    when HADDR_SSMCPERIPHID3 =>
      NextHrdataReg <= (ZEROFILL(23 downto 0) & SSMCPERIPHID3);

    when HADDR_SSMCPCELLID0  =>
      NextHrdataReg <= (ZEROFILL(23 downto 0) & SSMCPCELLID0);

    when HADDR_SSMCPCELLID1  =>
      NextHrdataReg <= (ZEROFILL(23 downto 0) & SSMCPCELLID1);

    when HADDR_SSMCPCELLID2  =>
      NextHrdataReg <= (ZEROFILL(23 downto 0) & SSMCPCELLID2);

    when HADDR_SSMCPCELLID3  =>
      NextHrdataReg <= (ZEROFILL(23 downto 0) & SSMCPCELLID3);

    when others => null;
  end case;
end process p_ReadComb;

-- -----------------------------------------------------------------------------
-- Few bank informations are registered separately to meet timing
-- -----------------------------------------------------------------------------
p_FewBnkInfoComb : process (SMBCR0, SMBCR1, SMBCR2, SMBCR3, SMBCR4, SMBCR5, 
                            SMBCR6, SMBCR7, iMW1, HSELSMC, HTRANSSMC, iWaitEn1, 
                            iWrapRead, iSyncEnRead1, iWP1, iSyncEnWrite1,
                            HREADYINSMC)
begin
  NextMW1          <= iMW1;
  NextWaitEn1      <= iWaitEn1;
  NextWrapRead     <= iWrapRead;
  NextSyncEnRead1  <= iSyncEnRead1;
  NextWP1          <= iWP1;
  NextSyncEnWrite1 <= iSyncEnWrite1;
  if ((HTRANSSMC and HREADYINSMC) = '1') then
    case HSELSMC is
      when BANK0 =>
        NextMW1          <= SMBCR0(5 downto 4);
        NextWaitEn1      <= SMBCR0(2);
        NextWrapRead     <= SMBCR0(14);
        NextSyncEnRead1  <= SMBCR0(9);
        NextWP1          <= SMBCR0(3);
        NextSyncEnWrite1 <= SMBCR0(17);
 
      when BANK1 =>
        NextMW1          <= SMBCR1(5 downto 4);
        NextWaitEn1      <= SMBCR1(2);
        NextWrapRead     <= SMBCR1(14);
        NextSyncEnRead1  <= SMBCR1(9);
        NextWP1          <= SMBCR1(3);
        NextSyncEnWrite1 <= SMBCR1(17);
 
      when BANK2 =>
        NextMW1          <= SMBCR2(5 downto 4);
        NextWaitEn1      <= SMBCR2(2);
        NextWrapRead     <= SMBCR2(14);
        NextSyncEnRead1  <= SMBCR2(9);
        NextWP1          <= SMBCR2(3);
        NextSyncEnWrite1 <= SMBCR2(17);

      when BANK3 =>
        NextMW1          <= SMBCR3(5 downto 4);
        NextWaitEn1      <= SMBCR3(2);
        NextWrapRead     <= SMBCR3(14);
        NextSyncEnRead1  <= SMBCR3(9);
        NextWP1          <= SMBCR3(3);
        NextSyncEnWrite1 <= SMBCR3(17);

      when BANK4 =>
        NextMW1          <= SMBCR4(5 downto 4);
        NextWaitEn1      <= SMBCR4(2);
        NextWrapRead     <= SMBCR4(14);
        NextSyncEnRead1  <= SMBCR4(9);
        NextWP1          <= SMBCR4(3);
        NextSyncEnWrite1 <= SMBCR4(17);

      when BANK5 =>
        NextMW1          <= SMBCR5(5 downto 4);
        NextWaitEn1      <= SMBCR5(2);
        NextWrapRead     <= SMBCR5(14);
        NextSyncEnRead1  <= SMBCR5(9);
        NextWP1          <= SMBCR5(3);
        NextSyncEnWrite1 <= SMBCR5(17);

      when BANK6 =>
        NextMW1          <= SMBCR6(5 downto 4);
        NextWaitEn1      <= SMBCR6(2);
        NextWrapRead     <= SMBCR6(14);
        NextSyncEnRead1  <= SMBCR6(9);
        NextWP1          <= SMBCR6(3);
        NextSyncEnWrite1 <= SMBCR6(17);

      when BANK7 =>
        NextMW1          <= SMBCR7(5 downto 4);
        NextWaitEn1      <= SMBCR7(2);
        NextWrapRead     <= SMBCR7(14);
        NextSyncEnRead1  <= SMBCR7(9);
        NextWP1          <= SMBCR7(3);
        NextSyncEnWrite1 <= SMBCR7(17);

      when others =>
        null;
    end case;
  end if;
end process p_FewBnkInfoComb;

-- -----------------------------------------------------------------------------
-- Routing the Memory Bank Resources for other modules.
-- These resources are required while making state transitions, Turnaround
-- decision, when degranted...
-- HselMemBuf1 is used as multiplexer select input to decide the bank number.
-- -----------------------------------------------------------------------------
p_BankInfoMux : process (SMBCR0, SMBWSTRDR0, SMBWSTBRDR0,
                         SMBWSTWRR0, SMBWSTOENR0, SMBWSTWENR0,
                         SMBIDCYCR0,
                         SMBCR1, SMBWSTRDR1, SMBWSTBRDR1,
                         SMBWSTWRR1, SMBWSTOENR1, SMBWSTWENR1,
                         SMBIDCYCR1,
                         SMBCR2, SMBWSTRDR2, SMBWSTBRDR2,
                         SMBWSTWRR2, SMBWSTOENR2, SMBWSTWENR2,
                         SMBIDCYCR2,
                         SMBCR3, SMBWSTRDR3, SMBWSTBRDR3,
                         SMBWSTWRR3, SMBWSTOENR3, SMBWSTWENR3,
                         SMBIDCYCR3,
                         SMBCR4, SMBWSTRDR4, SMBWSTBRDR4,
                         SMBWSTWRR4, SMBWSTOENR4, SMBWSTWENR4,
                         SMBIDCYCR4,
                         SMBCR5, SMBWSTRDR5, SMBWSTBRDR5,
                         SMBWSTWRR5, SMBWSTOENR5, SMBWSTWENR5,
                         SMBIDCYCR5,
                         SMBCR6, SMBWSTRDR6, SMBWSTBRDR6,
                         SMBWSTWRR6, SMBWSTOENR6, SMBWSTWENR6,
                         SMBIDCYCR6,
                         SMBCR7, SMBWSTRDR7, SMBWSTBRDR7,
                         SMBWSTWRR7, SMBWSTOENR7, SMBWSTWENR7,
                         SMBIDCYCR7, HselMemBuf1)
begin
  BIWriteEn1        <= '0';
  AddrValWriteEn1   <= '0';
  BurstLenWrite1    <= "00";
  BMWrite1          <= '0';
  BIReadEn1         <= '0';
  AddrValidReadEn1  <= '0';
  BurstLenRead1     <= "00";
  BMRead1           <= '0';
  SMBLSPol1         <= '0';
  WaitPol1          <= '0';
  RBLE1             <= '0';
  WSTRD1            <= "11111";
  WSTBRD1           <= "11111";
  WSTWR1            <= "11111";
  WSTOEN1           <= "0000";
  WSTWEN1           <= "0001";
  IDCYC1            <= "1111";
  case HselMemBuf1 is
    when BANK0 =>
      BIWriteEn1        <= SMBCR0(21);
      AddrValWriteEn1   <= SMBCR0(20);
      BurstLenWrite1    <= SMBCR0(19 downto 18);
      BMWrite1          <= SMBCR0(16);
      BIReadEn1         <= SMBCR0(13);
      AddrValidReadEn1  <= SMBCR0(12);
      BurstLenRead1     <= SMBCR0(11 downto 10);
      BMRead1           <= SMBCR0(8);
      SMBLSPol1         <= SMBCR0(6);
      WaitPol1          <= SMBCR0(1);
      RBLE1             <= SMBCR0(0);
      WSTRD1            <= SMBWSTRDR0;
      WSTBRD1           <= SMBWSTBRDR0;
      WSTWR1            <= SMBWSTWRR0;
      WSTOEN1           <= SMBWSTOENR0;
      WSTWEN1           <= SMBWSTWENR0;
      IDCYC1            <= SMBIDCYCR0;
    when BANK1 =>
      BIWriteEn1        <= SMBCR1(21);
      AddrValWriteEn1   <= SMBCR1(20);
      BurstLenWrite1    <= SMBCR1(19 downto 18);
      BMWrite1          <= SMBCR1(16);
      BIReadEn1         <= SMBCR1(13);
      AddrValidReadEn1  <= SMBCR1(12);
      BurstLenRead1     <= SMBCR1(11 downto 10);
      BMRead1           <= SMBCR1(8);
      SMBLSPol1         <= SMBCR1(6);
      WaitPol1          <= SMBCR1(1);
      RBLE1             <= SMBCR1(0);
      WSTRD1            <= SMBWSTRDR1;
      WSTBRD1           <= SMBWSTBRDR1;
      WSTWR1            <= SMBWSTWRR1;
      WSTOEN1           <= SMBWSTOENR1;
      WSTWEN1           <= SMBWSTWENR1;
      IDCYC1            <= SMBIDCYCR1;
    when BANK2 =>
      BIWriteEn1        <= SMBCR2(21);
      AddrValWriteEn1   <= SMBCR2(20);
      BurstLenWrite1    <= SMBCR2(19 downto 18);
      BMWrite1          <= SMBCR2(16);
      BIReadEn1         <= SMBCR2(13);
      AddrValidReadEn1  <= SMBCR2(12);
      BurstLenRead1     <= SMBCR2(11 downto 10);
      BMRead1           <= SMBCR2(8);
      SMBLSPol1         <= SMBCR2(6);
      WaitPol1          <= SMBCR2(1);
      RBLE1             <= SMBCR2(0);
      WSTRD1            <= SMBWSTRDR2;
      WSTBRD1           <= SMBWSTBRDR2;
      WSTWR1            <= SMBWSTWRR2;
      WSTOEN1           <= SMBWSTOENR2;
      WSTWEN1           <= SMBWSTWENR2;
      IDCYC1            <= SMBIDCYCR2;
    when BANK3 =>
      BIWriteEn1        <= SMBCR3(21);
      AddrValWriteEn1   <= SMBCR3(20);
      BurstLenWrite1    <= SMBCR3(19 downto 18);
      BMWrite1          <= SMBCR3(16);
      BIReadEn1         <= SMBCR3(13);
      AddrValidReadEn1  <= SMBCR3(12);
      BurstLenRead1     <= SMBCR3(11 downto 10);
      BMRead1           <= SMBCR3(8);
      SMBLSPol1         <= SMBCR3(6);
      WaitPol1          <= SMBCR3(1);
      RBLE1             <= SMBCR3(0);
      WSTRD1            <= SMBWSTRDR3;
      WSTBRD1           <= SMBWSTBRDR3;
      WSTWR1            <= SMBWSTWRR3;
      WSTOEN1           <= SMBWSTOENR3;
      WSTWEN1           <= SMBWSTWENR3;
      IDCYC1            <= SMBIDCYCR3;
    when BANK4 =>
      BIWriteEn1        <= SMBCR4(21);
      AddrValWriteEn1   <= SMBCR4(20);
      BurstLenWrite1    <= SMBCR4(19 downto 18);
      BMWrite1          <= SMBCR4(16);
      BIReadEn1         <= SMBCR4(13);
      AddrValidReadEn1  <= SMBCR4(12);
      BurstLenRead1     <= SMBCR4(11 downto 10);
      BMRead1           <= SMBCR4(8);
      SMBLSPol1         <= SMBCR4(6);
      WaitPol1          <= SMBCR4(1);
      RBLE1             <= SMBCR4(0);
      WSTRD1            <= SMBWSTRDR4;
      WSTBRD1           <= SMBWSTBRDR4;
      WSTWR1            <= SMBWSTWRR4;
      WSTOEN1           <= SMBWSTOENR4;
      WSTWEN1           <= SMBWSTWENR4;
      IDCYC1            <= SMBIDCYCR4;
    when BANK5 =>
      BIWriteEn1        <= SMBCR5(21);
      AddrValWriteEn1   <= SMBCR5(20);
      BurstLenWrite1    <= SMBCR5(19 downto 18);
      BMWrite1          <= SMBCR5(16);
      BIReadEn1         <= SMBCR5(13);
      AddrValidReadEn1  <= SMBCR5(12);
      BurstLenRead1     <= SMBCR5(11 downto 10);
      BMRead1           <= SMBCR5(8);
      SMBLSPol1         <= SMBCR5(6);
      WaitPol1          <= SMBCR5(1);
      RBLE1             <= SMBCR5(0);
      WSTRD1            <= SMBWSTRDR5;
      WSTBRD1           <= SMBWSTBRDR5;
      WSTWR1            <= SMBWSTWRR5;
      WSTOEN1           <= SMBWSTOENR5;
      WSTWEN1           <= SMBWSTWENR5;
      IDCYC1            <= SMBIDCYCR5;
    when BANK6 =>
      BIWriteEn1        <= SMBCR6(21);
      AddrValWriteEn1   <= SMBCR6(20);
      BurstLenWrite1    <= SMBCR6(19 downto 18);
      BMWrite1          <= SMBCR6(16);
      BIReadEn1         <= SMBCR6(13);
      AddrValidReadEn1  <= SMBCR6(12);
      BurstLenRead1     <= SMBCR6(11 downto 10);
      BMRead1           <= SMBCR6(8);
      SMBLSPol1         <= SMBCR6(6);
      WaitPol1          <= SMBCR6(1);
      RBLE1             <= SMBCR6(0);
      WSTRD1            <= SMBWSTRDR6;
      WSTBRD1           <= SMBWSTBRDR6;
      WSTWR1            <= SMBWSTWRR6;
      WSTOEN1           <= SMBWSTOENR6;
      WSTWEN1           <= SMBWSTWENR6;
      IDCYC1            <= SMBIDCYCR6;
    when BANK7 =>
      BIWriteEn1        <= SMBCR7(21);
      AddrValWriteEn1   <= SMBCR7(20);
      BurstLenWrite1    <= SMBCR7(19 downto 18);
      BMWrite1          <= SMBCR7(16);
      BIReadEn1         <= SMBCR7(13);
      AddrValidReadEn1  <= SMBCR7(12);
      BurstLenRead1     <= SMBCR7(11 downto 10);
      BMRead1           <= SMBCR7(8);
      SMBLSPol1         <= SMBCR7(6);
      WaitPol1          <= SMBCR7(1);
      RBLE1             <= SMBCR7(0);
      WSTRD1            <= SMBWSTRDR7;
      WSTBRD1           <= SMBWSTBRDR7;
      WSTWR1            <= SMBWSTWRR7;
      WSTOEN1           <= SMBWSTOENR7;
      WSTWEN1           <= SMBWSTWENR7;
      IDCYC1            <= SMBIDCYCR7;
    when others =>
      null;
  end case;
end process p_BankInfoMux;

-- ----------------------------------------------------------------------------
-- Routing the WaitToutErr to appropriate banks.
-- ----------------------------------------------------------------------------
p_ErrCondGenComb : process (HselMemBuf1, WaitToutErr)
begin
  Bank0ToutErr <= '0';
  Bank1ToutErr <= '0';
  Bank2ToutErr <= '0';
  Bank3ToutErr <= '0';
  Bank4ToutErr <= '0';
  Bank5ToutErr <= '0';
  Bank6ToutErr <= '0';
  Bank7ToutErr <= '0';

  case HselMemBuf1 is
    when BANK0 =>
      Bank0ToutErr  <= WaitToutErr;

    when BANK1 =>
      Bank1ToutErr  <= WaitToutErr;

    when BANK2 =>
      Bank2ToutErr  <= WaitToutErr;

    when BANK3 =>
      Bank3ToutErr  <= WaitToutErr;

    when BANK4 =>
      Bank4ToutErr  <= WaitToutErr;

    when BANK5 =>
      Bank5ToutErr  <= WaitToutErr;

    when BANK6 =>
      Bank6ToutErr  <= WaitToutErr;

    when BANK7 =>
      Bank7ToutErr  <= WaitToutErr;

    when others =>
      null;
  end case;
end process p_ErrCondGenComb;

-- ----------------------------------------------------------------------------
-- Registering and clearing the WaitToutErr for appropriate banks.
-- ----------------------------------------------------------------------------
NextSMBTOUTR0 <= '1' when (Bank0ToutErr = '1')
              else
                 '0' when (Bank0ToutClr = '1')
              else
                 SMBTOUTR0;

NextSMBTOUTR1 <= '1' when (Bank1ToutErr = '1')
              else
                 '0' when (Bank1ToutClr = '1')
              else
                 SMBTOUTR1;

NextSMBTOUTR2 <= '1' when (Bank2ToutErr = '1')
              else
                 '0' when (Bank2ToutClr = '1')
              else
                 SMBTOUTR2;

NextSMBTOUTR3 <= '1' when (Bank3ToutErr = '1')
              else
                 '0' when (Bank3ToutClr = '1')
              else
                 SMBTOUTR3;

NextSMBTOUTR4 <= '1' when (Bank4ToutErr = '1')
              else
                 '0' when (Bank4ToutClr = '1')
              else
                 SMBTOUTR4;

NextSMBTOUTR5 <= '1' when (Bank5ToutErr = '1')
              else
                 '0' when (Bank5ToutClr = '1')
              else
                 SMBTOUTR5;

NextSMBTOUTR6 <= '1' when (Bank6ToutErr = '1')
              else
                 '0' when (Bank6ToutClr = '1')
              else
                 SMBTOUTR6;

NextSMBTOUTR7 <= '1' when (Bank7ToutErr = '1')
              else
                 '0' when (Bank7ToutClr = '1')
              else
                 SMBTOUTR7;

-- ----------------------------------------------------------------------------
-- Integration Output Mux Implementation.
-- ----------------------------------------------------------------------------
iSMTICBUSREQEBI <= TestCtrlOutReg(1) when (TestCtrlReg = '1')
                else
                   SMTICBUSREQExt;


iSMBUSREQEBI <= TestCtrlOutReg(0) when (TestCtrlReg = '1')
             else
                SMBUSREQExt;

-- ----------------------------------------------------------------------------
-- Integration Input Mux Implementation
-- ----------------------------------------------------------------------------
iSmBusBackOffExt <= TestCtrlInReg(6) when (TestCtrlReg = '1')
                 else
                    SmBusBackOffReg;

iSMTICBUSGNTExt <= TestCtrlInReg(5) when (TestCtrlReg = '1')
                else
                   SmTicGntEbiReg;

SMBUSGNTTest    <= TestCtrlInReg(4) when (TestCtrlReg = '1')
                else
                   SmBusGntEbiReg;

iBUSMUXEXT      <= TestCtrlInReg(3) when (TestCtrlReg = '1')
                else
                   SMEXTBUSMUX;

IntClockRatio   <= TestCtrlInReg(2 downto 1) when (TestCtrlReg = '1')
                else
                   SMMEMCLKRATIO;

iBIGENDIAN      <= TestCtrlInReg(0) when (TestCtrlReg = '1')
                else
                   SMBIGENDIAN;

end synth;

-- --================================== End ==================================--
