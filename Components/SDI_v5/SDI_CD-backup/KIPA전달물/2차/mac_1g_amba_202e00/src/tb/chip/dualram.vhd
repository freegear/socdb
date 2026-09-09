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
-- File name            : dualram.vhd
-- File contents        : Entity DUALRAM
--                        Architecture SIM of DUALRAM
-- Purpose              : Dual-port RAM for MAC
--
-- Destination library  : MAC_1G_LIB
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
-- 2.02.E00   :
-- 2003.03.21 : T.K. - rstw (write reset) port added
--                   - synchronous reset in MEMORY_PROC added
-- 2003.05.12 : T.K. - synchronous reset removed
--*******************************************************************--

library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  use IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER;


  entity DUALRAM is
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
  end DUALRAM;

--*******************************************************************--
architecture SIM of DUALRAM is

  -- single word in DP RAM
  subtype TWORD is STD_LOGIC_VECTOR(DRAMWIDTH-1 downto 0);
  -- memory type
  type TMEMORY is array (2**DRAMDEPTH-1 downto 0) of TWORD;
  -- read adderss registered
  signal raddr_r : STD_LOGIC_VECTOR(DRAMDEPTH-1 downto 0);
  -- memory
  signal mem     : TMEMORY;

begin

  ---------------------------------------------------------------------
  -- memory registered
  ---------------------------------------------------------------------
  memory_proc:
  process (clkw)
  begin
    -- write data -------------------------------
    if clkw'event and clkw='1' then
      if we='1' then
        mem(CONV_INTEGER(waddr)) <= wdata;
      end if;
    end if;
  end process;

  ---------------------------------------------------------------------
  -- read address registered
  ---------------------------------------------------------------------
  raddr_reg_proc:
  process(clkr)
  begin
    if clkr'event and clkr='1' then
      raddr_r <= raddr;
    end if;
  end process; -- raddr_reg_proc
  
  ---------------------------------------------------------------------
  -- read data
  -- combinatorial output
  ---------------------------------------------------------------------
  rdata_drv:
    rdata <= mem(CONV_INTEGER(raddr_r)) after 1 ns;
    
end SIM;
--*******************************************************************--
