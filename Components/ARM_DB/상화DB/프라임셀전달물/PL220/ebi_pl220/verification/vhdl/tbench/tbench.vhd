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
-- File Name              : tbench.vhd.rca
-- File Revision          : 1.2
--
-- Release Information    : PrimeCell(TM)-PL220-r0p0-00ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose : 
--           Top level of the EBI Compliance TestBench
--
--           This file instantiates the EBI module, the EBI trickbox
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
use trickbox.EbiTrPackage.all;

entity tbench is
end tbench;

-- --============================== ARCHITECTURE =============================--

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
-- UUT (Ebi)
-- -----------------------------------------------------------------------------
component Ebi
  port (
        EBICLK           : in    std_logic;
        nPOR             : in    std_logic;
        EBIREQ1          : in    std_logic;
        EBIADDR1         : in    std_logic_vector(31 downto 0);
        EBIDATA1         : in    std_logic_vector(31 downto 0);
        nEBIDATAEN1      : in    std_logic_vector(3 downto 0);
        EBITIMEOUTVALUE1 : in    std_logic_vector(9 downto 0);
        EBIREQ2          : in    std_logic;
        EBIADDR2         : in    std_logic_vector(31 downto 0);
        EBIDATA2         : in    std_logic_vector(31 downto 0);
        nEBIDATAEN2      : in    std_logic_vector(3 downto 0);
        EBITIMEOUTVALUE2 : in    std_logic_vector(9 downto 0);
        EBIREQ3          : in    std_logic;
        EBIADDR3         : in    std_logic_vector(31 downto 0);
        EBIDATA3         : in    std_logic_vector(31 downto 0);
        nEBIDATAEN3      : in    std_logic_vector(3 downto 0);
        EBITIMEOUTVALUE3 : in    std_logic_vector(9 downto 0);
        EBIEXTDATAIN     : in    std_logic_vector(31 downto 0);
        SCANENABLE       : in    std_logic;
        SCANINEBICLK     : in    std_logic;
        EBIGNT1          : out   std_logic;
        EBIBACKOFF1      : out   std_logic;
        EBIGNT2          : out   std_logic;
        EBIBACKOFF2      : out   std_logic;
        EBIGNT3          : out   std_logic;
        EBIBACKOFF3      : out   std_logic;
        EBIEXTDATAOUT    : out   std_logic_vector(31 downto 0);
        EBIEXTADDROUT    : out   std_logic_vector(31 downto 0);
        nEBIEXTDATAEN    : out   std_logic_vector(3 downto 0);
        EBIDATAIN        : out   std_logic_vector(31 downto 0);
        SCANOUTEBICLK    : out   std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- EBI Trickbox
-- -----------------------------------------------------------------------------
component EbiTrick
  generic (
           Tclkl            : time;
           Tclkh            : time;
           Tclks            : time
          );
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HADDR            : in    std_logic_vector(11 downto 2);
        HTRANS           : in    std_logic_vector(1 downto 0);
        HWRITE           : in    std_logic;
        HSIZE            : in    std_logic_vector(2 downto 0);
        HREADYIN         : in    std_logic;
        HWDATA           : in    std_logic_vector(31 downto 0);
        HSELEBITRICKBOX  : in    std_logic;
        EBIGNT1          : in    std_logic;
        EBIGNT2          : in    std_logic;
        EBIGNT3          : in    std_logic;
        EBIBACKOFF1      : in    std_logic;
        EBIBACKOFF2      : in    std_logic;
        EBIBACKOFF3      : in    std_logic;
        nEBIEXTDATAEN    : in    std_logic_vector(3 downto 0);
        EBIEXTADDROUT    : in    std_logic_vector(31 downto 0);
        EBIEXTDATAOUT    : in    std_logic_vector(31 downto 0);
        EBIDATAIN        : in    std_logic_vector(31 downto 0);
        EBICLK           : out   std_logic;
        EBIREQ1          : out   std_logic;
        EBIREQ2          : out   std_logic;
        EBIREQ3          : out   std_logic;
        nPOR             : out   std_logic;
        HREADYOUT        : out   std_logic;
        HRESP            : out   std_logic_vector(1 downto 0);
        HRDATA           : out   std_logic_vector(31 downto 0);
        EBIADDR1         : out   std_logic_vector(31 downto 0);
        EBIADDR2         : out   std_logic_vector(31 downto 0);
        EBIADDR3         : out   std_logic_vector(31 downto 0);
        EBIDATA1         : out   std_logic_vector(31 downto 0);
        EBIDATA2         : out   std_logic_vector(31 downto 0);
        EBIDATA3         : out   std_logic_vector(31 downto 0);
        nEBIDATAEN1      : out   std_logic_vector(3 downto 0);
        nEBIDATAEN2      : out   std_logic_vector(3 downto 0);
        nEBIDATAEN3      : out   std_logic_vector(3 downto 0);
        EBIEXTDATAIN     : out   std_logic_vector(31 downto 0);
        EBITIMEOUTVALUE1 : out   std_logic_vector(9 downto 0);
        EBITIMEOUTVALUE2 : out   std_logic_vector(9 downto 0);
        EBITIMEOUTVALUE3 : out   std_logic_vector(9 downto 0)
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
        HBUSREQ          : in std_logic;
        HGRANT           : in std_logic;
        HREADY           : in T_line;
        HLOCK            : in T_line;
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
signal HCLK             : std_logic;
signal HRESETn          : std_logic;

-- Virtual registers (AHB).
signal VRG0             : std_logic_vector(31 downto 0);
signal VRG1             : std_logic_vector(31 downto 0);
signal VRG2             : std_logic_vector(31 downto 0);
signal VRG3             : std_logic_vector(31 downto 0);
signal VRG4             : std_logic_vector(31 downto 0);
signal VRG5             : std_logic_vector(31 downto 0);
signal VRG6             : std_logic_vector(31 downto 0);
signal VRG7             : std_logic_vector(31 downto 0);

-- Internal version of virtual registers (AHB).
signal iVRG0            : std_logic_vector(31 downto 0);
signal iVRG1            : std_logic_vector(31 downto 0);
signal iVRG2            : std_logic_vector(31 downto 0);
signal iVRG3            : std_logic_vector(31 downto 0);

-- EBI Trickbox Response signals for AHB.
signal HREADYOutEBITr    : T_line;
signal HRESPOutEBITr     : T_resp;
signal HRDATAOutEBITr    : T_data;
signal iHRDATAOutEBITr   : T_data;

-- -----------------------------------------------------------------------------
-- Ebi Signal declarations
-- -----------------------------------------------------------------------------
signal  EBICLK           : std_logic;
-- External Bus Interface Clock

signal  nPOR             : std_logic;
 -- Power On Reset

signal  EBIREQ1          : std_logic;
 -- EBI request for Port 1,Active high

signal  EBIADDR1         :std_logic_vector(31 downto 0);
-- EBI Address for Port 1

signal  EBIDATA1         : std_logic_vector(31 downto 0);
-- EBI Data for Port 1

signal  nEBIDATAEN1      : std_logic_vector(3 downto 0);
-- EBI Data Enable for port 1

signal  EBITIMEOUTVALUE1 : std_logic_vector(9 downto 0);
-- Gives the value to be loaded into timeout counter for port 1.

signal  EBIREQ2          : std_logic;
-- EBI request for Port 2, Active high

signal  EBIADDR2         : std_logic_vector(31 downto 0);
-- EBI Address for Port 2

signal  EBIDATA2         : std_logic_vector(31 downto 0);
-- EBI Data for Port 2

signal  nEBIDATAEN2      : std_logic_vector(3 downto 0);
-- EBI Data Enable for port 2

signal  EBITIMEOUTVALUE2 : std_logic_vector(9 downto 0);
-- Gives the value to be loaded into timeout counter for port 2.

signal  EBIREQ3          : std_logic;
-- EBI request for Port 3, Active high

signal  EBIADDR3         : std_logic_vector(31 downto 0);
-- EBI Address for Port 3

signal  EBIDATA3         : std_logic_vector(31 downto 0);
-- EBI Data for Port 3

signal  nEBIDATAEN3      : std_logic_vector(3 downto 0);
-- EBI Data Enable for port 3

signal  EBITIMEOUTVALUE3 : std_logic_vector(9 downto 0);
-- Gives the value to be loaded into timeout counter for port 3.

signal  EBIEXTDATAIN     : std_logic_vector(31 downto 0);
-- External Data input for the Pads

signal  SCANENABLE       : std_logic;
-- Scan enable signal

signal  SCANINEBICLK     : std_logic;
-- Scan input signal

signal  EBIGNT1          : std_logic;
-- EBI Grant for port 1

signal  EBIBACKOFF1      : std_logic;
-- EBIBACKOFF signal for port 1 Indicates to Controller-1 that the current
-- transfer should be completed as soon as possible.

signal  EBIGNT2          : std_logic;
-- EBI Grant for port 2

signal  EBIBACKOFF2      : std_logic;
-- EBIBACKOFF signal for port 2 Indicates to Controller-2 that the current
-- transfer should be completed as soon as possible.

signal  EBIGNT3          : std_logic;
-- EBI Grant for port 3

signal  EBIBACKOFF3      : std_logic;
-- EBIBACKOFF signal for port 3 Indicates to Controller-3 that the current
-- transfer should be completed as soon as possible.

signal  EBIEXTDATAOUT    : std_logic_vector(31 downto 0);
-- Data output to the pads

signal  EBIEXTADDROUT    : std_logic_vector(31 downto 0);
-- Address output to the pads

signal  nEBIEXTDATAEN    : std_logic_vector(3 downto 0);
-- Data Enable to the Pads

signal  EBIDATAIN        : std_logic_vector(31 downto 0);
-- Data input connected to all the Controllers

signal  SCANOUTEBICLK    : std_logic;
-- Scan output signal

-- AHB Bus signals.
signal HWRITE           : std_logic;
signal HSIZE            : std_logic_vector(2 downto 0);
signal HBURST           : std_logic_vector(2 downto 0);
signal HPROT            : std_logic_vector(3 downto 0);
signal HTRANS           : std_logic_vector(1 downto 0);
signal HRESP            : std_logic_vector(1 downto 0);
signal HREADY           : std_logic;
signal HADDR            : std_logic_vector(31 downto 0);
signal HRDATA           : T_data;
signal HWDATA           : T_data;
signal HSPLIT           : std_logic_vector(15 downto 0);
signal HMASTER          : std_logic_vector(3 downto 0);
signal HMASTLOCK        : T_line;


-- Default Slave signals for AHB Bus.
signal HREADYOutDef     : T_line;
signal HRDATAOutDef     : T_data;
signal HRESPOutDef      : T_resp;

signal DefSlaveSel      : std_logic;
signal DelDefSel        : std_logic;

-- Decoder Signals
signal HSEL             : std_logic_vector(15 downto 0);
signal DelHSEL          : std_logic_vector(15 downto 0);

-- MUX Bus signals for AHB Bus.
signal HREADYMUX        : T_line;
signal HRESPMUX         : T_resp;
signal HRDATAMUX        : T_data;

-- OR Bus signals for AHB Bus.
signal HREADYOR         : T_line;
signal HRESPOR          : T_resp;
signal HRDATAOR         : T_data;

-- AHB Bus Arbitration signals.
signal HLOCK            : std_logic := '0';
signal HBUSREQ          : std_logic := '1';
signal HGRANT           : std_logic := '1';

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- VRGs (AHB)
-- -----------------------------------------------------------------------------
iVRG0           <= VRG0;
iVRG1           <= VRG1;
iVRG2           <= VRG2;
iVRG3           <= VRG3;

VRG4            <= iVRG0;
VRG5            <= iVRG1;
VRG7            <= iVRG3;
VRG6            <= iVRG2;

-- -----------------------------------------------------------------------------
--  AHB BUS CONFIGURATION
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
-- Initialise iHRDATAOut for every slave to be tested 
-- -----------------------------------------------------------------------------

iHRDATAOutEBITr  <= (to_stdlogicvector(X"00000000") &
                    HRDATAOutEBITr(31 downto 0)) when (Databuswidth = 32)
                 else
                    HRDATAOutEBITr;

-- -----------------------------------------------------------------------------
-- For MUX-bus implementations
-- When trickbox is selected, the bus will remain with trickbox. Else it default
-- will be selected.
-- -----------------------------------------------------------------------------
HREADYMUX       <= HREADYOutEBITr when (DelHSEL(8) = '1') 
                 else
                   HREADYOutDef when (DelDefSel = '1')
                 else
                   '0';

HRESPMUX        <= HRESPOutEBITr when (DelHSEL(8) = '1') 
                 else
                   HRESPOutDef when (DelDefSel = '1')
                 else
                   "00";

HRDATAMUX       <= iHRDATAOutEBITr when (DelHSEL(8) = '1')
                 else
                   HRDATAOutDef when (DelDefSel = '1')
                 else
                   to_stdlogicvector(X"0000000000000000");

-- -----------------------------------------------------------------------------
-- For OR bus implementations
-- -----------------------------------------------------------------------------
HRESPOR         <= HRESPOutEBITr or HRESPOutDef;

HREADYOR        <= HREADYOutEBITr or HREADYOutDef;

HRDATAOR        <= iHRDATAOutEBITr or HRDATAOutDef;

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
-- Default Slave Instantiation for AHB Bus
-- -----------------------------------------------------------------------------
u0Defslave : Defslave
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HSEL             => DefSlaveSel,
            HTRANS           => HTRANS(1),
            HRESP            => HRESPOutDef,
            HREADYIn         => HREADY,
            HREADYOut        => HREADYOutDef,
            HRDATAOut        => HRDATAOutDef
           );

