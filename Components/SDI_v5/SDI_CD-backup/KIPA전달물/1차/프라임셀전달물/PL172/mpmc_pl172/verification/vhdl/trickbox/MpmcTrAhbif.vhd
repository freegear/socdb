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
-- File Name              : MpmcTrAhbif.vhd.rca
-- File Revision          : 1.8
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block interfaces the MPMC Trickbox with the AHB.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use work.MpmcTrPackage.all;

-- -----------------------------------------------------------------------------

entity MpmcTrAhbif is
  port (
-- Inputs
        -- AHB bus signals
        HCLK             : in    std_logic; -- AHB Bus Clock
        HRESETn          : in    std_logic; -- Bus Reset
        HADDR            : in    std_logic_vector(11 downto 2);
                                            -- AHB Address Bus
        HTRANS           : in    std_logic_vector(1 downto 0);
                                            -- Transfer type
        HWRITE           : in    std_logic; -- AHB Peripheral Write
        HSIZE            : in    std_logic_vector(2 downto 0);
                                            -- Transfer size
        HREADYIN         : in    std_logic; -- Multiplexed version of
                                            -- HREADY outputs
        MPMCTrSR         : in    std_logic_vector(8 downto 0);
                                            -- MPMCTrSR Register
        HWDATA           : in    std_logic_vector(31 downto 0);
                                            -- AHB Write Data bus
        HSELMPMCTR       : in    std_logic; -- AHB Peripheral (Trickbox)
                                            -- Select
        HSELMPMCREG      : in    std_logic; -- AHB Peripheral (MPMC Reg)
                                            -- Select
        Fifo1Out         : in    std_logic_vector(31 downto 0);
                                            -- Snooper fifo1 data from snooper
                                            -- module
        Fifo2Out         : in    std_logic_vector(31 downto 0);
                                            -- Snooper fifo2 data from snooper
                                            -- module
        MPMCTrCR         : in    std_logic_vector(6 downto 0);
                                            -- MPMCTrCR Register
        MPMCTrSNPCR      : in    std_logic_vector(3 downto 0);
                                            -- MPMCTrSNP Control Register
        MPMCTrExpRef     : in    std_logic_vector(3 downto 0);
                                            -- MPMCTrExpRef Register
        MPMCTrExBkOff    : in    std_logic_vector(5 downto 0);
                                            -- MPMCTrExBkOff Register
        MPMCTrStCS       : in    std_logic_vector(6 downto 0);
                                            -- MPMCTrStCS Register
        MPMCTrTES        : in    std_logic_vector(3 downto 0);
                                            -- MPMCTrTES Register
        HREADY0CNT       : in    std_logic_vector(7 downto 0);
                                            -- HREADY0CNT Register
        HREADY1CNT       : in    std_logic_vector(7 downto 0);
                                            -- HREADY1CNT Register
-- Outputs
        HREADYOUT        : out   std_logic; -- Slave HREADY output
        HRESP            : out   std_logic_vector(1 downto 0);
                                            -- Slave response
        HRDATA           : out   std_logic_vector(31 downto 0);
                                            -- AHB Read Data bus
        WriteData        : out   std_logic_vector(31 downto 0);
                                            -- Write Data bus to the Register
                                            -- Block
        MPMCTrSRWr       : out   std_logic; -- MPMCTrSR register write enable
        MPMCTrCRWr       : out   std_logic; -- MPMCTrCR Register Write Enable
        MPMCTrSNPCRWr    : out   std_logic; -- MPMCTrSNPCR Register Write
        MPMCTrControlWr  : out   std_logic; -- MPMCTrControl Register Write
                                            -- Enable
        MPMCTrConfigWr   : out   std_logic; -- MPMCTrConfig Register Write
                                            -- Enable
        MPMCTrDynCntlWr  : out   std_logic; -- MPMCTrDynCntl Register Write
                                            -- Enable
        MPMCTrDynRfrshWr : out   std_logic; -- MPMCTrDynRfrsh Register Write
                                            -- Enable
        MPMCTrStExtWtWr  : out   std_logic; -- MPMCTrExtWait Register Write
                                            -- Enable
        MPMCTrDynRC0Wr   : out   std_logic; -- MPMCTrDynRC0 Register Write
                                            -- Enable
        MPMCTrDynRC1Wr   : out   std_logic; -- MPMCTrDynRC1 Register Write
                                            -- Enable
        MPMCTrDynRC2Wr   : out   std_logic; -- MPMCTrDynRC2 Register Write
                                            -- Enable
        MPMCTrDynRC3Wr   : out   std_logic; -- MPMCTrDynRC3 Register Write
                                            -- Enable
        MPMCTrDynCnfg0Wr : out   std_logic; -- MPMCTrDynCnfg0 Register Write
                                            -- Enable
        MPMCTrDynCnfg1Wr : out   std_logic; -- MPMCTrDynCnfg1 Register Write
                                            -- Enable
        MPMCTrDynCnfg2Wr : out   std_logic; -- MPMCTrDynCnfg2 Register Write
                                            -- Enable
        MPMCTrDynCnfg3Wr : out   std_logic; -- MPMCTrDynCnfg3 Register Write
                                            -- Enable
        MPMCTrStCSWr     : out   std_logic; -- MPMCTrStCS Register Write Enable
        MPMCTrTESWr      : out   std_logic; -- MPMCTrTES Register Write Enable
        MPMCTrExpRefWr   : out   std_logic; -- MPMCTrExpRef Register Write
                                            -- Enable
        MPMCTrExBkOffWr  : out   std_logic; -- MPMCTrExBkOff Register Write
                                            -- Enable
        HREADY0CNTWr     : out   std_logic; -- HREADY0CNT Register Write
        HREADY1CNTWr     : out   std_logic; -- HREADY1CNT Register Write
        Fifo1Rd          : out   std_logic; -- Snooper fifo1 Read Enable signal
        Fifo2Rd          : out   std_logic  -- Snooper fifo2 Read Enable signal
       );
