-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : VicTrAhbif.vhd.rca
-- File Revision          : 1.6
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This module implements the AHB Interface and Register
--           block.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use work.VicTrPackage.all;

-- -----------------------------------------------------------------------------

entity VicTrAhbif is
  generic (
           tovmaxintsrc     : time;
           tovmaxnvicfiqin  : time;
           tovmaxnvicirqin  : time;
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
        VICVECTADDRV     : in    std_logic; -- Vector Address Valid signal from 
                                            -- VIC

-- Outputs
        HRDATA           : out   std_logic_vector(31 downto 0);
                                            -- Read Data output from AHB
                                            -- Slave
        HREADYOUT        : out   std_logic; -- Ready Signal from
                                            -- AHB Slave
        HRESP            : out   std_logic_vector(1 downto 0);
                                            -- Transfer Response from
                                            -- AHB Slave
        VICTrTCR         : out   std_logic_vector(8 downto 0);
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
        VICIRQINREG      : out   std_logic; -- VICIRQINREG Daisy chain signal 
                                            -- signal to the VIC
        VICFIQINREG      : out   std_logic; -- VICFIQINREG Daisy chain signal 
                                            -- signal to the VIC
        nVICSYNCEN       : out   std_logic; -- nVICSYNCEN Sync Enable signal 
                                            -- signal to the VIC
        VICTrSoftInt     : out   std_logic_vector(31 downto 0);
                                            -- Mirrored VICSoftInt
                                            -- register
        VICTrIntEnable   : out   std_logic_vector(31 downto 0);
                                            -- Mirrored VICIntEnable
                                            -- register
        VICTrIntSelect   : out   std_logic_vector(31 downto 0);
                                            -- Mirrored Interrupt Select 
                                            -- register 
        VICTrSwPriMask   : out   std_logic_vector(15 downto 0);
                                            -- Mirrored software priority mask 
                                            -- register 
        VICTrVectPriDsy  : out   std_logic_vector(3 downto 0);
                                            -- Mirrored Programmed priority 
                                            -- Daisy Chain register 
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
        VICTrVectAddr16  : out   std_logic_vector(31 downto 0);
                                           -- Mirrored VICVectorAddr16
                                           -- register
        VICTrVectAddr17  : out   std_logic_vector(31 downto 0);
                                           -- Mirrored VICVectorAddr17
                                           -- register
        VICTrVectAddr18  : out   std_logic_vector(31 downto 0);
                                           -- Mirrored VICVectorAddr18
                                           -- register
        VICTrVectAddr19  : out   std_logic_vector(31 downto 0);
                                           -- Mirrored VICVectorAddr19
                                           -- register
        VICTrVectAddr20  : out   std_logic_vector(31 downto 0);
                                            -- Mirrored VICVectorAddr20
                                            -- register
        VICTrVectAddr21  : out   std_logic_vector(31 downto 0);
                                            -- Mirrored VICVectorAddr21
                                            -- register
        VICTrVectAddr22  : out   std_logic_vector(31 downto 0);
                                            -- Mirrored VICVectorAddr22
                                            -- register
        VICTrVectAddr23  : out   std_logic_vector(31 downto 0);
                                            -- Mirrored VICVectorAddr23
                                            -- register
        VICTrVectAddr24  : out   std_logic_vector(31 downto 0);
                                            -- Mirrored VICVectorAddr24
                                            -- register
        VICTrVectAddr25  : out   std_logic_vector(31 downto 0);
                                            -- Mirrored VICVectorAddr25
                                            -- register
        VICTrVectAddr26  : out   std_logic_vector(31 downto 0);
                                           -- Mirrored VICVectorAddr26
                                           -- register
        VICTrVectAddr27  : out   std_logic_vector(31 downto 0);
                                           -- Mirrored VICVectorAddr27
                                           -- register
        VICTrVectAddr28  : out   std_logic_vector(31 downto 0);
                                           -- Mirrored VICVectorAddr28
                                           -- register
        VICTrVectAddr29  : out   std_logic_vector(31 downto 0);
                                           -- Mirrored VICVectorAddr29
                                           -- register
        VICTrVectAddr30  : out   std_logic_vector(31 downto 0);
                                            -- Mirrored VICVectorAddr30
                                            -- register
        VICTrVectAddr31  : out   std_logic_vector(31 downto 0);
                                            -- Mirrored VICVectorAddr31
                                            -- register
        VICTrVectPrity0  : out   std_logic_vector(3 downto 0);
                                           -- Mirrored VICTrVectPrity0
                                           -- register
        VICTrVectPrity1  : out   std_logic_vector(3 downto 0);
                                           -- Mirrored VICTrVectPrity1
                                           -- register
        VICTrVectPrity2  : out   std_logic_vector(3 downto 0);
                                           -- Mirrored VICTrVectPrity2
                                           -- register
        VICTrVectPrity3  : out   std_logic_vector(3 downto 0);
                                           -- Mirrored VICTrVectPrity3
                                           -- register
        VICTrVectPrity4  : out   std_logic_vector(3 downto 0);
                                           -- Mirrored VICTrVectPrity4
                                           -- register
        VICTrVectPrity5  : out   std_logic_vector(3 downto 0);
                                           -- Mirrored VICTrVectPrity5
                                           -- register
        VICTrVectPrity6  : out   std_logic_vector(3 downto 0);
                                           -- Mirrored VICTrVectPrity6
                                           -- register
        VICTrVectPrity7  : out   std_logic_vector(3 downto 0);
                                           -- Mirrored VICTrVectPrity7
                                           -- register
        VICTrVectPrity8  : out   std_logic_vector(3 downto 0);
                                           -- Mirrored VICTrVectPrity8
                                           -- register
        VICTrVectPrity9  : out   std_logic_vector(3 downto 0);
                                           -- Mirrored VICTrVectPrity9
                                           -- register
        VICTrVectPrity10 : out   std_logic_vector(3 downto 0);
                                           -- Mirrored VICTrVectPrity10
                                           -- register
        VICTrVectPrity11 : out   std_logic_vector(3 downto 0);
                                           -- Mirrored VICTrVectPrity11
                                           -- register
        VICTrVectPrity12 : out   std_logic_vector(3 downto 0);
                                           -- Mirrored VICTrVectPrity12
                                           -- register
        VICTrVectPrity13 : out   std_logic_vector(3 downto 0);
                                           -- Mirrored VICTrVectPrity13
                                           -- register
        VICTrVectPrity14 : out   std_logic_vector(3 downto 0);
                                           -- Mirrored VICTrVectPrity14
                                           -- register
        VICTrVectPrity15 : out   std_logic_vector(3 downto 0);
                                           -- Mirrored VICTrVectPrity15
                                           -- register
        VICTrVectPrity16 : out   std_logic_vector(3 downto 0);
                                          -- Mirrored VICTrVectPrity16
                                          -- register
        VICTrVectPrity17 : out   std_logic_vector(3 downto 0);
                                          -- Mirrored VICTrVectPrity17
                                          -- register
        VICTrVectPrity18 : out   std_logic_vector(3 downto 0);
                                          -- Mirrored VICTrVectPrity18
                                          -- register
        VICTrVectPrity19 : out   std_logic_vector(3 downto 0);
                                          -- Mirrored VICTrVectPrity19
                                          -- register
        VICTrVectPrity20 : out   std_logic_vector(3 downto 0);
                                          -- Mirrored VICTrVectPrity20
                                          -- register
        VICTrVectPrity21 : out   std_logic_vector(3 downto 0);
                                           -- Mirrored VICTrVectPrity21
                                           -- register
        VICTrVectPrity22 : out   std_logic_vector(3 downto 0);
                                           -- Mirrored VICTrVectPrity22
                                           -- register
        VICTrVectPrity23 : out   std_logic_vector(3 downto 0);
                                           -- Mirrored VICTrVectPrity23
                                           -- register
        VICTrVectPrity24 : out   std_logic_vector(3 downto 0);
                                           -- Mirrored VICTrVectPrity24
                                           -- register
        VICTrVectPrity25 : out   std_logic_vector(3 downto 0);
                                           -- Mirrored VICTrVectPrity25
                                           -- register
        VICTrVectPrity26 : out   std_logic_vector(3 downto 0);
                                          -- Mirrored VICTrVectPrity26
                                          -- register
        VICTrVectPrity27 : out   std_logic_vector(3 downto 0);
                                          -- Mirrored VICTrVectPrity27
                                          -- register
        VICTrVectPrity28 : out   std_logic_vector(3 downto 0);
                                          -- Mirrored VICTrVectPrity28
                                          -- register
        VICTrVectPrity29 : out   std_logic_vector(3 downto 0);
                                          -- Mirrored VICTrVectPrity29
                                          -- register
        VICTrVectPrity30 : out   std_logic_vector(3 downto 0);
                                          -- Mirrored VICTrVectPrity30
                                          -- register
        VICTrVectPrity31 : out   std_logic_vector(3 downto 0);
                                            -- Mirrored VICTrVectPrity31
                                            -- register
        VICACKOUT        : out   std_logic; -- Acknowledge signal to 
                                            -- uut and Trickbox
        HCLKTRICK        : out   std_logic; -- Clock to UUT and mirrored 
                                            -- trickbox If bit 5 in VICTrTCR 
                                            -- is set the is turned off
        VectAddrWrTrig   : out   std_logic; -- Write Enable signal on
                                            -- VICTrVectAddr register
        VectAddrRdTrig   : out   std_logic; -- Read enable signal on
                                            -- VICTrVectAddr register
        AsyncRdEn        : out   std_logic  -- Asynchronous Read enable
                                            -- to Mirrored Trickbox 
       );
end VicTrAhbif;

-- -----------------------------------------------------------------------------
--
--                             VicTrAhbif
--                             ==========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--   This block interfaces the Trickbox with the AHB. It decodes AHB
-- accesses and generates the write strobes to appropriate registers.
-- This module also contains the output data multiplexer that forms the
-- read interface. Slave response signals are generated from this
-- module. This block implements both the VIC Mirrored and the
-- Trickbox specific registers.
-- -----------------------------------------------------------------------------
-- VIC Registers
-- =============                                              
-- VICTrVectAddr     0x008  32   R/W  Interrupt Vector Address    
-- VICTrIntSelect    0x010  32   R/W  Select IRQ or FIQ interrupts
-- VICTrIntEnable    0x014  32   R/W  Interrupt Enable      
-- VICTrIntEnClear   0x018  32   W    Interrupt Enable Clear         
-- VICTrSoftInt      0x01C  32   R/W  To generate Software interrupts
-- VICTrSoftIntClear 0x020  32   W    Software Interrupt Clear  
-- VICTrProtection   0x024  1    R/W  Protection Enable Register
-- VICTrSwPriMask    0x028  16   R/W  Software priority mask
-- VICTrVectAddr0-31 0x100- 32   R/W  Interrupt Vector Addresses from 0 to 31
--                   0x17C                                     
-- VICTrVectPrity0   0x200- 4    R/W  Interrupt Vector Control from 0 to 31
-- -31               0x27C            from 0 to 15                        
-- -----------------------------------------------------------------------------
-- Note :
--   A write to a VIC register will automatically update its mirrored
-- register as well. If these mirrored VIC registers are accessed using
-- the VIC Base address, the Trickbox returns zeroes on the HRDATA bus.
-- However, if these registers are accessed using the Trickbox Base
-- address (instead of the VIC Base address), their current contents are
-- reflected onto the HRDATA bus.
-- -----------------------------------------------------------------------------
-- Vic Trickbox-specific Registers [offsets are from Trickbox
--                                  Base address]
-- -----------------------------------------------------------------------------
-- VICTrTCR          0x050  9    R/W  Error Message Enable & Clock Off
-- VICTrIntSource    0x054  32   R/W  Interrupt Source
-- VICTrStatus       0x058  2    R    FIQ and IRQ Status
-- VICTrVectAddrOut  0x05C  32   R    VICVECTADDROUT Status
-- VICTrIntIn        0x060  2    R/W  nVICFIQIN and nVICIRQIN
-- VICTrIntInReg     0x064  2    R/W  Register enable nVICFIQIN and nVICIRQIN
-- VICTrVectAddrIn   0x068  32   R/W  VICVECTADDRIN Source
-- VicTrSync         0x06C  1    R/W  Sync Enable register
-- VicTrAckCnt       0x074  4    R/W  Cnt to control Acknowledge generation
-- VICTrWaitStReg    0x078  32   R/W  A location accessible with
--                                    Non-zero wait states.
--                                    Returns 0x55555555
--                                    when read
--
-- -----------------------------------------------------------------------------

-- --============================= ARCHITECTURE ==============================--

architecture behavioural of VicTrAhbif is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------
constant tovmaxnvicsynin : time := 1 ns;
-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
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

signal MrWrAccesstmp    : std_logic;
-- Write Access to Mirrored registers

signal NxtMrWrAccess    : std_logic;
-- D-input of MrWrAccess

signal MrRdAccess       : std_logic;
-- Read Access to Mirrored registers

signal MrRdAccesstmp    : std_logic;
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

signal SwPrityMaskEn    : std_logic;
-- VICTrSwPriMask Access Enable signal

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

signal VectAddrEnA      : std_logic;
-- Asynchronous VICTrVectAddr Access Enable signal

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

signal VectAddr16En     : std_logic;
-- VICTrVectAddr16 Access Enable signal

