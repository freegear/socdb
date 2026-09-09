--============================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  
--  ----------------------------------------------------------------------------
--  Version and Release Control Information:
--  
--  File Name           : EASY_ML.vhd,v
--  File Revision       : 1.15
--  
--  Release Information : ADK_REL1v1
--  
--  ----------------------------------------------------------------------------
--  Purpose             : Structural architecture of Example Amba SYstem
--                        Multi-layer (EASY-ML) consisting of the ARM922T, 
--                        File Reader Bus Master and EgMaster. 
--============================================================================--

library ieee;
use     ieee.std_logic_1164.all;

-- pragma translate_off
library BusMatrix;
use BusMatrix.all;
library ResetCntl;
use ResetCntl.all;
-- pragma translate_on

--------------------------------------------------------------------------------
-- EASY_ML Address Map
--------------------------------------------------------------------------------
-- Full Decoding of the Address Map is performed continuously as a function of
--  HADDR. All unused slots are connected to a Default Slave.
--
-- AHB address map is:
--
-- 0x00000000 - 0x000FFFFF Default Slave (Remap LOW)  (HSELS0B) (SMI alias)
-- 0x00000000 - 0x000FFFFF IntMem alias  (Remap HIGH) (HSELS0R)
-- 0x00100000 - 0x10000000 Default Slave              (HSELS0)  (SDRAM)
-- 0x10000000 - 0x1FFFFFFF Default Slave              (HSELS1)
-- 0x20000000 - 0x2FFFFFFF Default Slave              (HSELS2)
-- 0x30000000 - 0x3FFFFFFF SMI                        (HSELS3)
-- 0x40000000 - 0x4FFFFFFF Default Slave              (HSELS4)
-- 0x50000000 - 0x5FFFFFFF Default Slave              (HSELS5)
-- 0x60000000 - 0x6FFFFFFF Default Slave              (HSELS6)
-- 0x70000000 - 0x7FFFFFFF IntMem                     (HSELS7)
-- 0x80000000 - 0x8FFFFFFF Default Slave              (HSELS8)
-- 0x90000000 - 0x9FFFFFFF Default Slave              (HSELS9)
-- 0xA0000000 - 0xAFFFFFFF Default Slave              (HSELS10)
-- 0xB0000000 - 0xBFFFFFFF Default Slave              (HSELS11)
-- 0xC0000000 - 0xCFFFFFFF APB Peripherals            (HSELS12)
-- 0xD0000000 - 0xDFFFFFFF Retry Slave                (HSELS13)
-- 0xE0000000 - 0xEFFFFFFF Default Slave              (HSELS14)
-- 0xF0000000 - 0xFFFFFFFF Interrupt Controller       (HSELS15)
--
-- APB address map is:
--
-- 0xC0000000 - 0xC0FFFFFF Unused                     (PSELS0)  (System Control)
-- 0xC1000000 - 0xC1FFFFFF Watchdog                   (PSELS1)
-- 0xC2000000 - 0xC2FFFFFF Timers                     (PSELS2)
-- 0xC3000000 - 0xC3FFFFFF Unused                     (PSELS3)  (Extra Timers)
-- 0xC4000000 - 0xC4FFFFFF GPIO                       (PSELS4)
-- 0xC5000000 - 0xC5FFFFFF Unused                     (PSELS5)  (Extra GPIO)
-- 0xC6000000 - 0xC6FFFFFF Unused                     (PSELS6)  (Extra GPIO)
-- 0xC7000000 - 0xC7FFFFFF Unused                     (PSELS7)  (Extra GPIO)
-- 0xC8000000 - 0xC8FFFFFF Remap/Pause                (PSELS8)
-- 0xC9000000 - 0xC9FFFFFF Unused                     (PSELS9)
-- 0xCA000000 - 0xCAFFFFFF Unused                     (PSELS10)
-- 0xCB000000 - 0xCBFFFFFF Unused                     (PSELS11)
-- 0xCC000000 - 0xCCFFFFFF Unused                     (PSELS12)
-- 0xCD000000 - 0xCDFFFFFF Unused                     (PSELS13)
-- 0xCE000000 - 0xCEFFFFFF Unused                     (PSELS14)
-- 0xCF000000 - 0xCFFFFFFF EgAPBSlave                 (PSELS15)
--
--------------------------------------------------------------------------------
  
