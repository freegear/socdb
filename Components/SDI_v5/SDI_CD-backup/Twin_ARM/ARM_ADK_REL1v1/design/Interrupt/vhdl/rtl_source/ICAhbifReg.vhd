-- --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : ICAhbifReg.vhd,v
-- File Revision          : 1.9
--
-- Release Information    : ADK_REL1v1
--
-- ---------------------------------------------------------------------
-- Purpose :
--           AHB Interface block
--
-- --=================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- ---------------------------------------------------------------------

entity ICAhbifReg is
  port (
-- Inputs
        -- AHB signals
        HCLK             : in    std_logic; -- AHB Clock
        HRESETn          : in    std_logic; -- AHB Reset
        HSELIC           : in    std_logic; -- IC select
        HWRITE           : in    std_logic; -- AHB Write
        HREADY           : in    std_logic; -- Shared HREADY line
        HPROT            : in    std_logic; -- Protection mode
        HTRANS           : in    std_logic; -- Bit 1 of HTRANS
        HSIZE            : in    std_logic_vector(2 downto 0);
                                            -- AHB transfer size
        HWDATA           : in    std_logic_vector(31 downto 0);
                                            -- AHB write data bus
        HADDR            : in    std_logic_vector(11 downto 2);
                                            -- AHB address bus
        -- Revision number
        Revision         : in    std_logic_vector(3 downto 0);
                                            -- Revision number from RevAnd
        -- Interrupt source
        ICINTSOURCE      : in    std_logic_vector(31 downto 0);
                                            -- Interrupt source
        -- Daisy chain signals
        nICFIQIN         : in    std_logic; -- Fast interrupt input
        nICIRQIN         : in    std_logic; -- Normal interrupt input
        ICIRQCo          : in    std_logic; -- Normal IRQ
        ICVECTADDRIN     : in    std_logic_vector(31 downto 0);
                                            -- Vector Address input
        -- Priority logic signals
        ICVECTADDROUTCo  : in    std_logic_vector(31 downto 0);
                                            -- Vector Address output
        ICRawIntrSync    : in    std_logic_vector(31 downto 0);
                                            -- Synced ICRawIntr
        ICIRQStatusSync  : in    std_logic_vector(31 downto 0);
                                            -- Synced ICIRQStatus
        ICFIQStatusSync  : in    std_logic_vector(31 downto 0);
                                            -- Synced ICFIQStatus
-- Outputs
        PriorWrEnCo      : out   std_logic; -- VectAddr Write signal to
                                            -- Priority logic
        PriorRdEn        : out   std_logic; -- VectAddr Read signal to
                                            -- Priority logic
        HREADYOUT        : out   std_logic; -- IC ready signal
        HRESP            : out   std_logic_vector(1 downto 0);
                                            -- AHB transfer response
        NonVectIrqCo     : out   std_logic; -- Non-Vectored Interrupt
        ICDefVectAddr    : out   std_logic_vector(31 downto 0);
                                            -- Default Vector address
        nICFIQ           : out   std_logic; -- Fast Interrupt request
        ICIRQStatusCo    : out   std_logic_vector(31 downto 0);
                                            -- Normal IRQ status
        ICFIQStatusCo    : out   std_logic_vector(31 downto 0);
                                            -- FIQ status
        ICRawIntrCo      : out   std_logic_vector(31 downto 0);
                                            -- IC Raw Interrupt
        HRDATA           : out   std_logic_vector(31 downto 0)
                                            -- Read data bus
       );
end ICAhbifReg;

-- ---------------------------------------------------------------------
--
--                             ICAhbifReg
--                             ===========
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--
--   This module decodes AHB accesses and generates the write strobes to
-- the appropriate registers. This module also contains the output read
-- data multiplexer.
--
-- ---------------------------------------------------------------------
--                    IC Functional Mode Register Map
-- ---------------------------------------------------------------------
-- Offset  Read (Width)          Write (Width)       Description
-- ---------------------------------------------------------------------
--
-- 0x00 ICIRQStatus(32-bit)       -                 IRQ Status
-- 0x04 ICFIQStatus(32-bit)       -                 FIQ Status
-- 0x08 ICRawIntr(32-bit)         -                 Status before mask
-- 0x0C ICIntSelect(32-bit)   ICIntSelect(32-bit)   Select IRQ or FIQ
-- 0x10 ICIntEnable(32-bit)   ICIntEnable(32-bit)   Intr Enable
-- 0x14      -                ICIntEnClear(32-bit)  Intr Enable Clear
-- 0x18 ICSoftInt(32-bit)     ICSoftInt(32-bit)     Generate S/W Intr
-- 0x1C      -                ICSoftIntClear(32-bit)S/W Intr Clear
-- 0x20 ICProtection(1-bit)   ICProtection(1-bit)   Protection Enable
-- 0x30 ICVectAddr(32-bit)    ICVectAddr(32-bit)    Intr Vector Address
-- 0x34 ICDefVectAddr(32-bit) ICDefVectAddr(32-bit) Default Vector Addr
--
-- ---------------------------------------------------------------------
--                 IC Identification Register Map
-- ---------------------------------------------------------------------
-- Offset Read (Width)           Write (Width)       Description
-- ---------------------------------------------------------------------
-- 0xFE0 ICPeriphID0(8-bit)       -                 Peripheral ID 0
-- 0xFE4 ICPeriphID1(8-bit)       -                 Peripheral ID 1
-- 0xFE8 ICPeriphID2(4-bit)       -                 Peripheral ID 2
-- 0xFEC ICPeriphID3(8-bit)       -                 Peripheral ID 3
-- 0xFF0 ICPCellID0(8-bit)        -                 PrimeCell ID 0
-- 0xFF4 ICPCellID1(8-bit)        -                 PrimeCell ID 1
-- 0xFF8 ICPCellID2(8-bit)        -                 PrimeCell ID 2
-- 0xFFC ICPCellID3(8-bit)        -                 PrimeCell ID 3
-- ---------------------------------------------------------------------
--                 IC Test Mode Register Map
-- ---------------------------------------------------------------------
-- Offset Read (Width)         Write (Width)         Description
-- ---------------------------------------------------------------------
-- 0x300 ICITCR(1-bit)       ICITCR(1-bit)          Test Control
-- 0x304 ICITIP1(2-bit)      ICITIP1(2-bit)         Input Read/Set
-- 0x308 ICITIP2(32-bit)     ICITIP2(32-bit)        Input Read/Set
-- 0x30C ICITOP1(2-bit)         -                   Output Set/Read
-- 0x310 ICITOP2(32-bit)        -                   Output Set/Read
--
-- ---------------------------------------------------------------------

