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
-- File Name              : tbench5.vhd.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose : 
--           Top level of the MPMC Compliance TestBench
--
--           This file instantiates the MPMC module, the MPMC trickbox
--           the AHB decoder and the Default Slave. 
--           Details of Denali models connected :
--     CS        Part               Vendor  Size    SOMA
--     DYCS[0] : K4S561632A-75      Samsung 16Mx32  (k4s561632a_75.soma x 2)
--     DYCS[1] : MT48LC32M16A2-75   Micron  32Mx32  (mt48lc32m16a2_75.soma x 2)
--     DYCS[2] : MT48LC1M16A1_6S    Micron  1Mx16   (mt48lc1m16a1_6s.soma)
--     DYCS[3] : MT28S4M16LC-12     Micron  4Mx16   (mt28s4m16lc_12.soma)
--
--     STCS[0] : K6R1016V1C-15      Samsung 64Kx16  (k6r1016v1c_15.soma)
--     STCS[1] : INT28F800F3B95     Intel   128Kx16 (Int28f800f3b95.soma)
--     STCS[2] : K3P9VU1000M        Samsung 8Mx16   (k3n9vu1000m.soma)
--     STCS[3] : 28F800F3B115-AUTO  Intel   128Mx16 (Int28f800f3b115.soma)
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
use trickbox.MpmcTrPackage.all;

entity tbench5 is
end tbench5;

-- --============================== ARCHITECTURE =============================--

architecture behavioural of tbench5 is

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------
constant ORBUS        : std_logic := '0';
-- If this bit is set, the testbench will have an OR bus configuration
-- Else, by default, it will be a MUX implementation.

constant Databuswidth : integer := 32;
-- Databus width of the Slave 
-- -----------------------------------------------------------------------------
-- FBCLK generation
-- Feedback clk is used to sample the data. Each memory has its own trc value
-- after which data becomes stable. During command delay mode, to sample the
-- data at the proper time, FBCLK clocks are made tbench dependent.
-- -----------------------------------------------------------------------------
constant MPMCCLKOUT_TO_MPMCFBCLKIN0_DELAY : time := 3 ns;
constant MPMCCLKOUT_TO_MPMCFBCLKIN1_DELAY : time := 3 ns;
constant MPMCCLKOUT_TO_MPMCFBCLKIN2_DELAY : time := 3 ns;
constant MPMCCLKOUT_TO_MPMCFBCLKIN3_DELAY : time := 3 ns;
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
-- UUT (MPMC) 
-- -----------------------------------------------------------------------------
component Mpmc
  port (
        HCLK             : in    std_logic;
        MPMCCLK          : in    std_logic;
        MPMCCLKDELAY     : in    std_logic;
        HRESETn          : in    std_logic;
        nPOR             : in    std_logic;
        MPMCFBCLKIN0     : in    std_logic;
        MPMCFBCLKIN1     : in    std_logic;
        MPMCFBCLKIN2     : in    std_logic;
        MPMCFBCLKIN3     : in    std_logic;
        HWRITE0          : in    std_logic;
        HTRANS0          : in    std_logic_vector(1 downto 0);
        HSIZE0           : in    std_logic_vector(2 downto 0);
        HBURST0          : in    std_logic_vector(2 downto 0);
        HREADYIN0        : in    std_logic;
        HSELMPMC0G       : in    std_logic;
        HSELMPMC0CS      : in    std_logic_vector(7 downto 0);
        HMASTLOCK0       : in    std_logic;
        HADDR0           : in    std_logic_vector(27 downto 0);
        HWDATA0          : in    std_logic_vector(31 downto 0);
        HWRITE1          : in    std_logic;
        HTRANS1          : in    std_logic_vector(1 downto 0);
        HSIZE1           : in    std_logic_vector(2 downto 0);
        HBURST1          : in    std_logic_vector(2 downto 0);
        HREADYIN1        : in    std_logic;
        HSELMPMC1G       : in    std_logic;
        HSELMPMC1CS      : in    std_logic_vector(7 downto 0);
        HMASTLOCK1       : in    std_logic;
        HADDR1           : in    std_logic_vector(27 downto 0);
        HWDATA1          : in    std_logic_vector(31 downto 0);
        HWRITE2          : in    std_logic;
        HTRANS2          : in    std_logic_vector(1 downto 0);
        HSIZE2           : in    std_logic_vector(2 downto 0);
        HBURST2          : in    std_logic_vector(2 downto 0);
        HREADYIN2        : in    std_logic;
        HSELMPMC2G       : in    std_logic;
        HSELMPMC2CS      : in    std_logic_vector(7 downto 0);
        HMASTLOCK2       : in    std_logic;
        HADDR2           : in    std_logic_vector(27 downto 0);
        HWDATA2          : in    std_logic_vector(31 downto 0);
        HWRITE3          : in    std_logic;
        HTRANS3          : in    std_logic_vector(1 downto 0);
        HSIZE3           : in    std_logic_vector(2 downto 0);
        HBURST3          : in    std_logic_vector(2 downto 0);
        HREADYIN3        : in    std_logic;
        HSELMPMC3G       : in    std_logic;
        HSELMPMC3CS      : in    std_logic_vector(7 downto 0);
        HMASTLOCK3       : in    std_logic;
        HADDR3           : in    std_logic_vector(27 downto 0);
        HWDATA3          : in    std_logic_vector(31 downto 0);
        HWRITEREG        : in    std_logic;
        HTRANSREG        : in    std_logic;
        HSIZEREG         : in    std_logic_vector(2 downto 0);
        HREADYINREG      : in    std_logic;
        HSELMPMCREG      : in    std_logic;
        HADDRREG         : in    std_logic_vector(11 downto 2);
        HWDATAREG15TO0   : in    std_logic_vector(15 downto 0);
        HWDATAREG20TO19  : in    std_logic_vector(20 downto 19);
        HRDATATIC        : in    std_logic_vector(31 downto 0);
        HREADYINTIC      : in    std_logic;
        HGRANTTIC        : in    std_logic;
        HRESPTIC         : in    std_logic_vector(1 downto 0);
        MPMCTESTIN       : in    std_logic;
        MPMCDATAIN       : in    std_logic_vector(31 downto 0);
        MPMCSREFREQ      : in    std_logic;
        MPMCBIGENDIAN    : in    std_logic;
        MPMCSTCS1MW      : in    std_logic_vector(1 downto 0);
        MPMCSTCS0POL     : in    std_logic;
        MPMCSTCS1POL     : in    std_logic;
        MPMCSTCS2POL     : in    std_logic;
        MPMCSTCS3POL     : in    std_logic;
        MPMCSTCS1PB      : in    std_logic;
        MPMCREL1CONFIG   : in    std_logic;
        MPMCTESTREQA     : in    std_logic;
        MPMCTESTREQB     : in    std_logic;
        SCANINHCLK       : in    std_logic;
        SCANINMPMCCLK    : in    std_logic;
        SCANINCLKDELAY   : in    std_logic;
        SCANINFBCLKIN0   : in    std_logic;
        SCANINFBCLKIN1   : in    std_logic;
        SCANINFBCLKIN2   : in    std_logic;
        SCANINFBCLKIN3   : in    std_logic;
        SCANENABLE       : in    std_logic;

        HREADYOUT0       : out   std_logic;
        HRESP0           : out   std_logic_vector(1 downto 0);
        HRDATA0          : out   std_logic_vector(31 downto 0);
        HREADYOUT1       : out   std_logic;
        HRESP1           : out   std_logic_vector(1 downto 0);
        HRDATA1          : out   std_logic_vector(31 downto 0);
        HREADYOUT2       : out   std_logic;
        HRESP2           : out   std_logic_vector(1 downto 0);
        HRDATA2          : out   std_logic_vector(31 downto 0);
        HREADYOUT3       : out   std_logic;
        HRESP3           : out   std_logic_vector(1 downto 0);
        HRDATA3          : out   std_logic_vector(31 downto 0);
        HREADYOUTREG     : out   std_logic;
        HRESPREG         : out   std_logic_vector(1 downto 0);
        HRDATAREG        : out   std_logic_vector(20 downto 0);
        HWRITETIC        : out   std_logic;
        HTRANSTIC        : out   std_logic_vector(1 downto 0);
        HSIZETIC         : out   std_logic_vector(2 downto 0);
        HBURSTTIC        : out   std_logic_vector(2 downto 0);
        HLOCKTIC         : out   std_logic;
        HPROTTIC         : out   std_logic_vector(3 downto 0);
        HBUSREQTIC       : out   std_logic;
        HADDRTIC         : out   std_logic_vector(31 downto 0);
        HWDATATIC        : out   std_logic_vector(31 downto 0);
        MPMCCLKOUT       : out   std_logic_vector(3 downto 0);
        MPMCCKEOUT       : out   std_logic_vector(3 downto 0);
        MPMCDQMOUT       : out   std_logic_vector(3 downto 0);
        nMPMCBLSOUT      : out   std_logic_vector(3 downto 0);
        nMPMCRASOUT      : out   std_logic;
        nMPMCCASOUT      : out   std_logic;
        nMPMCOEOUT       : out   std_logic;
        nMPMCWEOUT       : out   std_logic;
        nMPMCSTCSOUT     : out   std_logic_vector(3 downto 0);
        nMPMCDYCSOUT     : out   std_logic_vector(3 downto 0);
        MPMCADDROUT      : out   std_logic_vector(27 downto 0);
        MPMCDATAOUT      : out   std_logic_vector(31 downto 0);
        nMPMCRPOUT       : out   std_logic;
        MPMCRPVHHOUT     : out   std_logic;
        nMPMCDATAEN      : out   std_logic_vector(3 downto 0);
        MPMCSREFACK      : out   std_logic;
        MPMCEBIREQ       : out   std_logic;
        MPMCEBIGNT       : in   std_logic;
        MPMCEBIBACKOFF   : in   std_logic;
        SCANOUTHCLK      : out   std_logic;
        SCANOUTMPMCCLK   : out   std_logic;
        SCANOUTCLKDELAY  : out   std_logic;
        SCANOUTFBCLKIN0  : out   std_logic;
        SCANOUTFBCLKIN1  : out   std_logic;
        SCANOUTFBCLKIN2  : out   std_logic;
        SCANOUTFBCLKIN3  : out   std_logic
       );
end component;

component BWMonitor
  port (
         CLK       : in std_logic;
         nCS       : in std_logic_vector(3 downto 0);
         nRAS      : in std_logic;
         nCAS      : in std_logic;
         nWE       : in std_logic;
         DQM       : in std_logic_vector(3 downto 0);
         Addr      : in std_logic_vector(27 downto 0)
       );
end component;

component LatencyMonitor
generic(
    ID : string := "AHBx"      -- AHB identity tag
    );

  port (
         HCLK       : in  std_logic;
         HRESETn    : in  std_logic;
         HWRITE     : in  std_logic;
         HTRANS     : in  std_logic_vector(1 downto 0);
         HSIZE      : in  std_logic_vector(2 downto 0);
         HBURST     : in  std_logic_vector(2 downto 0);
         HSEL       : in  std_logic; --  select line
         HMASTLOCK  : in  std_logic;
         HADDR      : in  std_logic_vector(31 downto 0);
         HWDATA     : in  std_logic_vector(31 downto 0);
         HREADY     : in  std_logic
       );
