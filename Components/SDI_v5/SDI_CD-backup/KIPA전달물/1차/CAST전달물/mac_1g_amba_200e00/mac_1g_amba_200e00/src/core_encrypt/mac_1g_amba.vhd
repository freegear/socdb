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
-- File name            : mac_1g_amba.vhd
-- File contents        : Architecture STR of MAC_1G_AMBA
--                        Configuration MAC_1G_AMBA_STRUCTURE
-- Purpose              : Top level structure of MAC_1G_AMBA
--
-- Destination library  : MAC_1G_AMBA_LIB
-- Dependencies         : IEEE.STD_LOGIC.1164
--                      : MAC_1G_LIB.UTILITY_MAC_1G
--                      : MAC_1G_LIB.MAC_1G
--                      : MAC2AMBA_LIB.MAC2AMBA                       
--
-- Design Engineer      : L.C.
-- Quality Engineer     : M.B.
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
use MAC_1G_LIB.MAC_1G;

library MAC2AMBA_LIB;
use MAC2AMBA_LIB.MAC2AMBA;

--*******************************************************************--

entity MAC_1G_AMBA is
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
    
    -- transmit clock
    clkt      : in  STD_LOGIC;
    -- receive clock
    clkr      : in  STD_LOGIC;
    -- transmit reset output
    rsttco    : out STD_LOGIC;
    -- receive reset output
    rstrco    : out STD_LOGIC;
    -- gigabit mode selection output --
    gbo       : out STD_LOGIC;
    
    ---------------------------- interrupt --------------------------
    int       : out STD_LOGIC;
    
    -------------------------- clock control ------------------------
    -- transmit process stopped
    tps       : out STD_LOGIC;
    -- receive process stopped
    rps       : out STD_LOGIC; 
    
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
    paddr       : in  STD_LOGIC_VECTOR(APBADDRESSWIDTH-1 downto 0);
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
    
    
    ---------------- transmit dual port ram interface ---------------
    -- read data
    trdata     : in  STD_LOGIC_VECTOR(AHBDATAWIDTH-1 downto 0);
    -- write enable
    twe        : out STD_LOGIC;
    -- write address
    twaddr     : out STD_LOGIC_VECTOR(TFIFODEPTH-1 downto 0);
    -- read address
    traddr     : out STD_LOGIC_VECTOR(TFIFODEPTH-1 downto 0);
    -- write data
    twdata     : out STD_LOGIC_VECTOR(AHBDATAWIDTH-1 downto 0);
    
    ------------------ receive dual port ram interface --------------
    -- read data
    rrdata     : in  STD_LOGIC_VECTOR(AHBDATAWIDTH-1 downto 0);
    -- write enable
    rwe        : out STD_LOGIC;
    -- write address
    rwaddr     : out STD_LOGIC_VECTOR(RFIFODEPTH-1 downto 0);
    -- read address
    rraddr     : out STD_LOGIC_VECTOR(RFIFODEPTH-1 downto 0);
    -- write data
    rwdata     : out STD_LOGIC_VECTOR(AHBDATAWIDTH-1 downto 0);
    
    ------------------ address filtering ram interface --------------
    -- read data
    frdata     : in  STD_LOGIC_VECTOR(15 downto 0);
    -- write enable
    fwe        : out STD_LOGIC;
    -- write address
    fwaddr     : out STD_LOGIC_VECTOR(ADDRDEPTH-1 downto 0);
    -- read address
    fraddr     : out STD_LOGIC_VECTOR(ADDRDEPTH-1 downto 0);
    -- write data
    fwdata     : out STD_LOGIC_VECTOR(15 downto 0);
    
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
    
    --------------------------- mii interface -----------------------
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
    -- transmit error
    txer       : out STD_LOGIC;
    -- transmit data
    txd        : out STD_LOGIC_VECTOR(MIIWIDTH-1 downto 0);
    -- management clock
    mdc        : out STD_LOGIC;
    -- management data input
    mdi        : in  STD_LOGIC;
    -- management data output
    mdo        : out STD_LOGIC;
    -- management output enable
    mden       : out STD_LOGIC
    );
end;


