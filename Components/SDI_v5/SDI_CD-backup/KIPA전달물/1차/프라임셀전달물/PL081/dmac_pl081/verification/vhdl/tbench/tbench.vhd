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
-- File Name              : tbench.vhd.rca
-- File Revision          : 1.5
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose : 
--           Top level of the DMAC Compliance TestBench
--
--           This file instantiates the DMAC module, the DMAC trickbox
--           the AHB decoder and the Default Slave. 
--
-- --=========================================================================--

library IEEE;
use     IEEE.std_logic_1164.all;
use     IEEE.std_logic_arith.all;

library tbench;
use     tbench.timing.all;
use     tbench.timingmaster.all;
use     tbench.defsmaster.all;
 

library uut;
 
library trickbox;
use trickbox.DmacTrPackage.all;

entity tbench is
end tbench;

-- ============================ ARCHITECTURE ======================== --

architecture behavioural of tbench is

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------
constant ORBUS        : std_logic := '0';
-- If this bit is set, the testbench will have an OR bus configuration
-- Else, by default, it will be a MUX implementation.

constant Databuswidth : integer := 32;
-- Databus width of the Slave 

-- -----------------------------------------------------------------------------
-- Note on PARAMETERS :
-- * Verbosity       : To suppress messages other than error messages,
--                     Verbosity is to be cleared.
-- * HaltOnMismatch  : If HaltOnMismatch is set, it halts the
--                     simulation when it detects any error.
-- * XonSig          : XonSig if set, enables signals to be unknown
--                     values; else signals will take their default
--                     values.
-- * SuppressOnReset : SuppressOnReset suppresses all protocol checks
--                     on slave's output signals.
-- * Databuswidth    : Databuswidth can be set to 64 or 32, depending
--                     upon the device to be tested.
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- AHB Slave Testbench
-- -----------------------------------------------------------------------------
component ahbslave_tb
  generic (
           INFILE                 : string;
           Verbosity              : integer;
           HaltOnMismatch         : integer;
           XonSig                 : integer;
           tclks                  : time;
           tclkl                  : time;
           tclkh                  : time;
           Databuswidth           : integer;
           ahbslave_tb_TimingFile : string
	  );
  port (
        HREADY           : in    std_logic;
        HRESP            : in    std_logic_vector(1 downto 0);
        HRDATA           : in    std_logic_vector(63 downto 0);
        HSPLIT           : in    std_logic_vector(15 downto 0);
        VRG0             : inout std_logic_vector(31 downto 0);
        VRG1             : inout std_logic_vector(31 downto 0);
        VRG2             : inout std_logic_vector(31 downto 0);
        VRG3             : inout std_logic_vector(31 downto 0);
        VRG4             : inout std_logic_vector(31 downto 0);
        VRG5             : inout std_logic_vector(31 downto 0);
        VRG6             : inout std_logic_vector(31 downto 0);
        VRG7             : inout std_logic_vector(31 downto 0);
        HCLK             : out   std_ulogic;
        HRESETn          : out   std_ulogic;
        HADDR            : out   std_logic_vector(31 downto 0);
        HTRANS           : out   std_logic_vector(1 downto 0);
        HWRITE           : out   std_logic;
        HSIZE            : out   std_logic_vector(2 downto 0);
        HBURST           : out   std_logic_vector(2 downto 0);
        HPROT            : out   std_logic_vector(3 downto 0);
        HMASTER          : out   std_logic_vector(3 downto 0);
        HMASTLOCK        : out   std_logic;
        HWDATA           : out   std_logic_vector(63 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- Address Decoder
-- -----------------------------------------------------------------------------
component decoder
  port (
        HADDR            : in    std_logic_vector(31 downto 0);
        HSEL             : out   std_logic_vector(15 downto 0);
        DefSlaveSel      : out   std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- UUT (DMAC) 
-- -----------------------------------------------------------------------------
component Dmac
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HSELDMAC         : in    std_logic;
        HWRITE           : in    std_logic;
        HTRANS           : in    std_logic;
        HADDR            : in    std_logic_vector(11 downto 2);
        HSIZE            : in    std_logic_vector(2 downto 0);
        HREADYIN         : in    std_logic;
        HWDATA           : in    std_logic_vector(31 downto 0);
        HGRANTDMACM      : in    std_logic;
        HREADYINM        : in    std_logic;
        HRESPM           : in    std_logic_vector(1 downto 0);
        HRDATAM          : in    std_logic_vector(31 downto 0);
        DMACBREQ         : in    std_logic_vector(15 downto 0);
        DMACLBREQ        : in    std_logic_vector(15 downto 0);
        DMACSREQ         : in    std_logic_vector(15 downto 0);
        DMACLSREQ        : in    std_logic_vector(15 downto 0);
        SCANINHCLK       : in    std_logic;
        SCANENABLE       : in    std_logic;
        HREADYOUT        : out   std_logic;
        HRESP            : out   std_logic_vector(1 downto 0);
        HRDATA           : out   std_logic_vector(31 downto 0);
        HBUSREQDMACM     : out   std_logic;
        HLOCKDMACM       : out   std_logic;
        HTRANSM          : out   std_logic_vector(1 downto 0);
        HADDRM           : out   std_logic_vector(31 downto 0);
        HSIZEM           : out   std_logic_vector(2 downto 0);
        HBURSTM          : out   std_logic_vector(2 downto 0);
        HPROTM           : out   std_logic_vector(3 downto 0);
        HWRITEM          : out   std_logic;
        HWDATAM          : out   std_logic_vector(31 downto 0);
        DMACCLR          : out   std_logic_vector(15 downto 0);
        DMACTC           : out   std_logic_vector(15 downto 0);
        DMACINTERR       : out   std_logic;
        DMACINTTC        : out   std_logic;
        DMACINTR         : out   std_logic;
        SCANOUTHCLK      : out   std_logic
       );
  end component;

-- -----------------------------------------------------------------------------
-- DMAC Trickbox
-- -----------------------------------------------------------------------------
component DmacTrick
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HSELDMAC         : in    std_logic;
        HSELDMACTr       : in    std_logic;
        HWRITE           : in    std_logic;
        HTRANS           : in    std_logic;
        HADDR            : in    std_logic_vector(20 downto 2);
        HSIZE            : in    std_logic_vector(2 downto 0);
        HREADYIN         : in    std_logic;
        HREADYINM        : in    std_logic;
        HWDATA           : in    std_logic_vector(31 downto 0);
        HRESPMBeh        : in    std_logic_vector(1 downto 0);
        HRDATAMBeh       : in    std_logic_vector(31 downto 0);
        HBUSREQDMACM     : in    std_logic;
        HLOCKDMACM       : in    std_logic;
        HTRANSM          : in    std_logic_vector(1 downto 0);
        HADDRM           : in    std_logic_vector(31 downto 0);
        HSIZEM           : in    std_logic_vector(2 downto 0);
        HBURSTM          : in    std_logic_vector(2 downto 0);
        HPROTM           : in    std_logic_vector(3 downto 0);
        HWRITEM          : in    std_logic;
        HWDATAM          : in    std_logic_vector(31 downto 0);
        DMACCLR          : in    std_logic_vector(15 downto 0);
        DMACTC           : in    std_logic_vector(15 downto 0);
        DMACINTERR       : in    std_logic;
        DMACINTTC        : in    std_logic;
        DMACINTR         : in    std_logic;
        HREADYOUT        : out   std_logic;
        HRESP            : out   std_logic_vector(1 downto 0);
        HRDATA           : out   std_logic_vector(31 downto 0);
        HGRANTDMACM      : out   std_logic;
        HREADYOUTM       : out   std_logic;
        HRESPM           : out   std_logic_vector(1 downto 0);
        HRDATAM          : out   std_logic_vector(31 downto 0);
        DMACBREQ         : out   std_logic_vector(15 downto 0);
        DMACLBREQ        : out   std_logic_vector(15 downto 0);
        DMACSREQ         : out   std_logic_vector(15 downto 0);
        DMACLSREQ        : out   std_logic_vector(15 downto 0)
       );
  end component;

-- -----------------------------------------------------------------------------
-- Default Slave
-- -----------------------------------------------------------------------------
component defslave
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HSEL             : in    std_logic;
        HTRANS           : in    std_logic;
        HREADYIn         : in    std_logic;
        HRESP            : out   std_logic_vector(1 downto 0);
        HREADYOut        : out   std_logic;
        HRDATAOut        : out   std_logic_vector(63 downto 0) 
       );
