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
--  File Name           : Inport1.vhd,v
--  File Revision       : 1.7
--  
--  Release Information : ADK_REL1v1
--  
--  ----------------------------------------------------------------------------
--  Purpose             : Structural sub-block architecture of Example Amba 
--                        SYstem Multi-layer (EASY-ML), connected to BusMatrix
--                        Inport 1. The module contains the following AHB 
--                        devices:
--                       
--                          - File Reader Bus Master (Local master 3)
--                          - Example Bus Master (Local master 1)
--                          - Local Arbiter3
--                          - Local Master-to-Slave multiplexor
--                       
--                        The BusMatrix is the only slave to this module,
--                        therefore the HSELmtrx signal is always driven high.
--                       
--                        The Pause signal is used to remove the bus grant
--                        from the two masters by raising a request on HBUSREQ0
--                        which is assigned to the Dummy Master.
--============================================================================--

library ieee;
use     ieee.std_logic_1164.all;

-- pragma translate_off
library EgMaster;
use EgMaster.all;
library FileReader;
use FileReader.all;
library ElementsAHB;
use ElementsAHB.all;
-- pragma translate_on

entity Inport1 is
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
end Inport1;

architecture structural of Inport1 is

--------------------------------------------------------------------------------
-- Components: Module specific (AHB)
--------------------------------------------------------------------------------

-- Example Bus Master (master 1)
  component EgMaster
    -- pragma synthesis_off
    generic(
      -- Block enable
      EBMenable    : integer := 1;
      -- Base address read
      EBMreadAddr  : integer := 16#0D0#;
      -- Base address write
      EBMwriteAddr : integer := 16#0C4#;
      -- Delay between transactions
      EBMinitCount : integer := 4
      );
    -- pragma synthesis_on
    port(
      HCLK        : in  std_logic;
      HRESETn     : in  std_logic;

      HRDATA      : in  std_logic_vector(31 downto 0);
      HREADY      : in  std_logic;
      HRESP       : in  std_logic_vector(1 downto 0);
      HGRANT      : in  std_logic;

      HADDR       : out std_logic_vector(31 downto 0);
      HTRANS      : out std_logic_vector(1 downto 0);
      HWRITE      : out std_logic;
      HSIZE       : out std_logic_vector(2 downto 0);
      HBURST      : out std_logic_vector(2 downto 0);
      HPROT       : out std_logic_vector(3 downto 0);
      HWDATA      : out std_logic_vector(31 downto 0);
      HBUSREQ     : out std_logic;
      HLOCK       : out std_logic;

      -- Scan test dummy signals; not connected until scan insertion 
      SCANENABLE  : in  std_logic; -- Scan Test Mode Enbl
      SCANINHCLK  : in  std_logic; -- Scan Chain Input
      SCANOUTHCLK : out std_logic  -- Scan Chain Output    
      );
  end component;

-- File Reader Bus Master (master 3)
  component FileReader
    -- pragma synthesis_off
    generic(
      InputFileName : string := "filestim.frd"  -- Default stimulus filename
      );
    -- pragma synthesis_on
    port(
      HCLK    : in  std_logic;
      HRESETn : in  std_logic;

      HGRANT  : in  std_logic;
      HREADY  : in  std_logic;
      HRESP   : in  std_logic_vector(1 downto 0);
      HRDATA  : in  std_logic_vector(31 downto 0);

      HBUSREQ : out std_logic;
      HTRANS  : out std_logic_vector(1 downto 0);
      HBURST  : out std_logic_vector(2 downto 0);
      HPROT   : out std_logic_vector(3 downto 0);
      HSIZE   : out std_logic_vector(2 downto 0);
      HWRITE  : out std_logic;
      HLOCK   : out std_logic;
      HADDR   : out std_logic_vector(31 downto 0);
      HWDATA  : out std_logic_vector(31 downto 0)
      );
  end component;


--------------------------------------------------------------------------------
-- Components: Common AHB Infrastructure
--------------------------------------------------------------------------------

