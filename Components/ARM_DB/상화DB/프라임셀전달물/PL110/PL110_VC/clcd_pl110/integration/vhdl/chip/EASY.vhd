-- --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000-2003 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : EASY.vhd.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Structural architecture of Example Amba SYstem (EASY)
--
-- --=================================================================--

library IEEE;
use     IEEE.std_logic_1164.all;

library sys;
use     sys.all;

library uut;
use     uut.all;

library chip;
use     chip.all;

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
        TESTACK          : out   std_logic -- Test acknowledge
       );
end EASY;

architecture structural of EASY is

-- ---------------------------------------------------------------------
-- Component declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- The UUT (CLCD PL110)  
-- ---------------------------------------------------------------------
component Clcd 
  port (
        HCLK            : in std_logic;
        CLCDCLK         : in std_logic;
        nCLCDCLK        : in std_logic;
        HRESETn         : in std_logic;
        nCLCLKRESET     : in std_logic;
        HSELCLCD        : in std_logic;
        HTRANSS         : in std_logic_vector(1 downto 0);

        HWRITES         : in std_logic;
        HREADYINS       : in std_logic;
        HRESPM          : in std_logic_vector(1 downto 0);

        HREADYINM       : in std_logic;
        HGRANTM         : in std_logic;

        HADDRS          : in std_logic_vector(11 downto 2);

        HWDATAS         : in std_logic_vector(31 downto 0);

        HRDATAM         : in std_logic_vector(31 downto 0);

        SCANENABLE      : in  std_logic;
        SCANINHCLK      : in  std_logic;
        SCANINCLCDCLK   : in  std_logic;
        SCANINnCLCDCLK  : in  std_logic;
        
        HRESPS          : out std_logic_vector(1 downto 0);

        HREADYOUTS      : out std_logic;
        HTRANSM         : out std_logic_vector(1 downto 0);

        HWRITEM         : out std_logic;
        HSIZEM          : out std_logic_vector(2 downto 0);

        HBURSTM         : out std_logic_vector(2 downto 0);

        HBUSREQM        : out std_logic;
        HPROT           : out std_logic_vector(3 downto 0);

        HLOCK           : out std_logic;
        CLCDCLKSEL      : out std_logic;

        HADDRM          : out std_logic_vector(31 downto 0);

        HRDATAS         : out std_logic_vector(31 downto 0);

        CLCDMBEINTR     : out std_logic;
        CLCDFUFINTR     : out std_logic;
        CLCDLNBUINTR    : out std_logic;
        CLCDVCOMPINTR   : out std_logic;

        CLCDINTR        : out std_logic;
        CLPOWER         : out std_logic;
        CLLP            : out std_logic;
        CLCP            : out std_logic;
        CLFP            : out std_logic;

        CLAC            : out std_logic;

        CLLE            : out std_logic;
        CLD             : out std_logic_vector(23 downto 0);

        SCANOUTHCLK     : out std_logic;
        SCANOUTCLCDCLK  : out std_logic;
        SCANOUTnCLCDCLK : out std_logic
       );
end component;

-- ---------------------------------------------------------------------
-- The AHB to APB bridge
-- ---------------------------------------------------------------------
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

-- ---------------------------------------------------------------------
-- The AHB system arbiter
-- ---------------------------------------------------------------------
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

-- ---------------------------------------------------------------------
-- The system address Decoder
-- ---------------------------------------------------------------------
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

-- ---------------------------------------------------------------------
-- The Default Slave
-- ---------------------------------------------------------------------
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

-- ---------------------------------------------------------------------
-- Central multiplexer - masters to slaves
-- Also generates the default master outputs when no other masters
-- are selected
-- ---------------------------------------------------------------------
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

-- ---------------------------------------------------------------------
-- Central multiplexer - slaves to masters
-- ---------------------------------------------------------------------
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

-- ---------------------------------------------------------------------
-- The bus reset controller
-- ---------------------------------------------------------------------
component ResCntl
  port (
        HCLK             : in    std_logic;
        POReset          : in    std_logic; -- Power on reset input
        HRESETn          : out   std_logic
       );
end component;

-- ---------------------------------------------------------------------
-- The AMBA peripheral bus bridge, the reset controller and
-- the APB UUT.
-- ---------------------------------------------------------------------
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

-- ---------------------------------------------------------------------
-- An example External Bus Interface
-- ---------------------------------------------------------------------
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

