--*******************************************************************--
-- Copyright (c) 2001-2004  Evatronix SA                             --
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
-- File name            : mac2amba.vhd
-- File contents        : Entity MAC2AMBA
--                        Architecture STR of MAC2AHB
--
-- Purpose              : MAC to AHB wrapper
--
-- Destination library  : MAC2AHB_LIB
-- Dependencies         : MAC2AHB_LIB.MAC2AHB_PACKAGE
--                        IEEE.STD_LOGIC_1164
--
--
-- Design Engineer      : L.C.
-- Quality Engineer     : M.B.
-- Version              : 2.02.E00
-- Last modification    : 2004-08-16
-----------------------------------------------------------------------

--*******************************************************************--
-- Modifications with respect to Version 2.00.E00:
--*******************************************************************--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library MAC2AMBA_LIB;
use MAC2AMBA_LIB.MAC2AMBA_PACKAGE.all;


--*******************************************************************--
entity MAC2AMBA is
  
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
  
end;

--*******************************************************************--

architecture STR of MAC2AMBA is
  
  -- MAC data to AHB wrapper --
  component MACDATA2AHB
    generic (
      AHBDATAWIDTH    : INTEGER := 32;
      AHBADDRESSWIDTH : INTEGER := 32;
      MACDATAWIDTH     : INTEGER := 32;
      MACADDRESSWIDTH  : INTEGER := 32
      );
    port (
      -- AHB interface --
      hclk        : in  STD_LOGIC;
      hresetn     : in  STD_LOGIC;
      hrdata      : in  STD_LOGIC_VECTOR(AHBDATAWIDTH-1 downto 0);
      hready      : in  STD_LOGIC;
      hresp       : in  STD_LOGIC_VECTOR(1 downto 0);
      haddr       : out STD_LOGIC_VECTOR(AHBADDRESSWIDTH-1 downto 0);
      htrans      : out STD_LOGIC_VECTOR(1 downto 0);
      hwrite      : out STD_LOGIC;
      hsize       : out STD_LOGIC_VECTOR(2 downto 0);
      hburst      : out STD_LOGIC_VECTOR(2 downto 0);
      hprot       : out STD_LOGIC_VECTOR(3 downto 0);
      hwdata      : out STD_LOGIC_VECTOR(AHBDATAWIDTH-1 downto 0);
      hgrantmac   : in  STD_LOGIC;
      hbusreqmac  : out STD_LOGIC;
      hlockmac    : out STD_LOGIC;
      -- MAC 2.0 DATA interface --
      datareq     : in  STD_LOGIC;
      datareqc    : in  STD_LOGIC;
      datarw      : in  STD_LOGIC;
      dataeob     : in  STD_LOGIC;
      dataeobc    : in  STD_LOGIC;
      dataaddr    : in  STD_LOGIC_VECTOR(MACADDRESSWIDTH-1 downto 0);
      datao       : in  STD_LOGIC_VECTOR(MACDATAWIDTH-1 downto 0);
      dataack     : out STD_LOGIC;
      datai       : out STD_LOGIC_VECTOR(MACDATAWIDTH-1 downto 0)
      );
  end component;
  
  component MACCSR2APB 
    generic (
      APBDATAWIDTH    : INTEGER := 32;
      APBADDRESSWIDTH : INTEGER := 8;
      CSRDATAWIDTH    : INTEGER := 32;
      CSRADDRESSWIDTH : INTEGER := 8
      );
    
    port (
      --------------------------
      --  AMBA APB interface  --
      --------------------------
      pclk        : in  STD_LOGIC;
      presetn     : in  STD_LOGIC;
      paddr       : in  STD_LOGIC_VECTOR(APBADDRESSWIDTH-1 downto 0);
      pselmaccsr  : in  STD_LOGIC;
      penable     : in  STD_LOGIC;
      pwrite      : in  STD_LOGIC;
      pwdata      : in  STD_LOGIC_VECTOR(APBDATAWIDTH-1 downto 0);
      prdata      : out  STD_LOGIC_VECTOR(APBDATAWIDTH-1 downto 0);
      
      -----------------------------
      --  MAC 2.0 CSR interface  --
      -----------------------------
      csrack      : in  STD_LOGIC;
      csrdatao    : in  STD_LOGIC_VECTOR(CSRDATAWIDTH-1 downto 0);
      csrreq      : out STD_LOGIC;
      csrrw       : out STD_LOGIC;
      csrbe       : out STD_LOGIC_VECTOR(CSRDATAWIDTH/8-1 downto 0);
      csrdatai    : out STD_LOGIC_VECTOR(CSRDATAWIDTH-1 downto 0);
      csraddr     : out STD_LOGIC_VECTOR(CSRADDRESSWIDTH-1 downto 0)
      ); 
  end component;
  
begin
  
  ----------------------------------
  -- MAC data to AMBA AHB wrapper --
  ----------------------------------
  
  U_MACDATA2AHB: MACDATA2AHB
  generic map (
    AHBDATAWIDTH      => AHBDATAWIDTH,
    AHBADDRESSWIDTH   => AHBADDRESSWIDTH,
    MACDATAWIDTH      => MACDATAWIDTH,
    MACADDRESSWIDTH   => MACADDRESSWIDTH
    )
  port map (
    -- AHB interface --
    hclk              => hclk,
    hresetn           => hresetn,
    hrdata            => hrdata,
    hready            => hready,
    hresp             => hresp,
    haddr             => haddr,
    htrans            => htrans,
    hwrite            => hwrite,
    hsize             => hsize,
    hburst            => hburst,
    hprot             => hprot,
    hwdata            => hwdata,
    hgrantmac         => hgrantmac,
    hbusreqmac        => hbusreqmac,
    hlockmac          => hlockmac,
    -- MAC 2.0 DATA interface --
    datareq          => datareq,  
    datareqc         => datareqc,
    datarw           => datarw,
    dataeob          => dataeob,
    dataeobc         => dataeobc,
    dataaddr         => dataaddr,
    datao            => datao,
    dataack          => dataack,
    datai            => datai
    );
  
  ---------------------------------
  -- MAC CSR to AMBA APB wrapper --
  ---------------------------------
  
  U_MACCSR2APB:MACCSR2APB
  generic map (
    APBDATAWIDTH    => APBDATAWIDTH,
    APBADDRESSWIDTH => APBADDRESSWIDTH,
    CSRDATAWIDTH    => CSRDATAWIDTH,
    CSRADDRESSWIDTH => CSRADDRESSWIDTH
    )
  port map (
    --  AMBA APB interface  --
    pclk        => pclk,
    presetn     => presetn,
    paddr       => paddr,
    pselmaccsr  => pselmaccsr,
    penable     => penable,
    pwrite      => pwrite,
    pwdata      => pwdata,
    prdata      => prdata,
    --  MAC 2.0 CSR interface  --
    csrack      => csrack,
    csrdatao    => csrdatao,
    csrreq      => csrreq,
    csrrw       => csrrw,
    csrbe       => csrbe,
    csrdatai    => csrdatai,
    csraddr     => csraddr
    );

  
end;