signal VectAddr17En     : std_logic;
-- VICTrVectAddr17 Access Enable signal

signal VectAddr18En     : std_logic;
-- VICTrVectAddr18 Access Enable signal

signal VectAddr19En     : std_logic;
-- VICTrVectAddr19 Access Enable signal

signal VectAddr20En     : std_logic;
-- VICTrVectAddr20 Access Enable signal

signal VectAddr21En     : std_logic;
-- VICTrVectAddr21 Access Enable signal

signal VectAddr22En     : std_logic;
-- VICTrVectAddr22 Access Enable signal

signal VectAddr23En     : std_logic;
-- VICTrVectAddr23 Access Enable signal

signal VectAddr24En     : std_logic;
-- VICTrVectAddr24 Access Enable signal

signal VectAddr25En     : std_logic;
-- VICTrVectAddr25 Access Enable signal

signal VectAddr26En     : std_logic;
-- VICTrVectAddr26 Access Enable signal

signal VectAddr27En     : std_logic;
-- VICTrVectAddr27 Access Enable signal

signal VectAddr28En     : std_logic;
-- VICTrVectAddr28 Access Enable signal

signal VectAddr29En     : std_logic;
-- VICTrVectAddr29 Access Enable signal

signal VectAddr30En     : std_logic;
-- VICTrVectAddr30 Access Enable signal

signal VectAddr31En     : std_logic;
-- VICTrVectAddr31 Access Enable signal

signal VectPrity0En     : std_logic;
-- VICTrVectPrity0 Access Enable signal

signal VectPrity1En     : std_logic;
-- VICTrVectPrity1 Access Enable signal

signal VectPrity2En     : std_logic;
-- VICTrVectPrity2 Access Enable signal

signal VectPrity3En     : std_logic;
-- VICTrVectPrity3 Access Enable signal

signal VectPrity4En     : std_logic;
-- VICTrVectPrity4 Access Enable signal

signal VectPrity5En     : std_logic;
-- VICTrVectPrity5 Access Enable signal

signal VectPrity6En     : std_logic;
-- VICTrVectPrity6 Access Enable signal

signal VectPrity7En     : std_logic;
-- VICTrVectPrity7 Access Enable signal

signal VectPrity8En     : std_logic;
-- VICTrVectPrity8 Access Enable signal

signal VectPrity9En     : std_logic;
-- VICTrVectPrity9 Access Enable signal

signal VectPrity10En    : std_logic;
-- VICTrVectPrity10 Access Enable signal

signal VectPrity11En    : std_logic;
-- VICTrVectPrity11 Access Enable signal

signal VectPrity12En    : std_logic;
-- VICTrVectPrity12 Access Enable signal

signal VectPrity13En    : std_logic;
-- VICTrVectPrity13 Access Enable signal

signal VectPrity14En    : std_logic;
-- VICTrVectPrity14 Access Enable signal

signal VectPrity15En    : std_logic;
-- VICTrVectPrity15 Access Enable signal

signal VectPrity16En    : std_logic;
-- VICTrVectPrity16 Access Enable signal

signal VectPrity17En    : std_logic;
-- VICTrVectPrity17 Access Enable signal

signal VectPrity18En    : std_logic;
-- VICTrVectPrity18 Access Enable signal

signal VectPrity19En    : std_logic;
-- VICTrVectPrity19 Access Enable signal

signal VectPrity20En    : std_logic;
-- VICTrVectPrity20 Access Enable signal

signal VectPrity21En    : std_logic;
-- VICTrVectPrity21 Access Enable signal

signal VectPrity22En    : std_logic;
-- VICTrVectPrity22 Access Enable signal

signal VectPrity23En    : std_logic;
-- VICTrVectPrity23 Access Enable signal

signal VectPrity24En    : std_logic;
-- VICTrVectPrity24 Access Enable signal

signal VectPrity25En    : std_logic;
-- VICTrVectPrity25 Access Enable signal

signal VectPrity26En    : std_logic;
-- VICTrVectPrity26 Access Enable signal

signal VectPrity27En    : std_logic;
-- VICTrVectPrity27 Access Enable signal

signal VectPrity28En    : std_logic;
-- VICTrVectPrity28 Access Enable signal

signal VectPrity29En    : std_logic;
-- VICTrVectPrity29 Access Enable signal

signal VectPrity30En    : std_logic;
-- VICTrVectPrity30 Access Enable signal

signal VectPrity31En    : std_logic;
-- VICTrVectPrity31 Access Enable signal

signal VectPrityDsyEn   : std_logic;
-- VICTrVectPriDsy Access Enable signal

signal VICTrTCREn       : std_logic;
-- VICTrTCR Access Enable signal

signal TrIntSourceEn    : std_logic;
-- VICTrIntSource Access Enable signal

signal TrStatusEn       : std_logic;
-- VICTrStatus Access Enable signal

signal TrIntInEn        : std_logic;
-- VICTrIntIn Access Enable signal

signal TrIntInRegEn     : std_logic;
-- VICTrIntInReg Access Enable signal

signal TrSyncEn         : std_logic;
-- VICTrSync Access Enable signal

signal TrAckCntEn       : std_logic;
-- VICTrAckCnt Access Enable signal

signal TrVectAdInEn     : std_logic;
-- VICTrVectAddrIn Access Enable signal

signal TrVectAdOutEn    : std_logic;
-- VICVECTADDROUT Access Enable signal

signal WaitStRegEn      : std_logic;
-- VICTrWaitStReg Access Enable signal

signal IntSelectRdEn    : std_logic;
-- VICTrIntSelect Access Enable signal

signal SwPrityMaskRdEn  : std_logic;
-- VICTrSwPriMask Access Enable signal

signal IntEnableRdEn    : std_logic;
-- VICTrIntEnable Access Enable signal

signal IntEnClearRdEn   : std_logic;
-- VICTrIntEnableClear Access Enable signal

signal SoftIntRdEn      : std_logic;
-- VICTrSoftInt Access Enable signal

signal SoftIntClearRdEn : std_logic;
-- VICTrSoftIntClear Access Enable signal

signal ProtectionRdEn   : std_logic;
-- VICTrProtection Access Enable signal

signal VectAddrRdEn     : std_logic;
-- VICTrVectAddr Access Enable signal

signal VectAddrRdEnA    : std_logic;
-- Asynchronous VICTrVectAddr Access Enable signal

signal VectAddr0RdEn    : std_logic;
-- VICTrVectAddr0 Access Enable signal

signal VectAddr1RdEn    : std_logic;
-- VICTrVectAddr1 Access Enable signal

signal VectAddr2RdEn    : std_logic;
-- VICTrVectAddr2 Access Enable signal

signal VectAddr3RdEn    : std_logic;
-- VICTrVectAddr3 Access Enable signal

signal VectAddr4RdEn    : std_logic;
-- VICTrVectAddr4 Access Enable signal

signal VectAddr5RdEn    : std_logic;
-- VICTrVectAddr5 Access Enable signal

signal VectAddr6RdEn    : std_logic;
-- VICTrVectAddr6 Access Enable signal

signal VectAddr7RdEn    : std_logic;
-- VICTrVectAddr7 Access Enable signal

signal VectAddr8RdEn    : std_logic;
-- VICTrVectAddr8 Access Enable signal

signal VectAddr9RdEn    : std_logic;
-- VICTrVectAddr9 Access Enable signal

signal VectAddr10RdEn   : std_logic;
-- VICTrVectAddr10 Access Enable signal

signal VectAddr11RdEn   : std_logic;
-- VICTrVectAddr11 Access Enable signal

signal VectAddr12RdEn   : std_logic;
-- VICTrVectAddr12 Access Enable signal

signal VectAddr13RdEn   : std_logic;
-- VICTrVectAddr13 Access Enable signal

signal VectAddr14RdEn   : std_logic;
-- VICTrVectAddr14 Access Enable signal

signal VectAddr15RdEn   : std_logic;
-- VICTrVectAddr15 Access Enable signal

signal VectAddr16RdEn   : std_logic;
-- VICTrVectAddr16 Access Enable signal

signal VectAddr17RdEn   : std_logic;
-- VICTrVectAddr17 Access Enable signal

signal VectAddr18RdEn   : std_logic;
-- VICTrVectAddr18 Access Enable signal

signal VectAddr19RdEn   : std_logic;
-- VICTrVectAddr19 Access Enable signal

signal VectAddr20RdEn   : std_logic;
-- VICTrVectAddr20 Access Enable signal

signal VectAddr21RdEn   : std_logic;
-- VICTrVectAddr21 Access Enable signal

signal VectAddr22RdEn   : std_logic;
-- VICTrVectAddr22 Access Enable signal

signal VectAddr23RdEn   : std_logic;
-- VICTrVectAddr23 Access Enable signal

signal VectAddr24RdEn   : std_logic;
-- VICTrVectAddr24 Access Enable signal

signal VectAddr25RdEn   : std_logic;
-- VICTrVectAddr25 Access Enable signal

signal VectAddr26RdEn   : std_logic;
-- VICTrVectAddr26 Access Enable signal

signal VectAddr27RdEn   : std_logic;
-- VICTrVectAddr27 Access Enable signal

signal VectAddr28RdEn   : std_logic;
-- VICTrVectAddr28 Access Enable signal

signal VectAddr29RdEn   : std_logic;
-- VICTrVectAddr29 Access Enable signal

signal VectAddr30RdEn   : std_logic;
-- VICTrVectAddr30 Access Enable signal

signal VectAddr31RdEn   : std_logic;
-- VICTrVectAddr31 Access Enable signal

signal VectPrity0RdEn   : std_logic;
-- VICTrVectPrity0 Access Enable signal

signal VectPrity1RdEn   : std_logic;
-- VICTrVectPrity1 Access Enable signal

signal VectPrity2RdEn   : std_logic;
-- VICTrVectPrity2 Access Enable signal

signal VectPrity3RdEn   : std_logic;
-- VICTrVectPrity3 Access Enable signal

signal VectPrity4RdEn   : std_logic;
-- VICTrVectPrity4 Access Enable signal

signal VectPrity5RdEn   : std_logic;
-- VICTrVectPrity5 Access Enable signal

signal VectPrity6RdEn   : std_logic;
-- VICTrVectPrity6 Access Enable signal

signal VectPrity7RdEn   : std_logic;
-- VICTrVectPrity7 Access Enable signal

signal VectPrity8RdEn   : std_logic;
-- VICTrVectPrity8 Access Enable signal

signal VectPrity9RdEn   : std_logic;
-- VICTrVectPrity9 Access Enable signal

signal VectPrity10RdEn  : std_logic;
-- VICTrVectPrity10 Access Enable signal

signal VectPrity11RdEn  : std_logic;
-- VICTrVectPrity11 Access Enable signal

signal VectPrity12RdEn  : std_logic;
-- VICTrVectPrity12 Access Enable signal

signal VectPrity13RdEn  : std_logic;
-- VICTrVectPrity13 Access Enable signal

signal VectPrity14RdEn  : std_logic;
-- VICTrVectPrity14 Access Enable signal

signal VectPrity15RdEn  : std_logic;
-- VICTrVectPrity15 Access Enable signal

signal VectPrity16RdEn  : std_logic;
-- VICTrVectPrity16 Access Enable signal

signal VectPrity17RdEn  : std_logic;
-- VICTrVectPrity17 Access Enable signal

signal VectPrity18RdEn  : std_logic;
-- VICTrVectPrity18 Access Enable signal

signal VectPrity19RdEn  : std_logic;
-- VICTrVectPrity19 Access Enable signal

signal VectPrity20RdEn  : std_logic;
-- VICTrVectPrity20 Access Enable signal

signal VectPrity21RdEn  : std_logic;
-- VICTrVectPrity21 Access Enable signal

signal VectPrity22RdEn  : std_logic;
-- VICTrVectPrity22 Access Enable signal

signal VectPrity23RdEn  : std_logic;
-- VICTrVectPrity23 Access Enable signal

signal VectPrity24RdEn  : std_logic;
-- VICTrVectPrity24 Access Enable signal

signal VectPrity25RdEn  : std_logic;
-- VICTrVectPrity25 Access Enable signal

signal VectPrity26RdEn  : std_logic;
-- VICTrVectPrity26 Access Enable signal

signal VectPrity27RdEn  : std_logic;
-- VICTrVectPrity27 Access Enable signal

signal VectPrity28RdEn  : std_logic;
-- VICTrVectPrity28 Access Enable signal

signal VectPrity29RdEn  : std_logic;
-- VICTrVectPrity29 Access Enable signal

signal VectPrity30RdEn  : std_logic;
-- VICTrVectPrity30 Access Enable signal

signal VectPrity31RdEn  : std_logic;
-- VICTrVectPrity31 Access Enable signal

signal VectPrityDsyRdEn : std_logic;
-- VICTrVectPriDsy Access Enable signal

signal VICTrTCRRdEn     : std_logic;
-- VICTrTCR Access Enable signal

signal TrIntSrcRdEn     : std_logic;
-- VICTrIntSource Access Enable signal

signal IntStatRdEn      : std_logic;
-- VICTrStatus Access Enable signal

signal TrIntInRdEn      : std_logic;
-- VICTrIntIn Access Enable signal

signal TrIntInRegRdEn   : std_logic;
-- VICTrIntInReg Access Enable signal

signal TrSyncRdEn       : std_logic;
-- VICTrSync Access Enable signal