-- ---------------------------------------------------------------------
-- The test interface controller
-- ---------------------------------------------------------------------
component TIC
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HREADY           : in    std_logic;
        HRESP            : in    std_logic_vector(1 downto 0);
        HGRANTtic        : in    std_logic;

        HADDR            : out   std_logic_vector(31 downto 0);
        HTRANS           : out   std_logic_vector(1 downto 0);
        HWRITE           : out   std_logic;
        HSIZE            : out   std_logic_vector(2 downto 0);
        HBURST           : out   std_logic_vector(2 downto 0);
        HPROT            : out   std_logic_vector(3 downto 0);
        HWDATA           : out   std_logic_vector(31 downto 0);
        HBUSREQtic       : out   std_logic;
        HLOCKtic         : out   std_logic;

        TESTBUS          : in    std_logic_vector(31 downto 0);
                                            -- External data bus

        TESTREQA         : in    std_logic; -- Test bus request A
        TESTREQB         : in    std_logic; -- Test bus request B

        TESTACK          : out   std_logic; -- Test acknowledge
        TicRead          : out   std_logic  -- Drive out read data
       );
end component;

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------
----------------------------------------
-- AHB Signals
----------------------------------------
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

-- Clcd Slave Interface signals
signal HSELClcd            : std_logic;
signal HRDATAClcds         : std_logic_vector(31 downto 0)
                           := (others => '0');
signal HREADYOutClcds      : std_logic := '0';
signal HRESPClcds          : std_logic_vector(1 downto 0) := "00";

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
signal HWDATAtic        : std_logic_vector(31 downto 0);
signal HBUSREQtic       : std_logic;
signal HLOCKtic         : std_logic;
signal HGRANTtic        : std_logic;

-- Clcd AHB Master interface (Read Only) specific signals
signal HADDRClcdM       : std_logic_vector(31 downto 0);
signal HTRANSClcdM      : std_logic_vector(1 downto 0);
signal HWRITEClcdM      : std_logic;
signal HSIZEClcdM       : std_logic_vector(2 downto 0);
signal HBURSTClcdM      : std_logic_vector(2 downto 0);
signal HPROTClcdM       : std_logic_vector(3 downto 0);
signal HWDATAClcdM      : std_logic_vector(31 downto 0) 
                          := (others => '0');
signal HBUSREQClcdM     : std_logic;
signal HLOCKClcdM       : std_logic;
signal HGRANTClcdM      : std_logic := '0';


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

----------------------------------------
-- APB Signals
----------------------------------------
signal PENABLE          : std_logic;
signal PSELIC           : std_logic;
signal PSELUUT          : std_logic;
signal PSELRPC          : std_logic;
signal PADDR            : std_logic_vector(31 downto 0);
signal PWRITE           : std_logic;
signal PWDATA           : std_logic_vector(31 downto 0);
signal PRDATA           : std_logic_vector(31 downto 0);

----------------------------------------
-- Example System Signals
----------------------------------------
signal Remap            : std_logic;
signal Pause            : std_logic;

signal TicRead          : std_logic;

signal nTDOEN           : std_logic;

-- --------------------------------------
-- CLCD Signals
-- --------------------------------------

signal CLCDCLK         : std_logic;
signal nCLCDCLK        : std_logic;
  
signal CLCDMBEINTR     : std_logic;
signal CLCDFUFINTR     : std_logic;
signal CLCDLNBUINTR    : std_logic;
signal CLCDVCOMPINTR   : std_logic;
signal CLCDINTR        : std_logic;
signal CLCDCLKSEL      :std_logic;
-- Display signals
signal CLPOWER         : std_logic;
signal CLLP            : std_logic;
signal CLCP            : std_logic;
signal CLFP            : std_logic;
signal CLAC            : std_logic;
signal CLLE            : std_logic;
signal CLD             : std_logic_vector(23 downto 0);

-- Scan Interface signals
signal SCANENABLE      : std_logic := '0';
signal SCANINHCLK      : std_logic := '0';
signal SCANINCLCDCLK   : std_logic := '0';
signal SCANINnCLCDCLK  : std_logic := '0';
signal SCANOUTHCLK     : std_logic;
signal SCANOUTCLCDCLK  : std_logic;
signal SCANOUTnCLCDCLK : std_logic;

-- Interrupt signals
signal HselNext        : std_logic_vector(2 downto 0);

-- 
signal HselReg         : std_logic_vector(2 downto 0);
-- ---------------------------------------------------------------------
-- Beginning of main code
-- ---------------------------------------------------------------------
begin

