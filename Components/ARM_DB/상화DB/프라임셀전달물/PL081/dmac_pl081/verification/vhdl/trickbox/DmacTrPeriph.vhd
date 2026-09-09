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
-- File Name              : DmacTrPeriph.vhd.rca
-- File Revision          : 1.5
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block mimics a Peripheral block on the AHB.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

use work.DmacTrPackage.all;

-- -----------------------------------------------------------------------------

entity DmacTrPeriph is
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB Clock
        HRESETn          : in    std_logic; -- AHB Reset
        HADDR            : in    std_logic_vector
                                           (SLAVEADDRHB downto SLAVEADDRLB);
                                            -- Register Address
        HSELREG          : in    std_logic; -- Register Select
        HWRITE           : in    std_logic; -- Register Read/Write
        HTRANS           : in    std_logic_vector(1 downto 0);
                                            -- Type of transfer on Register
                                            -- interface
        HSIZE            : in    std_logic_vector(2 downto 0);
                                            -- The width of the register data
                                            -- transfer
        HWDATA           : in    std_logic_vector(31 downto 0);
                                            -- Register Write Data
        HREADYIN         : in    std_logic; -- Ready response to register
                                            -- interface
        HADDRM           : in    std_logic_vector
                                           (MASTERADDRHB downto MASTERADDRLB);
                                            -- Peripheral Address
        HSELPERIPH       : in    std_logic; -- Peripheral Select
        HWRITEM          : in    std_logic; -- Peripheral Read/Write
        HTRANSM          : in    std_logic_vector(1 downto 0);
                                            -- Type of transfer on Peripheral
                                            -- Interface
        HBURSTM          : in    std_logic_vector(2 downto 0);
                                            -- Type of AHB Burst on Peripheral
                                            -- Interface
        HSIZEM           : in    std_logic_vector(2 downto 0);
                                            -- The width of the transfer on
                                            -- Peripheral Interface
        HWDATAM          : in    std_logic_vector(31 downto 0);
                                            -- Peripheral Write Data
        HREADYINM        : in    std_logic; -- Ready response to Peripheral
                                            -- interface

        DMACTC           : in    std_logic; -- DMA Terminal Count signal

        DMACCLR          : in    std_logic; -- DMA clear signal
-- Outputs
        HREADYOUT        : out   std_logic; -- Ready response from Register
                                            -- interface
        HRESP            : out   std_logic_vector(1 downto 0);
                                            -- Transfer response from Register
                                            -- interface
        HRDATA           : out   std_logic_vector(31 downto 0);
                                            -- Register read Data
        HREADYOUTM       : out   std_logic; -- Ready response from Peripheral
                                            -- interface
        HRESPM           : out   std_logic_vector(1 downto 0);
                                            -- Transfer response from
                                            -- Peripheral interface
        HRDATAM          : out   std_logic_vector(31 downto 0);
                                            -- Peripheral read data
        DMACSREQ         : out   std_logic; -- DMA Single Request
        DMACBREQ         : out   std_logic; -- DMA Burst Request
        DMACLSREQ        : out   std_logic; -- DMA Last Single Request
        DMACLBREQ        : out   std_logic  -- DMA Last Burst Request
       );
end DmacTrPeriph;

-- -----------------------------------------------------------------------------
--
--                                DmacTrPeriph
--                                ============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--        This module is a behavioural model of a Peripheral interface. It has 2
-- AHB slave interfaces. One AHB slave port is used to program the control
-- registers and other slave port is used by the DMAC for peripheral accesses
-- control registers are programmed to provide different data generation
-- methods and various responses depending on data patterns and for the
-- generation of all DMA requests. During read operation, this module generates
-- the required number of data depending on data generation method. Any one data
-- generation method, out of Four data generation methods, can be used. During
-- write operation, it generates the expected data and compares it with
-- incoming data. The module flags an error if there is mismatch in incoming
-- and expected data. This module also checks whether DMATC and DMACLR signals
-- are asserted at specified time. The Data generation methods are Random,
-- GRAYCODE, Address based and Data based method. The following sub methods are
-- used along with above data generation methods. The sub methods are Increment,
-- Decrement, 1's complement and 2's complement. The above sub methods are only
-- applicable to Address and Data generation method.
--
-- -----------------------------------------------------------------------------

-- --=========================== ARCHITECTURE ================================--

architecture behavioural of DmacTrPeriph is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------
component DmacTrCounter
  generic (
           CounterWidth     : integer := 8
          );
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        CountIn          : in    std_logic_vector((CounterWidth - 1) downto 0);
        Load             : in    std_logic;
        Enable           : in    std_logic;
        Reset            : in    std_logic;
        TerminalCount    : out   std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal PeriphAddr       : std_logic_vector(MASTERADDRHB downto MASTERADDRLB);
-- Clocked peripheral address

signal RegAddr          : std_logic_vector(SLAVEADDRHB downto SLAVEADDRLB);
-- Clocked register address

signal RegTrans         : std_logic_vector(1 downto 0);
-- Clocked HTRANS

signal PeriphTrans      : std_logic_vector(1 downto 0);
-- Clocked HTRANSM

signal Selected         : std_logic;
-- Selected state of the peripheral

signal iHRESP           : std_logic_vector(1 downto 0);
-- Data transfer response from register interface

signal RegSize          : std_logic_vector(2 downto 0);
-- Clocked HSIZE

signal PeriphSize       : std_logic_vector(2 downto 0);
-- Clocked HSIZEM

signal iHRESPM          : std_logic_vector(1 downto 0);
-- Data transfer response from peripheral interface

signal iHREADYOUT       : std_logic;
-- Ready response from register interface

signal iHREADYOUTM      : std_logic;
-- Ready response from peripheral interface

signal iHRDATA          : std_logic_vector(31 downto 0);
-- Register read data

signal iHRDATAM         : std_logic_vector(31 downto 0);
-- Peripheral read data

signal iDMACSREQ        : std_logic;
-- DMA Single Request

signal iDMACBREQ        : std_logic;
-- DMA Burst Request

signal iDMACLSREQ       : std_logic;
-- DMA Last Single Request

signal iDMACLBREQ       : std_logic;
-- DMA Last Burst Request

signal PeriphRegWrEn    : std_logic;
-- Write enable for peripheral-specific register

signal Cyc1             : std_logic;
-- First cycle of error response

signal Cyc2             : std_logic;
-- Second cycle of error response

signal Err1             : std_logic;
-- First cycle of split/retry/error response

signal Err2             : std_logic;
-- Second cycle of split/retry/error response

signal PeriphWrEn       : std_logic;
-- Peripheral write enable

signal PeriphEnable     : std_logic;
-- Peripheral model enable bit

signal PeriphReset      : std_logic;
-- Peripheral reset bit

signal DataGenMethod    : std_logic_vector(1 downto 0);
-- Data pattern generation method

signal DefaultNoOfResp  : std_logic_vector(7 downto 6);
-- Default number of split and retry response

signal PrgmRespCount    : std_logic_vector(23 downto 22) := (others => '0');
-- Programmed number of split and retry response

signal RespCount        : std_logic_vector(2 downto 0) := (others => '0');
-- To Count number of split and retry response asserted

signal DefIndicate      : std_logic := '0';
-- To indicate Default split and retry response asserted

signal PrgmIndicate     : std_logic := '0';
-- To indicate programmed split and retry response asserted

signal PrgmIndSync      : std_logic := '0';
-- Delayed PrgmIndicate

signal PrgmRespSync     : std_logic_vector(1 downto 0) := "00";
-- Delayed Programmed Response

signal DefaultWaitCyc   : std_logic_vector(5 downto 2);
-- Default wait cycles to be asserted by peripheral

signal ProgramedWaitCyc : std_logic_vector(21 downto 18) := (others => '0');
-- Programmed wait cycles to be asserted by peripheral

signal PeriphWaitCyc    : std_logic;
-- To indicate wait cycle to be asserted

signal Endianness       : std_logic := '0';
-- Indicates peripheral module is configured for Little/Big endian mode

signal DataTransfer     : std_logic := '0';
-- To indicate data is transferred

signal TransferClear    : std_logic;
-- To clear DataTransfer signal

signal WaitCycCount     : std_logic_vector(3 downto 0) := (others => '0');
-- To count number of wait cycle asserted

signal RdTotalTrans     : std_logic_vector(15 downto 0)  := (others =>'0');
-- To count number of read data

signal WrTotalTrans     : std_logic_vector(15 downto 0)  := (others =>'0');
-- To count number of write data

signal DefaultResp      : std_logic_vector(1 downto 0);
-- Default Response should be asserted by peripheral

signal Offset           : std_logic_vector(3 downto 0);
-- Offset to generate address based data

signal DataMethod       : std_logic_vector(7 downto 6);
-- Type of method to be used to generate address based data

signal RdPreviousData   : std_logic_vector(7 downto 0) := (others =>'0');
-- To hold the previous cycle memory read data

signal WrPreviousData   : std_logic_vector(7 downto 0) := (others =>'0');
-- To hold the previous cycle memory write data

signal ExpectedData     : std_logic_vector(31 downto 0) := (others => '0');
-- To hold expected data

signal RespOkInform     : std_logic;
-- Indicates OK response should be asserted

signal RespClear        : std_logic;
-- To clear response count.

signal FirstAccess      : std_logic := '0';
-- Indicate first access of DMAC

signal DMASCountEn      : std_logic;
-- DMA Single Request counter enable bit

