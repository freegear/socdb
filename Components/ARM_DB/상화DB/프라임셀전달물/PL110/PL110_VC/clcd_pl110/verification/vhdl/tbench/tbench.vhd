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
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose : 
--           Top level of the PL110 CLCDC Compliance TestBench
--
--           This file instantiates the CLCDC module, the CLCDC trickbox
--           the AHB decoder and the Default Slave. 
--
-- --=========================================================================--

library ieee;
use     ieee.std_logic_1164.all;
use     ieee.std_logic_arith.all;
 
library tbench;
use     tbench.timing.all;
use     tbench.timingmaster.all;

library uut;
library trickbox;
library common;

entity tbench is
end tbench;

architecture behavioural of tbench is

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------
 
constant ORBUS : std_logic := '0';
-- If this bit is set, then testbench will have a OR bus configuration
-- Else, by default, it will be a MUX implementation
 
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

component ahbslave_tb
generic(
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
  port(
       HREADY        : in  std_logic;
       HRDATA        : in  std_logic_vector(63 downto 0);
       HRESP         : in  std_logic_vector(1 downto 0);
       HSPLIT        : in  std_logic_vector(15 downto 0);
       VRG0          : inout std_logic_vector(31 downto 0);
       VRG1          : inout std_logic_vector(31 downto 0);
       VRG2          : inout std_logic_vector(31 downto 0);
       VRG3          : inout std_logic_vector(31 downto 0);
       VRG4          : inout std_logic_vector(31 downto 0);
       VRG5          : inout std_logic_vector(31 downto 0);
       VRG6          : inout std_logic_vector(31 downto 0);
       VRG7          : inout std_logic_vector(31 downto 0);
       HCLK          : out std_ulogic;
       HRESETn       : out std_ulogic;
       HADDR         : out std_logic_vector(31 downto 0);
       HTRANS        : out std_logic_vector(1 downto 0);
       HMASTER       : out std_logic_vector(3 downto 0);
       HMASTLOCK     : out std_logic;
       HWRITE        : out std_logic;
       HSIZE         : out std_logic_vector(2 downto 0);
       HBURST        : out std_logic_vector(2 downto 0);
       HPROT         : out std_logic_vector(3 downto 0);
       HWDATA        : out std_logic_vector(63 downto 0)
      );
end  component;

-- -----------------------------------------------------------------------------
-- Address Decoder
-- -----------------------------------------------------------------------------
component decoder
  port(
       HADDR        : in    std_logic_vector(31 downto 0);
       HSEL         : out   std_logic_vector(15 downto 0);
       DefSlaveSel  : out   std_logic
      );
end  component;
 
-- -----------------------------------------------------------------------------
-- UUT (CLCDC) 
-- -----------------------------------------------------------------------------

component Clcd
port   (
       -- AHB BUS(Slave Interface)
       HCLK            : in    std_ulogic;
       HRESETn         : in    std_ulogic;
       HADDRS          : in    std_logic_vector(11 downto 2);
       HTRANSS         : in    std_logic_vector(1 downto 0);
       HWRITES         : in    std_logic;
       HREADYINS       : in    std_logic;
       HREADYOUTS      : out   std_logic;
       HRESPS          : out   std_logic_vector(1 downto 0);
       HWDATAS         : in    std_logic_vector(31 downto 0);
       HRDATAS         : out   std_logic_vector(31 downto 0);
       HSELCLCD        : in    std_logic;
 
       -- AHB BUS(Master Interface)
       HADDRM          : out   std_logic_vector(31 downto 0);
       HTRANSM         : out   std_logic_vector(1 downto 0);
       HWRITEM         : out   std_logic;
       HSIZEM          : out   std_logic_vector(2 downto 0);
       HBURSTM         : out   std_logic_vector(2 downto 0);
       HREADYINM       : in    std_logic;
       HRESPM          : in    std_logic_vector(1 downto 0);
       HRDATAM         : in    std_logic_vector(31 downto 0);
       HPROT           : out   std_logic_vector(3 downto 0);
       HLOCK           : out   std_logic;
       HBUSREQM        : out   std_logic;
       HGRANTM         : in    std_logic;
 
       -- LCD Panel
       CLPOWER         : out   std_logic;
       CLLP            : out   std_logic;
       CLCP            : out   std_logic;
       CLFP            : out   std_logic;
       CLAC            : out   std_logic;
       CLD             : out   std_logic_vector(23 downto 0);
       CLLE            : out   std_logic;
 
       -- Clock source
       CLCDCLK         : in    std_logic;
       nCLCDCLK        : in    std_logic;
       CLCDCLKSEL      : out   std_logic;
       nCLCLKRESET     : in    std_logic;
       
       --Scan interface
       SCANENABLE      : in  std_logic;
       SCANINHCLK      : in  std_logic;
       SCANINCLCDCLK   : in  std_logic;
       SCANINnCLCDCLK  : in  std_logic;
       SCANOUTHCLK     : out std_logic;
       SCANOUTCLCDCLK  : out std_logic;
   
       -- Interrupts
       CLCDMBEINTR     : out   std_logic;
       CLCDFUFINTR     : out   std_logic;
       CLCDLNBUINTR    : out   std_logic;
       CLCDVCOMPINTR   : out   std_logic;
       CLCDINTR        : out   std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- CLCDC Trickbox
-- -----------------------------------------------------------------------------
component CLTrick
  port(
       HCLK            : in    std_ulogic;
       HRESETN         : in    std_ulogic;
 
       -- Bus Slave AHB Signals
       HSELB           : in    std_logic;
       HSELCom         : in    std_logic;
       HADDRB          : in    std_logic_vector(9 downto 2);
       HTRANSB         : in    std_logic_vector(1 downto 0);
       HWRITEB         : in    std_logic;
       HSIZEB          : in    std_logic_vector(2 downto 0);
       HBURSTB         : in    std_logic_vector(2 downto 0);
       HWDATAB         : in    std_logic_vector(31 downto 0);
       HREADYBIn       : in    std_logic;
       HRDATAB         : out   std_logic_vector(31 downto 0);
       HREADYBOut      : out   std_logic;
       HRESPB          : out   std_logic_vector(1 downto 0);
 
       -- CLCD AHB Signals
       HADDRC          : in    std_logic_vector(31 downto 0);
       HTRANSC         : in    std_logic_vector(1 downto 0);
       HWRITEC         : in    std_logic;
       HSIZEC          : in    std_logic_vector(2 downto 0);
       HBURSTC         : in    std_logic_vector(2 downto 0);
       HPROTC          : in    std_logic_vector(3 downto 0);
       HLOCKC          : in    std_logic;
       HBUSREQC        : in    std_logic;
       HRDATAC         : out   std_logic_vector(31 downto 0);
       HRESPC          : out   std_logic_vector(1 downto 0);
       HREADYC         : out   std_logic;
       HGRANTC         : out   std_logic;
 
       -- CLCD Panel Signals
       LCDCLK          : out   std_logic;
       CLCLKSEL        : in    std_logic;
       CLPOWER         : in    std_logic;
       CLFP            : in    std_logic;
       CLLP            : in    std_logic;
       CLCP            : in    std_logic;
       CLAC            : in    std_logic;
       CLD             : in    std_logic_vector(23 downto 0);
       CLLE            : in    std_logic;
 
       -- Interrupt Signals
       BEINTTR         : in    std_logic;
       FUFINTR         : in    std_logic;
       LNBUINTR        : in    std_logic;
       VCOMPINTR       : in    std_logic;
       INTR            : in    std_logic
       );
end component;


-- -----------------------------------------------------------------------------
-- Default Slave
-- -----------------------------------------------------------------------------
component Defslave
  port(
       HCLK        : in     std_logic;
       HRESETn     : in     std_logic;
       HSEL        : in     std_logic;
       HTRANS      : in     std_logic;
       HRESP       : out    std_logic_vector(1 downto 0);
       HREADYIn    : in     std_logic;
       HREADYOut   : out    std_logic;
       HRDATAOut   : out    std_logic_vector(63 downto 0) 
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
        HCLK      : in std_logic;
        HRESETn   : in std_logic;
        HTRANS    : in std_logic_vector(1 downto 0);
        HADDR     : in std_logic_vector(31 downto 0);
        HSIZE     : in std_logic_vector(2 downto 0);
        HBURST    : in std_logic_vector(2 downto 0);
        HBUSREQx  : in std_logic;
        HGRANTx   : in std_logic;
        HREADY    : in std_logic;
        HLOCKx    : in std_logic;
        HWDATA    : in std_logic_vector(63 downto 0);
        HPROT     : in std_logic_vector(3 downto 0);
        HWRITE    : in std_logic;
        HRESP     : in std_logic_vector(1 downto 0);
        ResetOver : out boolean
       );
end component;

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- AHB signals.
-- -----------------------------------------------------------------------------
signal HCLK           : std_ulogic;
signal HRESETn        : std_ulogic;
signal HADDR          : std_logic_vector(31 downto 0); 
signal HRDATA         : std_logic_vector(63 downto 0);
signal HWDATA         : std_logic_vector(63 downto 0);
signal HSEL           : std_logic_vector(15 downto 0);
signal HMASTLOCK      : std_logic;
signal HWRITE         : std_logic;
signal HSIZE          : std_logic_vector(2 downto 0);
signal HBURST         : std_logic_vector(2 downto 0);
signal HPROT          : std_logic_vector(3 downto 0);
signal HTRANS         : std_logic_vector(1 downto 0);
signal HRESP          : std_logic_vector(1 downto 0);
signal HREADY         : std_logic;
signal HSPLITIn       : std_logic_vector(15 downto 0) := (others => '0');
signal HMASTER        : std_logic_vector(3 downto 0);

-- -----------------------------------------------------------------------------
-- Virtual registers
-- -----------------------------------------------------------------------------
signal VRG0             : std_logic_vector(31 downto 0);
signal VRG1             : std_logic_vector(31 downto 0);
signal VRG2             : std_logic_vector(31 downto 0);
signal VRG3             : std_logic_vector(31 downto 0);
signal VRG4             : std_logic_vector(31 downto 0);
signal VRG5             : std_logic_vector(31 downto 0);
signal VRG6             : std_logic_vector(31 downto 0);
signal VRG7             : std_logic_vector(31 downto 0);
signal HSPLITOut        : std_logic_vector(15 downto 0);

-- -----------------------------------------------------------------------------
-- Clcd response signals
-- -----------------------------------------------------------------------------
signal HREADYOutClcd    : std_logic;
signal HRDATAOutClcd    : std_logic_vector(31 downto 0);
signal HRESPOutClcd     : std_logic_vector(1 downto 0);

-- -----------------------------------------------------------------------------
-- Clcd trickbox response signals
-- -----------------------------------------------------------------------------
signal HREADYOutClcdTr  : std_logic;
signal HRDATAOutClcdTr  : std_logic_vector(31 downto 0);
signal HRESPOutClcdTr   : std_logic_vector(1 downto 0);

-- -----------------------------------------------------------------------------
-- Default slave signals
-- -----------------------------------------------------------------------------
signal HREADYOutDef     : std_logic;
signal HRDATAOutDef     : std_logic_vector(63 downto 0);
signal HRESPOutDef      : std_logic_vector(1 downto 0);
signal DefSlaveSel      : std_logic;
signal DelHSEL          : std_logic_vector(15 downto 0);
signal DelDefSel        : std_logic;

-- -----------------------------------------------------------------------------
-- MUX bus signals
-- -----------------------------------------------------------------------------
signal HREADYMUX        : std_logic;
signal HRDATAMUX        : std_logic_vector(63 downto 0);
signal HRESPMUX         : std_logic_vector(1 downto 0);

-- -----------------------------------------------------------------------------
-- OR bus signals
-- -----------------------------------------------------------------------------
signal HREADYOR         : std_logic;
signal HRDATAOR         : std_logic_vector(63 downto 0);
signal HRESPOR          : std_logic_vector(1 downto 0);

-- -----------------------------------------------------------------------------
-- Scan ports of Clcd
-- -----------------------------------------------------------------------------
signal SCANENABLE       : std_logic;
signal SCANINHCLK       : std_logic;
signal SCANINCLCDCLK    : std_logic;
signal SCANINnCLCDCLK   : std_logic;
signal SCANOUTHCLK      : std_logic;
signal SCANOUTCLCDCLK   : std_logic;

-- -----------------------------------------------------------------------------
-- Clcd Master Port
-- -----------------------------------------------------------------------------
signal HADDRM           : std_logic_vector(31 downto 0);
signal HTRANSM          : std_logic_vector(1 downto 0);
signal HRESPM           : std_logic_vector(1 downto 0);
signal HWRITEM          : std_logic;
signal HSIZEM           : std_logic_vector(2 downto 0); 
signal HBURSTM          : std_logic_vector(2 downto 0);
signal HRDATAM          : std_logic_vector(31 downto 0);
signal HPROTM           : std_logic_vector(3 downto 0);
signal HLOCKM           : std_logic;
signal HBUSREQM         : std_logic;
signal HREADYINM        : std_logic;
signal HGRANTM          : std_logic;
signal HWDATATrCl       : std_logic_vector(63 downto 0);

-- -----------------------------------------------------------------------------
-- Clcd Non-Amba Ports
-------------------------------------------------------------------------------
signal CLPOWER          : std_logic;
signal CLLP             : std_logic;
signal CLAC             : std_logic;
signal CLCP             : std_logic;
signal CLFP             : std_logic;
signal CLLE             : std_logic;
signal CLCDCLK          : std_logic;
signal CLD              : std_logic_vector(23 downto 0);
signal CLCDCLKSEL       : std_logic;
signal CLCDMBEINTR      : std_logic;
signal CLCDFUFINTR      : std_logic;
signal CLCDLNBUINTR     : std_logic;
signal CLCDVCOMPINTR    : std_logic;
signal CLCDINTR         : std_logic;
signal nCLCDCLK         : std_logic;

-- -----------------------------------------------------------------------------
-- Logic 0 tie offs
-------------------------------------------------------------------------------
signal ZERO             : std_logic;
signal ZERO64           : std_logic_vector(63 downto 0);

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

ZERO           <= '0';
ZERO64         <= (others => '0');
SCANENABLE     <= '0';
SCANINHCLK     <= '0';
SCANINCLCDCLK  <= '0';
SCANINnCLCDCLK <= '0';

-- assigning non X values to HWDATATrCl so that BusWatcher does not flash error
  HWDATATrCl <= ZERO64;

  HREADY <= HREADYOR when (ORBUS = '1')
         else
            HREADYMUX;
  HRESP  <= HRESPOR when (ORBUS = '1')
           else
            HRESPMUX;
  HRDATA <= HRDATAOR when (ORBUS = '1')
         else
            HRDATAMUX;
-- ----------------------------------------------------------------------------
-- For MUX-bus implementations
-- ----------------------------------------------------------------------------
 
  HREADYMUX <= HREADYOutClcd  when (DelHSEL(0) = '1')
            else
               HREADYOutClcdTr  when (DelHSEL(1) = '1') 
            else
               HREADYOutDef  when DelDefSel = '1'
            else
               '0';
 
  HRESPMUX  <= HRESPOutClcd when (DelHSEL(0) = '1')
            else
               HRESPOutClcdTr when (DelHSEL(1) = '1') 
            else
               HRESPOutDef  when DelDefSel = '1'
            else
               "00";
  HRDATAMUX <= to_stdlogicvector(X"00000000") & HRDATAOutClcd
                 when (DelHSEL(0) = '1')
            else
               to_stdlogicvector(X"00000000") & HRDATAOutClcdTr
                 when (DelHSEL(1) = '1')
            else
               HRDATAOutDef
                 when DelDefSel = '1'
            else
               to_stdlogicvector(X"0000000000000000");
-- ----------------------------------------------------------------------------
-- For OR bus implementations
-- ----------------------------------------------------------------------------
  HRESPOR  <= HRESPOutClcd or HRESPOutClcdTr or HRESPOutDef;
 
  HREADYOR <= HREADYOutClcd or HREADYOutClcdTr or HREADYOutDef;
 
  HRDATAOR <= to_stdlogicvector(X"00000000") & HRDATAOutClcd or 
              to_stdlogicvector(X"00000000") &  HRDATAOutClcdTr or
              HRDATAOutDef;
 
-- ----------------------------------------------------------------------------
-- For generating the inverted clock 
-- ----------------------------------------------------------------------------
  
  nCLCDCLK <= not HCLK;

-- ----------------------------------------------------------------------------
-- Latching HSEL
-- ----------------------------------------------------------------------------
p_HSELSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    DelHSEL <= (others => '0');
    DelDefSel <= '1';
  elsif (HCLK'event and HCLK = '1' and HREADY = '1') then
    DelHSEL <= HSEL;
    DelDefSel <= DefSlaveSel;
  end if;
end process p_HSELSeq;


-------------------------------------------------------------------------------

u_ahbslv_tb : ahbslave_tb
generic map(
	    INFILE                 => "../../bustest/invec/infile.bif",
            Verbosity              => 0,
            HaltOnMismatch         => 0,
            XonSig                 => 0,
            tclks                  => Tclks,
            tclkl                  => Tclkl,
            tclkh                  => Tclkh,
            Databuswidth           => 32,
            ahbslave_tb_TimingFile => ""
	   )
port map(
         HCLK         => HCLK, 
         HRESETn      => HRESETn, 
         HADDR        => HADDR, 
         HTRANS       => HTRANS, 
         HWRITE       => HWRITE, 
         HSIZE        => HSIZE, 
         HBURST       => HBURST, 
         HPROT        => HPROT, 
         HMASTER      => HMASTER,
         HMASTLOCK    => HMASTLOCK,
         HWDATA       => HWDATA,
         HSPLIT       => HSPLITIn, 
         HRDATA       => HRDATA, 
         HREADY       => HREADY, 
         HRESP        => HRESP
        );

u_decoder : decoder
port map(
         HADDR       => HADDR,
         HSEL        => HSEL,
         DefSlaveSel => DefSlaveSel
        );
 
uut : Clcd
port map(
          -- AHB BUS(Slave Interface)
          HCLK           => HCLK,
          HRESETn        => HRESETn,
          HADDRS         => HADDR(11 downto 2),
          HTRANSS        => HTRANS,
          HWRITES        => HWRITE,
          HREADYINS      => HREADY,
          HREADYOUTS     => HREADYOutClcd,
          HRESPS         => HRESPOutClcd,
          HWDATAS        => HWDATA(31 downto 0),
          HRDATAS        => HRDATAOutClcd,
          HSELCLCD       => HSEL(0),
 
          -- AHB BUS(Master Interface)
          HADDRM         => HADDRM,
          HTRANSM        => HTRANSM,
          HWRITEM        => HWRITEM,
          HSIZEM         => HSIZEM,
          HBURSTM        => HBURSTM,
          HREADYINM      => HREADYINM,
          HRESPM         => HRESPM,
          HRDATAM        => HRDATAM(31 downto 0),
          HPROT          => HPROTM,
          HLOCK          => HLOCKM,
          HBUSREQM       => HBUSREQM,
          HGRANTM        => HGRANTM,
 
          -- LCD Panel
          CLPOWER        => CLPOWER,
          CLLP           => CLLP,
          CLCP           => CLCP,
          CLFP           => CLFP,
          CLAC           => CLAC,
          CLD            => CLD,
          CLLE           => CLLE,
 
          -- Clock source
          CLCDCLK        => HCLK,
          nCLCDCLK       => nCLCDCLK,
          CLCDCLKSEL     => CLCDCLKSEL,
          nCLCLKRESET    => HRESETn,

          -- Scan interface
          SCANENABLE     => SCANENABLE,
          SCANINHCLK     => SCANINHCLK,
          SCANINCLCDCLK  => SCANINCLCDCLK,
          SCANINnCLCDCLK => SCANINnCLCDCLK,
          SCANOUTHCLK    => SCANOUTHCLK,
          SCANOUTCLCDCLK => SCANOUTCLCDCLK,

          -- Interrupts
          CLCDMBEINTR    => CLCDMBEINTR,
          CLCDFUFINTR    => CLCDFUFINTR,
          CLCDLNBUINTR   => CLCDLNBUINTR,
          CLCDVCOMPINTR  => CLCDVCOMPINTR,
          CLCDINTR       => CLCDINTR
        );

u_CLTrick : CLTrick
port map(
          HCLK       => HCLK,
          HRESETN    => HRESETn,
 
          HSELB      => HSEL(1),
          HSELCom    => HSEL(0),
          HADDRB     => HADDR(9 downto 2),
          HTRANSB    => HTRANS,
          HWRITEB    => HWRITE,
          HSIZEB     => HSIZE,
          HBURSTB    => HBURST,
          HWDATAB    => HWDATA(31 downto 0),
          HRDATAB    => HRDATAOutClcdTr,
          HREADYBIn  => HREADY,
          HREADYBOut => HREADYOutClcdTr,
          HRESPB     => HRESPOutClcdTr,
 
          HADDRC     => HADDRM,
          HTRANSC    => HTRANSM,
          HWRITEC    => HWRITEM,
          HSIZEC     => HSIZEM,
          HBURSTC    => HBURSTM,
          HRDATAC    => HRDATAM,
          HPROTC     => HPROTM,
          HLOCKC     => HLOCKM,
          HBUSREQC   => HBUSREQM,
 
          HREADYC    => HREADYINM,
          HRESPC     => HRESPM,
          HGRANTC    => HGRANTM,

          LCDCLK     => CLCDCLK,
          CLCLKSEL   => CLCDCLKSEL,
          CLPOWER    => CLPOWER,
          CLFP       => CLFP,
          CLLP       => CLLP,
          CLCP       => CLCP,
          CLAC       => CLAC,
          CLD        => CLD,
          CLLE       => CLLE,
 
          BEINTTR    => CLCDMBEINTR,
          FUFINTR    => CLCDFUFINTR,
          LNBUINTR   => CLCDLNBUINTR,
          VCOMPINTR  => CLCDVCOMPINTR,
          INTR       => CLCDINTR
         );


 u_Defslave : Defslave
 port map(
          HCLK      => HCLK,
          HSEL      => DelDefSel,
          HRESETn   => HRESETn,
          HTRANS    => HTRANS(1),
          HRESP     => HRESPOutDef,
          HREADYIn  => HREADY,
          HREADYOut => HREADYOutDef,
          HRDATAOut => HRDATAOutDef
         );


u_buswatchmaster : buswatchmaster
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
            HCLK      => HCLK,
            HRESETn   => HRESETn,
            HTRANS    => HTRANSM,
            HADDR     => HADDRM,
            HSIZE     => HSIZEM,
            HBURST    => HBURSTM,
            HBUSREQx  => HBUSREQM,
            HGRANTx   => HGRANTM,
            HREADY    => HREADYINM,
            HLOCKx    => HLOCKM,
            HWDATA    => HWDATATrCl,
            HPROT     => HPROTM,
            HWRITE    => HWRITEM,
            HRESP     => HRESPM
           );

end behavioural;

-- ================================== End =================================== --
