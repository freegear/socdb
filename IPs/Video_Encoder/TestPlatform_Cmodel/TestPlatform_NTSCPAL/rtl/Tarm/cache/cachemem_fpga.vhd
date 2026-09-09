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

  signal gnd      : std_logic;

  signal inenable : std_logic;
  signal intwrite : std_logic_vector ( 1 downto  0);
  signal indwrite : std_logic_vector ( 1 downto  0);
  signal itaddr   : std_logic_vector ( 8 downto  0);
  signal itwdata  : std_logic_vector (35 downto  0);
  signal itrdata0 : std_logic_vector (35 downto  0);
  signal itrdata1 : std_logic_vector (35 downto  0);
  signal idaddr   : std_logic_vector ( 8 downto  0);
  signal idwdata  : std_logic_vector (35 downto  0);
  signal idrdata0 : std_logic_vector (35 downto  0);
  signal idrdata1 : std_logic_vector (35 downto  0);

  signal dnenable : std_logic;
  signal dntwrite : std_logic_vector ( 1 downto  0);
  signal dndwrite : std_logic_vector ( 1 downto  0);
  signal dtaddr   : std_logic_vector ( 8 downto  0);
  signal dtwdata  : std_logic_vector (35 downto  0);
  signal dtrdata0 : std_logic_vector (35 downto  0);
  signal dtrdata1 : std_logic_vector (35 downto  0);
  signal ddaddr   : std_logic_vector ( 8 downto  0);
  signal ddwdata  : std_logic_vector (35 downto  0);
  signal ddrdata0 : std_logic_vector (35 downto  0);
  signal ddrdata1 : std_logic_vector (35 downto  0);

  component RAMB16_S1
    port (
      DO    : out std_logic_vector ( 0 downto 0);
      ADDR  : in  std_logic_vector (13 downto 0);
      DI    : in  std_logic_vector ( 0 downto 0);
      EN    : in  std_logic;
      CLK   : in  std_logic;
      WE    : in  std_logic;
      SSR   : in  std_logic
    );
  end component;

  component RAMB16_S2
    port (
      DO    : out std_logic_vector ( 1 downto 0);
      ADDR  : in  std_logic_vector (12 downto 0);
      DI    : in  std_logic_vector ( 1 downto 0);
      EN    : in  std_logic;
      CLK   : in  std_logic;
      WE    : in  std_logic;
      SSR   : in  std_logic
    );
  end component;

  component RAMB16_S4
    port (
      DO    : out std_logic_vector ( 3 downto 0);
      ADDR  : in  std_logic_vector (11 downto 0);
      DI    : in  std_logic_vector ( 3 downto 0);
      EN    : in  std_logic;
      CLK   : in  std_logic;
      WE    : in  std_logic;
      SSR   : in  std_logic
    );
  end component;
 
  component RAMB16_S9
    port (
      DO    : out std_logic_vector ( 7 downto 0);
      DOP   : out std_logic_vector ( 0 downto 0);
      ADDR  : in  std_logic_vector (10 downto 0);
      DI    : in  std_logic_vector ( 7 downto 0);
      DIP   : in  std_logic_vector ( 0 downto 0);
      EN    : in  std_logic;
      CLK   : in  std_logic;
      WE    : in  std_logic;
      SSR   : in  std_logic
    );
  end component;

  component RAMB16_S18
    port (
      DO    : out std_logic_vector (15 downto 0);
      DOP   : out std_logic_vector ( 1 downto 0);
      ADDR  : in  std_logic_vector ( 9 downto 0);
      DI    : in  std_logic_vector (15 downto 0);
      DIP   : in  std_logic_vector ( 1 downto 0);
      EN    : in  std_logic;
      CLK   : in  std_logic;
      WE    : in  std_logic;
      SSR   : in  std_logic
    );
  end component;

  component RAMB16_S36
    port (
      DO    : out std_logic_vector (31 downto 0);
      DOP   : out std_logic_vector ( 3 downto 0);
      ADDR  : in  std_logic_vector ( 8 downto 0);
      DI    : in  std_logic_vector (31 downto 0);
      DIP   : in  std_logic_vector ( 3 downto 0);
      EN    : in  std_logic;
      CLK   : in  std_logic;
      WE    : in  std_logic;
      SSR   : in  std_logic
    );
  end component;
 
  component RAMB16_S4_S4
    port (
      DOA   : out std_logic_vector ( 3 downto 0);
      DOB   : out std_logic_vector ( 3 downto 0);
      ADDRA : in  std_logic_vector (11 downto 0);
      CLKA  : in  std_logic;
      DIA   : in  std_logic_vector ( 3 downto 0);
      ENA   : in  std_logic;
      SSRA  : in  std_logic;
      WEA   : in  std_logic;
      ADDRB : in  std_logic_vector (11 downto 0);
      CLKB  : in  std_logic;
      DIB   : in  std_logic_vector ( 3 downto 0);
      ENB   : in  std_logic;
      SSRB  : in  std_logic;
      WEB   : in  std_logic
    );
  end component;

  component RAMB16_S9_S9
    port (
      DOA   : out std_logic_vector ( 7 downto 0);
      DOPA  : out std_logic_vector ( 0 downto 0);
      DOB   : out std_logic_vector ( 7 downto 0);
      DOPB  : out std_logic_vector ( 0 downto 0);
      ADDRA : in  std_logic_vector (10 downto 0);
      CLKA  : in  std_logic;
      DIA   : in  std_logic_vector ( 7 downto 0);
      DIPA  : in  std_logic_vector ( 0 downto 0);
      ENA   : in  std_logic;
      SSRA  : in  std_logic;
      WEA   : in  std_logic;
      ADDRB : in  std_logic_vector (10 downto 0);
      CLKB  : in  std_logic;
      DIB   : in  std_logic_vector ( 7 downto 0);
      DIPB  : in  std_logic_vector ( 0 downto 0);
      ENB   : in  std_logic;
      SSRB  : in  std_logic;
      WEB   : in  std_logic
    );
  end component;
 
  component RAMB16_S18_S18
    port (
      DOA   : out std_logic_vector (15 downto 0);
      DOPA  : out std_logic_vector ( 1 downto 0);
      DOB   : out std_logic_vector (15 downto 0);
      DOPB  : out std_logic_vector ( 1 downto 0);
      ADDRA : in  std_logic_vector ( 9 downto 0);
      CLKA  : in  std_logic;
      DIA   : in  std_logic_vector (15 downto 0);
      DIPA  : in  std_logic_vector ( 1 downto 0);
      ENA   : in  std_logic;
      SSRA  : in  std_logic;
      WEA   : in  std_logic;
      ADDRB : in  std_logic_vector ( 9 downto 0);
      CLKB  : in  std_logic;
      DIB   : in  std_logic_vector (15 downto 0);
      DIPB  : in  std_logic_vector ( 1 downto 0);
      ENB   : in  std_logic;
      SSRB  : in  std_logic;
      WEB   : in  std_logic
    );
  end component;

  component RAMB16_S36_S36
    port (
      DOA   : out std_logic_vector (31 downto 0);
      DOPA  : out std_logic_vector ( 3 downto 0);
      DOB   : out std_logic_vector (31 downto 0);
      DOPB  : out std_logic_vector ( 3 downto 0);
      ADDRA : in  std_logic_vector ( 8 downto 0);
      CLKA  : in  std_logic;
      DIA   : in  std_logic_vector (31 downto 0);
      DIPA  : in  std_logic_vector ( 3 downto 0);
      ENA   : in  std_logic;
      SSRA  : in  std_logic;
      WEA   : in  std_logic;
      ADDRB : in  std_logic_vector ( 8 downto 0);
      CLKB  : in  std_logic;
      DIB   : in  std_logic_vector (31 downto 0);
      DIPB  : in  std_logic_vector ( 3 downto 0);
      ENB   : in  std_logic;
      SSRB  : in  std_logic;
      WEB   : in  std_logic
    );
  end component;
 
