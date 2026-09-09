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
-- Entity:      cackepkg
-- File:        cachepkg.vhd
-- Author:      Injo Hwang - Daewoo Electronics
-- Description: Package with type declarations for cache module
------------------------------------------------------------------------------  

library ieee;
    use ieee.std_logic_1164.all;

package cachepkg is

  constant cp15base : std_logic_vector (31 downto 12) := x"ffff8";

-- AMBA macros
  constant HTRANS_IDLE   : std_logic_vector (1 downto 0) := "00";
  constant HTRANS_BUSY   : std_logic_vector (1 downto 0) := "01";
  constant HTRANS_NONSEQ : std_logic_vector (1 downto 0) := "10";
  constant HTRANS_SEQ    : std_logic_vector (1 downto 0) := "11";
  
  constant HBURST_SINGLE : std_logic_vector (2 downto 0) := "000";
  constant HBURST_INCR   : std_logic_vector (2 downto 0) := "001";
  constant HBURST_WRAP4  : std_logic_vector (2 downto 0) := "010";
  constant HBURST_INCR4  : std_logic_vector (2 downto 0) := "011";
  constant HBURST_WRAP8  : std_logic_vector (2 downto 0) := "100";
  constant HBURST_INCR8  : std_logic_vector (2 downto 0) := "101";
  constant HBURST_WRAP16 : std_logic_vector (2 downto 0) := "110";
  constant HBURST_INCR16 : std_logic_vector (2 downto 0) := "111";
  
  constant HSIZE_BYTE    : std_logic_vector (2 downto 0) := "000";
  constant HSIZE_HWORD   : std_logic_vector (2 downto 0) := "001";
  constant HSIZE_WORD    : std_logic_vector (2 downto 0) := "010";
  constant HSIZE_DWORD   : std_logic_vector (2 downto 0) := "011";
  constant HSIZE_4WORD   : std_logic_vector (2 downto 0) := "100";
  constant HSIZE_8WORD   : std_logic_vector (2 downto 0) := "101";
  constant HSIZE_16WORD  : std_logic_vector (2 downto 0) := "110";
  constant HSIZE_32WORD  : std_logic_vector (2 downto 0) := "111";
  
  constant HRESP_OKAY    : std_logic_vector (1 downto 0) := "00";
  constant HRESP_ERROR   : std_logic_vector (1 downto 0) := "01";
  constant HRESP_RETRY   : std_logic_vector (1 downto 0) := "10";
  constant HRESP_SPLIT   : std_logic_vector (1 downto 0) := "11";
  
-- functions
  function linemask (addr : std_logic_vector)
                     return std_logic_vector;
  function lanemask (addr : std_logic_vector; size : std_logic_vector)
                     return std_logic_vector;
  function pubaaddr (addr : std_logic_vector; size : std_logic_vector)
                     return std_logic_vector;
  function merge    (inp0 : std_logic_vector; inp1 : std_logic_vector;
                     lane : std_logic_vector)
                     return std_logic_vector;
  
end cachepkg;

package body cachepkg is

-- functions

  function linemask (addr : std_logic_vector)
                     return std_logic_vector is
    variable a : std_logic_vector (1 downto 0);
    variable r : std_logic_vector (3 downto 0);
  begin
    a := addr(3 downto 2);
    r := "0000";
    case a is
    when "00"   => r := "0001";
    when "01"   => r := "0010";
    when "10"   => r := "0100";
    when "11"   => r := "1000";
    when others => r := "0000";
    end case;
    return r;
  end;
  
  function lanemask (addr : std_logic_vector; size : std_logic_vector)
                     return std_logic_vector is
    variable a : std_logic_vector (1 downto 0);
    variable s : std_logic_vector (1 downto 0);
    variable r : std_logic_vector (3 downto 0);
  begin
    a := addr(1 downto 0);
    s := size(1 downto 0);
    r := "0000";
    case s is
    when "00" =>
      case a is
      when "00"   => r := "0001";
      when "01"   => r := "0010";
      when "10"   => r := "0100";
      when "11"   => r := "1000";
      when others => r := "0000";
      end case;
    when "01" =>
      case a is
      when "00"   => r := "0011";
      when "01"   => r := "0011";
      when "10"   => r := "1100";
      when "11"   => r := "1100";
      when others => r := "0000";
      end case;
    when "10" =>
      case a is
      when "00"   => r := "1111";
      when "01"   => r := "1111";
      when "10"   => r := "1111";
      when "11"   => r := "1111";
      when others => r := "0000";
      end case;
    when others =>
      r := "0000";
    end case;
    return r;
  end;

  function pubaaddr (addr : std_logic_vector; size : std_logic_vector)
                     return std_logic_vector is
    variable a : std_logic_vector (31 downto 12);
    variable s : std_logic_vector ( 5 downto  1);
    variable r : std_logic_vector (31 downto 12);
  begin
    a := addr(31 downto 12);
    s := size(5 downto 1);
    r := (others => '0');
    case s is
    when "11111" => r(31 downto 12) := (others => '0');
    when "11110" => r(31 downto 31) := a(31 downto 31);
    when "11101" => r(31 downto 30) := a(31 downto 30);
    when "11100" => r(31 downto 29) := a(31 downto 29);
    when "11011" => r(31 downto 28) := a(31 downto 28);
    when "11010" => r(31 downto 27) := a(31 downto 27);
    when "11001" => r(31 downto 26) := a(31 downto 26);
    when "11000" => r(31 downto 25) := a(31 downto 25);
    when "10111" => r(31 downto 24) := a(31 downto 24);
    when "10110" => r(31 downto 23) := a(31 downto 23);
    when "10101" => r(31 downto 22) := a(31 downto 22);
    when "10100" => r(31 downto 21) := a(31 downto 21);
    when "10011" => r(31 downto 20) := a(31 downto 20);
    when "10010" => r(31 downto 19) := a(31 downto 19);
    when "10001" => r(31 downto 18) := a(31 downto 18);
    when "10000" => r(31 downto 17) := a(31 downto 17);
    when "01111" => r(31 downto 16) := a(31 downto 16);
    when "01110" => r(31 downto 15) := a(31 downto 15);
    when "01101" => r(31 downto 14) := a(31 downto 14);
    when "01100" => r(31 downto 13) := a(31 downto 13);
    when "01011" => r(31 downto 12) := a(31 downto 12);
    when others  => r(31 downto 12) := a(31 downto 12);
    end case;
    return r;
  end;

  function merge (inp0 : std_logic_vector; inp1 : std_logic_vector;
                  lane : std_logic_vector)
                  return std_logic_vector is
    variable l : std_logic_vector ( 3 downto 0);
    variable i : std_logic_vector (31 downto 0);
    variable r : std_logic_vector (31 downto 0);
  begin
    l := lane( 3 downto 0);
    i := inp1(31 downto 0);
    r := inp0(31 downto 0);
    if (l(0) = '1') then r( 7 downto  0) := i( 7 downto  0); end if;
    if (l(1) = '1') then r(15 downto  8) := i(15 downto  8); end if;
    if (l(2) = '1') then r(23 downto 16) := i(23 downto 16); end if;
    if (l(3) = '1') then r(31 downto 24) := i(31 downto 24); end if;
    return r;
  end;

end cachepkg;
