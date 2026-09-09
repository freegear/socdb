-- --=========================================================================--
-- confidential and proprietary software may be used only as
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
-- File Name              : SsmcTrAhbIfReg.vhd.rca
-- File Revision          : 1.8
--
-- Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block interfaces the SSMC Trickbox with the AHB.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SsmcTrAhbIfReg is
  port (
-- Inputs
        -- AHB bus signals
        HCLK             : in    std_logic; -- AHB Bus Clock
        HRESETn          : in    std_logic; -- Bus Reset
        HADDR            : in    std_logic_vector(5 downto 2);
                                            -- AHB Address Bus
        HTRANS           : in    std_logic_vector(1 downto 0);
                                            -- Transfer type
        HWRITE           : in    std_logic; 
                                            -- AHB Peripheral Write
        HSIZE            : in    std_logic_vector(2 downto 0);
                                            -- Transfer size
        HREADYINTr       : in    std_logic; -- Multiplexed version of
                                            -- HREADY outputs
        HWDATA           : in    std_logic_vector(31 downto 0);
                                            -- AHB Write Data bus
        HSELSSMCTr       : in    std_logic; -- AHB Peripheral (Trickbox)
                                            -- Select
-- Outputs
        HRDATATr         : out   std_logic_vector(31 downto 0);
                                            -- AHB Read Data bus
        HREADYOUTTr      : out   std_logic; 
                                            -- Slave HREADY output
        HRESPTr          : out   std_logic_vector(1 downto 0);
                                            -- Slave response
        -- External signals
        BIGENDIAN        : out   std_logic; 
                                            -- Endianness of the System
        SSMCTrExtMux     : out   std_logic_vector(8 downto 0);
                                            -- External bus MUX Register 
-- SMC related signals
        SMMWCS7          : out   std_logic_vector(1 downto 0);
                                            -- SSMCTrMWCS Register
        SSMCTrCS2WTR0    : out   std_logic_vector(11 downto 0);
                                            -- SSMCTrCEWTR0 Register
        SSMCTrCS2WTR1    : out   std_logic_vector(11 downto 0);
                                            -- SSMCTrCEWTR1 Register
        SSMCTrCS2WTR2    : out   std_logic_vector(11 downto 0);
                                            -- SSMCTrCEWTR2 Register
        SSMCTrCS2WTR3    : out   std_logic_vector(11 downto 0);
                                            -- SSMCTrCEWTR3 Register
        SSMCTrCS2WTR4    : out   std_logic_vector(11 downto 0);
                                            -- SSMCTrCEWTR4 Register
        SSMCTrCS2WTR5    : out   std_logic_vector(11 downto 0);
                                            -- SSMCTrCEWTR5 Register
        SSMCTrCS2WTR6    : out   std_logic_vector(11 downto 0);
                                            -- SSMCTrCEWTR6 Register
        SSMCTrCS2WTR7    : out   std_logic_vector(11 downto 0);
                                            -- SSMCTrCEWTR7 Register
        SSMCTrWTCNCL     : out   std_logic_vector(8 downto 0);
                                            -- SSMCTrWTCNCL Register
        SSMCTrCR         : out   std_logic_vector(2 downto 0);
                                            -- Clock ratio register
        SMBLS7POL        : out   std_logic
                                            -- SSMCTrSMBLSPOL register 
       );
end SsmcTrAhbIfReg;