entity EASY_ML is
  port(
    XCLKIN      : in std_logic;  -- External clock in
    nReset      : in std_logic;  -- Power on reset in

    -- Data from Memory to SMC
    SMDATAIN    : in  std_logic_vector(31 downto 0);
    -- Data Bus output from SMC to Memory
    SMDATAOUT   : out std_logic_vector(31 downto 0);
    -- Tri-state I/O pad enable for the byte lanes of external
    --  memory data bus
    nSMDATAEN   : out std_logic_vector(3 downto 0);
    -- External Memory address bus
    SMADDR      : out std_logic_vector(25 downto 0);
    -- Memory bank Chip Select output pins
    SMCS        : out std_logic_vector(7 downto 0);
    -- Memory device Byte lane enables
    nSMBLS      : out std_logic_vector(3 downto 0);
    -- Memory Output Enable (complement serves as Write-Enable)
    nSMOEN      : out std_logic;

    -- TIC test command signals
    TESTREQA    : in  std_logic;  -- Test bus request A
    TESTREQB    : in  std_logic;  -- Test bus request B
    TESTACK     : out std_logic;  -- Test acknowledge

    -- JTAG connections
    nTRST       : in  std_logic;  
    TCK         : in  std_logic;
    TDI         : in  std_logic;
    TMS         : in  std_logic;
    TDO         : out std_logic;
    nTDOEN      : out std_logic;

    -- ARM922T comms channel debug lines
    COMMRX      : out std_logic;
    COMMTX      : out std_logic;

    -- ARM922T Fast Cache clock
    XFCLK       : in  std_logic;

    -- GPIO lines
    GPIN        : in  std_logic_vector(7 downto 0); -- Inputs
    GPOUT       : out std_logic_vector(7 downto 0); -- Outputs
    nGPEN       : out std_logic_vector(7 downto 0); -- Output ctrl enables
    nGPAFEN     : in  std_logic_vector(7 downto 0); -- H/w ctrl enables
    GPAFOUT     : in  std_logic_vector(7 downto 0); -- H/w ctrl inputs
    GPAFIN      : out std_logic_vector(7 downto 0); -- H/w ctrl outputs

    -- Scan test dummy signals; not connected until scan insertion 
    SCANENABLE  : in  std_logic; -- Scan Test Mode Enbl
    SCANINHCLK  : in  std_logic; -- Scan Chain Input (HCLK)
    SCANOUTHCLK : out std_logic; -- Scan Chain Output (HCLK)
    SCANINPCLK  : in  std_logic; -- Scan Chain Input (PCLK)
    SCANOUTPCLK : out std_logic  -- Scan Chain Output (PCLK)
    );
end EASY_ML;

architecture structural of EASY_ML is

--------------------------------------------------------------------------------
-- Components: Common AHB Infrastructure
--------------------------------------------------------------------------------

-- The Bus reset controller, which resets the entire multi-layer system
  component ResetCntl
    port(
      HCLK     : in  std_logic;
      nPOReset : in  std_logic;  -- Power on reset input
      WDOGRES  : in  std_logic;  -- Watchdog reset input
      HRESETn  : out std_logic;  -- AHB system reset output
      WDOGRESn : out std_logic   -- Watchdog reset output
      );
  end component;

-- Multi-layer Bus Matrix module
  component BusMatrix
    port(
      -- Common AHB signals
      HCLK        : in  std_logic;
      HRESETn     : in  std_logic;

      -- Input Port 0
      HSELS0      : in  std_logic;
      HADDRS0     : in  std_logic_vector(31 downto 0);
      HTRANSS0    : in  std_logic_vector(1 downto 0);
      HWRITES0    : in  std_logic;
      HSIZES0     : in  std_logic_vector(2 downto 0);
      HBURSTS0    : in  std_logic_vector(2 downto 0);
      HPROTS0     : in  std_logic_vector(3 downto 0);
      HWDATAS0    : in  std_logic_vector(31 downto 0);
      HMASTLOCKS0 : in  std_logic;
      HREADYS0    : in  std_logic;

      HRDATAS0    : out std_logic_vector(31 downto 0);
      HREADYOUTS0 : out std_logic;
      HRESPS0     : out std_logic_vector(1 downto 0);

      -- Input Port 1
      HSELS1      : in  std_logic;
      HADDRS1     : in  std_logic_vector(31 downto 0);
      HTRANSS1    : in  std_logic_vector(1 downto 0);
      HWRITES1    : in  std_logic;
      HSIZES1     : in  std_logic_vector(2 downto 0);
      HBURSTS1    : in  std_logic_vector(2 downto 0);
      HPROTS1     : in  std_logic_vector(3 downto 0);
      HWDATAS1    : in  std_logic_vector(31 downto 0);
      HMASTLOCKS1 : in  std_logic;
      HREADYS1    : in  std_logic;

      HRDATAS1    : out std_logic_vector(31 downto 0);
      HREADYOUTS1 : out std_logic;
      HRESPS1     : out std_logic_vector(1 downto 0);

      -- Output Port 0
      HSELM0      : out std_logic;
      HADDRM0     : out std_logic_vector(31 downto 0);
      HTRANSM0    : out std_logic_vector(1 downto 0);
      HWRITEM0    : out std_logic;
      HSIZEM0     : out std_logic_vector(2 downto 0);
      HBURSTM0    : out std_logic_vector(2 downto 0);
      HPROTM0     : out std_logic_vector(3 downto 0);
      HWDATAM0    : out std_logic_vector(31 downto 0);
      HMASTLOCKM0 : out std_logic;
      HREADYM0    : out std_logic;

      HRDATAM0    : in  std_logic_vector(31 downto 0);
      HREADYOUTM0 : in  std_logic;
      HRESPM0     : in  std_logic_vector(1 downto 0);

      -- Output Port 1
      HSELM1      : out std_logic;
      HADDRM1     : out std_logic_vector(31 downto 0);
      HTRANSM1    : out std_logic_vector(1 downto 0);
      HWRITEM1    : out std_logic;
      HSIZEM1     : out std_logic_vector(2 downto 0);
      HBURSTM1    : out std_logic_vector(2 downto 0);
      HPROTM1     : out std_logic_vector(3 downto 0);
      HWDATAM1    : out std_logic_vector(31 downto 0);
      HMASTLOCKM1 : out std_logic;
      HREADYM1    : out std_logic;

      HRDATAM1    : in  std_logic_vector(31 downto 0);
      HREADYOUTM1 : in  std_logic;
      HRESPM1     : in  std_logic_vector(1 downto 0);

      -- Output Port 2
      HSELM2      : out std_logic;
      HADDRM2     : out std_logic_vector(31 downto 0);
      HTRANSM2    : out std_logic_vector(1 downto 0);
      HWRITEM2    : out std_logic;
      HSIZEM2     : out std_logic_vector(2 downto 0);
      HBURSTM2    : out std_logic_vector(2 downto 0);
      HPROTM2     : out std_logic_vector(3 downto 0);
      HWDATAM2    : out std_logic_vector(31 downto 0);
      HMASTLOCKM2 : out std_logic;
      HREADYM2    : out std_logic;

      HRDATAM2    : in  std_logic_vector(31 downto 0);
      HREADYOUTM2 : in  std_logic;
      HRESPM2     : in  std_logic_vector(1 downto 0);

      -- Scan test dummy signals; not connected until scan insertion 
      SCANENABLE  : in  std_logic; -- Scan Test Mode Enbl
      SCANINHCLK  : in  std_logic; -- Scan Chain Input
      SCANOUTHCLK : out std_logic  -- Scan Chain Output
      );
  end component;