begin

  gnd <= '0';

-- instruction cache signals
  inenable <= imcen;
  intwrite <= ((imten & imten) and imwset);
  indwrite <= ((imden & imden) and imwset);

  itaddr ( 6 downto  0) <= imaddr(10 downto  4);
  itaddr ( 8 downto  7) <= (others => '0');
  itwdata(21 downto  0) <= imaddr(31 downto 11) & imwvalid;
  itwdata(35 downto 22) <= (others => '0');
  imrcam0  <= itrdata0(21 downto 0);
  imrcam1  <= itrdata1(21 downto 0);

  idaddr ( 8 downto  0) <= imaddr(10 downto  2);
  idwdata(31 downto  0) <= imwdata;
  idwdata(35 downto 32) <= (others => '0');
  imrdata0 <= idrdata0(31 downto 0);
  imrdata1 <= idrdata1(31 downto 0);

-- instruction cache memories
  icam_0 : RAMB16_S36
    port map (
      DO   => itrdata0(31 downto  0),
      DOP  => itrdata0(35 downto 32),
      ADDR => itaddr,
      DI   => itwdata (31 downto  0),
      DIP  => itwdata (35 downto 32),
      EN   => inenable,
      CLK  => clk,
      WE   => intwrite(0),
      SSR  => gnd
    );
  icam_1 : RAMB16_S36
    port map (
      DO   => itrdata1(31 downto  0),
      DOP  => itrdata1(35 downto 32),
      ADDR => itaddr,
      DI   => itwdata (31 downto  0),
      DIP  => itwdata (35 downto 32),
      EN   => inenable,
      CLK  => clk,
      WE   => intwrite(1),
      SSR  => gnd
    );
  idata_0 : RAMB16_S36
    port map (
      DO   => idrdata0(31 downto  0),
      DOP  => idrdata0(35 downto 32),
      ADDR => idaddr,
      DI   => idwdata (31 downto  0),
      DIP  => idwdata (35 downto 32),
      EN   => inenable,
      CLK  => clk,
      WE   => indwrite(0),
      SSR  => gnd
    );
  idata_1 : RAMB16_S36
    port map (
      DO   => idrdata1(31 downto  0),
      DOP  => idrdata1(35 downto 32),
      ADDR => idaddr,
      DI   => idwdata (31 downto  0),
      DIP  => idwdata (35 downto 32),
      EN   => inenable,
      CLK  => clk,
      WE   => indwrite(1),
      SSR  => gnd
    );

