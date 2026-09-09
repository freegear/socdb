----------------------------------------------------------------------------
--  This file is a part of the ToyARM cache model
--  Copyright (C) 2003  Injoh
--
--  This library is free software; you can redistribute it and/or
--  modify it under the terms of the GNU Lesser General Public
--  License as published by the Free Software Foundation; either
--  version 2 of the License, or (at your option) any later version.
--
--  See the file COPYING.LGPL for the full details of the license.


-----------------------------------------------------------------------------   
-- Entity:      cachewb
-- File:        cachewb.vhd
-- Author:      Injo Hwang - Daewoo Electronics
-- Description: This unit implements the write buffer of data cache
------------------------------------------------------------------------------  

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_arith.all;
    use ieee.std_logic_misc.all;
    use ieee.std_logic_unsigned.all;
library work;
    use work.cachepkg.all;

entity cachewb is
  port (
    clk      : in  std_logic;
    rst      : in  std_logic;
    -- dcache interface
    dwwrite  : in  std_logic;
    dwaddr   : in  std_logic_vector (31 downto  0);
    dwsize   : in  std_logic_vector ( 1 downto  0);
    dwdata   : in  std_logic_vector (31 downto  0);
    dwcount  : out std_logic_vector ( 3 downto  0);
    -- cachectl interface
    paddr    : in  std_logic_vector (11 downto  0);
    psel     : in  std_logic;
    penable  : in  std_logic;
    pwrite   : in  std_logic;
    pwdata   : in  std_logic_vector (31 downto  0);
    -- acache interface
    wagrant  : in  std_logic;
    waready  : in  std_logic;
    wawrite  : out std_logic;
    waaddr   : out std_logic_vector (31 downto  0);
    wasize   : out std_logic_vector ( 1 downto  0);
    wadata   : out std_logic_vector (31 downto  0);
    hgrant   : in  std_logic;
    hready   : in  std_logic;
    haddr    : in  std_logic_vector (31 downto  0);
    hrdata   : in  std_logic_vector (31 downto  0);
    hwdata   : out std_logic_vector (31 downto  0)
  );
end cachewb;

architecture behavioral of cachewb is

  signal hgrant_r   : std_logic;
  signal haddr_r    : std_logic_vector (31 downto  0);

  -- write buffer register
  signal drain_r    : std_logic;
  signal count_r    : std_logic_vector ( 3 downto  0);
  signal iaddr_r    : std_logic_vector ( 0 downto  0);
  signal ibreq_r    : std_logic_vector ( 1 downto  0);
  signal grant_r    : std_logic;
  signal ready_r    : std_logic;

  signal valid0_r   : std_logic;
  signal addr0_r    : std_logic_vector (31 downto  0);
  signal size0_r    : std_logic_vector ( 1 downto  0);
  signal data0_r    : std_logic_vector (31 downto  0);
  signal valid1_r   : std_logic;
  signal addr1_r    : std_logic_vector (31 downto  0);
  signal size1_r    : std_logic_vector ( 1 downto  0);
  signal data1_r    : std_logic_vector (31 downto  0);
  signal valid2_r   : std_logic;
  signal addr2_r    : std_logic_vector (31 downto  0);
  signal size2_r    : std_logic_vector ( 1 downto  0);
  signal data2_r    : std_logic_vector (31 downto  0);
  signal valid3_r   : std_logic;
  signal addr3_r    : std_logic_vector (31 downto  0);
  signal size3_r    : std_logic_vector ( 1 downto  0);
  signal data3_r    : std_logic_vector (31 downto  0);
  signal valid4_r   : std_logic;
  signal addr4_r    : std_logic_vector (31 downto  0);
  signal size4_r    : std_logic_vector ( 1 downto  0);
  signal data4_r    : std_logic_vector (31 downto  0);
  signal valid5_r   : std_logic;
  signal addr5_r    : std_logic_vector (31 downto  0);
  signal size5_r    : std_logic_vector ( 1 downto  0);
  signal data5_r    : std_logic_vector (31 downto  0);
  signal valid6_r   : std_logic;
  signal addr6_r    : std_logic_vector (31 downto  0);
  signal size6_r    : std_logic_vector ( 1 downto  0);
  signal data6_r    : std_logic_vector (31 downto  0);
  signal valid7_r   : std_logic;
  signal addr7_r    : std_logic_vector (31 downto  0);
  signal size7_r    : std_logic_vector ( 1 downto  0);
  signal data7_r    : std_logic_vector (31 downto  0);

  -- compare write buffer
  signal wblane0_i  : std_logic_vector ( 3 downto  0);
  signal wblane1_i  : std_logic_vector ( 3 downto  0);
  signal wblane2_i  : std_logic_vector ( 3 downto  0);
  signal wblane3_i  : std_logic_vector ( 3 downto  0);
  signal wblane4_i  : std_logic_vector ( 3 downto  0);
  signal wblane5_i  : std_logic_vector ( 3 downto  0);
  signal wblane6_i  : std_logic_vector ( 3 downto  0);
  signal wblane7_i  : std_logic_vector ( 3 downto  0);
  signal acvalid0_i : std_logic;
  signal acvalid1_i : std_logic;
  signal acvalid2_i : std_logic;
  signal acvalid3_i : std_logic;
  signal acvalid4_i : std_logic;
  signal acvalid5_i : std_logic;
  signal acvalid6_i : std_logic;
  signal acvalid7_i : std_logic;