end component; 

-- -----------------------------------------------------------------------------
-- Master Buswatch
-- -----------------------------------------------------------------------------
component buswatchmaster
  generic (
           HaltOnMismatch : boolean;
           Verbosity      : boolean;
           Tclk           : time;
           Tovtr          : time;
           Tohtr          : time;
           Tova           : time;
           Toha           : time;
           Tovctl         : time;
           Tohctl         : time;
           Tovwd          : time;
           Tohwd          : time;
           Tovreq         : time;
           Tohreq         : time;
           Tovlck         : time;
           Tohlck         : time
          );
  port (
        HCLK             : in std_logic;
        HRESETn          : in std_logic;
        HTRANS           : in T_trans;
        HADDR            : in T_addr;
        HSIZE            : in T_size;
        HBURST           : in T_burst;
        HBUSREQx         : in std_logic;
        HGRANTx          : in std_logic;
        HREADY           : in T_line;
        HLOCKx           : in T_line;
        HWDATA           : in T_data;
        HPROT            : in T_prot;
        HWRITE           : in T_line;
        HRESP            : in T_resp;
        ResetOver        : out boolean
       );
end component;

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------

-- AHB Bus3 signals.
-- Slave interface of the DMAC and the trickbox are connected here.
signal HCLK             : std_logic;
signal HRESETn          : std_logic;
signal HSEL             : std_logic_vector(15 downto 0);
signal HMASTLOCK        : T_line;
signal HWRITE           : T_line;
signal HSIZE            : T_size;
signal HBURST           : T_burst;
signal HPROT            : T_prot;
signal HTRANS           : T_trans;
signal HRESP            : T_resp;
signal HREADY           : T_line;
signal HSPLIT           : std_logic_vector(15 downto 0);
signal HMASTER          : std_logic_vector(3 downto 0);
signal HADDR            : T_addr;
signal HRDATA           : T_data;
signal HWDATA           : T_data;

