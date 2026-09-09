-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2003 ARM Limited
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
-- Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Structural architecture of Example Amba SYstem (EASY)
--
-- --=========================================================================--

library IEEE;
use     IEEE.std_logic_1164.all;

library sys;
use     sys.all;

library trickbox;
use     trickbox.all;

library uut;
use     uut.all;

library chip;
use     chip.all;
use     chip.timing.all;
use     chip.timingmaster.all;
use     chip.defsmaster.all;

entity EASY is
  port (
        XCLKIN           : in    std_logic; -- External clock in
        nReset           : in    std_logic; -- Power on reset input
        XD               : inout std_logic_vector(31 downto 0);
                                            -- External data bus
        XA               : out   std_logic_vector(30 downto 0);
                                            -- External address bus
        XCSN             : out   std_logic_vector(3 downto 0);
                                            -- External chip select
        XOEN             : out   std_logic; -- External output enable
        XWEN             : out   std_logic_vector(3 downto 0);
                                            -- External write enable
    
        TESTREQA         : in    std_logic; -- Test bus request A
        TESTREQB         : in    std_logic; -- Test bus request B
        TESTACK          : out   std_logic; -- Test acknowledge

        nTRST            : in    std_logic; -- JTAG connections
        TCK              : in    std_logic;
        TDI              : in    std_logic;
        TMS              : in    std_logic;
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
        PSELIC           : out   std_logic; -- Interrupt Controller
        PSELUUT          : out   std_logic; -- APB Unit Under Test
        PSELRPC          : out   std_logic; -- Remap and Pause
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
  
        HBUSREQarm       : in    std_logic; -- Master bus request inputs
        HBUSREQtic       : in    std_logic;
        HBUSREQ003       : in    std_logic;
        HBUSREQ004       : in    std_logic;

        HLOCKarm         : in    std_logic; -- Master bus lock request
                                            -- inputs
        HLOCKtic         : in    std_logic;
        HLOCK003         : in    std_logic;
        HLOCK004         : in    std_logic;

        HSPLIT           : in    std_logic_vector(15 downto 0);
                                            -- Slave split inputs

        Pause            : in    std_logic; -- Pause mode entered

        HGRANTarm        : out   std_logic; -- Master bus grant outputs
        HGRANTtic        : out   std_logic;
        HGRANT003        : out   std_logic;
        HGRANT004        : out   std_logic;

        HMASTER          : out   std_logic_vector(3 downto 0);
                                            -- Current bus master
        HMASTLOCK        : out   std_logic  -- Indicates locked sequence
                                            -- of transfers
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

        HSELIntMem       : out   std_logic; -- Internal Memory
        HSELExtMem       : out   std_logic; -- External Memory
        HSELUUT          : out   std_logic; -- AHB Slave
        HSELAPBif        : out   std_logic; -- APB Peripherals
        HSELArmTest      : out   std_logic; -- ARM Test
        HSELDefault      : out   std_logic  -- Default Slave
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
        POReset          : in    std_logic; -- Power on reset input
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
        Pause            : out   std_logic; -- Pause mode entered
        Remap            : out   std_logic; -- Reset memory map in use

        PSELRPC          : in    std_logic; -- Remap and Pause
        PSELUUT          : in    std_logic; -- APB UUT

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

        Remap            : in    std_logic; -- Reset memory map in use
        TicRead          : in    std_logic; -- Drive out read data

        XD               : inout std_logic_vector(31 downto 0);
                                            -- External data bus

        XA               : out   std_logic_vector(30 downto 0);
                                            -- External address bus
        XCSN             : out   std_logic_vector(3 downto 0);
                                            -- External chip select
        XOEN             : out   std_logic; -- External output enable
        XWEN             : out   std_logic_vector(3 downto 0)
                                            -- External write enable
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
-- SSMC and the TIC Module
-- -----------------------------------------------------------------------------
component Ssmc
  port (
        HCLK             : in    std_logic;
        SMMEMCLK         : in    std_logic;
        nSMMEMCLK        : in    std_logic;
        SMMEMCLKDELAY    : in    std_logic;
        SMFBCLK0         : in    std_logic;
        SMFBCLK1         : in    std_logic;
        SMFBCLK2         : in    std_logic;
        SMFBCLK3         : in    std_logic;
        HRESETn          : in    std_logic;
        HADDRSMC         : in    std_logic_vector(25 downto 0);
        HTRANSSMC        : in    std_logic_vector(1 downto 0);
        HWRITESMC        : in    std_logic;
        HSIZESMC         : in    std_logic_vector(2 downto 0);
        HBURSTSMC        : in    std_logic_vector(2 downto 0);
        HWDATASMC        : in    std_logic_vector(31 downto 0);
        HSELSMC          : in    std_logic_vector(7 downto 0);
        HREADYINSMC      : in    std_logic;
        HADDRREG         : in    std_logic_vector(11 downto 2);
        HTRANSREG        : in    std_logic_vector(1 downto 0);
        HWRITEREG        : in    std_logic;
        HSIZEREG         : in    std_logic_vector(2 downto 0);
        HWDATAREG        : in    std_logic_vector(31 downto 0);
        HSELREG          : in    std_logic;
        HREADYINREG      : in    std_logic;
        HREADYINTIC      : in    std_logic;
        HRESPTIC         : in    std_logic_vector(1 downto 0);
        HRDATATIC        : in    std_logic_vector(31 downto 0);
        HGRANTTIC        : in    std_logic;
        SMBUSGNTEBI      : in    std_logic;
        SMBUSBACKOFFEBI  : in    std_logic;
        SMTICBUSGNTEBI   : in    std_logic;
        SMBIGENDIAN      : in    std_logic;
        SMEXTBUSMUX      : in    std_logic;
        SCANENABLE       : in    std_logic;
        SCANINHCLK       : in    std_logic;
        SCANINSMMEMCLK   : in    std_logic;
        SCANINnSMMEMCLK  : in    std_logic;
        SCANINCLKDELAY   : in    std_logic;
        SCANINFBCLK0     : in    std_logic;
        SCANINFBCLK1     : in    std_logic;
        SCANINFBCLK2     : in    std_logic;
        SCANINFBCLK3     : in    std_logic;
        SMMWCS7          : in    std_logic_vector(1 downto 0);
        SMBLS7POL        : in    std_logic;
        SMMemClkRatio    : in    std_logic_vector(1 downto 0);
        SMWAIT           : in    std_logic;
        SMCANCELWAIT     : in    std_logic;
        nSMBURSTWAIT     : in    std_logic_vector(7 downto 0);
        SMDATAIN         : in    std_logic_vector(31 downto 0);
        SMTESTREQA       : in    std_logic;
        SMTESTREQB       : in    std_logic;
        HRDATASMC        : out   std_logic_vector(31 downto 0);
        HREADYOUTSMC     : out   std_logic;
        HRESPSMC         : out   std_logic_vector(1 downto 0);
        HRDATAREG        : out   std_logic_vector(31 downto 0);
        HREADYOUTREG     : out   std_logic;
        HRESPREG         : out   std_logic_vector(1 downto 0);
        HADDRTIC         : out   std_logic_vector(31 downto 0);
        HTRANSTIC        : out   std_logic_vector(1 downto 0);
        HWRITETIC        : out   std_logic;
        HSIZETIC         : out   std_logic_vector(2 downto 0);
        HBURSTTIC        : out   std_logic_vector(2 downto 0);
        HPROTTIC         : out   std_logic_vector(3 downto 0);
        HWDATATIC        : out   std_logic_vector(31 downto 0);
        HBUSREQTIC       : out   std_logic;
        HLOCKTIC         : out   std_logic;
        SMBUSREQEBI      : out   std_logic;
        SMTICBUSREQEBI   : out   std_logic;
        SCANOUTHCLK      : out   std_logic;
        SCANOUTFBCLK0    : out   std_logic;
        SCANOUTFBCLK1    : out   std_logic;
        SCANOUTFBCLK2    : out   std_logic;
        SCANOUTFBCLK3    : out   std_logic;
        SCANOUTSMMEMCLK  : out   std_logic;
        SCANOUTnSMMEMCLK : out   std_logic;
        SCANOUTCLKDELAY  : out   std_logic;
        SMCLK            : out   std_logic_vector(3 downto 0);
        SMDATAOUT        : out   std_logic_vector(31 downto 0);
        SMBAA            : out   std_logic;
        SMADDRVALID      : out   std_logic;
        SMADDR           : out   std_logic_vector(25 downto 0);
        SMCS0            : out   std_logic;
        SMCS1            : out   std_logic;
        SMCS2            : out   std_logic;
        SMCS3            : out   std_logic;
        SMCS4            : out   std_logic;
        SMCS5            : out   std_logic;
        SMCS6            : out   std_logic;
        SMCS7            : out   std_logic;
        nSMCS0           : out   std_logic;
        nSMCS1           : out   std_logic;
        nSMCS2           : out   std_logic;
        nSMCS3           : out   std_logic;
        nSMCS4           : out   std_logic;
        nSMCS5           : out   std_logic;
        nSMCS6           : out   std_logic;
        nSMCS7           : out   std_logic;
        nSMDATAEN        : out   std_logic_vector(3 downto 0);
        nSMWEN           : out   std_logic;
        nSMBLS           : out   std_logic_vector(3 downto 0);
        nSMOEN           : out   std_logic;
        SMTESTACK        : out   std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
-- AHB Signals
signal HCLK             : std_logic;
signal nHCLK            : std_logic;
signal HRESETn          : std_logic;
signal HTRANS           : std_logic_vector(1 downto 0);
signal HADDR          : std_logic_vector(31 downto 0);
signal HWRITE           : std_logic;
signal HSIZE            : std_logic_vector(2 downto 0);
signal HBURST           : std_logic_vector(2 downto 0);
signal HPROT            : std_logic_vector(3 downto 0);
signal HWDATA           : std_logic_vector(31 downto 0);
signal HMASTER          : std_logic_vector(3 downto 0);
signal HMASTLOCK        : std_logic;
signal HSPLIT           : std_logic_vector(15 downto 0);

-- Multiplexed slave output signals
signal HRDATA        : std_logic_vector(31 downto 0);
signal HRESP         : std_logic_vector(1 downto 0);
signal HREADY        : std_logic;

-- Slave specific output signals
signal HSELIntMem          : std_logic;
signal HRDATAIntMem        : std_logic_vector(31 downto 0)
                           := (others => '0');
signal HREADYIntMem        : std_logic := '0';
signal HRESPIntMem         : std_logic_vector(1 downto 0) := "00";

signal HSELExtMem          : std_logic;
signal HRDATAExtMem        : std_logic_vector(31 downto 0);
signal HREADYExtMem        : std_logic;
signal HRESPExtMem         : std_logic_vector(1 downto 0);

signal HSELREG             : std_logic := '0';
signal HSELUUT             : std_logic;
signal HRDATAUUT           : std_logic_vector(31 downto 0)
                           := (others => '0');
signal HREADYUUT           : std_logic := '0';
signal HRESPUUT            : std_logic_vector(1 downto 0) := "00";
signal HSELAPBif           : std_logic;
signal HRDATAAPBif         : std_logic_vector(31 downto 0);
signal HREADYAPBif         : std_logic;
signal HRESPAPBif          : std_logic_vector(1 downto 0);

signal HSELArmTest         : std_logic;
signal HRDATAArmTest       : std_logic_vector(31 downto 0);
signal HREADYArmTest       : std_logic;
signal HRESPArmTest        : std_logic_vector(1 downto 0);

signal HSELDefault         : std_logic;
signal HREADYDefault       : std_logic;
signal HRESPDefault        : std_logic_vector(1 downto 0);

signal HSPLIT001           : std_logic_vector(15 downto 0);
signal HSPLIT002           : std_logic_vector(15 downto 0);
signal HSPLIT003           : std_logic_vector(15 downto 0);
signal HSPLIT004           : std_logic_vector(15 downto 0);

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
signal iTESTACK         : std_logic := '1';
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

signal HRDATAdly        : std_logic_vector(63 downto 0);
signal HWDATASlave      : std_logic_vector(63 downto 0);

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
-- Synchronous Static Memory Controller Signals
-- -----------------------------------------------------------------------------
-- Ssmc related signals
signal SMCLK            : std_logic_vector(3 downto 0);
signal SMADDR           : std_logic_vector(25 downto 0);
signal SMDATA           : std_logic_vector(31 downto 0) := (others => 'H');
signal SMCS             : std_logic_vector(7 downto 0);
signal nSMCS            : std_logic_vector(7 downto 0);
signal nSMWEN           : std_logic;
signal nSMBLS           : std_logic_vector(3 downto 0);
signal nSMOEN           : std_logic;
signal SMBAA            : std_logic;
signal SMADDRVALID      : std_logic;
signal SMDATAOUT        : std_logic_vector(31 downto 0);
signal SMDATAIN         : std_logic_vector(31 downto 0);
signal nSMDATAEN        : std_logic_vector(3 downto 0);
signal SMMWCS7          : std_logic_vector(1 downto 0);
signal SMBUSREQ         : std_logic;
signal SMBUSGNT         : std_logic;
signal SMWAIT           : std_logic;
signal SMBUSGNTEBI      : std_logic := '0';
signal SMTICBUSGNTEBI   : std_logic := '0';
signal SMBIGENDIAN      : std_logic := '0';
signal SMEXTBUSMUX      : std_logic := '0';
signal SMBUSBACKOFFEBI  : std_logic := '0';
signal HTRANSSMC        : std_logic_vector(1 downto 0);
signal HWRITESMC        : std_logic;
signal HSIZESMC         : std_logic_vector(2 downto 0); 
signal HBURSTSMC        : std_logic_vector(2 downto 0);
signal HWDATASMC        : std_logic_vector(31 downto 0);
signal HSELSMC          : std_logic_vector(7 downto 0);
signal HREADYINSMC      : std_logic;
signal HRDATASMC        : std_logic_vector(31 downto 0);
signal HREADYOUTSMC     : std_logic;
signal HRESPSMC         : std_logic_vector(1 downto 0);
signal HRDATAREG        : std_logic_vector(31 downto 0); 
signal HREADYOUTREG     : std_logic;
signal HRESPREG         : std_logic_vector(1 downto 0);
signal SMCS0            : std_logic;
signal SMCS1            : std_logic;
signal SMCS2            : std_logic;
signal SMCS3            : std_logic;
signal SMCS4            : std_logic;
signal SMCS5            : std_logic;
signal SMCS6            : std_logic;
signal SMCS7            : std_logic;
signal nSMCS0           : std_logic;
signal nSMCS1           : std_logic;
signal nSMCS2           : std_logic;
signal NSMCS3           : std_logic;
signal nSMCS4           : std_logic;
signal nSMCS5           : std_logic;
signal nSMCS6           : std_logic;
signal nSMCS7           : std_logic;

-- External Wait Control related signals
signal SMCActLowCS      : std_logic_vector(7 downto 0);

-- Following 4 signals commented out
-- TIC signals
-- signal HGRANTTIC        : std_logic := '0';
-- signal TESTREQA         : std_logic := '0';
-- signal TESTREQB         : std_logic := '0';
-- signal TESTACK          : std_logic;


-- Scan test related signals
signal SCANENABLE       : std_logic := '0';
signal SCANINHCLK       : std_logic;
signal SCANINnHCLK      : std_logic;
signal SCANINFBCLK0     : std_logic;
signal SCANINFBCLK1     : std_logic;
signal SCANINFBCLK2     : std_logic;
signal SCANINFBCLK3     : std_logic;
signal SCANINSMMemCLK   : std_logic;
signal SCANINnSMMemCLK  : std_logic;
signal SCANINCLKDELAY   : std_logic;

signal SCANOUTHCLK      : std_logic;
signal SCANOUTFBCLK0    : std_logic;
signal SCANOUTFBCLK1    : std_logic;
signal SCANOUTFBCLK2    : std_logic;
signal SCANOUTFBCLK3    : std_logic;
signal SCANOUTSMMemCLK  : std_logic;
signal SCANOUTnSMMemCLK : std_logic;
signal SCANOUTCLKDELAY  : std_logic;

-- Trickbox related signals
signal SMBUSREQEBI      : std_logic := '1';
signal SMTICBUSREQEBI   : std_logic := '0';
signal SMCANCELWAIT     : std_logic;

-- TrickMem related signals
signal nSMBURSTWAIT     : std_logic_vector(7 downto 0);
signal SMFBCLK          : std_logic;
--signal SMFBCLK          : std_logic_vector(3 downto 0);
signal SMMemClkRatio    : std_logic_vector(1 downto 0) := "00";
signal SMBLS7POL        : std_logic;
signal FBCLK4           : std_logic_vector(3 downto 0);

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
p_SMDATAComb : process (nSMDATAEN, SMDATAOUT)
begin
  if (nSMDATAEN(0) = '0') then
    XD(7 downto 0) <= SMDATAOUT(7 downto 0);
  else
    XD(7 downto 0) <= (others =>'Z');
  end if;

  if (nSMDATAEN(1) = '0') then
    XD(15 downto 8) <= SMDATAOUT(15 downto 8);
  else
    XD(15 downto 8) <= (others =>'Z');
  end if;

  if (nSMDATAEN(2) = '0') then
    XD(23 downto 16) <= SMDATAOUT(23 downto 16);
  else
    XD(23 downto 16) <= (others =>'Z');
  end if;

  if (nSMDATAEN(3) = '0') then
    XD(31 downto 24) <= SMDATAOUT(31 downto 24);
  else
    XD(31 downto 24) <= (others =>'Z');
  end if;
end process p_SMDATAComb;

SMDATAIN         <= XD;

-- -----------------------------------------------------------------------------
-- Drive the AHB clock with the external clock input.
-- -----------------------------------------------------------------------------
TESTACK          <= iTESTACK;
HCLK             <= XCLKIN;
nHCLK            <= '0';

-- -----------------------------------------------------------------------------
-- OR connection of split input to the Arbiter.
-- -----------------------------------------------------------------------------
HSPLIT           <= HSPLIT001 or
                    HSPLIT002 or
                    HSPLIT003 or
                    HSPLIT004;

-- -----------------------------------------------------------------------------
-- Unconnected Arbiter inputs driven LOW
-- -----------------------------------------------------------------------------
HBUSREQ003       <= '0';
HBUSREQ004       <= '0';

HRDATAUUT        <= HRDATAdly(31 downto 0);
HWDATASlave      <= "00000000000000000000000000000000" & HWDATA;

HLOCK003         <= '0';
HLOCK004         <= '0';

HSPLIT002        <= (others => '0');
HSPLIT003        <= (others => '0');
HSPLIT004        <= (others => '0');

SCANENABLE       <= '0';
SCANINHCLK       <= '0';
SCANINnHCLK      <= '0';
SCANINCLKDELAY   <= '0';
HREADYExtMem     <=  HREADYOUTSMC;

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
            HRDATAIn         => HRDATAdly,
            HREADYIn         => HREADY,
            HSPLITIn         => HSPLIT,
            HSEL             => HSELUUT,
            HMASTER          => HMASTER,
            HMASTLOCK        => HMASTLOCK,
            HRESPIn          => HRESP,
            HRDATAdly        => HRDATAdly,
            HREADYdly        => HREADYUUT,
            HRESPdly         => HRESPUUT,
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
-- SSMC and the TIC Module Instantiation
-- -----------------------------------------------------------------------------
uut : Ssmc
  port map (
-- Inputs
                   HCLK             => HCLK,
                   SMMEMCLK         => HCLK,
                   nSMMEMCLK        => nHCLK,
                   SMMEMCLKDELAY    => SMFBCLK,
                   SMFBCLK0         => SMFBCLK,
                   SMFBCLK1         => SMFBCLK,
                   SMFBCLK2         => SMFBCLK,
                   SMFBCLK3         => SMFBCLK,
                   HRESETn          => HRESETn,
                   HADDRSMC         => HADDR(25 downto 0),
                   HTRANSSMC        => HTRANSSMC,
                   HWRITESMC        => HWRITESMC,
                   HSIZESMC         => HSIZESMC,
                   HBURSTSMC        => HBURSTSMC,
                   HWDATASMC        => HWDATASMC,
                   HSELSMC          => HSELSMC,
                   HREADYINSMC      => HREADYINSMC,
                   HADDRREG         => HADDR(11 downto 2),
                   HTRANSREG        => HTRANS,
                   HWRITEREG        => HWRITE,
                   HSIZEREG         => HSIZE,
                   HWDATAREG        => HWDATA(31 downto 0),
                   HSELREG          => HSELREG,
                   HREADYINREG      => HREADY,
                   HREADYINTIC      => HREADY,
                   HRESPTIC         => HRESP,
                   HRDATATIC        => HRDATA,
                   HGRANTTIC        => HGRANTTIC,
                   SMBUSGNTEBI      => SMBUSGNTEBI,
                   SMBUSBACKOFFEBI  => SMBUSBACKOFFEBI,
                   SMTICBUSGNTEBI   => SMTICBUSGNTEBI,
                   SMBIGENDIAN      => SMBIGENDIAN,
                   SMEXTBUSMUX      => SMEXTBUSMUX,
                   SCANENABLE       => SCANENABLE,
                   SCANINHCLK       => SCANINHCLK,
                   SCANINSMMEMCLK   => SCANINSMMemCLK,
                   SCANINnSMMEMCLK  => SCANINnSMMemCLK,
                   SCANINCLKDELAY   => SCANINCLKDELAY,
                   SCANINFBCLK0     => SCANINFBCLK0,
                   SCANINFBCLK1     => SCANINFBCLK1,
                   SCANINFBCLK2     => SCANINFBCLK2,
                   SCANINFBCLK3     => SCANINFBCLK3,
                   SMMWCS7          => SMMWCS7,
                   SMBLS7POL        => SMBLS7POL,
                   SMMemClkRatio    => SMMemClkRatio,
                   SMWAIT           => SMWAIT,
                   SMCANCELWAIT     => SMCANCELWAIT,
                   nSMBURSTWAIT     => nSMBURSTWAIT,
                   SMDATAIN         => SMDATAIN,
                   SMTESTREQA       => TESTREQA,
                   SMTESTREQB       => TESTREQB,

-- Outputs
                   HRDATASMC        => HRDATASMC,
                   HREADYOUTSMC     => HREADYOUTSMC,
                   HRESPSMC         => HRESPSMC,
                   HRDATAREG        => HRDATAREG,
                   HREADYOUTREG     => HREADYOUTREG,
                   HRESPREG         => HRESPREG,
                   HADDRTIC         => HADDRTIC,
                   HTRANSTIC        => HTRANSTIC,
                   HWRITETIC        => HWRITETIC,
                   HSIZETIC         => HSIZETIC,
                   HBURSTTIC        => HBURSTTIC,
                   HPROTTIC         => HPROTTIC,
                   HWDATATIC        => HWDATATIC,
                   HBUSREQTIC       => HBUSREQTIC,
                   HLOCKTIC         => HLOCKTIC,
                   SMBUSREQEBI      => SMBUSREQEBI,
                   SMTICBUSREQEBI   => SMTICBUSREQEBI,
                   SCANOUTHCLK      => SCANOUTHCLK,
                   SCANOUTFBCLK0    => SCANOUTFBCLK0,
                   SCANOUTFBCLK1    => SCANOUTFBCLK1,
                   SCANOUTFBCLK2    => SCANOUTFBCLK2,
                   SCANOUTFBCLK3    => SCANOUTFBCLK3,
                   SCANOUTSMMEMCLK  => SCANOUTSMMemCLK,
                   SCANOUTnSMMEMCLK => SCANOUTnSMMemCLK,
                   SCANOUTCLKDELAY  => SCANOUTCLKDELAY,
                   SMCLK            => SMCLK,
                   SMDATAOUT        => SMDATAOUT,
                   SMBAA            => SMBAA,
                   SMADDRVALID      => SMADDRVALID,
                   SMADDR           => SMADDR,
                   SMCS0            => SMCS0,
                   SMCS1            => SMCS1,
                   SMCS2            => SMCS2,
                   SMCS3            => SMCS3,
                   SMCS4            => SMCS4,
                   SMCS5            => SMCS5,
                   SMCS6            => SMCS6,
                   SMCS7            => SMCS7,
                   nSMCS0           => nSMCS0,
                   nSMCS1           => nSMCS1,
                   nSMCS2           => nSMCS2,
                   nSMCS3           => nSMCS3,
                   nSMCS4           => nSMCS4,
                   nSMCS5           => nSMCS5,
                   nSMCS6           => nSMCS6,
                   nSMCS7           => nSMCS7,
                   nSMDATAEN        => nSMDATAEN,
                   nSMWEN           => nSMWEN,
                   nSMBLS           => nSMBLS,
                   nSMOEN           => nSMOEN,
                   SMTESTACK        => iTESTACK
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