-- ---------------------------------------------------------------------
-- Drive the AHB clock with the external clock input.
-- ---------------------------------------------------------------------
HCLK             <= XCLKIN;
CLCDCLK          <= XCLKIN;
nCLCDCLK         <= not(XCLKIN);

-- ---------------------------------------------------------------------
-- OR connection of split input to the Arbiter.
-- ---------------------------------------------------------------------
HSPLIT           <= HSPLIT001 or
                    HSPLIT002 or
                    HSPLIT003 or
                    HSPLIT004;

-- ---------------------------------------------------------------------
-- Unconnected Arbiter inputs driven LOW
-- ---------------------------------------------------------------------
HBUSREQ004       <= '0';

HLOCK004         <= '0';

HSPLIT001        <= (others => '0');
HSPLIT002        <= (others => '0');
HSPLIT003        <= (others => '0');
HSPLIT004        <= (others => '0');

-- -----------------------------------------------------------------------------
-- Registered HSEL outputs are needed to control the slave output
-- multiplexers, as the multiplexers must be switched in the cycle
-- after the HSEL signals have been driven.
-- -----------------------------------------------------------------------------
p_HselSeq :process (HRESETn, HCLK)
begin 
  if (HRESETn = '0') then
    HselReg          <= (others => '0');
  elsif (HREADY = '1') then
      HselReg          <= HselNext;
  end if; 
end process p_HselSeq; 


-- ---------------------------------------------------------------------
-- The AHB to APB bridge Instantiation
-- ---------------------------------------------------------------------
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

-- ---------------------------------------------------------------------
-- The AHB system arbiter Instantiation
-- ---------------------------------------------------------------------
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
            HBUSREQ003       => HBUSREQClcdM,
            HBUSREQ004       => HBUSREQ004,

            HLOCKarm         => HLOCKarm,
            HLOCKtic         => HLOCKtic,
            HLOCK003         => HLOCKClcdM,
            HLOCK004         => HLOCK004,

            HSPLIT           => HSPLIT,

            Pause            => Pause,

            HGRANTarm        => HGRANTarm,
            HGRANTtic        => HGRANTtic,
            HGRANT003        => HGRANTClcdM,
            HGRANT004        => HGRANT004,

            HMASTER          => HMASTER,
            HMASTLOCK        => HMASTLOCK
           );

-- ---------------------------------------------------------------------
-- The system address Decoder Instantiation
-- ---------------------------------------------------------------------
uDecoder : Decoder
  port map (
            HRESETn          => HRESETn,
            HADDR            => HADDR,

            Remap            => Remap,

            HSELIntMem       => HSELIntMem,
            HSELExtMem       => HSELExtMem,
            HSELUUT          => HSELClcd,
            HSELAPBif        => HSELAPBif,
            HSELArmTest      => HSELArmTest,
            HSELDefault      => HSELDefault
           );

-- ---------------------------------------------------------------------
-- The Default Slave Instantiation
-- ---------------------------------------------------------------------
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

-- ---------------------------------------------------------------------
-- Central multiplexer - masters to slaves - Instantiation
-- ---------------------------------------------------------------------
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

            HADDR003         => HADDRClcdM,
            HTRANS003        => HTRANSClcdM,
            HWRITE003        => HWRITEClcdM,
            HSIZE003         => HSIZEClcdM,
            HBURST003        => HBURSTClcdM,
            HPROT003         => HPROTClcdM,
            HWDATA003        => HWDATAClcdM,

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