end MpmcTrAhbif;

-- -----------------------------------------------------------------------------
--
--                                 MpmcTrAhbif
--                                 ===========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- MPMC Tricbox is an AHB slave. This block performs the following operations:
--   - Interfaces the Trickbox with the AHB
--       All slave response signals are generated from this module.
--       This module decodes AHB accesses and generates the read/write
--       strobe to the appropriate registers.
--
-- -----------------------------------------------------------------------------
--                         MPMC Trickbox Register Map
-- -----------------------------------------------------------------------------
-- Offset    Register       Type  Width    Describtion
-- -----------------------------------------------------------------------------
-- [from MpmcTr Base]
-- 0x0000 -  MPMCTrCR       R/W  7-bits  This is MPMC Trickbox Control register
--                                       used to control various signals
--
-- 0x0004 -  MPMCTrSR       R/W  9-bits  This is MPMC Trickbox Status register
--                                       used to setting and reading the
--                                       various signals
--
-- 0x0008 -  MPMCTrSNPFIFO1 R/W  32-bits This is MPMC Trickbox snooper Fifo1
--                                       used to snoop the PAD signals from MPMC
--
-- 0x000C -  MPMCTrSNPFIFO2 R/W  32-bits This is MPMC Trickbox snooper Fifo2
--                                       used to snoop the PAD signals from MPMC
--
-- 0x0014    MPMCTrStCS     R/W  6-bits  This register is used to drive the
--                                       MPMCSTATICCS1POL and
--                                       MPMCSTATICCS1MW width signal
--
-- 0x0018    MPMCTrTES      R/W  4-bits  This register indicates the Test End
--                                       Status of 4 AHBs
--
-- 0x001C -  MPMCTrSNPCR    R/W  4-bits  This is MPMC Trickbox snooper Fifo
--                                       used to snoop the PAD signals from MPMC
--
-- 0x0020 -  MPMCTrExpRef   R/W  4-bits  This register specifies the number of
--                                       refresh cycles needed during the
--                                       initialisation
-- 0x0024 -  MPMCTrExBkOff  W    6-bits  This register specifies the number of
--                                       clks after which BackOff is asserted
--
-- [from Mpmc Base]
-- 0x0000    MPMCTrControl  R/W  4-bits  This register is a mirrored version
--                                       of the MPMCControl register
--
-- 0x0008    MPMCTrConfig   R/W  10-bits This register is a mirrored version
--                                       of the MPMCConfig register
--
-- 0x0020    MPMCTrDynCntl  R/W  16-bits This register is a mirrored version
--                                       of the MPMCDynControl register
--
-- 0x0024    MPMCTrDynRfrsh R/W  11-bits This register is a mirrored version
--                                       of the MPMCTrDynRefresh register
--
-- 0x0080    MPMCTrStExtWt  R/W  10-bits This register indicates the Extended
--                                       Wait count
--
-- 0x0100    MPMCTrDynCnfg0 R/W  16-bits This register is a mirrored version
--                                       of the MPMCTrDynConfig0 register
--
-- 0x0104    MPMCTrDynRC0   R/W 10-bits  This register is a mirrored version
--                                       of the MPMCTrDynRasCas0 register
--
-- 0x0120    MPMCTrDynCnfg1 R/W  16-bits This register is a mirrored version
--                                       of the MPMCTrDynConfig1 register
--
-- 0x0124    MPMCTrDynRC1   R/W 10-bits  This register is a mirrored version
--                                       of the MPMCTrDynRasCas1 register
--
-- 0x0140    MPMCTrDynCnfg2 R/W  16-bits This register is a mirrored version
--                                       of the MPMCTrDynConfig2 register
--
-- 0x0144    MPMCTrDynRC2   R/W 10-bits  This register is a mirrored version
--                                       of the MPMCTrDynRasCas2 register
--
-- 0x0160    MPMCTrDynCnfg3 R/W  16-bits This register is a mirrored version
--                                       of the MPMCTrDynConfig3 register
--
-- 0x0164    MPMCTrDynRC3   R/W 10-bits  This register is a mirrored version
--                                       of the MPMCTrDynRasCas3 register
--
-- -----------------------------------------------------------------------------