end component;
-- -----------------------------------------------------------------------------
-- MPMC Trickbox
-- -----------------------------------------------------------------------------
component MpmcTrick
  generic (
           Tclkl            : time;
           Tclkh            : time;
           Tclks            : time
          );
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HADDR0           : in    std_logic_vector(11 downto 2);
        HADDR1           : in    std_logic_vector(11 downto 2);
        HADDR2           : in    std_logic_vector(11 downto 2);
        HADDR3           : in    std_logic_vector(11 downto 2);
        HTRANS0          : in    std_logic_vector(1 downto 0);
        HTRANS1          : in    std_logic_vector(1 downto 0);
        HTRANS2          : in    std_logic_vector(1 downto 0);
        HTRANS3          : in    std_logic_vector(1 downto 0);
        HWRITE0          : in    std_logic;
        HWRITE1          : in    std_logic;
        HWRITE2          : in    std_logic;
        HWRITE3          : in    std_logic;
        HSIZE0           : in    std_logic_vector(2 downto 0);
        HSIZE1           : in    std_logic_vector(2 downto 0);
        HSIZE2           : in    std_logic_vector(2 downto 0);
        HSIZE3           : in    std_logic_vector(2 downto 0);
        HBURST0          : in    std_logic_vector(2 downto 0);
        HBURST1          : in    std_logic_vector(2 downto 0);
        HBURST2          : in    std_logic_vector(2 downto 0);
        HBURST3          : in    std_logic_vector(2 downto 0);
        HREADYIN0        : in    std_logic;
        HREADYIN1        : in    std_logic;
        HREADYIN2        : in    std_logic;
        HREADYIN3        : in    std_logic;
        HWDATA0          : in    std_logic_vector(31 downto 0);
        HWDATA1          : in    std_logic_vector(31 downto 0);
        HWDATA2          : in    std_logic_vector(31 downto 0);
        HWDATA3          : in    std_logic_vector(31 downto 0);
        HSELMPMCTR0      : in    std_logic;
        HSELMPMCTR1      : in    std_logic;
        HSELMPMCTR2      : in    std_logic;
        HSELMPMCTR3      : in    std_logic;
        HSELMPMCREG      : in    std_logic;
        MPMCCLKOUT       : in    std_logic_vector(3 downto 0);
        MPMCCKEOUT       : in    std_logic_vector(3 downto 0);
        nMPMCRASOUT      : in    std_logic;
        nMPMCCASOUT      : in    std_logic;
        nMPMCDYCSOUT     : in    std_logic_vector(3 downto 0);
        nMPMCSTCSOUT     : in    std_logic_vector(3 downto 0);
        MPMCACTLOWCS     : in    std_logic_vector(3 downto 0);
        nMPMCWEOUT       : in    std_logic;
        nMPMCDATAEN      : in    std_logic_vector(3 downto 0);
        nMPMCOEOUT       : in    std_logic;
        MPMCDQMOUT       : in    std_logic_vector(3 downto 0);
        nMPMCRPOUT       : in    std_logic;
        MPMCRPVHHOUT     : in    std_logic;
        MPMCSREFACK      : in    std_logic;
        HREADYOutMpmc0   : in    std_logic;
        HREADYOutMpmc1   : in    std_logic;
        MPMCADDROUT      : in    std_logic_vector(27 downto 0);
        MPMCDATAIN       : in    std_logic_vector(31 downto 0);
        MPMCDATAOUT      : in    std_logic_vector(31 downto 0);
        MPMCEBIREQ       : in    std_logic;

        MPMCEBIGNT       : out   std_logic;
        MPMCEBIBACKOFF   : out   std_logic;
        HREADYOUT0       : out   std_logic;
        HREADYOUT1       : out   std_logic;
        HREADYOUT2       : out   std_logic;
        HREADYOUT3       : out   std_logic;
        HRESP0           : out   std_logic_vector(1 downto 0);
        HRESP1           : out   std_logic_vector(1 downto 0);
        HRESP2           : out   std_logic_vector(1 downto 0);
        HRESP3           : out   std_logic_vector(1 downto 0);
        MPMCCLK          : out   std_logic;
        MPMCCLKDELAY     : out   std_logic;
        nPOR             : out   std_logic;
        MPMCSREFREQ      : out   std_logic;
        MPMCBIGENDIAN    : out   std_logic;
        MPMCSTCS0POL     : out   std_logic;
        MPMCSTCS1POL     : out   std_logic;
        MPMCSTCS2POL     : out   std_logic;
        MPMCSTCS3POL     : out   std_logic;
        MPMCSTCS1PB      : out   std_logic;
        MPMCSTCS1MW      : out   std_logic_vector(1 downto 0);
        HRDATA0          : out   std_logic_vector(31 downto 0);
        HRDATA1          : out   std_logic_vector(31 downto 0);
        HRDATA2          : out   std_logic_vector(31 downto 0);
        HRDATA3          : out   std_logic_vector(31 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- Denali Models
-- -----------------------------------------------------------------------------
component k6r1016v1c_15
  generic (
           memory_spec : string;
           init_file   : string
          );
  port (
        a                : in    std_logic_vector(15 downto 0);
        webar            : in    std_logic;
        csbar            : in    std_logic;
        oebar            : in    std_logic;
        bebar            : in    std_logic_vector(1 downto 0);
        io               : inout std_logic_vector(15 downto 0)
       );
end component;

component Int28f800f3b95
  generic (
           memory_spec : string;
           init_file   : string
          );
  port (
        a                : in    std_logic_vector(18 downto 0);
        dq               : inout std_logic_vector(15 downto 0);
        cebar            : in    std_logic;
        oebar            : in    std_logic;
        webar            : in    std_logic;
        wpbar            : in    std_logic;
        rstbar           : in    std_logic;
        clk              : in    std_logic;
        advbar           : in    std_logic;
        waitbar          : out   std_logic
       );
end component;

component k3n9vu1000m
  generic (
           memory_spec : string;
           init_file   : string
          );
  port (
        a                : in    std_logic_vector(22 downto 0);
        cebar            : in    std_logic;
        oebar            : in    std_logic;
        q                : inout std_logic_vector(15 downto 0);
        bhe              : in    std_logic
       );
end component;

component Int28f800f3b115
  generic (
           memory_spec : string;
           init_file   : string
          );
  port (
        a                : in    std_logic_vector(18 downto 0);
        dq               : inout std_logic_vector(15 downto 0);
        cebar            : in    std_logic;
        oebar            : in    std_logic;
        webar            : in    std_logic;
        wpbar            : in    std_logic;
        rstbar           : in    std_logic;
        clk              : in    std_logic;
        advbar           : in    std_logic;
        waitbar          : out   std_logic
       );
end component;

component k4s561632a_75
  generic (
           memory_spec : string;
           init_file   : string
          );
  port (
        a                : in    std_logic_vector(12 downto 0);
        rasbar           : in    std_logic;
        casbar           : in    std_logic;
        webar            : in    std_logic;
        csbar            : in    std_logic;
        dqm              : in    std_logic_vector(1 downto 0);
        clk              : in    std_logic;
        cke              : in    std_logic;
        dq               : inout std_logic_vector(15 downto 0);
        ba               : in    std_logic_vector(1 downto 0)
       );
end component;

component mt48lc32m16a2_75
  generic (
           memory_spec : string;
           init_file   : string
          );
  port (
        a                : in    std_logic_vector(12 downto 0);
        rasbar           : in    std_logic;
        casbar           : in    std_logic;
        webar            : in    std_logic;
        csbar            : in    std_logic;
        dqm              : in    std_logic_vector(1 downto 0);
        clk              : in    std_logic;
        cke              : in    std_logic;
        dq               : inout std_logic_vector(15 downto 0);
        ba               : in    std_logic_vector(1 downto 0)
       );
end component;

component mt48lc1m16a1_6s
  generic (
           memory_spec : string;
           init_file   : string
          );
  port (
        a                : in    std_logic_vector(10 downto 0);
        rasbar           : in    std_logic;
        casbar           : in    std_logic;
        webar            : in    std_logic;
        csbar            : in    std_logic;
        dqm              : in    std_logic_vector(1 downto 0);
        clk              : in    std_logic;
        cke              : in    std_logic;
        ba               : in    std_logic;
        dq               : inout std_logic_vector(15 downto 0)
       );
end component;

component mt28s4m16lc_12
  generic (
           memory_spec : string;
           init_file   : string
          );
  port (
        clk              : in    std_logic;
        cke              : in    std_logic;
        csbar            : in    std_logic;
        rasbar           : in    std_logic;
        casbar           : in    std_logic;
        webar            : in    std_logic;
        dqm              : in    std_logic_vector(1 downto 0);
        address          : in    std_logic_vector(11 downto 0);
        data             : inout std_logic_vector(15 downto 0);
        rpbar            : in    std_logic;
        ba               : in    std_logic_vector(1 downto 0)
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
signal HCLK             : std_logic;
signal HRESETn          : std_logic;

-- Virtual registers (AHB 0).
signal VRG00            : std_logic_vector(31 downto 0);
signal VRG01            : std_logic_vector(31 downto 0);
signal VRG02            : std_logic_vector(31 downto 0);
signal VRG03            : std_logic_vector(31 downto 0);
signal VRG04            : std_logic_vector(31 downto 0);
signal VRG05            : std_logic_vector(31 downto 0);
signal VRG06            : std_logic_vector(31 downto 0);
signal VRG07            : std_logic_vector(31 downto 0);

-- Internal version of virtual registers (AHB 0).
signal iVRG00           : std_logic_vector(31 downto 0);
signal iVRG01           : std_logic_vector(31 downto 0);
signal iVRG02           : std_logic_vector(31 downto 0);
signal iVRG03           : std_logic_vector(31 downto 0);

-- Virtual registers (AHB 1).
signal VRG10            : std_logic_vector(31 downto 0);
signal VRG11            : std_logic_vector(31 downto 0);
signal VRG12            : std_logic_vector(31 downto 0);
signal VRG13            : std_logic_vector(31 downto 0);
signal VRG14            : std_logic_vector(31 downto 0);
signal VRG15            : std_logic_vector(31 downto 0);
signal VRG16            : std_logic_vector(31 downto 0);
signal VRG17            : std_logic_vector(31 downto 0);

-- Internal version of virtual registers (AHB 1).
signal iVRG10           : std_logic_vector(31 downto 0);
signal iVRG11           : std_logic_vector(31 downto 0);
signal iVRG12           : std_logic_vector(31 downto 0);
signal iVRG13           : std_logic_vector(31 downto 0);

-- Virtual registers (AHB 2).
signal VRG20            : std_logic_vector(31 downto 0);
signal VRG21            : std_logic_vector(31 downto 0);
signal VRG22            : std_logic_vector(31 downto 0);
signal VRG23            : std_logic_vector(31 downto 0);
signal VRG24            : std_logic_vector(31 downto 0);
signal VRG25            : std_logic_vector(31 downto 0);
signal VRG26            : std_logic_vector(31 downto 0);
signal VRG27            : std_logic_vector(31 downto 0);

-- Internal version of virtual registers (AHB 2).
signal iVRG20           : std_logic_vector(31 downto 0);
signal iVRG21           : std_logic_vector(31 downto 0);
signal iVRG22           : std_logic_vector(31 downto 0);
signal iVRG23           : std_logic_vector(31 downto 0);

-- Virtual registers (AHB 3).
signal VRG30            : std_logic_vector(31 downto 0);
signal VRG31            : std_logic_vector(31 downto 0);
signal VRG32            : std_logic_vector(31 downto 0);
signal VRG33            : std_logic_vector(31 downto 0);
signal VRG34            : std_logic_vector(31 downto 0);
signal VRG35            : std_logic_vector(31 downto 0);
signal VRG36            : std_logic_vector(31 downto 0);
signal VRG37            : std_logic_vector(31 downto 0);

-- Internal version of virtual registers (AHB 3).
signal iVRG30           : std_logic_vector(31 downto 0);
signal iVRG31           : std_logic_vector(31 downto 0);
signal iVRG32           : std_logic_vector(31 downto 0);
signal iVRG33           : std_logic_vector(31 downto 0);

-- MPMC Register Interface Response signals.
signal HREADYOutMCReg   : T_line;
signal HRESPOutMCReg    : T_resp;
signal HRDATAOutMCReg   : T_data;
signal iHRDATAOutMCReg  : T_data;

-- MPMC Response signals for AHB 0. 
signal HREADYOutMpmc0   : T_line;
signal HRESPOutMpmc0    : T_resp;
signal HRDATAOutMpmc0   : T_data;
signal iHRDATAOutMpmc0  : T_data;

-- MPMC Trickbox Response signals for AHB 0.
signal HREADYOutMCTr0   : T_line;
signal HRESPOutMCTr0    : T_resp;
signal HRDATAOutMCTr0   : T_data;
signal iHRDATAOutMCTr0  : T_data;

-- MPMC Response signals for AHB 1. 
signal HREADYOutMpmc1   : T_line;
signal HRESPOutMpmc1    : T_resp;
signal HRDATAOutMpmc1   : T_data;
signal iHRDATAOutMpmc1  : T_data;

-- MPMC Trickbox Response signals for AHB 1.
signal HREADYOutMCTr1   : T_line;
signal HRESPOutMCTr1    : T_resp;
signal HRDATAOutMCTr1   : T_data;
signal iHRDATAOutMCTr1  : T_data;

-- MPMC Response signals for AHB 2. 
signal HREADYOutMpmc2   : T_line;
signal HRESPOutMpmc2    : T_resp;
signal HRDATAOutMpmc2   : T_data;
signal iHRDATAOutMpmc2  : T_data;

-- MPMC Trickbox Response signals for AHB 2.
signal HREADYOutMCTr2   : T_line;
signal HRESPOutMCTr2    : T_resp;
signal HRDATAOutMCTr2   : T_data;
signal iHRDATAOutMCTr2  : T_data;

-- MPMC Response signals for AHB 3. 
signal HREADYOutMpmc3   : T_line;
signal HRESPOutMpmc3    : T_resp;
signal HRDATAOutMpmc3   : T_data;
signal iHRDATAOutMpmc3  : T_data;

-- MPMC Trickbox Response signals for AHB 3.
signal HREADYOutMCTr3   : T_line;
signal HRESPOutMCTr3    : T_resp;
signal HRDATAOutMCTr3   : T_data;
signal iHRDATAOutMCTr3  : T_data;

-- Scan Ports of MPMC.
signal SCANENABLE       : std_logic;
signal SCANINHCLK       : std_logic;
signal SCANINMPMCCLK    : std_logic;
signal SCANINCLKDELAY   : std_logic;
signal SCANINFBCLKIN0   : std_logic;
signal SCANINFBCLKIN1   : std_logic;
signal SCANINFBCLKIN2   : std_logic;
signal SCANINFBCLKIN3   : std_logic;
signal SCANOUTHCLK      : std_logic;
signal SCANOUTMPMCCLK   : std_logic;
signal SCANOUTCLKDELAY  : std_logic;
signal SCANOUTFBCLKIN0  : std_logic;
signal SCANOUTFBCLKIN1  : std_logic;
signal SCANOUTFBCLKIN2  : std_logic;
signal SCANOUTFBCLKIN3  : std_logic;

-- -----------------------------------------------------------------------------
-- Mpmc Signal declarations
-- -----------------------------------------------------------------------------

-- AHB Bus0 signals.
signal HWRITE0          : std_logic;
signal HSIZE0           : std_logic_vector(2 downto 0);
signal HBURST0          : std_logic_vector(2 downto 0);
signal HPROT0           : std_logic_vector(3 downto 0);
signal HTRANS0          : std_logic_vector(1 downto 0);
signal HRESP0           : std_logic_vector(1 downto 0);
signal HREADY0          : std_logic;
signal HADDR0           : std_logic_vector(31 downto 0);
signal HRDATA0          : T_data;
signal HWDATA0          : T_data;
signal HSPLIT0          : std_logic_vector(15 downto 0);
signal HMASTER0         : std_logic_vector(3 downto 0);
signal HMASTLOCK0       : T_line;

-- AHB Bus1 signals.
signal HWRITE1          : std_logic;
signal HSIZE1           : std_logic_vector(2 downto 0);
signal HBURST1          : std_logic_vector(2 downto 0);
signal HPROT1           : std_logic_vector(3 downto 0);
signal HTRANS1          : std_logic_vector(1 downto 0);
signal HRESP1           : std_logic_vector(1 downto 0);
signal HREADY1          : std_logic;
signal HADDR1           : std_logic_vector(31 downto 0);
signal HRDATA1          : T_data;
signal HWDATA1          : T_data;
signal HSPLIT1          : std_logic_vector(15 downto 0);
signal HMASTER1         : std_logic_vector(3 downto 0);
signal HMASTLOCK1       : T_line;

-- AHB Bus2 signals.
signal HWRITE2          : std_logic;
signal HSIZE2           : std_logic_vector(2 downto 0);
signal HBURST2          : std_logic_vector(2 downto 0);
signal HPROT2           : std_logic_vector(3 downto 0);
signal HTRANS2          : std_logic_vector(1 downto 0);
signal HRESP2           : std_logic_vector(1 downto 0);
signal HREADY2          : std_logic;
signal HADDR2           : std_logic_vector(31 downto 0);
signal HRDATA2          : T_data;
signal HWDATA2          : T_data;
signal HSPLIT2          : std_logic_vector(15 downto 0);
signal HMASTER2         : std_logic_vector(3 downto 0);
signal HMASTLOCK2       : T_line;

-- AHB Bus3 signals.
signal HWRITE3          : std_logic;
signal HSIZE3           : std_logic_vector(2 downto 0);
signal HBURST3          : std_logic_vector(2 downto 0);
signal HPROT3           : std_logic_vector(3 downto 0);
signal HTRANS3          : std_logic_vector(1 downto 0);
signal HRESP3           : std_logic_vector(1 downto 0);
signal HREADY3          : std_logic;
signal HADDR3           : std_logic_vector(31 downto 0);
signal HRDATA3          : T_data;
signal HWDATA3          : T_data;
signal HSPLIT3          : std_logic_vector(15 downto 0);
signal HMASTER3         : std_logic_vector(3 downto 0);
signal HMASTLOCK3       : T_line;

-- Default Slave signals for AHB Bus0.
signal HREADYOutDef0    : T_line;
signal HRDATAOutDef0    : T_data;
signal HRESPOutDef0     : T_resp;

signal DefSlaveSel0     : std_logic;
signal DelDefSel0       : std_logic;

-- Default Slave signals for AHB Bus1.
signal HREADYOutDef1    : T_line;
signal HRDATAOutDef1    : T_data;
signal HRESPOutDef1     : T_resp;

signal DefSlaveSel1     : std_logic;
signal DelDefSel1       : std_logic;

-- Default Slave signals for AHB Bus2.
signal HREADYOutDef2    : T_line;
signal HRDATAOutDef2    : T_data;
signal HRESPOutDef2     : T_resp;

signal DefSlaveSel2     : std_logic;
signal DelDefSel2       : std_logic;

-- Default Slave signals for AHB Bus3.
signal HREADYOutDef3    : T_line;
signal HRDATAOutDef3    : T_data;
signal HRESPOutDef3     : T_resp;

signal DefSlaveSel3     : std_logic;
signal DelDefSel3       : std_logic;

-- Decoder Signals
signal HSEL0            : std_logic_vector(8 downto 0);
signal DelHSEL0         : std_logic_vector(8 downto 0);
signal HSEL1            : std_logic_vector(8 downto 0);
signal DelHSEL1         : std_logic_vector(8 downto 0);
signal HSEL2            : std_logic_vector(8 downto 0);
signal DelHSEL2         : std_logic_vector(8 downto 0);
signal HSEL3            : std_logic_vector(15 downto 0);
signal DelHSEL3         : std_logic_vector(15 downto 0);

-- MUX Bus signals for AHB Bus0.
signal HREADY0MUX       : T_line;
signal HRESP0MUX        : T_resp;
signal HRDATA0MUX       : T_data;

-- OR Bus signals for AHB Bus0.
signal HREADY0OR        : T_line;
signal HRESP0OR         : T_resp;
signal HRDATA0OR        : T_data;

-- MUX Bus signals for AHB Bus1.
signal HREADY1MUX       : T_line;
signal HRESP1MUX        : T_resp;
signal HRDATA1MUX       : T_data;

-- OR Bus signals for AHB Bus1.
signal HREADY1OR        : T_line;
signal HRESP1OR         : T_resp;
signal HRDATA1OR        : T_data;

-- MUX Bus signals for AHB Bus2.
signal HREADY2MUX       : T_line;
signal HRESP2MUX        : T_resp;
signal HRDATA2MUX       : T_data;

-- OR Bus signals for AHB Bus2.
signal HREADY2OR        : T_line;
signal HRESP2OR         : T_resp;
signal HRDATA2OR        : T_data;

-- MUX Bus signals for AHB Bus3.
signal HREADY3MUX       : T_line;
signal HRESP3MUX        : T_resp;
signal HRDATA3MUX       : T_data;

-- OR Bus signals for AHB Bus3.
signal HREADY3OR        : T_line;
signal HRESP3OR         : T_resp;
signal HRDATA3OR        : T_data;

-- AHB Bus0 Arbitration signals.
signal HLOCK0           : std_logic := '0';
signal HBUSREQ0         : std_logic := '1';
signal HGRANT0          : std_logic := '1';

-- AHB Bus1 Arbitration signals.
signal HLOCK1           : std_logic := '0';
signal HBUSREQ1         : std_logic := '1';
signal HGRANT1          : std_logic := '1';

-- AHB Bus2 Arbitration signals.
signal HLOCK2           : std_logic := '0';
signal HBUSREQ2         : std_logic := '1';
signal HGRANT2          : std_logic := '1';

-- AHB Bus3 Arbitration signals.
signal HLOCK3           : std_logic := '0';
signal HBUSREQ3         : std_logic := '1';
signal HGRANT3          : std_logic := '1';

-- MPMC Signals
signal MPMCCLK          : std_logic;
signal MPMCCLKDELAY     : std_logic;
signal MPMCFBCLKIN0     : std_logic;
signal MPMCFBCLKIN1     : std_logic;
signal MPMCFBCLKIN2     : std_logic;
signal MPMCFBCLKIN3     : std_logic;
signal nPOR             : std_logic;
signal MPMCWAITIN       : std_logic;
signal MPMCDATAIN       : std_logic_vector(31 downto 0);
signal MPMCSREFACK      : std_logic;
signal MPMCBIGENDIAN    : std_logic;
signal MPMCSTCS1MW      : std_logic_vector(1 downto 0);
signal MPMCSTCS0POL     : std_logic;
signal MPMCSTCS1POL     : std_logic;
signal MPMCSTCS2POL     : std_logic;
signal MPMCSTCS3POL     : std_logic;
signal MPMCSTCS1PB      : std_logic;
signal MPMCREL1CONFIG   : std_logic := '0';
signal MPMCCLKOUT       : std_logic_vector(3 downto 0);
signal DelMPMCCLKOUT    : std_logic_vector(3 downto 0);
signal MPMCCKEOUT       : std_logic_vector(3 downto 0);
signal MPMCDQMOUT       : std_logic_vector(3 downto 0);
signal nMPMCBLSOUT      : std_logic_vector(3 downto 0);
signal nMPMCRASOUT      : std_logic;
signal nMPMCCASOUT      : std_logic;
signal nMPMCOEOUT       : std_logic;
signal nMPMCWEOUT       : std_logic;
signal nMPMCSTCSOUT     : std_logic_vector(3 downto 0);
signal nMPMCDYCSOUT     : std_logic_vector(3 downto 0);
signal MPMCADDROUT      : std_logic_vector(27 downto 0);
signal MPMCDATAOUT      : std_logic_vector(31 downto 0);
signal MPMCDATA         : std_logic_vector(31 downto 0);
signal nMPMCRPOUT       : std_logic;
signal MPMCRPVHHOUT     : std_logic;
signal MPMCSREFREQ      : std_logic;
signal nMPMCDATAEN      : std_logic_vector(3 downto 0);
signal MPMCACTLOWCS     : std_logic_vector(7 downto 0);
signal MPMCTrAllCS      : std_logic_vector(7 downto 0);
signal HSELMPMC0G       : std_logic;
signal HSELMPMC1G       : std_logic;
signal HSELMPMC2G       : std_logic;
signal HSELMPMC3G       : std_logic;

-- EBI Related signals
signal MPMCEBIREQ       : std_logic;
signal MPMCEBIGNT       : std_logic:='1';
signal MPMCEBIBACKOFF   : std_logic:='0';

-- TIC Signals
signal HRDATATIC        : std_logic_vector(31 downto 0);
signal HREADYINTIC      : std_logic;
signal HGRANTTIC        : std_logic := '0';
signal HRESPTIC         : T_resp;
signal HWRITETIC        : std_logic;
signal HTRANSTIC        : std_logic_vector(1 downto 0);
signal HSIZETIC         : std_logic_vector(2 downto 0);
signal HBURSTTIC        : std_logic_vector(2 downto 0);
signal HLOCKTIC         : std_logic;
signal HPROTTIC         : std_logic_vector(3 downto 0);
signal HBUSREQTIC       : std_logic;
signal HADDRTIC         : std_logic_vector(31 downto 0);
signal HWDATATIC        : std_logic_vector(31 downto 0);
signal MPMCTESTIN       : std_logic := '0';
signal MPMCTESTREQA     : std_logic := '0';
signal MPMCTESTREQB     : std_logic := '0';

-- Denali signals
signal nWP              : std_logic := '0';
signal nRP              : std_logic := '1';
signal BHE              : std_logic := '1';
signal nRST             : std_logic := '1';
signal nADV             : std_logic := '1';
signal CLK              : std_logic := '1';
signal nWAIT            : std_logic := '1';
signal MPMCDQMBLS       : std_logic_vector(3 downto 0);

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- VRGs (AHB0)
-- -----------------------------------------------------------------------------
iVRG00           <= VRG00;
iVRG01           <= VRG01;
iVRG02           <= VRG02;
iVRG03           <= VRG03;

VRG04            <= iVRG00;
VRG05            <= iVRG01;
VRG07            <= iVRG03;
VRG06            <= iVRG02;

-- -----------------------------------------------------------------------------
-- VRGs (AHB1)
-- -----------------------------------------------------------------------------
iVRG10           <= VRG10;
iVRG11           <= VRG11;
iVRG12           <= VRG12;
iVRG13           <= VRG13;

VRG14            <= iVRG10;
VRG15            <= iVRG11;
VRG17            <= iVRG13;
VRG16            <= iVRG12;

-- -----------------------------------------------------------------------------
-- VRGs (AHB2)
-- -----------------------------------------------------------------------------
iVRG20           <= VRG20;
iVRG21           <= VRG21;
iVRG22           <= VRG22;
iVRG23           <= VRG23;

VRG24            <= iVRG20;
VRG25            <= iVRG21;
VRG27            <= iVRG23;
VRG26            <= iVRG22;

-- -----------------------------------------------------------------------------
-- VRGs (AHB3)
-- -----------------------------------------------------------------------------
iVRG30           <= VRG30;
iVRG31           <= VRG31;
iVRG32           <= VRG32;
iVRG33           <= VRG33;

VRG34            <= iVRG30;
VRG35            <= iVRG31;
VRG37            <= iVRG33;
VRG36            <= iVRG32;

-- -----------------------------------------------------------------------------
--  AHB BUS0 CONFIGURATION
-- -----------------------------------------------------------------------------
HREADY0          <= HREADY0OR when (ORBUS = '1')
                 else
                    HREADY0MUX;

HRESP0           <= HRESP0OR when (ORBUS = '1')
                 else
                    HRESP0MUX;

HSPLIT0          <= (others => '0');

HRDATA0          <= HRDATA0OR when (ORBUS = '1') 
                 else
                    HRDATA0MUX;

-- -----------------------------------------------------------------------------
-- Initialise iHRDATAOutx for every slave to be tested 
-- -----------------------------------------------------------------------------
iHRDATAOutMpmc0  <= (to_stdlogicvector(X"00000000") &
                    HRDATAOutMpmc0(31 downto 0)) when (Databuswidth = 32)
                 else
                    HRDATAOutMpmc0;

iHRDATAOutMCTr0  <= (to_stdlogicvector(X"00000000") &
                    HRDATAOutMCTr0(31 downto 0)) when (Databuswidth = 32)
                 else
                    HRDATAOutMCTr0;

-- -----------------------------------------------------------------------------
-- For MUX-bus implementations
-- When the HGRANT of the corresponding bus stays with the Mpmc,
-- the HSEL1 for the trickbox is generated. Otherwise it points to the
-- default slave on AHB Bus1.
-- -----------------------------------------------------------------------------
HREADY0MUX       <= HREADYOutMpmc0 when (DelHSEL0(0) = '1') 
                 else
                    HREADYOutMpmc0 when (DelHSEL0(1) = '1')
                 else
                    HREADYOutMpmc0 when (DelHSEL0(2) = '1')
                 else
                    HREADYOutMpmc0 when (DelHSEL0(3) = '1')
                 else
                    HREADYOutMpmc0 when (DelHSEL0(4) = '1')
                 else
                    HREADYOutMpmc0 when (DelHSEL0(5) = '1')
                 else
                    HREADYOutMpmc0 when (DelHSEL0(6) = '1')
                 else
                    HREADYOutMpmc0 when (DelHSEL0(7) = '1')
                 else
                    HREADYOutMCTr0 when (DelHSEL0(8) = '1')
                 else
                    HREADYOutDef0 when DelDefSel0 = '1'
                 else
                    '0';

HRESP0MUX        <= HRESPOutMpmc0 when (DelHSEL0(0) = '1') 
                 else
                    HRESPOutMpmc0 when (DelHSEL0(1) = '1')
                 else
                    HRESPOutMpmc0 when (DelHSEL0(2) = '1')
                 else
                    HRESPOutMpmc0 when (DelHSEL0(3) = '1')
                 else
                    HRESPOutMpmc0 when (DelHSEL0(4) = '1')
                 else
                    HRESPOutMpmc0 when (DelHSEL0(5) = '1')
                 else
                    HRESPOutMpmc0 when (DelHSEL0(6) = '1')
                 else
                    HRESPOutMpmc0 when (DelHSEL0(7) = '1')
                 else
                    HRESPOutMCTr0 when (DelHSEL0(8) = '1')
                 else
                    HRESPOutDef0 when DelDefSel0 = '1'
                 else
                    "00";

HRDATA0MUX       <= iHRDATAOutMpmc0 when (DelHSEL0(0) = '1')
                 else
                    iHRDATAOutMpmc0 when (DelHSEL0(1) = '1')
                 else
                    iHRDATAOutMpmc0 when (DelHSEL0(2) = '1')
                 else
                    iHRDATAOutMpmc0 when (DelHSEL0(3) = '1')
                 else
                    iHRDATAOutMpmc0 when (DelHSEL0(4) = '1')
                 else
                    iHRDATAOutMpmc0 when (DelHSEL0(5) = '1')
                 else
                    iHRDATAOutMpmc0 when (DelHSEL0(6) = '1')
                 else
                    iHRDATAOutMpmc0 when (DelHSEL0(7) = '1')
                 else
                    iHRDATAOutMCTr0 when (DelHSEL0(8) = '1')
                 else
                    HRDATAOutDef0 when DelDefSel0 = '1'
                 else
                    to_stdlogicvector(X"0000000000000000");

-- -----------------------------------------------------------------------------
-- For OR bus implementations
-- -----------------------------------------------------------------------------
HRESP0OR         <= HRESPOutMpmc0 or HRESPOutMCTr0 or HRESPOutDef0;

HREADY0OR        <= HREADYOutMpmc0 or HREADYOutMCTr0 or HREADYOutDef0;

HRDATA0OR        <= iHRDATAOutMpmc0 or iHRDATAOutMCTr0 or HRDATAOutDef0;

-- -----------------------------------------------------------------------------
-- Generating HSEL0
-- -----------------------------------------------------------------------------
HSEL0(0)         <= '1' when ((MPMC00LOWADDRRANGE <= HADDR0) and
                              (HADDR0 <= MPMC00HIGHADDRRANGE))
                 else
                    '0';

HSEL0(1)         <= '1' when ((MPMC01LOWADDRRANGE <= HADDR0) and
                              (HADDR0 <= MPMC01HIGHADDRRANGE))
                 else
                    '0';

HSEL0(2)         <= '1' when ((MPMC02LOWADDRRANGE <= HADDR0) and
                              (HADDR0 <= MPMC02HIGHADDRRANGE))
                 else
                    '0';

HSEL0(3)         <= '1' when ((MPMC03LOWADDRRANGE <= HADDR0) and
                              (HADDR0 <= MPMC03HIGHADDRRANGE))
                 else
                    '0';

HSEL0(4)         <= '1' when ((MPMC04LOWADDRRANGE <= HADDR0) and
                              (HADDR0 <= MPMC04HIGHADDRRANGE))
                 else
                    '0';

HSEL0(5)         <= '1' when ((MPMC05LOWADDRRANGE <= HADDR0) and
                              (HADDR0 <= MPMC05HIGHADDRRANGE))
                 else
                    '0';

HSEL0(6)         <= '1' when ((MPMC06LOWADDRRANGE <= HADDR0) and
                              (HADDR0 <= MPMC06HIGHADDRRANGE))
                 else
                    '0';

HSEL0(7)         <= '1' when ((MPMC07LOWADDRRANGE <= HADDR0) and
                              (HADDR0 <= MPMC07HIGHADDRRANGE))
                 else
                    '0';

HSEL0(8)         <= '1' when ((MCTR0LOWADDRRANGE <= HADDR0) and
                              (HADDR0 <= MCTR0HIGHADDRRANGE))
                 else
                    '0';

DefSlaveSel0     <= '1' when ((HSEL0(0) or HSEL0(1) or HSEL0(2) or HSEL0(3) or
                               HSEL0(4) or HSEL0(5) or HSEL0(6) or HSEL0(7) or
                               HSEL0(8)) /= '1')
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Latching HSEL0
-- -----------------------------------------------------------------------------
p_DelHSEL0Seq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    DelHSEL0   <= (others => '0');
    DelDefSel0 <= '1';
  elsif (HCLK'event and HCLK = '1' and HREADY0 = '1') then
    DelHSEL0   <= HSEL0;
    DelDefSel0 <= DefSlaveSel0;
  end if;
end process p_DelHSEL0Seq;
 
-- -----------------------------------------------------------------------------
--  AHB BUS1 CONFIGURATION
-- -----------------------------------------------------------------------------
HREADY1          <= HREADY1OR when (ORBUS = '1')
                 else
                    HREADY1MUX;

HRESP1           <= HRESP1OR when (ORBUS = '1')
                 else
                    HRESP1MUX;

HSPLIT1          <= (others => '0');

HRDATA1          <= HRDATA1OR when (ORBUS = '1') 
                 else
                    HRDATA1MUX;

-- -----------------------------------------------------------------------------
-- Initialise iHRDATAOutx for every slave to be tested 
-- -----------------------------------------------------------------------------
iHRDATAOutMpmc1  <= (to_stdlogicvector(X"00000000") &
                    HRDATAOutMpmc1(31 downto 0)) when (Databuswidth = 32)
                 else
                    HRDATAOutMpmc1;

iHRDATAOutMCTr1  <= (to_stdlogicvector(X"00000000") &
                    HRDATAOutMCTr1(31 downto 0)) when (Databuswidth = 32)
                 else
                    HRDATAOutMCTr1;

-- -----------------------------------------------------------------------------
-- For MUX-bus implementations
-- When the HGRANT of the corresponding bus stays with the Mpmc,
-- the HSEL1 for the trickbox is generated. Otherwise it points to the
-- default slave on AHB Bus1.
-- -----------------------------------------------------------------------------
HREADY1MUX       <= HREADYOutMpmc1 when (DelHSEL1(0) = '1') 
                 else
                    HREADYOutMpmc1 when (DelHSEL1(1) = '1')
                 else
                    HREADYOutMpmc1 when (DelHSEL1(2) = '1')
                 else
                    HREADYOutMpmc1 when (DelHSEL1(3) = '1')
                 else
                    HREADYOutMpmc1 when (DelHSEL1(4) = '1')
                 else
                    HREADYOutMpmc1 when (DelHSEL1(5) = '1')
                 else
                    HREADYOutMpmc1 when (DelHSEL1(6) = '1')
                 else
                    HREADYOutMpmc1 when (DelHSEL1(7) = '1')
                 else
                    HREADYOutMCTr1 when (DelHSEL1(8) = '1')
                 else
                    HREADYOutDef1 when DelDefSel1 = '1'
                 else
                    '0';

HRESP1MUX        <= HRESPOutMpmc1 when (DelHSEL1(0) = '1') 
                 else
                    HRESPOutMpmc1 when (DelHSEL1(1) = '1')
                 else
                    HRESPOutMpmc1 when (DelHSEL1(2) = '1')
                 else
                    HRESPOutMpmc1 when (DelHSEL1(3) = '1')
                 else
                    HRESPOutMpmc1 when (DelHSEL1(4) = '1')
                 else
                    HRESPOutMpmc1 when (DelHSEL1(5) = '1')
                 else
                    HRESPOutMpmc1 when (DelHSEL1(6) = '1')
                 else
                    HRESPOutMpmc1 when (DelHSEL1(7) = '1')
                 else
                    HRESPOutMCTr1 when (DelHSEL1(8) = '1')
                 else
                    HRESPOutDef1 when DelDefSel1 = '1'
                 else
                    "00";

HRDATA1MUX       <= iHRDATAOutMpmc1 when (DelHSEL1(0) = '1')
                 else
                    iHRDATAOutMpmc1 when (DelHSEL1(1) = '1')
                 else
                    iHRDATAOutMpmc1 when (DelHSEL1(2) = '1')
                 else
                    iHRDATAOutMpmc1 when (DelHSEL1(3) = '1')
                 else
                    iHRDATAOutMpmc1 when (DelHSEL1(4) = '1')
                 else
                    iHRDATAOutMpmc1 when (DelHSEL1(5) = '1')
                 else
                    iHRDATAOutMpmc1 when (DelHSEL1(6) = '1')
                 else
                    iHRDATAOutMpmc1 when (DelHSEL1(7) = '1')
                 else
                    iHRDATAOutMCTr1 when (DelHSEL1(8) = '1')
                 else
                    HRDATAOutDef1 when DelDefSel1 = '1'
                 else
                    to_stdlogicvector(X"0000000000000000");

-- -----------------------------------------------------------------------------
-- For OR bus implementations
-- -----------------------------------------------------------------------------
HRESP1OR         <= HRESPOutMpmc1 or HRESPOutMCTr1 or HRESPOutDef1;

HREADY1OR        <= HREADYOutMpmc1 or HREADYOutMCTr1 or HREADYOutDef1;

HRDATA1OR        <= iHRDATAOutMpmc1 or iHRDATAOutMCTr1 or HRDATAOutDef1;

-- -----------------------------------------------------------------------------
-- Generating HSEL1
-- -----------------------------------------------------------------------------
HSEL1(0)         <= '1' when ((MPMC10LOWADDRRANGE <= HADDR1) and
                              (HADDR1 <= MPMC10HIGHADDRRANGE))
                 else
                    '0';

HSEL1(1)         <= '1' when ((MPMC11LOWADDRRANGE <= HADDR1) and
                              (HADDR1 <= MPMC11HIGHADDRRANGE))
                 else
                    '0';

HSEL1(2)         <= '1' when ((MPMC12LOWADDRRANGE <= HADDR1) and
                              (HADDR1 <= MPMC12HIGHADDRRANGE))
                 else
                    '0';

HSEL1(3)         <= '1' when ((MPMC13LOWADDRRANGE <= HADDR1) and
                              (HADDR1 <= MPMC13HIGHADDRRANGE))
                 else
                    '0';

HSEL1(4)         <= '1' when ((MPMC14LOWADDRRANGE <= HADDR1) and
                              (HADDR1 <= MPMC14HIGHADDRRANGE))
                 else
                    '0';

HSEL1(5)         <= '1' when ((MPMC15LOWADDRRANGE <= HADDR1) and
                              (HADDR1 <= MPMC15HIGHADDRRANGE))
                 else
                    '0';

HSEL1(6)         <= '1' when ((MPMC16LOWADDRRANGE <= HADDR1) and
                              (HADDR1 <= MPMC16HIGHADDRRANGE))
                 else
                    '0';

HSEL1(7)         <= '1' when ((MPMC17LOWADDRRANGE <= HADDR1) and
                              (HADDR1 <= MPMC17HIGHADDRRANGE))
                 else
                    '0';

HSEL1(8)         <= '1' when ((MCTR1LOWADDRRANGE <= HADDR1) and
                              (HADDR1 <= MCTR1HIGHADDRRANGE))
                 else
                    '0';

DefSlaveSel1     <= '1' when ((HSEL1(0) or HSEL1(1) or HSEL1(2) or HSEL1(3) or
                               HSEL1(4) or HSEL1(5) or HSEL1(6) or HSEL1(7) or
                               HSEL1(8)) /= '1')
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Latching HSEL1
-- -----------------------------------------------------------------------------
p_DelHSEL1Seq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    DelHSEL1 <= (others => '0');
    DelDefSel1  <= '1';
  elsif (HCLK'event and HCLK = '1' and HREADY1 = '1') then
    DelHSEL1 <= HSEL1;
    DelDefSel1  <= DefSlaveSel1;
  end if;
end process p_DelHSEL1Seq;
 
-- -----------------------------------------------------------------------------
--  AHB BUS2 CONFIGURATION
-- -----------------------------------------------------------------------------
HREADY2          <= HREADY2OR when (ORBUS = '1')
                 else
                    HREADY2MUX;

HRESP2           <= HRESP2OR when (ORBUS = '1')
                 else
                    HRESP2MUX;

HSPLIT2          <= (others => '0');

HRDATA2          <= HRDATA2OR when (ORBUS = '1') 
                 else
                    HRDATA2MUX;

-- -----------------------------------------------------------------------------
-- Initialise iHRDATAOutx for every slave to be tested 
-- -----------------------------------------------------------------------------
iHRDATAOutMpmc2  <= (to_stdlogicvector(X"00000000") &
                    HRDATAOutMpmc2(31 downto 0)) when (Databuswidth = 32)
                 else
                    HRDATAOutMpmc2;

iHRDATAOutMCTr2  <= (to_stdlogicvector(X"00000000") &
                    HRDATAOutMCTr2(31 downto 0)) when (Databuswidth = 32)
                 else
                    HRDATAOutMCTr2;

-- -----------------------------------------------------------------------------
-- For MUX-bus implementations
-- When the HGRANT of the corresponding bus stays with the Mpmc,
-- the HSEL1 for the trickbox is generated. Otherwise it points to the
-- default slave on AHB Bus1.
-- -----------------------------------------------------------------------------
HREADY2MUX       <= HREADYOutMpmc2 when (DelHSEL2(0) = '1') 
                 else
                    HREADYOutMpmc2 when (DelHSEL2(1) = '1')
                 else
                    HREADYOutMpmc2 when (DelHSEL2(2) = '1')
                 else
                    HREADYOutMpmc2 when (DelHSEL2(3) = '1')
                 else
                    HREADYOutMpmc2 when (DelHSEL2(4) = '1')
                 else
                    HREADYOutMpmc2 when (DelHSEL2(5) = '1')
                 else
                    HREADYOutMpmc2 when (DelHSEL2(6) = '1')
                 else
                    HREADYOutMpmc2 when (DelHSEL2(7) = '1')
                 else
                    HREADYOutMCTr2 when (DelHSEL2(8) = '1')
                 else
                    HREADYOutDef2 when DelDefSel2 = '1'
                 else
                    '0';

HRESP2MUX        <= HRESPOutMpmc2 when (DelHSEL2(0) = '1') 
                 else
                    HRESPOutMpmc2 when (DelHSEL2(1) = '1')
                 else
                    HRESPOutMpmc2 when (DelHSEL2(2) = '1')
                 else
                    HRESPOutMpmc2 when (DelHSEL2(3) = '1')
                 else
                    HRESPOutMpmc2 when (DelHSEL2(4) = '1')
                 else
                    HRESPOutMpmc2 when (DelHSEL2(5) = '1')
                 else
                    HRESPOutMpmc2 when (DelHSEL2(6) = '1')
                 else
                    HRESPOutMpmc2 when (DelHSEL2(7) = '1')
                 else
                    HRESPOutMCTr2 when (DelHSEL2(8) = '1')
                 else
                    HRESPOutDef2 when DelDefSel2 = '1'
                 else
                    "00";

HRDATA2MUX       <= iHRDATAOutMpmc2 when (DelHSEL2(0) = '1')
                 else
                    iHRDATAOutMpmc2 when (DelHSEL2(1) = '1')
                 else
                    iHRDATAOutMpmc2 when (DelHSEL2(2) = '1')
                 else
                    iHRDATAOutMpmc2 when (DelHSEL2(3) = '1')
                 else
                    iHRDATAOutMpmc2 when (DelHSEL2(4) = '1')
                 else
                    iHRDATAOutMpmc2 when (DelHSEL2(5) = '1')
                 else
                    iHRDATAOutMpmc2 when (DelHSEL2(6) = '1')
                 else
                    iHRDATAOutMpmc2 when (DelHSEL2(7) = '1')
                 else
                    iHRDATAOutMCTr2 when (DelHSEL2(8) = '1')
                 else
                    HRDATAOutDef2 when DelDefSel2 = '1'
                 else
                    to_stdlogicvector(X"0000000000000000");

-- -----------------------------------------------------------------------------
-- For OR bus implementations
-- -----------------------------------------------------------------------------
HRESP2OR         <= HRESPOutMpmc2 or HRESPOutMCTr2 or HRESPOutDef2;

HREADY2OR        <= HREADYOutMpmc2 or HREADYOutMCTr2 or HREADYOutDef2;

HRDATA2OR        <= iHRDATAOutMpmc2 or iHRDATAOutMCTr2 or HRDATAOutDef2;

-- -----------------------------------------------------------------------------
-- Generating HSEL2
-- -----------------------------------------------------------------------------
HSEL2(0)         <= '1' when ((MPMC20LOWADDRRANGE <= HADDR2) and
                              (HADDR2 <= MPMC20HIGHADDRRANGE))
                 else
                    '0';

HSEL2(1)         <= '1' when ((MPMC21LOWADDRRANGE <= HADDR2) and
                              (HADDR2 <= MPMC21HIGHADDRRANGE))
                 else
                    '0';

HSEL2(2)         <= '1' when ((MPMC22LOWADDRRANGE <= HADDR2) and
                              (HADDR2 <= MPMC22HIGHADDRRANGE))
                 else
                    '0';

HSEL2(3)         <= '1' when ((MPMC23LOWADDRRANGE <= HADDR2) and
                              (HADDR2 <= MPMC23HIGHADDRRANGE))
                 else
                    '0';

HSEL2(4)         <= '1' when ((MPMC24LOWADDRRANGE <= HADDR2) and
                              (HADDR2 <= MPMC24HIGHADDRRANGE))
                 else
                    '0';

HSEL2(5)         <= '1' when ((MPMC25LOWADDRRANGE <= HADDR2) and
                              (HADDR2 <= MPMC25HIGHADDRRANGE))
                 else
                    '0';

HSEL2(6)         <= '1' when ((MPMC26LOWADDRRANGE <= HADDR2) and
                              (HADDR2 <= MPMC26HIGHADDRRANGE))
                 else
                    '0';

HSEL2(7)         <= '1' when ((MPMC27LOWADDRRANGE <= HADDR2) and
                              (HADDR2 <= MPMC27HIGHADDRRANGE))
                 else
                    '0';

HSEL2(8)         <= '1' when ((MCTR2LOWADDRRANGE <= HADDR2) and
                              (HADDR2 <= MCTR2HIGHADDRRANGE))
                 else
                    '0';

DefSlaveSel2     <= '1' when ((HSEL2(0) or HSEL2(1) or HSEL2(2) or HSEL2(3) or
                               HSEL2(4) or HSEL2(5) or HSEL2(6) or HSEL2(7) or
                               HSEL2(8)) /= '1')
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Latching HSEL2
-- -----------------------------------------------------------------------------
p_DelHSEL2Seq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    DelHSEL2   <= (others => '0');
    DelDefSel2 <= '1';
  elsif (HCLK'event and HCLK = '1' and HREADY2 = '1') then
    DelHSEL2   <= HSEL2;
    DelDefSel2 <= DefSlaveSel2;
  end if;
end process p_DelHSEL2Seq;
 
-- -----------------------------------------------------------------------------
--  AHB BUS3 CONFIGURATION
-- The slave interfaces of the Mpmc, Trickbox and TrickMem (4 instances) are
-- connected to this bus.
-- -----------------------------------------------------------------------------
HREADY3          <= HREADY3OR when (ORBUS = '1')
                 else
                    HREADY3MUX;

HRESP3           <= HRESP3OR when (ORBUS = '1')
                 else
                    HRESP3MUX;

HSPLIT3          <= (others => '0');

HRDATA3          <= HRDATA3OR when (ORBUS = '1') 
                 else
                    HRDATA3MUX;

-- -----------------------------------------------------------------------------
-- Connect all the scan inputs to '0' to prevent interference with
-- functional mode tests.
-- -----------------------------------------------------------------------------
SCANENABLE       <= '0';
SCANINHCLK       <= '0';

-- -----------------------------------------------------------------------------
-- Initialise iHRDATAOutx for every slave to be tested 
-- -----------------------------------------------------------------------------
iHRDATAOutMpmc3  <= (to_stdlogicvector(X"00000000") &
                    HRDATAOutMpmc3(31 downto 0)) when (Databuswidth = 32)
                 else
                    HRDATAOutMpmc3;

HRDATAOutMCReg(31 downto 21) <= (others => '0');

iHRDATAOutMCReg  <= (to_stdlogicvector(X"00000000") &
                    HRDATAOutMCReg(31 downto 0)) when (Databuswidth = 32)
                 else
                    HRDATAOutMCReg;

iHRDATAOutMCTr3  <= (to_stdlogicvector(X"00000000") &
                    HRDATAOutMCTr3(31 downto 0)) when (Databuswidth = 32)
                 else
                    HRDATAOutMCTr3;

-- -----------------------------------------------------------------------------
-- For MUX-bus implementations
-- -----------------------------------------------------------------------------
HREADY3MUX       <= HREADYOutMpmc3 when (DelHSEL3(0) = '1')
                 else
                    HREADYOutMpmc3 when (DelHSEL3(1) = '1')
                 else
                    HREADYOutMpmc3 when (DelHSEL3(2) = '1')
                 else
                    HREADYOutMpmc3 when (DelHSEL3(3) = '1')
                 else
                    HREADYOutMpmc3 when (DelHSEL3(4) = '1')
                 else
                    HREADYOutMpmc3 when (DelHSEL3(5) = '1')
                 else
                    HREADYOutMpmc3 when (DelHSEL3(6) = '1')
                 else
                    HREADYOutMpmc3 when (DelHSEL3(7) = '1')
                 else
                    HREADYOutMCReg when (DelHSEL3(8) = '1')
                 else
                    HREADYOutMCTr3 when (DelHSEL3(9) = '1') 
                 else
                    HREADYOutDef3 when DelDefSel3 = '1'
                 else
                    '0';

HRESP3MUX        <= HRESPOutMpmc3 when (DelHSEL3(0) = '1')
                 else
                    HRESPOutMpmc3 when (DelHSEL3(1) = '1')
                 else
                    HRESPOutMpmc3 when (DelHSEL3(2) = '1')
                 else
                    HRESPOutMpmc3 when (DelHSEL3(3) = '1')
                 else
                    HRESPOutMpmc3 when (DelHSEL3(4) = '1')
                 else
                    HRESPOutMpmc3 when (DelHSEL3(5) = '1')
                 else
                    HRESPOutMpmc3 when (DelHSEL3(6) = '1')
                 else
                    HRESPOutMpmc3 when (DelHSEL3(7) = '1')
                 else
                    HRESPOutMCReg when (DelHSEL3(8) = '1')
                 else
                    HRESPOutMCTr3 when (DelHSEL3(9) = '1') 
                 else
                    HRESPOutDef3 when DelDefSel3 = '1'
                 else
                    "00";

HRDATA3MUX       <= iHRDATAOutMpmc3 when (DelHSEL3(0) = '1')
                 else
                    iHRDATAOutMpmc3 when (DelHSEL3(1) = '1')
                 else
                    iHRDATAOutMpmc3 when (DelHSEL3(2) = '1')
                 else
                    iHRDATAOutMpmc3 when (DelHSEL3(3) = '1')
                 else
                    iHRDATAOutMpmc3 when (DelHSEL3(4) = '1')
                 else
                    iHRDATAOutMpmc3 when (DelHSEL3(5) = '1')
                 else
                    iHRDATAOutMpmc3 when (DelHSEL3(6) = '1')
                 else
                    iHRDATAOutMpmc3 when (DelHSEL3(7) = '1')
                 else
                    iHRDATAOutMCReg when (DelHSEL3(8) = '1')
                 else
                    iHRDATAOutMCTr3 when (DelHSEL3(9) = '1')
                 else
                    HRDATAOutDef3 when DelDefSel3 = '1'
                 else
                    to_stdlogicvector(X"0000000000000000");

-- -----------------------------------------------------------------------------
-- For OR bus implementations
-- -----------------------------------------------------------------------------
HRESP3OR         <= HRESPOutMpmc3 or HRESPOutMCReg or HRESPOutMCTr3 or
                    HRESPOutDef3;

HREADY3OR        <= HREADYOutMpmc3 or HREADYOutMCReg or HREADYOutMCTr3 or
                    HREADYOutDef3;

HRDATA3OR        <= iHRDATAOutMpmc3 or iHRDATAOutMCReg or iHRDATAOutMCTr3 or
                    HRDATAOutDef3;

-- -----------------------------------------------------------------------------
-- Latching HSEL3
-- -----------------------------------------------------------------------------
p_DelHSEL3Seq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    DelHSEL3   <= (others => '0');
    DelDefSel3 <= '1';
  elsif (HCLK'event and HCLK = '1' and HREADY3 = '1') then
    DelHSEL3   <= HSEL3;
    DelDefSel3 <= DefSlaveSel3;
  end if;
end process p_DelHSEL3Seq;
 
-- -----------------------------------------------------------------------------
-- Memory Data Bus multiplexing
-- -----------------------------------------------------------------------------
p_MPMCDATAComb : process (nMPMCDATAEN, MPMCDATAOUT)
begin
  if (nMPMCDATAEN(0) = '0') then
    MPMCDATA(7 downto 0) <= MPMCDATAOUT(7 downto 0);
  else
    MPMCDATA(7 downto 0) <= (others =>'Z');
  end if;

  if (nMPMCDATAEN(1) = '0') then
    MPMCDATA(15 downto 8) <= MPMCDATAOUT(15 downto 8);
  else
    MPMCDATA(15 downto 8) <= (others =>'Z');
  end if;

  if (nMPMCDATAEN(2) = '0') then
    MPMCDATA(23 downto 16) <= MPMCDATAOUT(23 downto 16);
  else
    MPMCDATA(23 downto 16) <= (others =>'Z');
  end if;

  if (nMPMCDATAEN(3) = '0') then
    MPMCDATA(31 downto 24) <= MPMCDATAOUT(31 downto 24);
  else
    MPMCDATA(31 downto 24) <= (others =>'Z');
  end if;
end process p_MPMCDATAComb;

MPMCDATA         <= (others => 'H');
MPMCDATAIN       <= MPMCDATA;
HSELMPMC0G       <= HSEL0(7) or HSEL0(6) or HSEL0(5) or HSEL0(4) or HSEL0(3) or
                    HSEL0(2) or HSEL0(1) or HSEL0(0);
HSELMPMC1G       <= HSEL1(7) or HSEL1(6) or HSEL1(5) or HSEL1(4) or HSEL1(3) or
                    HSEL1(2) or HSEL1(1) or HSEL1(0);
HSELMPMC2G       <= HSEL2(7) or HSEL2(6) or HSEL2(5) or HSEL2(4) or HSEL2(3) or
                    HSEL2(2) or HSEL2(1) or HSEL2(0);
HSELMPMC3G       <= HSEL3(7) or HSEL3(6) or HSEL3(5) or HSEL3(4) or HSEL3(3) or
                    HSEL3(2) or HSEL3(1) or HSEL3(0);
DelMPMCCLKOUT    <= transport MPMCCLKOUT after 3 ns;
MPMCDQMBLS       <= MPMCDQMOUT and nMPMCBLSOUT;

-- -----------------------------------------------------------------------------
--  MPMCFBCLKIN Generation
-- -----------------------------------------------------------------------------
MPMCFBCLKIN0     <= MPMCCLKOUT(0) after MPMCCLKOUT_TO_MPMCFBCLKIN0_DELAY;
MPMCFBCLKIN1     <= MPMCCLKOUT(1) after MPMCCLKOUT_TO_MPMCFBCLKIN1_DELAY;
MPMCFBCLKIN2     <= MPMCCLKOUT(2) after MPMCCLKOUT_TO_MPMCFBCLKIN2_DELAY;
MPMCFBCLKIN3     <= MPMCCLKOUT(3) after MPMCCLKOUT_TO_MPMCFBCLKIN3_DELAY;

-- -----------------------------------------------------------------------------
-- AHB Slave Testbench_0 instantiation
-- -----------------------------------------------------------------------------
u0ahbslv_tb : ahbslave_tb
  generic map (
               INFILE                 =>
                                      "../../bustest/invec/infile0.bif",
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
            HCLK             => open,
            HRESETn          => open,
            HADDR            => HADDR0,
            HTRANS           => HTRANS0,
            HWRITE           => HWRITE0,
            HSIZE            => HSIZE0,
            HBURST           => HBURST0,
            HPROT            => HPROT0,
            HMASTER          => HMASTER0,
            HMASTLOCK        => HMASTLOCK0,
            HWDATA           => HWDATA0,
            HSPLIT           => HSPLIT0,
            HRDATA           => HRDATA0,
            HREADY           => HREADY0,
            HRESP            => HRESP0,
            VRG0             => VRG00,
            VRG1             => VRG01,
            VRG2             => VRG02,
            VRG3             => VRG03,
            VRG4             => VRG04,
            VRG5             => VRG05,
            VRG6             => VRG06,
            VRG7             => VRG07
           );

-- -----------------------------------------------------------------------------
-- AHB Slave Testbench_1 instantiation
-- -----------------------------------------------------------------------------
u1ahbslv_tb : ahbslave_tb
  generic map (
               INFILE                 =>
                                      "../../bustest/invec/infile1.bif",
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
            HCLK             => open,
            HRESETn          => open,
            HADDR            => HADDR1,
            HTRANS           => HTRANS1,
            HWRITE           => HWRITE1,
            HSIZE            => HSIZE1,
            HBURST           => HBURST1,
            HPROT            => HPROT1,
            HMASTER          => HMASTER1,
            HMASTLOCK        => HMASTLOCK1,
            HWDATA           => HWDATA1,
            HSPLIT           => HSPLIT1,
            HRDATA           => HRDATA1,
            HREADY           => HREADY1,
            HRESP            => HRESP1,
            VRG0             => VRG10,
            VRG1             => VRG11,
            VRG2             => VRG12,
            VRG3             => VRG13,
            VRG4             => VRG14,
            VRG5             => VRG15,
            VRG6             => VRG16,
            VRG7             => VRG17
           );

-- -----------------------------------------------------------------------------
-- AHB Slave Testbench_2 instantiation
-- -----------------------------------------------------------------------------
u2ahbslv_tb : ahbslave_tb
  generic map (
               INFILE                 =>
                                      "../../bustest/invec/infile2.bif",
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
            HCLK             => open,
            HRESETn          => open,
            HADDR            => HADDR2,
            HTRANS           => HTRANS2,
            HWRITE           => HWRITE2,
            HSIZE            => HSIZE2,
            HBURST           => HBURST2,
            HPROT            => HPROT2,
            HMASTER          => HMASTER2,
            HMASTLOCK        => HMASTLOCK2,
            HWDATA           => HWDATA2,
            HSPLIT           => HSPLIT2,
            HRDATA           => HRDATA2,
            HREADY           => HREADY2,
            HRESP            => HRESP2,
            VRG0             => VRG20,
            VRG1             => VRG21,
            VRG2             => VRG22,
            VRG3             => VRG23,
            VRG4             => VRG24,
            VRG5             => VRG25,
            VRG6             => VRG26,
            VRG7             => VRG27
           );

-- -----------------------------------------------------------------------------
-- AHB Slave Testbench_3 instantiation
-- -----------------------------------------------------------------------------
u3ahbslv_tb : ahbslave_tb
  generic map (
               INFILE                 =>
                                      "../../bustest/invec/infile3.bif",
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
            HADDR            => HADDR3,
            HTRANS           => HTRANS3,
            HWRITE           => HWRITE3,
            HSIZE            => HSIZE3,
            HBURST           => HBURST3,
            HPROT            => HPROT3,
            HMASTER          => HMASTER3,
            HMASTLOCK        => HMASTLOCK3,
            HWDATA           => HWDATA3,
            HSPLIT           => HSPLIT3,
            HRDATA           => HRDATA3,
            HREADY           => HREADY3,
            HRESP            => HRESP3,
            VRG0             => VRG30,
            VRG1             => VRG31,
            VRG2             => VRG32,
            VRG3             => VRG33,
            VRG4             => VRG34,
            VRG5             => VRG35,
            VRG6             => VRG36,
            VRG7             => VRG37
           );

-- -----------------------------------------------------------------------------
-- Address Decoder instantiation
-- -----------------------------------------------------------------------------
udecoder : decoder
  port map (
            HADDR            => HADDR3,
            HSEL             => HSEL3,
            DefSlaveSel      => DefSlaveSel3
           );

-- -----------------------------------------------------------------------------
-- Default Slave Instantiation for AHB Bus0
-- -----------------------------------------------------------------------------
u0Defslave : Defslave
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HSEL             => DefSlaveSel0,
            HTRANS           => HTRANS0(1),
            HRESP            => HRESPOutDef0,
            HREADYIn         => HREADY0,
            HREADYOut        => HREADYOutDef0,
            HRDATAOut        => HRDATAOutDef0
           );

-- -----------------------------------------------------------------------------
-- Default Slave Instantiation for AHB Bus1
-- -----------------------------------------------------------------------------
u1Defslave : Defslave
  port map (
            HCLK             => HCLK,
            HSEL             => DefSlaveSel1,
            HRESETn          => HRESETn,
            HTRANS           => HTRANS1(1),
            HRESP            => HRESPOutDef1,
            HREADYIn         => HREADY1,
            HREADYOut        => HREADYOutDef1,
            HRDATAOut        => HRDATAOutDef1
           );

-- -----------------------------------------------------------------------------
-- Default Slave Instantiation for AHB Bus2
-- -----------------------------------------------------------------------------
u2Defslave : Defslave
  port map (
            HCLK             => HCLK,
            HSEL             => DefSlaveSel2,
            HRESETn          => HRESETn,
            HTRANS           => HTRANS2(1),
            HRESP            => HRESPOutDef2,
            HREADYIn         => HREADY2,
            HREADYOut        => HREADYOutDef2,
            HRDATAOut        => HRDATAOutDef2
           );

-- -----------------------------------------------------------------------------
-- Default Slave Instantiation for AHB Bus3
-- -----------------------------------------------------------------------------
u3Defslave : Defslave
  port map (
            HCLK             => HCLK,
            HSEL             => DefSlaveSel3,
            HRESETn          => HRESETn,
            HTRANS           => HTRANS3(1),
            HRESP            => HRESPOutDef3,
            HREADYIn         => HREADY3,
            HREADYOut        => HREADYOutDef3,
            HRDATAOut        => HRDATAOutDef3
           );

-- -----------------------------------------------------------------------------
-- Master Buswatch Instantiation (AHB0)
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
             HTRANS           => HTRANS0,
             HADDR            => HADDR0,
             HSIZE            => HSIZE0,
             HBURST           => HBURST0,
             HBUSREQx         => HBUSREQ0,
             HGRANTx          => HGRANT0,
             HREADY           => HREADY0,
             HLOCKx           => HLOCK0,
             HWDATA           => HWDATA0,
             HPROT            => HPROT0,
             HWRITE           => HWRITE0,
             HRESP            => HRESP0,
             ResetOver        => OPEN
            );

-- -----------------------------------------------------------------------------
-- Master Buswatch Instantiation (AHB1)
-- -----------------------------------------------------------------------------
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
            HTRANS           => HTRANS1,
            HADDR            => HADDR1,
            HSIZE            => HSIZE1,
            HBURST           => HBURST1,
            HBUSREQx         => HBUSREQ1,
            HGRANTx          => HGRANT1,
            HREADY           => HREADY1,
            HLOCKx           => HLOCK1,
            HWDATA           => HWDATA1,
            HPROT            => HPROT1,
            HWRITE           => HWRITE1,
            HRESP            => HRESP1,
            ResetOver        => OPEN
           );

-- -----------------------------------------------------------------------------
-- Master Buswatch Instantiation (AHB2)
-- -----------------------------------------------------------------------------
u2buswatchmaster : buswatchmaster
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
            HTRANS           => HTRANS2,
            HADDR            => HADDR2,
            HSIZE            => HSIZE2,
            HBURST           => HBURST2,
            HBUSREQx         => HBUSREQ2,
            HGRANTx          => HGRANT2,
            HREADY           => HREADY2,
            HLOCKx           => HLOCK2,
            HWDATA           => HWDATA2,
            HPROT            => HPROT2,
            HWRITE           => HWRITE2,
            HRESP            => HRESP2,
            ResetOver        => OPEN
           );

-- -----------------------------------------------------------------------------
-- Master Buswatch Instantiation (AHB3)
-- -----------------------------------------------------------------------------
u3buswatchmaster : buswatchmaster
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
            HTRANS           => HTRANS3,
            HADDR            => HADDR3,
            HSIZE            => HSIZE3,
            HBURST           => HBURST3,
            HBUSREQx         => HBUSREQ3,
            HGRANTx          => HGRANT3,
            HREADY           => HREADY3,
            HLOCKx           => HLOCK3,
            HWDATA           => HWDATA3,
            HPROT            => HPROT3,
            HWRITE           => HWRITE3,
            HRESP            => HRESP3,
            ResetOver        => OPEN
           );

-- -----------------------------------------------------------------------------
-- Unit Under Test (MPMC)
-- -----------------------------------------------------------------------------
uut : Mpmc
  port map (
            HCLK             => HCLK,
            MPMCCLK          => MPMCCLK,
            MPMCCLKDELAY     => MPMCCLKDELAY,
            HRESETn          => HRESETn,
            nPOR             => nPOR,
            MPMCFBCLKIN0     => MPMCFBCLKIN0,
            MPMCFBCLKIN1     => MPMCFBCLKIN1,
            MPMCFBCLKIN2     => MPMCFBCLKIN2,
            MPMCFBCLKIN3     => MPMCFBCLKIN3,
            HWRITE0          => HWRITE0,
            HTRANS0          => HTRANS0,
            HSIZE0           => HSIZE0,
            HBURST0          => HBURST0,
            HREADYIN0        => HREADY0,
            HSELMPMC0G       => HSELMPMC0G,
            HSELMPMC0CS      => HSEL0(7 downto 0),
            HMASTLOCK0       => HMASTLOCK0,
            HADDR0           => HADDR0(27 downto 0),
            HWDATA0          => HWDATA0(31 downto 0),
            HWRITE1          => HWRITE1,
            HTRANS1          => HTRANS1,
            HSIZE1           => HSIZE1,
            HBURST1          => HBURST1,
            HREADYIN1        => HREADY1,
            HSELMPMC1G       => HSELMPMC1G,
            HSELMPMC1CS      => HSEL1(7 downto 0),
            HMASTLOCK1       => HMASTLOCK1,
            HADDR1           => HADDR1(27 downto 0),
            HWDATA1          => HWDATA1(31 downto 0),
            HWRITE2          => HWRITE2,
            HTRANS2          => HTRANS2,
            HSIZE2           => HSIZE2,
            HBURST2          => HBURST2,
            HREADYIN2        => HREADY2,
            HSELMPMC2G       => HSELMPMC2G,
            HSELMPMC2CS      => HSEL2(7 downto 0),
            HMASTLOCK2       => HMASTLOCK2,
            HADDR2           => HADDR2(27 downto 0),
            HWDATA2          => HWDATA2(31 downto 0),
            HWRITE3          => HWRITE3,
            HTRANS3          => HTRANS3,
            HSIZE3           => HSIZE3,
            HBURST3          => HBURST3,
            HREADYIN3        => HREADY3,
            HSELMPMC3G       => HSELMPMC3G,
            HSELMPMC3CS      => HSEL3(7 downto 0),
            HMASTLOCK3       => HMASTLOCK3,
            HADDR3           => HADDR3(27 downto 0),
            HWDATA3          => HWDATA3(31 downto 0),
            HWRITEREG        => HWRITE3,
            HTRANSREG        => HTRANS3(1),
            HSIZEREG         => HSIZE3,
            HREADYINREG      => HREADY3,
            HSELMPMCREG      => HSEL3(8),
            HADDRREG         => HADDR3(11 downto 2),
            HWDATAREG15TO0   => HWDATA3(15 downto 0),
            HWDATAREG20TO19  => HWDATA3(20 downto 19),
            HRDATATIC        => HRDATATIC,
            HREADYINTIC      => HREADYINTIC,
            HGRANTTIC        => HGRANTTIC,
            HRESPTIC         => HRESPTIC,
            MPMCTESTIN       => MPMCTESTIN,
            MPMCDATAIN       => MPMCDATAIN,
            MPMCSREFREQ      => MPMCSREFREQ,
            MPMCBIGENDIAN    => MPMCBIGENDIAN,
            MPMCSTCS1MW      => MPMCSTCS1MW,
            MPMCSTCS0POL     => MPMCSTCS0POL,
            MPMCSTCS1POL     => MPMCSTCS1POL,
            MPMCSTCS2POL     => MPMCSTCS2POL,
            MPMCSTCS3POL     => MPMCSTCS3POL,
            MPMCSTCS1PB      => MPMCSTCS1PB,
            MPMCREL1CONFIG   => MPMCREL1CONFIG,
            MPMCTESTREQA     => MPMCTESTREQA,
            MPMCTESTREQB     => MPMCTESTREQB,
            SCANINHCLK       => SCANINHCLK,
            SCANINMPMCCLK    => SCANINMPMCCLK,
            SCANINCLKDELAY   => SCANINCLKDELAY,
            SCANINFBCLKIN0   => SCANINFBCLKIN0,
            SCANINFBCLKIN1   => SCANINFBCLKIN1,
            SCANINFBCLKIN2   => SCANINFBCLKIN2,
            SCANINFBCLKIN3   => SCANINFBCLKIN3,
            SCANENABLE       => SCANENABLE,
            HREADYOUT0       => HREADYOutMpmc0,
            HRESP0           => HRESPOutMpmc0,
            HRDATA0          => HRDATAOutMpmc0(31 downto 0),
            HREADYOUT1       => HREADYOutMpmc1,
            HRESP1           => HRESPOutMpmc1,
            HRDATA1          => HRDATAOutMpmc1(31 downto 0),
            HREADYOUT2       => HREADYOutMpmc2,
            HRESP2           => HRESPOutMpmc2,
            HRDATA2          => HRDATAOutMpmc2(31 downto 0),
            HREADYOUT3       => HREADYOutMpmc3,
            HRESP3           => HRESPOutMpmc3,
            HRDATA3          => HRDATAOutMpmc3(31 downto 0),
            HREADYOUTREG     => HREADYOutMCReg,
            HRESPREG         => HRESPOutMCReg,
            HRDATAREG        => HRDATAOutMCReg(20 downto 0),
            HWRITETIC        => HWRITETIC,
            HTRANSTIC        => HTRANSTIC,
            HSIZETIC         => HSIZETIC,
            HBURSTTIC        => HBURSTTIC,
            HLOCKTIC         => HLOCKTIC,
            HPROTTIC         => HPROTTIC,
            HBUSREQTIC       => HBUSREQTIC,
            HADDRTIC         => HADDRTIC,
            HWDATATIC        => HWDATATIC,
            MPMCCLKOUT       => MPMCCLKOUT,
            MPMCCKEOUT       => MPMCCKEOUT,
            MPMCDQMOUT       => MPMCDQMOUT,
            nMPMCBLSOUT      => nMPMCBLSOUT,
            nMPMCRASOUT      => nMPMCRASOUT,
            nMPMCCASOUT      => nMPMCCASOUT,
            nMPMCOEOUT       => nMPMCOEOUT,
            nMPMCWEOUT       => nMPMCWEOUT,
            nMPMCSTCSOUT     => nMPMCSTCSOUT,
            nMPMCDYCSOUT     => nMPMCDYCSOUT,
            MPMCADDROUT      => MPMCADDROUT,
            MPMCDATAOUT      => MPMCDATAOUT,
            nMPMCRPOUT       => nMPMCRPOUT,
            MPMCRPVHHOUT     => MPMCRPVHHOUT,
            nMPMCDATAEN      => nMPMCDATAEN,
            MPMCSREFACK      => MPMCSREFACK,
            MPMCEBIREQ       => MPMCEBIREQ,
            MPMCEBIGNT       => MPMCEBIGNT,
            MPMCEBIBACKOFF   => MPMCEBIBACKOFF,
            SCANOUTHCLK      => SCANOUTHCLK,
            SCANOUTMPMCCLK   => SCANOUTMPMCCLK,
            SCANOUTCLKDELAY  => SCANOUTCLKDELAY,
            SCANOUTFBCLKIN0  => SCANOUTFBCLKIN0,
            SCANOUTFBCLKIN1  => SCANOUTFBCLKIN1,
            SCANOUTFBCLKIN2  => SCANOUTFBCLKIN2,
            SCANOUTFBCLKIN3  => SCANOUTFBCLKIN3
           );

-- -----------------------------------------------------------------------------
-- MPMC Trickbox
-- -----------------------------------------------------------------------------
uMpmcTrick : MpmcTrick
  generic map (
               Tclkl            => Tclkl,
               Tclkh            => Tclkh,
               Tclks            => Tclks
              )
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HADDR0           => HADDR0(11 downto 2),
            HADDR1           => HADDR1(11 downto 2),
            HADDR2           => HADDR2(11 downto 2),
            HADDR3           => HADDR3(11 downto 2),
            HTRANS0          => HTRANS0,
            HTRANS1          => HTRANS1,
            HTRANS2          => HTRANS2,
            HTRANS3          => HTRANS3,
            HWRITE0          => HWRITE0,
            HWRITE1          => HWRITE1,
            HWRITE2          => HWRITE2,
            HWRITE3          => HWRITE3,
            HSIZE0           => HSIZE0,
            HSIZE1           => HSIZE1,
            HSIZE2           => HSIZE2,
            HSIZE3           => HSIZE3,
            HBURST0          => HBURST0,
            HBURST1          => HBURST1,
            HBURST2          => HBURST2,
            HBURST3          => HBURST3,
            HREADYIN0        => HREADY0,
            HREADYIN1        => HREADY1,
            HREADYIN2        => HREADY2,
            HREADYIN3        => HREADY3,
            HWDATA0          => HWDATA0(31 downto 0),
            HWDATA1          => HWDATA1(31 downto 0),
            HWDATA2          => HWDATA2(31 downto 0),
            HWDATA3          => HWDATA3(31 downto 0),
            HSELMPMCTR0      => HSEL0(8),
            HSELMPMCTR1      => HSEL1(8),
            HSELMPMCTR2      => HSEL2(8),
            HSELMPMCTR3      => HSEL3(9),
            HSELMPMCREG      => HSEL3(8),
            MPMCCLKOUT       => MPMCCLKOUT,
            MPMCCKEOUT       => MPMCCKEOUT,
            nMPMCRASOUT      => nMPMCRASOUT,
            nMPMCCASOUT      => nMPMCCASOUT,
            nMPMCDYCSOUT     => nMPMCDYCSOUT,
            nMPMCSTCSOUT     => nMPMCSTCSOUT,
            MPMCACTLOWCS     => nMPMCSTCSOUT,
            nMPMCWEOUT       => nMPMCWEOUT,
            nMPMCDATAEN      => nMPMCDATAEN,
            nMPMCOEOUT       => nMPMCOEOUT,
            MPMCDQMOUT       => MPMCDQMBLS,
            nMPMCRPOUT       => nMPMCRPOUT,
            MPMCRPVHHOUT     => MPMCRPVHHOUT,
            MPMCSREFACK      => MPMCSREFACK,
            HREADYOutMpmc0   => HREADYOutMpmc0,
            HREADYOutMpmc1   => HREADYOutMpmc1,
            MPMCADDROUT      => MPMCADDROUT,
            MPMCDATAIN       => MPMCDATAIN,
            MPMCDATAOUT      => MPMCDATAOUT,

            HREADYOUT0       => HREADYOutMCTr0,
            HREADYOUT1       => HREADYOutMCTr1,
            HREADYOUT2       => HREADYOutMCTr2,
            HREADYOUT3       => HREADYOutMCTr3,
            HRESP0           => HRESPOutMCTr0,
            HRESP1           => HRESPOutMCTr1,
            HRESP2           => HRESPOutMCTr2,
            HRESP3           => HRESPOutMCTr3,
            MPMCCLK          => MPMCCLK,
            MPMCCLKDELAY     => MPMCCLKDELAY,
            nPOR             => nPOR,
            MPMCSREFREQ      => MPMCSREFREQ,
            MPMCBIGENDIAN    => MPMCBIGENDIAN,
            MPMCSTCS0POL     => MPMCSTCS0POL,
            MPMCSTCS1POL     => MPMCSTCS1POL,
            MPMCSTCS2POL     => MPMCSTCS2POL,
            MPMCSTCS3POL     => MPMCSTCS3POL,
            MPMCSTCS1PB      => MPMCSTCS1PB,
            MPMCSTCS1MW      => MPMCSTCS1MW,
            MPMCEBIREQ       => MPMCEBIREQ,
            MPMCEBIGNT       => MPMCEBIGNT,
            MPMCEBIBACKOFF   => MPMCEBIBACKOFF,
            HRDATA0          => HRDATAOutMCTr0(31 downto 0),
            HRDATA1          => HRDATAOutMCTr1(31 downto 0),
            HRDATA2          => HRDATAOutMCTr2(31 downto 0),
            HRDATA3          => HRDATAOutMCTr3(31 downto 0)
           );