architecture STR of MAC_1G_AMBA is
  
  component MAC_1G 
    generic (
      -- CSR interface data bus width
      CSRWIDTH   : INTEGER := 32;   -- 8|16|32
      -- Data interface data bus width
      DATAWIDTH  : INTEGER := 32;   -- 8|16|32
      -- Data interface address bus width
      DATADEPTH  : INTEGER := 32;   -- 8-32
      -- Transmit FIFO depth
      TFIFODEPTH : INTEGER := 9;    -- 6-16
      -- Receive FIFO depth
      RFIFODEPTH : INTEGER := 9;    -- 6-16
      -- Transmit frame cache depth
      TCDEPTH    : INTEGER := 1;    -- 1...
      -- Receive frame cache depth
      RCDEPTH    : INTEGER := 2     -- 1...
      );
    port (
      
      ------------------------- clocks / resets -----------------------
      -- dma interface clock
      clkdma    : in  STD_LOGIC;
      -- csr interface clock
      clkcsr    : in  STD_LOGIC;
      -- reset
      rst       : in  STD_LOGIC;
      -- transmit clock
      clkt      : in  STD_LOGIC;
      -- receive clock
      clkr      : in  STD_LOGIC;
      -- gigabit mode selection output
      gbo       : out STD_LOGIC;
      
      ---------------------------- interrupt --------------------------
      int       : out STD_LOGIC;
      
      -------------------------- clock control ------------------------
      -- transmit process stopped
      tps       : out STD_LOGIC;
      -- receive process stopped
      rps       : out STD_LOGIC;
      
      -------------------------- csr interface ------------------------
      -- request
      csrreq    : in  STD_LOGIC;
      -- read/ not write selection
      csrrw     : in  STD_LOGIC;
      -- byte enable
      csrbe     : in  STD_LOGIC_VECTOR(CSRWIDTH/8-1 downto 0);
      -- data input
      csrdatai  : in  STD_LOGIC_VECTOR(CSRWIDTH-1 downto 0);
      -- address
      csraddr   : in  STD_LOGIC_VECTOR(CSRDEPTH-1 downto 0);
      -- acknowledge
      csrack    : out STD_LOGIC;
      -- data output
      csrdatao  : out STD_LOGIC_VECTOR(CSRWIDTH-1 downto 0);
      
      ----------------------- host data interface ---------------------
      -- acknowledge
      dataack    : in  STD_LOGIC;
      -- request
      datareq    : out STD_LOGIC;
      -- request combinatorial
      datareqc   : out STD_LOGIC;
      -- read / not write selection
      datarw     : out STD_LOGIC;
      -- end of burst
      dataeob    : out STD_LOGIC;
      -- end of burst combinatorial
      dataeobc   : out STD_LOGIC;      
      -- data input
      datai      : in  STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
      -- address
      dataaddr   : out STD_LOGIC_VECTOR(DATADEPTH-1 downto 0);
      -- data output
      datao      : out STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
      
      ---------------- transmit dual port ram interface ---------------
      -- read data
      trdata     : in  STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
      -- write enable
      twe        : out STD_LOGIC;
      -- write address
      twaddr     : out STD_LOGIC_VECTOR(TFIFODEPTH-1 downto 0);
      -- read address
      traddr     : out STD_LOGIC_VECTOR(TFIFODEPTH-1 downto 0);
      -- write data
      twdata     : out STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
      
      ------------------ receive dual port ram interface --------------
      -- read data
      rrdata     : in  STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
      -- write enable
      rwe        : out STD_LOGIC;
      -- write address
      rwaddr     : out STD_LOGIC_VECTOR(RFIFODEPTH-1 downto 0);
      -- read address
      rraddr     : out STD_LOGIC_VECTOR(RFIFODEPTH-1 downto 0);
      -- write data
      rwdata     : out STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
      
      ------------------ address filtering ram interface --------------
      -- read data
      frdata     : in  STD_LOGIC_VECTOR(15 downto 0);
      -- write enable
      fwe        : out STD_LOGIC;
      -- write address
      fwaddr     : out STD_LOGIC_VECTOR(ADDRDEPTH-1 downto 0);
      -- read address
      fraddr     : out STD_LOGIC_VECTOR(ADDRDEPTH-1 downto 0);
      -- write data
      fwdata     : out STD_LOGIC_VECTOR(15 downto 0);
      
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
      
      --------------------------- mii interface -----------------------
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
      -- transmit error
      txer       : out STD_LOGIC;
      -- transmit data
      txd        : out STD_LOGIC_VECTOR(MIIWIDTH-1 downto 0);
      -- management clock
      mdc        : out STD_LOGIC;
      -- management data input
      mdi        : in  STD_LOGIC;
      -- management data output
      mdo        : out STD_LOGIC;
      -- management output enable
      mden       : out STD_LOGIC
      );
  end component;
  
  
  ---------------------------------------------------------------------
  -- MAC to AMBA wrapper unit
  ---------------------------------------------------------------------
  
  --*******************************************************************--
  component MAC2AMBA
    
    generic (
      -- AMBA AHB data width --
      AHBDATAWIDTH    : INTEGER := 32;
      -- AMBA AHB address width --
      AHBADDRESSWIDTH : INTEGER := 32;
      
      -- AMBA APB data width --
      APBDATAWIDTH    : INTEGER := 32;
      -- AMBA APB addresss width --
      APBADDRESSWIDTH : INTEGER := 32;
      
      -- MAC DATA data width --
      MACDATAWIDTH    : INTEGER := 32;
      -- MAC DATA address width --
      MACADDRESSWIDTH : INTEGER := 32;
      
      -- MAC CSR data width --
      CSRDATAWIDTH    : INTEGER := 32;
      -- MAC CSR address width --
      CSRADDRESSWIDTH : INTEGER := 32
      );
    
    port (
      ---------------------------------
      --  AMBA AHB master interface  --
      ---------------------------------
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
      
      --  AMBA AHB multiple bus masters support  --
      -- bus grant --
      hgrantmac   : in  STD_LOGIC;
      -- bus request --
      hbusreqmac  : out STD_LOGIC;
      -- locked transfers --
      hlockmac    : out STD_LOGIC;
      
      
      --------------------------
      --  AMBA APB interface  --
      --------------------------
      
      -- interface clock --
      pclk        : in  STD_LOGIC;
      -- bus reset --
      presetn     : in  STD_LOGIC;
      -- bus address --
      paddr       : in  STD_LOGIC_VECTOR(APBADDRESSWIDTH-1 downto 0);
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
      
      
      ------------------------------
      --  MAC 2.0 DATA interface  --
      ------------------------------
      
      -- request --
      datareq     : in  STD_LOGIC;
      -- request --
      datareqc    : in  STD_LOGIC;
      -- read / not write selection --
      datarw      : in  STD_LOGIC;
      -- end of burst --
      dataeob     : in  STD_LOGIC;
      -- end of burst combinatorial --
      dataeobc    : in  STD_LOGIC;
      -- address --
      dataaddr    : in  STD_LOGIC_VECTOR(MACADDRESSWIDTH-1 downto 0);
      -- data output --
      datao       : in  STD_LOGIC_VECTOR(MACDATAWIDTH-1 downto 0);
      -- acknowledge --
      dataack     : out STD_LOGIC;
      -- data input --
      datai       : out STD_LOGIC_VECTOR(MACDATAWIDTH-1 downto 0);
      
      
      -----------------------------
      --  MAC 2.0 CSR interface  --
      -----------------------------
      
      -- acknowledge --
      csrack      : in  STD_LOGIC;
      -- data output --
      csrdatao    : in  STD_LOGIC_VECTOR(CSRDATAWIDTH-1 downto 0);
      -- request --
      csrreq      : out STD_LOGIC;
      -- read/ not write selection --
      csrrw       : out STD_LOGIC;
      -- byte enable --
      csrbe       : out STD_LOGIC_VECTOR(CSRDATAWIDTH/8-1 downto 0);
      -- data input --
      csrdatai    : out STD_LOGIC_VECTOR(CSRDATAWIDTH-1 downto 0);
      -- address --
      csraddr     : out STD_LOGIC_VECTOR(CSRADDRESSWIDTH-1 downto 0)
      );
  end component;      
  
  -- reset signal --
  signal preset     : STD_LOGIC;
  
  -- MAC DATA interface signals --
  signal datareq    : STD_LOGIC;
  signal datarw     : STD_LOGIC;
  signal dataeob    : STD_LOGIC;
  signal dataaddr   : STD_LOGIC_VECTOR((AHBADDRESSWIDTH-1) downto 0);
  signal datao      : STD_LOGIC_VECTOR((AHBDATAWIDTH-1) downto 0);
  signal dataack    : STD_LOGIC;
  signal datai      : STD_LOGIC_VECTOR((AHBDATAWIDTH-1) downto 0); 
  signal datareqc   : STD_LOGIC;
  signal dataeobc   : STD_LOGIC;
  
  -- MAC CSR interface signals --
  signal rstcsr     : STD_LOGIC;
  signal csrack     : STD_LOGIC;
  signal csrdatao   : STD_LOGIC_VECTOR(APBDATAWIDTH-1 downto 0);
  signal csrreq     : STD_LOGIC;
  signal csrrw      : STD_LOGIC;
  signal csrbe      : STD_LOGIC_VECTOR(APBDATAWIDTH/8-1 downto 0);
  signal csrdatai   : STD_LOGIC_VECTOR(APBDATAWIDTH-1 downto 0);
  signal csraddr    : STD_LOGIC_VECTOR(APBADDRESSWIDTH-1 downto 0);
  