begin

  process (addr0_r, size0_r, addr1_r, size1_r,
           addr2_r, size2_r, addr3_r, size3_r,
           addr4_r, size4_r, addr5_r, size5_r,
           addr6_r, size6_r, addr7_r, size7_r)
  begin
    wblane0_i <= lanemask(addr0_r, size0_r);
    wblane1_i <= lanemask(addr1_r, size1_r);
    wblane2_i <= lanemask(addr2_r, size2_r);
    wblane3_i <= lanemask(addr3_r, size3_r);
    wblane4_i <= lanemask(addr4_r, size4_r);
    wblane5_i <= lanemask(addr5_r, size5_r);
    wblane6_i <= lanemask(addr6_r, size6_r);
    wblane7_i <= lanemask(addr7_r, size7_r);
  end process;

  process (haddr_r,
           valid0_r, addr0_r, valid1_r, addr1_r,
           valid2_r, addr2_r, valid3_r, addr3_r,
           valid4_r, addr4_r, valid5_r, addr5_r,
           valid6_r, addr6_r, valid7_r, addr7_r)
  begin
    if (addr0_r(31 downto 2) = haddr_r(31 downto 2)) then
      acvalid0_i <= valid0_r;
    else
      acvalid0_i <= '0';
    end if;
    if (addr1_r(31 downto 2) = haddr_r(31 downto 2)) then
      acvalid1_i <= valid1_r;
    else
      acvalid1_i <= '0';
    end if;
    if (addr2_r(31 downto 2) = haddr_r(31 downto 2)) then
      acvalid2_i <= valid2_r;
    else
      acvalid2_i <= '0';
    end if;
    if (addr3_r(31 downto 2) = haddr_r(31 downto 2)) then
      acvalid3_i <= valid3_r;
    else
      acvalid3_i <= '0';
    end if;
    if (addr4_r(31 downto 2) = haddr_r(31 downto 2)) then
      acvalid4_i <= valid4_r;
    else
      acvalid4_i <= '0';
    end if;
    if (addr5_r(31 downto 2) = haddr_r(31 downto 2)) then
      acvalid5_i <= valid5_r;
    else
      acvalid5_i <= '0';
    end if;
    if (addr6_r(31 downto 2) = haddr_r(31 downto 2)) then
      acvalid6_i <= valid6_r;
    else
      acvalid6_i <= '0';
    end if;
    if (addr7_r(31 downto 2) = haddr_r(31 downto 2)) then
      acvalid7_i <= valid7_r;
    else
      acvalid7_i <= '0';
    end if;
  end process;

  process (wblane0_i, acvalid0_i, data0_r, wblane1_i, acvalid1_i, data1_r,
           wblane2_i, acvalid2_i, data2_r, wblane3_i, acvalid3_i, data3_r,
           wblane4_i, acvalid4_i, data4_r, wblane5_i, acvalid5_i, data5_r,
           wblane6_i, acvalid6_i, data6_r, wblane7_i, acvalid7_i, data7_r,
           hrdata)
  begin
    if    ((acvalid7_i and wblane7_i(0)) = '1') then
      hwdata(7 downto 0) <= data7_r(7 downto 0);
    elsif ((acvalid6_i and wblane6_i(0)) = '1') then
      hwdata(7 downto 0) <= data6_r(7 downto 0);
    elsif ((acvalid5_i and wblane5_i(0)) = '1') then
      hwdata(7 downto 0) <= data5_r(7 downto 0);
    elsif ((acvalid4_i and wblane4_i(0)) = '1') then
      hwdata(7 downto 0) <= data4_r(7 downto 0);
    elsif ((acvalid3_i and wblane3_i(0)) = '1') then
      hwdata(7 downto 0) <= data3_r(7 downto 0);
    elsif ((acvalid2_i and wblane2_i(0)) = '1') then
      hwdata(7 downto 0) <= data2_r(7 downto 0);
    elsif ((acvalid1_i and wblane1_i(0)) = '1') then
      hwdata(7 downto 0) <= data1_r(7 downto 0);
    elsif ((acvalid0_i and wblane0_i(0)) = '1') then
      hwdata(7 downto 0) <= data0_r(7 downto 0);
    else
      hwdata(7 downto 0) <= hrdata(7 downto 0);
    end if;
    if    ((acvalid7_i and wblane7_i(1)) = '1') then
      hwdata(15 downto 8) <= data7_r(15 downto 8);
    elsif ((acvalid6_i and wblane6_i(1)) = '1') then
      hwdata(15 downto 8) <= data6_r(15 downto 8);
    elsif ((acvalid5_i and wblane5_i(1)) = '1') then
      hwdata(15 downto 8) <= data5_r(15 downto 8);
    elsif ((acvalid4_i and wblane4_i(1)) = '1') then
      hwdata(15 downto 8) <= data4_r(15 downto 8);
    elsif ((acvalid3_i and wblane3_i(1)) = '1') then
      hwdata(15 downto 8) <= data3_r(15 downto 8);
    elsif ((acvalid2_i and wblane2_i(1)) = '1') then
      hwdata(15 downto 8) <= data2_r(15 downto 8);
    elsif ((acvalid1_i and wblane1_i(1)) = '1') then
      hwdata(15 downto 8) <= data1_r(15 downto 8);
    elsif ((acvalid0_i and wblane0_i(1)) = '1') then
      hwdata(15 downto 8) <= data0_r(15 downto 8);
    else
      hwdata(15 downto 8) <= hrdata(15 downto 8);
    end if;
    if    ((acvalid7_i and wblane7_i(2)) = '1') then
      hwdata(23 downto 16) <= data7_r(23 downto 16);
    elsif ((acvalid6_i and wblane6_i(2)) = '1') then
      hwdata(23 downto 16) <= data6_r(23 downto 16);
    elsif ((acvalid5_i and wblane5_i(2)) = '1') then
      hwdata(23 downto 16) <= data5_r(23 downto 16);
    elsif ((acvalid4_i and wblane4_i(2)) = '1') then
      hwdata(23 downto 16) <= data4_r(23 downto 16);
    elsif ((acvalid3_i and wblane3_i(2)) = '1') then
      hwdata(23 downto 16) <= data3_r(23 downto 16);
    elsif ((acvalid2_i and wblane2_i(2)) = '1') then
      hwdata(23 downto 16) <= data2_r(23 downto 16);
    elsif ((acvalid1_i and wblane1_i(2)) = '1') then
      hwdata(23 downto 16) <= data1_r(23 downto 16);
    elsif ((acvalid0_i and wblane0_i(2)) = '1') then
      hwdata(23 downto 16) <= data0_r(23 downto 16);
    else
      hwdata(23 downto 16) <= hrdata(23 downto 16);
    end if;
    if ((acvalid7_i and wblane7_i(3)) = '1') then
      hwdata(31 downto 24) <= data7_r(31 downto 24);
    elsif ((acvalid6_i and wblane6_i(3)) = '1') then
      hwdata(31 downto 24) <= data6_r(31 downto 24);
    elsif ((acvalid5_i and wblane5_i(3)) = '1') then
      hwdata(31 downto 24) <= data5_r(31 downto 24);
    elsif ((acvalid4_i and wblane4_i(3)) = '1') then
      hwdata(31 downto 24) <= data4_r(31 downto 24);
    elsif ((acvalid3_i and wblane3_i(3)) = '1') then
      hwdata(31 downto 24) <= data3_r(31 downto 24);
    elsif ((acvalid2_i and wblane2_i(3)) = '1') then
      hwdata(31 downto 24) <= data2_r(31 downto 24);
    elsif ((acvalid1_i and wblane1_i(3)) = '1') then
      hwdata(31 downto 24) <= data1_r(31 downto 24);
    elsif ((acvalid0_i and wblane0_i(3)) = '1') then
      hwdata(31 downto 24) <= data0_r(31 downto 24);
    else
      hwdata(31 downto 24) <= hrdata(31 downto 24);
    end if;
  end process;

  process (drain_r, count_r, ibreq_r, iaddr_r,
           valid0_r, addr0_r, size0_r, data0_r,
           valid1_r, addr1_r, size1_r, valid2_r)
  begin
    if (drain_r = '1') then
      dwcount <= "1000";
    else
      dwcount <= count_r;
    end if;
    if (ibreq_r = "00") then
      wawrite <= valid0_r;
    elsif (ibreq_r = "01") then
      wawrite <= valid1_r;
    else
      wawrite <= valid2_r;
    end if;
    if (iaddr_r = "0") then
      waaddr  <= addr0_r;
      wasize  <= size0_r;
    else
      waaddr  <= addr1_r;
      wasize  <= size1_r;
    end if;
    wadata <= data0_r;
  end process;

  process (clk, rst)
  begin
    if (rst = '0') then
      hgrant_r <= '0';
      haddr_r  <= (others => '0');
      drain_r  <= '0';
      count_r  <= "0000";
      iaddr_r  <= "0";
      ibreq_r  <= "00";
      grant_r  <= '0';
      ready_r  <= '0';
      valid0_r <= '0';
      addr0_r  <= (others => '0');
      size0_r  <= (others => '0');
      data0_r  <= (others => '0');
      valid1_r <= '0';
      addr1_r  <= (others => '0');
      size1_r  <= (others => '0');
      data1_r  <= (others => '0');
      valid2_r <= '0';
      addr2_r  <= (others => '0');
      size2_r  <= (others => '0');
      data2_r  <= (others => '0');
      valid3_r <= '0';
      addr3_r  <= (others => '0');
      size3_r  <= (others => '0');
      data3_r  <= (others => '0');
      valid4_r <= '0';
      addr4_r  <= (others => '0');
      size4_r  <= (others => '0');
      data4_r  <= (others => '0');
      valid5_r <= '0';
      addr5_r  <= (others => '0');
      size5_r  <= (others => '0');
      data5_r  <= (others => '0');
      valid6_r <= '0';
      addr6_r  <= (others => '0');
      size6_r  <= (others => '0');
      data6_r  <= (others => '0');
      valid7_r <= '0';
      addr7_r  <= (others => '0');
      size7_r  <= (others => '0');
      data7_r  <= (others => '0');
    elsif rising_edge(clk) then
      if (hready = '1') then
        hgrant_r <= hgrant;
        if (hgrant_r = '1') then
          haddr_r <= haddr;
        end if;
      end if;
      if (count_r = "0000") then
        drain_r <= '0';
      elsif ((psel and penable and pwrite) = '1') and (paddr = x"740") then
        drain_r <= '1';
      end if;
      if (dwwrite = '1') and (ready_r = '0' or waready = '0') then
        count_r <= count_r + '1';
      elsif (dwwrite = '0') and (ready_r = '1' and waready = '1') then
        count_r <= count_r - '1';
      end if;
      if (waready = '1') then
        if (wagrant = '0') and (ready_r = '1') then
          ibreq_r <= ibreq_r - '1';
        elsif (wagrant = '1') and (ready_r = '0') then
          ibreq_r <= ibreq_r + '1';
        end if;
      end if;
      if (waready = '1') then
        if (grant_r = '0') and (ready_r = '1') then
          iaddr_r <= "0";
        elsif (grant_r = '1') and (ready_r = '0') then
          iaddr_r <= "1";
        end if;
      end if;
      if (waready = '1') then
        grant_r <= wagrant;
        ready_r <= grant_r;
      end if;
      if ((count_r=x"1") and ((dwwrite and ready_r and waready)='1')) or
         ((count_r=x"0") and ((dwwrite and not(ready_r and waready))='1')) then
        valid0_r <= '1';
        addr0_r  <= dwaddr;
        size0_r  <= dwsize;
        data0_r  <= dwdata;
      elsif (ready_r = '1' and waready = '1') then
        valid0_r <= valid1_r;
        addr0_r  <= addr1_r;
        size0_r  <= size1_r;
        data0_r  <= data1_r;
      end if;
      if ((count_r=x"2") and ((dwwrite and ready_r and waready)='1')) or
         ((count_r=x"1") and ((dwwrite and not(ready_r and waready))='1')) then
        valid1_r <= '1';
        addr1_r  <= dwaddr;
        size1_r  <= dwsize;
        data1_r  <= dwdata;
      elsif (ready_r = '1' and waready = '1') then
        valid1_r <= valid2_r;
        addr1_r  <= addr2_r;
        size1_r  <= size2_r;
        data1_r  <= data2_r;
      end if;
      if ((count_r=x"3") and ((dwwrite and ready_r and waready)='1')) or
         ((count_r=x"2") and ((dwwrite and not(ready_r and waready))='1')) then
        valid2_r <= '1';
        addr2_r  <= dwaddr;
        size2_r  <= dwsize;
        data2_r  <= dwdata;
      elsif (ready_r = '1' and waready = '1') then
        valid2_r <= valid3_r;
        addr2_r  <= addr3_r;
        size2_r  <= size3_r;
        data2_r  <= data3_r;
      end if;
      if ((count_r=x"4") and ((dwwrite and ready_r and waready)='1')) or
         ((count_r=x"3") and ((dwwrite and not(ready_r and waready))='1')) then
        valid3_r <= '1';
        addr3_r  <= dwaddr;
        size3_r  <= dwsize;
        data3_r  <= dwdata;
      elsif (ready_r = '1' and waready = '1') then
        valid3_r <= valid4_r;
        addr3_r  <= addr4_r;
        size3_r  <= size4_r;
        data3_r  <= data4_r;
      end if;
      if ((count_r=x"5") and ((dwwrite and ready_r and waready)='1')) or
         ((count_r=x"4") and ((dwwrite and not(ready_r and waready))='1')) then
        valid4_r <= '1';
        addr4_r  <= dwaddr;
        size4_r  <= dwsize;
        data4_r  <= dwdata;
      elsif (ready_r = '1' and waready = '1') then
        valid4_r <= valid5_r;
        addr4_r  <= addr5_r;
        size4_r  <= size5_r;
        data4_r  <= data5_r;
      end if;
      if ((count_r=x"6") and ((dwwrite and ready_r and waready)='1')) or
         ((count_r=x"5") and ((dwwrite and not(ready_r and waready))='1')) then
        valid5_r <= '1';
        addr5_r  <= dwaddr;
        size5_r  <= dwsize;
        data5_r  <= dwdata;
      elsif (ready_r = '1' and waready = '1') then
        valid5_r <= valid6_r;
        addr5_r  <= addr6_r;
        size5_r  <= size6_r;
        data5_r  <= data6_r;
      end if;
      if ((count_r=x"7") and ((dwwrite and ready_r and waready)='1')) or
         ((count_r=x"6") and ((dwwrite and not(ready_r and waready))='1')) then
        valid6_r <= '1';
        addr6_r  <= dwaddr;
        size6_r  <= dwsize;
        data6_r  <= dwdata;
      elsif (ready_r = '1' and waready = '1') then
        valid6_r <= valid7_r;
        addr6_r  <= addr7_r;
        size6_r  <= size7_r;
        data6_r  <= data7_r;
      end if;
      if ((count_r=x"8") and ((dwwrite and ready_r and waready)='1')) or
         ((count_r=x"7") and ((dwwrite and not(ready_r and waready))='1')) then
        valid7_r <= '1';
        addr7_r  <= dwaddr;
        size7_r  <= dwsize;
        data7_r  <= dwdata;
      elsif (ready_r = '1' and waready = '1') then
        valid7_r <= '0';
        addr7_r  <= (others => '0');
        size7_r  <= (others => '0');
        data7_r  <= (others => '0');
      end if;
    end if;
  end process;

end behavioral;

configuration cfg_cachewb of cachewb is
  for behavioral
  end for;
end cfg_cachewb;
