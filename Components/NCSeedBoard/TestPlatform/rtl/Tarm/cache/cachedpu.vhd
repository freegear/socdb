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
-- Entity:      cachedpu
-- File:        cachedpu.vhd
-- Author:      Injo Hwang - Daewoo Electronics
-- Description: Protection Unit of Data Cache
------------------------------------------------------------------------------  

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_unsigned.conv_integer;
    use ieee.std_logic_arith.all;
    use ieee.std_logic_misc.all;
library work;
    use work.cachepkg.all;

entity cachedpu is
  port (
    clk      : in  std_logic;
    rst      : in  std_logic;
    -- cachectl interface
    paddr    : in  std_logic_vector (11 downto  0);
    psel     : in  std_logic;
    penable  : in  std_logic;
    pwrite   : in  std_logic;
    pwdata   : in  std_logic_vector (31 downto  0);
    prdata   : out std_logic_vector (31 downto  0);
    -- dcache interface
    dpaddr   : in  std_logic_vector (31 downto  0);
    dpc      : out std_logic;
    dpb      : out std_logic;
    dpap     : out std_logic_vector ( 1 downto  0)
  );
end cachedpu;

architecture behavioral of cachedpu is

  -- protection unit register
  signal c0_r      : std_logic;
  signal c1_r      : std_logic;
  signal c2_r      : std_logic;
  signal c3_r      : std_logic;
  signal c4_r      : std_logic;
  signal c5_r      : std_logic;
  signal c6_r      : std_logic;
  signal c7_r      : std_logic;
  signal b0_r      : std_logic;
  signal b1_r      : std_logic;
  signal b2_r      : std_logic;
  signal b3_r      : std_logic;
  signal b4_r      : std_logic;
  signal b5_r      : std_logic;
  signal b6_r      : std_logic;
  signal b7_r      : std_logic;
  signal ap0_r     : std_logic_vector ( 1 downto  0);
  signal ap1_r     : std_logic_vector ( 1 downto  0);
  signal ap2_r     : std_logic_vector ( 1 downto  0);
  signal ap3_r     : std_logic_vector ( 1 downto  0);
  signal ap4_r     : std_logic_vector ( 1 downto  0);
  signal ap5_r     : std_logic_vector ( 1 downto  0);
  signal ap6_r     : std_logic_vector ( 1 downto  0);
  signal ap7_r     : std_logic_vector ( 1 downto  0);
  signal base0_r   : std_logic_vector (31 downto 12);
  signal size0_r   : std_logic_vector ( 5 downto  1);
  signal enable0_r : std_logic;
  signal base1_r   : std_logic_vector (31 downto 12);
  signal size1_r   : std_logic_vector ( 5 downto  1);
  signal enable1_r : std_logic;
  signal base2_r   : std_logic_vector (31 downto 12);
  signal size2_r   : std_logic_vector ( 5 downto  1);
  signal enable2_r : std_logic;
  signal base3_r   : std_logic_vector (31 downto 12);
  signal size3_r   : std_logic_vector ( 5 downto  1);
  signal enable3_r : std_logic;
  signal base4_r   : std_logic_vector (31 downto 12);
  signal size4_r   : std_logic_vector ( 5 downto  1);
  signal enable4_r : std_logic;
  signal base5_r   : std_logic_vector (31 downto 12);
  signal size5_r   : std_logic_vector ( 5 downto  1);
  signal enable5_r : std_logic;
  signal base6_r   : std_logic_vector (31 downto 12);
  signal size6_r   : std_logic_vector ( 5 downto  1);
  signal enable6_r : std_logic;
  signal base7_r   : std_logic_vector (31 downto 12);
  signal size7_r   : std_logic_vector ( 5 downto  1);
  signal enable7_r : std_logic;