-- Local Arbiter
  component Arbiter3
    port(
      HCLK        : in  std_logic;
      HRESETn     : in  std_logic;

      HTRANS      : in  std_logic_vector(1 downto 0);
      HBURST      : in  std_logic_vector(2 downto 0);
      HREADY      : in  std_logic;
      HRESP       : in  std_logic_vector(1 downto 0);
      
      HBUSREQM3   : in  std_logic;
      HBUSREQM2   : in  std_logic;
      HBUSREQM1   : in  std_logic;
      HBUSREQM0   : in  std_logic;

      HLOCKM3     : in  std_logic;
      HLOCKM2     : in  std_logic;
      HLOCKM1     : in  std_logic;
      HLOCKM0     : in  std_logic;

      HSPLIT      : in  std_logic_vector(3 downto 0);
      
      HGRANTM3    : out std_logic;
      HGRANTM2    : out std_logic;
      HGRANTM1    : out std_logic;
      HGRANTM0    : out std_logic;
      
      HMASTER     : out std_logic_vector(3 downto 0);
      HMASTERD    : out std_logic_vector(3 downto 0);
      HMASTLOCK   : out std_logic;

      -- Scan test dummy signals; not connected until scan insertion 
      SCANENABLE  : in  std_logic; -- Scan Test Mode Enbl
      SCANINHCLK  : in  std_logic; -- Scan Chain Input
      SCANOUTHCLK : out std_logic  -- Scan Chain Output
      );
  end component;

-- Local muliplexer - master to slaves. Also generates the dummy master
--  outputs when no other masters are selected
  component MuxM2S
    port(
      HMASTER  : in  std_logic_vector(3 downto 0);
      HMASTERD : in  std_logic_vector(3 downto 0);
      
      HADDRM1  : in  std_logic_vector(31 downto 0);
      HTRANSM1 : in  std_logic_vector(1 downto 0);
      HWRITEM1 : in  std_logic;
      HSIZEM1  : in  std_logic_vector(2 downto 0);
      HBURSTM1 : in  std_logic_vector(2 downto 0);
      HPROTM1  : in  std_logic_vector(3 downto 0);
      HWDATAM1 : in  std_logic_vector(31 downto 0);
      
      HADDRM2  : in  std_logic_vector(31 downto 0);
      HTRANSM2 : in  std_logic_vector(1 downto 0);
      HWRITEM2 : in  std_logic;
      HSIZEM2  : in  std_logic_vector(2 downto 0);
      HBURSTM2 : in  std_logic_vector(2 downto 0);
      HPROTM2  : in  std_logic_vector(3 downto 0);
      HWDATAM2 : in  std_logic_vector(31 downto 0);
      
      HADDRM3  : in  std_logic_vector(31 downto 0);
      HTRANSM3 : in  std_logic_vector(1 downto 0);
      HWRITEM3 : in  std_logic;
      HSIZEM3  : in  std_logic_vector(2 downto 0);
      HBURSTM3 : in  std_logic_vector(2 downto 0);
      HPROTM3  : in  std_logic_vector(3 downto 0);
      HWDATAM3 : in  std_logic_vector(31 downto 0);
      
      HADDR    : out std_logic_vector(31 downto 0);
      HTRANS   : out std_logic_vector(1 downto 0);
      HWRITE   : out std_logic;
      HSIZE    : out std_logic_vector(2 downto 0);
      HBURST   : out std_logic_vector(2 downto 0);
      HPROT    : out std_logic_vector(3 downto 0);
      HWDATA   : out std_logic_vector(31 downto 0)
      );
  end component;


--------------------------------------------------------------------------------
-- Signal declarations: AHB
--------------------------------------------------------------------------------

