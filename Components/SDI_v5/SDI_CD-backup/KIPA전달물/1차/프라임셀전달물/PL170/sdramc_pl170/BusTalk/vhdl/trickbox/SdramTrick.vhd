--  --------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999, 2000 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  --------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : $RCS: $
--  File Revision          : 1.5
--
--  Release Information    : PrimeCell(TM)-PL170-REL2v2
--
--  --------------------------------------------------------------------
--
--  --------------------------------------------------------------------
--  Purpose       : This module implements the behavioural TrickBox for
--                  the SDRAM Controller.
--  --------------------------------------------------------------------
--
library ieee;
use ieee.std_logic_1164.all;

library work;
use work.SdramTrDefs.all;

library Std_DevelopersKit;
use std_developerskit.std_IOpak.all;

entity SdramTrick is
port ( HCLK       : in  std_logic; -- AHB Clock Input
       HRESETn    : in  std_logic; -- AHB Reset Input
       HWRITE     : in  std_logic; -- AHB Access Type Indicator (R/W)
       HSEL       : in  std_logic; -- AHB Slave Select Line
       HSIZE      : in  std_logic_vector(2 downto 0);
                                   -- AHB HSIZE Bus
       HBURST     : in  std_logic_vector(2 downto 0);
                                   -- AHB Burst type
       HTRANS     : in  std_logic_vector(1 downto 0);
                                   -- AHB transfer type
       HREADYIn   : in  std_logic; -- AHB Bus Free Input
       SREFAck    : in  std_logic; -- Self Refresh Acknowledge From UUT
       nWE        : in  std_logic; -- WE driven by the UUT
       nRAS       : in  std_logic; -- RAS driven by the UUT
       nCAS       : in  std_logic; -- CAS driven by the UUT
       nCS        : in  std_logic_vector(3 downto 0);
                                   -- CS driven by the UUT
       CKE        : in  std_logic_vector(3 downto 0);
                                   -- CKE driven by the UUT
       ExtBusReq  : in  std_logic; -- Bus Request driven by the UUT
       AddrOut    : in  std_logic_vector(13 downto 0);
                                   -- ADDR driven by the UUT
       HADDR      : in  std_logic_vector(ADDWIDTH downto 0);
                                   -- AHB Address Bus
       HWDATA     : in  std_logic_vector(Width-1 downto 0);
                                   -- AHB Input Data Bus

       nPOR       : out std_logic; -- Power On Reset Pin
       ExtBusGnt  : out std_logic; -- Bus Grant output to the UUT
       SREFReq    : out std_logic; -- Self Refresh Request
       HREADYOut  : out std_logic; -- AHB Slave Ready Response
       HRESP      : out std_logic_vector(1 downto 0);
                                   -- AHB Slave Response
       HRDATA     : out std_logic_vector(Width-1 downto 0);
                                   -- Output Data Bus to the AHB
       BIGENDIAN  : out std_logic  -- BigeEndian control signal

     );
end SdramTrick;

--  --------------------------------------------------------------------
--
--                    SdramTrick
--                    ==========
--
--  --------------------------------------------------------------------
--  Overview
--  ========
--  This Module implements the Behavioural trickbox for the controller.
--  The trickbox has an AHB Slave interface for access to the internal
--  Registers.
--  This module instantiates the following modules:
--  - SdramTrSnp      - Snooper module which tracks commands issued to
--                       Devices.
--  - SdramTrBusGnt   - Controls the Bus Request to Bus Grant delay.
--  - SdramTrSigCheck - Module to check validity of command sequences
--                       issued by the controller.
--
--==========================ARCHITECTURE================================
--
------------------------------------------------------------------------
-- Architecture Packages
------------------------------------------------------------------------

architecture behavioural of SdramTrick is

------------------------------------------------------------------------
-- Component declaration
------------------------------------------------------------------------

component SdramTrSnp
port (
       HCLK       : in  std_logic;
       nReset     : in  std_logic;
       FifoIn     : in  std_logic_vector(16 downto 0);
       ChipSelect : in  std_logic_vector(3 downto 0);
       FifoClear  : in  std_logic;
       FifoEn     : in  std_logic;
       ReadEn     : in  std_logic;
       ModeBit    : in  std_logic;
       SupREFBit  : in  std_logic;
       SupALL     : in  std_logic;

       FifoOut    : out std_logic_vector(31 downto 0)
      );
