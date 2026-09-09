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
-- File Name              : Ahbif.vhd.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL092-REL1v1
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This module implements the AHB bus inteface logic.
--
-- -----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- --=========================================================================--

entity Ahbif is
  port (
        HCLK             : in    std_logic; -- AHB Clock Signal
        HRESETn          : in    std_logic; -- AHB Reset Signal
        HWRITEdly        : in    std_logic; -- AHB Read/Write Signal
        HREADYIn         : in    std_logic; -- Combined AHB HREADY from all
                                            -- Slaves
        HSELdly          : in    std_logic; -- Slave Selected
        HMASTLOCKdly     : in    std_logic; -- Delayed AHB Master Locked signal
        HADDRdly         : in    std_logic_vector(31 downto 0);
                                            -- AHB Address Bus
        HTRANSdly        : in    std_logic_vector(1 downto 0);
                                            -- AHB Transfer type
        HSIZEdly         : in    std_logic_vector(2 downto 0);
                                            -- AHB Data Transfer Size
        HBURSTdly        : in    std_logic_vector(2 downto 0);
                                            -- AHB Burst Mode
        HWDATAdly        : in    std_logic_vector(63 downto 0);
                                            -- AHB Write Data Bus
        HMASTERdly       : in    std_logic_vector(3 downto 0);
                                            -- AHB Master Number
        HSPLITIn         : in    std_logic_vector(15 downto 0);
                                            -- Delayed AHB HSPLIT bus
        WSCReg1          : in    std_logic_vector(31 downto 0);
                                            -- Wait State Register 1
        WSCReg2          : in    std_logic_vector(31 downto 0);
                                            -- Wait State Register 2
        TMReg            : in    std_logic_vector(31 downto 0);
                                            -- Timeout Register
        XRDlyReg         : in    std_logic_vector(31 downto 0);
                                            -- Transfer delay Reg.
        CR               : in    std_logic_vector(31 downto 0);
                                            -- Control Register
        HRESPIn          : in    std_logic_vector(1 downto 0);
                                            -- Combined AHB HRESP
        HWRITEdlyInt     : out   std_logic; -- Clocked AHB HWRITE signal
        HSELdlyInt       : out   std_logic; -- Latched Slave Selected Signal
        WrEn             : out   std_logic; -- Write Enable Signal
        RdEn             : out   std_logic; -- Read Enable Signal
        BYTE0En          : out   std_logic; -- Enable signal for 0th Byte in a
                                            -- Double Word
        BYTE1En          : out   std_logic; -- Enable signal for 1th Byte in a
                                            -- Double Word
        BYTE2En          : out   std_logic; -- Enable signal for 2th Byte in a
                                            -- Double Word
        BYTE3En          : out   std_logic; -- Enable signal for 3th Byte in a
                                            -- Double Word
        BYTE4En          : out   std_logic; -- Enable signal for 4th Byte in a
                                            -- Double Word
        BYTE5En          : out   std_logic; -- Enable signal for 5th Byte in a
                                            -- Double Word
        BYTE6En          : out   std_logic; -- Enable signal for 6th Byte in a
                                            -- Double Word
        BYTE7En          : out   std_logic; -- Enable signal for 7th Byte in a
                                            -- Double Word
        ARRAY1Sel        : out   std_logic; -- ARRAY 1 Select Signal
        ARRAY2Sel        : out   std_logic; -- ARRAY 2 Select Signal
        WSCReg1Sel       : out   std_logic; -- Wait State Register 1 Select
                                            -- Signal
        WSCReg2Sel       : out   std_logic; -- Wait State Register 2 Select
                                            -- Signal
        CRSel            : out   std_logic; -- Control Register Select Signal
        TMRegSel         : out   std_logic; -- Timeout Register Select Signal
        XRDlyRegSel      : out   std_logic; -- Transfer Delay time Register
                                            -- Select Signal
        HREADYOut        : out   std_logic; -- HREADY signal
        HADDRdlyInt      : out   std_logic_vector(31 downto 0);
                                            -- Clocked HADDR signal
        HSIZEdlyInt      : out   std_logic_vector(2 downto 0);
                                            -- Clocked HSIZE signal
        HSPLITOut        : out   std_logic_vector(15 downto 0);
                                            -- Split reply
        HRESPOut         : out   std_logic_vector(1 downto 0)
                                            -- HRESP signal
       );
end Ahbif;

-- -----------------------------------------------------------------------------
--
--                                  Ahbif
--                                  =====
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--   This module samples the AHB signals, latches addresses and control signals
-- and drives out the appropriate transfer response. It also decodes AHB
-- accesses and generates the read/write strobes to the  appropriate registers.
-- It also inserts required number of wait states  expected for each transfer
-- and implements the split and retry logic.
--   The generic slave has two wait state registers and two memory arrays. Each
-- array can give all the responses depending upon the memory range being
-- accessed.
--
-- -----------------------------------------------------------------------------

-- --============================= ARCHITECTURE ==============================--

architecture synth of Ahbif is

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------
constant WSCReg1ADDR     : std_logic_vector(11 downto 2) := (others => '0');
-- Wait State Register1 BaseAddress

constant WSCReg2ADDR     : std_logic_vector(11 downto 2) := "0000000001";
-- Wait State Register2 BaseAddress

constant CRADDR          : std_logic_vector(11 downto 2) := "0000000010";
-- Control Register BaseAddress

constant TMOUTREGADDR    : std_logic_vector(11 downto 2) := "0000000011";
--  TimeOut Register Base Address

constant XRDLYREGADDR    : std_logic_vector(11 downto 2) := "0000000100";
--  Transfer data delay Register BaseAddress

constant ARRAY1LOWADDR   : std_logic_vector(11 downto 8) := "0001";
-- BaseAddress of Array 1 OK Response Address Range

constant ARRAY1ERRADDR   : std_logic_vector(11 downto 8)
                                             := to_stdlogicvector(X"2");
-- BaseAddress of Array 1 Error Response Address Range

constant ARRAY1RTRYADDR  : std_logic_vector(11 downto 8)
                                             := to_stdlogicvector(X"3");
-- BaseAddress of Array 1 Retry Response Address Range

constant ARRAY1SPLITADDR : std_logic_vector(11 downto 8)
                                             := to_stdlogicvector(X"4");
-- BaseAddress of Array 1 Split Response Address Range

constant ARRAY2LOWADDR   : std_logic_vector(11 downto 8)
                                             := to_stdlogicvector(X"5");