-- -----------------------------------------------------------------------------
-- Denali Models Instantiations
-- -----------------------------------------------------------------------------
uk6r1016v1c_15 : k6r1016v1c_15
  generic map (
               memory_spec => "../../denali/k6r1016v1c_15.soma",
               init_file   => "../../denali/k6r1016v1c_15.dat"
              )
  port map (
            a                => MPMCADDROUT(15 downto 0),
            webar            => nMPMCWEOUT,
            csbar            => nMPMCSTCSOUT(0),
            oebar            => nMPMCOEOUT,
            bebar            => nMPMCBLSOUT(1 downto 0),
            io               => MPMCDATA(15 downto 0)
           );

uInt28f800f3b95: Int28f800f3b95
  generic map (
               memory_spec => "../../denali/Int28f800f3b95.soma",
               init_file   => "../../denali/Int28f800f3b95.dat"
              )
  port map (
            a                => MPMCADDROUT(18 downto 0),
            dq               => MPMCDATA(15 downto 0),
            cebar            => nMPMCSTCSOUT(1),
            oebar            => nMPMCOEOUT,
            webar            => nMPMCWEOUT,
            wpbar            => nWP,
            rstbar           => nRST,
            clk              => CLK,
            advbar           => nADV,
            waitbar          => nWAIT
           );

