-- --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : VicTrAhbif.vhd.rca
-- File Revision          : 1.6
--
-- Release Information    : PrimeCell(TM)-PL190-REL1v1
--
-- ---------------------------------------------------------------------
-- Purpose :
--           This module implements the AHB Interface and Register
--           block.
--
-- --=================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use work.VicTrPackage.all;

-- ---------------------------------------------------------------------

entity VicTrAhbif is
  generic (
           tovminintsrc     : time;
           tovmaxintsrc     : time;
           tovminnvicfiqin  : time;
           tovmaxnvicfiqin  : time;
           tovminnvicirqin  : time;
           tovmaxnvicirqin  : time;
           tovminvectadin   : time;
           tovmaxvectadin   : time
          );
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB Clock
        HRESETn          : in    std_logic; -- AHB Reset
        HREADYIN         : in    std_logic; -- Transfer Ready Signal
        HADDR            : in    std_logic_vector(11 downto 2);
                                            -- Address Bus for AHB Slave
        HTRANS           : in    std_logic; -- Transfer signal for
                                            -- AHB Slave
        HSIZE            : in    std_logic_vector(2 downto 0);
                                            -- AHB transfer size
        HWRITE           : in    std_logic; -- Write Signal for AHB
                                            -- Slave
        HPROT            : in    std_logic; -- Protection Control signal
        HWDATA           : in    std_logic_vector(31 downto 0);
                                            -- Write Data input for AHB
                                            -- Slave
        HSELVICTR        : in    std_logic; -- Slave Select Signal for
                                            -- the VIC Trickbox
        HSELVIC          : in    std_logic; -- Slave Select Signal for
                                            -- the VIC
        VICTrVectAddr    : in    std_logic_vector(31 downto 0);
                                            -- Vector address from the
                                            -- Mirrored VIC Model
        nVICFIQ          : in    std_logic; -- nVICFIQ output from the
                                            -- VIC
        nVICIRQ          : in    std_logic; -- nVICIRQ output from the
                                            -- VIC
        VICVECTADDROUT   : in    std_logic_vector(31 downto 0);
                                            -- Input lines for reading
                                            -- VICVECTADDROUT
-- Outputs
        HRDATA           : out   std_logic_vector(31 downto 0);
                                            -- Read Data output from AHB
                                            -- Slave
        HREADYOUT        : out   std_logic; -- Ready Signal from
                                            -- AHB Slave
        HRESP            : out   std_logic_vector(1 downto 0);
                                            -- Transfer Response from
                                            -- AHB Slave
        VICTrTCR         : out   std_logic_vector(2 downto 0);
                                            -- Compare Enable signals
                                            -- for VicTrProtChkr
        VICINTSOURCE     : out   std_logic_vector(31 downto 0);
                                            -- Output lines for raising
                                            -- Interrupt requests to the
                                            -- VIC
        VICVECTADDRIN    : out   std_logic_vector(31 downto 0);
                                            -- VICVECTADDRIN Daisy
                                            -- chain Vector address
                                            -- signal to the VIC
        nVICFIQIN        : out   std_logic; -- nVICFIQIN Daisy chain
                                            -- signal to the VIC
        nVICIRQIN        : out   std_logic; -- nVICIRQIN Daisy chain
                                            -- signal to the VIC
        SetCSRBit        : out   std_logic; -- Control signal to set
                                            -- the Current Service
                                            -- register in the priority
                                            -- resolver
        ClearCSRBit      : out   std_logic; -- Control signal to clear
                                            -- the Current Service
                                            -- register in the priority
                                            -- resolver
        VICTrSoftInt     : out   std_logic_vector(31 downto 0);
                                            -- Mirrored VICSoftInt
                                            -- register
        VICTrIntEnable   : out   std_logic_vector(31 downto 0);
                                            -- Mirrored VICIntEnable
                                            -- register
        VICTrIntSelect   : out   std_logic_vector(31 downto 0);
                                            -- Mirrored VICIntSelect
                                            -- register
        VICTrDefVectAddr : out   std_logic_vector(31 downto 0);
                                            -- Mirrored VICDefVectAddr
                                            -- register
        VICTrVectAddr0   : out   std_logic_vector(31 downto 0);
                                            -- Mirrored VICVectorAddr0
                                            -- register
        VICTrVectAddr1   : out   std_logic_vector(31 downto 0);
                                            -- Mirrored VICVectorAddr1
                                            -- register
        VICTrVectAddr2   : out   std_logic_vector(31 downto 0);
                                            -- Mirrored VICVectorAddr2
                                            -- register
        VICTrVectAddr3   : out   std_logic_vector(31 downto 0);
                                            -- Mirrored VICVectorAddr3
                                            -- register
        VICTrVectAddr4   : out   std_logic_vector(31 downto 0);
                                            -- Mirrored VICVectorAddr4
                                            -- register
        VICTrVectAddr5   : out   std_logic_vector(31 downto 0);
                                            -- Mirrored VICVectorAddr5
                                            -- register
        VICTrVectAddr6   : out   std_logic_vector(31 downto 0);
                                            -- Mirrored VICVectorAddr6
                                            -- register
        VICTrVectAddr7   : out   std_logic_vector(31 downto 0);
                                            -- Mirrored VICVectorAddr7
                                            -- register
        VICTrVectAddr8   : out   std_logic_vector(31 downto 0);
                                            -- Mirrored VICVectorAddr8
                                            -- register
        VICTrVectAddr9   : out   std_logic_vector(31 downto 0);
                                            -- Mirrored VICVectorAddr9
                                            -- register
        VICTrVectAddr10  : out   std_logic_vector(31 downto 0);
                                            -- Mirrored VICVectorAddr10
                                            -- register
        VICTrVectAddr11  : out   std_logic_vector(31 downto 0);
                                            -- Mirrored VICVectorAddr11
                                            -- register
        VICTrVectAddr12  : out   std_logic_vector(31 downto 0);
                                            -- Mirrored VICVectorAddr12
                                            -- register
        VICTrVectAddr13  : out   std_logic_vector(31 downto 0);
                                            -- Mirrored VICVectorAddr13
                                            -- register
        VICTrVectAddr14  : out   std_logic_vector(31 downto 0);
                                            -- Mirrored VICVectorAddr14
                                            -- register
        VICTrVectAddr15  : out   std_logic_vector(31 downto 0);
                                            -- Mirrored VICVectorAddr15
                                            -- register
        VICTrVectCntl0   : out   std_logic_vector(5 downto 0);
                                            -- Mirrored VICVectorCntl0
                                            -- register
        VICTrVectCntl1   : out   std_logic_vector(5 downto 0);
                                            -- Mirrored VICVectorCntl1
                                            -- register
        VICTrVectCntl2   : out   std_logic_vector(5 downto 0);
                                            -- Mirrored VICVectorCntl2
                                            -- register
        VICTrVectCntl3   : out   std_logic_vector(5 downto 0);
                                            -- Mirrored VICVectorCntl3
                                            -- register
        VICTrVectCntl4   : out   std_logic_vector(5 downto 0);
                                            -- Mirrored VICVectorCntl4
                                            -- register
        VICTrVectCntl5   : out   std_logic_vector(5 downto 0);
                                            -- Mirrored VICVectorCntl5
                                            -- register
        VICTrVectCntl6   : out   std_logic_vector(5 downto 0);
                                            -- Mirrored VICVectorCntl6
                                            -- register
        VICTrVectCntl7   : out   std_logic_vector(5 downto 0);
                                            -- Mirrored VICVectorCntl7
                                            -- register
        VICTrVectCntl8   : out   std_logic_vector(5 downto 0);
                                            -- Mirrored VICVectorCntl8
                                            -- register
        VICTrVectCntl9   : out   std_logic_vector(5 downto 0);
                                            -- Mirrored VICVectorCntl9
                                            -- register
        VICTrVectCntl10  : out   std_logic_vector(5 downto 0);
                                            -- Mirrored VICVectorCntl10
                                            -- register
        VICTrVectCntl11  : out   std_logic_vector(5 downto 0);
                                            -- Mirrored VICVectorCntl11
                                            -- register
        VICTrVectCntl12  : out   std_logic_vector(5 downto 0);
                                            -- Mirrored VICVectorCntl12
                                            -- register
        VICTrVectCntl13  : out   std_logic_vector(5 downto 0);
                                            -- Mirrored VICVectorCntl13
                                            -- register
        VICTrVectCntl14  : out   std_logic_vector(5 downto 0);
                                            -- Mirrored VICVectorCntl14
                                            -- register
        VICTrVectCntl15  : out   std_logic_vector(5 downto 0)
                                            -- Mirrored VICVectorCntl15
                                            -- register
       );
end VicTrAhbif;

-- ---------------------------------------------------------------------
--
--                             VicTrAhbif
--                             ==========
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--   This block interfaces the Trickbox with the AHB. It decodes AHB
-- accesses and generates the write strobes to appropriate registers.
-- This module also contains the output data multiplexer that forms the
-- read interface. Slave response signals are generated from this
-- module. This block implements both the VIC Mirrored and the
-- Trickbox specific registers.
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
--                      VIC Trickbox Register Map
-- ---------------------------------------------------------------------
-- Offset          Read (Width)           Write (Width)   Description
-- ---------------------------------------------------------------------
-- Mirrored Registers :