--------------------------------------------------------------------------------
-- Components: System modules
--------------------------------------------------------------------------------

-- Inport 0 (Containing the ARM922T and Internal Memory)
  component Inport0
    -- pragma synthesis_off
    generic(
      -- Width of the address bus of the Internal Memory block
      IntMemAddrWidth : integer := 10;
      -- Internal Memory initialisation file
      IntMemInitFile  : string  := "intram.dat"
      );
    -- pragma synthesis_on    
    port(
      -- Common AHB signals
      HCLK         : in  std_logic;
      HRESETn      : in  std_logic;

      -- Matrix AHB connections
      HADDR        : out std_logic_vector(31 downto 0);
      HBURST       : out std_logic_vector(2 downto 0);
      HMASTLOCK    : out std_logic;
      HPROT        : out std_logic_vector(3 downto 0);
      HSIZE        : out std_logic_vector(2 downto 0);
      HTRANS       : out std_logic_vector(1 downto 0);
      HWDATA       : out std_logic_vector(31 downto 0);
      HWRITE       : out std_logic;
      HSELmtrx     : out std_logic;
      HREADYOUT    : out std_logic;

      HRDATAmtrx   : in  std_logic_vector(31 downto 0);
      HREADYmtrx   : in  std_logic;
      HRESPmtrx    : in  std_logic_vector(1 downto 0);

      -- ARM922T Test Slave connections
      HADDRtst     : in  std_logic_vector(11 downto 2);
      HSELtst      : in  std_logic;
      HTRANStst    : in  std_logic_vector(1 downto 0);
      HWRITEtst    : in  std_logic;
      HWDATAtst    : in  std_logic_vector(31 downto 0);

      HRDATAtst    : out std_logic_vector(31 downto 0);
      HREADYOUTtst : out std_logic;
      HRESPtst     : out std_logic_vector(1 downto 0);

      -- ARM922T interrupts
      nFIQ         : in  std_logic;
      nIRQ         : in  std_logic;

      -- ARM922T comms channel debug lines
      COMMRX       : out std_logic;
      COMMTX       : out std_logic;

      -- ARM922T Fast Cache clock
      FCLK         : in  std_logic;

      -- JTAG connections
      nTRST        : in  std_logic;
      TCK          : in  std_logic;
      TDI          : in  std_logic;
      TMS          : in  std_logic;
      nTDOEN       : out std_logic;
      TDO          : out std_logic;

      -- Remap/Pause control signals
      Remap        : in  std_logic;
      Pause        : in  std_logic;

      -- Scan test dummy signals; not connected until scan insertion 
      SCANENABLE   : in  std_logic; -- Scan Test Mode Enbl
      SCANINHCLK   : in  std_logic; -- Scan Chain Input
      SCANOUTHCLK  : out std_logic  -- Scan Chain Output
      );
  end component;

-- Inport 1 (Containing the EgMaster and File Reader Bus Master)
  component Inport1
    -- pragma synthesis_off
    generic(
      -- Stimulus file for the File Reader Bus Master (FRBM)
      StimFileFRBM : string  := "fileStim.frd";
      -- Enable for Example Bus Master (EgMaster)
      EnableEBM    : integer := 1;
      -- EgMaster reads from the Retry Slave (0xD0000000)
      ReadAddrEBM  : integer := 16#0D0#;
      -- EgMaster writes to the Tube via SMI (0x38000000)
      WriteAddrEBM : integer := 16#038#;
      -- Number of cycles between transactions by EgMaster
      InitCountEBM : integer := 10             
      );
    -- pragma synthesis_on    
    port(
      -- Common AHB signals
      HCLK         : in  std_logic;
      HRESETn      : in  std_logic;

      -- Reset for the FRBM
      nRESETfrbm   : in  std_logic;

      -- Matrix AHB connections
      HADDR        : out std_logic_vector(31 downto 0);
      HBURST       : out std_logic_vector(2 downto 0);
      HMASTLOCK    : out std_logic;
      HPROT        : out std_logic_vector(3 downto 0);
      HSIZE        : out std_logic_vector(2 downto 0);
      HTRANS       : out std_logic_vector(1 downto 0);
      HWDATA       : out std_logic_vector(31 downto 0);
      HWRITE       : out std_logic;
      HSELmtrx     : out std_logic;
      HREADYOUT    : out std_logic;

      HRDATAmtrx   : in  std_logic_vector(31 downto 0);
      HREADYmtrx   : in  std_logic;
      HRESPmtrx    : in  std_logic_vector(1 downto 0); 

      -- Pause control signal
      Pause        : in  std_logic;

      -- Scan test dummy signals; not connected until scan insertion 
      SCANENABLE   : in  std_logic; -- Scan Test Mode Enbl
      SCANINHCLK   : in  std_logic; -- Scan Chain Input
      SCANOUTHCLK  : out std_logic  -- Scan Chain Output
      );
  end component;

