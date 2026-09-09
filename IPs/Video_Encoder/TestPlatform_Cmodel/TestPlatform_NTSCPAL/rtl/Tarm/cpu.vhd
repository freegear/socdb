--------------------------------------------------------------------------------
-- cpu.vhd
-- Designed by Im, JinHyeock
-- Copyright (C) 2003 by Chips&Media Inc.
--
-- Version 0.1 (27/09/2003)
--     0.1 Created in 27/09/2003
--
-- Purpose : integrate toyarm, cache and cache-ram
--------------------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.std_logic_arith.all;

entity cpu is
  port (
    rstcore  : in  std_logic;
    rstcache : in  std_logic;
    clk      : in  std_logic;
    bigend   : in  std_logic; -- 0, big endian is not supported yet
    hivecs   : in  std_logic; -- start from 0xffff0000 if 1 else 0x00000000
    nfiq     : in  std_logic;
    nirq     : in  std_logic;
    hbusreq  : out std_logic;
    hgrant   : in  std_logic;
    haddr    : out std_logic_vector (31 downto 0);
    htrans   : out std_logic_vector ( 1 downto 0);
    hwrite   : out std_logic;
    hsize    : out std_logic_vector ( 2 downto 0);
    hburst   : out std_logic_vector ( 2 downto 0);
    hlock    : out std_logic;
    hprot    : out std_logic_vector ( 3 downto 0);
    hready   : in  std_logic;
    hresp    : in  std_logic_vector ( 1 downto 0);
    hwdata   : out std_logic_vector (31 downto 0);
    hrdata   : in  std_logic_vector (31 downto 0)
  );
end cpu;

