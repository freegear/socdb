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
-- File Name              : tbench_denali2.vhd.rca
-- File Revision          : 1.10
--
-- Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Top level testbench for the Synchronouse Static Memory Controller.
--           This testbench instantiates the ssmc, the Denali Memory Models, the
--           Trickboxes and the AHB Bus Master model.
--           The Clock frequency must be kept < 40 MHz for this test bench. 
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;

library tbench;
use tbench.timing.all;
use     tbench.timingmaster.all;
use     tbench.defsmaster.all;

library trickbox;

library uut;

-- -----------------------------------------------------------------------------

entity tbench_denali2 is
end tbench_denali2;

-- -----------------------------------------------------------------------------

-- --============================== ARCHITECTURE =============================--

architecture test of tbench_denali2 is

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------
constant ORBUS : std_logic := '0';
-- If this bit is set, then testbench will have a OR bus configuration
-- Else, by default, it will be a MUX implementation

constant Databuswidth : integer := 32;
-- Databus width of the Slave

-- -----------------------------------------------------------------------------
-- Note on PARAMETERS :
-- * Verbosity       : To suppress messages other than error messages,
--                     Verbosity is to be cleared.
-- * HaltOnMismatch  : If HaltOnMismatch is set, it halts the simulation when
--                     it detects any error.
-- * XonSig          : XonSig if set, enables signals to be unknown values;
--                     else signals will take their default values.
-- * SuppressOnReset : SuppressOnReset suppresses all protocol checks on
--                     slave's output signals.
-- * Databuswidth    : Databuswidth can be set to 64 or 32, depending upon the
--                     device to be tested.
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
-- UUT (ssmc)
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
        SMMEMCLKRATIO    : in    std_logic_vector(1 downto 0);
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
-- ssmc Trickbox
-- -----------------------------------------------------------------------------