-- --======================== ARCHITECTURE =========================--

architecture synth of ICAhbifReg is

-- ---------------------------------------------------------------------
-- Component declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Zero fill for register reads to return zeros in unused bit positions
-- ---------------------------------------------------------------------
constant ZEROFILL             : std_logic_vector(31 downto 0)
                              := "00000000000000000000000000000000";

-- ---------------------------------------------------------------------
-- AHB HRESP constant definitions
-- ---------------------------------------------------------------------
constant H_OKAY               : std_logic_vector(1 downto 0) := "00";
constant H_ERROR              : std_logic_vector(1 downto 0) := "01";

-- ---------------------------------------------------------------------
-- AHB HREADYOUT constant definitions
-- ---------------------------------------------------------------------
constant H_WAIT               : std_logic := '0';
constant H_READY              : std_logic := '1';

-- ---------------------------------------------------------------------
-- IC Functional registers' address constant definitions
-- ---------------------------------------------------------------------
constant HADDR_ICIRQSTATUS    : std_logic_vector(11 downto 2) := "0000000000";
-- ICIRQStatus at offset 0x000

constant HADDR_ICFIQSTATUS    : std_logic_vector(11 downto 2) := "0000000001";
-- ICFIQStatus at offset 0x004

constant HADDR_ICRAWINTR      : std_logic_vector(11 downto 2) := "0000000010";
-- ICRawIntr at offset 0x008

constant HADDR_ICINTSELECT    : std_logic_vector(11 downto 2) := "0000000011";
-- ICIntSelect at offset 0x00C

constant HADDR_ICINTENABLE    : std_logic_vector(11 downto 2) := "0000000100";
-- ICIntEnable at offset 0x010

constant HADDR_ICINTENCLEAR   : std_logic_vector(11 downto 2) := "0000000101";
-- ICIntEnClear at offset 0x014

constant HADDR_ICSOFTINT      : std_logic_vector(11 downto 2) := "0000000110";
-- ICSoftInt at offset 0x018

constant HADDR_ICSOFTINTCLEAR : std_logic_vector(11 downto 2) := "0000000111";
-- ICSoftIntClear at offset 0x01C

constant HADDR_ICPROTECTION   : std_logic_vector(11 downto 2) := "0000001000";
-- ICProtection at offset 0x020

constant HADDR_ICVECTADDR     : std_logic_vector(11 downto 2) := "0000001100";
-- ICVectAddr at offset 0x030

constant HADDR_ICDEFVECTADDR  : std_logic_vector(11 downto 2) := "0000001101";
-- ICDefVectAddr at offset 0x034

-- ---------------------------------------------------------------------
-- IC test registers' address constant definitions
-- ---------------------------------------------------------------------
constant HADDR_ICITCR     : std_logic_vector(11 downto 2) := "0011000000";
-- ICITCR at offset 0x300

constant HADDR_ICITIP1    : std_logic_vector(11 downto 2) := "0011000001";
-- ICITIP1 at offset 0x304

constant HADDR_ICITIP2    : std_logic_vector(11 downto 2) := "0011000010";
-- ICITIP2 at offset 0x308

constant HADDR_ICITOP1    : std_logic_vector(11 downto 2) := "0011000011";
-- ICITOP1 at offset 0x30C

constant HADDR_ICITOP2    : std_logic_vector(11 downto 2) := "0011000100";
-- ICITOP2 at offset 0x310

-- ---------------------------------------------------------------------
-- Identification registers' address constant definitions
-- ---------------------------------------------------------------------
constant HADDR_ICPERIPHID0 : std_logic_vector(11 downto 2) := "1111111000";
-- ICPeriphID0 at offset 0xFE0

constant HADDR_ICPERIPHID1 : std_logic_vector(11 downto 2) := "1111111001";
-- ICPeriphID1 at offset 0xFE4

constant HADDR_ICPERIPHID2 : std_logic_vector(11 downto 2) := "1111111010";
-- ICPeriphID2 at offset 0xFE8

