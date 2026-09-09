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
-- File Name              : SmcTrAhbifReg.vhd.rca
-- File Revision          : 1.9
--
-- Release Information    : PrimeCell(TM)-PL092-REL1v1
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block interfaces the SMC Trickbox with the AHB.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SmcTrAhbifReg is
  port (
-- Inputs
        -- AHB bus signals
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
-- Outputs
        HRDATA           : out   std_logic_vector(31 downto 0);
                                            -- AHB Read Data bus
        HREADYOUT        : out   std_logic; -- Slave HREADY output
        HRESP            : out   std_logic_vector(1 downto 0);
                                            -- Slave response
        ENDIANCNT        : out   std_logic; -- Endianness of the System
        REMAP            : out   std_logic; -- Reset/Normal Memory map select

        -- SMC related signals
        SMMWCS7          : out   std_logic_vector(1 downto 0);
                                            -- Boot Memory Bank Width
        SMCTrCS2WTR0     : out   std_logic_vector(25 downto 0);
                                            -- SMCTrCS2WTR0 Register
        SMCTrCEWTR0      : out   std_logic_vector(23 downto 0);
                                            -- SMCTrCEWTR0 Register
        SMCTrCS2WTR1     : out   std_logic_vector(25 downto 0);
                                            -- SMCTrCS2WTR1 Register
        SMCTrCEWTR1      : out   std_logic_vector(23 downto 0);
                                            -- SMCTrCEWTR1 Register
        SMCTrCS2WTR2     : out   std_logic_vector(25 downto 0);
                                            -- SMCTrCS2WTR2 Register
        SMCTrCEWTR2      : out   std_logic_vector(23 downto 0);
                                            -- SMCTrCEWTR2 Register
        SMCTrCS2WTR3     : out   std_logic_vector(25 downto 0);
                                            -- SMCTrCS2WTR3 Register
        SMCTrCEWTR3      : out   std_logic_vector(23 downto 0);
                                            -- SMCTrCEWTR3 Register
        SMCTrCS2WTR4     : out   std_logic_vector(25 downto 0);
                                            -- SMCTrCS2WTR4 Register
        SMCTrCEWTR4      : out   std_logic_vector(23 downto 0);
                                            -- SMCTrCEWTR4 Register
        SMCTrCS2WTR5     : out   std_logic_vector(25 downto 0);
                                            -- SMCTrCS2WTR5 Register
        SMCTrCEWTR5      : out   std_logic_vector(23 downto 0);
                                            -- SMCTrCEWTR5 Register
        SMCTrCS2WTR6     : out   std_logic_vector(25 downto 0);
                                            -- SMCTrCS2WTR6 Register
        SMCTrCEWTR6      : out   std_logic_vector(23 downto 0);
                                            -- SMCTrCEWTR6 Register
        SMCTrCS2WTR7     : out   std_logic_vector(25 downto 0);
                                            -- SMCTrCS2WTR7 Register
        SMCTrCEWTR7      : out   std_logic_vector(23 downto 0);
                                            -- SMCTrCEWTR7 Register
        SMCTrMCREQD      : out   std_logic_vector(4 downto 0);
                                            -- MCBUS Access to REQUEST Delay
                                            -- Count Register
        SMCTrGNT2RMREQ   : out   std_logic_vector(4 downto 0);
                                            -- MCBUS Grant to REQUEST
                                            -- de-assertion delay count
                                            -- Register
        SMCTrMCADDR      : out   std_logic_vector(25 downto 0);
                                            -- Address to eb driven out
                                            -- to the MCADDR bus of the SMC
        SMCTrMCDATAOUT   : out   std_logic_vector(31 downto 0);
                                            -- Data to be driven out to the
                                            -- MCDATAOUT bus of the SMC
        SMCTrMCBUSRRd    : out   std_logic; -- MCBUS Read Enable
        SMCTrMCBUSRWr    : out   std_logic  -- MCBUS Write Enable
       );
end SmcTrAhbifReg;