-- Outport 0 (Containing the TIC, SMI, Retry slave, Default Slave and
--  Lite2AHB wrapper)
  component Outport0
    port(
      -- Common AHB signals
      HCLK        : in  std_logic;
      HRESETn     : in  std_logic;

      -- Matrix AHB connections
      HADDR       : in  std_logic_vector(31 downto 0);
      HBURST      : in  std_logic_vector(2 downto 0);
      HMASTLOCK   : in  std_logic;
      HPROT       : in  std_logic_vector(3 downto 0);
      HREADYmtrx  : in  std_logic;
      HSELmtrx    : in  std_logic;
      HSIZE       : in  std_logic_vector(2 downto 0);
      HTRANS      : in  std_logic_vector(1 downto 0);
      HWDATA      : in  std_logic_vector(31 downto 0);
      HWRITE      : in  std_logic;

      HRDATA      : out std_logic_vector(31 downto 0);
      HREADYOUT   : out std_logic;
      HRESP       : out std_logic_vector(1 downto 0);
       
      -- Remap control signal
      Remap       : in  std_logic; 

      -- SMI external connections       
      SMDATAIN    : in  std_logic_vector(31 downto 0); -- Data from Memory
                                                       --  to SMI
      SMDATAOUT   : out std_logic_vector(31 downto 0); -- Data Bus output from
                                                       --  SMI to Memory
      nSMDATAEN   : out std_logic_vector(3 downto 0);  -- Tri-state I/O pad 
                                                       --  enable for the byte
                                                       --  lanes of external
                                                       --  memory data bus
      SMADDR      : out std_logic_vector(25 downto 0); -- External Memory 
                                                       --  address bus
      SMCS        : out std_logic_vector(7 downto 0);  -- Memory bank Chip 
                                                       --  Select output pins
      nSMBLS      : out std_logic_vector(3 downto 0);  -- Memory device Byte
                                                       --  lane enables
                                  
      nSMOEN      : out std_logic; -- Memory Output Enable/not Write-Enable

      -- TIC connections (AHB)
      HADDRtst    : out std_logic_vector(31 downto 0);
      HSELtst     : out std_logic;
      HTRANStst   : out std_logic_vector(1 downto 0);
      HWRITEtst   : out std_logic;
      HWDATAtst   : out std_logic_vector(31 downto 0);

      HREADYtst   : in  std_logic;
      HRESPtst    : in  std_logic_vector(1 downto 0);
      HRDATAtst   : in  std_logic_vector(31 downto 0);

      -- TIC test signals
      TESTREQA    : in  std_logic;
      TESTREQB    : in  std_logic;
      TESTACK     : out std_logic;

      -- Scan test dummy signals; not connected until scan insertion 
      SCANENABLE  : in  std_logic; -- Scan Test Mode Enbl
      SCANINHCLK  : in  std_logic; -- Scan Chain Input
      SCANOUTHCLK : out std_logic  -- Scan Chain Output
      );
  end component;

-- Outport 1 (Containing the AHB IRQ Controller)
  component Outport1
    port (
      -- Common AHB signals
      HCLK        : in  std_logic;
      HRESETn     : in  std_logic;

      -- Matrix AHB connections
      HADDR       : in  std_logic_vector(31 downto 0);
      HBURST      : in  std_logic_vector(2 downto 0);
      HPROT       : in  std_logic_vector(3 downto 0);
      HREADYmtrx  : in  std_logic;
      HSELmtrx    : in  std_logic;
      HSIZE       : in  std_logic_vector(2 downto 0);
      HTRANS      : in  std_logic_vector(1 downto 0);
      HWDATA      : in  std_logic_vector(31 downto 0);
      HWRITE      : in  std_logic;

      HRDATA      : out std_logic_vector(31 downto 0);
      HREADYOUT   : out std_logic;
      HRESP       : out std_logic_vector(1 downto 0);

      -- Peripheral interrupt sources
      WDOGINT     : in  std_logic;
      TIMINTC     : in  std_logic;
      TIMINT2     : in  std_logic;
      TIMINT1     : in  std_logic;
      GPIOMIS     : in  std_logic_vector(7 downto 0);
      GPIOINTR    : in  std_logic;
      
      -- Processor interrupts
      nICFIQ      : out std_logic;
      nICIRQ      : out std_logic;

      -- Scan test dummy signals; not connected until scan insertion 
      SCANENABLE  : in  std_logic; -- Scan Test Mode Enbl
      SCANINHCLK  : in  std_logic; -- Scan Chain Input
      SCANOUTHCLK : out std_logic  -- Scan Chain Output
      );
  end component;