uk3n9vu1000m : k3n9vu1000m
  generic map (
               memory_spec => "../../denali/k3n9vu1000m.soma",
               init_file   => "../../denali/k3n9vu1000m.dat"
              )
  port map (
            a                => MPMCADDROUT(22 downto 0),
            cebar            => nMPMCSTCSOUT(2),
            oebar            => nMPMCOEOUT,
            q                => MPMCDATA(15 downto 0),
            bhe              => BHE
           );

uInt28f800f3b115 : Int28f800f3b115
  generic map (
               memory_spec => "../../denali/Int28f800f3b115.soma",
               init_file   => "../../denali/Int28f800f3b115.dat"
              )
  port map (
            a                => MPMCADDROUT(18 downto 0),
            dq               => MPMCDATA(15 downto 0),
            cebar            => nMPMCSTCSOUT(3),
            oebar            => nMPMCOEOUT,
            webar            => nMPMCWEOUT,
            wpbar            => nWP,
            rstbar           => nRST,
            clk              => CLK,
            advbar           => nADV,
            waitbar          => nWAIT
           );

u0k4s561632a_75 : k4s561632a_75
  generic map (
               memory_spec => "../../denali/k4s561632a_75.soma",
               init_file   => "../../denali/k4s561632a_75.dat"
              )
  port map (
            a                => MPMCADDROUT(12 downto 0),
            rasbar           => nMPMCRASOUT,
            casbar           => nMPMCCASOUT,
            webar            => nMPMCWEOUT,
            csbar            => nMPMCDYCSOUT(0),
            dqm              => MPMCDQMOUT(1 downto 0),
            clk              => DelMPMCCLKOUT(0),
            cke              => MPMCCKEOUT(1),
            dq               => MPMCDATA(15 downto 0),
            ba               => MPMCADDROUT(14 downto 13)
           );

