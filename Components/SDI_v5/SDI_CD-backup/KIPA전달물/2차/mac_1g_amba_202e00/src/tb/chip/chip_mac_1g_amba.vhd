--*******************************************************************--
-- Copyright (c) 2001-2003  Evatronix SA                                  --
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
-- File name            : chip_mac_1g_amba.vhd
-- File contents        : Architecture STR of CHIP_MAC_1G_AMBA
--
-- Purpose              : Top level structure of CHIP_MAC_1G_AMBA
--
-- Destination library  : MAC_1G_AMBA_LIB
-- Dependencies         : IEEE.STD_LOGIC_1164
--                        MAC_1G_LIB.UTILITY_MAC_1G
--                        
--
-- Design Engineer      : T.K., L.C.
-- Quality Engineer     : M.B.
-- Version              : 2.02.E00
-- Last modification    : 2004-08-16
-----------------------------------------------------------------------

--*******************************************************************--
-- Modifications with respect to Version 2.00.E00:
--*******************************************************************--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library MAC_1G_LIB;
use MAC_1G_LIB.UTILITY_MAC_1G.all;

--*******************************************************************--

entity CHIP_MAC_1G_AMBA is
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
    -- gigabit mode selection outupt
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
    
end CHIP_MAC_1G_AMBA;


--*******************************************************************--