signal DMABCountEn      : std_logic;
-- DMA Burst Request counter enable bit

signal DMALSCountEn     : std_logic;
-- DMA Last Single Request counter enable bit

signal DMALBCountEn     : std_logic;
-- DMA Last Burst Request counter enable bit

signal DMACLRCountEn    : std_logic;
-- DMA clear counter enable bit

signal DMATCCountEn     : std_logic;
-- DMA TC counter enable bit

signal DMASCntLoad      : std_logic;
-- DMA Single Request counter load bit

signal DMABCntLoad      : std_logic;
-- DMA Burst Request counter load bit

signal DMALSCntLoad     : std_logic;
-- DMA Last Single Request counter load bit

signal DMALBCntLoad     : std_logic;
-- DMA Last Burst Request counter load bit

signal DMACLRCntLoad    : std_logic;
-- DMA clear counter load bit

signal DMATCCntLoad     : std_logic;
-- DMA TC counter load bit

signal DMASTermCount    : std_logic;
-- DMA Single Terminal Count

signal DMABTermCount    : std_logic;
-- DMA Burst Terminal Count

signal DMALSTermCount   : std_logic;
-- DMA Last Single Terminal Count

signal DMALBTermCount   : std_logic;
-- DMA Last Burst Terminal Count

signal DMACLRTermCount  : std_logic;
-- DMA clear Terminal Count

signal DMATCTermCount   : std_logic;
-- DMA TC Terminal Count

signal NxtRespCount     : std_logic_vector(2 downto 0)   := (others =>'0');
-- D Input of RespCount

signal NxtRegAddr       : std_logic_vector(SLAVEADDRHB downto SLAVEADDRLB);
-- D Input RegAddr

signal NxtRegTrans      : std_logic_vector(1 downto 0);
-- D input of RegTrans

signal NxtPeriphTrans   : std_logic_vector(1 downto 0);
-- D input of PeriphTrans

signal NxtRegSize       : std_logic_vector(2 downto 0);
-- D input of RegSize

signal NxtPeriphSize    : std_logic_vector(2 downto 0);
-- D input of PeriphSize

signal NxtPeriphAddr    : std_logic_vector(MASTERADDRHB downto MASTERADDRLB);
-- D Input RegAddr

signal NxtPeriphRegWrEn : std_logic;
-- D Input of PeriphRegWrEn

signal NxtPeriphWrEn    : std_logic;
-- D Input of PeriphWrEn

signal NxtDMACSREQ      : std_logic;
-- D input of iDMACSREQ

signal NxtDMACBREQ      : std_logic;
-- D input of iDMACBREQ

signal NxtDMACLSREQ     : std_logic;
-- D input of iDMACLSREQ

signal NxtDMACLBREQ     : std_logic;
-- D input of iDMACLBREQ

signal NxtDMASCntLoad   : std_logic;
-- D input of DMA single request counter load

signal NxtDMABCntLoad   : std_logic;
-- D input of DMA single request counter load

signal NxtDMALSCntLoad  : std_logic;
-- D input of DMA single request counter load

signal NxtDMALBCntLoad  : std_logic;
-- D input of DMA single request counter load

signal NxtDMACLRCntLoad : std_logic;
-- DMA clear counter load bit

signal NxtDMATCCntLoad  : std_logic;
-- DMA TC counter load bit

signal NxtDMASCountEn   : std_logic;
-- D input of DMA Single Request counter enable bit

signal NxtDMABCountEn   : std_logic;
-- D input of DMA Burst Request counter enable bit

signal NxtDMALSCountEn  : std_logic;
-- D input of DMA Last Single Request counter enable bit

signal NxtDMALBCountEn  : std_logic;
-- D input of DMA Last Burst Request counter enable bit

signal NxtDMACLRCountEn : std_logic;
-- D input of DMA clear counter enable bit

signal NxtDMATCCountEn  : std_logic;
-- D input of DMA TC counter enable bit

signal NxtPrgmRespSync  : std_logic_vector(1 downto 0);
-- D Input of PrgmRespSync

-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Type declarations
-- -----------------------------------------------------------------------------
type RegArray is array ((NO_OF_REG-1) downto 0) of
                                        std_logic_vector(31 downto 0);

signal iPeriphReg     : RegArray;
-- Peripheral Registers

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- Instantiation of DMACTrSCounter
-- -----------------------------------------------------------------------------
DMACTrSCounter : DmacTrCounter
  generic map (
               CounterWidth     => 8
              )
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            CountIn          => iPeriphReg(2)(7 downto 0),
            Load             => DMASCntLoad,
            Enable           => DMASCountEn,
            Reset            => PeriphReset,
            TerminalCount    => DMASTermCount
           );

-- -----------------------------------------------------------------------------
-- Instantiation of DMACTrBCounter
-- -----------------------------------------------------------------------------
DMACTrBCounter : DmacTrCounter
  generic map (
               CounterWidth     => 8
              )
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            CountIn          => iPeriphReg(2)(15 downto 8),
            Load             => DMABCntLoad,
            Enable           => DMABCountEn,
            Reset            => PeriphReset,
            TerminalCount    => DMABTermCount
           );

-- -----------------------------------------------------------------------------
-- Instantiation of DMACTrLSCounter
-- -----------------------------------------------------------------------------
DMACTrLSCounter : DmacTrCounter
  generic map (
               CounterWidth     => 8
              )
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            CountIn          => iPeriphReg(2)(23 downto 16),
            Load             => DMALSCntLoad,
            Enable           => DMALSCountEn,
            Reset            => PeriphReset,
            TerminalCount    => DMALSTermCount
           );

-- -----------------------------------------------------------------------------
-- Instantiation of DMACTrLBCounter
-- -----------------------------------------------------------------------------
DMACTrLBCounter : DmacTrCounter
  generic map (
               CounterWidth     => 8
              )
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            CountIn          => iPeriphReg(2)(31 downto 24),
            Load             => DMALBCntLoad,
            Enable           => DMALBCountEn,
            Reset            => PeriphReset,
            TerminalCount    => DMALBTermCount
           );

-- -----------------------------------------------------------------------------
-- Instantiation of DMACTrCLRCounter
-- -----------------------------------------------------------------------------
DMACTrCLRCounter : DmacTrCounter
  generic map (
               CounterWidth     => 32
              )
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            CountIn          => iPeriphReg(3),
            Load             => DMACLRCntLoad,
            Enable           => DMACLRCountEn,
            Reset            => PeriphReset,
            TerminalCount    => DMACLRTermCount
           );

-- -----------------------------------------------------------------------------
-- Instantiation of DMACTrTCCounter
-- -----------------------------------------------------------------------------
uDMACTrTCCounter : DmacTrCounter
  generic map (
               CounterWidth     => 32
              )
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            CountIn          => iPeriphReg(4),
            Load             => DMATCCntLoad,
            Enable           => DMATCCountEn,
            Reset            => PeriphReset,
            TerminalCount    => DMATCTermCount
           );
-- -----------------------------------------------------------------------------
-- Latching of Register Address
-- -----------------------------------------------------------------------------
p_RegAddrComb : process (HSELREG, HREADYIN, HTRANS, HADDR, RegAddr)
begin
  NxtRegAddr        <= RegAddr;
  if ((HSELREG = '1') and (HREADYIN = '1') and
         (HTRANS = NSEQ or HTRANS = SEQ)) then
     NxtRegAddr          <= HADDR(SLAVEADDRHB downto SLAVEADDRLB);
  end if;
end process p_RegAddrComb;

-- -----------------------------------------------------------------------------
-- Register Address sequential logic
-- -----------------------------------------------------------------------------
p_RegAddrSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    RegAddr           <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    RegAddr           <= NxtRegAddr;
  end if;
end process p_RegAddrSeq;

-- -----------------------------------------------------------------------------
-- Latching of Peripheral Address
-- -----------------------------------------------------------------------------
p_PeriphAddrComb : process (HSELPERIPH, HREADYINM, HTRANSM, HADDRM, PeriphAddr)
begin
  NxtPeriphAddr     <= PeriphAddr;
  if ((HSELPERIPH = '1') and (HREADYINM = '1') and
        (HTRANSM = NSEQ or HTRANSM = SEQ)) then
    NxtPeriphAddr    <= HADDRM(MASTERADDRHB downto MASTERADDRLB);
  end if;
end process p_PeriphAddrComb;

-- -----------------------------------------------------------------------------
-- Peripheral Address sequential logic
-- -----------------------------------------------------------------------------
p_PeriphAddrSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    PeriphAddr        <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    PeriphAddr        <= NxtPeriphAddr;
  end if;
end process p_PeriphAddrSeq;

-- -----------------------------------------------------------------------------
-- Latching of HTRANS
-- -----------------------------------------------------------------------------
p_RegTransComb : process (HSELREG, HREADYIN, HTRANS, RegTrans)
begin
  NxtRegTrans       <= RegTrans;
  if (HSELREG = '1') and (HREADYIN = '1') then
    NxtRegTrans         <= HTRANS(1 downto 0);
  end if;
end process p_RegTransComb;

-- -----------------------------------------------------------------------------
-- Register Trans sequential logic
-- -----------------------------------------------------------------------------
p_RegTransSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    RegTrans          <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    RegTrans          <= NxtRegTrans;
  end if;
end process p_RegTransSeq;