-- BaseAddress of Array 1 OK Response Address Range

constant ARRAY2ERRADDR   : std_logic_vector(11 downto 8)
                                             := to_stdlogicvector(X"6");
-- BaseAddress of Array 1 Error Response Address Range

constant ARRAY2RTRYADDR  : std_logic_vector(11 downto 8)
                                             := to_stdlogicvector(X"7");
-- BaseAddress of Array 1 Retry Response Address Range

constant ARRAY2SPLITADDR : std_logic_vector(11 downto 8)
                                             := to_stdlogicvector(X"8");
-- BaseAddress of Array 1 Split Response Address Range

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal iARRAY1Sel       : std_logic;
-- Internal ARRAY 1 Select signal

signal iARRAY2Sel       : std_logic;
-- Internal ARRAY 2 Select signal

signal NextARRAY1Sel    : std_logic;
-- ARRAY 1 Select signal  in the Address phase

signal NextARRAY2Sel    : std_logic;
-- ARRAY 2 Select signal  in the Address phase

signal iWSCReg1Sel      : std_logic;
-- Internal Wait State Register1 select signal

signal iWSCReg2Sel      : std_logic;
-- Internal Wait State Register2 select signal

signal iCRSel           : std_logic;
-- Internal Control Register1 select signal

signal iTMRegSel        : std_logic;
-- Internal Timeout Register select signal

signal iXRDlyRegSel     : std_logic;
-- Internal Transfer delay Register select signal

signal WSC1Init         : std_logic_vector(7 downto 0);
-- Wait State Counter value to be loaded in next beat while accessing Array 1

signal WSC2Init         : std_logic_vector(7 downto 0);
-- Wait State Counter value to be loaded in next beat while accessing Array 2

signal WSC              : std_logic_vector(7 downto 0);
-- Wait State Counter

signal NextWSC          : std_logic_vector(7 downto 0);
-- D-input of Wait State Counter

signal BeatCount        : std_logic_vector(3 downto 0);
-- Beat Counter value

signal NextBeatCount    : std_logic_vector(3 downto 0);
-- D-input of BeatCounter

signal iHREADYOut       : std_logic;
-- Internal HREADY signal

signal RespSel          : std_logic_vector(1 downto 0);
-- RESP Select signal according to the memory range access

signal iHRESPOut        : std_logic_vector(1 downto 0);
-- Internal HRESP signal

signal iHADDRdlyInt     : std_logic_vector(31 downto 0);
-- Internal HADDR signal

signal NxtHADDRdlyInt   : std_logic_vector(31 downto 0);
-- D-input  of Address bus

signal iHWRITEdlyInt    : std_logic;
-- Internal HWRITE signal

signal NxtHWRITEdlyInt  : std_logic;
-- D-input of HWRITE signal

signal iHSELdlyInt      : std_logic;
-- Internal HSEL signal

signal NxtHSELdlyInt    : std_logic;
-- D-input of HSEL signal

signal iHBURSTdlyInt    : std_logic_vector(2 downto 0);
-- Internal HBURST signal

signal NxtHBURSTdlyInt  : std_logic_vector(2 downto 0);
-- D-input of HBURST signal

signal iHTRANSdlyInt    : std_logic_vector(1 downto 0);
-- Internal HTRANS signal

signal NxtHTRANSdlyInt  : std_logic_vector(1 downto 0);
-- D-input of HTRANS signal

signal iHSIZEdlyInt     : std_logic_vector(2 downto 0);
-- Internal HSIZE signal

signal NxtHMASTERdlyInt : std_logic_vector(3 downto 0);
-- D-input of HMASTER signal

signal iHMASTERdlyInt   : std_logic_vector(3 downto 0);
-- Internal HMASTER signal

signal NxtHSIZEdlyInt   : std_logic_vector(2 downto 0);
-- D-input of HSIZE signal

signal RespEn           : std_logic;
-- Memory access Response enable signal

signal ForceErrResp     : std_logic;
-- Complement of HRESP signal to generate errors

signal PopEn            : std_logic;
-- Enable signal to pop the Master addresses into HSPLIT bus

signal FlushEn          : std_logic;
-- Indicates Split/retry  Data Transfer over

signal LoadQEn          : std_logic;
-- Enables to load HMASTER into Queue

signal LoadMasterEn     : std_logic;
-- Loads HMASTER into the Active Master address bus

signal ActiveMaster     : std_logic_vector(4 downto 0);
-- Active Master for which Slave is fetching data and a valid bit

signal NxtActiveMaster  : std_logic_vector(4 downto 0);
-- D-input of Active Master for which Slave is fetching data

signal ActiveHADDR      : std_logic_vector(31 downto 0);
-- Active Address for which Slave is fetching data

signal NxtActiveHADDR   : std_logic_vector(31 downto 0);
-- D-input of Active Address for which Slave is fetching data

signal XRDlyCnt         : std_logic_vector(15 downto 0);
-- Data Transfer Delay Counter

signal NextXRDlyCnt     : std_logic_vector(15 downto 0);
-- D-input of Data Transfer Delay Counter

signal TMOutCnt         : std_logic_vector(31 downto 0);
-- TimeOut Counter for a particular Master access

signal NextTMOutCnt     : std_logic_vector(31 downto 0);
-- D-input of TimeOut Counter for a particular Master access

signal AccType          : std_logic;
-- Indicates Split/Retry Access

signal NxtAccType       : std_logic;
-- D-input of AccType signal

signal SplitStatus      : std_logic_vector(15 downto 0);
-- Split Status of 16 Masters

signal NxtSplitStatus   : std_logic_vector(15 downto 0);
-- D-input of Split Status

signal iHSPLITOut       : std_logic_vector(15 downto 0);
-- Internal HSPLIT signal

signal Master           : std_logic_vector(3 downto 0);
-- Internal MASTER signal

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- Latching Address Bus
-- -----------------------------------------------------------------------------
p_HADDRSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    iHADDRdlyInt <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    iHADDRdlyInt <= NxtHADDRdlyInt;
  end if;
end process p_HADDRSeq;

-- -----------------------------------------------------------------------------
-- Loading address only when HREADY is set
-- -----------------------------------------------------------------------------
p_HADDRComb : process (HADDRdly, HREADYIn, iHADDRdlyInt)
begin
-- Loading address only when HREADY is set at the posedge of HCLK
  if (HREADYIn = '1') then
    NxtHADDRdlyInt   <= HADDRdly;
  else
    NxtHADDRdlyInt   <= iHADDRdlyInt;
  end if;