signal TrAckCntRdEn     : std_logic;
-- VICTrAckCnt Access Enable signal

signal TrVectAdInRdEn   : std_logic;
-- VICTrVectAddrIn Access Enable signal

signal TrVectAdOutRdEn  : std_logic;
-- VICVECTADDROUT Access Enable signal

signal IntSelectWrEn    : std_logic;
-- VICTrIntSelect Access Enable signal

signal SwPrityMaskWrEn  : std_logic;
-- VICTrSwPriMask Access Enable signal

signal IntEnableWrEn    : std_logic;
-- VICTrIntEnable Access Enable signal

signal IntEnClearWrEn   : std_logic;
-- VICTrIntEnableClear Access Enable signal

signal SoftIntWrEn      : std_logic;
-- VICTrSoftInt Access Enable signal

signal SoftIntClearWrEn : std_logic;
-- VICTrSoftIntClear Access Enable signal

signal ProtectionWrEn   : std_logic;
-- VICTrProtection Access Enable signal

signal VectAddrWrEn     : std_logic;
-- VICTrVectAddr Access Enable signal

signal VectAddrWrEnA    : std_logic;
-- Asynchronous VICTrVectAddr Access Enable signal

signal VectAddr0WrEn    : std_logic;
-- VICTrVectAddr0 Access Enable signal

signal VectAddr1WrEn    : std_logic;
-- VICTrVectAddr1 Access Enable signal

signal VectAddr2WrEn    : std_logic;
-- VICTrVectAddr2 Access Enable signal

signal VectAddr3WrEn    : std_logic;
-- VICTrVectAddr3 Access Enable signal

signal VectAddr4WrEn    : std_logic;
-- VICTrVectAddr4 Access Enable signal

signal VectAddr5WrEn    : std_logic;
-- VICTrVectAddr5 Access Enable signal

signal VectAddr6WrEn    : std_logic;
-- VICTrVectAddr6 Access Enable signal

signal VectAddr7WrEn    : std_logic;
-- VICTrVectAddr7 Access Enable signal

signal VectAddr8WrEn    : std_logic;
-- VICTrVectAddr8 Access Enable signal

signal VectAddr9WrEn    : std_logic;
-- VICTrVectAddr9 Access Enable signal

signal VectAddr10WrEn   : std_logic;
-- VICTrVectAddr10 Access Enable signal

signal VectAddr11WrEn   : std_logic;
-- VICTrVectAddr11 Access Enable signal

signal VectAddr12WrEn   : std_logic;
-- VICTrVectAddr12 Access Enable signal

signal VectAddr13WrEn   : std_logic;
-- VICTrVectAddr13 Access Enable signal

signal VectAddr14WrEn   : std_logic;
-- VICTrVectAddr14 Access Enable signal

signal VectAddr15WrEn   : std_logic;
-- VICTrVectAddr15 Access Enable signal

signal VectAddr16WrEn   : std_logic;
-- VICTrVectAddr16 Access Enable signal

signal VectAddr17WrEn   : std_logic;
-- VICTrVectAddr17 Access Enable signal

signal VectAddr18WrEn   : std_logic;
-- VICTrVectAddr18 Access Enable signal

signal VectAddr19WrEn   : std_logic;
-- VICTrVectAddr19 Access Enable signal

signal VectAddr20WrEn   : std_logic;
-- VICTrVectAddr20 Access Enable signal

signal VectAddr21WrEn   : std_logic;
-- VICTrVectAddr21 Access Enable signal

signal VectAddr22WrEn   : std_logic;
-- VICTrVectAddr22 Access Enable signal

signal VectAddr23WrEn   : std_logic;
-- VICTrVectAddr23 Access Enable signal

signal VectAddr24WrEn   : std_logic;
-- VICTrVectAddr24 Access Enable signal

signal VectAddr25WrEn   : std_logic;
-- VICTrVectAddr25 Access Enable signal

signal VectAddr26WrEn   : std_logic;
-- VICTrVectAddr26 Access Enable signal

signal VectAddr27WrEn   : std_logic;
-- VICTrVectAddr27 Access Enable signal

signal VectAddr28WrEn   : std_logic;
-- VICTrVectAddr28 Access Enable signal

signal VectAddr29WrEn   : std_logic;
-- VICTrVectAddr29 Access Enable signal

signal VectAddr30WrEn   : std_logic;
-- VICTrVectAddr30 Access Enable signal

signal VectAddr31WrEn   : std_logic;
-- VICTrVectAddr31 Access Enable signal

signal VectPrity0WrEn   : std_logic;
-- VICTrVectPrity0 Access Enable signal

signal VectPrity1WrEn   : std_logic;
-- VICTrVectPrity1 Access Enable signal

signal VectPrity2WrEn   : std_logic;
-- VICTrVectPrity2 Access Enable signal

signal VectPrity3WrEn   : std_logic;
-- VICTrVectPrity3 Access Enable signal

signal VectPrity4WrEn   : std_logic;
-- VICTrVectPrity4 Access Enable signal

signal VectPrity5WrEn   : std_logic;
-- VICTrVectPrity5 Access Enable signal

signal VectPrity6WrEn   : std_logic;
-- VICTrVectPrity6 Access Enable signal

signal VectPrity7WrEn   : std_logic;
-- VICTrVectPrity7 Access Enable signal

signal VectPrity8WrEn   : std_logic;
-- VICTrVectPrity8 Access Enable signal

signal VectPrity9WrEn   : std_logic;
-- VICTrVectPrity9 Access Enable signal

signal VectPrity10WrEn  : std_logic;
-- VICTrVectPrity10 Access Enable signal

signal VectPrity11WrEn  : std_logic;
-- VICTrVectPrity11 Access Enable signal

signal VectPrity12WrEn  : std_logic;
-- VICTrVectPrity12 Access Enable signal

signal VectPrity13WrEn  : std_logic;
-- VICTrVectPrity13 Access Enable signal

signal VectPrity14WrEn  : std_logic;
-- VICTrVectPrity14 Access Enable signal

signal VectPrity15WrEn  : std_logic;
-- VICTrVectPrity15 Access Enable signal

signal VectPrity16WrEn  : std_logic;
-- VICTrVectPrity16 Access Enable signal

signal VectPrity17WrEn  : std_logic;
-- VICTrVectPrity17 Access Enable signal

signal VectPrity18WrEn  : std_logic;
-- VICTrVectPrity18 Access Enable signal

signal VectPrity19WrEn  : std_logic;
-- VICTrVectPrity19 Access Enable signal

signal VectPrity20WrEn  : std_logic;
-- VICTrVectPrity20 Access Enable signal

signal VectPrity21WrEn  : std_logic;
-- VICTrVectPrity21 Access Enable signal

signal VectPrity22WrEn  : std_logic;
-- VICTrVectPrity22 Access Enable signal

signal VectPrity23WrEn  : std_logic;
-- VICTrVectPrity23 Access Enable signal

signal VectPrity24WrEn  : std_logic;
-- VICTrVectPrity24 Access Enable signal

signal VectPrity25WrEn  : std_logic;
-- VICTrVectPrity25 Access Enable signal

signal VectPrity26WrEn  : std_logic;
-- VICTrVectPrity26 Access Enable signal

signal VectPrity27WrEn  : std_logic;
-- VICTrVectPrity27 Access Enable signal

signal VectPrity28WrEn  : std_logic;
-- VICTrVectPrity28 Access Enable signal

signal VectPrity29WrEn  : std_logic;
-- VICTrVectPrity29 Access Enable signal

signal VectPrity30WrEn  : std_logic;
-- VICTrVectPrity30 Access Enable signal

signal VectPrity31WrEn  : std_logic;
-- VICTrVectPrity31 Access Enable signal

signal VectPrityDsyWrEn : std_logic;
-- VICTrVectPriDsy Access Enable signal

signal VICTrTCRWrEn     : std_logic;
-- VICTrTCR Access Enable signal

signal TrIntSrcWrEn     : std_logic;
-- VICTrIntSource Access Enable signal

signal TrIntInWrEn      : std_logic;
-- VICTrIntIn Access Enable signal

signal TrIntInRegWrEn   : std_logic;
-- VICTrIntInReg Access Enable signal

signal TrSyncWrEn       : std_logic;
-- VICTrSync Access Enable signal

signal TrAckCntWrEn     : std_logic;
-- VICTrAckCnt Access Enable signal

signal TrVectAdInWrEn   : std_logic;
-- VICTrVectAddrIn Access Enable signal

signal iVICTrIntSelect  : std_logic_vector(31 downto 0);
-- Internal version of IntSelect Register

signal NxtTrIntSelect   : std_logic_vector(31 downto 0);
-- D-input of VICTrIntSelect Register

signal iVICTrSwPriMask  : std_logic_vector(15 downto 0);
-- Internal version of Software priority Register

signal NxtTrSwPrityMask : std_logic_vector(15 downto 0);
-- D-input of NxtTrSwPrityMask Register

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

signal iVICTrVectAddr0  : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectAddr0 Register

signal NxtTrVectAddr0   : std_logic_vector(31 downto 0);
-- D-input of VICTrVectAddr0 Register

signal iVICTrVectAddr1  : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectAddr1 Register

signal NxtTrVectAddr1   : std_logic_vector(31 downto 0);
-- D-input of VICTrVectAddr1 Register

signal iVICTrVectAddr2  : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectAddr2 Register

signal NxtTrVectAddr2   : std_logic_vector(31 downto 0);
-- D-input of VICTrVectAddr2 Register

signal iVICTrVectAddr3  : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectAddr3 Register

signal NxtTrVectAddr3   : std_logic_vector(31 downto 0);
-- D-input of VICTrVectAddr3 Register

signal iVICTrVectAddr4  : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectAddr4 Register

signal NxtTrVectAddr4   : std_logic_vector(31 downto 0);
-- D-input of VICTrVectAddr1 Register

signal iVICTrVectAddr5  : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectAddr5 Register

signal NxtTrVectAddr5   : std_logic_vector(31 downto 0);
-- D-input of VICTrVectAddr5 Register

signal iVICTrVectAddr6  : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectAddr6 Register

signal NxtTrVectAddr6   : std_logic_vector(31 downto 0);
-- D-input of VICTrVectAddr6 Register

signal iVICTrVectAddr7  : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectAddr7 Register

signal NxtTrVectAddr7   : std_logic_vector(31 downto 0);
-- D-input of VICTrVectAddr7 Register

signal iVICTrVectAddr8  : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectAddr8 Register

signal NxtTrVectAddr8   : std_logic_vector(31 downto 0);
-- D-input of VICTrVectAddr8 Register

signal iVICTrVectAddr9  : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectAddr9 Register

signal NxtTrVectAddr9   : std_logic_vector(31 downto 0);
-- D-input of VICTrVectAddr9 Register

signal iVICTrVectAddr10 : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectAddr10 Register

signal NxtTrVectAddr10  : std_logic_vector(31 downto 0);
-- D-input of VICTrVectAddr10 Register

signal iVICTrVectAddr11 : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectAddr11 Register

signal NxtTrVectAddr11  : std_logic_vector(31 downto 0);
-- D-input of VICTrVectAddr11 Register

signal iVICTrVectAddr12 : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectAddr12 Register

signal NxtTrVectAddr12  : std_logic_vector(31 downto 0);
-- D-input of VICTrVectAddr12 Register

signal iVICTrVectAddr13 : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectAddr13 Register

signal NxtTrVectAddr13  : std_logic_vector(31 downto 0);
-- D-input of VICTrVectAddr13 Register

signal iVICTrVectAddr14 : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectAddr14 Register

signal NxtTrVectAddr14  : std_logic_vector(31 downto 0);
-- D-input of VICTrVectAddr14 Register

signal iVICTrVectAddr15 : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectAddr15 Register

signal NxtTrVectAddr15  : std_logic_vector(31 downto 0);
-- D-input of VICTrVectAddr15 Register

signal iVICTrVectAddr16 : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectAddr16 Register

signal NxtTrVectAddr16  : std_logic_vector(31 downto 0);
-- D-input of VICTrVectAddr16 Register

signal iVICTrVectAddr17 : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectAddr17 Register

signal NxtTrVectAddr17  : std_logic_vector(31 downto 0);
-- D-input of VICTrVectAddr17 Register

signal iVICTrVectAddr18 : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectAddr18 Register

signal NxtTrVectAddr18  : std_logic_vector(31 downto 0);
-- D-input of VICTrVectAddr18 Register

signal iVICTrVectAddr19 : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectAddr19 Register

signal NxtTrVectAddr19  : std_logic_vector(31 downto 0);
-- D-input of VICTrVectAddr19 Register

signal iVICTrVectAddr20 : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectAddr20 Register

signal NxtTrVectAddr20  : std_logic_vector(31 downto 0);
-- D-input of VICTrVectAddr20 Register

signal iVICTrVectAddr21 : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectAddr21 Register

signal NxtTrVectAddr21  : std_logic_vector(31 downto 0);
-- D-input of VICTrVectAddr21 Register

signal iVICTrVectAddr22 : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectAddr22 Register

signal NxtTrVectAddr22  : std_logic_vector(31 downto 0);
-- D-input of VICTrVectAddr22 Register

signal iVICTrVectAddr23 : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectAddr23 Register

