--*******************************************************************--
-- Copyright (c) 2001-2003  Evatronix SA                             --
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
-- File name            : CAM.VHD
-- File contents        : Entity CAM
--                        Architecture SIM of CAM
-- Purpose              : 2*47 bits external CAM memory for MAC
--
-- Destination library  : MAC_1G_AMBA_LIB
-- Dependencies         : IEEE.STD_LOGIC_1164
--                        IEEE.STD_LOGIC_UNSIGNED
--
-- Design Engineer      : T.K.
-- Quality Engineer     : M.B.
-- Version              : 2.00.E00
-- Last modification    : 2003-11-27
-----------------------------------------------------------------------

--*******************************************************************--
-- Modifications with respect to Version 2.00.E00:
--*******************************************************************--

library IEEE;
  use IEEE.STD_LOGIC_1164.all;


  entity CAM is
    port (
          -- clock
          clk       : in  STD_LOGIC;
          -- match enable
          matchen   : in  STD_LOGIC;
          -- match data
          matchdata : in  STD_LOGIC_VECTOR(47 downto 0);
          -- match output
          match     : out STD_LOGIC;
          -- match valid
          matchval  : out STD_LOGIC
    );
  end CAM;

--*******************************************************************--
architecture SIM of CAM is

  constant adr0  : STD_LOGIC_VECTOR(47 downto 0)
                 := "10111010" & "10011000" & "01110110" &
                    "01010100" & "00110010" & "00010001";
  constant adr1  : STD_LOGIC_VECTOR(47 downto 0)
                 := "00000000" & "00000000" & "00000000" &
                    "00000000" & "00000000" & "00000000";
  constant adr2  : STD_LOGIC_VECTOR(47 downto 0)
                 := "00000000" & "00000000" & "00000000" &
                    "00000000" & "00000000" & "00000000";
  constant adr3  : STD_LOGIC_VECTOR(47 downto 0)
                 := "00000000" & "00000000" & "00000000" &
                    "00000000" & "00000000" & "00000000";
  signal imatchval : STD_LOGIC;

begin
  
  ---------------------------------------------------------------------
  -- internal match valid registered
  ---------------------------------------------------------------------
  imatchval_proc:
  process(clk)
  begin
    if clk'event and clk='1' then
      imatchval <= matchen;
    end if;
  end process; -- imatchval_reg_proc
  
  ---------------------------------------------------------------------
  -- match output
  ---------------------------------------------------------------------
  match_drv:
    match <= '1' when imatchval='1' and
                      (
                        adr0=matchdata or
                        adr1=matchdata or
                        adr2=matchdata or
                        adr3=matchdata
                      ) else
              '0';
              
  ---------------------------------------------------------------------
  -- match valid
  ---------------------------------------------------------------------
  matchval_drv:
    matchval <= imatchval;
    
end SIM;
