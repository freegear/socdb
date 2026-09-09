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
-- File Name              : EbiTrAhbif.vhd.rca
-- File Revision          : 1.2
--
-- Release Information    : PrimeCell(TM)-PL220-r0p0-00ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block interfaces the EBI Trickbox with the AHB.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use work.EbiTrPackage.all;

-- -----------------------------------------------------------------------------

entity EbiTrAhbif is
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
        HWDATA           : in    std_logic_vector(31 downto 0);
                                            -- AHB Write Data bus
        HSELEBITRICKBOX  : in    std_logic; -- AHB Peripheral (Trickbox)
                                            -- Select
        EbiTrCntl        : in    std_logic_vector(7 downto 0);
                                            -- EbiTrCntl Register
        EbiTrStatus      : in    std_logic_vector(5 downto 0);
                                            -- EbiTrStatus Register
        EbiTrClk         : in    std_logic_vector (2 downto 0);
                                            -- Indicates speed of MEMCLK
        EbiTrAddr1       : in    std_logic_vector(31 downto 0);
                                            -- Indicates address on EBIADDR1
        EbiTrAddr2       : in    std_logic_vector(31 downto 0);
                                            -- Indicates address on EBIADDR1
        EbiTrAddr3       : in    std_logic_vector(31 downto 0);
                                            -- Indicates address on EBIADDR1
        EbiTrData1       : in    std_logic_vector(31 downto 0);
                                            -- Indicates data on EBIDATA1
        EbiTrData2       : in    std_logic_vector(31 downto 0);
                                            -- Indicates data on EBIDATA2
        EbiTrData3       : in    std_logic_vector(31 downto 0);
                                            -- Indicates data on EBIDATA3
        nEbiTrDataEn1    : in    std_logic_vector(3 downto 0);
                                            -- Indicates data enable on
                                            -- EBIDATAEN1
        nEbiTrDataEn2    : in    std_logic_vector(3 downto 0);
                                            -- Indicates data enable on
                                            -- EBIDATAEN2
        nEbiTrDataEn3    : in    std_logic_vector(3 downto 0);
                                            -- Indicates data enable on
                                            -- EBIDATAEN3
        EbiTrExtDataIn   : in    std_logic_vector(31 downto 0);
                                            -- Indicates data enable on
                                            -- EBIEXTDATAIN
        EbiTrTimeOut1    : in    std_logic_vector(9 downto 0);
                                            -- Indicates EBITIMEOUTVALUE1
        EbiTrTimeOut2    : in    std_logic_vector(9 downto 0);
                                            -- Indicates EBITIMEOUTVALUE2
        EbiTrTimeOut3    : in    std_logic_vector(9 downto 0);
                                            -- Indicates EBITIMEOUTVALUE3
-- Outputs
        HREADYOUT        : out   std_logic; -- Slave HREADY output
        HRESP            : out   std_logic_vector(1 downto 0);
                                            -- Slave response
        HRDATA           : out   std_logic_vector(31 downto 0);
                                            -- AHB Read Data bus
        WriteData        : out   std_logic_vector(31 downto 0);
                                            -- Write Data bus to the Register
                                            -- Block
        EbiTrCntlWr      : out   std_logic; -- EbiTrCntl register write enable
        EbiTrClkWr       : out   std_logic; -- EbiTrClk Register Write Enable
        EbiTrAddr1Wr     : out   std_logic; -- EbiTrAddr1 Register Write
        EbiTrAddr2Wr     : out   std_logic; -- EbiTrAddr2 Register Write
        EbiTrAddr3Wr     : out   std_logic; -- EbiTrAddr3 Register Write
        EbiTrData1Wr     : out   std_logic; -- EbiTrData1 Register Write
        EbiTrData2Wr     : out   std_logic; -- EbiTrData2 Register Write
        EbiTrData3Wr     : out   std_logic; -- EbiTrData3 Register Write
        nEbiTrDataEn1Wr  : out   std_logic; -- nEbiTrDataEn1 Register Write
        nEbiTrDataEn2Wr  : out   std_logic; -- nEbiTrDataEn2 Register Write
        nEbiTrDataEn3Wr  : out   std_logic; -- nEbiTrDataEn3 Register Write
        EbiTrExtDataInWr : out   std_logic; -- EbiTrExtDataIn Register Write
        EbiTrTimeOut1Wr  : out   std_logic; -- EbiTrTimeOut1 register write
        EbiTrTimeOut2Wr  : out   std_logic; -- EbiTrTimeOut2 register write
        EbiTrTimeOut3Wr  : out   std_logic  -- EbiTrTimeOut3 register write
       );
