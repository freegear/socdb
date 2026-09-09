--*******************************************************************--
-- Copyright (c) 2001-2003  Evatronix SA                             --
--*******************************************************************--
-- Please review the terms of the license agreement before using     --
-- this file. If you are not an authorized user, please destroy this --
-- source code file and notify Evatronix SA immediately that you     --
-- inadvertently received an unauthorized copy.                      --
--*******************************************************************--

-----------------------------------------------------------------------
-- Project name         : MAC-1G AMBA
-- Project description  : Gigabit Ethernet Media Access Controller
--
-- File name            : mac_1g_amba_tb
-- File contents        : Entity MAC_1G_AMBA_TB
--                        Architecture TESTBENCH of MAC_1G_AMBA_TB
-- Purpose              : Testbench for MAC_1G_AMBA
--
-- Destination library  : MAC_1G_AMBA_LIB
-- Dependencies         : MAC_1G_LIB.UTILITY
--                        IEEE.STD_LOGIC_1164
--
-- Design Engineer      : T.K.
-- Quality Engineer     : L.C.
-- Version              : 2.00.E00
-- Last modification    : 2003-11-27
-----------------------------------------------------------------------

--*******************************************************************--
-- Modifications with respect to Version 2.00.E00:
--*******************************************************************--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library MAC_1G_LIB;
use MAC_1G_LIB.UTILITY_MAC_1G.all;    

library MAC_1G_AMBA_LIB;

--*******************************************************************--

entity MAC_1G_AMBA_TB is
  
  generic (
    -- test directory name
    TESTNAME        : STRING  := "default";
    -- path to the test directory
    TESTPATH        : STRING  := "tests";
    -- transmit clock period
    CLKMII_PERIOD   : TIME    := 40 ns; --  40 ns (100M mode ); 400 ns (10M mode)
    -- AHB clock period
    CLKAHB_PERIOD   : TIME    := 40 ns;
    -- APB clock period
    CLKAPB_PERIOD   : TIME    := 40 ns;
    -- dma reset period
    RSTAHB_CYCLES   : INTEGER := 32;
    -- csr reset period
    RSTAPB_CYCLES   : INTEGER := 32;
    -- link monitor mode
    LINKMODE        : INTEGER := 2;     -- 0 - no occurrence
    --                                  -- 1 - the COMPFILE writer
    --                                  -- 2 - vectors comparator
    -- interrupt monitor mode  
    INTMODE         : INTEGER := 2;     -- 0 - no occurrence
    --                                  -- 1 - the COMPFILE writer
    --                                  -- 2 - vectors comparator
    -- APB interface monitor mode
    APBMODE         : INTEGER := 2;     -- 0 - no occurrence
    --                                  -- 1 - the COMPFILE writer
    --                                  -- 2 - vectors comparator
    -- AHB interface comparator mode 
    AHBMODE         : INTEGER := 2;     -- 0 - no occurrence
    --                                  -- 1 - the COMPFILE writer
    --                                  -- 2 - vectors comparator
    -- AMBA arbiter mode 
    ARBMODE         : INTEGER := 1;     -- 0 - no occurrence
    --                                  -- 1 - stimulate
    -- AMBA APB data bus width  --
    APBDATAWIDTH    : INTEGER := 32;    -- 8, 16, 32
    -- AMBA AHB data bus width --
    AHBDATAWIDTH    : INTEGER := 32;    -- 8, 16, 32
    -- AMBA AHB address bus width --
    AHBADDRESSWIDTH : INTEGER := 32;    -- 8..32
    -- Transmit FIFO depth
    TFIFODEPTH      : INTEGER := 9;     -- 6..16 (9 def)
    -- Receive FIFO depth
    RFIFODEPTH      : INTEGER := 9;     -- 6..16 (9 def)
    -- Transmit frame cache depth
    TCDEPTH         : INTEGER := 1;     -- 1... (1 def)
    -- Receive frame cache depth
    RCDEPTH         : INTEGER := 2      -- 1... (2 def)
    );
  
end MAC_1G_AMBA_TB;


--*******************************************************************--