-- -----------------------------------------------------------------------------
--
--                                SmcTrAhbifReg
--                                =============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- SMC Tricbox is an AHB slave. This block performs the following operations:
--   - Interfaces the Trickbox with the AHB
--       All slave response signals are generated from this module.
--       This module decodes AHB accesses and generates the read/write
--       strobe to the appropriate registers.
--   - Implements SMC Trickbox registers
--   - Drives non-AMBA, non-memory related signals into the SMC
--
-- -----------------------------------------------------------------------------
--                         SMC Trickbox Register Map
-- -----------------------------------------------------------------------------
-- Offset    Register    Type   Width    Describtion
-- -----------------------------------------------------------------------------
-- 0x0000 -  SMCTrMWCS     R/W   2-bits  These bits determine the memory width.
--                                       These are clocked, but not affected by
--                                       HRESETn. Used to check SMMWCS1
--                                       functionality.
--                                       00 -> 8 bits wide memory
--                                       01 -> 16 bits wide memory
--                                       10 -> 32 bits wide memory
--                                       11 -> 8 bits wide memory
--
-- 0x0004    SMCTrREMAP    R/W  1-bit    Indicates the state of the memory map.
--                                       0 -> Reset memory map (SMCS[1] shadows
--                                            SMCS[0])
--                                       1 -> Normal memory map
--                                       This bit is clocked, but not affected
--                                       by HRESETn.
--
-- 0x0008    SMCTrEndian   R/W  1-bit    Indicates the type of Endianness of
--                                       the System. The value put in this
--                                       register is driven on BIGENDIAN input
--                                       of the SMC.
--
--           SMCTrCS2WTRx  R/W  26-bits  This register determines the time
--                                       duration between nCS and SmcTrWait
--                                       assertions for Bank x.
--
-- 0x000C    SMCTrCS2WTR0  R/W  26-bits
-- 0x0014    SMCTrCS2WTR1  R/W  26-bits
-- 0x001C    SMCTrCS2WTR2  R/W  26-bits
-- 0x0024    SMCTrCS2WTR3  R/W  26-bits
-- 0x002C    SMCTrCS2WTR4  R/W  26-bits
-- 0x0034    SMCTrCS2WTR5  R/W  26-bits
-- 0x003C    SMCTrCS2WTR6  R/W  26-bits
-- 0x0044    SMCTrCS2WTR7  R/W  26-bits
--
--           SMCTrCEWTRx   R/W  26-bits  This register determines the time
--                                       duration between counter expiry and
--                                       the SMWAIT de-assertion for Bank x.
--
-- 0x0010    SMCTrCEWTR0   R/W  26-bits
-- 0x0018    SMCTrCEWTR1   R/W  26-bits
-- 0x0020    SMCTrCEWTR2   R/W  26-bits
-- 0x0028    SMCTrCEWTR3   R/W  26-bits
-- 0x0030    SMCTrCEWTR4   R/W  26-bits
-- 0x0038    SMCTrCEWTR5   R/W  26-bits
-- 0x0040    SMCTrCEWTR6   R/W  26-bits
-- 0x0048    SMCTrCEWTR7   R/W  26-bits
--
-- 0x004C    SMCTrMCREQD   R/W  5-bit    This register determines the time
--                                       duration between the access to the
--                                       address SMCTrMCBUSR and the MCBUSREQ
--                                       assertion.
--
-- 0x0050    SMCTrGNT2RMREQ R/W 5-bit    This register determines the time
--                                       delay for the MCBUSREQ de-assertion
--                                       after getting the MCBUSGNT.
--
-- 0x0054    SMCTrMCADDR   R/W  32-bits  This register holds the value to be
--                                       driven out through the MCADDR bus to
--                                       the SMC.
--
-- 0x0058    SMCTrMCBUSR   R/W  32-bits  An access to this address causes the
--                                       MCBUSREQ line to go HIGH after a
--                                       delay. The delay is determined by the
--                                       value programmed in SMCTrMCREQD
--                                       register. A write access drives out
--                                       the written data to be driven out
--                                       through the MCDATAOUT lines to the
--                                       SMC. Switching between write and read
--                                       to this address toggles the MCDATAEN
--                                       lines.
--
-- -----------------------------------------------------------------------------

-- --============================ ARCHITECTURE ===============================--

architecture behavioural of SmcTrAhbifReg is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------
constant IDLE             : std_logic_vector(1 downto 0) := "00";
-- Master IDLE transfer

constant BUSY             : std_logic_vector(1 downto 0) := "01";
-- Master BUSY transfer

constant OKAY             : std_logic_vector(1 downto 0) := "00";
-- Slave OKAY respone

constant ERROR            : std_logic_vector(1 downto 0) := "01";
-- Slave ERROR respone

constant WORD             : std_logic_vector(2 downto 0) := "010";
-- 32-bit operation

-- -----------------------------------------------------------------------------
-- Zero fill for register reads to return zeros in unused bit positions
-- -----------------------------------------------------------------------------
constant ZEROFILL         : std_logic_vector(31 downto 0)
                          := "00000000000000000000000000000000";

-- -----------------------------------------------------------------------------
-- Trickbox registers address constants. Address decode is for
-- bits 2 to 4 (3 bits)
-- -----------------------------------------------------------------------------
constant ADDR_SMCTrMWCS      : std_logic_vector(6 downto 2)  := "00000";
-- SMCTrMWCS at offset 0x0000

constant ADDR_SMCTrREMAP     : std_logic_vector(6 downto 2)  := "00001";
-- SMCTrRemap at offset 0x0004

constant ADDR_SMCTrEndian    : std_logic_vector(6 downto 2)  := "00010";
-- SMCTrEndian at offset 0x0008

constant ADDR_SMCTrCS2WTR0   : std_logic_vector(6 downto 2)  := "00011";
-- SMCTrCS2WT at offset 0x000C

constant ADDR_SMCTrCEWTR0    : std_logic_vector(6 downto 2)  := "00100";
-- SMCTrCEWT at offset 0x0010

constant ADDR_SMCTrCS2WTR1   : std_logic_vector(6 downto 2)  := "00101";
-- SMCTrCS2WT at offset 0x0014

constant ADDR_SMCTrCEWTR1    : std_logic_vector(6 downto 2)  := "00110";
-- SMCTrCEWT at offset 0x0018

constant ADDR_SMCTrCS2WTR2   : std_logic_vector(6 downto 2)  := "00111";
-- SMCTrCS2WT at offset 0x001C

constant ADDR_SMCTrCEWTR2    : std_logic_vector(6 downto 2)  := "01000";
-- SMCTrCEWT at offset 0x0020

constant ADDR_SMCTrCS2WTR3   : std_logic_vector(6 downto 2)  := "01001";
-- SMCTrCS2WT at offset 0x0024

constant ADDR_SMCTrCEWTR3    : std_logic_vector(6 downto 2)  := "01010";
-- SMCTrCEWT at offset 0x0028

constant ADDR_SMCTrCS2WTR4   : std_logic_vector(6 downto 2)  := "01011";
-- SMCTrCS2WT at offset 0x002C

constant ADDR_SMCTrCEWTR4    : std_logic_vector(6 downto 2)  := "01100";
-- SMCTrCEWT at offset 0x0030