signal NxtTrVectAddr23  : std_logic_vector(31 downto 0);
-- D-input of VICTrVectAddr23 Register

signal iVICTrVectAddr24 : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectAddr24 Register

signal NxtTrVectAddr24  : std_logic_vector(31 downto 0);
-- D-input of VICTrVectAddr24 Register

signal iVICTrVectAddr25 : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectAddr25 Register

signal NxtTrVectAddr25  : std_logic_vector(31 downto 0);
-- D-input of VICTrVectAddr25 Register

signal iVICTrVectAddr26 : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectAddr26 Register

signal NxtTrVectAddr26  : std_logic_vector(31 downto 0);
-- D-input of VICTrVectAddr26 Register

signal iVICTrVectAddr27 : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectAddr27 Register

signal NxtTrVectAddr27  : std_logic_vector(31 downto 0);
-- D-input of VICTrVectAddr27 Register

signal iVICTrVectAddr28 : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectAddr28 Register

signal NxtTrVectAddr28  : std_logic_vector(31 downto 0);
-- D-input of VICTrVectAddr28 Register

signal iVICTrVectAddr29 : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectAddr29 Register

signal NxtTrVectAddr29  : std_logic_vector(31 downto 0);
-- D-input of VICTrVectAddr29 Register

signal iVICTrVectAddr30 : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectAddr30 Register

signal NxtTrVectAddr30  : std_logic_vector(31 downto 0);
-- D-input of VICTrVectAddr30 Register

signal iVICTrVectAddr31 : std_logic_vector(31 downto 0);
-- Internal version of VICTrVectAddr31 Register

signal NxtTrVectAddr31  : std_logic_vector(31 downto 0);
-- D-input of VICTrVectAddr31 Register

signal iVICTrVectPrity0 : std_logic_vector(3 downto 0);
-- Internal version of VICTrVectPrity0 Register

signal NxtTrVectPrity0  : std_logic_vector(3 downto 0);
-- D-input of VICTrVectPrity0 Register

signal iVICTrVectPrity1 : std_logic_vector(3 downto 0);
-- Internal version of VICTrVectPrity1 Register

signal NxtTrVectPrity1  : std_logic_vector(3 downto 0);
-- D-input of VICTrVectPrity1 Register

signal iVICTrVectPrity2 : std_logic_vector(3 downto 0);
-- Internal version of VICTrVectPrity2 Register

signal NxtTrVectPrity2  : std_logic_vector(3 downto 0);
-- D-input of VICTrVectPrity2 Register

signal iVICTrVectPrity3 : std_logic_vector(3 downto 0);
-- Internal version of VICTrVectPrity3 Register

signal NxtTrVectPrity3  : std_logic_vector(3 downto 0);
-- D-input of VICTrVectPrity3 Register

signal iVICTrVectPrity4 : std_logic_vector(3 downto 0);
-- Internal version of VICTrVectPrity4 Register

signal NxtTrVectPrity4  : std_logic_vector(3 downto 0);
-- D-input of VICTrVectPrity1 Register

signal iVICTrVectPrity5 : std_logic_vector(3 downto 0);
-- Internal version of VICTrVectPrity5 Register

signal NxtTrVectPrity5  : std_logic_vector(3 downto 0);
-- D-input of VICTrVectPrity5 Register

signal iVICTrVectPrity6 : std_logic_vector(3 downto 0);
-- Internal version of VICTrVectPrity6 Register

signal NxtTrVectPrity6  : std_logic_vector(3 downto 0);
-- D-input of VICTrVectPrity6 Register

signal iVICTrVectPrity7 : std_logic_vector(3 downto 0);
-- Internal version of VICTrVectPrity7 Register

signal NxtTrVectPrity7  : std_logic_vector(3 downto 0);
-- D-input of VICTrVectPrity7 Register

signal iVICTrVectPrity8 : std_logic_vector(3 downto 0);
-- Internal version of VICTrVectPrity8 Register

signal NxtTrVectPrity8  : std_logic_vector(3 downto 0);
-- D-input of VICTrVectPrity8 Register

signal iVICTrVectPrity9 : std_logic_vector(3 downto 0);
-- Internal version of VICTrVectPrity9 Register

signal NxtTrVectPrity9  : std_logic_vector(3 downto 0);
-- D-input of VICTrVectPrity9 Register

signal iVICTrVectPrity10 : std_logic_vector(3 downto 0);
-- Internal version of VICTrVectPrity10 Register

signal NxtTrVectPrity10  : std_logic_vector(3 downto 0);
-- D-input of VICTrVectPrity10 Register

signal iVICTrVectPrity11 : std_logic_vector(3 downto 0);
-- Internal version of VICTrVectPrity11 Register

signal NxtTrVectPrity11  : std_logic_vector(3 downto 0);
-- D-input of VICTrVectPrity11 Register

signal iVICTrVectPrity12 : std_logic_vector(3 downto 0);
-- Internal version of VICTrVectPrity12 Register

signal NxtTrVectPrity12  : std_logic_vector(3 downto 0);
-- D-input of VICTrVectPrity12 Register

signal iVICTrVectPrity13 : std_logic_vector(3 downto 0);
-- Internal version of VICTrVectPrity13 Register

signal NxtTrVectPrity13  : std_logic_vector(3 downto 0);
-- D-input of VICTrVectPrity13 Register

signal iVICTrVectPrity14 : std_logic_vector(3 downto 0);
-- Internal version of VICTrVectPrity14 Register

signal NxtTrVectPrity14  : std_logic_vector(3 downto 0);
-- D-input of VICTrVectPrity14 Register

signal iVICTrVectPrity15 : std_logic_vector(3 downto 0);
-- Internal version of VICTrVectPrity15 Register

signal NxtTrVectPrity15  : std_logic_vector(3 downto 0);
-- D-input of VICTrVectPrity15 Register

signal iVICTrVectPrity16 : std_logic_vector(3 downto 0);
-- Internal version of VICTrVectPrity16 Register

signal NxtTrVectPrity16  : std_logic_vector(3 downto 0);
-- D-input of VICTrVectPrity16 Register

signal iVICTrVectPrity17 : std_logic_vector(3 downto 0);
-- Internal version of VICTrVectPrity17 Register

signal NxtTrVectPrity17  : std_logic_vector(3 downto 0);
-- D-input of VICTrVectPrity17 Register

signal iVICTrVectPrity18 : std_logic_vector(3 downto 0);
-- Internal version of VICTrVectPrity18 Register

signal NxtTrVectPrity18  : std_logic_vector(3 downto 0);
-- D-input of VICTrVectPrity18 Register

signal iVICTrVectPrity19 : std_logic_vector(3 downto 0);
-- Internal version of VICTrVectPrity19 Register

signal NxtTrVectPrity19  : std_logic_vector(3 downto 0);
-- D-input of VICTrVectPrity19 Register

signal iVICTrVectPrity20 : std_logic_vector(3 downto 0);
-- Internal version of VICTrVectPrity20 Register

signal NxtTrVectPrity20  : std_logic_vector(3 downto 0);
-- D-input of VICTrVectPrity20 Register

signal iVICTrVectPrity21 : std_logic_vector(3 downto 0);
-- Internal version of VICTrVectPrity21 Register

signal NxtTrVectPrity21  : std_logic_vector(3 downto 0);
-- D-input of VICTrVectPrity21 Register

signal iVICTrVectPrity22 : std_logic_vector(3 downto 0);
-- Internal version of VICTrVectPrity22 Register

signal NxtTrVectPrity22  : std_logic_vector(3 downto 0);
-- D-input of VICTrVectPrity22 Register

signal iVICTrVectPrity23 : std_logic_vector(3 downto 0);
-- Internal version of VICTrVectPrity23 Register

signal NxtTrVectPrity23  : std_logic_vector(3 downto 0);
-- D-input of VICTrVectPrity23 Register

signal iVICTrVectPrity24 : std_logic_vector(3 downto 0);
-- Internal version of VICTrVectPrity24 Register

signal NxtTrVectPrity24  : std_logic_vector(3 downto 0);
-- D-input of VICTrVectPrity24 Register

signal iVICTrVectPrity25 : std_logic_vector(3 downto 0);
-- Internal version of VICTrVectPrity25 Register

signal NxtTrVectPrity25  : std_logic_vector(3 downto 0);
-- D-input of VICTrVectPrity25 Register

signal iVICTrVectPrity26 : std_logic_vector(3 downto 0);
-- Internal version of VICTrVectPrity26 Register

signal NxtTrVectPrity26  : std_logic_vector(3 downto 0);
-- D-input of VICTrVectPrity26 Register

signal iVICTrVectPrity27 : std_logic_vector(3 downto 0);
-- Internal version of VICTrVectPrity27 Register

signal NxtTrVectPrity27  : std_logic_vector(3 downto 0);
-- D-input of VICTrVectPrity27 Register

signal iVICTrVectPrity28 : std_logic_vector(3 downto 0);
-- Internal version of VICTrVectPrity28 Register

signal NxtTrVectPrity28  : std_logic_vector(3 downto 0);
-- D-input of VICTrVectPrity28 Register

signal iVICTrVectPrity29 : std_logic_vector(3 downto 0);
-- Internal version of VICTrVectPrity29 Register

signal NxtTrVectPrity29  : std_logic_vector(3 downto 0);
-- D-input of VICTrVectPrity29 Register

signal iVICTrVectPrity30 : std_logic_vector(3 downto 0);
-- Internal version of VICTrVectPrity30 Register

signal NxtTrVectPrity30  : std_logic_vector(3 downto 0);
-- D-input of VICTrVectPrity30 Register

signal iVICTrVectPrity31 : std_logic_vector(3 downto 0);
-- Internal version of VICTrVectPrity31 Register

signal NxtTrVectPrity31  : std_logic_vector(3 downto 0);
-- D-input of VICTrVectPrity31 Register

signal iVICTrVectPriDsy  : std_logic_vector(3 downto 0);
-- Internal version of VICTrVectPriDsy Register

signal NxtTrVectPrityDsy : std_logic_vector(3 downto 0);
-- D-input of VICTrVectPriDsy Register

signal iVICTrTCR         : std_logic_vector(8 downto 0);
-- Internal version of VICTrTCR Register

signal NxtVICTrTCR       : std_logic_vector(8 downto 0);
-- D-input of VICTrTCR Register

signal VICTrIntSource    : std_logic_vector(31 downto 0);
-- VICTrIntSource Register

signal iVICTrIntSource   : std_logic_vector(31 downto 0);
-- VICTrIntSource delayed signal

signal NxtTrIntSource    : std_logic_vector(31 downto 0);
-- D-input of VICTrIntSource Register

signal VICTrIntIn        : std_logic_vector(1 downto 0);
-- VICTrIntIn Register

signal iVICTrIntIn       : std_logic_vector(1 downto 0);
-- Delayed TrIntIn signal

signal NxtTrIntIn        : std_logic_vector(1 downto 0);
-- D-input of VICTrIntIn Register

signal VICTrIntInReg     : std_logic_vector(1 downto 0);
-- VICTrIntInReg Register

signal iVICTrIntInReg    : std_logic_vector(1 downto 0);
-- Delayed TrIntInReg signal

signal NxtTrIntInReg     : std_logic_vector(1 downto 0);
-- D-input of VICTrIntInReg Register

signal VICTrSync         : std_logic;
-- VICTrSync Register

signal iVICTrSync        : std_logic;
-- Delayed TrSync Signal

signal NxtTrSync         : std_logic;
-- D-input of VICTrSync Register

signal VICTrAckCnt       : std_logic_vector(2 downto 0);
-- VICTrAckCnt Register

signal iVICTrAckCnt      : std_logic_vector(2 downto 0);
-- Delayed TrAckCnt Signal

signal NxtTrAckCnt       : std_logic_vector(2 downto 0);
-- D-input of VICTrAckCnt Register

signal VICTrVectAddrIn   : std_logic_vector(31 downto 0);
-- VICTrVectAddrIn Register
 
signal iVICTrVectAddrIn  : std_logic_vector(31 downto 0);
-- Delayed VICTrVectAddrIn signal

signal NxtTrVectAddrIn   : std_logic_vector(31 downto 0);
-- D-input of VICTrVectAddrIn Register

signal VICTrAckCnt1      : std_logic;
-- VICTrAckCnt1 Signal

signal VICTrAckCnt2      : std_logic;
-- VICTrAckCnt2 Signal

signal VICTrAckCnt3      : std_logic;
-- VICTrAckCnt3 Signal

signal VICTrAckCnt4      : std_logic;
-- VICTrAckCnt4 Signal

signal VICTrAckCnt5      : std_logic;
-- VICTrAckCnt5 Signal

signal VICTrAckCnt6      : std_logic;
-- VICTrAckCnt6 Signal

signal VICTrAckCnt7      : std_logic;
-- VICTrAckCnt7 Signal

signal VICACKOUTp      : std_logic;
-- VICACKOUTp Signal

signal VICACKOUTn      : std_logic;
-- VICACKOUTn Signal

signal AckGen   : std_logic_vector(3 downto 0);
-- Internal used for Acknowledge generation

signal iVectAddrRdTrig : std_logic;
-- Internal signal

signal iVectAddrWrTrig : std_logic;
-- Internal signal

