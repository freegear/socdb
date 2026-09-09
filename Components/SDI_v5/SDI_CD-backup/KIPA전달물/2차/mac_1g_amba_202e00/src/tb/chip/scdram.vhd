--*******************************************************************--
-- Copyright (c) 2001-2004  Evatronix SA                             --
--*******************************************************************--
-- Please review the terms of the license agreement before using     --
-- this file. If you are not an authorized user, please destroy this --
-- source code file and notify Evatronix SA immediately that you     --
-- inadvertently received an unauthorized copy.                      --
--*******************************************************************--

-----------------------------------------------------------------------
-- Project name         : MAC-1G
-- Project description  : Gigabit Ethernet Media Access Controller
--
-- File name            : DUALRAM.VHD
-- File contents        : Entity DUALRAM
--                        Architecture SIM of DUALRAM
-- Purpose              : Dual-port RAM for MAC
--
-- Destination library  : MAC_LIB
-- Dependencies         : IEEE.STD_LOGIC_1164
--                        IEEE.STD_LOGIC_UNSIGNED
--
-- Design Engineer      : B.W.
-- Quality Engineer     : M.B.
-- Version              : 2.02E00
-- Last modification    : 2004-08-16
-----------------------------------------------------------------------

library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  use IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER;


  entity SCDRAM is
    generic (
            -- address bus width
            DRAMDEPTH : INTEGER := 9;
            -- data bus width
            DRAMWIDTH : INTEGER := 32
    );
    port (
            -- port A clock
            clka      : in  STD_LOGIC;
            -- write enable
            wea       : in  STD_LOGIC;
            -- port A write data
            dina      : in  STD_LOGIC_VECTOR(DRAMWIDTH-1 downto 0);
            -- port A read data
            douta     : out STD_LOGIC_VECTOR(DRAMWIDTH-1 downto 0);
            -- port A address
            addra     : in  STD_LOGIC_VECTOR(DRAMDEPTH-1 downto 0);

            -- port B clock
            clkb      : in  STD_LOGIC;
            -- write enable
            web       : in  STD_LOGIC;
            -- port B write data
            dinb      : in  STD_LOGIC_VECTOR(DRAMWIDTH-1 downto 0);
            -- port B read data
            doutb     : out STD_LOGIC_VECTOR(DRAMWIDTH-1 downto 0);
            -- port B address
            addrb     : in  STD_LOGIC_VECTOR(DRAMDEPTH-1 downto 0)
            
    );
  end SCDRAM;

--*******************************************************************--
architecture SIM of SCDRAM is

  -- single word in DP RAM
  subtype TWORD is STD_LOGIC_VECTOR(DRAMWIDTH-1 downto 0);
  -- memory type
  type TMEMORY is array (2**DRAMDEPTH-1 downto 0) of TWORD;
  -- port A read adderss registered
  signal addra_r : STD_LOGIC_VECTOR(DRAMDEPTH-1 downto 0);
  -- port B read adderss registered
  signal addrb_r : STD_LOGIC_VECTOR(DRAMDEPTH-1 downto 0);
  -- memory
  signal mem     : TMEMORY;

begin

  ---------------------------------------------------------------------
  -- port A operations
  ---------------------------------------------------------------------

  ---------------------------------------------------------------------
  -- memory registered
  ---------------------------------------------------------------------
  porta_wr_proc:
  process (clka)
  begin
    -- write data -------------------------------
    if clka'event and clka='1' then
--      if rstb='1' then
--        for i in 2**DRAMDEPTH-1 downto 0 loop
--          mem(i) <= (others=>'1');
--        end loop;
--      else
        addra_r <= addra;
--      end if;
    end if;
  end process; -- porta_wr_proc

  ---------------------------------------------------------------------
  -- read data
  -- combinatorial output
  ---------------------------------------------------------------------
  douta_drv:
    douta <= mem(CONV_INTEGER(addra_r)) after 1 ns;

    
  ---------------------------------------------------------------------
  -- writing memory
  ---------------------------------------------------------------------
  mem_wr_proc:
  process(clka, clkb)
  begin
    if clka'event and clka='1' then
      if wea='1' then
        mem(CONV_INTEGER(addra)) <= dina;
      end if;
    end if;
    
    if clkb'event and clkb='1' then
      if web='1' then
        mem(CONV_INTEGER(addrb)) <= dinb;
      end if;
    end if;    
  end process; -- mem_wr_proc
  
    
    
  ---------------------------------------------------------------------
  -- port B operations
  ---------------------------------------------------------------------
  
  ---------------------------------------------------------------------
  -- read address registered
  ---------------------------------------------------------------------
  portb_rd_proc:
  process(clkb)
  begin
    if clkb'event and clkb='1' then
      addrb_r <= addrb;
    end if;
  end process; -- raddr_reg_proc
  
  ---------------------------------------------------------------------
  -- read data
  -- combinatorial output
  ---------------------------------------------------------------------
  doutb_drv:
    doutb <= mem(CONV_INTEGER(addrb_r)) after 1 ns;
    
end SIM;
--*******************************************************************--