constant HADDR_ICPERIPHID3 : std_logic_vector(11 downto 2) := "1111111011";
-- ICPeriphID3 at offset 0xFEC

constant HADDR_ICPCELLID0  : std_logic_vector(11 downto 2) := "1111111100";
-- ICPCellID0 at offset 0xFF0

constant HADDR_ICPCELLID1  : std_logic_vector(11 downto 2) := "1111111101";
-- ICPCellID1 at offset 0xFF4

constant HADDR_ICPCELLID2  : std_logic_vector(11 downto 2) := "1111111110";
-- ICPCellID2 at offset 0xFF8

constant HADDR_ICPCELLID3  : std_logic_vector(11 downto 2) := "1111111111";
-- ICPCellID3 at offset 0xFFC

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------
signal NxtAccessEn      : std_logic;
-- D-input of AccessEn

signal NxtHTrans        : std_logic;
-- D-input of IntHTrans

signal NxtHAddr         : std_logic_vector(11 downto 2);
-- D-input of IntHAddr

signal NxtHWrite        : std_logic;
-- D-input of IntHWrite

signal ICFIQ           : std_logic;
-- IC FIQ interrupt

signal iPriorRdEn       : std_logic;
-- Internal copy of PriorRdEn

signal NxtHREADYOUT     : std_logic;
-- D-input of HREADYOUT

signal NxtHRESP         : std_logic_vector(1 downto 0);
-- D-input of HRESP

signal AccessEn         : std_logic;
-- Access Enable for user and privilege mode

signal IntHAddr         : std_logic_vector(11 downto 2);
-- Clocked HADDR

signal IntHTrans        : std_logic;
-- Clocked HTRANS

signal HReadyD1       : std_logic;
-- Delayed HREADY

signal IntHWrite        : std_logic;
-- Clocked HWRITE

signal HSELICD1        : std_logic;
-- Delayed HSELIC

signal HAddrGated       : std_logic_vector(11 downto 2);
-- Gated version of HADDR

signal ICVectAddrdec   : std_logic;
-- ICVectAddr decode

signal ICIntSelectdec  : std_logic;
-- ICIntSelect decode

signal ICIntEnabledec  : std_logic;
-- ICIntEnable decode

signal ICIntEnCleardec : std_logic;
-- ICIntEnClear decode

signal ICSoftIntdec    : std_logic;
-- ICSoftInt decode

signal ICSoftIntClrdec : std_logic;
-- ICSoftIntClear decode

signal ICProtectiondec : std_logic;
-- ICProtection decode

signal ICDefAddrdec    : std_logic;
-- ICDefVectAddr decode

signal ICITCRdec       : std_logic;
-- ICITCR decode

signal ICITIP1dec      : std_logic;
-- ICITIP1 decode

signal ICITIP2dec      : std_logic;
-- ICITIP2 decode

signal WrEn             : std_logic;
-- Register Write enable

signal RdEn             : std_logic;
-- Register Read enable

signal NxtICIRQStatus  : std_logic_vector(31 downto 0);
-- D-input of ICIRQStatus

signal NxtICFIQStatus  : std_logic_vector(31 downto 0);
-- D-input of ICFIQStatus

signal NxtICRawIntr    : std_logic_vector(31 downto 0);
-- D-input of ICRawIntr

signal ICIntSelect     : std_logic_vector(31 downto 0);
-- Interrupt select

signal ICIntEnable     : std_logic_vector(31 downto 0);
-- Interrupt Enable

signal ICSoftInt       : std_logic_vector(31 downto 0);
-- Software Interrupt

signal ICProtection    : std_logic;
-- Protection bit

signal iICDefVectAddr  : std_logic_vector(31 downto 0);
-- Internal copy of ICDefVectAddr

signal ICITCR          : std_logic;
-- Integration test control register

signal ICITIP1         : std_logic_vector(7 downto 6);
-- Integration test input register 1

signal ICITIP2         : std_logic_vector(31 downto 0);
-- Integration test input register 2

signal ICPeriphID0     : std_logic_vector(7 downto 0);
-- Peripheral ID 0

signal ICPeriphID1     : std_logic_vector(7 downto 0);
-- Peripheral ID 1

signal ICPeriphID2     : std_logic_vector(3 downto 0);
-- Peripheral ID 2

signal ICPeriphID3     : std_logic_vector(7 downto 0);
-- Peripheral ID 3

signal ICPCellID0      : std_logic_vector(7 downto 0);
-- PrimeCell ID register 0

signal ICPCellID1      : std_logic_vector(7 downto 0);
-- PrimeCell ID register 1

signal ICPCellID2      : std_logic_vector(7 downto 0);
-- PrimeCell ID register 2

signal ICPCellID3      : std_logic_vector(7 downto 0);
-- PrimeCell ID register 3

signal ICIntSelectWr   : std_logic;
-- Write enable for ICIntSelect

signal ICIntEnableWr   : std_logic;
-- Write enable for ICIntEnable

signal ICIntEnClearWr  : std_logic;
-- Write enable for ICIntEnClear

signal ICSoftIntWr     : std_logic;
-- Write enable for ICSoftInt

signal ICSoftIntClrWr  : std_logic;
-- Write enable for ICSoftIntClear

signal ICProtectionWr  : std_logic;
-- Write enable for ICProtection