end EbiTrAhbif;

-- -----------------------------------------------------------------------------
--
--                                 EbiTrAhbif
--                                 ==========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- EBI Tricbox is an AHB slave. This block performs the following operations:
--   - Interfaces the Trickbox with the AHB
--       All slave response signals are generated from this module.
--       This module decodes AHB accesses and generates the read/write
--       strobe to the appropriate registers.
--
-- -----------------------------------------------------------------------------
--                         EBI Trickbox Register Map
-- -----------------------------------------------------------------------------
-- Offset    Register       Type  Width    Describtion
-- -----------------------------------------------------------------------------
-- [from EBI trickbox Base]
-- 0x0000 -  EbiTrCntl      R/W  8-bits  This is EBI request register
--
-- 0x0004 -  EbiTrStatus    R/W  6-bits  This is EBI Status register
--
-- 0x0008 -  EbiTrClk       R/W  3-bits  This register indicates the clock
--                                       speed
--
-- 0x000C -  EbiTrAddr1     R/W  32-bits This is EBI Trickbox register which
--                                       indicates the address to be put on
--                                       EBIADDR1[31:0]
--
-- 0x0010 -  EbiTrAddr2     R/W  32-bits This is EBI Trickbox register which
--                                       indicates the address to be put on
--                                       EBIADDR2[31:0]
--
-- 0x0014 -  EbiTrAddr3     R/W  32-bits This is EBI Trickbox register which
--                                       indicates the address to be put on
--                                       EBIADDR3[31:0]
--
-- 0x0018 -  EbiTrData1     R/W  32-bits This is EBI Trickbox register which
--                                       indicates the data to be put on
--                                       EBIDATA1[31:0]
--
-- 0x001C -  EbiTrData2     R/W  32-bits This is EBI Trickbox register which
--                                       indicates the data to be put on
--                                       EBIDATA2[31:0]
--
-- 0x0020 -  EbiTrData3     R/W  32-bits This is EBI Trickbox register which
--                                       indicates the data to be put on
--                                       EBIDATA3[31:0]
--
-- 0x0024 -  nEbiTrDataEn1   R/W   4-bits This is EBI Trickbox register which
--                                       indicates the dataen to be put on
--                                       EBIDATAEn1[3:0]
--
-- 0x0028 -  nEbiTrDataEn2   R/W   4-bits This is EBI Trickbox register which
--                                       indicates the dataen to be put on
--                                       EBIDATAEn2[3:0]
--
-- 0x002C -  nEbiTrDataEn3   R/W   4-bits This is EBI Trickbox register which
--                                       indicates the dataen to be put on
--                                       EBIDATAEn3[3:0]
--
-- 0x0030 -  EbiTrExtDataIn R/W  32-bits This is EBI Trickbox register which
--                                       indicates the External Data in to be
--                                       put on  EBIEXTDATAIN[31:0]
--
-- 0x0034 -  EbiTrTimeOut1  R/W  10-bits This is EBI Trickbox register which
--                                       indicates the timeout value to be put
--                                       on EBITIMEOUTVALUE1[9:0]
--
-- 0x0038 -  EbiTrTimeOut2  R/W  10-bits This is EBI Trickbox register which
--                                       indicates the timeout value to be put
--                                       on EBITIMEOUTVALUE2[9:0]
--
-- 0x003C -  EbiTrTimeOut3  R/W  10-bits This is EBI Trickbox register which
--                                       indicates the timeout value to be put
--                                       on EBITIMEOUTVALUE3[9:0]
--
-- -----------------------------------------------------------------------------

-- --============================ ARCHITECTURE ===============================--

architecture behavioural of EbiTrAhbif is

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
constant ADDR_EBITRCNTL      : std_logic_vector(11 downto 2) := "0000000000";
-- EbiTrCntl at offset 0x0000

constant ADDR_EBITRSTATUS    : std_logic_vector(11 downto 2) := "0000000001";
-- EbiTrStatus at offset 0x0001

constant ADDR_EBITRCLK      : std_logic_vector(11 downto 2) := "0000000010";
-- EbiTrClk at offset 0x0004

constant ADDR_EBITRADDR1    : std_logic_vector(11 downto 2) := "0000000011";
-- EbiTrAddr1 at offset 0x0008