end process p_HADDRComb;

-- -----------------------------------------------------------------------------
-- Latching HSEL
-- -----------------------------------------------------------------------------
p_HSELSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    iHSELdlyInt <= '0';
  elsif (HCLK'event and HCLK = '1') then
    iHSELdlyInt <= NxtHSELdlyInt;
  end if;
end process p_HSELSeq;

-- -----------------------------------------------------------------------------
-- Loading address only when HREADY is set
-- -----------------------------------------------------------------------------
p_HSELComb : process (HSELdly, HREADYIn, iHSELdlyInt)
begin
-- Loading HSEL only when HREADY is set at the posedge of HCLK
  if (HREADYIn = '1') then
    NxtHSELdlyInt <= HSELdly;
  else
    NxtHSELdlyInt <= iHSELdlyInt;
  end if;
end process p_HSELComb;

-- -----------------------------------------------------------------------------
-- Latching Write Signal
-- -----------------------------------------------------------------------------
p_HWRITEdlySeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    iHWRITEdlyInt <=  '0';
  elsif (HCLK'event and HCLK = '1') then
    iHWRITEdlyInt <= NxtHWRITEdlyInt;
  end if;
end process p_HWRITEdlySeq;

-- -----------------------------------------------------------------------------
-- Loading Write signal only when HREADY is set
-- -----------------------------------------------------------------------------
p_HWRITEdlyComb : process (HWRITEdly, HREADYIn, iHWRITEdlyInt)
begin
  if (HREADYIn = '1') then
    NxtHWRITEdlyInt <= HWRITEdly;
  else
    NxtHWRITEdlyInt <= iHWRITEdlyInt;
  end if;
end process p_HWRITEdlyComb;
-- -----------------------------------------------------------------------------
-- Latching Control signal HSIZE
-- -----------------------------------------------------------------------------
p_HSIZEdlySeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    iHSIZEdlyInt <=  (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    iHSIZEdlyInt <= NxtHSIZEdlyInt;
  end if;
end process p_HSIZEdlySeq;

-- -----------------------------------------------------------------------------
-- Loading HSIZE signal only when HREADY is set
-- -----------------------------------------------------------------------------
p_HSIZEdlyComb : process (HSIZEdly, HREADYIn, iHSIZEdlyInt)
begin
  if (HREADYIn = '1') then
    NxtHSIZEdlyInt <= HSIZEdly;
  else
    NxtHSIZEdlyInt <= iHSIZEdlyInt;
  end if;
end process p_HSIZEdlyComb;

-- -----------------------------------------------------------------------------
-- Latching Control signal HTRANS
-- -----------------------------------------------------------------------------
p_HTRANSdlySeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    iHTRANSdlyInt <=  (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    iHTRANSdlyInt <= NxtHTRANSdlyInt;
  end if;
end process p_HTRANSdlySeq;

-- -----------------------------------------------------------------------------
-- Loading HTRANS signal only when HREADY is set
-- -----------------------------------------------------------------------------
p_HTRANSdlyComb : process (HTRANSdly, HREADYIn, iHTRANSdlyInt)
begin
  if (HREADYIn = '1') then
    NxtHTRANSdlyInt <= HTRANSdly;
  else
    NxtHTRANSdlyInt <= iHTRANSdlyInt;
  end if;
end process p_HTRANSdlyComb;

-- -----------------------------------------------------------------------------
-- Latching Control signal HBURST
-- -----------------------------------------------------------------------------
p_HBURSTdlySeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    iHBURSTdlyInt <=  (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    iHBURSTdlyInt <= NxtHBURSTdlyInt;
  end if;
end process p_HBURSTdlySeq;

-- -----------------------------------------------------------------------------
-- Loading HBURST signal only when HREADY is set
-- -----------------------------------------------------------------------------
p_HBURSTdlyComb : process (HBURSTdly, HREADYIn, iHBURSTdlyInt)
begin
  if (HREADYIn = '1') then
    NxtHBURSTdlyInt <= HBURSTdly;
  else
    NxtHBURSTdlyInt <= iHBURSTdlyInt;
  end if;
end process p_HBURSTdlyComb;

-- -----------------------------------------------------------------------------
-- Latching HMASTER Signal
-- -----------------------------------------------------------------------------
p_HMASTERdlySeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    iHMASTERdlyInt <=  (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    iHMASTERdlyInt <= NxtHMASTERdlyInt;
  end if;
end process p_HMASTERdlySeq;

-- -----------------------------------------------------------------------------
-- Loading HMASTER signal only when HREADY is set
-- -----------------------------------------------------------------------------
p_HMASTERdlyComb : process (HMASTERdly, HREADYIn, iHMASTERdlyInt)
begin
  if (HREADYIn = '1') then
    NxtHMASTERdlyInt <= HMASTERdly;
  else
    NxtHMASTERdlyInt <= iHMASTERdlyInt;
  end if;
end process p_HMASTERdlyComb;

-- -----------------------------------------------------------------------------
-- Combinational Decode logic for Control and Wait state registers
-- -----------------------------------------------------------------------------
iWSCReg1Sel      <= '1' when ((iHADDRdlyInt(11 downto 2) = WSCReg1ADDR) and
                             (iHSELdlyInt = '1'))
                 else
                    '0';

iWSCReg2Sel      <= '1' when ((iHADDRdlyInt(11 downto 2) = WSCReg2ADDR) and
                             (iHSELdlyInt = '1'))
                 else
                    '0';

iCRSel           <= '1' when ((iHADDRdlyInt(11 downto 2) = CRADDR) and
                             (iHSELdlyInt = '1'))
                 else
                    '0';

iTMRegSel        <= '1' when ((iHADDRdlyInt(11 downto 2) = TMOutRegADDR) and
                             (iHSELdlyInt = '1'))
                 else
                    '0';

iXRDlyRegSel     <= '1' when ((iHADDRdlyInt(11 downto 2) = XRDlyRegADDR) and
                             (iHSELdlyInt = '1'))
                 else
                    '0';

iARRAY1Sel       <= '1' when ((iHADDRdlyInt(11 downto 8) >= ARRAY1LOWADDR) and
                             (iHADDRdlyInt(11 downto 8) <= ARRAY1SPLITADDR) and
                             (iHSELdlyInt = '1'))
                 else
                    '0';

iARRAY2Sel       <= '1' when ((iHADDRdlyInt(11 downto 8) >= ARRAY2LOWADDR) and
                             (iHADDRdlyInt(11 downto 8) <= ARRAY2SPLITADDR) and
                             (iHSELdlyInt = '1'))
                 else
                    '0';

NextARRAY1Sel    <= '1' when ((HADDRdly(11 downto 8)>= ARRAY1LOWADDR) and
                             (HADDRdly(11 downto 8)<= ARRAY1SPLITADDR) and
                             (iHSELdlyInt = '1'))
                 else
                    '0';

NextARRAY2Sel    <= '1' when ((HADDRdly(11 downto 8)>= ARRAY2LOWADDR) and
                             (HADDRdly(11 downto 8)<= ARRAY2SPLITADDR) and
                             (iHSELdlyInt = '1'))
                 else
                    '0';

WrEn             <= iHWRITEdlyInt and iHTRANSdlyInt(1);

RdEn             <= (not(iHWRITEdlyInt)) and iHTRANSdlyInt(1);

-- -----------------------------------------------------------------------------
-- Combinational Decode logic to select the byte location being accessed
-- -----------------------------------------------------------------------------
BYTE0En          <= '1' when (((iHSIZEdlyInt(1 downto 0) = "00") and
                             (iHADDRdlyInt(2 downto 0) = "000")) or
                             ((iHSIZEdlyInt(1 downto 0) = "01") and
                             (iHADDRdlyInt(2 downto 1) = "00")) or
                             ((iHSIZEdlyInt(1 downto 0) = "10") and
                             (iHADDRdlyInt(2) = '0')) or
                             (iHSIZEdlyInt(1 downto 0) = "11"))
                 else
                    '0';

BYTE1En          <= '1' when (((iHSIZEdlyInt(1 downto 0) = "00") and
                             (iHADDRdlyInt(2 downto 0) = "001")) or
                             ((iHSIZEdlyInt(1 downto 0) = "01") and
                             (iHADDRdlyInt(2 downto 1) = "00")) or
                             ((iHSIZEdlyInt(1 downto 0) = "10") and
                             (iHADDRdlyInt(2) = '0')) or
                             (iHSIZEdlyInt(1 downto 0) = "11"))
                 else
                    '0';

BYTE2En          <= '1' when (((iHSIZEdlyInt(1 downto 0) = "00") and
                             (iHADDRdlyInt(2 downto 0) = "010")) or
                             ((iHSIZEdlyInt(1 downto 0) = "01") and
                             (iHADDRdlyInt(2 downto 1) = "01")) or
                             ((iHSIZEdlyInt(1 downto 0) = "10") and
                             (iHADDRdlyInt(2) = '0')) or
                             (iHSIZEdlyInt(1 downto 0) = "11"))
                 else
                    '0';

BYTE3En          <= '1' when (((iHSIZEdlyInt(1 downto 0) = "00") and
                             (iHADDRdlyInt(2 downto 0) = "011")) or
                             ((iHSIZEdlyInt(1 downto 0) = "01") and
                             (iHADDRdlyInt(2 downto 1) = "01")) or
                             ((iHSIZEdlyInt(1 downto 0) = "10") and
                             (iHADDRdlyInt(2) = '0')) or
                             (iHSIZEdlyInt(1 downto 0) = "11"))
                 else
                    '0';

BYTE4En          <= '1' when (((iHSIZEdlyInt(1 downto 0) = "00") and
                             (iHADDRdlyInt(2 downto 0) = "100")) or
                             ((iHSIZEdlyInt(1 downto 0) = "01") and
                             (iHADDRdlyInt(2 downto 1) = "10")) or
                             ((iHSIZEdlyInt(1 downto 0) = "10") and
                             (iHADDRdlyInt(2) = '1')) or
                             (iHSIZEdlyInt(1 downto 0) = "11"))
                 else
                    '0';

BYTE5En          <= '1' when (((iHSIZEdlyInt(1 downto 0) = "00") and
                             (iHADDRdlyInt(2 downto 0) = "101")) or
                             ((iHSIZEdlyInt(1 downto 0) = "01") and
                             (iHADDRdlyInt(2 downto 1) = "10")) or
                             ((iHSIZEdlyInt(1 downto 0) = "10") and
                             (iHADDRdlyInt(2) = '1')) or
                             (iHSIZEdlyInt(1 downto 0) = "11"))
                 else
                    '0';

BYTE6En          <= '1' when (((iHSIZEdlyInt(1 downto 0) = "00") and
                             (iHADDRdlyInt(2 downto 0) = "110")) or
                             ((iHSIZEdlyInt(1 downto 0) = "01") and
                             (iHADDRdlyInt(2 downto 1) = "11")) or
                             ((iHSIZEdlyInt(1 downto 0) = "10") and
                             (iHADDRdlyInt(2) = '1')) or
                             (iHSIZEdlyInt(1 downto 0) = "11"))
                 else
                    '0';

BYTE7En          <= '1' when (((iHSIZEdlyInt(1 downto 0) = "00") and
                             (iHADDRdlyInt(2 downto 0) = "111")) or
                             ((iHSIZEdlyInt(1 downto 0) = "01") and
                             (iHADDRdlyInt(2 downto 1) = "11")) or
                             ((iHSIZEdlyInt(1 downto 0) = "10") and
                             (iHADDRdlyInt(2) = '1')) or
                             (iHSIZEdlyInt(1 downto 0) = "11"))
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Generating Response Signal
-- -----------------------------------------------------------------------------
RespSel          <= "01" when (((iHADDRdlyInt(11 downto 8) = ARRAY1ERRADDR) or
                              (iHADDRdlyInt(11 downto 8) = ARRAY2ERRADDR)) and
                              (iHSELdlyInt = '1') and (RespEn = '1'))
                 else
                    "10" when (((iHADDRdlyInt(11 downto 8) = ARRAY1RTRYADDR) or
                              (iHADDRdlyInt(11 downto 8) = ARRAY2RTRYADDR)) and
                              (iHSELdlyInt = '1') and (RespEn = '1'))
                 else
                    "11" when (((iHADDRdlyInt(11 downto 8) = ARRAY1SPLITADDR) or
                              (iHADDRdlyInt(11 downto 8) = ARRAY2SPLITADDR)) and
                              (iHSELdlyInt = '1') and (RespEn = '1'))
                 else
                    "00";

iHRESPOut        <= "00" when ((iHTRANSdlyInt(1) = '0') or (PopEn = '1') or
                              ((LoadMasterEn = '0') and
                              (XRDlyCnt = "0000000000000000") and
                              (ActiveMaster = ('1' & iHMASTERdlyInt))) or
                              ((RespSel /= "00") and (WSC > "00000001")))
                 else
                    RespSel;

-- -----------------------------------------------------------------------------
-- Wait Cycles to be introduced in next beat :
-- While accessing  ARRAY #1 :
-- WSCReg1(7 downto 0) if it is INCR
-- different wait states in other burst modes depending upon beatcount
-- -----------------------------------------------------------------------------
WSC1Init         <= WSCReg1(7 downto 0) when ((HBURSTdly(2 downto 1) = "00") or
                                            ((HBURSTdly(2 downto 1) = "01") and
                                            (HTRANSdly = "10")))
                 else
                    WSCReg1(15 downto 8)
                                       when ((HBURSTdly(2 downto 1) = "01") and
                                            (BeatCount = "0000"))
                 else
                    WSCReg1(23 downto 16)
                                       when ((HBURSTdly(2 downto 1) = "01") and
                                            (BeatCount = "0001"))
                 else
                    WSCReg1(31 downto 24)
                                       when ((HBURSTdly(2 downto 1) = "01") and
                                            (BeatCount = "0010"))
                 else
                    "0000" & WSCReg1(3 downto 0)
                                       when (HBURSTdly(2 downto 1) ="01" and
                                            (HTRANSdly = "10"))
                 else
                    "0000" & WSCReg1(7 downto 4)
                                       when ((HBURSTdly(2 downto 1) = "10") and
                                            (BeatCount = "0000"))
                 else
                    "0000" & WSCReg1(11 downto 8)
                                       when ((HBURSTdly(2 downto 1) = "10") and
                                            (BeatCount = "0001"))
                 else
                    "0000" & WSCReg1(15 downto 12)
                                       when ((HBURSTdly(2 downto 1) = "10") and
                                            (BeatCount = "0010"))
                 else
                    "0000" & WSCReg1(19 downto 16)
                                       when ((HBURSTdly(2 downto 1) = "10") and
                                            (BeatCount = "0011"))
                 else
                    "0000" & WSCReg1(23 downto 20)
                                       when ((HBURSTdly(2 downto 1) = "10") and
                                            (BeatCount = "0100"))
                 else
                    "0000" & WSCReg1(27 downto 24)
                                       when ((HBURSTdly(2 downto 1) = "10") and
                                            (BeatCount = "0101"))
                 else
                    "0000" & WSCReg1(31 downto 28)
                                       when ((HBURSTdly(2 downto 1) = "10") and
                                            (BeatCount = "0110"))
                 else
                    "000000" & WSCReg1(1 downto 0)
                                       when (HBURSTdly(2 downto 1) = "11" and
                                            (HTRANSdly = "10"))
                 else
                    "000000" & WSCReg1(3 downto 2)
                                       when ((HBURSTdly(2 downto 1)= "11") and
                                            (BeatCount = "0000"))
                 else
                    "000000" & WSCReg1(5 downto 4)
                                       when ((HBURSTdly(2 downto 1)= "11") and
                                            (BeatCount = "0001"))
                 else
                    "000000" & WSCReg1(7 downto 6)
                                       when ((HBURSTdly(2 downto 1)= "11") and
                                            (BeatCount = "0010"))
                 else
                    "000000" & WSCReg1(9 downto 8)
                                       when ((HBURSTdly(2 downto 1)= "11") and
                                            (BeatCount = "0011"))
                 else
                    "000000" & WSCReg1(11 downto 10)
                                       when ((HBURSTdly(2 downto 1)= "11") and
                                            (BeatCount = "0100"))
                 else
                    "000000" & WSCReg1(13 downto 12)
                                       when ((HBURSTdly(2 downto 1)= "11") and
                                            (BeatCount = "0101"))
                 else
                    "000000" & WSCReg1(15 downto 14)
                                       when ((HBURSTdly(2 downto 1)= "11") and
                                            (BeatCount = "0110"))
                 else
                    "000000" & WSCReg1(17 downto 16)
                                       when (HBURSTdly(2 downto 1) = "11" and
                                            (BeatCount = "0111"))
                 else
                    "000000" & WSCReg1(19 downto 18)
                                       when ((HBURSTdly(2 downto 1)= "11") and
                                            (BeatCount = "1000"))
                 else
                    "000000" & WSCReg1(21 downto 20)
                                       when ((HBURSTdly(2 downto 1)= "11") and
                                            (BeatCount = "1001"))
                 else
                    "000000" & WSCReg1(23 downto 22)
                                       when ((HBURSTdly(2 downto 1)= "11") and
                                            (BeatCount = "1010"))
                 else
                    "000000" & WSCReg1(25 downto 24)
                                       when ((HBURSTdly(2 downto 1)= "11") and
                                            (BeatCount = "1011"))
                 else
                    "000000" & WSCReg1(27 downto 26)
                                       when ((HBURSTdly(2 downto 1)= "11") and
                                            (BeatCount = "1100"))
                 else
                    "000000" & WSCReg1(29 downto 28)
                                       when ((HBURSTdly(2 downto 1)= "11") and
                                            (BeatCount = "1101"))
                 else
                    "000000" & WSCReg1(31 downto 30)
                                       when ((HBURSTdly(2 downto 1)= "11") and
                                            (BeatCount = "1110"))
                 else
                    (others => '0');

WSC2Init         <= WSCReg2(7 downto 0)
                                       when ((HBURSTdly(2 downto 1) = "00") or
                                            ((HBURSTdly(2 downto 1) = "01") and
                                            (HTRANSdly = "10")))
                 else
                    WSCReg2(15 downto 8)
                                       when ((HBURSTdly(2 downto 1) = "01") and
                                            (BeatCount = "0000"))
                 else
                    WSCReg2(23 downto 16)
                                       when ((HBURSTdly(2 downto 1) = "01") and
                                            (BeatCount = "0001"))
                 else
                    WSCReg2(31 downto 24)
                                       when ((HBURSTdly(2 downto 1) = "01") and
                                            (BeatCount = "0010"))
                 else
                    "0000" & WSCReg2(3 downto 0)
                                       when (HBURSTdly(2 downto 1) = "10" and
                                            (HTRANSdly = "10"))
                 else
                    "0000" & WSCReg2(7 downto 4)
                                       when ((HBURSTdly(2 downto 1) = "10") and
                                            (BeatCount = "0000"))
                 else
                    "0000" & WSCReg2(11 downto 8)
                                       when ((HBURSTdly(2 downto 1) = "10") and
                                            (BeatCount = "0001"))
                 else
                    "0000" & WSCReg2(15 downto 12)
                                       when ((HBURSTdly(2 downto 1) = "10") and
                                            (BeatCount = "0010"))
                 else
                    "0000" & WSCReg2(19 downto 16)
                                       when ((HBURSTdly(2 downto 1) = "10") and
                                            (BeatCount = "0011"))
                 else
                    "0000" & WSCReg2(23 downto 20)
                                       when ((HBURSTdly(2 downto 1) = "10") and
                                            (BeatCount = "0100"))
                 else
                    "0000" & WSCReg2(27 downto 24)
                                       when ((HBURSTdly(2 downto 1) = "10") and
                                            (BeatCount = "0101"))
                 else
                    "0000" & WSCReg2(31 downto 28)
                                       when ((HBURSTdly(2 downto 1) = "10") and
                                            (BeatCount = "0110"))
                 else
                    "000000" & WSCReg2(1 downto 0)
                                       when (HBURSTdly(2 downto 1) = "11" and
                                            (HTRANSdly = "10"))
                 else
                    "000000" & WSCReg2(3 downto 2)
                                       when ((HBURSTdly(2 downto 1) = "11") and
                                            (BeatCount = "0000"))
                 else
                    "000000" & WSCReg2(5 downto 4)
                                       when ((HBURSTdly(2 downto 1) = "11") and
                                            (BeatCount = "0001"))
                 else
                    "000000" & WSCReg2(7 downto 6)
                                       when ((HBURSTdly(2 downto 1) = "11") and
                                            (BeatCount = "0010"))
                 else
                    "000000" & WSCReg2(9 downto 8)
                                       when ((HBURSTdly(2 downto 1) = "11") and
                                            (BeatCount = "0011"))
                 else
                    "000000" & WSCReg2(11 downto 10)
                                       when ((HBURSTdly(2 downto 1) = "11") and
                                            (BeatCount = "0100"))
                 else
                    "000000" & WSCReg2(13 downto 12)
                                       when ((HBURSTdly(2 downto 1) = "11") and
                                            (BeatCount = "0101"))
                 else
                    "000000" & WSCReg2(15 downto 14)
                                       when ((HBURSTdly(2 downto 1) = "11") and
                                            (BeatCount = "0110"))
                 else
                    "000000" & WSCReg2(17 downto 16)
                                       when (HBURSTdly(2 downto 1) = "11" and
                                            (BeatCount = "0111"))
                 else
                    "000000" & WSCReg2(19 downto 18)
                                       when ((HBURSTdly(2 downto 1) = "11") and
                                            (BeatCount = "1000"))
                 else
                    "000000" & WSCReg2(21 downto 20)
                                       when ((HBURSTdly(2 downto 1) = "11") and
                                            (BeatCount = "1001"))
                 else
                    "000000" & WSCReg2(23 downto 22)
                                       when ((HBURSTdly(2 downto 1) = "11") and
                                            (BeatCount = "1010"))
                 else
                    "000000" & WSCReg2(25 downto 24)
                                       when ((HBURSTdly(2 downto 1) = "11") and
                                            (BeatCount = "1011"))
                 else
                    "000000" & WSCReg2(27 downto 26)
                                       when ((HBURSTdly(2 downto 1) = "11") and
                                            (BeatCount = "1100"))
                 else
                    "000000" & WSCReg2(29 downto 28)
                                       when ((HBURSTdly(2 downto 1) = "11") and
                                            (BeatCount = "1101"))
                 else
                    "000000" & WSCReg2(31 downto 30)
                                       when ((HBURSTdly(2 downto 1) = "11") and
                                            (BeatCount = "1110"))
                 else
                    (others => '0');

-- -----------------------------------------------------------------------------
-- LoadMasterEn signal loads the ActiveMaster for which  the slave has given a
-- split or retry
-- -----------------------------------------------------------------------------
LoadMasterEn     <= '1' when (((HREADYIn = '0') and (((HRESPIn = "11") and
                             (ActiveMaster(3 downto 0) = iHMASTERdlyInt)) or
                             ((ActiveMaster(3 downto 0) /= iHMASTERdlyInt) and
                             (HRESPIn = "10")) or ((HRESPIn = "11") and
                             (ActiveMaster(4) = '0')))) or
                             ((HREADYIn = '0') and (HRESPIn(1) = '1') and
                             (ActiveMaster(4) = '0') and (HMASTLOCKdly = '1')))
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- LoadQEn denotes the bus master has to be loaded in split queue.
-- -----------------------------------------------------------------------------
LoadQEn          <= '1' when ((HREADYIn = '0') and (HRESPIn = "11") and
                           (ActiveMaster(4) = '1') and (HMASTLOCKdly = '0') and
                           (ActiveMaster(3 downto 0) /= iHMASTERdlyInt))
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- PopEn denotes that current access is successful and the split queue has to
-- be popped.
-- -----------------------------------------------------------------------------
PopEn            <= '1' when ((LoadMasterEn = '0') and
                             (XRDlyCnt = "0000000000000000") and
                             (ActiveMaster = ('1' & iHMASTERdlyInt)))
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- FlushEn denotes split/retry access is over and asserts HREADY.
-- -----------------------------------------------------------------------------
FlushEn          <= '1' when ((PopEn = '1') and
                             (iHSPLITOut = "0000000000000000"))
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- SPLITx lines from AHB Slave
-- -----------------------------------------------------------------------------
iHSPLITOut       <= SplitStatus when ((XRDlyCnt = "0000000000000001") and
                                   (HREADYIn = '1') and (RespSel(1) = '1') and
                                   (AccType = '1') and
                                   (ActiveMaster(3 downto 0) = iHMASTERdlyInt))
                 else
                    (others => '0');

-- -----------------------------------------------------------------------------
-- Master address to be loaded in queue
-- -----------------------------------------------------------------------------
Master           <= iHMASTERdlyInt when (LoadQen = '1' or LoadMasterEn = '1')
                 else
                    (others => '0');

-- -----------------------------------------------------------------------------
-- SPLIT status of all the masters
-- -----------------------------------------------------------------------------
p_LdQSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    SplitStatus <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    SplitStatus <= NxtSplitStatus;
  end if;
end process p_LdQSeq;

-- -----------------------------------------------------------------------------
-- Asserting and deasserting SPLIT status of masters
-- -----------------------------------------------------------------------------
p_LdQComb : process (LoadMasterEn, PopEn, LoadQEn, SplitStatus, Master,
                     HRESPIn)
begin
  if ((LoadQEn= '1') or ((LoadMasterEn = '1') and (HRESPIn = "11"))) then
    NxtSplitStatus <= SplitStatus;
    case Master is
      when "0000" =>
        NxtSplitStatus(0) <= (LoadQEn or LoadMasterEn);
      when "0001" =>
        NxtSplitStatus(1) <= (LoadQEn or LoadMasterEn);
      when "0010" =>
        NxtSplitStatus(2) <= (LoadQEn or LoadMasterEn);
      when "0011" =>
        NxtSplitStatus(3) <= (LoadQEn or LoadMasterEn);
      when "0100" =>
        NxtSplitStatus(4) <= (LoadQEn or LoadMasterEn);
      when "0101" =>
        NxtSplitStatus(5) <= (LoadQEn or LoadMasterEn);
      when "0110" =>
        NxtSplitStatus(6) <= (LoadQEn or LoadMasterEn);
      when "0111" =>
        NxtSplitStatus(7) <= (LoadQEn or LoadMasterEn);
      when "1000" =>
        NxtSplitStatus(8) <= (LoadQEn or LoadMasterEn);
      when "1001" =>
        NxtSplitStatus(9) <= (LoadQEn or LoadMasterEn);
      when "1010" =>
        NxtSplitStatus(10) <= (LoadQEn or LoadMasterEn);
      when "1011" =>
        NxtSplitStatus(11) <= (LoadQEn or LoadMasterEn);
      when "1100" =>
        NxtSplitStatus(12) <= (LoadQEn or LoadMasterEn);
      when "1101" =>
        NxtSplitStatus(13) <= (LoadQEn or LoadMasterEn);
      when "1110" =>
        NxtSplitStatus(14) <= (LoadQEn or LoadMasterEn);
      when "1111" =>
        NxtSplitStatus(15) <= (LoadQEn or LoadMasterEn);
      when others =>
        NxtSplitStatus     <= (others => '0');
    end case;
  elsif (PopEn = '1') then
    NxtSplitStatus <= (others => '0');
  else
    NxtSplitStatus <= SplitStatus;
  end if;
end process p_LdQComb;

-- -----------------------------------------------------------------------------
-- Loading the Master address for which the slave is fetching data
-- Loading the access type, if SPLIT then AccType => 1.
-- -----------------------------------------------------------------------------
p_LdMasterSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    ActiveMaster <= (others => '0');
    AccType      <= '0';
    ActiveHADDR  <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    ActiveMaster <= NxtActiveMaster;
    AccType      <= NxtAccType;
    ActiveHADDR  <= NxtActiveHADDR;
  end if;
end process p_LdMasterSeq;

-- -----------------------------------------------------------------------------
-- Loads ActiveMaster when a new master comes in and is given a retry, or when
-- a Master comes up with a SPLIT access when Slave is not fetching data for
-- any other master which is SPLIT/RETRY.
-- -----------------------------------------------------------------------------
p_LdMasterComb : process (ActiveMaster, iHMASTERdlyInt, LoadMasterEn, FlushEn,
                          TMOutCnt)
begin
  if (LoadMasterEn = '1' and (ActiveMaster(3 downto 0) /= iHMASTERdlyInt)) then
    NxtActiveMaster <= ('1' & iHMASTERdlyInt);
  elsif ((FlushEn = '1') or ((TMOutCnt = to_stdlogicvector(X"00000000")))) then
    NxtActiveMaster <= (others => '0');
  else
    NxtActiveMaster <= ActiveMaster;
  end if;
end process p_LdMasterComb;

-- -----------------------------------------------------------------------------
-- Loading Access type with which slave responded to Master
-- -----------------------------------------------------------------------------
p_LdAccComb : process (LoadMasterEn, FlushEn, TMOutCnt, AccType, HRESPIn,
                       iHADDRDlyInt, ActiveHADDR)
begin
  if (LoadMasterEn = '1') then
    NxtAccType      <= HRESPIn(0);
    NxtActiveHADDR  <= iHADDRdlyInt;
  elsif ((FlushEn = '1') or ((TMOutCnt = to_stdlogicvector(X"00000000")))) then
    NxtAccType      <= '0';
    NxtActiveHADDR  <= (others => '0');
  else
    NxtAccType      <= AccType;
    NxtActiveHADDR  <= ActiveHADDR;
  end if;
end process p_LdAccComb;

-- -----------------------------------------------------------------------------
-- TimeOut Counter
-- -----------------------------------------------------------------------------
p_TMOutCntSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    TMOutCnt <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    TMOutCnt <= NextTMOutCnt;
  end if;
end process p_TMOutCntSeq;

-- -----------------------------------------------------------------------------
-- Timeout Counter loaded when a Master takes over the slave
-- -----------------------------------------------------------------------------
p_TMOutCntComb : process (TMOutCnt, LoadMasterEn, TMReg)
begin
  if (LoadMasterEn = '1' and (ActiveMaster(3 downto 0) /= iHMASTERdlyInt)) then
    NextTMOutCnt <= TMReg;
  elsif (ActiveMaster(4) = '1') then
    NextTMOutCnt <= unsigned(TMOutCnt) - 1;
  else
    NextTMOutCnt <= TMOutCnt;
  end if;
end process p_TMOutCntComb;

-- -----------------------------------------------------------------------------
-- Transfer delay reqd. by slave
-- -----------------------------------------------------------------------------
p_XRDlyCntSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    XRDlyCnt <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    XRDlyCnt <= NextXRDlyCnt;
  end if;
end process p_XRDlyCntSeq;

-- -----------------------------------------------------------------------------
-- Counter loaded when slave starts fetching data for a SPLIT/RETRY access
-- Decrement counter whenever the same slave comes for an access again
-- -----------------------------------------------------------------------------
p_XRDlyCntComb : process (XRDlyCnt, LoadMasterEn, ActiveMaster, iHMASTERdlyInt,
                          HREADYIn, HRESPIn, NxtActiveMaster, XRDlyReg,
                          RespSel, XRDlyCnt)
begin
  if ((LoadMasterEn = '1') and
      (ActiveMaster(3 downto 0) /= iHMASTERdlyInt)) then
    if (HRESPIn(0) = '0') then
      NextXRDlyCnt <= XRDlyReg(31 downto 16);
    else
      NextXRDlyCnt <= XRDlyReg(15 downto 0);
    end if;
  elsif ((HREADYIn = '0') and ((HRESPIn(1) = '1') or ((RespSel(1) = '1') and
         (XRDlyCnt = "0000000000000001"))) and
        (ActiveMaster = ('1' & iHMASTERdlyInt))) then
    NextXRDlyCnt <= unsigned(XRDlyCnt) - 1;
  else
    NextXRDlyCnt <= XRDlyCnt;
  end if;
end process p_XRDlyCntComb;

-- -----------------------------------------------------------------------------
-- For introducing different wait states depending upon type of burst
-- BeatCounter is instantiated.
-- -----------------------------------------------------------------------------
p_BeatCountSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    BeatCount <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    BeatCount <= NextBeatCount;
  end if;
end process p_BeatCountSeq;

-- -----------------------------------------------------------------------------
-- If NSEQ is detected, then BeatCounter is cleared.
-- Else if it is a SEQ and not an INCR, then if HREADY is set, BeatCount has to -- be incremented
-- -----------------------------------------------------------------------------
p_BeatCountComb : process (iHTRANSdlyInt, iHBURSTdlyInt, HREADYIn, BeatCount)
begin
  if (iHTRANSdlyInt = "10") then
    NextBeatCount <= (others => '0');
  elsif ((iHBURSTdlyInt /= "000") and (iHTRANSdlyInt(1) = '1') and
         (HREADYIn = '1')) then
    NextBeatCount <= unsigned(BeatCount) + 1;
  else
    NextBeatCount <= BeatCount;
  end if;
end process p_BeatCountComb;

-- -----------------------------------------------------------------------------
-- HREADY set high immediately if Registers are being accessed and in BUSY and
-- IDLE transfers.
-- Once a SPLIT/RETRY transfer is complete.
-- Else set high only when Wait State Counter is cleared in normal transfers
-- -----------------------------------------------------------------------------
p_HREADYComb : process (iHTRANSdlyInt, iWSCReg1Sel, iWSCReg2Sel, iCRSel,
                        iXRDlyRegSel, iTMRegSel, iARRAY1Sel, iARRAY2Sel,
                        HRESPIn, WSC, FlushEn)
begin
  if ((iWSCReg1Sel= '1') or (iWSCReg2Sel = '1') or (iCRSel = '1') or
     (iTMRegSel = '1') or (iXRDlyRegSel = '1') or
     (iHTRANSdlyInt(1) = '0')) then
    iHREADYOut <= '1';
  elsif ((FlushEn = '1') and (ActiveMaster(4) = '1')) then
    iHREADYOut <= '1';
  elsif ((iHTRANSdlyInt(1) = '1') and ((iARRAY1Sel = '1') or (iARRAY2Sel = '1')
        or (HRESPIn = "01")) and (WSC = "00000000")) then
    iHREADYOut <= '1';
  else
    iHREADYOut <= '0';
  end if;
end process p_HREADYComb;

-- -----------------------------------------------------------------------------
-- Wait State Counter Generation
-- -----------------------------------------------------------------------------
p_WSCSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    WSC <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    WSC <= NextWSC;
  end if;
end process p_WSCSeq;

-- -----------------------------------------------------------------------------
-- When HREADY is set, load new value in Wait State Counter
-- An access to the arrays immediately after the waitstate value has changed,
-- should load the WSC with new value.
-- Else WSCInit value will be loaded
-- If HREADY is not set, WSC is decremented.
-- -----------------------------------------------------------------------------
p_WSCComb : process (HREADYIn, HWDATAdly, WSC, iHWRITEdlyInt, iWSCReg1Sel,
                     iWSCReg2Sel, NextARRAY1Sel, NextARRAY2Sel, WSC1Init,
                     WSC2Init, HADDRdly)
begin
  if (HREADYIn = '1') then
    if (NextARRAY1Sel = '1') then
      if ((iHWRITEdlyInt = '1') and (iWSCReg1Sel = '1')) then
        if (iHBURSTdlyInt(0) = '0') then
          NextWSC <= HWDATAdly(7 downto 0);
        else
          NextWSC <= "0000" & HWDATAdly(3 downto 0);
        end if;
      elsif(HADDRdly(31 downto 8) /= to_stdlogicvector(X"000001")) then
        NextWSC <= unsigned(WSC1Init) + 2;
      else
        NextWSC <= WSC1Init;
      end if;
    elsif (NextARRAY2Sel = '1') then
      if ((iHWRITEdlyInt = '1') and (iWSCReg2Sel = '1')) then
        if (iHBURSTdlyInt(0) = '0') then
          NextWSC <= HWDATAdly(7 downto 0);
        else
          NextWSC <= "0000" & HWDATAdly(3 downto 0);
        end if;
      elsif(HADDRdly(31 downto 8) /= to_stdlogicvector(X"000005")) then
        NextWSC <= unsigned(WSC2Init) + 2;
      else
        NextWSC <= WSC2Init;
      end if;
    end if;
  else
    NextWSC <= unsigned(WSC) - 1;
  end if;
end process p_WSCComb;

-- -----------------------------------------------------------------------------
-- Assign local copies of signals to the outputs
-- -----------------------------------------------------------------------------
HREADYOut        <= iHREADYOut;
HRESPOut         <= not(iHRESPOut) when (ForceErrResp = '1')
                 else
                    iHRESPOut;
HSPLITOut        <= iHSPLITOut;
HADDRdlyInt      <= iHADDRdlyInt;
HSIZEdlyInt      <= iHSIZEdlyInt;
HWRITEdlyInt     <= iHWRITEdlyInt;
HSELdlyInt       <= iHSELdlyInt;
ARRAY1Sel        <= iARRAY1Sel;
ARRAY2Sel        <= iARRAY2Sel;
WSCReg1Sel       <= iWSCReg1Sel;
WSCReg2Sel       <= iWSCReg2Sel;
CRSel            <= iCRSel;
TMRegSel         <= iTMRegSel;
XRDlyRegSel      <= iXRDlyRegSel;
ForceErrResp     <= CR(2);
RespEn           <= CR(4);

end synth;

-- --================================= END ===================================--
