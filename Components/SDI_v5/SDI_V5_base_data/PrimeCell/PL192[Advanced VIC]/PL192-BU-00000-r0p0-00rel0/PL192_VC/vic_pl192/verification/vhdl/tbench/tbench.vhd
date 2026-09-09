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
-- File Name              : tbench.vhd.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose : 
--           Top level of the VIC Compliance TestBench
--
--           This file instantiates the VIC module, the VIC trickbox
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

entity tbench is
end tbench;

-- ================================ ARCHITECTURE ============================ --

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
           Tclks                  : time;
           Tclkl                  : time;
           Tclkh                  : time;
           Databuswidth           : integer;
           ahbslave_tb_TimingFile : string
	  );
  port (
        HREADY           : in    std_logic;
        HRDATA           : in    std_logic_vector(63 downto 0);
        HRESP            : in    std_logic_vector(1 downto 0);
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
        HMASTER          : out   std_logic_vector(3 downto 0);
        HMASTLOCK        : out   std_logic;
        HWRITE           : out   std_logic;
        HSIZE            : out   std_logic_vector(2 downto 0);
        HBURST           : out   std_logic_vector(2 downto 0);
        HPROT            : out   std_logic_vector(3 downto 0);
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
-- UUT (VIC) 
-- -----------------------------------------------------------------------------
component Vic
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HSELVIC          : in    std_logic;
        HADDR            : in    std_logic_vector(11 downto 2);
        HWRITE           : in    std_logic;
        HREADYIN         : in    std_logic;
        HPROT            : in    std_logic_vector(3 downto 0);
        HTRANS           : in    std_logic_vector(1 downto 0);
        HSIZE            : in    std_logic_vector(2 downto 0);
        HWDATA           : in    std_logic_vector(31 downto 0);
        VICINTSOURCE     : in    std_logic_vector(31 downto 0);
        nVICSYNCEN       : in    std_logic;
        VICIRQACK        : in    std_logic;
        nVICFIQIN        : in    std_logic;
        nVICIRQIN        : in    std_logic;
        VICVECTADDRIN    : in    std_logic_vector(31 downto 0);
        VICFIQINREG      : in    std_logic;
        VICIRQINREG      : in    std_logic;
        SCANENABLE       : in    std_logic;
        SCANINHCLK       : in    std_logic;
        HREADYOUT        : out   std_logic;
        HRESP            : out   std_logic_vector(1 downto 0);
        HRDATA           : out   std_logic_vector(31 downto 0);
        nVICFIQ          : out   std_logic;
        nVICIRQ          : out   std_logic;
        VICVECTADDROUT   : out   std_logic_vector(31 downto 0);
        VICVECTADDRV     : out   std_logic;
        VICIRQACKOUT     : out   std_logic;
        SCANOUTHCLK      : out   std_logic
       );
  end component;

-- -----------------------------------------------------------------------------
-- VIC Trickbox
-- -----------------------------------------------------------------------------
component VicTrick
  generic (
           Tclk : time
          );
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HREADYIN         : in    std_logic;
        HADDR            : in    std_logic_vector(11 downto 2);
        HTRANS           : in    std_logic;
        HSIZE            : in    std_logic_vector(2 downto 0);
        HWRITE           : in    std_logic;
        HPROT            : in    std_logic;
        HWDATA           : in    std_logic_vector(31 downto 0);
        HSELVICTR        : in    std_logic;
        HSELVIC          : in    std_logic;
        nVICFIQ          : in    std_logic;
        nVICIRQ          : in    std_logic;
        VICVECTADDROUT   : in    std_logic_vector(31 downto 0);
        VICVECTADDRV     : in    std_logic;
        VICIRQACKOUT     : in    std_logic;
        HCLKTRICK        : out   std_logic;
        HRDATA           : out   std_logic_vector(31 downto 0);
        HREADYOUT        : out   std_logic;
        HRESP            : out   std_logic_vector(1 downto 0);
        VICINTSOURCE     : out   std_logic_vector(31 downto 0);
        VICIRQACK        : out   std_logic;
        VICSYNCEN        : out   std_logic;
        VICVECTADDRIN    : out   std_logic_vector(31 downto 0);
        nVICFIQIN        : out   std_logic;
        nVICIRQIN        : out   std_logic;
        VICFIQINREG      : out   std_logic;
        VICIRQINREG      : out   std_logic
       );
  end component;