-- AHB Bus3 arbitration signals.
signal HLOCK            : std_logic := '0';
signal HBUSREQ          : std_logic := '1';
signal HGRANT           : std_logic := '1';

-- Virtual registers.
signal VRG0             : std_logic_vector(31 downto 0);
signal VRG1             : std_logic_vector(31 downto 0);
signal VRG2             : std_logic_vector(31 downto 0);
signal VRG3             : std_logic_vector(31 downto 0);
signal VRG4             : std_logic_vector(31 downto 0);
signal VRG5             : std_logic_vector(31 downto 0);
signal VRG6             : std_logic_vector(31 downto 0);
signal VRG7             : std_logic_vector(31 downto 0);

-- Internal version of virtual registers.
signal iVRG0            : std_logic_vector(31 downto 0);
signal iVRG1            : std_logic_vector(31 downto 0);
signal iVRG2            : std_logic_vector(31 downto 0);
signal iVRG3            : std_logic_vector(31 downto 0);

-- DMAC response signals.
signal HREADYOutDmac    : T_line;
signal HRESPOutDmac     : T_resp;
signal HRDATAOutDmac    : T_data;
signal iHRDATAOutDmac   : T_data;

-- DMAC Trickbox response signals.
signal HREADYOutDmacTr  : T_line;
signal HRESPOutDmacTr   : T_resp;
signal HRDATAOutDmacTr  : T_data;
signal iHRDATAOutDmacTr : T_data;

-- Default Slave signals.
signal HREADYOutDef     : T_line;
signal HRDATAOutDef     : T_data;
signal HRESPOutDef      : T_resp;

signal DelHSEL          : std_logic_vector(15 downto 0);
signal DefSlaveSel      : std_logic;
signal DelDefSel        : std_logic;

-- MUX Bus signals
signal HREADYMUX        : T_line;
signal HRESPMUX         : T_resp;
signal HRDATAMUX        : T_data;

-- OR Bus signals
signal HREADYOR         : T_line;
signal HRESPOR          : T_resp;
signal HRDATAOR         : T_data;

-- Scan Ports of DMAC.
signal SCANENABLE       : std_logic;
signal SCANINHCLK       : std_logic;
signal SCANOUTHCLK      : std_logic;

-- -----------------------------------------------------------------------------
-- Dmac Signal declarations
-- -----------------------------------------------------------------------------

