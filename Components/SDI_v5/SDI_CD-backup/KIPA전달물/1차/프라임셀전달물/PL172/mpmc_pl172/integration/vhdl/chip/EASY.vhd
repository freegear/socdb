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
-- File Name              : EASY.vhd.rca
-- File Revision          : 1.6
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Structural architecture of Example Amba SYstem (EASY)
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

library sys;
use sys.all;

library trickbox;
use trickbox.all;

library uut;
use uut.all;

library chip;
use chip.all;
use chip.timing.all;
use chip.timingmaster.all;
use chip.defsmaster.all;

entity EASY is
  port (
-- Inputs
        XCLKIN           : in    std_logic; -- External clock in
        nReset           : in    std_logic; -- Power on reset input
        TESTREQA         : in    std_logic; -- Test bus request A
        TESTREQB         : in    std_logic; -- Test bus request B
        nTRST            : in    std_logic; -- JTAG connections
        TCK              : in    std_logic;
        TDI              : in    std_logic;
        TMS              : in    std_logic;

-- Inouts
        XD               : inout std_logic_vector(31 downto 0);
                                            -- External data bus

-- Outputs
        XA               : out   std_logic_vector(30 downto 0);
                                            -- External address bus
        XCSN             : out   std_logic_vector(3 downto 0);
                                            -- External chip select
        XOEN             : out   std_logic; -- External output enable
        XWEN             : out   std_logic_vector(3 downto 0);
                                            -- External write enable

        TESTACK          : out   std_logic; -- Test acknowledge

        TDO              : out   std_logic
       );
end EASY;

architecture structural of EASY is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- The AHB to APB bridge
-- -----------------------------------------------------------------------------
component APBif
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HADDR            : in    std_logic_vector(31 downto 0);
        HTRANS           : in    std_logic_vector(1 downto 0);
        HWRITE           : in    std_logic;
        HWDATA           : in    std_logic_vector(31 downto 0);
        HSELAPBif        : in    std_logic;
        HREADYin         : in    std_logic;

        HRDATA           : out   std_logic_vector(31 downto 0);
        HREADYout        : out   std_logic;
        HRESP            : out   std_logic_vector(1 downto 0);

        PRDATA           : in    std_logic_vector(31 downto 0);

        PWDATA           : out   std_logic_vector(31 downto 0);
        PENABLE          : out   std_logic;
        PSELIC           : out   std_logic;
        PSELUUT          : out   std_logic;
        PSELRPC          : out   std_logic;
        PADDR            : out   std_logic_vector(31 downto 0);
        PWRITE           : out   std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- The AHB system arbiter
-- -----------------------------------------------------------------------------
component Arbiter
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HTRANS           : in    std_logic_vector(1 downto 0);
        HBURST           : in    std_logic_vector(2 downto 0);
        HREADY           : in    std_logic;
        HRESP            : in    std_logic_vector(1 downto 0);

        HBUSREQarm       : in    std_logic;
        HBUSREQtic       : in    std_logic;
        HBUSREQ003       : in    std_logic;
        HBUSREQ004       : in    std_logic;

        HLOCKarm         : in    std_logic;

        HLOCKtic         : in    std_logic;
        HLOCK003         : in    std_logic;
        HLOCK004         : in    std_logic;

        HSPLIT           : in    std_logic_vector(15 downto 0);

        Pause            : in    std_logic;

        HGRANTarm        : out   std_logic;
        HGRANTtic        : out   std_logic;
        HGRANT003        : out   std_logic;
        HGRANT004        : out   std_logic;

        HMASTER          : out   std_logic_vector(3 downto 0);
        HMASTLOCK        : out   std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- The system address Decoder
-- -----------------------------------------------------------------------------
component Decoder
  port (
        HRESETn          : in    std_logic;
        HADDR            : in    std_logic_vector(31 downto 0);

        Remap            : in    std_logic;

        HSELIntMem       : out   std_logic;
        HSELExtMem       : out   std_logic;
        HSELUUT          : out   std_logic;
        HSELAPBif        : out   std_logic;
        HSELArmTest      : out   std_logic;
        HSELDefault      : out   std_logic
       );
  end component;