-- 0x00C  VICTrIntSelect          VICTrIntSelect          Mirrored VIC
--                    (32 bits)               (32 bits)   IntSelect
-- 0x010  VICTrIntEnable          VICTrIntEnable          Mirrored VIC
--                    (32 bits)               (32 bits)   IntEnable
-- 0x014  -                       VICTrIntEnClear         Mirrored VIC
--                                            (32 bits)   IntEnableClear
-- 0x018  VICTrSoftInt            VICTrSoftInt            Mirrored VIC
--                    (32 bits)               (32 bits)   SoftInt
-- 0x01C  -                       VICTrSoftIntClear       Mirrored VIC
--                                            (32 bits)   SoftIntClear
-- 0x020  VICTrProtection         VICTrProtection         Mirrored VIC
--                       (1 bit)                (1 bit)   Protection
-- 0x030  VICTrVectAddr           VICTrVectAddr           Mirrored VIC
--                    (32 bits)               (32 bits)   VectAddr
-- 0x034  VICTrDefVectAddr        VICTrDefVectAddr        Mirrored VIC
--                    (32 bits)               (32 bits)   DefVectAddr
-- 0x100- VICTrVectAddr0-15       VICTrVectAddr0-15       Mirrored VIC
-- 0x13C              (32 bits)               (32 bits)   VectAddr0-15
-- 0x200- VICTrVectCntl0-15       VICTrVectCntl0-15       Mirrored VIC
-- 0x23C               (6 bits)                (6 bits)   VectCntl0-15
-- ---------------------------------------------------------------------
-- Note :
--   A write to a VIC register will automatically update its mirrored
-- register as well. If these mirrored VIC registers are accessed using
-- the VIC Base address, the Trickbox returns zeroes on the HRDATA bus.
-- However, if these registers are accessed using the Trickbox Base
-- address (instead of the VIC Base address), their current contents are
-- reflected onto the HRDATA bus.
-- ---------------------------------------------------------------------
-- VIC Trickbox-specific Registers :

-- 0x000  VICTrTCR     (3 bits)   VICTrTCR     (3 bits)   Error Message
--                                                        Enable
-- 0x004  VICTrIntSource          VICTrIntSource          Interrupt
--                    (32 bits)               (32 bits)   Source
-- 0x008  VICTrStatus  (2 bits)   -                       FIQ and IRQ
--                                                        Status
-- 0x024  VICTrVectAddrOut        -                       VICVECTADDROUT
--                    (32 bits)                           Status
-- 0x028  VICTrIntIn   (2 bits)   VICTrIntIn   (2 bits)   nVICFIQIN and
--                                                        nVICIRQIN
--                                                        Source
-- 0x02C  VICTrVectAddrIn         VICTrVectAddrIn         VICVECTADDRIN
--                    (32 bits)               (32 bits)   Source
-- 0x038  VICTrWaitStReg          VICTrWaitStReg          An address
--                                            (32 bits)   location 
--                                                        accessible
--                                                        with Non-Zero
--                                                        wait states
--                                                        and returns
--                                                        0x55555555
--                                                        when it is
--                                                        read
-- ---------------------------------------------------------------------

-- --========================= ARCHITECTURE ==========================--

architecture behavioural of VicTrAhbif is

-- ---------------------------------------------------------------------
-- Component declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------
signal WaitCount        : integer;
-- Wait State Counter

signal NewAccess        : std_logic;
-- New Access to Trickbox or the VIC

signal BusEn            : std_logic;
-- Bus latch Enable signal

signal NxtBusEn         : std_logic;
-- D-input of BusEn

signal RdAccess         : std_logic;
-- Read Access to Trickbox

signal NxtRdAccess      : std_logic;
-- D-input of RdAccess

signal WrAccess         : std_logic;
-- Write Access to Trickbox

signal NxtWrAccess      : std_logic;
-- D-input of WrAccess

signal MrAccessEn       : std_logic;
-- Mirrored registers access enable signal

signal MrWrAccess       : std_logic;
-- Write Access to Mirrored registers

signal NxtMrWrAccess    : std_logic;
-- D-input of MrWrAccess

signal MrRdAccess       : std_logic;
-- Read Access to Mirrored registers

signal NxtMrRdAccess    : std_logic;
-- D-input of MrRdAccess

signal DeviceSel        : std_logic;
-- Latched Device Select signal

signal NxtDeviceSel     : std_logic;
-- D-input of DeviceSel

signal Addr             : std_logic_vector(11 downto 2);
-- Latched Address bus within Trickbox

signal NxtAddr          : std_logic_vector(11 downto 2);
-- D-input of Addr

signal RdData1          : std_logic_vector(31 downto 0);
-- Internal Read Data bus1

signal RdData2          : std_logic_vector(31 downto 0);
-- Internal Read Data bus2

signal RdData3          : std_logic_vector(31 downto 0);
-- Internal Read Data bus3

signal RdData           : std_logic_vector(31 downto 0);
-- Internal Read Data bus

signal IntSelectEn      : std_logic;
-- VICTrIntSelect Access Enable signal

signal IntEnableEn      : std_logic;
-- VICTrIntEnable Access Enable signal

signal IntEnClearEn     : std_logic;
-- VICTrIntEnableClear Access Enable signal

signal SoftIntEn        : std_logic;
-- VICTrSoftInt Access Enable signal

signal SoftIntClearEn   : std_logic;
-- VICTrSoftIntClear Access Enable signal

signal ProtectionEn     : std_logic;
-- VICTrProtection Access Enable signal

signal VectAddrEn       : std_logic;
-- VICTrVectAddr Access Enable signal

signal DefVectAddrEn    : std_logic;
-- VICTrDefVectAddr Access Enable signal

signal VectAddr0En      : std_logic;
-- VICTrVectAddr0 Access Enable signal

signal VectAddr1En      : std_logic;
-- VICTrVectAddr1 Access Enable signal

signal VectAddr2En      : std_logic;
-- VICTrVectAddr2 Access Enable signal

signal VectAddr3En      : std_logic;
-- VICTrVectAddr3 Access Enable signal

signal VectAddr4En      : std_logic;
-- VICTrVectAddr4 Access Enable signal

signal VectAddr5En      : std_logic;
-- VICTrVectAddr5 Access Enable signal

signal VectAddr6En      : std_logic;
-- VICTrVectAddr6 Access Enable signal

signal VectAddr7En      : std_logic;
-- VICTrVectAddr7 Access Enable signal

signal VectAddr8En      : std_logic;
-- VICTrVectAddr8 Access Enable signal

signal VectAddr9En      : std_logic;
-- VICTrVectAddr9 Access Enable signal

signal VectAddr10En     : std_logic;
-- VICTrVectAddr10 Access Enable signal

signal VectAddr11En     : std_logic;
-- VICTrVectAddr11 Access Enable signal

signal VectAddr12En     : std_logic;
-- VICTrVectAddr12 Access Enable signal

signal VectAddr13En     : std_logic;
-- VICTrVectAddr13 Access Enable signal

signal VectAddr14En     : std_logic;
-- VICTrVectAddr14 Access Enable signal

signal VectAddr15En     : std_logic;
-- VICTrVectAddr15 Access Enable signal

signal VectCntl0En      : std_logic;
-- VICTrVectCntl0 Access Enable signal

signal VectCntl1En      : std_logic;
-- VICTrVectCntl1 Access Enable signal

signal VectCntl2En      : std_logic;
-- VICTrVectCntl2 Access Enable signal

signal VectCntl3En      : std_logic;
-- VICTrVectCntl3 Access Enable signal

signal VectCntl4En      : std_logic;
-- VICTrVectCntl4 Access Enable signal

signal VectCntl5En      : std_logic;
-- VICTrVectCntl5 Access Enable signal

signal VectCntl6En      : std_logic;
-- VICTrVectCntl6 Access Enable signal

signal VectCntl7En      : std_logic;
-- VICTrVectCntl7 Access Enable signal

signal VectCntl8En      : std_logic;
-- VICTrVectCntl8 Access Enable signal

signal VectCntl9En      : std_logic;
-- VICTrVectCntl9 Access Enable signal

signal VectCntl10En     : std_logic;
-- VICTrVectCntl10 Access Enable signal

signal VectCntl11En     : std_logic;
-- VICTrVectCntl11 Access Enable signal

signal VectCntl12En     : std_logic;
-- VICTrVectCntl12 Access Enable signal

signal VectCntl13En     : std_logic;
-- VICTrVectCntl13 Access Enable signal

signal VectCntl14En     : std_logic;
-- VICTrVectCntl14 Access Enable signal

signal VectCntl15En     : std_logic;
-- VICTrVectCntl15 Access Enable signal

signal VICTrTCREn       : std_logic;
-- VICTrTCR Access Enable signal

signal TrIntSourceEn    : std_logic;
-- VICTrIntSource Access Enable signal

signal TrStatusEn       : std_logic;
-- VICTrStatus Access Enable signal

signal TrIntInEn        : std_logic;
-- VICTrIntIn Access Enable signal

signal TrVectAdInEn     : std_logic;
-- VICTrVectAddrIn Access Enable signal

signal TrVectAdOutEn    : std_logic;
-- VICVECTADDROUT Access Enable signal

signal WaitStRegEn      : std_logic;
-- VICTrWaitStReg Access Enable signal

signal IntSelectRdEn    : std_logic;
-- VICTrIntSelect Read Access Enable signal

signal IntEnableRdEn    : std_logic;
-- VICTrIntEnable Read Access Enable signal

signal SoftIntRdEn      : std_logic;
-- VICTrSoftInt Read Access Enable signal

signal ProtectionRdEn   : std_logic;
-- VICTrProtection Read Access Enable signal

signal VectAddrRdEn     : std_logic;
-- VICTrVectAddr Read Access Enable signal

signal DefVectAddrRdEn  : std_logic;
-- VICTrDefVectAddr Read Access Enable signal

signal VectAddr0RdEn    : std_logic;
-- VICTrVectAddr0 Read Access Enable signal

signal VectAddr1RdEn    : std_logic;
-- VICTrVectAddr1 Read Access Enable signal