-- Local Master specific signals
  signal HBUSREQM0 : std_logic;
  signal HGRANTM0  : std_logic;
  signal HLOCKM0   : std_logic;
    
  signal HADDRM1   : std_logic_vector(31 downto 0);
  signal HBURSTM1  : std_logic_vector(2 downto 0);
  signal HBUSREQM1 : std_logic;
  signal HGRANTM1  : std_logic;
  signal HLOCKM1   : std_logic;
  signal HPROTM1   : std_logic_vector(3 downto 0);
  signal HSIZEM1   : std_logic_vector(2 downto 0);
  signal HTRANSM1  : std_logic_vector(1 downto 0);
  signal HWDATAM1  : std_logic_vector(31 downto 0);
  signal HWRITEM1  : std_logic;

  signal HADDRM2   : std_logic_vector(31 downto 0);
  signal HBURSTM2  : std_logic_vector(2 downto 0);
  signal HBUSREQM2 : std_logic;
  signal HGRANTM2  : std_logic;
  signal HLOCKM2   : std_logic;
  signal HPROTM2   : std_logic_vector(3 downto 0);
  signal HSIZEM2   : std_logic_vector(2 downto 0);
  signal HTRANSM2  : std_logic_vector(1 downto 0);
  signal HWDATAM2  : std_logic_vector(31 downto 0);
  signal HWRITEM2  : std_logic;

  signal HADDRM3   : std_logic_vector(31 downto 0);
  signal HBURSTM3  : std_logic_vector(2 downto 0);
  signal HBUSREQM3 : std_logic;
  signal HGRANTM3  : std_logic;
  signal HLOCKM3   : std_logic;
  signal HPROTM3   : std_logic_vector(3 downto 0);
  signal HSIZEM3   : std_logic_vector(2 downto 0);
  signal HTRANSM3  : std_logic_vector(1 downto 0);
  signal HWDATAM3  : std_logic_vector(31 downto 0);
  signal HWRITEM3  : std_logic;

-- Miscellaneous signals

  signal HMASTER   : std_logic_vector(3 downto 0);
  signal HMASTERD  : std_logic_vector(3 downto 0);

  signal iHTRANS   : std_logic_vector(1 downto 0);
  signal iHBURST   : std_logic_vector(2 downto 0);
  signal HSPLIT    : std_logic_vector(15 downto 0);


--------------------------------------------------------------------------------
-- Signal declarations: Scan chain
--------------------------------------------------------------------------------

  signal SCANINarb    : std_logic;
  signal SCANOUTarb   : std_logic;
  signal SCANINegmst  : std_logic;
  signal SCANOUTegmst : std_logic;

  
--------------------------------------------------------------------------------
-- Signal declarations: Tie-offs
--------------------------------------------------------------------------------

  signal TieOffHi1  : std_logic;

  
--------------------------------------------------------------------------------
-- Beginning of main code
--------------------------------------------------------------------------------

begin

-- The TieOff signals must be assigned explicitly within the body of the VHDL.
-- Using initial values (in the signal declaration, above) will not work in
--  Synopsys. Signals are used rather than constants as constants can not be 
--  connected directly to sub-component instantiations
  TieOffHi1  <= '1';


-- Example Bus Master instantiated as Local master 1
  uEgMaster : EgMaster
    -- pragma synthesis_off
    generic map(
      -- These map to the top level generics
      EBMenable    => EnableEBM,
      EBMreadAddr  => ReadAddrEBM,
      EBMwriteAddr => WriteAddrEBM,
      EBMinitCount => InitCountEBM
      )
    -- pragma synthesis_on
    port map(
      HCLK        => HCLK,
      HRESETn     => HRESETn,
    
      HRDATA      => HRDATAmtrx,
      HREADY      => HREADYmtrx,
      HRESP       => HRESPmtrx,
      HGRANT      => HGRANTM1,

      HADDR       => HADDRM1,
      HTRANS      => HTRANSM1,
      HWRITE      => HWRITEM1,
      HSIZE       => HSIZEM1,
      HBURST      => HBURSTM1,
      HPROT       => HPROTM1,
      HWDATA      => HWDATAM1,
      HBUSREQ     => HBUSREQM1,
      HLOCK       => HLOCKM1,

      -- Scan signals
      SCANENABLE  => SCANENABLE,
      SCANINHCLK  => SCANINegmst,
      SCANOUTHCLK => SCANOUTegmst
      );