-- -----------------------------------------------------------------------------
-- The Default Slave
-- -----------------------------------------------------------------------------
component DefaultSlave
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HTRANS           : in    std_logic_vector(1 downto 0);
        HSELDefault      : in    std_logic;
        HREADYin         : in    std_logic;

        HREADYout        : out   std_logic;
        HRESP            : out   std_logic_vector(1 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- Central multiplexer - masters to slaves
-- Also generates the default master outputs when no other masters
-- are selected
-- -----------------------------------------------------------------------------
component MuxM2S
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HMASTER          : in    std_logic_vector(3 downto 0);
        HREADY           : in    std_logic;

        HADDRarm         : in    std_logic_vector(31 downto 0);
        HTRANSarm        : in    std_logic_vector(1 downto 0);
        HWRITEarm        : in    std_logic;
        HSIZEarm         : in    std_logic_vector(2 downto 0);
        HBURSTarm        : in    std_logic_vector(2 downto 0);
        HPROTarm         : in    std_logic_vector(3 downto 0);
        HWDATAarm        : in    std_logic_vector(31 downto 0);

        HADDRtic         : in    std_logic_vector(31 downto 0);
        HTRANStic        : in    std_logic_vector(1 downto 0);
        HWRITEtic        : in    std_logic;
        HSIZEtic         : in    std_logic_vector(2 downto 0);
        HBURSTtic        : in    std_logic_vector(2 downto 0);
        HPROTtic         : in    std_logic_vector(3 downto 0);
        HWDATAtic        : in    std_logic_vector(31 downto 0);

        HADDR003         : in    std_logic_vector(31 downto 0);
        HTRANS003        : in    std_logic_vector(1 downto 0);
        HWRITE003        : in    std_logic;
        HSIZE003         : in    std_logic_vector(2 downto 0);
        HBURST003        : in    std_logic_vector(2 downto 0);
        HPROT003         : in    std_logic_vector(3 downto 0);
        HWDATA003        : in    std_logic_vector(31 downto 0);

        HADDR004         : in    std_logic_vector(31 downto 0);
        HTRANS004        : in    std_logic_vector(1 downto 0);
        HWRITE004        : in    std_logic;
        HSIZE004         : in    std_logic_vector(2 downto 0);
        HBURST004        : in    std_logic_vector(2 downto 0);
        HPROT004         : in    std_logic_vector(3 downto 0);
        HWDATA004        : in    std_logic_vector(31 downto 0);

        HADDR            : out   std_logic_vector(31 downto 0);
        HTRANS           : out   std_logic_vector(1 downto 0);
        HWRITE           : out   std_logic;
        HSIZE            : out   std_logic_vector(2 downto 0);
        HBURST           : out   std_logic_vector(2 downto 0);
        HPROT            : out   std_logic_vector(3 downto 0);
        HWDATA           : out   std_logic_vector(31 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- Central multiplexer - slaves to masters
-- -----------------------------------------------------------------------------
component MuxS2M
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HSELIntMem       : in    std_logic;
        HSELExtMem       : in    std_logic;
        HSELUUT          : in    std_logic;
        HSELAPBif        : in    std_logic;
        HSELArmTest      : in    std_logic;

        HRDATAIntMem     : in    std_logic_vector(31 downto 0);
        HREADYIntMem     : in    std_logic;
        HRESPIntMem      : in    std_logic_vector(1 downto 0);

        HRDATAExtMem     : in    std_logic_vector(31 downto 0);
        HREADYExtMem     : in    std_logic;
        HRESPExtMem      : in    std_logic_vector(1 downto 0);

        HRDATAUUT        : in    std_logic_vector(31 downto 0);
        HREADYUUT        : in    std_logic;
        HRESPUUT         : in    std_logic_vector(1 downto 0);

        HRDATAAPBif      : in    std_logic_vector(31 downto 0);
        HREADYAPBif      : in    std_logic;
        HRESPAPBif       : in    std_logic_vector(1 downto 0);

        HRDATAArmTest    : in    std_logic_vector(31 downto 0);
        HREADYArmTest    : in    std_logic;
        HRESPArmTest     : in    std_logic_vector(1 downto 0);

        HREADYDefault    : in    std_logic;
        HRESPDefault     : in    std_logic_vector(1 downto 0);

        HRDATA           : out   std_logic_vector(31 downto 0);
        HREADY           : out   std_logic;
        HRESP            : out   std_logic_vector(1 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- The bus reset controller
-- -----------------------------------------------------------------------------
component ResCntl
  port (
        HCLK             : in    std_logic;
        POReset          : in    std_logic;
        HRESETn          : out   std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- The AMBA peripheral bus bridge, the reset controller and
-- the APB UUT.
-- -----------------------------------------------------------------------------
component RPS
  port (
        PCLK             : in    std_logic;
        PRESETn          : in    std_logic;
        Pause            : out   std_logic;
        Remap            : out   std_logic;

        PSELRPC          : in    std_logic;
        PSELUUT          : in    std_logic;

        PENABLE          : in    std_logic;
        PADDR            : in    std_logic_vector(31 downto 0);
        PWRITE           : in    std_logic;
        PWDATA           : in    std_logic_vector(31 downto 0);
        PRDATA           : out   std_logic_vector(31 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- An example External Bus Interface
-- -----------------------------------------------------------------------------
component SMI
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HADDR            : in    std_logic_vector(31 downto 0);
        HTRANS           : in    std_logic_vector(1 downto 0);
        HWRITE           : in    std_logic;
        HSIZE            : in    std_logic_vector(2 downto 0);
        HWDATAin         : in    std_logic_vector(31 downto 0);
        HSELExtMem       : in    std_logic;
        HRDATAin         : in    std_logic_vector(31 downto 0);
        HREADYin         : in    std_logic;

        HRDATAout        : out   std_logic_vector(31 downto 0);
        HREADYout        : out   std_logic;
        HRESP            : out   std_logic_vector(1 downto 0);

        Remap            : in    std_logic;
        TicRead          : in    std_logic;

        XD               : inout std_logic_vector(31 downto 0);

        XA               : out   std_logic_vector(30 downto 0);
        XCSN             : out   std_logic_vector(3 downto 0);
        XOEN             : out   std_logic;
        XWEN             : out   std_logic_vector(3 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- TIC Master Watcher
-- -----------------------------------------------------------------------------
component TicWatcher
  port (
        TCLK             : in    std_logic;
        RESETn           : in    std_logic;
        TESTREQA         : in    std_logic;
        TESTREQB         : in    std_logic;
        TESTACK          : in    std_logic;
        TESTBUS          : in    std_logic_vector(31 downto 0);

        HADDRTIC         : in    std_logic_vector(31 downto 0);
        HWRITETIC        : in    std_logic;
        HTRANSTIC        : in    std_logic_vector(1 downto 0);
        HSIZETIC         : in    std_logic_vector(2 downto 0);
        HBURSTTIC        : in    std_logic_vector(2 downto 0);
        HPROTTIC         : in    std_logic_vector(3 downto 0);
        HWDATATIC        : in    std_logic_vector(31 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- Master Bus Watcher Module
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
-- Inputs
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HTRANS           : in    T_trans;
        HADDR            : in    T_addr;
        HSIZE            : in    T_size;
        HBURST           : in    T_burst;
        HBUSREQx         : in    std_logic;
        HGRANTx          : in    std_logic;
        HREADY           : in    T_line;
        HLOCKx           : in    T_line;
        HWDATA           : in    T_data;
        HPROT            : in    T_prot;
        HWRITE           : in    T_line;
        HRESP            : in    T_resp;
-- Outputs
        ResetOver        : out   boolean
       );
end component;

-- -----------------------------------------------------------------------------
-- Generic AHB Slave
-- -----------------------------------------------------------------------------
component AhbSlave
  generic (
           tclkl       : time;
           tclkh       : time;
           tovrdy      : time;
           tohrdy      : time;
           tovrsp      : time;
           tohrsp      : time;
           tovsplt     : time;
           tohsplt     : time;
           tovdr       : time;
           tohdr       : time
          );
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HADDR            : in    std_logic_vector(31 downto 0);
        HTRANS           : in    std_logic_vector(1 downto 0);
        HWRITE           : in    std_logic;
        HSIZE            : in    std_logic_vector(2 downto 0);
        HBURST           : in    std_logic_vector(2 downto 0);
        HWDATA           : in    std_logic_vector(63 downto 0);
        HRDATAIn         : in    std_logic_vector(63 downto 0);
        HREADYIn         : in    std_logic;
        HSPLITIn         : in    std_logic_vector(15 downto 0);
        HSEL             : in    std_logic;
        HMASTER          : in    std_logic_vector(3 downto 0);
        HMASTLOCK        : in    std_logic;
        HRESPIn          : in    std_logic_vector(1 downto 0);
        HRDATAdly        : out   std_logic_vector(63 downto 0);
        HREADYdly        : out   std_logic;
        HRESPdly         : out   std_logic_vector(1 downto 0);
        HSPLITdly        : out   std_logic_vector(15 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- MPMC and the TIC Module
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
        MPMCEBIGNT       : in    std_logic;
        MPMCEBIBACKOFF   : in    std_logic;
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
        nMPMCRASOUT      : out   std_logic;
        nMPMCCASOUT      : out   std_logic;
        nMPMCOEOUT       : out   std_logic;
        nMPMCWEOUT       : out   std_logic;
        nMPMCSTCSOUT     : out   std_logic_vector(3 downto 0);
        nMPMCDYCSOUT     : out   std_logic_vector(3 downto 0);
        MPMCADDROUT      : out   std_logic_vector(27 downto 0);
        MPMCDATAOUT      : out   std_logic_vector(31 downto 0);
        nMPMCRPOUT       : out   std_logic;
        nMPMCDATAEN      : out   std_logic_vector(3 downto 0);
        MPMCSREFACK      : out   std_logic;
        MPMCEBIREQ       : out   std_logic;
        SCANOUTHCLK      : out   std_logic;
        SCANOUTMPMCCLK   : out   std_logic;
        SCANOUTCLKDELAY  : out   std_logic;
        SCANOUTFBCLKIN0  : out   std_logic;
        SCANOUTFBCLKIN1  : out   std_logic;
        SCANOUTFBCLKIN2  : out   std_logic;
        SCANOUTFBCLKIN3  : out   std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal IntHSel          : std_logic_vector(1 downto 0);
signal DelHSel          : std_logic_vector(1 downto 0);

-- AHB Signals
signal HCLK             : std_logic;
signal HRESETn          : std_logic;
signal HTRANS           : std_logic_vector(1 downto 0);

signal HADDR            : std_logic_vector(31 downto 0);
signal HWRITE           : std_logic;
signal HSIZE            : std_logic_vector(2 downto 0);
signal HBURST           : std_logic_vector(2 downto 0);
signal HPROT            : std_logic_vector(3 downto 0);
signal HWDATA           : std_logic_vector(31 downto 0);
signal HMASTER          : std_logic_vector(3 downto 0);
signal HMASTLOCK        : std_logic;
signal HSPLIT           : std_logic_vector(15 downto 0);

-- Multiplexed slave output signals
signal HRDATA           : std_logic_vector(31 downto 0);
signal HREADY           : std_logic;
signal HRESP            : std_logic_vector(1 downto 0);

-- Open inputs for the AHB Slave ports of the MPMC
signal HWDATAREG20TO19  : std_logic_vector(20 downto 19);
signal HWDATAREG15TO0   : std_logic_vector(15 downto 0);
signal HSELMPMCREG      : std_logic := '0';

signal HREADYIN0        : std_logic;
signal HTRANS0          : std_logic_vector(1 downto 0);
signal HADDR0           : std_logic_vector(27 downto 0);
signal HWRITE0          : std_logic;
signal HSIZE0           : std_logic_vector(2 downto 0);
signal HBURST0          : std_logic_vector(2 downto 0);
signal HPROT0           : std_logic_vector(3 downto 0);
signal HWDATA0          : std_logic_vector(31 downto 0);
signal HSELMPMC0G       : std_logic := '0';
signal HSELMPMC0CS      : std_logic_vector(7 downto 0) := (others => '0');
signal HMASTLOCK0       : std_logic;

signal HREADYIN1        : std_logic;
signal HTRANS1          : std_logic_vector(1 downto 0);
signal HADDR1           : std_logic_vector(27 downto 0);
signal HWRITE1          : std_logic;
signal HSIZE1           : std_logic_vector(2 downto 0);
signal HBURST1          : std_logic_vector(2 downto 0);
signal HPROT1           : std_logic_vector(3 downto 0);
signal HWDATA1          : std_logic_vector(31 downto 0);
signal HSELMPMC1G       : std_logic := '0';
signal HSELMPMC1CS      : std_logic_vector(7 downto 0) := (others => '0');
signal HMASTLOCK1       : std_logic;

signal HREADYIN2        : std_logic;
signal HTRANS2          : std_logic_vector(1 downto 0);
signal HADDR2           : std_logic_vector(27 downto 0);
signal HWRITE2          : std_logic;
signal HSIZE2           : std_logic_vector(2 downto 0);
signal HBURST2          : std_logic_vector(2 downto 0);
signal HPROT2           : std_logic_vector(3 downto 0);
signal HWDATA2          : std_logic_vector(31 downto 0);
signal HSELMPMC2G       : std_logic := '0';
signal HSELMPMC2CS      : std_logic_vector(7 downto 0) := (others => '0');
signal HMASTLOCK2       : std_logic;

signal HREADYIN3        : std_logic;
signal HTRANS3          : std_logic_vector(1 downto 0);
signal HADDR3           : std_logic_vector(27 downto 0);
signal HWRITE3          : std_logic;
signal HSIZE3           : std_logic_vector(2 downto 0);
signal HBURST3          : std_logic_vector(2 downto 0);
signal HPROT3           : std_logic_vector(3 downto 0);
signal HWDATA3          : std_logic_vector(31 downto 0);
signal HSELMPMC3G       : std_logic := '0';
signal HSELMPMC3CS      : std_logic_vector(7 downto 0) := (others => '0');
signal HMASTLOCK3       : std_logic;

-- Open outputs of the MPMC AHB Slave ports
signal HRDATAREG        : std_logic_vector(20 downto 0);
signal HREADYOUTREG     : std_logic;
signal HRESPREG         : std_logic_vector(1 downto 0);

signal HRDATA0          : std_logic_vector(31 downto 0);
signal HREADYOUT0       : std_logic;
signal HRESP0           : std_logic_vector(1 downto 0);

signal HRDATA1          : std_logic_vector(31 downto 0);
signal HREADYOUT1       : std_logic;
signal HRESP1           : std_logic_vector(1 downto 0);

signal HRDATA2          : std_logic_vector(31 downto 0);
signal HREADYOUT2       : std_logic;
signal HRESP2           : std_logic_vector(1 downto 0);

signal HRDATA3          : std_logic_vector(31 downto 0);
signal HREADYOUT3       : std_logic;
signal HRESP3           : std_logic_vector(1 downto 0);

-- Slave specific output signals
signal HSELIntMem       : std_logic;
signal HRDATAIntMem     : std_logic_vector(31 downto 0)
                        := (others => '0');
signal HREADYIntMem     : std_logic := '0';
signal HRESPIntMem      : std_logic_vector(1 downto 0) := "00";

signal HSELExtMem       : std_logic;
signal HRDATAExtMem     : std_logic_vector(31 downto 0);
signal HREADYExtMem     : std_logic;
signal HRESPExtMem      : std_logic_vector(1 downto 0);

signal HSELREG          : std_logic := '0';
signal HSELUUT          : std_logic;
signal HRDATAUUT        : std_logic_vector(31 downto 0)
                           := (others => '0');
signal HREADYUUT        : std_logic := '0';
signal HRESPUUT         : std_logic_vector(1 downto 0) := "00";
signal HSELAPBif        : std_logic;
signal HRDATAAPBif      : std_logic_vector(31 downto 0);
signal HREADYAPBif      : std_logic;
signal HRESPAPBif       : std_logic_vector(1 downto 0);

signal HSELArmTest      : std_logic;
signal HRDATAArmTest    : std_logic_vector(31 downto 0);
signal HREADYArmTest    : std_logic;
signal HRESPArmTest     : std_logic_vector(1 downto 0);

signal HSELDefault      : std_logic;
signal HREADYDefault    : std_logic;
signal HRESPDefault     : std_logic_vector(1 downto 0);

signal HSPLIT001        : std_logic_vector(15 downto 0);
signal HSPLIT002        : std_logic_vector(15 downto 0);
signal HSPLIT003        : std_logic_vector(15 downto 0);
signal HSPLIT004        : std_logic_vector(15 downto 0);

-- Master specific signals
signal HADDRarm         : std_logic_vector(31 downto 0)
                        := (others => '0');
signal HTRANSarm        : std_logic_vector(1 downto 0)
                        := (others => '0');
signal HWRITEarm        : std_logic := '0';
signal HSIZEarm         : std_logic_vector(2 downto 0)
                        := (others => '0');
signal HBURSTarm        : std_logic_vector(2 downto 0)
                        := (others => '0');
signal HPROTarm         : std_logic_vector(3 downto 0)
                        := (others => '0');
signal HWDATAarm        : std_logic_vector(31 downto 0)
                        := (others => '0');
signal HBUSREQarm       : std_logic := '0';
signal HLOCKarm         : std_logic := '0';
signal HGRANTarm        : std_logic;

signal HADDRtic         : std_logic_vector(31 downto 0);
signal HTRANStic        : std_logic_vector(1 downto 0);
signal HWRITEtic        : std_logic;
signal HSIZEtic         : std_logic_vector(2 downto 0);
signal HBURSTtic        : std_logic_vector(2 downto 0);
signal HPROTtic         : std_logic_vector(3 downto 0);
signal HRDATAtic        : std_logic_vector(31 downto 0);
signal HWDATAtic        : std_logic_vector(31 downto 0);
signal HBUSREQtic       : std_logic;
signal HLOCKtic         : std_logic;
signal HGRANTtic        : std_logic := '1';
signal TICBUSREQ        : std_logic;
signal TICBUSGNT        : std_logic := '1';
signal iTESTACK         : std_logic;
signal TBUSOUT          : std_logic_vector(31 downto 0);

signal HADDR003         : std_logic_vector(31 downto 0);
signal HTRANS003        : std_logic_vector(1 downto 0);
signal HWRITE003        : std_logic;
signal HSIZE003         : std_logic_vector(2 downto 0);
signal HBURST003        : std_logic_vector(2 downto 0);
signal HPROT003         : std_logic_vector(3 downto 0);
signal HWDATA003        : std_logic_vector(31 downto 0);
signal HBUSREQ003       : std_logic;
signal HLOCK003         : std_logic;
signal HGRANT003        : std_logic;

signal HADDR004         : std_logic_vector(31 downto 0);
signal HTRANS004        : std_logic_vector(1 downto 0);
signal HWRITE004        : std_logic;
signal HSIZE004         : std_logic_vector(2 downto 0);
signal HBURST004        : std_logic_vector(2 downto 0);
signal HPROT004         : std_logic_vector(3 downto 0);
signal HWDATA004        : std_logic_vector(31 downto 0);
signal HBUSREQ004       : std_logic;
signal HLOCK004         : std_logic;
signal HGRANT004        : std_logic;

-- Generic AHB Slave signals
signal HRDATAAHBSLV     : std_logic_vector(63 downto 0);
signal HREADYOUTAHBSLV  : std_logic;
signal HRESPAHBSLV      : std_logic_vector(1 downto 0);
signal HWDATASlave      : std_logic_vector(63 downto 0);
signal HSELAHBSLAVE     : std_logic;

-- -----------------------------------------------------------------------------
-- APB Signals
-- -----------------------------------------------------------------------------
signal PENABLE          : std_logic;
signal PSELIC           : std_logic;
signal PSELUUT          : std_logic;
signal PSELRPC          : std_logic;
signal PADDR            : std_logic_vector(31 downto 0);
signal PWRITE           : std_logic;
signal PWDATA           : std_logic_vector(31 downto 0);
signal PRDATA           : std_logic_vector(31 downto 0);

-- -----------------------------------------------------------------------------
-- Example System Signals
-- -----------------------------------------------------------------------------
signal Remap            : std_logic;
signal Pause            : std_logic;

signal TicRead          : std_logic;

-- -----------------------------------------------------------------------------
-- Static Memory Controller Signals
-- -----------------------------------------------------------------------------
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
signal MPMCBIGENDIAN    : std_logic;

-- External Signals
signal MPMCSTCS1MW      : std_logic_vector(1 downto 0) :="00";
signal MPMCSTCS0POL     : std_logic := '0';
signal MPMCSTCS1POL     : std_logic := '0';
signal MPMCSTCS2POL     : std_logic := '0';
signal MPMCSTCS3POL     : std_logic := '0';
signal MPMCSTCS1PB      : std_logic := '0';
signal MPMCREL1CONFIG   : std_logic := '0';
signal MPMCCLKOUT       : std_logic_vector(3 downto 0);
signal MPMCFBCLKIN0     : std_logic;
signal MPMCFBCLKIN1     : std_logic;
signal MPMCFBCLKIN2     : std_logic;
signal MPMCFBCLKIN3     : std_logic;
signal nPOR             : std_logic;
signal MPMCCKEOUT       : std_logic_vector(3 downto 0);
signal MPMCDQMOUT       : std_logic_vector(3 downto 0);
signal MPMCTESTIN       : std_logic;
signal MPMCSREFACK      : std_logic;
signal MPMCDATAIN       : std_logic_vector(31 downto 0);
signal MPMCDATAOUT      : std_logic_vector(31 downto 0);
signal MPMCADDROUT      : std_logic_vector(27 downto 0);
signal nMPMCDATAEN      : std_logic_vector(3 downto 0) := "1111";
signal nMPMCRASOUT      : std_logic;
signal nMPMCCASOUT      : std_logic;
signal nMPMCOEOUT       : std_logic;
signal nMPMCWEOUT       : std_logic;
signal nMPMCRPOUT       : std_logic;
signal MPMCSREFREQ      : std_logic := '0';
signal nMPMCSTCSOUT     : std_logic_vector(3 downto 0);
signal nMPMCDYCSOUT     : std_logic_vector(3 downto 0);
signal MPMCCLK1         : std_logic;
signal MPMCCLKDELAY     : std_logic;

-- EBI related signals
signal MPMCEBIREQ       : std_logic;
signal MPMCEBIGNT       : std_logic;
signal MPMCEBIBACKOFF   : std_logic;

signal NxtMPMCEBIGNT    : std_logic;
-- D input of MPMCEBIGNT

signal NxtMPMCEBIBACKOFF: std_logic;
-- D input of MPMCBACKOFF

signal iMPMCEBIGNT      : std_logic;
-- Internal version of MPMCEBIGNT

signal iMPMCEBIGNT1     : std_logic;
-- Internal version of MPMCEBIGNT

signal MPMCEBIGNTQ      : std_logic;
-- Clked version of MPMCEBIGNT

signal iMPMCEBIBACKOFF  : std_logic;
-- Internal version of MPMCEBIBACKOFF

signal CntFlag        : std_logic;
-- Flag to indicate the end of counter

signal Cntr           : std_logic_vector(1 downto 0);
-- Counter to count the clk to generate the backoff signal

signal NxtCntr        : std_logic_vector(1 downto 0);
-- D - input of Cntr
-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------
begin

-- -----------------------------------------------------------------------------
-- Memory Data Bus multiplexing
-- -----------------------------------------------------------------------------
p_MPMCDATAComb : process (nMPMCDATAEN, MPMCDATAOUT)
begin
  if (nMPMCDATAEN(0) = '0') then
    XD(7 downto 0) <= MPMCDATAOUT(7 downto 0);
  else
    XD(7 downto 0) <= (others =>'Z');
  end if;

  if (nMPMCDATAEN(1) = '0') then
    XD(15 downto 8) <= MPMCDATAOUT(15 downto 8);
  else
    XD(15 downto 8) <= (others =>'Z');
  end if;

  if (nMPMCDATAEN(2) = '0') then
    XD(23 downto 16) <= MPMCDATAOUT(23 downto 16);
  else
    XD(23 downto 16) <= (others =>'Z');
  end if;

  if (nMPMCDATAEN(3) = '0') then
    XD(31 downto 24) <= MPMCDATAOUT(31 downto 24);
  else
    XD(31 downto 24) <= (others =>'Z');
  end if;
end process p_MPMCDATAComb;

MPMCDATAIN         <= XD;

-- -----------------------------------------------------------------------------
-- Drive the AHB clock with the external clock input.
-- -----------------------------------------------------------------------------
TESTACK          <= iTESTACK;
HCLK             <= XCLKIN;

nPOR             <= nReset;

-- -----------------------------------------------------------------------------
-- OR connection of split input to the Arbiter.
-- -----------------------------------------------------------------------------
HSPLIT           <= HSPLIT001 or
                    HSPLIT002 or
                    HSPLIT003 or
                    HSPLIT004;

-- -----------------------------------------------------------------------------
-- Enable the TEST Interface and connect the Test mode signals
-- -----------------------------------------------------------------------------
MPMCTESTIN       <= '1';
iTESTACK         <= nMPMCWEOUT;

-- -----------------------------------------------------------------------------
-- Unconnected Arbiter inputs driven LOW
-- -----------------------------------------------------------------------------
HBUSREQ003       <= '0';
HBUSREQ004       <= '0';

HWDATASlave      <= "00000000000000000000000000000000" & HWDATA;

HLOCK003         <= '0';
HLOCK004         <= '0';

HSPLIT002        <= (others => '0');
HSPLIT003        <= (others => '0');
HSPLIT004        <= (others => '0');

SCANENABLE       <= '0';
SCANINHCLK       <= '0';
SCANINMPMCCLK    <= '0';
SCANINCLKDELAY   <= '0';
SCANINFBCLKIN0   <= '0';
SCANINFBCLKIN1   <= '0';
SCANINFBCLKIN2   <= '0';
SCANINFBCLKIN3   <= '0';

HRDATAExtMem     <= HRDATA0;
HREADYExtMem     <= HREADYOUT0;
HRESPExtMem      <= HRESP0;

-- -----------------------------------------------------------------------------
-- Split the HSELUUT range for MPMC and AHBSlave
-- -----------------------------------------------------------------------------
p_AddrDecodeComb : process (HSELUUT, HADDR)
begin
  HSELMPMCREG  <= '0';
  HSELAHBSLAVE <= '0';

  if (HSELUUT = '1') then
    if (HADDR(28) = '0') then
      HSELAHBSLAVE <= '1';                  -- AHBSlave
    else
      HSELMPMCREG  <= '1';                  -- AHB UUT
    end if;
  else
    HSELAHBSLAVE <= '0';
    HSELMPMCREG  <= '0';
  end if;
end process p_AddrDecodeComb;

IntHSEL          <= (HSELMPMCREG & HSELAHBSLAVE);

p_DelHSELSeq : process (HRESETn, HCLK)
begin
  if (HRESETn = '0') then
    DelHSEL <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    if (HREADY = '1') then
      DelHSEL <= IntHSEL;
    end if;
  end if;
end process p_DelHSELSeq;

p_RespComb : process(DelHSEL, HRDATAAHBSLV, HRESPAHBSLV, HREADYOUTAHBSLV,
                      HRDATAREG, HRESPREG, HREADYOUTREG)
begin
  case DelHSEL is
    when "01"   => HRDATAUUT <= HRDATAAHBSLV(31 downto 0);
                   HRESPUUT  <= HRESPAHBSLV;
                   HREADYUUT <= HREADYOUTAHBSLV;

    when "10"   => HRDATAUUT <= "00000000000" & HRDATAREG(20 downto 0);
                   HRESPUUT  <= HRESPREG;
                   HREADYUUT <= HREADYOUTREG;

    when others => HRDATAUUT <= (others => '0');
                   HRESPUUT  <= "00";
                   HREADYUUT <= '1';
  end case;
end process p_RespComb;

-- -----------------------------------------------------------------------------
-- Generate MPMCCLK1
-- -----------------------------------------------------------------------------
MPMCCLK1 <= HRESETn or HCLK;
-- -----------------------------------------------------------------------------
-- Assign uut HWDATA
-- -----------------------------------------------------------------------------
HWDATAREG20TO19  <= HWDATA(20 downto 19);
HWDATAREG15TO0   <= HWDATA(15 downto 0);

-- -----------------------------------------------------------------------------
-- EBIGNT generator
-- -----------------------------------------------------------------------------
p_EbiGntGenComb : process (MPMCEBIREQ)
begin
  if (MPMCEBIREQ = '1') then
    NxtMPMCEBIGNT <= '1';
  else
    NxtMPMCEBIGNT <= '0';
  end if;
end process p_EbiGntGenComb;
-- -----------------------------------------------------------------------------
-- Combinational part of the counter
-- -----------------------------------------------------------------------------

p_BACKOFFCNTR : process (iMPMCEBIGNT, CntFlag, Cntr)
begin
  NxtCntr <= Cntr;
  if (iMPMCEBIGNT = '0') then
    NxtCntr <= "11";
  elsif (CntFlag /= '1') then
    NxtCntr <= unsigned(Cntr) - 1;
  end if;
end process p_BACKOFFCNTR;

-- -----------------------------------------------------------------------------
-- Sequential part of the counter 
-- -----------------------------------------------------------------------------

p_CNTRSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    Cntr <= "11";
  elsif (HCLK'event and HCLK = '1') then
    Cntr <= NxtCntr;
  end if;
end process p_CNTRSeq;
-- -----------------------------------------------------------------------------
-- Flag to indicate the assertion of the BackOff signal
-- -----------------------------------------------------------------------------
CntFlag <= '1' when (Cntr = "00")
        else
           '0';
iMPMCEBIGNT1     <= iMPMCEBIGNT;
-- -----------------------------------------------------------------------------
-- Clocking the GNT signal
-- -----------------------------------------------------------------------------
p_GntSeq : process (HCLK, HRESETn, iMPMCEBIGNT1)
begin
  if (HRESETn = '0') then
    MPMCEBIGNTQ <= '0';
  elsif (HCLK'event and HCLK = '1') then
    MPMCEBIGNTQ <= iMPMCEBIGNT1;
  end if;
end process p_GntSeq;

-- -----------------------------------------------------------------------------
-- Assertion of BackOff signal
-- -----------------------------------------------------------------------------
p_BackOffGen : process (nPOR,CntFlag, iMPMCEBIGNT, MPMCEBIGNTQ, iMPMCEBIBACKOFF)
begin
    NxtMPMCEBIBACKOFF <= iMPMCEBIBACKOFF;
  if (nPOR = '0') then
    NxtMPMCEBIBACKOFF <= '0';
  elsif (iMPMCEBIGNT = '0') then
    NxtMPMCEBIBACKOFF <= '0';
  elsif (CntFlag = '1' and MPMCEBIGNTQ = '1') then
    NxtMPMCEBIBACKOFF <= '1';
  end if;
end process p_BackOffGen;

-- -----------------------------------------------------------------------------
-- Clking the GNT and BackOff signal
-- -----------------------------------------------------------------------------
p_EbiGntSeq : process(nPOR, HCLK, NxtMPMCEBIGNT, NxtMPMCEBIBACKOFF)
begin
  if (nPOR = '0') then
    iMPMCEBIGNT     <= '1';
  elsif (HCLK'event and HCLK = '1') then
    iMPMCEBIGNT     <= NxtMPMCEBIGNT;
    iMPMCEBIBACKOFF <= NxtMPMCEBIBACKOFF;
  end if;
end process p_EbiGntSeq;


MPMCEBIGNT     <= iMPMCEBIGNT;
MPMCEBIBACKOFF <= iMPMCEBIBACKOFF and iMPMCEBIGNT;
-- -----------------------------------------------------------------------------
-- The AHB to APB bridge Instantiation
-- -----------------------------------------------------------------------------
uAPBif : APBif
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HADDR            => HADDR,
            HTRANS           => HTRANS,
            HWRITE           => HWRITE,
            HWDATA           => HWDATA,
            HSELAPBif        => HSELAPBif,
            HREADYin         => HREADY,

            HRDATA           => HRDATAAPBif,
            HREADYout        => HREADYAPBif,
            HRESP            => HRESPAPBif,

            PRDATA           => PRDATA,

            PWDATA           => PWDATA,
            PENABLE          => PENABLE,
            PSELIC           => PSELIC,
            PSELUUT          => PSELUUT,
            PSELRPC          => PSELRPC,
            PADDR            => PADDR,
            PWRITE           => PWRITE
           );

-- -----------------------------------------------------------------------------
-- The AHB system arbiter Instantiation
-- -----------------------------------------------------------------------------
uArbiter : Arbiter
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HTRANS           => HTRANS,
            HBURST           => HBURST,
            HREADY           => HREADY,
            HRESP            => HRESP,

            HBUSREQarm       => HBUSREQarm,
            HBUSREQtic       => HBUSREQtic,
            HBUSREQ003       => HBUSREQ003,
            HBUSREQ004       => HBUSREQ004,

            HLOCKarm         => HLOCKarm,
            HLOCKtic         => HLOCKtic,
            HLOCK003         => HLOCK003,
            HLOCK004         => HLOCK004,

            HSPLIT           => HSPLIT,

            Pause            => Pause,

            HGRANTarm        => HGRANTarm,
            -- HGRANTtic        => OPEN,
            HGRANTtic        => HGRANTtic,
            HGRANT003        => HGRANT003,
            HGRANT004        => HGRANT004,

            HMASTER          => HMASTER,
            HMASTLOCK        => HMASTLOCK
           );

-- -----------------------------------------------------------------------------
-- The system address Decoder Instantiation
-- -----------------------------------------------------------------------------
uDecoder : Decoder
  port map (
            HRESETn          => HRESETn,
            HADDR            => HADDR,

            Remap            => Remap,

            HSELIntMem       => HSELIntMem,
            HSELExtMem       => HSELExtMem,
            HSELUUT          => HSELUUT,
            HSELAPBif        => HSELAPBif,
            HSELArmTest      => HSELArmTest,
            HSELDefault      => HSELDefault
           );

-- -----------------------------------------------------------------------------
-- The Default Slave Instantiation
-- -----------------------------------------------------------------------------
uDefaultSlave : DefaultSlave
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HTRANS           => HTRANS,
            HSELDefault      => HSELDefault,
            HREADYin         => HREADY,

            HREADYout        => HREADYDefault,
            HRESP            => HRESPDefault
           );

-- -----------------------------------------------------------------------------
-- Central multiplexer - masters to slaves - Instantiation
-- -----------------------------------------------------------------------------
uMuxM2S : MuxM2S
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HMASTER          => HMASTER,
            HREADY           => HREADY,

            HADDRarm         => HADDRarm,
            HTRANSarm        => HTRANSarm,
            HWRITEarm        => HWRITEarm,
            HSIZEarm         => HSIZEarm,
            HBURSTarm        => HBURSTarm,
            HPROTarm         => HPROTarm,
            HWDATAarm        => HWDATAarm,

            HADDRtic         => HADDRtic,
            HTRANStic        => HTRANStic,
            HWRITEtic        => HWRITEtic,
            HSIZEtic         => HSIZEtic,
            HBURSTtic        => HBURSTtic,
            HPROTtic         => HPROTtic,
            HWDATAtic        => HWDATAtic,

            HADDR003         => HADDR003,
            HTRANS003        => HTRANS003,
            HWRITE003        => HWRITE003,
            HSIZE003         => HSIZE003,
            HBURST003        => HBURST003,
            HPROT003         => HPROT003,
            HWDATA003        => HWDATA003,

            HADDR004         => HADDR004,
            HTRANS004        => HTRANS004,
            HWRITE004        => HWRITE004,
            HSIZE004         => HSIZE004,
            HBURST004        => HBURST004,
            HPROT004         => HPROT004,
            HWDATA004        => HWDATA004,

            HADDR            => HADDR,
            HTRANS           => HTRANS,
            HWRITE           => HWRITE,
            HSIZE            => HSIZE,
            HBURST           => HBURST,
            HPROT            => HPROT,
            HWDATA           => HWDATA
           );

-- -----------------------------------------------------------------------------
-- Central multiplexer - slaves to masters - Instantiation
-- -----------------------------------------------------------------------------
uMuxS2M : MuxS2M
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HSELIntMem       => HSELIntMem,
            HSELExtMem       => HSELExtMem,
            HSELUUT          => HSELUUT,
            HSELAPBif        => HSELAPBif,
            HSELArmTest      => HSELArmTest,

            HRDATAIntMem     => HRDATAIntMem,
            HREADYIntMem     => HREADYIntMem,
            HRESPIntMem      => HRESPIntMem,

            HRDATAExtMem     => HRDATAExtMem,
            HREADYExtMem     => HREADYExtMem,
            HRESPExtMem      => HRESPExtMem,

            HRDATAUUT        => HRDATAUUT,
            HREADYUUT        => HREADYUUT,
            HRESPUUT         => HRESPUUT,

            HRDATAAPBif      => HRDATAAPBif,
            HREADYAPBif      => HREADYAPBif,
            HRESPAPBif       => HRESPAPBif,

            HRDATAArmTest    => HRDATAArmTest,
            HREADYArmTest    => HREADYArmTest,
            HRESPArmTest     => HRESPArmTest,

            HREADYDefault    => HREADYDefault,
            HRESPDefault     => HRESPDefault,

            HRDATA           => HRDATA,
            HREADY           => HREADY,
            HRESP            => HRESP
           );

-- -----------------------------------------------------------------------------
-- The bus reset controller Instantiation
-- -----------------------------------------------------------------------------
uResCntl : ResCntl
  port map (
            HCLK             => HCLK,
            POReset          => nReset,
            HRESETn          => HRESETn
           );

-- -----------------------------------------------------------------------------
-- Generic AHB Slave Instantiation
-- -----------------------------------------------------------------------------
uAhbSlave : AhbSlave
  generic map (
               tclkl       => Tclkl,
               tclkh       => Tclkh,
               tovrdy      => Tovrdy,
               tohrdy      => Tohrdy,
               tovrsp      => Tovrsp,
               tohrsp      => Tohrsp,
               tovsplt     => Tovsplt,
               tohsplt     => Tohsplt,
               tovdr       => Tovdr,
               tohdr       => Tohdr
              )
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HADDR            => HADDR,
            HTRANS           => HTRANS,
            HWRITE           => HWRITE,
            HSIZE            => HSIZE,
            HBURST           => HBURST,
            HWDATA           => HWDATASlave,
            HRDATAIn         => HRDATAAHBSLV,
            HREADYIn         => HREADY,
            HSPLITIn         => HSPLIT,
            HSEL             => HSELAHBSLAVE,
            HMASTER          => HMASTER,
            HMASTLOCK        => HMASTLOCK,
            -- HRESPIn          => HRESPUUT,
            HRESPIn          => HRESP,
            HRDATAdly        => HRDATAAHBSLV,
            HREADYdly        => HREADYOUTAHBSLV,
            HRESPdly         => HRESPAHBSLV,
            HSPLITdly        => HSPLIT001
           );

-- -----------------------------------------------------------------------------
-- RPS Instantiation
-- -----------------------------------------------------------------------------
uRPS : RPS
  port map (
            PCLK             => HCLK,
            PRESETn          => HRESETn,
            Pause            => Pause,
            Remap            => Remap,

            PSELUUT          => PSELUUT,
            PSELRPC          => PSELRPC,

            PENABLE          => PENABLE,
            PADDR            => PADDR,
            PWRITE           => PWRITE,
            PWDATA           => PWDATA,
            PRDATA           => PRDATA
           );

-- -----------------------------------------------------------------------------
-- MPMC and the TIC Module Instantiation
-- -----------------------------------------------------------------------------
uut : Mpmc
  port map (
            HCLK             => HCLK,
            MPMCCLK          => MPMCCLK1,
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
            HREADYIN0        => HREADYIN0,
            HSELMPMC0G       => HSELMPMC0G,
            HSELMPMC0CS      => HSELMPMC0CS,
            HMASTLOCK0       => HMASTLOCK0,
            HADDR0           => HADDR0,
            HWDATA0          => HWDATA0,
            HWRITE1          => HWRITE1,
            HTRANS1          => HTRANS1,
            HSIZE1           => HSIZE1,
            HBURST1          => HBURST1,
            HREADYIN1        => HREADYIN1,
            HSELMPMC1G       => HSELMPMC1G,
            HSELMPMC1CS      => HSELMPMC1CS,
            HMASTLOCK1       => HMASTLOCK1,
            HADDR1           => HADDR1,
            HWDATA1          => HWDATA1,
            HWRITE2          => HWRITE2,
            HTRANS2          => HTRANS2,
            HSIZE2           => HSIZE2,
            HBURST2          => HBURST2,
            HREADYIN2        => HREADYIN2,
            HSELMPMC2G       => HSELMPMC2G,
            HSELMPMC2CS      => HSELMPMC2CS,
            HMASTLOCK2       => HMASTLOCK2,
            HADDR2           => HADDR2,
            HWDATA2          => HWDATA2,
            HWRITE3          => HWRITE3,
            HTRANS3          => HTRANS3,
            HSIZE3           => HSIZE3,
            HBURST3          => HBURST3,
            HREADYIN3        => HREADYIN3,
            HSELMPMC3G       => HSELMPMC3G,
            HSELMPMC3CS      => HSELMPMC3CS,
            HMASTLOCK3       => HMASTLOCK3,
            HADDR3           => HADDR3,
            HWDATA3          => HWDATA3,
            HWRITEREG        => HWRITE,
            HTRANSREG        => HTRANS(1),
            HSIZEREG         => HSIZE,
            HREADYINREG      => HREADY,
            HSELMPMCREG      => HSELMPMCREG,
            HADDRREG         => HADDR(11 downto 2),
            HWDATAREG20TO19  => HWDATAREG20TO19,
            HWDATAREG15TO0   => HWDATAREG15TO0,
            HRDATATIC        => HRDATA,
            HREADYINTIC      => HREADY,
            HGRANTTIC        => HGRANTTIC,
            HRESPTIC         => HRESP,
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
            MPMCEBIREQ       => MPMCEBIREQ,
            MPMCEBIGNT       => MPMCEBIGNT,
            MPMCEBIBACKOFF   => MPMCEBIBACKOFF,
            MPMCTESTREQA     => TESTREQA,
            MPMCTESTREQB     => TESTREQB,
            SCANINHCLK       => SCANINHCLK,
            SCANINMPMCCLK    => SCANINMPMCCLK,
            SCANINCLKDELAY   => SCANINCLKDELAY,
            SCANINFBCLKIN0   => SCANINFBCLKIN0,
            SCANINFBCLKIN1   => SCANINFBCLKIN1,
            SCANINFBCLKIN2   => SCANINFBCLKIN2,
            SCANINFBCLKIN3   => SCANINFBCLKIN3,
            SCANENABLE       => SCANENABLE,

            HREADYOUT0       => HREADYOUT0,
            HRESP0           => HRESP0,
            HRDATA0          => HRDATA0,
            HREADYOUT1       => HREADYOUT1,
            HRESP1           => HRESP1,
            HRDATA1          => HRDATA1,
            HREADYOUT2       => HREADYOUT2,
            HRESP2           => HRESP2,
            HRDATA2          => HRDATA2,
            HREADYOUT3       => HREADYOUT3,
            HRESP3           => HRESP3,
            HRDATA3          => HRDATA3,
            HREADYOUTREG     => HREADYOUTREG,
            HRESPREG         => HRESPREG,
            HRDATAREG        => HRDATAREG,
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
            nMPMCRASOUT      => nMPMCRASOUT,
            nMPMCCASOUT      => nMPMCCASOUT,
            nMPMCOEOUT       => nMPMCOEOUT,
            nMPMCWEOUT       => nMPMCWEOUT,
            nMPMCSTCSOUT     => nMPMCSTCSOUT,
            nMPMCDYCSOUT     => nMPMCDYCSOUT,
            MPMCADDROUT      => MPMCADDROUT,
            MPMCDATAOUT      => MPMCDATAOUT,
            nMPMCRPOUT       => nMPMCRPOUT,
            nMPMCDATAEN      => nMPMCDATAEN,
            MPMCSREFACK      => MPMCSREFACK,
            SCANOUTHCLK      => SCANOUTHCLK,
            SCANOUTMPMCCLK   => SCANOUTMPMCCLK,
            SCANOUTCLKDELAY  => SCANOUTCLKDELAY,
            SCANOUTFBCLKIN0  => SCANOUTFBCLKIN0,
            SCANOUTFBCLKIN1  => SCANOUTFBCLKIN1,
            SCANOUTFBCLKIN2  => SCANOUTFBCLKIN2,
            SCANOUTFBCLKIN3  => SCANOUTFBCLKIN3
           );

-- -----------------------------------------------------------------------------
-- TIC Master Watcher Instantiation
-- -----------------------------------------------------------------------------
uTicWatcher : TicWatcher
  port map (
            TCLK             => HCLK,
            RESETn           => HRESETn,
            TESTREQA         => TESTREQA,
            TESTREQB         => TESTREQB,
            TESTACK          => iTESTACK,
            TESTBUS          => XD,

            HADDRTIC         => HADDRtic,
            HWRITETIC        => HWRITEtic,
            HTRANSTIC        => HTRANStic,
            HSIZETIC         => HSIZEtic,
            HBURSTTIC        => HBURSTtic,
            HPROTTIC         => HPROTtic,
            HWDATATIC        => HWDATAtic
       );

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
-- Inputs
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HTRANS           => HTRANS,
            HADDR            => HADDR,
            HSIZE            => HSIZE,
            HBURST           => HBURST,
            HBUSREQx         => HBUSREQtic,
            HGRANTx          => HGRANTtic,
            HREADY           => HREADY,
            HLOCKx           => HLOCKtic,
            HWDATA           => HWDATA,
            HPROT            => HPROT,
            HWRITE           => HWRITE,
            HRESP            => HRESP,
-- Outputs
            ResetOver        => OPEN
           );

end structural;

-- --================================== End ==================================--
