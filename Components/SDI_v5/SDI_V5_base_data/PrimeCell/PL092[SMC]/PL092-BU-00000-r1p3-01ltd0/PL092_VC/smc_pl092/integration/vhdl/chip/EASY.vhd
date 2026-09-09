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
-- File Name              : EASY.vhd.rca
-- File Revision          : 1.12
--
-- Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
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
-- SMC and the TIC Module
-- -----------------------------------------------------------------------------
component Smc
  port (
-- Inputs
        nHCLK            : in    std_logic;
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HREADYIN         : in    std_logic;
        HADDR            : in    std_logic_vector(28 downto 0);
        HBURST           : in    std_logic_vector(2 downto 0);
        HTRANS           : in    std_logic_vector(1 downto 0);
        HWRITE           : in    std_logic;
        HSIZE            : in    std_logic_vector(2 downto 0);
        HWDATA           : in    std_logic_vector(31 downto 0);
        HSELSMC          : in    std_logic;
        HSELREG          : in    std_logic;
        HRESPTIC         : in    std_logic_vector(1 downto 0);
        HRDATATIC        : in    std_logic_vector(31 downto 0);
        HGRANTTIC        : in    std_logic;
        BIGENDIAN        : in    std_logic;
        REMAP            : in    std_logic;

        TICBUSGNTEBI     : in    std_logic;
        SMBUSGNTEBI      : in    std_logic;

        SCANENABLE       : in    std_logic;
        SCANINHCLK       : in    std_logic;
        SCANINnHCLK      : in    std_logic;

        SMWAIT           : in    std_logic;
        CANCELSMWAIT     : in    std_logic;
        SMMWCS7          : in    std_logic_vector(1 downto 0);
        SMRBLECS7        : in    std_logic; 
        SMDATAIN         : in    std_logic_vector(31 downto 0);

        TESTREQA         : in    std_logic;
        TESTREQB         : in    std_logic;

        MCBUSREQ         : in    std_logic;
        MCADDR           : in    std_logic_vector(25 downto 0);
        MCDATAOUT        : in    std_logic_vector(31 downto 0);
        MCDATAEN         : in    std_logic_vector(3 downto 0);

        EXTBUSMUX        : in    std_logic;

-- Outputs
        HRDATA           : out   std_logic_vector(31 downto 0);
        HREADYOUT        : out   std_logic;
        HRESP            : out   std_logic_vector(1 downto 0);

        HADDRTIC         : out   std_logic_vector(31 downto 0);
        HTRANSTIC        : out   std_logic_vector(1 downto 0);
        HWRITETIC        : out   std_logic;
        HSIZETIC         : out   std_logic_vector(2 downto 0);
        HBURSTTIC        : out   std_logic_vector(2 downto 0);
        HPROTTIC         : out   std_logic_vector(3 downto 0);
        HWDATATIC        : out   std_logic_vector(31 downto 0);
        HBUSREQTIC       : out   std_logic;
        HLOCKTIC         : out   std_logic;

        TICBUSREQEBI     : out   std_logic;
        SMBUSREQEBI      : out   std_logic;

        SCANOUTnHCLK     : out   std_logic;
        SCANOUTHCLK      : out   std_logic;

        SMDATAOUT        : out   std_logic_vector(31 downto 0);
        nSMDATAEN        : out   std_logic_vector(3 downto 0);
        SMADDR           : out   std_logic_vector(25 downto 0);
        SMCS             : out   std_logic_vector(7 downto 0);
        nSMBLS           : out   std_logic_vector(3 downto 0);
        nSMWEN           : out   std_logic;
        nSMOEN           : out   std_logic;

        TICREADEBI       : out   std_logic;
        TBUSOUTEBI       : out   std_logic_vector(31 downto 0);
        TESTACK          : out   std_logic;

        MCBUSGNT         : out   std_logic
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
signal HREADY        : std_logic;
signal HRESP         : std_logic_vector(1 downto 0);

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
-- Static Memory Controller Signals
-- -----------------------------------------------------------------------------
signal SCANENABLE       : std_logic;
signal SCANINHCLK       : std_logic;
signal SCANINnHCLK      : std_logic;
signal SCANOUTHCLK      : std_logic;
signal SCANOUTnHCLK     : std_logic;
signal BIGENDIAN        : std_logic;

-- External Signals
signal SMMWCS7          : std_logic_vector(1 downto 0);
signal SMRBLECS7        : std_logic;
signal SMWAIT           : std_logic;
signal CANCELSMWAIT     : std_logic;
signal SMDATAIN         : std_logic_vector(31 downto 0);
signal SMDATAOUT        : std_logic_vector(31 downto 0);
signal SMADDR           : std_logic_vector(25 downto 0);
signal SMCS             : std_logic_vector(7 downto 0);
signal nSMDATAEN        : std_logic_vector(3 downto 0) := "1111";
signal nSMWEN           : std_logic;
signal nSMBLS           : std_logic_vector(3 downto 0);
signal nSMOEN           : std_logic;

signal MCBUSREQ         : std_logic := '0';
signal MCADDR           : std_logic_vector(25 downto 0) := (others => '0');
signal MCDATAOUT        : std_logic_vector(31 downto 0) := (others => '0');
signal MCDATAEN         : std_logic_vector(3 downto 0) := (others => '0');
signal MCBUSGNT         : std_logic;

-- External signals related to the EbiSdram
signal TICBUSGNTEBI     : std_logic := '0';
signal SMBUSGNTEBI      : std_logic := '0';

signal EXTBUSMUX        : std_logic := '0';

signal TICBUSREQEBI     : std_logic;
signal SMBUSREQEBI      : std_logic;

signal TICREADEBI       : std_logic;
signal TBUSOUTEBI       : std_logic_vector(31 downto 0);

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

-- process (HRESETn, HCLK)
-- begin
--   if (HRESETn = '0') then
--     HREADYExtMem <= '1';
--   elsif (HCLK'event and HCLK = '1') then
--     if (HSELExtMem = '1') then
--       HREADYExtMem <= not HREADYExtMem;
--     else
--       HREADYExtMem <= '1';
--     end if;
--   end if;
-- end process;

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
            -- HRESPIn          => HRESPUUT,
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
-- SMC and the TIC Module Instantiation
-- -----------------------------------------------------------------------------
uut : Smc
  port map (
-- Inputs
            nHCLK              => nHCLK,
            HCLK               => HCLK,
            HRESETn            => HRESETn,
            HREADYIN           => HREADY,
            HADDR              => HADDR(28 downto 0),
            HBURST             => HBURST,
            HTRANS             => HTRANS,
            HWRITE             => HWRITE,
            HSIZE              => HSIZE,
            HWDATA             => HWDATA,
            HSELSMC            => HSELExtMem,
            HSELREG            => HSELREG,
            HRESPTIC           => HRESP,
            HRDATATIC          => HRDATA,
            HGRANTTIC          => HGRANTtic,
            BIGENDIAN          => BIGENDIAN,
            REMAP              => Remap,

            TICBUSGNTEBI       => TICBUSGNTEBI,
            SMBUSGNTEBI        => SMBUSGNTEBI,

            SCANENABLE         => SCANENABLE,
            SCANINHCLK         => SCANINHCLK,
            SCANINnHCLK        => SCANINnHCLK,
            SMWAIT             => SMWAIT,
            CANCELSMWAIT       => CANCELSMWAIT,
            SMMWCS7            => SMMWCS7,
            SMRBLECS7        => SMRBLECS7,
            SMDATAIN           => SMDATAIN,
            TESTREQA           => TESTREQA,
            TESTREQB           => TESTREQB,
            MCBUSREQ           => MCBUSREQ,
            MCADDR             => MCADDR,
            MCDATAOUT          => MCDATAOUT,
            MCDATAEN           => MCDATAEN,

            EXTBUSMUX          => EXTBUSMUX,

-- Outputs
            HRDATA           => HRDATAExtMem,
            HREADYOUT        => HREADYExtMem,
            -- HREADYOUT        => OPEN,
            HRESP            => HRESPExtMem,
            HADDRTIC         => HADDRtic,
            HTRANSTIC        => HTRANStic,
            HWRITETIC        => HWRITEtic,
            HSIZETIC         => HSIZEtic,
            HBURSTTIC        => HBURSTtic,
            HPROTTIC         => HPROTtic,
            HWDATATIC        => HWDATAtic,
            HBUSREQTIC       => HBUSREQtic,
            HLOCKTIC         => HLOCKtic,

            TICBUSREQEBI     => TICBUSREQEBI,
            SMBUSREQEBI      => SMBUSREQEBI,

            SCANOUTnHCLK     => SCANOUTnHCLK,
            SCANOUTHCLK      => SCANOUTHCLK,
            SMDATAOUT        => SMDATAOUT,
            nSMDATAEN        => nSMDATAEN,
            SMADDR           => SMADDR,
            SMCS             => SMCS,
            nSMBLS           => nSMBLS,
            nSMWEN           => nSMWEN,
            nSMOEN           => nSMOEN,

            TICREADEBI       => TICREADEBI,
            TBUSOUTEBI       => TBUSOUTEBI,

            TESTACK          => iTESTACK,
            MCBUSGNT         => MCBUSGNT
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