architecture TESTBENCH of MAC_1G_AMBA_TB is
  
  -------------------------------------------------------
  -- MAC_AMBA component --
  -------------------------------------------------------
  component CHIP_MAC_1G_AMBA
    
    generic (
      -- AMBA AHB data bus width --
      AHBDATAWIDTH    : INTEGER := 32;    -- 8, 16, 32
      -- AMBA AHB address bus width --
      AHBADDRESSWIDTH : INTEGER := 32;    -- 8..32
      -- AMBA APB data bus width  --
      APBDATAWIDTH    : INTEGER := 32;    -- 8, 16, 32
      -- Transmit FIFO depth
      TFIFODEPTH      : INTEGER := 9;     -- 6..16 (9 def)
      -- Receive FIFO depth
      RFIFODEPTH      : INTEGER := 9;     -- 6..16 (9 def)
      -- Transmit frame cache depth
      TCDEPTH         : INTEGER := 1;     -- 1... (1 def)
      -- Receive frame cache depth
      RCDEPTH         : INTEGER := 2      -- 1... (2 def)
      );
    
    port(
      ----------------------------- clocks ------------------------
      -- transmit clock
      clkt      : in  STD_LOGIC;
      -- receive clock
      clkr      : in  STD_LOGIC;
      
      -------------------------- clock control --------------------
      -- transmit process stopped
      tps       : out STD_LOGIC;
      -- receive process stopped
      rps       : out STD_LOGIC;
      -- gigabit mode
      gbo       : out STD_LOGIC;
      
      -------------------------- interrupt ------------------------
      int       : out STD_LOGIC;
      
      ----------------------- AMBA AHB interface ----------------------
      -- bus clock --
      hclk        : in  STD_LOGIC;
      -- bus reset --
      hresetn     : in  STD_LOGIC;
      -- read data bus --
      hrdata      : in  STD_LOGIC_VECTOR(AHBDATAWIDTH-1 downto 0);
      -- transfer done --
      hready      : in  STD_LOGIC;
      -- transfer responce --
      hresp       : in  STD_LOGIC_VECTOR(1 downto 0);
      -- bus address --
      haddr       : out STD_LOGIC_VECTOR(AHBADDRESSWIDTH-1 downto 0);
      -- transfer type --
      htrans      : out STD_LOGIC_VECTOR(1 downto 0);
      -- transfer direction --
      hwrite      : out STD_LOGIC;
      -- transfer size --
      hsize       : out STD_LOGIC_VECTOR(2 downto 0);
      -- burst type --
      hburst      : out STD_LOGIC_VECTOR(2 downto 0);
      -- protection control --
      hprot       : out STD_LOGIC_VECTOR(3 downto 0);
      -- write data bus --
      hwdata      : out STD_LOGIC_VECTOR(AHBDATAWIDTH-1 downto 0);
      
      -- bus grant --
      hgrantmac   : in  STD_LOGIC;
      -- bus request --
      hbusreqmac  : out STD_LOGIC;
      -- locked transfers --
      hlockmac    : out STD_LOGIC;
      
      -----------------------  AMBA APB interface  ---------------------
      -- interface clock --
      pclk        : in  STD_LOGIC;
      -- bus reset --
      presetn     : in  STD_LOGIC;
      -- bus address --
      paddr       : in  STD_LOGIC_VECTOR(CSRDEPTH-1 downto 0);
      -- device select --
      pselmaccsr  : in  STD_LOGIC;
      -- device enable --
      penable     : in  STD_LOGIC;
      -- transfer direction --
      pwrite      : in  STD_LOGIC;
      -- write data --
      pwdata      : in  STD_LOGIC_VECTOR(APBDATAWIDTH-1 downto 0);
      -- read data  --
      prdata      : out  STD_LOGIC_VECTOR(APBDATAWIDTH-1 downto 0);
      
      
      -------------------- external address filtering -----------------
      -- match input
      match      : in  STD_LOGIC;
      -- match valid
      matchval   : in  STD_LOGIC;
      -- match enable
      matchen    : out STD_LOGIC;
      -- match data
      matchdata  : out STD_LOGIC_VECTOR(47 downto 0);
      
      -------------------- serial micro-wire interface ----------------
      -- serial data input
      sdi        : in  STD_LOGIC;
      -- serial clock
      sclk       : out STD_LOGIC;
      -- serial chip select
      scs        : out STD_LOGIC;
      -- serial data output
      sdo        : out STD_LOGIC;
      
      ----------------------------- mii ---------------------------
      -- receive error
      rxer       : in  STD_LOGIC;
      -- receive data valid
      rxdv       : in  STD_LOGIC;
      -- collision detected
      col        : in  STD_LOGIC;
      -- carrier sense
      crs        : in  STD_LOGIC;
      -- receive data
      rxd        : in  STD_LOGIC_VECTOR(MIIWIDTH-1 downto 0);
      -- transmit enable
      txen       : out STD_LOGIC;
      -- mii transmit error
      txer      : out STD_LOGIC;
      -- transmit data
      txd        : out STD_LOGIC_VECTOR(MIIWIDTH-1 downto 0);
      -- management clock
      mdc        : out STD_LOGIC;
      -- management data input / output
      mdio       : inout  STD_LOGIC
      );
  end component;
  
  ----------------------------------------------
  -- RAM with AHB interface and stimulator  
  ----------------------------------------------
  component SMEMSTIMAHB 
    generic(
      DATAWIDTH   : INTEGER := 32;
      ADDRWIDTH   : INTEGER := 32;
      MODE        : INTEGER := 0; -- Comparator mode
      --                          -- 0 - no occurrence
      --                          -- 1 - stimulator with COMPFILE writer
      --              -- 2 - stimulator with comparator
      STIMFILE    : STRING  := "smemstim.txt";
      COMPFILE    : STRING  := "ahbcomp.txt";
      DIFFFILE    : STRING  := "ahbdiff.txt";
      TESTNAME    : STRING  := "default";
      TESTPATH    : STRING  := "tests";
      CLK_PERIOD  : TIME    := 40 ns
      );
    port(
      --       AHB interface 
      -- Bus clock
      hclk          : in  STD_LOGIC;
      -- Reset
      hresetn       : in  STD_LOGIC;
      -- Select
      hsel          : in STD_LOGIC;
      -- Transfer direction
      hwr           : in STD_LOGIC;
      -- Locked transfers
      hmastlock     : in STD_LOGIC;
      -- Master select
      hmaster       : in STD_LOGIC_VECTOR(3 downto 0);
      -- Transfer type
      htrans        : in STD_LOGIC_VECTOR(1 downto 0);
      -- Transfer size
      hsize         : in STD_LOGIC_VECTOR(2 downto 0);
      -- Burst type
      hburst        : in STD_LOGIC_VECTOR(2 downto 0);
      -- Write data bus
      hwdata        : in STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
      -- Address bus
      haddr         : in STD_LOGIC_VECTOR(ADDRWIDTH-1 downto 0);
      -- Transfer done 
      hready        : out  STD_LOGIC;
      -- Transfer response 
      hresp         : out STD_LOGIC_VECTOR(1 downto 0);
      -- Read data bus
      hrdata        : out STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0)
      );
  end component;
  
  ----------------------------------------------
  -- AMBA arbiter signal stimulator  
  ----------------------------------------------
  component AMBAARBCMD 
    generic(
      MODE            : INTEGER := 1; -- operating mode
      --                              -- 0 - no occurrence
      --                              -- 1 - stimulate
      STIMFILE        : STRING  := "arbstim.txt";
      TESTNAME        : STRING  := "default";
      TESTPATH        : STRING  := "tests";
      CLK_PERIOD      : TIME    := 40 ns 
      );
    
    port(
      -- AHB interface clock --
      hclk        : in  STD_LOGIC;
      -- AHB bus reset --
      hresetn     : in  STD_LOGIC;
      -- AHB MAC bus request
      hbusreqmac  : in  STD_LOGIC;
      -- AHB MAC lock transfer
      hlockmac    : in  STD_LOGIC;
      -- AHB Master identifier --
      hmaster     : out STD_LOGIC_VECTOR(3 downto 0);
      -- AHB master lock transfer --
      hmastlock   : out STD_LOGIC;
      -- AHB MAC bus grant
      hgrantmac   : out STD_LOGIC;
      -- RAM_AHB select
      hselram     : out STD_LOGIC;
      -- memory wait cycles
      waitstates  : out STD_LOGIC_VECTOR(2 downto 0)
      );
  end component;
  
  -------------------------------------------------------
  -- APB stimulator 
  -------------------------------------------------------
  
  component APBCMD 
    generic(
      MODE            : INTEGER := 1; -- operating mode
      --                              -- 0 - no occurrence
      --                              -- 1 - the COMPFILE writer
      --                              -- 2 - vectors comparator
      APBDATAWIDTH    : INTEGER := 32;
      APBADDRESSWIDTH : INTEGER := 8;
      STIMFILE        : STRING  := "apbstim.txt";
      COMPFILE        : STRING  := "apbcomp.txt";
      DIFFFILE        : STRING  := "apbdiff.txt";
      TESTNAME        : STRING  := "default";
      TESTPATH        : STRING  := "tests";
      CLK_PERIOD      : TIME    := 40 ns 
      );
    
    port(
      
      -- interface clock --
      pclk        : in  STD_LOGIC;
      -- bus reset --
      presetn     : in  STD_LOGIC;
      -- read data  --
      prdata      : in  STD_LOGIC_VECTOR(APBDATAWIDTH-1 downto 0);  
      -- bus address --
      paddr       : out STD_LOGIC_VECTOR(APBADDRESSWIDTH-1 downto 0);
      -- device select --
      pselmaccsr  : out STD_LOGIC;
      -- device enable --
      penable     : out STD_LOGIC;
      -- transfer direction --
      pwrite      : out STD_LOGIC;
      -- write data --
      pwdata      : out STD_LOGIC_VECTOR(APBDATAWIDTH-1 downto 0)
      
      );
  end component;
  
  ---------------------------------------------------------------------
  -- Link monitor
  ---------------------------------------------------------------------
  component LINKMON
    generic (
      MODE       : INTEGER := 0; -- Comparator mode
      --                         -- 0 - no occurrence
      --                         -- 1 - the COMPFILE writer
      --                         -- 2 - vectors comparator
      -- clock period
      CLK_PERIOD : TIME    := 40 ns;
      -- file with compare vectors
      COMPFILE   : STRING  := "linkcomp.txt";
      -- file with differences
      DIFFFILE   : STRING  := "linkdiff.txt";
      -- file with stimulus vectors
      STIMFILE   : STRING  := "linkstim.txt";
      -- test name
      TESTNAME   : STRING  := "default";
      -- path to the filename
      TESTPATH   : STRING  := "tests";
      -- mii width
      MIIWIDTH   : INTEGER := 4 -- 4
      );
    port(
      -- mii clock
      clk       : in  STD_LOGIC;
      -- reset
      rst       : in  STD_LOGIC; 
      -- gigabit mode 
      gb        : in  STD_LOGIC;
      -- transmit enable
      txen      : in  STD_LOGIC;
      -- transmit error
      txer      : in  STD_LOGIC;
      -- transmit data
      txd       : in  STD_LOGIC_VECTOR(MIIWIDTH-1 downto 0);
      -- collision detection
      col       : out STD_LOGIC;
      -- carrier sense
      crs       : out STD_LOGIC;
      -- receive data valid
      rxdv      : out STD_LOGIC;
      -- receive error
      rxer      : out STD_LOGIC;
      -- receive data
      rxd       : out STD_LOGIC_VECTOR(MIIWIDTH-1 downto 0)
      );
  end component;   
  
  ---------------------------------------------------------------------
  -- Interrupt monitor
  ---------------------------------------------------------------------
  component INTMON
    generic (
      MODE      : INTEGER := 0;  -- Comparator mode
      --                         -- 0 - no occurrence
      --                         -- 1 - the COMPFILE writer
      --                         -- 2 - vectors comparator
      
      COMPFILE  : STRING  := "intcomp.txt"; 
      DIFFFILE  : STRING  := "intdiff.txt"; 
      TESTNAME  : STRING  := "default";
      TESTPATH  : STRING  := "tests"
      );
    port(
      clk       : in  STD_LOGIC;
      int       : in  STD_LOGIC;
      rst       : in  STD_LOGIC
      );
  end component;
  
  ---------------------------------------------------------------------
  -- Clock generator
  ---------------------------------------------------------------------
  component CLKGEN
    generic(
      -- clock period
      PERIOD    : TIME := 40 ns
      );
    port(
      -- reset
      rst       : in  STD_LOGIC;
      -- clock enable #1
      en1_n     : in  STD_LOGIC;
      -- clock enable #2
      en2_n     : in  STD_LOGIC;
      -- clock output
      clk       : out STD_LOGIC
      );
  end component;
  
  ---------------------------------------------------------------------
  -- Hardware reset generator
  ---------------------------------------------------------------------
  component RSTGEN
    generic(
      -- AHB reset period (in AHB clock cycles)
      RSTAHB_CYCLES    : INTEGER := 32;
      -- APB reset period (in APB clock cycles)
      RSTAPB_CYCLES    : INTEGER := 32
      );
    port(
      -- AHB clock
      hclk      : in  STD_LOGIC;
      -- APB clock
      pclk      : in  STD_LOGIC;
      -- AHB reset
      hresetn    : out STD_LOGIC;
      -- APB reset
      presetn    : out STD_LOGIC
      );
  end component;
  
  ---------------------------------------------------------------------
  -- external CAM for MAC addresses
  ---------------------------------------------------------------------
  component CAM
    port (
      -- clock
      clk       : in  STD_LOGIC;
      -- match enable
      matchen   : in  STD_LOGIC;
      -- match data
      matchdata : in  STD_LOGIC_VECTOR(47 downto 0);
      -- match output
      match     : out STD_LOGIC;
      -- match valid
      matchval  : out STD_LOGIC
      );
  end component;
  
  --------------------------- test file names -------------------------  
  constant APBSTIMFILE  : STRING := "apbstim.txt";
  constant APBCOMPFILE  : STRING := "apbcomp.txt";
  constant APBDIFFFILE  : STRING := "apbdiff.txt";
  constant MEMSTIMFILE  : STRING := "smemstim.txt";
  constant AHBCOMPFILE  : STRING := "ahbcomp.txt";
  constant AHBDIFFFILE  : STRING := "ahbdiff.txt";
  constant ARBSTIMFILE  : STRING := "arbstim.txt";
  constant LINKCOMPFILE : STRING := "linkcomp.txt";
  constant LINKDIFFFILE : STRING := "linkdiff.txt";
  constant LINKSTIMFILE : STRING := "linkstim.txt";
  constant INTCOMPFILE  : STRING := "intcomp.txt";
  constant INTDIFFFILE  : STRING := "intdiff.txt";
  
  ------------------------------ common -------------------------------
  signal clkdmatb    : STD_LOGIC;
  signal clkt        : STD_LOGIC;
  signal clkr        : STD_LOGIC;
  
  ----------------------------- interrupt -----------------------------
  signal int         : STD_LOGIC;
  signal gbo         : STD_LOGIC;
  
  --------------------------- clock control ---------------------------
  signal rps         : STD_LOGIC;
  signal tps         : STD_LOGIC;
  
  -----------------------------  AMBA AHB -----------------------------
  signal hclk        : STD_LOGIC;
  signal hresetn     : STD_LOGIC;
  signal hrdata      : STD_LOGIC_VECTOR((AHBDATAWIDTH-1) downto 0);
  signal hready      : STD_LOGIC;
  signal hresp       : STD_LOGIC_VECTOR(1 downto 0);
  signal hgrantmac   : STD_LOGIC;
  signal haddr       : STD_LOGIC_VECTOR((AHBADDRESSWIDTH-1) downto 0);
  signal htrans      : STD_LOGIC_VECTOR(1 downto 0);
  signal hwrite      : STD_LOGIC;
  signal hsize       : STD_LOGIC_VECTOR(2 downto 0);
  signal hburst      : STD_LOGIC_VECTOR(2 downto 0);
  signal hprot       : STD_LOGIC_VECTOR(3 downto 0);
  signal hwdata      : STD_LOGIC_VECTOR((AHBDATAWIDTH-1) downto 0);
  signal hbusreqmac  : STD_LOGIC;
  signal hlockmac    : STD_LOGIC;
  signal hselram     : STD_LOGIC;
  signal hmastlock   : STD_LOGIC;
  signal hmaster     : STD_LOGIC_VECTOR(3 downto 0);
  
  -----------------------------  AMBA APB -----------------------------
  signal pclk        : STD_LOGIC;
  signal presetn     : STD_LOGIC;
  signal paddr       : STD_LOGIC_VECTOR(CSRDEPTH-1 downto 0);
  signal pselmaccsr  : STD_LOGIC;
  signal penable     : STD_LOGIC;
  signal pwrite      : STD_LOGIC;
  signal pwdata      : STD_LOGIC_VECTOR(APBDATAWIDTH-1 downto 0);
  signal prdata      : STD_LOGIC_VECTOR(APBDATAWIDTH-1 downto 0);
  
  --------------------------------- MII -------------------------------
  signal rxer        : STD_LOGIC;
  signal rxdv        : STD_LOGIC;
  signal col         : STD_LOGIC;
  signal crs         : STD_LOGIC;
  signal rxd         : STD_LOGIC_VECTOR(MIIWIDTH-1 downto 0);
  signal txer        : STD_LOGIC;
  signal txen        : STD_LOGIC;
  signal txd         : STD_LOGIC_VECTOR(MIIWIDTH-1 downto 0);
  
  ---------------------------- external CAM ---------------------------
  signal match       : STD_LOGIC;
  signal matchval    : STD_LOGIC;
  signal matchen     : STD_LOGIC;
  signal matchdata   : STD_LOGIC_VECTOR(47 downto 0);
  
  --------------------------- MII management --------------------------
  signal mdc         : STD_LOGIC;
  signal mdio        : STD_LOGIC;
  
  --------------------- serial micro-wire interface -------------------
  signal sdi         : STD_LOGIC;
  signal sclk        : STD_LOGIC;
  signal scs         : STD_LOGIC;
  signal sdo         : STD_LOGIC;
  
  ------------------------------ others -------------------------------
  signal low         : STD_LOGIC;
  signal high        : STD_LOGIC;
  signal phyreset    : STD_LOGIC;
  signal hreset      : STD_LOGIC;
  signal preset      : STD_LOGIC;
  signal csrbe_low   : STD_LOGIC_VECTOR(APBDATAWIDTH/8-1 downto 0);
  signal csraddr_low : STD_LOGIC_VECTOR(CSRDEPTH-1 downto 0);
  signal waitstates  : STD_LOGIC_VECTOR(2 downto 0);
  
  