-- --============================ ARCHITECTURE ===============================--

architecture behavioural of MpmcTrAhbif is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Zero fill for register reads to return zeros in unused bit positions
-- -----------------------------------------------------------------------------
constant ZEROFILL         : std_logic_vector(31 downto 0)
                          := "00000000000000000000000000000000";

-- -----------------------------------------------------------------------------
-- Trickbox registers address constants. Address decode is for
-- bits 2 to 4 (3 bits)
-- -----------------------------------------------------------------------------
constant ADDR_MPMCTrCR        : std_logic_vector(11 downto 2)  := "0000000000";
-- MPMCTrCR at offset 0x0000

constant ADDR_MPMCTrSR        : std_logic_vector(11 downto 2)  := "0000000001";
-- MPMCTrSR at offset 0x0004

constant ADDR_MPMCTrSNPFIFO1  : std_logic_vector(11 downto 2)  := "0000000010";
-- MPMCTrSNP1 at offset 0x0008

constant ADDR_MPMCTrSNPFIFO2  : std_logic_vector(11 downto 2)  := "0000000011";
-- MPMCTrSNP1 at offset 0x000C

constant ADDR_MPMCTrStCS      : std_logic_vector(11 downto 2)  := "0000000101";
-- MPMCTrStCS at offset 0x0014

constant ADDR_MPMCTrTES       : std_logic_vector(11 downto 2)  := "0000000110";
-- MPMCTrDynCnfg at offset 0x0018

constant ADDR_MPMCTrSNPCR     : std_logic_vector(11 downto 2)  := "0000000111";
-- MPMCTrSNPCR at offset 0x001C

constant ADDR_MPMCTrExpRef    : std_logic_vector(11 downto 2)  := "0000001000";
-- MPMCTrExpRef at offset 0x0020

constant ADDR_MPMCTrExBkOff    : std_logic_vector(11 downto 2)  := "0000001001";
-- MPMCTrExBkOff at offset 0x0024

constant ADDR_HREADY0CNT    : std_logic_vector(11 downto 2)  := "0000001010";
-- HREADY0CNT at offset 0x0028

constant ADDR_HREADY1CNT    : std_logic_vector(11 downto 2)  := "0000001011";
-- HREADY1CNT at offset 0x002C