begin

  process (c0_r, b0_r, ap0_r, base0_r, size0_r, enable0_r,
           c1_r, b1_r, ap1_r, base1_r, size1_r, enable1_r,
           c2_r, b2_r, ap2_r, base2_r, size2_r, enable2_r,
           c3_r, b3_r, ap3_r, base3_r, size3_r, enable3_r,
           c4_r, b4_r, ap4_r, base4_r, size4_r, enable4_r,
           c5_r, b5_r, ap5_r, base5_r, size5_r, enable5_r,
           c6_r, b6_r, ap6_r, base6_r, size6_r, enable6_r,
           c7_r, b7_r, ap7_r, base7_r, size7_r, enable7_r,
           dpaddr)
  begin
    if    (enable7_r = '1') and (pubaaddr(dpaddr, size7_r) = base7_r) then
      dpc  <= c7_r;
      dpb  <= b7_r;
      dpap <= ap7_r;
    elsif (enable6_r = '1') and (pubaaddr(dpaddr, size6_r) = base6_r) then
      dpc  <= c6_r;
      dpb  <= b6_r;
      dpap <= ap6_r;
    elsif (enable5_r = '1') and (pubaaddr(dpaddr, size5_r) = base5_r) then
      dpc  <= c5_r;
      dpb  <= b5_r;
      dpap <= ap5_r;
    elsif (enable4_r = '1') and (pubaaddr(dpaddr, size4_r) = base4_r) then
      dpc  <= c4_r;
      dpb  <= b4_r;
      dpap <= ap4_r;
    elsif (enable3_r = '1') and (pubaaddr(dpaddr, size3_r) = base3_r) then
      dpc  <= c3_r;
      dpb  <= b3_r;
      dpap <= ap3_r;
    elsif (enable2_r = '1') and (pubaaddr(dpaddr, size2_r) = base2_r) then
      dpc  <= c2_r;
      dpb  <= b2_r;
      dpap <= ap2_r;
    elsif (enable1_r = '1') and (pubaaddr(dpaddr, size1_r) = base1_r) then
      dpc  <= c1_r;
      dpb  <= b1_r;
      dpap <= ap1_r;
    elsif (enable0_r = '1') and (pubaaddr(dpaddr, size0_r) = base0_r) then
      dpc  <= c0_r;
      dpb  <= b0_r;
      dpap <= ap0_r;
    else
      dpc  <= '0';
      dpb  <= '0';
      dpap <= "11";
    end if;
  end process;

  process (c0_r, b0_r, ap0_r, base0_r, size0_r, enable0_r,
           c1_r, b1_r, ap1_r, base1_r, size1_r, enable1_r,
           c2_r, b2_r, ap2_r, base2_r, size2_r, enable2_r,
           c3_r, b3_r, ap3_r, base3_r, size3_r, enable3_r,
           c4_r, b4_r, ap4_r, base4_r, size4_r, enable4_r,
           c5_r, b5_r, ap5_r, base5_r, size5_r, enable5_r,
           c6_r, b6_r, ap6_r, base6_r, size6_r, enable6_r,
           c7_r, b7_r, ap7_r, base7_r, size7_r, enable7_r,
           paddr, psel, pwrite)
  begin
    if (psel = '1' and pwrite = '0') then
      case paddr(11 downto 0) is
      when x"200" =>
        prdata(0) <= c0_r;
        prdata(1) <= c1_r;
        prdata(2) <= c2_r;
        prdata(3) <= c3_r;
        prdata(4) <= c4_r;
        prdata(5) <= c5_r;
        prdata(6) <= c6_r;
        prdata(7) <= c7_r;
        prdata(31 downto 8) <= (others => '0');
      when x"300" =>
        prdata(0) <= b0_r;
        prdata(1) <= b1_r;
        prdata(2) <= b2_r;
        prdata(3) <= b3_r;
        prdata(4) <= b4_r;
        prdata(5) <= b5_r;
        prdata(6) <= b6_r;
        prdata(7) <= b7_r;
        prdata(31 downto 8) <= (others => '0');
      when x"500" =>
        prdata( 1 downto  0) <= ap0_r;
        prdata( 3 downto  2) <= ap1_r;
        prdata( 5 downto  4) <= ap2_r;
        prdata( 7 downto  6) <= ap3_r;
        prdata( 9 downto  8) <= ap4_r;
        prdata(11 downto 10) <= ap5_r;
        prdata(13 downto 12) <= ap6_r;
        prdata(15 downto 14) <= ap7_r;
        prdata(31 downto 16) <= (others => '0');
      when x"600" =>
        prdata(31 downto 12) <= base0_r;
        prdata(13 downto  6) <= (others => '0');
        prdata( 5 downto  1) <= size0_r;
        prdata(0)            <= enable0_r;
      when x"604" =>
        prdata(31 downto 12) <= base1_r;
        prdata(13 downto  6) <= (others => '0');
        prdata( 5 downto  1) <= size1_r;
        prdata(0)            <= enable1_r;
      when x"608" =>
        prdata(31 downto 12) <= base2_r;
        prdata(13 downto  6) <= (others => '0');
        prdata( 5 downto  1) <= size2_r;
        prdata(0)            <= enable2_r;
      when x"60c" =>
        prdata(31 downto 12) <= base3_r;
        prdata(13 downto  6) <= (others => '0');
        prdata( 5 downto  1) <= size3_r;
        prdata(0)            <= enable3_r;
      when x"610" =>
        prdata(31 downto 12) <= base4_r;
        prdata(13 downto  6) <= (others => '0');
        prdata( 5 downto  1) <= size4_r;
        prdata(0)            <= enable4_r;
      when x"614" =>
        prdata(31 downto 12) <= base5_r;
        prdata(13 downto  6) <= (others => '0');
        prdata( 5 downto  1) <= size5_r;
        prdata(0)            <= enable5_r;
      when x"618" =>
        prdata(31 downto 12) <= base6_r;
        prdata(13 downto  6) <= (others => '0');
        prdata( 5 downto  1) <= size6_r;
        prdata(0)            <= enable6_r;
      when x"61c" =>
        prdata(31 downto 12) <= base7_r;
        prdata(13 downto  6) <= (others => '0');
        prdata( 5 downto  1) <= size7_r;
        prdata(0)            <= enable7_r;
      when others =>
        prdata <= (others => '0');
      end case;
    else
      prdata <= (others => '0');
    end if;
  end process;

  process (clk, rst)
  begin
    if (rst = '0') then
      c0_r      <= '0';
      c1_r      <= '0';
      c2_r      <= '0';
      c3_r      <= '0';
      c4_r      <= '0';
      c5_r      <= '0';
      c6_r      <= '0';
      c7_r      <= '0';
      b0_r      <= '0';
      b1_r      <= '0';
      b2_r      <= '0';
      b3_r      <= '0';
      b4_r      <= '0';
      b5_r      <= '0';
      b6_r      <= '0';
      b7_r      <= '0';
      ap0_r     <= "00";
      ap1_r     <= "00";
      ap2_r     <= "00";
      ap3_r     <= "00";
      ap4_r     <= "00";
      ap5_r     <= "00";
      ap6_r     <= "00";
      ap7_r     <= "00";
      base0_r   <= (others => '0');
      size0_r   <= (others => '0');
      enable0_r <= '0';
      base1_r   <= (others => '0');
      size1_r   <= (others => '0');
      enable1_r <= '0';
      base2_r   <= (others => '0');
      size2_r   <= (others => '0');
      enable2_r <= '0';
      base3_r   <= (others => '0');
      size3_r   <= (others => '0');
      enable3_r <= '0';
      base4_r   <= (others => '0');
      size4_r   <= (others => '0');
      enable4_r <= '0';
      base5_r   <= (others => '0');
      size5_r   <= (others => '0');
      enable5_r <= '0';
      base6_r   <= (others => '0');
      size6_r   <= (others => '0');
      enable6_r <= '0';
      base7_r   <= (others => '0');
      size7_r   <= (others => '0');
      enable7_r <= '0';
    elsif rising_edge(clk) then
      if (psel = '1' and penable = '1' and pwrite = '1') then
        case paddr(11 downto 0) is
        when x"200" =>
          c0_r <= pwdata(0);
          c1_r <= pwdata(1);
          c2_r <= pwdata(2);
          c3_r <= pwdata(3);
          c4_r <= pwdata(4);
          c5_r <= pwdata(5);
          c6_r <= pwdata(6);
          c7_r <= pwdata(7);
        when x"300" =>
          b0_r <= pwdata(0);
          b1_r <= pwdata(1);
          b2_r <= pwdata(2);
          b3_r <= pwdata(3);
          b4_r <= pwdata(4);
          b5_r <= pwdata(5);
          b6_r <= pwdata(6);
          b7_r <= pwdata(7);
        when x"500" =>
          ap0_r <= pwdata( 1 downto  0);
          ap1_r <= pwdata( 3 downto  2);
          ap2_r <= pwdata( 5 downto  4);
          ap3_r <= pwdata( 7 downto  6);
          ap4_r <= pwdata( 9 downto  8);
          ap5_r <= pwdata(11 downto 10);
          ap6_r <= pwdata(13 downto 12);
          ap7_r <= pwdata(15 downto 14);
        when x"600" =>
          base0_r   <= pwdata(31 downto 12);
          size0_r   <= pwdata( 5 downto  1);
          enable0_r <= pwdata(0);
        when x"604" =>
          base1_r   <= pwdata(31 downto 12);
          size1_r   <= pwdata( 5 downto  1);
          enable1_r <= pwdata(0);
        when x"608" =>
          base2_r   <= pwdata(31 downto 12);
          size2_r   <= pwdata( 5 downto  1);
          enable2_r <= pwdata(0);
        when x"60c" =>
          base3_r   <= pwdata(31 downto 12);
          size3_r   <= pwdata( 5 downto  1);
          enable3_r <= pwdata(0);
        when x"610" =>
          base4_r   <= pwdata(31 downto 12);
          size4_r   <= pwdata( 5 downto  1);
          enable4_r <= pwdata(0);
        when x"614" =>
          base5_r   <= pwdata(31 downto 12);
          size5_r   <= pwdata( 5 downto  1);
          enable5_r <= pwdata(0);
        when x"618" =>
          base6_r   <= pwdata(31 downto 12);
          size6_r   <= pwdata( 5 downto  1);
          enable6_r <= pwdata(0);
        when x"61c" =>
          base7_r   <= pwdata(31 downto 12);
          size7_r   <= pwdata( 5 downto  1);
          enable7_r <= pwdata(0);
        when others =>
        end case;
      end if;
    end if;
  end process;

end behavioral;

configuration cfg_cachedpu of cachedpu is
  for behavioral
  end for;
end cfg_cachedpu;