-- -----------------------------------------------------------------------------
--
--                                SsmcTrAhbIfReg
--                                ============== 
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- SSMC Tricbox is an AHB slave. This block performs the following operations:
--   - Interfaces the Trickbox with the AHB.
--   - All slave response signals are generated from this module.
--   - This module decodes AHB accesses and generates the read/write
--     strobe to the appropriate registers.
--   - Implements SMC Trickbox registers.
--   - Drives non-AMBA, non-memory related signals into the SSMC.
--
-- -----------------------------------------------------------------------------
--                         SMC Trickbox Register Map
-- -----------------------------------------------------------------------------
-- Offset    Register        Type   Width    Describtion
-- -----------------------------------------------------------------------------
-- 0x0000 -  SSMCTrMWCS      R/W   2-bits These bits determine the memory width.
--                                        These are clocked, but not affected by
--                                        HRESETn. Used to check SMMWCS7
--                                        functionality.
--                                        00 -> 8 bits wide memory
--                                        01 -> 16 bits wide memory
--                                        10 -> 32 bits wide memory
--                                        11 -> 8 bits wide memory
--
-- 0x0004    SSMCTrExtMux   R/W  9-bit    This register controls the SMEXTBUSMUX
--                                        bit and also generate the Request for
--                                        for external controller.
--
-- 0x0008    SSMCTrEndian   R/W  1-bit    Indicates the type of Endianness of
--                                        the System. The value put in this
--                                        register is driven on BIGENDIAN input
--                                        of the SMC.
--
--           SSMCTrCS2WTRx  R/W  10-bits  This register determines the time
--                                        duration between nCS to SmcTrWait
--                                        assertions and deassertion for Bank x.
--
-- 0x000C    SSMCTrCS2WTR0  R/W  12-bits
-- 0x0010    SSMCTrCS2WTR1  R/W  12-bits
-- 0x0014    SSMCTrCS2WTR2  R/W  12-bits
-- 0x0018    SSMCTrCS2WTR3  R/W  12-bits
-- 0x001C    SSMCTrCS2WTR4  R/W  12-bits
-- 0x0020    SSMCTrCS2WTR5  R/W  12-bits
-- 0x0024    SSMCTrCS2WTR6  R/W  12-bits
-- 0x0028    SSMCTrCS2WTR7  R/W  12-bits
-- 0x002C    SSMCTrWTCNCL   R/W   9-bits  This register determines the delay 
--                                        count after which nSMCANCELWAIT will
--                                        be asserted.
--
-- 0x0030    SSMCTrCR       R/W   3-bit   Clock ratio control register
--
-- 0x0034    SSMCTrSMBLSPOL R/W   1-bit   This register drives the reset value
--                                        for SMBLS7POL signal.
--
-- -----------------------------------------------------------------------------

-- --============================ ARCHITECTURE ===============================--

architecture behavioural of SsmcTrAhbIfReg is

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
constant ADDR_SSMCTrMWCS      : std_logic_vector(5 downto 2)  := "0000";
-- SSMCTrMWCS at offset 0x0000

constant ADDR_SSMCTrExtMux    : std_logic_vector(5 downto 2)  := "0001";
-- SSMCTrExtMux at offset 0x0004

constant ADDR_SSMCTrEndian    : std_logic_vector(5 downto 2)  := "0010";
-- SSMCTrEndian at offset 0x0008

constant ADDR_SSMCTrCS2WTR0   : std_logic_vector(5 downto 2)  := "0011";
-- SSMCTrCS2WT at offset 0x000C

constant ADDR_SSMCTrCS2WTR1   : std_logic_vector(5 downto 2)  := "0100";
-- SSMCTrCS2WT at offset 0x0010

constant ADDR_SSMCTrCS2WTR2   : std_logic_vector(5 downto 2)  := "0101";
-- SSMCTrCS2WT at offset 0x0014

constant ADDR_SSMCTrCS2WTR3   : std_logic_vector(5 downto 2)  := "0110";
-- SSMCTrCS2WT at offset 0x0018

constant ADDR_SSMCTrCS2WTR4   : std_logic_vector(5 downto 2)  := "0111";
-- SSMCTrCS2WT at offset 0x001C

constant ADDR_SSMCTrCS2WTR5   : std_logic_vector(5 downto 2)  := "1000";
-- SSMCTrCS2WT at offset 0x0020

constant ADDR_SSMCTrCS2WTR6   : std_logic_vector(5 downto 2)  := "1001";
-- SSMCTrCS2WT at offset 0x0024

constant ADDR_SSMCTrCS2WTR7   : std_logic_vector(5 downto 2)  := "1010";
-- SSMCTrCS2WT at offset 0x0028

constant ADDR_SSMCTrWTCNCL    : std_logic_vector(5 downto 2)  := "1011";
-- SSMCTrWTCNCL at offset 0x002C

constant ADDR_SSMCTrCR        : std_logic_vector(5 downto 2)  := "1100";
-- SSMCTrCR at offset 0x0030