u1k4s561632a_75 : k4s561632a_75
  generic map (
               memory_spec => "../../denali/k4s561632a_75.soma",
               init_file   => "../../denali/k4s561632a_75.dat"
              )
  port map (
            a                => MPMCADDROUT(12 downto 0),
            rasbar           => nMPMCRASOUT,
            casbar           => nMPMCCASOUT,
            webar            => nMPMCWEOUT,
            csbar            => nMPMCDYCSOUT(0),
            dqm              => MPMCDQMOUT(3 downto 2),
            clk              => DelMPMCCLKOUT(0),
            cke              => MPMCCKEOUT(1),
            dq               => MPMCDATA(31 downto 16),
            ba               => MPMCADDROUT(14 downto 13)
           );

u0mt48lc32m16a2_75 : mt48lc32m16a2_75
  generic map (
               memory_spec => "../../denali/mt48lc32m16a2_75.soma",
               init_file   => "../../denali/mt48lc32m16a2_75.dat"
              )
  port map (
            a                => MPMCADDROUT(12 downto 0),
            rasbar           => nMPMCRASOUT,
            casbar           => nMPMCCASOUT,
            webar            => nMPMCWEOUT,
            csbar            => nMPMCDYCSOUT(1),
            dqm              => MPMCDQMOUT(1 downto 0),
            clk              => DelMPMCCLKOUT(1),
            cke              => MPMCCKEOUT(1),
            dq               => MPMCDATA(15 downto 0),
            ba               => MPMCADDROUT(14 downto 13)
           );

