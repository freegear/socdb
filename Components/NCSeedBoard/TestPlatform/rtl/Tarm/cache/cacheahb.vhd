----------------------------------------------------------------------------
--  This file is a part of the LEON VHDL model
--  Copyright (C) 1999  European Space Agency (ESA)
--
--  This library is free software; you can redistribute it and/or
--  modify it under the terms of the GNU Lesser General Public
--  License as published by the Free Software Foundation; either
--  version 2 of the License, or (at your option) any later version.
--
--  See the file COPYING.LGPL for the full details of the license.


-----------------------------------------------------------------------------   
-- Entity:      cacheahb
-- File:        cacheahb.vhd
-- Author:      Injo Hwang - Daewoo Electronics
-- Description: Interface module between I/D cache controllers and AMBA AHB 
------------------------------------------------------------------------------  

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_unsigned."+";
    use ieee.std_logic_arith.all;
    use ieee.std_logic_misc.all;
library work;
    use work.cachepkg.all;

entity cacheahb is
  port (
    clk      : in  std_logic;
    rst      : in  std_logic;
    -- icache interface
    iagrant  : out std_logic;
    iaready  : out std_logic;
    iaresp   : out std_logic_vector ( 1 downto  0);
    iardata  : out std_logic_vector (31 downto  0);
    iabusreq : in  std_logic;
    ialock   : in  std_logic;
    iatrans  : in  std_logic_vector ( 1 downto  0);
    iaaddr   : in  std_logic_vector (31 downto  0);
    iawrite  : in  std_logic;
    iasize   : in  std_logic_vector ( 2 downto  0);
    iaburst  : in  std_logic_vector ( 2 downto  0);
    iaprot   : in  std_logic_vector ( 3 downto  0);
    iawdata  : in  std_logic_vector (31 downto  0);
    -- dcache interface
    dacpreq  : in  std_logic;
    dagrant  : out std_logic;
    daready  : out std_logic;
    daresp   : out std_logic_vector ( 1 downto  0);
    dardata  : out std_logic_vector (31 downto  0);
    dabusreq : in  std_logic;
    dalock   : in  std_logic;
    datrans  : in  std_logic_vector ( 1 downto  0);
    daaddr   : in  std_logic_vector (31 downto  0);
    dawrite  : in  std_logic;
    dasize   : in  std_logic_vector ( 2 downto  0);
    daburst  : in  std_logic_vector ( 2 downto  0);
    daprot   : in  std_logic_vector ( 3 downto  0);
    dawdata  : in  std_logic_vector (31 downto  0);
    -- cachewb interface
    wagrant  : out std_logic;
    waready  : out std_logic;
    wawrite  : in  std_logic;
    waaddr   : in  std_logic_vector (31 downto  0);
    wasize   : in  std_logic_vector ( 1 downto  0);
    wadata   : in  std_logic_vector (31 downto  0);
    -- acache interface
    paddr    : out std_logic_vector (11 downto  0);
    psel     : out std_logic;
    penable  : out std_logic;
    pwrite   : out std_logic;
    pwdata   : out std_logic_vector (31 downto  0);
    prdata   : in  std_logic_vector (31 downto  0);
    -- AHB bus interface
    hgrant   : in  std_logic;
    hready   : in  std_logic;
    hresp    : in  std_logic_vector ( 1 downto  0);
    hrdata   : in  std_logic_vector (31 downto  0);
    hbusreq  : out std_logic;
    hlock    : out std_logic;
    htrans   : out std_logic_vector ( 1 downto  0);
    haddr    : out std_logic_vector (31 downto  0);
    hwrite   : out std_logic;
    hsize    : out std_logic_vector ( 2 downto  0);
    hburst   : out std_logic_vector ( 2 downto  0);
    hprot    : out std_logic_vector ( 3 downto  0);
    hwdata   : out std_logic_vector (31 downto  0)
  );
end cacheahb;

architecture behavioral of cacheahb is

  type busowner is ( idle, addr, data, wbuf );

  signal addrbus_r : busowner;
  signal databus_r : busowner;
  signal preq_r    : std_logic;
  signal psel_r    : std_logic;
  signal penable_r : std_logic;
  signal paddr_r   : std_logic_vector (11 downto  0);
  signal pwrite_r  : std_logic;

  signal addrbus_i : busowner;
  signal hbusreq_i : std_logic;
  signal htrans_i  : std_logic_vector ( 1 downto  0);
  signal hgrant_i  : std_logic;
  signal hready_i  : std_logic;
  signal hresp_i   : std_logic_vector ( 1 downto  0);
  signal hrdata_i  : std_logic_vector (31 downto  0);