constant ADDR_SSMCTrSMBLSPOL  : std_logic_vector(5 downto 2)  := "1101";
-- SSMCTrSMBLSPOL at offset 0x0034

-- ------------------------------------------------------------------------------- Signal declarations
-- -----------------------------------------------------------------------------
signal iLatchHADDR      : std_logic_vector(3 downto 0);
-- Latched version of HADDR

signal iHRESPTr         : std_logic_vector(1 downto 0);
-- Indicates the type of response for a transfer      

signal SSMCTrMWCS       : std_logic_vector(1 downto 0) := "00";
-- SSMCTrMWCS Register

signal SSMCTrSMBLSPOL   : std_logic := '0';
-- SSMCTrSMBLSPOL Register

signal iSSMCTrExtMux    : std_logic_vector(8 downto 0) := (others => '0');
-- Internal version of SSMCTrExtMux Register

signal SSMCTrEndian     : std_logic := '0';
-- SSMCTrEndian Register

signal iSSMCTrCS2WTR0   : std_logic_vector(11 downto 0) := (others => '0');
-- Internal version of SSMCTrCS2WT Register for Bank 0

signal iSSMCTrCS2WTR1   : std_logic_vector(11 downto 0) := (others => '0');
-- Internal version of SSMCTrCS2WT Register for Bank 1

signal iSSMCTrCS2WTR2   : std_logic_vector(11 downto 0) := (others => '0');
-- Internal version of SSMCTrCS2WT Register for Bank 2

signal iSSMCTrCS2WTR3   : std_logic_vector(11 downto 0) := (others => '0');
-- Internal version of SSMCTrCS2WT Register for Bank 3

signal iSSMCTrCS2WTR4   : std_logic_vector(11 downto 0) := (others => '0');
-- Internal version of SSMCTrCS2WT Register for Bank 4

signal iSSMCTrCS2WTR5   : std_logic_vector(11 downto 0) := (others => '0');
-- Internal version of SSMCTrCS2WT Register for Bank 5

signal iSSMCTrCS2WTR6   : std_logic_vector(11 downto 0) := (others => '0');
-- Internal version of SSMCTrCS2WT Register for Bank 6

signal iSSMCTrCS2WTR7   : std_logic_vector(11 downto 0) := (others => '0');
-- Internal version of SSMCTrCS2WT Register for Bank 7

signal iSSMCTrWTCNCL    : std_logic_vector(8 downto 0) := (others => '0');
-- Internal version of iSSMCTrWTCNCL Register

signal iSSMCTrCR        : std_logic_vector(2 downto 0) := (others => '0');
-- Internal version of SSMCTrCR

signal NxtSSMCTrMWCS    : std_logic_vector(1 downto 0) := "00";
-- D-input of SSMCTrMWCS Register

signal NxtSSMCTrSMBLSPOL: std_logic := '0';
-- D-input of SSMCTrSMBLSPOL Register

signal NxtSSMCTrExtMux  : std_logic_vector(8 downto 0) := (others => '0');
-- D-input of SSMCTrExtMux Register

signal NxtSSMCTrEndian  : std_logic := '0';
-- D-input of SSMCTrEndian Register

signal NxtSSMCTrCS2WTR0 : std_logic_vector(11 downto 0) := (others => '0');
-- D-input of SSMCTrCS2WT Register for Bank 0

signal NxtSSMCTrCS2WTR1 : std_logic_vector(11 downto 0) := (others => '0');
-- D-input of SSMCTrCS2WT Register for Bank 1

signal NxtSSMCTrCS2WTR2 : std_logic_vector(11 downto 0) := (others => '0');
-- D-input of SSMCTrCS2WT Register for Bank 2

signal NxtSSMCTrCS2WTR3 : std_logic_vector(11 downto 0) := (others => '0');
-- D-input of SSMCTrCS2WT Register for Bank 3

signal NxtSSMCTrCS2WTR4 : std_logic_vector(11 downto 0) := (others => '0');
-- D-input of SSMCTrCS2WT Register for Bank 4

signal NxtSSMCTrCS2WTR5 : std_logic_vector(11 downto 0) := (others => '0');
-- D-input of SSMCTrCS2WT Register for Bank 5