u1mt48lc32m16a2_75 : mt48lc32m16a2_75
  generic map (
               memory_spec => "../../denali/mt48lc32m16a2_75.soma",
               init_file   => "../../denali/mt48lc32m16a2_75.dat"
              )
  port map (
            a                => MPMCADDROUT(12 downto 0),
            rasbar           => nMPMCRASOUT,
            casbar           => nMPMCCASOUT,
            webar            => nMPMCWEOUT,
            csbar            => nMPMCDYCSOUT(1),
            dqm              => MPMCDQMOUT(3 downto 2),
            clk              => DelMPMCCLKOUT(1),
            cke              => MPMCCKEOUT(1),
            dq               => MPMCDATA(31 downto 16),
            ba               => MPMCADDROUT(14 downto 13)
           );

umt48lc1m16a1_6s : mt48lc1m16a1_6s
  generic map (
               memory_spec => "../../denali/mt48lc1m16a1_6s.soma",
               init_file   => "../../denali/mt48lc1m16a1_6s.dat"
              )
  port map (
            a                => MPMCADDROUT(10 downto 0),
            rasbar           => nMPMCRASOUT,
            casbar           => nMPMCCASOUT,
            webar            => nMPMCWEOUT,
            csbar            => nMPMCDYCSOUT(2),
            dqm              => MPMCDQMOUT(1 downto 0),
            clk              => DelMPMCCLKOUT(2),
            cke              => MPMCCKEOUT(2),
            ba               => MPMCADDROUT(14),
            dq               => MPMCDATA(15 downto 0)
           );