begin
  
  ----------------------------------------
  -- Unit Under Testing : CHIP MAC AMBA --
  ---------------------------------------- 
  UUT: CHIP_MAC_1G_AMBA
  generic map(
    AHBDATAWIDTH     => AHBDATAWIDTH,
    AHBADDRESSWIDTH  => AHBADDRESSWIDTH,
    APBDATAWIDTH     => APBDATAWIDTH,
    TFIFODEPTH       => TFIFODEPTH,
    RFIFODEPTH       => RFIFODEPTH,
    TCDEPTH          => TCDEPTH,
    RCDEPTH          => RCDEPTH)
  port map
    (
    clkt          => clkt,
    clkr          => clkr,
    rps           => rps,
    tps           => tps,
    gbo           => gbo,
    int           => int,
    hclk          => hclk,
    hresetn       => hresetn,
    hrdata        => hrdata,
    hready        => hready,
    hresp         => hresp,
    haddr         => haddr,
    htrans        => htrans,
    hwrite        => hwrite,
    hsize         => hsize,
    hburst        => hburst,
    hprot         => hprot,
    hwdata        => hwdata,
    hgrantmac     => hgrantmac,
    hbusreqmac    => hbusreqmac,
    hlockmac      => hlockmac,
    pclk          => pclk,
    presetn       => presetn,
    paddr         => paddr,
    pselmaccsr    => pselmaccsr,
    penable       => penable,
    pwrite        => pwrite,
    pwdata        => pwdata,
    prdata        => prdata,    
    match         => match,
    matchval      => matchval,
    matchen       => matchen,
    matchdata     => matchdata,
    sdi           => sdi,
    sclk          => sclk,
    scs           => scs,
    sdo           => sdo,
    rxer          => rxer,
    rxdv          => rxdv,
    col           => col,
    crs           => crs,
    rxd           => rxd,
    txen          => txen,
    txer          => txer,
    txd           => txd,
    mdc           => mdc,
    mdio          => mdio
    );
  
  U_SMEMSTIMAHB : SMEMSTIMAHB
  generic map(
    DATAWIDTH        => AHBDATAWIDTH,
    ADDRWIDTH        => AHBADDRESSWIDTH,
    MODE             => AHBMODE,
    STIMFILE         => MEMSTIMFILE,
    COMPFILE         => AHBCOMPFILE,
    DIFFFILE         => AHBDIFFFILE,
    TESTNAME         => TESTNAME,
    TESTPATH         => TESTPATH,
    CLK_PERIOD       => CLKAHB_PERIOD
    )
  port map(           
    hclk             => hclk,
    hresetn          => hresetn,
    hsel             => hselram,
    hwr              => hwrite,
    hmastlock        => hmastlock,
    hmaster          => hmaster,
    htrans           => htrans,
    hsize            => hsize,
    hburst           => hburst,
    hwdata           => hwdata,
    haddr            => haddr,
    hready           => hready,
    hresp            => hresp,
    hrdata           => hrdata
    );  
  
  ----------------------
  -- AMBA ARBITER CMD --
  ----------------------   
  U_AMBAARBCMD : AMBAARBCMD 
  generic map (
    MODE            => ARBMODE,
    STIMFILE        => ARBSTIMFILE,
    TESTNAME        => TESTNAME,
    TESTPATH        => TESTPATH,
    CLK_PERIOD      => CLKAHB_PERIOD 
    )
  port map (
    hclk            => hclk,
    hresetn         => hresetn,
    hbusreqmac      => hbusreqmac,
    hlockmac        => hlockmac,
    hmaster         => hmaster,
    hmastlock       => hmastlock,
    hgrantmac       => hgrantmac,
    hselram         => hselram,
    waitstates      => waitstates
    );
  
  
  ------------------------------
  -- APB interface stimulator --
  ------------------------------ 
  U_APBCMD:APBCMD 
  generic map(
    MODE            => APBMODE,
    APBDATAWIDTH    => APBDATAWIDTH,
    APBADDRESSWIDTH => CSRDEPTH,
    STIMFILE        => APBSTIMFILE,
    COMPFILE        => APBCOMPFILE,
    DIFFFILE        => APBDIFFFILE,
    TESTNAME        => TESTNAME,
    TESTPATH        => TESTPATH,
    CLK_PERIOD      => CLKAPB_PERIOD 
    )
  port map(
    pclk            => pclk,
    presetn         => presetn,
    prdata          => prdata,
    paddr           => paddr,
    pselmaccsr      => pselmaccsr,
    penable         => penable,
    pwrite          => pwrite,
    pwdata          => pwdata  
    );
  
  ---------------------------------------------------------------------
  -- MII monitor
  ---------------------------------------------------------------------
  U_LINKMON : LINKMON
  generic map(
    MODE          => LINKMODE,
    CLK_PERIOD    => CLKMII_PERIOD,
    COMPFILE      => LINKCOMPFILE,
    DIFFFILE      => LINKDIFFFILE,
    STIMFILE      => LINKSTIMFILE,
    TESTNAME      => TESTNAME,
    TESTPATH      => TESTPATH,
    MIIWIDTH      => MIIWIDTH
    )
  port map(
    rst           => phyreset,
    clk           => clkt,
    gb            => gbo,
    rxer          => rxer,
    rxdv          => rxdv,
    col           => col,
    crs           => crs,
    rxd           => rxd,
    txer          => low,
    txen          => txen,
    txd           => txd
    );   
  
  ---------------------------------------------------------------------
  -- Interrupt monitor
  ---------------------------------------------------------------------
  U_INTMON : INTMON
  generic map(
    MODE          => INTMODE,
    COMPFILE      => INTCOMPFILE,
    DIFFFILE      => INTDIFFFILE,
    TESTNAME      => TESTNAME,
    TESTPATH      => TESTPATH
    )
  port map(
    rst           => phyreset,
    clk           => pclk,
    int           => int
    );  
  
  ---------------------------------------------------------------------
  -- APB clock generator
  ---------------------------------------------------------------------
  U_CLKAPB : CLKGEN
  generic map(
    PERIOD        => CLKAPB_PERIOD
    )
  port map(
    rst           => preset,
    en1_n         => low,
    en2_n         => low,
    clk           => pclk
    );
  
  ---------------------------------------------------------------------
  -- AHB clock generator
  ---------------------------------------------------------------------
  U_CLKAHB : CLKGEN
  generic map(
    PERIOD        => CLKAHB_PERIOD
    )
  port map(
    rst           => hreset,
    en1_n         => low,
    en2_n         => low,
    clk           => hclk
    );
  
  ---------------------------------------------------------------------
  -- Transmit clock generator
  ---------------------------------------------------------------------
  U_CLKT : CLKGEN
  generic map(
    PERIOD        => CLKMII_PERIOD
    )
  port map(
    rst           => phyreset,
    en1_n         => low,
    en2_n         => low,
    clk           => clkt
    );
  
  ---------------------------------------------------------------------
  -- Receive clock generator
  ---------------------------------------------------------------------
  U_CLKR : CLKGEN
  generic map(
    PERIOD        => CLKMII_PERIOD
    )
  port map(
    rst           => phyreset,
    en1_n         => low,
    en2_n         => low,
    clk           => clkr
    );
  
  ---------------------------------------------------------------------
  -- Hardware reset generator
  ---------------------------------------------------------------------
  U_RSTGEN : RSTGEN
  generic map(
    RSTAHB_CYCLES    => RSTAHB_CYCLES,
    RSTAPB_CYCLES    => RSTAPB_CYCLES
    )
  port map(
    hclk       => hclk,
    pclk       => pclk,
    hresetn    => hresetn,
    presetn    => presetn
    );
  
  ---------------------------------------------------------------------
  -- external CAM for MAC addresses
  ---------------------------------------------------------------------
  U_CAM : CAM
  port map (
    clk           => clkt,
    matchen       => matchen,
    matchdata     => matchdata,
    match         => match,
    matchval      => matchval
    );
  
  ---------------------------------------------------------------------
  -- AHB active high reset 
  ---------------------------------------------------------------------
  hreset_drv:
  hreset <= not hresetn;  
  
  ---------------------------------------------------------------------
  -- APB active high reset 
  ---------------------------------------------------------------------
  preset_drv:
  preset <= not presetn;  
  
  ---------------------------------------------------------------------
  -- PHY active high reset 
  ---------------------------------------------------------------------
  phyreset_drv:
  phyreset <= not presetn;
  
  ---------------------------------------------------------------------
  -- Low level
  ---------------------------------------------------------------------
  low_drv:
  low <= '0';
  
  ---------------------------------------------------------------------
  -- High level
  ---------------------------------------------------------------------
  high_drv:
  high <= '1';
  
  ---------------------------------------------------------------------
  -- serial eeprom data input
  ---------------------------------------------------------------------
  sdi_drv:
  sdi <= sdo or sclk or scs;
  
end;

configuration TESTBENCH_MAC_1G_AMBA_CONFIGURATION of MAC_1G_AMBA_TB is
  for TESTBENCH
    for UUT : CHIP_MAC_1G_AMBA
      use entity MAC_1G_AMBA_LIB.CHIP_MAC_1G_AMBA(STR);
    end for;
  end for;   
end;