-- -----------------------------------------------------------------------------
-- Default Slave
-- -----------------------------------------------------------------------------
component Defslave
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HSEL             : in    std_logic;
        HTRANS           : in    std_logic;
        HRESP            : out   std_logic_vector(1 downto 0);
        HREADYIn         : in    std_logic;
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
signal HCLK             : std_logic;
signal HRESETn          : std_logic;
signal HADDR            : std_logic_vector(31 downto 0); 
signal HRDATA           : std_logic_vector(63 downto 0);
signal HWDATA           : std_logic_vector(63 downto 0);
signal HSEL             : std_logic_vector(15 downto 0);
signal HMASTLOCK        : std_logic;
signal HWRITE           : std_logic;
signal HSIZE            : std_logic_vector(2 downto 0);
signal HBURST           : std_logic_vector(2 downto 0);
signal HPROT            : std_logic_vector(3 downto 0);
signal HTRANS           : std_logic_vector(1 downto 0);
signal HRESP            : std_logic_vector(1 downto 0);
signal HREADY           : std_logic;
signal HSPLIT           : std_logic_vector(15 downto 0);
signal HMASTER          : std_logic_vector(3 downto 0);
signal VRG0             : std_logic_vector(31 downto 0);
signal VRG1             : std_logic_vector(31 downto 0);
signal VRG2             : std_logic_vector(31 downto 0);
signal VRG3             : std_logic_vector(31 downto 0);
signal VRG4             : std_logic_vector(31 downto 0);
signal VRG5             : std_logic_vector(31 downto 0);
signal VRG6             : std_logic_vector(31 downto 0);
signal VRG7             : std_logic_vector(31 downto 0);
signal HSPLITOut        : std_logic_vector(15 downto 0);
signal HREADYOut0       : std_logic;
signal HREADYOut1       : std_logic;
signal HRDATAOut0       : std_logic_vector(63 downto 0);
signal HRDATAOut1       : std_logic_vector(63 downto 0);
signal iHRDATAOut0      : std_logic_vector(63 downto 0);
signal iHRDATAOut1      : std_logic_vector(63 downto 0);
signal HRESPOut0        : std_logic_vector(1 downto 0);
signal HRESPOut1        : std_logic_vector(1 downto 0);
signal HREADYOutDef     : std_logic;
signal HRDATAOutDef     : std_logic_vector(63 downto 0);
signal HRESPOutDef      : std_logic_vector(1 downto 0);
signal DelHSEL          : std_logic_vector(15 downto 0);
signal DefSlaveSel      : std_logic;
signal DelDefSel        : std_logic;
signal iHREADYMUX       : std_logic;
signal HREADYMUX        : std_logic;
signal HREADYOR         : std_logic;
signal HRESPOR          : std_logic_vector(1 downto 0);
signal HRESPMUX         : std_logic_vector(1 downto 0);
signal HRDATAMUX        : std_logic_vector(63 downto 0);
signal HRDATAOR         : std_logic_vector(63 downto 0);
signal iVRG0            : std_logic_vector(31 downto 0);
signal iVRG1            : std_logic_vector(31 downto 0);
signal iVRG2            : std_logic_vector(31 downto 0);
signal iVRG3            : std_logic_vector(31 downto 0);
signal nVICFiq          : std_logic;
signal nVICIrq          : std_logic;
signal VICVectAddrOut   : std_logic_vector(31 downto 0);
signal VICIntSource     : std_logic_vector(31 downto 0);
signal VICVectAddrIn    : std_logic_vector(31 downto 0);
signal nVICFiqIn        : std_logic;
signal nVICIrqIn        : std_logic;
signal VICSyncEn        : std_logic;
signal VICIrqAck        : std_logic;
signal VICFiqInReg      : std_logic;
signal VICIrqInReg      : std_logic;
signal VICVectAddrv     : std_logic;
signal VICIrqAckOut     : std_logic;
signal SCANENABLE       : std_logic;
signal SCANINHCLK       : std_logic;
signal SCANOUTHCLK      : std_logic;
signal HLOCK            : std_logic := '0';
signal HBUSREQ          : std_logic := '1';
signal HGRANT           : std_logic := '1';
signal HCLKTRICK        : std_logic;

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
iHRDATAOut0      <= (to_stdlogicvector(X"00000000") &
                    HRDATAOut0(31 downto 0)) when (Databuswidth = 32)
                 else
                    HRDATAOut0;

iHRDATAOut1      <= (to_stdlogicvector(X"00000000") &
                    HRDATAOut1(31 downto 0)) when (Databuswidth = 32)
                 else
                    HRDATAOut1;

-- -----------------------------------------------------------------------------
-- For MUX-bus implementations
-- -----------------------------------------------------------------------------
HREADYMUX        <= iHREADYMUX;      

iHREADYMUX       <= HREADYOut0 when (DelHSEL(0) = '1')
                 else
                    HREADYOut1 when (DelHSEL(1) = '1') 
                 else
                    HREADYOutDef when DelDefSel = '1'
                 else
                    '0';

HRESPMUX         <= HRESPOut0 when (DelHSEL(0) = '1')
                 else
                    HRESPOut1 when (DelHSEL(1) = '1') 
                 else
                    HRESPOutDef when DelDefSel = '1'
                 else
                    "00";