end component;

component SdramTrBusGnt
port (
       HCLK       : in  std_logic;
       nReset     : in  std_logic;
       ExtBusReq  : in  std_logic;
       BusGntMode : in  std_logic;
       BusGntHigh : in  std_logic;
       BusGntClk  : in  std_logic_vector(4 downto 0);

       ExtBusGnt  : out std_logic
     );
end component;

component SdramTrSigCheck
port (
       HCLK         : in  std_logic;
       HRESETn      : in  std_logic;
       nPOR         : in  std_logic;
       ReadSel      : in  std_logic;
       WriteSel     : in  std_logic;
       DIn          : in  std_logic_vector(31 downto 0);
       CKE          : in  std_logic_vector(3 downto 0);
       nRAS         : in  std_logic;
       nCAS         : in  std_logic;
       nCS          : in  std_logic_vector(3 downto 0);
       nWE          : in  std_logic;
       A10          : in  std_logic;
       A5           : in  std_logic;
       A6           : in  std_logic;

       DOut         : out std_logic_vector(31 downto 0);
       ModeBit      : out std_logic;
       ExtBusWidth  : out std_logic
     );
end component;

------------------------------------------------------------------------
--  Signal Declarations
------------------------------------------------------------------------

signal   NextMASTERCTRL      : std_logic_vector(14 downto 0);
-- D-Input for MASTERCTRL Regsister

signal   MASTERCTRLSel       : std_logic;
-- MASTERCTRL Register Select

signal   NextMASTERCTRLWr    : std_logic;
-- D-Input for MASTERCTRLWr

signal   NextMASTERCTRLRd    : std_logic;
-- D-Input for MASTERCTRLRd

signal   HTRANSValid         : std_logic;
-- Valid transfer type for Trickbox

signal   POR                 : std_logic;
-- Power on Reset bit of MASTERCTRL

signal   SREFBit             : std_logic;
-- Self Refresh Request Bit

signal   ModeBit             : std_logic;
-- Mode Select Signal

signal   ExtBusWidth             : std_logic;
-- External Bus width selection bit

signal   NextSREFReq         : std_logic;
-- D-Input for SREFReq

signal   MASTERCTRL          : std_logic_vector(14 downto 0);
-- MASTERCTRL Register

signal   MASTERCTRLWr        : std_logic;
-- Write Enable Pin to MASTERCTRL

signal   MASTERCTRLRd        : std_logic;
-- Read Enable for MASTERCTRLRd

signal   NextRead            : std_logic;
-- D input to Read

signal   Read              : std_logic;
-- Read Enable for the Signal check module

signal   DataWrite           : std_logic;
-- AHB data write Signal

signal   NextDataWrite       : std_logic;
-- D input to DataWrite

signal   ReadSel             : std_logic;
-- Signal Check module Read Select signal

signal   NextReadSel         : std_logic;
-- D Input for Read Select signal

signal   WriteSel            : std_logic;
-- Signal Check module Write Select signal

signal   NextWriteSel        : std_logic;
-- D Input for Write Select signal

signal   nReset              : std_logic;
-- Trickbox Reset Signal

signal   SnpDIn              : std_logic_vector(16 downto 0);
-- Data Input to the snooper module

signal   SnpRd               : std_logic;
-- Read pulse to the snooper module

signal   NextSnpRd           : std_logic;
-- D input to the SnpRd

signal   SnpWr               : std_logic;
-- Write Signal for the Snooper Register.

signal   NextSnpWr           : std_logic;
-- D input for SnpWr

signal   SnpClr              : std_logic;
-- FIFO clear pulse

signal   NextSnpClr          : std_logic;
-- D input to SnpClr

signal   SupREFBit           : std_logic;
-- Signal to prevent the storage of REF command in the snooper

signal   NextSupREFBit       : std_logic;
-- D input to SupREFBit

signal   SupALLBit           : std_logic;
-- Stops the snooper storing all commands except READ and WRITE

signal   NextSupALLBit       : std_logic;
-- D input for SupALLBit

signal   SnpEn               : std_logic;
-- FIFO Enable signal

signal   NextSnpEn           : std_logic;
-- D input to SnpEn

signal   SnpDOut             : std_logic_vector(31 downto 0);
-- Output data from the snooper

signal   DIn                 : std_logic_vector(Width-1 downto 0);
-- AHB data bus (Input).