begin

  process (addrbus_r, iabusreq, dabusreq, wawrite)
  begin
    hbusreq_i <= (iabusreq or dabusreq or wawrite);
    if (addrbus_r = addr and iabusreq = '1') or
       (addrbus_r = data and dabusreq = '1') then
      addrbus_i <= addrbus_r;
    elsif (dabusreq = '1') then
      addrbus_i <= data;
    elsif (iabusreq = '1') then
      addrbus_i <= addr;
    elsif (wawrite = '1') then
      addrbus_i <= wbuf;
    else
      addrbus_i <= idle;
    end if;
  end process;

  process (addrbus_r, databus_r,
           iatrans, iaaddr, iawrite, iasize, iaburst, iaprot, iawdata,
           datrans, daaddr, dawrite, dasize, daburst, daprot, dawdata,
           waaddr, wasize, wadata)
  begin
    case addrbus_r is
    when addr =>
      htrans_i <= iatrans;
      haddr    <= iaaddr;
      hwrite   <= iawrite;
      hsize    <= iasize;
      hburst   <= iaburst;
      hprot    <= iaprot;
    when data =>
      htrans_i <= datrans;
      haddr    <= daaddr;
      hwrite   <= dawrite;
      hsize    <= dasize;
      hburst   <= daburst;
      hprot    <= daprot;
    when wbuf =>
      htrans_i <= HTRANS_NONSEQ;
      haddr    <= waaddr;
      hwrite   <= '1';
      hsize    <= '0' & wasize;
      hburst   <= HBURST_SINGLE;
      hprot    <= (others => '0');
    when others =>
      htrans_i <= HTRANS_IDLE;
      haddr    <= (others => '0');
      hwrite   <= '0';
      hsize    <= HSIZE_BYTE;
      hburst   <= HBURST_SINGLE;
      hprot    <= (others => '0');
    end case;
    case databus_r is
    when addr   => hwdata <= iawdata;
    when data   => hwdata <= dawdata;
    when wbuf   => hwdata <= wadata;
    when others => hwdata <= (others => '0');
    end case;
  end process;

  iaready <= hready_i;
  iaresp  <= hresp_i;
  iardata <= hrdata_i;
  daready <= hready_i;
  daresp  <= hresp_i;
  dardata <= hrdata_i;

  process (addrbus_r, databus_r, addrbus_i, hgrant_i, hready_i)
  begin
    if (addrbus_i = addr) then
      iagrant <= hgrant_i;
    else
      iagrant <= '0';
    end if;
    if (addrbus_i = data) then
      dagrant <= hgrant_i;
    else
      dagrant <= '0';
    end if;
    if (addrbus_i = wbuf) then
      wagrant <= hgrant_i;
    else
      wagrant <= '0';
    end if;
    if (addrbus_i = wbuf) or (addrbus_r = wbuf) or (databus_r = wbuf) then
      waready <= hready_i;
    else
      waready <= '0';
    end if;
  end process;

  process (psel_r, penable_r, addrbus_i, hbusreq_i, htrans_i,
           ialock, dabusreq, dacpreq, dalock,
           hgrant, hready, hresp, hrdata, prdata)
  begin
    case addrbus_i is
    when addr   => hlock <= ialock;
    when data   => hlock <= dalock;
    when wbuf   => hlock <= '0';
    when others => hlock <= '0';
    end case;
    if (psel_r = '1' and penable_r = '0') then
      hbusreq  <= '0';
      htrans   <= HTRANS_BUSY;
      hgrant_i <= '0';
      hready_i <= '0';
    else
      hbusreq  <= hbusreq_i and not (dabusreq and dacpreq);
      htrans   <= htrans_i;
      hgrant_i <= hgrant or (dabusreq and dacpreq);
      hready_i <= hready;
    end if;
    if (psel_r = '1') then
      hresp_i  <= HRESP_OKAY;
      hrdata_i <= prdata;
    else
      hresp_i  <= hresp;
      hrdata_i <= hrdata;
    end if;
  end process;

  psel     <= psel_r;
  penable  <= penable_r;
  paddr    <= paddr_r;
  pwrite   <= pwrite_r;
  pwdata   <= dawdata;

  process (clk, rst)
  begin
    if (rst = '0') then
      addrbus_r <= idle;
      databus_r <= idle;
      preq_r    <= '0';
      psel_r    <= '0';
      penable_r <= '0';
      paddr_r   <= (others => '0');
      pwrite_r  <= '0';
    elsif rising_edge(clk) then
      if (hready_i = '1') then
        if (hgrant_i = '1') then
          addrbus_r <= addrbus_i;
        else
          addrbus_r <= idle;
        end if;
        databus_r <= addrbus_r;
        preq_r    <= dabusreq and dacpreq;
      end if;
      if (psel_r = '1' and penable_r = '0') then
        penable_r <= '1';
      elsif (hready_i = '1') then
        if (preq_r = '1' and datrans(1) = '1') then
          psel_r    <= '1';
          penable_r <= '0';
          paddr_r   <= daaddr(11 downto 0);
          pwrite_r  <= dawrite;
        else
          psel_r    <= '0';
          penable_r <= '0';
          paddr_r   <= (others => '0');
          pwrite_r  <= '0';
        end if;
      end if;
    end if;
  end process;

end behavioral;

configuration cfg_cacheahb of cacheahb is
  for behavioral
  end for;
end cfg_cacheahb;