signal NxtSSMCTrCS2WTR6 : std_logic_vector(11 downto 0) := (others => '0');
-- D-input of SSMCTrCS2WT Register for Bank 6

signal NxtSSMCTrCS2WTR7 : std_logic_vector(11 downto 0) := (others => '0');
-- D-input of SSMCTrCS2WT Register for Bank 7

signal NxtSSMCTrWTCNCL  : std_logic_vector(8 downto 0) := (others => '0');
-- D-input of SSMCTrWTCNCL Register

signal NxtSSMCTrCR      : std_logic_vector(2 downto 0) := (others => '0');
-- D-input of SSMCTrCR Register

signal RdEn             : std_logic;
-- Read enable signal

signal SSMCTrMWCSRd     : std_logic;
-- SSMCTrMWCS Read

signal SSMCTrSMBLSPOLRd     : std_logic;
-- SSMCTrSMBLSPOL Read

signal SSMCTrExtMuxRd   : std_logic;
-- SSMCTrExtMux Read

signal SSMCTrEndianRd   : std_logic;
-- SSMCTrEndian Read

signal SSMCTrCS2WTR0Rd  : std_logic;
-- SSMCTrCS2WTR0 Read

signal SSMCTrCS2WTR1Rd  : std_logic;
-- SSMCTrCS2WTR1 Read

signal SSMCTrCS2WTR2Rd  : std_logic;
-- SSMCTrCS2WTR2 Read

signal SSMCTrCS2WTR3Rd  : std_logic;
-- SSMCTrCS2WTR3 Read

signal SSMCTrCS2WTR4Rd  : std_logic;
-- SSMCTrCS2WTR4 Read

signal SSMCTrCS2WTR5Rd  : std_logic;
-- SSMCTrCS2WTR5 Read

signal SSMCTrCS2WTR6Rd  : std_logic;
-- SSMCTrCS2WTR6 Read

signal SSMCTrCS2WTR7Rd  : std_logic;
-- SSMCTrCS2WTR7 Read

signal SSMCTrWTCNCLRd   : std_logic;
-- SSMCTrWTCNCL Read

signal SSMCTrCRRd       : std_logic;
-- SSMCTrCR Read

signal WrEn             : std_logic;
-- Write enable signal

signal SSMCTrMWCSWr     : std_logic;
-- SSMCTrMWCS Write

signal SSMCTrSMBLSPOLWr : std_logic;
-- SSMCTrSMBLSPOL Write

signal SSMCTrExtMuxWr   : std_logic;
-- SSMCTrExtMux Write

signal SSMCTrEndianWr   : std_logic;
-- SSMCTrEndian Write

signal SSMCTrCS2WTR0Wr  : std_logic;
-- SSMCTrCS2WTR0 Write

signal SSMCTrCS2WTR1Wr  : std_logic;
-- SSMCTrCS2WTR1 Write

signal SSMCTrCS2WTR2Wr  : std_logic;
-- SSMCTrCS2WTR2 Write 

signal SSMCTrCS2WTR3Wr  : std_logic;
-- SSMCTrCS2WTR3 Write

signal SSMCTrCS2WTR4Wr  : std_logic;
-- SSMCTrCS2WTR4 Write

signal SSMCTrCS2WTR5Wr  : std_logic;
-- SSMCTrCS2WTR5 Write

signal SSMCTrCS2WTR6Wr  : std_logic;
-- SSMCTrCS2WTR6 Write

signal SSMCTrCS2WTR7Wr  : std_logic;
-- SSMCTrCS2WTR7 Write

signal SSMCTrWTCNCLWr   : std_logic;
-- SSMCTrWTCNCL Write

signal SSMCTrCRWr       : std_logic;
-- SSMCTrCR Write

signal ErrorLat         : std_logic := '0';
-- Latch error condition

-- -----------------------------------------------------------------------------
--Function declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
--                            Main Body of code
-- -----------------------------------------------------------------------------
begin
-- -----------------------------------------------------------------------------
-- Read enables for registers
-- -----------------------------------------------------------------------------

SSMCTrMWCSRd      <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_SSMCTrMWCS))
                 else
                    '0';

SSMCTrSMBLSPOLRd  <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_SSMCTrSMBLSPOL))
                 else
                    '0';