-- File Reader Bus Master instantiated as Local master 3
  uFileReader : FileReader
    -- pragma synthesis_off 
    generic map(
      -- This maps to the top level generic
      InputFileName => StimFileFRBM
      )
    -- pragma synthesis_on
    port map(
      HCLK    => HCLK,
      HRESETn => nRESETfrbm,  -- Not reset via HRESETn, to allow Reset test

      HGRANT  => HGRANTM3,
      HREADY  => HREADYmtrx,
      HRESP   => HRESPmtrx,
      HRDATA  => HRDATAmtrx,
    
      HBUSREQ => HBUSREQM3,
      HTRANS  => HTRANSM3,
      HBURST  => HBURSTM3,
      HPROT   => HPROTM3,
      HSIZE   => HSIZEM3,
      HWRITE  => HWRITEM3,
      HLOCK   => HLOCKM3,
      HADDR   => HADDRM3,
      HWDATA  => HWDATAM3
      );


-- Local Arbiter
  uArbiter : Arbiter3
    port map(
      HCLK        => HCLK,
      HRESETn     => HRESETn,

      HTRANS      => iHTRANS,
      HBURST      => iHBURST,
      HREADY      => HREADYmtrx,
      HRESP       => HRESPmtrx,

      HBUSREQM3   => HBUSREQM3,
      HBUSREQM2   => HBUSREQM2,
      HBUSREQM1   => HBUSREQM1,
      HBUSREQM0   => HBUSREQM0,

      HLOCKM3     => HLOCKM3,
      HLOCKM2     => HLOCKM2,
      HLOCKM1     => HLOCKM1,
      HLOCKM0     => HLOCKM0,

      HSPLIT      => HSPLIT(3 downto 0),

      HGRANTM3    => HGRANTM3,
      HGRANTM2    => HGRANTM2,
      HGRANTM1    => HGRANTM1,
      HGRANTM0    => HGRANTM0,
      
      HMASTER     => HMASTER,
      HMASTERD    => HMASTERD,
      HMASTLOCK   => HMASTLOCK,
    
      -- Scan signals
      SCANENABLE  => SCANENABLE,
      SCANINHCLK  => SCANINarb,
      SCANOUTHCLK => SCANOUTarb
      );

  -- Pause requests Master 0 (2nd highest priority)
  HBUSREQM0 <= Pause;

  -- Unconnected Arbiter inputs driven LOW
  HLOCKM0   <= '0';
  HLOCKM2   <= '0';
  HBUSREQM2 <= '0';
  HSPLIT    <= (others => '0');


-- Local multiplexer - masters to slaves
  uMuxM2S : MuxM2S
    port map(
      HMASTER  => HMASTER,
      HMASTERD => HMASTERD,

      HADDRM1  => HADDRM1,
      HTRANSM1 => HTRANSM1,
      HWRITEM1 => HWRITEM1,
      HSIZEM1  => HSIZEM1,
      HBURSTM1 => HBURSTM1,
      HPROTM1  => HPROTM1,
      HWDATAM1 => HWDATAM1,

      HADDRM2  => HADDRM2,
      HTRANSM2 => HTRANSM2,
      HWRITEM2 => HWRITEM2,
      HSIZEM2  => HSIZEM2,
      HBURSTM2 => HBURSTM2,
      HPROTM2  => HPROTM2,
      HWDATAM2 => HWDATAM2,

      HADDRM3  => HADDRM3,
      HTRANSM3 => HTRANSM3,
      HWRITEM3 => HWRITEM3,
      HSIZEM3  => HSIZEM3,
      HBURSTM3 => HBURSTM3,
      HPROTM3  => HPROTM3,
      HWDATAM3 => HWDATAM3,

      HADDR    => HADDR,
      HTRANS   => iHTRANS,
      HWRITE   => HWRITE,
      HSIZE    => HSIZE,
      HBURST   => iHBURST,
      HPROT    => HPROT,
      HWDATA   => HWDATA
    );


-- Drive the BusMatrix select signal HIGH because there are no other
--  slaves present in this module and BusMatrix is also the Default Slave
  HSELmtrx  <= TieOffHi1;


-- Drive HREADYOUT with the state of HREADY from the BusMatrix because 
--  it is the Default Slave (see previous comment)
  HREADYOUT <= HREADYmtrx;       


-- Connect these Local AHB backbone signals to the module interface
  HTRANS <= iHTRANS;
  HBURST <= iHBURST;

  
end structural;

-- --================================= End ===================================--