constant ADDR_SMCTrCS2WTR5   : std_logic_vector(6 downto 2)  := "01101";
-- SMCTrCS2WT at offset 0x0034

constant ADDR_SMCTrCEWTR5    : std_logic_vector(6 downto 2)  := "01110";
-- SMCTrCEWT at offset 0x0038

constant ADDR_SMCTrCS2WTR6   : std_logic_vector(6 downto 2)  := "01111";
-- SMCTrCS2WT at offset 0x003C

constant ADDR_SMCTrCEWTR6    : std_logic_vector(6 downto 2)  := "10000";
-- SMCTrCEWT at offset 0x0040

constant ADDR_SMCTrCS2WTR7   : std_logic_vector(6 downto 2)  := "10001";
-- SMCTrCS2WT at offset 0x0044

constant ADDR_SMCTrCEWTR7    : std_logic_vector(6 downto 2)  := "10010";
-- SMCTrCEWT at offset 0x0048

constant ADDR_SMCTrMCREQD    : std_logic_vector(6 downto 2)  := "10011";
-- SMCTrMCREQD at offset 0x004C

constant ADDR_SMCTrGNT2RMREQ : std_logic_vector(6 downto 2)  := "10100";
-- SMCTrGNT2RMREQ at offset 0x0050

constant ADDR_SMCTrMCADDR    : std_logic_vector(6 downto 2)  := "10101";
-- SMCTrMCBUSR at offset 0x0054

constant ADDR_SMCTrMCBUSR    : std_logic_vector(6 downto 2)  := "10110";
-- SMCTrMCBUSR at offset 0x0058

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal WaitCount        : unsigned(7 downto 0) := "00000000";
-- Wait State Counter

signal Wait4GNT         : std_logic;
-- Indicates that the device is waiting for the SMBUSGNT assertion

signal Wait4GNTRm       : std_logic;
-- Indicates that the device is waiting for the SMBUSGNT de-assertion

signal iLatchHADDR      : std_logic_vector(6 downto 2) := "00000";
-- Latched version of HADDR

signal iHRESP           : std_logic_vector(1 downto 0);
-- Indicates the type of response for a transfer

signal SMCTrMWCS        : std_logic_vector(1 downto 0) := "10";
-- SMCTrMWCS Register

signal SMCTrRemap       : std_logic := '1';
-- SMCTrRemap Register

signal SMCTrEndian      : std_logic := '0';
-- SMCTrEndian Register

signal iSMCTrCS2WTR0    : std_logic_vector(25 downto 0) := (others => '0');
-- Internal version of SMCTrCS2WT Register for Bank 0

signal iSMCTrCEWTR0     : std_logic_vector(23 downto 0) := (others => '0');
-- Internal version of SMCTrCEWT Register for Bank 0

signal iSMCTrCS2WTR1    : std_logic_vector(25 downto 0) := (others => '0');
-- Internal version of SMCTrCS2WT Register for Bank 1

signal iSMCTrCEWTR1     : std_logic_vector(23 downto 0) := (others => '0');
-- Internal version of SMCTrCEWT Register for Bank 1

signal iSMCTrCS2WTR2    : std_logic_vector(25 downto 0) := (others => '0');
-- Internal version of SMCTrCS2WT Register for Bank 2

signal iSMCTrCEWTR2     : std_logic_vector(23 downto 0) := (others => '0');
-- Internal version of SMCTrCEWT Register for Bank 2

signal iSMCTrCS2WTR3    : std_logic_vector(25 downto 0) := (others => '0');
-- Internal version of SMCTrCS2WT Register for Bank 3

signal iSMCTrCEWTR3     : std_logic_vector(23 downto 0) := (others => '0');
-- Internal version of SMCTrCEWT Register for Bank 3

signal iSMCTrCS2WTR4    : std_logic_vector(25 downto 0) := (others => '0');
-- Internal version of SMCTrCS2WT Register for Bank 4

signal iSMCTrCEWTR4     : std_logic_vector(23 downto 0) := (others => '0');
-- Internal version of SMCTrCEWT Register for Bank 4

signal iSMCTrCS2WTR5    : std_logic_vector(25 downto 0) := (others => '0');
-- Internal version of SMCTrCS2WT Register for Bank 5

signal iSMCTrCEWTR5     : std_logic_vector(23 downto 0) := (others => '0');
-- Internal version of SMCTrCEWT Register for Bank 5

signal iSMCTrCS2WTR6    : std_logic_vector(25 downto 0) := (others => '0');
-- Internal version of SMCTrCS2WT Register for Bank 6

signal iSMCTrCEWTR6     : std_logic_vector(23 downto 0) := (others => '0');
-- Internal version of SMCTrCEWT Register for Bank 6

signal iSMCTrCS2WTR7    : std_logic_vector(25 downto 0) := (others => '0');
-- Internal version of SMCTrCS2WT Register for Bank 7

signal iSMCTrCEWTR7     : std_logic_vector(23 downto 0) := (others => '0');
-- Internal version of SMCTrCEWT Register for Bank 7

signal iSMCTrMCREQD     : std_logic_vector(4 downto 0) := (others => '0');
-- Internal version of SMCTrMCREQD Register

signal iSMCTrGNT2RMREQ  : std_logic_vector(4 downto 0) := (others => '0');
-- Internal version of SMCTrGNT2RMREQ Register

signal iSMCTrMCADDR     : std_logic_vector(25 downto 0);
-- Internal version of SMCTrMCADDR Register

signal iSMCTrMCDATA     : std_logic_vector(31 downto 0);
-- Internal version of SMCTrMCDATAOUT Register