-- -----------------------------------------------------------------------------
-- Master Buswatch Instantiation (AHB)
-- -----------------------------------------------------------------------------
ubuswatchmaster : buswatchmaster
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
            HBUSREQ          => HBUSREQ,
            HGRANT           => HGRANT,
            HREADY           => HREADY,
            HLOCK            => HLOCK,
            HWDATA           => HWDATA,
            HPROT            => HPROT,
            HWRITE           => HWRITE,
            HRESP            => HRESP,
            ResetOver        => OPEN
           );
-- -----------------------------------------------------------------------------
-- Unit Under Test (EBI)
-- -----------------------------------------------------------------------------
uut : Ebi
  port map (
        EBICLK            => EBICLK,
        nPOR              => nPOR,
        EBIREQ1           => EBIREQ1,
        EBIADDR1          => EBIADDR1,
        EBIDATA1          => EBIDATA1,
        nEBIDATAEN1       => nEBIDATAEN1,
        EBITIMEOUTVALUE1  => EBITIMEOUTVALUE1,
        EBIREQ2           => EBIREQ2,
        EBIADDR2          => EBIADDR2,
        EBIDATA2          => EBIDATA2,
        nEBIDATAEN2       => nEBIDATAEN2,
        EBITIMEOUTVALUE2  => EBITIMEOUTVALUE2,
        EBIREQ3           => EBIREQ3,
        EBIADDR3          => EBIADDR3,
        EBIDATA3          => EBIDATA3,
        nEBIDATAEN3       => nEBIDATAEN3,
        EBITIMEOUTVALUE3  => EBITIMEOUTVALUE3,
        EBIEXTDATAIN      => EBIEXTDATAIN,
        SCANENABLE        => SCANENABLE,
        SCANINEBICLK      => SCANINEBICLK,
        EBIGNT1           => EBIGNT1,
        EBIBACKOFF1       => EBIBACKOFF1,
        EBIGNT2           => EBIGNT2,
        EBIBACKOFF2       => EBIBACKOFF2,
        EBIGNT3           => EBIGNT3,
        EBIBACKOFF3       => EBIBACKOFF3,
        EBIEXTDATAOUT     => EBIEXTDATAOUT,
        EBIEXTADDROUT     => EBIEXTADDROUT,
        nEBIEXTDATAEN     => nEBIEXTDATAEN,
        EBIDATAIN         => EBIDATAIN,
        SCANOUTEBICLK     => SCANOUTEBICLK
       );