umt28s4m16lc_12 : mt28s4m16lc_12
  generic map (
               memory_spec => "../../denali/mt28s4m16lc_12.soma",
               init_file   => "../../denali/mt28s4m16lc_12.dat"
              )
  port map (
            clk              => DelMPMCCLKOUT(3),
            cke              => MPMCCKEOUT(3),
            csbar            => nMPMCDYCSOUT(3),
            rasbar           => nMPMCRASOUT,
            casbar           => nMPMCCASOUT,
            webar            => nMPMCWEOUT,
            dqm              => MPMCDQMOUT(1 downto 0),
            address          => MPMCADDROUT(11 downto 0),
            data             => MPMCDATA(15 downto 0),
            rpbar            => nMPMCRPOUT,
            ba               => MPMCADDROUT(14 downto 13)
           );

u0BWMonitor : BWMonitor
  port map (
             CLK          => HCLK,
             nCS          => nMPMCDYCSOUT,
             nRAS         => nMPMCRASOUT,
             nCAS         => nMPMCCASOUT,
             nWE          => nMPMCWEOUT,
             DQM          => MPMCDQMOUT,
             Addr         => MPMCADDROUT

           );

u0LatencyMonitor : LatencyMonitor
generic map(
    ID => "AHB0"      -- AHB identity tag
    )
  port map (
             HCLK         => HCLK, 
             HRESETn      => HRESETn, 
             HWRITE       => HWRITE0, 
             HTRANS       => HTRANS0, 
             HSIZE        => HSIZE0, 
             HBURST       => HBURST0, 
             HSEL         => HSELMPMC0G, 
             HMASTLOCK    => HMASTLOCK0, 
             HADDR        => HADDR0, 
             HWDATA       => HWDATA0(31 downto 0), 
             HREADY       => HREADY0 
           );