signal   DOut                : std_logic_vector(Width-1 downto 0);
-- AHB Data from the Signal check module

signal   inPOR               : std_logic;
-- internal value of the nPOR

signal   iHRESP              : std_logic_vector(1 downto 0);
-- internal value of the output HRESP

signal   iSREFReq            : std_logic;
-- internal value of the SREFReq

signal   AddSn               : std_logic_vector(ADDWIDTH downto 0);
-- Address for the snooper

signal   AddSel              : std_logic_vector(ADDWIDTH downto 0);

signal   ZERO                : std_logic_vector(Width-1 downto 0);

signal   Big                 : std_logic;

-- ---------------------------------------------------------------------
--  Constant Declarations
-- ---------------------------------------------------------------------
constant IDLE                : std_logic_vector(1 downto 0)  := "00";
-- Master IDLE response

constant BUSY                : std_logic_vector(1 downto 0)  := "01";
-- Master BUSY response

constant NONSEQ              : std_logic_vector(1 downto 0)  := "10";
-- Master NONSEQ response

constant SEQ                 : std_logic_vector(1 downto 0)  := "11";
-- Master SEQ response

constant OKAY                : std_logic_vector(1 downto 0)  := "00";
-- Slave OKAY response

constant ERR                 : std_logic_vector(1 downto 0)  := "01";
-- Slave ERROR response

constant WORD                : std_logic_vector(2 downto 0)  := "010";
-- 32 - bit Operation

constant DWORD               : std_logic_vector(2 downto 0)  := "011";
-- 64 - bit Operation

-- constant INCR             : std_logic_vector(2 downto 0)  := "001";
-- Undefined length burst

--  --------------------------------------------------------------------
--   Main VHDL Code
--   ==============
--  --------------------------------------------------------------------
begin

ZERO <= (others => '0');

u_SdramTrSnp : SdramTrSnp
port map (
          HCLK        => HCLK,
          nReset      => nReset,
          FifoIn      => SnpDIn,
          ChipSelect  => nCS ,
          FifoClear   => SnpClr,
          FifoEn      => SnpEn,
          ReadEn      => NextSnpRd,
          ModeBit     => ModeBit,
          SupREFBit   => SupREFBit,
          SupALL      => SupALLBit,

          FifoOut     => SnpDOut
         );

u_SdramTrBusGnt : SdramTrBusGnt
port map (
          HCLK        => HCLK,
          nReset      => nReset,
          ExtBusReq   => ExtBusReq,
          BusGntMode  => MASTERCTRL(8),
          BusGntHigh  => MASTERCTRL(9),
          BusGntClk   => MASTERCTRL(14 downto 10),

          ExtBusGnt   => ExtBusGnt
         );

u_SdramTrSigCheck : SdramTrSigCheck
port map (
          HCLK        => HCLK,
          HRESETn     => HRESETn,
          nPOR        => inPOR,
          ReadSel     => ReadSel,
          WriteSel    => WriteSel,
          DIn         => DIn(31 downto 0),
          CKE         => CKE,
          nRAS        => nRAS,
          nCAS        => nCAS,
          nCS         => nCS,
          nWE         => nWE,
          A10         => AddrOut(10),
          A5          => AddrOut(5),
          A6          => AddrOut(6),

          DOut        => DOut(31 downto 0),
          ModeBit     => ModeBit,
          ExtBusWidth => ExtBusWidth
         );

nPOR  <= inPOR;

--  --------------------------------------------------------------------
--  nReset Generation
--  --------------------------------------------------------------------
nReset <= inPOR and HRESETn;

 HTRANSValid <= '1' when HTRANS(1) = '1' and HREADYIn = '1'
             else
                '0';

 SnpDIn       <= nRAS & nCAS & nWE & AddrOut;

--  --------------------------------------------------------------------
--  SnpClr and SnpEn Generation
--  ===========================
--  --------------------------------------------------------------------
 NextSnpEn     <= HWDATA(0) when SnpWr = '1'
               else
                  SnpEn;

NextSnpClr     <= HWDATA(1) when SnpWr = '1'
               else
                  '0';

NextSupREFBit  <= HWDATA(2) when SnpWr = '1'
               else
                  SupREFBit;

NextSupALLBit  <= HWDATA(3) when SnpWr = '1'
               else
                  SupALLBit;