SSMCTrExtMuxRd    <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_SSMCTrExtMux))
                 else
                    '0';       

SSMCTrEndianRd    <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_SSMCTrENDIAN))
                 else
                    '0';

SSMCTrCS2WTR0Rd   <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_SSMCTrCS2WTR0))
                 else
                    '0';

SSMCTrCS2WTR1Rd   <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_SSMCTrCS2WTR1))
                 else
                    '0';

SSMCTrCS2WTR2Rd   <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_SSMCTrCS2WTR2))
                 else
                    '0';

SSMCTrCS2WTR3Rd   <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_SSMCTrCS2WTR3))
                 else
                    '0';

SSMCTrCS2WTR4Rd   <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_SSMCTrCS2WTR4))
                 else
                    '0';

SSMCTrCS2WTR5Rd   <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_SSMCTrCS2WTR5))
                 else
                    '0';

SSMCTrCS2WTR6Rd   <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_SSMCTrCS2WTR6))
                 else
                    '0';

SSMCTrCS2WTR7Rd   <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_SSMCTrCS2WTR7))
                 else
                    '0';

SSMCTrWTCNCLRd    <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_SSMCTrWTCNCL))
                 else
                    '0';
SSMCTrCRRd        <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_SSMCTrCR))
                 else
                    '0';
   
-- ------------------------------------------------------------------------------- Write enables for registers
-- -----------------------------------------------------------------------------
SSMCTrMWCSWr      <= '1' when ((iLatchHADDR = ADDR_SSMCTrMWCS) and
                               (WrEn = '1'))
                 else
                    '0';

SSMCTrSMBLSPOLWr  <= '1' when ((iLatchHADDR = ADDR_SSMCTrSMBLSPOL) and
                               (WrEn = '1'))
                 else
                    '0';

SSMCTrExtMuxWr    <= '1' when ((WrEn = '1') and 
                             (iLatchHADDR = ADDR_SSMCTrExtMux))
                 else 
                    '0';

SSMCTrEndianWr    <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_SSMCTrENDIAN))
                 else
                    '0';

SSMCTrCS2WTR0Wr   <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_SSMCTrCS2WTR0))
                 else
                    '0';

SSMCTrCS2WTR1Wr   <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_SSMCTrCS2WTR1))
                 else
                    '0';

SSMCTrCS2WTR2Wr   <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_SSMCTrCS2WTR2))
                 else
                    '0';

SSMCTrCS2WTR3Wr   <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_SSMCTrCS2WTR3))
                 else
                    '0';

SSMCTrCS2WTR4Wr   <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_SSMCTrCS2WTR4))
                 else
                    '0';

SSMCTrCS2WTR5Wr   <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_SSMCTrCS2WTR5))
                 else
                    '0';

SSMCTrCS2WTR6Wr   <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_SSMCTrCS2WTR6))
                 else
                    '0';

SSMCTrCS2WTR7Wr   <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_SSMCTrCS2WTR7))
                 else
                    '0';

SSMCTrWTCNCLWr    <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_SSMCTrWTCNCL))
                 else
                    '0';

SSMCTrCRWr        <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_SSMCTrCR))
                 else
                    '0';
       