constant ADDR_MPMCTrControl   : std_logic_vector(11 downto 2)  := "0000000000";
-- MPMCTrControl at offset 0x0000 from Mpmc base

constant ADDR_MPMCTrConfig    : std_logic_vector(11 downto 2)  := "0000000010";
-- MPMCTrConfig at offset 0x0008 from Mpmc base

constant ADDR_MPMCTrDynCntl   : std_logic_vector(11 downto 2)  := "0000001000";
-- MPMCTrDynCntl at offset 0x0020 from Mpmc base

constant ADDR_MPMCTrDynRfrsh  : std_logic_vector(11 downto 2)  := "0000001001";
-- MPMCTrDynRfrsh at offset 0x0024 from Mpmc base

constant ADDR_MPMCTrStExtWt   : std_logic_vector(11 downto 2)  := "0000100000";
-- MPMCTrDynRfrsh at offset 0x0080 from Mpmc base

constant ADDR_MPMCTrDynCnfg0  : std_logic_vector(11 downto 2)  := "0001000000";
-- MPMCTrDynCnfg0 at offset 0x0100 from Mpmc base

constant ADDR_MPMCTrDynRC0    : std_logic_vector(11 downto 2)  := "0001000001";
-- MPMCTrDynRC0 at offset 0x0104 from Mpmc base

constant ADDR_MPMCTrDynCnfg1  : std_logic_vector(11 downto 2)  := "0001001000";
-- MPMCTrDynCnfg1 at offset 0x0120 from Mpmc base

constant ADDR_MPMCTrDynRC1    : std_logic_vector(11 downto 2)  := "0001001001";
-- MPMCTrDynRC1 at offset 0x0124 from Mpmc base

constant ADDR_MPMCTrDynCnfg2  : std_logic_vector(11 downto 2)  := "0001010000";
-- MPMCTrDynCnfg2 at offset 0x0140 from Mpmc base

constant ADDR_MPMCTrDynRC2    : std_logic_vector(11 downto 2)  := "0001010001";
-- MPMCTrDynRC2 at offset 0x0144 from Mpmc base

constant ADDR_MPMCTrDynCnfg3  : std_logic_vector(11 downto 2)  := "0001011000";
-- MPMCTrDynCnfg3 at offset 0x0160 from Mpmc base

constant ADDR_MPMCTrDynRC3    : std_logic_vector(11 downto 2)  := "0001011001";
-- MPMCTrDynRC3 at offset 0x0164 from Mpmc base

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal WaitCount        : unsigned(7 downto 0) := "00000000";
-- Wait State Counter

signal iLatchHADDR      : std_logic_vector(11 downto 2) := (others => '0');
-- Latched version of HADDR

signal iHRESP           : std_logic_vector(1 downto 0);
-- Indicates the type of response for a transfer

signal RdEn             : std_logic;
-- Read enable signal

signal MPMCTrCRRd       : std_logic;
-- MPMCTrCR Read

signal MPMCTrSRRd       : std_logic;
-- MPMCTrSR Read

signal MPMCTrSNPCRRd    : std_logic;
-- MPMCTrSNPCR Read

signal MPMCTrExpRefRd   : std_logic;
-- MPMCTrExpRef Read

signal MPMCTrSNPFIFO1Rd : std_logic;
-- MPMCTrSNPFIFO1 Read

signal MPMCTrSNPFIFO2Rd : std_logic;
-- MPMCTrSNPFIFO1 Read

signal MPMCTrStCSRd     : std_logic;
-- MPMCTrStCS Read

signal MPMCTrTESRd      : std_logic;
-- MPMCTrTES Read

signal WrEn             : std_logic;
-- Write enable signal

signal WrEnCom          : std_logic;
-- Write enable signal for MPMC mirror registers

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
MPMCTrCRWr       <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_MPMCTrCR))
                 else
                    '0';

MPMCTrSRWr       <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_MPMCTrSR))
                 else
                    '0';

MPMCTrSNPCRWr    <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_MPMCTrSNPCR))
                 else
                    '0';

MPMCTrStCSWr     <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_MPMCTrStCS))
                 else
                    '0';

MPMCTrTESWr      <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_MPMCTrTES))
                 else
                    '0';