architecture struct of cpu is

  component toyarm
    port (
      nreset : in  std_logic;
      clk    : in  std_logic;
      bigend : in  std_logic;
      hivecs : in  std_logic;
      nfiq   : in  std_logic;
      nirq   : in  std_logic;
      inmreq : out std_logic;
      iseq   : out std_logic;                      -- not used
      ia     : out std_logic_vector (31 downto 0);
      id     : in  std_logic_vector (31 downto 0);
      inwait : in  std_logic;
      iabort : in  std_logic;
      dnmreq : out std_logic;
      dseq   : out std_logic;                      -- not used
      dmore  : out std_logic;                      -- not used
      dnrw   : out std_logic;
      dmas   : out std_logic_vector ( 1 downto 0); -- size
      da     : out std_logic_vector (31 downto 0);
      ddin   : in  std_logic_vector (31 downto 0);
      ddout  : out std_logic_vector (31 downto 0);
      dnwait : in  std_logic;
      dabort : in  std_logic
    );
  end component;

  component cachectl
    port (
      rst      : in  std_logic;
      clk      : in  std_logic;
      -- for toyarm
      inmreq   : in  std_logic;
      iseq     : in  std_logic;
      ia       : in  std_logic_vector (31 downto  0);
      inm      : in  std_logic_vector ( 4 downto  0);
      intrans  : in  std_logic;
      id       : out std_logic_vector (31 downto  0);
      iabort   : out std_logic;
      inwait   : out std_logic;
      dnmreq   : in  std_logic;
      dseq     : in  std_logic;
      dmas     : in  std_logic_vector ( 1 downto  0);
      dnrw     : in  std_logic;
      da       : in  std_logic_vector (31 downto  0);
      dnm      : in  std_logic_vector ( 4 downto  0);
      dntrans  : in  std_logic;
      dmore    : in  std_logic;
      dlock    : in  std_logic;
      dden     : in  std_logic;
      dd       : in  std_logic_vector (31 downto  0);
      dabe     : out std_logic;
      dabort   : out std_logic;
      dnwait   : out std_logic;
      ddbe     : out std_logic;
      ddin     : out std_logic_vector (31 downto  0);
      -- for cachemem
      imaddr   : out std_logic_vector (31 downto  0);
      imcen    : out std_logic;
      imten    : out std_logic;
      imden    : out std_logic;
      imwset   : out std_logic_vector ( 1 downto  0);
      imwvalid : out std_logic;
      imwdata  : out std_logic_vector (31 downto  0);
      imrcam0  : in  std_logic_vector (31 downto 10);
      imrcam1  : in  std_logic_vector (31 downto 10);
      imrdata0 : in  std_logic_vector (31 downto  0);
      imrdata1 : in  std_logic_vector (31 downto  0);
      dmaddr   : out std_logic_vector (31 downto  0);
      dmcen    : out std_logic;
      dmten    : out std_logic;
      dmden    : out std_logic;
      dmwset   : out std_logic_vector ( 1 downto  0);
      dmwvalid : out std_logic;
      dmwdirty : out std_logic;
      dmwdata  : out std_logic_vector (31 downto  0);
      dmrcam0  : in  std_logic_vector (31 downto  9);
      dmrcam1  : in  std_logic_vector (31 downto  9);
      dmrdata0 : in  std_logic_vector (31 downto  0);
      dmrdata1 : in  std_logic_vector (31 downto  0);
      -- for amba
      hgrant  : in  std_logic;
      hready  : in  std_logic;
      hresp   : in  std_logic_vector ( 1 downto 0);
      hrdata  : in  std_logic_vector (31 downto 0);
      hbusreq : out std_logic;
      hlock   : out std_logic;
      htrans  : out std_logic_vector ( 1 downto 0);
      haddr   : out std_logic_vector (31 downto 0);
      hwrite  : out std_logic;
      hsize   : out std_logic_vector ( 2 downto 0);
      hburst  : out std_logic_vector ( 2 downto 0);
      hprot   : out std_logic_vector ( 3 downto 0);
      hwdata  : out std_logic_vector (31 downto 0)
    );
  end component;

  component cachemem
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
  end component;  

  signal i_dseq   : std_logic;
  signal i_dmore  : std_logic;
  signal i_hsize  : std_logic_vector ( 2 downto  0);
  signal i_hburst : std_logic_vector ( 2 downto  0);
  signal i_hprot  : std_logic_vector ( 3 downto  0);

  -- for toyarm
  signal inmreq   : std_logic;
  signal iseq     : std_logic;
  signal ia       : std_logic_vector (31 downto  0);
  signal inm      : std_logic_vector ( 4 downto  0);
  signal intrans  : std_logic;
  signal id       : std_logic_vector (31 downto  0);
  signal iabort   : std_logic;
  signal inwait   : std_logic;
  signal dnmreq   : std_logic;
  signal dseq     : std_logic;
  signal dmas     : std_logic_vector ( 1 downto  0);
  signal dnrw     : std_logic;
  signal da       : std_logic_vector (31 downto  0);
  signal dnm      : std_logic_vector ( 4 downto  0);
  signal dntrans  : std_logic;
  signal dmore    : std_logic;
  signal dlock    : std_logic;
  signal dden     : std_logic;
  signal dd       : std_logic_vector (31 downto  0);
  signal dabe     : std_logic;
  signal dabort   : std_logic;
  signal dnwait   : std_logic;
  signal ddbe     : std_logic;
  signal ddin     : std_logic_vector (31 downto  0);

  -- for cachemem
  signal imaddr   : std_logic_vector (31 downto  0);
  signal imcen    : std_logic;
  signal imten    : std_logic;
  signal imden    : std_logic;
  signal imwset   : std_logic_vector ( 1 downto  0);
  signal imwvalid : std_logic;
  signal imwdata  : std_logic_vector (31 downto  0);
  signal imrcam0  : std_logic_vector (31 downto 10);
  signal imrcam1  : std_logic_vector (31 downto 10);
  signal imrdata0 : std_logic_vector (31 downto  0);
  signal imrdata1 : std_logic_vector (31 downto  0);
  signal dmaddr   : std_logic_vector (31 downto  0);
  signal dmcen    : std_logic;
  signal dmten    : std_logic;
  signal dmden    : std_logic;
  signal dmwset   : std_logic_vector ( 1 downto  0);
  signal dmwvalid : std_logic;
  signal dmwdirty : std_logic;
  signal dmwdata  : std_logic_vector (31 downto  0);
  signal dmrcam0  : std_logic_vector (31 downto  9);
  signal dmrcam1  : std_logic_vector (31 downto  9);
  signal dmrdata0 : std_logic_vector (31 downto  0);
  signal dmrdata1 : std_logic_vector (31 downto  0);

