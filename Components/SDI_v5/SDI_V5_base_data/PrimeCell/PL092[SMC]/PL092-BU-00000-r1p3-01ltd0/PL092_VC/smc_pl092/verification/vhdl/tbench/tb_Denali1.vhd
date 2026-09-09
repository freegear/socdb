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
-- File Name              : tb_Denali1.vhd.rca
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
--   Purpose :
--             Top level testbench for the Static Memory Controller. 
--             This testbench instantiates the SMC, the Denali Memory Models,
--             the Trickboxes and the AHB Bus Master model. 
--
--         Details of Denali models used :
--         CS    Model                    Vendor   Connection
--         CS[0] k3p9vu1000m_3_0v BROM    SAMSUNG  8Mx16 x 1 (RBLE disabled)
--         CS[1] KM68V1002C-20 SRAM       SAMSUNG  128Kx8 x 4 (RBLE disabled)
--         CS[2] k3p9vu1000m_3_3v BROM    SAMSUNG  8Mx16 x 1 (RBLE disabled)
--         CS[3] 28F800C3B_110    FLASH   INTEL    512Kx16 x 1 (RBLE disabled)
--         CS[4] K3P9VU1000M-3.3V-YC MROM SAMSUNG  8Mx16 x 1 (RBLE disabled)
--         CS[5] SST37Vf020-90 MROM       SST      256Kx8 x 1 (RBLE disabled)
--         CS[6] KM68V1002C-12 SRAM       SAMSUNG  128Kx8 x 2 (RBLE disabled)
--         CS[7] KM68V1002C-20 SRAM       SAMSUNG  128Kx8 x 1 (RBLE disabled)
--
-- -----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

library tbench;
use tbench.timing.all;
use     tbench.timingmaster.all;
use     tbench.defsmaster.all;

library trickbox;

library uut;

-- --=========================================================================--

entity tb_Denali1 is
end tb_Denali1;

-- -----------------------------------------------------------------------------

-- ================================ ARCHITECTURE ============================ --

architecture test of tb_Denali1 is

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
end  component;

-- -----------------------------------------------------------------------------
-- UUT (SMC)
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
-- SMC Trickbox
-- -----------------------------------------------------------------------------
component SmcTrick 
  generic (
           Tclk : time
          );
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HADDR            : in    std_logic_vector(6 downto 2);
        HTRANS           : in    std_logic_vector(1 downto 0);
        HWRITE           : in    std_logic;
        HSIZE            : in    std_logic_vector(2 downto 0);
        HREADYIN         : in    std_logic;
        HWDATA           : in    std_logic_vector(31 downto 0);
        HSELSMCTR        : in    std_logic;

        SMDATAOUT        : in    std_logic_vector(31 downto 0);
        SMADDR           : in    std_logic_vector(25 downto 0);
        SMCS             : in    std_logic_vector(7 downto 0);
        nSMDATAEN        : in    std_logic_vector(3 downto 0);
        nSMWEN           : in    std_logic;
        nSMBLS           : in    std_logic_vector(3 downto 0);
        nSMOEN           : in    std_logic;
        SMCActLowCS      : in    std_logic_vector(7 downto 0);
        MCBUSGNT         : in    std_logic;
        SMBUSREQ         : in    std_logic;

        HRDATA           : out   std_logic_vector(31 downto 0);
        HREADYOUT        : out   std_logic;
        HRESP            : out   std_logic_vector(1 downto 0);
        ENDIANCNT        : out   std_logic;
        REMAP            : out   std_logic;

        SMMWCS7          : out   std_logic_vector(1 downto 0);
        SMWAIT           : out   std_logic;
        nSMWAIT          : out   std_logic;
        CANCELSMWAIT     : out   std_logic;
        MCBUSREQ         : out   std_logic;
        MCADDR           : out   std_logic_vector(25 downto 0);
        MCDATAOUT        : out   std_logic_vector(31 downto 0);
        MCDATAEN         : out   std_logic_vector(3 downto 0);
        SMBUSGNT         : out   std_logic;
        EXTBUSMUX        : out   std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- Denali Memory Model (BROM 1)
-- -----------------------------------------------------------------------------
component k3p9vu1000m_3_0v
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