signal NxtSMCTrMWCS     : std_logic_vector(1 downto 0) := "10";
-- D-input of SMCTrMWCS Register

signal NxtSMCTrRemap    : std_logic := '1';
-- D-input of SMCTrRemap Register

signal NxtSMCTrEndian   : std_logic := '0';
-- D-input of SMCTrEndian Register

signal NxtSMCTrCS2WTR0  : std_logic_vector(25 downto 0) := (others => '0');
-- D-input for the SMCTrCS2WT Register for Bank 0

signal NxtSMCTrCEWTR0   : std_logic_vector(23 downto 0) := (others => '0');
-- D-input for the SMCTrCEWT Register for Bank 0

signal NxtSMCTrCS2WTR1  : std_logic_vector(25 downto 0) := (others => '0');
-- D-input for the SMCTrCS2WT Register for Bank 1

signal NxtSMCTrCEWTR1   : std_logic_vector(23 downto 0) := (others => '0');
-- D-input for the SMCTrCEWT Register for Bank 1

signal NxtSMCTrCS2WTR2  : std_logic_vector(25 downto 0) := (others => '0');
-- D-input for the SMCTrCS2WT Register for Bank 2

signal NxtSMCTrCEWTR2   : std_logic_vector(23 downto 0) := (others => '0');
-- D-input for the SMCTrCEWT Register for Bank 2

signal NxtSMCTrCS2WTR3  : std_logic_vector(25 downto 0) := (others => '0');
-- D-input for the SMCTrCS2WT Register for Bank 3

signal NxtSMCTrCEWTR3   : std_logic_vector(23 downto 0) := (others => '0');
-- D-input for the SMCTrCEWT Register for Bank 3

signal NxtSMCTrCS2WTR4  : std_logic_vector(25 downto 0) := (others => '0');
-- D-input for the SMCTrCS2WT Register for Bank 4

signal NxtSMCTrCEWTR4   : std_logic_vector(23 downto 0) := (others => '0');
-- D-input for the SMCTrCEWT Register for Bank 4

signal NxtSMCTrCS2WTR5  : std_logic_vector(25 downto 0) := (others => '0');
-- D-input for the SMCTrCS2WT Register for Bank 5

signal NxtSMCTrCEWTR5   : std_logic_vector(23 downto 0) := (others => '0');
-- D-input for the SMCTrCEWT Register for Bank 5

signal NxtSMCTrCS2WTR6  : std_logic_vector(25 downto 0) := (others => '0');
-- D-input for the SMCTrCS2WT Register for Bank 6

signal NxtSMCTrCEWTR6   : std_logic_vector(23 downto 0) := (others => '0');
-- D-input for the SMCTrCEWT Register for Bank 6

signal NxtSMCTrCS2WTR7  : std_logic_vector(25 downto 0) := (others => '0');
-- D-input for the SMCTrCS2WT Register for Bank 7

signal NxtSMCTrCEWTR7   : std_logic_vector(23 downto 0) := (others => '0');
-- D-input for the SMCTrCEWT Register for Bank 7

signal NxtSMCTrMCREQD   : std_logic_vector(4 downto 0) := (others => '0');
-- D-input for the SMCTrMCREQD Register

signal NxtSMCTrGNT2RMRQ : std_logic_vector(4 downto 0) := (others => '0');
-- D-input for the SMCTrGNT2RMREQ Register

signal NxtSMCTrMCADDR   : std_logic_vector(25 downto 0);
-- D-input for the SMCTrMCADDR Register

signal NxtSMCTrMCDATA   : std_logic_vector(31 downto 0);
-- D-input for the SMCTrMCDATAOUT Register

signal RdEn             : std_logic;
-- Read enable signal

signal SMCTrMWCSRd      : std_logic;
-- SMCTrMWCS Read

signal SMCTrRemapRd     : std_logic;
-- SMCTrRemap Read

signal SMCTrEndianRd    : std_logic;
-- SMCTrEndian Read

signal SMCTrCS2WTR0Rd   : std_logic;
-- SMCTrCS2WTR0 Read

signal SMCTrCEWTR0Rd    : std_logic;
-- SMCTrCEWTR0 Read

signal SMCTrCS2WTR1Rd   : std_logic;
-- SMCTrCS2WTR1 Read

signal SMCTrCEWTR1Rd    : std_logic;
-- SMCTrCEWTR1 Read

signal SMCTrCS2WTR2Rd   : std_logic;
-- SMCTrCS2WTR2 Read

signal SMCTrCEWTR2Rd    : std_logic;
-- SMCTrCEWTR2 Read

signal SMCTrCS2WTR3Rd   : std_logic;
-- SMCTrCS2WTR3 Read

signal SMCTrCEWTR3Rd    : std_logic;
-- SMCTrCEWTR3 Read

signal SMCTrCS2WTR4Rd   : std_logic;
-- SMCTrCS2WTR4 Read

signal SMCTrCEWTR4Rd    : std_logic;
-- SMCTrCEWTR4 Read

signal SMCTrCS2WTR5Rd   : std_logic;
-- SMCTrCS2WTR5 Read

signal SMCTrCEWTR5Rd    : std_logic;
-- SMCTrCEWTR5 Read

signal SMCTrCS2WTR6Rd   : std_logic;
-- SMCTrCS2WTR6 Read

signal SMCTrCEWTR6Rd    : std_logic;
-- SMCTrCEWTR6 Read

signal SMCTrCS2WTR7Rd   : std_logic;
-- SMCTrCS2WTR7 Read

signal SMCTrCEWTR7Rd    : std_logic;
-- SMCTrCEWTR7 Read