constant ADDR_EBITRADDR2    : std_logic_vector(11 downto 2) := "0000000100";
-- EbiTrAddr2 at offset 0x000C

constant ADDR_EBITRADDR3    : std_logic_vector(11 downto 2) := "0000000101";
-- EbiTrAddr3 at offset 0x0010

constant ADDR_EBITRDATA1    : std_logic_vector(11 downto 2) := "0000000110";
-- EbiTrData1 at offset 0x0014

constant ADDR_EBITRDATA2    : std_logic_vector(11 downto 2) := "0000000111";
-- EbiTrData2 at offset 0x0018

constant ADDR_EBITRDATA3    : std_logic_vector(11 downto 2) := "0000001000";
-- EbiTrData3 at offset 0x001C

constant ADDR_EBITRDATAEN1  : std_logic_vector(11 downto 2) := "0000001001";
-- nEbiTrDataEn1 at offset 0x0020 from EBI base

constant ADDR_EBITRDATAEN2  : std_logic_vector(11 downto 2) := "0000001010";
-- nEbiTrDataEn2 at offset 0x0024 from EBI base

constant ADDR_EBITRDATAEN3  : std_logic_vector(11 downto 2) := "0000001011";
-- nEbiTrDataEn3 at offset 0x0028 from EBI base

constant ADDR_EBITREXTDATAIN : std_logic_vector(11 downto 2) := "0000001100";
-- nEbiTrDataEn3 at offset 0x002C from EBI base

constant ADDR_EBITRTIMEOUT1 : std_logic_vector(11 downto 2) := "0000001101";
-- EbiTrTimeOut1 at offset 0x0030 from EBI base

constant ADDR_EBITRTIMEOUT2 : std_logic_vector(11 downto 2) := "0000001110";
-- EbiTrTimeOut2 at offset 0x0034 from EBI base

constant ADDR_EBITRTIMEOUT3 : std_logic_vector(11 downto 2) := "0000001111";
-- EbiTrTimeOut3 at offset 0x0038 from EBI base

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

signal EbiTrCntlRd      : std_logic;
-- EbiTrCntl Read

signal EbiTrStatusRd    : std_logic;
-- EbiTrStatus Read

signal EbiTrClkRd       : std_logic;
-- EbiTrClk Read

signal EbiTrAddr1Rd     : std_logic;
-- EbiTrAddr1 Read

signal EbiTrAddr2Rd     : std_logic;
-- EbiTrAddr2 Read

signal EbiTrAddr3Rd     : std_logic;
-- EbiTrAddr3 Read

signal EbiTrData1Rd     : std_logic;
-- EbiTrData1 Read

signal EbiTrData2Rd     : std_logic;
-- EbiTrData2 Read

signal EbiTrData3Rd     : std_logic;
-- EbiTrData3 Read

signal nEbiTrDataEn1Rd  : std_logic;
-- EbiTrData1En Read

signal nEbiTrDataEn2Rd  : std_logic;
-- EbiTrData2En Read

signal nEbiTrDataEn3Rd  : std_logic;
-- EbiTrData3En Read

signal EbiTrExtDataInRd : std_logic;
-- EbiTrExtDataIn Read

signal EbiTrTimeOut1Rd  : std_logic;
-- EbiTrTimeOut1 Read

signal EbiTrTimeOut2Rd  : std_logic;
-- EbiTrTimeOut2 Read

signal EbiTrTimeOut3Rd  : std_logic;
-- EbiTrTimeOut3 Read

signal WrEn             : std_logic;
-- Write enable signal

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
EbiTrCntlWr      <= '1' when ((WrEn = '1') and
                               (iLatchHADDR = ADDR_EBITRCNTL))
                 else
                    '0';

EbiTrClkWr       <= '1' when ((WrEn = '1') and
                              (iLatchHADDR = ADDR_EBITRCLK))
                 else
                    '0';

EbiTrAddr1Wr     <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_EBITRADDR1))
                 else
                    '0';

EbiTrAddr2Wr     <= '1' when ((WrEn = '1') and
                              (iLatchHADDR = ADDR_EBITRADDR2))
                 else
                    '0';

EbiTrAddr3Wr     <= '1' when ((WrEn = '1') and
                              (iLatchHADDR = ADDR_EBITRADDR3))
                 else
                    '0';

EbiTrData1Wr     <= '1' when ((WrEn = '1') and
                              (iLatchHADDR = ADDR_EBITRDATA1))
                 else
                    '0';