component SsmcTrick
 generic (
           Tclk             : time;
           Tclks            : time;
           Tclkl            : time;
           Tclkh            : time
          );
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HADDR            : in    std_logic_vector(5 downto 2);
        HTRANS           : in    std_logic_vector(1 downto 0);
        HWRITE           : in    std_logic;
        HSIZE            : in    std_logic_vector(2 downto 0);
        HREADYINTr       : in    std_logic;
        HWDATA           : in    std_logic_vector(31 downto 0);
        HSELSSMCTr       : in    std_logic;
        SMDATAOUT        : in    std_logic_vector(31 downto 0);
        SMADDR           : in    std_logic_vector(25 downto 0);
        SSMTrCS          : in    std_logic_vector(7 downto 0);
        nSSMTrCS         : in    std_logic_vector(7 downto 0);
        nSMDATAEN        : in    std_logic_vector(3 downto 0);
        nSMWEN           : in    std_logic;
        nSMBLS           : in    std_logic_vector(3 downto 0);
        nSMOEN           : in    std_logic;
        SMBUSREQEBI      : in    std_logic;
        SMTICBUSREQEBI   : in    std_logic;
        HRDATATr         : out   std_logic_vector(31 downto 0);
        HREADYOUTTr      : out   std_logic;
        HRESPTr          : out   std_logic_vector(1 downto 0);
        BIGENDIAN        : out   std_logic;
        SMEXTBUSMUX      : out   std_logic;
        SMMWCS7          : out   std_logic_vector(1 downto 0);
        SMWAIT           : out   std_logic;
        SMCANCELWAIT     : out   std_logic;
        SMBUSGNTEBI      : out   std_logic;
        SMBUSBACKOFFEBI  : out   std_logic;
        SMTICBUSGNTEBI   : out   std_logic;
        SMFBCLK          : out   std_logic;
        SMMemCLK         : out   std_logic;
        SMMemClkRatio    : out   std_logic_vector(1 downto 0);
        SMBLS7POL        : out   std_logic
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
-- Denali Memory Model (SRAM 1)
-- -----------------------------------------------------------------------------
component sram1
  generic (
           memory_spec      : string;
           init_file        : string
          );
  port (
        address          : in    std_logic_vector(16 downto 0);
        nCS              : in    std_logic;
        nWE              : in    std_logic;
        nOE              : in    std_logic;
        Data             : inout std_logic_vector(7 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- Denali Memory Model (SRAM 2)
-- -----------------------------------------------------------------------------
component sram2
  generic (
           memory_spec      : string;
           init_file        : string
          );
  port (
        address          : in    std_logic_vector(15 downto 0);
        nCS              : in    std_logic;
        nWE              : in    std_logic;
        nOE              : in    std_logic;
        nBLS             : in    std_logic_vector(1 downto 0);
        Data             : inout std_logic_vector(15 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- Denali Memory Model (SRAM 3) 
-- -----------------------------------------------------------------------------
component sram3
  generic (
           memory_spec : string;
           init_file   : string
          );
  port (
        address : in    STD_LOGIC_VECTOR(15 downto 0);
        nCS     : in    STD_LOGIC;
        nWE     : in    STD_LOGIC;
        nOE     : in    STD_LOGIC;
        nBLS    : in    STD_LOGIC_VECTOR(1 downto 0);
        Data    : inout STD_LOGIC_VECTOR(15 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- Denali Memory Model (SRAM 4)
-- -----------------------------------------------------------------------------
component sram4
  generic (
           memory_spec      : string;
           init_file        : string
          );
  port (
        address          : in    std_logic_vector(16 downto 0);
        nCS              : in    std_logic;
        nWE              : in    std_logic;
        nOE              : in    std_logic;
        Data             : inout std_logic_vector(7 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- Denali Memory Model (FLASH 1)
-- -----------------------------------------------------------------------------
component flash1
  generic (
           memory_spec      : string;
           init_file        : string
          );
  port (
        address          : in    std_logic_vector(21 downto 0);
        Data             : inout std_logic_vector(15 downto 0);
        nCS              : in    std_logic;
        nOE              : in    std_logic;
        nWE              : in    std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- Denali Memory Model (FLASH 2)
-- -----------------------------------------------------------------------------
component flash2
  generic (
           memory_spec      : string;
           init_file        : string
          );
  port (
        address          : in    std_logic_vector(18 downto 0);
        Data             : inout std_logic_vector(15 downto 0);
        nCS              : in    std_logic;
        nOE              : in    std_logic;
        nWE              : in    std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- Denali Memory Model (FLASH 2)
-- -----------------------------------------------------------------------------

component S_28f6408W30B70_flash 
  generic (
           memory_spec       : string;
           init_file         : string
          );
  port (
        a                : in    STD_LOGIC_VECTOR(21 downto 0);
        dq               : inout STD_LOGIC_VECTOR(15 downto 0);
        cebar            : in    STD_LOGIC;
        oebar            : in    STD_LOGIC;
        webar            : in    STD_LOGIC;
        wpbar            : in    STD_LOGIC;
        resetbar         : in    STD_LOGIC;
        clk              : in    STD_LOGIC;
        advbar           : in    STD_LOGIC;
        waitbar          : out   STD_LOGIC;
        vpp              : in    STD_LOGIC
     );
end component;

-- -----------------------------------------------------------------------------
-- Denali Memory Model (MROM 1)
-- -----------------------------------------------------------------------------
component mrom1
  generic (
           memory_spec      : string;
           init_file        : string
          );
  port (
        address          : in    std_logic_vector(18 downto 0);
        nCS              : in    std_logic;
        nOE              : in    std_logic;
        Data             : inout std_logic_vector(31 downto 0);
        nWRD             : in    std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- Denali Memory Model (MROM 2)
-- -----------------------------------------------------------------------------
component mrom2
  generic (
           memory_spec      : string;
           init_file        : string
          );
  port (
        address          : in    std_logic_vector(19 downto 0);
        nCS              : in    std_logic;
        nOE              : in    std_logic;
        Data             : inout std_logic_vector(31 downto 0);
        nWRD             : in    std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
-- AMBA related signals
signal nHCLK            : std_logic;
signal HCLK             : std_logic;
signal HRESETn          : std_logic;
signal HADDR            : std_logic_vector(31 downto 0);
signal HRDATA           : std_logic_vector(63 downto 0);
signal HWDATA           : std_logic_vector(63 downto 0);
signal HMASTLOCK        : std_logic;
signal HWRITE           : std_logic;
signal HSIZE            : std_logic_vector(2 downto 0);
signal HBURST           : std_logic_vector(2 downto 0);
signal HPROT            : std_logic_vector(3 downto 0);
signal HTRANS           : std_logic_vector(1 downto 0);
signal HRESP            : std_logic_vector(1 downto 0);
signal DefSlaveSel      : std_logic;
signal HREADY           : std_logic;
signal HSPLIT           : std_logic_vector(15 downto 0);
signal HMASTER          : std_logic_vector(3 downto 0);
signal HBUSREQ          : std_logic := '1';
signal HGRANT           : std_logic := '1';
signal HLOCK            : std_logic := '0';

signal HSEL             : std_logic_vector(15 downto 0);
signal DelHSEL          : std_logic_vector(15 downto 0);
signal DelDefSel        : std_logic;

signal HREADYOutDef     : std_logic;
signal HREADYOut0       : std_logic;
signal HREADYOut1       : std_logic;
signal HREADYOut2       : std_logic;
signal HREADYOut3       : std_logic;
signal HREADYOut4       : std_logic;
signal HREADYOut5       : std_logic;
signal HREADYOut6       : std_logic;
signal HREADYOut7       : std_logic;
signal HREADYOut8       : std_logic;
signal HREADYOut9       : std_logic;
signal HREADYOut10      : std_logic;
signal HREADYOR         : std_logic;
signal HREADYMUX        : std_logic;

signal VRG0             : std_logic_vector(31 downto 0);
signal VRG1             : std_logic_vector(31 downto 0);
signal VRG2             : std_logic_vector(31 downto 0);
signal VRG3             : std_logic_vector(31 downto 0);
signal VRG4             : std_logic_vector(31 downto 0);
signal VRG5             : std_logic_vector(31 downto 0);
signal VRG6             : std_logic_vector(31 downto 0);
signal VRG7             : std_logic_vector(31 downto 0);

signal iVRG0            : std_logic_vector(31 downto 0);
signal iVRG1            : std_logic_vector(31 downto 0);
signal iVRG2            : std_logic_vector(31 downto 0);
signal iVRG3            : std_logic_vector(31 downto 0);

signal HRDATAOutDef     : std_logic_vector(63 downto 0);
signal HRDATAOut0       : std_logic_vector(63 downto 0);
signal HRDATAOut1       : std_logic_vector(63 downto 0);
signal HRDATAOut2       : std_logic_vector(63 downto 0);
signal HRDATAOut3       : std_logic_vector(63 downto 0);
signal HRDATAOut4       : std_logic_vector(63 downto 0);
signal HRDATAOut5       : std_logic_vector(63 downto 0);
signal HRDATAOut6       : std_logic_vector(63 downto 0);
signal HRDATAOut7       : std_logic_vector(63 downto 0);
signal HRDATAOut8       : std_logic_vector(63 downto 0);
signal HRDATAOut9       : std_logic_vector(63 downto 0);
signal HRDATAOut10      : std_logic_vector(63 downto 0);
signal iHRDATAOut0      : std_logic_vector(63 downto 0);
signal iHRDATAOut1      : std_logic_vector(63 downto 0);
signal iHRDATAOut2      : std_logic_vector(63 downto 0);
signal iHRDATAOut3      : std_logic_vector(63 downto 0);
signal iHRDATAOut4      : std_logic_vector(63 downto 0);
signal iHRDATAOut5      : std_logic_vector(63 downto 0);
signal iHRDATAOut6      : std_logic_vector(63 downto 0);
signal iHRDATAOut7      : std_logic_vector(63 downto 0);
signal iHRDATAOut8      : std_logic_vector(63 downto 0);
signal iHRDATAOut9      : std_logic_vector(63 downto 0);
signal iHRDATAOut10     : std_logic_vector(63 downto 0);
signal HRDATAOR         : std_logic_vector(63 downto 0);
signal HRDATAMUX        : std_logic_vector(63 downto 0);

signal HRESPOutDef      : std_logic_vector(1 downto 0);
signal HRESPOut0        : std_logic_vector(1 downto 0);
signal HRESPOut1        : std_logic_vector(1 downto 0);
signal HRESPOut2        : std_logic_vector(1 downto 0);
signal HRESPOut3        : std_logic_vector(1 downto 0);
signal HRESPOut4        : std_logic_vector(1 downto 0);
signal HRESPOut5        : std_logic_vector(1 downto 0);
signal HRESPOut6        : std_logic_vector(1 downto 0);
signal HRESPOut7        : std_logic_vector(1 downto 0);
signal HRESPOut8        : std_logic_vector(1 downto 0);
signal HRESPOut9        : std_logic_vector(1 downto 0);
signal HRESPOut10       : std_logic_vector(1 downto 0);
signal HRESPOR          : std_logic_vector(1 downto 0);
signal HRESPMUX         : std_logic_vector(1 downto 0);

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
signal SMBUSGNTEBI      : std_logic;
signal SMTICBUSGNTEBI   : std_logic;
signal SMBIGENDIAN      : std_logic;
signal SMEXTBUSMUX      : std_logic;
signal SMBUSBACKOFFEBI  : std_logic := '0';
signal nWP              : std_logic := '1';

-- External Wait Control related signals
signal SMCActLowCS      : std_logic_vector(7 downto 0);

-- TIC signals
signal HGRANTTIC        : std_logic := '0';
signal SMTESTREQA       : std_logic := '0';
signal SMTESTREQB       : std_logic := '0';
signal SMTESTACK        : std_logic;

-- Scan test related signals
signal SCANENABLE       : std_logic := '0';
signal SCANINHCLK       : std_logic;
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
signal SCANOUTSMMEMCLK  : std_logic;
signal SCANOUTnSMMEMCLK : std_logic;

-- Trickbox related signals
signal SMBUSREQEBI      : std_logic := '1';
signal SMTICBUSREQEBI   : std_logic := '0';
signal SMCANCELWAIT     : std_logic; 

signal nSMBURSTWAIT     : std_logic_vector(7 downto 0) := "11111111";
signal SMFBCLK          : std_logic;
signal SMMemCLK         : std_logic;
signal SMMemClkRatio    : std_logic_vector(1 downto 0);
signal SMBLS7POL        : std_logic;
signal nSMMEMCLK        : std_logic;

signal FBCLK4           : std_logic_vector(3 downto 0);

-- Denali model related signal
signal nWRD             : std_logic := '1'; 
signal HIGH             : std_logic := '1';
                         -- Logic high for Vpp       
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

nHCLK            <= not HCLK;

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
-- Connect all the scan inputs to '0' to prevent interference with functional
-- mode tests.
-- -----------------------------------------------------------------------------
SCANENABLE       <= '0';
SCANINHCLK       <= '0';
SCANINFBCLK0     <= '0';
SCANINFBCLK1     <= '0';
SCANINFBCLK2     <= '0';
SCANINFBCLK3     <= '0';
SCANINSMMemCLK   <= '0';
SCANINnSMMemCLK  <= '0';
SCANINCLKDELAY   <= '0';

-- -----------------------------------------------------------------------------
-- Inverted SMMEMCLK
-- -----------------------------------------------------------------------------
nSMMEMCLK <= (not (SMMemCLK));

-- -----------------------------------------------------------------------------
-- Initialise iHRDATAOutx for every slave to be tested
-- -----------------------------------------------------------------------------
iHRDATAOut0      <= (to_stdlogicvector(X"00000000") &
                    HRDATAOut0(31 downto 0)) when (Databuswidth = 32)
                  else
                    HRDATAOut0;

iHRDATAOut1      <= (to_stdlogicvector(X"00000000") &
                    HRDATAOut0(31 downto 0)) when (Databuswidth = 32)
                 else
                    HRDATAOut0;

iHRDATAOut2      <= (to_stdlogicvector(X"00000000") &
                    HRDATAOut0(31 downto 0)) when (Databuswidth = 32)
                 else
                    HRDATAOut0;

iHRDATAOut3      <= (to_stdlogicvector(X"00000000") &
                    HRDATAOut0(31 downto 0)) when (Databuswidth = 32)
                 else
                    HRDATAOut0;

iHRDATAOut4      <= (to_stdlogicvector(X"00000000") &
                    HRDATAOut0(31 downto 0)) when (Databuswidth = 32)
                 else
                    HRDATAOut0;

iHRDATAOut5      <= (to_stdlogicvector(X"00000000") &
                    HRDATAOut0(31 downto 0)) when (Databuswidth = 32)
                 else
                    HRDATAOut0;

iHRDATAOut6      <= (to_stdlogicvector(X"00000000") &
                    HRDATAOut0(31 downto 0)) when (Databuswidth = 32)
                 else
                    HRDATAOut0;

iHRDATAOut7      <= (to_stdlogicvector(X"00000000") &
                    HRDATAOut0(31 downto 0)) when (Databuswidth = 32)
                 else
                    HRDATAOut0;

iHRDATAOut8      <= (to_stdlogicvector(X"00000000") &
                    HRDATAOut1(31 downto 0)) when (Databuswidth = 32)
                 else
                    HRDATAOut1;

iHRDATAOut9      <= (to_stdlogicvector(X"00000000") &
                    HRDATAOut2(31 downto 0)) when (Databuswidth = 32)
                 else
                    HRDATAOut2;


iHRDATAOut10     <= (to_stdlogicvector(X"00000000") &
                    HRDATAOut3(31 downto 0)) when (Databuswidth = 32)
                 else
                    HRDATAOut3;

-- -----------------------------------------------------------------------------
-- For MUX bus Implementations
-- -----------------------------------------------------------------------------
HREADYMUX        <= HREADYOut0 when (DelHSEL(0) = '1')
                 else
                    HREADYOut0 when (DelHSEL(1) = '1')
                 else
                    HREADYOut0 when (DelHSEL(2) = '1')
                 else
                    HREADYOut0 when (DelHSEL(3) = '1')
                 else
                    HREADYOut0 when (DelHSEL(4) = '1')
                 else
                    HREADYOut0 when (DelHSEL(5) = '1')
                 else
                    HREADYOut0 when (DelHSEL(6) = '1')
                 else
                    HREADYOut0 when (DelHSEL(7) = '1')
                 else
                    HREADYOut1 when (DelHSEL(8) = '1')
                 else
                    HREADYOut2 when (DelHSEL(9) = '1')
                 else
                    HREADYOut3 when (DelHSEL(10) = '1')
                 else
                    HREADYOutDef when DelDefSel = '1'
                 else
                    '0';

HRESPMUX         <= HRESPOut0 when (DelHSEL(0) = '1')
                 else
                    HRESPOut0 when (DelHSEL(1) = '1')
                 else
                    HRESPOut0 when (DelHSEL(2) = '1')
                 else
                    HRESPOut0 when (DelHSEL(3) = '1')
                 else
                    HRESPOut0 when (DelHSEL(4) = '1')
                 else
                    HRESPOut0 when (DelHSEL(5) = '1')
                 else
                    HRESPOut0 when (DelHSEL(6) = '1')
                 else
                    HRESPOut0 when (DelHSEL(7) = '1')
                 else
                    HRESPOut1 when (DelHSEL(8) = '1')
                 else
                    HRESPOut2 when (DelHSEL(9) = '1')
                 else
                    HRESPOut3 when (DelHSEL(10) = '1')
                 else
                    HRESPOutDef when DelDefSel = '1'
                 else
                    "00";

HRDATAMUX        <= iHRDATAOut0 when (DelHSEL(0) = '1')
                 else
                    iHRDATAOut0 when (DelHSEL(1) = '1')
                 else
                    iHRDATAOut0 when (DelHSEL(2) = '1')
                 else
                    iHRDATAOut0 when (DelHSEL(3) = '1')
                 else
                    iHRDATAOut0 when (DelHSEL(4) = '1')
                 else
                    iHRDATAOut0 when (DelHSEL(5) = '1')
                 else
                    iHRDATAOut0 when (DelHSEL(6) = '1')
                 else
                    iHRDATAOut0 when (DelHSEL(7) = '1')
                 else
                    iHRDATAOut8 when (DelHSEL(8) = '1')
                 else
                    iHRDATAOut9 when (DelHSEL(9) = '1')
                 else
                    iHRDATAOut10 when (DelHSEL(10) = '1')
                 else
                    HRDATAOutDef when DelDefSel = '1'
                 else
                    to_stdlogicvector(X"0000000000000000");

-- -----------------------------------------------------------------------------
-- For OR bus Implementations
-- -----------------------------------------------------------------------------
HRESPOR          <= HRESPOut0 or HRESPOut1 or HRESPOut2 or
                    HRESPOut3 or HRESPOut4 or HRESPOut5 or
                    HRESPOut6 or HRESPOut7 or HRESPOut8 or
                    HRESPOut9 or HRESPOut10 or HRESPOutDef;

HREADYOR         <= HREADYOut0 or HREADYOut1 or HREADYOut2 or
                    HREADYOut3 or HREADYOut4 or HREADYOut5 or
                    HREADYOut6 or HREADYOut7 or HREADYOut8 or
                    HREADYOut9 or HREADYOut10 or HREADYOutDef;

HRDATAOR         <= iHRDATAOut0 or iHRDATAOut1 or iHRDATAOut2 or
                    iHRDATAOut3 or iHRDATAOut4 or iHRDATAOut5 or
                    iHRDATAOut6 or iHRDATAOut7 or iHRDATAOut8 or
                    iHRDATAOut9 or iHRDATAOut10 or HRDATAOutDef;

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
-- Memory Data Bus multiplexing
-- -----------------------------------------------------------------------------
p_SMDATAComb : process (nSMDATAEN, SMDATAOUT)
begin
  if (nSMDATAEN(0) = '0') then
    SMDATA(7 downto 0) <= SMDATAOUT(7 downto 0);
  else
    SMDATA(7 downto 0) <= (others =>'Z');
  end if;

  if (nSMDATAEN(1) = '0') then
    SMDATA(15 downto 8) <= SMDATAOUT(15 downto 8);
  else
    SMDATA(15 downto 8) <= (others =>'Z');
  end if;

  if (nSMDATAEN(2) = '0') then
    SMDATA(23 downto 16) <= SMDATAOUT(23 downto 16);
  else
    SMDATA(23 downto 16) <= (others =>'Z');
  end if;

  if (nSMDATAEN(3) = '0') then
    SMDATA(31 downto 24) <= SMDATAOUT(31 downto 24);
  else
    SMDATA(31 downto 24) <= (others =>'Z');
  end if;
end process p_SMDATAComb;

SMDATA           <= (others => 'H');
SMDATAIN         <= SMDATA;

-- -----------------------------------------------------------------------------
-- Component Instantiations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- AHB Slave Testbench Instantiation
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
-- Address Decoder Instantiation
-- -----------------------------------------------------------------------------
udecoder : decoder
  port map (
            HADDR            => HADDR,
            HSEL             => HSEL,
            DefSlaveSel      => DefSlaveSel
           );

-- -----------------------------------------------------------------------------
-- SSMC Trickbox Instantiation
-- -----------------------------------------------------------------------------
uSsmcTrick : SsmcTrick
 generic map (
              Tclk             => Tclk,
              Tclks            => Tclks,
              Tclkl            => Tclkl,
              Tclkh            => Tclkh  
             )
  port map   (
              HCLK             => HCLK,
              HRESETn          => HRESETn,
              HADDR            => HADDR(5 downto 2),
              HTRANS           => HTRANS,
              HWRITE           => HWRITE,
              HSIZE            => HSIZE,
              HREADYINTr       => HREADY,
              HWDATA           => HWDATA(31 downto 0),
              HSELSSMCTr       => HSEL(9),
              SMDATAOUT        => SMDATAOUT,
              SMADDR           => SMADDR,
              SSMTrCS          => SMCS,
              nSSMTrCS         => nSMCS,
              nSMDATAEN        => nSMDATAEN,
              nSMWEN           => nSMWEN,
              nSMBLS           => nSMBLS,
              nSMOEN           => nSMOEN,
              SMBUSREQEBI      => SMBUSREQEBI,
              SMTICBUSREQEBI   => SMTICBUSREQEBI,
              HRDATATr         => HRDATAOut2(31 downto 0),
              HREADYOUTTr      => HREADYOut2,
              HRESPTr          => HRESPOut2,
              SMEXTBUSMUX      => SMEXTBUSMUX,
              BIGENDIAN        => SMBIGENDIAN,
              SMMWCS7          => SMMWCS7,
              SMWAIT           => SMWAIT,
              SMCANCELWAIT     => SMCANCELWAIT,
              SMBUSGNTEBI      => SMBUSGNTEBI,
              SMBUSBACKOFFEBI  => SMBUSBACKOFFEBI,
              SMTICBUSGNTEBI   => SMTICBUSGNTEBI,
              SMFBCLK          => SMFBCLK,
              SMMemCLK         => SMMemCLK,
              SMMemClkRatio    => SMMemClkRatio,
              SMBLS7POL        => SMBLS7POL
             );

-- -----------------------------------------------------------------------------
-- Denali Memory Model (SRAM 1) Instantiation
-- -----------------------------------------------------------------------------
usram1 : sram1
  generic map (
               memory_spec      => "../../denali/sram1.spc",
               init_file        => "../../denali/sram1.dat"
              )
  port map (
            address          => SMADDR(16 downto 0),
            nCS              => nSMCS(0),
            nWE              => nSMBLS(0),
            nOE              => nSMOEN,
            Data             => SMDATA(7 downto 0)
           );

-- -----------------------------------------------------------------------------
-- Denali Memory Model (SRAM 2) Instantiation
-- -----------------------------------------------------------------------------
usram2 : sram2
  generic map (
               memory_spec      => "../../denali/sram2.spc",
               init_file        => "../../denali/sram2.dat"
              )
  port map (
            address          => SMADDR(15 downto 0),
            nCS              => nSMCS(1),
            nWE              => nSMWEN,
            nOE              => nSMOEN,
            nBLS             => nSMBLS(1 downto 0),
            Data             => SMDATA(15 downto 0)
           );

-- -----------------------------------------------------------------------------
-- Denali Memory Model (FLASH 3) Instantiation to build 16 bit Sync. memory
-- -----------------------------------------------------------------------------
uflash3 :S_28f6408W30B70_flash
  generic map (
               memory_spec      => "../../denali/28f6408W30B70_flash.spc",
               init_file        => "../../denali/28f6408W30B70_flash.dat"
              )
   port map (
              a                => SMADDR(21 downto 0),
              dq               => SMDATA(15 downto 0),
              cebar            => nSMCS(2),
              oebar            => nSMOEN,
              webar            => nSMWEN,
              wpbar            => nWP,
              resetbar         => HRESETn,
              clk              => SMFBCLK,
              advbar           => SMADDRVALID,
              waitbar          => nSMBURSTWAIT(2),
              vpp              => HIGH 
            );

-- -----------------------------------------------------------------------------
-- Denali Memory Model (FLASH 2) Instantiation
-- -----------------------------------------------------------------------------
uflash2 : flash2
  generic map (
               memory_spec      => "../../denali/flash2.spc",
               init_file        => "../../denali/flash2.dat"
              )
  port map (
            address          => SMADDR(18 downto 0),
            Data             => SMDATA(15 downto 0),
            nCS              => nSMCS(3),
            nOE              => nSMOEN,
            nWE              => nSMWEN
           );

-- -----------------------------------------------------------------------------
-- Making memory of 32 bit using 8 bit memory
-- -----------------------------------------------------------------------------
usram4a : sram1
  generic map (
               memory_spec      => "../../denali/sram1.spc",
               init_file        => "../../denali/sram1.dat"
              )
  port map (
            address          => SMADDR(16 downto 0),
            nCS              => nSMCS(4),
            nWE              => nSMBLS(0),
            nOE              => nSMOEN,
            Data             => SMDATA(7 downto 0)
           );
usram4b : sram1
  generic map (
               memory_spec      => "../../denali/sram1.spc",
               init_file        => "../../denali/sram1.dat"
              )
  port map (
            address          => SMADDR(16 downto 0),
            nCS              => nSMCS(4),
            nWE              => nSMBLS(1),
            nOE              => nSMOEN,
            Data             => SMDATA(15 downto 8)
           );
usram4c : sram1
  generic map (
               memory_spec      => "../../denali/sram1.spc",
               init_file        => "../../denali/sram1.dat"
              )
  port map (
            address          => SMADDR(16 downto 0),
            nCS              => nSMCS(4),
            nWE              => nSMBLS(2),
            nOE              => nSMOEN,
            Data             => SMDATA(23 downto 16)
           );
usram4d : sram1
  generic map (
               memory_spec      => "../../denali/sram1.spc",
               init_file        => "../../denali/sram1.dat"
              )
  port map (
            address          => SMADDR(16 downto 0),
            nCS              => nSMCS(4),
            nWE              => nSMBLS(3),
            nOE              => nSMOEN,
            Data             => SMDATA(31 downto 24)
           );

-- -----------------------------------------------------------------------------
-- Denali Memory Model (MROM 2) Instantiation
-- -----------------------------------------------------------------------------
umrom2 : mrom2
  generic map (
               memory_spec      => "../../denali/mrom2.spc",
               init_file        => "../../denali/mrom2.dat"
              )
  port map (
            address          => SMADDR(19 downto 0),
            nCS              => nSMCS(5),
            nOE              => nSMOEN,
            Data             => SMDATA,
            nWRD             => nWRD
           );

-- -----------------------------------------------------------------------------
-- Denali Memory Model (SRAM 3) Instantiation
-- -----------------------------------------------------------------------------
usram3 : sram3
  generic map (
               memory_spec      => "../../denali/sram3.spc",
               init_file        => "../../denali/sram3.dat"
              )
  port map (
            address          => SMADDR(15 downto 0),
            nCS              => nSMCS(6),
            nWE              => nSMWEN,
            nOE              => nSMOEN,
            nBLS             => nSMBLS(1 downto 0),
            Data             => SMDATA(15 downto 0)
           );

-- -----------------------------------------------------------------------------
-- Denali Memory Model (SRAM 4) Instantiation
-- -----------------------------------------------------------------------------
usram4 : sram4
  generic map (
               memory_spec      => "../../denali/sram4.spc",
               init_file        => "../../denali/sram4.dat"
              )
  port map (
            address          => SMADDR(16 downto 0),
            nCS              => nSMCS(7),
            nWE              => nSMWEN,
            nOE              => nSMOEN,
            Data             => SMDATA(7 downto 0)
           );


-- -----------------------------------------------------------------------------
-- UUT Instantiation (SSMC)
-- -----------------------------------------------------------------------------
uut : Ssmc
  port map (
            HCLK             => HCLK,
            SMMEMCLK         => SMMemCLK,
            nSMMEMCLK        => nSMMEMCLK,
            SMMEMCLKDELAY    => nSMMEMCLK,
            SMFBCLK0         => SMFBCLK,
            SMFBCLK1         => SMFBCLK,
            SMFBCLK2         => SMFBCLK,
            SMFBCLK3         => SMFBCLK,
            HRESETn          => HRESETn,
            HADDRSMC         => HADDR(25 downto 0),
            HTRANSSMC        => HTRANS,
            HWRITESMC        => HWRITE,
            HSIZESMC         => HSIZE,
            HBURSTSMC        => HBURST,
            HWDATASMC        => HWDATA(31 downto 0),
            HSELSMC          => HSEL(7 downto 0),
            HREADYINSMC      => HREADY,
            HADDRREG         => HADDR(11 downto 2),
            HTRANSREG        => HTRANS,
            HWRITEREG        => HWRITE,
            HSIZEREG         => HSIZE,
            HWDATAREG        => HWDATA(31 downto 0),
            HSELREG          => HSEL(8),
            HREADYINREG      => HREADY,
            HREADYINTIC      => HREADY,
            HRESPTIC         => HRESP,
            HRDATATIC        => HRDATA(31 downto 0),
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
            SMMEMCLKRATIO    => SMMemClkRatio,
            SMWAIT           => SMWAIT,
            SMCANCELWAIT     => SMCANCELWAIT,
            nSMBURSTWAIT     => nSMBURSTWAIT,
            SMDATAIN         => SMDATAIN,
            SMTESTREQA       => SMTESTREQA,
            SMTESTREQB       => SMTESTREQB,
            HRDATASMC        => HRDATAOut0(31 downto 0),
            HREADYOUTSMC     => HREADYOut0,
            HRESPSMC         => HRESPOut0,
            HRDATAREG        => HRDATAOut1(31 downto 0),
            HREADYOUTREG     => HREADYOut1,
            HRESPREG         => HRESPOut1,
            HADDRTIC         => OPEN,
            HTRANSTIC        => OPEN,
            HWRITETIC        => OPEN,
            HSIZETIC         => OPEN,
            HBURSTTIC        => OPEN,
            HPROTTIC         => OPEN,
            HWDATATIC        => OPEN,
            HBUSREQTIC       => OPEN,
            HLOCKTIC         => OPEN,
            SMBUSREQEBI      => SMBUSREQEBI,
            SMTICBUSREQEBI   => SMTICBUSREQEBI,
            SCANOUTHCLK      => SCANOUTHCLK,
            SCANOUTFBCLK0    => SCANOUTFBCLK0,
            SCANOUTFBCLK1    => SCANOUTFBCLK1,
            SCANOUTFBCLK2    => SCANOUTFBCLK2,
            SCANOUTFBCLK3    => SCANOUTFBCLK3,
            SCANOUTSMMEMCLK  => SCANOUTSMMEMCLK,
            SCANOUTnSMMEMCLK => SCANOUTnSMMEMCLK,
            SMCLK            => SMCLK,
            SMDATAOUT        => SMDATAOUT,
            SMBAA            => SMBAA,
            SMADDRVALID      => SMADDRVALID,
            SMADDR           => SMADDR,
            SMCS0            => SMCS(0),
            SMCS1            => SMCS(1),
            SMCS2            => SMCS(2),
            SMCS3            => SMCS(3),
            SMCS4            => SMCS(4),
            SMCS5            => SMCS(5),
            SMCS6            => SMCS(6),
            SMCS7            => SMCS(7),
            nSMCS0           => nSMCS(0),
            nSMCS1           => nSMCS(1),
            nSMCS2           => nSMCS(2),
            nSMCS3           => nSMCS(3),
            nSMCS4           => nSMCS(4),
            nSMCS5           => nSMCS(5),
            nSMCS6           => nSMCS(6),
            nSMCS7           => nSMCS(7),
            nSMDATAEN        => nSMDATAEN,
            nSMWEN           => nSMWEN,
            nSMBLS           => nSMBLS,
            nSMOEN           => nSMOEN,
            SMTESTACK        => SMTESTACK
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

end test;

-- ================================== End =================================== --