architecture STR of CHIP_MAC_1G_AMBA is
  
  ---------------------------------------------------------------------
  -- Media Access Controller unit
  ---------------------------------------------------------------------
  component MAC_1G_AMBA
    generic (
      -- AMBA AHB interface --
      AHBDATAWIDTH    : INTEGER := 32;
      AHBADDRESSWIDTH : INTEGER := 32;
      -- AMBA APB interface --
      APBDATAWIDTH    : INTEGER := 32;
      APBADDRESSWIDTH : INTEGER := 8;
      -- Transmit FIFO depth
      TFIFODEPTH : INTEGER := 11; 
      -- Receive FIFO depth
      RFIFODEPTH : INTEGER := 13;
      -- Transmit frame cache depth
      TCDEPTH    : INTEGER := 2;
      -- Receive frame cache depth
      RCDEPTH    : INTEGER := 5 
      );
    port (
      
      ------------------------- clocks / resets -----------------------
      clkt      : in  STD_LOGIC;
      clkr      : in  STD_LOGIC;
      rsttco    : out STD_LOGIC;
      rstrco    : out STD_LOGIC;
      gbo       : out STD_LOGIC;
      
      ---------------------------- interrupt --------------------------
      int       : out STD_LOGIC;
      
      -------------------------- clock control ------------------------
      tps       : out STD_LOGIC;
      rps       : out STD_LOGIC;
      
      ----------------------- AMBA AHB interface ----------------------
      hclk        : in  STD_LOGIC;
      hresetn     : in  STD_LOGIC;
      hrdata      : in  STD_LOGIC_VECTOR((AHBDATAWIDTH-1) downto 0);
      hready      : in  STD_LOGIC;
      hresp       : in  STD_LOGIC_VECTOR(1 downto 0);
      haddr       : out STD_LOGIC_VECTOR((AHBADDRESSWIDTH-1) downto 0);
      htrans      : out STD_LOGIC_VECTOR(1 downto 0);
      hwrite      : out STD_LOGIC;
      hsize       : out STD_LOGIC_VECTOR(2 downto 0);
      hburst      : out STD_LOGIC_VECTOR(2 downto 0);
      hprot       : out STD_LOGIC_VECTOR(3 downto 0);
      hwdata      : out STD_LOGIC_VECTOR((AHBDATAWIDTH-1) downto 0);
      hgrantmac   : in  STD_LOGIC;
      hbusreqmac  : out STD_LOGIC;
      hlockmac    : out STD_LOGIC;
      
      -----------------------  AMBA APB interface  ---------------------
      pclk        : in  STD_LOGIC;
      presetn     : in  STD_LOGIC;
      paddr       : in  STD_LOGIC_VECTOR(APBADDRESSWIDTH-1 downto 0);
      pselmaccsr  : in  STD_LOGIC;
      penable     : in  STD_LOGIC;
      pwrite      : in  STD_LOGIC;
      pwdata      : in  STD_LOGIC_VECTOR(APBDATAWIDTH-1 downto 0);
      prdata      : out STD_LOGIC_VECTOR(APBDATAWIDTH-1 downto 0);
      
      
      ---------------- transmit dual port ram interface ---------------
      trdata     : in  STD_LOGIC_VECTOR(AHBDATAWIDTH-1 downto 0);
      twe        : out STD_LOGIC;
      twaddr     : out STD_LOGIC_VECTOR(TFIFODEPTH-1 downto 0);
      traddr     : out STD_LOGIC_VECTOR(TFIFODEPTH-1 downto 0);
      twdata     : out STD_LOGIC_VECTOR(AHBDATAWIDTH-1 downto 0);
      
      ------------------ receive dual port ram interface --------------
      rrdata     : in  STD_LOGIC_VECTOR(AHBDATAWIDTH-1 downto 0);
      rwe        : out STD_LOGIC;
      rwaddr     : out STD_LOGIC_VECTOR(RFIFODEPTH-1 downto 0);
      rraddr     : out STD_LOGIC_VECTOR(RFIFODEPTH-1 downto 0);
      rwdata     : out STD_LOGIC_VECTOR(AHBDATAWIDTH-1 downto 0);
      
      ------------------ address filtering ram interface --------------
      frdata     : in  STD_LOGIC_VECTOR(15 downto 0);
      fwe        : out STD_LOGIC;
      fwaddr     : out STD_LOGIC_VECTOR(ADDRDEPTH-1 downto 0);
      fraddr     : out STD_LOGIC_VECTOR(ADDRDEPTH-1 downto 0);
      fwdata     : out STD_LOGIC_VECTOR(15 downto 0);

      ------------------------ statistical counters -------------------
      -- single receive SC clear
      sscclrr    : out STD_LOGIC;        
      -- single transmit SC clear
      sscclrt    : out STD_LOGIC;        
      -- address for statistical transmit counter
      scadr      : out STD_LOGIC_VECTOR(3 downto 0);
      -- address for statistical receive counter
      scadt      : out STD_LOGIC_VECTOR(4 downto 0);
      -- receive statistical counter read data 
      scdr       : in  STD_LOGIC_VECTOR(31 downto 0);
      -- transmit statistical counter read data 
      scdt       : in  STD_LOGIC_VECTOR(31 downto 0);
      
      ------------- DP RAM receive counters interface -----------------
      -- read ram data for receive counters
      dir        : in  STD_LOGIC_VECTOR(31 downto 0);
      -- write enable for receive counters
      ramwer     : out STD_LOGIC;
      -- ram address for receive counters
      ar         : out STD_LOGIC_VECTOR(3 downto 0);
      -- ram data to be written for receive counters
      dor        : out STD_LOGIC_VECTOR(31 downto 0);

      ------------ DP RAM transmit counters interface -----------------
      -- read ram data for transmit counters
      dit        : in  STD_LOGIC_VECTOR(31 downto 0);
      -- write enable for transmit counters
      ramwet     : out STD_LOGIC;
      -- ram address for transmit counters
      at         : out STD_LOGIC_VECTOR(4 downto 0);
      -- ram data to be written for transmit counters
      dot        : out STD_LOGIC_VECTOR(31 downto 0);
      
      -------------------- external address filtering -----------------
      match      : in  STD_LOGIC;
      matchval   : in  STD_LOGIC;
      matchen    : out STD_LOGIC;
      matchdata  : out STD_LOGIC_VECTOR(47 downto 0);
      
      -------------------- serial micro-wire interface ----------------
      sdi        : in  STD_LOGIC;
      sclk       : out STD_LOGIC;
      scs        : out STD_LOGIC;
      sdo        : out STD_LOGIC;
      
      --------------------------- mii interface -----------------------
      rxer       : in  STD_LOGIC;
      rxdv       : in  STD_LOGIC;
      col        : in  STD_LOGIC;
      crs        : in  STD_LOGIC;
      rxd        : in  STD_LOGIC_VECTOR(MIIWIDTH-1 downto 0);
      txen       : out STD_LOGIC;
      txer       : out STD_LOGIC;
      txd        : out STD_LOGIC_VECTOR(MIIWIDTH-1 downto 0);
      mdc        : out STD_LOGIC;
      mdi        : in  STD_LOGIC;
      mdo        : out STD_LOGIC;
      mden       : out STD_LOGIC
      );
  end component;
  
  ---------------------------------------------------------------------
  -- On-chip dual port RAM
  ---------------------------------------------------------------------
  component DUALRAM
    generic (
      -- address bus width
      DRAMDEPTH : INTEGER := 9;
      -- data bus width
      DRAMWIDTH : INTEGER := 32
      );
    port (
      -- write clock
      clkw      : in  STD_LOGIC;
      -- read clock
      clkr      : in  STD_LOGIC;
      -- write enable
      we        : in  STD_LOGIC;
      -- write data
      wdata     : in  STD_LOGIC_VECTOR(DRAMWIDTH-1 downto 0);
      -- write address
      waddr     : in  STD_LOGIC_VECTOR(DRAMDEPTH-1 downto 0);
      -- read address
      raddr     : in  STD_LOGIC_VECTOR(DRAMDEPTH-1 downto 0);
      -- read data
      rdata     : out STD_LOGIC_VECTOR(DRAMWIDTH-1 downto 0)
      );
  end component;

  ---------------------------------------------------------------------
  -- On-chip dual port RAM for statistical counters
  ---------------------------------------------------------------------
  component SCDRAM
    generic (
      -- address bus width
      DRAMDEPTH : INTEGER := 9;
      -- data bus width
      DRAMWIDTH : INTEGER := 32
    );
    port (
      -- port A clock
      clka      : in  STD_LOGIC;
      -- write enable
      wea       : in  STD_LOGIC;
      -- port A write data
      dina      : in  STD_LOGIC_VECTOR(DRAMWIDTH-1 downto 0);
      -- port A read data
      douta     : out STD_LOGIC_VECTOR(DRAMWIDTH-1 downto 0);
      -- port A address
      addra     : in  STD_LOGIC_VECTOR(DRAMDEPTH-1 downto 0);

      -- port B clock
      clkb      : in  STD_LOGIC;
      -- write enable
      web       : in  STD_LOGIC;
      -- port B write data
      dinb      : in  STD_LOGIC_VECTOR(DRAMWIDTH-1 downto 0);
      -- port B read data
      doutb     : out STD_LOGIC_VECTOR(DRAMWIDTH-1 downto 0);
      -- port B address
      addrb     : in  STD_LOGIC_VECTOR(DRAMDEPTH-1 downto 0)
    );
  end component;
  
  ---------------------------------------------------------------------
  -- Tristate buffer
  ---------------------------------------------------------------------
  component TRIS
    port (
      -- input port
      inp          : in    STD_LOGIC;
      -- output enable
      enable       : in    STD_LOGIC;
      -- output port
      outp         : out   STD_LOGIC;
      -- tristate input / output port
      io           : inout STD_LOGIC
      );
  end component;
  
  
  ------------------------- internal resets ---------------------------
  -- transmit reset
  signal rsttc     : STD_LOGIC;
  -- receive reset
  signal rstrc     : STD_LOGIC;
  
  ---------------- transmit dual port ram interface -------------------
  -- write data
  signal twdata    : STD_LOGIC_VECTOR(AHBDATAWIDTH-1 downto 0);
  -- read data
  signal trdata    : STD_LOGIC_VECTOR(AHBDATAWIDTH-1 downto 0);
  -- write enable
  signal twe       : STD_LOGIC;
  -- write address
  signal twaddr    : STD_LOGIC_VECTOR(TFIFODEPTH-1 downto 0);
  -- read address
  signal traddr    : STD_LOGIC_VECTOR(TFIFODEPTH-1 downto 0);
  
  ----------------- receive dual port ram interface -------------------
  -- write data
  signal rwdata    : STD_LOGIC_VECTOR(AHBDATAWIDTH-1 downto 0);
  -- read data
  signal rrdata    : STD_LOGIC_VECTOR(AHBDATAWIDTH-1 downto 0);
  -- write enable
  signal rwe       : STD_LOGIC;
  -- write address
  signal rwaddr    : STD_LOGIC_VECTOR(RFIFODEPTH-1 downto 0);
  -- read address
  signal rraddr    : STD_LOGIC_VECTOR(RFIFODEPTH-1 downto 0);
  
  ------------------- address filtering ram interface -----------------
  -- read data
  signal frdata    : STD_LOGIC_VECTOR(15 downto 0);
  -- write enable
  signal fwe       : STD_LOGIC;
  -- write address
  signal fwaddr    : STD_LOGIC_VECTOR(ADDRDEPTH-1 downto 0);
  -- read address
  signal fraddr    : STD_LOGIC_VECTOR(ADDRDEPTH-1 downto 0);
  -- write data
  signal fwdata    : STD_LOGIC_VECTOR(15 downto 0);

  --------------- DP RAM receive counters -------------------
  -- read ram data for receive counters
  signal dir       : STD_LOGIC_VECTOR(31 downto 0);
  -- write enable for receive counters
  signal ramwer    : STD_LOGIC;
  -- ram address for receive counters
  signal ar        : STD_LOGIC_VECTOR(3 downto 0);
  -- ram data to be written for receive counters
  signal dor       : STD_LOGIC_VECTOR(31 downto 0);

  --------------- DP RAM transmit counters ------------------
  -- read ram data for transmit counters
  signal dit       : STD_LOGIC_VECTOR(31 downto 0);
  -- write enable for transmit counters
  signal ramwet    : STD_LOGIC;
  -- ram address for transmit counters
  signal at        : STD_LOGIC_VECTOR(4 downto 0);
  -- ram data to be written for transmit counters
  signal dot       : STD_LOGIC_VECTOR(31 downto 0);

  -- address for statistical transmit counter
  signal scadr     : STD_LOGIC_VECTOR(3 downto 0);
  -- address for statistical receive counter
  signal scadt     : STD_LOGIC_VECTOR(4 downto 0);
  -- receive statistical counter read data
  signal scdr      : STD_LOGIC_VECTOR(31 downto 0);
  -- transmit statistical counter read data 
  signal scdt      : STD_LOGIC_VECTOR(31 downto 0);

  ------------------- single SC clearing ---------------------
  -- single receive SC clear
  signal sscclrr   : STD_LOGIC;
  -- single transmit SC clear
  signal sscclrt   : STD_LOGIC;
  
  --------------------------- mii management --------------------------
  -- mii management data input
  signal mdi       : STD_LOGIC;
  -- mii management data output
  signal mdo       : STD_LOGIC;
  -- mii data output enable
  signal mden      : STD_LOGIC;

    --------------------------- other signals --------------------------
  signal zero      : STD_LOGIC_VECTOR(31 downto 0);
  
  