MPMCTrExpRefWr   <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_MPMCTrExpRef))
                 else
                    '0';

MPMCTrExBkOffWr   <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_MPMCTrExBkOff))
                 else
                    '0';

HREADY0CNTWr     <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_HREADY0CNT))
                 else
                    '0';

HREADY1CNTWr     <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_HREADY1CNT))
                 else
                    '0';

MPMCTrControlWr  <= '1' when ((WrEnCom = '1') and
                             (iLatchHADDR = ADDR_MPMCTrControl))
                 else
                    '0';

MPMCTrConfigWr   <= '1' when ((WrEnCom = '1') and
                             (iLatchHADDR = ADDR_MPMCTrConfig))
                 else
                     '0';

MPMCTrDynCntlWr  <= '1' when ((WrEnCom = '1') and
                             (iLatchHADDR = ADDR_MPMCTrDynCntl))
                 else
                    '0';

MPMCTrDynRfrshWr <= '1' when ((WrEnCom = '1') and
                             (iLatchHADDR = ADDR_MPMCTrDynRfrsh))
                 else
                    '0';

MPMCTrStExtWtWr  <= '1' when ((WrEnCom = '1') and
                             (iLatchHADDR = ADDR_MPMCTrStExtWt))
                 else
                    '0';

MPMCTrDynRC0Wr   <= '1' when ((WrEnCom = '1') and
                             (iLatchHADDR = ADDR_MPMCTrDynRC0))
                 else
                    '0';

MPMCTrDynRC1Wr   <= '1' when ((WrEnCom = '1') and
                             (iLatchHADDR = ADDR_MPMCTrDynRC1))
                 else
                    '0';

MPMCTrDynRC2Wr   <= '1' when ((WrEnCom = '1') and
                             (iLatchHADDR = ADDR_MPMCTrDynRC2))
                 else
                    '0';

MPMCTrDynRC3Wr   <= '1' when ((WrEnCom = '1') and
                             (iLatchHADDR = ADDR_MPMCTrDynRC3))
                 else
                    '0';

MPMCTrDynCnfg0Wr <= '1' when ((WrEnCom = '1') and
                             (iLatchHADDR = ADDR_MPMCTrDynCnfg0))
                 else
                    '0';

MPMCTrDynCnfg1Wr <= '1' when ((WrEnCom = '1') and
                             (iLatchHADDR = ADDR_MPMCTrDynCnfg1))
                 else
                    '0';

MPMCTrDynCnfg2Wr <= '1' when ((WrEnCom = '1') and
                             (iLatchHADDR = ADDR_MPMCTrDynCnfg2))
                 else
                    '0';

MPMCTrDynCnfg3Wr <= '1' when ((WrEnCom = '1') and
                             (iLatchHADDR = ADDR_MPMCTrDynCnfg3))
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Read enables for registers
-- -----------------------------------------------------------------------------
MPMCTrCRRd       <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_MPMCTrCR))
                 else
                    '0';

MPMCTrSRRd       <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_MPMCTrSR))
                 else
                    '0';

MPMCTrSNPCRRd    <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_MPMCTrSNPCR))
                 else
                    '0';

MPMCTrSNPFIFO1Rd <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_MPMCTrSNPFIFO1))
                 else
                    '0';

MPMCTrSNPFIFO2Rd <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_MPMCTrSNPFIFO2))
                 else
                    '0';

MPMCTrStCSRd     <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_MPMCTrStCS))
                 else
                    '0';

MPMCTrTESRd      <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_MPMCTrTES))
                 else
                    '0';