signal SMCTrMCREQDRd    : std_logic;
-- SMCTrMCREQD Read

signal SMCTrGNT2RMREQRd : std_logic;
-- SMCTrGNT2RMREQ Read

signal SMCTrMCADDRRd    : std_logic;
-- SMCTrMCADDR Read

signal iSMCTrMCBUSRRd   : std_logic;
-- Internal version of SMCTrMCBUSRRd

signal WrEn             : std_logic;
-- Write enable signal

signal SMCTrMWCSWr      : std_logic;
-- SMCTrMWCS Write

signal SMCTrRemapWr     : std_logic;
-- SMCTrRemap Write

signal SMCTrEndianWr    : std_logic;
-- SMCTrEndian Write

signal SMCTrCS2WTR0Wr   : std_logic;
-- SMCTrCS2WTR0 Write

signal SMCTrCEWTR0Wr    : std_logic;
-- SMCTrCEWTR0 Write

signal SMCTrCS2WTR1Wr   : std_logic;
-- SMCTrCS2WTR1 Write

signal SMCTrCEWTR1Wr    : std_logic;
-- SMCTrCEWTR1 Write

signal SMCTrCS2WTR2Wr   : std_logic;
-- SMCTrCS2WTR2 Write

signal SMCTrCEWTR2Wr    : std_logic;
-- SMCTrCEWTR2 Write

signal SMCTrCS2WTR3Wr   : std_logic;
-- SMCTrCS2WTR3 Write

signal SMCTrCEWTR3Wr    : std_logic;
-- SMCTrCEWTR3 Write

signal SMCTrCS2WTR4Wr   : std_logic;
-- SMCTrCS2WTR4 Write

signal SMCTrCEWTR4Wr    : std_logic;
-- SMCTrCEWTR4 Write

signal SMCTrCS2WTR5Wr   : std_logic;
-- SMCTrCS2WTR5 Write

signal SMCTrCEWTR5Wr    : std_logic;
-- SMCTrCEWTR5 Write

signal SMCTrCS2WTR6Wr   : std_logic;
-- SMCTrCS2WTR6 Write

signal SMCTrCEWTR6Wr    : std_logic;
-- SMCTrCEWTR6 Write

signal SMCTrCS2WTR7Wr   : std_logic;
-- SMCTrCS2WTR7 Write

signal SMCTrCEWTR7Wr    : std_logic;
-- SMCTrCEWTR7 Write

signal SMCTrMCREQDWr    : std_logic;
-- SMCTrMCREQD Write

signal SMCTrGNT2RMREQWr : std_logic;
-- SMCTrGNT2RMREQ Write

signal SMCTrMCADDRWr    : std_logic;
-- SMCTrMCADDR Write

signal iSMCTrMCBUSRWr   : std_logic;
-- Internal version of SMCTrMCBUSRWr

signal ErrorLat         : std_logic := '0';
-- Latch error condition

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
-- Write enables for registers
-- -----------------------------------------------------------------------------
SMCTrMWCSWr      <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrMWCS))
                 else
                    '0';

SMCTrRemapWr     <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrREMAP))
                 else
                    '0';

SMCTrEndianWr    <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrENDIAN))
                 else
                    '0';

SMCTrCS2WTR0Wr   <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrCS2WTR0))
                 else
                    '0';

SMCTrCEWTR0Wr    <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrCEWTR0))
                 else
                    '0';

SMCTrCS2WTR1Wr   <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrCS2WTR1))
                 else
                    '0';

SMCTrCEWTR1Wr    <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrCEWTR1))
                 else
                    '0';

SMCTrCS2WTR2Wr   <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrCS2WTR2))
                 else
                    '0';

SMCTrCEWTR2Wr    <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrCEWTR2))
                 else
                    '0';

SMCTrCS2WTR3Wr   <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrCS2WTR3))
                 else
                    '0';

SMCTrCEWTR3Wr    <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrCEWTR3))
                 else
                    '0';

SMCTrCS2WTR4Wr   <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrCS2WTR4))
                 else
                    '0';

SMCTrCEWTR4Wr    <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrCEWTR4))
                 else
                    '0';

SMCTrCS2WTR5Wr   <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrCS2WTR5))
                 else
                    '0';

SMCTrCEWTR5Wr    <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrCEWTR5))
                 else
                    '0';

SMCTrCS2WTR6Wr   <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrCS2WTR6))
                 else
                    '0';

SMCTrCEWTR6Wr    <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrCEWTR6))
                 else
                    '0';

SMCTrCS2WTR7Wr   <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrCS2WTR7))
                 else
                    '0';

SMCTrCEWTR7Wr    <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrCEWTR7))
                 else
                    '0';

SMCTrMCREQDWr    <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrMCREQD))
                 else
                    '0';

SMCTrGNT2RMREQWr  <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrGNT2RMREQ))
                 else
                    '0';

SMCTrMCADDRWr     <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrMCADDR))
                 else
                    '0';

iSMCTrMCBUSRWr    <= '1' when ((WrEn = '1') and
                              (iLatchHADDR = ADDR_SMCTrMCBUSR))
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Read enables for registers
-- -----------------------------------------------------------------------------
SMCTrMWCSRd      <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrMWCS))
                 else
                    '0';

SMCTrRemapRd     <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrREMAP))
                 else
                    '0';

SMCTrEndianRd    <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrENDIAN))
                 else
                    '0';

SMCTrCS2WTR0Rd   <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrCS2WTR0))
                 else
                    '0';

SMCTrCEWTR0Rd    <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrCEWTR0))
                 else
                    '0';