begin
  
  ---------------------------------------------------------------------
  -- MAC_AMBA core
  ---------------------------------------------------------------------
  U_MAC_1G_AMBA : MAC_1G_AMBA
  generic map(
    AHBDATAWIDTH     => AHBDATAWIDTH,
    AHBADDRESSWIDTH  => AHBADDRESSWIDTH,
    APBDATAWIDTH     => APBDATAWIDTH,
    APBADDRESSWIDTH  => CSRDEPTH,
    TFIFODEPTH       => TFIFODEPTH,
    RFIFODEPTH       => RFIFODEPTH,
    TCDEPTH          => TCDEPTH,
    RCDEPTH          => RCDEPTH
    )
  port map (
    clkt          => clkt,
    clkr          => clkr,
    rsttco        => rsttc,
    rstrco        => rstrc,
    gbo           => gbo,
    int           => int,
    rps           => rps,
    tps           => tps,
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
    trdata        => trdata,
    twe           => twe,
    twaddr        => twaddr,
    traddr        => traddr,
    twdata        => twdata,
    rrdata        => rrdata,
    rwe           => rwe,
    rwaddr        => rwaddr,
    rraddr        => rraddr,
    rwdata        => rwdata,
    frdata        => frdata,
    fwe           => fwe,
    fraddr        => fraddr,
    fwaddr        => fwaddr,
    fwdata        => fwdata,
    sscclrr       => sscclrr,
    sscclrt       => sscclrt,
    scadr         => scadr,
    scadt         => scadt,
    scdr          => scdr,
    scdt          => scdt,
    dir           => dir,
    ramwer        => ramwer,
    ar            => ar,
    dor           => dor,
    dit           => dit,
    ramwet        => ramwet,
    at            => at,
    dot           => dot,
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
    mdi           => mdi,
    mdo           => mdo,
    mden          => mden,
    mdc           => mdc
    );
  
  ---------------------------------------------------------------------
  -- Address filtering RAM
  ---------------------------------------------------------------------
  U_FILTRAM : DUALRAM
  generic map(
    DRAMDEPTH     => ADDRDEPTH,
    DRAMWIDTH     => 16
    )
  port map(
    clkw          => hclk,
    clkr          => clkr,
    we            => fwe,
    wdata         => fwdata,
    waddr         => fwaddr,
    raddr         => fraddr,
    rdata         => frdata
    );
  
  ---------------------------------------------------------------------
  -- Transmit data RAM
  ---------------------------------------------------------------------
  U_TRANSMITRAM : DUALRAM
  generic map(
    DRAMDEPTH      => TFIFODEPTH,
    DRAMWIDTH      => AHBDATAWIDTH
    )
  port map(
    clkw          => hclk,
    clkr          => clkt,
    we            => twe,
    wdata         => twdata,
    waddr         => twaddr,
    raddr         => traddr,
    rdata         => trdata
    );
  
  ---------------------------------------------------------------------
  -- Receive data RAM
  ---------------------------------------------------------------------
  U_RECEIVERAM : DUALRAM
  generic map(
    DRAMDEPTH      => RFIFODEPTH,
    DRAMWIDTH      => AHBDATAWIDTH
    )
  port map(
    clkw          => clkr,
    clkr          => hclk,
    we            => rwe,
    wdata         => rwdata,
    waddr         => rwaddr,
    raddr         => rraddr,
    rdata         => rrdata
    );

  ---------------------------------------------------------------------
  -- DP RAM for storing transmit statistical counters
  ---------------------------------------------------------------------
  U_TSCDRAM : SCDRAM
  generic map(
    DRAMDEPTH     => 5,
    DRAMWIDTH     => 32
    )
  port map(
    -- port A
    clka          => hclk,
    wea           => ramwet,
    dina          => dot,
    douta         => dit,
    addra         => at,
    
    clkb          => pclk,
    web           => sscclrt,
    dinb          => zero,
    addrb         => scadt,
    doutb         => scdt
    );

  ---------------------------------------------------------------------
  -- DP RAM for storing receive statistical counters
  ---------------------------------------------------------------------
  U_RSCDRAM : SCDRAM
  generic map(
    DRAMDEPTH     => 4,
    DRAMWIDTH     => 32
  )
  port map(
    clka          => hclk,
    wea           => ramwer,
    dina          => dor,
    douta         => dir,
    addra         => ar,
   
    clkb          => pclk,
    web           => sscclrr,
    dinb          => zero,
    addrb         => scadr,
    doutb         => scdr
  );
  
  ---------------------------------------------------------------------
  -- MDIO driver
  ---------------------------------------------------------------------
  U_MDIO : TRIS
  port map(
    inp           => mdo,
    enable        => mden,
    outp          => mdi,
    io            => mdio
    );

  zero <= (others => '0');
  
  
end STR;
--*******************************************************************--