EbiTrData2Wr     <= '1' when ((WrEn = '1') and
                              (iLatchHADDR = ADDR_EBITRDATA2))
                 else
                    '0';

EbiTrData3Wr     <= '1' when ((WrEn = '1') and
                              (iLatchHADDR = ADDR_EBITRDATA3))
                 else
                    '0';

nEbiTrDataEn1Wr   <= '1' when ((WrEn = '1') and
                              (iLatchHADDR = ADDR_EBITRDATAEN1))
                 else
                    '0';

nEbiTrDataEn2Wr   <= '1' when ((WrEn = '1') and
                              (iLatchHADDR = ADDR_EBITRDATAEN2))
                 else
                    '0';

nEbiTrDataEn3Wr   <= '1' when ((WrEn = '1') and
                              (iLatchHADDR = ADDR_EBITRDATAEN3))
                 else
                    '0';

EbiTrExtDataInWr <= '1' when ((WrEn = '1') and
                              (iLatchHADDR = ADDR_EBITREXTDATAIN))
                 else
                    '0';

EbiTrTimeOut1Wr  <= '1' when ((WrEn = '1') and
                              (iLatchHADDR = ADDR_EBITRTIMEOUT1))
                 else
                    '0';

EbiTrTimeOut2Wr  <= '1' when ((WrEn = '1') and
                              (iLatchHADDR = ADDR_EBITRTIMEOUT2))
                 else
                    '0';

EbiTrTimeOut3Wr  <= '1' when ((WrEn = '1') and
                             (iLatchHADDR = ADDR_EBITRTIMEOUT3))
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Read enables for registers
-- -----------------------------------------------------------------------------
EbiTrCntlRd      <= '1' when ((RdEn = '1') and
                              (iLatchHADDR = ADDR_EBITRCNTL))
                 else
                    '0';

EbiTrStatusRd    <= '1' when ((RdEn = '1') and
                              (iLatchHADDR = ADDR_EBITRSTATUS))
                 else
                    '0';

EbiTrClkRd       <= '1' when ((RdEn = '1') and
                              (iLatchHADDR = ADDR_EBITRCLK))
                 else
                    '0';

EbiTrAddr1Rd     <= '1' when ((RdEn = '1') and
                              (iLatchHADDR = ADDR_EBITRADDR1))
                 else
                    '0';


EbiTrAddr2Rd     <= '1' when ((RdEn = '1') and
                              (iLatchHADDR = ADDR_EBITRADDR2))
                 else
                    '0';

EbiTrAddr3Rd     <= '1' when ((RdEn = '1') and
                              (iLatchHADDR = ADDR_EBITRADDR3))
                 else
                    '0';

EbiTrData1Rd     <= '1' when ((RdEn = '1') and
                              (iLatchHADDR = ADDR_EBITRDATA1))
                 else
                    '0';

EbiTrData2Rd     <= '1' when ((RdEn = '1') and
                              (iLatchHADDR = ADDR_EBITRDATA2))
                 else
                    '0';

EbiTrData3Rd     <= '1' when ((RdEn = '1') and
                              (iLatchHADDR = ADDR_EBITRDATA3))
                 else
                    '0';

nEbiTrDataEn1Rd   <= '1' when ((RdEn = '1') and
                              (iLatchHADDR = ADDR_EBITRDATAEN1))
                 else
                    '0';

nEbiTrDataEn2Rd   <= '1' when ((RdEn = '1') and
                              (iLatchHADDR = ADDR_EBITRDATAEN2))
                 else
                    '0';


nEbiTrDataEn3Rd   <= '1' when ((RdEn = '1') and
                              (iLatchHADDR = ADDR_EBITRDATAEN3))
                 else
                    '0';

EbiTrExtDataInRd <= '1' when ((RdEn = '1') and
                               (iLatchHADDR = ADDR_EBITREXTDATAIN))
                 else
                    '0';

EbiTrTimeOut1Rd   <= '1' when ((RdEn = '1') and
                               (iLatchHADDR = ADDR_EBITRTIMEOUT1))
                  else
                     '0';

EbiTrTimeOut2Rd   <= '1' when ((RdEn = '1') and
                               (iLatchHADDR = ADDR_EBITRTIMEOUT2))
                  else
                     '0';