-- data cache signals
  dnenable <= dmcen;
  dntwrite <= ((dmten & dmten) and dmwset);
  dndwrite <= ((dmden & dmden) and dmwset);

  dtaddr ( 6 downto  0) <= dmaddr(10 downto  4);
  dtaddr ( 8 downto  7) <= (others => '0');
  dtwdata(22 downto  0) <= dmaddr(31 downto 11) & dmwvalid & dmwdirty;
  dtwdata(35 downto 23) <= (others => '0');
  dmrcam0  <= dtrdata0(22 downto 0);
  dmrcam1  <= dtrdata1(22 downto 0);

  ddaddr ( 8 downto  0) <= dmaddr(10 downto  2);
  ddwdata(31 downto  0) <= dmwdata;
  ddwdata(35 downto 32) <= (others => '0');
  dmrdata0 <= ddrdata0(31 downto 0);
  dmrdata1 <= ddrdata1(31 downto 0);

-- data cache memories
  dcam_0 : RAMB16_S36
    port map (
      DO   => dtrdata0(31 downto  0),
      DOP  => dtrdata0(35 downto 32),
      ADDR => dtaddr,
      DI   => dtwdata (31 downto  0),
      DIP  => dtwdata (35 downto 32),
      EN   => dnenable,
      CLK  => clk,
      WE   => dntwrite(0),
      SSR  => gnd
    );
  dcam_1 : RAMB16_S36
    port map (
      DO   => dtrdata1(31 downto  0),
      DOP  => dtrdata1(35 downto 32),
      ADDR => dtaddr,
      DI   => dtwdata (31 downto  0),
      DIP  => dtwdata (35 downto 32),
      EN   => dnenable,
      CLK  => clk,
      WE   => dntwrite(1),
      SSR  => gnd
    );
  ddata_0 : RAMB16_S36
    port map (
      DO   => ddrdata0(31 downto  0),
      DOP  => ddrdata0(35 downto 32),
      ADDR => ddaddr,
      DI   => ddwdata (31 downto  0),
      DIP  => ddwdata (35 downto 32),
      EN   => dnenable,
      CLK  => clk,
      WE   => dndwrite(0),
      SSR  => gnd
    );
  ddata_1 : RAMB16_S36
    port map (
      DO   => ddrdata1(31 downto  0),
      DOP  => ddrdata1(35 downto 32),
      ADDR => ddaddr,
      DI   => ddwdata (31 downto  0),
      DIP  => ddwdata (35 downto 32),
      EN   => dnenable,
      CLK  => clk,
      WE   => dndwrite(1),
      SSR  => gnd
    );
 
end struct;

configuration cfg_cachemem of cachemem is
  for struct
  end for;
end cfg_cachemem;