-- ---------------------------------------------------------------------
-- Central multiplexer - slaves to masters - Instantiation
-- ---------------------------------------------------------------------
uMuxS2M : MuxS2M
  port map (
            hCLK             => HCLK,
            HRESETn          => HRESETn,
            HSELIntMem       => HSELIntMem,
            HSELExtMem       => HSELExtMem,
            HSELUUT          => HSELClcd,
            HSELAPBif        => HSELAPBif,
            HSELArmTest      => HSELArmTest,

            HRDATAIntMem     => HRDATAIntMem,
            HREADYIntMem     => HREADYIntMem,
            HRESPIntMem      => HRESPIntMem,

            HRDATAExtMem     => HRDATAExtMem,
            HREADYExtMem     => HREADYExtMem,
            HRESPExtMem      => HRESPExtMem,

            HRDATAUUT        => HRDATAClcdS,
            HREADYUUT        => HREADYOutClcdS,
            HRESPUUT         => HRESPClcdS,

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

-- ---------------------------------------------------------------------
-- The bus reset controller Instantiation
-- ---------------------------------------------------------------------
uResCntl : ResCntl
  port map (
            HCLK             => HCLK,
            POReset          => nReset,
            HRESETn          => HRESETn
           );
-- -----------------------------------------------------------------------------
-- UUT (CLCD PL110) Instantiation
-- -----------------------------------------------------------------------------
uut : Clcd 
  port map (
        -- Inputs
         HCLK             => HCLK,
         CLCDCLK          => CLCDCLK,
         nCLCDCLK         => nCLCDCLK,
         HRESETn          => HRESETn,
         nCLCLKRESET      => HRESETn,
         HSELCLCD         => HSELClcd,
         HTRANSS          => HTRANS,
         HWRITES          => HWRITE,
         HREADYINS        => HREADY,
         HRESPM           => HRESP,
         HREADYINM        => HREADY,
         HGRANTM          => HGRANTClcdM,
         HADDRS           => HADDR(11 downto 2),
         HWDATAS          => HWDATA,
         HRDATAM          => HRDATA,
         SCANENABLE       => SCANENABLE,
         SCANINHCLK       => SCANINHCLK,
         SCANINCLCDCLK    => SCANINCLCDCLK,
         SCANINnCLCDCLK   => SCANINnCLCDCLK,

        -- Outputs
         HRESPS           => HRESPClcdS,
         HREADYOUTS       => HREADYOutClcdS,
         HTRANSM          => HTRANSClcdM,
         HWRITEM          => HWRITEClcdM,
         HSIZEM           => HSIZEClcdM,
         HBURSTM          => HBURSTClcdM,
         HBUSREQM         => HBUSREQClcdM,
         HPROT            => HPROTClcdM,
         HLOCK            => HLOCKClcdM,
         CLCDCLKSEL       => CLCDCLKSEL,
         HADDRM           => HADDRClcdM,
         HRDATAS          => HRDATAClcdS,
         CLCDMBEINTR      => CLCDMBEINTR,
         CLCDFUFINTR      => CLCDFUFINTR,
         CLCDLNBUINTR     => CLCDLNBUINTR,
         CLCDVCOMPINTR    => CLCDVCOMPINTR,
         CLCDINTR         => CLCDINTR,
         CLPOWER          => CLPOWER,
         CLLP             => CLLP,
         CLCP             => CLCP,
         CLFP             => CLFP,
         CLAC             => CLAC,
         CLLE             => CLLE,
         CLD              => CLD,
         SCANOUTHCLK      => SCANOUTHCLK,
         SCANOUTCLCDCLK   => SCANOUTCLCDCLK,
         SCANOUTnCLCDCLK  => SCANOUTnCLCDCLK
    );
-- ---------------------------------------------------------------------
-- RPS Instantiation
-- ---------------------------------------------------------------------
u_rps : RPS
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

-- ---------------------------------------------------------------------
-- An example External Bus Interface Instantiation
-- ---------------------------------------------------------------------
uSMI : SMI
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HADDR            => HADDR,
            HTRANS           => HTRANS,
            HWRITE           => HWRITE,
            HSIZE            => HSIZE,
            HWDATAin         => HWDATA,
            HSELExtMem       => HSELExtMem,
            HRDATAin         => HRDATA,
            HREADYin         => HREADY,
            HRDATAout        => HRDATAExtMem,
            HREADYout        => HREADYExtMem,
            HRESP            => HRESPExtMem,
            Remap            => Remap,
            TicRead          => TicRead,
            XD               => XD,
            XA               => XA,
            XCSN             => XCSN,
            XOEN             => XOEN,
            XWEN             => XWEN
           );

-- ---------------------------------------------------------------------
-- The Test Interface Controller Instantiation
-- ---------------------------------------------------------------------
uTIC : TIC
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HREADY           => HREADY,
            HRESP            => HRESP,
            HGRANTtic        => HGRANTtic,
            HADDR            => HADDRtic,
            HTRANS           => HTRANStic,
            HWRITE           => HWRITEtic,
            HSIZE            => HSIZEtic,
            HBURST           => HBURSTtic,
            HPROT            => HPROTtic,
            HWDATA           => HWDATAtic,
            HBUSREQtic       => HBUSREQtic,
            HLOCKtic         => HLOCKtic,
            TESTBUS          => XD,
            TESTREQA         => TESTREQA,
            TESTREQB         => TESTREQB,
            TESTACK          => TESTACK,
            TicRead          => TicRead
           );

end structural;

-- --============================== End ==============================--
