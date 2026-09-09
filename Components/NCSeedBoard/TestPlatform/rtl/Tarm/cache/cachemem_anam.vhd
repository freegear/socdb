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
-- Entity:      cachemem
-- File:        cachemem.vhd
-- Author:      Injo Hwang - Daewoo Electronics
-- Description: Contains ram cells for both instruction and data caches
------------------------------------------------------------------------------  

library ieee;
    use ieee.std_logic_1164.all;

entity cachemem is
  port (
    clk      : in  std_logic;
    imaddr   : in  std_logic_vector (31 downto  0);
    imcen    : in  std_logic;
    imten    : in  std_logic;
    imden    : in  std_logic;
    imwset   : in  std_logic_vector ( 1 downto  0);
    imwvalid : in  std_logic;
    imwdata  : in  std_logic_vector (31 downto  0);
    imrcam0  : out std_logic_vector (31 downto 10);
    imrcam1  : out std_logic_vector (31 downto 10);
    imrdata0 : out std_logic_vector (31 downto  0);
    imrdata1 : out std_logic_vector (31 downto  0);
    dmaddr   : in  std_logic_vector (31 downto  0);
    dmcen    : in  std_logic;
    dmten    : in  std_logic;
    dmden    : in  std_logic;
    dmwset   : in  std_logic_vector ( 1 downto  0);
    dmwvalid : in  std_logic;
    dmwdirty : in  std_logic;
    dmwdata  : in  std_logic_vector (31 downto  0);
    dmrcam0  : out std_logic_vector (31 downto  9);
    dmrcam1  : out std_logic_vector (31 downto  9);
    dmrdata0 : out std_logic_vector (31 downto  0);
    dmrdata1 : out std_logic_vector (31 downto  0)
  );
end cachemem;

architecture struct of cachemem is

  signal vdd      : std_logic;
  signal gnd      : std_logic;

  signal inenable : std_logic;
  signal intwrite : std_logic_vector ( 1 downto  0);
  signal indwrite : std_logic_vector ( 1 downto  0);
  signal itwdata  : std_logic_vector (31 downto 10);

  signal dnenable : std_logic;
  signal dntwrite : std_logic_vector ( 1 downto  0);
  signal dndwrite : std_logic_vector ( 1 downto  0);
  signal dtwdata  : std_logic_vector (31 downto  9);

  component sp128x22m4
    port (
      clk : in  std_logic;
      me  : in  std_logic;
      we  : in  std_logic;
      adr : in  std_logic_vector ( 6 downto 0);
      d   : in  std_logic_vector (21 downto 0);
      oe  : in  std_logic;
      q   : out std_logic_vector (21 downto 0)
    );
  end component;

  component sp128x23m4
    port (
      clk : in  std_logic;
      me  : in  std_logic;
      we  : in  std_logic;
      adr : in  std_logic_vector ( 6 downto 0);
      d   : in  std_logic_vector (22 downto 0);
      oe  : in  std_logic;
      q   : out std_logic_vector (22 downto 0)
    );
  end component;

  component sp512x32m4
    port (
      clk : in  std_logic;
      me  : in  std_logic;
      we  : in  std_logic;
      adr : in  std_logic_vector ( 8 downto 0);
      d   : in  std_logic_vector (31 downto 0);
      oe  : in  std_logic;
      q   : out std_logic_vector (31 downto 0)
    );
  end component;

begin

  vdd <= '1';
  gnd <= '0';

-- instruction cache signals
  inenable <= imcen;
  intwrite <= (imten & imten) and imwset;
  indwrite <= (imden & imden) and imwset;
  itwdata  <= imaddr(31 downto 11) & imwvalid;

-- instruction cache memories
  icam_0 : sp128x22m4
    port map (
      clk => clk,
      me  => inenable,
      we  => intwrite(0),
      adr => imaddr(10 downto 4),
      d   => itwdata,
      oe  => vdd,
      q   => imrcam0
    );
  icam_1 : sp128x22m4
    port map (
      clk => clk,
      me  => inenable,
      we  => intwrite(1),
      adr => imaddr(10 downto 4),
      d   => itwdata,
      oe  => vdd,
      q   => imrcam1
    );
  idata_0 : sp512x32m4
    port map (
      clk => clk,
      me  => inenable,
      we  => indwrite(0),
      adr => imaddr(10 downto 2),
      d   => imwdata,
      oe  => vdd,
      q   => imrdata0
    );
  idata_1 : sp512x32m4
    port map (
      clk => clk,
      me  => inenable,
      we  => indwrite(1),
      adr => imaddr(10 downto 2),
      d   => imwdata,
      oe  => vdd,
      q   => imrdata1
    );

-- data cache signals
  dnenable <= dmcen;
  dntwrite <= (dmten & dmten) and dmwset;
  dndwrite <= (dmden & dmden) and dmwset;
  dtwdata  <= dmaddr(31 downto 11) & dmwvalid & dmwdirty;

-- data cache memories
  dcam_0 : sp128x23m4
    port map (
      clk => clk,
      me  => dnenable,
      we  => dntwrite(0),
      adr => dmaddr(10 downto 4),
      d   => dtwdata,
      oe  => vdd,
      q   => dmrcam0
    );
  dcam_1 : sp128x23m4
    port map (
      clk => clk,
      me  => dnenable,
      we  => dntwrite(1),
      adr => dmaddr(10 downto 4),
      d   => dtwdata,
      oe  => vdd,
      q   => dmrcam1
    );
  ddata_0 : sp512x32m4
    port map (
      clk => clk,
      me  => dnenable,
      we  => dndwrite(0),
      adr => dmaddr(10 downto 2),
      d   => dmwdata,
      oe  => vdd,
      q   => dmrdata0
    );
  ddata_1 : sp512x32m4
    port map (
      clk => clk,
      me  => dnenable,
      we  => dndwrite(1),
      adr => dmaddr(10 downto 2),
      d   => dmwdata,
      oe  => vdd,
      q   => dmrdata1
    );
 
end struct;

configuration cfg_cachemem of cachemem is
  for struct
-- pragma translate_off
    for icam_0, icam_1 : sp128x25m4
      use configuration work.cfg_sp128x22m4;
    end for;
    for idata_0, idata_1 : sp512x32m4
      use configuration work.cfg_sp512x32m4;
    end for;
    for dcam_0, dcam_1 : sp128x25m4
      use configuration work.cfg_sp128x23m4;
    end for;
    for ddata_0, ddata_1 : sp512x32m4
      use configuration work.cfg_sp512x32m4;
    end for;
-- pragma translate_on
  end for;
end cfg_cachemem;