EbiTrTimeOut3Rd   <= '1' when ((RdEn = '1') and
                               (iLatchHADDR = ADDR_EBITRTIMEOUT3))
                  else
                     '0';

-- -----------------------------------------------------------------------------
-- Output Mux
-- When the peripheral is not being accessed, '0's are driven
-- on the Read Databus (HRDATA)
-- -----------------------------------------------------------------------------
HRDATA           <= ZEROFILL(31 downto 8) & EbiTrCntl when
                                           (EbiTrCntlRd = '1')
                 else
                    ZEROFILL(31 downto 6) & EbiTrStatus when
                                           (EbiTrStatusRd = '1')
                 else
                    ZEROFILL(31 downto 3) & EbiTrClk when
                                           (EbiTrClkRd = '1')
                 else
                    EbiTrAddr1                       when
                                           (EbiTrAddr1Rd = '1')
                 else
                    EbiTrAddr2                       when
                                           (EbiTrAddr2Rd = '1')
                 else
                    EbiTrAddr3                       when
                                           (EbiTrAddr3Rd = '1')
                 else
                    EbiTrData1                       when
                                           (EbiTrData1Rd = '1')

                 else
                    EbiTrData2                       when
                                           (EbiTrData2Rd = '1')
                 else
                    EbiTrData3                       when
                                           (EbiTrData3Rd = '1')
                 else
                    ZEROFILL(31 downto 4) & nEbiTrDataEn1 when
                                           (nEbiTrDataEn1Rd = '1')
                 else
                    ZEROFILL(31 downto 4) & nEbiTrDataEn2 when
                                           (nEbiTrDataEn2Rd = '1')
                 else
                    ZEROFILL(31 downto 4) & nEbiTrDataEn3 when
                                           (nEbiTrDataEn3Rd = '1')
                 else
                                            EbiTrExtDataIn when
                                           (EbiTrExtDataInRd = '1')
                 else
                    ZEROFILL(31 downto 10) & EbiTrTimeOut1 when
                                           (EbiTrTimeOut1Rd = '1')
                 else
                    ZEROFILL(31 downto 10) & EbiTrTimeOut2 when
                                           (EbiTrTimeOut2Rd = '1')
                 else
                    ZEROFILL(31 downto 10) & EbiTrTimeOut3 when
                                           (EbiTrTimeOut3Rd = '1')
                 else

                    ZEROFILL;

-- -----------------------------------------------------------------------------
-- This process generates the bus response required for an AHB slave.
-- EBI Trickbox is designed for an HSIZE of 32-bit. So this process will
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
           (HSELEBITRICKBOX = '1') and
           (HREADYIN = '1')) then
      WrEn          <= '0';
      RdEn          <= '0';
      iHRESP        <= HRESP_OKAY;
      HREADYOUT     <= '1';
    elsif ((HREADYIN = '1') and (HSELEBITRICKBOX = '1')) then
      if (HSIZE = HSIZE_WORD) then
        HREADYOUT   <= '1';
        iLatchHADDR <= HADDR;
        iHRESP      <= HRESP_OKAY;
        if (HWRITE = '1') then
          WrEn      <= '1';
          RdEn      <= '0';
        else
          WrEn      <= '0';
          RdEn      <= '1';
        end if;
      else
        iHRESP      <= HRESP_ERROR;
        HREADYOUT   <= '0';
        WrEn        <= '0';
        RdEn        <= '0';
        ErrorLat    <= '1';
        assert false
          report "Error Response from EBI trickbox slave"
        severity warning;
      end if;
    elsif (HREADYIN = '1') then
      if (HSIZE = HSIZE_WORD) then
        HREADYOUT   <= '1';
        iLatchHADDR <= HADDR;
        iHRESP      <= HRESP_OKAY;
        if (HWRITE = '1') then
          WrEn      <= '0';
          RdEn      <= '0';
        else
          WrEn      <= '0';
          RdEn      <= '0';
        end if;
      else
        iHRESP      <= HRESP_ERROR;
        HREADYOUT   <= '0';
        WrEn        <= '0';
        RdEn        <= '0';
        ErrorLat    <= '1';
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
-- Assign AHB Write Data
-- -----------------------------------------------------------------------------
WriteData        <= HWDATA when (WrEn = '1')
                 else
                    (others => '0');

-- -----------------------------------------------------------------------------
-- Assign local copies of signals to the outputs
-- -----------------------------------------------------------------------------
HRESP            <= iHRESP;

end behavioural;

-- --================================== End ==================================--