begin

  inm     <= (others => '0');
  intrans <= '0';
  dnm     <= (others => '0');
  dntrans <= '0';
  dlock   <= '0';
  dden    <= '0';
  dseq    <= '0';
  dmore   <= '0';

  toyarm_0 : toyarm
    port map (
      nreset => rstcore,
      clk    => clk,
      bigend => bigend,
      hivecs => hivecs,
      nfiq   => nfiq,
      nirq   => nirq,
      inmreq => inmreq,
      iseq   => iseq,
      ia     => ia,
      id     => id,
      inwait => inwait,
      iabort => iabort,
      dnmreq => dnmreq,
      dseq   => i_dseq,
      dmore  => i_dmore,
      dnrw   => dnrw,
      dmas   => dmas,
      da     => da,
      ddin   => ddin,
      ddout  => dd,
      dnwait => dnwait,
      dabort => dabort
    );

  hsize  <= '0' & i_hsize(1 downto 0);
  hburst <= '0' & i_hburst(1) & '0';
  hprot  <= (others => '0');

  -- cache controller
  cachectl_0 : cachectl
    port map (
      clk      => clk,
      rst      => rstcache,
      inmreq   => inmreq,
      iseq     => iseq,
      ia       => ia,
      inm      => inm,
      intrans  => intrans,
      id       => id,
      iabort   => iabort,
      inwait   => inwait,
      dnmreq   => dnmreq,
      dseq     => dseq,
      dmas     => dmas,
      dnrw     => dnrw,
      da       => da,
      dnm      => dnm,
      dntrans  => dntrans,
      dmore    => dmore,
      dlock    => dlock,
      dden     => dden,
      dd       => dd,
      dabe     => dabe,
      dabort   => dabort,
      dnwait   => dnwait,
      ddbe     => ddbe,
      ddin     => ddin,
      imaddr   => imaddr,
      imcen    => imcen,
      imten    => imten,
      imden    => imden,
      imwset   => imwset,
      imwvalid => imwvalid,
      imwdata  => imwdata,
      imrcam0  => imrcam0,
      imrcam1  => imrcam1,
      imrdata0 => imrdata0,
      imrdata1 => imrdata1,
      dmaddr   => dmaddr,
      dmcen    => dmcen,
      dmten    => dmten,
      dmden    => dmden,
      dmwset   => dmwset,
      dmwvalid => dmwvalid,
      dmwdirty => dmwdirty,
      dmwdata  => dmwdata,
      dmrcam0  => dmrcam0,
      dmrcam1  => dmrcam1,
      dmrdata0 => dmrdata0,
      dmrdata1 => dmrdata1,
      hgrant   => hgrant,
      hready   => hready,
      hresp    => hresp,
      hrdata   => hrdata,
      hbusreq  => hbusreq,
      hlock    => hlock,
      htrans   => htrans,
      haddr    => haddr,
      hwrite   => hwrite,
      hsize    => i_hsize,
      hburst   => i_hburst,
      hprot    => i_hprot,
      hwdata   => hwdata
    );

  -- cache memory
  cachemem_0 : cachemem
    port map ( 
      clk      => clk,
      imaddr   => imaddr,
      imcen    => imcen,
      imten    => imten,
      imden    => imden,
      imwset   => imwset,
      imwvalid => imwvalid,
      imwdata  => imwdata,
      imrcam0  => imrcam0,
      imrcam1  => imrcam1,
      imrdata0 => imrdata0,
      imrdata1 => imrdata1,
      dmaddr   => dmaddr,
      dmcen    => dmcen,
      dmten    => dmten,
      dmden    => dmden,
      dmwset   => dmwset,
      dmwvalid => dmwvalid,
      dmwdirty => dmwdirty,
      dmwdata  => dmwdata,
      dmrcam0  => dmrcam0,
      dmrcam1  => dmrcam1,
      dmrdata0 => dmrdata0,
      dmrdata1 => dmrdata1
    );

end struct;

configuration cfg_cpu of cpu is
  for struct
    for toyarm_0 : toyarm
      use configuration work.cfg_toyarm;
    end for;
    for cachectl_0 : cachectl
      use configuration work.cfg_cachectl;
    end for;
    for cachemem_0 : cachemem
      use configuration work.cfg_cachemem;
    end for;
  end for;
end cfg_cpu;