HRDATAMUX        <= iHRDATAOut0 when (DelHSEL(0) = '1')
                 else
                    iHRDATAOut1 when (DelHSEL(1) = '1')
                 else
                    HRDATAOutDef when DelDefSel = '1'
                 else
                    to_stdlogicvector(X"0000000000000000");

-- -----------------------------------------------------------------------------
-- For OR bus implementations
-- -----------------------------------------------------------------------------
HRESPOR          <= HRESPOut0 or HRESPOut1 or HRESPOutDef;

HREADYOR         <= HREADYOut0 or HREADYOut1 or HREADYOutDef;

HRDATAOR         <= iHRDATAOut0 or iHRDATAOut1 or HRDATAOutDef;

-- -----------------------------------------------------------------------------
-- Latching HSEL
-- -----------------------------------------------------------------------------
p_HSELSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    DelHSEL   <= (others => '0');
    DelDefSel <= '1';
  elsif (HCLK'event and HCLK = '1' and HREADY = '1') then
    DelHSEL   <= HSEL;
    DelDefSel <= DefSlaveSel;
  end if;
end process p_HSELSeq;
 
-- -----------------------------------------------------------------------------

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
-- UUT instantiation (VIC) 
-- -----------------------------------------------------------------------------
uut : Vic
  port map (
            HCLK             => HCLKTRICK,
            HRESETn          => HRESETn,
            HSELVIC          => HSEL(0),
            HADDR            => HADDR(11 downto 2),
            HWRITE           => HWRITE,
            HREADYIN         => HREADY,
            HPROT            => HPROT,
            HTRANS           => HTRANS,
            HSIZE            => HSIZE,
            HWDATA           => HWDATA(31 downto 0),
            VICINTSOURCE     => VICIntSource,
            nVICSYNCEN       => VICSyncEn,
            VICIRQACK        => VICIrqAck,
            nVICFIQIN        => nVICFiqIn,
            nVICIRQIN        => nVICIrqIn,
            VICVECTADDRIN    => VICVectAddrIn,
            VICFIQINREG      => VICFiqInReg,
            VICIRQINREG      => VICIrqInReg,
            SCANENABLE       => SCANENABLE,
            SCANINHCLK       => SCANINHCLK,
            HREADYOUT        => HREADYOut0,
            HRESP            => HRESPOut0,
            HRDATA           => HRDATAOut0(31 downto 0),
            nVICFIQ          => nVICFiq,
            nVICIRQ          => nVICIrq,
            VICVECTADDROUT   => VICVectAddrOut,
            VICVECTADDRV     => VICVectAddrv,
            VICIRQACKOUT     => VICIrqAckOut,
            SCANOUTHCLK      => SCANOUTHCLK
            );

-- -----------------------------------------------------------------------------
-- VIC Trickbox Instantiation
-- -----------------------------------------------------------------------------
uVicTrick : VicTrick
  generic map (
               Tclk => Tclk
              )
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HREADYIN         => HREADY,
            HADDR            => HADDR(11 downto 2),
            HTRANS           => HTRANS(1),
            HSIZE            => HSIZE,
            HWRITE           => HWRITE,
            HPROT            => HPROT(1),
            HWDATA           => HWDATA(31 downto 0),
            HSELVICTR        => HSEL(1),
            HSELVIC          => HSEL(0),
            nVICFIQ          => nVICFiq,
            nVICIRQ          => nVICIrq,
            VICVECTADDROUT   => VICVectAddrOut,
            VICVECTADDRV     => VICVectAddrv,
            VICIRQACKOUT     => VICIrqAckOut,
            HCLKTRICK        => HCLKTRICK,
            HRDATA           => HRDATAOut1(31 downto 0),
            HREADYOUT        => HREADYOut1,
            HRESP            => HRESPOut1,
            VICINTSOURCE     => VICIntSource,
            VICSYNCEN        => VICSyncEn,
            VICIRQACK        => VICIrqAck,
            VICVECTADDRIN    => VICVectAddrIn,
            nVICFIQIN        => nVICFiqIn,
            nVICIRQIN        => nVICIrqIn,
            VICFIQINREG      => VICFiqInReg,
            VICIRQINREG      => VICIrqInReg
           );

-- -----------------------------------------------------------------------------
-- Default Slave Instantiation
-- -----------------------------------------------------------------------------
uDefslave : Defslave
  port map (
            HCLK             => HCLK,
            HSEL             => DelDefSel,
            HRESETn          => HRESETn,
            HTRANS           => HTRANS(1),
            HRESP            => HRESPOutDef,
            HREADYIn         => HREADY,
            HREADYOut        => HREADYOutDef,
            HRDATAOut        => HRDATAOutDef
           );

-- -----------------------------------------------------------------------------
-- Master Buswatch Instantiation
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

end behavioural;

--================================== End =====================================--