SMCTrCS2WTR1Rd   <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrCS2WTR1))
                 else
                    '0';

SMCTrCEWTR1Rd    <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrCEWTR1))
                 else
                    '0';

SMCTrCS2WTR2Rd   <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrCS2WTR2))
                 else
                    '0';

SMCTrCEWTR2Rd    <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrCEWTR2))
                 else
                    '0';

SMCTrCS2WTR3Rd   <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrCS2WTR3))
                 else
                    '0';

SMCTrCEWTR3Rd    <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrCEWTR3))
                 else
                    '0';

SMCTrCS2WTR4Rd   <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrCS2WTR4))
                 else
                    '0';

SMCTrCEWTR4Rd    <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrCEWTR4))
                 else
                    '0';

SMCTrCS2WTR5Rd   <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrCS2WTR5))
                 else
                    '0';

SMCTrCEWTR5Rd    <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrCEWTR5))
                 else
                    '0';

SMCTrCS2WTR6Rd   <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrCS2WTR6))
                 else
                    '0';

SMCTrCEWTR6Rd    <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrCEWTR6))
                 else
                    '0';

SMCTrCS2WTR7Rd   <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrCS2WTR7))
                 else
                    '0';

SMCTrCEWTR7Rd    <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrCEWTR7))
                 else
                    '0';

SMCTrMCREQDRd    <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrMCREQD))
                 else
                    '0';

SMCTrGNT2RMREQRd <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrGNT2RMREQ))
                 else
                    '0';

SMCTrMCADDRRd    <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_SMCTrMCADDR))
                 else
                    '0';

iSMCTrMCBUSRRd    <= '1' when ((RdEn = '1') and
                              (iLatchHADDR = ADDR_SMCTrMCBUSR))
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Output Mux
-- When the peripheral is not being accessed, '0's are driven
-- on the Read Databus (HRDATA)
-- -----------------------------------------------------------------------------
HRDATA           <= ZEROFILL(31 downto 2) & SMCTrMWCS when
                                          (SMCTrMWCSRd = '1')
                 else
                    ZEROFILL(31 downto 1) & SMCTrRemap when
                                          (SMCTrRemapRd = '1')
                 else
                    ZEROFILL(31 downto 1) & SMCTrEndian when
                                          (SMCTrEndianRd = '1')
                 else
                    ZEROFILL(31 downto 22) & iSMCTrCS2WTR0 when
                                           (SMCTrCS2WTR0Rd = '1')
                 else
                    ZEROFILL(31 downto 24) & iSMCTrCEWTR0 when
                                           (SMCTrCEWTR0Rd = '1')
                 else
                    ZEROFILL(31 downto 22) & iSMCTrCS2WTR1 when
                                           (SMCTrCS2WTR1Rd = '1')
                 else
                    ZEROFILL(31 downto 24) & iSMCTrCEWTR1 when
                                           (SMCTrCEWTR1Rd = '1')
                 else
                    ZEROFILL(31 downto 22) & iSMCTrCS2WTR2 when
                                           (SMCTrCS2WTR2Rd = '1')
                 else
                    ZEROFILL(31 downto 24) & iSMCTrCEWTR2 when
                                           (SMCTrCEWTR2Rd = '1')
                 else
                    ZEROFILL(31 downto 22) & iSMCTrCS2WTR3 when
                                           (SMCTrCS2WTR3Rd = '1')
                 else
                    ZEROFILL(31 downto 24) & iSMCTrCEWTR3 when
                                           (SMCTrCEWTR3Rd = '1')
                 else
                    ZEROFILL(31 downto 22) & iSMCTrCS2WTR4 when
                                           (SMCTrCS2WTR4Rd = '1')
                 else
                    ZEROFILL(31 downto 24) & iSMCTrCEWTR4 when
                                           (SMCTrCEWTR4Rd = '1')
                 else
                    ZEROFILL(31 downto 22) & iSMCTrCS2WTR5 when
                                           (SMCTrCS2WTR5Rd = '1')
                 else
                    ZEROFILL(31 downto 24) & iSMCTrCEWTR5 when
                                           (SMCTrCEWTR5Rd = '1')
                 else
                    ZEROFILL(31 downto 22) & iSMCTrCS2WTR6 when
                                           (SMCTrCS2WTR6Rd = '1')
                 else
                    ZEROFILL(31 downto 24) & iSMCTrCEWTR6 when
                                           (SMCTrCEWTR6Rd = '1')
                 else
                    ZEROFILL(31 downto 22) & iSMCTrCS2WTR7 when
                                           (SMCTrCS2WTR7Rd = '1')
                 else
                    ZEROFILL(31 downto 24) & iSMCTrCEWTR7 when
                                           (SMCTrCEWTR7Rd = '1')
                 else
                    ZEROFILL(31 downto 5) & iSMCTrMCREQD when
                                           (SMCTrMCREQDRd = '1')
                 else
                    ZEROFILL(31 downto 5) & iSMCTrGNT2RMREQ when
                                           (SMCTrGNT2RMREQRd = '1')
                 else
                    ZEROFILL(31 downto 26) & iSMCTrMCADDR when
                                           (SMCTrMCADDRRd = '1')
                 else
                    ZEROFILL;

