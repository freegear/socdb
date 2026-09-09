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
-- File name            : clkgen.vhd
-- File contents        : Entity CLKGEN
--                        Architecture SIM of CLKGEN
-- Purpose              : Clock generator for MAC
--
-- Destination library  : MAC_1G_AMBA_LIB
-- Dependencies         : IEEE.STD_LOGIC_1164
--                        IEEE.STD_LOGIC_UNSIGNED
--
-- Design Engineer      : T.K.
-- Quality Engineer     : M.B.
-- Version              : 2.02.E00
-- Last modification    : 2004-08-16
-----------------------------------------------------------------------

--*******************************************************************--
-- Modifications with respect to Version 2.00.E00:
--*******************************************************************--

library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  use IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER;

  entity CLKGEN is
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
  end CLKGEN;

--*******************************************************************--
architecture SIM of CLKGEN is

  -- internal clock
  signal iclk      : STD_LOGIC;
  -- internal clock enable
  signal iclken    : STD_LOGIC;
  
begin
  
  ---------------------------------------------------------------------
  -- clock generator
  ---------------------------------------------------------------------
  iclk_proc:
  process(iclk)
  begin
    if iclk='U' then
      iclk <= '0';
    else
      iclk <= not iclk after PERIOD/2;
    end if;
  end process; -- iclk_proc
  
  ---------------------------------------------------------------------
  -- clock gating
  ---------------------------------------------------------------------
  iclken_reg_proc:
  process(iclk)
  begin
    if iclk'event and iclk='0' then
      if rst='1' then
        iclken <= '1';
      else
        iclken <= not en1_n or not en2_n;
      end if;
    end if;
  end process; -- iclken_n;
  
  ---------------------------------------------------------------------
  -- clk driver
  ---------------------------------------------------------------------
  clk_drv:
    clk <= iclk and iclken;

end SIM;
--*******************************************************************--