p_SnpCERSeq : process (HCLK, nReset)
begin
  if (nReset = '0') then
    SnpClr    <= '0';
    SnpEn     <= '0';
    SupREFBit <= '0';
    SupALLBit <= '0';
  elsif (HCLK'event and HCLK = '1') then
    SnpClr    <= NextSnpClr;
    SnpEn     <= NextSnpEn;
    SupREFBit <= NextSupREFBit;
    SupALLBit <= NextSupALLBit;
  end if;
end process p_SnpCERSeq;

--  --------------------------------------------------------------------
--  Slave Response Generation
--  =========================
--
-- This process generate the bus response required for an AHB slave.
-- The trickbox is designed for HSIZE of 32-bits or 64-bits.
-- So this process will generate an ERROR response when the master tries
-- to access it in some other mode. Trickbox always provides a ZERO
-- wait state OKAY response for IDLE and BUSY HTRANS of the master.
--  --------------------------------------------------------------------
p_SlaveRespSeq : process (HCLK, HRESETn)

variable printstr : string(1 to 255);

begin
  if(HRESETn = '0') then
    iHRESP         <= OKAY;
    HREADYOut      <= '0';
  elsif (HCLK'event and HCLK = '1') then
    if (iHRESP = ERR and HREADYIn = '0' and HSEL = '1') then
      iHRESP       <= ERR;
      HREADYOut    <= '1';
    elsif ((HTRANS = IDLE or HTRANS = BUSY) and HSEL = '1' and
            HREADYIn = '1') then
      iHRESP       <= OKAY;
      HREADYOut    <= '1';
    elsif (HSEL = '1' and HREADYIn = '1') then
      iHRESP       <= OKAY;
      HREADYOut    <= '1';
    else
      iHRESP       <= OKAY;
      HREADYOut    <= '0';
    end if;
  end if;
end process p_SlaveRespSeq;

HRESP  <= iHRESP;
--  --------------------------------------------------------------------
--  SREFReq Generation
--  --------------------------------------------------------------------
SREFBit <= MASTERCTRL(0);

p_SREFReqComb : process (SREFBit, SREFAck, iSREFReq)
begin
  if (SREFAck = '1') then
    NextSREFReq <= SREFBit;
  elsif (SREFBit = '1') then
    NextSREFReq <= '1';
  else
    NextSREFReq <= iSREFReq;
  end if;
end process p_SREFReqComb;

p_SREFReqSeq : process (HCLK, nReset)
begin
  if (nReset = '0') then
    iSREFReq <= '0';
  elsif (HCLK'event and HCLK = '1') then
    iSREFReq <= NextSREFReq;
  end if;
end process p_SREFReqSeq;

SREFReq  <= iSREFReq;

--  --------------------------------------------------------------------
--  inPOR Generation
--  --------------------------------------------------------------------
POR <= MASTERCTRL(1);

p_nPORSeq : process (HCLK, POR)
begin
  if (POR = '1') then
    inPOR <= '0' after PORDelay;
  elsif (HCLK'event and HCLK = '1') then
    inPOR <= '1';
  end if;
end process p_nPORSeq;

--  --------------------------------------------------------------------
--  BIGENDIAN Generation
--  --------------------------------------------------------------------
BIGENDIAN <= MASTERCTRL(2);

--  --------------------------------------------------------------------
--  SnpRd and SnpWr Generation
--  ==========================
--
--  Whenever there is request to access the location, these pins are
--  asserted depending on the condition of HWRITE pin.
--  --------------------------------------------------------------------
AddSn     <= ((ADDWIDTH-1) => '1', others => '0') ;

NextSnpWr <= '1' when
                 (HSEL = '1' and (HADDR = AddSn) and HWRITE = '1' and
                  HTRANSValid = '1')
          else
             '0';

NextSnpRd <= '1' when
                 (HSEL = '1' and (HADDR = AddSn) and HWRITE = '0' and
                  HTRANSValid = '1')
          else
             '0';

p_SnpWSeq : process (HCLK, HRESETn)
begin
  if(HRESETn = '0') then
    SnpWr <= '0';
  elsif (HCLK'event and HCLK = '1') then
    SnpWr <= NextSnpWr;
  end if;
end process p_SnpWSeq;

p_SnpRSeq : process (HCLK, HRESETn)
 begin
    if (HRESETn = '0') then
      SnpRd <= '0';
    elsif (HCLK'event and HCLK = '1') then
      SnpRd <= NextSnpRd;
    end if;
end process p_SnpRSeq;

--  --------------------------------------------------------------------
--  ReadSel and WriteSel
--  ====================
--
--  Whenever there is request to access the location zero, these pins
--  are asserted depending on the condition of HWRITE pin.
--  --------------------------------------------------------------------
AddSel  <= ((ADDWIDTH-2) => '1' , others => '0');

NextWriteSel <= '1' when
                   (HSEL = '1' and (HADDR = AddSel) and HWRITE = '1'and
                    HTRANSValid = '1')
             else
                '0';

NextReadSel  <= '1' when
                   (HSEL = '1' and (HADDR = AddSel) and HWRITE = '0'and
                    HTRANSValid = '1')
             else
                '0';

p_WrSelSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    WriteSel <= '0';
  elsif (HCLK'event and HCLK = '1') then
    WriteSel <= NextWriteSel;
  end if;
end process p_WrSelSeq;

p_RdSelSeq : process (HCLK, HRESETn)
begin
  if(HRESETn = '0') then
    ReadSel <= '0';
  elsif (HCLK'event and HCLK = '1') then
    ReadSel <= NextReadSel;
  end if;
end process p_RdSelSeq;

--  --------------------------------------------------------------------
--  DataWrite and Read Generation
--  =======================================
--
--  --------------------------------------------------------------------
NextRead      <= '1' when
                     (HWRITE = '0') and HTRANSValid = '1' and
                     (HADDR = AddSel)
              else
                 '0';

NextDataWrite <= HWRITE and HSEL and HTRANSValid;

p_RdWrSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    Read      <= '0';
    DataWrite <= '0';
  elsif (HCLK'event and HCLK = '1') then
    Read      <= NextRead;
    DataWrite <= NextDataWrite;
  end if;
end process p_RdWrSeq;

--  --------------------------------------------------------------------
--  MASTERCTRLWr and MASTERCTRLRd Generation
--  =======================================
--
--  Whenever there is request to access the location zero, these pins
--  are asserted depending on the condition of HWRITE pin.
--  --------------------------------------------------------------------

MASTERCTRLSel <= '1' when
                     HSEL = '1' and (HADDR = ZERO(ADDWIDTH downto 0))
                                and HTRANSValid = '1'
                 else
                    '0';

NextMASTERCTRLWr <= MASTERCTRLSel and HWRITE;
NextMASTERCTRLRd <= MASTERCTRLSel and not(HWRITE);

p_MCtrlWrSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    MASTERCTRLWr <= '0';
  elsif (HCLK'event and HCLK = '1') then
    MASTERCTRLWr <= NextMASTERCTRLWr;
  end if;
end process p_MCtrlWrSeq;

p_MCtrlRdSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    MASTERCTRLRd <= '0';
  elsif (HCLK'event and HCLK = '1') then
    MASTERCTRLRd <= NextMASTERCTRLRd;
  end if;
end process p_MCtrlRdSeq;

--  --------------------------------------------------------------------
--  MASTERCTRL Register Assignments
--  --------------------------------------------------------------------
NextMASTERCTRL <= HWDATA(14 downto 0) when MASTERCTRLWr = '1'
               else
                  MASTERCTRL;

p_MCtrlSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    MASTERCTRL <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    MASTERCTRL <= NextMASTERCTRL;
  end if;
end process p_MCtrlSeq;

--  --------------------------------------------------------------------
--  MASTERCTRL Read Output to HRDATA
--  --------------------------------------------------------------------
p_MCtrlReadComb : process (MASTERCTRLRd, Read, SnpRd, MASTERCTRL, DOut,
                           SnpDOut)
begin
  HRDATA <= (others =>'0');

  if (MASTERCTRLRd ='1') then
    HRDATA              <= (ZERO(Width-1 downto 15) & MASTERCTRL);
  elsif (Read ='1') then
    HRDATA              <= DOut;
  elsif (SnpRd ='1') then
    HRDATA(31 downto 0) <= SnpDOut;
  else
    HRDATA              <= (others =>'0');
  end if;
end process p_MCtrlReadComb;

DIn <= HWDATA when DataWrite = '1'
    else
       (others => '0');

end behavioural;

-- ================================ End ==============================--