-- -----------------------------------------------------------------------------
-- Latching of HTRANSM
-- -----------------------------------------------------------------------------
p_PeriTranComb : process (HSELPERIPH, HREADYINM, HTRANSM, PeriphTrans, Selected)
begin
  NxtPeriphTrans    <= PeriphTrans;
  if (HREADYINM = '1' and HSELPERIPH = '1') then
    NxtPeriphTrans    <= HTRANSM;
  elsif (Selected = '0') then
    NxtPeriphTrans    <= IDLE;
  end if;
end process p_PeriTranComb;

-- -----------------------------------------------------------------------------
-- Peripheral Trans sequential logic
-- -----------------------------------------------------------------------------
p_PeriphTransSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    PeriphTrans       <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    PeriphTrans       <= NxtPeriphTrans;
  end if;
end process p_PeriphTransSeq;

-- -----------------------------------------------------------------------------
-- Latching of HSIZE
-- -----------------------------------------------------------------------------
p_RegSizeComb : process (HSELREG, HREADYIN, HSIZE, RegSize, HTRANS)
begin
  NxtRegSize        <= RegSize;
  if ((HSELREG = '1') and (HREADYIN = '1') and
        (HTRANS = NSEQ or HTRANS = SEQ)) then
    NxtRegSize          <= HSIZE(2 downto 0);
  end if;
end process p_RegSizeComb;

-- -----------------------------------------------------------------------------
-- Register SIZE sequential logic
-- -----------------------------------------------------------------------------
p_RegSizeSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    RegSize           <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    RegSize           <= NxtRegSize;
  end if;
end process p_RegSizeSeq;

-- -----------------------------------------------------------------------------
-- Peripheral SIZE sequential logic
-- -----------------------------------------------------------------------------
p_PeriphSizeComb : process (HSELPERIPH, HREADYINM, HSIZEM, PeriphSize, HTRANSM)
begin
  NxtPeriphSize     <= PeriphSize;
  if ((HSELPERIPH = '1') and (HREADYINM = '1') and
          (HTRANSM = NSEQ or HTRANSM = SEQ)) then
    NxtPeriphSize       <= HSIZEM(2 downto 0);
  end if;
end process p_PeriphSizeComb;

-- -----------------------------------------------------------------------------
-- Latching of HSIZEM
-- -----------------------------------------------------------------------------
p_PeriphSizeSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    PeriphSize        <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    PeriphSize        <= NxtPeriphSize;
  end if;
end process p_PeriphSizeSeq;

-- -----------------------------------------------------------------------------
-- Peripheral Selected State Generation Block
-- The Selected signal indicates selected state of the peripheral block. It
-- indicates the valid duration where the peripheral block should assert default
-- or programmed response.
-- The Selected signal is set when there is HREADYINM or default/programmed
-- response to be asserted. The signal is cleared when all default/programmed
-- responses are asserted for current transfer.
-- -----------------------------------------------------------------------------
p_SelcectedSeq : process (HRESETn, HREADYINM, PeriphWaitCyc, RespClear,
                          PeriphEnable, DefIndicate, PrgmIndicate)
begin
 if (HRESETn = '0') then
    Selected          <= '0';
 else
   if (HREADYINM = '1' or ((DefIndicate = '1' or PrgmIndicate = '1') or
       (PeriphWaitCyc = '1' and RespClear = '0' and PeriphEnable = '1'))) then
     Selected       <= '1';
   else
     Selected       <= '0';
   end if;
 end if;
end process p_SelcectedSeq;
-- -----------------------------------------------------------------------------
-- D input of the PeriphRegWrEn assignment
-- -----------------------------------------------------------------------------
p_RegWrGenComb : process (HTRANS, HSELREG, HREADYIN, HWRITE)
begin
  if ((HSELREG = '1') and (HREADYIN = '1') and
       (HTRANS = NSEQ or HTRANS = SEQ) and (HWRITE = '1')) then
    NxtPeriphRegWrEn  <= '1';
  else
    NxtPeriphRegWrEn  <= '0';
  end if;
end process p_RegWrGenComb;