-- Outport 2 (Containing the AHB-APB Bridge, Timers, Remap/Pause, Watchdog,
--  Example APB Slave and GPIO)
  component Outport2
    port(
      -- Common AHB signals
      HCLK        : in  std_logic;
      HRESETn     : in  std_logic;

      -- Matrix AHB connections
      HADDR       : in  std_logic_vector(31 downto 0);
      HBURST      : in  std_logic_vector(2 downto 0);
      HPROT       : in  std_logic_vector(3 downto 0);
      HREADYmtrx  : in  std_logic;
      HSELmtrx    : in  std_logic;
      HSIZE       : in  std_logic_vector(2 downto 0);
      HTRANS      : in  std_logic_vector(1 downto 0);
      HWDATA      : in  std_logic_vector(31 downto 0);
      HWRITE      : in  std_logic;

      HRDATA      : out std_logic_vector(31 downto 0);
      HREADYOUT   : out std_logic;
      HRESP       : out std_logic_vector(1 downto 0);

      -- Timer signals 
      TIMINT1     : out std_logic;
      TIMINT2     : out std_logic;
      TIMINTC     : out std_logic;

      -- Watchdog signals
      WDOGRESn    : in  std_logic;
      WDOGRES     : out std_logic;
      WDOGINT     : out std_logic;
      
      -- Processor interrupts
      nFIQ        : in  std_logic;
      nIRQ        : in  std_logic;

      -- Remap/Pause control signals
      Pause       : out std_logic;
      Remap       : out std_logic;

      -- GPIO signals
      GPIN        : in  std_logic_vector(7 downto 0);
      nGPAFEN     : in  std_logic_vector(7 downto 0);
      GPAFOUT     : in  std_logic_vector(7 downto 0); 
      GPOUT       : out std_logic_vector(7 downto 0);
      nGPEN       : out std_logic_vector(7 downto 0);
      GPAFIN      : out std_logic_vector(7 downto 0);
      GPIOINTR    : out std_logic;
      GPIOMIS     : out std_logic_vector(7 downto 0);

      -- Scan test dummy signals; not connected until scan insertion 
      SCANENABLE  : in  std_logic; -- Scan Test Mode Enable
      SCANINHCLK  : in  std_logic; -- Scan Chain Input (HCLK)
      SCANOUTHCLK : out std_logic; -- Scan Chain Output (HCLK)
      SCANINPCLK  : in  std_logic; -- Scan Chain Input (PCLK)
      SCANOUTPCLK : out std_logic  -- Scan Chain Output (PCLK)
      );
  end component;
  

--------------------------------------------------------------------------------
-- Signal declarations: AHB Common
--------------------------------------------------------------------------------

  signal HCLK         : std_logic;
  signal HRESETn      : std_logic;


--------------------------------------------------------------------------------
-- Signal declarations: BusMatrix modules
--------------------------------------------------------------------------------

-- Inport 0 AHB signals
  signal HADDRS0      : std_logic_vector(31 downto 0);
  signal HBURSTS0     : std_logic_vector(2 downto 0);
  signal HMASTLOCKS0  : std_logic;
  signal HPROTS0      : std_logic_vector(3 downto 0);
  signal HRDATAS0     : std_logic_vector(31 downto 0);
  signal HREADYS0     : std_logic;
  signal HRESPS0      : std_logic_vector(1 downto 0);
  signal HSIZES0      : std_logic_vector(2 downto 0);
  signal HTRANSS0     : std_logic_vector(1 downto 0);
  signal HWDATAS0     : std_logic_vector(31 downto 0);
  signal HWRITES0     : std_logic;
  signal HSELS0       : std_logic;
  signal HREADYmtrxS0 : std_logic;

-- Inport 1 AHB signals
  signal HADDRS1      : std_logic_vector(31 downto 0);
  signal HBURSTS1     : std_logic_vector(2 downto 0);
  signal HMASTLOCKS1  : std_logic;
  signal HPROTS1      : std_logic_vector(3 downto 0);
  signal HRDATAS1     : std_logic_vector(31 downto 0);
  signal HREADYS1     : std_logic;
  signal HRESPS1      : std_logic_vector(1 downto 0);
  signal HSIZES1      : std_logic_vector(2 downto 0);
  signal HTRANSS1     : std_logic_vector(1 downto 0);
  signal HWDATAS1     : std_logic_vector(31 downto 0);
  signal HWRITES1     : std_logic;
  signal HSELS1       : std_logic;
  signal HREADYmtrxS1 : std_logic;

-- Outport 0 AHB signals 
  signal HADDRM0      : std_logic_vector(31 downto 0);
  signal HBURSTM0     : std_logic_vector(2 downto 0);
  signal HMASTLOCKM0  : std_logic;
  signal HPROTM0      : std_logic_vector(3 downto 0);
  signal HRDATAM0     : std_logic_vector(31 downto 0);
  signal HREADYM0     : std_logic;
  signal HRESPM0      : std_logic_vector(1 downto 0);
  signal HSIZEM0      : std_logic_vector(2 downto 0);
  signal HTRANSM0     : std_logic_vector(1 downto 0);
  signal HWDATAM0     : std_logic_vector(31 downto 0);
  signal HWRITEM0     : std_logic;
  signal HSELM0       : std_logic;
  signal HREADYOUTM0  : std_logic;

-- Outport 1 AHB signals
  signal HADDRM1      : std_logic_vector(31 downto 0);
  signal HBURSTM1     : std_logic_vector(2 downto 0);
  signal HMASTLOCKM1  : std_logic;
  signal HPROTM1      : std_logic_vector(3 downto 0);
  signal HRDATAM1     : std_logic_vector(31 downto 0);
  signal HREADYM1     : std_logic;
  signal HRESPM1      : std_logic_vector(1 downto 0);
  signal HSIZEM1      : std_logic_vector(2 downto 0);
  signal HTRANSM1     : std_logic_vector(1 downto 0);
  signal HWDATAM1     : std_logic_vector(31 downto 0);
  signal HWRITEM1     : std_logic;
  signal HSELM1       : std_logic;
  signal HREADYOUTM1  : std_logic;