signal VectAddr2RdEn    : std_logic;
-- VICTrVectAddr2 Read Access Enable signal

signal VectAddr3RdEn    : std_logic;
-- VICTrVectAddr3 Read Access Enable signal

signal VectAddr4RdEn    : std_logic;
-- VICTrVectAddr4 Read Access Enable signal

signal VectAddr5RdEn    : std_logic;
-- VICTrVectAddr5 Read Access Enable signal

signal VectAddr6RdEn    : std_logic;
-- VICTrVectAddr6 Read Access Enable signal

signal VectAddr7RdEn    : std_logic;
-- VICTrVectAddr7 Read Access Enable signal

signal VectAddr8RdEn    : std_logic;
-- VICTrVectAddr8 Read Access Enable signal

signal VectAddr9RdEn    : std_logic;
-- VICTrVectAddr9 Read Access Enable signal

signal VectAddr10RdEn   : std_logic;
-- VICTrVectAddr10 Read Access Enable signal

signal VectAddr11RdEn   : std_logic;
-- VICTrVectAddr11 Read Access Enable signal

signal VectAddr12RdEn   : std_logic;
-- VICTrVectAddr12 Read Access Enable signal

signal VectAddr13RdEn   : std_logic;
-- VICTrVectAddr13 Read Access Enable signal

signal VectAddr14RdEn   : std_logic;
-- VICTrVectAddr14 Read Access Enable signal

signal VectAddr15RdEn   : std_logic;
-- VICTrVectAddr15 Read Access Enable signal

signal VectCntl0RdEn    : std_logic;
-- VICTrVectCntl0 Read Access Enable signal

signal VectCntl1RdEn    : std_logic;
-- VICTrVectCntl1 Read Access Enable signal

signal VectCntl2RdEn    : std_logic;
-- VICTrVectCntl2 Read Access Enable signal

signal VectCntl3RdEn    : std_logic;
-- VICTrVectCntl3 Read Access Enable signal

signal VectCntl4RdEn    : std_logic;
-- VICTrVectCntl4 Read Access Enable signal

signal VectCntl5RdEn    : std_logic;
-- VICTrVectCntl5 Read Access Enable signal

signal VectCntl6RdEn    : std_logic;
-- VICTrVectCntl6 Read Access Enable signal

signal VectCntl7RdEn    : std_logic;
-- VICTrVectCntl7 Read Access Enable signal

signal VectCntl8RdEn    : std_logic;
-- VICTrVectCntl8 Read Access Enable signal

signal VectCntl9RdEn    : std_logic;
-- VICTrVectCntl9 Read Access Enable signal

signal VectCntl10RdEn   : std_logic;
-- VICTrVectCntl10 Read Access Enable signal

signal VectCntl11RdEn   : std_logic;
-- VICTrVectCntl11 Read Access Enable signal

signal VectCntl12RdEn   : std_logic;
-- VICTrVectCntl12 Read Access Enable signal

signal VectCntl13RdEn   : std_logic;
-- VICTrVectCntl13 Read Access Enable signal

signal VectCntl14RdEn   : std_logic;
-- VICTrVectCntl14 Read Access Enable signal

signal VectCntl15RdEn   : std_logic;
-- VICTrVectCntl15 Read Access Enable signal

signal VICTrTCRRdEn     : std_logic;
-- VICTrTCR Read Access Enable signal

signal TrIntSrcRdEn     : std_logic;
-- VICTrIntSource Read Access Enable signal

signal IntStatRdEn      : std_logic;
-- VICTrStatus Read Access Enable signal

signal TrIntInRdEn      : std_logic;
-- VICTrIntIn Read Access Enable signal

signal TrVectAdInRdEn   : std_logic;
-- VICTrVectAddrIn Read Access Enable signal

signal TrVectAdOutRdEn  : std_logic;
-- VICVICVECTADDROUT Read Access Enable signal

signal IntSelectWrEn    : std_logic;
-- VICTrIntSelect Write Access Enable signal

signal IntEnableWrEn    : std_logic;
-- VICTrIntEnable Write Access Enable signal

signal IntEnClearWrEn   : std_logic;
-- VICTrIntEnableClear Write Access Enable signal

signal SoftIntWrEn      : std_logic;
-- VICTrSoftInt Write Access Enable signal

signal SoftIntClearWrEn : std_logic;
-- VICTrSoftIntClear Write Access Enable signal

signal ProtectionWrEn   : std_logic;
-- VICTrProtection Write Access Enable signal

signal VectAddrWrEn     : std_logic;
-- VICTrVectAddr Write Access Enable signal

signal DefVectAddrWrEn  : std_logic;
-- VICTrDefVectAddr Write Access Enable signal

signal VectAddr0WrEn    : std_logic;
-- VICTrVectAddr0 Write Access Enable signal

signal VectAddr1WrEn    : std_logic;
-- VICTrVectAddr1 Write Access Enable signal

signal VectAddr2WrEn    : std_logic;
-- VICTrVectAddr2 Write Access Enable signal

signal VectAddr3WrEn    : std_logic;
-- VICTrVectAddr3 Write Access Enable signal

signal VectAddr4WrEn    : std_logic;
-- VICTrVectAddr4 Write Access Enable signal

signal VectAddr5WrEn    : std_logic;
-- VICTrVectAddr5 Write Access Enable signal

signal VectAddr6WrEn    : std_logic;
-- VICTrVectAddr6 Write Access Enable signal

signal VectAddr7WrEn    : std_logic;
-- VICTrVectAddr7 Write Access Enable signal

signal VectAddr8WrEn    : std_logic;
-- VICTrVectAddr8 Write Access Enable signal

signal VectAddr9WrEn    : std_logic;
-- VICTrVectAddr9 Write Access Enable signal

signal VectAddr10WrEn   : std_logic;
-- VICTrVectAddr10 Write Access Enable signal

signal VectAddr11WrEn   : std_logic;
-- VICTrVectAddr11 Write Access Enable signal

signal VectAddr12WrEn   : std_logic;
-- VICTrVectAddr12 Write Access Enable signal

signal VectAddr13WrEn   : std_logic;
-- VICTrVectAddr13 Write Access Enable signal

signal VectAddr14WrEn   : std_logic;
-- VICTrVectAddr14 Write Access Enable signal

signal VectAddr15WrEn   : std_logic;
-- VICTrVectAddr15 Write Access Enable signal

signal VectCntl0WrEn    : std_logic;
-- VICTrVectCntl0 Write Access Enable signal

signal VectCntl1WrEn    : std_logic;
-- VICTrVectCntl1 Write Access Enable signal

signal VectCntl2WrEn    : std_logic;
-- VICTrVectCntl2 Write Access Enable signal

signal VectCntl3WrEn    : std_logic;
-- VICTrVectCntl3 Write Access Enable signal

signal VectCntl4WrEn    : std_logic;
-- VICTrVectCntl4 Write Access Enable signal

signal VectCntl5WrEn    : std_logic;
-- VICTrVectCntl5 Write Access Enable signal

signal VectCntl6WrEn    : std_logic;
-- VICTrVectCntl6 Write Access Enable signal

signal VectCntl7WrEn    : std_logic;
-- VICTrVectCntl7 Write Access Enable signal

signal VectCntl8WrEn    : std_logic;
-- VICTrVectCntl8 Write Access Enable signal

signal VectCntl9WrEn    : std_logic;
-- VICTrVectCntl9 Write Access Enable signal

signal VectCntl10WrEn   : std_logic;
-- VICTrVectCntl10 Write Access Enable signal

signal VectCntl11WrEn   : std_logic;
-- VICTrVectCntl11 Write Access Enable signal

signal VectCntl12WrEn   : std_logic;
-- VICTrVectCntl12 Write Access Enable signal

signal VectCntl13WrEn   : std_logic;
-- VICTrVectCntl13 Write Access Enable signal

signal VectCntl14WrEn   : std_logic;
-- VICTrVectCntl14 Write Access Enable signal

signal VectCntl15WrEn   : std_logic;
-- VICTrVectCntl15 Write Access Enable signal

signal VICTrTCRWrEn     : std_logic;
-- VICTrTCR Write Access Enable signal

signal TrIntSrcWrEn     : std_logic;
-- VICTrIntSource Write Access Enable signal

signal TrIntInWrEn      : std_logic;
-- VICTrIntIn Write Access Enable signal

signal TrVectAdInWrEn   : std_logic;
-- VICTrVectAddrIn Write Access Enable signal

signal iVICTrIntSelect  : std_logic_vector(31 downto 0);
-- Internal version of IntSelect Register

signal NxtTrIntSelect   : std_logic_vector(31 downto 0);
-- D-input of VICTrIntSelect Register

signal iVICTrIntEnable  : std_logic_vector(31 downto 0);
-- Internal version of IntEnable Register

signal NxtTrIntEnable   : std_logic_vector(31 downto 0);
-- D-input of VICTrIntEnable Register

signal iVICTrSoftInt    : std_logic_vector(31 downto 0);
-- Internal version of VICTrSoftInt Register

signal NxtTrSoftInt     : std_logic_vector(31 downto 0);
-- D-input of VICTrSoftInt Register

signal VICTrProtection  : std_logic;
-- VICTrProtection Register

signal NxtTrProtection  : std_logic;
-- D-input of VICTrProtection Register

signal iVICTrDefVecAddr : std_logic_vector(31 downto 0);
-- Internal version of VICTrDefVectAddr Register

signal NxtTrDefVectAddr : std_logic_vector(31 downto 0);
-- D-input of VICTrDefVectAddr Register

signal iVICTrVectAddr0  : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectorAddr0 Register

