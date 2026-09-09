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
-- File name            : rstgen.vhd
-- File contents        : Entity RSTGEN
--                        Architecture SIM of RSTGEN
-- Purpose              : Reset generator for AMBA AHB/APB
--
-- Destination library  : MAC_1G_AMBA_LIB
-- Dependencies         : IEEE.STD_LOGIC_1164
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

--*******************************************************************--

entity RSTGEN is
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
end RSTGEN;

--*******************************************************************--
architecture SIM of RSTGEN is
  
begin
  
  ---------------------------------------------------------------------
  -- AHB reset
  ---------------------------------------------------------------------
  hresetn_proc:
    process
    variable hcnt : INTEGER := 0;
  begin
    hresetn <= '0';
    while hcnt < RSTAHB_CYCLES loop
      wait on hclk until hclk='1';
      hcnt := hcnt+1;
    end loop;
    hresetn <= '1';
    wait;
  end process; -- hresetn_proc
  
  ---------------------------------------------------------------------
  -- APB reset
  ---------------------------------------------------------------------
  presetn_proc:
    process
    variable pcnt : INTEGER := 0;
  begin
    presetn <= '0';
    while pcnt < RSTAPB_CYCLES loop
      wait on pclk until pclk='1';
      pcnt := pcnt+1;
    end loop;
    presetn <= '1';
    wait;
  end process; -- hresetn_proc  
  
end SIM;
--*******************************************************************--