-- Outport 2 AHB signals
  signal HADDRM2      : std_logic_vector(31 downto 0);
  signal HBURSTM2     : std_logic_vector(2 downto 0);
  signal HMASTLOCKM2  : std_logic;
  signal HPROTM2      : std_logic_vector(3 downto 0);
  signal HRDATAM2     : std_logic_vector(31 downto 0);
  signal HREADYM2     : std_logic;
  signal HRESPM2      : std_logic_vector(1 downto 0);
  signal HSIZEM2      : std_logic_vector(2 downto 0);
  signal HTRANSM2     : std_logic_vector(1 downto 0);
  signal HWDATAM2     : std_logic_vector(31 downto 0);
  signal HWRITEM2     : std_logic;
  signal HSELM2       : std_logic;
  signal HREADYOUTM2  : std_logic;


--------------------------------------------------------------------------------
-- Signal declarations: Scan chain
--------------------------------------------------------------------------------

  signal SCANINHCLKbmtx   : std_logic;
  signal SCANOUTHCLKbmtx  : std_logic;
  signal SCANINHCLKinp0   : std_logic;
  signal SCANOUTHCLKinp0  : std_logic;
  signal SCANINHCLKinp1   : std_logic;
  signal SCANOUTHCLKinp1  : std_logic;
  signal SCANINHCLKoutp0  : std_logic;
  signal SCANOUTHCLKoutp0 : std_logic;
  signal SCANINHCLKoutp1  : std_logic;
  signal SCANOUTHCLKoutp1 : std_logic;
  signal SCANINHCLKoutp2  : std_logic;
  signal SCANOUTHCLKoutp2 : std_logic;
  signal SCANINPCLKoutp2  : std_logic;
  signal SCANOUTPCLKoutp2 : std_logic;


--------------------------------------------------------------------------------
-- Signal declarations: System specific
--------------------------------------------------------------------------------

-- Watchdog
  signal WDOGRES   : std_logic;
  signal WDOGRESn  : std_logic;

-- TIC signals
  signal HREADYtst : std_logic;
  signal HRESPtst  : std_logic_vector(1 downto 0);
  signal HRDATAtst : std_logic_vector(31 downto 0);
  signal HADDRtst  : std_logic_vector(31 downto 0);
  signal HSELtst   : std_logic;
  signal HTRANStst : std_logic_vector(1 downto 0);
  signal HWRITEtst : std_logic;
  signal HWDATAtst : std_logic_vector(31 downto 0);
  
-- Interrupts
  signal WDOGINT   : std_logic;
  signal TIMINTC   : std_logic;
  signal TIMINT2   : std_logic;
  signal TIMINT1   : std_logic;
  signal GPIOINTR  : std_logic;
  signal GPIOMIS   : std_logic_vector(7 downto 0);
  signal nFIQ      : std_logic;
  signal nIRQ      : std_logic;

-- Miscellaneous signals
  signal Remap     : std_logic;
  signal Pause     : std_logic;


--------------------------------------------------------------------------------
-- Beginning of main code
--------------------------------------------------------------------------------

begin

--------------------------------------------------------------------------------
-- Common system features
--------------------------------------------------------------------------------

-- Drive the AHB clock with the external clock input.
  HCLK <= XCLKIN;


-- Common reset controller
  uResetCntl : ResetCntl
    port map(
      HCLK     => HCLK,
      nPOReset => nReset,   -- Power on reset input
      WDOGRES  => WDOGRES,  -- Watchdog reset input
      HRESETn  => HRESETn,  -- AHB system reset output
      WDOGRESn => WDOGRESn  -- Watchdog reset output
      );


--------------------------------------------------------------------------------
-- AHB Multi-layer System
--------------------------------------------------------------------------------

-- Multi-layer Bus Matrix module
  uBusMatrix : BusMatrix
    port map(
      -- Common AHB signals
      HCLK        => HCLK,
      HRESETn     => HRESETn,

      -- Input Port 0
      HSELS0      => HSELS0,
      HADDRS0     => HADDRS0,
      HTRANSS0    => HTRANSS0,
      HWRITES0    => HWRITES0,
      HSIZES0     => HSIZES0,
      HBURSTS0    => HBURSTS0,
      HPROTS0     => HPROTS0,
      HWDATAS0    => HWDATAS0,
      HMASTLOCKS0 => HMASTLOCKS0,
      HREADYS0    => HREADYS0,

      HRDATAS0    => HRDATAS0,
      HREADYOUTS0 => HREADYmtrxS0,
      HRESPS0     => HRESPS0,

      -- Input Port 1
      HSELS1      => HSELS1,
      HADDRS1     => HADDRS1,
      HTRANSS1    => HTRANSS1,
      HWRITES1    => HWRITES1,
      HSIZES1     => HSIZES1,
      HBURSTS1    => HBURSTS1,
      HPROTS1     => HPROTS1,
      HWDATAS1    => HWDATAS1,
      HMASTLOCKS1 => HMASTLOCKS1,
      HREADYS1    => HREADYS1,

      HRDATAS1    => HRDATAS1,
      HREADYOUTS1 => HREADYmtrxS1,
      HRESPS1     => HRESPS1,

      -- Output Port 0
      HSELM0      => HSELM0,
      HADDRM0     => HADDRM0,
      HTRANSM0    => HTRANSM0,
      HWRITEM0    => HWRITEM0,
      HSIZEM0     => HSIZEM0,
      HBURSTM0    => HBURSTM0,
      HPROTM0     => HPROTM0,
      HWDATAM0    => HWDATAM0,
      HMASTLOCKM0 => HMASTLOCKM0,
      HREADYM0    => HREADYM0,

      HRDATAM0    => HRDATAM0,
      HREADYOUTM0 => HREADYOUTM0,
      HRESPM0     => HRESPM0,

      -- Output Port 1
      HSELM1      => HSELM1,
      HADDRM1     => HADDRM1,
      HTRANSM1    => HTRANSM1,
      HWRITEM1    => HWRITEM1,
      HSIZEM1     => HSIZEM1,
      HBURSTM1    => HBURSTM1,
      HPROTM1     => HPROTM1,
      HWDATAM1    => HWDATAM1,
      HMASTLOCKM1 => HMASTLOCKM1,
      HREADYM1    => HREADYM1,

      HRDATAM1    => HRDATAM1,
      HREADYOUTM1 => HREADYOUTM1,
      HRESPM1     => HRESPM1,

      -- Output Port 2
      HSELM2      => HSELM2,
      HADDRM2     => HADDRM2,
      HTRANSM2    => HTRANSM2,
      HWRITEM2    => HWRITEM2,
      HSIZEM2     => HSIZEM2,
      HBURSTM2    => HBURSTM2,
      HPROTM2     => HPROTM2,
      HWDATAM2    => HWDATAM2,
      HMASTLOCKM2 => HMASTLOCKM2,
      HREADYM2    => HREADYM2,

      HRDATAM2    => HRDATAM2,
      HREADYOUTM2 => HREADYOUTM2,
      HRESPM2     => HRESPM2,

      -- Scan signals
      SCANENABLE  => SCANENABLE,
      SCANINHCLK  => SCANINHCLKbmtx,
      SCANOUTHCLK => SCANOUTHCLKbmtx
      );