signal ICDefVectAddrWr : std_logic;
-- Write enable for ICDefVectAddr

signal ICITCRWr        : std_logic;
-- Write enable for ICITCR

signal ICITIP1Wr       : std_logic;
-- Write enable for ICITIP1

signal ICITIP2Wr       : std_logic;
-- Write enable for ICITIP2

signal NxtICIntSelect  : std_logic_vector(31 downto 0);
-- D-input of ICIntSelect

signal NxtICIntEnable  : std_logic_vector(31 downto 0);
-- D-input of ICIntEnable

signal NxtICSoftInt    : std_logic_vector(31 downto 0);
-- D-input of ICSoftInt

signal NxtICProtection : std_logic;
-- D-input of ICProtection

signal NxtICDefAddr    : std_logic_vector(31 downto 0);
-- D-input of ICDefVectAddr

signal NxtICITCR       : std_logic;
-- D-input of ICITCR

signal NxtICITIP1      : std_logic_vector(7 downto 6);
-- D-input of ICITIP1

signal NxtICITIP2      : std_logic_vector(31 downto 0);
-- D-input of ICITIP2

signal iHWDataIn        : std_logic_vector(31 downto 0);
-- Internal copy of HWDATA

signal ICStatus        : std_logic_vector(31 downto 0);
-- Status of IRQ and FIQ

signal ErrorResp        : std_logic;
-- Flag for returning ERROR response

signal NxtErrorResp     : std_logic;
-- D-input of ErrorResp

signal ITEN             : std_logic;
-- Integration test enable

signal IntICIntSource  : std_logic_vector(31 downto 0);
-- Internal Interrupt source

signal IcTip1Read      : std_logic_vector(31 downto 0);
-- Integration test mux output for ITIP1

signal IcTip2Read      : std_logic_vector(31 downto 0);
-- Integration test mux output for ITIP2

-- ---------------------------------------------------------------------
-- Function declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------

begin

-- ---------------------------------------------------------------------
-- Assign the IC Peripheral ID
--
-- The IC Peripheral ID is a 32-bit value composed of the
-- following 4 fields:
-- Bits [11:0] -> Part Number used to identify the peripheral
--                For the IC, this is 0x808
-- Bits[19:12] -> Designer ID (ARM)
--                ARM is designated 0x41
-- Bits[23:20] -> Peripheral Revision Number
--                For the IC this is 0x00
-- Bits[31:24] -> Peripheral Configuration Options
--                For the IC this is 0x00
--
-- The 32-bits are readable via 4 separate address locations with
-- each location returning 8 valid bits at positions [7:0]. The
-- values returned by the 4 Peripheral ID registers are given below:
--
-- ICPeriphID0 = 0x08
-- ICPeriphID1 = 0x18
-- ICPeriphID2 = 0x4
-- ICPeriphID3 = 0x00
-- ---------------------------------------------------------------------
ICPeriphID0     <= "00001000";
ICPeriphID1     <= "00011000";
ICPeriphID2     <= "0100";
ICPeriphID3     <= "00000000";

-- ---------------------------------------------------------------------
-- Assign the IC PrimeCell ID
--
-- ICPCellID0 = 0x0D
-- ICPCellID1 = 0xF0
-- ICPCellID2 = 0x05
-- ICPCellID3 = 0xB1
-- These PrimeCell ID values should not be changed.
-- ---------------------------------------------------------------------
ICPCellID0      <= "00001101";
ICPCellID1      <= "11110000";
ICPCellID2      <= "00000101";
ICPCellID3      <= "10110001";

-- ---------------------------------------------------------------------
-- Gate the HWDATA bus to minimise toggling.
-- ---------------------------------------------------------------------
iHWDataIn        <= HWDATA
                      when ((HSELICD1 = '1') and (IntHWrite = '1'))
                 else
                    ZEROFILL;

-- ---------------------------------------------------------------------
-- Combinational process for generating the AccessEn signal.
-- Set the Access signal if
-- 1. The incoming access is a 32-bit privilege mode access and the
-- Protection bit is set.
-- 2. The incoming access is any 32-bit access and the Protection bit is
-- cleared.
--
-- ---------------------------------------------------------------------
p_SetAccessEnComb : process (ICProtection, HPROT, HSELIC,
                             HREADY, AccessEn, HSIZE)
begin
  if ((HSELIC = '1') and (HREADY = '1')) then
    if (((ICProtection = '0') or
         ((ICProtection = '1') and (HPROT = '1'))) and
        (HSIZE = "010")) then
      NxtAccessEn <= '1';
    else
      NxtAccessEn <= '0';
    end if;
  else
    NxtAccessEn <= AccessEn;
  end if;
end process p_SetAccessEnComb;