begin
  
  ---------------------------------------------------------------------
  -- MAC core
  ---------------------------------------------------------------------
  U_MAC_1G : MAC_1G
  generic map(
    CSRWIDTH      => APBDATAWIDTH,
    DATAWIDTH     => AHBDATAWIDTH,
    DATADEPTH     => AHBADDRESSWIDTH,
    TFIFODEPTH    => TFIFODEPTH,
    RFIFODEPTH    => RFIFODEPTH,
    TCDEPTH       => TCDEPTH,
    RCDEPTH       => RCDEPTH
    )
  port map(
    clkdma        => hclk,
    clkcsr        => pclk,
    rst           => preset,
    clkt          => clkt,
    clkr          => clkr,
    gbo            => gbo,
    int           => int,
    rps           => rps,
    tps           => tps,
    csrreq        => csrreq,
    csrrw         => csrrw,
    csrbe         => csrbe,
    csrdatai      => csrdatai,
    csrack        => csrack,
    csraddr       => csraddr,
    csrdatao      => csrdatao,
    dataack       => dataack,
    datareq       => datareq,
    datareqc      => datareqc,
    datarw        => datarw,
    dataeob       => dataeob,
    dataeobc      => dataeobc,
    datai         => datai,
    dataaddr      => dataaddr,
    datao         => datao,
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
  -- MAC2AMBA core
  ---------------------------------------------------------------------
  
  U_MAC2AMBA : MAC2AMBA
  generic map (
    -- AMBA AHB --
    AHBDATAWIDTH     => AHBDATAWIDTH,
    AHBADDRESSWIDTH  => AHBADDRESSWIDTH,
    -- MAC 2.0 DATA --
    MACDATAWIDTH     => AHBDATAWIDTH,
    MACADDRESSWIDTH  => AHBADDRESSWIDTH,
    -- AMBA APB --
    APBDATAWIDTH     => APBDATAWIDTH,
    APBADDRESSWIDTH  => APBADDRESSWIDTH,
    -- MAC 2.0 CSR --
    CSRDATAWIDTH     => APBDATAWIDTH,
    CSRADDRESSWIDTH  => APBADDRESSWIDTH
    )
  
  port map (
    -- AMBA AHB interface
    hclk        => hclk,
    hresetn     => hresetn,
    hrdata      => hrdata,
    hready      => hready,
    hresp       => hresp,
    haddr       => haddr,
    htrans      => htrans,
    hwrite      => hwrite,
    hsize       => hsize,
    hburst      => hburst,
    hprot       => hprot,
    hwdata      => hwdata,
    hgrantmac   => hgrantmac,
    hbusreqmac  => hbusreqmac,
    hlockmac    => hlockmac,
    
    --  AMBA APB interface  -- 
    pclk        => pclk,
    presetn     => presetn,
    paddr       => paddr,
    pselmaccsr  => pselmaccsr,
    penable     => penable,
    pwrite      => pwrite,
    pwdata      => pwdata,
    prdata      => prdata,
    
    -- MAC 2.0 DATA interface
    datareq     => datareq,
    datarw      => datarw,
    dataeob     => dataeob,
    dataaddr    => dataaddr,
    datao       => datao,
    dataack     => dataack,
    datai       => datai, 
    datareqc    => datareqc,
    dataeobc    => dataeobc,
    
    --  MAC 2.0 CSR interface  --
    csrack      => csrack,
    csrdatao    => csrdatao,
    csrreq      => csrreq,
    csrrw       => csrrw,
    csrbe       => csrbe,
    csrdatai    => csrdatai,
    csraddr     => csraddr
    );            
    
    -- preset driver --
    preset_drv: preset <= not presetn ;
  
end;