-- -----------------------------------------------------------------------------
-- Denali Memory Model (SRAM 1)
-- -----------------------------------------------------------------------------
component km68v1002c_12
  port (
        a     : in    std_logic_vector(16 downto 0);
        csbar : in    std_logic;
        webar : in    std_logic;
        oebar : in    std_logic;
        io    : inout std_logic_vector(7 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- Denali Memory Model (SRAM 2)
-- -----------------------------------------------------------------------------
component km68v1002c_20
  port (
        a     : in    std_logic_vector(16 downto 0);
        csbar : in    std_logic;
        webar : in    std_logic;
        oebar : in    std_logic;
        io    : inout std_logic_vector(7 downto 0)
        );
end component;

-- -----------------------------------------------------------------------------
-- Denali Memory Model (BROM2) 
-- -----------------------------------------------------------------------------
component k3p9vu1000m_3_3v
  generic (
           memory_spec : string;
           init_file   : string
          );
  port (
       a     : in    STD_LOGIC_VECTOR(22 downto 0);
       cebar : in    STD_LOGIC;
       oebar : in    STD_LOGIC;
       q     : inout STD_LOGIC_VECTOR(15 downto 0);
       bhe   : in    STD_LOGIC
       );
end component;

-- -----------------------------------------------------------------------------
-- Denali Memory Model (FLASH 1)
-- -----------------------------------------------------------------------------
component x28f640b3b_3v_100
  port (
        address : in    std_logic_vector(21 downto 0);
        data    : inout std_logic_vector(15 downto 0);
        cebar   : in    std_logic;
        oebar   : in    std_logic;
        webar   : in    std_logic;
        wpbar   : in    std_logic;
        rpbar   : in    std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- Denali Memory Model (FLASH 2)
-- -----------------------------------------------------------------------------
component x28f800c3b_110
  port (
        a     : in    std_logic_vector(18 downto 0);
        dq    : inout std_logic_vector(15 downto 0);
        cebar : in    std_logic;
        oebar : in    std_logic;
        webar : in    std_logic;
        wpbar : in    std_logic;
        rpbar : in    std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- Denali Memory Model (MROM 1)
-- -----------------------------------------------------------------------------
component k3p9vu1000m_33v_yc
  generic (
           memory_spec : string;
           init_file   : string
          );

  port (
        a     : in    std_logic_vector(22 downto 0);
        cebar : in    std_logic;
        oebar : in    std_logic;
        q     : inout std_logic_vector(15 downto 0);
        bhe   : in    std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- Denali Memory Model (MROM 2)
-- -----------------------------------------------------------------------------
component sst37vf020_90
  generic (
           memory_spec : string;
           init_file   : string
          );

  port (
        a     : in    std_logic_vector(17 downto 0);
        cebar : in    std_logic;
        oebar : in    std_logic;
        dq    : inout std_logic_vector(7 downto 0)
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
signal HREADYOut2       : std_logic := '1';
signal HREADYOut3       : std_logic := '1';
signal HREADYOut4       : std_logic := '1';
signal HREADYOut5       : std_logic := '1';
signal HREADYOut6       : std_logic := '1';
signal HREADYOut7       : std_logic := '1';
signal HREADYOut8       : std_logic := '1';
signal HREADYOut9       : std_logic := '1';
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
signal HRDATAOR         : std_logic_vector(63 downto 0);
signal HRDATAMUX        : std_logic_vector(63 downto 0);

signal HRESPOutDef      : std_logic_vector(1 downto 0);
signal HRESPOut0        : std_logic_vector(1 downto 0);
signal HRESPOut1        : std_logic_vector(1 downto 0);
signal HRESPOut2        : std_logic_vector(1 downto 0) := "00";
signal HRESPOut3        : std_logic_vector(1 downto 0) := "00";
signal HRESPOut4        : std_logic_vector(1 downto 0) := "00";
signal HRESPOut5        : std_logic_vector(1 downto 0) := "00";
signal HRESPOut6        : std_logic_vector(1 downto 0) := "00";
signal HRESPOut7        : std_logic_vector(1 downto 0) := "00";
signal HRESPOut8        : std_logic_vector(1 downto 0) := "00";
signal HRESPOut9        : std_logic_vector(1 downto 0) := "00";
signal HRESPOR          : std_logic_vector(1 downto 0) := "00";
signal HRESPMUX         : std_logic_vector(1 downto 0) := "00";

-- SMC related signals
signal SMADDR           : std_logic_vector(25 downto 0);
signal SMDATA           : std_logic_vector(31 downto 0) := (others => 'H');
signal SMCS             : std_logic_vector(7 downto 0);
signal nSMWEN           : std_logic;
signal nSMBLS           : std_logic_vector(3 downto 0);
signal nSMOEN           : std_logic;
signal SMDATAOUT        : std_logic_vector(31 downto 0);
signal SMDATAIN         : std_logic_vector(31 downto 0);
signal nSMDATAEN        : std_logic_vector(3 downto 0);
signal SMMWCS7          : std_logic_vector(1 downto 0);
signal SMRBLECS7        : std_logic;
signal SMBUSREQ         : std_logic;
signal SMBUSGNT         : std_logic;
signal SMWAIT           : std_logic;
signal nSMWAIT          : std_logic;
signal MCBUSREQ         : std_logic;
signal MCADDR           : std_logic_vector(25 downto 0);
signal MCDATAOUT        : std_logic_vector(31 downto 0);
signal MCDATAEN         : std_logic_vector(3 downto 0);
signal MCBUSGNT         : std_logic;

-- External Wait Control related signals
signal SMCActLowCS      : std_logic_vector(7 downto 0);
signal SMCTrWAIT        : std_logic_vector(7 downto 0);
signal SMCTrAllWAITPOL  : std_logic_vector(7 downto 0);
signal CANCELSMWAIT     : std_logic;

--TIC signals
signal HGRANTTIC        : std_logic := '0';
signal TESTREQA         : std_logic := '0';
signal TESTREQB         : std_logic := '0';

-- Static inputs
signal BIGENDIAN        : std_logic;
signal REMAP            : std_logic;
signal ZEROFILL         : std_logic_vector(7 downto 0) := (others => '0'); 
signal ONEFILL          : std_logic_vector(7 downto 0) :=  (others => '1');

-- Scan test related signals
signal SCANENABLE       : std_logic := '0';
signal SCANINHCLK       : std_logic;
signal SCANINnHCLK      : std_logic;
signal SCANOUTHCLK      : std_logic;
signal SCANOUTnHCLK     : std_logic;
signal SCANIN           : std_logic := '0';
signal SCANOUT          : std_logic := '0';

signal nWP              : std_logic := '1';
signal nRP              : std_logic := '1';
signal nADV             : std_logic := '1';
signal BHE              : std_logic := '1';
signal nWAIT            : std_logic := '1';

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

SMRBLECS7        <= '0';
-- -----------------------------------------------------------------------------
-- Connect all the scan inputs to '0' to prevent interference with functional
-- mode tests.
-- -----------------------------------------------------------------------------
SCANENABLE       <= '0';
SCANINHCLK       <= '0';
SCANINnHCLK      <= '0';

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

iHRDATAOut2      <= (to_stdlogicvector(X"00000000") &
                    HRDATAOut2(31 downto 0)) when (Databuswidth = 32)
                 else
                    HRDATAOut2;

iHRDATAOut3      <= (to_stdlogicvector(X"00000000") &
                    HRDATAOut3(31 downto 0)) when (Databuswidth = 32)
                 else
                    HRDATAOut3;

iHRDATAOut4      <= (to_stdlogicvector(X"00000000") &
                    HRDATAOut4(31 downto 0)) when (Databuswidth = 32)
                 else
                    HRDATAOut4;

iHRDATAOut5      <= (to_stdlogicvector(X"00000000") &
                    HRDATAOut5(31 downto 0)) when (Databuswidth = 32)
                 else
                    HRDATAOut5;

iHRDATAOut6      <= (to_stdlogicvector(X"00000000") &
                    HRDATAOut6(31 downto 0)) when (Databuswidth = 32)
                 else
                    HRDATAOut6;

iHRDATAOut7      <= (to_stdlogicvector(X"00000000") &
                    HRDATAOut7(31 downto 0)) when (Databuswidth = 32)
                 else
                    HRDATAOut7;

iHRDATAOut8      <= (to_stdlogicvector(X"00000000") &
                    HRDATAOut8(31 downto 0)) when (Databuswidth = 32)
                 else
                    HRDATAOut8;

iHRDATAOut9      <= (to_stdlogicvector(X"00000000") &
                    HRDATAOut9(31 downto 0)) when (Databuswidth = 32)
                 else
                    HRDATAOut9;

-- -----------------------------------------------------------------------------
-- For MUX bus Implementations
-- -----------------------------------------------------------------------------
HREADYMUX        <= HREADYOut0 when (DelHSEL(0) = '1')
                 else
                    HREADYOut0 when (DelHSEL(1) = '1')
                 else
                    HREADYOut1 when (DelHSEL(2) = '1')
                 else
                    HREADYOut2 when (DelHSEL(3) = '1')
                 else
                    HREADYOut3 when (DelHSEL(4) = '1')
                 else
                    HREADYOut4 when (DelHSEL(5) = '1')
                 else
                    HREADYOut5 when (DelHSEL(6) = '1')
                 else
                    HREADYOut6 when (DelHSEL(7) = '1')
                 else
                    HREADYOut7 when (DelHSEL(8) = '1')
                 else
                    HREADYOut8 when (DelHSEL(9) = '1')
                 else
                    HREADYOut9 when (DelHSEL(10) = '1')
                 else
                    HREADYOutDef when DelDefSel = '1'
                 else
                    '0';

HRESPMUX         <= HRESPOut0 when (DelHSEL(0) = '1')
                 else
                    HRESPOut0 when (DelHSEL(1) = '1')
                 else
                    HRESPOut1 when (DelHSEL(2) = '1')
                 else
                    HRESPOut2 when (DelHSEL(3) = '1')
                 else
                    HRESPOut3 when (DelHSEL(4) = '1')
                 else
                    HRESPOut4 when (DelHSEL(5) = '1')
                 else
                    HRESPOut5 when (DelHSEL(6) = '1')
                 else
                    HRESPOut6 when (DelHSEL(7) = '1')
                 else
                    HRESPOut7 when (DelHSEL(8) = '1')
                 else
                    HRESPOut8 when (DelHSEL(9) = '1')
                 else
                    HRESPOut9 when (DelHSEL(10) = '1')
                 else
                    HRESPOutDef when DelDefSel = '1'
                 else
                    "00";

HRDATAMUX        <= iHRDATAOut0 when (DelHSEL(0) = '1')
                 else
                    iHRDATAOut0 when (DelHSEL(1) = '1')
                 else
                    iHRDATAOut1 when (DelHSEL(2) = '1')
                 else
                    iHRDATAOut2 when (DelHSEL(3) = '1')
                 else
                    iHRDATAOut3 when (DelHSEL(4) = '1')
                 else
                    iHRDATAOut4 when (DelHSEL(5) = '1')
                 else
                    iHRDATAOut5 when (DelHSEL(6) = '1')
                 else
                    iHRDATAOut6 when (DelHSEL(7) = '1')
                 else
                    iHRDATAOut7 when (DelHSEL(8) = '1')
                 else
                    iHRDATAOut8 when (DelHSEL(9) = '1')
                 else
                    iHRDATAOut9 when (DelHSEL(10) = '1')
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
                    HRESPOut9 or HRESPOutDef;

HREADYOR         <= HREADYOut0 or HREADYOut1 or HREADYOut2 or
                    HREADYOut3 or HREADYOut4 or HREADYOut5 or
                    HREADYOut6 or HREADYOut7 or HREADYOut8 or
                    HREADYOut9 or HREADYOutDef;

HRDATAOR         <= iHRDATAOut0 or iHRDATAOut1 or iHRDATAOut2 or
                    iHRDATAOut3 or iHRDATAOut4 or iHRDATAOut5 or
                    iHRDATAOut6 or iHRDATAOut7 or iHRDATAOut8 or
                    iHRDATAOut9 or HRDATAOutDef;

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
-- SMC Trickbox Instantiation
-- -----------------------------------------------------------------------------
uSmcTrick : SmcTrick
  generic map (
               Tclk          => Tclk
              )
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HADDR            => HADDR(6 downto 2),
            HTRANS           => HTRANS,
            HWRITE           => HWRITE,
            HSIZE            => HSIZE,
            HREADYIN         => HREADY,
            HWDATA           => HWDATA(31 downto 0),
            HSELSMCTR        => HSEL(2),

            SMDATAOUT        => SMDATAOUT,
            SMADDR           => SMADDR,
            SMCS             => SMCS,
            nSMDATAEN        => nSMDATAEN,
            nSMWEN           => nSMWEN,
            nSMBLS           => nSMBLS,
            nSMOEN           => nSMOEN,
            SMCActLowCS      => SMCActLowCS,
            MCBUSGNT         => MCBUSGNT,
            SMBUSREQ         => SMBUSREQEBI,

            HRDATA           => HRDATAOut1(31 downto 0),
            HREADYOUT        => HREADYOut1,
            HRESP            => HRESPOut1,
            ENDIANCNT        => BIGENDIAN,
            REMAP            => REMAP,

            SMMWCS7          => SMMWCS7,
            SMWAIT           => SMWAIT,
            nSMWAIT          => nSMWAIT,
            CANCELSMWAIT     => CANCELSMWAIT,
            MCBUSREQ         => MCBUSREQ,
            MCADDR           => MCADDR,
            MCDATAOUT        => MCDATAOUT,
            MCDATAEN         => MCDATAEN,
            SMBUSGNT         => SMBUSGNTEBI,
            EXTBUSMUX        => EXTBUSMUX
           );

-- -----------------------------------------------------------------------------
-- Denali Memory Model (BROM1) Instantiation
-- -----------------------------------------------------------------------------
uk3p9vu1000m_3_0v : k3p9vu1000m_3_0v
  generic map (
               memory_spec => "../../denali/k3p9vu1000m_3_0v.soma",
               init_file   => "../../denali/k3p9vu1000m_3_0v.dat"
              )
  port map (
            a     => SMADDR(22 downto 0),
            cebar => SMCS(0),
            oebar => nSMOEN,
            q     => SMDATA(15 downto 0),
            bhe   => BHE
           );

-- -----------------------------------------------------------------------------
-- Denali Memory Model (SRAM 2) Instantiation
-- -----------------------------------------------------------------------------
u0SRAM2 : km68v1002c_20
  port map (
            a     => SMADDR(18 downto 2),
            csbar => SMCS(1),
            webar => nSMBLS(0),
            oebar => nSMOEN,
            io    => SMDATA(7 downto 0)
           );

u1SRAM2 : km68v1002c_20
  port map (
            a     => SMADDR(18 downto 2),
            csbar => SMCS(1),
            webar => nSMBLS(1),
            oebar => nSMOEN,
            io    => SMDATA(15 downto 8)
           );

u2SRAM2 : km68v1002c_20
  port map (
            a     => SMADDR(18 downto 2),
            csbar => SMCS(1),
            webar => nSMBLS(2),
            oebar => nSMOEN,
            io    => SMDATA(23 downto 16)
           );

u3SRAM2 : km68v1002c_20
  port map (
            a     => SMADDR(18 downto 2),
            csbar => SMCS(1),
            webar => nSMBLS(3),
            oebar => nSMOEN,
            io    => SMDATA(31 downto 24)
           );

-- -----------------------------------------------------------------------------
-- Denali Memory Model (BROM2) Instantiation
-- -----------------------------------------------------------------------------
uk3p9vu1000m_3_3v : k3p9vu1000m_3_3v
  generic map (
               memory_spec => "../../denali/k3p9vu1000m_3_3v.soma",
               init_file   => "../../denali/k3p9vu1000m_3_3v.dat"
              )
  port map (
            a      => SMADDR(22 downto 0),
            cebar  => SMCS(2),
            oebar  => nSMOEN,
            q      => SMDATA(15 downto 0),
            bhe    => BHE
           );

-- -----------------------------------------------------------------------------
-- Denali Memory Model (FLASH 2) Instantiation
-- -----------------------------------------------------------------------------
uFLASH2 : x28f800c3b_110
  port map (
            a     => SMADDR(19 downto 1),
            dq    => SMDATA(15 downto 0),
            cebar => SMCS(3),
            oebar => nSMOEN,
            webar => nSMWEN,
            wpbar => nWP,
            rpbar => nRP
           );

-- -----------------------------------------------------------------------------
-- Denali Memory Model (MROM 1) Instantiation
-- -----------------------------------------------------------------------------
uMROM1 : k3p9vu1000m_33v_yc
  generic map (
               memory_spec => "../../denali/k3p9vu1000m_3.3v_yc.soma",
               init_file   => "../../denali/k3p9vu1000m_3.3v_yc.dat"
              )
  port map (
            a     => SMADDR(23 downto 1),
            cebar => SMCS(4),
            oebar => nSMOEN,
            q     => SMDATA(15 downto 0),
            bhe   => BHE
           );

-- -----------------------------------------------------------------------------
-- Denali Memory Model (MROM 2) Instantiation
-- -----------------------------------------------------------------------------
uMROM2 : sst37vf020_90
  generic map (
               memory_spec => "../../denali/sst37vf020_90.soma",
               init_file   => "../../denali/sst37vf020_90.dat"
              )

  port map (
            a     => SMADDR(17 downto 0),
            cebar => SMCS(5),
            oebar => nSMOEN,
            dq    => SMDATA(7 downto 0)
           );

-- -----------------------------------------------------------------------------
-- Denali Memory Model (SRAM 3) Instantiation
-- -----------------------------------------------------------------------------
u0SRAM3 :  km68v1002c_12
  port map (
            a     => SMADDR(17 downto 1),
            csbar => SMCS(6),
            webar => nSMBLS(0),
            oebar => nSMOEN,
            io    => SMDATA(7 downto 0)
           );

u1SRAM3 : km68v1002c_12
  port map (
            a     => SMADDR(17 downto 1),
            csbar => SMCS(6),
            webar => nSMBLS(1),
            oebar => nSMOEN,
            io    => SMDATA(15 downto 8)
           );

-- -----------------------------------------------------------------------------
-- Denali Memory Model (SRAM 4) Instantiation
-- -----------------------------------------------------------------------------
uSRAM4 : km68v1002c_20
  port map (
            a     => SMADDR(16 downto 0),
            csbar => SMCS(7),
            webar => nSMBLS(0),
            oebar => nSMOEN,
            io    => SMDATA(7 downto 0)
           );

-- -----------------------------------------------------------------------------
-- UUT Instantiation (SMC)
-- -----------------------------------------------------------------------------
uut : Smc
  port map (
-- Inputs
            nHCLK            => nHCLK,
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HREADYIN         => HREADY,
            HADDR            => HADDR(28 downto 0),
            HBURST           => HBURST,
            HTRANS           => HTRANS,
            HWRITE           => HWRITE,
            HSIZE            => HSIZE,
            HWDATA           => HWDATA(31 downto 0),
            HSELSMC          => HSEL(0),
            HSELREG          => HSEL(1),
            HRESPTIC         => HRESP,
            HRDATATIC        => HRDATA(31 downto 0),
            HGRANTTIC        => HGRANTTIC,
            BIGENDIAN        => BIGENDIAN,
            REMAP            => REMAP,

            TICBUSGNTEBI     => TICBUSGNTEBI,
            SMBUSGNTEBI      => SMBUSGNTEBI,

            SCANENABLE       => SCANENABLE,
            SCANINHCLK       => SCANINHCLK,
            SCANINnHCLK      => SCANINnHCLK,

            SMWAIT           => SMWAIT,
            CANCELSMWAIT     => CANCELSMWAIT,
            SMMWCS7          => SMMWCS7,
            SMRBLECS7        => SMRBLECS7,
            SMDATAIN         => SMDATAIN,

            TESTREQA         => TESTREQA,
            TESTREQB         => TESTREQB,

            MCBUSREQ         => MCBUSREQ,
            MCADDR           => MCADDR,
            MCDATAOUT        => MCDATAOUT,
            MCDATAEN         => MCDATAEN,

            EXTBUSMUX        => EXTBUSMUX,

-- Outputs
            HRDATA           => HRDATAOut0(31 downto 0),
            HREADYOUT        => HREADYOut0,
            HRESP            => HRESPOut0,

            HADDRTIC         => OPEN,
            HTRANSTIC        => OPEN,
            HWRITETIC        => OPEN,
            HSIZETIC         => OPEN,
            HBURSTTIC        => OPEN,
            HPROTTIC         => OPEN,
            HWDATATIC        => OPEN,
            HBUSREQTIC       => OPEN,
            HLOCKTIC         => OPEN,

            TICBUSREQEBI     => OPEN,
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

            TICREADEBI       => OPEN,
            TBUSOUTEBI       => OPEN,
            TESTACK          => OPEN,

            MCBUSGNT         => MCBUSGNT
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