-- -----------------------------------------------------------------------------
-- This process generates the bus response required for an AHB slave.
-- SMC Trickbox is designed for an HSIZE of 32-bit. So this process will
-- generate an ERROR response when the master tries to access it in some other
-- mode. Also it displays an error message to the output. Trickbox always
-- provides a ZERO wait state OKAY response for IDLE and BUSY
-- HTRANS of the master.
-- -----------------------------------------------------------------------------
p_BusRespSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    iHRESP          <= "00";
    HREADYOUT       <= '1';
    WrEn            <= '0';
    RdEn            <= '0';
    ErrorLat        <= '0';
    iLatchHADDR     <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    if ((iHRESP = ERROR) and (HREADYIN = '0') and (ErrorLat = '1')) then
      iHRESP        <= ERROR;
      HREADYOUT     <= '1';
      WrEn          <= '0';
      RdEn          <= '0';
      ErrorLat      <= '0';
    elsif (((HTRANS = IDLE) or (HTRANS = BUSY)) and
           (HSELSMCTR = '1') and (HREADYIN = '1')) then
      iHRESP        <= OKAY;
      HREADYOUT     <= '1';
    elsif ((HREADYIN = '1') and (HSELSMCTR = '1')) then
      if (HSIZE = WORD) then
        HREADYOUT   <= '1';
        iLatchHADDR <= HADDR;
        iHRESP      <= OKAY;
        if (HWRITE = '1') then
          WrEn      <= '1';
          RdEn      <= '0';
        else
          WrEn      <= '0';
          RdEn      <= '1';
        end if;
      else
        iHRESP      <= ERROR;
        HREADYOUT   <= '0';
        WrEn        <= '0';
        RdEn        <= '0';
        ErrorLat    <= '1';
        assert false
          report "Error Response from SMC trickbox slave"
        severity warning;
      end if;
    else
      WrEn          <= '0';
      RdEn          <= '0';
      iHRESP        <= "00";
      HREADYOUT     <= '1';
      ErrorLat      <= '0';
    end if;
  end if;
end process p_BusRespSeq;

-- -----------------------------------------------------------------------------
-- Combinational logic for all functional registers. When the respective
-- write enable input is asserted, copy the contents of the HWDATA Bus into
-- the corresponding registers.
-- -----------------------------------------------------------------------------
NxtSMCTrMWCS     <= HWDATA(1 downto 0) when (SMCTrMWCSWr = '1')
                 else
                    SMCTrMWCS;

NxtSMCTrRemap    <= HWDATA(0) when (SMCTrRemapWr = '1')
                 else
                    SMCTrRemap;

NxtSMCTrEndian   <= HWDATA(0) when (SMCTrEndianWr = '1')
                 else
                    SMCTrEndian;

NxtSMCTrCS2WTR0  <= HWDATA(25 downto 0) when (SMCTrCS2WTR0Wr = '1')
                 else
                    iSMCTrCS2WTR0;

NxtSMCTrCEWTR0   <= HWDATA(23 downto 0) when (SMCTrCEWTR0Wr = '1')
                 else
                    iSMCTrCEWTR0;

NxtSMCTrCS2WTR1  <= HWDATA(25 downto 0) when (SMCTrCS2WTR1Wr = '1')
                 else
                    iSMCTrCS2WTR1;

NxtSMCTrCEWTR1   <= HWDATA(23 downto 0) when (SMCTrCEWTR1Wr = '1')
                 else
                    iSMCTrCEWTR1;

NxtSMCTrCS2WTR2  <= HWDATA(25 downto 0) when (SMCTrCS2WTR2Wr = '1')
                 else
                    iSMCTrCS2WTR2;

NxtSMCTrCEWTR2   <= HWDATA(23 downto 0) when (SMCTrCEWTR2Wr = '1')
                 else
                    iSMCTrCEWTR2;

NxtSMCTrCS2WTR3  <= HWDATA(25 downto 0) when (SMCTrCS2WTR3Wr = '1')
                 else
                    iSMCTrCS2WTR3;

NxtSMCTrCEWTR3   <= HWDATA(23 downto 0) when (SMCTrCEWTR3Wr = '1')
                 else
                    iSMCTrCEWTR3;

NxtSMCTrCS2WTR4  <= HWDATA(25 downto 0) when (SMCTrCS2WTR4Wr = '1')
                 else
                    iSMCTrCS2WTR4;

NxtSMCTrCEWTR4   <= HWDATA(23 downto 0) when (SMCTrCEWTR4Wr = '1')
                 else
                    iSMCTrCEWTR4;

NxtSMCTrCS2WTR5  <= HWDATA(25 downto 0) when (SMCTrCS2WTR5Wr = '1')
                 else
                    iSMCTrCS2WTR5;

NxtSMCTrCEWTR5   <= HWDATA(23 downto 0) when (SMCTrCEWTR5Wr = '1')
                 else
                    iSMCTrCEWTR5;

NxtSMCTrCS2WTR6  <= HWDATA(25 downto 0) when (SMCTrCS2WTR6Wr = '1')
                 else
                    iSMCTrCS2WTR6;

NxtSMCTrCEWTR6   <= HWDATA(23 downto 0) when (SMCTrCEWTR6Wr = '1')
                 else
                    iSMCTrCEWTR6;

NxtSMCTrCS2WTR7  <= HWDATA(25 downto 0) when (SMCTrCS2WTR7Wr = '1')
                 else
                    iSMCTrCS2WTR7;

NxtSMCTrCEWTR7   <= HWDATA(23 downto 0) when (SMCTrCEWTR7Wr = '1')
                 else
                    iSMCTrCEWTR7;

NxtSMCTrMCREQD   <= HWDATA(4 downto 0) when (SMCTrMCREQDWr = '1')
                 else
                    iSMCTrMCREQD;

NxtSMCTrGNT2RMRQ <= HWDATA(4 downto 0) when (SMCTrGNT2RMREQWr = '1')
                 else
                    iSMCTrGNT2RMREQ;