MPMCTrExpRefRd   <= '1' when ((RdEn = '1') and
                             (iLatchHADDR = ADDR_MPMCTrExpRef))
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Output Mux
-- When the peripheral is not being accessed, '0's are driven
-- on the Read Databus (HRDATA)
-- -----------------------------------------------------------------------------
HRDATA           <= ZEROFILL(31 downto 7) & MPMCTrCR when
                                           (MPMCTrCRRd = '1')
                 else
                    ZEROFILL(31 downto 9) & MPMCTrSR when
                                           (MPMCTrSRRd = '1')
                 else
                    ZEROFILL(31 downto 4) & MPMCTrSNPCR when
                                           (MPMCTrSNPCRRd = '1')
                 else
                    Fifo1Out                          when
                                           (MPMCTrSNPFIFO1Rd = '1')
                 else
                    Fifo2Out                          when
                                           (MPMCTrSNPFIFO2Rd = '1')
                 else
                    ZEROFILL(31 downto 6) & MPMCTrStCS when
                                           (MPMCTrStCSRd = '1')
                 else
                    ZEROFILL(31 downto 4) & MPMCTrTES when
                                           (MPMCTrTESRd = '1')
                 else
                    ZEROFILL(31 downto 4) & MPMCTrExpRef when
                                           (MPMCTrExpRefRd = '1')
                 else
                    ZEROFILL;

-- -----------------------------------------------------------------------------
-- This process generates the bus response required for an AHB slave.
-- MPMC Trickbox is designed for an HSIZE of 32-bit. So this process will
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
    if ((iHRESP = HRESP_ERROR) and (HREADYIN = '0') and (ErrorLat = '1')) then
      iHRESP        <= HRESP_ERROR;
      HREADYOUT     <= '1';
      WrEn          <= '0';
      RdEn          <= '0';
      ErrorLat      <= '0';
    elsif (((HTRANS = HTRANS_IDLE) or (HTRANS = HTRANS_BUSY)) and
           ((HSELMPMCTR = '1') or (HSELMPMCREG = '1')) and
           (HREADYIN = '1')) then
      WrEn          <= '0';
      RdEn          <= '0';
      WrEnCom       <= '0';
      iHRESP        <= HRESP_OKAY;
      HREADYOUT     <= '1';
    elsif ((HREADYIN = '1') and (HSELMPMCTR = '1')) then
      if (HSIZE = HSIZE_WORD) then
        HREADYOUT   <= '1';
        iLatchHADDR <= HADDR;
        iHRESP      <= HRESP_OKAY;
        if (HWRITE = '1') then
          WrEn      <= '1';
          RdEn      <= '0';
          WrEnCom   <= '0';
        else
          WrEn      <= '0';
          RdEn      <= '1';
          WrEnCom   <= '0';
        end if;
      else
        iHRESP      <= HRESP_ERROR;
        HREADYOUT   <= '0';
        WrEn        <= '0';
        RdEn        <= '0';
        WrEnCom     <= '0';
        ErrorLat    <= '1';
        assert false
          report "Error Response from MPMC trickbox slave"
        severity warning;
      end if;
    elsif ((HREADYIN = '1') and (HSELMPMCREG = '1')) then
      if (HSIZE = HSIZE_WORD) then
        HREADYOUT   <= '1';
        iLatchHADDR <= HADDR;
        iHRESP      <= HRESP_OKAY;
        if (HWRITE = '1') then
          WrEn      <= '0';
          WrEnCom   <= '1';
          RdEn      <= '0';
        else
          WrEn      <= '0';
          WrEnCom   <= '0';
          RdEn      <= '0';
        end if;
      else
        iHRESP      <= HRESP_ERROR;
        HREADYOUT   <= '0';
        WrEn        <= '0';
        WrEnCom     <= '0';
        RdEn        <= '0';
        ErrorLat    <= '1';
      end if;
    else
      WrEn          <= '0';
      RdEn          <= '0';
      WrEnCom       <= '0';
      iHRESP        <= "00";
      HREADYOUT     <= '1';
      ErrorLat      <= '0';
    end if;
  end if;
end process p_BusRespSeq;

-- -----------------------------------------------------------------------------
-- Generation of FifoRd signals
-- -----------------------------------------------------------------------------
Fifo1Rd          <= MPMCTrSNPFIFO1Rd;
Fifo2Rd          <= MPMCTrSNPFIFO2Rd;

-- -----------------------------------------------------------------------------
-- Assign AHB Write Data
-- -----------------------------------------------------------------------------
WriteData        <= HWDATA when (WrEn = '1' or WrEnCom = '1')
                 else
                    (others => '0');

-- -----------------------------------------------------------------------------
-- Assign local copies of signals to the outputs
-- -----------------------------------------------------------------------------
HRESP            <= iHRESP;

end behavioural;

-- --================================== End ==================================--