-- AHB Bus1 signals.
-- Master 1 of the DMAC and the trickbox are connected here.
signal HWRITEM          : std_logic;
signal HSIZEM           : std_logic_vector(2 downto 0);
signal HBURSTM          : std_logic_vector(2 downto 0);
signal HPROTM           : std_logic_vector(3 downto 0);
signal HTRANSM          : std_logic_vector(1 downto 0);
signal HRESP1           : std_logic_vector(1 downto 0);
signal HREADY1          : std_logic;
signal HADDRM           : std_logic_vector(31 downto 0);
signal HRDATA1          : T_data;
signal HWDATA1          : T_data;
signal StuffedHWDATA    : std_logic_vector(63 downto 0);

-- AHB Bus1 arbitration signals.
signal HLOCKDMACM       : std_logic;
signal HBUSREQDMACM     : std_logic;
signal HGRANTDMACM      : std_logic := '1';

-- DMA Peripheral signals.
signal DMACSREQ         : std_logic_vector(15 downto 0) := "0000000000000000";
signal DMACLSREQ        : std_logic_vector(15 downto 0) := "0000000000000000";
signal DMACBREQ         : std_logic_vector(15 downto 0) := "0000000000000000";
signal DMACLBREQ        : std_logic_vector(15 downto 0) := "0000000000000000";

signal DMACCLR          : std_logic_vector(15 downto 0);
signal DMACTC           : std_logic_vector(15 downto 0);

-- DMA Interrupt signals.
signal DMACINTERR       : std_logic;
signal DMACINTTC        : std_logic;
signal DMACINTR         : std_logic;

-- DMAC Trickbox response signals for AHB Bus1.
signal HREADYOutTr1     : T_line := '0';
signal HRESPOutTr1      : T_resp := (others => '0');
signal HRDATAOutTr1     : T_data := (others => '0');
signal iHRDATAOutTr1    : T_data := (others => '0');

-- Default Slave signals for AHB Bus1.
signal HREADYOutDef1    : T_line;
signal HRDATAOutDef1    : T_data;
signal HRESPOutDef1     : T_resp;

signal HSELMEM          : std_logic;
signal DelHSELMEM       : std_logic;
signal DefSlaveSel1     : std_logic;
signal DelDefSel1       : std_logic;

-- MUX Bus signals for AHB Bus1.
signal HREADY1MUX       : T_line;
signal HRESP1MUX        : T_resp;
signal HRDATA1MUX       : T_data;

-- OR Bus signals for AHB Bus1.
signal HREADY1OR        : T_line;
signal HRESP1OR         : T_resp;
signal HRDATA1OR        : T_data;

-- MUX Bus signals for AHB Bus1 master
signal DelHGRANTDMACM   : std_logic;
signal HTRANSMMux       : T_trans;

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

iVRG0            <= VRG0;
iVRG1            <= VRG1;
iVRG2            <= VRG2;
iVRG3            <= VRG3;

VRG4             <= iVRG0;
VRG5             <= iVRG1;
VRG7             <= iVRG3;
VRG6             <= iVRG2;

-- -----------------------------------------------------------------------------
--  AHB BUS3 CONFIGURATION
-- The slave interfaces of the Dmac and the Trickbox are connected to
-- this bus.
-- -----------------------------------------------------------------------------
HREADY           <= HREADYOR when (ORBUS = '1')
                 else
                    HREADYMUX;

HRESP            <= HRESPOR when (ORBUS = '1')
                 else
                    HRESPMUX;

HSPLIT           <= (others => '0');

HRDATA           <= HRDATAOR when (ORBUS = '1') 
                 else
                    HRDATAMUX;

-- -----------------------------------------------------------------------------
-- Connect all the scan inputs to '0' to prevent interference with
-- functional mode tests.
-- -----------------------------------------------------------------------------
SCANENABLE       <= '0';
SCANINHCLK       <= '0';

-- -----------------------------------------------------------------------------
-- Initialise iHRDATAOutx for every slave to be tested 
-- -----------------------------------------------------------------------------
iHRDATAOutDmac   <= (to_stdlogicvector(X"00000000") &
                    HRDATAOutDmac(31 downto 0)) when (Databuswidth = 32)
                 else
                    HRDATAOutDmac;

iHRDATAOutDmacTr <= (to_stdlogicvector(X"00000000") &
                    HRDATAOutDmacTr(31 downto 0)) when (Databuswidth = 32)
                 else
                    HRDATAOutDmacTr;