-- Inport 0 (ARM922T and Internal Memory)
  uInport0 : Inport0
    -- pragma synthesis_off
    generic map(
      -- Width of address bus for the Internal Memory block
      IntMemAddrWidth => 10,
      -- Internal Memory initialisation file
      IntMemInitFile  => "intram.dat"
      )
    -- pragma synthesis_on    
    port map(
      -- Common AHB signals
      HCLK         => HCLK,
      HRESETn      => HRESETn,

      -- Matrix AHB connections
      HADDR        => HADDRS0,
      HBURST       => HBURSTS0,
      HMASTLOCK    => HMASTLOCKS0,
      HPROT        => HPROTS0,
      HSIZE        => HSIZES0,
      HTRANS       => HTRANSS0,
      HWDATA       => HWDATAS0,
      HWRITE       => HWRITES0,
      HSELmtrx     => HSELS0,
      HREADYOUT    => HREADYS0,

      HRDATAmtrx   => HRDATAS0,
      HREADYmtrx   => HREADYmtrxS0,
      HRESPmtrx    => HRESPS0,

      -- ARM922T Test Slave connections
      HADDRtst     => HADDRtst(11 downto 2),
      HSELtst      => HSELtst,
      HTRANStst    => HTRANStst,
      HWRITEtst    => HWRITEtst,
      HWDATAtst    => HWDATAtst,

      HRDATAtst    => HRDATAtst,
      HREADYOUTtst => HREADYtst,
      HRESPtst     => HRESPtst,

      -- ARM922T interrupts
      nFIQ         => nFIQ,
      nIRQ         => nIRQ,
      
      -- ARM922T comms channel debug lines
      COMMRX       => COMMRX,
      COMMTX       => COMMTX,

      -- ARM922T Fast Cache clock
      FCLK         => XFCLK,

      -- JTAG connections      
      nTRST        => nTRST,
      TCK          => TCK,
      TDI          => TDI,
      TMS          => TMS,
      nTDOEN       => nTDOEN,
      TDO          => TDO,

      -- Remap/Pause control signals
      Remap        => Remap,
      Pause        => Pause,

      -- Scan signals
      SCANENABLE   => SCANENABLE,
      SCANINHCLK   => SCANINHCLKinp0,
      SCANOUTHCLK  => SCANOUTHCLKinp0      
      );


-- Inport 1 (EgMaster and File Reader Bus Master)
  uInport1 : Inport1
    -- pragma synthesis_off
    generic map(
      -- Stimulus file for the File Reader Bus Master
      StimFileFRBM => "filestim.frd",
      -- Enable for Example Bus Master (EgMaster)
      EnableEBM    => 1,
      -- EgMaster reads from the external memory via SMI (0x30000000)
      ReadAddrEBM  => 16#030#,
      -- EgMaster writes to the external memory via SMI (0x34000000)
      WriteAddrEBM => 16#034#,
      -- Number of cycles between transactions by EgMaster
      InitCountEBM => 1000
      )
    -- pragma synthesis_on
    port map(
      -- Common AHB signals
      HCLK        => HCLK,
      HRESETn     => HRESETn,

      -- Reset for FRBM from Watchdog
      nRESETfrbm  => WDOGRESn,

      -- Matrix AHB connections
      HADDR       => HADDRS1,
      HBURST      => HBURSTS1,
      HMASTLOCK   => HMASTLOCKS1,
      HPROT       => HPROTS1,
      HSIZE       => HSIZES1,
      HTRANS      => HTRANSS1,
      HWDATA      => HWDATAS1,
      HWRITE      => HWRITES1,
      HSELmtrx    => HSELS1,
      HREADYOUT   => HREADYS1,

      HRDATAmtrx  => HRDATAS1,
      HREADYmtrx  => HREADYmtrxS1,
      HRESPmtrx   => HRESPS1,

      -- Pause control signal
      Pause       => Pause,

      -- Scan signals
      SCANENABLE  => SCANENABLE,
      SCANINHCLK  => SCANINHCLKinp1,
      SCANOUTHCLK => SCANOUTHCLKinp1
     );