-- -----------------------------------------------------------------------------
-- EBI Trickbox
-- -----------------------------------------------------------------------------
uEbiTrick : EbiTrick
  generic map (
               Tclkl            => Tclkl,
               Tclkh            => Tclkh,
               Tclks            => Tclks
              )
  port map (
        HCLK              => HCLK,
        HRESETn           => HRESETn,
        HADDR             => HADDR(11 downto 2),
        HTRANS            => HTRANS,
        HWRITE            => HWRITE,
        HSIZE             => HSIZE,
        HREADYIN          => HREADY,
        HWDATA            => HWDATA(31 downto 0),
        HSELEBITRICKBOX   => HSEL(8),
        EBIGNT1           => EBIGNT1,
        EBIGNT2           => EBIGNT2,
        EBIGNT3           => EBIGNT3,
        EBIBACKOFF1       => EBIBACKOFF1,
        EBIBACKOFF2       => EBIBACKOFF2,
        EBIBACKOFF3       => EBIBACKOFF3,
        nEBIEXTDATAEN     => nEBIEXTDATAEN,
        EBIEXTADDROUT     => EBIEXTADDROUT,
        EBIEXTDATAOUT     => EBIEXTDATAOUT,
        EBIDATAIN         => EBIDATAIN,
        EBICLK            => EBICLK,
        EBIREQ1           => EBIREQ1,
        EBIREQ2           => EBIREQ2,
        EBIREQ3           => EBIREQ3,
        nPOR              => nPOR,
        HREADYOUT         => HREADYOutEBITr,
        HRESP             => HRESPOutEBITr,
        HRDATA            => HRDATAOutEBITr(31 downto 0),
        EBIADDR1          => EBIADDR1,
        EBIADDR2          => EBIADDR2,
        EBIADDR3          => EBIADDR3,
        EBIDATA1          => EBIDATA1,
        EBIDATA2          => EBIDATA2,
        EBIDATA3          => EBIDATA3,
        nEBIDATAEN1       => nEBIDATAEN1,
        nEBIDATAEN2       => nEBIDATAEN2,
        nEBIDATAEN3       => nEBIDATAEN3,
        EBIEXTDATAIN      => EBIEXTDATAIN,
        EBITIMEOUTVALUE1  => EBITIMEOUTVALUE1,
        EBITIMEOUTVALUE2  => EBITIMEOUTVALUE2,
        EBITIMEOUTVALUE3  => EBITIMEOUTVALUE3
       );

SCANENABLE         <= '0';
SCANINEBICLK       <= '0';

end behavioural;

-- --================================ End ====================================--
