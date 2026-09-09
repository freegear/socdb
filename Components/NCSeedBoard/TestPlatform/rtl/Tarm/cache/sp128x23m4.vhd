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
-- Entity:      sp128x23m4
-- File:        sp128x23m4.vhd
-- Author:      Kevin Lim
-- Description: Synchronous SRAM
------------------------------------------------------------------------------  

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.std_logic_arith.all;

entity sp128x23m4 is
  port (
    clk : in  std_logic;
    cen : in  std_logic;
    wen : in  std_logic;
    a   : in  std_logic_vector( 6 downto 0);
    d   : in  std_logic_vector(22 downto 0);
    oen : in  std_logic;
    q   : out std_logic_vector(22 downto 0)
  );
end sp128x23m4;

architecture behavioral of sp128x23m4 is

  type memtype is array(0 to 127) of std_logic_vector(22 downto 0);
 
begin

  process (clk)
  variable mem : memtype;
  begin
-- pragma translate_off
    if not is_x(a) then
-- pragma translate_on
    if rising_edge(clk) then
      if (cen = '0') then
        if (wen = '0') then
          mem(conv_integer(unsigned(a))) := d;
        elsif (oen = '0') then
          q <= mem(conv_integer(unsigned(a)));
        end if;
      end if;
    end if;
-- pragma translate_off
    end if;
-- pragma translate_on
  end process;

end behavioral;

configuration cfg_sp128x23m4 of sp128x23m4 is
  for behavioral
  end for;
end cfg_sp128x23m4;