signal NxtTrVectAddr0   : std_logic_vector(31 downto 0);
-- D-input of VICTrVectorAddr0 Register

signal iVICTrVectAddr1  : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectorAddr1 Register

signal NxtTrVectAddr1   : std_logic_vector(31 downto 0);
-- D-input of VICTrVectorAddr1 Register

signal iVICTrVectAddr2  : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectorAddr2 Register

signal NxtTrVectAddr2   : std_logic_vector(31 downto 0);
-- D-input of VICTrVectorAddr2 Register

signal iVICTrVectAddr3  : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectorAddr3 Register

signal NxtTrVectAddr3   : std_logic_vector(31 downto 0);
-- D-input of VICTrVectorAddr3 Register

signal iVICTrVectAddr4  : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectorAddr4 Register

signal NxtTrVectAddr4   : std_logic_vector(31 downto 0);
-- D-input of VICTrVectorAddr1 Register

signal iVICTrVectAddr5  : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectorAddr5 Register

signal NxtTrVectAddr5   : std_logic_vector(31 downto 0);
-- D-input of VICTrVectorAddr5 Register

signal iVICTrVectAddr6  : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectorAddr6 Register

signal NxtTrVectAddr6   : std_logic_vector(31 downto 0);
-- D-input of VICTrVectorAddr6 Register

signal iVICTrVectAddr7  : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectorAddr7 Register

signal NxtTrVectAddr7   : std_logic_vector(31 downto 0);
-- D-input of VICTrVectorAddr7 Register

signal iVICTrVectAddr8  : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectorAddr8 Register

signal NxtTrVectAddr8   : std_logic_vector(31 downto 0);
-- D-input of VICTrVectorAddr8 Register

signal iVICTrVectAddr9  : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectorAddr9 Register

signal NxtTrVectAddr9   : std_logic_vector(31 downto 0);
-- D-input of VICTrVectorAddr9 Register

signal iVICTrVectAddr10 : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectorAddr10 Register

signal NxtTrVectAddr10  : std_logic_vector(31 downto 0);
-- D-input of VICTrVectorAddr10 Register

signal iVICTrVectAddr11 : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectorAddr11 Register

signal NxtTrVectAddr11  : std_logic_vector(31 downto 0);
-- D-input of VICTrVectorAddr11 Register

signal iVICTrVectAddr12 : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectorAddr12 Register

signal NxtTrVectAddr12  : std_logic_vector(31 downto 0);
-- D-input of VICTrVectorAddr12 Register

signal iVICTrVectAddr13 : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectorAddr13 Register

signal NxtTrVectAddr13  : std_logic_vector(31 downto 0);
-- D-input of VICTrVectorAddr13 Register

signal iVICTrVectAddr14 : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectorAddr14 Register

signal NxtTrVectAddr14  : std_logic_vector(31 downto 0);
-- D-input of VICTrVectorAddr14 Register

signal iVICTrVectAddr15 : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectorAddr15 Register

signal NxtTrVectAddr15  : std_logic_vector(31 downto 0);
-- D-input of VICTrVectorAddr15 Register

signal iVICTrVectCntl0  : std_logic_vector(5 downto 0);
-- Internal version of VICTrVectorCntl0 Register

signal NxtTrVectCntl0   : std_logic_vector(5 downto 0);
-- D-input of VICTrVectorCntl0 Register

signal iVICTrVectCntl1  : std_logic_vector(5 downto 0);
-- Internal version of VICTrVectorCntl1 Register

signal NxtTrVectCntl1   : std_logic_vector(5 downto 0);
-- D-input of VICTrVectorCntl1 Register

signal iVICTrVectCntl2  : std_logic_vector(5 downto 0);
-- Internal version of VICTrVectorCntl2 Register

signal NxtTrVectCntl2   : std_logic_vector(5 downto 0);
-- D-input of VICTrVectorCntl2 Register

signal iVICTrVectCntl3  : std_logic_vector(5 downto 0);
-- Internal version of VICTrVectorCntl3 Register

signal NxtTrVectCntl3   : std_logic_vector(5 downto 0);
-- D-input of VICTrVectorCntl3 Register

signal iVICTrVectCntl4  : std_logic_vector(5 downto 0);
-- Internal version of VICTrVectorCntl4 Register

signal NxtTrVectCntl4   : std_logic_vector(5 downto 0);
-- D-input of VICTrVectorCntl4 Register

signal iVICTrVectCntl5  : std_logic_vector(5 downto 0);
-- Internal version of VICTrVectorCntl5 Register

signal NxtTrVectCntl5   : std_logic_vector(5 downto 0);
-- D-input of VICTrVectorCntl5 Register

signal iVICTrVectCntl6  : std_logic_vector(5 downto 0);
-- Internal version of VICTrVectorCntl6 Register

signal NxtTrVectCntl6   : std_logic_vector(5 downto 0);
-- D-input of VICTrVectorCntl6 Register

signal iVICTrVectCntl7  : std_logic_vector(5 downto 0);
-- Internal version of VICTrVectorCntl7 Register

signal NxtTrVectCntl7   : std_logic_vector(5 downto 0);
-- D-input of VICTrVectorCntl7 Register

signal iVICTrVectCntl8  : std_logic_vector(5 downto 0);
-- Internal version of VICTrVectorCntl8 Register

signal NxtTrVectCntl8   : std_logic_vector(5 downto 0);
-- D-input of VICTrVectorCntl8 Register

signal iVICTrVectCntl9  : std_logic_vector(5 downto 0);
-- Internal version of VICTrVectorCntl9 Register

signal NxtTrVectCntl9   : std_logic_vector(5 downto 0);
-- D-input of VICTrVectorCntl9 Register

signal iVICTrVectCntl10 : std_logic_vector(5 downto 0);
-- Internal version of VICTrVectorCntl10 Register

signal NxtTrVectCntl10  : std_logic_vector(5 downto 0);
-- D-input of VICTrVectorCntl10 Register

signal iVICTrVectCntl11 : std_logic_vector(5 downto 0);
-- Internal version of VICTrVectorCntl11 Register

signal NxtTrVectCntl11  : std_logic_vector(5 downto 0);
-- D-input of VICTrVectorCntl11 Register

signal iVICTrVectCntl12 : std_logic_vector(5 downto 0);
-- Internal version of VICTrVectorCntl12 Register

signal NxtTrVectCntl12  : std_logic_vector(5 downto 0);
-- D-input of VICTrVectorCntl12 Register

signal iVICTrVectCntl13 : std_logic_vector(5 downto 0);
-- Internal version of VICTrVectorCntl13 Register

signal NxtTrVectCntl13  : std_logic_vector(5 downto 0);
-- D-input of VICTrVectorCntl13 Register

signal iVICTrVectCntl14 : std_logic_vector(5 downto 0);
-- Internal version of VICTrVectorCntl14 Register

signal NxtTrVectCntl14  : std_logic_vector(5 downto 0);
-- D-input of VICTrVectorCntl14 Register

signal iVICTrVectCntl15 : std_logic_vector(5 downto 0);
-- Internal version of VICTrVectorCntl15 Register

signal NxtTrVectCntl15  : std_logic_vector(5 downto 0);
-- D-input of VICTrVectorCntl15 Register

signal iVICTrTCR        : std_logic_vector(2 downto 0);
-- Internal version of VICTrTCR Register

signal NxtVICTrTCR      : std_logic_vector(2 downto 0);
-- D-input of VICTrTCR Register

signal VICTrIntSource   : std_logic_vector(31 downto 0);
-- VICTrIntSource Register

signal iVICTrIntSource  : std_logic_vector(31 downto 0);
-- VICTrIntSource delayed signal

signal NxtTrIntSource   : std_logic_vector(31 downto 0);
-- D-input of VICTrIntSource Register

signal VICTrIntIn       : std_logic_vector(1 downto 0);
-- VICTrIntIn Register

signal iVICTrIntIn      : std_logic_vector(1 downto 0);
-- Delayed TrIntIn signal

signal NxtTrIntIn       : std_logic_vector(1 downto 0);
-- D-input of VICTrIntIn Register

signal VICTrVectAddrIn  : std_logic_vector(31 downto 0);
-- VICTrVectAddrIn Register

signal iVICTrVectAddrIn : std_logic_vector(31 downto 0);
-- Delayed VICTrVectAddrIn signal

signal NxtTrVectAddrIn  : std_logic_vector(31 downto 0);
-- D-input of VICTrVectAddrIn Register

signal NxtClearCSRBit   : std_logic;
-- Signal to delay the CSR bit Clearing by one clock

-- ---------------------------------------------------------------------
-- Function declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Type declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------

begin