-- -----------------------------------------------------------------------------
-- For MUX-bus implementations
-- -----------------------------------------------------------------------------
HREADYMUX        <= HREADYOutDmac when (DelHSEL(0) = '1')
                 else
                    HREADYOutDmacTr when (DelHSEL(1) = '1') 
                 else
                    HREADYOutDef when DelDefSel = '1'
                 else
                    '0';

HRESPMUX         <= HRESPOutDmac when (DelHSEL(0) = '1')
                 else
                    HRESPOutDmacTr when (DelHSEL(1) = '1') 
                 else
                    HRESPOutDef when DelDefSel = '1'
                 else
                    "00";

HRDATAMUX        <= iHRDATAOutDmac when (DelHSEL(0) = '1')
                 else
                    iHRDATAOutDmacTr when (DelHSEL(1) = '1')
                 else
                    HRDATAOutDef when DelDefSel = '1'
                 else
                    to_stdlogicvector(X"0000000000000000");

-- -----------------------------------------------------------------------------
-- For OR bus implementations
-- -----------------------------------------------------------------------------
HRESPOR          <= HRESPOutDmac or HRESPOutDmacTr or HRESPOutDef;

HREADYOR         <= HREADYOutDmac or HREADYOutDmacTr or HREADYOutDef;

HRDATAOR         <= iHRDATAOutDmac or iHRDATAOutDmacTr or HRDATAOutDef;