u1LatencyMonitor : LatencyMonitor
generic map (
    ID => "AHB1"      -- AHB identity tag
    )
  port map (
             HCLK         => HCLK, 
             HRESETn      => HRESETn, 
             HWRITE       => HWRITE1, 
             HTRANS       => HTRANS1, 
             HSIZE        => HSIZE1, 
             HBURST       => HBURST1, 
             HSEL         => HSELMPMC1G, 
             HMASTLOCK    => HMASTLOCK1, 
             HADDR        => HADDR1, 
             HWDATA       => HWDATA1(31 downto 0), 
             HREADY       => HREADY1 
           );

u2LatencyMonitor : LatencyMonitor
generic map (
    ID => "AHB2"      -- AHB identity tag
    )
  port map (
             HCLK         => HCLK, 
             HRESETn      => HRESETn, 
             HWRITE       => HWRITE2, 
             HTRANS       => HTRANS2, 
             HSIZE        => HSIZE2, 
             HBURST       => HBURST2, 
             HSEL         => HSELMPMC2G, 
             HMASTLOCK    => HMASTLOCK2, 
             HADDR        => HADDR2, 
             HWDATA       => HWDATA2(31 downto 0), 
             HREADY       => HREADY2 
           );

u3LatencyMonitor : LatencyMonitor
generic map (
    ID => "AHB3"      -- AHB identity tag
    )
  port map (
             HCLK         => HCLK, 
             HRESETn      => HRESETn, 
             HWRITE       => HWRITE3, 
             HTRANS       => HTRANS3, 
             HSIZE        => HSIZE3, 
             HBURST       => HBURST3, 
             HSEL         => HSELMPMC3G, 
             HMASTLOCK    => HMASTLOCK3, 
             HADDR        => HADDR3, 
             HWDATA       => HWDATA3(31 downto 0), 
             HREADY       => HREADY3 
           );
end behavioural;

-- --================================ End ====================================--
