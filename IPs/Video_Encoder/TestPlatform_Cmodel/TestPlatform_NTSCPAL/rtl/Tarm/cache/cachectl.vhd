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
-- Entity:      cachectl
-- File:        cachectl.vhd
-- Author:      Injo Hwang - Daewoo Electronics
-- Description: Complete cache sub-system with controllers
------------------------------------------------------------------------------  

library ieee;
    use ieee.std_logic_1164.all;

entity cachectl is
  port (
    clk      : in  std_logic;
    rst      : in  std_logic;
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
    hgrant   : in  std_logic;
    hready   : in  std_logic;
    hresp    : in  std_logic_vector ( 1 downto  0);
    hrdata   : in  std_logic_vector (31 downto  0);
    hbusreq  : out std_logic;
    hlock    : out std_logic;
    htrans   : out std_logic_vector ( 1 downto  0);
    haddr    : out std_logic_vector (31 downto  0);
    hwrite   : out std_logic;
    hsize    : out std_logic_vector ( 2 downto  0);
    hburst   : out std_logic_vector ( 2 downto  0);
    hprot    : out std_logic_vector ( 3 downto  0);
    hwdata   : out std_logic_vector (31 downto  0)
  );
end cachectl;

architecture struct of cachectl is

  component cachereg
    port (
      clk      : in  std_logic;
      rst      : in  std_logic;
      -- acache interface
      paddr    : in  std_logic_vector (11 downto  0);
      psel     : in  std_logic;
      penable  : in  std_logic;
      pwrite   : in  std_logic;
      pwdata   : in  std_logic_vector (31 downto  0);
      prdata   : out std_logic_vector (31 downto  0);
      -- cachectl interface
      caddr    : out std_logic_vector (11 downto  0);
      cselip   : out std_logic;
      cseldp   : out std_logic;
      cselic   : out std_logic;
      cseldc   : out std_logic;
      cselwb   : out std_logic;
      cenable  : out std_logic;
      cwrite   : out std_logic;
      cwdata   : out std_logic_vector (31 downto  0);
      crdataip : in  std_logic_vector (31 downto  0);
      crdatadp : in  std_logic_vector (31 downto  0);
      crreg    : out std_logic_vector (31 downto  0)
    );
  end component;

  component cacheipu
    port (
      clk      : in  std_logic;
      rst      : in  std_logic;
      -- cachectl interface
      paddr    : in  std_logic_vector (11 downto  0);
      psel     : in  std_logic;
      penable  : in  std_logic;
      pwrite   : in  std_logic;
      pwdata   : in  std_logic_vector (31 downto  0);
      prdata   : out std_logic_vector (31 downto  0);
      -- icache interface
      ipaddr   : in  std_logic_vector (31 downto  0);
      ipc      : out std_logic;
      ipap     : out std_logic_vector ( 1 downto  0)
    );
  end component;

  component cachedpu
    port (
      clk      : in  std_logic;
      rst      : in  std_logic;
      -- cachectl interface
      paddr    : in  std_logic_vector (11 downto  0);
      psel     : in  std_logic;
      penable  : in  std_logic;
      pwrite   : in  std_logic;
      pwdata   : in  std_logic_vector (31 downto  0);
      prdata   : out std_logic_vector (31 downto  0);
      -- dcache interface
      dpaddr   : in  std_logic_vector (31 downto  0);
      dpc      : out std_logic;
      dpb      : out std_logic;
      dpap     : out std_logic_vector ( 1 downto  0)
    );
  end component;

  component cacheic
    port (
      clk      : in  std_logic;
      rst      : in  std_logic;
      -- processor interface
      inmreq   : in  std_logic;
      iseq     : in  std_logic;
      ia       : in  std_logic_vector (31 downto  0);
      inm      : in  std_logic_vector ( 4 downto  0);
      intrans  : in  std_logic;
      id       : out std_logic_vector (31 downto  0);
      iabort   : out std_logic;
      inwait   : out std_logic;
      -- cachectl interface
      paddr    : in  std_logic_vector (11 downto  0);
      psel     : in  std_logic;
      penable  : in  std_logic;
      pwrite   : in  std_logic;
      pwdata   : in  std_logic_vector (31 downto  0);
      crreg    : in  std_logic_vector (31 downto  0);
      -- icachepu interface
      ipaddr   : out std_logic_vector (31 downto  0);
      ipc      : in  std_logic;
      ipap     : in  std_logic_vector ( 1 downto  0);
      -- cachemem interface
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
      -- acache interface
      iagrant  : in  std_logic;
      iaready  : in  std_logic;
      iaresp   : in  std_logic_vector ( 1 downto  0);
      iardata  : in  std_logic_vector (31 downto  0);
      iabusreq : out std_logic;
      ialock   : out std_logic;
      iatrans  : out std_logic_vector ( 1 downto  0);
      iaaddr   : out std_logic_vector (31 downto  0);
      iawrite  : out std_logic;
      iasize   : out std_logic_vector ( 2 downto  0);
      iaburst  : out std_logic_vector ( 2 downto  0);
      iaprot   : out std_logic_vector ( 3 downto  0);
      iawdata  : out std_logic_vector (31 downto  0)
    );
  end component;

  component cachedc
    port (
      clk      : in  std_logic;
      rst      : in  std_logic;
      -- processor interface
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
      -- cachectl interface
      paddr    : in  std_logic_vector (11 downto  0);
      psel     : in  std_logic;
      penable  : in  std_logic;
      pwrite   : in  std_logic;
      pwdata   : in  std_logic_vector (31 downto  0);
      crreg    : in  std_logic_vector (31 downto  0);
      -- dcachepu interface
      dpaddr   : out std_logic_vector (31 downto  0);
      dpc      : in  std_logic;
      dpb      : in  std_logic;
      dpap     : in  std_logic_vector ( 1 downto  0);
      -- cachemem interface
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
      -- cachewb interface
      dwwrite  : out std_logic;
      dwaddr   : out std_logic_vector (31 downto  0);
      dwsize   : out std_logic_vector ( 1 downto  0);
      dwdata   : out std_logic_vector (31 downto  0);
      dwcount  : in  std_logic_vector ( 3 downto  0);
      -- acache interface
      dacpreq  : out std_logic;
      dagrant  : in  std_logic;
      daready  : in  std_logic;
      daresp   : in  std_logic_vector ( 1 downto  0);
      dardata  : in  std_logic_vector (31 downto  0);
      dabusreq : out std_logic;
      dalock   : out std_logic;
      datrans  : out std_logic_vector ( 1 downto  0);
      daaddr   : out std_logic_vector (31 downto  0);
      dawrite  : out std_logic;
      dasize   : out std_logic_vector ( 2 downto  0);
      daburst  : out std_logic_vector ( 2 downto  0);
      daprot   : out std_logic_vector ( 3 downto  0);
      dawdata  : out std_logic_vector (31 downto  0)
    );
  end component;

  component cachewb
    port (
      clk      : in  std_logic;
      rst      : in  std_logic;
      -- dcache interface
      dwwrite  : in  std_logic;
      dwaddr   : in  std_logic_vector (31 downto  0);
      dwsize   : in  std_logic_vector ( 1 downto  0);
      dwdata   : in  std_logic_vector (31 downto  0);
      dwcount  : out std_logic_vector ( 3 downto  0);
      -- cachectl interface
      paddr    : in  std_logic_vector (11 downto  0);
      psel     : in  std_logic;
      penable  : in  std_logic;
      pwrite   : in  std_logic;
      pwdata   : in  std_logic_vector (31 downto  0);
      -- acache interface
      wagrant  : in  std_logic;
      waready  : in  std_logic;
      wawrite  : out std_logic;
      waaddr   : out std_logic_vector (31 downto  0);
      wasize   : out std_logic_vector ( 1 downto  0);
      wadata   : out std_logic_vector (31 downto  0);
      hgrant   : in  std_logic;
      hready   : in  std_logic;
      haddr    : in  std_logic_vector (31 downto  0);
      hrdata   : in  std_logic_vector (31 downto  0);
      hwdata   : out std_logic_vector (31 downto  0)
    );
  end component;

  component cacheahb
    port (
      clk      : in  std_logic;
      rst      : in  std_logic;
      -- icache interface
      iagrant  : out std_logic;
      iaready  : out std_logic;
      iaresp   : out std_logic_vector ( 1 downto  0);
      iardata  : out std_logic_vector (31 downto  0);
      iabusreq : in  std_logic;
      ialock   : in  std_logic;
      iatrans  : in  std_logic_vector ( 1 downto  0);
      iaaddr   : in  std_logic_vector (31 downto  0);
      iawrite  : in  std_logic;
      iasize   : in  std_logic_vector ( 2 downto  0);
      iaburst  : in  std_logic_vector ( 2 downto  0);
      iaprot   : in  std_logic_vector ( 3 downto  0);
      iawdata  : in  std_logic_vector (31 downto  0);
      -- dcache interface
      dacpreq  : in  std_logic;
      dagrant  : out std_logic;
      daready  : out std_logic;
      daresp   : out std_logic_vector ( 1 downto  0);
      dardata  : out std_logic_vector (31 downto  0);
      dabusreq : in  std_logic;
      dalock   : in  std_logic;
      datrans  : in  std_logic_vector ( 1 downto  0);
      daaddr   : in  std_logic_vector (31 downto  0);
      dawrite  : in  std_logic;
      dasize   : in  std_logic_vector ( 2 downto  0);
      daburst  : in  std_logic_vector ( 2 downto  0);
      daprot   : in  std_logic_vector ( 3 downto  0);
      dawdata  : in  std_logic_vector (31 downto  0);
      -- cachewb interface
      wagrant  : out std_logic;
      waready  : out std_logic;
      wawrite  : in  std_logic;
      waaddr   : in  std_logic_vector (31 downto  0);
      wasize   : in  std_logic_vector ( 1 downto  0);
      wadata   : in  std_logic_vector (31 downto  0);
      -- acache interface
      paddr    : out std_logic_vector (11 downto  0);
      psel     : out std_logic;
      penable  : out std_logic;
      pwrite   : out std_logic;
      pwdata   : out std_logic_vector (31 downto  0);
      prdata   : in  std_logic_vector (31 downto  0);
      -- AHB bus interface
      hgrant   : in  std_logic;
      hready   : in  std_logic;
      hresp    : in  std_logic_vector ( 1 downto  0);
      hrdata   : in  std_logic_vector (31 downto  0);
      hbusreq  : out std_logic;
      hlock    : out std_logic;
      htrans   : out std_logic_vector ( 1 downto  0);
      haddr    : out std_logic_vector (31 downto  0);
      hwrite   : out std_logic;
      hsize    : out std_logic_vector ( 2 downto  0);
      hburst   : out std_logic_vector ( 2 downto  0);
      hprot    : out std_logic_vector ( 3 downto  0);
      hwdata   : out std_logic_vector (31 downto  0)
    );
  end component;

  -- cachectl <==> cacheahb
  signal paddr    : std_logic_vector (11 downto  0);
  signal psel     : std_logic;
  signal penable  : std_logic;
  signal pwrite   : std_logic;
  signal pwdata   : std_logic_vector (31 downto  0);
  signal prdata   : std_logic_vector (31 downto  0);

  -- cachectl <==> icachepu/dcachepu/icache/dcache
  signal caddr    : std_logic_vector (11 downto  0);
  signal cselip   : std_logic;
  signal cseldp   : std_logic;
  signal cselic   : std_logic;
  signal cseldc   : std_logic;
  signal cselwb   : std_logic;
  signal cenable  : std_logic;
  signal cwrite   : std_logic;
  signal cwdata   : std_logic_vector (31 downto  0);
  signal crdataip : std_logic_vector (31 downto  0);
  signal crdatadp : std_logic_vector (31 downto  0);
  signal crreg    : std_logic_vector (31 downto  0);

  -- icachepu <==> icache
  signal ipaddr   : std_logic_vector (31 downto  0);
  signal ipc      : std_logic;
  signal ipap     : std_logic_vector ( 1 downto  0);

  -- dcachepu <==> dcache
  signal dpaddr   : std_logic_vector (31 downto  0);
  signal dpc      : std_logic;
  signal dpb      : std_logic;
  signal dpap     : std_logic_vector ( 1 downto  0);

  -- icache <==> cacheahb
  signal iagrant  : std_logic;
  signal iaready  : std_logic;
  signal iaresp   : std_logic_vector ( 1 downto  0);
  signal iardata  : std_logic_vector (31 downto  0);
  signal iabusreq : std_logic;
  signal ialock   : std_logic;
  signal iatrans  : std_logic_vector ( 1 downto  0);
  signal iaaddr   : std_logic_vector (31 downto  0);
  signal iawrite  : std_logic;
  signal iasize   : std_logic_vector ( 2 downto  0);
  signal iaburst  : std_logic_vector ( 2 downto  0);
  signal iaprot   : std_logic_vector ( 3 downto  0);
  signal iawdata  : std_logic_vector (31 downto  0);

  -- dcache <==> cacheahb
  signal dacpreq  : std_logic;

  signal dagrant  : std_logic;
  signal daready  : std_logic;
  signal daresp   : std_logic_vector ( 1 downto  0);
  signal dardata  : std_logic_vector (31 downto  0);
  signal dabusreq : std_logic;
  signal dalock   : std_logic;
  signal datrans  : std_logic_vector ( 1 downto  0);
  signal daaddr   : std_logic_vector (31 downto  0);
  signal dawrite  : std_logic;
  signal dasize   : std_logic_vector ( 2 downto  0);
  signal daburst  : std_logic_vector ( 2 downto  0);
  signal daprot   : std_logic_vector ( 3 downto  0);
  signal dawdata  : std_logic_vector (31 downto  0);

  -- dcache <==> cachewb
  signal dwwrite  : std_logic;
  signal dwaddr   : std_logic_vector (31 downto  0);
  signal dwsize   : std_logic_vector ( 1 downto  0);
  signal dwdata   : std_logic_vector (31 downto  0);
  signal dwcount  : std_logic_vector ( 3 downto  0);

  -- cachewb <==> cacheahb
  signal wagrant  : std_logic;
  signal waready  : std_logic;
  signal wawrite  : std_logic;
  signal waaddr   : std_logic_vector (31 downto  0);
  signal wasize   : std_logic_vector ( 1 downto  0);
  signal wadata   : std_logic_vector (31 downto  0);

  -- AHB bus
  signal gaddr    : std_logic_vector (31 downto  0);
  signal grdata   : std_logic_vector (31 downto  0);