-- Outport 0 (TIC, SMI, Retry slave, Default Slave and Lite2AHB wrapper)
  uOutport0 : Outport0
    port map(
      -- Common AHB signals
      HCLK        => HCLK,
      HRESETn     => HRESETn,

      -- Matrix AHB connections
      HADDR       => HADDRM0,
      HBURST      => HBURSTM0,
      HMASTLOCK   => HMASTLOCKM0,
      HPROT       => HPROTM0,
      HREADYmtrx  => HREADYM0,
      HSELmtrx    => HSELM0,
      HSIZE       => HSIZEM0,
      HTRANS      => HTRANSM0,
      HWDATA      => HWDATAM0,
      HWRITE      => HWRITEM0,

      HRDATA      => HRDATAM0,
      HREADYOUT   => HREADYOUTM0,
      HRESP       => HRESPM0,
      
      -- Remap control signal
      Remap       => Remap,

      -- SMI external connections
      SMDATAIN    => SMDATAIN,
      SMDATAOUT   => SMDATAOUT,
      nSMDATAEN   => nSMDATAEN,
      SMADDR      => SMADDR,
      SMCS        => SMCS,
      nSMBLS      => nSMBLS,
      nSMOEN      => nSMOEN,

      -- TIC connections (AHB)
      HADDRtst    => HADDRtst,
      HSELtst     => HSELtst,
      HTRANStst   => HTRANStst,
      HWRITEtst   => HWRITEtst,
      HWDATAtst   => HWDATAtst,

      HREADYtst   => HREADYtst,
      HRESPtst    => HRESPtst,
      HRDATAtst   => HRDATAtst,

      -- TIC test signals
      TESTREQA    => TESTREQA,
      TESTREQB    => TESTREQB,
      TESTACK     => TESTACK,

      -- Scan signals
      SCANENABLE  => SCANENABLE,
      SCANINHCLK  => SCANINHCLKoutp0,
      SCANOUTHCLK => SCANOUTHCLKoutp0
      );


-- Outport 1 (AHB IRQ Controller)
  uOutport1 : Outport1
    port map(
      -- Common AHB signals
      HCLK        => HCLK,
      HRESETn     => HRESETn,

      -- Matrix AHB connections
      HADDR       => HADDRM1,
      HBURST      => HBURSTM1,
      HPROT       => HPROTM1,
      HREADYmtrx  => HREADYM1,
      HSELmtrx    => HSELM1,
      HSIZE       => HSIZEM1,
      HTRANS      => HTRANSM1,
      HWDATA      => HWDATAM1,
      HWRITE      => HWRITEM1,

      HRDATA      => HRDATAM1,
      HREADYOUT   => HREADYOUTM1,
      HRESP       => HRESPM1,

      -- Peripheral interrupt sources
      WDOGINT     => WDOGINT,
      TIMINTC     => TIMINTC,
      TIMINT2     => TIMINT2,
      TIMINT1     => TIMINT1,
      GPIOMIS     => GPIOMIS,
      GPIOINTR    => GPIOINTR,
      
      -- Processor interrupts
      nICFIQ      => nFIQ,
      nICIRQ      => nIRQ,

      -- Scan signals
      SCANENABLE  => SCANENABLE,
      SCANINHCLK  => SCANINHCLKoutp1,
      SCANOUTHCLK => SCANOUTHCLKoutp1
      );
  

-- Outport 2 (AHB-APB Bridge, Timers, Remap/Pause, Watchdog, Example APB Slave
--  and GPIO)
  uOutport2 : Outport2
    port map(
      -- Common AHB signals
      HCLK        => HCLK,
      HRESETn     => HRESETn,

      -- Matrix AHB connections
      HADDR       => HADDRM2,
      HBURST      => HBURSTM2,
      HPROT       => HPROTM2,
      HREADYmtrx  => HREADYM2,
      HSELmtrx    => HSELM2,
      HSIZE       => HSIZEM2,
      HTRANS      => HTRANSM2,
      HWDATA      => HWDATAM2,
      HWRITE      => HWRITEM2,

      HRDATA      => HRDATAM2,
      HREADYOUT   => HREADYOUTM2,
      HRESP       => HRESPM2,

      -- Timer signals 
      TIMINT1     => TIMINT1,
      TIMINT2     => TIMINT2,
      TIMINTC     => TIMINTC,

      -- Watchdog signals
      WDOGRESn    => WDOGRESn,
      WDOGRES     => WDOGRES,
      WDOGINT     => WDOGINT,

      -- Processor interrupts
      nFIQ        => nFIQ,
      nIRQ        => nIRQ,
      
      -- Remap/Pause control signals
      Pause       => Pause,
      Remap       => Remap,

      -- GPIO signals
      GPIN        => GPIN,
      nGPAFEN     => nGPAFEN,
      GPAFOUT     => GPAFOUT,
      GPOUT       => GPOUT,
      nGPEN       => nGPEN,
      GPAFIN      => GPAFIN,
      GPIOINTR    => GPIOINTR,
      GPIOMIS     => GPIOMIS,

      -- Scan signals
      SCANENABLE  => SCANENABLE,
      SCANINHCLK  => SCANINHCLKoutp2,
      SCANOUTHCLK => SCANOUTHCLKoutp2,
      SCANINPCLK  => SCANINPCLKoutp2,
      SCANOUTPCLK => SCANOUTPCLKoutp2
      );


end structural;

--================================= End ======================================--