-- -----------------------------------------------------------------------------
-- Latching HSEL
-- -----------------------------------------------------------------------------
p_DelHSELSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    DelHSEL   <= (others => '0');
    DelDefSel <= '1';
  elsif (HCLK'event and HCLK = '1' and HREADY = '1') then
    DelHSEL   <= HSEL;
    DelDefSel <= DefSlaveSel;
  end if;
end process p_DelHSELSeq;
 
-- -----------------------------------------------------------------------------
--  AHB BUS1 CONFIGURATION
-- -----------------------------------------------------------------------------
HREADY1          <= HREADY1OR when (ORBUS = '1')
                 else
                    HREADY1MUX;

HRESP1           <= HRESP1OR when (ORBUS = '1')
                 else
                    HRESP1MUX;

HRDATA1          <= HRDATA1OR when (ORBUS = '1') 
                 else
                    HRDATA1MUX;

-- -----------------------------------------------------------------------------
-- Initialise iHRDATAOutx for every slave to be tested 
-- -----------------------------------------------------------------------------
iHRDATAOutTr1    <= (to_stdlogicvector(X"00000000") &
                    HRDATAOutTr1(31 downto 0)) when (Databuswidth = 32)
                 else
                    HRDATAOutTr1;

-- -----------------------------------------------------------------------------
-- For MUX-bus implementations
-- When the HGRANT of the corresponding bus stays with the Dmac,
-- the HSEL1 for the trickbox is generated. Otherwise it points to the
-- default slave on AHB Bus1.
-- -----------------------------------------------------------------------------
HREADY1MUX       <= HREADYOutTr1 when (DelHSELMEM = '1') 
                 else
                    HREADYOutDef1 when DelDefSel1 = '1'
                 else
                    '0';

HRESP1MUX        <= HRESPOutTr1 when (DelHSELMEM = '1') 
                 else
                    HRESPOutDef1 when DelDefSel1 = '1'
                 else
                    "00";

HRDATA1MUX       <= iHRDATAOutTr1 when (DelHSELMEM = '1')
                 else
                    HRDATAOutDef1 when DelDefSel1 = '1'
                 else
                    to_stdlogicvector(X"0000000000000000");

-- -----------------------------------------------------------------------------
-- For OR bus implementations
-- -----------------------------------------------------------------------------
HRESP1OR         <= HRESPOutTr1 or HRESPOutDef1;

HREADY1OR        <= HREADYOutTr1 or HREADYOutDef1;

HRDATA1OR        <= iHRDATAOutTr1 or HRDATAOutDef1;

-- -----------------------------------------------------------------------------
-- Generating HSEL
-- -----------------------------------------------------------------------------
HSELMEM         <= '1' when (((HADDRM(31 downto 0) >= M0LOWADDRRANGE) and
                               (HADDRM(31 downto 0) <= M0HIGHADDRRANGE)) or
                             ((HADDRM(31 downto 0) >= M1LOWADDRRANGE) and
                               (HADDRM(31 downto 0) <= M1HIGHADDRRANGE)) or
                             ((HADDRM(31 downto 0) >= P0LOWADDRRANGE) and
                               (HADDRM(31 downto 0) <= P0HIGHADDRRANGE)) or
                             ((HADDRM(31 downto 0) >= P1LOWADDRRANGE) and
                               (HADDRM(31 downto 0) <= P1HIGHADDRRANGE)) or
                             ((HADDRM(31 downto 0) >= P2LOWADDRRANGE) and
                               (HADDRM(31 downto 0) <= P2HIGHADDRRANGE)) or
                             ((HADDRM(31 downto 0) >= P3LOWADDRRANGE) and
                               (HADDRM(31 downto 0) <= P3HIGHADDRRANGE)) or
                             ((HADDRM(31 downto 0) >= P4LOWADDRRANGE) and
                               (HADDRM(31 downto 0) <= P4HIGHADDRRANGE)) or
                             ((HADDRM(31 downto 0) >= P5LOWADDRRANGE) and
                               (HADDRM(31 downto 0) <= P5HIGHADDRRANGE)) or
                             ((HADDRM(31 downto 0) >= P6LOWADDRRANGE) and
                               (HADDRM(31 downto 0) <= P6HIGHADDRRANGE)) or
                             ((HADDRM(31 downto 0) >= P7LOWADDRRANGE) and
                               (HADDRM(31 downto 0) <= P7HIGHADDRRANGE)) or
                             ((HADDRM(31 downto 0) >= P8LOWADDRRANGE) and
                               (HADDRM(31 downto 0) <= P8HIGHADDRRANGE)) or
                             ((HADDRM(31 downto 0) >= P9LOWADDRRANGE) and
                               (HADDRM(31 downto 0) <= P9HIGHADDRRANGE)) or
                             ((HADDRM(31 downto 0) >= P10LOWADDRRANGE) and
                               (HADDRM(31 downto 0) <= P10HIGHADDRRANGE)) or
                             ((HADDRM(31 downto 0) >= P11LOWADDRRANGE) and
                               (HADDRM(31 downto 0) <= P11HIGHADDRRANGE)) or
                             ((HADDRM(31 downto 0) >= P12LOWADDRRANGE) and
                               (HADDRM(31 downto 0) <= P12HIGHADDRRANGE)) or
                             ((HADDRM(31 downto 0) >= P13LOWADDRRANGE) and
                               (HADDRM(31 downto 0) <= P13HIGHADDRRANGE)) or
                             ((HADDRM(31 downto 0) >= P14LOWADDRRANGE) and
                               (HADDRM(31 downto 0) <= P14HIGHADDRRANGE)) or
                             ((HADDRM(31 downto 0) >= P15LOWADDRRANGE) and
                               (HADDRM(31 downto 0) <= P15HIGHADDRRANGE)))
                 else
                    '0';
 
DefSlaveSel1    <= not(HSELMEM);
 
-- -----------------------------------------------------------------------------
-- Latching HSEL
-- -----------------------------------------------------------------------------
p_DelHSEL1Seq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    DelHSELMEM  <= '0';
    DelDefSel1  <= '1';
  elsif (HCLK'event and HCLK = '1' and HREADY1 = '1') then
    DelHSELMEM  <= HSELMEM ;
    DelDefSel1  <= DefSlaveSel1;
  end if;
end process p_DelHSEL1Seq;
 
-- -----------------------------------------------------------------------------
-- Latching HGRANTDMACM
-- -----------------------------------------------------------------------------
p_DelHGRANT1Seq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    DelHGRANTDMACM    <= '0';
  elsif (HCLK'event and HCLK = '1' and HREADY1 = '1') then
    DelHGRANTDMACM    <= HGRANTDMACM;
  end if;
end process p_DelHGRANT1Seq;
 
HTRANSMMux <= HTRANSM when (DelHGRANTDMACM = '1')
            else "00";

-- -----------------------------------------------------------------------------
-- AHB Slave Testbench instantiation
-- -----------------------------------------------------------------------------
uahbslv_tb : ahbslave_tb
  generic map (
               INFILE                 =>
                                      "../../bustest/invec/infile.bif",
               Verbosity              => 0,
               HaltOnMismatch         => 0,
               XonSig                 => 0,
               Tclks                  => Tclks,
               Tclkl                  => Tclkl,
               Tclkh                  => Tclkh,
               Databuswidth           => Databuswidth,
               ahbslave_tb_TimingFile => ""
    	    )
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HADDR            => HADDR,
            HTRANS           => HTRANS,
            HWRITE           => HWRITE,
            HSIZE            => HSIZE,
            HBURST           => HBURST,
            HPROT            => HPROT,
            HMASTER          => HMASTER,
            HMASTLOCK        => HMASTLOCK,
            HWDATA           => HWDATA,
            HSPLIT           => HSPLIT,
            HRDATA           => HRDATA,
            HREADY           => HREADY,
            HRESP            => HRESP,
            VRG0             => VRG0,
            VRG1             => VRG1,
            VRG2             => VRG2,
            VRG3             => VRG3,
            VRG4             => VRG4,
            VRG5             => VRG5,
            VRG6             => VRG6,
            VRG7             => VRG7
           );

-- -----------------------------------------------------------------------------
-- Address Decoder instantiation
-- -----------------------------------------------------------------------------
udecoder : decoder
  port map (
            HADDR            => HADDR,
            HSEL             => HSEL,
            DefSlaveSel      => DefSlaveSel
           );

-- -----------------------------------------------------------------------------
-- UUT instantiation (DMAC) 
-- -----------------------------------------------------------------------------
uut : Dmac
 port map (
        HCLK              => HCLK,
        HRESETn           => HRESETn,
        HSELDMAC          => HSEL(0),
        HWRITE            => HWRITE,
        HTRANS            => HTRANS(1),
        HADDR             => HADDR(11 downto 2),
        HSIZE             => HSIZE,
        HREADYIN          => HREADY,
        HWDATA            => HWDATA(31 downto 0),
        HGRANTDMACM       => HGRANTDMACM,
        HREADYINM         => HREADY1,
        HRESPM            => HRESP1,
        HRDATAM           => HRDATA1(31 downto 0),
        DMACBREQ          => DMACBREQ,
        DMACLBREQ         => DMACLBREQ,
        DMACSREQ          => DMACSREQ,
        DMACLSREQ         => DMACLSREQ,
        SCANINHCLK        => SCANINHCLK,
        SCANENABLE        => SCANENABLE,
        HREADYOUT         => HREADYOutDmac,
        HRESP             => HRESPOutDmac,
        HRDATA            => HRDATAOutDmac(31 downto 0),
        HBUSREQDMACM      => HBUSREQDMACM,
        HLOCKDMACM        => HLOCKDMACM,
        HTRANSM           => HTRANSM,
        HADDRM            => HADDRM,
        HSIZEM            => HSIZEM,
        HBURSTM           => HBURSTM,
        HPROTM            => HPROTM,
        HWRITEM           => HWRITEM,
        HWDATAM           => HWDATA1(31 downto 0),
        DMACCLR           => DMACCLR,
        DMACTC            => DMACTC,
        DMACINTERR        => DMACINTERR,
        DMACINTTC         => DMACINTTC,
        DMACINTR          => DMACINTR,
        SCANOUTHCLK       => SCANOUTHCLK
       );

-- -----------------------------------------------------------------------------
-- DMAC Trickbox Instantiation
-- -----------------------------------------------------------------------------
uDmacTrick : DmacTrick
  port map (
        HCLK              => HCLK,
        HRESETn           => HRESETn,
        HSELDMAC          => HSEL(0),
        HSELDMACTr        => HSEL(1),
        HWRITE            => HWRITE,
        HTRANS            => HTRANS(1),
        HADDR             => HADDR(20 downto 2),
        HSIZE             => HSIZE,
        HREADYIN          => HREADY,
        HWDATA            => HWDATA(31 downto 0),
        HREADYINM         => HREADY1,
        HRESPMBeh         => HRESP1,
        HRDATAMBeh        => HRDATA1(31 downto 0),
        HBUSREQDMACM      => HBUSREQDMACM,
        HLOCKDMACM        => HLOCKDMACM,
        HTRANSM           => HTRANSMMux,
        HADDRM            => HADDRM,
        HSIZEM            => HSIZEM,
        HBURSTM           => HBURSTM,
        HPROTM            => HPROTM,
        HWRITEM           => HWRITEM,
        HWDATAM           => HWDATA1(31 downto 0),
        DMACCLR           => DMACCLR,
        DMACTC            => DMACTC,
        DMACINTERR        => DMACINTERR,
        DMACINTTC         => DMACINTTC,
        DMACINTR          => DMACINTR,
        HREADYOUT         => HREADYOutDmacTr,
        HRESP             => HRESPOutDmacTr,
        HRDATA            => HRDATAOutDmacTr(31 downto 0),
        HGRANTDMACM       => HGRANTDMACM,
        HREADYOUTM        => HREADYOutTr1,
        HRESPM            => HRESPOutTr1,
        HRDATAM           => HRDATAOutTr1(31 downto 0),
        DMACBREQ          => DMACBREQ,
        DMACLBREQ         => DMACLBREQ,
        DMACSREQ          => DMACSREQ,
        DMACLSREQ         => DMACLSREQ
       );

-- -----------------------------------------------------------------------------
-- Default Slave Instantiation for AHB Bus3
-- -----------------------------------------------------------------------------
u0Defslave : Defslave
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HSEL             => DelDefSel,
            HTRANS           => HTRANS(1),
            HRESP            => HRESPOutDef,
            HREADYIn         => HREADY,
            HREADYOut        => HREADYOutDef,
            HRDATAOut        => HRDATAOutDef
           );

-- -----------------------------------------------------------------------------
-- Default Slave Instantiation for AHB Bus1
-- -----------------------------------------------------------------------------
u1Defslave : Defslave
  port map (
            HCLK             => HCLK,
            HSEL             => DelDefSel1,
            HRESETn          => HRESETn,
            HTRANS           => HTRANSM(1),
            HRESP            => HRESPOutDef1,
            HREADYIn         => HREADY1,
            HREADYOut        => HREADYOutDef1,
            HRDATAOut        => HRDATAOutDef1
           );

-- -----------------------------------------------------------------------------
-- Master Buswatch Instantiation
-- -----------------------------------------------------------------------------
 u0buswatchmaster : buswatchmaster
   generic map (
                HaltOnMismatch => FALSE,
                Verbosity      => FALSE,
                Tclk           => Tclk,
                Tovtr          => Tovtr,
                Tohtr          => Tohtr,
                Tova           => Tova,
                Toha           => Toha,
                Tovctl         => Tovctl,
                Tohctl         => Tohctl,
                Tovwd          => Tovwd,
                Tohwd          => Tohwd,
                Tovreq         => Tovreq,
                Tohreq         => Tohreq,
                Tovlck         => Tovlck,
                Tohlck         => Tohlck
               )
   port map (
             HCLK             => HCLK,
             HRESETn          => HRESETn,
             HTRANS           => HTRANS,
             HADDR            => HADDR,
             HSIZE            => HSIZE,
             HBURST           => HBURST,
             HBUSREQx         => HBUSREQ,
             HGRANTx          => HGRANT,
             HREADY           => HREADY,
             HLOCKx           => HLOCK,
             HWDATA           => HWDATA,
             HPROT            => HPROT,
             HWRITE           => HWRITE,
             HRESP            => HRESP,
             ResetOver        => OPEN
            );

StuffedHWDATA <= to_stdlogicvector(X"00000000") & HWDATA1(31 downto 0);

u1buswatchmaster : buswatchmaster
  generic map (
               HaltOnMismatch => FALSE,
               Verbosity      => FALSE,
               Tclk           => Tclk,
               Tovtr          => Tovtr,
               Tohtr          => Tohtr,
               Tova           => Tova,
               Toha           => Toha,
               Tovctl         => Tovctl,
               Tohctl         => Tohctl,
               Tovwd          => Tovwd,
               Tohwd          => Tohwd,
               Tovreq         => Tovreq,
               Tohreq         => Tohreq,
               Tovlck         => Tovlck,
               Tohlck         => Tohlck
              )
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HTRANS           => HTRANSM,
            HADDR            => HADDRM,
            HSIZE            => HSIZEM,
            HBURST           => HBURSTM,
            HBUSREQx         => HBUSREQDMACM,
            HGRANTx          => HGRANTDMACM,
            HREADY           => HREADY1,
            HLOCKx           => HLOCKDMACM,
            HWDATA           => StuffedHWDATA,
            HPROT            => HPROTM,
            HWRITE           => HWRITEM,
            HRESP            => HRESP1,
            ResetOver        => OPEN
           );

end behavioural;

-- --================================ End ====================================--