-- ---------------------------------------------------------------------
-- Sequential process for generating the AccessEn signal.
-- ---------------------------------------------------------------------
p_SetAccessEnSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    AccessEn <= '0';
  elsif (HCLK'event and HCLK = '1') then
    AccessEn <= NxtAccessEn;
  end if;
end process p_SetAccessEnSeq;

-- ---------------------------------------------------------------------
-- Combinational process for generation of Responses.
-- ---------------------------------------------------------------------
p_ResponseComb : process (HSIZE, HSELIC, HREADY, ErrorResp, HTRANS)
begin
  -- If the ErrorResp flag is set, terminate the 2-cycle
  -- ERROR response by driving HREADYOUT high.
  if (ErrorResp = '1') then
    NxtHREADYOUT  <= H_READY;
    NxtHRESP      <= H_ERROR;
    NxtErrorResp  <= '0';
  elsif ((HSELIC = '1') and (HREADY = '1')) then
    -- If the incoming access is an NSEQ or a SEQ transaction
    -- and the transfer size is not 32-bits, initiate the
    -- first cycle of the 2-cycle ERROR response.
    if ((HSIZE /= "010") and (HTRANS = '1')) then
       NxtHREADYOUT  <= H_WAIT;
       NxtHRESP      <= H_ERROR;
       NxtErrorResp  <= '1';

    -- Return a 0-Wait state OK response if the incoming
    -- transaction is an NSEQ or a SEQ transaction and the
    -- transfer size is 32-bits
    -- OR
    -- If the incoming access indicates an IDLE or BUSY
    -- transaction.
    else
      NxtHREADYOUT <= H_READY;
      NxtHRESP     <= H_OKAY;
      NxtErrorResp <= '0';
    end if;

  -- Drive HREADYOUT high if the access is not to the IC.
  else
    NxtHREADYOUT <= H_READY;
    NxtHRESP     <= H_OKAY;
    NxtErrorResp <= '0';
  end if;
end process p_ResponseComb;

-- ---------------------------------------------------------------------
-- Sequential process for generation of Responses.
-- ---------------------------------------------------------------------
p_ResponseSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    HREADYOUT <= H_READY;
    HRESP     <= H_OKAY;
    ErrorResp <= '0';
  elsif (HCLK'event and HCLK = '1') then
    HREADYOUT <= NxtHREADYOUT;
    HRESP     <= NxtHRESP;
    ErrorResp <= NxtErrorResp;
  end if;
end process p_ResponseSeq;

-- ---------------------------------------------------------------------
-- Combinational process to write into and clear the
-- ICSoftInt register.
-- Writes to the ICSoftInt address location will set only those bits
-- for which the HWDATAIn[i] is high. All other bits retain their
-- previous value.
-- Writes to the ICSoftIntClear address location will clear only
-- those bits for which the HWDATAIn[i] is high. All other bits remain
-- unaffected.
-- ---------------------------------------------------------------------
p_SetSoftIntComb : process (ICSoftIntWr, ICSoftIntClrWr, iHWDataIn, ICSoftInt)
begin
  NxtICSoftInt <= ICSoftInt;
  if (ICSoftIntWr = '1') then
    for i in 0 to 31 loop
      if (iHWDataIn(i) = '1') then
        NxtICSoftInt(i) <= '1';
      end if;
    end loop;
  elsif (ICSoftIntClrWr = '1') then
    for i in 0 to 31 loop
      if (iHWDataIn(i) = '1') then
        NxtICSoftInt(i) <= '0';
      end if;
    end loop;
  end if;
end process p_SetSoftIntComb;

-- ---------------------------------------------------------------------
-- Combinational process to write into and clear the
-- ICIntEnable register.
-- Writes to the ICIntEnable address location will set only those bits
-- for which the HWDATAIn[i] is high. All other bits retain their
-- previous value.
-- Writes to the ICIntEnClear address location will clear only
-- those bits for which the HWDATAIn[i] is high. All other bits remain
-- unaffected.
-- ---------------------------------------------------------------------
p_SetIntEnComb : process (ICIntEnableWr, ICIntEnClearWr, iHWDataIn, ICIntEnable)
begin
  NxtICIntEnable <= ICIntEnable;
  if (ICIntEnableWr = '1') then
    for i in 0 to 31 loop
      if (iHWDataIn(i) = '1') then
        NxtICIntEnable(i) <= '1';
      end if;
    end loop;
  elsif (ICIntEnClearWr = '1') then
    for i in 0 to 31 loop
      if (iHWDataIn(i) = '1') then
        NxtICIntEnable(i) <= '0';
      end if;
    end loop;
  end if;
end process p_SetIntEnComb;

-- ---------------------------------------------------------------------
-- Save power by preventing change in internal address bus when the
-- device is not selected.
-- ---------------------------------------------------------------------
HAddrGated       <= HADDR when (HSELIC = '1') else

                    "0000000000";

-- ---------------------------------------------------------------------
-- Combinational process for generation of clocked input AHB signals
-- (HTRANS, HWRITE, HADDR) which will be used for generation of
-- read and write enables.
-- ---------------------------------------------------------------------
p_IntCntlComb : process (HSELIC, HREADY, HTRANS, HAddrGated,
                         HWRITE, IntHTrans, IntHAddr, IntHWrite)
begin
  if ((HSELIC = '1') and (HREADY = '1')) then
    NxtHTrans  <= HTRANS;
    NxtHAddr   <= HAddrGated;
    NxtHWrite  <= HWRITE;
  else
    NxtHTrans  <= IntHTrans;
    NxtHAddr   <= IntHAddr;
    NxtHWrite  <= IntHWrite;
  end if;
end process p_IntCntlComb;

-- ---------------------------------------------------------------------
-- Sequential process for generation of clocked HTRANS, HWRITE, HADDR.
-- ---------------------------------------------------------------------
p_IntCntlSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    IntHTrans  <= '0';
    IntHAddr   <= "0000000000";
    IntHWrite  <= '0';
  elsif (HCLK'event and HCLK = '1') then
    IntHTrans  <= NxtHTrans;
    IntHAddr   <= NxtHAddr;
    IntHWrite  <= NxtHWrite;
  end if;
end process p_IntCntlSeq;

-- ---------------------------------------------------------------------
-- Sequential process for generation of one clock delayed HREADY
-- and HSELIC.
-- ---------------------------------------------------------------------
p_DelHSigSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    HReadyD1 <= '0';
    HSELICD1  <= '0';
  elsif (HCLK'event and HCLK = '1') then
    HReadyD1 <= HREADY;
    HSELICD1  <= HSELIC;
  end if;
end process p_DelHSigSeq;

-- ---------------------------------------------------------------------
-- Generate combinational decodes from IntHADDR for register accesses.
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
--  Functional Mode Registers.
-- ---------------------------------------------------------------------

-- ICVectAddr
ICVectAddrdec   <= '1' when (IntHAddr = HADDR_ICVECTADDR)
                 else
                    '0';

-- ICIntSelect
ICIntSelectdec  <= '1' when (IntHAddr = HADDR_ICINTSELECT)
                 else
                    '0';

-- ICIntEnable
ICIntEnabledec  <= '1' when (IntHAddr = HADDR_ICINTENABLE)
                 else
                    '0';

-- ICIntEnClear
ICIntEnCleardec <= '1' when (IntHAddr = HADDR_ICINTENCLEAR)
                 else
                    '0';

-- ICSoftInt
ICSoftIntdec    <= '1' when (IntHAddr = HADDR_ICSOFTINT)
                 else
                    '0';

-- ICSoftIntClear
ICSoftIntClrdec <= '1' when (IntHAddr = HADDR_ICSOFTINTCLEAR)
                 else
                    '0';

-- ICProtection
ICProtectiondec <= '1' when (IntHAddr = HADDR_ICPROTECTION)
                 else
                    '0';

-- ICDefVectAddr
ICDefAddrdec    <= '1' when (IntHAddr = HADDR_ICDEFVECTADDR)
                 else
                    '0';

-- ---------------------------------------------------------------------
-- Test Register decodes
-- ---------------------------------------------------------------------
-- ICITCR
ICITCRdec       <= '1' when (IntHAddr = HADDR_ICITCR)
                 else
                    '0';

-- ICITIP1
ICITIP1dec      <= '1' when (IntHAddr = HADDR_ICITIP1)
                 else
                    '0';

-- ICITIP2
ICITIP2dec      <= '1' when (IntHAddr = HADDR_ICITIP2)
                 else
                    '0';

-- ---------------------------------------------------------------------
-- Write Interface
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Combinational logic for WrEn.
-- ---------------------------------------------------------------------
WrEn             <= HSELICD1 and IntHTrans and IntHWrite and
                    HReadyD1 and AccessEn;

-- ---------------------------------------------------------------------
-- Combinational logic for creating Register Write enables.
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Functional Mode Registers
-- ---------------------------------------------------------------------
-- ICIntSelect
ICIntSelectWr   <= WrEn and ICIntSelectdec;

-- ICIntEnable
ICIntEnableWr   <= WrEn and ICIntEnabledec;

-- ICIntEnClear
ICIntEnClearWr  <= WrEn and ICIntEnCleardec;

-- ICSoftInt
ICSoftIntWr     <= WrEn and ICSoftIntdec;

-- ICSoftIntClear
ICSoftIntClrWr  <= WrEn and ICSoftIntClrdec;

-- ICProtection
ICProtectionWr  <= WrEn and ICProtectiondec;

-- ICVectAddr
PriorWrEnCo     <= WrEn and ICVectAddrdec;

-- ICDefVectAddr
ICDefVectAddrWr <= WrEn and ICDefAddrdec;

-- -------------------------------------------------------------------
-- Test Registers
-- ---------------------------------------------------------------------
-- ICITCR
ICITCRWr        <= WrEn and ICITCRdec;

-- ICITIP1
ICITIP1Wr       <= WrEn and ICITIP1dec;

-- ICITIP2
ICITIP2Wr       <= WrEn and ICITIP2dec;

-- ---------------------------------------------------------------------
-- Read interface
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Combinational logic for creating Register Read enables.
-- ---------------------------------------------------------------------
RdEn             <= HSELICD1 and IntHTrans and (not (IntHWrite)) and
                    HReadyD1 and AccessEn;

-- ---------------------------------------------------------------------
-- Functional mode registers
-- ---------------------------------------------------------------------
-- ICVectAddr
iPriorRdEn       <= RdEn and ICVectAddrdec;

-- ---------------------------------------------------------------------
-- Combinational logic for all writeable registers.
--
-- When the respective write enable input is asserted, copy the contents
-- of the HWDataIn bus into the corresponding registers.
-- ---------------------------------------------------------------------
NxtICIntSelect  <= iHWDataIn(31 downto 0) when (ICIntSelectWr = '1')
                 else
                    ICIntSelect;

NxtICProtection <= iHWDataIn(0) when (ICProtectionWr = '1')
                 else
                    ICProtection;

NxtICDefAddr    <= iHWDataIn(31 downto 0) when (ICDefVectAddrWr = '1')
                 else
                    iICDefVectAddr;

-- ---------------------------------------------------------------------
-- Test Registers
-- ---------------------------------------------------------------------

NxtICITCR       <= iHWDataIn(0) when (ICITCRWr = '1')
                 else
                    ICITCR;

NxtICITIP1      <= iHWDataIn(7 downto 6) when (ICITIP1Wr = '1')
                 else
                    ICITIP1;

NxtICITIP2      <= iHWDataIn when (ICITIP2Wr = '1')
                 else
                    ICITIP2;

-- ---------------------------------------------------------------------
-- Sequential process for writeable registers
-- ---------------------------------------------------------------------
p_RegSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    ICIntSelect     <= ZEROFILL;
    ICIntEnable     <= ZEROFILL;
    ICSoftInt       <= ZEROFILL;
    ICProtection    <= '0';
    iICDefVectAddr  <= ZEROFILL;
    ICITCR          <= '0';
    ICITIP1         <= "00";
    ICITIP2         <= ZEROFILL;
  elsif (HCLK'event and HCLK = '1') then
    ICIntSelect     <= NxtICIntSelect;
    ICIntEnable     <= NxtICIntEnable;
    ICSoftInt       <= NxtICSoftInt;
    ICProtection    <= NxtICProtection;
    iICDefVectAddr  <= NxtICDefAddr;
    ICITCR          <= NxtICITCR;
    ICITIP1         <= NxtICITIP1;
    ICITIP2         <= NxtICITIP2;
  end if;
end process p_RegSeq;

-- ---------------------------------------------------------------------
-- Combinational logic for generation of ITEN, Test Interrupt Source,
-- Raw interrupt and vector status.
-- ITEN bit will contol IntICIntSource. If ITEN is deasserted then
-- IntICIntSource will contain ICINTSOURCE, else Zero
-- ---------------------------------------------------------------------
ITEN             <= ICITCR;

IntICIntSource   <= ICINTSOURCE when (ITEN = '0')
                 else
                    ZEROFILL;

NxtICRawIntr     <= IntICIntSource or ICSoftInt;

ICStatus         <= NxtICRawIntr and ICIntEnable;

-- ---------------------------------------------------------------------
-- Combinational logic for generation of IRQ and FIQ status.
-- ---------------------------------------------------------------------
p_SetStatusComb : process (ICStatus, ICIntSelect)
begin
  for i in 0 to 31 loop
    if (ICIntSelect(i) = '1') then
      NxtICFIQStatus(i) <= ICStatus(i);
      NxtICIRQStatus(i) <= '0';
    else
      NxtICFIQStatus(i) <= '0';
      NxtICIRQStatus(i) <= ICStatus(i);
    end if;
  end loop;
end process p_SetStatusComb;

-- ---------------------------------------------------------------------
-- Raise the FIQ interrupt if any of the NxtICFIQStatus bits are set
-- or if the external FIQ interrupt is active.
-- ---------------------------------------------------------------------
ICFIQ            <= NxtICFIQStatus(0) or NxtICFIQStatus(1) or
                    NxtICFIQStatus(2) or NxtICFIQStatus(3) or
                    NxtICFIQStatus(4) or NxtICFIQStatus(5) or
                    NxtICFIQStatus(6) or NxtICFIQStatus(7) or
                    NxtICFIQStatus(8) or NxtICFIQStatus(9) or
                    NxtICFIQStatus(10) or NxtICFIQStatus(11) or
                    NxtICFIQStatus(12) or NxtICFIQStatus(13) or
                    NxtICFIQStatus(14) or NxtICFIQStatus(15) or
                    NxtICFIQStatus(16) or NxtICFIQStatus(17) or
                    NxtICFIQStatus(18) or NxtICFIQStatus(19) or
                    NxtICFIQStatus(20) or NxtICFIQStatus(21) or
                    NxtICFIQStatus(22) or NxtICFIQStatus(23) or
                    NxtICFIQStatus(24) or NxtICFIQStatus(25) or
                    NxtICFIQStatus(26) or NxtICFIQStatus(27) or
                    NxtICFIQStatus(28) or NxtICFIQStatus(29) or
                    NxtICFIQStatus(30) or NxtICFIQStatus(31) or
                    not (nICFIQIN);

-- ---------------------------------------------------------------------
-- Generation of nICFIQ.
-- ---------------------------------------------------------------------
nICFIQ           <= (not ICFIQ);

-- ---------------------------------------------------------------------
-- Raise a non-Vectored interrupt if any of the NxtICIRQStatus bits
-- are set.
-- ---------------------------------------------------------------------
NonVectIrqCo     <= NxtICIRQStatus(0) or NxtICIRQStatus(1) or
                    NxtICIRQStatus(2) or NxtICIRQStatus(3) or
                    NxtICIRQStatus(4) or NxtICIRQStatus(5) or
                    NxtICIRQStatus(6) or NxtICIRQStatus(7) or
                    NxtICIRQStatus(8) or NxtICIRQStatus(9) or
                    NxtICIRQStatus(10) or NxtICIRQStatus(11) or
                    NxtICIRQStatus(12) or NxtICIRQStatus(13) or
                    NxtICIRQStatus(14) or NxtICIRQStatus(15) or
                    NxtICIRQStatus(16) or NxtICIRQStatus(17) or
                    NxtICIRQStatus(18) or NxtICIRQStatus(19) or
                    NxtICIRQStatus(20) or NxtICIRQStatus(21) or
                    NxtICIRQStatus(22) or NxtICIRQStatus(23) or
                    NxtICIRQStatus(24) or NxtICIRQStatus(25) or
                    NxtICIRQStatus(26) or NxtICIRQStatus(27) or
                    NxtICIRQStatus(28) or NxtICIRQStatus(29) or
                    NxtICIRQStatus(30) or NxtICIRQStatus(31);

-- ---------------------------------------------------------------------
-- Integration test mux for ITIP1
-- ---------------------------------------------------------------------
IcTip1Read       <= ZEROFILL(31 downto 8) & nICIRQIN & nICFIQIN &
                    ZEROFILL(5 downto 0) when (ITEN = '0')
                 else
                    ZEROFILL(31 downto 8) & ICITIP1 &
                    ZEROFILL(5 downto 0);

-- ---------------------------------------------------------------------
-- Integration test mux for ITIP1
-- ---------------------------------------------------------------------
IcTip2Read       <= ICVECTADDRIN when (ITEN = '0')
                 else
                    ICITIP2;

-- ---------------------------------------------------------------------
-- Read Data Output Multiplexer.
-- When the peripheral is not being accessed, '0's are driven on the
-- Read Databus (HRDATA) so as not to place any restrictions on the
-- method of external bus connection. The external data buses of the
-- peripherals on the AHB may then be connected using Muxed or Ored
-- bus connection method.
-- ---------------------------------------------------------------------
p_RdDataOutComb : process (RdEn, IntHAddr, ICIRQCo, ICFIQ,
                           IcTip2Read, IcTip1Read, ICVECTADDROUTCo,
                           ICIRQStatusSync, ICFIQStatusSync,
                           ICRawIntrSync, ICITCR, ICIntSelect,
                           ICIntEnable, ICSoftInt, ICProtection,
                           iICDefVectAddr,
                           ICPeriphID0, ICPeriphID1, Revision,
                           ICPeriphID2, ICPeriphID3, ICPCellID0,
                           ICPCellID1, ICPCellID2, ICPCellID3)
begin
  if (RdEn = '1') then
    case IntHAddr is
      when HADDR_ICITOP1       =>
       HRDATA <= ZEROFILL(31 downto 8) & ICIRQCo & ICFIQ & ZEROFILL(5 downto 0);

      when HADDR_ICITIP2       =>
        HRDATA <= IcTip2Read;

      when HADDR_ICITIP1       =>
        HRDATA <= IcTip1Read;

      when HADDR_ICITOP2       =>
        HRDATA <= ICVECTADDROUTCo;

      when HADDR_ICVECTADDR    =>
        HRDATA <= ICVECTADDROUTCo;

      when HADDR_ICIRQSTATUS   =>
        HRDATA <= ICIRQStatusSync;

      when HADDR_ICFIQSTATUS   =>
        HRDATA <= ICFIQStatusSync;

      when HADDR_ICRAWINTR     =>
        HRDATA <= ICRawIntrSync;

      when HADDR_ICITCR        =>
        HRDATA <= ZEROFILL(31 downto 1) & ICITCR;

      when HADDR_ICINTSELECT   =>
        HRDATA <= ICIntSelect;

      when HADDR_ICINTENABLE   =>
        HRDATA <= ICIntEnable;

      when HADDR_ICSOFTINT     =>
        HRDATA <= ICSoftInt;

      when HADDR_ICPROTECTION  =>
        HRDATA <= ZEROFILL(31 downto 1) & ICProtection;

      when HADDR_ICDEFVECTADDR =>
        HRDATA <= iICDefVectAddr;

      when HADDR_ICPERIPHID0   =>
        HRDATA <= ZEROFILL(31 downto 8) & ICPeriphID0;

      when HADDR_ICPERIPHID1   =>
        HRDATA <= ZEROFILL(31 downto 8) & ICPeriphID1;

      when HADDR_ICPERIPHID2   =>
        HRDATA <= ZEROFILL(31 downto 8) & Revision & ICPeriphID2;

      when HADDR_ICPERIPHID3   =>
        HRDATA <= ZEROFILL(31 downto 8) & ICPeriphID3;

      when HADDR_ICPCELLID0    =>
        HRDATA <= ZEROFILL(31 downto 8) & ICPCellID0;

      when HADDR_ICPCELLID1    =>
        HRDATA <= ZEROFILL(31 downto 8) & ICPCellID1;

      when HADDR_ICPCELLID2    =>
        HRDATA <= ZEROFILL(31 downto 8) & ICPCellID2;

      when HADDR_ICPCELLID3    =>
        HRDATA <= ZEROFILL(31 downto 8) & ICPCellID3;

      when others =>
        HRDATA <= ZEROFILL;
    end case;
  else
    HRDATA <= ZEROFILL;
  end if;
end process p_RdDataOutComb;

-- ---------------------------------------------------------------------
-- Assign local copies of signals to the outputs.
-- ---------------------------------------------------------------------
ICDefVectAddr   <= iICDefVectAddr;
ICIRQStatusCo   <= NxtICIRQStatus;
ICFIQStatusCo   <= NxtICFIQStatus;
ICRawIntrCo     <= NxtICRawIntr;
PriorRdEn       <= iPriorRdEn;

end synth;

-- --============================== End ==============================--