-- ------------------------------------------------------------------------------- Output MUX
-- When the periphal is not bieng accessed, '0's are driven on the Read Databus
-- -----------------------------------------------------------------------------
HRDATATr         <= ZEROFILL(31 downto 2) & SSMCTrMWCS when
                                          (SSMCTrMWCSRd = '1')
                 else
                    ZEROFILL(31 downto 1) & SSMCTrSMBLSPOL when
                                          (SSMCTrSMBLSPOLRd = '1')
                 else
                    ZEROFILL(31 downto 9) & iSSMCTrExtMux when
                                          (SSMCTrExtMuxRd = '1')
                 else
                    ZEROFILL(31 downto 1) & SSMCTrEndian when
                                          (SSMCTrEndianRd = '1')
                 else
                    ZEROFILL(31 downto 12) & iSSMCTrCS2WTR0 when
                                           (SSMCTrCS2WTR0Rd = '1')
                 else
                    ZEROFILL(31 downto 12) & iSSMCTrCS2WTR1 when
                                           (SSMCTrCS2WTR1Rd = '1')
                 else
                    ZEROFILL(31 downto 12) & iSSMCTrCS2WTR2 when
                                           (SSMCTrCS2WTR2Rd = '1')
                 else
                    ZEROFILL(31 downto 12) & iSSMCTrCS2WTR3 when
                                           (SSMCTrCS2WTR3Rd = '1')
                 else
                    ZEROFILL(31 downto 12) & iSSMCTrCS2WTR4 when
                                           (SSMCTrCS2WTR4Rd = '1')
                 else
                    ZEROFILL(31 downto 12) & iSSMCTrCS2WTR5 when
                                           (SSMCTrCS2WTR5Rd = '1')
                 else
                    ZEROFILL(31 downto 12) & iSSMCTrCS2WTR6 when
                                           (SSMCTrCS2WTR6Rd = '1')
                 else
                    ZEROFILL(31 downto 12) & iSSMCTrCS2WTR7 when
                                           (SSMCTrCS2WTR7Rd = '1')
                 else
                    ZEROFILL(31 downto 9) & iSSMCTrWTCNCL when
                                           (SSMCTrWTCNCLRd = '1')
                 else
                    ZEROFILL(31 downto 3) & iSSMCTrCR when
                                           (SSMCTrCRRd = '1')
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
    iHRESPTr        <= "00";
    HREADYOUTTr     <= '1';
    WrEn            <= '0';
    RdEn            <= '0';
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
           (HSELSSMCTr = '1') and (HREADYINTr = '1')) then
      iHRESPTr      <= OKAY;
      HREADYOUTTr   <= '1';
    elsif ((HREADYINTr = '1') and (HSELSSMCTr = '1')) then
      if (HSIZE = WORD) then
        HREADYOUTTr <= '1';
        iLatchHADDR <= HADDR;
        iHRESPTr    <= OKAY;
        if (HWRITE = '1') then
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
          report "Error Response from SSMC trickbox slave"
        severity warning;
      end if;
    else
      WrEn          <= '0';
      RdEn          <= '0';
      iHRESPTr      <= "00";
      HREADYOUTTr   <= '1';
      ErrorLat      <= '0';
    end if;
  end if;
end process p_BusRespSeq;

-- -----------------------------------------------------------------------------
-- Combinational logic for all functional registers. When the respective
-- write enable input is asserted, copy the contents of the HWDATA Bus into
-- the corresponding registers.
-- -----------------------------------------------------------------------------
NxtSSMCTrMWCS     <= HWDATA(1 downto 0) when (SSMCTrMWCSWr = '1')
                 else
                    SSMCTrMWCS;

NxtSSMCTrSMBLSPOL <= HWDATA(0) when (SSMCTrSMBLSPOLWr = '1')
                 else
                    SSMCTrSMBLSPOL;

NxtSSMCTrExtMux   <= HWDATA(8 downto 0) when (SSMCTrExtMuxWr = '1')
                 else
                    iSSMCTrExtMux;

NxtSSMCTrEndian   <= HWDATA(0) when (SSMCTrEndianWr = '1')
                 else
                    SSMCTrEndian;

NxtSSMCTrCS2WTR0  <= HWDATA(11 downto 0) when (SSMCTrCS2WTR0Wr = '1')
                 else
                    iSSMCTrCS2WTR0;

NxtSSMCTrCS2WTR1  <= HWDATA(11 downto 0) when (SSMCTrCS2WTR1Wr = '1')
                 else
                    iSSMCTrCS2WTR1;

NxtSSMCTrCS2WTR2  <= HWDATA(11 downto 0) when (SSMCTrCS2WTR2Wr = '1')
                 else
                    iSSMCTrCS2WTR2;

NxtSSMCTrCS2WTR3  <= HWDATA(11 downto 0) when (SSMCTrCS2WTR3Wr = '1')
                 else
                    iSSMCTrCS2WTR3;

NxtSSMCTrCS2WTR4  <= HWDATA(11 downto 0) when (SSMCTrCS2WTR4Wr = '1')
                 else
                    iSSMCTrCS2WTR4;