NxtSMCTrMCADDR   <= HWDATA(25 downto 0) when (SMCTrMCADDRWr = '1')
                 else
                    iSMCTrMCADDR;

NxtSMCTrMCDATA   <= HWDATA(31 downto 0) when ((iSMCTrMCBUSRRd = '1') or
                                             (iSMCTrMCBUSRWr = '1'))
                 else
                    iSMCTrMCDATA;

-- -----------------------------------------------------------------------------
-- Sequential process for all functional registers writes.
-- -----------------------------------------------------------------------------
p_RegUpdateSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    SMCTrEndian   <= '0';
    iSMCTrCS2WTR0   <= (others => '0');
    iSMCTrCEWTR0    <= (others => '0');
    iSMCTrCS2WTR1   <= (others => '0');
    iSMCTrCEWTR1    <= (others => '0');
    iSMCTrCS2WTR2   <= (others => '0');
    iSMCTrCEWTR2    <= (others => '0');
    iSMCTrCS2WTR3   <= (others => '0');
    iSMCTrCEWTR3    <= (others => '0');
    iSMCTrCS2WTR4   <= (others => '0');
    iSMCTrCEWTR4    <= (others => '0');
    iSMCTrCS2WTR5   <= (others => '0');
    iSMCTrCEWTR5    <= (others => '0');
    iSMCTrCS2WTR6   <= (others => '0');
    iSMCTrCEWTR6    <= (others => '0');
    iSMCTrCS2WTR7   <= (others => '0');
    iSMCTrCEWTR7    <= (others => '0');
    iSMCTrMCREQD    <= (others => '0');
    iSMCTrGNT2RMREQ <= (others => '0');
    iSMCTrMCADDR    <= (others => '0');
    iSMCTrMCDATA    <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    SMCTrMWCS       <= NxtSMCTrMWCS;
    SMCTrRemap      <= NxtSMCTrRemap;
    SMCTrEndian     <= NxtSMCTrEndian;
    iSMCTrCS2WTR0   <= NxtSMCTrCS2WTR0;
    iSMCTrCEWTR0    <= NxtSMCTrCEWTR0;
    iSMCTrCS2WTR1   <= NxtSMCTrCS2WTR1;
    iSMCTrCEWTR1    <= NxtSMCTrCEWTR1;
    iSMCTrCS2WTR2   <= NxtSMCTrCS2WTR2;
    iSMCTrCEWTR2    <= NxtSMCTrCEWTR2;
    iSMCTrCS2WTR3   <= NxtSMCTrCS2WTR3;
    iSMCTrCEWTR3    <= NxtSMCTrCEWTR3;
    iSMCTrCS2WTR4   <= NxtSMCTrCS2WTR4;
    iSMCTrCEWTR4    <= NxtSMCTrCEWTR4;
    iSMCTrCS2WTR5   <= NxtSMCTrCS2WTR5;
    iSMCTrCEWTR5    <= NxtSMCTrCEWTR5;
    iSMCTrCS2WTR6   <= NxtSMCTrCS2WTR6;
    iSMCTrCEWTR6    <= NxtSMCTrCEWTR6;
    iSMCTrCS2WTR7   <= NxtSMCTrCS2WTR7;
    iSMCTrCEWTR7    <= NxtSMCTrCEWTR7;
    iSMCTrMCREQD    <= NxtSMCTrMCREQD;
    iSMCTrGNT2RMREQ <= NxtSMCTrGNT2RMRQ;
    iSMCTrMCADDR    <= NxtSMCTrMCADDR;
    iSMCTrMCDATA    <= NxtSMCTrMCDATA;
  end if;
end process p_RegUpdateSeq;

-- -----------------------------------------------------------------------------
-- Assign local copies of signals to the outputs
-- -----------------------------------------------------------------------------
HRESP            <= iHRESP;
SMMWCS7          <= SMCTrMWCS;
REMAP            <= SMCTrRemap;
ENDIANCNT        <= SMCTrEndian;
SMCTrCS2WTR0     <= iSMCTrCS2WTR0;
SMCTrCEWTR0      <= iSMCTrCEWTR0;
SMCTrCS2WTR1     <= iSMCTrCS2WTR1;
SMCTrCEWTR1      <= iSMCTrCEWTR1;
SMCTrCS2WTR2     <= iSMCTrCS2WTR2;
SMCTrCEWTR2      <= iSMCTrCEWTR2;
SMCTrCS2WTR3     <= iSMCTrCS2WTR3;
SMCTrCEWTR3      <= iSMCTrCEWTR3;
SMCTrCS2WTR4     <= iSMCTrCS2WTR4;
SMCTrCEWTR4      <= iSMCTrCEWTR4;
SMCTrCS2WTR5     <= iSMCTrCS2WTR5;
SMCTrCEWTR5      <= iSMCTrCEWTR5;
SMCTrCS2WTR6     <= iSMCTrCS2WTR6;
SMCTrCEWTR6      <= iSMCTrCEWTR6;
SMCTrCS2WTR7     <= iSMCTrCS2WTR7;
SMCTrCEWTR7      <= iSMCTrCEWTR7;
SMCTrMCREQD      <= iSMCTrMCREQD;
SMCTrGNT2RMREQ   <= iSMCTrGNT2RMREQ;
SMCTrMCADDR      <= iSMCTrMCADDR;
SMCTrMCDATAOUT   <= iSMCTrMCDATA;
SMCTrMCBUSRWr    <= iSMCTrMCBUSRWr;
SMCTrMCBUSRRd    <= iSMCTrMCBUSRRd;

end behavioural;

-- --================================== End ==================================--