-- -----------------------------------------------------------------------------
-- Generation of Register read/write signal
-- -----------------------------------------------------------------------------
p_RegWrGenSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    PeriphRegWrEn     <= '0';
  elsif (HCLK'event and HCLK = '1') then
    PeriphRegWrEn     <= NxtPeriphRegWrEn;
  end if;
end process p_RegWrGenSeq;

-- -----------------------------------------------------------------------------
-- D input of the PeriphRegWrEn assignment
-- -----------------------------------------------------------------------------
p_PeriphWrComb : process (HTRANSM, HSELPERIPH, HREADYINM, HWRITEM)
begin
  if ((HSELPERIPH = '1') and (HREADYINM = '1') and
       (HTRANSM = NSEQ or HTRANSM = SEQ) and (HWRITEM = '1')) then
    NxtPeriphWrEn     <= '1';
  else
    NxtPeriphWrEn     <= '0';
  end if;
end process p_PeriphWrComb;

-- -----------------------------------------------------------------------------
-- Generation of Peripheral read/write signal
-- -----------------------------------------------------------------------------
p_PeriphWrGenSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    PeriphWrEn        <= '0';
  elsif (HCLK'event and HCLK = '1') then
    PeriphWrEn        <= NxtPeriphWrEn;
  end if;
end process p_PeriphWrGenSeq;

-- ----------------------------------------------------------------------------
-- Peripheral Register Read Write Block
-- This combination process is responsible for writing and reading of register
-- block. It also gives AHB response for each read/write access to register
-- block.
-- ----------------------------------------------------------------------------
p_RegRdWrComb : process (HRESETn, PeriphRegWrEn, iPeriphReg, RegTrans, RegSize,
                         RegAddr)
begin
  iHRDATA           <= (others => '0');

  if (HRESETn = '0') then
    iHRDATA           <= (others => '0');
    iHRESP            <= (others => '0');
  end if;

  if (PeriphRegWrEn = '1') then
    if (RegTrans = NSEQ or RegTrans = SEQ) then
      -- If the write access to register block is word wide, update register
      -- block with new data. If the register write access is not word wide,
      -- flag Error message
      if (RegSize = WORD) then
        iHRESP            <= OKAY_RESP;
      else
        assert RegSize = WORD
        report "DmacTrPeriph1 : WRITE ACCESS IS NOT WORD WIDE"
        severity ERROR;
        iHRESP            <= ERROR_RESP;
      end if;
    else
      iHRESP   <= OKAY_RESP;
    end if;
  else
    if (RegTrans = NSEQ or RegTrans = SEQ) then
       -- If the register read access is not word wide, flag Error message
      if (RegSize = WORD) then
        iHRDATA           <= iPeriphReg(to_integer(RegAddr));
        iHRESP            <= OKAY_RESP;
      else
        assert RegSize = WORD
        report "DmacTrPeriph2 : READ ACCESS IS NOT WORD WIDE"
        severity ERROR;
        iHRESP            <= ERROR_RESP;
      end if;
     else
      iHRESP            <= OKAY_RESP;
    end if;
  end if;
end process p_RegRdWrComb;

-- ----------------------------------------------------------------------------
-- Write Block for Peripheral Registers
-- This process is responsible for the updating of register block. When there is
-- valid write to register block, it writes in register indicated by RegAddr.
-- This process clears all control register except control 1 register when
-- Peripheral reset bit is set. It clears all registers when HRESETn is
-- asserted.
-- -----------------------------------------------------------------------------
p_RegSeq : process (HCLK, HRESETn)
variable TempReg1Value : std_logic_vector(31 downto 0) := (others => '0');
begin
  if (HRESETn = '0') then
    iPeriphReg <= (others =>(others => '0'));
  elsif (HCLK'event and HCLK = '1') then
    if (PeriphReset = '1') then
      TempReg1Value    := iPeriphReg(0);
      iPeriphReg       <= (others =>(others => '0'));
      iPeriphReg(0)    <= TempReg1Value;
    end if;
    if ((PeriphRegWrEn = '1') and (RegSize = WORD)) then
      iPeriphReg(to_integer(RegAddr)) <= HWDATA(31 downto 0);
    end if;
  end if;
end process p_RegSeq;

-- -----------------------------------------------------------------------------
-- Assigning internal signals values
-- -----------------------------------------------------------------------------
PeriphEnable      <= iPeriphReg(0)(31);

PeriphReset       <= iPeriphReg(0)(30);

Endianness        <= iPeriphReg(0)(10);

DataGenMethod     <= iPeriphReg(0)(9 downto 8);

DefaultNoOfResp   <= iPeriphReg(0)(7 downto 6);

DefaultWaitCyc    <= iPeriphReg(0)(5 downto 2);

DefaultResp       <= iPeriphReg(0)(1 downto 0);

DataMethod        <= iPeriphReg(1)(7 downto 6);

Offset            <= iPeriphReg(1)(3 downto 0);

-- -----------------------------------------------------------------------------
-- Register two Cycle Response Generation
-- First Cycle Generation
-- -----------------------------------------------------------------------------
-- Cyc1 is set HIGH during the first cycle of an error response. The registered
-- Cyc2 is HIGH during the second cycle of the error response.

Cyc1 <= '1' when (iHRESP = ERROR_RESP and Cyc2 = '0')
     else
        '0';

-- -----------------------------------------------------------------------------
-- Register two Cycle Response Generation
-- Second Cycle Generation
-- -----------------------------------------------------------------------------
p_Cyc2Seq : process (HRESETn, HCLK)
begin
  if HRESETn = '0' then
    Cyc2              <= '0';
  elsif (HCLK'event and HCLK = '1') then
    Cyc2              <= Cyc1;
  end if;
end process p_Cyc2Seq;

-- -----------------------------------------------------------------------------
-- Peripheral two Cycle Response Generation
-- First Cycle Generation
-- -----------------------------------------------------------------------------
-- Err1 is set HIGH during the first cycle of an error response. The registered
-- Err2 is HIGH during the second cycle of the error response.

Err1 <= '1' when (iHRESPM /= OKAY_RESP and Err2 = '0')
     else
        '0';

-- -----------------------------------------------------------------------------
-- Peripheral two Cycle Response Generation
-- Second Cycle Generation
-- -----------------------------------------------------------------------------
p_Err2Seq : process (HRESETn, HCLK)
begin
  if HRESETn = '0' then
    Err2              <= '0';
  elsif (HCLK'event and HCLK = '1') then
    Err2              <= Err1;
  end if;
end process p_Err2Seq;

-- ----------------------------------------------------------------------------
-- Register Ready Response generator Block
-- The HREADYOUT is kept low in first cycle of two cycle response(i.e. When
-- Cyc1 is set and Cyc2 is cleared).
-- ----------------------------------------------------------------------------
p_RegReadyComb  : process (HRESETn, Cyc1, Cyc2)
begin
  if (HRESETn = '0') then
    iHREADYOUT        <= '1';
  end if;
  if (Cyc1 = '1' and Cyc2 = '0') then
    iHREADYOUT        <= '0';
  elsif (Cyc1 = '0' and Cyc2 = '1') then
    iHREADYOUT        <= '1';
  end if;
end process p_RegReadyComb;

-- ----------------------------------------------------------------------------
-- First Access signal Generation Block
-- ----------------------------------------------------------------------------
p_FirstAccComb : process (HRESETn, HREADYINM)
begin
  if (HRESETn = '0') then
    FirstAccess        <= '0';
  elsif (HREADYINM = '1') then
    FirstAccess        <= '1';
  end if;
end process p_FirstAccComb;

-- ----------------------------------------------------------------------------
-- Peripheral Ready Response generator Block
-- The HREADYOUTM is kept low in first cycle of two cycle response(i.e. When
-- Err1 is set and Err2 is cleared) or when Wait response is asserted.
-- ----------------------------------------------------------------------------
p_PeriphReadyComb  : process (HRESETn, Err1, Err2, PeriphWaitCyc)
begin
  if (HRESETn = '0') then
    iHREADYOUTM       <= '1';
  elsif (Err1 = '1' and Err2 = '0') then
    iHREADYOUTM       <= '0';
  elsif (Err1 = '0' and Err2 = '1') then
    iHREADYOUTM       <= '1';
  elsif (PeriphWaitCyc = '1') then
    iHREADYOUTM       <= '0';
  elsif (PeriphWaitCyc ='0') then
    iHREADYOUTM       <= '1';
  end if;
end process p_PeriphReadyComb;

-- ----------------------------------------------------------------------------
-- Peripheral Read data generation Block
-- This process is responsible for peripheral block read access.
-- ----------------------------------------------------------------------------
p_PeriphRdSeq : process (HRESETn, HCLK)
variable RdCount             : integer := 0;
variable Shifted_DataRd      : std_logic_vector(31 downto 0) := (others =>'0');
variable TempRd              : std_logic_vector(7 downto 0)  := (others =>'0');
variable RdFlag              : boolean;
variable TempAddr            : std_logic_vector(7 downto 0)  := (others =>'0');
begin
  if (HRESETn = '0') then
    -- Clear previous cycle memory read data.
    RdPreviousData    <= (others => '0');
    -- Clear HRDATAM.
    iHRDATAM          <= (others => '0');
    -- Clear Number of total read data transfer.
    RdPreviousData    <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    if (PeriphReset = '1') then
      -- If Peripheral Reset bit is set, clear previous cycle peripheral data
      -- and number of total read data transfer.
      RdPreviousData    <= (others => '0');
      RdTotalTrans      <= (others => '0');
    end if;

    if (RdTotalTrans = to_stdlogicvector(X"0000")) then
      RdFlag            := TRUE;
    end if;

    if (RdFlag = TRUE) then
      -- Load seed from control register 1 for read data generation.
      RdPreviousData    <= iPeriphReg(1)(31 downto 24);
    end if;

    -- The RdCount indicates number of times data generation function to be
    -- called to generate read data. The Data generation functions returns byte
    -- wide data.
    -- If HSIZEM is BYTE then Data generation function is called only once.
    -- If HSIZEM is Half Word then Data generation function is called twice as
    -- function returns only byte wide data.
    if (HSIZEM = BYTE) then
      RdCount             := 1;
    elsif (HSIZEM = HWORD) then
      RdCount             := 2;
    elsif (HSIZEM = WORD) then
      RdCount             := 4;
    end if;

    if ((HSELPERIPH = '1') and (HREADYINM = '1')) then
      if (HWRITEM = '0' and RespCount = "000" and RespClear = '0') then
        if (HTRANSM = NSEQ or HTRANSM = SEQ) then
          if (FirstAccess = '1') then
            if (PeriphEnable = '1') then
              if (HSIZEM = BYTE or HSIZEM = HWORD or HSIZEM = WORD) then
                -- Load previous cycle Read data.
                TempRd           := RdPreviousData;
                Shifted_DataRd   := (others =>'0');
                TempAddr         := HADDRM(7 downto 0);
                R2: for i in 1 to RdCount loop
                  case DataGenMethod is
                    when RANDOM =>
                      -- RANDOM Data generation method. Call Random Data
                      -- generator function
                      RdFlag           := False;
                      TempRd           := PRBSDataGen(TempRd);
                    when GRAYCODE =>
                      -- GRAYCODE Data generation method. Call GRAYCODE Data
                      -- generator function
                      RdFlag           := False;
                      TempRd           := GrayDataGen(TempRd);
                    when ADDRESSBASED =>
                      -- Address Based Data Generation Method
                      TempRd           := AddrBasedGen(TempAddr, Offset,
                                                       DataMethod);
                      TempAddr         := TempAddr + 1;
                    when DATABASED =>
                      -- Data Based Data generation Method.
                      RdFlag           := False;
                      TempRd           := DataBasedGen(TempRD, Offset,
                                                       DataMethod);
                    when others =>
                      -- Invalid Data Generation Method, assert error message
                      assert (DataGenMethod = RANDOM or
                              DataGenMethod = GRAYCODE or
                              DataGenMethod = ADDRESSBASED or
                              DataGenMethod = DATABASED
                             )
                      report " DmacTrPeriph3 : INVALID DATA GENERATION METHOD"&
                             " FOR READ DATA COMPARISION"
                      severity ERROR;
                  end case;
                  if (Endianness = '0') then
                    -- Little Endian Mode
                    if (HSIZEM = BYTE) then
                      if (HADDRM(1 downto 0) = "00") then
                        Shifted_DataRd(7 downto 0) := TempRd;
                      elsif (HADDRM(1 downto 0) = "01") then
                        Shifted_DataRd(15 downto 8) := TempRd;
                      elsif (HADDRM(1 downto 0) = "10") then
                        Shifted_DataRd(23 downto 16) := TempRd;
                      elsif (HADDRM(1 downto 0) = "11") then
                        Shifted_DataRd(31 downto 24) := TempRd;
                      end if;
                    elsif (HSIZEM = HWORD) then
                         Shifted_DataRd((8 * i )- 1 downto (8* i) -8) := TempRd;
                         if (i = 2) then
                           if (HADDRM(1 downto 0) = "10") then
                             Shifted_DataRd := Shifted_DataRd(15 downto 0) &
                                                            "0000000000000000";
                           end if;
                         end if;
                    elsif (HSIZEM = WORD) then
                      Shifted_DataRd((8 * i )- 1 downto (8* i) -8) := TempRd;
                    end if;
                  else
                  -- Big Endian Mode
                    if (HSIZEM = BYTE) then
                      if (HADDRM(1 downto 0) = "00") then
                        Shifted_DataRd(31 downto 24) := TempRd;
                      elsif (HADDRM(1 downto 0) = "01") then
                        Shifted_DataRd(23 downto 16) := TempRd;
                      elsif (HADDRM(1 downto 0) = "10") then
                        Shifted_DataRd(15 downto 8) := TempRd;
                      elsif (HADDRM(1 downto 0) = "11") then
                        Shifted_DataRd(7 downto 0) := TempRd;
                      end if;
                    elsif (HSIZEM = HWORD) then
                      Shifted_DataRd((8 * i )- 1 downto (8* i) -8) := TempRd;
                      if (i = 2) then
                        if (HADDRM(1 downto 0) = "00") then
                          Shifted_DataRd := Shifted_DataRd(15 downto 0) &
                                                          "0000000000000000";
                        end if;
                      end if;
                    elsif (HSIZEM = WORD) then
                      Shifted_DataRd((8 * i )- 1 downto (8* i) -8) := TempRd;
                    end if;
                  end if;
                end loop R2;
                if (DataGenMethod = RANDOM or DataGenMethod = GRAYCODE or
                    DataGenMethod = ADDRESSBASED or DataGenMethod = DATABASED
                   ) then
                  iHRDATAM         <= Shifted_DataRd;
                  RdTotalTrans     <= unsigned(RdTotalTrans) + '1';
                  if (RdFlag = false) then
                    RdPreviousData     <= TempRd;
                  end if;
                else
                  iHRDATAM         <= (others => '0');
                end if;
              end if;
            end if;
          end if;
        end if;
      end if;
    end if;
  end if;
end process p_PeriphRdSeq;

-- ----------------------------------------------------------------------------
-- Peripheral Read Write combinational Block
-- ----------------------------------------------------------------------------
p_PeriphRdWrComb : process (PeriphWrEn, PeriphTrans, PeriphSize, PeriphEnable,
                            FirstAccess, Selected)
begin
  -- If Peripheral Read/Write access is non BYTE/Half Word/Word access then
  -- assert error message. If memory model is not enabled, return error message
  -- to peripheral read/write access.
  if (PeriphWrEn = '1') then
    if (PeriphTrans = NSEQ or PeriphTrans = SEQ) then
      if (PeriphEnable = '1') then
        if (PeriphSize /= BYTE or PeriphSize /= HWORD or
             PeriphSize /= WORD) then
          assert PeriphSize = BYTE or PeriphSize = HWORD or PeriphSize = WORD
          report "DmacTrPeriph4 : WRITE ACCESS OF INVALID HSIZEM "
          severity ERROR;
        end if;
      else
        assert PeriphEnable = '1'
        report "DmacTrPeriph5 : PERIPHERAL MODEL IS NOT ENABLED. INVALID WRITE"&
               " ACCESS"
        severity ERROR;
      end if;
    end if;
  else
    if (PeriphTrans = NSEQ or PeriphTrans = SEQ) then
      if (FirstAccess = '1') then
        if (PeriphEnable = '1') then
          if (PeriphSize /= BYTE or PeriphSize /= HWORD or
                PeriphSize /= WORD) then
            assert PeriphSize = BYTE or PeriphSize = HWORD or PeriphSize = WORD
            report "DmacTrPeriph6 : READ ACCESS OF INVALID HSIZEM "
            severity ERROR;
          end if;
        else
          if (Selected = '1' and FirstAccess = '1' and
                  PeriphTrans /= IDLE) then
            assert PeriphEnable = '1'
            report "DmacTrPeriph7 : PERIPHERAL MODEL IS NOT ENABLED. INVALID"&
                   " READ ACCESS"
            severity ERROR;
          end if;
        end if;
      end if;
    end if;
  end if;
end process p_PeriphRdWrComb;

-- -----------------------------------------------------------------------------
-- Expected Data Generation Block.
-- This process is responsible for the generation of expected data.
-- -----------------------------------------------------------------------------
p_ExpectDataSeq : process (HRESETn, HCLK)
variable WrCount             : integer := 0;
variable Shifted_DataWr      : std_logic_vector(31 downto 0) := (others =>'0');
variable TempWr              : std_logic_vector(7 downto 0) := (others =>'0');
variable WrFlag              : boolean;
variable TempAddr            : std_logic_vector(7 downto 0) := (others =>'0');
begin
  if (HRESETn = '0') then
    -- Clear Expected Data
    ExpectedData      <= (others => '0');
    -- Clear previous cycle Peripheral write data.
    WrPreviousData    <= (others => '0');
    -- Clear Number of total write data transfer.
    WrTotalTrans      <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    if (PeriphReset = '1') then
      -- Clear previous cycle Peripheral write data.
      WrPreviousData    <= (others => '0');
      -- Clear Number of total write data transfer.
      WrTotalTrans      <= (others => '0');
    end if;

    if (WrTotalTrans = to_stdlogicvector(X"0000")) then
      WrFlag            := TRUE;
    end if;

    if (WrFlag = TRUE) then
      -- Load seed from control register 1 for write data generation.
      WrPreviousData    <= iPeriphReg(1)(31 downto 24);
    end if;

    -- The WrCount indicates number of times data generation function to be
    -- called to generate the Expected data. The Data generation functions
    -- returns byte wide data.
    -- If HSIZEM is BYTE then Data generation function is called only once.
    -- If HSIZEM is Half Word then Data generation function is called twice as
    -- function returns only byte wide data.
    if (HSIZEM = BYTE) then
      WrCount             := 1;
    elsif (HSIZEM = HWORD) then
      WrCount             := 2;
    elsif (HSIZEM = WORD) then
      WrCount             := 4;
    end if;

    if (HSELPERIPH = '1' and HREADYINM = '1') then
      if (HWRITEM = '1' and RespCount = "000" and RespClear = '0') then
        if (HTRANSM = NSEQ or HTRANSM = SEQ) then
          if (PeriphEnable = '1') then
            if (HSIZEM = BYTE or HSIZEM = HWORD or HSIZEM = WORD) then
              -- Increment Total Write Data transfer count
              WrTotalTrans       <= unsigned(WrTotalTrans) + '1';
              -- Load previous cycle write data
              TempWr           := WrPreviousData;
              Shifted_DataWr   := (others =>'0');
              TempAddr         := HADDRM(7 downto 0);
              R1: for i in 1 to WrCount loop
               case DataGenMethod is
                  when RANDOM =>
                    -- RANDOM Data generation method. Call Random Data generator
                    -- function
                    WrFlag           := False;
                    TempWr           := PRBSDataGen(TempWr);
                  when GRAYCODE =>
                    -- GRAYCODE Data generation method
                    WrFlag           := False;
                    TempWr           := GrayDataGen(TempWr);
                  when ADDRESSBASED =>
                    -- Address Based Data Generation Method
                    TempWr           := AddrBasedGen(TempAddr, Offset,
                                                     DataMethod);
                    TempAddr         := TempAddr + 1;
                  when DATABASED =>
                    -- Data Based Data generation Method.Call Databased Data
                    -- generator function
                    WrFlag           := False;
                    TempWr           := DataBasedGen(TempWr, Offset,
                                                     DataMethod);
                  when others =>
                    -- Invalid Data Generation method, assert Error message
                    assert (DataGenMethod = RANDOM or
                            DataGenMethod = GRAYCODE or
                            DataGenMethod = ADDRESSBASED or
                            DataGenMethod = DATABASED
                           )
                    report "DmacTrPeriph8 : INVALID DATA GENERATION METHOD FOR"&
                           " WRITE DATA COMPARISION"
                    severity ERROR;
                end case;
                Shifted_DataWr((8 * i )- 1 downto (8* i) -8) := TempWr;
              end loop R1;
              if (HSIZEM = BYTE) then
                ExpectedData     <= Shifted_DataWr(7 downto 0) &
                                    Shifted_DataWr(7 downto 0) &
                                    Shifted_DataWr(7 downto 0) &
                                    Shifted_DataWr(7 downto 0);
              elsif (HSIZEM = HWORD) then
                ExpectedData   <= Shifted_DataWr(15 downto 0) &
                                  Shifted_DataWr(15 downto 0);
              else
                ExpectedData      <= Shifted_DataWr;
              end if;
              if (DataGenMethod = RANDOM or DataGenMethod = GRAYCODE or
                  DataGenMethod = ADDRESSBASED or DataGenMethod = DATABASED
                 ) then
                if (WrFlag = false) then
                  WrPreviousData     <= TempWr;
                end if;
              else
                ExpectedData      <= (others=>'0');
              end if;
            end if;
          end if;
        end if;
      end if;
    end if;
  end if;
end process p_ExpectDataSeq;

-- ----------------------------------------------------------------------------
-- Master Response decision Block
-- This process is responsible for the assertion of HRESPM for peripheral
-- Read/Write access.
-- ----------------------------------------------------------------------------
p_RespDecideComb : process (HRESETn, PeriphReset, PeriphSize, PeriphTrans,
                            PeriphAddr, PeriphEnable, iPeriphReg, DefaultResp,
                            TransferClear, Err2, RespCount, RespClear,
                            RespOkInform, PeriphWaitCyc, Selected, PrgmIndSync,
                            PrgmRespSync, FirstAccess, PeriphWrEn)
variable Flag              : boolean := false;
variable Found             : boolean := false;
variable ValidBits         : integer := 0;
variable i                 : integer := 0;
variable TransCount        : std_logic_vector(15 downto 0);
begin
  NxtRespCount      <= RespCount;
  NxtPrgmRespSync   <= PrgmRespSync;

  if (HRESETn = '0') then
    -- Assert OK response on reset
    iHRESPM           <= (others => '0');
  end if;

  if (HRESETn = '0' or PeriphReset = '1') then
    -- Clear Response count on HRESETn or Periph Reset.
    NxtRespCount      <= (others =>'0');
    -- Clear programmed response on HRESETn or Periph Reset.
    NxtPrgmRespSync   <= (others => '0');
  end if;

  if (TransferClear = '1') then
    -- Clear Data Transfer single when last data transfer is done
    DataTransfer      <= '0';
  end if;

  -- TransCount variable is used for assertion of programmed response. It holds
  -- number of total read/write count depending peripheral read/write data
  -- transfer. For Data based programmed response(i.e. bit 30 of Peripheral
  -- Control register is set)assertion, TransCount is compared with DataCount
  -- field of control register. If TransCount is equal to DataCount, Programmed
  -- response is asserted.
  if (PeriphWrEn = '1') then
    -- Assign Total number of Write Data Transfer to TransCount
    TransCount := WrTotalTrans;
  else
    -- Assign Total number of Read Data Transfer to TransCount
    TransCount := RdTotalTrans;
  end if;

  if (Selected = '1') then
    if (PeriphTrans = IDLE) then
       -- Assert OK response to IDLE transfer
      iHRESPM           <= OKAY_RESP;
    else
      if (PeriphEnable = '1') then
        if (PeriphSize = BYTE or PeriphSize = HWORD or PeriphSize = WORD) then
          if (PeriphReset = '1') then
          -- If Peripheral reset bit is set, assert Error Response for
          -- peripheral read/write access.
            iHRESPM           <= ERROR_RESP;
            assert PeriphReset = '0'
            report " PeriphReset1: Peripheral Reset bit is set. Invalid Access."
            severity Error;
          else
            if (HREADYINM = '1') then
              -- Programmed response assertion block.
              i := 0;
              L4 : for j in 5 to (NO_OF_REG-1) loop
                   -- Check Control register Enable bit is set
                   if (iPeriphReg(j)(31) ='1') then
                     if (iPeriphReg(j)(30) = '0') then
                   -- Address based Programmed Response assertion method
                   -- Determine Valid bits and Compare Periph address with
                   -- AddressCount. If it equals set Flag True.
                       ValidBits := to_integer(iPeriphReg(j)(27 downto 24));
                       if (iPeriphReg(j)(29 downto 28) = "00") then
                         if (PeriphAddr(ValidBits downto 0) =
                             iPeriphReg(j)(ValidBits downto 0)) then
                           Flag              := TRUE;
                         end if;
                       elsif (iPeriphReg(j)(29 downto 28) = "01") then
                         if (PeriphAddr((ValidBits + 1) downto 1) =
                             iPeriphReg(j)(ValidBits downto 0)) then
                           Flag              := TRUE;
                         end if;
                       elsif (iPeriphReg(j)(29 downto 28) = "10") then
                         if (PeriphAddr((ValidBits + 2) downto 2) =
                             iPeriphReg(j)(ValidBits downto 0)) then
                           Flag              := TRUE;
                         end if;
                       end if;
                       if (Flag = TRUE) then
                         Found             := TRUE;
                         DataTransfer      <= '1';
                       end if;
                     else
                     -- Data Based Programmed Response assertion
                     -- Determine Valid number of bits and compare
                     -- TransCount(i.e. Total Read/Write transfer count) with
                     -- Data Count. If it is equals set Flag True.
                       ValidBits := to_integer(iPeriphReg(j)(27 downto 24));
                       if (TransCount(ValidBits downto 0) =
                           iPeriphReg(j)(ValidBits downto 0)) then
                         Flag              := TRUE;
                       end if;
                       if (Flag = TRUE) then
                         Found             := TRUE;
                         DataTransfer      <= '1';
                       end if;
                     end if;
                   end if;
                   -- Exit loop if any programmed response is found.
                   if (Found = TRUE) then
                     i := j;
                     exit L4;
                   end if;
               end loop L4;
            end if;
            if (Flag = TRUE or PrgmIndSync /= '0') then
              if (Flag = TRUE) then
                -- If Programmed response is found for current transfer, assert
                -- programmed response.
                iHRESPM           <= iPeriphReg(i)(17 downto 16);
                if ((iPeriphReg(i)(17 downto 16) = SPLIT_RESP or
                    iPeriphReg(i)(17 downto 16) = RETRY_RESP or
                    iPeriphReg(i)(17 downto 16) = ERROR_RESP) and
                    RespOkInform = '0') then
                  -- Store Programmed Response and set PrgmIndicate(It indicates
                  -- Programmed response is asserted
                  PrgmRespCount     <= iPeriphReg(i)(23 downto 22);
                  PrgmIndicate      <= '1';
                  -- During Wait Cycle assert Ok Response
                  if (PeriphWaitCyc = '1' and Err2 = '0') then
                    iHRESPM       <= OKAY_RESP;
                  else
                    if (Err2 = '0' and
                        (iPeriphReg(i)(17 downto 16) /= ERROR_RESP)) then
                      -- Increment Response counter
                      NxtRespCount      <= unsigned(RespCount) + '1';
                    end if;
                  end if;
                end if;
                -- Latch Programmed response and Programmed Wait cycle
                NxtPrgmRespSync   <= iPeriphReg(i)(17 downto 16);
                ProgramedWaitCyc  <= iPeriphReg(i)(21 downto 18);
              else
                if (RespOkInform = '0') then
                  PrgmIndicate      <= '1';
                  if (PeriphWaitCyc = '1' and Err2 = '0') then
                  -- For Programmed Wait Cycle response assert Ok response
                    iHRESPM       <= OKAY_RESP;
                  else
                    -- If Programmed Wait Cycles are asserted, assert
                    -- programmed response.
                    iHRESPM           <= PrgmRespSync;
                    if ((Err2 = '0') and (PrgmRespSync /= ERROR_RESP)) then
                      -- Increment Response counter
                      NxtRespCount    <= unsigned(RespCount) + '1';
                    end if;
                  end if;
                end if;
              end if;
            else
              -- if there is no programmed response for current transaction
              -- assert default response.
              iHRESPM           <= DefaultResp;
              if ((DefaultResp = SPLIT_RESP or DefaultResp = RETRY_RESP or
                   DefaultResp = ERROR_RESP) and (RespOkInform = '0')) then
                if (PeriphWaitCyc = '1' and Err2 = '0') then
                  -- If default wait cycle any, assert Ok response
                  iHRESPM       <= OKAY_RESP;
                else
                  DefIndicate       <= '1';
                  if ((Err2 = '0') and (DefaultResp /= ERROR_RESP)) then
                    -- Increment Response counter
                    NxtRespCount      <= unsigned(RespCount) + '1';
                  end if;
                end if;
              end if;
            end if;
          end if;
        else
          -- assert error response for Non byte/Half word/Word peripheral access
          iHRESPM           <= ERROR_RESP;
        end if;
      else
        if (FirstAccess = '1') then
          iHRESPM           <= ERROR_RESP;
        end if;
      end if;
    end if;
  end if;

  if (RespOkInform = '1') then
    -- assert ok response after all programmed/default responses are asserted.
    iHRESPM           <= OKAY_RESP;
    NxtPrgmRespSync   <= (others => '0');
    DefIndicate       <= '0';
    PrgmIndicate      <= '0';
  end if;

  if (RespClear = '1') then
    -- All programmed/Default responses are asserted, clear response count
    NxtRespCount      <= (others => '0');
    -- All programmed/Default responses are asserted, clear programmed response
    -- indicate and default response indicate signal.
    DefIndicate       <= '0';
    PrgmIndicate      <= '0';
    PrgmRespCount     <= (others => '0');
    NxtPrgmRespSync   <= (others => '0');
  end if;

  -- clear Flag and Found flags
  Flag              := False;
  Found             := False;

end process p_RespDecideComb;

-- -----------------------------------------------------------------------------
-- Data Check Sequential Block.
-- This block is responsible for data comparison. It compares the HWDATAM and
-- Expected data. It flags an error message if there is mismatch.
-- -----------------------------------------------------------------------------
p_DataCheckSeq : process (HCLK)
variable ErrorStr         : string (1 to 255);
begin
  if (HCLK'event and HCLK = '1') then
    if (PeriphWrEn = '1') then
      if (DataGenMethod = RANDOM) then
        fprint (ErrorStr, "DmacTrPeriph9 : RANDOM METHOD : MISMATCH IN"&
               " EXPECTED AND ACTUAL DATA. EXPECTED DATA : %s ACTUAL DATA :%s ",
                To_HexString(ExpectedData), To_HexString(HWDATAM));
        assert ExpectedData = HWDATAM
        report ErrorStr
        severity ERROR;
      elsif (DataGenMethod = GRAYCODE) then
        fprint (ErrorStr, " DmacTrPeriph10 : GRAYCODE METHOD : MISMATCH IN "&
              " EXPECTED AND ACTUAL DATA. EXPECTED DATA : %s ACTUAL DATA :%s ",
                To_HexString(ExpectedData), To_HexString(HWDATAM));
        assert ExpectedData = HWDATAM
        report ErrorStr
        severity ERROR;
      elsif (DataGenMethod = ADDRESSBASED) then
        fprint (ErrorStr, " DmacTrPeriph11 : ADDRESSBASED METHOD : MISMATCH IN"&
             " EXPECTED AND ACTUAL DATA. EXPECTED DATA : %s ACTUAL DATA :%s ",
                To_HexString(ExpectedData), To_HexString(HWDATAM));
        assert ExpectedData = HWDATAM
        report ErrorStr
        severity ERROR;
      elsif (DataGenMethod = DATABASED) then
        fprint (ErrorStr, " DmacTrPeriph12 : DATABASED METHOD : MISMATCH IN" &
               " EXPECTED AND ACTUAL DATA. EXPECTED DATA : %s ACTUAL DATA :%s ",
                To_HexString(ExpectedData), To_HexString(HWDATAM));
        assert ExpectedData = HWDATAM
        report ErrorStr
        severity ERROR;
      end if;
    end if;
  end if;
end process p_DataCheckSeq;

-- ----------------------------------------------------------------------------
-- Response Count Sequential Block
-- ----------------------------------------------------------------------------
p_RespCountSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    RespCount           <= (others => '0');
    PrgmIndSync         <= '0';
    PrgmRespSync        <= OKAY_RESP;
  elsif (HCLK'event and HCLK = '1') then
    RespCount           <= NxtRespCount;
    PrgmIndSync         <= PrgmIndicate;
    PrgmRespSync        <= NxtPrgmRespSync;
  end if;
end process p_RespCountSeq;

-- ----------------------------------------------------------------------------
-- Response Counter Clear Generation Block
-- This process is responsible generation of RespClear signal. The RespClear
-- signal is used to clear programmed response counter.
-- ----------------------------------------------------------------------------
p_RSPComb : process (HRESETn, HCLK)
variable Count : std_logic_vector(2 downto 0);
variable PrgmCount : std_logic_vector(2 downto 0);
variable DefCount : std_logic_vector(2 downto 0);
begin
 if (HRESETn = '0') then
   RespClear       <= '0';
 elsif (HCLK'event and HCLK = '1') then
   Count     := RespCount;
   PrgmCount := '0' & PrgmRespCount;
   DefCount  := '0' & DefaultNoOfResp;
   PrgmCount := PrgmCount + 1;
   DefCount := DefCount + 1;
   if (PeriphReset = '1') then
     RespClear       <= '0';
   elsif (PrgmIndicate = '1' and Count = PrgmCount) then
     -- Check actual response asserted and programmed response asserted are
     -- equal. If it is equal generate RespClear signal to clear response
     -- counter.
     RespClear       <= '1';
   elsif (DefIndicate = '1' and Count = DefCount) then
     -- Check actual response asserted and default response asserted are
     -- equal. If it is equal generate RespClear signal to clear response
     -- counter.
     RespClear       <= '1';
   elsif (HTRANSM /= IDLE) then
     RespClear       <= '0';
   end if;
 end if;
end process p_RSPComb;

-- ----------------------------------------------------------------------------
-- Ok Response Decision Sequential block
-- ----------------------------------------------------------------------------
p_RespOkInfSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    RespOkInform           <= '0';
  elsif (HCLK'event and HCLK = '1') then
    if (RespClear = '1' or (iHRESPM = ERROR_RESP and Err2 = '1')) then
      RespOkInform        <= '1';
    else
      RespOkInform        <= '0';
    end if;
  end if;
end process p_RespOkInfSeq;

-- ----------------------------------------------------------------------------
-- Peripheral Wait Cycle assertion Block
-- This block is responsible for assertion of wait cycle response. If there is
-- default wait cycle response or programmed wait cycle response to current
-- data transfer, this block asserts wait cycle response
-- ----------------------------------------------------------------------------
p_PeriphWaitCycSeq : process (HRESETn, HCLK)
begin
  if (HRESETn = '0' and PeriphReset = '1') then
    TransferClear     <= '0';
    PeriphWaitCyc     <= '0';
    WaitCycCount      <= (others =>'0');
  elsif (HCLK'event and HCLK ='1') then
    if (PeriphEnable = '1' and Selected = '1') then
      if (HTRANSM = IDLE and HREADYINM = '1') then
        -- For Idle cycle No Wait Cycle to be asserted
        PeriphWaitCyc    <= '0';
      elsif ((ProgramedWaitCyc /="0000") and (DataTransfer = '1') and
             iHRESPM = OKAY_RESP) then
        if (WaitCycCount < ProgramedWaitCyc and RespClear = '0' and
            Err2 = '0') then
          -- If number of wait cycle asserted is not equal to programmed wait
          -- cycle count, Assert wait cycle and increment wait cycle counter
          TransferClear     <= '0';
          PeriphWaitCyc     <= '1';
          WaitCycCount      <= unsigned(WaitCycCount) + 1;
        else
          -- If number of wait cycle asserted is equal to programmed Wait Cycle
          -- count, Clear wait cycle counter
          WaitCycCount      <= (others =>'0');
          PeriphWaitCyc     <= '0';
          TransferClear     <= '1';
        end if;
      elsif (DefaultWaitCyc /="0000" and iHRESPM = OKAY_RESP) then
        if (WaitCycCount < DefaultWaitCyc and RespClear = '0' and
            Err2 = '0') then
          -- If number of Wait Cycle asserted is not equal to Default Wait
          -- Cycle count. Assert Wait Cycle and Increment Wait Cycle counter
          TransferClear     <= '0';
          PeriphWaitCyc     <= '1';
          WaitCycCount      <= unsigned(WaitCycCount) + 1;
        else
          -- If number of wait cycle asserted is equal to default wait Cycle
          -- count, Clear wait cycle counter
          WaitCycCount      <= (others =>'0');
          PeriphWaitCyc     <= '0';
          TransferClear     <= '1';
        end if;
      else
        PeriphWaitCyc     <= '0';
        TransferClear     <= '1';
      end if;
    else
      PeriphWaitCyc     <= '0';
      TransferClear     <= '1';
    end if;
  end if;
end process p_PeriphWaitCycSeq;

-- ----------------------------------------------------------------------------
-- DMASREQ generation block
-- This process is responsible for the assertion of DMACSREQ request.
-- ----------------------------------------------------------------------------
p_SREQGenComb : process (iDMACSREQ, DMASTermCount, DMACTC, RegAddr, PeriphReset,
                         PeriphEnable, PeriphRegWrEn, DMASCountEn, DMASCntLoad,
                         DMACCLR, iDMACBREQ, iDMACLSREQ, iDMACLBREQ)
begin
  NxtDMACSREQ       <= iDMACSREQ;
  NxtDMASCountEn    <= DMASCountEn;
  NxtDMASCntLoad    <= DMASCntLoad;

  if (PeriphEnable = '1') then
    -- Generate Load signal for DMACTrSCounter. It is generated when there is
    -- Write access to DMAC Peripheral request register. The counter load is
    -- also generated when only DMACCLR signal is asserted for previous
    -- request.
    if ((((PeriphRegWrEn = '1' and RegAddr = ADDR_DMACTRREQREG)) and
          (iDMACSREQ = '0') and (iDMACBREQ = '0') and (iDMACLSREQ = '0') and
         (iDMACLBREQ = '0')) or (DMACCLR = '1' and DMACTC = '0')) then
      NxtDMASCntLoad    <= '1';
      NxtDMASCountEn    <= '1';
    else
      NxtDMASCntLoad    <= '0';
    end if;
  end if;
  -- When terminal count occurs assert DMACSREQ request and clear Counter enable
  -- signal.
  if (DMASTermCount = '1') then
    NxtDMACSREQ       <= '1';
    NxtDMASCountEn    <= '0';
  elsif (DMACCLR = '1' or PeriphReset = '1') then
  -- Clear DMACBREQ request when DMACCLR or Peripheral Reset is asserted.
    NxtDMACSREQ       <= '0';
  end if;
end process p_SREQGenComb;

-- ----------------------------------------------------------------------------
-- DMASREQ Sequential block
-- ----------------------------------------------------------------------------
p_SREQGenSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    DMASCntLoad      <= '0';
  elsif (HCLK'event and HCLK = '1') then
    DMASCntLoad      <= NxtDMASCntLoad;
  end if;
end process p_SREQGenSeq;

-- ----------------------------------------------------------------------------
-- DMABREQ generation block
-- ----------------------------------------------------------------------------
p_BREQGenComb : process (HRESETn, iDMACBREQ, DMABTermCount, DMACTC, RegAddr,
                         PeriphEnable, PeriphRegWrEn, DMABCountEn, DMABCntLoad,
                         DMACCLR, iDMACSREQ, iDMACLSREQ, iDMACLBREQ,
                         PeriphReset)
begin
  NxtDMACBREQ       <= iDMACBREQ;
  NxtDMABCountEn    <= DMABCountEn;
  NxtDMABCntLoad    <= DMABCntLoad;

  if (PeriphEnable = '1') then
    -- Generate Load signal for DMACTrBCounter. It is generated when there is
    -- Write access to DMAC Peripheral request register. The counter load is
    -- also generated when only DMACCLR signal is asserted for previous
    -- request.
    if ((((PeriphRegWrEn = '1' and RegAddr = ADDR_DMACTRREQREG)) and
          (iDMACSREQ = '0') and (iDMACBREQ = '0') and (iDMACLSREQ = '0') and
         (iDMACLBREQ = '0')) or (DMACCLR = '1' and DMACTC = '0')) then
      NxtDMABCntLoad    <= '1';
      NxtDMABCountEn    <= '1';
    else
      NxtDMABCntLoad     <= '0';
    end if;
  end if;
  -- When terminal count occurs assert DMACBREQ request and clear Counter enable
  -- signal.
  if (DMABTermCount = '1') then
    NxtDMACBREQ       <= '1';
    NxtDMABCountEn    <= '0';
  elsif (DMACCLR = '1' or PeriphReset = '1') then
  -- Clear DMACBREQ request when DMACCLR or Peripheral Reset is asserted.
    NxtDMACBREQ       <= '0';
  end if;
end process p_BREQGenComb;

-- ----------------------------------------------------------------------------
-- DMABREQ Sequential block
-- ----------------------------------------------------------------------------
p_BREQGenSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    DMABCntLoad       <= '0';
  elsif (HCLK'event and HCLK = '1') then
    DMABCntLoad      <= NxtDMABCntLoad;
  end if;
end process p_BREQGenSeq;

-- ----------------------------------------------------------------------------
-- DMALSREQ generation block
-- ----------------------------------------------------------------------------
p_LSREQGenComb : process (iDMACLSREQ, DMALSTermCount, DMACTC, RegAddr,
                          PeriphEnable, PeriphRegWrEn, DMALSCountEn, DMACCLR,
                          DMALSCntLoad, iDMACBREQ, iDMACSREQ, iDMACLBREQ,
                          PeriphReset)
begin
  NxtDMACLSREQ      <= iDMACLSREQ;
  NxtDMALSCountEn   <= DMALSCountEn;
  NxtDMALSCntLoad   <= DMALSCntLoad;

  if (PeriphEnable = '1') then
    -- Generate Load signal for DMACTrLSCounter. It is generated when there is
    -- Write access to DMAC Peripheral request register. The counter load is
    -- also generated when only DMACCLR signal is asserted for previous
    -- request.
    if ((((PeriphRegWrEn = '1' and RegAddr = ADDR_DMACTRREQREG)) and
          (iDMACSREQ = '0') and (iDMACBREQ = '0') and (iDMACLSREQ = '0') and
         (iDMACLBREQ = '0')) or (DMACCLR = '1' and DMACTC = '0')) then
      NxtDMALSCntLoad   <= '1';
      NxtDMALSCountEn   <= '1';
    else
      NxtDMALSCntLoad   <= '0';
    end if;
  end if;
  if (DMALSTermCount = '1') then
  -- When terminal count occurs assert DMACBREQ request and clear Counter enable
  -- signal.
    NxtDMACLSREQ      <= '1';
    NxtDMALSCountEn   <= '0';
  elsif ((DMACCLR = '1' and DMACTC = '1') or PeriphReset = '1') then
  -- Clear DMACLSREQ request when DMACCLR and DMATC or Peripheral Reset is
  -- asserted.
    NxtDMACLSREQ      <= '0';
  end if;
end process p_LSREQGenComb;

-- ----------------------------------------------------------------------------
-- DMALSREQ Sequential block
-- ----------------------------------------------------------------------------
p_LSREQGenSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    DMALSCntLoad      <= '0';
  elsif (HCLK'event and HCLK = '1') then
    DMALSCntLoad     <= NxtDMALSCntLoad;
  end if;
end process p_LSREQGenSeq;

-- ----------------------------------------------------------------------------
-- DMALBREQ generation block
-- ----------------------------------------------------------------------------
p_LBREQGenComb : process (iDMACLBREQ, DMALBTermCount, DMACTC, RegAddr,
                          PeriphEnable, PeriphRegWrEn, DMALBCountEn, DMACCLR,
                          DMALBCntLoad, iDMACLSREQ, iDMACSREQ, iDMACBREQ,
                          PeriphReset)
begin
  NxtDMACLBREQ      <= iDMACLBREQ;
  NxtDMALBCountEn   <= DMALBCountEn;
  NxtDMALBCntLoad   <= DMALBCntLoad;

  if (PeriphEnable = '1') then
    -- Generate Load signal for DMACTrLBCounter. It is generated when there is
    -- Write access to DMAC Peripheral request register. The counter load is
    -- also generated when only DMACCLR signal is asserted for previous
    -- request.
    if ((((PeriphRegWrEn = '1' and RegAddr = ADDR_DMACTRREQREG)) and
          (iDMACSREQ = '0') and (iDMACBREQ = '0') and (iDMACLSREQ = '0') and
         (iDMACLBREQ = '0')) or (DMACCLR = '1' and DMACTC = '0')) then
      NxtDMALBCntLoad   <= '1';
      NxtDMALBCountEn   <= '1';
    else
      NxtDMALBCntLoad   <= '0';
    end if;
  end if;
  if (DMALBTermCount = '1') then
  -- When terminal count occurs assert DMACBREQ request and clear Counter enable
  -- signal.
    NxtDMACLBREQ      <= '1';
    NxtDMALBCountEn   <= '0';
  elsif ((DMACCLR = '1' and DMACTC = '1')or PeriphReset = '1') then
  -- Clear DMACLBREQ request when DMACCLR and DMATC or Peripheral Reset is
  -- asserted.
    NxtDMACLBREQ      <= '0';
  end if;
end process p_LBREQGenComb;

-- ----------------------------------------------------------------------------
-- DMALBREQ Sequential block
-- ----------------------------------------------------------------------------
p_LBREQGenSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    DMALBCntLoad      <= '0';
  elsif (HCLK'event and HCLK = '1') then
    DMALBCntLoad     <= NxtDMALBCntLoad;
  end if;
end process p_LBREQGenSeq;

-- ----------------------------------------------------------------------------
-- DMACLR comparison block
-- ----------------------------------------------------------------------------
p_DMACLRComb : process (DMACCLR, PeriphEnable, PeriphRegWrEn, RegAddr,
                        DMACLRTermCount, DMACLRCountEn, DMACLRCntLoad)
begin
  NxtDMACLRCountEn  <= DMACLRCountEn;
  NxtDMACLRCntLoad  <= DMACLRCntLoad;

  if (PeriphEnable = '1') then
    -- Generate Load signal for DMACTrCLRCounter. It is generated when there is
    -- Write access to DMAC Peripheral request register.
    if (PeriphRegWrEn = '1' and RegAddr = ADDR_DMACTRCLRREG) then
      NxtDMACLRCntLoad  <= '1';
      NxtDMACLRCountEn  <= '1';
    else
      NxtDMACLRCntLoad  <= '0';
    end if;
  end if;
  if (DMACLRTermCount = '1') then
    -- Clear enable bit of DMACTrCLRCounter when terminal count is reached.
    NxtDMACLRCountEn  <= '0';
    assert DMACCLR = '1'
    report "DmacTrPeriph13 : DMACLR IS NOT RECEIVED"
    severity ERROR;
  end if;
end process p_DMACLRComb;

-- ----------------------------------------------------------------------------
-- DMACLR Sequential block
-- ----------------------------------------------------------------------------
p_DMACLRSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    DMACLRCntLoad     <= '0';
  elsif (HCLK'event and HCLK = '1') then
    DMACLRCntLoad    <= NxtDMACLRCntLoad;
  end if;
end process p_DMACLRSeq;

-- ----------------------------------------------------------------------------
-- DMATC comparison block
-- ----------------------------------------------------------------------------
p_DMATCComb : process (DMACTC, PeriphEnable, PeriphRegWrEn, RegAddr,
                       DMATCTermCount, DMATCCountEn, DMATCCntLoad)
begin
  NxtDMATCCountEn   <= DMATCCountEn;
  NxtDMATCCntLoad   <= DMATCCntLoad;

  if (PeriphEnable = '1') then
    -- Generate Load signal for DMACTrTCCounter. It is generated when there is
    -- Write access to DMAC Peripheral request register.
    if (PeriphRegWrEn = '1' and RegAddr = ADDR_DMACTRTCREG) then
      NxtDMATCCntLoad   <= '1';
      NxtDMATCCountEn   <= '1';
    else
      NxtDMATCCntLoad   <= '0';
    end if;
  end if;
  if (DMATCTermCount = '1') then
    -- Clear enable bit of DMACTrTCCounter when terminal count is reached.
    NxtDMATCCountEn   <= '0';
    assert DMACTC = '1'
    report "DmacTrPeriph14 : DMATC IS NOT RECEIVED"
    severity ERROR;
  end if;
end process p_DMATCComb;

-- ----------------------------------------------------------------------------
-- DMATC Sequential block
-- ----------------------------------------------------------------------------
p_DMATCSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    DMATCCntLoad      <= '0';
  elsif (HCLK'event and HCLK = '1') then
    DMATCCntLoad     <= NxtDMATCCntLoad;
  end if;
end process p_DMATCSeq;

-- ----------------------------------------------------------------------------
-- DMA request generation block
-- ----------------------------------------------------------------------------
p_DMAREQSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    iDMACSREQ         <= '0';
    iDMACBREQ         <= '0';
    iDMACLSREQ        <= '0';
    iDMACLBREQ        <= '0';
  elsif (HCLK'event and HCLK = '1') then
    iDMACSREQ         <= NxtDMACSREQ;
    iDMACBREQ         <= NxtDMACBREQ;
    iDMACLSREQ        <= NxtDMACLSREQ;
    iDMACLBREQ        <= NxtDMACLBREQ;
  end if;
end process p_DMAREQSeq;

-- ----------------------------------------------------------------------------
-- Counter Enable signal generation block
-- ----------------------------------------------------------------------------
p_CountEnSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    DMASCountEn       <= '0';
    DMABCountEn       <= '0';
    DMALSCountEn       <= '0';
    DMALBCountEn       <= '0';
    DMATCCountEn       <= '0';
    DMACLRCountEn      <= '0';
  elsif (HCLK'event and HCLK = '1') then
    DMASCountEn       <= NxtDMASCountEn;
    DMABCountEn       <= NxtDMABCountEn;
    DMALSCountEn      <= NxtDMALSCountEn;
    DMALBCountEn      <= NxtDMALBCountEn;
    DMATCCountEn      <= NxtDMATCCountEn;
    DMACLRCountEn     <= NxtDMACLRCountEn;
  end if;
end process p_CountEnSeq;

-- -----------------------------------------------------------------------------
-- Assigning internal signals to the outputs
-- -----------------------------------------------------------------------------
HRESP             <= iHRESP;

HRESPM            <= iHRESPM;

HREADYOUT         <= iHREADYOUT;

HREADYOUTM        <= iHREADYOUTM;

HRDATA            <= iHRDATA;

HRDATAM           <= iHRDATAM;

DMACSREQ          <= iDMACSREQ;

DMACBREQ          <= iDMACBREQ;

DMACLSREQ         <= iDMACLSREQ;

DMACLBREQ         <= iDMACLBREQ;

-- -----------------------------------------------------------------------------
-- START OF PROTOCOL CHECKERS
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- END OF PROTOCOL CHECKERS
-- -----------------------------------------------------------------------------

end behavioural;

-- --================================== End ==================================--