NxtSSMCTrCS2WTR5  <= HWDATA(11 downto 0) when (SSMCTrCS2WTR5Wr = '1')
                 else
                    iSSMCTrCS2WTR5;

NxtSSMCTrCS2WTR6  <= HWDATA(11 downto 0) when (SSMCTrCS2WTR6Wr = '1')
                 else
                    iSSMCTrCS2WTR6;

NxtSSMCTrCS2WTR7  <= HWDATA(11 downto 0) when (SSMCTrCS2WTR7Wr = '1')
                 else
                    iSSMCTrCS2WTR7;

NxtSSMCTrWTCNCL   <= HWDATA(8 downto 0) when (SSMCTrWTCNCLWr = '1')
                 else
                    iSSMCTrWTCNCL;

NxtSSMCTrCR       <= HWDATA(2 downto 0) when (SSMCTrCRWr = '1')
                 else
                    iSSMCTrCR;   
-- -----------------------------------------------------------------------------
-- Sequential process for all functional registers writes.
-- -----------------------------------------------------------------------------
p_RegUpdateSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    iSSMCTrExtMux    <= (others => '0');
    SSMCTrEndian     <= '0';
    iSSMCTrCS2WTR0   <= (others => '0');
    iSSMCTrCS2WTR1   <= (others => '0');
    iSSMCTrCS2WTR2   <= (others => '0');
    iSSMCTrCS2WTR3   <= (others => '0');
    iSSMCTrCS2WTR4   <= (others => '0');
    iSSMCTrCS2WTR5   <= (others => '0');
    iSSMCTrCS2WTR6   <= (others => '0');
    iSSMCTrCS2WTR7   <= (others => '0');
    iSSMCTrWTCNCL    <= (others => '0');
    iSSMCTrCR        <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    SSMCTrMWCS       <= NxtSSMCTrMWCS;
    SSMCTrSMBLSPOL   <= NxtSSMCTrSMBLSPOL;
    iSSMCTrExtMux    <= NxtSSMCTrExtMux;
    SSMCTrEndian     <= NxtSSMCTrEndian;
    iSSMCTrCS2WTR0   <= NxtSSMCTrCS2WTR0;
    iSSMCTrCS2WTR1   <= NxtSSMCTrCS2WTR1;
    iSSMCTrCS2WTR2   <= NxtSSMCTrCS2WTR2;
    iSSMCTrCS2WTR3   <= NxtSSMCTrCS2WTR3;
    iSSMCTrCS2WTR4   <= NxtSSMCTrCS2WTR4;
    iSSMCTrCS2WTR5   <= NxtSSMCTrCS2WTR5;
    iSSMCTrCS2WTR6   <= NxtSSMCTrCS2WTR6;
    iSSMCTrCS2WTR7   <= NxtSSMCTrCS2WTR7;
    iSSMCTrWTCNCL    <= NxtSSMCTrWTCNCL;
    iSSMCTrCR        <= NxtSSMCTrCR;
  end if;
end process p_RegUpdateSeq;  

-- -----------------------------------------------------------------------------
-- Assign local copies of signals to the outputs
-- -----------------------------------------------------------------------------
HRESPTr          <= iHRESPTr;
SMMWCS7          <= SSMCTrMWCS;
SMBLS7POL        <= SSMCTrSMBLSPOL;
SSMCTrExtMux     <= iSSMCTrExtMux;
BIGENDIAN        <= SSMCTrEndian;
SSMCTrCS2WTR0    <= iSSMCTrCS2WTR0;
SSMCTrCS2WTR1    <= iSSMCTrCS2WTR1;
SSMCTrCS2WTR2    <= iSSMCTrCS2WTR2;
SSMCTrCS2WTR3    <= iSSMCTrCS2WTR3;
SSMCTrCS2WTR4    <= iSSMCTrCS2WTR4;
SSMCTrCS2WTR5    <= iSSMCTrCS2WTR5;
SSMCTrCS2WTR6    <= iSSMCTrCS2WTR6;
SSMCTrCS2WTR7    <= iSSMCTrCS2WTR7;
SSMCTrWTCNCL     <= iSSMCTrWTCNCL;
SSMCTrCR         <= iSSMCTrCR;
end behavioural;

-- --================================== End ==================================-- 