-- ---------------------------------------------------------------------
-- Assign 'min' and 'max' delays to the VICINTSOURCE signal
-- ---------------------------------------------------------------------
p_TrVICINTSRCComb : process (HCLK, iVICTrIntSource)
begin
  if (HCLK'event and HCLK = '1') then
    iVICTrIntSource <= (others => 'X') after tovminintsrc;
  elsif (iVICTrIntSource'event) then
    iVICTrIntSource <= VICTrIntSource
                       after (tovmaxintsrc - tovminintsrc);
  end if;
end process p_TrVICINTSRCComb;

-- ---------------------------------------------------------------------
-- Assign 'min' and 'max' delays to the nVICFIQIN signal
-- ---------------------------------------------------------------------
p_TrVICFIQINComb : process (HCLK, iVICTrIntIn(0))
begin
  if (HCLK'event and HCLK = '1') then
    iVICTrIntIn(0) <= 'X' after tovminnvicfiqin;
  elsif (iVICTrIntIn(0)'event) then
    iVICTrIntIn(0) <= VICTrIntIn(0)
                      after (tovmaxnvicfiqin - tovminnvicfiqin);
  end if;
end process p_TrVICFIQINComb;

-- ---------------------------------------------------------------------
-- Assign 'min' and 'max' delays to the nVICIRQIN signal
-- ---------------------------------------------------------------------
p_TrVICIRQINComb : process (HCLK, iVICTrIntIn(1))
begin
  if (HCLK'event and HCLK = '1') then
    iVICTrIntIn(1) <= 'X' after tovminnvicirqin;
  elsif (iVICTrIntIn(1)'event) then
    iVICTrIntIn(1) <= VICTrIntIn(1)
                      after (tovmaxnvicirqin - tovminnvicirqin);
  end if;
end process p_TrVICIRQINComb;

-- ---------------------------------------------------------------------
-- Assign 'min' and 'max' delays to the VICVECTADDRIN signal
-- ---------------------------------------------------------------------
p_TrVICVECTADComb : process (HCLK, iVICTrVectAddrIn)
begin
  if (HCLK'event and HCLK = '1') then
    iVICTrVectAddrIn <= (others => 'X') after tovminvectadin;
  elsif (iVICTrVectAddrIn'event) then
    iVICTrVectAddrIn <= VICTrVectAddrIn
                        after (tovmaxvectadin - tovminvectadin);
  end if;
end process p_TrVICVECTADComb;

-- ---------------------------------------------------------------------
-- Detecting new accesses to either the VIC or the Trickbox
-- ---------------------------------------------------------------------
NewAccess        <= (HSELVICTR or HSELVIC) and HREADYIN and HTRANS;

NxtWrAccess      <= (HSELVICTR and HWRITE and HTRANS)
                    when (HREADYIN = '1')
                 else
                    WrAccess;

MrAccessEn       <= '1' when (VICTrProtection = '0')
                 else
                    HPROT;

NxtMrWrAccess    <= (HSELVIC and HWRITE and HTRANS and MrAccessEn and
                     not (HSIZE(2)) and HSIZE(1) and not (HSIZE(0)))
                     when (HREADYIN = '1')
                 else
                    MrWrAccess;

NxtMrRdAccess    <= (HSELVIC and not (HWRITE) and HTRANS and
                     MrAccessEn and not (HSIZE(2)) and HSIZE(1) and
                     not (HSIZE(0))) when (HREADYIN = '1')
                 else
                    MrRdAccess;

NxtRdAccess      <= (HSELVICTR and not (HWRITE) and HTRANS)
                    when (HREADYIN = '1')
                 else
                    RdAccess;

NxtDeviceSel     <= HSELVICTR when (HREADYIN = '1')
                 else
                    DeviceSel;

-- ---------------------------------------------------------------------
-- Sequential logic for the Access Enable signals
-- ---------------------------------------------------------------------
p_AccesstypeSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    WrAccess   <= '0';
    MrWrAccess <= '0';
    MrRdAccess <= '0';
    RdAccess   <= '0';
    DeviceSel  <= '0';
  elsif (HCLK'event and HCLK = '1') then
    WrAccess   <= NxtWrAccess;
    MrWrAccess <= NxtMrWrAccess;
    MrRdAccess <= NxtMrRdAccess;
    RdAccess   <= NxtRdAccess;
    DeviceSel  <= NxtDeviceSel;
  end if;
end process p_AccesstypeSeq;

-- ---------------------------------------------------------------------
-- Samples the address if the slave is selected
-- ---------------------------------------------------------------------
NxtAddr          <= HADDR when (NewAccess = '1')
                 else
                    Addr;

-- ---------------------------------------------------------------------
-- Sequential logic for the internal Address bus
-- ---------------------------------------------------------------------
p_AddrSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    Addr <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    Addr <= NxtAddr;
  end if;
end process p_AddrSeq;

-- ---------------------------------------------------------------------
-- Bus Latch Enable signal generation
-- ---------------------------------------------------------------------
NxtBusEn         <= '1' when (NewAccess = '1')
                 else
                    '0';

-- ---------------------------------------------------------------------
-- Sequential logic for the Bus Latch Enable
-- ---------------------------------------------------------------------
p_BusEnSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    BusEn <= '0';
  elsif (HCLK'event and HCLK = '1') then
    BusEn <= NxtBusEn;
  end if;
end process p_BusEnSeq;

-- ---------------------------------------------------------------------
-- Decode the latched Address
-- ---------------------------------------------------------------------
IntSelectEn      <= '1' when (Addr = VICTRINTSELECTADDR)
                 else
                    '0';

IntEnableEn      <= '1' when (Addr = VICTRINTENABLEADDR)
                 else
                    '0';

IntEnClearEn     <= '1' when (Addr = VICTRINTENCLEARADDR)
                 else
                    '0';

SoftIntEn        <= '1' when (Addr = VICTRSOFTINTADDR)
                 else
                    '0';

SoftIntClearEn   <= '1' when (Addr = VICTRSOFTINTCLEARADDR)
                 else
                    '0';

ProtectionEn     <= '1' when (Addr = VICTRPROTECTIONADDR)
                 else
                    '0';

VectAddrEn       <= '1' when (Addr = VICTRVECTADADDR)
                 else
                    '0';

DefVectAddrEn    <= '1' when (Addr = VICTRDEFVECTADADDR)
                 else
                    '0';

VectAddr0En      <= '1' when (Addr = VICTRVECTAD0ADDR)
                 else
                    '0';

VectAddr1En      <= '1' when (Addr = VICTRVECTAD1ADDR)
                 else
                    '0';

VectAddr2En      <= '1' when (Addr = VICTRVECTAD2ADDR)
                 else
                    '0';

VectAddr3En      <= '1' when (Addr = VICTRVECTAD3ADDR)
                 else
                    '0';

VectAddr4En      <= '1' when (Addr = VICTRVECTAD4ADDR)
                 else
                    '0';

VectAddr5En      <= '1' when (Addr = VICTRVECTAD5ADDR)
                 else
                    '0';

VectAddr6En      <= '1' when (Addr = VICTRVECTAD6ADDR)
                 else
                    '0';

VectAddr7En      <= '1' when (Addr = VICTRVECTAD7ADDR)
                 else
                    '0';

VectAddr8En      <= '1' when (Addr = VICTRVECTAD8ADDR)
                 else
                    '0';

VectAddr9En      <= '1' when (Addr = VICTRVECTAD9ADDR)
                 else
                    '0';

VectAddr10En     <= '1' when (Addr = VICTRVECTAD10ADDR)
                 else
                    '0';

VectAddr11En     <= '1' when (Addr = VICTRVECTAD11ADDR)
                 else
                    '0';

VectAddr12En     <= '1' when (Addr = VICTRVECTAD12ADDR)
                 else
                    '0';

VectAddr13En     <= '1' when (Addr = VICTRVECTAD13ADDR)
                 else
                    '0';

VectAddr14En     <= '1' when (Addr = VICTRVECTAD14ADDR)
                 else
                    '0';

VectAddr15En     <= '1' when (Addr = VICTRVECTAD15ADDR)
                 else
                    '0';

VectCntl0En      <= '1' when (Addr = VICTRVECTCNTL0ADDR)
                 else
                    '0';

VectCntl1En      <= '1' when (Addr = VICTRVECTCNTL1ADDR)
                 else
                    '0';

VectCntl2En      <= '1' when (Addr = VICTRVECTCNTL2ADDR)
                 else
                    '0';

VectCntl3En      <= '1' when (Addr = VICTRVECTCNTL3ADDR)
                 else
                    '0';

VectCntl4En      <= '1' when (Addr = VICTRVECTCNTL4ADDR)
                 else
                    '0';

VectCntl5En      <= '1' when (Addr = VICTRVECTCNTL5ADDR)
                 else
                    '0';

VectCntl6En      <= '1' when (Addr = VICTRVECTCNTL6ADDR)
                 else
                    '0';

VectCntl7En      <= '1' when (Addr = VICTRVECTCNTL7ADDR)
                 else
                    '0';

VectCntl8En      <= '1' when (Addr = VICTRVECTCNTL8ADDR)
                 else
                    '0';

VectCntl9En      <= '1' when (Addr = VICTRVECTCNTL9ADDR)
                 else
                    '0';

VectCntl10En     <= '1' when (Addr = VICTRVECTCNTL10ADDR)
                 else
                    '0';

VectCntl11En     <= '1' when (Addr = VICTRVECTCNTL11ADDR)
                 else
                    '0';

VectCntl12En     <= '1' when (Addr = VICTRVECTCNTL12ADDR)
                 else
                    '0';

VectCntl13En     <= '1' when (Addr = VICTRVECTCNTL13ADDR)
                 else
                    '0';

VectCntl14En     <= '1' when (Addr = VICTRVECTCNTL14ADDR)
                 else
                    '0';

VectCntl15En     <= '1' when (Addr = VICTRVECTCNTL15ADDR)
                 else
                    '0';

VICTrTCREn       <= '1' when (Addr = VICTRTCRADDR)
                 else
                    '0';

TrIntSourceEn    <= '1' when (Addr = VICTRINTSOURCEADDR)
                 else
                    '0';

TrStatusEn       <= '1' when (Addr = VICTRINTSTATUSADDR)
                 else
                    '0';

TrIntInEn        <= '1' when (Addr = VICTRINTINADDR)
                 else
                    '0';

TrVectAdInEn     <= '1' when (Addr = VICTRVECTADINADDR)
                 else
                    '0';

TrVectAdOutEn    <= '1' when (Addr = VICTRVECTADOUTADDR)
                 else
                    '0';

WaitStRegEn      <= '1' when (Addr = VICTRWAITACCESSADDR)
                 else
                    '0';

-- ---------------------------------------------------------------------
-- Generates Read Access Enable Signals
-- ---------------------------------------------------------------------
IntSelectRdEn    <= IntSelectEn and RdAccess;

IntEnableRdEn    <= IntEnableEn and RdAccess;

SoftIntRdEn      <= SoftIntEn and RdAccess;

ProtectionRdEn   <= ProtectionEn and RdAccess;

VectAddrRdEn     <= VectAddrEn and RdAccess;

DefVectAddrRdEn  <= DefVectAddrEn and RdAccess;

VectAddr0RdEn    <= VectAddr0En and RdAccess;

VectAddr1RdEn    <= VectAddr1En and RdAccess;

VectAddr2RdEn    <= VectAddr2En and RdAccess;

VectAddr3RdEn    <= VectAddr3En and RdAccess;

VectAddr4RdEn    <= VectAddr4En and RdAccess;

VectAddr5RdEn    <= VectAddr5En and RdAccess;

VectAddr6RdEn    <= VectAddr6En and RdAccess;

VectAddr7RdEn    <= VectAddr7En and RdAccess;

VectAddr8RdEn    <= VectAddr8En and RdAccess;

VectAddr9RdEn    <= VectAddr9En and RdAccess;

VectAddr10RdEn   <= VectAddr10En and RdAccess;

VectAddr11RdEn   <= VectAddr11En and RdAccess;

VectAddr12RdEn   <= VectAddr12En and RdAccess;

VectAddr13RdEn   <= VectAddr13En and RdAccess;

VectAddr14RdEn   <= VectAddr14En and RdAccess;

VectAddr15RdEn   <= VectAddr15En and RdAccess;

VectCntl0RdEn    <= VectCntl0En and RdAccess;

VectCntl1RdEn    <= VectCntl1En and RdAccess;

VectCntl2RdEn    <= VectCntl2En and RdAccess;

VectCntl3RdEn    <= VectCntl3En and RdAccess;

VectCntl4RdEn    <= VectCntl4En and RdAccess;

VectCntl5RdEn    <= VectCntl5En and RdAccess;

VectCntl6RdEn    <= VectCntl6En and RdAccess;

VectCntl7RdEn    <= VectCntl7En and RdAccess;

VectCntl8RdEn    <= VectCntl8En and RdAccess;

VectCntl9RdEn    <= VectCntl9En and RdAccess;

VectCntl10RdEn   <= VectCntl10En and RdAccess;

VectCntl11RdEn   <= VectCntl11En and RdAccess;

VectCntl12RdEn   <= VectCntl12En and RdAccess;

VectCntl13RdEn   <= VectCntl13En and RdAccess;

VectCntl14RdEn   <= VectCntl14En and RdAccess;

VectCntl15RdEn   <= VectCntl15En and RdAccess;

VICTrTCRRdEn     <= VICTrTCREn and RdAccess;

TrIntSrcRdEn     <= TrIntSourceEn and RdAccess;

IntStatRdEn      <= TrStatusEn and RdAccess;

TrIntInRdEn      <= TrIntInEn and RdAccess;

TrVectAdInRdEn   <= TrVectAdInEn and RdAccess;

TrVectAdOutRdEn  <= TrVectAdOutEn and RdAccess;

-- ---------------------------------------------------------------------
-- Genarates Write Access Enable Signals
-- ---------------------------------------------------------------------
IntSelectWrEn    <= IntSelectEn and MrWrAccess;

IntEnableWrEn    <= IntEnableEn and MrWrAccess;

IntEnClearWrEn   <= IntEnClearEn and MrWrAccess;

SoftIntWrEn      <= SoftIntEn and MrWrAccess;

SoftIntClearWrEn <= SoftIntClearEn and MrWrAccess;

ProtectionWrEn   <= ProtectionEn and MrWrAccess;

VectAddrWrEn     <= VectAddrEn and MrWrAccess;

DefVectAddrWrEn  <= DefVectAddrEn and MrWrAccess;

VectAddr0WrEn    <= VectAddr0En and MrWrAccess;

VectAddr1WrEn    <= VectAddr1En and MrWrAccess;

VectAddr2WrEn    <= VectAddr2En and MrWrAccess;

VectAddr3WrEn    <= VectAddr3En and MrWrAccess;

VectAddr4WrEn    <= VectAddr4En and MrWrAccess;

VectAddr5WrEn    <= VectAddr5En and MrWrAccess;

VectAddr6WrEn    <= VectAddr6En and MrWrAccess;

VectAddr7WrEn    <= VectAddr7En and MrWrAccess;

VectAddr8WrEn    <= VectAddr8En and MrWrAccess;

VectAddr9WrEn    <= VectAddr9En and MrWrAccess;

VectAddr10WrEn   <= VectAddr10En and MrWrAccess;

VectAddr11WrEn   <= VectAddr11En and MrWrAccess;

VectAddr12WrEn   <= VectAddr12En and MrWrAccess;

VectAddr13WrEn   <= VectAddr13En and MrWrAccess;

VectAddr14WrEn   <= VectAddr14En and MrWrAccess;

VectAddr15WrEn   <= VectAddr15En and MrWrAccess;

VectCntl0WrEn    <= VectCntl0En and MrWrAccess;

VectCntl1WrEn    <= VectCntl1En and MrWrAccess;

VectCntl2WrEn    <= VectCntl2En and MrWrAccess;

VectCntl3WrEn    <= VectCntl3En and MrWrAccess;

VectCntl4WrEn    <= VectCntl4En and MrWrAccess;

VectCntl5WrEn    <= VectCntl5En and MrWrAccess;

VectCntl6WrEn    <= VectCntl6En and MrWrAccess;

VectCntl7WrEn    <= VectCntl7En and MrWrAccess;

VectCntl8WrEn    <= VectCntl8En and MrWrAccess;

VectCntl9WrEn    <= VectCntl9En and MrWrAccess;

VectCntl10WrEn   <= VectCntl10En and MrWrAccess;

VectCntl11WrEn   <= VectCntl11En and MrWrAccess;

VectCntl12WrEn   <= VectCntl12En and MrWrAccess;

VectCntl13WrEn   <= VectCntl13En and MrWrAccess;

VectCntl14WrEn   <= VectCntl14En and MrWrAccess;

VectCntl15WrEn   <= VectCntl15En and MrWrAccess;

VICTrTCRWrEn     <= VICTrTCREn and WrAccess;

TrIntSrcWrEn     <= TrIntSourceEn and WrAccess;

TrIntInWrEn      <= TrIntInEn and WrAccess;

TrVectAdInWrEn   <= TrVectAdInEn and WrAccess;

-- ---------------------------------------------------------------------
-- Generates control signals to set/clear the Current Service Register
-- ---------------------------------------------------------------------
SetCSRBit        <= VectAddrEn and MrRdAccess;

NxtClearCSRBit   <= VectAddrWrEn;

-- ---------------------------------------------------------------------
-- Combinational logic for all writeable registers.
--
-- When the respective write enable input is asserted, copy the contents
-- of the HWDATA bus into the corresponding registers.
-- ---------------------------------------------------------------------
NxtTrIntSelect   <= HWDATA when (IntSelectWrEn = '1')
                 else
                    iVICTrIntSelect;

NxtTrIntEnable   <= (HWDATA or iVICTrIntEnable) when
                    (IntEnableWrEn = '1')
                 else
                    (not(HWDATA) and iVICTrIntEnable) when
                    (IntEnClearWrEn = '1')
                 else
                    iVICTrIntEnable;

NxtTrSoftInt     <= (HWDATA or iVICTrSoftInt) when (SoftIntWrEn = '1')
                 else
                    (not(HWDATA) and iVICTrSoftInt) when
                                               (SoftIntClearWrEn = '1')
                 else
                    iVICTrSoftInt;

NxtTrProtection  <= HWDATA(0) when (ProtectionWrEn = '1')
                 else
                    VICTrProtection;

NxtTrDefVectAddr <= HWDATA when (DefVectAddrWrEn = '1')
                 else
                    iVICTrDefVecAddr;

NxtTrVectAddr0   <= HWDATA when (VectAddr0WrEn = '1')
                 else
                    iVICTrVectAddr0;

NxtTrVectAddr1   <= HWDATA when (VectAddr1WrEn = '1')
                 else
                    iVICTrVectAddr1;

NxtTrVectAddr2   <= HWDATA when (VectAddr2WrEn = '1')
                 else
                    iVICTrVectAddr2;

NxtTrVectAddr3   <= HWDATA when (VectAddr3WrEn = '1')
                 else
                    iVICTrVectAddr3;

NxtTrVectAddr4   <= HWDATA when (VectAddr4WrEn = '1')
                 else
                    iVICTrVectAddr4;

NxtTrVectAddr5   <= HWDATA when (VectAddr5WrEn = '1')
                 else
                    iVICTrVectAddr5;

NxtTrVectAddr6   <= HWDATA when (VectAddr6WrEn = '1')
                 else
                    iVICTrVectAddr6;

NxtTrVectAddr7   <= HWDATA when (VectAddr7WrEn = '1')
                 else
                    iVICTrVectAddr7;

NxtTrVectAddr8   <= HWDATA when (VectAddr8WrEn = '1')
                 else
                    iVICTrVectAddr8;

NxtTrVectAddr9   <= HWDATA when (VectAddr9WrEn = '1')
                 else
                    iVICTrVectAddr9;

NxtTrVectAddr10  <= HWDATA when (VectAddr10WrEn = '1')
                 else
                    iVICTrVectAddr10;

NxtTrVectAddr11  <= HWDATA when (VectAddr11WrEn = '1')
                 else
                    iVICTrVectAddr11;

NxtTrVectAddr12  <= HWDATA when (VectAddr12WrEn = '1')
                 else
                    iVICTrVectAddr12;

NxtTrVectAddr13  <= HWDATA when (VectAddr13WrEn = '1')
                 else
                    iVICTrVectAddr13;

NxtTrVectAddr14  <= HWDATA when (VectAddr14WrEn = '1')
                 else
                    iVICTrVectAddr14;

NxtTrVectAddr15  <= HWDATA when (VectAddr15WrEn = '1')
                 else
                    iVICTrVectAddr15;

NxtTrVectCntl0   <= HWDATA(5 downto 0) when (VectCntl0WrEn = '1')
                 else
                    iVICTrVectCntl0;

NxtTrVectCntl1   <= HWDATA(5 downto 0) when (VectCntl1WrEn = '1')
                 else
                    iVICTrVectCntl1;

NxtTrVectCntl2   <= HWDATA(5 downto 0) when (VectCntl2WrEn = '1')
                 else
                    iVICTrVectCntl2;

NxtTrVectCntl3   <= HWDATA(5 downto 0) when (VectCntl3WrEn = '1')
                 else
                    iVICTrVectCntl3;

NxtTrVectCntl4   <= HWDATA(5 downto 0) when (VectCntl4WrEn = '1')
                 else
                    iVICTrVectCntl4;

NxtTrVectCntl5   <= HWDATA(5 downto 0) when (VectCntl5WrEn = '1')
                 else
                    iVICTrVectCntl5;

NxtTrVectCntl6   <= HWDATA(5 downto 0) when (VectCntl6WrEn = '1')
                 else
                    iVICTrVectCntl6;

NxtTrVectCntl7   <= HWDATA(5 downto 0) when (VectCntl7WrEn = '1')
                 else
                    iVICTrVectCntl7;

NxtTrVectCntl8   <= HWDATA(5 downto 0) when (VectCntl8WrEn = '1')
                 else
                    iVICTrVectCntl8;

NxtTrVectCntl9   <= HWDATA(5 downto 0) when (VectCntl9WrEn = '1')
                 else
                    iVICTrVectCntl9;

NxtTrVectCntl10  <= HWDATA(5 downto 0) when (VectCntl10WrEn = '1')
                 else
                    iVICTrVectCntl10;

NxtTrVectCntl11  <= HWDATA(5 downto 0) when (VectCntl11WrEn = '1')
                 else
                    iVICTrVectCntl11;

NxtTrVectCntl12  <= HWDATA(5 downto 0) when (VectCntl12WrEn = '1')
                 else
                    iVICTrVectCntl12;

NxtTrVectCntl13  <= HWDATA(5 downto 0) when (VectCntl13WrEn = '1')
                 else
                    iVICTrVectCntl13;

NxtTrVectCntl14  <= HWDATA(5 downto 0) when (VectCntl14WrEn = '1')
                 else
                    iVICTrVectCntl14;

NxtTrVectCntl15  <= HWDATA(5 downto 0) when (VectCntl15WrEn = '1')
                 else
                    iVICTrVectCntl15;

NxtVICTrTCR      <= HWDATA(2 downto 0) when (VICTrTCRWrEn = '1')
                 else
                    iVICTrTCR;

NxtTrIntSource   <= HWDATA when (TrIntSrcWrEn = '1')
                 else
                    VICTrIntSource;

NxtTrIntIn       <= HWDATA(1 downto 0) when (TrIntInWrEn = '1')
                 else
                    VICTrIntIn;

NxtTrVectAddrIn  <= HWDATA when (TrVectAdInWrEn = '1')
                 else
                    VICTrVectAddrIn;

-- ---------------------------------------------------------------------
-- Sequential logic for VICTrIntSelect, VICTrIntEnable, VICTrSoftInt,
-- VICTrProtection and VICTrDefVectAddr
-- ---------------------------------------------------------------------
p_TrIntRegSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    iVICTrIntSelect  <= (others => '0');
    iVICTrIntEnable  <= (others => '0');
    iVICTrSoftInt    <= (others => '0');
    VICTrProtection  <= '0';
    iVICTrDefVecAddr <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    iVICTrIntSelect  <= NxtTrIntSelect;
    iVICTrIntEnable  <= NxtTrIntEnable;
    iVICTrSoftInt    <= NxtTrSoftInt;
    VICTrProtection  <= NxtTrProtection;
    iVICTrDefVecAddr <= NxtTrDefVectAddr;
  end if;
end process p_TrIntRegSeq;

-- ---------------------------------------------------------------------
-- Sequential logic for the VICrVectAddr registers
-- ---------------------------------------------------------------------
p_TrVectAddrSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    iVICTrVectAddr0  <= (others => '0');
    iVICTrVectAddr1  <= (others => '0');
    iVICTrVectAddr2  <= (others => '0');
    iVICTrVectAddr3  <= (others => '0');
    iVICTrVectAddr4  <= (others => '0');
    iVICTrVectAddr5  <= (others => '0');
    iVICTrVectAddr6  <= (others => '0');
    iVICTrVectAddr7  <= (others => '0');
    iVICTrVectAddr8  <= (others => '0');
    iVICTrVectAddr9  <= (others => '0');
    iVICTrVectAddr10 <= (others => '0');
    iVICTrVectAddr11 <= (others => '0');
    iVICTrVectAddr12 <= (others => '0');
    iVICTrVectAddr13 <= (others => '0');
    iVICTrVectAddr14 <= (others => '0');
    iVICTrVectAddr15 <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    iVICTrVectAddr0  <= NxtTrVectAddr0;
    iVICTrVectAddr1  <= NxtTrVectAddr1;
    iVICTrVectAddr2  <= NxtTrVectAddr2;
    iVICTrVectAddr3  <= NxtTrVectAddr3;
    iVICTrVectAddr4  <= NxtTrVectAddr4;
    iVICTrVectAddr5  <= NxtTrVectAddr5;
    iVICTrVectAddr6  <= NxtTrVectAddr6;
    iVICTrVectAddr7  <= NxtTrVectAddr7;
    iVICTrVectAddr8  <= NxtTrVectAddr8;
    iVICTrVectAddr9  <= NxtTrVectAddr9;
    iVICTrVectAddr10 <= NxtTrVectAddr10;
    iVICTrVectAddr11 <= NxtTrVectAddr11;
    iVICTrVectAddr12 <= NxtTrVectAddr12;
    iVICTrVectAddr13 <= NxtTrVectAddr13;
    iVICTrVectAddr14 <= NxtTrVectAddr14;
    iVICTrVectAddr15 <= NxtTrVectAddr15;
  end if;
end process p_TrVectAddrSeq;

-- ---------------------------------------------------------------------
-- Sequential logic for the VICTrVectCntl registers
-- ---------------------------------------------------------------------
p_TrVectCntlSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    iVICTrVectCntl0  <= (others => '0');
    iVICTrVectCntl1  <= (others => '0');
    iVICTrVectCntl2  <= (others => '0');
    iVICTrVectCntl3  <= (others => '0');
    iVICTrVectCntl4  <= (others => '0');
    iVICTrVectCntl5  <= (others => '0');
    iVICTrVectCntl6  <= (others => '0');
    iVICTrVectCntl7  <= (others => '0');
    iVICTrVectCntl8  <= (others => '0');
    iVICTrVectCntl9  <= (others => '0');
    iVICTrVectCntl10 <= (others => '0');
    iVICTrVectCntl11 <= (others => '0');
    iVICTrVectCntl12 <= (others => '0');
    iVICTrVectCntl13 <= (others => '0');
    iVICTrVectCntl14 <= (others => '0');
    iVICTrVectCntl15 <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    iVICTrVectCntl0  <= NxtTrVectCntl0;
    iVICTrVectCntl1  <= NxtTrVectCntl1;
    iVICTrVectCntl2  <= NxtTrVectCntl2;
    iVICTrVectCntl3  <= NxtTrVectCntl3;
    iVICTrVectCntl4  <= NxtTrVectCntl4;
    iVICTrVectCntl5  <= NxtTrVectCntl5;
    iVICTrVectCntl6  <= NxtTrVectCntl6;
    iVICTrVectCntl7  <= NxtTrVectCntl7;
    iVICTrVectCntl8  <= NxtTrVectCntl8;
    iVICTrVectCntl9  <= NxtTrVectCntl9;
    iVICTrVectCntl10 <= NxtTrVectCntl10;
    iVICTrVectCntl11 <= NxtTrVectCntl11;
    iVICTrVectCntl12 <= NxtTrVectCntl12;
    iVICTrVectCntl13 <= NxtTrVectCntl13;
    iVICTrVectCntl14 <= NxtTrVectCntl14;
    iVICTrVectCntl15 <= NxtTrVectCntl15;
  end if;
end process p_TrVectCntlSeq;

-- ---------------------------------------------------------------------
-- Sequential logic for VICTrTCR, VICTrIntSource, VICTrIntIn and
-- VICTrVectAddrIn
-- ---------------------------------------------------------------------
p_TrRegSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    iVICTrTCR       <= (others => '0');
    VICTrIntSource  <= (others => '0');
    VICTrIntIn      <= (others => '1');
    VICTrVectAddrIn <= (others => '0');
    ClearCSRBit     <= '0';
  elsif (HCLK'event and HCLK = '1') then
    iVICTrTCR       <= NxtVICTrTCR;
    VICTrIntSource  <= NxtTrIntSource;
    VICTrIntIn      <= NxtTrIntIn;
    VICTrVectAddrIn <= NxtTrVectAddrIn;
    ClearCSRBit     <= NxtClearCSRBit;
  end if;
end process p_TrRegSeq;

-- ---------------------------------------------------------------------
-- Multiplexing RdData1 bus
-- ---------------------------------------------------------------------
RdData1          <= iVICTrIntSelect when (IntSelectRdEn = '1')
                 else
                    iVICTrIntEnable when (IntEnableRdEn = '1')
                 else
                    iVICTrSoftInt when (SoftIntRdEn = '1')
                 else
                    VICTrVectAddr when (VectAddrRdEn = '1')
                 else
                    iVICTrDefVecAddr when (DefVectAddrRdEn = '1')
                 else
                    ZEROFILL(31 downto 3) & iVICTrTCR when
                                        (VICTrTCRRdEn = '1')
                 else
                    iVICTrIntSource when (TrIntSrcRdEn = '1')
                 else
                    ZEROFILL(31 downto 2) & nVICFIQ & nVICIRQ when
                                        (IntStatRdEn = '1')
                 else
                    ZEROFILL(31 downto 2) & iVICTrIntIn when
                                        (TrIntInRdEn = '1')
                 else
                    iVICTrVectAddrIn when (TrVectAdInRdEn = '1')
                 else
                    VICVECTADDROUT when (TrVectAdOutRdEn = '1')
                 else
                    Data5 when (WaitCount = WAITSTATES)
                 else
                    (others => '0');

-- ---------------------------------------------------------------------
-- Multiplexing RdData2 bus
-- ---------------------------------------------------------------------
RdData2          <= iVICTrVectAddr0 when (VectAddr0RdEn = '1')
                 else
                    iVICTrVectAddr1 when (VectAddr1RdEn = '1')
                 else
                    iVICTrVectAddr2 when (VectAddr2RdEn = '1')
                 else
                    iVICTrVectAddr3 when (VectAddr3RdEn = '1')
                 else
                    iVICTrVectAddr4 when (VectAddr4RdEn = '1')
                 else
                    iVICTrVectAddr5 when (VectAddr5RdEn = '1')
                 else
                    iVICTrVectAddr6 when (VectAddr6RdEn = '1')
                 else
                    iVICTrVectAddr7 when (VectAddr7RdEn = '1')
                 else
                    iVICTrVectAddr8 when (VectAddr8RdEn = '1')
                 else
                    iVICTrVectAddr9 when (VectAddr9RdEn = '1')
                 else
                    iVICTrVectAddr10 when (VectAddr10RdEn = '1')
                 else
                    iVICTrVectAddr11 when (VectAddr11RdEn = '1')
                 else
                    iVICTrVectAddr12 when (VectAddr12RdEn = '1')
                 else
                    iVICTrVectAddr13 when (VectAddr13RdEn = '1')
                 else
                    iVICTrVectAddr14 when (VectAddr14RdEn = '1')
                 else
                    iVICTrVectAddr15 when (VectAddr15RdEn = '1')
                 else
                    (others => '0');

-- ---------------------------------------------------------------------
-- Multiplexing RdData3 bus
-- ---------------------------------------------------------------------
RdData3          <= ZEROFILL(31 downto 6) & iVICTrVectCntl0 when
                                          (VectCntl0RdEn = '1')
                 else
                    ZEROFILL(31 downto 6) & iVICTrVectCntl1 when
                                          (VectCntl1RdEn = '1')
                 else
                    ZEROFILL(31 downto 6) & iVICTrVectCntl2 when
                                          (VectCntl2RdEn = '1')
                 else
                    ZEROFILL(31 downto 6) & iVICTrVectCntl3 when
                                          (VectCntl3RdEn = '1')
                 else
                    ZEROFILL(31 downto 6) & iVICTrVectCntl4 when
                                          (VectCntl4RdEn = '1')
                 else
                    ZEROFILL(31 downto 6) & iVICTrVectCntl5 when
                                          (VectCntl5RdEn = '1')
                 else
                    ZEROFILL(31 downto 6) & iVICTrVectCntl6 when
                                          (VectCntl6RdEn = '1')
                 else
                    ZEROFILL(31 downto 6) & iVICTrVectCntl7 when
                                          (VectCntl7RdEn = '1')
                 else
                    ZEROFILL(31 downto 6) & iVICTrVectCntl8 when
                                          (VectCntl8RdEn = '1')
                 else
                    ZEROFILL(31 downto 6) & iVICTrVectCntl9 when
                                          (VectCntl9RdEn = '1')
                 else
                    ZEROFILL(31 downto 6) & iVICTrVectCntl10 when
                                          (VectCntl10RdEn = '1')
                 else
                    ZEROFILL(31 downto 6) & iVICTrVectCntl11 when
                                          (VectCntl11RdEn = '1')
                 else
                    ZEROFILL(31 downto 6) & iVICTrVectCntl12 when
                                          (VectCntl12RdEn = '1')
                 else
                    ZEROFILL(31 downto 6) & iVICTrVectCntl13 when
                                          (VectCntl13RdEn = '1')
                 else
                    ZEROFILL(31 downto 6) & iVICTrVectCntl14 when
                                          (VectCntl14RdEn = '1')
                 else
                    ZEROFILL(31 downto 6) & iVICTrVectCntl15 when
                                          (VectCntl15RdEn = '1')
                 else
                    (others => '0');

-- ---------------------------------------------------------------------
-- Assigning Internal Read Data bus
-- ---------------------------------------------------------------------
RdData           <= (RdData1 or RdData2 or RdData3);

-- ---------------------------------------------------------------------
-- Inserting Wait States
-- ---------------------------------------------------------------------
p_WaitStatesSeq : process (HRESETn, HCLK)
begin
  if (HRESETn = '0') then
    WaitCount <= 0;
  elsif (HCLK'event and HCLK = '1') then
    if (DeviceSel = '1') then
      if (WaitStRegEn = '1' or WaitCount /= 0) then
        if (WaitCount < WAITSTATES) then
          WaitCount <= WaitCount + 1;
        else
          WaitCount <= 0;
        end if;
      else
        WaitCount <= 0;
      end if;
    else
      WaitCount <= 0;
    end if;
  end if;
end process p_WaitStatesSeq;

-- ---------------------------------------------------------------------
-- HREADYOUT Generation
-- ---------------------------------------------------------------------
p_HREADYComb : process (HRESETn, DeviceSel, WaitStRegEn, WaitCount)
begin
  if (HRESETn = '0') then
    HREADYOUT <= TR_H_READY;
  elsif (DeviceSel = '1') then
    if (WaitStRegEn = '1') then
      if (WaitCount = WAITSTATES) then
        HREADYOUT <= TR_H_READY;
      else
        HREADYOUT <= TR_H_WAIT;
      end if;
    else
      HREADYOUT <= TR_H_READY;
    end if;
  else
    HREADYOUT <= TR_H_READY;
  end if;
end process p_HREADYComb;

-- ---------------------------------------------------------------------
-- AHB Output Assignments
-- ---------------------------------------------------------------------
HRDATA           <= RdData when (RdAccess = '1')
                 else
                    (others => '0');

HRESP            <= TR_H_OKAY;

-- ---------------------------------------------------------------------
-- Assign local copies of signals to the outputs
-- ---------------------------------------------------------------------
VICTrTCR         <= iVICTrTCR;
VICINTSOURCE     <= iVICTrIntSource;
VICVECTADDRIN    <= iVICTrVectAddrIn;
nVICFIQIN        <= iVICTrIntIn(0);
nVICIRQIN        <= iVICTrIntIn(1);
VICTrSoftInt     <= iVICTrSoftInt;
VICTrIntEnable   <= iVICTrIntEnable;
VICTrIntSelect   <= iVICTrIntSelect;
VICTrDefVectAddr <= iVICTrDefVecAddr;
VICTrVectAddr0   <= iVICTrVectAddr0;
VICTrVectAddr1   <= iVICTrVectAddr1;
VICTrVectAddr2   <= iVICTrVectAddr2;
VICTrVectAddr3   <= iVICTrVectAddr3;
VICTrVectAddr4   <= iVICTrVectAddr4;
VICTrVectAddr5   <= iVICTrVectAddr5;
VICTrVectAddr6   <= iVICTrVectAddr6;
VICTrVectAddr7   <= iVICTrVectAddr7;
VICTrVectAddr8   <= iVICTrVectAddr8;
VICTrVectAddr9   <= iVICTrVectAddr9;
VICTrVectAddr10  <= iVICTrVectAddr10;
VICTrVectAddr11  <= iVICTrVectAddr11;
VICTrVectAddr12  <= iVICTrVectAddr12;
VICTrVectAddr13  <= iVICTrVectAddr13;
VICTrVectAddr14  <= iVICTrVectAddr14;
VICTrVectAddr15  <= iVICTrVectAddr15;
VICTrVectCntl0   <= iVICTrVectCntl0;
VICTrVectCntl1   <= iVICTrVectCntl1;
VICTrVectCntl2   <= iVICTrVectCntl2;
VICTrVectCntl3   <= iVICTrVectCntl3;
VICTrVectCntl4   <= iVICTrVectCntl4;
VICTrVectCntl5   <= iVICTrVectCntl5;
VICTrVectCntl6   <= iVICTrVectCntl6;
VICTrVectCntl7   <= iVICTrVectCntl7;
VICTrVectCntl8   <= iVICTrVectCntl8;
VICTrVectCntl9   <= iVICTrVectCntl9;
VICTrVectCntl10  <= iVICTrVectCntl10;
VICTrVectCntl11  <= iVICTrVectCntl11;
VICTrVectCntl12  <= iVICTrVectCntl12;
VICTrVectCntl13  <= iVICTrVectCntl13;
VICTrVectCntl14  <= iVICTrVectCntl14;
VICTrVectCntl15  <= iVICTrVectCntl15;

end behavioural;

-- --============================== End ==============================--