-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Type declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- Assign 'min' and 'max' delays to the VICACKOUTp signal
-- -----------------------------------------------------------------------------
p_TrVICACKOUTComb1 : process (HCLK,HRESETn)
begin
  if (HRESETn = '0') then
    VICACKOUTp <= '0';
  elsif (HCLK'event and HCLK = '1') then
    case VICVECTADDRV is
      when '1' =>
        VICACKOUTp <= '0' ; 
      when '0' =>
        case AckGen is
          when "0001" =>
            VICACKOUTp <= VICTrAckCnt1 ;
          when "0010" =>
            VICACKOUTp <= VICTrAckCnt2 ;
          when "0011" =>
            VICACKOUTp <= VICTrAckCnt3 ;
          when "0100" =>
            VICACKOUTp <= VICTrAckCnt4 ;
          when "0101" =>
            VICACKOUTp <= VICTrAckCnt5 ;
          when "0110" =>
            VICACKOUTp <= VICTrAckCnt6 ;
          when "0111" =>
            VICACKOUTp <= VICTrAckCnt7 ;
          when others => 
            null ;
        end case;
      when others => 
       null ;
    end case;
  end if ;
end process p_TrVICACKOUTComb1;

-- -----------------------------------------------------------------------------
-- Assign 'min' and 'max' delays to the VICACKOUTn signal
-- -----------------------------------------------------------------------------
p_TrVICACKOUTComb2 : process (HCLK,HRESETn)
begin
  if (HRESETn = '0') then
    VICACKOUTn <= '0';
  elsif (HCLK'event and HCLK = '1') then
    case VICVECTADDRV is
      when '1' =>
        VICACKOUTn <= '0' ; 
      when '0' =>
        case AckGen is
          when "0001" =>
            VICACKOUTn <= VICTrAckCnt1 ;
          when "0010" =>
            VICACKOUTn <= VICTrAckCnt2 ;
          when "0011" =>
            VICACKOUTn <= VICTrAckCnt3 ;
          when "0100" =>
            VICACKOUTn <= VICTrAckCnt4 ;
          when "0101" =>
            VICACKOUTn <= VICTrAckCnt5 ;
          when "0110" =>
            VICACKOUTn <= VICTrAckCnt6 ;
          when "0111" =>
            VICACKOUTn <= VICTrAckCnt7 ;
          when others => 
            null ;
        end case;
      when others => 
       null ;
    end case;
  end if ;
end process p_TrVICACKOUTComb2;

-- -----------------------------------------------------------------------------
-- Acknowledge signal generation
-- -----------------------------------------------------------------------------
AckGen    <= nVICIRQ & VICTrAckCnt;

VICACKOUT <= VICACKOUTn when(iVICTrTCR(8 downto 6) = "010")
           else
             VICACKOUTp; 

-- -----------------------------------------------------------------------------
-- Clock Mux
-- -----------------------------------------------------------------------------
HCLKTRICK <= '1' when(iVICTrTCR(5) = '1')
           else
             HCLK; 

-- -----------------------------------------------------------------------------
-- VICTrIntSource Internal signal assignment
-- -----------------------------------------------------------------------------
iVICTrIntSource <= VICTrIntSource after tovmaxintsrc;

-- -----------------------------------------------------------------------------
-- nVICFIQIN and nVICIRQIN internal signals
-- -----------------------------------------------------------------------------
iVICTrIntIn(1) <= VICTrIntIn(1) after tovmaxnvicirqin;
iVICTrIntIn(0) <= VICTrIntIn(0) after tovmaxnvicfiqin;

-- -----------------------------------------------------------------------------
-- Assign 'min' and 'max' delays to the nVICFIQINREG signal
-- -----------------------------------------------------------------------------
p_TrVICFIQINREGComb : process (HCLK,HRESETn)
begin
  if (HRESETn = '0') then
    iVICTrIntInReg(0) <= '0'; 
  elsif (HCLK'event and HCLK = '1') then
    iVICTrIntInReg(0) <= VICTrIntInReg(0) ;
  else
    iVICTrIntInReg(0) <= iVICTrIntInReg(0);
  end if;
end process p_TrVICFIQINREGComb;

-- -----------------------------------------------------------------------------
-- Assign 'min' and 'max' delays to the nVICIRQINREG signal
-- -----------------------------------------------------------------------------
p_TrVICIRQINREGComb : process (HCLK,HRESETn)
begin
  if (HRESETn = '0') then
    iVICTrIntInReg(1) <= '0'; 
  elsif (HCLK'event and HCLK = '1') then
    iVICTrIntInReg(1) <= VICTrIntInReg(1) ;
  else
    iVICTrIntInReg(1) <= iVICTrIntInReg(1);
  end if;
end process p_TrVICIRQINREGComb;

-- -----------------------------------------------------------------------------
-- VICTrVectAddrIn internal signal
-- -----------------------------------------------------------------------------
iVICTrVectAddrIn <= VICTrVectAddrIn after tovmaxvectadin;

-- -----------------------------------------------------------------------------
-- VICTrSync Synchronization internal signal
-- -----------------------------------------------------------------------------
iVICTrSync <= VICTrSync after tovmaxnvicsynin;

-- -----------------------------------------------------------------------------
-- Detecting new accesses to either the VIC or the Trickbox
-- -----------------------------------------------------------------------------
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

-- -----------------------------------------------------------------------------
-- Sequential logic for the Access Enable signals
-- -----------------------------------------------------------------------------
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

-- -----------------------------------------------------------------------------
-- Samples the address if the slave is selected
-- -----------------------------------------------------------------------------
NxtAddr          <= HADDR when (NewAccess = '1')
                 else
                    Addr;

-- -----------------------------------------------------------------------------
-- Sequential logic for the internal Address bus
-- -----------------------------------------------------------------------------
p_AddrSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    Addr <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    Addr <= NxtAddr;
  end if;
end process p_AddrSeq;

-- -----------------------------------------------------------------------------
-- Bus Latch Enable signal generation
-- -----------------------------------------------------------------------------
NxtBusEn         <= '1' when (NewAccess = '1')
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Sequential logic for the Bus Latch Enable
-- -----------------------------------------------------------------------------
p_BusEnSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    BusEn <= '0';
  elsif (HCLK'event and HCLK = '1') then
    BusEn <= NxtBusEn;
  end if;
end process p_BusEnSeq;

-- -----------------------------------------------------------------------------
-- Decode the latched Address
-- -----------------------------------------------------------------------------
IntSelectEn      <= '1' when (Addr = VICTRINTSELECTADDR)
                 else
                    '0';

SwPrityMaskEn    <= '1' when (Addr = VICTRSWPRITYMASKADDR)
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

VectAddrEnA      <= '1' when (NxtAddr = VICTRVECTADADDR)
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

VectAddr16En     <= '1' when (Addr = VICTRVECTAD16ADDR)
                 else
                    '0';

VectAddr17En     <= '1' when (Addr = VICTRVECTAD17ADDR)
                 else
                    '0';

VectAddr18En     <= '1' when (Addr = VICTRVECTAD18ADDR)
                 else
                    '0';

VectAddr19En     <= '1' when (Addr = VICTRVECTAD19ADDR)
                 else
                    '0';

VectAddr20En     <= '1' when (Addr = VICTRVECTAD20ADDR)
                 else
                    '0';

VectAddr21En     <= '1' when (Addr = VICTRVECTAD21ADDR)
                 else
                    '0';

VectAddr22En     <= '1' when (Addr = VICTRVECTAD22ADDR)
                 else
                    '0';

VectAddr23En     <= '1' when (Addr = VICTRVECTAD23ADDR)
                 else
                    '0';

VectAddr24En     <= '1' when (Addr = VICTRVECTAD24ADDR)
                 else
                    '0';

VectAddr25En     <= '1' when (Addr = VICTRVECTAD25ADDR)
                 else
                    '0';

VectAddr26En     <= '1' when (Addr = VICTRVECTAD26ADDR)
                 else
                    '0';

VectAddr27En     <= '1' when (Addr = VICTRVECTAD27ADDR)
                 else
                    '0';

VectAddr28En     <= '1' when (Addr = VICTRVECTAD28ADDR)
                 else
                    '0';

VectAddr29En     <= '1' when (Addr = VICTRVECTAD29ADDR)
                 else
                    '0';

VectAddr30En     <= '1' when (Addr = VICTRVECTAD30ADDR)
                 else
                    '0';

VectAddr31En     <= '1' when (Addr = VICTRVECTAD31ADDR)
                 else
                    '0';

VectPrity0En     <= '1' when (Addr = VICTRVECTPL0PLVL)
                 else
                    '0';

VectPrity1En     <= '1' when (Addr = VICTRVECTPL1PLVL)
                 else
                    '0';

VectPrity2En     <= '1' when (Addr = VICTRVECTPL2PLVL)
                 else
                    '0';

VectPrity3En     <= '1' when (Addr = VICTRVECTPL3PLVL)
                 else
                    '0';

VectPrity4En     <= '1' when (Addr = VICTRVECTPL4PLVL)
                 else
                    '0';

VectPrity5En     <= '1' when (Addr = VICTRVECTPL5PLVL)
                 else
                    '0';

VectPrity6En     <= '1' when (Addr = VICTRVECTPL6PLVL)
                 else
                    '0';

VectPrity7En     <= '1' when (Addr = VICTRVECTPL7PLVL)
                 else
                    '0';

VectPrity8En     <= '1' when (Addr = VICTRVECTPL8PLVL)
                 else
                    '0';

VectPrity9En     <= '1' when (Addr = VICTRVECTPL9PLVL)
                 else
                    '0';

VectPrity10En    <= '1' when (Addr = VICTRVECTPL10PLVL)
                 else
                    '0';

VectPrity11En    <= '1' when (Addr = VICTRVECTPL11PLVL)
                 else
                    '0';

VectPrity12En    <= '1' when (Addr = VICTRVECTPL12PLVL)
                 else
                    '0';

VectPrity13En    <= '1' when (Addr = VICTRVECTPL13PLVL)
                 else
                    '0';

VectPrity14En    <= '1' when (Addr = VICTRVECTPL14PLVL)
                 else
                    '0';

VectPrity15En    <= '1' when (Addr = VICTRVECTPL15PLVL)
                 else
                    '0';

VectPrity16En    <= '1' when (Addr = VICTRVECTPL16PLVL)
                 else
                    '0';

VectPrity17En    <= '1' when (Addr = VICTRVECTPL17PLVL)
                 else
                    '0';

VectPrity18En    <= '1' when (Addr = VICTRVECTPL18PLVL)
                 else
                    '0';

VectPrity19En    <= '1' when (Addr = VICTRVECTPL19PLVL)
                 else
                    '0';

VectPrity20En    <= '1' when (Addr = VICTRVECTPL20PLVL)
                 else
                    '0';

VectPrity21En    <= '1' when (Addr = VICTRVECTPL21PLVL)
                 else
                    '0';

VectPrity22En    <= '1' when (Addr = VICTRVECTPL22PLVL)
                 else
                    '0';

VectPrity23En    <= '1' when (Addr = VICTRVECTPL23PLVL)
                 else
                    '0';

VectPrity24En    <= '1' when (Addr = VICTRVECTPL24PLVL)
                 else
                    '0';

VectPrity25En    <= '1' when (Addr = VICTRVECTPL25PLVL)
                 else
                    '0';

VectPrity26En    <= '1' when (Addr = VICTRVECTPL26PLVL)
                 else
                    '0';

VectPrity27En    <= '1' when (Addr = VICTRVECTPL27PLVL)
                 else
                    '0';

VectPrity28En    <= '1' when (Addr = VICTRVECTPL28PLVL)
                 else
                    '0';

VectPrity29En    <= '1' when (Addr = VICTRVECTPL29PLVL)
                 else
                    '0';

VectPrity30En    <= '1' when (Addr = VICTRVECTPL30PLVL)
                 else
                    '0';

VectPrity31En    <= '1' when (Addr = VICTRVECTPL31PLVL)
                 else
                    '0';

VectPrityDsyEn    <= '1' when (Addr = VICTRVECTPLDSYPLVL)
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

TrIntInRegEn     <= '1' when (Addr = VICTRINTINREGADDR)
                 else
                    '0';

TrSyncEn         <= '1' when (Addr = VICTRSYNCADDR)
                 else
                    '0';

TrAckCntEn       <= '1' when (Addr = VICTRACKCNTADDR)
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
-- -----------------------------------------------------------------------------
-- Generates Read Access Enable Signals
-- -----------------------------------------------------------------------------
IntSelectRdEn    <= IntSelectEn and RdAccess;

SwPrityMaskRdEn  <= SwPrityMaskEn and RdAccess;

IntEnableRdEn    <= IntEnableEn and RdAccess;

SoftIntRdEn      <= SoftIntEn and RdAccess;

ProtectionRdEn   <= ProtectionEn and RdAccess;

VectAddrRdEn     <= VectAddrEn and RdAccess;

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

VectAddr16RdEn   <= VectAddr16En and RdAccess;

VectAddr17RdEn   <= VectAddr17En and RdAccess;

VectAddr18RdEn   <= VectAddr18En and RdAccess;

VectAddr19RdEn   <= VectAddr19En and RdAccess;

VectAddr20RdEn   <= VectAddr20En and RdAccess;

VectAddr21RdEn   <= VectAddr21En and RdAccess;

VectAddr22RdEn   <= VectAddr22En and RdAccess;

VectAddr23RdEn   <= VectAddr23En and RdAccess;

VectAddr24RdEn   <= VectAddr24En and RdAccess;

VectAddr25RdEn   <= VectAddr25En and RdAccess;

VectAddr26RdEn   <= VectAddr26En and RdAccess;

VectAddr27RdEn   <= VectAddr27En and RdAccess;

VectAddr28RdEn   <= VectAddr28En and RdAccess;

VectAddr29RdEn   <= VectAddr29En and RdAccess;

VectAddr30RdEn   <= VectAddr30En and RdAccess;

VectAddr31RdEn   <= VectAddr31En and RdAccess;

VectPrity0RdEn   <= VectPrity0En and RdAccess;

VectPrity1RdEn   <= VectPrity1En and RdAccess;

VectPrity2RdEn   <= VectPrity2En and RdAccess;

VectPrity3RdEn   <= VectPrity3En and RdAccess;

VectPrity4RdEn   <= VectPrity4En and RdAccess;

VectPrity5RdEn   <= VectPrity5En and RdAccess;

VectPrity6RdEn   <= VectPrity6En and RdAccess;

VectPrity7RdEn   <= VectPrity7En and RdAccess;

VectPrity8RdEn   <= VectPrity8En and RdAccess;

VectPrity9RdEn   <= VectPrity9En and RdAccess;

VectPrity10RdEn  <= VectPrity10En and RdAccess;

VectPrity11RdEn  <= VectPrity11En and RdAccess;

VectPrity12RdEn  <= VectPrity12En and RdAccess;

VectPrity13RdEn  <= VectPrity13En and RdAccess;

VectPrity14RdEn  <= VectPrity14En and RdAccess;

VectPrity15RdEn  <= VectPrity15En and RdAccess;

VectPrity16RdEn  <= VectPrity16En and RdAccess;

VectPrity17RdEn  <= VectPrity17En and RdAccess;

VectPrity18RdEn  <= VectPrity18En and RdAccess;

VectPrity19RdEn  <= VectPrity19En and RdAccess;

VectPrity20RdEn  <= VectPrity20En and RdAccess;

VectPrity21RdEn  <= VectPrity21En and RdAccess;

VectPrity22RdEn  <= VectPrity22En and RdAccess;

VectPrity23RdEn  <= VectPrity23En and RdAccess;

VectPrity24RdEn  <= VectPrity24En and RdAccess;

VectPrity25RdEn  <= VectPrity25En and RdAccess;

VectPrity26RdEn  <= VectPrity26En and RdAccess;

VectPrity27RdEn  <= VectPrity27En and RdAccess;

VectPrity28RdEn  <= VectPrity28En and RdAccess;

VectPrity29RdEn  <= VectPrity29En and RdAccess;

VectPrity30RdEn  <= VectPrity30En and RdAccess;

VectPrity31RdEn  <= VectPrity31En and RdAccess;

VectPrityDsyRdEn <= VectPrityDsyEn and RdAccess;

VICTrTCRRdEn     <= VICTrTCREn and RdAccess;

TrIntSrcRdEn     <= TrIntSourceEn and RdAccess;

IntStatRdEn      <= TrStatusEn and RdAccess;

TrIntInRdEn      <= TrIntInEn and RdAccess;

TrIntInRegRdEn   <= TrIntInRegEn and RdAccess;

TrSyncRdEn       <= TrSyncEn and RdAccess;

TrAckCntRdEn     <= TrAckCntEn and RdAccess;

TrVectAdInRdEn   <= TrVectAdInEn and RdAccess;

TrVectAdOutRdEn  <= TrVectAdOutEn and RdAccess;

-- -----------------------------------------------------------------------------
-- Generates Write Access Enable Signals
-- -----------------------------------------------------------------------------
IntSelectWrEn    <= IntSelectEn and MrWrAccess;

SwPrityMaskWrEn  <= SwPrityMaskEn and MrWrAccess;

IntEnableWrEn    <= IntEnableEn and MrWrAccess;

IntEnClearWrEn   <= IntEnClearEn and MrWrAccess;

SoftIntWrEn      <= SoftIntEn and MrWrAccess;

SoftIntClearWrEn <= SoftIntClearEn and MrWrAccess;

ProtectionWrEn   <= ProtectionEn and MrWrAccess;

VectAddrWrEn     <= VectAddrEn and MrWrAccesstmp;

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

VectAddr16WrEn   <= VectAddr16En and MrWrAccess;

VectAddr17WrEn   <= VectAddr17En and MrWrAccess;

VectAddr18WrEn   <= VectAddr18En and MrWrAccess;

VectAddr19WrEn   <= VectAddr19En and MrWrAccess;

VectAddr20WrEn   <= VectAddr20En and MrWrAccess;

VectAddr21WrEn   <= VectAddr21En and MrWrAccess;

VectAddr22WrEn   <= VectAddr22En and MrWrAccess;

VectAddr23WrEn   <= VectAddr23En and MrWrAccess;

VectAddr24WrEn   <= VectAddr24En and MrWrAccess;

VectAddr25WrEn   <= VectAddr25En and MrWrAccess;

VectAddr26WrEn   <= VectAddr26En and MrWrAccess;

VectAddr27WrEn   <= VectAddr27En and MrWrAccess;

VectAddr28WrEn   <= VectAddr28En and MrWrAccess;

VectAddr29WrEn   <= VectAddr29En and MrWrAccess;

VectAddr30WrEn   <= VectAddr30En and MrWrAccess;

VectAddr31WrEn   <= VectAddr31En and MrWrAccess;

VectPrity0WrEn   <= VectPrity0En and MrWrAccess;

VectPrity1WrEn   <= VectPrity1En and MrWrAccess;

VectPrity2WrEn   <= VectPrity2En and MrWrAccess;

VectPrity3WrEn   <= VectPrity3En and MrWrAccess;

VectPrity4WrEn   <= VectPrity4En and MrWrAccess;

VectPrity5WrEn   <= VectPrity5En and MrWrAccess;

VectPrity6WrEn   <= VectPrity6En and MrWrAccess;

VectPrity7WrEn   <= VectPrity7En and MrWrAccess;

VectPrity8WrEn   <= VectPrity8En and MrWrAccess;

VectPrity9WrEn   <= VectPrity9En and MrWrAccess;

VectPrity10WrEn  <= VectPrity10En and MrWrAccess;

VectPrity11WrEn  <= VectPrity11En and MrWrAccess;

VectPrity12WrEn  <= VectPrity12En and MrWrAccess;

VectPrity13WrEn  <= VectPrity13En and MrWrAccess;

VectPrity14WrEn  <= VectPrity14En and MrWrAccess;

VectPrity15WrEn  <= VectPrity15En and MrWrAccess;

VectPrity16WrEn  <= VectPrity16En and MrWrAccess;

VectPrity17WrEn  <= VectPrity17En and MrWrAccess;

VectPrity18WrEn  <= VectPrity18En and MrWrAccess;

VectPrity19WrEn  <= VectPrity19En and MrWrAccess;

VectPrity20WrEn  <= VectPrity20En and MrWrAccess;

VectPrity21WrEn  <= VectPrity21En and MrWrAccess;

VectPrity22WrEn  <= VectPrity22En and MrWrAccess;

VectPrity23WrEn  <= VectPrity23En and MrWrAccess;

VectPrity24WrEn  <= VectPrity24En and MrWrAccess;

VectPrity25WrEn  <= VectPrity25En and MrWrAccess;

VectPrity26WrEn  <= VectPrity26En and MrWrAccess;

VectPrity27WrEn  <= VectPrity27En and MrWrAccess;

VectPrity28WrEn  <= VectPrity28En and MrWrAccess;

VectPrity29WrEn  <= VectPrity29En and MrWrAccess;

VectPrity30WrEn  <= VectPrity30En and MrWrAccess;

VectPrity31WrEn  <= VectPrity31En and MrWrAccess;

VectPrityDsyWrEn <= VectPrityDsyEn and MrWrAccess;

VICTrTCRWrEn     <= VICTrTCREn and WrAccess;

TrIntSrcWrEn     <= TrIntSourceEn and WrAccess;

TrIntInWrEn      <= TrIntInEn and WrAccess;

TrIntInRegWrEn   <= TrIntInRegEn and WrAccess;

TrVectAdInWrEn   <= TrVectAdInEn and WrAccess;

TrSyncWrEn       <= TrSyncEn and WrAccess;

TrAckCntWrEn     <= TrAckCntEn and WrAccess;

-- -----------------------------------------------------------------------------
-- Read and Write Trigger to Mirrored trickbox to indicate the read and write
-- on VICADDRESS register(uut).
-- -----------------------------------------------------------------------------
iVectAddrRdTrig <= VectAddrEn and MrRdAccess;
iVectAddrWrTrig <= VectAddrWrEn;
AsyncRdEn       <= VectAddrEnA and NxtMrRdAccess;
VectAddrRdTrig  <= iVectAddrRdTrig;
VectAddrWrTrig  <= iVectAddrWrTrig;
MrRdAccesstmp   <= MrRdAccess;
MrWrAccesstmp   <= MrWrAccess;
-- -----------------------------------------------------------------------------
-- Combinational logic for all writeable registers.
--
-- When the respective write enable input is asserted, copy the contents
-- of the HWDATA bus into the corresponding registers.
-- -----------------------------------------------------------------------------
NxtTrIntSelect   <= HWDATA when (IntSelectWrEn = '1')
                 else
                    iVICTrIntSelect;

NxtTrSwPrityMask <= HWDATA(15 downto 0) when (SwPrityMaskWrEn = '1')
                 else
                    iVICTrSwPriMask;

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

NxtTrVectAddr16  <= HWDATA when (VectAddr16WrEn = '1')
                 else
                    iVICTrVectAddr16;

NxtTrVectAddr17  <= HWDATA when (VectAddr17WrEn = '1')
                 else
                    iVICTrVectAddr17;

NxtTrVectAddr18  <= HWDATA when (VectAddr18WrEn = '1')
                 else
                    iVICTrVectAddr18;

NxtTrVectAddr19  <= HWDATA when (VectAddr19WrEn = '1')
                 else
                    iVICTrVectAddr19;

NxtTrVectAddr20  <= HWDATA when (VectAddr20WrEn = '1')
                 else
                    iVICTrVectAddr20;

NxtTrVectAddr21  <= HWDATA when (VectAddr21WrEn = '1')
                 else
                    iVICTrVectAddr21;

NxtTrVectAddr22  <= HWDATA when (VectAddr22WrEn = '1')
                 else
                    iVICTrVectAddr22;

NxtTrVectAddr23  <= HWDATA when (VectAddr23WrEn = '1')
                 else
                    iVICTrVectAddr23;

NxtTrVectAddr24  <= HWDATA when (VectAddr24WrEn = '1')
                 else
                    iVICTrVectAddr24;

NxtTrVectAddr25  <= HWDATA when (VectAddr25WrEn = '1')
                 else
                    iVICTrVectAddr25;

NxtTrVectAddr26  <= HWDATA when (VectAddr26WrEn = '1')
                 else
                    iVICTrVectAddr26;

NxtTrVectAddr27  <= HWDATA when (VectAddr27WrEn = '1')
                 else
                    iVICTrVectAddr27;

NxtTrVectAddr28  <= HWDATA when (VectAddr28WrEn = '1')
                 else
                    iVICTrVectAddr28;

NxtTrVectAddr29  <= HWDATA when (VectAddr29WrEn = '1')
                 else
                    iVICTrVectAddr29;

NxtTrVectAddr30  <= HWDATA when (VectAddr30WrEn = '1')
                 else
                    iVICTrVectAddr30;

NxtTrVectAddr31  <= HWDATA when (VectAddr31WrEn = '1')
                 else
                    iVICTrVectAddr31;

NxtTrVectPrity0  <= HWDATA(3 downto 0) when (VectPrity0WrEn = '1')
                 else
                    iVICTrVectPrity0;

NxtTrVectPrity1  <= HWDATA(3 downto 0) when (VectPrity1WrEn = '1')
                 else
                    iVICTrVectPrity1;

NxtTrVectPrity2  <= HWDATA(3 downto 0) when (VectPrity2WrEn = '1')
                 else
                    iVICTrVectPrity2;

NxtTrVectPrity3  <= HWDATA(3 downto 0) when (VectPrity3WrEn = '1')
                 else
                    iVICTrVectPrity3;

NxtTrVectPrity4  <= HWDATA(3 downto 0) when (VectPrity4WrEn = '1')
                 else
                    iVICTrVectPrity4;

NxtTrVectPrity5  <= HWDATA(3 downto 0) when (VectPrity5WrEn = '1')
                 else
                    iVICTrVectPrity5;

NxtTrVectPrity6  <= HWDATA(3 downto 0) when (VectPrity6WrEn = '1')
                 else
                    iVICTrVectPrity6;

NxtTrVectPrity7  <= HWDATA(3 downto 0) when (VectPrity7WrEn = '1')
                 else
                    iVICTrVectPrity7;

NxtTrVectPrity8  <= HWDATA(3 downto 0) when (VectPrity8WrEn = '1')
                 else
                    iVICTrVectPrity8;

NxtTrVectPrity9  <= HWDATA(3 downto 0) when (VectPrity9WrEn = '1')
                 else
                    iVICTrVectPrity9;

NxtTrVectPrity10 <= HWDATA(3 downto 0) when (VectPrity10WrEn = '1')
                 else
                    iVICTrVectPrity10;

NxtTrVectPrity11 <= HWDATA(3 downto 0) when (VectPrity11WrEn = '1')
                 else
                    iVICTrVectPrity11;

NxtTrVectPrity12 <= HWDATA(3 downto 0) when (VectPrity12WrEn = '1')
                 else
                    iVICTrVectPrity12;

NxtTrVectPrity13 <= HWDATA(3 downto 0) when (VectPrity13WrEn = '1')
                 else
                    iVICTrVectPrity13;

NxtTrVectPrity14 <= HWDATA(3 downto 0) when (VectPrity14WrEn = '1')
                 else
                    iVICTrVectPrity14;

NxtTrVectPrity15  <= HWDATA(3 downto 0) when (VectPrity15WrEn = '1')
                 else
                    iVICTrVectPrity15;

NxtTrVectPrity16 <= HWDATA(3 downto 0) when (VectPrity16WrEn = '1')
                 else
                    iVICTrVectPrity16;

NxtTrVectPrity17 <= HWDATA(3 downto 0) when (VectPrity17WrEn = '1')
                 else
                    iVICTrVectPrity17;

NxtTrVectPrity18 <= HWDATA(3 downto 0) when (VectPrity18WrEn = '1')
                 else
                    iVICTrVectPrity18;

NxtTrVectPrity19 <= HWDATA(3 downto 0) when (VectPrity19WrEn = '1')
                 else
                    iVICTrVectPrity19;

NxtTrVectPrity20 <= HWDATA(3 downto 0) when (VectPrity20WrEn = '1')
                 else
                    iVICTrVectPrity20;

NxtTrVectPrity21 <= HWDATA(3 downto 0) when (VectPrity21WrEn = '1')
                 else
                    iVICTrVectPrity21;

NxtTrVectPrity22 <= HWDATA(3 downto 0) when (VectPrity22WrEn = '1')
                 else
                    iVICTrVectPrity22;

NxtTrVectPrity23 <= HWDATA(3 downto 0) when (VectPrity23WrEn = '1')
                 else
                    iVICTrVectPrity23;

NxtTrVectPrity24 <= HWDATA(3 downto 0) when (VectPrity24WrEn = '1')
                 else
                    iVICTrVectPrity24;

NxtTrVectPrity25 <= HWDATA(3 downto 0) when (VectPrity25WrEn = '1')
                 else
                    iVICTrVectPrity25;

NxtTrVectPrity26 <= HWDATA(3 downto 0) when (VectPrity26WrEn = '1')
                 else
                    iVICTrVectPrity26;

NxtTrVectPrity27 <= HWDATA(3 downto 0) when (VectPrity27WrEn = '1')
                 else
                    iVICTrVectPrity27;

NxtTrVectPrity28 <= HWDATA(3 downto 0) when (VectPrity28WrEn = '1')
                 else
                    iVICTrVectPrity28;

NxtTrVectPrity29 <= HWDATA(3 downto 0) when (VectPrity29WrEn = '1')
                 else
                    iVICTrVectPrity29;

NxtTrVectPrity30 <= HWDATA(3 downto 0) when (VectPrity30WrEn = '1')
                 else
                    iVICTrVectPrity30;

NxtTrVectPrity31 <= HWDATA(3 downto 0) when (VectPrity31WrEn = '1')
                 else
                    iVICTrVectPrity31;

NxtTrVectPrityDsy <= HWDATA(3 downto 0) when (VectPrityDsyWrEn = '1')
                 else
                    iVICTrVectPriDsy;

NxtVICTrTCR      <= HWDATA(8 downto 0) when (VICTrTCRWrEn = '1')
                 else
                    iVICTrTCR;

NxtTrIntSource   <= HWDATA when (TrIntSrcWrEn = '1')
                 else
                    VICTrIntSource;

NxtTrIntIn       <= HWDATA(1 downto 0) when (TrIntInWrEn = '1')
                 else
                    VICTrIntIn;

NxtTrIntInReg    <= HWDATA(1 downto 0) when (TrIntInRegWrEn = '1')
                 else
                    VICTrIntInReg;

NxtTrVectAddrIn  <= HWDATA when (TrVectAdInWrEn = '1')
                 else
                    VICTrVectAddrIn;

NxtTrSync        <= HWDATA(0) when (TrSyncWrEn = '1')
                 else
                    VICTrSync;

NxtTrAckCnt      <= HWDATA(2 downto 0) when (TrAckCntWrEn = '1')
                 else
                    VICTrAckCnt;

-- -----------------------------------------------------------------------------
-- Sequential logic for VICTrIntSelect, VICTrIntEnable, VICTrSoftInt,
-- VICTrProtection 
-- -----------------------------------------------------------------------------
p_TrIntRegSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    iVICTrIntSelect  <= (others => '0');
    iVICTrIntEnable  <= (others => '0');
    iVICTrSoftInt    <= (others => '0');
    iVICTrSwPriMask  <= (others => '1');
    VICTrProtection  <= '0';
  elsif (HCLK'event and HCLK = '1') then
    iVICTrIntSelect  <= NxtTrIntSelect;
    iVICTrIntEnable  <= NxtTrIntEnable;
    iVICTrSwPriMask  <= NxtTrSwPrityMask;
    iVICTrSoftInt    <= NxtTrSoftInt;
    VICTrProtection  <= NxtTrProtection;
  end if;
end process p_TrIntRegSeq;

-- -----------------------------------------------------------------------------
-- Sequential logic for the VICrVectAddr registers
-- -----------------------------------------------------------------------------
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
    iVICTrVectAddr16 <= (others => '0');
    iVICTrVectAddr17 <= (others => '0');
    iVICTrVectAddr18 <= (others => '0');
    iVICTrVectAddr19 <= (others => '0');
    iVICTrVectAddr20 <= (others => '0');
    iVICTrVectAddr21 <= (others => '0');
    iVICTrVectAddr22 <= (others => '0');
    iVICTrVectAddr23 <= (others => '0');
    iVICTrVectAddr24 <= (others => '0');
    iVICTrVectAddr25 <= (others => '0');
    iVICTrVectAddr26 <= (others => '0');
    iVICTrVectAddr27 <= (others => '0');
    iVICTrVectAddr28 <= (others => '0');
    iVICTrVectAddr29 <= (others => '0');
    iVICTrVectAddr30 <= (others => '0');
    iVICTrVectAddr31 <= (others => '0');
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
    iVICTrVectAddr16 <= NxtTrVectAddr16;
    iVICTrVectAddr17 <= NxtTrVectAddr17;
    iVICTrVectAddr18 <= NxtTrVectAddr18;
    iVICTrVectAddr19 <= NxtTrVectAddr19;
    iVICTrVectAddr20 <= NxtTrVectAddr20;
    iVICTrVectAddr21 <= NxtTrVectAddr21;
    iVICTrVectAddr22 <= NxtTrVectAddr22;
    iVICTrVectAddr23 <= NxtTrVectAddr23;
    iVICTrVectAddr24 <= NxtTrVectAddr24;
    iVICTrVectAddr25 <= NxtTrVectAddr25;
    iVICTrVectAddr26 <= NxtTrVectAddr26;
    iVICTrVectAddr27 <= NxtTrVectAddr27;
    iVICTrVectAddr28 <= NxtTrVectAddr28;
    iVICTrVectAddr29 <= NxtTrVectAddr29;
    iVICTrVectAddr30 <= NxtTrVectAddr30;
    iVICTrVectAddr31 <= NxtTrVectAddr31;
  end if;
end process p_TrVectAddrSeq;

-- -----------------------------------------------------------------------------
-- Sequential logic for the VICTrVectPrity registers
-- -----------------------------------------------------------------------------
p_TrVectPritySeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    iVICTrVectPrity0  <= (others => '1');
    iVICTrVectPrity1  <= (others => '1');
    iVICTrVectPrity2  <= (others => '1');
    iVICTrVectPrity3  <= (others => '1');
    iVICTrVectPrity4  <= (others => '1');
    iVICTrVectPrity5  <= (others => '1');
    iVICTrVectPrity6  <= (others => '1');
    iVICTrVectPrity7  <= (others => '1');
    iVICTrVectPrity8  <= (others => '1');
    iVICTrVectPrity9  <= (others => '1');
    iVICTrVectPrity10 <= (others => '1');
    iVICTrVectPrity11 <= (others => '1');
    iVICTrVectPrity12 <= (others => '1');
    iVICTrVectPrity13 <= (others => '1');
    iVICTrVectPrity14 <= (others => '1');
    iVICTrVectPrity15 <= (others => '1');
    iVICTrVectPrity16 <= (others => '1');
    iVICTrVectPrity17 <= (others => '1');
    iVICTrVectPrity18 <= (others => '1');
    iVICTrVectPrity19 <= (others => '1');
    iVICTrVectPrity20 <= (others => '1');
    iVICTrVectPrity21 <= (others => '1');
    iVICTrVectPrity22 <= (others => '1');
    iVICTrVectPrity23 <= (others => '1');
    iVICTrVectPrity24 <= (others => '1');
    iVICTrVectPrity25 <= (others => '1');
    iVICTrVectPrity26 <= (others => '1');
    iVICTrVectPrity27 <= (others => '1');
    iVICTrVectPrity28 <= (others => '1');
    iVICTrVectPrity29 <= (others => '1');
    iVICTrVectPrity30 <= (others => '1');
    iVICTrVectPrity31 <= (others => '1');
    iVICTrVectPriDsy  <= (others => '1');
  elsif (HCLK'event and HCLK = '1') then
    iVICTrVectPrity0  <= NxtTrVectPrity0;
    iVICTrVectPrity1  <= NxtTrVectPrity1;
    iVICTrVectPrity2  <= NxtTrVectPrity2;
    iVICTrVectPrity3  <= NxtTrVectPrity3;
    iVICTrVectPrity4  <= NxtTrVectPrity4;
    iVICTrVectPrity5  <= NxtTrVectPrity5;
    iVICTrVectPrity6  <= NxtTrVectPrity6;
    iVICTrVectPrity7  <= NxtTrVectPrity7;
    iVICTrVectPrity8  <= NxtTrVectPrity8;
    iVICTrVectPrity9  <= NxtTrVectPrity9;
    iVICTrVectPrity10 <= NxtTrVectPrity10;
    iVICTrVectPrity11 <= NxtTrVectPrity11;
    iVICTrVectPrity12 <= NxtTrVectPrity12;
    iVICTrVectPrity13 <= NxtTrVectPrity13;
    iVICTrVectPrity14 <= NxtTrVectPrity14;
    iVICTrVectPrity15 <= NxtTrVectPrity15;
    iVICTrVectPrity16 <= NxtTrVectPrity16;
    iVICTrVectPrity17 <= NxtTrVectPrity17;
    iVICTrVectPrity18 <= NxtTrVectPrity18;
    iVICTrVectPrity19 <= NxtTrVectPrity19;
    iVICTrVectPrity20 <= NxtTrVectPrity20;
    iVICTrVectPrity21 <= NxtTrVectPrity21;
    iVICTrVectPrity22 <= NxtTrVectPrity22;
    iVICTrVectPrity23 <= NxtTrVectPrity23;
    iVICTrVectPrity24 <= NxtTrVectPrity24;
    iVICTrVectPrity25 <= NxtTrVectPrity25;
    iVICTrVectPrity26 <= NxtTrVectPrity26;
    iVICTrVectPrity27 <= NxtTrVectPrity27;
    iVICTrVectPrity28 <= NxtTrVectPrity28;
    iVICTrVectPrity29 <= NxtTrVectPrity29;
    iVICTrVectPrity30 <= NxtTrVectPrity30;
    iVICTrVectPrity31 <= NxtTrVectPrity31;
    iVICTrVectPriDsy  <= NxtTrVectPrityDsy;
  end if;
end process p_TrVectPritySeq;

-- -----------------------------------------------------------------------------
-- Sequential logic for VICTrTCR, VICTrIntSource, VICTrIntIn and
-- VICTrVectAddrIn
-- -----------------------------------------------------------------------------
p_TrRegSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    iVICTrTCR       <= (others => '0');
    VICTrIntSource  <= (others => '0');
    VICTrIntIn      <= (others => '1');
    VICTrIntInReg   <= (others => '0');
    VICTrVectAddrIn <= (others => '0');
    VICTrSync       <= '1';
    VICTrAckCnt     <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    iVICTrTCR       <= NxtVICTrTCR;
    VICTrIntSource  <= NxtTrIntSource;
    VICTrIntIn      <= NxtTrIntIn;
    VICTrIntInReg   <= NxtTrIntInReg;
    VICTrVectAddrIn <= NxtTrVectAddrIn;
    VICTrSync       <= NxtTrSync;
    VICTrAckCnt     <= NxtTrAckCnt;
  end if;
end process p_TrRegSeq;

-- -----------------------------------------------------------------------------
-- Acknowledge generation. VICTrAckCnt register can be programmed to delay the
-- acknowledge signal generation for vic port handshake. The signal is delayed
-- based on the count loaded in the register
-- -----------------------------------------------------------------------------
p_TrAckSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    VICTrAckCnt1 <= '0';
    VICTrAckCnt2 <= '0';
    VICTrAckCnt3 <= '0';
    VICTrAckCnt4 <= '0';
    VICTrAckCnt5 <= '0';
    VICTrAckCnt6 <= '0';
    VICTrAckCnt7 <= '0';
  elsif (HCLK'event and HCLK = '1') then
    if (nVICIRQ = '0') then
      VICTrAckCnt1 <= VICTrAckCnt(2) or VICTrAckCnt(1) or VICTrAckCnt(0);
      VICTrAckCnt2 <= VICTrAckCnt1;
      VICTrAckCnt3 <= VICTrAckCnt2;
      VICTrAckCnt4 <= VICTrAckCnt3;
      VICTrAckCnt5 <= VICTrAckCnt4;
      VICTrAckCnt6 <= VICTrAckCnt5;
      VICTrAckCnt7 <= VICTrAckCnt6;
    else
      VICTrAckCnt1 <= '0';
      VICTrAckCnt2 <= '0';
      VICTrAckCnt3 <= '0';
      VICTrAckCnt4 <= '0';
      VICTrAckCnt5 <= '0';
      VICTrAckCnt6 <= '0';
      VICTrAckCnt7 <= '0';
    end if;
  end if;
end process p_TrAckSeq;

-- -----------------------------------------------------------------------------
-- Multiplexing RdData1 bus
-- -----------------------------------------------------------------------------
RdData1          <= iVICTrIntSelect when (IntSelectRdEn = '1')
                 else
                    ZEROFILL(31 downto 16) & iVICTrSwPriMask when 
                                          (SwPrityMaskRdEn = '1')
                 else
                    iVICTrIntEnable when (IntEnableRdEn = '1')
                 else
                    iVICTrSoftInt when (SoftIntRdEn = '1')
                 else
                    VICTrVectAddr when (VectAddrRdEn = '1')
                 else
                    ZEROFILL(31 downto 9) & iVICTrTCR when
                                        (VICTrTCRRdEn = '1')
                 else
                    iVICTrIntSource when (TrIntSrcRdEn = '1')
                 else
                    ZEROFILL(31 downto 2) & nVICFIQ & nVICIRQ when
                                        (IntStatRdEn = '1')
                 else
                    ZEROFILL(31 downto 2) & VICTrIntIn when
                                        (TrIntInRdEn = '1')
                 else
                    ZEROFILL(31 downto 2) & VICTrIntInReg when
                                        (TrIntInRdEn = '1')
                 else
                    ZEROFILL(31 downto 1) & VICTrSync when
                                        (TrIntInRdEn = '1')
                 else
                    ZEROFILL(31 downto 3) & VICTrAckCnt when
                                        (TrIntInRdEn = '1')
                 else
                    iVICTrVectAddrIn when (TrVectAdInRdEn = '1')
                 else
                    VICVECTADDROUT when (TrVectAdOutRdEn = '1')
                 else
                    Data5 when (WaitCount = WAITSTATES)
                 else
                    (others => '0');

-- -----------------------------------------------------------------------------
-- Multiplexing RdData2 bus
-- -----------------------------------------------------------------------------
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
                    iVICTrVectAddr16 when (VectAddr16RdEn = '1')
                 else
                    iVICTrVectAddr17 when (VectAddr17RdEn = '1')
                 else
                    iVICTrVectAddr18 when (VectAddr18RdEn = '1')
                 else
                    iVICTrVectAddr19 when (VectAddr19RdEn = '1')
                 else
                    iVICTrVectAddr20 when (VectAddr20RdEn = '1')
                 else
                    iVICTrVectAddr21 when (VectAddr21RdEn = '1')
                 else
                    iVICTrVectAddr22 when (VectAddr22RdEn = '1')
                 else
                    iVICTrVectAddr23 when (VectAddr23RdEn = '1')
                 else
                    iVICTrVectAddr24 when (VectAddr24RdEn = '1')
                 else
                    iVICTrVectAddr25 when (VectAddr25RdEn = '1')
                 else
                    iVICTrVectAddr26 when (VectAddr26RdEn = '1')
                 else
                    iVICTrVectAddr27 when (VectAddr27RdEn = '1')
                 else
                    iVICTrVectAddr28 when (VectAddr28RdEn = '1')
                 else
                    iVICTrVectAddr29 when (VectAddr29RdEn = '1')
                 else
                    iVICTrVectAddr30 when (VectAddr30RdEn = '1')
                 else
                    iVICTrVectAddr31 when (VectAddr31RdEn = '1')
                 else
                    (others => '0');

-- -----------------------------------------------------------------------------
-- Multiplexing RdData3 bus
-- -----------------------------------------------------------------------------
RdData3          <= ZEROFILL(31 downto 4) & iVICTrVectPrity0 when
                                          (VectPrity0RdEn = '1')
                 else
                    ZEROFILL(31 downto 4) & iVICTrVectPrity1 when
                                          (VectPrity1RdEn = '1')
                 else
                    ZEROFILL(31 downto 4) & iVICTrVectPrity2 when
                                          (VectPrity2RdEn = '1')
                 else
                    ZEROFILL(31 downto 4) & iVICTrVectPrity3 when
                                          (VectPrity3RdEn = '1')
                 else
                    ZEROFILL(31 downto 4) & iVICTrVectPrity4 when
                                          (VectPrity4RdEn = '1')
                 else
                    ZEROFILL(31 downto 4) & iVICTrVectPrity5 when
                                          (VectPrity5RdEn = '1')
                 else
                    ZEROFILL(31 downto 4) & iVICTrVectPrity6 when
                                          (VectPrity6RdEn = '1')
                 else
                    ZEROFILL(31 downto 4) & iVICTrVectPrity7 when
                                          (VectPrity7RdEn = '1')
                 else
                    ZEROFILL(31 downto 4) & iVICTrVectPrity8 when
                                          (VectPrity8RdEn = '1')
                 else
                    ZEROFILL(31 downto 4) & iVICTrVectPrity9 when
                                          (VectPrity9RdEn = '1')
                 else
                    ZEROFILL(31 downto 4) & iVICTrVectPrity10 when
                                          (VectPrity10RdEn = '1')
                 else
                    ZEROFILL(31 downto 4) & iVICTrVectPrity11 when
                                          (VectPrity11RdEn = '1')
                 else
                    ZEROFILL(31 downto 4) & iVICTrVectPrity12 when
                                          (VectPrity12RdEn = '1')
                 else
                    ZEROFILL(31 downto 4) & iVICTrVectPrity13 when
                                          (VectPrity13RdEn = '1')
                 else
                    ZEROFILL(31 downto 4) & iVICTrVectPrity14 when
                                          (VectPrity14RdEn = '1')
                 else
                    ZEROFILL(31 downto 4) & iVICTrVectPrity15 when
                                          (VectPrity15RdEn = '1')
                 else
                    ZEROFILL(31 downto 4) & iVICTrVectPrity16 when
                                          (VectPrity16RdEn = '1')
                 else
                    ZEROFILL(31 downto 4) & iVICTrVectPrity17 when
                                          (VectPrity17RdEn = '1')
                 else
                    ZEROFILL(31 downto 4) & iVICTrVectPrity18 when
                                          (VectPrity18RdEn = '1')
                 else
                    ZEROFILL(31 downto 4) & iVICTrVectPrity19 when
                                          (VectPrity19RdEn = '1')
                 else
                    ZEROFILL(31 downto 4) & iVICTrVectPrity20 when
                                          (VectPrity20RdEn = '1')
                 else
                    ZEROFILL(31 downto 4) & iVICTrVectPrity21 when
                                          (VectPrity21RdEn = '1')
                 else
                    ZEROFILL(31 downto 4) & iVICTrVectPrity22 when
                                          (VectPrity22RdEn = '1')
                 else
                    ZEROFILL(31 downto 4) & iVICTrVectPrity23 when
                                          (VectPrity23RdEn = '1')
                 else
                    ZEROFILL(31 downto 4) & iVICTrVectPrity24 when
                                          (VectPrity24RdEn = '1')
                 else
                    ZEROFILL(31 downto 4) & iVICTrVectPrity25 when
                                          (VectPrity25RdEn = '1')
                 else
                    ZEROFILL(31 downto 4) & iVICTrVectPrity26 when
                                          (VectPrity26RdEn = '1')
                 else
                    ZEROFILL(31 downto 4) & iVICTrVectPrity27 when
                                          (VectPrity27RdEn = '1')
                 else
                    ZEROFILL(31 downto 4) & iVICTrVectPrity28 when
                                          (VectPrity28RdEn = '1')
                 else
                    ZEROFILL(31 downto 4) & iVICTrVectPrity29 when
                                          (VectPrity29RdEn = '1')
                 else
                    ZEROFILL(31 downto 4) & iVICTrVectPrity30 when
                                          (VectPrity30RdEn = '1')
                 else
                    ZEROFILL(31 downto 4) & iVICTrVectPrity31 when
                                          (VectPrity31RdEn = '1')
                 else
                    (others => '0');

-- -----------------------------------------------------------------------------
-- Assigning Internal Read Data bus
-- -----------------------------------------------------------------------------
RdData           <= (RdData1 or RdData2 or RdData3);

-- -----------------------------------------------------------------------------
-- Inserting Wait States
-- -----------------------------------------------------------------------------
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

-- -----------------------------------------------------------------------------
-- HREADYOUT Generation
-- -----------------------------------------------------------------------------
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

-- -----------------------------------------------------------------------------
-- AHB Output Assignments
-- -----------------------------------------------------------------------------
HRDATA           <= RdData when (RdAccess = '1')
                 else
                    (others => '0');

HRESP            <= TR_H_OKAY;

-- -----------------------------------------------------------------------------
-- Assign local copies of signals to the outputs
-- -----------------------------------------------------------------------------
VICTrTCR         <= iVICTrTCR;
VICINTSOURCE     <= iVICTrIntSource;
VICVECTADDRIN    <= iVICTrVectAddrIn;
nVICFIQIN        <= iVICTrIntIn(0);
nVICIRQIN        <= iVICTrIntIn(1);
VICFIQINREG      <= iVICTrIntInReg(0);
VICIRQINREG      <= iVICTrIntInReg(1);
nVICSYNCEN       <= iVICTrSync;
VICTrSoftInt     <= iVICTrSoftInt;
VICTrIntEnable   <= iVICTrIntEnable;
VICTrIntSelect   <= iVICTrIntSelect;
VICTrSwPriMask   <= iVICTrSwPriMask;
VICTrVectPriDsy  <= iVICTrVectPriDsy;
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
VICTrVectAddr16  <= iVICTrVectAddr16;
VICTrVectAddr17  <= iVICTrVectAddr17;
VICTrVectAddr18  <= iVICTrVectAddr18;
VICTrVectAddr19  <= iVICTrVectAddr19;
VICTrVectAddr20  <= iVICTrVectAddr20;
VICTrVectAddr21  <= iVICTrVectAddr21;
VICTrVectAddr22  <= iVICTrVectAddr22;
VICTrVectAddr23  <= iVICTrVectAddr23;
VICTrVectAddr24  <= iVICTrVectAddr24;
VICTrVectAddr25  <= iVICTrVectAddr25;
VICTrVectAddr26  <= iVICTrVectAddr26;
VICTrVectAddr27  <= iVICTrVectAddr27;
VICTrVectAddr28  <= iVICTrVectAddr28;
VICTrVectAddr29  <= iVICTrVectAddr29;
VICTrVectAddr30  <= iVICTrVectAddr30;
VICTrVectAddr31  <= iVICTrVectAddr31;
VICTrVectPrity0  <= iVICTrVectPrity0;
VICTrVectPrity1  <= iVICTrVectPrity1;
VICTrVectPrity2  <= iVICTrVectPrity2;
VICTrVectPrity3  <= iVICTrVectPrity3;
VICTrVectPrity4  <= iVICTrVectPrity4;
VICTrVectPrity5  <= iVICTrVectPrity5;
VICTrVectPrity6  <= iVICTrVectPrity6;
VICTrVectPrity7  <= iVICTrVectPrity7;
VICTrVectPrity8  <= iVICTrVectPrity8;
VICTrVectPrity9  <= iVICTrVectPrity9;
VICTrVectPrity10 <= iVICTrVectPrity10;
VICTrVectPrity11 <= iVICTrVectPrity11;
VICTrVectPrity12 <= iVICTrVectPrity12;
VICTrVectPrity13 <= iVICTrVectPrity13;
VICTrVectPrity14 <= iVICTrVectPrity14;
VICTrVectPrity15 <= iVICTrVectPrity15;
VICTrVectPrity16 <= iVICTrVectPrity16;
VICTrVectPrity17 <= iVICTrVectPrity17;
VICTrVectPrity18 <= iVICTrVectPrity18;
VICTrVectPrity19 <= iVICTrVectPrity19;
VICTrVectPrity20 <= iVICTrVectPrity20;
VICTrVectPrity21 <= iVICTrVectPrity21;
VICTrVectPrity22 <= iVICTrVectPrity22;
VICTrVectPrity23 <= iVICTrVectPrity23;
VICTrVectPrity24 <= iVICTrVectPrity24;
VICTrVectPrity25 <= iVICTrVectPrity25;
VICTrVectPrity26 <= iVICTrVectPrity26;
VICTrVectPrity27 <= iVICTrVectPrity27;
VICTrVectPrity28 <= iVICTrVectPrity28;
VICTrVectPrity29 <= iVICTrVectPrity29;
VICTrVectPrity30 <= iVICTrVectPrity30;
VICTrVectPrity31 <= iVICTrVectPrity31;

end behavioural;

-- --================================== End ==================================--