begin

  cachereg_0 : cachereg
    port map (
      clk      => clk,
      rst      => rst,
      paddr    => paddr,
      psel     => psel,
      penable  => penable,
      pwrite   => pwrite,
      pwdata   => pwdata,
      prdata   => prdata,
      caddr    => caddr,
      cselip   => cselip,
      cseldp   => cseldp,
      cselic   => cselic,
      cseldc   => cseldc,
      cselwb   => cselwb,
      cenable  => cenable,
      cwrite   => cwrite,
      cwdata   => cwdata,
      crdataip => crdataip,
      crdatadp => crdatadp,
      crreg    => crreg
    );

  cacheipu_0 : cacheipu
    port map (
      clk      => clk,
      rst      => rst,
      paddr    => caddr,
      psel     => cselip,
      penable  => cenable,
      pwrite   => cwrite,
      pwdata   => cwdata,
      prdata   => crdataip,
      ipaddr   => ipaddr,
      ipc      => ipc,
      ipap     => ipap
    );

  cachedpu_0 : cachedpu
    port map (
      clk      => clk,
      rst      => rst,
      paddr    => caddr,
      psel     => cseldp,
      penable  => cenable,
      pwrite   => cwrite,
      pwdata   => cwdata,
      prdata   => crdatadp,
      dpaddr   => dpaddr,
      dpc      => dpc,
      dpb      => dpb,
      dpap     => dpap
    );

  cacheic_0 : cacheic
    port map (
      clk      => clk,
      rst      => rst,
      inmreq   => inmreq,
      iseq     => iseq,
      ia       => ia,
      inm      => inm,
      intrans  => intrans,
      id       => id,
      iabort   => iabort,
      inwait   => inwait,
      paddr    => caddr,
      psel     => cselic,
      penable  => cenable,
      pwrite   => cwrite,
      pwdata   => cwdata,
      crreg    => crreg,
      ipaddr   => ipaddr,
      ipc      => ipc,
      ipap     => ipap,
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
      iagrant  => iagrant,
      iaready  => iaready,
      iaresp   => iaresp,
      iardata  => iardata,
      iabusreq => iabusreq,
      ialock   => ialock,
      iatrans  => iatrans,
      iaaddr   => iaaddr,
      iawrite  => iawrite,
      iasize   => iasize,
      iaburst  => iaburst,
      iaprot   => iaprot,
      iawdata  => iawdata
    );

  cachedc_0 : cachedc
    port map (
      clk      => clk,
      rst      => rst,
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
      paddr    => caddr,
      psel     => cseldc,
      penable  => cenable,
      pwrite   => cwrite,
      pwdata   => cwdata,
      crreg    => crreg,
      dpaddr   => dpaddr,
      dpc      => dpc,
      dpb      => dpb,
      dpap     => dpap,
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
      dwwrite  => dwwrite,
      dwaddr   => dwaddr,
      dwsize   => dwsize,
      dwdata   => dwdata,
      dwcount  => dwcount,
      dacpreq  => dacpreq,
      dagrant  => dagrant,
      daready  => daready,
      daresp   => daresp,
      dardata  => dardata,
      dabusreq => dabusreq,
      dalock   => dalock,
      datrans  => datrans,
      daaddr   => daaddr,
      dawrite  => dawrite,
      dasize   => dasize,
      daburst  => daburst,
      daprot   => daprot,
      dawdata  => dawdata
    );

  cachewb_0 : cachewb
    port map (
      clk      => clk,
      rst      => rst,
      dwwrite  => dwwrite,
      dwaddr   => dwaddr,
      dwsize   => dwsize,
      dwdata   => dwdata,
      dwcount  => dwcount,
      paddr    => caddr,
      psel     => cselwb,
      penable  => cenable,
      pwrite   => cwrite,
      pwdata   => cwdata,
      wagrant  => wagrant,
      waready  => waready,
      wawrite  => wawrite,
      waaddr   => waaddr,
      wasize   => wasize,
      wadata   => wadata,
      hgrant   => hgrant,
      hready   => hready,
      haddr    => gaddr,
      hrdata   => hrdata,
      hwdata   => grdata
    );

  cacheahb_0 : cacheahb
    port map (
      clk      => clk,
      rst      => rst,
      iagrant  => iagrant,
      iaready  => iaready,
      iaresp   => iaresp,
      iardata  => iardata,
      iabusreq => iabusreq,
      ialock   => ialock,
      iatrans  => iatrans,
      iaaddr   => iaaddr,
      iawrite  => iawrite,
      iasize   => iasize,
      iaburst  => iaburst,
      iaprot   => iaprot,
      iawdata  => iawdata,
      dacpreq  => dacpreq,
      dagrant  => dagrant,
      daready  => daready,
      daresp   => daresp,
      dardata  => dardata,
      dabusreq => dabusreq,
      dalock   => dalock,
      datrans  => datrans,
      daaddr   => daaddr,
      dawrite  => dawrite,
      dasize   => dasize,
      daburst  => daburst,
      daprot   => daprot,
      dawdata  => dawdata,
      wagrant  => wagrant,
      waready  => waready,
      wawrite  => wawrite,
      waaddr   => waaddr,
      wasize   => wasize,
      wadata   => wadata,
      paddr    => paddr,
      psel     => psel,
      penable  => penable,
      pwrite   => pwrite,
      pwdata   => pwdata,
      prdata   => prdata,
      hgrant   => hgrant,
      hready   => hready,
      hresp    => hresp,
      hrdata   => grdata,
      hbusreq  => hbusreq,
      hlock    => hlock,
      htrans   => htrans,
      haddr    => gaddr,
      hwrite   => hwrite,
      hsize    => hsize,
      hburst   => hburst,
      hprot    => hprot,
      hwdata   => hwdata
    );

  haddr <= gaddr;

end struct;

configuration cfg_cachectl of cachectl is
  for struct
    for cachereg_0 : cachereg
      use configuration work.cfg_cachereg;
    end for;
    for cacheipu_0 : cacheipu
      use configuration work.cfg_cacheipu;
    end for;
    for cachedpu_0 : cachedpu
      use configuration work.cfg_cachedpu;
    end for;
    for cacheic_0 : cacheic
      use configuration work.cfg_cacheic;
    end for;
    for cachedc_0 : cachedc
      use configuration work.cfg_cachedc;
    end for;
    for cachewb_0 : cachewb
      use configuration work.cfg_cachewb;
    end for;
    for cacheahb_0 : cacheahb
      use configuration work.cfg_cacheahb;
    end for;
  end for;
end cfg_cachectl;
